
/*Table structure for table 'dxd_cap_report_pancreasendos' */

DROP TABLE IF EXISTS `dxd_cap_report_pancreasendos`;

CREATE TABLE IF NOT EXISTS `dxd_cap_report_pancreasendos` (
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
-- Tumor size
-- See Master  

-- Tumor Focality
  `tumor_unifocal` tinyint(1) NULL DEFAULT 0, 
  `tumor_multifocal` tinyint(1) NULL DEFAULT 0, 
  `specify_number_of_tumors` smallint(1) DEFAULT NULL,
  `tumor_cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
  `tumor_not_specified` tinyint(1) NULL DEFAULT 0,   
-- Histologic Type 
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
  `small_cell_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `large_cell_endocrine_carcinoma` tinyint(1) NULL DEFAULT 0,   
-- World Health Organization Classification
  `world_health_organization_classification` varchar(60) DEFAULT NULL,
-- Functional Type  
  `functional_cannot_be_assessed` tinyint(1) NULL DEFAULT 0,
  `pancreatic_endocrine_tumor,_functional`  tinyint(1) NULL DEFAULT 0,
-- heading (correlation with clinical syndrome and elevated serum levels of hormone product)
  `insulin_producing` tinyint(1) NULL DEFAULT 0, 
  `glucagon_producing` tinyint(1) NULL DEFAULT 0, 
  `somatostatin_producing` tinyint(1) NULL DEFAULT 0, 
  `gastrin_producing` tinyint(1) NULL DEFAULT 0, 
  `VIP_producing` tinyint(1) NULL DEFAULT 0, 
  `functional_other` tinyint(1) NULL DEFAULT 0, 
  `functional_other_specify` varchar(250) DEFAULT NULL,
  `pancreatic_endocrine_tumor_nonfunctional` tinyint(1) NULL DEFAULT 0, 
  `pancreatic_endocrine_tumor,_functional_status_unknown` tinyint(1) NULL DEFAULT 0, 
-- Mototic Activity  
  `mitotic_not_applicable` tinyint(1) NULL DEFAULT 0, 
  `less_than_2_mitoses_10_high_power_fields` tinyint(1) NULL DEFAULT 0,   
  `specify_mitoses_per_10_HPF` varchar(10) DEFAULT NULL,
  `greater_than_or_equal_to_2_mitoses_10_HPF_to_10_mitoses_10_HPF` tinyint(1) NULL DEFAULT 0,  
  `great_specify_mitoses_per_10_HPF` varchar(10) DEFAULT NULL,
  `greater_than_10_mitoses_per_10_HPF` tinyint(1) NULL DEFAULT 0,  
  `mitotic_cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
-- heading Ki67 labeling index:
  `less_or_equal_2percent_Ki67_positive_cells` tinyint(1) NULL DEFAULT 0,    
  `3_to_20percent_Ki67_positive_cells` tinyint(1) NULL DEFAULT 0,
  `great_than_20percent_Ki67-positive_cells` tinyint(1) NULL DEFAULT 0,   
  `tumor_necrosis` varchar(30) DEFAULT NULL,
-- Microscopic Tumor Extension  
  `microscopic_tumor_extension_cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
  `no_evidence_of_primary_tumor` tinyint(1) NULL DEFAULT 0,
  `tumor_is_confined_to_pancreas` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_ampulla_of_vater` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_duodenal_wall` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_peripancreatic_soft_tissues` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_adjacent_organs_or_structures` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_adjacent_organs_or_structures_specify` varchar(250) DEFAULT NULL,
-- Margins (select all that apply) 
  `margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0,
  `margins_uninvolved_by_tumor` tinyint(1) NULL DEFAULT 0,
  `distance_of_tumor_from_closest_margin_mm` decimal (3,1)NULL DEFAULT NULL,
  `specify_margin_if_possible` varchar(50) DEFAULT NULL,
  `margins_involved_by_tumor` tinyint(1) NULL DEFAULT 0,
  `uncinate_process_retroperitoneal_margin` tinyint(1) NULL DEFAULT 0,
  `distal_pancreatic_margin` tinyint(1) NULL DEFAULT 0,
  `common_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `promimal_pancreatic_margin` tinyint(1) NULL DEFAULT 0,
  `margin_other` tinyint(1) NULL DEFAULT 0,
  `margin_other_specify` varchar(250) DEFAULT NULL, 
  `tumor_involves_posterior_retroperitoneal_surface_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,
-- pTNM 
-- See Master

-- Additional Pathologic Findings
  `additional_path_none_identified` tinyint(1) NULL DEFAULT 0,    
  `chronic_pancreatitis` tinyint(1) NULL DEFAULT 0, 
  `acute_pancreatitis` tinyint(1) NULL DEFAULT 0, 
  `adenomatosis` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,

  `ancillary_studies_specify` varchar(250) DEFAULT NULL,
-- Clinical History  
  `von_hippel-Lindau_disease` tinyint(1) NULL DEFAULT 0,
  `multiple_endocrine_neoplasia_type_1`  tinyint(1) NULL DEFAULT 0,
  `familial_pancreatic_cancer_syndrome`  tinyint(1) NULL DEFAULT 0,
  `hypoglycemic_syndrome` varchar(250) DEFAULT NULL,  
  `necrolytic_migratory_erythema` tinyint(1) NULL DEFAULT 0,
  `watery_diarrhea` tinyint(1) NULL DEFAULT 0,
  `hypergastrinemia` tinyint(1) NULL DEFAULT 0,
  `zollinger-Ellison_syndrome` tinyint(1) NULL DEFAULT 0,
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


ALTER TABLE `dxd_cap_report_pancreasendos` ADD CONSTRAINT `FK_dxd_cap_report_pancreasendos_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 


/*Table structure for table 'dxd_cap_report_pancreasendos_revs' */

DROP TABLE IF EXISTS `dxd_cap_report_pancreasendos_revs`;

CREATE TABLE `dxd_cap_report_pancreasendos_revs` (
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
-- Tumor size
-- See Master  

-- Tumor Focality
  `tumor_unifocal` tinyint(1) NULL DEFAULT 0, 
  `tumor_multifocal` tinyint(1) NULL DEFAULT 0, 
  `specify_number_of_tumors` smallint(1) DEFAULT NULL,
  `tumor_cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
  `tumor_not_specified` tinyint(1) NULL DEFAULT 0,   
-- Histologic Type 
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
  `small_cell_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `large_cell_endocrine_carcinoma` tinyint(1) NULL DEFAULT 0,   
-- World Health Organization Classification
  `world_health_organization_classification` varchar(60) DEFAULT NULL,
-- Functional Type  
  `functional_cannot_be_assessed` tinyint(1) NULL DEFAULT 0,
  `pancreatic_endocrine_tumor,_functional`  tinyint(1) NULL DEFAULT 0,
-- heading (correlation with clinical syndrome and elevated serum levels of hormone product)
  `insulin_producing` tinyint(1) NULL DEFAULT 0, 
  `glucagon_producing` tinyint(1) NULL DEFAULT 0, 
  `somatostatin_producing` tinyint(1) NULL DEFAULT 0, 
  `gastrin_producing` tinyint(1) NULL DEFAULT 0, 
  `VIP_producing` tinyint(1) NULL DEFAULT 0, 
  `functional_other` tinyint(1) NULL DEFAULT 0, 
  `functional_other_specify` varchar(250) DEFAULT NULL,
  `pancreatic_endocrine_tumor_nonfunctional` tinyint(1) NULL DEFAULT 0, 
  `pancreatic_endocrine_tumor,_functional_status_unknown` tinyint(1) NULL DEFAULT 0, 
-- Mototic Activity  
  `mitotic_not_applicable` tinyint(1) NULL DEFAULT 0, 
  `less_than_2_mitoses_10_high_power_fields` tinyint(1) NULL DEFAULT 0,   
  `specify_mitoses_per_10_HPF` varchar(10) DEFAULT NULL,
  `greater_than_or_equal_to_2_mitoses_10_HPF_to_10_mitoses_10_HPF` tinyint(1) NULL DEFAULT 0,  
  `great_specify_mitoses_per_10_HPF` varchar(10) DEFAULT NULL,
  `greater_than_10_mitoses_per_10_HPF` tinyint(1) NULL DEFAULT 0,  
  `mitotic_cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
-- heading Ki67 labeling index:
  `less_or_equal_2percent_Ki67_positive_cells` tinyint(1) NULL DEFAULT 0,    
  `3_to_20percent_Ki67_positive_cells` tinyint(1) NULL DEFAULT 0,
  `great_than_20percent_Ki67-positive_cells` tinyint(1) NULL DEFAULT 0,   
  `tumor_necrosis` varchar(30) DEFAULT NULL,
-- Microscopic Tumor Extension  
  `microscopic_tumor_extension_cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
  `no_evidence_of_primary_tumor` tinyint(1) NULL DEFAULT 0,
  `tumor_is_confined_to_pancreas` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_ampulla_of_vater` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_duodenal_wall` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_peripancreatic_soft_tissues` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_adjacent_organs_or_structures` tinyint(1) NULL DEFAULT 0,
  `tumor_invades_other_adjacent_organs_or_structures_specify` varchar(250) DEFAULT NULL,
-- Margins (select all that apply) 
  `margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0,
  `margins_uninvolved_by_tumor` tinyint(1) NULL DEFAULT 0,
  `distance_of_tumor_from_closest_margin_mm` decimal (3,1)NULL DEFAULT NULL,
  `specify_margin_if_possible` varchar(50) DEFAULT NULL,
  `margins_involved_by_tumor` tinyint(1) NULL DEFAULT 0,
  `uncinate_process_retroperitoneal_margin` tinyint(1) NULL DEFAULT 0,
  `distal_pancreatic_margin` tinyint(1) NULL DEFAULT 0,
  `common_bile_duct_margin` tinyint(1) NULL DEFAULT 0,
  `promimal_pancreatic_margin` tinyint(1) NULL DEFAULT 0,
  `margin_other` tinyint(1) NULL DEFAULT 0,
  `margin_other_specify` varchar(250) DEFAULT NULL, 
  `tumor_involves_posterior_retroperitoneal_surface_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,
-- pTNM 
-- See Master

-- Additional Pathologic Findings
  `additional_path_none_identified` tinyint(1) NULL DEFAULT 0,    
  `chronic_pancreatitis` tinyint(1) NULL DEFAULT 0, 
  `acute_pancreatitis` tinyint(1) NULL DEFAULT 0, 
  `adenomatosis` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,

  `ancillary_studies_specify` varchar(250) DEFAULT NULL,
-- Clinical History  
  `von_hippel-Lindau_disease` tinyint(1) NULL DEFAULT 0,
  `multiple_endocrine_neoplasia_type_1`  tinyint(1) NULL DEFAULT 0,
  `familial_pancreatic_cancer_syndrome`  tinyint(1) NULL DEFAULT 0,
  `hypoglycemic_syndrome` varchar(250) DEFAULT NULL,  
  `necrolytic_migratory_erythema` tinyint(1) NULL DEFAULT 0,
  `watery_diarrhea` tinyint(1) NULL DEFAULT 0,
  `hypergastrinemia` tinyint(1) NULL DEFAULT 0,
  `zollinger-Ellison_syndrome` tinyint(1) NULL DEFAULT 0,
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
('cap report - pancreas endo', 1, 'dx_cap_report_pancreasendos', 'dxd_cap_report_pancreasendos');

-- The table structures hold all forms in the application, Add the dxd_cap_report_smintestines in table structures. It doesn't hold the form itself but the form alias.

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_cap_report_pancreasendos', '', '', '0', '0', '1', '1');


--
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'head_of_pancreas', 'head of pancreas', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'body_of_pancreas', 'body of pancreas', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tail_of_pancreas', 'tail of pancreas', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'duodenum', 'duodenum', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'stomach', 'stomach', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'common_bile_duct', 'common bile duct', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'gallbladder', 'gallbladder', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'spleen', 'spleen', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'adjacent_large_vessels', 'adjacent large vessels', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'portal_vein', 'portal vein', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'superior_mesenteric_vein', 'superior mesenteric vein', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'other_large_vessels', 'other large vessels', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'other_large_vessels_specify', '', 'other large vessels specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'other', 'other', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'specimen_not_specified', 'specimen not specified', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'procedure', 'procedure', '', 'select', '', '', NULL, 'procedure', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'procedure_specify', 'procedure specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_site_pancreatic_head', 'pancreatic head', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , 'tumor site', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_site_uncinate_process', 'uncinate process', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_site_pancreatic_body', 'pancreatic body', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_site_pancreatic_tail', 'pancreatic tail', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_site_other', 'other', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_site_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_site_cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_site_not_specified', 'not specified', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_unifocal', 'unifocal', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , 'tumor focality', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_multifocal', 'multifocal', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'specify_number_of_tumors', '', 'specify number of tumors', 'integer', '', '', NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_not_specified', 'not specified', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'histologic_type', 'histologic type', '', 'select', '', '', NULL, 'histologic type', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'small_cell_carcinoma', 'small cell carcinoma', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'large_cell_endocrine_carcinoma', 'large cell endocrine carcinoma', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'world_health_organization_classification', 'world health organization classification', '', 'select', '', '', NULL, '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'functional_cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , 'functional type', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'pancreatic_endocrine_tumor,_functional', 'pancreatic endocrine tumor, functional', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'insulin_producing', 'insulin_producing', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'glucagon_producing', 'glucagon_producing', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'somatostatin_producing', 'somatostatin_producing', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'gastrin_producing', 'gastrin_producing', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'VIP_producing', 'vasoactive intestinal polypeptide (VIP)-producing', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'functional_other', 'other', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'functional_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'pancreatic_endocrine_tumor_nonfunctional', 'pancreatic endocrine tumor nonfunctional', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'pancreatic_endocrine_tumor,_functional_status_unknown', 'pancreatic endocrine tumor, functional status unknown', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'mitotic_not_applicable', 'not applicable', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , 'mitotic activity', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'less_than_2_mitoses_10_high_power_fields', 'less than 2 mitoses/10 high power fields (HPF)', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'greater_than_or_equal_to_2_mitoses_10_HPF_to_10_mitoses_10_HPF', 'greater than or equal to 2 mitoses/10 HPF to 10 mitoses/10 HPF', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'specify_mitoses_per_10_HPF', '', 'specify mitoses per 10 HPF', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'great_specify_mitoses_per_10_HPF', '', 'specify mitoses per 10 HPF', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'greater_than_10_mitoses_per_10_HPF', 'greater than 10 mitoses per 10 HPF', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'mitotic_cannot_be_determined', 'mitotic cannot be determined', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'less_or_equal_2percent_Ki67_positive_cells', 'less or equal 2% Ki67-positive cells', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , 'Ki67 labeling index:', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', '3_to_20percent_Ki67_positive_cells', '3%-20% Ki67-positive cells', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'great_than_20percent_Ki67-positive_cells', 'great than 20% Ki67-positive cells', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_necrosis', 'tumor necrosis', '', 'select', '', '', NULL, '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'microscopic_tumor_extension_cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , 'microscopic tumor extension', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'no_evidence_of_primary_tumor', 'no evidence of primary tumor', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_is_confined_to_pancreas', 'tumor is confined to pancreas', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_invades_ampulla_of_vater', 'tumor invades ampulla of vater', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_invades_common_bile_duct', 'tumor invades common bile duct', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_invades_duodenal_wall', 'tumor invades duodenal wall', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_invades_peripancreatic_soft_tissues', 'tumor invades peripancreatic soft tissues', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_invades_other_adjacent_organs_or_structures', 'tumor invades other adjacent organs or structures', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_invades_other_adjacent_organs_or_structures_specify', '', 'specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'margin_cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , 'margin', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'margins_uninvolved_by_tumor', 'margins uninvolved by tumor', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'distance_of_tumor_from_closest_margin_mm', 'distance of tumor from closest margin mm', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'specify_margin_if_possible', 'specify margin (if possible)', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'margins_involved_by_tumor', 'margin(s) involved by tumor', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'uncinate_process_retroperitoneal_margin', 'uncinate process (retroperitoneal) margin', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'distal_pancreatic_margin', 'distal pancreatic margin', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'common_bile_duct_margin', 'common bile duct margin', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'promimal_pancreatic_margin', 'promimal pancreatic margin', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'margin_other', 'margin other', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'margin_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'tumor_involves_posterior_retroperitoneal_surface_of_pancreas', 'tumor involves posterior retroperitoneal surface of pancreas', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'lymph_vascular_invasion', 'lymph vascular invasion', '', 'select', '', '', NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'perineural_invasion', 'perineural invasion', '', 'select', '', '', NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_pe', 'path_tstage', 'path tstage', '', 'select', '', '', NULL, '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'additional_path_none_identified', 'none identified', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , 'additional pathologic findings', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'chronic_pancreatitis', 'chronic pancreatitis', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'acute_pancreatitis', 'acute pancreatitis', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'adenomatosis', 'adenomatosis (multiple endocrine tumors, each less than 5 mm in greatest dimension)', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'additional_path_other', 'other', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'additional_path_other_specify', '', ' other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'ancillary_studies_specify', 'ancillary studies specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'von_hippel-Lindau_disease', 'von hippel-Lindau disease', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , 'clinical history', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'multiple_endocrine_neoplasia_type_1', 'multiple endocrine neoplasia type 1', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'familial_pancreatic_cancer_syndrome', 'familial pancreatic cancer syndrome', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'hypoglycemic_syndrome', 'hypoglycemic syndrome', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'necrolytic_migratory_erythema', 'necrolytic migratory erythema', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'watery_diarrhea', 'watery diarrhea', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'hypergastrinemia', 'hypergastrinemia', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'zollinger-Ellison_syndrome', 'zollinger-Ellison syndrome', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'other_clinical_history', 'other ', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'other_clinical_history_specify', '', 'other specify', 'input', '', '', NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'clinical_history_not_specified', 'not specified', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_pe', 'path_nstage', 'path nstage', '', 'select', '', '', NULL, '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_pe', 'path_mstage', 'path mstage', '', 'select', '', '', NULL, '', 'open', 'open', 'open');



INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='head_of_pancreas' AND `language_label`='head of pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '2', 'specimen', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='body_of_pancreas' AND `language_label`='body of pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tail_of_pancreas' AND `language_label`='tail of pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='duodenum' AND `language_label`='duodenum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='stomach' AND `language_label`='stomach' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='common_bile_duct' AND `language_label`='common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='gallbladder' AND `language_label`='gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='spleen' AND `language_label`='spleen' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='adjacent_large_vessels' AND `language_label`='adjacent large vessels' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='portal_vein' AND `language_label`='portal vein' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='superior_mesenteric_vein' AND `language_label`='superior mesenteric vein' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='other_large_vessels' AND `language_label`='other large vessels' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='other_large_vessels_specify' AND `language_label`='' AND `language_tag`='other large vessels specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='specimen_not_specified' AND `language_label`='specimen not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='procedure' AND `language_label`='procedure' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`=''  ), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='procedure_specify' AND `language_label`='procedure specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_site_pancreatic_head' AND `language_label`='pancreatic head' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '21', 'tumor site', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_site_uncinate_process' AND `language_label`='uncinate process' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_site_pancreatic_body' AND `language_label`='pancreatic body' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_site_pancreatic_tail' AND `language_label`='pancreatic tail' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_site_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_site_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_site_cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_site_not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension' AND `structure_value_domain`  IS NULL  ), '1', '29', 'tumor size', '1', 'greatest dimension', '0', '', '1', 'tumor size', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a' AND `structure_value_domain`  IS NULL  ), '1', '30', '', '1', 'additional_dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `structure_value_domain`  IS NULL  ), '1', '31', '', '0', '', '1', 'x', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cannot_be_determined'  ), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_unifocal' AND `language_label`='unifocal' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '33', 'tumor focality', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_multifocal' AND `language_label`='multifocal' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='specify_number_of_tumors' AND `language_label`='' AND `language_tag`='specify number of tumors' AND `type`='integer' AND `setting`='' AND `default`=''  AND `language_help`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='histologic_type' AND `language_label`='histologic type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`=''  ), '1', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='histologic_type_specify' AND `language_label`='histologic type specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='small_cell_carcinoma' AND `language_label`='small cell carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='large_cell_endocrine_carcinoma' AND `language_label`='large cell endocrine carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='world_health_organization_classification' AND `language_label`='world health organization classification' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `language_help`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='functional_cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') ), '1', '43', 'functional type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='pancreatic_endocrine_tumor,_functional' AND `language_label`='pancreatic endocrine tumor, functional' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='insulin_producing' AND `language_label`='insulin_producing' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='glucagon_producing' AND `language_label`='glucagon_producing' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='somatostatin_producing' AND `language_label`='somatostatin_producing' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='gastrin_producing' AND `language_label`='gastrin_producing' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='VIP_producing' AND `language_label`='vasoactive intestinal polypeptide (VIP)-producing' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='functional_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='functional_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='pancreatic_endocrine_tumor_nonfunctional' AND `language_label`='pancreatic endocrine tumor nonfunctional' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='pancreatic_endocrine_tumor,_functional_status_unknown' AND `language_label`='pancreatic endocrine tumor, functional status unknown' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='mitotic_not_applicable' AND `language_label`='not applicable' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`='mitotic activity'), '1', '54', 'mitotic activity', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='less_than_2_mitoses_10_high_power_fields' AND `language_label`='less than 2 mitoses/10 high power fields (HPF)' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='greater_than_or_equal_to_2_mitoses_10_HPF_to_10_mitoses_10_HPF' AND `language_label`='greater than or equal to 2 mitoses/10 HPF to 10 mitoses/10 HPF' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='specify_mitoses_per_10_HPF' AND `language_label`='' AND `language_tag`='specify mitoses per 10 HPF' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='great_specify_mitoses_per_10_HPF' AND `language_label`='' AND `language_tag`='specify mitoses per 10 HPF' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '58', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='greater_than_10_mitoses_per_10_HPF' AND `language_label`='greater than 10 mitoses per 10 HPF' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='mitotic_cannot_be_determined' AND `language_label`='mitotic cannot be determined' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='less_or_equal_2percent_Ki67_positive_cells' AND `language_label`='less or equal 2% Ki67-positive cells' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '1', '61', 'Ki67 labeling index:', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='3_to_20percent_Ki67_positive_cells' AND `language_label`='3%-20% Ki67-positive cells' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='great_than_20percent_Ki67-positive_cells' AND `language_label`='great than 20% Ki67-positive cells' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '63', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_necrosis' AND `language_label`='tumor necrosis' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`=''   AND `language_help`=''), '1', '64', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='microscopic_tumor_extension_cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '2', '1', 'microscopic tumor extension', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='no_evidence_of_primary_tumor' AND `language_label`='no evidence of primary tumor' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_is_confined_to_pancreas' AND `language_label`='tumor is confined to pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_invades_ampulla_of_vater' AND `language_label`='tumor invades ampulla of vater' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_invades_common_bile_duct' AND `language_label`='tumor invades common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_invades_duodenal_wall' AND `language_label`='tumor invades duodenal wall' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_invades_peripancreatic_soft_tissues' AND `language_label`='tumor invades peripancreatic soft tissues' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_invades_other_adjacent_organs_or_structures' AND `language_label`='tumor invades other adjacent organs or structures' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_invades_other_adjacent_organs_or_structures_specify' AND `language_label`='' AND `language_tag`='specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='margin_cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '2', '10', 'margin', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='margins_uninvolved_by_tumor' AND `language_label`='margins uninvolved by tumor' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='distance_of_tumor_from_closest_margin_mm' AND `language_label`='distance of tumor from closest margin mm' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='specify_margin_if_possible' AND `language_label`='specify margin (if possible)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='margins_involved_by_tumor' AND `language_label`='margin(s) involved by tumor' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='uncinate_process_retroperitoneal_margin' AND `language_label`='uncinate process (retroperitoneal) margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='distal_pancreatic_margin' AND `language_label`='distal pancreatic margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='common_bile_duct_margin' AND `language_label`='common bile duct margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='promimal_pancreatic_margin' AND `language_label`='promimal pancreatic margin' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='margin_other' AND `language_label`='margin other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='margin_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='tumor_involves_posterior_retroperitoneal_surface_of_pancreas' AND `language_label`='tumor involves posterior retroperitoneal surface of pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='lymph_vascular_invasion' AND `language_label`='lymph vascular invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`=''  AND `language_help`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='perineural_invasion' AND `language_label`='perineural invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`=''   AND `language_help`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_m'  ), '2', '24', 'pathologic staging (pTNM)', '1', 'path tnm descriptor', '1', 'multiple primary tumors', '1', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_r'   ), '2', '25', '', '1', '', '1', ' recurrent', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_y'   ), '2', '26', '', '0', '', '0', 'post treatment', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_pe' AND `field`='path_tstage' ), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_examined' ), '2', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_involved' ), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage_metastasis_site_specify' ), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='additional_path_none_identified' AND `language_label`='none identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '2', '33', 'additional pathologic findings', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='chronic_pancreatitis' AND `language_label`='chronic pancreatitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='acute_pancreatitis' AND `language_label`='acute pancreatitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='adenomatosis' AND `language_label`='adenomatosis (multiple endocrine tumors, each less than 5 mm in greatest dimension)' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='additional_path_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='additional_path_other_specify' AND `language_label`='' AND `language_tag`=' other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='ancillary_studies_specify' AND `language_label`='ancillary studies specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='von_hippel-Lindau_disease' AND `language_label`='von hippel-Lindau disease' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  ), '2', '40', 'clinical history', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='multiple_endocrine_neoplasia_type_1' AND `language_label`='multiple endocrine neoplasia type 1' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='familial_pancreatic_cancer_syndrome' AND `language_label`='familial pancreatic cancer syndrome' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='hypoglycemic_syndrome' AND `language_label`='hypoglycemic syndrome' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='necrolytic_migratory_erythema' AND `language_label`='necrolytic migratory erythema' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='watery_diarrhea' AND `language_label`='watery diarrhea' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='hypergastrinemia' AND `language_label`='hypergastrinemia' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='zollinger-Ellison_syndrome' AND `language_label`='zollinger-Ellison syndrome' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='other_clinical_history' AND `language_label`='other ' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='other_clinical_history_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `language_help`=''), '2', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='clinical_history_not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`=''   AND `language_help`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  ), '2', '51', '', '0', '', '0', '', '1', '', '0', '', '1', 'cols=40, rows=6', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_pe' AND `field`='path_nstage' AND `language_label`='path nstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`=''   AND `language_help`=''), '2', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_pe' AND `field`='path_mstage' AND `language_label`='path mstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`=''   AND `language_help`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');


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
and s.alias='dx_cap_report_pancreasendos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor site'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_site_pancreatic_head'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasendos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor size'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasendos';

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='functional type'
where sfi.id=sfo.structure_field_id
and sfi.field='functional_cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasendos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='mitotic activity'
where sfi.id=sfo.structure_field_id
and sfi.field='mitotic_not_applicable'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasendos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='microscopic tumor extension'
where sfi.id=sfo.structure_field_id
and sfi.field='microscopic_tumor_extension_cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasendos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='margin'
where sfi.id=sfo.structure_field_id
and sfi.field='margin_cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasendos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='pathologic staging (pTNM)'
where sfi.id=sfo.structure_field_id
and sfi.field='path_tnm_descriptor_m'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasendos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='additional pathologic findings'
where sfi.id=sfo.structure_field_id
and sfi.field='additional_path_none_identified'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasendos'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='clinical history'
where sfi.id=sfo.structure_field_id
and sfi.field='von_hippel-Lindau_disease'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_pancreasendos'; 


