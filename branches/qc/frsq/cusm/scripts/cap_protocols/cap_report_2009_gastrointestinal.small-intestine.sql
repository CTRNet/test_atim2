-- alter table diagnosis_masters
alter table diagnosis_masters
 -- Tumor Size
 add column `tumor_size_greatest_dimension` decimal (3,1)NULL DEFAULT NULL AFTER `dx_date_accuracy`,
 add column `additional_dimension_a` decimal (3,1)NULL DEFAULT NULL AFTER `tumor_size_greatest_dimension`,
 add column `additional_dimension_b` decimal (3,1)NULL DEFAULT NULL AFTER `additional_dimension_a`,
 add column `cannot_be_determined` tinyint(1) NULL DEFAULT 0 AFTER `additional_dimension_b`,
 
 -- Histologic Grade
 -- add column `histologic_grade` varchar(50) DEFAULT NULL, -- already into ATiM : tumour_grade
 add column `tumour_grade_specify` varchar(250) DEFAULT NULL AFTER `tumour_grade`,
 
 -- pTNM
 add column `path_tnm_descriptor_m` tinyint(1) NULL DEFAULT 0 AFTER `clinical_stage_summary`,
 add column `path_tnm_descriptor_r` tinyint(1) NULL DEFAULT 0 AFTER `path_tnm_descriptor_m`,
 add column `path_tnm_descriptor_y` tinyint(1) NULL DEFAULT 0 AFTER `path_tnm_descriptor_r`,
 add column `path_nstage_nbr_node_examined` smallint(1) NULL DEFAULT 0 AFTER `path_nstage`,
 add column `path_nstage_nbr_node_involved` smallint(1) NULL DEFAULT 0 AFTER `path_nstage_nbr_node_examined`,
 add column `path_mstage_metastasis_site_specify` varchar(250) DEFAULT NULL AFTER `path_mstage`;
 
alter table diagnosis_masters_revs
 -- Tumor Size
 add column `tumor_size_greatest_dimension` decimal (3,1)NULL DEFAULT NULL AFTER `dx_date_accuracy`,
 add column `additional_dimension_a` decimal (3,1)NULL DEFAULT NULL AFTER `tumor_size_greatest_dimension`,
 add column `additional_dimension_b` decimal (3,1)NULL DEFAULT NULL AFTER `additional_dimension_a`,
 add column `cannot_be_determined` tinyint(1) NULL DEFAULT 0 AFTER `additional_dimension_b`,
 
 -- Histologic Grade
 -- add column `histologic_grade` varchar(50) DEFAULT NULL, -- already into ATiM : tumour_grade
 add column `tumour_grade_specify` varchar(250) DEFAULT NULL AFTER `tumour_grade`,
 
 -- pTNM
 add column `path_tnm_descriptor_m` tinyint(1) NULL DEFAULT 0 AFTER `clinical_stage_summary`,
 add column `path_tnm_descriptor_r` tinyint(1) NULL DEFAULT 0 AFTER `path_tnm_descriptor_m`,
 add column `path_tnm_descriptor_y` tinyint(1) NULL DEFAULT 0 AFTER `path_tnm_descriptor_r`,
 add column `path_nstage_nbr_node_examined` smallint(1) NULL DEFAULT 0 AFTER `path_nstage`,
 add column `path_nstage_nbr_node_involved` smallint(1) NULL DEFAULT 0 AFTER `path_nstage_nbr_node_examined`,
 add column `path_mstage_metastasis_site_specify` varchar(250) DEFAULT NULL AFTER `path_mstage`;

/*Table structure for table 'dxd_cap_report_smintestines' */

DROP TABLE IF EXISTS `dxd_cap_report_smintestines`;

