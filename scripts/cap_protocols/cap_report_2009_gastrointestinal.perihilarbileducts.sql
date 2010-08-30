/*Table structure for table 'dxd_cap_report_perihilarbileducts' */

DROP TABLE IF EXISTS `dxd_cap_report_perihilarbileducts`;

CREATE TABLE IF NOT EXISTS `dxd_cap_report_perihilarbileducts` (
  `id` int(10) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
-- specimen
  `common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `right_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `left_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `junction_of_right_and_left_hepatic_ducts` tinyint(1) NULL DEFAULT 0,
  `common_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `cystic_duct` tinyint(1) NULL DEFAULT 0,
  `liver` tinyint(1) NULL DEFAULT 0,
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
-- procedure  
  `procedure` varchar(50) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL,
-- tumor site  
  `tumor_site_right_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_site_left_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_site_junction_of_right_and_left_hepatic_ducts` tinyint(1) NULL DEFAULT 0,
  `tumor_site_cystic_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_site_common_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_site_common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_site_not_specified` tinyint(1) NULL DEFAULT 0,    
-- tumor size in master  
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
-- histologic grade in masters  
-- Microscopic Tumor Extension
  `carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,    
  `tumor_confined_to_the_bile_duct_histologically` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_into_surrounding_connective_tissue` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_adjacent_liver_parenchyma` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_gallbladder` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_unilateral_branches_of_the_portal_vein` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_unilateral_branches_of_the_hepatic_artery` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_main_portal_vein_or_its_branches_bilaterally` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_common_hepatic_artery` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_second_order_biliary_radicals` tinyint(1) NULL DEFAULT 0,    
  `unilateral` tinyint(1) NULL DEFAULT 0,    
  `bilateral` tinyint(1) NULL DEFAULT 0,   
-- Margins  
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `margins_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin` decimal (3,1) DEFAULT NULL,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin` varchar(250) DEFAULT NULL,
  `margins_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `proximal_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `distal_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `hepatic_parenchymal_margin` tinyint(1) NULL DEFAULT 0,
  `margin_other` tinyint(1) NULL DEFAULT 0,
  `margin_other_specify` varchar(250) DEFAULT NULL, 
  `dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin`  tinyint(1) NULL DEFAULT 0,
  `dysplasia_carcinoma_in_situ_present_at_bile_duct_margin` tinyint(1) NULL DEFAULT 0,  
-- Pathologic Staging (pTNM) in masters
  
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,
  
--  Additional Pathologic Findings 
  `additional_path_none_identified` tinyint(1) NOT NULL DEFAULT 0,    
  `choledochal_cyst` tinyint(1) NOT NULL DEFAULT 0, 
  `dysplasia` tinyint(1) NOT NULL DEFAULT 0, 
  `primary_sclerosing_cholangitis_PSC` tinyint(1) NOT NULL DEFAULT 0, 
  `biliary_stones` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
-- clinical history  
  `PSC`  tinyint(1) NOT NULL DEFAULT 0,
  `inflammatory_bowel_disease` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_biliary_stones` tinyint(1) NOT NULL DEFAULT 0,
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

ALTER TABLE `dxd_cap_report_perihilarbileducts` ADD CONSTRAINT `FK_dxd_cap_report_perihilarbileducts_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 


/*Table structure for table 'dxd_cap_report_perihilarbileducts_revs' */

DROP TABLE IF EXISTS `dxd_cap_report_perihilarbileducts_revs`;

CREATE TABLE `dxd_cap_report_perihilarbileducts_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
-- specimen
  `common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `right_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `left_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `junction_of_right_and_left_hepatic_ducts` tinyint(1) NULL DEFAULT 0,
  `common_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `cystic_duct` tinyint(1) NULL DEFAULT 0,
  `liver` tinyint(1) NULL DEFAULT 0,
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
-- procedure  
  `procedure` varchar(50) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL,
-- tumor site  
  `tumor_site_right_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_site_left_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_site_junction_of_right_and_left_hepatic_ducts` tinyint(1) NULL DEFAULT 0,
  `tumor_site_cystic_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_site_common_hepatic_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_site_common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_site_not_specified` tinyint(1) NULL DEFAULT 0,    
-- tumor size in master  
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
-- histologic grade in masters  
-- Microscopic Tumor Extension
  `carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,    
  `tumor_confined_to_the_bile_duct_histologically` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_into_surrounding_connective_tissue` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_adjacent_liver_parenchyma` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_gallbladder` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_unilateral_branches_of_the_portal_vein` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_the_unilateral_branches_of_the_hepatic_artery` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_main_portal_vein_or_its_branches_bilaterally` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_common_hepatic_artery` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_second_order_biliary_radicals` tinyint(1) NULL DEFAULT 0,    
  `unilateral` tinyint(1) NULL DEFAULT 0,    
  `bilateral` tinyint(1) NULL DEFAULT 0,   
-- Margins  
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `margins_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin` decimal (3,1) DEFAULT NULL,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin` varchar(250) DEFAULT NULL,
  `margins_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `proximal_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `distal_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `hepatic_parenchymal_margin` tinyint(1) NULL DEFAULT 0,
  `margin_other` tinyint(1) NULL DEFAULT 0,
  `margin_other_specify` varchar(250) DEFAULT NULL, 
  `dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin`  tinyint(1) NULL DEFAULT 0,
  `dysplasia_carcinoma_in_situ_present_at_bile_duct_margin` tinyint(1) NULL DEFAULT 0,  
-- Pathologic Staging (pTNM) in masters
  
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,
  
--  Additional Pathologic Findings 
  `additional_path_none_identified` tinyint(1) NOT NULL DEFAULT 0,    
  `choledochal_cyst` tinyint(1) NOT NULL DEFAULT 0, 
  `dysplasia` tinyint(1) NOT NULL DEFAULT 0, 
  `primary_sclerosing_cholangitis_PSC` tinyint(1) NOT NULL DEFAULT 0, 
  `biliary_stones` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
-- clinical history  
  `PSC`  tinyint(1) NOT NULL DEFAULT 0,
  `inflammatory_bowel_disease` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_biliary_stones` tinyint(1) NOT NULL DEFAULT 0,
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
('cap report - perihilar bile ducts', 1, 'dx_cap_report_perihilarbileducts', 'dxd_cap_report_perihilarbileducts');

-- The table structures hold all forms in the application, Add the dxd_cap_report_ in table structures. It doesn't hold the form itself but the form alias.

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_cap_report_perihilarbileducts', '', '', '0', '0', '1', '1');


INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'common_bile_duct', 'common bile duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'right_hepatic_duct', 'right hepatic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'left_hepatic_duct', 'left hepatic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'junction_of_right_and_left_hepatic_ducts', 'junction of right and left hepatic ducts', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'common_hepatic_duct', 'common hepatic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'cystic_duct', 'cystic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'liver', 'liver', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'gallbladder', 'gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'procedure', 'procedure', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'procedure_specify', 'procedure specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_site_right_hepatic_duct', 'right hepatic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_site_junction_of_right_and_left_hepatic_ducts', 'junction of right and left hepatic ducts', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_site_left_hepatic_duct', 'left hepatic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_site_cystic_duct', 'cystic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_site_common_hepatic_duct', 'common hepatic duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_site_common_bile_duct', 'common bile duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_site_not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'histologic_type', 'histologic type', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_pbd', 'tumour_grade', 'histologic grade', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'carcinoma_in_situ', 'carcinoma in situ', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_confined_to_the_bile_duct_histologically', 'tumor confined to the bile duct histologically', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_invades_into_surrounding_connective_tissue', 'tumor invades into surrounding connective tissue', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_invades_the_adjacent_liver_parenchyma', 'tumor invades the adjacent liver parenchyma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_invades_the_gallbladder', 'tumor invades the gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_invades_the_unilateral_branches_of_the_portal_vein', 'tumor invades the unilateral branches of the portal vein', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_invades_the_unilateral_branches_of_the_hepatic_artery', 'tumor invades the unilateral branches of the hepatic artery', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_invades_main_portal_vein_or_its_branches_bilaterally', 'tumor invades main portal vein or its branches bilaterally', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_invades_common_hepatic_artery', 'tumor invades common hepatic artery', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'tumor_invades_second_order_biliary_radicals', 'tumor invades second order biliary radicals', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'unilateral', 'unilateral', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'bilateral', 'bilateral', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'margins_uninvolved_by_invasive_carcinoma', 'margins uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'distance_of_invasive_carcinoma_from_closest_margin', 'distance of invasive carcinoma from closest margin', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'distance_unit', '', 'distance unit', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'specify_margin', 'specify margin', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'margins_involved_by_invasive_carcinoma', 'margins involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'proximal_bile_duct_margin', 'proximal bile duct margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'distal_bile_duct_margin', 'distal bile duct margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'hepatic_parenchymal_margin', 'hepatic parenchymal margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'margin_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'margin_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin', 'dysplasia carcinoma in situ not identified at bile duct margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'dysplasia_carcinoma_in_situ_present_at_bile_duct_margin', 'dysplasia carcinoma in situ present at bile duct margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'lymph_vascular_invasion', 'lymph vascular invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'perineural_invasion', 'perineural invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'additional_path_none_identified', 'none identified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'choledochal_cyst', 'choledochal cyst', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'dysplasia', 'dysplasia', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'primary_sclerosing_cholangitis_PSC', 'primary sclerosing cholangitis (PSC)', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'biliary_stones', 'biliary stones', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'additional_path_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'additional_path_other_specify', '', ' other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'ancillary_studies_specify', 'ancillary studies specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'PSC', 'PSC', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'inflammatory_bowel_disease', 'inflammatory bowel disease', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'other_clinical_biliary_stones', 'biliary stones', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'other_clinical_history', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'other_clinical_history_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_perihilarbileducts', 'not_known', 'not known', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_pbd', 'path_tstage', 'path tstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_pbd', 'path_nstage', 'path nstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_pbd', 'path_mstage', 'path mstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');



INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='common_bile_duct' AND `language_label`='common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='right_hepatic_duct' AND `language_label`='right hepatic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='left_hepatic_duct' AND `language_label`='left hepatic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='junction_of_right_and_left_hepatic_ducts' AND `language_label`='junction of right and left hepatic ducts' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='common_hepatic_duct' AND `language_label`='common hepatic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='cystic_duct' AND `language_label`='cystic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='liver' AND `language_label`='liver' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='gallbladder' AND `language_label`='gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='procedure' AND `language_label`='procedure' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='procedure_specify' AND `language_label`='procedure specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_site_right_hepatic_duct' AND `language_label`='right hepatic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_site_junction_of_right_and_left_hepatic_ducts' AND `language_label`='junction of right and left hepatic ducts' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_site_left_hepatic_duct' AND `language_label`='left hepatic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_site_cystic_duct' AND `language_label`='cystic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_site_common_hepatic_duct' AND `language_label`='common hepatic duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_site_common_bile_duct' AND `language_label`='common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_site_not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension' AND `structure_value_domain`  IS NULL  ), '1', '21', '', '1', 'greatest dimension (cm)', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a' AND `structure_value_domain`  IS NULL  ), '1', '22', '', '1', 'additional dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `structure_value_domain`  IS NULL  ), '1', '23', '', '0', '', '1', 'x', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' ), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='histologic_type' AND `language_label`='histologic type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='histologic_type_specify' AND `language_label`='histologic type specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_pbd' AND `field`='tumour_grade' AND `language_label`='histologic grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='carcinoma_in_situ' AND `language_label`='carcinoma in situ' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_confined_to_the_bile_duct_histologically' AND `language_label`='tumor confined to the bile duct histologically' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_invades_into_surrounding_connective_tissue' AND `language_label`='tumor invades into surrounding connective tissue' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_invades_the_adjacent_liver_parenchyma' AND `language_label`='tumor invades the adjacent liver parenchyma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_invades_the_gallbladder' AND `language_label`='tumor invades the gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_invades_the_unilateral_branches_of_the_portal_vein' AND `language_label`='tumor invades the unilateral branches of the portal vein' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_invades_the_unilateral_branches_of_the_hepatic_artery' AND `language_label`='tumor invades the unilateral branches of the hepatic artery' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_invades_main_portal_vein_or_its_branches_bilaterally' AND `language_label`='tumor invades main portal vein or its branches bilaterally' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_invades_common_hepatic_artery' AND `language_label`='tumor invades common hepatic artery' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='tumor_invades_second_order_biliary_radicals' AND `language_label`='tumor invades second order biliary radicals' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='unilateral' AND `language_label`='unilateral' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='bilateral' AND `language_label`='bilateral' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='margins_uninvolved_by_invasive_carcinoma' AND `language_label`='margins uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='distance_of_invasive_carcinoma_from_closest_margin' AND `language_label`='distance of invasive carcinoma from closest margin' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='distance_unit' AND `language_label`='' AND `language_tag`='distance unit' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='specify_margin' AND `language_label`='specify margin' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='margins_involved_by_invasive_carcinoma' AND `language_label`='margins involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='proximal_bile_duct_margin' AND `language_label`='proximal bile duct margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='distal_bile_duct_margin' AND `language_label`='distal bile duct margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='hepatic_parenchymal_margin' AND `language_label`='hepatic parenchymal margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='margin_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='margin_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='dysplasia_carcinoma_in_situ_not_identified_at_bile_duct_margin' AND `language_label`='dysplasia carcinoma in situ not identified at bile duct margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='dysplasia_carcinoma_in_situ_present_at_bile_duct_margin' AND `language_label`='dysplasia carcinoma in situ present at bile duct margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='lymph_vascular_invasion' AND `language_label`='lymph vascular invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='perineural_invasion' AND `language_label`='perineural invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_m' ), '2', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_r' ), '2', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_y' ), '2', '58', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_pbd' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  ), '2', '59', '', '1', 'path tstage', '1', '', '0', '', '1', 'select', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_pbd' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  ), '2', '60', '', '1', 'path nstage', '1', '', '0', '', '1', 'select', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_examined' AND `structure_value_domain`  IS NULL  ), '2', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_involved' AND `structure_value_domain`  IS NULL  ), '2', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_pbd' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  ), '2', '63', '', '1', 'path mstage', '1', '', '0', '', '1', 'select', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage_metastasis_site_specify' AND `structure_value_domain`  IS NULL  ), '2', '64', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='additional_path_none_identified' AND `language_label`='none identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='choledochal_cyst' AND `language_label`='choledochal cyst' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '66', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='dysplasia' AND `language_label`='dysplasia' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '67', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='primary_sclerosing_cholangitis_PSC' AND `language_label`='primary sclerosing cholangitis (PSC)' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '68', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='biliary_stones' AND `language_label`='biliary stones' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '69', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='additional_path_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='additional_path_other_specify' AND `language_label`='' AND `language_tag`=' other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='ancillary_studies_specify' AND `language_label`='ancillary studies specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='PSC' AND `language_label`='PSC' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='inflammatory_bowel_disease' AND `language_label`='inflammatory bowel disease' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='other_clinical_biliary_stones' AND `language_label`='biliary stones' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='other_clinical_history' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='other_clinical_history_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '77', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='not_known' AND `language_label`='not known' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '78', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_perihilarbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  ), '2', '79', '', '0', '', '0', '', '1', '', '0', '', '1', 'cols=40, rows=6', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