-- index
UPDATE structures AS str, structure_formats AS stfo, structure_fields AS sf 
SET stfo.flag_index = '1'
WHERE str.alias = 'dx_cap_report_pancreasendos'
AND str.id = stfo.structure_id 
AND stfo.structure_field_id = sf.id
AND sf.field IN ('dx_date', 'tumor_site', 'tumour_grade', 'histologic_type');




-- dropdown list

-- procedure_dxd_pe
insert ignore into structure_permissible_values (value, language_alias) values
('excisional biopsy (enucleation)','excisional biopsy (enucleation)'),
('pancreaticoduodenectomy (whipple resection), partial pancreatectomy','pancreaticoduodenectomy (whipple resection), partial pancreatectomy'),
('pancreaticoduodenectomy (whipple resection), total pancreatectomy','pancreaticoduodenectomy (whipple resection), total pancreatectomy'),
('partial pancreatectomy, pancreatic body','partial pancreatectomy, pancreatic body'),
('partial pancreatectomy, pancreatic tail','partial pancreatectomy, pancreatic tail');



insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('procedure_dxd_pe', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='procedure_dxd_pe'), (select id from structure_permissible_values where value='excisional biopsy (enucleation)'), 1,1, 'excisional biopsy (enucleation)'),
((select id from structure_value_domains where domain_name='procedure_dxd_pe'), (select id from structure_permissible_values where value='pancreaticoduodenectomy (whipple resection), partial pancreatectomy'), 2,1, 'pancreaticoduodenectomy (whipple resection), partial pancreatectomy'),
((select id from structure_value_domains where domain_name='procedure_dxd_pe'), (select id from structure_permissible_values where value='pancreaticoduodenectomy (whipple resection), total pancreatectomy'), 3,1, 'pancreaticoduodenectomy (whipple resection), total pancreatectomy'),
((select id from structure_value_domains where domain_name='procedure_dxd_pe'), (select id from structure_permissible_values where value='partial pancreatectomy, pancreatic body'), 4,1, 'partial pancreatectomy, pancreatic body'),
((select id from structure_value_domains where domain_name='procedure_dxd_pe'), (select id from structure_permissible_values where value='partial pancreatectomy, pancreatic tail'), 5,1, 'partial pancreatectomy, pancreatic tail'),
((select id from structure_value_domains where domain_name='procedure_dxd_pe'), (select id from structure_permissible_values where value='other'), 6,1, 'other'),
((select id from structure_value_domains where domain_name='procedure_dxd_pe'), (select id from structure_permissible_values where value='not specified'), 7,1, 'not specified');

