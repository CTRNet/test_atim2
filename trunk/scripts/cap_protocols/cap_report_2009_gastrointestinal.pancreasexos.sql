/*Table structure for table 'dxd_cap_report_pancreasexos' */

DROP TABLE IF EXISTS `dxd_cap_report_pancreasexos`;

CREATE TABLE IF NOT EXISTS `dxd_cap_report_pancreasexos` (
  `id` int(10) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
-- Specimen
  `head_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `body_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `tail_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `duodenum` tinyint(1) NULL DEFAULT 0,
  `stomach` tinyint(1) NULL DEFAULT 0,
  `common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `gallbladder` tinyint(1) NULL DEFAULT 0,  
  `spleen` tinyint(1) NULL DEFAULT 0,
  `adjacent_large_vessels` tinyint(1) NULL DEFAULT 0,
  `portal_vein` tinyint(1) NULL DEFAULT 0,
  `superior_mesenteric_vein` tinyint(1) NULL DEFAULT 0,
  `other_large_vessels` tinyint(1) NULL DEFAULT 0,  
  `other_large_vessels_specify` varchar(50) DEFAULT NULL,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
  `specimen_not_specified` tinyint(1) NULL DEFAULT 0,
  `cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
-- Procedure  
  `procedure` varchar(100) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL,
-- Tumor site  
  `tumor_site_pancreatic_head` tinyint(1) NULL DEFAULT 0,
  `tumor_site_uncinate_process` tinyint(1) NULL DEFAULT 0,
  `tumor_site_pancreatic_body` tinyint(1) NULL DEFAULT 0,
  `tumor_site_pancreatic_tail` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other_specify` varchar(250) DEFAULT NULL,
  `tumor_site_cannot_be_determined` tinyint(1) NULL DEFAULT 0,
  `tumor_site_not_specified` tinyint(1) NULL DEFAULT 0,  
-- Tumor size -- See Master  

-- Histologic Type 
  `ductal_adenocarcinoma` tinyint(1) NULL DEFAULT 0, 
  `mucinous_noncystic_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `signet_ring_cell_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `adenosquamous_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `undifferentiated_anaplastic_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `undifferentiated_carcinoma_with_osteoclast_like_giant_cells` tinyint(1) NULL DEFAULT 0, 
  `mixed_ductal_endocrine_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `serous_cystadenocarcinoma` tinyint(1) NULL DEFAULT 0, 
  `mucinous_cystic_neoplasm` tinyint(1) NULL DEFAULT 0, 
  `noninvasive` tinyint(1) NULL DEFAULT 0, 
  `invasive` tinyint(1) NULL DEFAULT 0, 
  `intraductal_papillary_mucinous_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `i_noninvasive` tinyint(1) NULL DEFAULT 0, 
  `i_invasive` tinyint(1) NULL DEFAULT 0,   
  `acinar_cell_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `acinar_cell_cystadenocarcinoma` tinyint(1) NULL DEFAULT 0, 
  `mixed_acinar_endocrine_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `histologic_type_other` tinyint(1) NULL DEFAULT 0, 
  `histologic_type_other_specify` varchar(250) DEFAULT NULL, 

-- histologic grade in masters  tumor grade and specify

-- Microscopic Tumor Extension  
  `microscopic_tumor_extension_cannot_be_assessed` tinyint(1) NULL DEFAULT 0,  
  `no_evidence_of_primary_tumor` tinyint(1) NULL DEFAULT 0,
  `carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,
  `tumor_is_confined_to_pancreas` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_ampulla_of_vater_or_sphincter_of_oddi` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_duodenal_wall` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_peripancreatic_soft_tissues` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_retroperitoneal_soft_tissue` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_mesenteric_adipose_tissue` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_mesocolon` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_peripancreatic_soft_tissue` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_peripancreatic_soft_tissue_specify` varchar(250) DEFAULT NULL,
  `tumor_invades_extrapancreatic_common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_adjacent_organs_or_structures` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_adjacent_organs_or_structures_specify` varchar(250) DEFAULT NULL,

-- Margins (select all that apply) 
  `margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0,
  `margins_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1)NULL DEFAULT NULL,
  `specify_margin_if_possible` varchar(50) DEFAULT NULL,
  `margins_uninvolved_by_carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,
  `margins_involved_by_carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,
  `carcinoma_in_situ_present_at_common_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `carcinoma_in_situ_present_at_pancreatic_parenchymal_margin` tinyint(1) NULL DEFAULT 0,
  `margins_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `uncinate_process_margin` tinyint(1) NULL DEFAULT 0,
  `distal_pancreatic_margin` tinyint(1) NULL DEFAULT 0,
  `common_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `promimal_pancreatic_margin` tinyint(1) NULL DEFAULT 0,
  `margin_other` tinyint(1) NULL DEFAULT 0,
  `margin_other_specify` varchar(250) DEFAULT NULL, 
  `invasive_carcinoma_involves_posterior_retroperitoneal_surface_of` tinyint(1) NULL DEFAULT 0,

-- Treatment Effect
  `no_prior_treatment` tinyint(1) NULL DEFAULT 0,
  `present` tinyint(1) NULL DEFAULT 0,
  `no_residual_tumor_complete_response_grade_0` tinyint(1) NULL DEFAULT 0,
  `marked_response_grade_1_minimal_residual_cancer` tinyint(1) NULL DEFAULT 0,
  `moderate_response_grade_2` tinyint(1) NULL DEFAULT 0,
  `no_definite_response_identified_grade_3_poor_or_no_response` tinyint(1) NULL DEFAULT 0,
  `not_known` tinyint(1) NULL DEFAULT 0,

  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,  
  
-- pTNM  See Master

-- Additional Pathologic Findings
  `additional_path_none_identified` tinyint(1) NULL DEFAULT 0,    
  `pancreatic_intraepithelial_neoplasia` tinyint(1) NULL DEFAULT 0,
  `highest_grade_PanIN` varchar(50) DEFAULT NULL,
  `chronic_pancreatitis` tinyint(1) NULL DEFAULT 0, 
  `acute_pancreatitis` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,

  `ancillary_studies_specify` varchar(250) DEFAULT NULL,
  
-- Clinical History  
  `neoadjuvant_therapy` tinyint(1) NULL DEFAULT 0,
  `familial_pancreatitis`  tinyint(1) NULL DEFAULT 0,
  `familial_pancreatic_cancer_syndrome`  tinyint(1) NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NULL DEFAULT 0,
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
  `clinical_history_not_specified` tinyint(1) NULL DEFAULT 0,
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


ALTER TABLE `dxd_cap_report_pancreasexos` ADD CONSTRAINT `FK_dxd_cap_report_pancreasexos_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 