-- update checkbox structure value domain to 185
update structure_fields
set structure_value_domain=185
where type='checkbox'
and structure_value_domain is null;

-- validation distance_unit
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_perihilarbileducts' AND `field`='distance_unit' AND `type`='select'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

-- add heading
update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='common_bile_duct'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_perihilarbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor site'
where sfi.id=sfo.structure_field_id
and sfi.field='right_hepatic_duct'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_perihilarbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor size'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_perihilarbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='microscopic tumor extension'
where sfi.id=sfo.structure_field_id
and sfi.field='carcinoma_in_situ'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_perihilarbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='margins'
where sfi.id=sfo.structure_field_id
and sfi.field='cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_perihilarbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='pathologic staging (pTNM)'
where sfi.id=sfo.structure_field_id
and sfi.field='path_tnm_descriptor_m'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_perihilarbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='additional pathologic findings'
where sfi.id=sfo.structure_field_id
and sfi.field='additional_path_none_identified'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_perihilarbileducts'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='clinical history'
where sfi.id=sfo.structure_field_id
and sfi.field='psc'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_perihilarbileducts'; 

-- index
UPDATE structures AS str, structure_formats AS stfo, structure_fields AS sf 
SET stfo.flag_index = '1'
WHERE str.alias = 'dx_cap_report_perihilarbileducts'
AND str.id = stfo.structure_id 
AND stfo.structure_field_id = sf.id
AND sf.field IN ('dx_date', 'tumor_site', 'tumour_grade', 'histologic_type');