select * from structure_fields
where tablename='diagnosis_masters_pe' and field='procedure';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='procedure_dxd_pe')
where tablename='dxd_cap_report_pancreasendos' and field='procedure';

-- histologic_type_pe
insert ignore into structure_permissible_values (value, language_alias) values
('well-differentiated endocrine neoplasm','well-differentiated endocrine neoplasm'),
('poorly differentiated endocrine carcinoma','poorly differentiated endocrine carcinoma'),
('carcinoma, type cannot be determined','carcinoma, type cannot be determined');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_type_pe', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_type_pe'), (select id from structure_permissible_values where value='well-differentiated endocrine neoplasm'), 1,1, 'well-differentiated endocrine neoplasm'),
((select id from structure_value_domains where domain_name='histologic_type_pe'), (select id from structure_permissible_values where value='poorly differentiated endocrine carcinoma'), 2,1, 'poorly differentiated endocrine carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_pe'), (select id from structure_permissible_values where value='other'), 3,1, 'other'),
((select id from structure_value_domains where domain_name='histologic_type_pe'), (select id from structure_permissible_values where value='carcinoma, type cannot be determined'), 4,1, 'carcinoma, type cannot be determined');

select * from structure_fields
where tablename='dxd_cap_report_pancreasendos' and field='histologic_type';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_type_pe')
where tablename='dxd_cap_report_pancreasendos' and field='histologic_type';

