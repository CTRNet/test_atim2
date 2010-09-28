
--  ------------------------------------------------------------------------------------------------------- -- 
--       CAP REPORT - VERSION : October 2009                                                                -- 
--          'Cancer Protocols and Checklists' from the College of American Pathologists                     -- 
--  ------------------------------------------------------------------------------------------------------- -- 
--                                                                                                          --   
--  SOURCE                                                                                                  --  
--    . http://www.cap.org/apps/cap.portal                                                                  --                                                            --  
--                                                                                                          -- 
--  IMPLEMENTED REPORT                                                                                      -- 
--   # Breast                                                                                               -- 
--   # Central Nervous System                                                                               -- 
--   # Gastrointestinal                                                                                     -- 
--       - Ampulla of Vater [version: October 2009, source: Ampulla_09protocol.pdf]                         -- 
--       - Colon and Rectum [version: October 2009, source: Colon_09protocol.pdf]                           -- 
--       - Distal Extrahepatic Bile Ducts [version: October 2009, source: DistalExBileDucts_09protocol.pdf] -- 
--       - Gallbladder [version: October 2009, source: Gallbladder_09protocol.pdf]                          -- 
--       - Hepatocellular Carcinoma [version: October 2009, source: Hepatocellular_09protocol.pdf]          -- 
--       - Intrahepatic Bile Ducts [version: October 2009, source: IntrahepBileDucts_09protocol.pdf]        -- 
--       - Pancreas (Endocrine) [version: October 2009, source: PancreasEndo_09protocol.pdf]                -- 
--       - Pancreas (Exocrine) [version: October 2009, source: PancreasExo_09protocol.pdf]                  -- 
--       - Perihilar Bile Ducts [version: October 2009, source: PerihilarBileDucts_09protocol.pdf]          -- 
--       - Small Intestine [version: October 2009, source: SmIntestine_09protocol.pdf]                      -- 
--   # Genitourinary                                                                                        -- 
--   # Gynecologic                                                                                          -- 
--   # Head and Neck                                                                                        -- 
--   # Hematologic                                                                                          -- 
--   # Ophthalmic                                                                                           -- 
--   # Pediatric                                                                                            -- 
--   # Skin                                                                                                 -- 
--   # Thorax                                                                                               -- 
--   # Other                                                                                                -- 
--  ------------------------------------------------------------------------------------------------------- -- 

-- alter table diagnosis_masters
alter table diagnosis_masters

 -- path_mstage to varchar(15) to hold not applicable
 modify column path_mstage varchar(15) DEFAULT NULL,
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
-- Add table ?dxd_cap_report_smintestines? in the DB. 
-- insert value in diagnosis_controls
insert into diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename)
values
('CAP Report - Small Intestine', 1, 'dx_cap_report_smintestines', 'dxd_cap_report_smintestines');

insert ignore into i18n (id, en, fr) VALUES
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
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'additional_dimension_a', 'additional dimension', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'additional_dimension_b', '', 'x', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
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
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a' AND `language_label`='additional dimension' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `language_label`='' AND `language_tag`='x' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
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

-- update checkbox structure value domain to 185
update structure_fields
set structure_value_domain=185
where type='checkbox'
and structure_value_domain is null;

-- unit validation
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='distance_unit' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_smintestines' AND `field`='distance_unit_bile_duct' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

-- add heading
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
set sfo.language_heading='ancillary studies'
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
('ancillary studies', 'Ancillary Studies', ''),
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

-- -------------------------------------------- drop down list

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
('CAP Report - Perihilar Bile Duct', 1, 'dx_cap_report_perihilarbileducts', 'dxd_cap_report_perihilarbileducts');

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
('choledochal cyst resection','choledochal cyst resection'),
('total hepatectomy','total hepatectomy');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('procedure_dxd_pbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='procedure_dxd_pbd'), (select id from structure_permissible_values where value='hilar and hepatic resection'), 1,1, 'hilar and hepatic resection'),
((select id from structure_value_domains where domain_name='procedure_dxd_pbd'), (select id from structure_permissible_values where value='segmental resection of bile ducts(s)'), 2,1, 'segmental resection of bile ducts(s)'),
((select id from structure_value_domains where domain_name='procedure_dxd_pbd'), (select id from structure_permissible_values where value='choledochal cyst resection'), 3,1, 'choledochal cyst resection'),
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
('CAP Report - Pancreas Exo', 1, 'dx_cap_report_pancreasexos', 'dxd_cap_report_pancreasexos');

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
('CAP Report - Pancreas Endo', 1, 'dx_cap_report_pancreasendos', 'dxd_cap_report_pancreasendos');

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
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_pancreasendos', 'other_clinical_history', 'other', '', 'checkbox', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
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
((SELECT id FROM structures WHERE alias='dx_cap_report_pancreasendos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_pancreasendos' AND `field`='other_clinical_history' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '2', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
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
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
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
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
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
('CAP Report - Intrahep Bile Duct', 1, 'dx_cap_report_intrahepbileducts', 'dxd_cap_report_intrahepbileducts');

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
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_ibd', 'tumour_grade', 'histologic grade', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
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
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade_specify' AND `structure_value_domain`  IS NULL  ), '1', '26', '', '1', 'histologic grade specify', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
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
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_ibd' AND `field`='tumour_grade' AND `language_label`='histologic grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `structure_value_domain`  IS NULL  ), '1', '17', '', '0', '', '1', 'x', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='specify_type' AND `language_label`='' AND `language_tag`='specify type' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '66', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='cli_primary_sclerosing_cholangitis' AND `language_label`='primary sclerosing cholangitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='other_clinical_history' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_intrahepbileducts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_intrahepbileducts' AND `field`='other_clinical_history_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');




-- update checkbox structure value domain to 185
update structure_fields
set structure_value_domain=185
where type='checkbox'
and structure_value_domain is null;

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

-- dxd_cap_report_hepatocellulars
/*Table structure for table 'dxd_cap_report_hepatocellulars' */

DROP TABLE IF EXISTS `dxd_cap_report_hepatocellulars`;

CREATE TABLE IF NOT EXISTS `dxd_cap_report_hepatocellulars` (
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

-- Microscopic Tumor Extension
  `tumor_confined_to_liver` tinyint(1) NULL DEFAULT 0, 
  `tumor_involves_a_major_branch_of_the_portal_vein` tinyint(1) NULL DEFAULT 0,    
  `tumor_involves_1_or_more_hepatic_veins` tinyint(1) NULL DEFAULT 0,    
  `tumor_involves_visceral_peritoneum` tinyint(1) NULL DEFAULT 0,    
  `tumor_directly_invades_gallbladder` tinyint(1) NULL DEFAULT 0,    
  `tumor_directly_invades_other_adjacent_organs` tinyint(1) NULL DEFAULT 0,    
  `other_adjacent_organs_specify` varchar(250) DEFAULT NULL,  
-- Margins  
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
  `p_specify_margin` varchar(250) DEFAULT NULL,
  `involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
 
  `specify_margin` varchar(250) DEFAULT NULL, 
  `special_margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `special_margin_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,   
  `special_margin_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,    

-- Lymph-Vascular Invasion  
  `lymph_vascular_large_vessel_invasion` varchar(50) DEFAULT NULL,
  `lymph_vascular_small_vessel_invasion` varchar(50) DEFAULT NULL,  
  `perineural_invasion` varchar(50) DEFAULT NULL,

-- Pathologic Staging (pTNM) in masters

--  Additional Pathologic Findings 
  `cirrhosis_severe_fibrosis` tinyint(1) NOT NULL DEFAULT 0,    
  `none_to_moderate_fibrosis` tinyint(1) NOT NULL DEFAULT 0, 
  `hepatocellular_dysplasia` tinyint(1) NOT NULL DEFAULT 0, 
  `low_grade_dysplastic_nodule` tinyint(1) NOT NULL DEFAULT 0, 
  `high_grade_dysplastic_nodule` tinyint(1) NOT NULL DEFAULT 0, 
  `steatosis` tinyint(1) NOT NULL DEFAULT 0, 
  `iron_overload` tinyint(1) NOT NULL DEFAULT 0, 
  `chronic_hepatitis` tinyint(1) NOT NULL DEFAULT 0, 
  `specify_etiology` varchar(250) DEFAULT NULL,  
  `additional_path_other` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  `none_identified` tinyint(1) NOT NULL DEFAULT 0, 
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
-- clinical history  
  `cirrhosis`  tinyint(1) NOT NULL DEFAULT 0,
  `hepatitis_c_infection` tinyint(1) NOT NULL DEFAULT 0,
  `hepatitis_b_infection` tinyint(1) NOT NULL DEFAULT 0,
  `alcoholic_liver_disease` tinyint(1) NOT NULL DEFAULT 0,  
  `obesity` tinyint(1) NOT NULL DEFAULT 0, 
  `hereditary_hemochromatosis` tinyint(1) NOT NULL DEFAULT 0, 
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

ALTER TABLE `dxd_cap_report_hepatocellulars` ADD CONSTRAINT `FK_dxd_cap_report_hepatocellulars_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 


/*Table structure for table 'dxd_cap_report_hepatocellulars_revs' */

DROP TABLE IF EXISTS `dxd_cap_report_hepatocellulars_revs`;

CREATE TABLE `dxd_cap_report_hepatocellulars_revs` (
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

-- Microscopic Tumor Extension
  `tumor_confined_to_liver` tinyint(1) NULL DEFAULT 0, 
  `tumor_involves_a_major_branch_of_the_portal_vein` tinyint(1) NULL DEFAULT 0,    
  `tumor_involves_1_or_more_hepatic_veins` tinyint(1) NULL DEFAULT 0,    
  `tumor_involves_visceral_peritoneum` tinyint(1) NULL DEFAULT 0,    
  `tumor_directly_invades_gallbladder` tinyint(1) NULL DEFAULT 0,    
  `tumor_directly_invades_other_adjacent_organs` tinyint(1) NULL DEFAULT 0,    
  `other_adjacent_organs_specify` varchar(250) DEFAULT NULL,  
-- Margins  
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
  `p_specify_margin` varchar(250) DEFAULT NULL,
  `involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
 
  `specify_margin` varchar(250) DEFAULT NULL, 
  `special_margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `special_margin_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,   
  `special_margin_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,    

-- Lymph-Vascular Invasion  
  `lymph_vascular_large_vessel_invasion` varchar(50) DEFAULT NULL,
  `lymph_vascular_small_vessel_invasion` varchar(50) DEFAULT NULL,  
  `perineural_invasion` varchar(50) DEFAULT NULL,

-- Pathologic Staging (pTNM) in masters

--  Additional Pathologic Findings 
  `cirrhosis_severe_fibrosis` tinyint(1) NOT NULL DEFAULT 0,    
  `none_to_moderate_fibrosis` tinyint(1) NOT NULL DEFAULT 0, 
  `hepatocellular_dysplasia` tinyint(1) NOT NULL DEFAULT 0, 
  `low_grade_dysplastic_nodule` tinyint(1) NOT NULL DEFAULT 0, 
  `high_grade_dysplastic_nodule` tinyint(1) NOT NULL DEFAULT 0, 
  `steatosis` tinyint(1) NOT NULL DEFAULT 0, 
  `iron_overload` tinyint(1) NOT NULL DEFAULT 0, 
  `chronic_hepatitis` tinyint(1) NOT NULL DEFAULT 0, 
  `specify_etiology` varchar(250) DEFAULT NULL,  
  `additional_path_other` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  `none_identified` tinyint(1) NOT NULL DEFAULT 0, 
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
-- clinical history  
  `cirrhosis`  tinyint(1) NOT NULL DEFAULT 0,
  `hepatitis_c_infection` tinyint(1) NOT NULL DEFAULT 0,
  `hepatitis_b_infection` tinyint(1) NOT NULL DEFAULT 0,
  `alcoholic_liver_disease` tinyint(1) NOT NULL DEFAULT 0,  
  `obesity` tinyint(1) NOT NULL DEFAULT 0, 
  `hereditary_hemochromatosis` tinyint(1) NOT NULL DEFAULT 0, 
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
('CAP Report - Hepato Cellular', 1, 'dx_cap_report_hepatocellulars', 'dxd_cap_report_hepatocellulars');

-- The table structures hold all forms in the application, Add the dxd_cap_report_ in table structures. It doesn't hold the form itself but the form alias.

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_cap_report_hepatocellulars', '', '', '0', '0', '1', '1');


INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'liver', 'liver', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'gallbladder', 'gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'wedge_resection', 'wedge resection', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'partial_hepatectomy', 'partial hepatectomy', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'major_hepatectomy_3_segments_or_more', 'major hepatectomy 3 segments or more', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'minor_hepatectomy_less_than_3_segments', 'minor hepatectomy less than 3 segments', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'total_hepatectomy', 'total hepatectomy', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'procedure_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'procedure_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'procedure_not_specified', 'procedure not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'solitary', 'solitary', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'specify_location', '', 'specify location', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'multiple', 'multiple', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'specify_locations', '', 'specify locations', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'histologic_type', 'histologic type', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'tumor_confined_to_liver', 'tumor confined to liver', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'tumor_involves_a_major_branch_of_the_portal_vein', 'tumor involves a major branch of the portal vein', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'tumor_involves_1_or_more_hepatic_veins', 'tumor involves 1 or more hepatic veins', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'tumor_involves_visceral_peritoneum', 'tumor involves visceral peritoneum', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'tumor_directly_invades_gallbladder', 'tumor directly invades gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'tumor_directly_invades_other_adjacent_organs', 'tumor directly invades other adjacent organs', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'uninvolved_by_invasive_carcinoma', 'uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'distance_of_invasive_carcinoma_from_closest_margin_mm', 'distance of invasive carcinoma from closest margin mm', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'p_specify_margin', 'specify margin', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'involved_by_invasive_carcinoma', 'involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'specify_margin', 'specify margin', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'special_margin_cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'special_margin_uninvolved_by_invasive_carcinoma', 'uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'special_margin_involved_by_invasive_carcinoma', 'involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'lymph_vascular_large_vessel_invasion', 'lymph vascular large vessel invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'lymph_vascular_small_vessel_invasion', 'lymph vascular small vessel invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'perineural_invasion', 'perineural invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_hc', 'tumour_grade', 'histologic grade', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_hc', 'path_tstage', 'path tstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'cirrhosis_severe_fibrosis', 'cirrhosis severe fibrosis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'none_to_moderate_fibrosis', 'none to moderate fibrosis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'hepatocellular_dysplasia', 'hepatocellular dysplasia', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'low_grade_dysplastic_nodule', 'low grade dysplastic nodule', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'high_grade_dysplastic_nodule', 'high grade dysplastic nodule', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'steatosis', 'steatosis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'iron_overload', 'iron overload', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'chronic_hepatitis', 'chronic hepatitis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'specify_etiology', '', 'specify etiology', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'additional_path_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'additional_path_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'none_identified', 'none identified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'ancillary_studies_specify', 'ancillary studies specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'cirrhosis', 'cirrhosis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'hepatitis_c_infection', 'hepatitis c infection', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'hepatitis_b_infection', 'hepatitis b infection', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'alcoholic_liver_disease', 'alcoholic liver disease', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'obesity', 'obesity', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'hereditary_hemochromatosis', 'hereditary hemochromatosis', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'other_clinical_history', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'other_clinical_history_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'not_known', 'not known', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_hc', 'path_nstage', 'path nstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_hc', 'path_mstage', 'path mstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellulars', 'other_adjacent_organs_specify', '', 'specify', 'input', '', '',  NULL , '', 'open', 'open', 'open');



INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='liver' AND `language_label`='liver' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='gallbladder' AND `language_label`='gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='wedge_resection' AND `language_label`='wedge resection' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='partial_hepatectomy' AND `language_label`='partial hepatectomy' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='major_hepatectomy_3_segments_or_more' AND `language_label`='major hepatectomy 3 segments or more' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='minor_hepatectomy_less_than_3_segments' AND `language_label`='minor hepatectomy less than 3 segments' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='total_hepatectomy' AND `language_label`='total hepatectomy' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='procedure_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='procedure_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='procedure_not_specified' AND `language_label`='procedure not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension'  ), '1', '15', '', '1', 'greatest dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a'  ), '1', '16', '', '1', 'additional dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b'  ), '1', '17', '', '0', '', '1', 'x', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`=''  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='solitary' AND `language_label`='solitary' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='specify_location' AND `language_label`='' AND `language_tag`='specify location' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='multiple' AND `language_label`='multiple' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='specify_locations' AND `language_label`='' AND `language_tag`='specify locations' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='histologic_type' AND `language_label`='histologic type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='histologic_type_specify' AND `language_label`='histologic type specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='tumor_confined_to_liver' AND `language_label`='tumor confined to liver' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='tumor_involves_a_major_branch_of_the_portal_vein' AND `language_label`='tumor involves a major branch of the portal vein' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='tumor_involves_1_or_more_hepatic_veins' AND `language_label`='tumor involves 1 or more hepatic veins' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='tumor_involves_visceral_peritoneum' AND `language_label`='tumor involves visceral peritoneum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='tumor_directly_invades_gallbladder' AND `language_label`='tumor directly invades gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='tumor_directly_invades_other_adjacent_organs' AND `language_label`='tumor directly invades other adjacent organs' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='uninvolved_by_invasive_carcinoma' AND `language_label`='uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='distance_of_invasive_carcinoma_from_closest_margin_mm' AND `language_label`='distance of invasive carcinoma from closest margin mm' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='p_specify_margin' AND `language_label`='specify margin' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='involved_by_invasive_carcinoma' AND `language_label`='involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='specify_margin' AND `language_label`='specify margin' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='special_margin_cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='special_margin_uninvolved_by_invasive_carcinoma' AND `language_label`='uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='special_margin_involved_by_invasive_carcinoma' AND `language_label`='involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='lymph_vascular_large_vessel_invasion' AND `language_label`='lymph vascular large vessel invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='lymph_vascular_small_vessel_invasion' AND `language_label`='lymph vascular small vessel invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='perineural_invasion' AND `language_label`='perineural invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_m' ), '2', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_r' ), '2', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_y' ), '2', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_hc' AND `field`='tumour_grade' AND `language_label`='histologic grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade_specify' AND `structure_value_domain`  IS NULL  ), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_hc' AND `field`='path_tstage' AND `language_label`='path tstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_examined' AND `structure_value_domain`  IS NULL  ), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_involved' AND `structure_value_domain`  IS NULL  ), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage_metastasis_site_specify' AND `structure_value_domain`  IS NULL  ), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='cirrhosis_severe_fibrosis' AND `language_label`='cirrhosis severe fibrosis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='none_to_moderate_fibrosis' AND `language_label`='none to moderate fibrosis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='hepatocellular_dysplasia' AND `language_label`='hepatocellular dysplasia' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='low_grade_dysplastic_nodule' AND `language_label`='low grade dysplastic nodule' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '58', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='high_grade_dysplastic_nodule' AND `language_label`='high grade dysplastic nodule' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='steatosis' AND `language_label`='steatosis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='iron_overload' AND `language_label`='iron overload' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='chronic_hepatitis' AND `language_label`='chronic hepatitis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='specify_etiology' AND `language_label`='' AND `language_tag`='specify etiology' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '63', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='additional_path_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '64', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='additional_path_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='none_identified' AND `language_label`='none identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '66', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='ancillary_studies_specify' AND `language_label`='ancillary studies specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '67', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='cirrhosis' AND `language_label`='cirrhosis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '68', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='hepatitis_c_infection' AND `language_label`='hepatitis c infection' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '69', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='hepatitis_b_infection' AND `language_label`='hepatitis b infection' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='alcoholic_liver_disease' AND `language_label`='alcoholic liver disease' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='obesity' AND `language_label`='obesity' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='hereditary_hemochromatosis' AND `language_label`='hereditary hemochromatosis' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='other_clinical_history' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='other_clinical_history_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='not_known' AND `language_label`='not known' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '76', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  ), '2', '77', '', '0', '', '0', '', '1', '', '0', '', '1', 'cols=40, rows=6', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_hc' AND `field`='path_nstage' AND `language_label`='path nstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_hc' AND `field`='path_mstage' AND `language_label`='path mstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellulars'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_hepatocellulars' AND `field`='other_adjacent_organs_specify' AND `language_label`='' AND `language_tag`='specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');