-- dropdown list for select
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distance_unit')
where tablename='dxd_cap_report_perihilarbileducts' and field='distance_unit';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_perihilarbileducts' and field='lymph_vascular_invasion';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_perihilarbileducts' and field='perineural_invasion';

-- procedure_dxd_pbd
insert ignore into structure_permissible_values (value, language_alias) values
('hilar and hepatic resection','hilar and hepatic resection'),
('segmental resection of bile ducts(s)','segmental resection of bile ducts(s)'),
('choledochal cyst resection (Note B)','choledochal cyst resection (Note B)'),
('total hepatectomy','total hepatectomy');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('procedure_dxd_pbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='procedure_dxd_pbd'), (select id from structure_permissible_values where value='hilar and hepatic resection'), 1,1, 'hilar and hepatic resection'),
((select id from structure_value_domains where domain_name='procedure_dxd_pbd'), (select id from structure_permissible_values where value='segmental resection of bile ducts(s)'), 2,1, 'segmental resection of bile ducts(s)'),
((select id from structure_value_domains where domain_name='procedure_dxd_pbd'), (select id from structure_permissible_values where value='choledochal cyst resection (Note B)'), 3,1, 'choledochal cyst resection (Note B)'),
((select id from structure_value_domains where domain_name='procedure_dxd_pbd'), (select id from structure_permissible_values where value='total hepatectomy'), 4,1, 'total hepatectomy'),
((select id from structure_value_domains where domain_name='procedure_dxd_pbd'), (select id from structure_permissible_values where value='other'), 5,1, 'other'),
((select id from structure_value_domains where domain_name='procedure_dxd_pbd'), (select id from structure_permissible_values where value='not specified'), 6,1, 'not specified');

select * from structure_fields
where tablename='dxd_cap_report_perihilarbileducts' and field='procedure';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='procedure_dxd_pbd')
where tablename='dxd_cap_report_perihilarbileducts' and field='procedure';