-- World Health Organization Classification  WHO_classification_pe
insert ignore into structure_permissible_values (value, language_alias) values
('well-differentiated endocrine tumor, benign behavior','well-differentiated endocrine tumor, benign behavior'),
('well-differentiated endocrine tumor, uncertain behavior','well-differentiated endocrine tumor, uncertain behavior'),
('well-differentiated endocrine carcinoma','well-differentiated endocrine carcinoma'),
('poorly differentiated endocrine carcinoma','poorly differentiated endocrine carcinoma');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('WHO_classification_pe', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='WHO_classification_pe'), (select id from structure_permissible_values where value='well-differentiated endocrine tumor, benign behavior'), 1,1, 'well-differentiated endocrine tumor, benign behavior'),
((select id from structure_value_domains where domain_name='WHO_classification_pe'), (select id from structure_permissible_values where value='well-differentiated endocrine tumor, uncertain behavior'), 2,1, 'well-differentiated endocrine tumor, uncertain behavior'),
((select id from structure_value_domains where domain_name='WHO_classification_pe'), (select id from structure_permissible_values where value='well-differentiated endocrine carcinoma'), 3,1, 'well-differentiated endocrine carcinoma'),
((select id from structure_value_domains where domain_name='WHO_classification_pe'), (select id from structure_permissible_values where value='poorly differentiated endocrine carcinoma'), 4,1, 'poorly differentiated endocrine carcinoma');