/*Table structure for table 'dxd_cap_report_pancreasexos_revs' */

DROP TABLE IF EXISTS `dxd_cap_report_pancreasexos_revs`;

CREATE TABLE `dxd_cap_report_pancreasexos_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
-- Specimen
  `head_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `body_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `tail_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `duodenum` tinyint(1) NULL DEFAULT 0,
  `stomach` tinyint(1) NULL DEFAULT 0,
  `common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `gallbladder` tinyint(1) NULL DEFAULT 0,  
  `spleen` tinyint(1) NULL DEFAULT 0,
  `adjacent_large_vessels` tinyint(1) NULL DEFAULT 0,
  `portal_vein` tinyint(1) NULL DEFAULT 0,
  `superior_mesenteric_vein` tinyint(1) NULL DEFAULT 0,
  `other_large_vessels` tinyint(1) NULL DEFAULT 0,  
  `other_large_vessels_specify` varchar(50) DEFAULT NULL,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
  `specimen_not_specified` tinyint(1) NULL DEFAULT 0,
  `cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
-- Procedure  
  `procedure` varchar(100) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL,
-- Tumor site  
  `tumor_site_pancreatic_head` tinyint(1) NULL DEFAULT 0,
  `tumor_site_uncinate_process` tinyint(1) NULL DEFAULT 0,
  `tumor_site_pancreatic_body` tinyint(1) NULL DEFAULT 0,
  `tumor_site_pancreatic_tail` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other_specify` varchar(250) DEFAULT NULL,
  `tumor_site_cannot_be_determined` tinyint(1) NULL DEFAULT 0,
  `tumor_site_not_specified` tinyint(1) NULL DEFAULT 0,  
-- Tumor size -- See Master  

-- Histologic Type 
  `ductal_adenocarcinoma` tinyint(1) NULL DEFAULT 0, 
  `mucinous_noncystic_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `signet_ring_cell_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `adenosquamous_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `undifferentiated_anaplastic_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `undifferentiated_carcinoma_with_osteoclast_like_giant_cells` tinyint(1) NULL DEFAULT 0, 
  `mixed_ductal_endocrine_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `serous_cystadenocarcinoma` tinyint(1) NULL DEFAULT 0, 
  `mucinous_cystic_neoplasm` tinyint(1) NULL DEFAULT 0, 
  `noninvasive` tinyint(1) NULL DEFAULT 0, 
  `invasive` tinyint(1) NULL DEFAULT 0, 
  `intraductal_papillary_mucinous_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `i_noninvasive` tinyint(1) NULL DEFAULT 0, 
  `i_invasive` tinyint(1) NULL DEFAULT 0,   
  `acinar_cell_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `acinar_cell_cystadenocarcinoma` tinyint(1) NULL DEFAULT 0, 
  `mixed_acinar_endocrine_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `histologic_type_other` tinyint(1) NULL DEFAULT 0, 
  `histologic_type_other_specify` varchar(250) DEFAULT NULL, 

-- histologic grade in masters  tumor grade and specify

-- Microscopic Tumor Extension  
  `microscopic_tumor_extension_cannot_be_assessed` tinyint(1) NULL DEFAULT 0,  
  `no_evidence_of_primary_tumor` tinyint(1) NULL DEFAULT 0,
  `carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,
  `tumor_is_confined_to_pancreas` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_ampulla_of_vater_or_sphincter_of_oddi` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_duodenal_wall` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_peripancreatic_soft_tissues` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_retroperitoneal_soft_tissue` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_mesenteric_adipose_tissue` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_mesocolon` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_peripancreatic_soft_tissue` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_peripancreatic_soft_tissue_specify` varchar(250) DEFAULT NULL,
  `tumor_invades_extrapancreatic_common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_adjacent_organs_or_structures` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_adjacent_organs_or_structures_specify` varchar(250) DEFAULT NULL,

-- Margins (select all that apply) 
  `margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0,
  `margins_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1)NULL DEFAULT NULL,
  `specify_margin_if_possible` varchar(50) DEFAULT NULL,
  `margins_uninvolved_by_carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,
  `margins_involved_by_carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,
  `carcinoma_in_situ_present_at_common_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `carcinoma_in_situ_present_at_pancreatic_parenchymal_margin` tinyint(1) NULL DEFAULT 0,
  `margins_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `uncinate_process_margin` tinyint(1) NULL DEFAULT 0,
  `distal_pancreatic_margin` tinyint(1) NULL DEFAULT 0,
  `common_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `promimal_pancreatic_margin` tinyint(1) NULL DEFAULT 0,
  `margin_other` tinyint(1) NULL DEFAULT 0,
  `margin_other_specify` varchar(250) DEFAULT NULL, 
  `invasive_carcinoma_involves_posterior_retroperitoneal_surface_of` tinyint(1) NULL DEFAULT 0,