-- histologic_type_pbd
insert ignore into structure_permissible_values (value, language_alias) values
('adenocarcinoma (not otherwise characterized)','adenocarcinoma (not otherwise characterized)'),
('papillary adenocarcinoma','papillary adenocarcinoma'),
('mucinous adenocarcinoma','mucinous adenocarcinoma'),
('clear cell adenocarcinoma','clear cell adenocarcinoma'),
('signet-ring cell carcinoma','signet-ring cell carcinoma'),
('adenosquamous carcinoma','adenosquamous carcinoma'),
('squamous cell carcinoma','squamous cell carcinoma'),
('small cell carcinoma','small cell carcinoma'),
('biliary cystadenocarcinoma','biliary cystadenocarcinoma'),
('carcinoma, not otherwise specified','carcinoma, not otherwise specified');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_type_pbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_type_pbd'), (select id from structure_permissible_values where value='adenocarcinoma (not otherwise characterized)'), 1,1, 'adenocarcinoma (not otherwise characterized)'),
((select id from structure_value_domains where domain_name='histologic_type_pbd'), (select id from structure_permissible_values where value='papillary adenocarcinoma'), 2,1, 'papillary adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_pbd'), (select id from structure_permissible_values where value='mucinous adenocarcinoma'), 3,1, 'mucinous adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_pbd'), (select id from structure_permissible_values where value='clear cell adenocarcinoma'), 4,1, 'clear cell adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_pbd'), (select id from structure_permissible_values where value='signet-ring cell carcinoma'), 5,1, 'signet-ring cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_pbd'), (select id from structure_permissible_values where value='adenosquamous carcinoma'), 6,1, 'adenosquamous carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_pbd'), (select id from structure_permissible_values where value='squamous cell carcinoma'), 7,1, 'squamous cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_pbd'), (select id from structure_permissible_values where value='small cell carcinoma'), 8,1, 'small cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_pbd'), (select id from structure_permissible_values where value='biliary cystadenocarcinoma'), 9,1, 'biliary cystadenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_pbd'), (select id from structure_permissible_values where value='other'), 10,1, 'other'),
((select id from structure_value_domains where domain_name='histologic_type_pbd'), (select id from structure_permissible_values where value='carcinoma, not otherwise specified'), 11,1, 'carcinoma, not otherwise specified');