-- update checkbox structure value domain to 185
update structure_fields
set structure_value_domain=185
where type='checkbox'
and structure_value_domain is null;

-- add heading
update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='liver'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_hepatocellulars'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='procedure'
where sfi.id=sfo.structure_field_id
and sfi.field='wedge_resection'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_hepatocellulars'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor size'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_hepatocellulars'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor focality'
where sfi.id=sfo.structure_field_id
and sfi.field='solitary'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_hepatocellulars'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='microscopic tumor extension'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_confined_to_liver'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_hepatocellulars'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='parenchymal margin'
where sfi.id=sfo.structure_field_id
and sfi.field='cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_hepatocellulars'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='other margin'
where sfi.id=sfo.structure_field_id
and sfi.field='specify_margin'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_hepatocellulars'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='lymph vascular invasion'
where sfi.id=sfo.structure_field_id
and sfi.field='lymph_vascular_large_vessel_invasion'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_hepatocellulars'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='pathologic staging (pTNM)'
where sfi.id=sfo.structure_field_id
and sfi.field='path_tnm_descriptor_m'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_hepatocellulars'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='additional pathologic findings'
where sfi.id=sfo.structure_field_id
and sfi.field='cirrhosis_severe_fibrosis'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_hepatocellulars'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='clinical history'
where sfi.id=sfo.structure_field_id
and sfi.field='cirrhosis'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_hepatocellulars'; 


-- index
UPDATE structures AS str, structure_formats AS stfo, structure_fields AS sf 
SET stfo.flag_index = '1'
WHERE str.alias = 'dx_cap_report_hepatocellulars'
AND str.id = stfo.structure_id 
AND stfo.structure_field_id = sf.id
AND sf.field IN ('dx_date', 'tumor_site', 'tumour_grade', 'histologic_type');


-- dropdown list for select
-- invasion 
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_hepatocellulars' and field='lymph_vascular_large_vessel_invasion';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_hepatocellulars' and field='lymph_vascular_small_vessel_invasion';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_hepatocellulars' and field='perineural_invasion';


-- histologic_type_hc
insert ignore into structure_permissible_values (value, language_alias) values
('hepatocellular carcinoma','hepatocellular carcinoma'),
('fibrolamellar hepatocellular carcinoma','fibrolamellar hepatocellular carcinoma'),
('undifferentiated carcinoma','undifferentiated carcinoma'),
('carcinoma, type cannot be determined','carcinoma, type cannot be determined');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_type_hc', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_type_hc'), (select id from structure_permissible_values where value='hepatocellular carcinoma'), 1,1, 'hepatocellular carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_hc'), (select id from structure_permissible_values where value='fibrolamellar hepatocellular carcinoma'), 2,1, 'fibrolamellar hepatocellular carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_hc'), (select id from structure_permissible_values where value='undifferentiated carcinoma'), 3,1, 'undifferentiated carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_hc'), (select id from structure_permissible_values where value='other'), 4,1, 'other'),
((select id from structure_value_domains where domain_name='histologic_type_hc'), (select id from structure_permissible_values where value='carcinoma, type cannot be determined'), 4,1, 'carcinoma, type cannot be determined');

select * from structure_fields
where tablename='dxd_cap_report_hepatocellulars' and field='histologic_type';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_type_hc')
where tablename='dxd_cap_report_hepatocellulars' and field='histologic_type';

-- histologic_grade_hc
insert ignore into structure_permissible_values (value, language_alias) values
('gx','gx: cannot be assessed'),
('gi','gi: well differentiated'),
('gii','gii: moderately differentiated'),
('giii','giii: poorly differentiated'),
('giv','giv: undifferentiated/anaplastic');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_grade_hc', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_grade_hc'), (select id from structure_permissible_values where value='not applicable'), 1,1,'not applicable'),
((select id from structure_value_domains where domain_name='histologic_grade_hc'), (select id from structure_permissible_values where value='gx' and language_alias='gx: cannot be assessed'), 2,1,'gx: cannot be assessed'),
((select id from structure_value_domains where domain_name='histologic_grade_hc'), (select id from structure_permissible_values where value='gi' and language_alias='gi: well differentiated'), 3,1, 'gi: well differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_hc'), (select id from structure_permissible_values where value='gii' and language_alias='gii: moderately differentiated'), 4,1,'gii: moderately differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_hc'), (select id from structure_permissible_values where value='giii' and language_alias='giii: poorly differentiated'), 5,1,'giii: poorly differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_hc'), (select id from structure_permissible_values where value='giv' and language_alias='giv: undifferentiated/anaplastic'), 6,1,'giv: undifferentiated/anaplastic'),
((select id from structure_value_domains where domain_name='histologic_grade_hc'), (select id from structure_permissible_values where value='other'), 7,1,'other');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_grade_hc')
where tablename='diagnosis_masters_hc' and field='tumour_grade';

-- primary tumor (pt) path_tstage_hc
insert ignore into structure_permissible_values (value, language_alias) values
('ptx', 'ptx: cannot be assessed'),
('pt0', 'pt0: no evidence of primary tumor'),
('pt1', 'pt1: solitary tumor without vascular invasion'),
('pt2', 'pt2: solitary tumor with vascular invasion or multiple tumors none more than 5 cm'),
('pt3a', 'pt3a: multiple tumors more than 5 cm'),
('pt3b', 'pt3b: single tumor or multiple tumors of any size involving a major branch of the portal vein or hepatic veins'),
('pt4', 'pt4: tumor(s) with direct invasion of adjacent organs other than the gallbladder or with perforation of visceral peritoneum');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_tstage_hc', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_tstage_hc'), (select id from structure_permissible_values where value='ptx' and language_alias='ptx: cannot be assessed'), 1,1, 'ptx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_tstage_hc'), (select id from structure_permissible_values where value='pt0' and language_alias='pt0: no evidence of primary tumor'), 2,1, 'pt0: no evidence of primary tumor'),
((select id from structure_value_domains where domain_name='path_tstage_hc'), (select id from structure_permissible_values where value='pt1'  and language_alias='pt1: solitary tumor without vascular invasion'), 4,1, 'pt1: solitary tumor without vascular invasion'),
((select id from structure_value_domains where domain_name='path_tstage_hc'), (select id from structure_permissible_values where value='pt2' and language_alias='pt2: solitary tumor with vascular invasion or multiple tumors none more than 5 cm'), 5,1, 'pt2: solitary tumor with vascular invasion or multiple tumors none more than 5 cm'),
((select id from structure_value_domains where domain_name='path_tstage_hc'), (select id from structure_permissible_values where value='pt3a' and language_alias='pt3a: multiple tumors more than 5 cm'), 6,1, 'pt3a: multiple tumors more than 5 cm'),
((select id from structure_value_domains where domain_name='path_tstage_hc'), (select id from structure_permissible_values where value='pt3b' and language_alias='pt3b: single tumor or multiple tumors of any size involving a major branch of the portal vein or hepatic veins'), 7,1, 'pt3b: single tumor or multiple tumors of any size involving a major branch of the portal vein or hepatic veins'),
((select id from structure_value_domains where domain_name='path_tstage_hc'), (select id from structure_permissible_values where value='pt4' and language_alias='pt4: tumor(s) with direct invasion of adjacent organs other than the gallbladder or with perforation of visceral peritoneum'), 8,1, 'pt4: tumor(s) with direct invasion of adjacent organs other than the gallbladder or with perforation of visceral peritoneum');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_tstage_hc')
where tablename='diagnosis_masters_hc' and field='path_tstage';


-- regional lymph nodes (pn) path_nstage_hc
insert ignore into structure_permissible_values (value, language_alias) values
('pnx', 'pnx: cannot be assessed'),
('pn0', 'pn0: no regional lymph node metastasis'),
('pn1', 'pn1: regional lymph node metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_nstage_hc', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_nstage_hc'), (select id from structure_permissible_values where value='pnx' and language_alias='pnx: cannot be assessed'), 1,1, 'pnx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_nstage_hc'), (select id from structure_permissible_values where value='pn0' and language_alias='pn0: no regional lymph node metastasis'), 2,1, 'pn0: no regional lymph node metastasis'),
((select id from structure_value_domains where domain_name='path_nstage_hc'), (select id from structure_permissible_values where value='pn1' and language_alias='pn1: regional lymph node metastasis'), 3,1, 'pn1: regional lymph node metastasis');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_nstage_hc')
where tablename='diagnosis_masters_hc' and field='path_nstage';


-- distant metastasis (pm) path_mstage_hc
insert ignore into structure_permissible_values (value, language_alias) values
('pm1', 'pm1: distant metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_mstage_hc', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_mstage_hc'), (select id from structure_permissible_values where value='not applicable'), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='path_mstage_hc'), (select id from structure_permissible_values where value='pm1'), 2,1, 'pm1: distant metastasis');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_mstage_hc')
where tablename='diagnosis_masters_hc' and field='path_mstage';


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
('CAP Report - Gallbladders', 1, 'dx_cap_report_gallbladders', 'dxd_cap_report_gallbladders');

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
((select id from structure_value_domains where domain_name='procedure_dxd_gb'), (select id from structure_permissible_values where value='other' ), 3,1, 'other'),
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
('CAP Report - Distal Ex Bile Duct', 1, 'dx_cap_report_distalexbileducts', 'dxd_cap_report_distalexbileducts');

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
('choledochal cyst resection','choledochal cyst resection'),
('total hepatectomy','total hepatectomy');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('procedure_dxd_dbd', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='procedure_dxd_dbd'), (select id from structure_permissible_values where value='pancreaticoduodenectomy'), 1,1, 'pancreaticoduodenectomy'),
((select id from structure_value_domains where domain_name='procedure_dxd_dbd'), (select id from structure_permissible_values where value='segmental resection of bile ducts(s)'), 2,1, 'segmental resection of bile ducts(s)'),
((select id from structure_value_domains where domain_name='procedure_dxd_dbd'), (select id from structure_permissible_values where value='choledochal cyst resection'), 3,1, 'choledochal cyst resection'),
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
('CAP Report - Colon/Rectum', 1, 'dx_cap_report_colons', 'dxd_cap_report_colons');

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
((select id from structure_value_domains where domain_name='tumor_site_c'), (select id from structure_permissible_values where value='other' ), 9,1, 'other'),
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
('low-grade','low-grade (well-differentiated to moderately differentiated)'),
('high-grade','high-grade (poorly differentiated to undifferentiated)');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_grade_c', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_grade_c'), (select id from structure_permissible_values where value='not applicable'), 1,1,'not applicable'),
((select id from structure_value_domains where domain_name='histologic_grade_c'), (select id from structure_permissible_values where value='cannot be determined'), 2,1,'cannot be determined'),
((select id from structure_value_domains where domain_name='histologic_grade_c'), (select id from structure_permissible_values where value='low-grade'), 3,1, 'low-grade (well-differentiated to moderately differentiated)'),
((select id from structure_value_domains where domain_name='histologic_grade_c'), (select id from structure_permissible_values where value='high-grade'), 4,1,'high-grade (poorly differentiated to undifferentiated)');

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

/*Table structure for table 'dxd_cap_report_ampullas' */

DROP TABLE IF EXISTS `dxd_cap_report_ampullas`;

CREATE TABLE IF NOT EXISTS `dxd_cap_report_ampullas` (
  `id` int(10) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) NULL DEFAULT 0,
-- specimen
  `ampulla_of_vater` tinyint(1) NULL DEFAULT 0,
  `stomach` tinyint(1) NULL DEFAULT 0,
  `head_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `duodenum` tinyint(1) NULL DEFAULT 0,
  `common_bile_duct` tinyint(1) NULL DEFAULT 0,  
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
  `not_specified` tinyint(1) NULL DEFAULT 0,  
-- procedure  
  `procedure` varchar(50) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL,
-- tumor site  
  `intra_ampullary` tinyint(1) NULL DEFAULT 0,
  `peri_ampullary` tinyint(1) NULL DEFAULT 0,
  `papilla_of_vater` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other_specify` varchar(250) DEFAULT NULL,
  `tumor_site_cannot_be_determined` tinyint(1) NULL DEFAULT 0,    
  `tumor_site_not_specified` tinyint(1) NULL DEFAULT 0,   
-- tumor size in master  
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
-- histologic grade and specify in masters  
-- Microscopic Tumor Extension
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0,  
  `no_evidence_of_primary_tumor` tinyint(1) NULL DEFAULT 0, 
  `carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,    
  `tumor_limited_to_ampulla_of_vater_or_sphincter_of_oddi` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_duodenal_wall` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_pancreas` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_peripancreatic_soft_tissues` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_extrapancreatic_common_bile_duct` tinyint(1) NULL DEFAULT 0, 
  `tumor_invades_other_adjacent_organ_or_structures` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_specify` varchar(250) DEFAULT NULL, 
-- Margins  
  `margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `margins_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
  `specify_margin` varchar(250) DEFAULT NULL,
  `margins_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `specify_margins` varchar(250) DEFAULT NULL,  
  `not_applicable` tinyint(1) NULL DEFAULT 0,

  `proximal_mucosal_margin` varchar(50) DEFAULT NULL, 
  
  `distal_margin` varchar(50) DEFAULT NULL,   
  `pancreatic_retroperitoneal_margin` varchar(50) DEFAULT NULL,   
  `bile_duct_margin` varchar(50) DEFAULT NULL,   
  `distal_pancreatic_resection_margin` varchar(50) DEFAULT NULL,    
  `distance_of_invasive_carcinoma_from_closest_margin` decimal (3,1) DEFAULT NULL,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `n_specify_margin` varchar(250) DEFAULT NULL,
  
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,

-- Pathologic Staging (pTNM) in masters

--  Additional Pathologic Findings 
  `additional_path_none_identified` tinyint(1) NULL DEFAULT 0,    
  `dysplasia_adenoma` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
  `not_performed` tinyint(1) NULL DEFAULT 0,
-- clinical history  
  `familial_adenomatous_polyposis_coli`  tinyint(1) NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NULL DEFAULT 0,
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
  `not_known` tinyint(1) NULL DEFAULT 0,
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

ALTER TABLE `dxd_cap_report_ampullas` ADD CONSTRAINT `FK_dxd_cap_report_ampullas_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 


/*Table structure for table 'dxd_cap_report_ampullas_revs' */

DROP TABLE IF EXISTS `dxd_cap_report_ampullas_revs`;

CREATE TABLE `dxd_cap_report_ampullas_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NULL DEFAULT 0,
-- specimen
  `ampulla_of_vater` tinyint(1) NULL DEFAULT 0,
  `stomach` tinyint(1) NULL DEFAULT 0,
  `head_of_pancreas` tinyint(1) NULL DEFAULT 0,
  `duodenum` tinyint(1) NULL DEFAULT 0,
  `common_bile_duct` tinyint(1) NULL DEFAULT 0,  
  `gallbladder` tinyint(1) NULL DEFAULT 0,
  `other` tinyint(1) NULL DEFAULT 0,
  `other_specify` varchar(250) DEFAULT NULL,
  `not_specified` tinyint(1) NULL DEFAULT 0,  
-- procedure  
  `procedure` varchar(50) DEFAULT NULL,
  `procedure_specify` varchar(250) DEFAULT NULL,
-- tumor site  
  `intra_ampullary` tinyint(1) NULL DEFAULT 0,
  `peri_ampullary` tinyint(1) NULL DEFAULT 0,
  `papilla_of_vater` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other` tinyint(1) NULL DEFAULT 0,
  `tumor_site_other_specify` varchar(250) DEFAULT NULL,
  `tumor_site_cannot_be_determined` tinyint(1) NULL DEFAULT 0,    
  `tumor_site_not_specified` tinyint(1) NULL DEFAULT 0,   