CREATE TABLE IF NOT EXISTS `dxd_cap_report_smintestines` (
  `id` int(10) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
  
  -- Specimen
  `duodenum` tinyint(1) NULL DEFAULT 0,
  `small_intestine_other_than_duodenum` tinyint(1) NULL DEFAULT 0,
  `jejunum` tinyint(1) NULL DEFAULT 0,
  `ileum` tinyint(1) NULL DEFAULT 0,
  `stomach` tinyint(1) NULL DEFAULT 0,
  `head_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `ampulla` tinyint(1) NULL DEFAULT 0,
  `common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `colon` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
  `not_specified` tinyint(1) NULL DEFAULT 0,
  
  -- Procedure
  `procedure` varchar(50) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL,
  
  -- Tumor site
  `tumor_site` varchar(50) DEFAULT NULL,
  `tumor_site_specify` varchar(250) DEFAULT NULL,
  
  -- Tumor size
  -- 	See Master
  
  -- Macro Tumor Perfor
  `macroscopic_tumor_perforation` varchar(50) DEFAULT NULL,
  
  -- Histologic Type 
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
  
  -- Histologic Grade
  -- 	See Master 
  
  -- Microscopic Tumor Extendion
  `microscopic_tumor_extension` varchar(250) DEFAULT NULL,
  `microscopic_tumor_extension_specify` varchar(250) DEFAULT NULL,
  
  -- Margins
  `proximal_margin` varchar(100) DEFAULT NULL,
  `distal_margin` varchar(100) DEFAULT NULL,
  `radial_margin` varchar(100) DEFAULT NULL,
  `distance_of_invasive_carcinoma_from_closest_margin` decimal (3,1)NULL DEFAULT NULL,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin` varchar(250) DEFAULT NULL,
  `bile_duct_margin` varchar(50) DEFAULT NULL,
  `pancreatic_margin` varchar(50) DEFAULT NULL,
  `distance_of_invasive_carcinoma_from_closest_margin_bile_duct` decimal (3,1)NULL DEFAULT NULL,  -- it is for bile duct and pancreatic margin)
  `distance_unit_bile_duct` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin_bile_duct` varchar(250) DEFAULT NULL,
  
  -- Lymph Vascular Invasion
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  
  -- pTNM 
  --	See Master
  
  -- Additional Pathologic Findings
  `additional_path_none_identified` tinyint(1) NOT NULL DEFAULT 0,    
  `additional_path_adenoma` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_crohn` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_celiac` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_polyps` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_polyps_types` varchar(250) DEFAULT NULL,
  `additional_path_other` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  -- Ancillary Studies
  `microsatellite_instability` tinyint(1) NOT NULL DEFAULT 0, 
  `microsatellite_instability_testing_method` varchar(250) DEFAULT NULL,
  `microsatellite_instability_grade` varchar(10) DEFAULT NULL,
  `MLH1` tinyint(1) NOT NULL DEFAULT 0,  
  `MLH1_result` varchar(60) DEFAULT NULL,
  `MLH1_specify` varchar(250) DEFAULT NULL,  
  `MSH2` tinyint(1) NOT NULL DEFAULT 0,  
  `MSH2_result` varchar(60) DEFAULT NULL,
  `MSH2_specify` varchar(250) DEFAULT NULL,    
  `MSH6` tinyint(1) NOT NULL DEFAULT 0,  
  `MSH6_result` varchar(60) DEFAULT NULL,
  `MSH6_specify` varchar(250) DEFAULT NULL,  
  `PMS2` tinyint(1) NOT NULL DEFAULT 0,  
  `PMS2_result` varchar(60) DEFAULT NULL,
  `PMS2_specify` varchar(250) DEFAULT NULL,    
  `ancillary_other_specify` varchar(250) DEFAULT NULL,
  
  -- Clinical history
  `familial_adenomatous_polyposis_coli` tinyint(1) NOT NULL DEFAULT 0,
  `hereditary_nonpolyposis_colon_cancer`  tinyint(1) NOT NULL DEFAULT 0,
  `other_polyposis_syndrome`  tinyint(1) NOT NULL DEFAULT 0,
  `other_polyposis_syndrome_specify` varchar(250) DEFAULT NULL,  
  `crohn_disease` tinyint(1) NOT NULL DEFAULT 0,
  `celiac_disease` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
  `not_known` tinyint(1) NOT NULL DEFAULT 0,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `dxd_cap_report_smintestines` ADD CONSTRAINT `FK_dxd_cap_report_smintestines_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 


/*Table structure for table 'dxd_cap_report_smintestines_revs' */

DROP TABLE IF EXISTS `dxd_cap_report_smintestines_revs`;

CREATE TABLE `dxd_cap_report_smintestines_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
  
  -- Specimen
  `duodenum` tinyint(1) NULL DEFAULT 0,
  `small_intestine_other_than_duodenum` tinyint(1) NULL DEFAULT 0,
  `jejunum` tinyint(1) NULL DEFAULT 0,
  `ileum` tinyint(1) NULL DEFAULT 0,
  `stomach` tinyint(1) NULL DEFAULT 0,
  `head_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `ampulla` tinyint(1) NULL DEFAULT 0,
  `common_bile_duct` tinyint(1) NULL DEFAULT 0,
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `colon` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
  `not_specified` tinyint(1) NULL DEFAULT 0,
  
  -- Procedure
  `procedure` varchar(50) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL,
  
  -- Tumor site
  `tumor_site` varchar(50) DEFAULT NULL,
  `tumor_site_specify` varchar(250) DEFAULT NULL,
  
  -- Tumor size
  -- 	See Master
  
  -- Macro Tumor Perfor
  `macroscopic_tumor_perforation` varchar(50) DEFAULT NULL,
  
  -- Histologic Type 
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
  
  -- Histologic Grade
  -- 	See Master 
  
  -- Microscopic Tumor Extendion
  `microscopic_tumor_extension` varchar(250) DEFAULT NULL,
  `microscopic_tumor_extension_specify` varchar(250) DEFAULT NULL,
  
  -- Margins
  `proximal_margin` varchar(100) DEFAULT NULL,
  `distal_margin` varchar(100) DEFAULT NULL,
  `radial_margin` varchar(100) DEFAULT NULL,
  `distance_of_invasive_carcinoma_from_closest_margin` decimal (3,1)NULL DEFAULT NULL,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin` varchar(250) DEFAULT NULL,
  `bile_duct_margin` varchar(50) DEFAULT NULL,
  `pancreatic_margin` varchar(50) DEFAULT NULL,
  `distance_of_invasive_carcinoma_from_closest_margin_bile_duct` decimal (3,1)NULL DEFAULT NULL,  -- it is for bile duct and pancreatic margin)
  `distance_unit_bile_duct` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin_bile_duct` varchar(250) DEFAULT NULL,
  
  -- Lymph Vascular Invasion
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  
  -- pTNM 
  --	See Master
  
  -- Additional Pathologic Findings
  `additional_path_none_identified` tinyint(1) NOT NULL DEFAULT 0,    
  `additional_path_adenoma` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_crohn` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_celiac` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_polyps` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_polyps_types` varchar(250) DEFAULT NULL,
  `additional_path_other` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  -- Ancillary Studies
  `microsatellite_instability` tinyint(1) NOT NULL DEFAULT 0, 
  `microsatellite_instability_testing_method` varchar(250) DEFAULT NULL,
  `microsatellite_instability_grade` varchar(10) DEFAULT NULL,
  `MLH1` tinyint(1) NOT NULL DEFAULT 0,  
  `MLH1_result` varchar(60) DEFAULT NULL,
  `MLH1_specify` varchar(250) DEFAULT NULL,  
  `MSH2` tinyint(1) NOT NULL DEFAULT 0,  
  `MSH2_result` varchar(60) DEFAULT NULL,
  `MSH2_specify` varchar(250) DEFAULT NULL,    
  `MSH6` tinyint(1) NOT NULL DEFAULT 0,  
  `MSH6_result` varchar(60) DEFAULT NULL,
  `MSH6_specify` varchar(250) DEFAULT NULL,  
  `PMS2` tinyint(1) NOT NULL DEFAULT 0,  
  `PMS2_result` varchar(60) DEFAULT NULL,
  `PMS2_specify` varchar(250) DEFAULT NULL,    
  `ancillary_other_specify` varchar(250) DEFAULT NULL,
  
  -- Clinical history
  `familial_adenomatous_polyposis_coli` tinyint(1) NOT NULL DEFAULT 0,
  `hereditary_nonpolyposis_colon_cancer`  tinyint(1) NOT NULL DEFAULT 0,
  `other_polyposis_syndrome`  tinyint(1) NOT NULL DEFAULT 0,
  `other_polyposis_syndrome_specify` varchar(250) DEFAULT NULL,  
  `crohn_disease` tinyint(1) NOT NULL DEFAULT 0,
  `celiac_disease` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
  `not_known` tinyint(1) NOT NULL DEFAULT 0,
    
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- builder form smintestines


-- add table dxd_cap_report_smintestines and dxd_cap_report_smintestines_revs
-- Add table �dxd_cap_report_smintestines� in the DB. 
-- insert value in diagnosis_controls
insert into diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename)
values
('cap report - small intestine', 1, 'dx_cap_report_smintestines', 'dxd_cap_report_smintestines');

insert into i18n (id, en, fr) VALUES
('cap report - small intestine', 'Cap Report - Small Intestine', '');

-- use formbuilder to generate structures, structure_fields, structure_formats
-- to add a new structure - refresh the form builder
-- add the alias of the form into alias dx_cap_report_smintestines
-- click the table to add row, add all row the form needed
-- generate SQL, run the SQL.  DONE!

-- The table structures hold all forms in the application, Add the dxd_cap_report_smintestines in table structures. It doesn't hold the form itself but the form alias.

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_cap_report_smintestines', '', '', '0', '0', '1', '1');


-- add structure fields - tumor_site, histologic type, histologic grade, metastasis site, path_tstage, path_nstage, path_mstage for each site
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'duodenum', 'duodenum','','checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'small_intestine_other_than_duodenum','small intestine other than duodenum','', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'jejunum', '', 'jejunum','checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'ileum', '', 'ileum', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'stomach', 'stomach', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'head_of_pancreas', 'head of pancreas', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'ampulla', 'ampulla', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'common_bile_duct', 'common bile duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'gallbladder', 'gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'colon', 'colon', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'procedure', 'procedure', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'procedure_specify', 'procedure specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'tumor_site', 'tumor site', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'tumor_site_specify', 'tumor site specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumor_size_greatest_dimension', 'tumor size greatest dimension', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'additional_dimension_a', 'additional dimension a', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'additional_dimension_b', '', 'additional dimension b', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'macroscopic_tumor_perforation', 'macroscopic tumor perforation', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'histologic_type', 'histologic type', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_sm', 'tumour_grade', 'histologic grade', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumour_grade_specify', 'histologic grade specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'microscopic_tumor_extension', 'microscopic tumor extension', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'microscopic_tumor_extension_specify', 'microscopic tumor extension specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'proximal_margin', 'proximal margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'distal_margin', 'distal margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'radial_margin', 'radial margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'distance_of_invasive_carcinoma_from_closest_margin', 'distance of invasive carcinoma from closest margin', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'distance_unit', '', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'specify_margin', '', 'specify margin', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'bile_duct_margin', 'bile duct margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'pancreatic_margin', 'pancreatic margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'distance_of_invasive_carcinoma_from_closest_margin_bile_duct', 'distance of invasive carcinoma from closest margin bile duct', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'distance_unit_bile_duct', '', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'specify_margin_bile_duct', '', 'specify margin bile duct', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'lymph_vascular_invasion', 'lymph vascular invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_tnm_descriptor_m', 'tnm descriptors', 'multiple primary tumors', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_tnm_descriptor_r', '', 'recurrent', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_tnm_descriptor_y', '', 'post treatment', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_nstage_nbr_node_examined', 'number node examined', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_nstage_nbr_node_involved', 'number node involved', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_mstage_metastasis_site_specify', 'metastasis site specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'additional_path_none_identified', 'additional path none identified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'additional_path_adenoma', 'additional path adenoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'additional_path_crohn', 'additional path crohn', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'additional_path_celiac', 'additional path celiac', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'additional_path_other_polyps', 'additional path other polyps', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'additional_path_other_polyps_types', '', 'additional path other polyps types', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'additional_path_other', 'additional path other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'additional_path_other_specify', '', 'additional path other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'microsatellite_instability', 'microsatellite instability', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'microsatellite_instability_testing_method', 'microsatellite instability testing method', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'microsatellite_instability_grade', 'microsatellite instability grade', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'MLH1', 'MLH1', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'MLH1_result', 'MLH1 result', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'MLH1_specify', 'MLH1 specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'MSH2', 'MSH2', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'MSH2_result', 'MSH2 result', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'MSH2_specify', 'MSH2 specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'MSH6', 'MSH6', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'MSH6_result', 'MSH6 result', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'MSH6_specify', 'MSH6 specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'PMS2', 'PMS2', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'PMS2_result', 'PMS2 result', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'PMS2_specify', 'PMS2 specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'ancillary_other_specify', 'ancillary other specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'familial_adenomatous_polyposis_coli', 'familial adenomatous polyposis coli', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'hereditary_nonpolyposis_colon_cancer', 'hereditary nonpolyposis colon cancer', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'other_polyposis_syndrome', 'other polyposis syndrome', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'other_polyposis_syndrome_specify', '', 'other polyposis syndrome specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'crohn_disease', 'crohn disease', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'celiac_disease', 'celiac disease', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'other_clinical_history', 'other clinical history', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'other_clinical_history_specify', '', 'other clinical history specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_smintestines', 'not_known', 'not known', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_sm', 'path_tstage', 'path tstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_sm', 'path_nstage', 'path nstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_sm', 'path_mstage', 'path mstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
-- ((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `language_label`='dx_method' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=33  AND `language_help`='help_dx method'), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='duodenum' AND `language_label`='duodenum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='small_intestine_other_than_duodenum' AND `language_label`='small intestine other than duodenum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='jejunum' AND `language_label`='' AND `language_tag`='jejunum' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='ileum' AND `language_label`='' AND `language_tag`='ileum' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='stomach' AND `language_label`='stomach' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='head_of_pancreas' AND `language_label`='head of pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='ampulla' AND `language_label`='ampulla' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='common_bile_duct' AND `language_label`='common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='gallbladder' AND `language_label`='gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='colon' AND `language_label`='colon' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='procedure' AND `language_label`='procedure' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', 'procedure', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='procedure_specify' AND `language_label`='procedure specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='tumor_site' AND `language_label`='tumor site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='tumor_site_specify' AND `language_label`='tumor site specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension' AND `language_label`='tumor size greatest dimension' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a' AND `language_label`='additional dimension a' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `language_label`='' AND `language_tag`='additional dimension b' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cannot_be_determined'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='macroscopic_tumor_perforation' AND `language_label`='macroscopic tumor perforation' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '23', 'macroscopic tumor perforation', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='histologic_type' AND `language_label`='histologic type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '24', 'histologic type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='histologic_type_specify' AND `language_label`='histologic type specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_sm' AND `field`='tumour_grade' AND `language_label`='histologic grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '26', 'histologic grade', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade_specify' AND `language_label`='histologic grade specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='microscopic_tumor_extension' AND `language_label`='microscopic tumor extension' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '28', 'microscopic tumor extension', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='microscopic_tumor_extension_specify' AND `language_label`='microscopic tumor extension specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='proximal_margin' AND `language_label`='proximal margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='distal_margin' AND `language_label`='distal margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='radial_margin' AND `language_label`='radial margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='distance_of_invasive_carcinoma_from_closest_margin' AND `language_label`='distance of invasive carcinoma from closest margin' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='distance_unit' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='specify_margin' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='bile_duct_margin' AND `language_label`='bile duct margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='pancreatic_margin' AND `language_label`='pancreatic margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='distance_of_invasive_carcinoma_from_closest_margin_bile_duct' AND `language_label`='distance of invasive carcinoma from closest margin bile duct' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='distance_unit_bile_duct' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='specify_margin_bile_duct' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='lymph_vascular_invasion' AND `language_label`='lymph vascular invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '41', 'lymph vascular invasion', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_m' AND `language_label`='tnm descriptors' AND `language_tag`='multiple primary tumors' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_r' AND `language_label`='' AND `language_tag`='recurrent' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_y' AND `language_label`='' AND `language_tag`='post treatment' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_sm' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  ), '2', '4', '', '1', 'path tstage', '1', '', '0', '', '1', 'select', '1', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_sm' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  ), '2', '5', '', '1', 'path nstage', '1', '', '0', '', '1', 'select', '1', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_examined' AND `language_label`='number node examined' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_involved' AND `language_label`='number node involved' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_sm' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  ), '2', '8', '', '1', 'path mstage', '1', '', '0', '', '1', 'select', '1', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage_metastasis_site_specify' AND `language_label`='metastasis site specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='additional_path_none_identified' AND `language_label`='additional path none identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='additional_path_adenoma' AND `language_label`='additional path adenoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='additional_path_crohn' AND `language_label`='additional path crohn' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='additional_path_celiac' AND `language_label`='additional path celiac' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='additional_path_other_polyps' AND `language_label`='additional path other polyps' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='additional_path_other_polyps_types' AND `language_label`='' AND `language_tag`='additional path other polyps types' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='additional_path_other' AND `language_label`='additional path other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='additional_path_other_specify' AND `language_label`='' AND `language_tag`='additional path other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='microsatellite_instability' AND `language_label`='microsatellite instability' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='microsatellite_instability_testing_method' AND `language_label`='microsatellite instability testing method' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='microsatellite_instability_grade' AND `language_label`='microsatellite instability grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='MLH1' AND `language_label`='MLH1' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='MLH1_result' AND `language_label`='MLH1 result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='MLH1_specify' AND `language_label`='MLH1 specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='MSH2' AND `language_label`='MSH2' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='MSH2_result' AND `language_label`='MSH2 result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='MSH2_specify' AND `language_label`='MSH2 specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='MSH6' AND `language_label`='MSH6' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='MSH6_result' AND `language_label`='MSH6 result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='MSH6_specify' AND `language_label`='MSH6 specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='PMS2' AND `language_label`='PMS2' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='PMS2_result' AND `language_label`='PMS2 result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='PMS2_specify' AND `language_label`='PMS2 specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='ancillary_other_specify' AND `language_label`='ancillary other specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='familial_adenomatous_polyposis_coli' AND `language_label`='familial adenomatous polyposis coli' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='hereditary_nonpolyposis_colon_cancer' AND `language_label`='hereditary nonpolyposis colon cancer' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='other_polyposis_syndrome' AND `language_label`='other polyposis syndrome' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='other_polyposis_syndrome_specify' AND `language_label`='' AND `language_tag`='other polyposis syndrome specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='crohn_disease' AND `language_label`='crohn disease' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='celiac_disease' AND `language_label`='celiac disease' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='other_clinical_history' AND `language_label`='other clinical history' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='other_clinical_history_specify' AND `language_label`='' AND `language_tag`='other clinical history specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='not_known' AND `language_label`='not known' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes'), '2', '44', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='distance_unit' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='distance_unit_bile_duct' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='duodenum'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor site'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_site'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor size'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='margins'
where sfi.id=sfo.structure_field_id
and sfi.field='proximal_margin'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='pathologic staging (pTNM)'
where sfi.id=sfo.structure_field_id
and sfi.field='path_tnm_descriptor_m'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='additional pathologic findings'
where sfi.id=sfo.structure_field_id
and sfi.field='additional_path_none_identified'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='ancillary Studies'
where sfi.id=sfo.structure_field_id
and sfi.field='microsatellite_instability'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='clinical history'
where sfi.id=sfo.structure_field_id
and sfi.field='familial_adenomatous_polyposis_coli'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_smintestines'; 

update structure_fields
set structure_value_domain=185
where model like 'diagnosis%'
and type='checkbox';

INSERT IGNORE INTO i18n (id, en, fr)
VALUES
('duodenum', 'Duodenum', ''),
('small intestine other than duodenum', 'Small intestine, other than duodenum', ''),
('jejunum', 'Jejunum', ''),
('ileum', 'Ileum', ''),
('stomach', 'Stomach', ''),
('head of pancreas', 'Head of pancreas', ''),
('ampulla', 'Ampulla', ''),
('common bile duct', 'Common bile duct', ''),
('gallbladder', 'Gallbladder', ''),
('colon', 'Colon', ''),
('other specify', 'Specify', ''),
('not specified', 'Not specified', ''),
('procedure', 'Procedure', ''),
('procedure specify', 'Specify', ''),
('tumor site', 'Tumor Site', ''),
('tumor site specify', 'Specify', ''),
('tumor size', 'Tumor Size', ''),
('margins', 'Margins', ''),
('clinical history', 'Clinical History', ''),
('tumor size greatest dimension', 'Greatest Dimension (cm)', ''),
('additional dimension a', 'Additional Dimensions (cm)', ''),
('additional dimension b', 'x', ''),
('macroscopic tumor perforation', 'Macroscopic Tumor Perforation', ''),
('histologic type', 'Histologic Type', ''),
('histologic type specify', 'Specify', ''),
('histologic grade', 'Histologic Grade', ''),
('histologic grade specify', 'Specify', ''),
('additional path other polyps types', 'Types', ''),
('microscopic tumor extension', 'Microscopic Tumor Extension', ''),
('microscopic tumor extension specify', 'Specify', ''),
('proximal margin', 'Proximal Margin', ''),
('distal margin', 'Distal Margin', ''),
('radial margin', 'Radial Margin', ''),
('pathologic staging (pTNM)', 'pTNM', 'pTNM'),
('distance of invasive carcinoma from closest margin', 'Distance of invasive carcinoma from closest margin', ''),
('distance unit', 'Unit', ''),
('specify margin', 'Specify', ''),
('bile duct margin', 'Bile Duct Margin', ''),
('pancreatic margin', 'Pancreatic Margin', ''),
('distance of invasive carcinoma from closest margin bile duct', 'Distance of invasive carcinoma from closest margin bile duct', ''),
('distance unit bile duct', 'Unit', ''),
('specify margin bile duct', 'Specify', ''),
('lymph vascular invasion', 'Lymph-Vascular Invasion', ''),
('multiple primary tumors', 'm (multiple primary tumors)', ''),
('recurrent', 'r (recurrent)', ''),
('post treatment', 'y (post treatment)', ''),
('additional pathologic findings', 'Additional Pathologic Findings', ''),
('number node examined', 'Number Node Examined', ''),
('number node involved', 'Number Node Involved', ''),
('metastasis site specify', 'Specify Sites', ''),
('additional path none identified', 'None identified', ''),
('additional path adenoma', 'Adenoma(s)', ''),
('additional path crohn', 'Crohn''s disease', ''),
('additional path celiac', 'Celiac disease', ''),
('report date', 'Report Date', ''),
('microsatellite instability', 'Microsatellite Instability', ''),
('microsatellite instability testing method', 'Testing Method', ''),
('microsatellite instability grade', 'Grade', ''),
('MLH1', 'MLH1', ''),
('MLH1 result', 'MLH1 - Result', ''),
('MLH1 specify', 'MLH1 - Specify', ''),
('MSH2', 'MSH2', ''),
('MSH2 result', 'MSH2 - Result', ''),
('MSH2 specify', 'MSH2 - Specify', ''),
('MSH6', 'MSH6', ''),
('MSH6 result', 'MSH6 - Result', ''),
('MSH6 specify', 'MSH6 - Specify', ''),
('tnm descriptors', 'TNM Descriptors', ''),
('PMS2', 'PMS2', ''),
('ancillary Studies', 'Ancillary Studies', ''),
('additional path other polyps', 'Other Polyps', ''),
('additional path other specify', 'Specify', ''),
('additional path other', 'Other', ''),
('PMS2 result', 'PMS2 - Result', ''),
('PMS2 specify', 'PMS2 - Specify', ''),
('ancillary other specify', 'Other - Specify', ''),
('familial adenomatous polyposis coli', 'Familial Adenomatous Polyposis Coli', ''),
('hereditary nonpolyposis colon cancer', 'Hereditary Nonpolyposis Colon Cancer', ''),
('other polyposis syndrome', 'Other Polyposis Syndrome', ''),
('other polyposis syndrome specify', 'Specify', ''),
('crohn disease', 'Crohn''s Disease', ''),
('celiac disease', 'Celiac Disease', ''),
('other clinical history', 'Other clinical history', ''),
('other clinical history specify', 'Specify', ''),
('not known', 'Not known', ''),
('path tstage', 'pT', ''),
('path nstage', 'pN', ''),
('path mstage', 'pM', '');

-- --------------------------------------------

insert into structure_permissible_values (value, language_alias) values
('cannot be assessed', 'cannot be assessed'),
('segmental resection','segmental resection'),
('pancreaticoduodenectomy (whipple resection)', 'pancreaticoduodenectomy (whipple resection)'),
('not specified', 'not specified');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('procedure', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='procedure'), (select id from structure_permissible_values where value='segmental resection'), 1,1,'segmental resection'),
((select id from structure_value_domains where domain_name='procedure'), (select id from structure_permissible_values where value='pancreaticoduodenectomy (whipple resection)'), 2, 1,'pancreaticoduodenectomy (whipple resection)'),
((select id from structure_value_domains where domain_name='procedure'), (select id from structure_permissible_values where value='other'),3, 1, 'other'),
((select id from structure_value_domains where domain_name='procedure'), (select id from structure_permissible_values where value='not specified'), 4, 1, 'not specified');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='procedure')
where tablename='dxd_cap_report_smintestines' and field='procedure';


-- tumour_site_sm

insert into structure_permissible_values (value, language_alias) values
('duodenum','duodenum'),
('small intestine, other than duodenum', 'small intestine, other than duodenum'),
('ileum', 'ileum'),
('jejunum', 'jejunum');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('tumour_site_sm', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='duodenum'),1, 1,'duodenum'),
((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='small intestine, other than duodenum'), 2,1,'small intestine, other than duodenum'),
((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='jejunum'), 3,1, 'jejunum'),
((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='ileum'), 4, 1, 'ileum'),
((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='other'), 5, 1, 'other'),
((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='not specified'), 6, 1, 'not specified');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='tumour_site_sm')
where model='DiagnosisDetail' and field='tumor_site';

-- macroscopic_tumor_perforation
insert into structure_permissible_values (value, language_alias) values
('present','present'),
('not identified', 'not identified'),
('cannot be determined', 'cannot be determined');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('macroscopic_tumor_perforation', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='macroscopic_tumor_perforation'), (select id from structure_permissible_values where value='present'), 1,1,'present'),
((select id from structure_value_domains where domain_name='macroscopic_tumor_perforation'), (select id from structure_permissible_values where value='not identified'), 2,1,'not identified'),
((select id from structure_value_domains where domain_name='macroscopic_tumor_perforation'), (select id from structure_permissible_values where value='cannot be determined'), 3,1, 'cannot be determined');

select * from structure_fields
where tablename='dxd_cap_report_smintestines' and field='macroscopic_tumor_perforation';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='macroscopic_tumor_perforation')
where tablename='dxd_cap_report_smintestines' and field='macroscopic_tumor_perforation';

-- histologic_type_sm
insert into structure_permissible_values (value, language_alias) values
('adenocarcinoma (not otherwise characterized)','adenocarcinoma (not otherwise characterized)'),
('mucinous adenocarcinoma (greater than 50% mucinous)', 'mucinous adenocarcinoma (greater than 50% mucinous)'),
('signet-ring cell carcinoma (greater than 50% signet-ring cells)', 'signet-ring cell carcinoma (greater than 50% signet-ring cells)'),
('small cell carcinoma','small cell carcinoma'),
('squamous cell carcinoma','squamous cell carcinoma'),
('adenosquamous carcinoma','adenosquamous carcinoma'),
('medullary carcinoma','medullary carcinoma'),
('undifferentiated carcinoma','undifferentiated carcinoma'),
('mixed carcinoid-adenocarcinoma','mixed carcinoid-adenocarcinoma');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_type_sm', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='adenocarcinoma (not otherwise characterized)'), 1,1,'adenocarcinoma (not otherwise characterized)'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='mucinous adenocarcinoma (greater than 50% mucinous)'), 2,1,'mucinous adenocarcinoma (greater than 50% mucinous)'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='signet-ring cell carcinoma (greater than 50% signet-ring cells)'), 3,1, 'signet-ring cell carcinoma (greater than 50% signet-ring cells)'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='small cell carcinoma'), 4,1,'small cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='squamous cell carcinoma'), 5,1,'squamous cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='adenosquamous carcinoma'), 6,1, 'adenosquamous carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='medullary carcinoma'), 7,1,'medullary carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='undifferentiated carcinoma'), 8,1,'undifferentiated carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='mixed carcinoid-adenocarcinoma'), 9,1,'mixed carcinoid-adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='other'), 10,1, 'other');



select * from structure_fields
where model='DiagnosisDetail' and field='histologic_type';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_type_sm')
where  model='DiagnosisDetail' and field='histologic_type';


-- histologic grade
insert into structure_permissible_values (value, language_alias) values
('gx','gx: cannot be assessed'),
('g1','g1: well differentiated'),
('g2','g2: moderately differentiated'),
('g3','g3: poorly differentiated'),
('g4','g4: undifferentiated');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_grade', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_grade'), (select id from structure_permissible_values where value='not applicable'), 1,1,'not applicable'),
((select id from structure_value_domains where domain_name='histologic_grade'), (select id from structure_permissible_values where value='gx'), 2,1,'cannot be assessed'),
((select id from structure_value_domains where domain_name='histologic_grade'), (select id from structure_permissible_values where value='g1'), 3,1, 'well differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade'), (select id from structure_permissible_values where value='g2'), 4,1,'moderately differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade'), (select id from structure_permissible_values where value='g3'), 5,1,'poorly differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade'), (select id from structure_permissible_values where value='g4'), 6,1,'undifferentiated'),
((select id from structure_value_domains where domain_name='histologic_grade'), (select id from structure_permissible_values where value='other'), 7,1, 'other');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_grade')
where tablename='diagnosis_masters_sm' and field='tumour_grade';


-- microscopic tumor extension
insert into structure_permissible_values (value, language_alias) values
('no evidence of primary tumor', 'no evidence of primary tumor'),
('tumor invades lamina propria','tumor invades lamina propria'),
('tumor invades submucosa','tumor invades submucosa'),
('tumor invades muscularis propria','tumor invades muscularis propria'),
('tumor invades through the muscularis propria into the subserosal adipose tissue or the nonperitonealized peri-intestinal soft tissues but does not extend to the serosal surface','tumor invades through the muscularis propria into the subserosal adipose tissue or the nonperitonealized peri-intestinal soft tissues but does not extend to the serosal surface'),
('tumor microscopically involves the serosal surface (visceral peritoneum)','tumor microscopically involves the serosal surface (visceral peritoneum)'),
('tumor directly invades adjacent structures','tumor directly invades adjacent structures'),
('tumor penetrates to the surface of the visceral peritoneum (serosa) and directly invades adjacent structures','tumor penetrates to the surface of the visceral peritoneum (serosa) and directly invades adjacent structures');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('microscopic_tumor_extension', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='cannot be assessed'), 1,1,'cannot be assessed'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='no evidence of primary tumor'), 2,1,'no evidence of primary tumor'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='tumor invades lamina propria'), 3,1, 'tumor invades lamina propria'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='tumor invades submucosa'), 4,1,'tumor invades submucosa'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='tumor invades muscularis propria'), 5,1,'tumor invades muscularis propria'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='tumor invades through the muscularis propria into the subserosal adipose tissue or the nonperitonealized peri-intestinal soft tissues but does not extend to the serosal surface'), 6,1,'tumor invades through the muscularis propria into the subserosal adipose tissue or the nonperitonealized peri-intestinal soft tissues but does not extend to the serosal surface'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='tumor microscopically involves the serosal surface (visceral peritoneum)'), 7,1, 'tumor microscopically involves the serosal surface (visceral peritoneum)'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='tumor directly invades adjacent structures'), 7,1, 'tumor directly invades adjacent structures'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='tumor penetrates to the surface of the visceral peritoneum (serosa) and directly invades adjacent structures'), 7,1, 'tumor penetrates to the surface of the visceral peritoneum (serosa) and directly invades adjacent structures');

select id from structure_value_domains where domain_name='microscopic_tumor_extension';

select * from structure_fields
where tablename='dxd_cap_report_smintestines' and field='microscopic_tumor_extension';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='microscopic_tumor_extension')
where tablename='dxd_cap_report_smintestines' and field='microscopic_tumor_extension';

-- proximal margin

insert into structure_permissible_values (value, language_alias) values
('uninvolved by invasive carcinoma', 'uninvolved by invasive carcinoma'),
('involved by invasive carcinoma','involved by invasive carcinoma'),
('intramucosal carcinoma/adenoma not identified at proximal margin','intramucosal carcinoma/adenoma not identified at proximal margin'),
('intramucosal carcinoma/adenoma present at proximal margin','intramucosal carcinoma/adenoma present at proximal margin');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('proximal_margin', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='proximal_margin'), (select id from structure_permissible_values where value='cannot be assessed'), 1,1,'cannot be assessed'),
((select id from structure_value_domains where domain_name='proximal_margin'), (select id from structure_permissible_values where value='uninvolved by invasive carcinoma'), 2,1,'uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='proximal_margin'), (select id from structure_permissible_values where value='involved by invasive carcinoma'), 3,1, 'involved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='proximal_margin'), (select id from structure_permissible_values where value='intramucosal carcinoma/adenoma not identified at proximal margin'), 4,1,'intramucosal carcinoma/adenoma not identified at proximal margin'),
((select id from structure_value_domains where domain_name='proximal_margin'), (select id from structure_permissible_values where value='intramucosal carcinoma/adenoma present at proximal margin'), 7,1, 'intramucosal carcinoma/adenoma present at proximal margin');

select id from structure_value_domains where domain_name='proximal_margin';

select * from structure_fields
where tablename='dxd_cap_report_smintestines' and field='proximal_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='proximal_margin')
where tablename='dxd_cap_report_smintestines' and field='proximal_margin';

-- distal margin
insert into structure_permissible_values (value, language_alias) values
('intramucosal carcinoma/adenoma not identified at distal margin', 'intramucosal carcinoma/adenoma not identified at distal margin'),
('intramucosal carcinoma /adenoma present at distal margin', 'intramucosal carcinoma /adenoma present at distal margin');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('distal_margin', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='distal_margin'), (select id from structure_permissible_values where value='cannot be assessed'), 1,1,'cannot be assessed'),
((select id from structure_value_domains where domain_name='distal_margin'), (select id from structure_permissible_values where value='uninvolved by invasive carcinoma'), 2,1,'uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='distal_margin'), (select id from structure_permissible_values where value='involved by invasive carcinoma'), 3,1, 'involved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='distal_margin'), (select id from structure_permissible_values where value='intramucosal carcinoma/adenoma not identified at distal margin'), 4,1,'intramucosal carcinoma/adenoma not identified at distal margin'),
((select id from structure_value_domains where domain_name='distal_margin'), (select id from structure_permissible_values where value='intramucosal carcinoma /adenoma present at distal margin'), 7,1, 'intramucosal carcinoma /adenoma present at distal margin');

select id from structure_value_domains where domain_name='distal_margin';

select * from structure_fields
where tablename='dxd_cap_report_smintestines' and field='distal_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distal_margin')
where tablename='dxd_cap_report_smintestines' and field='distal_margin';


-- circumferential (radial) or mesenteric margin
insert into structure_permissible_values (value, language_alias) values
('involved by invasive carcinoma (tumor present 0-1 mm from margin)', 'involved by invasive carcinoma (tumor present 0-1 mm from margin)');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('radial_margin', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='radial_margin'), (select id from structure_permissible_values where value='not applicable'), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='radial_margin'), (select id from structure_permissible_values where value='cannot be assessed'), 2,1,'cannot be assessed'),
((select id from structure_value_domains where domain_name='radial_margin'), (select id from structure_permissible_values where value='uninvolved by invasive carcinoma'), 3,1,'uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='radial_margin'), (select id from structure_permissible_values where value='involved by invasive carcinoma (tumor present 0-1 mm from margin)'), 4,1, 'involved by invasive carcinoma (tumor present 0-1 mm from margin)');

select id from structure_value_domains where domain_name='radial_margin';

select * from structure_fields
where tablename='dxd_cap_report_smintestines' and field='radial_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='radial_margin')
where tablename='dxd_cap_report_smintestines' and field='radial_margin';

-- distance unit
insert into structure_permissible_values (value, language_alias) values
('mm', 'mm');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('distance_unit', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='distance_unit'), (select id from structure_permissible_values where value='mm'), 1,1, 'mm'),
((select id from structure_value_domains where domain_name='distance_unit'), (select id from structure_permissible_values where value='cm'), 2,1, 'cm');

select id from structure_value_domains where domain_name='distance_unit';

select * from structure_fields
where tablename='dxd_cap_report_smintestines' and field='distance_unit';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distance_unit')
where tablename='dxd_cap_report_smintestines' and field='distance_unit';

-- margin
insert into structure_permissible_values (value, language_alias) values
('margin uninvolved by invasive carcinoma', 'margin uninvolved by invasive carcinoma'),
('margin involved by invasive carcinoma', 'margin involved by invasive carcinoma');

-- bile duct margin
-- ___ not applicable
-- ___ cannot be assessed
-- ___ margin uninvolved by invasive carcinoma
-- ___ margin involved by invasive carcinoma

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('margin', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='margin'), (select id from structure_permissible_values where value='not applicable'), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='margin'), (select id from structure_permissible_values where value='cannot be assessed'), 2,1, 'cannot be assessed'),
((select id from structure_value_domains where domain_name='margin'), (select id from structure_permissible_values where value='margin uninvolved by invasive carcinoma'), 3,1, 'margin uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='margin'), (select id from structure_permissible_values where value='margin involved by invasive carcinoma'), 4,1, 'margin involved by invasive carcinoma');

select id from structure_value_domains where domain_name='margin';

select * from structure_fields
where tablename='dxd_cap_report_smintestines' and field='bile_duct_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin')
where tablename='dxd_cap_report_smintestines' and field='bile_duct_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin')
where tablename='dxd_cap_report_smintestines' and field='pancreatic_margin';

-- distance unit bile duct
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distance_unit')
where tablename='dxd_cap_report_smintestines' and field='distance_unit_bile_duct';

-- lymph-vascular invasion

insert into structure_permissible_values (value, language_alias) values
('indeterminate', 'indeterminate');

-- ___ not identified
-- ___ present
-- ___ indeterminate


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('lymph_vascular_invasion', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='lymph_vascular_invasion'), (select id from structure_permissible_values where value='not identified'), 1,1, 'not identified'),
((select id from structure_value_domains where domain_name='lymph_vascular_invasion'), (select id from structure_permissible_values where value='present'), 2,1, 'present'),
((select id from structure_value_domains where domain_name='lymph_vascular_invasion'), (select id from structure_permissible_values where value='indeterminate'), 3,1, 'indeterminate');

select id from structure_value_domains where domain_name='lymph_vascular_invasion';

select * from structure_fields
where tablename='dxd_cap_report_smintestines' and field='lymph_vascular_invasion';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_smintestines' and field='lymph_vascular_invasion';


-- primary tumor (pt)
insert into structure_permissible_values (value, language_alias) values
('ptx', 'ptx: cannot be assessed'),
('pt0', 'pt0: no evidence of primary tumor'),
('ptis', 'ptis: carcinoma in situ'),
('pt1a', 'pt1a: tumor invades lamina propria'),
('pt1b', 'pt1b: tumor invades submucosa'),
('pt2', 'pt2: tumor invades muscularis propria'),
('pt3', 'pt3: tumor invades through the muscularis propria into the subserosa or into the nonperitonealized perimuscular tissue (mesentery or retroperitoneum) with extension 2 cm or less'),
('pt4a', 'pt4a: tumor penetrates the visceral peritoneum'),
('pt4b', 'pt4b: tumor directly invades other organs or structures');



insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_tstage_sm', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='ptx'), 1,1, 'ptx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt0'), 2,1, 'pt0: no evidence of primary tumor'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='ptis'), 3,1, 'ptis: carcinoma in situ'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt1a'), 4,1, 'pt1a: tumor invades lamina propria'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt1b'), 5,1, 'pt1b: tumor invades submucosa'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt2'), 6,1, 'pt2: tumor invades muscularis propria'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt3'), 7,1, 'pt3: tumor invades through the muscularis propria into the subserosa or into the nonperitonealized perimuscular tissue (mesentery or retroperitoneum) with extension 2 cm or less'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt4a'), 8,1, 'pt4a: tumor penetrates the visceral peritoneum'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt4b'), 9,1, 'pt4b:tumor directly invades other organs or structures');

select id from structure_value_domains where domain_name='path_tstage_sm';

select * from structure_fields
where tablename='diagnosis_masters_sm' and field='path_tstage';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_tstage_sm')
where tablename='diagnosis_masters_sm' and field='path_tstage';


-- regional lymph nodes (pn)
insert into structure_permissible_values (value, language_alias) values
('pnx', 'pnx: cannot be assessed'),
('pn0', 'pn0: no regional lymph node metastasis'),
('pn1', 'pn1: metastasis in 1 to 3 regional lymph nodes'),
('pn2', 'pn2: metastasis in 4 or more regional lymph nodes');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_nstage_sm', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_nstage_sm'), (select id from structure_permissible_values where value='pnx'), 1,1, 'cannot be assessed'),
((select id from structure_value_domains where domain_name='path_nstage_sm'), (select id from structure_permissible_values where value='pn0'), 2,1, 'no regional lymph node metastasis'),
((select id from structure_value_domains where domain_name='path_nstage_sm'), (select id from structure_permissible_values where value='pn1'), 3,1, 'metastasis in 1 to 3 regional lymph nodes'),
((select id from structure_value_domains where domain_name='path_nstage_sm'), (select id from structure_permissible_values where value='pn2'), 4,1, 'metastasis in 4 or more regional lymph nodes');

select * from structure_fields
where tablename='diagnosis_masters_sm' and field='path_nstage';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_nstage_sm')
where tablename='diagnosis_masters_sm' and field='path_nstage';


-- distant metastasis (pm)
insert into structure_permissible_values (value, language_alias) values
('pm1', 'pm1: distant metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_mstage_sm', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_mstage_sm'), (select id from structure_permissible_values where value='not applicable'), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='path_mstage_sm'), (select id from structure_permissible_values where value='pm1'), 4,1, 'distant metastasis');

select * from structure_fields
where tablename='diagnosis_masters_sm' and field='path_mstage';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_mstage_sm')
where tablename='diagnosis_masters_sm' and field='path_mstage';


-- microsatellite instability grade
insert into structure_permissible_values (value, language_alias) values
('stable', 'stable'),
('low','low'),
('high','high');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('microsatellite_instability_grade', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='microsatellite_instability_grade'), (select id from structure_permissible_values where value='stable'), 1,1, 'stable'),
((select id from structure_value_domains where domain_name='microsatellite_instability_grade'), (select id from structure_permissible_values where value='low'), 2,1, 'low'),
((select id from structure_value_domains where domain_name='microsatellite_instability_grade'), (select id from structure_permissible_values where value='high'), 3,1, 'high');

select * from structure_fields
where tablename='dxd_cap_report_smintestines' and field='microsatellite_instability_grade';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='microsatellite_instability_grade')
where tablename='dxd_cap_report_smintestines' and field='microsatellite_instability_grade';

-- immunohistochemistry_sm
insert into structure_permissible_values (value, language_alias) values
('immunoreactive tumor cells present (nuclear positivity)', 'immunoreactive tumor cells present (nuclear positivity)'),
('no immunoreactive tumor cells present','no immunoreactive tumor cells present');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('immunohistochemistry_sm', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='immunohistochemistry_sm'), (select id from structure_permissible_values where value='immunoreactive tumor cells present (nuclear positivity)'), 1,1, 'immunoreactive tumor cells present (nuclear positivity)'),
((select id from structure_value_domains where domain_name='immunohistochemistry_sm'), (select id from structure_permissible_values where value='no immunoreactive tumor cells present'), 2,1, 'no immunoreactive tumor cells present'),
((select id from structure_value_domains where domain_name='immunohistochemistry_sm'), (select id from structure_permissible_values where value='pending'), 3,1, 'pending'),
((select id from structure_value_domains where domain_name='immunohistochemistry_sm'), (select id from structure_permissible_values where value='other'), 4,1, 'other');

select * from structure_fields
where tablename='dxd_cap_report_smintestines' and field='mlh1_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_cap_report_smintestines' and field='mlh1_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_cap_report_smintestines' and field='msh2_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_cap_report_smintestines' and field='msh6_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_cap_report_smintestines' and field='pms2_result';

INSERT IGNORE INTO i18n (id, en, fr) VALUES 
('segmental resection', 'Segmental resection', ''),
('pancreaticoduodenectomy (whipple resection)', 'Pancreaticoduodenectomy (whipple resection)', ''),
('not specified', 'Not Specified', ''),
('duodenum', 'Duodenum', ''),
('small intestine, other than duodenum', 'Small intestine, other than duodenum', ''),
('jejunum', 'Jejunum', ''),
('present', 'Present ', ''),
('not identified', 'Not identified', ''),
('cannot be determined', 'Cannot be determined ', ''),
('adenocarcinoma (not otherwise characterized)', 'Adenocarcinoma (not otherwise characterized)', ''),
('mucinous adenocarcinoma (greater than 50% mucinous)', 'Mucinous adenocarcinoma (greater than 50% mucinous)', ''),
('signet-ring cell carcinoma (greater than 50% signet-ring cells)', 'Signet-ring cell carcinoma (greater than 50% signet ring cells)', ''),
('small cell carcinoma', 'Small cell carcinoma', ''),
('squamous cell carcinoma', 'Squamous cell carcinoma', ''),
('adenosquamous carcinoma', 'Adenosquamous carcinoma', ''),
('medullary carcinoma', 'Medullary carcinoma', ''),
('undifferentiated carcinoma', 'Undifferentiated carcinoma', ''),
('mixed carcinoid-adenocarcinoma', 'Mixed carcinoid-adenocarcinoma', ''),
('gx: cannot be assessed', 'GX: Cannot be assessed', ''),
('g1: well differentiated', 'G1: Well differentiated', ''),
('g2: moderately differentiated', 'G2: Moderately differentiated', ''),
('g3: poorly differentiated', 'G3: Poorly differentiated', ''),
('g4: undifferentiated', 'G4: Undifferentiated', ''),
('no evidence of primary tumor', 'No evidence of primary tumor', ''),
('tumor invades lamina propria', 'Tumor invades lamina propria', ''),
('tumor invades submucosa', 'Tumor invades submucosa', ''),
('tumor invades muscularis propria', 'Tumor invades muscularis propria', ''),
('tumor invades through the muscularis propria into the subserosal adipose tissue or the nonperitonealized peri-intestinal soft tissues but does not extend to the serosal surface', 'Tumor invades through the muscularis propria into the subserosal adipose tissue or the nonperitonealized peri-intetinal soft tissues but does not extend to the serosal surface', ''),
('tumor microscopically involves the serosal surface (visceral peritoneum)', 'Tumor microscopically involves the serosal surface (visceral peritoneum)', ''),
('tumor directly invades adjacent structures', 'Tumor directly invades adjacent structures', ''),
('tumor penetrates to the surface of the visceral peritoneum (serosa) and directly invades adjacent structures', 'Tumor penetrates to the surface of the visceral peritoneum (serosa) AND directly invades adjacent structures', ''),
('uninvolved by invasive carcinoma', 'Uninvolved by invasive carcinoma', ''),
('involved by invasive carcinoma', 'Involved by invasive carcinoma', ''),
('intramucosal carcinoma/adenoma not identified at proximal margin', 'Intramucosal carcinoma/adenoma not identified at proximal margin', ''),
('intramucosal carcinoma/adenoma present at proximal margin', 'Intramucosal carcinoma/adenoma present at proximal margin', ''),
('intramucosal carcinoma/adenoma not identified at distal margin', 'Intramucosal carcinoma/adenoma not identified at distal margin', ''),
('intramucosal carcinoma /adenoma present at distal margin', 'Intramucosal carcinoma/adenoma present at distal margin', ''),
('involved by invasive carcinoma (tumor present 0-1 mm from margin)', 'Involved by invasive carcinoma (tumor present 0-1 mm from margin)', ''),
('mm', 'mm', ''),
('margin uninvolved by invasive carcinoma', 'Margin uninvolved by invasive carcinoma', ''),
('margin involved by invasive carcinoma', 'Margin involved by invasive carcinoma', ''),
('indeterminate', 'Indeterminate', ''),
('ptx: cannot be assessed', 'pTX: Cannot be assessed', ''),
('pt0: no evidence of primary tumor', 'pT0: No evidence of primary tumor', ''),
('ptis: carcinoma in situ', 'pTis: Carcinoma in situ', ''),
('pt1a: tumor invades lamina propria', 'pT1a: Tumor invades lamina propria', ''),
('pt1b: tumor invades submucosa', 'pT1b: Tumor invades submucosa', ''),
('pt2: tumor invades muscularis propria', 'pT2: Tumor invades muscularis propria', ''),
('pt3: tumor invades through the muscularis propria into the subserosa or into the nonperitonealized perimuscular tissue (mesentery or retroperitoneum) with extension 2 cm or less', 'pT3: Tumor invades through the muscularis propria into the subserosa or into the nonperitonealized perimuscular tissue (mesentery or retroperitoneum) with extension 2 cm or less', ''),
('pt4a: tumor penetrates the visceral peritoneum', 'pT4a: Tumor penetrates the visceral peritoneum', ''),
('pt4b: tumor directly invades other organs or structures', 'pT4b: Tumor directly invades other organs or structures', ''),
('pnx: cannot be assessed', 'pNX: Cannot be assessed', ''),
('pn0: no regional lymph node metastasis', 'pN0: No regional lymph node metastasis', ''),
('pn1: metastasis in 1 to 3 regional lymph nodes', 'pN1: Metastasis in 1 to 3 regional lymph nodes', ''),
('pn2: metastasis in 4 or more regional lymph nodes', 'pN2: Metastasis in 4 or more regional lymph nodes', ''),
('pm1: distant metastasis', 'pM1: Distant metastasis', ''),
('stable', 'Stable', ''),
('low', 'Low', ''),
('high', 'High', ''),
('cannot be assessed', 'Cannot be assessed', ''),
('immunoreactive tumor cells present (nuclear positivity)', 'Immunoreactive tumor cells present (nuclear positivity)', ''),
('no immunoreactive tumor cells present', 'No immunoreactive tumor cells present', '');

-- UPDATE structure_formats
-- SET display_column = '1'
-- WHERE structure_id = (SELECT id FROM structures WHERE alias='dx_cap_report_smintestines');

-- update structures
-- set flag_add_columns = 0, flag_edit_columns =0
-- where alias = 'dx_cap_report_smintestines';

UPDATE structures AS str, structure_formats AS stfo, structure_fields AS sf 
SET stfo.flag_index = '0'
WHERE str.alias = 'dx_cap_report_smintestines'
AND str.id = stfo.structure_id 
AND stfo.structure_field_id = sf.id
AND sf.field NOT IN ('dx_date', 'tumor_site', 'tumour_grade', 'histologic_type');