select * from structure_fields
where tablename='dxd_cap_report_perihilarbileducts' and field='histologic_type';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_type_pbd')
where tablename='dxd_cap_report_perihilarbileducts' and field='histologic_type';

-- histologic_grade_pbd
insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_grade_pbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_grade_pbd'), (select id from structure_permissible_values where value='not applicable'), 1,1,'not applicable'),
((select id from structure_value_domains where domain_name='histologic_grade_pbd'), (select id from structure_permissible_values where value='gx'), 2,1,'cannot be assessed'),
((select id from structure_value_domains where domain_name='histologic_grade_pbd'), (select id from structure_permissible_values where value='g1'), 3,1, 'well differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_pbd'), (select id from structure_permissible_values where value='g2'), 4,1,'moderately differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_pbd'), (select id from structure_permissible_values where value='g3'), 5,1,'poorly differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_pbd'), (select id from structure_permissible_values where value='g4'), 6,1,'undifferentiated');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_grade_pbd')
where tablename='diagnosis_masters_pbd' and field='tumour_grade';

-- primary tumor (pt) path_tstage_pbd
insert ignore into structure_permissible_values (value, language_alias) values
('ptx', 'ptx: cannot be assessed'),
('pt0', 'pt0: no evidence of primary tumor'),
('ptis', 'ptis: carcinoma in situ'),
('pt1', 'pt1: tumor confined to the bile duct, with extension up to the muscle layer or fibrous tissue'),
('pt2a', 'pt2a: tumor invades beyond the wall of the bile duct to surrounding adipose tissue'),
('pt2b', 'pt2b: tumor invades adjacent hepatic parenchyma'),
('pt3', 'pt3: tumor invades unilateral branches of the portal vein or hepatic artery'),
('pt4', 'pt4: tumor invades main portal vein or its branches bilaterally; or the common hepatic artery; or the second-order biliary radicals bilaterally; or unilateral second-order biliary radicals with contralateral portal vein or hepatic artery involvement');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_tstage_pbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_tstage_pbd'), (select id from structure_permissible_values where value='ptx' and language_alias='ptx: cannot be assessed'), 1,1, 'ptx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_tstage_pbd'), (select id from structure_permissible_values where value='pt0' and language_alias='pt0: no evidence of primary tumor'), 2,1, 'pt0: no evidence of primary tumor'),
((select id from structure_value_domains where domain_name='path_tstage_pbd'), (select id from structure_permissible_values where value='ptis' and language_alias='ptis: carcinoma in situ'), 3,1, 'ptis: carcinoma in situ'),
((select id from structure_value_domains where domain_name='path_tstage_pbd'), (select id from structure_permissible_values where value='pt1'  and language_alias='pt1: tumor confined to the bile duct, with extension up to the muscle layer or fibrous tissue'), 4,1, 'pt1: tumor confined to the bile duct, with extension up to the muscle layer or fibrous tissue'),
((select id from structure_value_domains where domain_name='path_tstage_pbd'), (select id from structure_permissible_values where value='pt2a' and language_alias='pt2a: tumor invades beyond the wall of the bile duct to surrounding adipose tissue'), 5,1, 'pt2a: tumor invades beyond the wall of the bile duct to surrounding adipose tissue'),
((select id from structure_value_domains where domain_name='path_tstage_pbd'), (select id from structure_permissible_values where value='pt2b' and language_alias='pt2b: tumor invades adjacent hepatic parenchyma'), 6,1, 'pt2b: tumor invades adjacent hepatic parenchyma'),
((select id from structure_value_domains where domain_name='path_tstage_pbd'), (select id from structure_permissible_values where value='pt3' and language_alias='pt3: tumor invades unilateral branches of the portal vein or hepatic artery'), 7,1, 'pt3: tumor invades unilateral branches of the portal vein or hepatic artery'),
((select id from structure_value_domains where domain_name='path_tstage_pbd'), (select id from structure_permissible_values where value='pt4' and language_alias='pt4: tumor invades main portal vein or its branches bilaterally; or the common hepatic artery; or the second-order biliary radicals bilaterally; or unilateral second-order biliary radicals with contralateral portal vein or hepatic artery involvement'), 8,1, 'pt4: tumor invades main portal vein or its branches bilaterally; or the common hepatic artery; or the second-order biliary radicals bilaterally; or unilateral second-order biliary radicals with contralateral portal vein or hepatic artery involvement');