-- tumor size in master  
-- histologic type
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
-- histologic grade and specify in masters  
-- Microscopic Tumor Extension
  `cannot_be_assessed` tinyint(1) NULL DEFAULT 0,  
  `no_evidence_of_primary_tumor` tinyint(1) NULL DEFAULT 0, 
  `carcinoma_in_situ` tinyint(1) NULL DEFAULT 0,    
  `tumor_limited_to_ampulla_of_vater_or_sphincter_of_oddi` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_duodenal_wall` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_pancreas` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_peripancreatic_soft_tissues` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_extrapancreatic_common_bile_duct` tinyint(1) NULL DEFAULT 0, 
  `tumor_invades_other_adjacent_organ_or_structures` tinyint(1) NULL DEFAULT 0,    
  `tumor_invades_specify` varchar(250) DEFAULT NULL, 
-- Margins  
  `margin_cannot_be_assessed` tinyint(1) NULL DEFAULT 0, 
  `margins_uninvolved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0, 
  `distance_of_invasive_carcinoma_from_closest_margin_mm` decimal (3,1) DEFAULT NULL,
  `specify_margin` varchar(250) DEFAULT NULL,
  `margins_involved_by_invasive_carcinoma` tinyint(1) NULL DEFAULT 0,
  `specify_margins` varchar(250) DEFAULT NULL,  
  `not_applicable` tinyint(1) NULL DEFAULT 0,

  `proximal_mucosal_margin` varchar(50) DEFAULT NULL, 
  
  `distal_margin` varchar(50) DEFAULT NULL,   
  `pancreatic_retroperitoneal_margin` varchar(50) DEFAULT NULL,   
  `bile_duct_margin` varchar(50) DEFAULT NULL,   
  `distal_pancreatic_resection_margin` varchar(50) DEFAULT NULL,    
  `distance_of_invasive_carcinoma_from_closest_margin` decimal (3,1) DEFAULT NULL,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `n_specify_margin` varchar(250) DEFAULT NULL,
  
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  `perineural_invasion` varchar(50) DEFAULT NULL,

-- Pathologic Staging (pTNM) in masters

--  Additional Pathologic Findings 
  `additional_path_none_identified` tinyint(1) NULL DEFAULT 0,    
  `dysplasia_adenoma` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other` tinyint(1) NULL DEFAULT 0, 
  `additional_path_other_specify` varchar(250) DEFAULT NULL,
  
  `ancillary_studies_specify` varchar(250) DEFAULT NULL,    
  `not_performed` tinyint(1) NULL DEFAULT 0,
-- clinical history  
  `familial_adenomatous_polyposis_coli`  tinyint(1) NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NULL DEFAULT 0,
  `other_clinical_history_specify` varchar(250) DEFAULT NULL,
  `not_known` tinyint(1) NULL DEFAULT 0,
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
('CAP Report - Ampulla', 1, 'dx_cap_report_ampullas', 'dxd_cap_report_ampullas');

-- The table structures hold all forms in the application, Add the dxd_cap_report_ in table structures. It doesn't hold the form itself but the form alias.

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_cap_report_ampullas', '', '', '0', '0', '1', '1');

-- form builder
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'ampulla_of_vater', 'ampulla of vater', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'stomach', 'stomach', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'head_of_pancreas', 'head of pancreas', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'duodenum', 'duodenum', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'common_bile_duct', 'common bile duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'gallbladder', 'gallbladder', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'procedure', 'procedure', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'procedure_specify', 'procedure specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'intra_ampullary', 'intra ampullary', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'peri_ampullary', 'peri ampullary', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'papilla_of_vater', 'papilla of vater', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_site_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_site_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_site_cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_site_not_specified', 'not specified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'histologic_type', 'histologic type', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'no_evidence_of_primary_tumor', 'no evidence of primary tumor', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'carcinoma_in_situ', 'carcinoma in situ', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_limited_to_ampulla_of_vater_or_sphincter_of_oddi', 'tumor limited to ampulla of vater or sphincter of oddi', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_invades_duodenal_wall', 'tumor invades duodenal wall', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_invades_pancreas', 'tumor invades pancreas', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_invades_peripancreatic_soft_tissues', 'tumor invades peripancreatic soft tissues', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_invades_extrapancreatic_common_bile_duct', 'tumor invades extrapancreatic common bile duct', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_invades_other_adjacent_organ_or_structures', 'tumor invades other adjacent organ or structures', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_invades_specify', 'specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'margin_cannot_be_assessed', 'cannot be assessed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'margins_uninvolved_by_invasive_carcinoma', 'margins uninvolved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'distance_of_invasive_carcinoma_from_closest_margin_mm', 'distance of invasive carcinoma from closest margin mm', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'specify_margin', 'specify margin', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'specify_margins', 'specify margins', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'margins_involved_by_invasive_carcinoma', 'margins involved by invasive carcinoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'not_applicable', 'not applicable', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'proximal_mucosal_margin', 'proximal mucosal margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'distal_margin', 'distal margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'pancreatic_retroperitoneal_margin', 'pancreatic retroperitoneal margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'bile_duct_margin', 'bile duct margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'distal_pancreatic_resection_margin', 'distal pancreatic resection margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'distance_of_invasive_carcinoma_from_closest_margin', 'distance of invasive carcinoma from closest margin', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'distance_unit', 'distance unit', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'n_specify_margin', 'specify margin', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'lymph_vascular_invasion', 'lymph vascular invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'perineural_invasion', 'perineural invasion', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'additional_path_none_identified', 'none identified', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'dysplasia_adenoma', 'dysplasia adenoma', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'additional_path_other', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'additional_path_other_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'ancillary_studies_specify', 'ancillary studies specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'not_performed', 'not performed', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'familial_adenomatous_polyposis_coli', 'familial adenomatous polyposis coli', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'other_clinical_history', 'other', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'other_clinical_history_specify', '', 'other specify', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'not_known', 'not known', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_a', 'tumour_grade', 'histologic grade', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_a', 'path_tstage', 'path tstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_a', 'path_nstage', 'path nstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_a', 'path_mstage', 'path mstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='ampulla_of_vater' AND `language_label`='ampulla of vater' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='stomach' AND `language_label`='stomach' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='head_of_pancreas' AND `language_label`='head of pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='duodenum' AND `language_label`='duodenum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='common_bile_duct' AND `language_label`='common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='gallbladder' AND `language_label`='gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='procedure' AND `language_label`='procedure' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='procedure_specify' AND `language_label`='procedure specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='intra_ampullary' AND `language_label`='intra ampullary' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='peri_ampullary' AND `language_label`='peri ampullary' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='papilla_of_vater' AND `language_label`='papilla of vater' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_site_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_site_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_site_cannot_be_determined' AND `language_label`='cannot be determined' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_site_not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension' AND `structure_value_domain`  IS NULL  ), '1', '20', '', '1', 'greatest dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a' AND `structure_value_domain`  IS NULL  ), '1', '21', '', '1', 'additional dimension', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `structure_value_domain`  IS NULL  ), '1', '22', '', '0', '', '1', 'x', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cannot_be_determined' ), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='histologic_type' AND `language_label`='histologic type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='histologic_type_specify' AND `language_label`='histologic type specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade_specify' AND `structure_value_domain`  IS NULL  ), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='no_evidence_of_primary_tumor' AND `language_label`='no evidence of primary tumor' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='carcinoma_in_situ' AND `language_label`='carcinoma in situ' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_limited_to_ampulla_of_vater_or_sphincter_of_oddi' AND `language_label`='tumor limited to ampulla of vater or sphincter of oddi' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_invades_duodenal_wall' AND `language_label`='tumor invades duodenal wall' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_invades_pancreas' AND `language_label`='tumor invades pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_invades_peripancreatic_soft_tissues' AND `language_label`='tumor invades peripancreatic soft tissues' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_invades_extrapancreatic_common_bile_duct' AND `language_label`='tumor invades extrapancreatic common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_invades_other_adjacent_organ_or_structures' AND `language_label`='tumor invades other adjacent organ or structures' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_invades_specify' AND `language_label`='specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='margin_cannot_be_assessed' AND `language_label`='cannot be assessed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='margins_uninvolved_by_invasive_carcinoma' AND `language_label`='margins uninvolved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='distance_of_invasive_carcinoma_from_closest_margin_mm' AND `language_label`='distance of invasive carcinoma from closest margin mm' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='specify_margin' AND `language_label`='specify margin' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='specify_margins' AND `language_label`='specify margins' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='margins_involved_by_invasive_carcinoma' AND `language_label`='margins involved by invasive carcinoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='not_applicable' AND `language_label`='not applicable' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='proximal_mucosal_margin' AND `language_label`='proximal mucosal margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='distal_margin' AND `language_label`='distal margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='pancreatic_retroperitoneal_margin' AND `language_label`='pancreatic retroperitoneal margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='bile_duct_margin' AND `language_label`='bile duct margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='distal_pancreatic_resection_margin' AND `language_label`='distal pancreatic resection margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='distance_of_invasive_carcinoma_from_closest_margin' AND `language_label`='distance of invasive carcinoma from closest margin' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='distance_unit' AND `language_label`='distance unit' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='n_specify_margin' AND `language_label`='specify margin' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='lymph_vascular_invasion' AND `language_label`='lymph vascular invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='perineural_invasion' AND `language_label`='perineural invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_m' ), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_r' ), '2', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tnm_descriptor_y' ), '2', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_examined' AND `structure_value_domain`  IS NULL  ), '2', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage_nbr_node_involved' AND `structure_value_domain`  IS NULL  ), '2', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage_metastasis_site_specify' AND `structure_value_domain`  IS NULL  ), '2', '63', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='additional_path_none_identified' AND `language_label`='none identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '64', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='dysplasia_adenoma' AND `language_label`='dysplasia adenoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '65', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='additional_path_other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '66', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='additional_path_other_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '67', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='ancillary_studies_specify' AND `language_label`='ancillary studies specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '68', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='not_performed' AND `language_label`='not performed' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '69', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='familial_adenomatous_polyposis_coli' AND `language_label`='familial adenomatous polyposis coli' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='other_clinical_history' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='other_clinical_history_specify' AND `language_label`='' AND `language_tag`='other specify' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='not_known' AND `language_label`='not known' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  ), '2', '74', '', '0', '', '0', '', '1', '', '0', '', '1', 'cols=40, rows=6', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_a' AND `field`='tumour_grade' AND `language_label`='histologic grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_a' AND `field`='path_tstage' AND `language_label`='path tstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '58', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_a' AND `field`='path_nstage' AND `language_label`='path nstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_a' AND `field`='path_mstage' AND `language_label`='path mstage' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');



-- update checkbox structure value domain to 185
update structure_fields
set structure_value_domain=185
where type='checkbox'
and structure_value_domain is null;

-- validation distance_unit
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_cap_report_ampullas' AND `field`='distance_unit' AND `type`='select'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

-- add heading
update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='ampulla_of_vater'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_ampullas'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='other organ received'
where sfi.id=sfo.structure_field_id
and sfi.field='stomach'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_ampullas'; 


update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor site'
where sfi.id=sfo.structure_field_id
and sfi.field='intra_ampullary'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_ampullas'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor size'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_ampullas'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='microscopic tumor extension'
where sfi.id=sfo.structure_field_id
and sfi.field='cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_ampullas'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='margins ampullectomy specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='margin_cannot_be_assessed'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_ampullas'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='magins pancreaticoduodenal resection specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='proximal_mucosal_margin'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_ampullas'; 


update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='pathologic staging (pTNM)'
where sfi.id=sfo.structure_field_id
and sfi.field='path_tnm_descriptor_m'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_ampullas'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='additional pathologic findings'
where sfi.id=sfo.structure_field_id
and sfi.field='additional_path_none_identified'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_ampullas'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='clinical history'
where sfi.id=sfo.structure_field_id
and sfi.field='familial_adenomatous_polyposis_coli'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_ampullas'; 

-- index
UPDATE structures AS str, structure_formats AS stfo, structure_fields AS sf 
SET stfo.flag_index = '1'
WHERE str.alias = 'dx_cap_report_ampullas'
AND str.id = stfo.structure_id 
AND stfo.structure_field_id = sf.id
AND sf.field IN ('dx_date', 'tumor_site', 'tumour_grade', 'histologic_type');


-- dropdown list for select
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distance_unit')
where tablename='dxd_cap_report_ampullas' and field='distance_unit';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_ampullas' and field='lymph_vascular_invasion';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_cap_report_ampullas' and field='perineural_invasion';

-- procedure_dxd_a
insert ignore into structure_permissible_values (value, language_alias) values
('ampullectomy','ampullectomy'),
('pancreaticoduodenectomy (whipple resection)','pancreaticoduodenectomy (whipple resection)'),
('not specified','not specified'),
('other (specify)','other (specify)');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('procedure_dxd_a', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='procedure_dxd_a'), (select id from structure_permissible_values where value='ampullectomy'), 1,1, 'ampullectomy'),
((select id from structure_value_domains where domain_name='procedure_dxd_a'), (select id from structure_permissible_values where value='pancreaticoduodenectomy (whipple resection)'), 2,1, 'pancreaticoduodenectomy (whipple resection)'),
((select id from structure_value_domains where domain_name='procedure_dxd_a'), (select id from structure_permissible_values where value='other (specify)'), 3,1, 'other (specify)'),
((select id from structure_value_domains where domain_name='procedure_dxd_a'), (select id from structure_permissible_values where value='not specified'), 6,1, 'not specified');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='procedure_dxd_a')
where tablename='dxd_cap_report_ampullas' and field='procedure';

-- histologic_type_a
insert ignore into structure_permissible_values (value, language_alias) values
('adenocarcinoma (not otherwise characterized)','adenocarcinoma (not otherwise characterized)'),
('papillary adenocarcinoma','papillary adenocarcinoma'),
('adenocarcinoma, intestinal type', 'adenocarcinoma, intestinal type'),
('mucinous adenocarcinoma','mucinous adenocarcinoma'),
('clear cell adenocarcinoma','clear cell adenocarcinoma'),
('signet-ring cell carcinoma','signet-ring cell carcinoma'),
('adenosquamous carcinoma','adenosquamous carcinoma'),
('squamous cell carcinoma','squamous cell carcinoma'),
('small cell carcinoma','small cell carcinoma'),
('other','other'),
('carcinoma, type cannot be determined','carcinoma, type cannot be determined');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_type_a', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_type_a'), (select id from structure_permissible_values where value='adenocarcinoma (not otherwise characterized)'), 1,1, 'adenocarcinoma (not otherwise characterized)'),
((select id from structure_value_domains where domain_name='histologic_type_a'), (select id from structure_permissible_values where value='papillary adenocarcinoma'), 2,1, 'papillary adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_a'), (select id from structure_permissible_values where value='adenocarcinoma, intestinal type'), 3,1, 'adenocarcinoma, intestinal type'),
((select id from structure_value_domains where domain_name='histologic_type_a'), (select id from structure_permissible_values where value='mucinous adenocarcinoma'), 4,1, 'mucinous adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_a'), (select id from structure_permissible_values where value='clear cell adenocarcinoma'), 5,1, 'clear cell adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_a'), (select id from structure_permissible_values where value='signet-ring cell carcinoma'), 6,1, 'signet-ring cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_a'), (select id from structure_permissible_values where value='adenosquamous carcinoma'), 7,1, 'adenosquamous carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_a'), (select id from structure_permissible_values where value='squamous cell carcinoma'), 8,1, 'squamous cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_a'), (select id from structure_permissible_values where value='small cell carcinoma'), 9,1, 'small cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_a'), (select id from structure_permissible_values where value='other'), 10,1, 'other'),
((select id from structure_value_domains where domain_name='histologic_type_a'), (select id from structure_permissible_values where value='carcinoma, type cannot be determined'), 11,1, 'carcinoma, type cannot be determined');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_type_a')
where tablename='dxd_cap_report_ampullas' and field='histologic_type';

-- histologic_grade_a
insert ignore into structure_permissible_values (value, language_alias) values
('not applicable (histologic type not usually graded)','not applicable (histologic type not usually graded)');


insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('histologic_grade_a', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_grade_a'), (select id from structure_permissible_values where value='not applicable (histologic type not usually graded)'), 1,1,'Nnot applicable (histologic type not usually graded)'),
((select id from structure_value_domains where domain_name='histologic_grade_a'), (select id from structure_permissible_values where value='gx'), 2,1,'gx: cannot be assessed'),
((select id from structure_value_domains where domain_name='histologic_grade_a'), (select id from structure_permissible_values where value='g1'), 3,1, 'g1: well differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_a'), (select id from structure_permissible_values where value='g2'), 4,1,'g2: moderately differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_a'), (select id from structure_permissible_values where value='g3'), 5,1,'g3: poorly differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_a'), (select id from structure_permissible_values where value='g4'), 6,1,'g4:undifferentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_a'), (select id from structure_permissible_values where value='other'), 7,1,'other');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_grade_a')
where tablename='diagnosis_masters_a' and field='tumour_grade';


-- proximal_mucosal_margin

insert ignore into structure_permissible_values (value, language_alias) values
('intramucosal carcinoma /adenoma not identified at proximal margin','intramucosal carcinoma /adenoma not identified at proximal margin'),
('intramucosal carcinoma/adenoma present at proximal margin','intramucosal carcinoma/adenoma present at proximal margin');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('proximal_mucosal_margin', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='proximal_mucosal_margin'), (select id from structure_permissible_values where value='cannot be assessed' ), 1,1, 'cannot be assessed'),
((select id from structure_value_domains where domain_name='proximal_mucosal_margin'), (select id from structure_permissible_values where value='uninvolved by invasive carcinoma' ), 2,1, 'uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='proximal_mucosal_margin'), (select id from structure_permissible_values where value='involved by invasive carcinoma' ), 3,1, 'involved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='proximal_mucosal_margin'), (select id from structure_permissible_values where value='intramucosal carcinoma /adenoma not identified at proximal margin' ), 4,1, 'intramucosal carcinoma /adenoma not identified at proximal margin'),
((select id from structure_value_domains where domain_name='proximal_mucosal_margin'), (select id from structure_permissible_values where value='intramucosal carcinoma/adenoma present at proximal margin' ), 5,1, 'intramucosal carcinoma/adenoma present at proximal margin');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='proximal_mucosal_margin')
where tablename='dxd_cap_report_ampullas' and field='proximal_mucosal_margin';

-- distal_margin_a