select * from structure_fields
where tablename='dxd_cap_report_pancreasendos' and field='world_health_organization_classification';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='WHO_classification_pe')
where tablename='dxd_cap_report_pancreasendos' and field='world_health_organization_classification';

-- tumor_necrosis
insert ignore into structure_permissible_values (value, language_alias) values
('not identified','not identified'),
('present','present'),
('not applicable','not applicable'),
('cannot be determined','cannot be determined');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('tumor_necrosis', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='tumor_necrosis'), (select id from structure_permissible_values where value='not identified'), 1,1, 'not identified'),
((select id from structure_value_domains where domain_name='tumor_necrosis'), (select id from structure_permissible_values where value='present'), 2,1, 'present'),
((select id from structure_value_domains where domain_name='tumor_necrosis'), (select id from structure_permissible_values where value='not applicable'), 3,1, 'not applicable'),
((select id from structure_value_domains where domain_name='tumor_necrosis'), (select id from structure_permissible_values where value='cannot be determined'), 4,1, 'cannot be determined');

select * from structure_fields
where tablename='dxd_cap_report_pancreasendos' and field='tumor_necrosis';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='tumor_necrosis')
where tablename='dxd_cap_report_pancreasendos' and field='tumor_necrosis';

--  lymph_vascular_invasion 
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_pancreasendos' and field='lymph_vascular_invasion';