select id from structure_value_domains where domain_name='path_tstage_pbd';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_tstage_pbd')
where tablename='diagnosis_masters_pbd' and field='path_tstage';


-- regional lymph nodes (pn) path_nstage_pbd
insert ignore into structure_permissible_values (value, language_alias) values
('pnx', 'pnx: cannot be assessed'),
('pn0', 'pn0: no regional lymph node metastasis'),
('pn1', 'pn1: regional lymph node metastasis (including nodes along the cystic duct, common bile duct, hepatic artery, and portal vein)'),
('pn2', 'pn2: metastasis to periaortic, pericaval, superior mesentery artery, and/or celiac artery lymph nodes');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_nstage_pbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_nstage_pbd'), (select id from structure_permissible_values where value='pnx' and language_alias='pnx: cannot be assessed'), 1,1, 'pnx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_nstage_pbd'), (select id from structure_permissible_values where value='pn0' and language_alias='pn0: no regional lymph node metastasis'), 2,1, 'pn0: no regional lymph node metastasis'),
((select id from structure_value_domains where domain_name='path_nstage_pbd'), (select id from structure_permissible_values where value='pn1' and language_alias='pn1: regional lymph node metastasis (including nodes along the cystic duct, common bile duct, hepatic artery, and portal vein)'), 3,1, 'pn1: regional lymph node metastasis (including nodes along the cystic duct, common bile duct, hepatic artery, and portal vein)'),
((select id from structure_value_domains where domain_name='path_nstage_pbd'), (select id from structure_permissible_values where value='pn2' and language_alias='pn2: metastasis to periaortic, pericaval, superior mesentery artery, and/or celiac artery lymph nodes'), 4,1, 'pn2: metastasis to periaortic, pericaval, superior mesentery artery, and/or celiac artery lymph nodes');

select * from structure_fields
where tablename='diagnosis_masters_pbd' and field='path_nstage';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_nstage_pbd')
where tablename='diagnosis_masters_pbd' and field='path_nstage';


-- distant metastasis (pm) path_mstage_pbd
insert ignore into structure_permissible_values (value, language_alias) values
('pm1', 'pm1: distant metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_mstage_pbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_mstage_pbd'), (select id from structure_permissible_values where value='not applicable'), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='path_mstage_pbd'), (select id from structure_permissible_values where value='pm1'), 2,1, 'pm1: distant metastasis');

select * from structure_fields
where tablename='diagnosis_masters_pbd' and field='path_mstage';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_mstage_pbd')
where tablename='diagnosis_masters_pbd' and field='path_mstage';