insert ignore into structure_permissible_values (value, language_alias) values
('intramucosal carcinoma/adenoma not identified at distal margin','intramucosal carcinoma/adenoma not identified at distal margin'),
('intramucosal carcinoma /adenoma present at distal margin','intramucosal carcinoma /adenoma present at distal margin');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('distal_margin_a', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='distal_margin_a'), (select id from structure_permissible_values where value='cannot be assessed' ), 1,1, 'cannot be assessed'),
((select id from structure_value_domains where domain_name='distal_margin_a'), (select id from structure_permissible_values where value='uninvolved by invasive carcinoma' ), 2,1, 'uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='distal_margin_a'), (select id from structure_permissible_values where value='involved by invasive carcinoma' ), 3,1, 'involved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='distal_margin_a'), (select id from structure_permissible_values where value='intramucosal carcinoma/adenoma not identified at distal margin' ), 4,1, 'intramucosal carcinoma/adenoma not identified at distal margin'),
((select id from structure_value_domains where domain_name='distal_margin_a'), (select id from structure_permissible_values where value='intramucosal carcinoma /adenoma present at distal margin' ), 5,1, 'intramucosal carcinoma /adenoma present at distal margin');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distal_margin_a')
where tablename='dxd_cap_report_ampullas' and field='distal_margin';

-- margin_0_1

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin_0_1')
where tablename='dxd_cap_report_ampullas' and field='pancreatic_retroperitoneal_margin';

-- margin_not_applicable

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin_not_applicable')
where tablename='dxd_cap_report_ampullas' and field='bile_duct_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin_not_applicable')
where tablename='dxd_cap_report_ampullas' and field='distal_pancreatic_resection_margin';

-- primary tumor (pt) path_tstage_a
insert ignore into structure_permissible_values (value, language_alias) values
('ptx', 'ptx: cannot be assessed'),
('pt0', 'pt0: no evidence of primary tumor'),
('ptis', 'ptis: carcinoma in situ'),
('pt1', 'pt1: tumor limited to ampulla of vater or sphincter of oddi'),
('pt2', 'pt2: tumor invades duodenal wall'),
('pt3', 'pt3: tumor invades pancreas'),
('pt4', 'pt4: tumor invades peripancreatic soft tissues or other adjacent organs or structures');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_tstage_a', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_tstage_a'), (select id from structure_permissible_values where value='ptx' and language_alias='ptx: cannot be assessed'), 1,1, 'ptx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_tstage_a'), (select id from structure_permissible_values where value='pt0' and language_alias='pt0: no evidence of primary tumor'), 2,1, 'pt0: no evidence of primary tumor'),
((select id from structure_value_domains where domain_name='path_tstage_a'), (select id from structure_permissible_values where value='ptis' and language_alias='ptis: carcinoma in situ'), 3,1, 'ptis: carcinoma in situ'),
((select id from structure_value_domains where domain_name='path_tstage_a'), (select id from structure_permissible_values where value='pt1'  and language_alias='pt1: tumor limited to ampulla of vater or sphincter of oddi'), 4,1, 'pt1: tumor limited to ampulla of vater or sphincter of oddi'),
((select id from structure_value_domains where domain_name='path_tstage_a'), (select id from structure_permissible_values where value='pt2' and language_alias='pt2: tumor invades duodenal wall'), 5,1, 'pt2: tumor invades duodenal wall'),
((select id from structure_value_domains where domain_name='path_tstage_a'), (select id from structure_permissible_values where value='pt3' and language_alias='pt3: tumor invades pancreas'), 7,1, 'pt3: tumor invades pancreas'),
((select id from structure_value_domains where domain_name='path_tstage_a'), (select id from structure_permissible_values where value='pt4' and language_alias='pt4: tumor invades peripancreatic soft tissues or other adjacent organs or structures'), 8,1, 'pt4: tumor invades peripancreatic soft tissues or other adjacent organs or structures');


update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_tstage_a')
where tablename='diagnosis_masters_a' and field='path_tstage';


-- regional lymph nodes (pn) path_nstage_a
insert ignore into structure_permissible_values (value, language_alias) values
('pnx', 'pnx: cannot be assessed'),
('pn0', 'pn0: no regional lymph node metastasis'),
('pn1', 'pn1: regional lymph node metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_nstage_a', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_nstage_a'), (select id from structure_permissible_values where value='pnx' and language_alias='pnx: cannot be assessed'), 1,1, 'pnx: cannot be assessed'),
((select id from structure_value_domains where domain_name='path_nstage_a'), (select id from structure_permissible_values where value='pn0' and language_alias='pn0: no regional lymph node metastasis'), 2,1, 'pn0: no regional lymph node metastasis'),
((select id from structure_value_domains where domain_name='path_nstage_a'), (select id from structure_permissible_values where value='pn1' and language_alias='pn1: regional lymph node metastasis'), 3,1, 'pn1: regional lymph node metastasis');


update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_nstage_a')
where tablename='diagnosis_masters_a' and field='path_nstage';


-- distant metastasis (pm) path_mstage_a
insert ignore into structure_permissible_values (value, language_alias) values
('pm1', 'pm1: distant metastasis');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('path_mstage_a', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_mstage_a'), (select id from structure_permissible_values where value='not applicable'), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='path_mstage_a'), (select id from structure_permissible_values where value='pm1'), 2,1, 'pm1: distant metastasis');


update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_mstage_a')
where tablename='diagnosis_masters_a' and field='path_mstage';


-- insert i18n
INSERT IGNORE INTO i18n (id, en, fr)
VALUES
('hilar and hepatic resection', 'Hilar and hepatic resection', ''),
('segmental resection of bile ducts(s)', 'Segmental resection of bile ducts(s)', ''),
('choledochal cyst resection', 'Choledochal cyst resection', ''),
('total hepatectomy', 'Total hepatectomy', ''),
('papillary adenocarcinoma', 'Papillary adenocarcinoma', ''),
('mucinous adenocarcinoma', 'Mucinous adenocarcinoma', ''),
('clear cell adenocarcinoma', 'Clear cell adenocarcinoma', ''),
('signet-ring cell carcinoma', 'Signet-ring cell carcinoma', ''),
('biliary cystadenocarcinoma', 'Biliary cystadenocarcinoma', ''),
('carcinoma, not otherwise specified', 'Carcinoma, not otherwise specified', ''),
('excisional biopsy (enucleation)', 'Excisional biopsy (enucleation)', ''),
('pancreaticoduodenectomy (whipple resection), partial pancreatectomy', 'Pancreaticoduodenectomy (whipple resection), partial pancreatectomy', ''),
('pancreaticoduodenectomy (whipple resection), total pancreatectomy', 'Pancreaticoduodenectomy (whipple resection), total pancreatectomy', ''),
('partial pancreatectomy, pancreatic body', 'Partial pancreatectomy, pancreatic body', ''),
('partial pancreatectomy, pancreatic tail', 'Partial pancreatectomy, pancreatic tail', ''),
('well-differentiated endocrine neoplasm', 'Well-differentiated endocrine neoplasm', ''),
('poorly differentiated endocrine carcinoma', 'Poorly differentiated endocrine carcinoma', ''),
('carcinoma, type cannot be determined', 'Carcinoma, type cannot be determined', ''),
('well-differentiated endocrine tumor, benign behavior', 'Well-differentiated endocrine tumor, benign behavior', ''),
('well-differentiated endocrine tumor, uncertain behavior', 'Well-differentiated endocrine tumor, uncertain behavior', ''),
('well-differentiated endocrine carcinoma', 'Well-differentiated endocrine carcinoma', ''),
('cholangiocarcinoma', 'Cholangiocarcinoma', ''),
('combined hepatocellular and cholangiocarcinoma', 'Combined hepatocellular and cholangiocarcinoma', ''),
('bile duct cystadenocarcinoma', 'Bile duct cystadenocarcinoma', ''),
('mass-forming', 'Mass-forming', ''),
('periductal infiltrating', 'Periductal infiltrating', ''),
('mixed mass-forming and periductal infiltrating', 'Mixed mass-forming and periductal infiltrating', ''),
('insert ignore into structure_permissible_values (value, language_alias) values', 'Insert ignore into structure_permissible_values (value, language_alias) values', ''),
('hepatocellular carcinoma', 'Hepatocellular carcinoma', ''),
('fibrolamellar hepatocellular carcinoma', 'Fibrolamellar hepatocellular carcinoma', ''),
('simple cholecystectomy (laparoscopic or open)', 'Simple cholecystectomy (laparoscopic or open)', ''),
('radical cholecystectomy (with liver resection and lymphadenectomy)', 'Radical cholecystectomy (with liver resection and lymphadenectomy)', ''),
('adenocarcinoma, intestinal type', 'Adenocarcinoma, intestinal type', ''),
('clear cell carcinoma', 'Clear cell carcinoma', ''),
('tumor invades muscle layer', 'Tumor invades muscle layer', ''),
('tumor invades perimuscular connective tissue; no extension beyond serosa or into liver', 'Tumor invades perimuscular connective tissue; no extension beyond serosa or into liver', ''),
('tumor perforates serosa (visceral peritoneum)', 'Tumor perforates serosa (visceral peritoneum)', ''),
('tumor directly invades the liver', 'Tumor directly invades the liver', ''),
('tumor directly invades extrahepatic bile ducts', 'Tumor directly invades extrahepatic bile ducts', ''),
('tumor directly invades other adjacent organ or structure, such as the stomach, duodenum, colon, pancreas, or omentum', 'Tumor directly invades other adjacent organ or structure, such as the stomach, duodenum, colon, pancreas, or omentum', ''),
('pancreaticoduodenectomy', 'Pancreaticoduodenectomy', ''),
('large cell carcinoma', 'Large cell carcinoma', ''),
('cecum', 'Cecum', ''),
('right (ascending) colon', 'Right (ascending) colon', ''),
('hepatic flexure', 'Hepatic flexure', ''),
('transverse colon', 'Transverse colon', ''),
('splenic flexure', 'Splenic flexure', ''),
('left (descending) colon', 'Left (descending) colon', ''),
('sigmoid colon', 'Sigmoid colon', ''),
('rectum', 'Rectum', ''),
('low-grade (well-differentiated to moderately differentiated)', 'Low-grade (well-differentiated to moderately differentiated)', ''),
('high-grade (poorly differentiated to undifferentiated)', 'High-grade (poorly differentiated to undifferentiated)', ''),
('lamina propria', 'Lamina propria', ''),
('muscularis mucosae', 'Muscularis mucosae', ''),
('submucosa', 'Submucosa', ''),
('muscularis propria', 'Muscularis propria', ''),
('tubular adenoma', 'Tubular adenoma', ''),
('villous adenoma', 'Villous adenoma', ''),
('tubulovillous adenoma', 'Tubulovillous adenoma', ''),
('traditional serrated adenoma', 'Traditional serrated adenoma', ''),
('sessile serrated adenoma', 'Sessile serrated adenoma', ''),
('hamartomatous polyp', 'Hamartomatous polyp', ''),
('ampullectomy', 'Ampullectomy', ''),
('other (specify)', 'Other (specify)', ''),
('not applicable (histologic type not usually graded)', 'Not applicable (histologic type not usually graded)', ''),
('intramucosal carcinoma /adenoma not identified at proximal margin', 'Intramucosal carcinoma /adenoma not identified at proximal margin', ''),
('g1: well differentiated', 'G1: Well differentiated', ''),
('g2: moderately differentiated', 'G2: Moderately differentiated', ''),
('g3: poorly differentiated', 'G3: Poorly differentiated', ''),
('g4: undifferentiated', 'G4: Undifferentiated', ''),
('gi: well differentiated', 'GI: Well differentiated', ''),
('gii: moderately differentiated', 'GII: Moderately differentiated', ''),
('giii: poorly differentiated', 'GIII: Poorly differentiated', ''),
('giv: undifferentiated', 'GIV: Undifferentiated', ''),
('giv: undifferentiated/anaplastic', 'GIV: Undifferentiated/Anaplastic', ''),
('gx: cannot be assessed', 'GX: Cannot be assessed', ''),
('pm1: distant metastasis', 'pM1: Distant metastasis', ''),
('pn0: no regional lymph node metastasis', 'pN0: No regional lymph node metastasis', ''),
('pn1: metastases to nodes along the cystic duct, common bile duct, hepatic artery, and/or portal vein', 'pN1: Metastases to nodes along the cystic duct, common bile duct, hepatic artery, and/or portal vein', ''),
('pn1: metastasis in 1 to 3 regional lymph nodes', 'pN1: Metastasis in 1 to 3 regional lymph nodes', ''),
('pn1: regional lymph node metastasis', 'pN1: Regional lymph node metastasis', ''),
('pn1: regional lymph node metastasis (including nodes along the cystic duct, common bile duct, hepatic artery, and portal vein)', 'pN1: Regional lymph node metastasis (including nodes along the cystic duct, common bile duct, hepatic artery, and portal vein)', ''),
('pn2: metastases to periaortic, pericaval, superior mesentery artery, and/or celiac artery lymph nodes', 'pN2: Metastases to periaortic, pericaval, superior mesentery artery, and/or celiac artery lymph nodes', ''),
('pn2: metastasis in 4 or more regional lymph nodes', 'pN2: Metastasis in 4 or more regional lymph nodes', ''),
('pn2: metastasis to periaortic, pericaval, superior mesentery artery, and/or celiac artery lymph nodes', 'pN2: Metastasis to periaortic, pericaval, superior mesentery artery, and/or celiac artery lymph nodes', ''),
('pnx: cannot be assessed', 'pNX: Cannot be assessed', ''),
('pt0: no evidence of primary tumor', 'pT0: No evidence of primary tumor', ''),
('pt1: solitary tumor without vascular invasion', 'pT1: solitary tumor without vascular invasion', ''),
('pt1: tumor confined to the bile duct histologically', 'pT1: Tumor confined to the bile duct histologically', ''),
('pt1: tumor confined to the bile duct, with extension up to the muscle layer or fibrous tissue', 'pT1: Tumor confined to the bile duct, with extension up to the muscle layer or fibrous tissue', ''),
('pt1: tumor invades lamina propria or muscular layer', 'pT1: Tumor invades lamina propria or muscular layer', ''),
('pt1: tumor limited to ampulla of vater or sphincter of oddi', 'pT1: Tumor limited to ampulla of vater or sphincter of oddi', ''),
('pt1: tumor limited to the pancreas, 2 cm or less in greatest dimension', 'pT1: Tumor limited to the pancreas, 2 cm or less in greatest dimension', ''),
('pt1a: tumor invades lamina propria', 'pT1a: Tumor invades lamina propria', ''),
('pt1b: tumor invades muscular layer', 'pT1b: Tumor invades muscular layer', ''),
('pt1b: tumor invades submucosa', 'pT1b: Tumor invades submucosa', ''),
('pt2: solitary tumor with vascular invasion or multiple tumors none more than 5 cm', 'pT2: Solitary tumor with vascular invasion or multiple tumors none more than 5 cm', ''),
('pt2: tumor invades beyond the wall of the bile duct', 'pT2: Tumor invades beyond the wall of the bile duct', ''),
('pt2: tumor invades duodenal wall', 'pT2: Tumor invades duodenal wall', ''),
('pt2: tumor invades muscularis propria', 'pT2: Tumor invades muscularis propria', ''),
('pt2: tumor invades perimuscular connective tissue; no extension beyond serosa or into liver', 'pT2: Tumor invades perimuscular connective tissue; no extension beyond serosa or into liver', ''),
('pt2: tumor limited to the pancreas, more than 2 cm in greatest dimension', 'pT2: Tumor limited to the pancreas, more than 2 cm in greatest dimension', ''),
('pt2a: solitary tumor with vascular invasion', 'pT2a: Solitary tumor with vascular invasion', ''),
('pt2a: tumor invades beyond the wall of the bile duct to surrounding adipose tissue', 'pT2a: Tumor invades beyond the wall of the bile duct to surrounding adipose tissue', ''),
('pt2b: multiple tumors, with or without vascular invasion', 'pT2b: Multiple tumors, with or without vascular invasion', ''),
('pt2b: tumor invades adjacent hepatic parenchyma', 'pT2b: Tumor invades adjacent hepatic parenchyma', ''),
('pt3: tumor extends beyond the pancreas but without involvement of the celiac axis or the superior mesenteric artery', 'pT3: Tumor extends beyond the pancreas but without involvement of the celiac axis or the superior mesenteric artery', ''),
('pt3: tumor invades pancreas', 'pT3: Tumor invades pancreas', ''),
('pt3: tumor invades the gallbladder, pancreas, duodenum, or other adjacent organs without involvement of the celiac axis or the superior mesenteric artery', 'pT3: Tumor invades the gallbladder, pancreas, duodenum, or other adjacent organs without involvement of the celiac axis or the superior mesenteric artery', ''),
('pt3: tumor invades through the muscularis propria into the subserosa or into the nonperitonealized perimuscular tissue (mesentery or retroperitoneum) with extension 2 cm or less', 'pT3: Tumor invades through the muscularis propria into the subserosa or into the nonperitonealized perimuscular tissue (mesentery or retroperitoneum) with extension 2 cm or less', ''),
('pt3: tumor invades unilateral branches of the portal vein or hepatic artery', 'pT3: Tumor invades unilateral branches of the portal vein or hepatic artery', ''),
('pt3: tumor perforates serosa (visceral peritoneum) and/or directly invades the liver and/or one other adjacent organ or structure, such as the stomach, duodenum, colon, pancreas, omentum, or extrahepatic bile ducts', 'pT3: Tumor perforates serosa (visceral peritoneum) and/or directly invades the liver and/or one other adjacent organ or structure, such as the stomach, duodenum, colon, pancreas, omentum, or extrahepatic bile ducts', ''),
('pt3: tumor perforating the visceral peritoneum or involving the local extrahepatic structures by direct invasion', 'pT3: Tumor perforating the visceral peritoneum or involving the local extrahepatic structures by direct invasion', ''),
('pt3a: multiple tumors more than 5 cm', 'pT3a: Multiple tumors more than 5 cm', ''),
('pt3b: single tumor or multiple tumors of any size involving a major branch of the portal vein or hepatic veins', 'pT3b: Single tumor or multiple tumors of any size involving a major branch of the portal vein or hepatic veins', ''),
('pt4: tumor invades main portal vein or hepatic artery or invades 2 or more extrahepatic organs or structures', 'pT4: Tumor invades main portal vein or hepatic artery or invades 2 or more extrahepatic organs or structures', ''),
('pt4: tumor invades main portal vein or its branches bilaterally; or the common hepatic artery; or the second-order biliary radicals bilaterally; or unilateral second-order biliary radicals with contralateral portal vein or hepatic artery involvement', 'pT4: Tumor invades main portal vein or its branches bilaterally; or the common hepatic artery; or the second-order biliary radicals bilaterally; or unilateral second-order biliary radicals with contralateral portal vein or hepatic artery involvement', ''),
('pt4: tumor invades peripancreatic soft tissues or other adjacent organs or structures', 'pT4: Tumor invades peripancreatic soft tissues or other adjacent organs or structures', ''),
('pt4: tumor involves the celiac axis or the superior mesenteric artery', 'pT4: Tumor involves the celiac axis or the superior mesenteric artery', ''),
('pt4: tumor with periductal invasion', 'pT4: Tumor with periductal invasion', ''),
('pt4: tumor(s) with direct invasion of adjacent organs other than the gallbladder or with perforation of visceral peritoneum', 'pT4: Tumor(s) with direct invasion of adjacent organs other than the gallbladder or with perforation of visceral peritoneum', ''),
('pt4a: tumor penetrates the visceral peritoneum', 'pT4a: Tumor penetrates the visceral peritoneum', ''),
('pt4b: tumor directly invades other organs or structures', 'pT4b: Tumor directly invades other organs or structures', ''),
('ptis: carcinoma in situ', 'pTis: Carcinoma in situ', ''),
('ptis: carcinoma in situ (intraductal tumor)', 'pTis: Carcinoma in situ (intraductal tumor)', ''),
('ptx: cannot be assessed', 'pTX: Cannot be assessed', '');

insert ignore into i18n (id, en, fr) VALUES
('cap report - small intestine', 'Cap Report - Small Intestine', ''),
('cap peport - perihilar bile duct', 'CAP Report - Perihilar Bile Duct', ''),
('cap report - pancreas exo', 'CAP Report - Pancreas Exo', ''),
('cap report - pancreas endo', 'CAP Report - Pancreas Endo', ''),
('cap report - intrahep bile duct', 'CAP Report - Intrahep Bile Duct', ''),
('cap report - hepato cellular', 'CAP Report - Hepato Cellular', ''),
('cap report - gallbladders', 'CAP Report - Gallbladders', ''),
('cap report - distal ex bile duct', 'CAP Report - Distal Ex Bile Duct', ''),
('cap report - colon/rectum', 'CAP Report - Colon/Rectum', ''),
('cap report - ampulla', 'CAP Report - Ampulla', '');

-- #### revision smintestines #### 

ALTER TABLE dxd_cap_report_smintestines
  CHANGE `other` `other_specimen` tinyint(1) DEFAULT '0',
  CHANGE `other_specify` `other_specimen_specify` varchar(250) DEFAULT NULL;

ALTER TABLE dxd_cap_report_smintestines_revs
  CHANGE `other` `other_specimen` tinyint(1) DEFAULT '0',
  CHANGE `other_specify` `other_specimen_specify` varchar(250) DEFAULT NULL;

UPDATE structure_fields SET field = 'other_specimen' WHERE tablename = 'dxd_cap_report_smintestines' AND field = 'other';
UPDATE structure_fields SET field = 'other_specimen_specify' WHERE tablename = 'dxd_cap_report_smintestines' AND field = 'other_specify';
  
ALTER TABLE dxd_cap_report_smintestines
  CHANGE `not_specified` `specimen_not_specified` tinyint(1) DEFAULT '0',
  
  CHANGE `distance_unit` `distance_unit_from_closest_margin` char(2) DEFAULT NULL,
  CHANGE `specify_margin` `specify_distance_from_closest_margin` varchar(250) DEFAULT NULL,

  CHANGE `distance_unit_bile_duct` `distance_unit_from_closest_margin_bile_duct` char(2) DEFAULT NULL,
  CHANGE `specify_margin_bile_duct` `specify_distance_from_closest_margin_bile_duct` varchar(250) DEFAULT NULL,  
  CHANGE `not_known` `clinical_history_not_known` tinyint(1) NOT NULL DEFAULT '0';
  
ALTER TABLE dxd_cap_report_smintestines_revs
  CHANGE `not_specified` `specimen_not_specified` tinyint(1) DEFAULT '0',
  
  CHANGE `distance_unit` `distance_unit_from_closest_margin` char(2) DEFAULT NULL,
  CHANGE `specify_margin` `specify_distance_from_closest_margin` varchar(250) DEFAULT NULL,

  CHANGE `distance_unit_bile_duct` `distance_unit_from_closest_margin_bile_duct` char(2) DEFAULT NULL,
  CHANGE `specify_margin_bile_duct` `specify_distance_from_closest_margin_bile_duct` varchar(250) DEFAULT NULL,  
  CHANGE `not_known` `clinical_history_not_known` tinyint(1) NOT NULL DEFAULT '0';
  
UPDATE structure_fields SET field = 'specimen_not_specified' WHERE tablename = 'dxd_cap_report_smintestines' AND field = 'not_specified';

UPDATE structure_fields SET field = 'distance_unit_from_closest_margin' WHERE tablename = 'dxd_cap_report_smintestines' AND field = 'distance_unit';
UPDATE structure_fields SET field = 'specify_distance_from_closest_margin' WHERE tablename = 'dxd_cap_report_smintestines' AND field = 'specify_margin';

UPDATE structure_fields SET field = 'distance_unit_from_closest_margin_bile_duct' WHERE tablename = 'dxd_cap_report_smintestines' AND field = 'distance_unit_bile_duct';
UPDATE structure_fields SET field = 'specify_distance_from_closest_margin_bile_duct' WHERE tablename = 'dxd_cap_report_smintestines' AND field = 'specify_margin_bile_duct';

UPDATE structure_fields SET field = 'clinical_history_not_known' WHERE tablename = 'dxd_cap_report_smintestines' AND field = 'not_known';

insert ignore into i18n (id, en, fr)
VALUES ('additional dimension', 'Additional Dimension', '');

UPDATE structure_fields SET language_label = '', language_tag = 'microsatellite instability testing method' WHERE tablename = 'dxd_cap_report_smintestines' AND field = 'microsatellite_instability_testing_method';

UPDATE structure_formats SET language_heading = 'margins : segmental resection or pancreaticoduodenectomy' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_smintestines') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_smintestines' 
AND field = 'proximal_margin'); 

insert ignore into i18n  (id, en) values ('margins : segmental resection or pancreaticoduodenectomy', 'Margins : Segmental Resection or Pancreaticoduodenectomy');

UPDATE structure_formats SET language_heading = 'margins : other' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_smintestines') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_smintestines' 
AND field = 'bile_duct_margin'); 