-- Treatment Effect
  `no_prior_treatment` tinyint(1) NULL DEFAULT 0,
  `present` tinyint(1) NULL DEFAULT 0,
  `no_residual_tumor_complete_response_grade_0` tinyint(1) NULL DEFAULT 0,
  `marked_response_grade_1_minimal_residual_cancer` tinyint(1) NULL DEFAULT 0,
  `moderate_response_grade_2` tinyint(1) NULL DEFAULT 0,
  `no_definite_response_identified_grade_3_poor_or_no_response` tinyint(1) NULL DEFAULT 0,
  `not_known` tinyint(1) NULL DEFAULT 0,

  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,  
  
-- pTNM  See Master

-- Additional Pathologic Findings
  `additional_path_none_identified` tinyint(1) NULL DEFAULT 0,    
  `pancreatic_intraepithelial_neoplasia` tinyint(1) NULL DEFAULT 0,
  `highest_grade_PanIN` varchar(50) DEFAULT NULL,
  `chronic_pancreatitis` tinyint(1) NULL DEFAULT 0, 
  `acute_pancreatitis` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,

  `ancillary_studies_specify` varchar(250) DEFAULT NULL,
  
-- Clinical History  
  `neoadjuvant_therapy` tinyint(1) NULL DEFAULT 0,
  `familial_pancreatitis`  tinyint(1) NULL DEFAULT 0,
  `familial_pancreatic_cancer_syndrome`  tinyint(1) NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NULL DEFAULT 0,
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
  `clinical_history_not_specified` tinyint(1) NULL DEFAULT 0,
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
('cap report - pancreas exo', 1, 'dx_cap_report_pancreasexos', 'dxd_cap_report_pancreasexos');

-- The table structures hold all forms in the application, Add the dxd_cap_report_smintestines in table structures. It doesn't hold the form itself but the form alias.

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_cap_report_pancreasexos', '', '', '0', '0', '1', '1');


