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
('cap report - ampullas', 1, 'dx_cap_report_ampullas', 'dxd_cap_report_ampullas');

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