insert ignore into i18n  (id, en) values ('margins : other', 'Margins : Other');

ALTER TABLE dxd_cap_report_smintestines
  CHANGE `distance_of_invasive_carcinoma_from_closest_margin_bile_duct` `other_distance_of_invasive_carcinoma_from_closest_margin` decimal(3,1) DEFAULT NULL,
  CHANGE `distance_unit_from_closest_margin_bile_duct` `other_distance_unit_from_closest_margin` char(2) DEFAULT NULL,
  CHANGE `specify_distance_from_closest_margin_bile_duct` `other_specify_distance_from_closest_margin` varchar(250) DEFAULT NULL;
ALTER TABLE dxd_cap_report_smintestines_revs
  CHANGE `distance_of_invasive_carcinoma_from_closest_margin_bile_duct` `other_distance_of_invasive_carcinoma_from_closest_margin` decimal(3,1) DEFAULT NULL,
  CHANGE `distance_unit_from_closest_margin_bile_duct` `other_distance_unit_from_closest_margin` char(2) DEFAULT NULL,
  CHANGE `specify_distance_from_closest_margin_bile_duct` `other_specify_distance_from_closest_margin` varchar(250) DEFAULT NULL;

UPDATE structure_fields SET field = 'other_distance_of_invasive_carcinoma_from_closest_margin' WHERE field = 'distance_of_invasive_carcinoma_from_closest_margin_bile_duct' and tablename = 'dxd_cap_report_smintestines';
UPDATE structure_fields SET field = 'other_distance_unit_from_closest_margin' WHERE field = 'distance_unit_from_closest_margin_bile_duct' and tablename = 'dxd_cap_report_smintestines';
UPDATE structure_fields SET field = 'other_specify_distance_from_closest_margin' WHERE field = 'specify_distance_from_closest_margin_bile_duct' and tablename = 'dxd_cap_report_smintestines';

ALTER TABLE dxd_cap_report_smintestines
  CHANGE `specify_distance_from_closest_margin` `specify_margin` varchar(250) DEFAULT NULL,
  CHANGE `other_specify_distance_from_closest_margin` `specify_other_margin` varchar(250) DEFAULT NULL;
ALTER TABLE dxd_cap_report_smintestines_revs
  CHANGE `specify_distance_from_closest_margin` `specify_margin` varchar(250) DEFAULT NULL,
  CHANGE `other_specify_distance_from_closest_margin` `specify_other_margin` varchar(250) DEFAULT NULL;
UPDATE structure_fields 
SET field = 'specify_margin', `language_label` = 'specify margins', `language_tag` = ''
WHERE tablename = 'dxd_cap_report_smintestines' AND field = 'specify_distance_from_closest_margin'; 
UPDATE structure_fields 
SET field = 'specify_other_margin', `language_label` = 'specify margins', `language_tag` = ''
WHERE tablename = 'dxd_cap_report_smintestines' AND field = 'other_specify_distance_from_closest_margin'; 

-- #### revision ampulla of vater ####

UPDATE diagnosis_controls SET controls_type = 'CAP Report - Ampulla of Vater' WHERE controls_type = 'CAP Report - Ampulla';

INSERT IGNORE into i18n (id, en) VALUES ('ampulla of vater','Ampulla Of Vater');
INSERT IGNORE into i18n (id, en) VALUES ('ancillary studies specify','Specify');
INSERT IGNORE into i18n (id, en) VALUES ('carcinoma in situ','Carcinoma In Situ');
INSERT IGNORE into i18n (id, en) VALUES ('distal pancreatic resection margin','Distal Pancreatic Resection Margin');
INSERT IGNORE into i18n (id, en) VALUES ('dysplasia adenoma','Dysplasia Adenoma');
INSERT IGNORE into i18n (id, en) VALUES ('greatest dimension','Greatest Dimension');
INSERT IGNORE into i18n (id, en) VALUES ('intra ampullary','Intra Ampullary');
INSERT IGNORE into i18n (id, en) VALUES ('magins pancreaticoduodenal resection specimen','Magins : Pancreaticoduodenal Resection Specimen');
INSERT IGNORE into i18n (id, en) VALUES ('margins ampullectomy specimen','Margins : Ampullectomy Specimen');
INSERT IGNORE into i18n (id, en) VALUES ('margins involved by invasive carcinoma','Margins Involved By Invasive Carcinoma');
INSERT IGNORE into i18n (id, en) VALUES ('margins uninvolved by invasive carcinoma','Margins Uninvolved By Invasive Carcinoma');
INSERT IGNORE into i18n (id, en) VALUES ('none identified','None Identified');
INSERT IGNORE into i18n (id, en) VALUES ('not performed','Not Performed');
INSERT IGNORE into i18n (id, en) VALUES ('other organ received','Other Organ Received');
INSERT IGNORE into i18n (id, en) VALUES ('pancreatic retroperitoneal margin','Pancreatic Retroperitoneal Margin');
INSERT IGNORE into i18n (id, en) VALUES ('papilla of vater','Papilla Of Vater');
INSERT IGNORE into i18n (id, en) VALUES ('Participant Identifier','Participant Identifier');
INSERT IGNORE into i18n (id, en) VALUES ('peri ampullary','Peri Ampullary');
INSERT IGNORE into i18n (id, en) VALUES ('perineural invasion','Perineural Invasion');
INSERT IGNORE into i18n (id, en) VALUES ('proximal mucosal margin','Proximal Mucosal Margin');
INSERT IGNORE into i18n (id, en) VALUES ('specify','Specify');
INSERT IGNORE into i18n (id, en) VALUES ('specify margins','Specify');
INSERT IGNORE into i18n (id, en) VALUES ('tumor invades duodenal wall','Tumor Invades Duodenal Wall');
INSERT IGNORE into i18n (id, en) VALUES ('tumor invades extrapancreatic common bile duct','Tumor Invades Extrapancreatic Common Bile Duct');
INSERT IGNORE into i18n (id, en) VALUES ('tumor invades other adjacent organ or structures','Tumor Invades Other Adjacent Organ Or Structures');
INSERT IGNORE into i18n (id, en) VALUES ('tumor invades pancreas','Tumor Invades Pancreas');
INSERT IGNORE into i18n (id, en) VALUES ('tumor invades peripancreatic soft tissues','Tumor Invades Peripancreatic Soft Tissues');

INSERT IGNORE into i18n (id, en) VALUES ('tumor limited to ampulla of vater or sphincter of oddi','Tumor Limited To Ampulla Of Vater Or sphincter Of Oddi');
INSERT IGNORE into i18n (id, en) VALUES ('distance of invasive carcinoma from closest margin mm','Distance Of invasive Carcinoma From Closest Margin (mm)');

INSERT IGNORE into i18n (id, en) VALUES ('CAP Report - Ampulla of Vater','CAP Report - Ampulla of Vater');

UPDATE structure_formats SET language_heading = '' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_ampullas') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'stomach');

UPDATE structure_formats SET language_heading = 'procedure' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_ampullas') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'procedure');

ALTER TABLE dxd_cap_report_ampullas
  CHANGE `other` `other_specimen` tinyint(1) DEFAULT '0',
  CHANGE `other_specify` `other_specimen_specify` varchar(250) DEFAULT NULL,
  CHANGE `not_specified` `specimen_not_specified` tinyint(1) DEFAULT '0';
  
ALTER TABLE dxd_cap_report_ampullas_revs
  CHANGE `other` `other_specimen` tinyint(1) DEFAULT '0',
  CHANGE `other_specify` `other_specimen_specify` varchar(250) DEFAULT NULL,
  CHANGE `not_specified` `specimen_not_specified` tinyint(1) DEFAULT '0';
  
UPDATE structure_fields SET field = 'other_specimen' WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'other';
UPDATE structure_fields SET field = 'other_specimen_specify' WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'other_specify';
UPDATE structure_fields SET field = 'specimen_not_specified' WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'not_specified';
   
UPDATE structure_fields SET language_label = 'additional dimension (cm)' WHERE field = 'additional_dimension_a';
UPDATE structure_fields SET language_label = 'tumor size greatest dimension (cm)' WHERE field = 'tumor_size_greatest_dimension';
  
INSERT IGNORE into i18n (id, en) VALUES ('tumor size greatest dimension (cm)', 'Tumor Size Greatest Dimension (cm)');  
INSERT IGNORE into i18n (id, en) VALUES ('additional dimension (cm)', 'Additional Dimension (cm)');  

ALTER TABLE dxd_cap_report_ampullas
  ADD `tumor_site` varchar(50) DEFAULT NULL AFTER `procedure_specify`,
   DROP COLUMN  `intra_ampullary`,
   DROP COLUMN  `peri_ampullary`,
   DROP COLUMN  `papilla_of_vater`,
   DROP COLUMN  `tumor_site_other`,
   DROP COLUMN  `tumor_site_cannot_be_determined`,
   DROP COLUMN  `tumor_site_not_specified`;

ALTER TABLE dxd_cap_report_ampullas_revs
  ADD `tumor_site` varchar(50) DEFAULT NULL AFTER `procedure_specify`,
   DROP COLUMN  `intra_ampullary`,
   DROP COLUMN  `peri_ampullary`,
   DROP COLUMN  `papilla_of_vater`,
   DROP COLUMN  `tumor_site_other`,
   DROP COLUMN  `tumor_site_cannot_be_determined`,
   DROP COLUMN  `tumor_site_not_specified`;
 
DELETE FROM structure_formats WHERE structure_field_id IN (
SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_ampullas' 
AND field IN ('intra_ampullary', 'peri_ampullary', 'papilla_of_vater', 'tumor_site_other', 'tumor_site_cannot_be_determined', 'tumor_site_not_specified') 
);
DELETE FROM structure_fields WHERE tablename = 'dxd_cap_report_ampullas' 
AND field IN ('intra_ampullary', 'peri_ampullary', 'papilla_of_vater', 'tumor_site_other', 'tumor_site_cannot_be_determined', 'tumor_site_not_specified');   
   
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) 
VALUES ('tumour_site_av', '', '', NULL);

SET @value_domain_id = LAST_INSERT_ID();

insert ignore into structure_permissible_values (value, language_alias) values
('intra ampullary', 'intra ampullary'),
('peri ampullary', 'peri ampullary'),
('papilla of vater', 'papilla of vater'),
('other', 'other'),
('cannot be determined', 'cannot be determined'),
('not specified', 'not specified');