-- perineural_invasion  use lymph_vascular_invasion drop down same
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_pancreasendos' and field='perineural_invasion';

-- path_tstage_pe
insert ignore into structure_permissible_values (value, language_alias) values
('pt1','pt1: tumor limited to the pancreas, 2 cm or less in greatest dimension'),
('pt2','pt2: tumor limited to the pancreas, more than 2 cm in greatest dimension'),
('pt3','pt3: tumor extends beyond the pancreas but without involvement of the celiac axis or the superior mesenteric artery'),
('pt4','pt4: tumor involves the celiac axis or the superior mesenteric artery');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_tstage_pe', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_tstage_pe'), (select id from structure_permissible_values where value='ptx' and language_alias='ptx: Cannot be assessed'), 1,1, 'ptx: Cannot be assessed'),
((select id from structure_value_domains where domain_name='path_tstage_pe'), (select id from structure_permissible_values where value='pt0' and language_alias='pt0: no evidence of primary tumor'), 2,1, 'pt0: no evidence of primary tumor'),
((select id from structure_value_domains where domain_name='path_tstage_pe'), (select id from structure_permissible_values where value='pt1' and language_alias='pt1: tumor limited to the pancreas, 2 cm or less in greatest dimension'), 3,1, 'pt1: tumor limited to the pancreas, 2 cm or less in greatest dimension'),
((select id from structure_value_domains where domain_name='path_tstage_pe'), (select id from structure_permissible_values where value='pt2' and language_alias='pt2: tumor limited to the pancreas, more than 2 cm in greatest dimension'), 4,1, 'pt2: tumor limited to the pancreas, more than 2 cm in greatest dimension'),
((select id from structure_value_domains where domain_name='path_tstage_pe'), (select id from structure_permissible_values where value='pt3' and language_alias='pt3: tumor extends beyond the pancreas but without involvement of the celiac axis or the superior mesenteric artery'), 5,1, 'pt3: tumor extends beyond the pancreas but without involvement of the celiac axis or the superior mesenteric artery'),
((select id from structure_value_domains where domain_name='path_tstage_pe'), (select id from structure_permissible_values where value='pt4' and language_alias='pt4: tumor involves the celiac axis or the superior mesenteric artery'), 6,1, 'pt4: tumor involves the celiac axis or the superior mesenteric artery');