-- form builder 
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'head_of_pancreas', 'head of pancreas', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'body_of_pancreas', 'body of pancreas', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tail_of_pancreas', 'tail of pancreas', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'duodenum', 'duodenum', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'stomach', 'stomach', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'common_bile_duct', 'common bile duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'gallbladder', 'gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'spleen', 'spleen', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'adjacent_large_vessels', 'adjacent large vessels', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'portal_vein', 'portal vein', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'superior_mesenteric_vein', 'superior mesenteric vein', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'other_large_vessels', 'other large vessels', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'other_large_vessels_specify', '', 'specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'specimen_not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'procedure', 'procedure', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'procedure_specify', 'procedure specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_site_pancreatic_head', 'pancreatic head', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_site_uncinate_process', 'uncinate process', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_site_pancreatic_body', 'pancreatic body', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_site_pancreatic_tail', 'pancreatic tail', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_site_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_site_other_specify', '', 'specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_site_cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_site_not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'ductal_adenocarcinoma', 'ductal adenocarcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'mucinous_noncystic_carcinoma', 'mucinous noncystic carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'signet_ring_cell_carcinoma', 'signet ring cell carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'adenosquamous_carcinoma', 'adenosquamous carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'undifferentiated_anaplastic_carcinoma', 'undifferentiated (anaplastic) carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'undifferentiated_carcinoma_with_osteoclast_like_giant_cells', 'undifferentiated carcinoma with osteoclast like giant cells', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'mixed_ductal_endocrine_carcinoma', 'mixed ductal endocrine carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'serous_cystadenocarcinoma', 'serous cystadenocarcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'mucinous_cystic_neoplasm', 'mucinous cystic neoplasm', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'noninvasive', '', 'noninvasive', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'invasive', '', 'invasive', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'intraductal_papillary_mucinous_carcinoma', 'intraductal papillary mucinous carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'i_noninvasive', '', 'noninvasive', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'i_invasive', '', 'invasive', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'acinar_cell_carcinoma', 'acinar cell carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'acinar_cell_cystadenocarcinoma', 'acinar cell cystadenocarcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'mixed_acinar_endocrine_carcinoma', 'mixed acinar endocrine carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'histologic_type_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'histologic_type_other_specify', '', 'specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'microscopic_tumor_extension_cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'no_evidence_of_primary_tumor', 'no evidence of primary tumor', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'carcinoma_in_situ', 'carcinoma in situ', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_is_confined_to_pancreas', 'tumor is confined to pancreas', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_invades_ampulla_of_vater_or_sphincter_of_oddi', 'tumor invades ampulla of vater or sphincter of oddi', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_invades_duodenal_wall', 'tumor invades duodenal wall', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_invades_peripancreatic_soft_tissues', 'tumor invades peripancreatic soft tissues', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_invades_retroperitoneal_soft_tissue', 'tumor invades retroperitoneal soft tissue', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_invades_mesenteric_adipose_tissue', 'tumor invades mesenteric adipose tissue', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_invades_mesocolon', 'tumor invades mesocolon', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_invades_other_peripancreatic_soft_tissue', 'tumor invades other peripancreatic soft tissue', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_invades_other_peripancreatic_soft_tissue_specify', '', 'specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_invades_extrapancreatic_common_bile_duct', 'tumor invades extrapancreatic common bile duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_invades_other_adjacent_organs_or_structures', 'tumor invades other adjacent organs or structures', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'tumor_invades_other_adjacent_organs_or_structures_specify', '', 'specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'margin_cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'margins_uninvolved_by_invasive_carcinoma', 'margins uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'distance_of_invasive_carcinoma_from_closest_margin_mm', 'distance of invasive carcinoma from closest margin mm', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'specify_margin_if_possible', 'specify margin (if possible):', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'margins_uninvolved_by_carcinoma_in_situ', 'margins uninvolved by carcinoma in situ', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'margins_involved_by_carcinoma_in_situ', 'margins involved by carcinoma in situ', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'carcinoma_in_situ_present_at_common_bile_duct_margin', 'carcinoma in situ present at common bile duct margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'carcinoma_in_situ_present_at_pancreatic_parenchymal_margin', 'carcinoma in situ present at pancreatic parenchymal margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'margins_involved_by_invasive_carcinoma', 'margins involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'uncinate_process_margin', 'uncinate process margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'distal_pancreatic_margin', 'distal pancreatic margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'common_bile_duct_margin', 'common bile duct margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'promimal_pancreatic_margin', 'promimal pancreatic margin', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'margin_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'margin_other_specify', '', 'specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'invasive_carcinoma_involves_posterior_retroperitoneal_surface_of', 'invasive carcinoma involves posterior retroperitoneal surface of', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'no_prior_treatment', 'no prior treatment', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'present', 'present', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'no_residual_tumor_complete_response_grade_0', 'no residual tumor (complete response grade 0)', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'marked_response_grade_1_minimal_residual_cancer', 'marked response (grade 1, minimal residual cancer)', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'moderate_response_grade_2', 'moderate response (grade 2)', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'no_definite_response_identified_grade_3_poor_or_no_response', 'no definite response identified (grade 3, poor or no response)', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'not_known', 'not known', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'lymph_vascular_invasion', 'lymph vascular invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'perineural_invasion', 'perineural invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'additional_path_none_identified', 'none identified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'pancreatic_intraepithelial_neoplasia', 'pancreatic intraepithelial neoplasia', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'highest_grade_PanIN', 'highest grade: PanIN', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'chronic_pancreatitis', 'chronic pancreatitis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'acute_pancreatitis', 'acute pancreatitis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'additional_path_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'additional_path_other_specify', '', 'specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'ancillary_studies_specify', 'ancillary studies specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'neoadjuvant_therapy', 'neoadjuvant therapy', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'familial_pancreatitis', 'familial pancreatitis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'familial_pancreatic_cancer_syndrome', 'familial pancreatic cancer syndrome', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'other_clinical_history', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'other_clinical_history_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasexos', 'clinical_history_not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_pex', 'tumour_grade', 'histologic grade', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_pex', 'path_tstage', 'path tstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_pex', 'path_nstage', 'path nstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_pex', 'path_mstage', 'path mstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='head_of_pancreas' AND `language_label`='head of pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='body_of_pancreas' AND `language_label`='body of pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tail_of_pancreas' AND `language_label`='tail of pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='duodenum' AND `language_label`='duodenum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='stomach' AND `language_label`='stomach' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='common_bile_duct' AND `language_label`='common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='gallbladder' AND `language_label`='gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='spleen' AND `language_label`='spleen' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='adjacent_large_vessels' AND `language_label`='adjacent large vessels' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='portal_vein' AND `language_label`='portal vein' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='superior_mesenteric_vein' AND `language_label`='superior mesenteric vein' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='other_large_vessels' AND `language_label`='other large vessels' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='other_large_vessels_specify' AND `language_label`='' AND `language_tag`='specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='specimen_not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='procedure' AND `language_label`='procedure' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='procedure_specify' AND `language_label`='procedure specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_site_pancreatic_head' AND `language_label`='pancreatic head' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_site_uncinate_process' AND `language_label`='uncinate process' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_site_pancreatic_body' AND `language_label`='pancreatic body' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_site_pancreatic_tail' AND `language_label`='pancreatic tail' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_site_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_site_other_specify' AND `language_label`='' AND `language_tag`='specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_site_cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_site_not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension' AND `structure_value_domain`  IS NULL  ), '1', '29', '', '1', 'greatest dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a' AND `structure_value_domain`  IS NULL  ), '1', '30', '', '1', 'additional dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `structure_value_domain`  IS NULL  ), '1', '31', '', '0', '', '1', 'x', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cannot_be_determined' ), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='ductal_adenocarcinoma' AND `language_label`='ductal adenocarcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='mucinous_noncystic_carcinoma' AND `language_label`='mucinous noncystic carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='signet_ring_cell_carcinoma' AND `language_label`='signet ring cell carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='adenosquamous_carcinoma' AND `language_label`='adenosquamous carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='undifferentiated_anaplastic_carcinoma' AND `language_label`='undifferentiated (anaplastic) carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='undifferentiated_carcinoma_with_osteoclast_like_giant_cells' AND `language_label`='undifferentiated carcinoma with osteoclast like giant cells' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='mixed_ductal_endocrine_carcinoma' AND `language_label`='mixed ductal endocrine carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='serous_cystadenocarcinoma' AND `language_label`='serous cystadenocarcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='mucinous_cystic_neoplasm' AND `language_label`='mucinous cystic neoplasm' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='noninvasive' AND `language_label`='' AND `language_tag`='noninvasive' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='invasive' AND `language_label`='' AND `language_tag`='invasive' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='intraductal_papillary_mucinous_carcinoma' AND `language_label`='intraductal papillary mucinous carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='i_noninvasive' AND `language_label`='' AND `language_tag`='noninvasive' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='i_invasive' AND `language_label`='' AND `language_tag`='invasive' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='acinar_cell_carcinoma' AND `language_label`='acinar cell carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='acinar_cell_cystadenocarcinoma' AND `language_label`='acinar cell cystadenocarcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='mixed_acinar_endocrine_carcinoma' AND `language_label`='mixed acinar endocrine carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='histologic_type_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='histologic_type_other_specify' AND `language_label`='' AND `language_tag`='specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade_specify' AND `structure_value_domain`  IS NULL  ), '1', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='microscopic_tumor_extension_cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='no_evidence_of_primary_tumor' AND `language_label`='no evidence of primary tumor' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='carcinoma_in_situ' AND `language_label`='carcinoma in situ' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_is_confined_to_pancreas' AND `language_label`='tumor is confined to pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_invades_ampulla_of_vater_or_sphincter_of_oddi' AND `language_label`='tumor invades ampulla of vater or sphincter of oddi' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '58', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_invades_duodenal_wall' AND `language_label`='tumor invades duodenal wall' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_invades_peripancreatic_soft_tissues' AND `language_label`='tumor invades peripancreatic soft tissues' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_invades_retroperitoneal_soft_tissue' AND `language_label`='tumor invades retroperitoneal soft tissue' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_invades_mesenteric_adipose_tissue' AND `language_label`='tumor invades mesenteric adipose tissue' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_invades_mesocolon' AND `language_label`='tumor invades mesocolon' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '63', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_invades_other_peripancreatic_soft_tissue' AND `language_label`='tumor invades other peripancreatic soft tissue' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '64', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_invades_other_peripancreatic_soft_tissue_specify' AND `language_label`='' AND `language_tag`='specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_invades_extrapancreatic_common_bile_duct' AND `language_label`='tumor invades extrapancreatic common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '66', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_invades_other_adjacent_organs_or_structures' AND `language_label`='tumor invades other adjacent organs or structures' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '67', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='tumor_invades_other_adjacent_organs_or_structures_specify' AND `language_label`='' AND `language_tag`='specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '68', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='margin_cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '69', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='margins_uninvolved_by_invasive_carcinoma' AND `language_label`='margins uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='distance_of_invasive_carcinoma_from_closest_margin_mm' AND `language_label`='distance of invasive carcinoma from closest margin mm' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='specify_margin_if_possible' AND `language_label`='specify margin (if possible):' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='margins_uninvolved_by_carcinoma_in_situ' AND `language_label`='margins uninvolved by carcinoma in situ' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='margins_involved_by_carcinoma_in_situ' AND `language_label`='margins involved by carcinoma in situ' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='carcinoma_in_situ_present_at_common_bile_duct_margin' AND `language_label`='carcinoma in situ present at common bile duct margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='carcinoma_in_situ_present_at_pancreatic_parenchymal_margin' AND `language_label`='carcinoma in situ present at pancreatic parenchymal margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='margins_involved_by_invasive_carcinoma' AND `language_label`='margins involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '77', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='uncinate_process_margin' AND `language_label`='uncinate process margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '78', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='distal_pancreatic_margin' AND `language_label`='distal pancreatic margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '79', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='common_bile_duct_margin' AND `language_label`='common bile duct margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='promimal_pancreatic_margin' AND `language_label`='promimal pancreatic margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='margin_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='margin_other_specify' AND `language_label`='' AND `language_tag`='specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='invasive_carcinoma_involves_posterior_retroperitoneal_surface_of' AND `language_label`='invasive carcinoma involves posterior retroperitoneal surface of' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '84', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='no_prior_treatment' AND `language_label`='no prior treatment' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '85', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='present' AND `language_label`='present' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '86', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='no_residual_tumor_complete_response_grade_0' AND `language_label`='no residual tumor (complete response grade 0)' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '87', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='marked_response_grade_1_minimal_residual_cancer' AND `language_label`='marked response (grade 1, minimal residual cancer)' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '88', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='moderate_response_grade_2' AND `language_label`='moderate response (grade 2)' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '89', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='no_definite_response_identified_grade_3_poor_or_no_response' AND `language_label`='no definite response identified (grade 3, poor or no response)' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='not_known' AND `language_label`='not known' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '91', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='lymph_vascular_invasion' AND `language_label`='lymph vascular invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '92', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='perineural_invasion' AND `language_label`='perineural invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '93', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_m' ), '2', '94', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_r' ), '2', '95', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_y' ), '2', '96', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_examined' AND `structure_value_domain`  IS NULL  ), '2', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_involved' AND `structure_value_domain`  IS NULL  ), '2', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage_metastasis_site_specify' AND `structure_value_domain`  IS NULL  ), '2', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='additional_path_none_identified' AND `language_label`='none identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='pancreatic_intraepithelial_neoplasia' AND `language_label`='pancreatic intraepithelial neoplasia' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='highest_grade_PanIN' AND `language_label`='highest grade: PanIN' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='chronic_pancreatitis' AND `language_label`='chronic pancreatitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '106', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='acute_pancreatitis' AND `language_label`='acute pancreatitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '107', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='additional_path_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '108', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='additional_path_other_specify' AND `language_label`='' AND `language_tag`='specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '109', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='ancillary_studies_specify' AND `language_label`='ancillary studies specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '110', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='neoadjuvant_therapy' AND `language_label`='neoadjuvant therapy' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '111', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='familial_pancreatitis' AND `language_label`='familial pancreatitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '112', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='familial_pancreatic_cancer_syndrome' AND `language_label`='familial pancreatic cancer syndrome' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '113', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='other_clinical_history' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '114', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='other_clinical_history_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '115', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasexos' AND `field`='clinical_history_not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '116', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  ), '2', '117', '', '0', '', '0', '', '1', '', '0', '', '1', 'cols=40, rows=6', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_pex' AND `field`='tumour_grade' AND `language_label`='histologic grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_pex' AND `field`='path_tstage' AND `language_label`='path tstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '97', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_pex' AND `field`='path_nstage' AND `language_label`='path nstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '98', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasexos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_pex' AND `field`='path_mstage' AND `language_label`='path mstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