insert into structure_value_domains_permissible_values 
(structure_value_domain_id, structure_permissible_value_id, display_order, flag_active)
values 
(@value_domain_id, (select id from structure_permissible_values where value='intra ampullary'), 1,1),
(@value_domain_id, (select id from structure_permissible_values where value='peri ampullary'), 2,1),
(@value_domain_id, (select id from structure_permissible_values where value='papilla of vater'), 3,1),
(@value_domain_id, (select id from structure_permissible_values where value='other'), 4,1),
(@value_domain_id, (select id from structure_permissible_values where value='cannot be determined'), 5,1),
(@value_domain_id, (select id from structure_permissible_values where value='not specified'), 6,1);

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_ampullas', 'tumor_site', 'tumor site', '', 'select', '', '', @value_domain_id, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_ampullas'), 
(SELECT id FROM structure_fields WHERE `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_site'), 
'1', '13', 'tumor site', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

UPDATE structure_fields set language_tag = '', language_label = 'tumor site specify'
WHERE `tablename`='dxd_cap_report_ampullas' AND `field`='tumor_site_other_specify';

UPDATE structure_formats SET flag_override_label = '0', language_label = ''
WHERE structure_id = (SELECT id FROM structures WHERE alias='dx_cap_report_ampullas')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `tablename`='diagnosis_masters' AND `field` IN ('tumor_size_greatest_dimension', 'additional_dimension_a'));

ALTER TABLE diagnosis_masters
  CHANGE `cannot_be_determined` `tumor_size_cannot_be_determined` tinyint(1) DEFAULT '0';
ALTER TABLE diagnosis_masters_revs
  CHANGE `cannot_be_determined` `tumor_size_cannot_be_determined` tinyint(1) DEFAULT '0';

UPDATE structure_fields SET field = 'tumor_size_cannot_be_determined'   
WHERE `model` LIKE 'DiagnosisMaster'
AND `field` LIKE 'cannot_be_determined';

UPDATE structure_formats SET language_heading = 'histologic type' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_ampullas') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_ampullas' 
AND field = 'histologic_type');
UPDATE structure_formats SET language_heading = 'histologic grade' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_ampullas') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters_a' 
AND field = 'tumour_grade');
  
ALTER TABLE dxd_cap_report_ampullas
  CHANGE `cannot_be_assessed` `tumor_extension_cannot_be_assessed` tinyint(1) DEFAULT '0';
  
ALTER TABLE dxd_cap_report_ampullas_revs
  CHANGE `cannot_be_assessed` `tumor_extension_cannot_be_assessed` tinyint(1) DEFAULT '0';
  
UPDATE structure_fields SET field = 'tumor_extension_cannot_be_assessed' WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'cannot_be_assessed';
  
ALTER TABLE dxd_cap_report_ampullas
  CHANGE `margin_cannot_be_assessed` `ampull_spec_margin_cannot_be_assessed` tinyint(1) DEFAULT '0',
  CHANGE `margins_uninvolved_by_invasive_carcinoma` `ampull_spec_margins_uninvolved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',
  CHANGE `distance_of_invasive_carcinoma_from_closest_margin_mm` `ampull_spec_distance_of_invasive_carcinoma_from_closest_margin` decimal(3,1) DEFAULT NULL,
  CHANGE `specify_margin` `ampull_spec_specify_margins_uninvolved` varchar(250) DEFAULT NULL,
  CHANGE `margins_involved_by_invasive_carcinoma` `ampull_spec_margins_involved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',
  CHANGE `specify_margins` `ampull_spec_specify_margins_involved` varchar(250) DEFAULT NULL,
  CHANGE `not_applicable` `ampull_spec_margins_not_applicable` tinyint(1) DEFAULT '0';
  
ALTER TABLE dxd_cap_report_ampullas_revs
  CHANGE `margin_cannot_be_assessed` `ampull_spec_margin_cannot_be_assessed` tinyint(1) DEFAULT '0',
  CHANGE `margins_uninvolved_by_invasive_carcinoma` `ampull_spec_margins_uninvolved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',
  CHANGE `distance_of_invasive_carcinoma_from_closest_margin_mm` `ampull_spec_distance_of_invasive_carcinoma_from_closest_margin` decimal(3,1) DEFAULT NULL,
  CHANGE `specify_margin` `ampull_spec_specify_margins_uninvolved` varchar(250) DEFAULT NULL,
  CHANGE `margins_involved_by_invasive_carcinoma` `ampull_spec_margins_involved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',
  CHANGE `specify_margins` `ampull_spec_specify_margins_involved` varchar(250) DEFAULT NULL,
  CHANGE `not_applicable` `ampull_spec_margins_not_applicable` tinyint(1) DEFAULT '0';

UPDATE structure_fields 
SET field = 'ampull_spec_margin_cannot_be_assessed' 
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'margin_cannot_be_assessed';
UPDATE structure_fields 
SET field = 'ampull_spec_margins_uninvolved_by_invasive_carcinoma' 
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'margins_uninvolved_by_invasive_carcinoma';
UPDATE structure_fields 
SET field = 'ampull_spec_distance_of_invasive_carcinoma_from_closest_margin' 
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'distance_of_invasive_carcinoma_from_closest_margin_mm';
UPDATE structure_fields 
SET field = 'ampull_spec_specify_margins_uninvolved' 
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'specify_margin';
UPDATE structure_fields 
SET field = 'ampull_spec_margins_involved_by_invasive_carcinoma' 
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'margins_involved_by_invasive_carcinoma';
UPDATE structure_fields 
SET field = 'ampull_spec_specify_margins_involved' 
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'specify_margins';
UPDATE structure_fields 
SET field = 'ampull_spec_margins_not_applicable' 
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'not_applicable';

UPDATE structure_fields 
SET language_label = '', language_tag = 'specify margins'
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'ampull_spec_specify_margins_involved'; 
UPDATE structure_fields 
SET language_label = '', language_tag = 'specify margins'
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'ampull_spec_specify_margins_uninvolved'; 
UPDATE structure_fields 
SET language_label = '', language_tag = 'distance from closest margin mm'
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'ampull_spec_distance_of_invasive_carcinoma_from_closest_margin'; 
   
INSERT IGNORE into i18n (id, en) VALUES ('distance from closest margin mm', 'Distance From Closest Margin (mm)'); 
  
UPDATE structure_fields 
SET language_label = '', language_tag = 'unit'
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'distance_unit'; 

ALTER TABLE dxd_cap_report_ampullas
  CHANGE `distance_unit` `distance_unit_of_inv_carc_from_clos_marg` char(2) DEFAULT NULL;
ALTER TABLE dxd_cap_report_ampullas_revs
  CHANGE `distance_unit` `distance_unit_of_inv_carc_from_clos_marg` char(2) DEFAULT NULL;
UPDATE structure_fields 
SET field = 'distance_unit_of_inv_carc_from_clos_marg'
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'distance_unit'; 

ALTER TABLE dxd_cap_report_ampullas
  CHANGE `n_specify_margin` `specify_inv_carc_from_clos_marg` varchar(250) DEFAULT NULL;
ALTER TABLE dxd_cap_report_ampullas_revs
  CHANGE `n_specify_margin` `specify_inv_carc_from_clos_marg` varchar(250) DEFAULT NULL;
UPDATE structure_fields 
SET field = 'specify_inv_carc_from_clos_marg', language_label = '', language_tag = 'specify'
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'n_specify_margin'; 

UPDATE structure_formats SET language_heading = 'invasion' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_ampullas') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_ampullas' 
AND field = 'lymph_vascular_invasion'); 
 
INSERT IGNORE into i18n (id, en) VALUES ('invasion', 'Invasion'); 
  
UPDATE structure_formats SET language_heading = 'ancillary studies' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_ampullas') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_ampullas' 
AND field = 'ancillary_studies_specify'); 

DELETE FROM i18n where id = 'ancillary studies';
INSERT IGNORE into i18n (id, en) VALUES ('ancillary studies', 'Ancillary Studies');

ALTER TABLE dxd_cap_report_ampullas
  CHANGE `not_performed` `ancillary_studies_not_performed` tinyint(1) DEFAULT '0';
ALTER TABLE dxd_cap_report_ampullas_revs
  CHANGE `not_performed` `ancillary_studies_not_performed` tinyint(1) DEFAULT '0';
UPDATE structure_fields 
SET field = 'ancillary_studies_not_performed'
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'not_performed'; 

ALTER TABLE dxd_cap_report_ampullas
  CHANGE `not_known` `clinical_history_not_known` tinyint(1) DEFAULT '0';
ALTER TABLE dxd_cap_report_ampullas_revs
  CHANGE `not_known` `clinical_history_not_known` tinyint(1) DEFAULT '0';
UPDATE structure_fields 
SET field = 'clinical_history_not_known'
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'not_known'; 
  
UPDATE structure_formats SET language_heading = 'other' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_ampullas') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' 
AND field = 'notes');   

UPDATE structure_fields SET language_label = '', language_tag = 'distance of invasive carcinoma from closest margin mm' where tablename = 'dxd_cap_report_ampullas' AND field = 'ampull_spec_distance_of_invasive_carcinoma_from_closest_margin';
  
ALTER TABLE dxd_cap_report_ampullas
  CHANGE `distance_of_invasive_carcinoma_from_closest_margin` `pr_spec_distance_of_invasive_carcinoma_from_closest_margin` decimal(3,1) DEFAULT NULL,  
  CHANGE `distance_unit_of_inv_carc_from_clos_marg` `pr_spec_distance_unit_of_inv_carc_from_clos_marg` char(2) DEFAULT NULL, 
  CHANGE `specify_inv_carc_from_clos_marg` `pr_spec_specify_inv_carc_from_clos_marg` varchar(250) DEFAULT NULL;
ALTER TABLE dxd_cap_report_ampullas_revs
  CHANGE `distance_of_invasive_carcinoma_from_closest_margin` `pr_spec_distance_of_invasive_carcinoma_from_closest_margin` decimal(3,1) DEFAULT NULL,  
  CHANGE `distance_unit_of_inv_carc_from_clos_marg` `pr_spec_distance_unit_of_inv_carc_from_clos_marg` char(2) DEFAULT NULL, 
  CHANGE `specify_inv_carc_from_clos_marg` `pr_spec_specify_inv_carc_from_clos_marg` varchar(250) DEFAULT NULL;
UPDATE structure_fields 
SET field = 'pr_spec_distance_of_invasive_carcinoma_from_closest_margin'
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'distance_of_invasive_carcinoma_from_closest_margin'; 
UPDATE structure_fields 
SET field = 'pr_spec_distance_unit_of_inv_carc_from_clos_marg'
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'distance_unit_of_inv_carc_from_clos_marg'; 
UPDATE structure_fields 
SET field = 'pr_spec_specify_inv_carc_from_clos_marg'
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'specify_inv_carc_from_clos_marg'; 
 
UPDATE structure_fields 
SET `language_label` = 'specify margins', `language_tag` = ''
WHERE tablename = 'dxd_cap_report_ampullas' AND field = 'pr_spec_specify_inv_carc_from_clos_marg';   
  
-- #### revision colon and rectum ####

UPDATE diagnosis_controls SET controls_type = 'cap report - small intestine' WHERE controls_type = 'Cap Report - Small Intestine';
UPDATE diagnosis_controls SET controls_type = 'cap peport - perihilar bile duct' WHERE controls_type = 'CAP Report - Perihilar Bile Duct';
UPDATE diagnosis_controls SET controls_type = 'cap report - pancreas exo' WHERE controls_type = 'CAP Report - Pancreas Exo';
UPDATE diagnosis_controls SET controls_type = 'cap report - pancreas endo' WHERE controls_type = 'CAP Report - Pancreas Endo';
UPDATE diagnosis_controls SET controls_type = 'cap report - intrahep bile duct' WHERE controls_type = 'CAP Report - Intrahep Bile Duct';
UPDATE diagnosis_controls SET controls_type = 'cap report - hepato cellular' WHERE controls_type = 'CAP Report - Hepato Cellular';
UPDATE diagnosis_controls SET controls_type = 'cap report - gallbladders' WHERE controls_type = 'CAP Report - Gallbladders';
UPDATE diagnosis_controls SET controls_type = 'cap report - distal ex bile duct' WHERE controls_type = 'CAP Report - Distal Ex Bile Duct';
UPDATE diagnosis_controls SET controls_type = 'cap report - colon/rectum - excisional biopsy' WHERE controls_type = 'CAP Report - Colon/Rectum';
UPDATE diagnosis_controls SET controls_type = 'cap report - ampulla of vater' WHERE controls_type = 'CAP Report - Ampulla of Vater';

INSERT IGNORE into i18n (id, en) VALUES ('cap report - colon/rectum - excisional biopsy', 'CAP Report - Colon/Rectum (Excisional Biopsy)');

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor site'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_site'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_colons'; 

RENAME TABLE `dxd_cap_report_colons` TO `dxd_cap_report_colon_biopsies` ;
RENAME TABLE `dxd_cap_report_colons_revs` TO `dxd_cap_report_colon_biopsies_revs` ;

UPDATE diagnosis_controls 
SET form_alias = 'dx_cap_report_colon_biopsies', detail_tablename = 'dxd_cap_report_colon_biopsies'
WHERE controls_type = 'cap report - colon/rectum - excisional biopsy';

UPDATE structures SET alias = 'dx_cap_report_colon_biopsies' WHERE alias = 'dx_cap_report_colons';

INSERT IGNORE into i18n (id, en) VALUES ('adenocarcinoma','Adenocarcinoma');
INSERT IGNORE into i18n (id, en) VALUES ('deep margin','Deep Margin');
INSERT IGNORE into i18n (id, en) VALUES ('fragmental','Fragmental');
INSERT IGNORE into i18n (id, en) VALUES ('inflammatory bowel disease','Inflammatory Bowel Disease');
INSERT IGNORE into i18n (id, en) VALUES ('intact','Intact');
INSERT IGNORE into i18n (id, en) VALUES ('involved by adenoma','Involved by Adenoma');
INSERT IGNORE into i18n (id, en) VALUES ('mucosal/Lateral margin','Mucosal/Lateral Margin');
INSERT IGNORE into i18n (id, en) VALUES ('pedunculated with stalk','Pedunculated With Stalk');
INSERT IGNORE into i18n (id, en) VALUES ('polyp configuration','Polyp Configuration');
INSERT IGNORE into i18n (id, en) VALUES ('polyp size','Polyp Size');
INSERT IGNORE into i18n (id, en) VALUES ('polyp size greatest dimension','Polyp Size Greatest Dimension (cm)');
INSERT IGNORE into i18n (id, en) VALUES ('quiescent','Quiescent');
INSERT IGNORE into i18n (id, en) VALUES ('sessile','Sessile');
INSERT IGNORE into i18n (id, en) VALUES ('size of invasive carcinoma','Size of Invasive Carcinoma');
INSERT IGNORE into i18n (id, en) VALUES ('specimen integrity','Specimen Integrity');
INSERT IGNORE into i18n (id, en) VALUES ('stalk length cm','Stalk Length (cm)');
INSERT IGNORE into i18n (id, en) VALUES ('type of polyp in which invasive carcinoma arose','Type of Polyp In Which Invasive Carcinoma Arose');

ALTER TABLE dxd_cap_report_colon_biopsies
  CHANGE `additional_dimension_a` `polyp_size_additional_dimension_a` decimal(3,1) DEFAULT NULL,
  CHANGE `additional_dimension_b` `polyp_size_additional_dimension_b` decimal(3,1) DEFAULT NULL,
  CHANGE `cannot_be_determined` `polyp_size_cannot_be_determined` tinyint(1) DEFAULT '0';
ALTER TABLE dxd_cap_report_colon_biopsies_revs
  CHANGE `additional_dimension_a` `polyp_size_additional_dimension_a` decimal(3,1) DEFAULT NULL,
  CHANGE `additional_dimension_b` `polyp_size_additional_dimension_b` decimal(3,1) DEFAULT NULL,
  CHANGE `cannot_be_determined` `polyp_size_cannot_be_determined` tinyint(1) DEFAULT '0';

UPDATE structure_fields set tablename = 'dxd_cap_report_colon_biopsies' where tablename = 'dxd_cap_report_colons';

UPDATE structure_fields set field = 'polyp_size_additional_dimension_a' where field = 'additional_dimension_a' and  tablename = 'dxd_cap_report_colon_biopsies';
UPDATE structure_fields set field = 'polyp_size_additional_dimension_b' where field = 'additional_dimension_b' and  tablename = 'dxd_cap_report_colon_biopsies';
UPDATE structure_fields set field = 'polyp_size_cannot_be_determined' where field = 'cannot_be_determined' and  tablename = 'dxd_cap_report_colon_biopsies';

UPDATE structure_fields SET language_label = 'polyp_size_greatest_dimension (cm)' WHERE field = 'polyp_size_greatest_dimension';
INSERT IGNORE into i18n (id, en) VALUES ('polyp_size_greatest_dimension (cm)','Polyp Size Greatest Dimension (cm)');

UPDATE structure_formats SET flag_override_label = '0', language_label = ''
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_colon_biopsies') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' 
AND field = 'additional_dimension_a');  

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='histologic type '
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_site'
and sfo.structure_id=s.id
and s.alias='dx_cap_report_colons'; 

UPDATE structure_formats SET language_heading='histologic type'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_colon_biopsies') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_colon_biopsies' 
AND field = 'histologic_type');  

UPDATE structure_formats SET language_heading='microscopic tumor extension'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_colon_biopsies') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_colon_biopsies' 
AND field = 'microscopic_tumor_extension'); 

UPDATE structure_formats SET language_heading='lymph vascular invasion'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_colon_biopsies') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_colon_biopsies' 
AND field = 'lymph_vascular_invasion'); 

UPDATE structure_formats SET language_heading='type of polyp in which invasive carcinoma arose'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_colon_biopsies') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_colon_biopsies' 
AND field = 'type_of_polyp_in_which_invasive_carcinoma_arose'); 

ALTER TABLE dxd_cap_report_colon_biopsies
  CHANGE `cannot_be_assessed` `dm_cannot_be_assessed` tinyint(1) DEFAULT '0',
  CHANGE `uninvolved_by_invasive_carcinoma` `dm_uninvolved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',
  CHANGE `involved_by_invasive_carcinoma` `dm_involved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',

  CHANGE `not_applicable` `mm_not_applicable` tinyint(1) DEFAULT '0';

ALTER TABLE dxd_cap_report_colon_biopsies_revs
  CHANGE `cannot_be_assessed` `dm_cannot_be_assessed` tinyint(1) DEFAULT '0',
  CHANGE `uninvolved_by_invasive_carcinoma` `dm_uninvolved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',
  CHANGE `involved_by_invasive_carcinoma` `dm_involved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',

  CHANGE `not_applicable` `mm_not_applicable` tinyint(1) DEFAULT '0';

UPDATE structure_fields SET field = 'dm_cannot_be_assessed' WHERE field = 'cannot_be_assessed' and tablename = 'dxd_cap_report_colon_biopsies';
UPDATE structure_fields SET field = 'dm_uninvolved_by_invasive_carcinoma' WHERE field = 'uninvolved_by_invasive_carcinoma' and tablename = 'dxd_cap_report_colon_biopsies';
UPDATE structure_fields SET field = 'dm_involved_by_invasive_carcinoma' WHERE field = 'involved_by_invasive_carcinoma' and tablename = 'dxd_cap_report_colon_biopsies';

UPDATE structure_fields SET field = 'mm_not_applicable' WHERE field = 'not_applicable' and tablename = 'dxd_cap_report_colon_biopsies';

UPDATE structure_formats SET language_heading = 'other' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_colon_biopsies') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' 
AND field = 'notes'); 

UPDATE structure_formats SET language_heading = 'ancillary studies' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_colon_biopsies') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_colon_biopsies' 
AND field = 'ancillary_studies_specify'); 

ALTER TABLE dxd_cap_report_colon_biopsies
  CHANGE `not_performed` `ancillary_studies_not_performed` tinyint(1) DEFAULT '0';
ALTER TABLE dxd_cap_report_colon_biopsies_revs
  CHANGE `not_performed` `ancillary_studies_not_performed` tinyint(1) DEFAULT '0';

UPDATE structure_fields SET field = 'ancillary_studies_not_performed' WHERE field = 'not_performed' and tablename = 'dxd_cap_report_colon_biopsies';

UPDATE structure_fields SET language_label = 'histologic grade' WHERE tablename = 'diagnosis_masters_c' and field = 'tumour_grade';

UPDATE structure_formats SET language_heading = 'histologic grade' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_colon_biopsies') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters_c' 
AND field = 'tumour_grade'); 
 	
DELETE FROM i18n WHERE id = 'CAP Report - Ampulla of Vater';
INSERT IGNORE into i18n (id, en) VALUES ('cap report - ampulla of vater','CAP Report - Ampulla of Vater');

ALTER TABLE dxd_cap_report_colon_biopsies
  ADD `deep_margin` varchar(50) DEFAULT NULL AFTER `microscopic_tumor_extension`,
  ADD `mucosal_lateral_margin` varchar(50) DEFAULT NULL AFTER `distance_of_invasive_carcinoma_from_closest_margin_mm`,
  DROP COLUMN  `dm_cannot_be_assessed`,
  DROP COLUMN  `dm_uninvolved_by_invasive_carcinoma`,
  DROP COLUMN  `dm_involved_by_invasive_carcinoma`,
  DROP COLUMN  `mm_not_applicable`,
  DROP COLUMN  `mm_uninvolved_by_invasive_carcinoma`,
  DROP COLUMN  `mm_involved_by_invasive_carcinoma`,
  DROP COLUMN  `mm_involved_by_adenoma`,
  DROP COLUMN  `mm_cannot_be_assessed`;
ALTER TABLE dxd_cap_report_colon_biopsies_revs
  ADD `deep_margin` varchar(50) DEFAULT NULL AFTER `microscopic_tumor_extension`,
  ADD `mucosal_lateral_margin` varchar(50) DEFAULT NULL AFTER `distance_of_invasive_carcinoma_from_closest_margin_mm`,
  DROP COLUMN  `dm_cannot_be_assessed`,
  DROP COLUMN  `dm_uninvolved_by_invasive_carcinoma`,
  DROP COLUMN  `dm_involved_by_invasive_carcinoma`,
  DROP COLUMN  `mm_not_applicable`,
  DROP COLUMN  `mm_uninvolved_by_invasive_carcinoma`,
  DROP COLUMN  `mm_involved_by_invasive_carcinoma`,
  DROP COLUMN  `mm_involved_by_adenoma`,
  DROP COLUMN  `mm_cannot_be_assessed`;

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_colon_biopsies' 
AND field IN ('dm_cannot_be_assessed', 'dm_uninvolved_by_invasive_carcinoma', 'dm_involved_by_invasive_carcinoma', 
'mm_not_applicable', 'mm_uninvolved_by_invasive_carcinoma', 'mm_involved_by_invasive_carcinoma', 'mm_involved_by_adenoma', 'mm_cannot_be_assessed')); 
DELETE FROM structure_fields WHERE tablename = 'dxd_cap_report_colon_biopsies' 
AND field IN ('dm_cannot_be_assessed', 'dm_uninvolved_by_invasive_carcinoma', 'dm_involved_by_invasive_carcinoma', 
'mm_not_applicable', 'mm_uninvolved_by_invasive_carcinoma', 'mm_involved_by_invasive_carcinoma', 'mm_involved_by_adenoma', 'mm_cannot_be_assessed');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) 
VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colon_biopsies', 'deep_margin', 'deep margin', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'margin_cannot') , '', 'open', 'open', 'open'); 
SET @id = LAST_INSERT_ID();
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_colon_biopsies'), @id, 
'2', '22', 'margins', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'); 

insert ignore into structure_permissible_values (value, language_alias) values ('involved by adenoma','involved by adenoma');

insert into `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
values ('margin_0_2', 'open', '', null);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values 
((select id from structure_value_domains where domain_name='margin_0_2'), 
(select id from structure_permissible_values where value='not applicable' ), 1,1, 'not applicable'),
((select id from structure_value_domains where domain_name='margin_0_2'), 
(select id from structure_permissible_values where value='cannot be assessed' ), 2,1, 'cannot be assessed'),
((select id from structure_value_domains where domain_name='margin_0_2'), 
(select id from structure_permissible_values where value='uninvolved by invasive carcinoma' ), 3,1, 'uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='margin_0_2'), 
(select id from structure_permissible_values where value='involved by invasive carcinoma' ), 4,1, 'involved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='margin_0_2'), 
(select id from structure_permissible_values where value='involved by adenoma' ), 5,1, 'involved by adenoma');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) 
VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_colon_biopsies', 'mucosal_lateral_margin', 'mucosal lateral margin', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'margin_0_2') , '', 'open', 'open', 'open'); 
SET @id = LAST_INSERT_ID();
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_colon_biopsies'), @id, 
'2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'); 