select * from structure_fields
where tablename='diagnosis_masters_pe' and field='path_tstage';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_tstage_pe')
where tablename='diagnosis_masters_pe' and field='path_tstage';

-- path_nstage_pe
insert ignore into structure_permissible_values (value, language_alias) values
('pnx','pnx: cannot be assessed'),
('pn0','pn0: no regional lymph node metastasis'),
('pn1','pn1: regional lymph node metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_nstage_pe', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_nstage_pe'), (select id from structure_permissible_values where value='pnx' and language_alias='pnx: Cannot be assessed'), 1,1, 'pnx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_nstage_pe'), (select id from structure_permissible_values where value='pn0' and language_alias='pn0: No regional lymph node metastasis'), 2,1, 'pn0: no regional lymph node metastasis'),
((select id from structure_value_domains where domain_name='path_nstage_pe'), (select id from structure_permissible_values where value='pn1' and language_alias='pn1: Regional lymph node metastasis'), 3,1, 'pn1: regional lymph node metastasis');

select * from structure_fields
where tablename='diagnosis_masters_pe' and field='path_tstage';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_nstage_pe')
where tablename='diagnosis_masters_pe' and field='path_nstage';

-- path_mstage_pe
insert ignore into structure_permissible_values (value, language_alias) values
('not applicable', 'not applicable'),
('pm1','pm1: distant metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_mstage_pe', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_mstage_pe'), (select id from structure_permissible_values where value='not applicable' and language_alias='not applicable'), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='path_mstage_pe'), (select id from structure_permissible_values where value='pm1' and language_alias='pm1: distant metastasis'), 2,1, 'pm1: distant metastasis');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_mstage_pe')
where tablename='diagnosis_masters_pe' and field='path_mstage';


--  insert into i18n need populate the value from the db
-- insert into i18n
INSERT IGNORE INTO i18n (id, en, fr)
select value, value, '' from structure_permissible_values 
where value  not in (select id from i18n);

INSERT IGNORE INTO i18n (id, en, fr)
select language_alias, language_alias, '' from structure_permissible_values 
where language_alias not in (select id from i18n);
                  