-- need checkbox update and heading
-- update checkbox structure value domain to 185
update structure_fields
set structure_value_domain=185
where type='checkbox'
and structure_value_domain is null;

-- add heading
update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='head_of_pancreas'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasexos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor site'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_site_pancreatic_head'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasexos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor size'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasexos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='histologic type'
where sfi.id=sfo.structure_field_id
and sfi.field='ductal_adenocarcinoma'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasexos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='microscopic tumor extension'
where sfi.id=sfo.structure_field_id
and sfi.field='microscopic_tumor_extension_cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasexos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='margin'
where sfi.id=sfo.structure_field_id
and sfi.field='margin_cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasexos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='treatment effect'
where sfi.id=sfo.structure_field_id
and sfi.field='no_prior_treatment'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasexos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='pathologic staging (pTNM)'
where sfi.id=sfo.structure_field_id
and sfi.field='path_tnm_descriptor_m'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasexos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='additional pathologic findings'
where sfi.id=sfo.structure_field_id
and sfi.field='additional_path_none_identified'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasexos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='clinical history'
where sfi.id=sfo.structure_field_id
and sfi.field='neoadjuvant_therapy'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasexos'; 


-- index
UPDATE structures AS str, structure_formats AS stfo, structure_fields AS sf 
SET stfo.flag_index = '1'
WHERE str.alias = 'dx_cap_report_pancreasexos'
AND str.id = stfo.structure_id 
AND stfo.structure_field_id = sf.id
AND sf.field IN ('dx_date', 'tumor_site', 'tumour_grade', 'histologic_type');