insert ignore into i18n  (id, en) values ('mucosal lateral margin', 'Mucosal Lateral Margin');


UPDATE structure_fields SET language_tag = language_label, language_label = '' WHERE tablename = 'dxd_cap_report_colon_biopsies' and field = 'distance_of_invasive_carcinoma_from_closest_margin_mm';









-- #### revision of bile ducts ####

ALTER TABLE dxd_cap_report_distalexbileducts
  CHANGE `not_specified` `specimen_not_specified` tinyint(1) DEFAULT '0',
  CHANGE `other` `other_organ_other` tinyint(1) DEFAULT '0',
  CHANGE `other_specify` `other_organ_other_specify` varchar(250) DEFAULT NULL;
ALTER TABLE dxd_cap_report_distalexbileducts_revs
  CHANGE `not_specified` `specimen_not_specified` tinyint(1) DEFAULT '0',
  CHANGE `other` `other_organ_other` tinyint(1) DEFAULT '0',
  CHANGE `other_specify` `other_organ_other_specify` varchar(250) DEFAULT NULL;

UPDATE structure_fields SET field = 'specimen_not_specified' WHERE field = 'not_specified' and tablename = 'dxd_cap_report_distalexbileducts';
UPDATE structure_fields SET field = 'other_organ_other' WHERE field = 'other' and tablename = 'dxd_cap_report_distalexbileducts';
UPDATE structure_fields SET field = 'other_organ_other_specify' WHERE field = 'other_specify' and tablename = 'dxd_cap_report_distalexbileducts';

UPDATE structure_formats SET language_heading = 'other organs received' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_distalexbileducts' 
AND field = 'stomach'); 

UPDATE structure_formats SET language_heading = 'procedure' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_distalexbileducts' 
AND field = 'procedure'); 

UPDATE structure_formats SET flag_override_label = '0', language_label = ''
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' 
AND field = 'tumor_size_greatest_dimension');  
UPDATE structure_formats SET flag_override_label = '0', language_label = ''
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' 
AND field = 'additional_dimension_a');  

UPDATE structure_formats SET language_heading = 'histologic type' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_distalexbileducts' 
AND field = 'histologic_type');  

UPDATE structure_formats SET language_heading = 'histologic grade' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters_dbd' 
AND field = 'tumour_grade'); 

insert ignore into i18n  (id, en) values ('right hepatic duct','Right Hepatic Duct');
insert ignore into i18n  (id, en) values ('left hepatic duct','Left Hepatic Duct');
insert ignore into i18n  (id, en) values ('junction of right and left hepatic ducts','Junction of Right and Left Hepatic Ducts');
insert ignore into i18n  (id, en) values ('common hepatic duct','Common Hepatic Duct');
insert ignore into i18n  (id, en) values ('cystic duct','Cystic Duct');
insert ignore into i18n  (id, en) values ('other organs received','Other Organs Received');
insert ignore into i18n  (id, en) values ('pancreas','Pancreas');
insert ignore into i18n  (id, en) values ('extrapancreatic','Extrapancreatic');
insert ignore into i18n  (id, en) values ('intrapancreatic','Intrapancreatic');
insert ignore into i18n  (id, en) values ('tumor confined to the bile duct histologically','Tumor Confined to The Bile Duct Histologically');
insert ignore into i18n  (id, en) values ('tumor invades beyond the wall of the bile duct','Tumor Invades Beyond The Wall of The Bile Duct');
insert ignore into i18n  (id, en) values ('tumor invades other adjacent structures','Tumor Invades Other Adjacent Structures');
insert ignore into i18n  (id, en) values ('tumor invades the duodenum','Tumor Invades The Duodenum');
insert ignore into i18n  (id, en) values ('tumor invades the gallbladder','Tumor Invades The Gallbladder');
insert ignore into i18n  (id, en) values ('tumor invades the pancreas','Tumor Invades The Pancreas');
insert ignore into i18n  (id, en) values (' specify',' Specify');
insert ignore into i18n  (id, en) values ('proximal bile duct margin','Proximal Bile Duct Margin');
insert ignore into i18n  (id, en) values ('distal bile duct margin','Distal Bile Duct Margin');
insert ignore into i18n  (id, en) values ('dysplasia carcinoma in situ not identified at bile duct margin','Dysplasia carcinoma in situ not identified at bile duct margin');
insert ignore into i18n  (id, en) values ('dysplasia carcinoma in situ present at bile duct margin','Dysplasia carcinoma in situ present at bile duct margin');
insert ignore into i18n  (id, en) values ('pancreaticoduodenal resection specimen','Pancreaticoduodenal Resection Specimen');
insert ignore into i18n  (id, en) values ('distal pancreatic margin','Distal Pancreatic Margin');
insert ignore into i18n  (id, en) values ('biliary stones','Biliary Stones');
insert ignore into i18n  (id, en) values ('choledochal cyst','Choledochal Cyst');
insert ignore into i18n  (id, en) values ('dysplasia','Dysplasia');
insert ignore into i18n  (id, en) values ('primary sclerosing cholangitis','Primary Sclerosing Cholangitis');
insert ignore into i18n  (id, en) values ('primary sclerosing cholangitis PSC','Primary Sclerosing Cholangitis PSC');
insert ignore into i18n  (id, en) values ('stones','Stones');

ALTER TABLE dxd_cap_report_distalexbileducts
  CHANGE `cannot_be_assessed` `seg_res_margins_cannot_be_assessed` tinyint(1) DEFAULT '0',
  CHANGE `margins_uninvolved_by_invasive_carcinoma` `seg_res_margins_uninvolved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',
  CHANGE `distance_of_invasive_carcinoma_from_closest_margin_mm` `seg_res_distance_of_invasive_carcinoma_from_closest_margin_mm` decimal(3,1) DEFAULT NULL,
  CHANGE `specify_margin` `seg_res_specify_uninvolved_margin` varchar(250) DEFAULT NULL,
  CHANGE `margins_involved_by_invasive_carcinoma` `seg_res_margins_involved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',
  CHANGE `proximal_bile_duct_margin` `seg_res_proximal_bile_duct_margin` tinyint(1) DEFAULT '0',
  CHANGE `distal_bile_duct_margin` `seg_res_distal_bile_duct_margin` tinyint(1) DEFAULT '0',
  CHANGE `margin_other` `seg_res_involved_margin_other` tinyint(1) DEFAULT '0',
  CHANGE `margin_other_specify` `seg_res_involved_margin_other_specify` varchar(250) DEFAULT NULL;
ALTER TABLE dxd_cap_report_distalexbileducts_revs
  CHANGE `cannot_be_assessed` `seg_res_margins_cannot_be_assessed` tinyint(1) DEFAULT '0',
  CHANGE `margins_uninvolved_by_invasive_carcinoma` `seg_res_margins_uninvolved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',
  CHANGE `distance_of_invasive_carcinoma_from_closest_margin_mm` `seg_res_distance_of_invasive_carcinoma_from_closest_margin_mm` decimal(3,1) DEFAULT NULL,
  CHANGE `specify_margin` `seg_res_specify_uninvolved_margin` varchar(250) DEFAULT NULL,
  CHANGE `margins_involved_by_invasive_carcinoma` `seg_res_margins_involved_by_invasive_carcinoma` tinyint(1) DEFAULT '0',
  CHANGE `proximal_bile_duct_margin` `seg_res_proximal_bile_duct_margin` tinyint(1) DEFAULT '0',
  CHANGE `distal_bile_duct_margin` `seg_res_distal_bile_duct_margin` tinyint(1) DEFAULT '0',
  CHANGE `margin_other` `seg_res_involved_margin_other` tinyint(1) DEFAULT '0',
  CHANGE `margin_other_specify` `seg_res_involved_margin_other_specify` varchar(250) DEFAULT NULL;
  
UPDATE structure_fields SET field = 'seg_res_margins_cannot_be_assessed' 
WHERE field = 'cannot_be_assessed' and tablename = 'dxd_cap_report_distalexbileducts';

UPDATE structure_fields SET field = 'seg_res_margins_uninvolved_by_invasive_carcinoma' 
WHERE field = 'margins_uninvolved_by_invasive_carcinoma' and tablename = 'dxd_cap_report_distalexbileducts'; 
UPDATE structure_fields SET field = 'seg_res_distance_of_invasive_carcinoma_from_closest_margin_mm' , language_tag = language_label, language_label = ''
WHERE field = 'distance_of_invasive_carcinoma_from_closest_margin_mm' and tablename = 'dxd_cap_report_distalexbileducts';  
UPDATE structure_fields SET field = 'seg_res_specify_uninvolved_margin', language_tag = language_label, language_label = '' 
WHERE field = 'specify_margin' and tablename = 'dxd_cap_report_distalexbileducts';  

UPDATE structure_fields SET field = 'seg_res_margins_involved_by_invasive_carcinoma' 
WHERE field = 'margins_involved_by_invasive_carcinoma' and tablename = 'dxd_cap_report_distalexbileducts';  
UPDATE structure_fields SET field = 'seg_res_proximal_bile_duct_margin', language_tag = language_label, language_label = ''  
WHERE field = 'proximal_bile_duct_margin' and tablename = 'dxd_cap_report_distalexbileducts';  
UPDATE structure_fields SET field = 'seg_res_distal_bile_duct_margin' , language_tag = language_label, language_label = ''  
WHERE field = 'distal_bile_duct_margin' and tablename = 'dxd_cap_report_distalexbileducts';  
UPDATE structure_fields SET field = 'seg_res_involved_margin_other' , language_tag = language_label, language_label = ''  
WHERE field = 'margin_other' and tablename = 'dxd_cap_report_distalexbileducts';  
UPDATE structure_fields SET field = 'seg_res_involved_margin_other_specify' 
WHERE field = 'margin_other_specify' and tablename = 'dxd_cap_report_distalexbileducts';   
  
UPDATE structure_formats SET language_heading = 'margins : segmental resection specimen' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_distalexbileducts' 
AND field = 'seg_res_margins_cannot_be_assessed'); 

insert ignore into i18n (id,en) values ('margins : segmental resection specimen', 'Margins : segmental Resection Specimen'); 
  
UPDATE structure_formats SET display_column = '2' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_distalexbileducts' 
AND field IN ('seg_res_margins_cannot_be_assessed', 'seg_res_margins_uninvolved_by_invasive_carcinoma', 'seg_res_distance_of_invasive_carcinoma_from_closest_margin_mm',
'seg_res_specify_uninvolved_margin', 'seg_res_margins_involved_by_invasive_carcinoma')); 
  
ALTER TABLE dxd_cap_report_distalexbileducts
  CHANGE `distance_of_invasive_carcinoma_from_closest_margin` `other_margins_distance_of_invasive_carcinoma_from_closest_margin` decimal(3,1) DEFAULT NULL,
  CHANGE `distance_unit` `other_margins_distance_unit` char(2) DEFAULT NULL,
  CHANGE `n_specify_margin` `other_margins_specify` varchar(250) DEFAULT NULL;
ALTER TABLE dxd_cap_report_distalexbileducts_revs
  CHANGE `distance_of_invasive_carcinoma_from_closest_margin` `other_margins_distance_of_invasive_carcinoma_from_closest_margin` decimal(3,1) DEFAULT NULL,
  CHANGE `distance_unit` `other_margins_distance_unit` char(2) DEFAULT NULL,
  CHANGE `n_specify_margin` `other_margins_specify` varchar(250) DEFAULT NULL;
   
UPDATE structure_formats SET language_heading = 'margins : pancreaticoduodenal resection specimen' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_distalexbileducts' 
AND field IN ('proximal_margin')); 
insert ignore into i18n (id,en) values ('margins : pancreaticoduodenal resection specimen', 'Margins : Pancreaticoduodenal Resection Specimen');  

UPDATE structure_fields SET field = 'other_margins_distance_of_invasive_carcinoma_from_closest_margin' 
WHERE field = 'distance_of_invasive_carcinoma_from_closest_margin' and tablename = 'dxd_cap_report_distalexbileducts';  
UPDATE structure_fields SET field = 'other_margins_distance_unit' , language_tag = language_label, language_label = ''
WHERE field = 'distance_unit' and tablename = 'dxd_cap_report_distalexbileducts';  
UPDATE structure_fields SET field = 'other_margins_specify' 
WHERE field = 'n_specify_margin' and tablename = 'dxd_cap_report_distalexbileducts';  

UPDATE structure_formats SET language_heading = '' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_distalexbileducts' 
AND field IN ('other_margins_distance_of_invasive_carcinoma_from_closest_margin')); 

UPDATE structure_formats SET language_heading = 'invasions' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_distalexbileducts' 
AND field IN ('lymph_vascular_invasion')); 

insert ignore into i18n (id,en) values ('invasions', 'Invasions');

UPDATE structure_formats
SET structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_distalexbileducts' AND field = 'additional_path_other_specify')
WHERE structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_distalexbileducts' AND field = 'other_clinical_history_specify')
AND display_order = '75';

UPDATE structure_formats SET language_heading = 'ancillary studies' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_distalexbileducts' 
AND field IN ('ancillary_studies_specify')); 

UPDATE structure_formats SET language_heading = 'other' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_distalexbileducts') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model = 'DiagnosisMaster' 
AND field IN ('notes')); 

-- #### revision of gallblader ####

ALTER TABLE dxd_cap_report_gallbladders
  CHANGE `other` `other_specimen` tinyint(1) DEFAULT '0',
  CHANGE `other_specify` `other_specimen_specify` varchar(250) DEFAULT NULL,
  CHANGE `not_specified` `specimen_not_specified` tinyint(1) DEFAULT '0';
ALTER TABLE dxd_cap_report_gallbladders_revs
  CHANGE `other` `other_specimen` tinyint(1) DEFAULT '0',
  CHANGE `other_specify` `other_specimen_specify` varchar(250) DEFAULT NULL,
  CHANGE `not_specified` `specimen_not_specified` tinyint(1) DEFAULT '0'; 
UPDATE structure_fields SET field = 'other_specimen' 
WHERE field = 'other' and tablename = 'dxd_cap_report_gallbladders';
UPDATE structure_fields SET field = 'other_specimen_specify' 
WHERE field = 'other_specify' and tablename = 'dxd_cap_report_gallbladders';
UPDATE structure_fields SET field = 'specimen_not_specified' 
WHERE field = 'not_specified' and tablename = 'dxd_cap_report_gallbladders';

ALTER TABLE dxd_cap_report_gallbladders
  CHANGE `cannot_be_determined` `tumor_site_cannot_be_determined` tinyint(1) DEFAULT '0';
ALTER TABLE dxd_cap_report_gallbladders_revs
  CHANGE `cannot_be_determined` `tumor_site_cannot_be_determined` tinyint(1) DEFAULT '0';
UPDATE structure_fields SET field = 'tumor_site_cannot_be_determined' 
WHERE field = 'cannot_be_determined' and tablename = 'dxd_cap_report_gallbladders';

UPDATE structure_formats SET flag_override_label = '0', language_label = ''
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' 
AND field IN ('additional_dimension_a', 'tumor_size_greatest_dimension'));  

UPDATE structure_formats SET language_heading = 'histologic type'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_gallbladders' 
AND field = 'histologic_type');  

UPDATE structure_formats SET language_heading = 'histologic grade'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters_gb' 
AND field = 'tumour_grade');  

UPDATE structure_formats SET language_heading = 'microscopic tumor extension'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_gallbladders' 
AND field = 'microscopic_tumor_extension');  

ALTER TABLE dxd_cap_report_gallbladders
  CHANGE `cannot_be_assessed` `margin_cannot_be_assessed` tinyint(1) DEFAULT '0',
  CHANGE `specify_margin` `specify_uninvolved_margin` varchar(250) DEFAULT NULL,
  CHANGE `specify_margins` `specify_involved_margin` varchar(250) DEFAULT NULL;
ALTER TABLE dxd_cap_report_gallbladders_revs
  CHANGE `cannot_be_assessed` `margin_cannot_be_assessed` tinyint(1) DEFAULT '0',
  CHANGE `specify_margin` `specify_uninvolved_margin` varchar(250) DEFAULT NULL,
  CHANGE `specify_margins` `specify_involved_margin` varchar(250) DEFAULT NULL;
UPDATE structure_fields SET field = 'margin_cannot_be_assessed' 
WHERE field = 'cannot_be_assessed' and tablename = 'dxd_cap_report_gallbladders';
UPDATE structure_fields SET field = 'specify_uninvolved_margin' 
WHERE field = 'specify_margin' and tablename = 'dxd_cap_report_gallbladders';
UPDATE structure_fields SET field = 'specify_involved_margin' 
WHERE field = 'specify_margins' and tablename = 'dxd_cap_report_gallbladders';
UPDATE structure_formats SET language_heading = 'margins'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_gallbladders' 
AND field = 'margin_cannot_be_assessed');  

UPDATE structure_fields SET language_tag = language_label, language_label = '' 
WHERE tablename = 'dxd_cap_report_gallbladders' AND 
field IN ('distance_of_invasive_carcinoma_from_closest_margin_mm', 'specify_uninvolved_margin', 'specify_involved_margin');

UPDATE structure_formats SET language_heading = 'invasions'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_gallbladders' 
AND field = 'lymph_vascular_invasion');  

ALTER TABLE dxd_cap_report_gallbladders
  CHANGE `none_identified` `additional_path_none_identified` tinyint(1) DEFAULT '0',
  CHANGE `not_performed` `ancillary_studies_not_performed` tinyint(1) DEFAULT '0';
ALTER TABLE dxd_cap_report_gallbladders_revs
  CHANGE `none_identified` `additional_path_none_identified` tinyint(1) DEFAULT '0',
  CHANGE `not_performed` `ancillary_studies_not_performed` tinyint(1) DEFAULT '0';
UPDATE structure_fields SET field = 'additional_path_none_identified' 
WHERE field = 'none_identified' and tablename = 'dxd_cap_report_gallbladders';
 UPDATE structure_fields SET field = 'ancillary_studies_not_performed' 
WHERE field = 'not_performed' and tablename = 'dxd_cap_report_gallbladders';
   
UPDATE structure_formats SET language_heading = 'ancillary studies'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_gallbladders' 
AND field = 'ancillary_studies_specify');  
  
UPDATE structure_formats SET language_heading = 'other' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_gallbladders') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model = 'DiagnosisMaster' 
AND field IN ('notes'));   
  
insert ignore into i18n (id,en) values
('liver', 'Liver'),
('extrahepatic bile duct', 'Extrahepatic Bile Duct'),
('fundus', 'Fundus'),
('body', 'Body'),
('neck', 'Neck'),
('free peritoneal side of gallbladder', 'Free Peritoneal Side of Gallbladder'),
('hepatic side of gallbladder', 'Hepatic Side of Gallbladder'),
('cystic duct margin uninvolved by intramucosal carcinoma', 'Cystic Duct Margin Uninvolved By Intramucosal Carcinoma'),
('cystic duct margin involved by intramucosal carcinoma', 'Cystic Duct Margin Involved By Intramucosal Carcinoma'),
('cholelithiasis', 'Cholelithiasis'),
('chronic cholecystitis', 'Chronic Cholecystitis'),
('acute cholecystitis', 'Acute Cholecystitis'),
('intestinal metaplasia', 'Intestinal Metaplasia'),
('diffuse calcification porcelain gallbladder', 'Diffuse Calcification Porcelain Gallbladder'),
('cholelithiasis', 'Cholelithiasis');

-- #### revision of hepatocellular carcinoma ####

RENAME TABLE `dxd_cap_report_hepatocellulars` TO `dxd_cap_report_hepatocellular_carcinomas` ;
RENAME TABLE `dxd_cap_report_hepatocellulars_revs` TO `dxd_cap_report_hepatocellular_carcinomas_revs` ;

UPDATE diagnosis_controls 
SET form_alias = 'dx_cap_report_hepatocellular_carcinomas', detail_tablename = 'dxd_cap_report_hepatocellular_carcinomas', controls_type = 'cap report - hepato cellular carcinoma'
WHERE controls_type = 'cap report - hepato cellular';

UPDATE structures SET alias = 'dx_cap_report_hepatocellular_carcinomas' WHERE alias = 'dx_cap_report_hepatocellulars';

UPDATE structure_fields set tablename = 'dxd_cap_report_hepatocellular_carcinomas' where tablename = 'dxd_cap_report_hepatocellulars';

insert ignore into i18n (id,en) values
('cap report - hepato cellular carcinoma', 'CAP Report - Hepato Cellular Carcinoma');

insert ignore into i18n (id,en) values
('alcoholic liver disease','Alcoholic Liver Disease'),
('chronic hepatitis','Chronic Hepatitis'),
('cirrhosis','Cirrhosis'),
('cirrhosis severe fibrosis','Cirrhosis Severe Fibrosis'),
('hepatitis b infection','Hepatitis B Infection'),
('hepatitis c infection','Hepatitis C Infection'),
('hepatocellular dysplasia','Hepatocellular Dysplasia'),
('hereditary hemochromatosis','Hereditary Hemochromatosis'),
('high grade dysplastic nodule','High Grade Dysplastic Nodule'),
('iron overload','Iron Overload'),
('low grade dysplastic nodule','Low Grade Dysplastic Nodule'),
('lymph vascular large vessel invasion','Lymph Vascular Large Vessel Invasion'),
('lymph vascular small vessel invasion','Lymph Vascular Small Vessel Invasion'),
('major hepatectomy 3 segments or more','Major Hepatectomy (3 segments or more)'),
('minor hepatectomy less than 3 segments','Minor Hepatectomy (Less than 3 segments)'),
('multiple','Multiple'),
('none to moderate fibrosis','None To Moderate Fibrosis'),
('obesity','Obesity'),
('other','Other'),
('other margin','Other Margin'),
('parenchymal margin','Parenchymal Margin'),
('partial hepatectomy','Partial Hepatectomy'),
('procedure not specified','Procedure Not Specified'),
('solitary','solitary'),
('specify etiology','Specify Etiology'),
('specify location','Specify Location'),
('specify locations','Specify Locations'),
('steatosis','Steatosis'),
('tumor confined to liver','Tumor Confined To Liver'),
('tumor directly invades gallbladder','Tumor Directly Invades Gallbladder'),
('tumor directly invades other adjacent organs','Tumor Directly Invades Other Adjacent Organs'),
('tumor focality','Tumor Focality'),
('tumor involves 1 or more hepatic veins','Tumor Involves 1 or More Hepatic Veins'),
('tumor involves a major branch of the portal vein','Tumor Involves a Major Branch of The Portal Vein'),
('tumor involves visceral peritoneum','Tumor Involves Visceral Peritoneum'),
('wedge resection','Wedge Resection');

ALTER TABLE dxd_cap_report_hepatocellular_carcinomas
  CHANGE `other` `other_specimen` tinyint(1) DEFAULT '0',
  CHANGE `other_specify` `other_specimen_specify` varchar(250) DEFAULT NULL,
  CHANGE `not_specified` `specimen_not_specified` tinyint(1) DEFAULT '0';
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas_revs
  CHANGE `other` `other_specimen` tinyint(1) DEFAULT '0',
  CHANGE `other_specify` `other_specimen_specify` varchar(250) DEFAULT NULL,
  CHANGE `not_specified` `specimen_not_specified` tinyint(1) DEFAULT '0';
UPDATE structure_fields SET field = 'other_specimen' 
WHERE field = 'other' and tablename = 'dxd_cap_report_hepatocellular_carcinomas';
UPDATE structure_fields SET field = 'other_specimen_specify' 
WHERE field = 'other_specify' and tablename = 'dxd_cap_report_hepatocellular_carcinomas';
UPDATE structure_fields SET field = 'specimen_not_specified' 
WHERE field = 'not_specified' and tablename = 'dxd_cap_report_hepatocellular_carcinomas';

UPDATE structure_fields SET language_tag = language_label, language_label = '' 
WHERE tablename = 'dxd_cap_report_hepatocellular_carcinomas' AND 
field IN ('major_hepatectomy_3_segments_or_more', 'minor_hepatectomy_less_than_3_segments');

UPDATE structure_formats SET flag_override_label = '0', language_label = ''
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellular_carcinomas') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' 
AND field IN ('additional_dimension_a', 'tumor_size_greatest_dimension'));  

UPDATE i18n set en = 'Solitary' where id = 'solitary';

ALTER TABLE dxd_cap_report_hepatocellular_carcinomas
  CHANGE `solitary` `solitary_focality` tinyint(1) DEFAULT '0',
  CHANGE `specify_location`  `specify_solitary_focality_location` varchar(250) DEFAULT NULL,
  CHANGE `multiple` `multiple_focality` tinyint(1) DEFAULT '0',
  CHANGE `specify_locations` `specify_multiple_focality_location`  varchar(250) DEFAULT NULL;
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas_revs
  CHANGE `solitary` `solitary_focality` tinyint(1) DEFAULT '0',
  CHANGE `specify_location`  `specify_solitary_focality_location` varchar(250) DEFAULT NULL,
  CHANGE `multiple` `multiple_focality` tinyint(1) DEFAULT '0',
  CHANGE `specify_locations` `specify_multiple_focality_location`  varchar(250) DEFAULT NULL; 
UPDATE structure_fields SET field = 'solitary_focality' 
WHERE field = 'solitary' and tablename = 'dxd_cap_report_hepatocellular_carcinomas';
UPDATE structure_fields SET field = 'specify_solitary_focality_location' 
WHERE field = 'specify_location' and tablename = 'dxd_cap_report_hepatocellular_carcinomas';
UPDATE structure_fields SET field = 'multiple_focality' 
WHERE field = 'multiple' and tablename = 'dxd_cap_report_hepatocellular_carcinomas';
UPDATE structure_fields SET field = 'specify_multiple_focality_location' 
WHERE field = 'specify_locations' and tablename = 'dxd_cap_report_hepatocellular_carcinomas';
  
UPDATE structure_formats SET language_heading = 'histologic type'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellular_carcinomas') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_hepatocellular_carcinomas' 
AND field = 'histologic_type');  

UPDATE structure_formats SET language_heading = 'histologic grade'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellular_carcinomas') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters_hc' 
AND field = 'tumour_grade');   

ALTER TABLE dxd_cap_report_hepatocellular_carcinomas  
  DROP COLUMN `cannot_be_assessed`,
  DROP COLUMN `uninvolved_by_invasive_carcinoma`,
  DROP COLUMN `involved_by_invasive_carcinoma`,
  DROP COLUMN `special_margin_cannot_be_assessed`,
  DROP COLUMN `special_margin_uninvolved_by_invasive_carcinoma`,
  DROP COLUMN `special_margin_involved_by_invasive_carcinoma`;
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas_revs  
  DROP COLUMN `cannot_be_assessed`,
  DROP COLUMN `uninvolved_by_invasive_carcinoma`,
  DROP COLUMN `involved_by_invasive_carcinoma`,
  DROP COLUMN `special_margin_cannot_be_assessed`,
  DROP COLUMN `special_margin_uninvolved_by_invasive_carcinoma`,
  DROP COLUMN `special_margin_involved_by_invasive_carcinoma`;      

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_hepatocellular_carcinomas' 
AND field IN ('cannot_be_assessed','uninvolved_by_invasive_carcinoma','involved_by_invasive_carcinoma','special_margin_cannot_be_assessed','special_margin_uninvolved_by_invasive_carcinoma','special_margin_involved_by_invasive_carcinoma')); 
DELETE FROM structure_fields WHERE tablename = 'dxd_cap_report_hepatocellular_carcinomas' 
AND field IN ('cannot_be_assessed','uninvolved_by_invasive_carcinoma','involved_by_invasive_carcinoma','special_margin_cannot_be_assessed','special_margin_uninvolved_by_invasive_carcinoma','special_margin_involved_by_invasive_carcinoma');
  
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas   
  ADD `parenchymal_margin` varchar(50) DEFAULT NULL AFTER other_adjacent_organs_specify,
  ADD `other_margin` varchar(50) DEFAULT NULL AFTER specify_margin;
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas_revs   
  ADD `parenchymal_margin` varchar(50) DEFAULT NULL AFTER other_adjacent_organs_specify,
  ADD `other_margin` varchar(50) DEFAULT NULL AFTER specify_margin;

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) 
VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellular_carcinomas', 'parenchymal_margin', 'parenchymal margin', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'margin_cannot') , '', 'open', 'open', 'open'); 
SET @id = LAST_INSERT_ID();
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellular_carcinomas'), @id, 
'1', '35', 'parenchymal margin', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'); 


INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) 
VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_cap_report_hepatocellular_carcinomas', 'other_margin', 'other margin', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'margin_cannot') , '', 'open', 'open', 'open'); 
SET @id = LAST_INSERT_ID();
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellular_carcinomas'), @id, 
'1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'); 
 
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas
  CHANGE `p_specify_margin` `parenchymal_margin_specify` varchar(250) DEFAULT NULL,
  CHANGE `specify_margin` `other_margin_specify` varchar(250) DEFAULT NULL;
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas_revs
  CHANGE `p_specify_margin` `parenchymal_margin_specify` varchar(250) DEFAULT NULL,
  CHANGE `specify_margin` `other_margin_specify` varchar(250) DEFAULT NULL;
UPDATE structure_fields SET field = 'parenchymal_margin_specify' 
WHERE field = 'p_specify_margin' and tablename = 'dxd_cap_report_hepatocellular_carcinomas';
UPDATE structure_fields SET field = 'other_margin_specify' 
WHERE field = 'specify_margin' and tablename = 'dxd_cap_report_hepatocellular_carcinomas';
 
UPDATE structure_fields SET language_tag = language_label, language_label = '' 
WHERE tablename = 'dxd_cap_report_hepatocellular_carcinomas' AND 
field IN ('low_grade_dysplastic_nodule', 'high_grade_dysplastic_nodule');
  
UPDATE structure_formats SET language_heading = 'ancillary studies'
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellular_carcinomas') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'dxd_cap_report_hepatocellular_carcinomas' 
AND field = 'ancillary_studies_specify'); 

ALTER TABLE dxd_cap_report_hepatocellular_carcinomas
  CHANGE `not_known` `clinical_history_not_known` tinyint(1) NOT NULL DEFAULT '0';
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas_revs
  CHANGE `not_known` `clinical_history_not_known` tinyint(1) NOT NULL DEFAULT '0';
UPDATE structure_fields SET field = 'clinical_history_not_known' 
WHERE field = 'not_known' and tablename = 'dxd_cap_report_hepatocellular_carcinomas';

UPDATE structure_formats SET language_heading = 'other' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_cap_report_hepatocellular_carcinomas') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE model = 'DiagnosisMaster' 
AND field IN ('notes'));   

-- #### 



