-- dropdown list
-- invasion 
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_pancreasexos' and field='lymph_vascular_invasion';


update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_pancreasexos' and field='perineural_invasion';

-- procedure_dxd_pex
insert ignore into structure_permissible_values (value, language_alias) values
('excisional biopsy (enucleation)','excisional biopsy (enucleation)'),
('pancreaticoduodenectomy (whipple resection), partial pancreatectomy','pancreaticoduodenectomy (whipple resection), partial pancreatectomy'),
('pancreaticoduodenectomy (whipple resection), total pancreatectomy','pancreaticoduodenectomy (whipple resection), total pancreatectomy'),
('partial pancreatectomy, pancreatic body','partial pancreatectomy, pancreatic body'),
('partial pancreatectomy, pancreatic tail','partial pancreatectomy, pancreatic tail');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('procedure_dxd_pex', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values 
((select id from structure_value_domains where domain_name='procedure_dxd_pex'), (select id from structure_permissible_values where value='pancreaticoduodenectomy (whipple resection), partial pancreatectomy'), 2,1, 'pancreaticoduodenectomy (whipple resection), partial pancreatectomy'),
((select id from structure_value_domains where domain_name='procedure_dxd_pex'), (select id from structure_permissible_values where value='pancreaticoduodenectomy (whipple resection), total pancreatectomy'), 3,1, 'pancreaticoduodenectomy (whipple resection), total pancreatectomy'),
((select id from structure_value_domains where domain_name='procedure_dxd_pex'), (select id from structure_permissible_values where value='partial pancreatectomy, pancreatic body'), 4,1, 'partial pancreatectomy, pancreatic body'),
((select id from structure_value_domains where domain_name='procedure_dxd_pex'), (select id from structure_permissible_values where value='partial pancreatectomy, pancreatic tail'), 5,1, 'partial pancreatectomy, pancreatic tail'),
((select id from structure_value_domains where domain_name='procedure_dxd_pex'), (select id from structure_permissible_values where value='other'), 6,1, 'other'),
((select id from structure_value_domains where domain_name='procedure_dxd_pex'), (select id from structure_permissible_values where value='not specified'), 7,1, 'not specified');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='procedure_dxd_pex')
where tablename='dxd_cap_report_pancreasexos' and field='procedure';

-- histologic_grade_pex
insert ignore into structure_permissible_values (value, language_alias) values
('gx','gx: cannot be assessed'),
('g1','g1: well differentiated'),
('g2','g2: moderately differentiated'),
('g3','g3: poorly differentiated'),
('g4','g4: undifferentiated');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_grade_pex', 'open', '', null);


insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_grade_pex'), (select id from structure_permissible_values where value='not applicable'), 1,1,'not applicable'),
((select id from structure_value_domains where domain_name='histologic_grade_pex'), (select id from structure_permissible_values where value='gx' and language_alias= 'gx: cannot be assessed'), 2,1,'gx: cannot be assessed'),
((select id from structure_value_domains where domain_name='histologic_grade_pex'), (select id from structure_permissible_values where value='g1' and language_alias= 'g1: well differentiated'), 3,1, 'g1: well differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_pex'), (select id from structure_permissible_values where value='g1' and language_alias= 'g2: moderately differentiated'), 4,1,'g2: moderately differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_pex'), (select id from structure_permissible_values where value='g3' and language_alias= 'g3: poorly differentiated'), 5,1,'g3: poorly differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_pex'), (select id from structure_permissible_values where value='g4' and language_alias= 'g4: undifferentiated'), 6,1,'g4: undifferentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_pex'), (select id from structure_permissible_values where value='other'), 7,1,'other');
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_grade_pex')
where tablename='diagnosis_masters_pex' and field='tumour_grade';

-- path_tstage_pex
insert ignore into structure_permissible_values (value, language_alias) values
('ptx', 'ptx: cannot be assessed'),
('pt0','pt0: no evidence of primary tumor'),
('ptis', 'ptis: carcinoma in situ'),
('pt1','pt1: tumor limited to the pancreas, 2 cm or less in greatest dimension'),
('pt2','pt2: tumor limited to the pancreas, more than 2 cm in greatest dimension'),
('pt3','pt3: tumor extends beyond the pancreas but without involvement of the celiac axis or the superior mesenteric artery'),
('pt4','pt4: tumor involves the celiac axis or the superior mesenteric artery');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_tstage_pex', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_tstage_pex'), (select id from structure_permissible_values where value='ptx' and language_alias='ptx: cannot be assessed'), 1,1, 'ptx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_tstage_pex'), (select id from structure_permissible_values where value='pt0' and language_alias='pt0: no evidence of primary tumor'), 2,1, 'pt0: no evidence of primary tumor'),
((select id from structure_value_domains where domain_name='path_tstage_pex'), (select id from structure_permissible_values where value='ptis' and language_alias='ptis: carcinoma in situ'), 2,1, 'ptis: carcinoma in situ'),
((select id from structure_value_domains where domain_name='path_tstage_pex'), (select id from structure_permissible_values where value='pt1' and language_alias='pt1: tumor limited to the pancreas, 2 cm or less in greatest dimension'), 3,1, 'pt1: tumor limited to the pancreas, 2 cm or less in greatest dimension'),
((select id from structure_value_domains where domain_name='path_tstage_pex'), (select id from structure_permissible_values where value='pt2' and language_alias='pt2: tumor limited to the pancreas, more than 2 cm in greatest dimension'), 4,1, 'pt2: tumor limited to the pancreas, more than 2 cm in greatest dimension'),
((select id from structure_value_domains where domain_name='path_tstage_pex'), (select id from structure_permissible_values where value='pt3' and language_alias='pt3: tumor extends beyond the pancreas but without involvement of the celiac axis or the superior mesenteric artery'), 5,1, 'pt3: tumor extends beyond the pancreas but without involvement of the celiac axis or the superior mesenteric artery'),
((select id from structure_value_domains where domain_name='path_tstage_pex'), (select id from structure_permissible_values where value='pt4' and language_alias='pt4: tumor involves the celiac axis or the superior mesenteric artery'), 6,1, 'pT4: tumor involves the celiac axis or the superior mesenteric artery');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_tstage_pex')
where tablename='diagnosis_masters_pex' and field='path_tstage';

-- path_nstage_pex
insert ignore into structure_permissible_values (value, language_alias) values
('pnx','pnx: cannot be assessed'),
('pn0','pn0: no regional lymph node metastasis'),
('pn1','pn1: regional lymph node metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_nstage_pex', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_nstage_pex'), (select id from structure_permissible_values where value='pnx' and language_alias='pnx: cannot be assessed'), 1,1, 'pnx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_nstage_pex'), (select id from structure_permissible_values where value='pn0' and language_alias='pn0: no regional lymph node metastasis'), 2,1, 'pn0: no regional lymph node metastasis'),
((select id from structure_value_domains where domain_name='path_nstage_pex'), (select id from structure_permissible_values where value='pn1' and language_alias='pn1: regional lymph node metastasis'), 3,1, 'pn1: regional lymph node metastasis');


update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_nstage_pex')
where tablename='diagnosis_masters_pex' and field='path_nstage';

-- path_mstage_pex
insert ignore into structure_permissible_values (value, language_alias) values
('pm1','pm1: Distant metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_mstage_pex', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_mstage_pex'), (select id from structure_permissible_values where value='not applicable' and language_alias='not applicable'), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='path_mstage_pex'), (select id from structure_permissible_values where value='pm1' and language_alias='pm1: Distant metastasis'), 2,1, 'pm1: Distant metastasis');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_mstage_pex')
where tablename='diagnosis_masters_pex' and field='path_mstage';


--  insert into i18n need populate the value from the db
-- insert into i18n
INSERT IGNORE INTO i18n (id, en, fr)
select value, value, '' from structure_permissible_values 
where value  not in (select id from i18n);

INSERT IGNORE INTO i18n (id, en, fr)
select language_alias, language_alias, '' from structure_permissible_values 
where language_alias not in (select id from i18n);
                  