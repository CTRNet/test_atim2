-- alter table diagnosis_masters
alter table diagnosis_masters
 add column `tumor_site` varchar(50) DEFAULT NULL,
 add column `tumor_site_specify` varchar(50) DEFAULT NULL,
 add column `tumor_size_greatest_dimension` decimal (3,1)NULL DEFAULT 0.0,
 add column `additional_dimension_a` decimal (3,1)NULL DEFAULT 0.0,
 add column `additional_dimension_b` decimal (3,1)NULL DEFAULT 0.0,
 add column `histologic_type` varchar(100) DEFAULT NULL,
 add column `histologic_type_specify` varchar(100) DEFAULT NULL,
 add column `histologic_grade` varchar(50) DEFAULT NULL,
 add column `histologic_grade_specify` varchar(50) DEFAULT NULL,
 add column `multiple_primary_tumors` tinyint(1) NULL DEFAULT 0,
 add column `recurrent` tinyint(1) NULL DEFAULT 0,  
 add column `post_treatment` tinyint(1) NULL DEFAULT 0, 
 add column `number_node_examined` smallint(1) NULL DEFAULT 0, 
 add column `number_node_involved` smallint(1) NULL DEFAULT 0,  
 -- add column `metastasis_site` varchar(20) DEFAULT NULL,
 add column `metastasis_site_specify` varchar(50) DEFAULT NULL; 
  
-- alter table diagnosis_masters CHANGE `notes` `comments` text default null; -- may be too much changes


-- drop matastasis_site
-- delete from structure_fields where tablename='diagnosis_masters_sm' field='metastasis_site'
-- delete structure_formats better delete from insert into structure_formats	
-- DELETE FROM structure_formats WHERE `structure_id`='213' AND `structure_field_id`='1013' AND `display_column`='2' AND `display_order`='9' AND `language_heading`='' AND `flag_override_label`='0' AND `language_label`='' AND `flag_override_tag`='0' AND `language_tag`='' AND `flag_override_help`='0' AND `language_help`='' AND `flag_override_type`='0' AND `type`='' AND `flag_override_setting`='0' AND `setting`='' AND `flag_override_default`='0' AND `default`='' AND `flag_add`='1' AND `flag_add_readonly`='0' AND `flag_edit`='1' AND `flag_edit_readonly`='0' AND `flag_search`='0' AND `flag_search_readonly`='0' AND `flag_datagrid`='0' AND `flag_datagrid_readonly`='0' AND `flag_index`='1' AND `flag_detail`='1' AND `created`='0000-00-00 00:00:00' AND `created_by`='0' AND `modified`='0000-00-00 00:00:00' AND `modified_by`='0' ;



/*Table structure for table 'dxd_smintestines' */

DROP TABLE IF EXISTS `dxd_smintestines`;

CREATE TABLE IF NOT EXISTS `dxd_smintestines` (
  `id` int(10) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
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
  `other_specify` varchar(50) DEFAULT NULL,
  `not_specified` tinyint(1) NULL DEFAULT 0,
  `procedure` varchar(50) DEFAULT NULL,
  `procedure_specify` varchar(50) DEFAULT NULL,
  `macroscopic_tumor_perforation` varchar(50) DEFAULT NULL,
  `microscopic_tumor_extension` varchar(200) DEFAULT NULL,
  `microscopic_tumor_extension_specify` varchar(50) DEFAULT NULL,
  `proximal_margin` varchar(100) DEFAULT NULL,
  `distal_margin` varchar(100) DEFAULT NULL,
  `radial_margin` varchar(100) DEFAULT NULL,
  `distance_of_invasive_carcinoma_from_closest_margin` decimal (3,1)NULL DEFAULT 0.0,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin` varchar(50) DEFAULT NULL,
  `bile_duct_margin` varchar(50) DEFAULT NULL,
  `pancreatic_margin` varchar(50) DEFAULT NULL,
  `distance_of_invasive_carcinoma_from_closest_margin_bile_duct` decimal (3,1)NULL DEFAULT 0.0,  -- it is for bile duct and pancreatic margin)
  `distance_unit_bile_duct` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin_bile_duct` varchar(50) DEFAULT NULL,
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  -- `primary_tumor` char(4) DEFAULT NULL,  	     -- diagnosis_masters.path_tstage	
  -- `regional_lymph_nodes` char(3) DEFAULT NULL,    -- diagnosis_masters.path_nstage
  -- `distant_metastasis` varchar(20) DEFAULT NULL,  -- diagnosis_masters.path_mstage
  `additional_path_none_identified` tinyint(1) NOT NULL DEFAULT 0,    
  `additional_path_adenoma` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_crohn` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_celiac` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_polyps` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_polups_types` varchar(50) DEFAULT NULL,
  `additional_path_other` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_specfy` varchar(50) DEFAULT NULL,
  `microsatellite_instability` tinyint(1) NOT NULL DEFAULT 0, 
  `microsatellite_instability_testing_method` varchar(50) DEFAULT NULL,
  `microsatellite_instability_grade` varchar(10) DEFAULT NULL,
  `MLH1` tinyint(1) NOT NULL DEFAULT 0,  
  `MLH1_result` varchar(60) DEFAULT NULL,
  `MLH1_specify` varchar(40) DEFAULT NULL,  
  `MSH2` tinyint(1) NOT NULL DEFAULT 0,  
  `MSH2_result` varchar(60) DEFAULT NULL,
  `MSH2_specify` varchar(40) DEFAULT NULL,    
  `MSH6` tinyint(1) NOT NULL DEFAULT 0,  
  `MSH6_result` varchar(60) DEFAULT NULL,
  `MSH6_specify` varchar(40) DEFAULT NULL,  
  `PMS2` tinyint(1) NOT NULL DEFAULT 0,  
  `PMS2_result` varchar(60) DEFAULT NULL,
  `PMS2_specify` varchar(40) DEFAULT NULL,    
  `ancillary_other_specify` varchar(60) DEFAULT NULL,
  `familial_adenomatous_polyposis_coli` tinyint(1) NOT NULL DEFAULT 0,
  `hereditary_nonpolyposis_colon_cancer`  tinyint(1) NOT NULL DEFAULT 0,
  `other_polyposis_syndrome`  tinyint(1) NOT NULL DEFAULT 0,
  `other_polyposis_syndrome_specify` varchar(50) DEFAULT NULL,  
  `crohn_disease` tinyint(1) NOT NULL DEFAULT 0,
  `celiac_disease` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_history_specify` varchar(50) DEFAULT NULL,
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

ALTER TABLE `dxd_smintestines` ADD CONSTRAINT `FK_dxd_smintestines_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 


/*Table structure for table 'dxd_smintestines_revs' */

DROP TABLE IF EXISTS `dxd_smintestines_revs`;

CREATE TABLE `dxd_smintestines_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
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
  `other_specify` varchar(50) DEFAULT NULL,
  `not_specified` tinyint(1) NULL DEFAULT 0,
  `procedure` varchar(50) DEFAULT NULL,
  `procedure_specify` varchar(50) DEFAULT NULL,
  `macroscopic_tumor_perforation` varchar(50) DEFAULT NULL,
  `microscopic_tumor_extension` varchar(200) DEFAULT NULL,
  `microscopic_tumor_extension_specify` varchar(50) DEFAULT NULL,
  `proximal_margin` varchar(100) DEFAULT NULL,
  `distal_margin` varchar(100) DEFAULT NULL,
  `radial_margin` varchar(100) DEFAULT NULL,
  `distance_of_invasive_carcinoma_from_closest_margin` decimal (3,1)NULL DEFAULT 0.0,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin` varchar(50) DEFAULT NULL,
  `bile_duct_margin` varchar(50) DEFAULT NULL,
  `pancreatic_margin` varchar(50) DEFAULT NULL,
  `distance_of_invasive_carcinoma_from_closest_margin_bile_duct` decimal (3,1)NULL DEFAULT 0.0,  -- it is for bile duct and pancreatic margin)
  `distance_unit_bile_duct` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin_bile_duct` varchar(50) DEFAULT NULL,
  `lymph_vascular_invasion` varchar(50) DEFAULT NULL,
  -- `primary_tumor` char(4) DEFAULT NULL,  	     -- diagnosis_masters.path_tstage	
  -- `regional_lymph_nodes` char(3) DEFAULT NULL,    -- diagnosis_masters.path_nstage
  -- `distant_metastasis` varchar(20) DEFAULT NULL,  -- diagnosis_masters.path_mstage
  `additional_path_none_identified` tinyint(1) NOT NULL DEFAULT 0,    
  `additional_path_adenoma` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_crohn` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_celiac` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_polyps` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_polups_types` varchar(50) DEFAULT NULL,
  `additional_path_other` tinyint(1) NOT NULL DEFAULT 0, 
  `additional_path_other_specfy` varchar(50) DEFAULT NULL,
  `microsatellite_instability` tinyint(1) NOT NULL DEFAULT 0, 
  `microsatellite_instability_testing_method` varchar(50) DEFAULT NULL,
  `microsatellite_instability_grade` varchar(10) DEFAULT NULL,
  `MLH1` tinyint(1) NOT NULL DEFAULT 0,  
  `MLH1_result` varchar(60) DEFAULT NULL,
  `MLH1_specify` varchar(40) DEFAULT NULL,  
  `MSH2` tinyint(1) NOT NULL DEFAULT 0,  
  `MSH2_result` varchar(60) DEFAULT NULL,
  `MSH2_specify` varchar(40) DEFAULT NULL,    
  `MSH6` tinyint(1) NOT NULL DEFAULT 0,  
  `MSH6_result` varchar(60) DEFAULT NULL,
  `MSH6_specify` varchar(40) DEFAULT NULL,  
  `PMS2` tinyint(1) NOT NULL DEFAULT 0,  
  `PMS2_result` varchar(60) DEFAULT NULL,
  `PMS2_specify` varchar(40) DEFAULT NULL,    
  `ancillary_other_specify` varchar(60) DEFAULT NULL,
  `familial_adenomatous_polyposis_coli` tinyint(1) NOT NULL DEFAULT 0,
  `hereditary_nonpolyposis_colon_cancer`  tinyint(1) NOT NULL DEFAULT 0,
  `other_polyposis_syndrome`  tinyint(1) NOT NULL DEFAULT 0,
  `other_polyposis_syndrome_specify` varchar(50) DEFAULT NULL,  
  `crohn_disease` tinyint(1) NOT NULL DEFAULT 0,
  `celiac_disease` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_history` tinyint(1) NOT NULL DEFAULT 0,
  `other_clinical_history_specify` varchar(50) DEFAULT NULL,
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

-- builder form smintestines


-- add table dxd_smintestines and dxd_smintestines_revs
-- Add table ‘dxd_smintestines’ in the DB. 
-- insert value in diagnosis_controls
insert into diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename)
values
('Small Intestine', 1, 'dx_smintestines', 'dxd_smintestines');

-- use formbuilder to generate structures, structure_fields, structure_formats
-- to add a new structure - refresh the form builder
-- add the alias of the form into alias dx_smintestines
-- click the table to add row, add all row the form needed
-- generate SQL, run the SQL.  DONE!

-- The table ‘structures’ hold all forms in the application, Add the dxd_smintestines in table ‘structures’. It doesn't hold the form itself but the form alias.

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_smintestines', '', '', '1', '1', '1', '1');


-- add structure fields - tumor_site, histologic type, histologic grade, metastasis site, path_tstage, path_nstage, path_mstage for each site
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'duodenum', 'duodenum','','checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'small_intestine_other_than_duodenum','small intestine other than duodenum','', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'jejunum', 'jejunum', '','checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'ileum', 'ileum', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'stomach', 'stomach', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'head_of_pancreas', 'head of pancreas', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'ampulla', 'ampulla', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'common_bile_duct', 'common bile duct', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'gallbladder', 'gallbladder', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'colon', 'colon', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'other', 'other', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'other_specify', 'other specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'not_specified', 'not specified', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'procedure', 'procedure', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'procedure_specify', 'procedure specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_sm', 'tumor_site', 'tumor site', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumor_site_specify', 'tumor site specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumor_size_greatest_dimension', 'tumor size greatest dimension', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'additional_dimension_a', 'additional dimension a', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'additional_dimension_b', 'additional dimension b', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'macroscopic_tumor_perforation', 'macroscopic tumor perforation', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_sm', 'histologic_type', 'histologic type', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_sm', 'histologic_grade', 'histologic grade', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'histologic_grade_specify', 'histologic grade specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'microscopic_tumor_extension', 'microscopic tumor extension', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'microscopic_tumor_extension_specify', 'microscopic tumor extension specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'proximal_margin', 'proximal margin', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'distal_margin', 'distal margin', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'radial_margin', 'radial margin', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'distance_of_invasive_carcinoma_from_closest_margin', 'distance of invasive carcinoma from closest margin', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'distance_unit', 'distance unit', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'specify_margin', 'specify margin', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'bile_duct_margin', 'bile duct margin', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'pancreatic_margin', 'pancreatic margin', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'distance_of_invasive_carcinoma_from_closest_margin_bile_duct', 'distance of invasive carcinoma from closest margin bile duct', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'distance_unit_bile_duct', 'distance unit bile duct', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'specify_margin_bile_duct', 'specify margin bile duct', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'lymph_vascular_invasion', 'lymph vascular invasion', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'multiple_primary_tumors', 'multiple primary tumors', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'recurrent', 'recurrent', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'post_treatment', 'post treatment', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'number_node_examined', 'number node examined', '', 'integer', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'number_node_involved', 'number node involved', '', 'integer', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'metastasis_site_specify', 'metastasis site specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'additional_path_none_identified', 'additional path none identified', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'additional_path_adenoma', 'additional path adenoma', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'additional_path_crohn', 'additional path crohn', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'additional_path_celiac', 'additional path celiac', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'additional_path_other_polyps', 'additional path other polyps', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'additional_path_other_polups_types', 'additional path other polups types', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'additional_path_other', 'additional path other', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'additional_path_other_specfy', 'additional path other specfy', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'microsatellite_instability', 'microsatellite instability', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'microsatellite_instability_testing_method', 'microsatellite instability testing method', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'microsatellite_instability_grade', 'microsatellite instability grade', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'MLH1', 'MLH1', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'MLH1_result', 'MLH1 result', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'MLH1_specify', 'MLH1 specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'MSH2', 'MSH2', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'MSH2_result', 'MSH2 result', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'MSH2_specify', 'MSH2 specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'MSH6', 'MSH6', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'MSH6_result', 'MSH6 result', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'MSH6_specify', 'MSH6 specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'PMS2', 'PMS2', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'PMS2_result', 'PMS2 result', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'PMS2_specify', 'PMS2 specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'ancillary_other_specify', 'ancillary other specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'familial_adenomatous_polyposis_coli', 'familial adenomatous polyposis coli', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'hereditary_nonpolyposis_colon_cancer', 'hereditary nonpolyposis colon cancer', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'other_polyposis_syndrome', 'other polyposis syndrome', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'other_polyposis_syndrome_specify', 'other polyposis syndrome specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'crohn_disease', 'crohn disease', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'celiac_disease', 'celiac disease', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'other_clinical_history', 'other clinical history', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'other_clinical_history_specify', 'other clinical history specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'not_known', 'not known', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_smintestines', 'comments', 'comments', '', 'input', 'cols=40,rows=6', '0',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_sm', 'path_tstage', 'path tstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_sm', 'path_nstage', 'path nstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters_sm', 'path_mstage', 'path mstage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), '1', '1', '', '1', 'diagnosis date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `language_label`='dx_method' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=33  AND `language_help`='help_dx method'), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='duodenum' AND `language_label`='duodenum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='small_intestine_other_than_duodenum' AND `language_label`='small intestine other than duodenum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='jejunum' AND `language_label`='jejunum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='ileum' AND `language_label`='ileum' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='stomach' AND `language_label`='stomach' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='head_of_pancreas' AND `language_label`='head of pancreas' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='ampulla' AND `language_label`='ampulla' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='common_bile_duct' AND `language_label`='common bile duct' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='gallbladder' AND `language_label`='gallbladder' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='colon' AND `language_label`='colon' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='other' AND `language_label`='other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='other_specify' AND `language_label`='other specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='not_specified' AND `language_label`='not specified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='procedure' AND `language_label`='procedure' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='procedure_specify' AND `language_label`='procedure specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_sm' AND `field`='tumor_site' AND `language_label`='tumor site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_site_specify' AND `language_label`='tumor site specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension' AND `language_label`='tumor size greatest dimension' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a' AND `language_label`='additional dimension a' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b' AND `language_label`='additional dimension b' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='macroscopic_tumor_perforation' AND `language_label`='macroscopic tumor perforation' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_sm' AND `field`='histologic_type' AND `language_label`='histologic type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='histologic_type_specify' AND `language_label`='histologic type specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_sm' AND `field`='histologic_grade' AND `language_label`='histologic grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='histologic_grade_specify' AND `language_label`='histologic grade specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='microscopic_tumor_extension' AND `language_label`='microscopic tumor extension' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='microscopic_tumor_extension_specify' AND `language_label`='microscopic tumor extension specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='proximal_margin' AND `language_label`='proximal margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='distal_margin' AND `language_label`='distal margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='radial_margin' AND `language_label`='radial margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='distance_of_invasive_carcinoma_from_closest_margin' AND `language_label`='distance of invasive carcinoma from closest margin' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='distance_unit' AND `language_label`='distance unit' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='specify_margin' AND `language_label`='specify margin' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='bile_duct_margin' AND `language_label`='bile duct margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='pancreatic_margin' AND `language_label`='pancreatic margin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='distance_of_invasive_carcinoma_from_closest_margin_bile_duct' AND `language_label`='distance of invasive carcinoma from closest margin bile duct' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='distance_unit_bile_duct' AND `language_label`='distance unit bile duct' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='specify_margin_bile_duct' AND `language_label`='specify margin bile duct' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='lymph_vascular_invasion' AND `language_label`='lymph vascular invasion' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='multiple_primary_tumors' AND `language_label`='multiple primary tumors' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='recurrent' AND `language_label`='recurrent' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='post_treatment' AND `language_label`='post treatment' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_sm' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  ), '2', '4', '', '1', 'path tstage', '1', '', '0', '', '1', 'select', '1', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_sm' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  ), '2', '5', '', '1', 'path nstage', '1', '', '0', '', '1', 'select', '1', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='number_node_examined' AND `language_label`='number node examined' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='number_node_involved' AND `language_label`='number node involved' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters_sm' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  ), '2', '8', '', '1', 'path mstage', '1', '', '0', '', '1', 'select', '1', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='metastasis_site_specify' AND `language_label`='metastasis site specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='additional_path_none_identified' AND `language_label`='additional path none identified' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='additional_path_adenoma' AND `language_label`='additional path adenoma' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='additional_path_crohn' AND `language_label`='additional path crohn' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='additional_path_celiac' AND `language_label`='additional path celiac' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='additional_path_other_polyps' AND `language_label`='additional path other polyps' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='additional_path_other_polups_types' AND `language_label`='additional path other polups types' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='additional_path_other' AND `language_label`='additional path other' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='additional_path_other_specfy' AND `language_label`='additional path other specfy' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='microsatellite_instability' AND `language_label`='microsatellite instability' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '19', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='microsatellite_instability_testing_method' AND `language_label`='microsatellite instability testing method' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='microsatellite_instability_grade' AND `language_label`='microsatellite instability grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='MLH1' AND `language_label`='MLH1' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='MLH1_result' AND `language_label`='MLH1 result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='MLH1_specify' AND `language_label`='MLH1 specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='MSH2' AND `language_label`='MSH2' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='MSH2_result' AND `language_label`='MSH2 result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='MSH2_specify' AND `language_label`='MSH2 specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='MSH6' AND `language_label`='MSH6' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='MSH6_result' AND `language_label`='MSH6 result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='MSH6_specify' AND `language_label`='MSH6 specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='PMS2' AND `language_label`='PMS2' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='PMS2_result' AND `language_label`='PMS2 result' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='PMS2_specify' AND `language_label`='PMS2 specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='ancillary_other_specify' AND `language_label`='ancillary other specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='familial_adenomatous_polyposis_coli' AND `language_label`='familial adenomatous polyposis coli' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='hereditary_nonpolyposis_colon_cancer' AND `language_label`='hereditary nonpolyposis colon cancer' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='other_polyposis_syndrome' AND `language_label`='other polyposis syndrome' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='other_polyposis_syndrome_specify' AND `language_label`='other polyposis syndrome specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '38', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='crohn_disease' AND `language_label`='crohn disease' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '39', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='celiac_disease' AND `language_label`='celiac disease' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='other_clinical_history' AND `language_label`='other clinical history' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='other_clinical_history_specify' AND `language_label`='other clinical history specify' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='not_known' AND `language_label`='not known' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '43', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_smintestines'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_smintestines' AND `field`='comments' AND `language_label`='comments' AND `language_tag`='' AND `type`='input' AND `setting`='cols=40,rows=6' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '2', '44', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');


update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='duodenum'
and sfo.structure_id=s.id
and s.alias='dx_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='Tumor Site'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_site'
and sfo.structure_id=s.id
and s.alias='dx_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='Tumor Size'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='Margin'
where sfi.id=sfo.structure_field_id
and sfi.field='proximal_margin'
and sfo.structure_id=s.id
and s.alias='dx_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='Pathologic Staging (pTNM)'
where sfi.id=sfo.structure_field_id
and sfi.field='multiple_primary_tumors'
and sfo.structure_id=s.id
and s.alias='dx_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='Additional Pathologic Findings'
where sfi.id=sfo.structure_field_id
and sfi.field='additional_path_none_identified'
and sfo.structure_id=s.id
and s.alias='dx_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='Ancillary Studies'
where sfi.id=sfo.structure_field_id
and sfi.field='microsatellite_instability'
and sfo.structure_id=s.id
and s.alias='dx_smintestines'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='Clinical History'
where sfi.id=sfo.structure_field_id
and sfi.field='familial_adenomatous_polyposis_coli'
and sfo.structure_id=s.id
and s.alias='dx_smintestines'; 

update structure_fields
set structure_value_domain=185
where model like 'diagnosis%'
and type='checkbox';

insert into structure_permissible_values (value, language_alias) values
('Segmental resection','Segmental resection'),
('Pancreaticoduodenectomy (Whipple resection)', 'Pancreaticoduodenectomy (Whipple resection)'),
('Not specified', 'Not specified');


INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('procedure', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='procedure'), (select id from structure_permissible_values where value='Segmental resection'), 1,1,'Segmental resection'),
((select id from structure_value_domains where domain_name='procedure'), (select id from structure_permissible_values where value='Pancreaticoduodenectomy (Whipple resection)'), 2, 1,'Pancreaticoduodenectomy (Whipple resection)'),
((select id from structure_value_domains where domain_name='procedure'), (select id from structure_permissible_values where value='Other'),3, 1, 'Other'),
((select id from structure_value_domains where domain_name='procedure'), (select id from structure_permissible_values where value='Not specified'), 4, 1, 'Not specified');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='procedure')
where tablename='dxd_smintestines' and field='procedure';


-- tumour_site_sm

insert into structure_permissible_values (value, language_alias) values
('Duodenum','Duodenum'),
('Small intestine, other than duodenum', 'Small intestine, other than duodenum'),
('Jejunum', 'Jejunum');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('tumour_site_sm', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='Duodenum'),1, 1,'Duodenum'),
((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='Small intestine, other than duodenum'), 2,1,'Small intestine, other than duodenum'),
((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='Jejunum'), 3,1, 'Jejunum'),
((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='Ileum'), 4, 1, 'Ileum'),
((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='Other'), 5, 1, 'Other'),
((select id from structure_value_domains where domain_name='tumour_site_sm'), (select id from structure_permissible_values where value='Not specified'), 6, 1, 'Not specified');

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='tumour_site_sm')
where tablename='diagnosis_masters_sm' and field='tumor_site';

-- macroscopic_tumor_perforation
insert into structure_permissible_values (value, language_alias) values
('Present','Present'),
('Not identified', 'Not identified'),
('Cannot be determined', 'Cannot be determined');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('macroscopic_tumor_perforation', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='macroscopic_tumor_perforation'), (select id from structure_permissible_values where value='Present'), 1,1,'Present'),
((select id from structure_value_domains where domain_name='macroscopic_tumor_perforation'), (select id from structure_permissible_values where value='Not identified'), 2,1,'Not identified'),
((select id from structure_value_domains where domain_name='macroscopic_tumor_perforation'), (select id from structure_permissible_values where value='Cannot be determined'), 3,1, 'Cannot be determined');

select * from structure_fields
where tablename='dxd_smintestines' and field='macroscopic_tumor_perforation';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='macroscopic_tumor_perforation')
where tablename='dxd_smintestines' and field='macroscopic_tumor_perforation';

-- histologic_type_sm
insert into structure_permissible_values (value, language_alias) values
('Adenocarcinoma (not otherwise characterized)','Adenocarcinoma (not otherwise characterized)'),
('Mucinous adenocarcinoma (greater than 50% mucinous)', 'Mucinous adenocarcinoma (greater than 50% mucinous)'),
('Signet-ring cell carcinoma (greater than 50% signet-ring cells)', 'Signet-ring cell carcinoma (greater than 50% signet-ring cells)'),
('Small cell carcinoma','Small cell carcinoma'),
('Squamous cell carcinoma','Squamous cell carcinoma'),
('Adenosquamous carcinoma','Adenosquamous carcinoma'),
('Medullary carcinoma','Medullary carcinoma'),
('Undifferentiated carcinoma','Undifferentiated carcinoma'),
('Mixed carcinoid-adenocarcinoma','Mixed carcinoid-adenocarcinoma');


INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('histologic_type_sm', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='Adenocarcinoma (not otherwise characterized)'), 1,1,'Adenocarcinoma (not otherwise characterized)'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='Mucinous adenocarcinoma (greater than 50% mucinous)'), 2,1,'Mucinous adenocarcinoma (greater than 50% mucinous)'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='Signet-ring cell carcinoma (greater than 50% signet-ring cells)'), 3,1, 'Signet-ring cell carcinoma (greater than 50% signet-ring cells)'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='Small cell carcinoma'), 4,1,'Small cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='Squamous cell carcinoma'), 5,1,'Squamous cell carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='Adenosquamous carcinoma'), 6,1, 'Adenosquamous carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='Medullary carcinoma'), 7,1,'Medullary carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='Undifferentiated carcinoma'), 8,1,'Undifferentiated carcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='Mixed carcinoid-adenocarcinoma'), 9,1,'Mixed carcinoid-adenocarcinoma'),
((select id from structure_value_domains where domain_name='histologic_type_sm'), (select id from structure_permissible_values where value='Other'), 10,1, 'Other');



select * from structure_fields
where tablename='diagnosis_masters_sm' and field='histologic_type';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_type_sm')
where tablename='diagnosis_masters_sm' and field='histologic_type';


-- histologic grade
insert into structure_permissible_values (value, language_alias) values
('GX','Cannot be assessed'),
('G1','Well differentiated'),
('G2','Moderately differentiated'),
('G3','Poorly differentiated'),
('G4','Undifferentiated');


INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('histologic_grade_sm', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='histologic_grade_sm'), (select id from structure_permissible_values where value='Not applicable'), 1,1,'Not applicable'),
((select id from structure_value_domains where domain_name='histologic_grade_sm'), (select id from structure_permissible_values where value='GX'), 2,1,'Cannot be assessed'),
((select id from structure_value_domains where domain_name='histologic_grade_sm'), (select id from structure_permissible_values where value='G1'), 3,1, 'Well differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_sm'), (select id from structure_permissible_values where value='G2'), 4,1,'Moderately differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_sm'), (select id from structure_permissible_values where value='G3'), 5,1,'Poorly differentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_sm'), (select id from structure_permissible_values where value='G4'), 6,1,'Undifferentiated'),
((select id from structure_value_domains where domain_name='histologic_grade_sm'), (select id from structure_permissible_values where value='Other'), 7,1, 'Other');

select id from structure_value_domains where domain_name='histologic_grade_sm';

select * from structure_fields
where tablename='diagnosis_masters_sm' and field='histologic_grade';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='histologic_grade_sm')
where tablename='diagnosis_masters_sm' and field='histologic_grade';


-- Microscopic Tumor Extension
insert into structure_permissible_values (value, language_alias) values
('No evidence of primary tumor', 'No evidence of primary tumor'),
('Tumor invades lamina propria','Tumor invades lamina propria'),
('Tumor invades submucosa','Tumor invades submucosa'),
('Tumor invades muscularis propria','Tumor invades muscularis propria'),
('Tumor invades through the muscularis propria into the subserosal adipose tissue or the nonperitonealized peri-intestinal soft tissues but does not extend to the serosal surface','Tumor invades through the muscularis propria into the subserosal adipose tissue or the nonperitonealized peri-intestinal soft tissues but does not extend to the serosal surface'),
('Tumor microscopically involves the serosal surface (visceral peritoneum)','Tumor microscopically involves the serosal surface (visceral peritoneum)'),
('Tumor directly invades adjacent structures','Tumor directly invades adjacent structures'),
('Tumor penetrates to the surface of the visceral peritoneum (serosa) AND directly invades adjacent structures','Tumor penetrates to the surface of the visceral peritoneum (serosa) AND directly invades adjacent structures');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('microscopic_tumor_extension', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='Cannot be assessed'), 1,1,'Cannot be assessed'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='No evidence of primary tumor'), 2,1,'No evidence of primary tumor'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='Tumor invades lamina propria'), 3,1, 'Tumor invades lamina propria'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='Tumor invades submucosa'), 4,1,'Tumor invades submucosa'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='Tumor invades muscularis propria'), 5,1,'Tumor invades muscularis propria'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='Tumor invades through the muscularis propria into the subserosal adipose tissue or the nonperitonealized peri-intestinal soft tissues but does not extend to the serosal surface'), 6,1,'Tumor invades through the muscularis propria into the subserosal adipose tissue or the nonperitonealized peri-intestinal soft tissues but does not extend to the serosal surface'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='Tumor microscopically involves the serosal surface (visceral peritoneum)'), 7,1, 'Tumor microscopically involves the serosal surface (visceral peritoneum)'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='Tumor directly invades adjacent structures'), 7,1, 'Tumor directly invades adjacent structures'),
((select id from structure_value_domains where domain_name='microscopic_tumor_extension'), (select id from structure_permissible_values where value='Tumor penetrates to the surface of the visceral peritoneum (serosa) AND directly invades adjacent structures'), 7,1, 'Tumor penetrates to the surface of the visceral peritoneum (serosa) AND directly invades adjacent structures');

select id from structure_value_domains where domain_name='microscopic_tumor_extension';

select * from structure_fields
where tablename='dxd_smintestines' and field='microscopic_tumor_extension';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='microscopic_tumor_extension')
where tablename='dxd_smintestines' and field='microscopic_tumor_extension';

-- Proximal Margin

insert into structure_permissible_values (value, language_alias) values
('Uninvolved by invasive carcinoma', 'Uninvolved by invasive carcinoma'),
('Involved by invasive carcinoma','Involved by invasive carcinoma'),
('Intramucosal carcinoma/adenoma not identified at proximal margin','Intramucosal carcinoma/adenoma not identified at proximal margin'),
('Intramucosal carcinoma/adenoma present at proximal margin','Intramucosal carcinoma/adenoma present at proximal margin');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('proximal_margin', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='proximal_margin'), (select id from structure_permissible_values where value='Cannot be assessed'), 1,1,'Cannot be assessed'),
((select id from structure_value_domains where domain_name='proximal_margin'), (select id from structure_permissible_values where value='Uninvolved by invasive carcinoma'), 2,1,'Uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='proximal_margin'), (select id from structure_permissible_values where value='Involved by invasive carcinoma'), 3,1, 'Involved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='proximal_margin'), (select id from structure_permissible_values where value='Intramucosal carcinoma/adenoma not identified at proximal margin'), 4,1,'Intramucosal carcinoma/adenoma not identified at proximal margin'),
((select id from structure_value_domains where domain_name='proximal_margin'), (select id from structure_permissible_values where value='Intramucosal carcinoma/adenoma present at proximal margin'), 7,1, 'Intramucosal carcinoma/adenoma present at proximal margin');

select id from structure_value_domains where domain_name='proximal_margin';

select * from structure_fields
where tablename='dxd_smintestines' and field='proximal_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='proximal_margin')
where tablename='dxd_smintestines' and field='proximal_margin';

-- Distal Margin
insert into structure_permissible_values (value, language_alias) values
('Intramucosal carcinoma/adenoma not identified at distal margin', 'Intramucosal carcinoma/adenoma not identified at distal margin'),
('Intramucosal carcinoma /adenoma present at distal margin', 'Intramucosal carcinoma /adenoma present at distal margin');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('distal_margin', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='distal_margin'), (select id from structure_permissible_values where value='Cannot be assessed'), 1,1,'Cannot be assessed'),
((select id from structure_value_domains where domain_name='distal_margin'), (select id from structure_permissible_values where value='Uninvolved by invasive carcinoma'), 2,1,'Uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='distal_margin'), (select id from structure_permissible_values where value='Involved by invasive carcinoma'), 3,1, 'Involved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='distal_margin'), (select id from structure_permissible_values where value='Intramucosal carcinoma/adenoma not identified at distal margin'), 4,1,'Intramucosal carcinoma/adenoma not identified at distal margin'),
((select id from structure_value_domains where domain_name='distal_margin'), (select id from structure_permissible_values where value='Intramucosal carcinoma /adenoma present at distal margin'), 7,1, 'Intramucosal carcinoma /adenoma present at distal margin');

select id from structure_value_domains where domain_name='distal_margin';

select * from structure_fields
where tablename='dxd_smintestines' and field='distal_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distal_margin')
where tablename='dxd_smintestines' and field='distal_margin';


-- Circumferential (Radial) or Mesenteric Margin
insert into structure_permissible_values (value, language_alias) values
('Involved by invasive carcinoma (tumor present 0-1 mm from margin)', 'Involved by invasive carcinoma (tumor present 0-1 mm from margin)');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('radial_margin', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='radial_margin'), (select id from structure_permissible_values where value='Not applicable'), 1,1, 'Not applicable'),
((select id from structure_value_domains where domain_name='radial_margin'), (select id from structure_permissible_values where value='Cannot be assessed'), 2,1,'Cannot be assessed'),
((select id from structure_value_domains where domain_name='radial_margin'), (select id from structure_permissible_values where value='Uninvolved by invasive carcinoma'), 3,1,'Uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='radial_margin'), (select id from structure_permissible_values where value='Involved by invasive carcinoma (tumor present 0-1 mm from margin)'), 4,1, 'Involved by invasive carcinoma (tumor present 0-1 mm from margin)');

select id from structure_value_domains where domain_name='radial_margin';

select * from structure_fields
where tablename='dxd_smintestines' and field='radial_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='radial_margin')
where tablename='dxd_smintestines' and field='radial_margin';

-- distance unit
insert into structure_permissible_values (value, language_alias) values
('mm', 'mm');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('distance_unit', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='distance_unit'), (select id from structure_permissible_values where value='mm'), 1,1, 'mm'),
((select id from structure_value_domains where domain_name='distance_unit'), (select id from structure_permissible_values where value='cm'), 2,1, 'cm');

select id from structure_value_domains where domain_name='distance_unit';

select * from structure_fields
where tablename='dxd_smintestines' and field='distance_unit';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distance_unit')
where tablename='dxd_smintestines' and field='distance_unit';

-- margin
insert into structure_permissible_values (value, language_alias) values
('Margin uninvolved by invasive carcinoma', 'Margin uninvolved by invasive carcinoma'),
('Margin involved by invasive carcinoma', 'Margin involved by invasive carcinoma');

-- Bile Duct Margin
-- ___ Not applicable
-- ___ Cannot be assessed
-- ___ Margin uninvolved by invasive carcinoma
-- ___ Margin involved by invasive carcinoma

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('margin', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='margin'), (select id from structure_permissible_values where value='Not applicable'), 1,1, 'Not applicable'),
((select id from structure_value_domains where domain_name='margin'), (select id from structure_permissible_values where value='Cannot be assessed'), 2,1, 'Cannot be assessed'),
((select id from structure_value_domains where domain_name='margin'), (select id from structure_permissible_values where value='Margin uninvolved by invasive carcinoma'), 3,1, 'Margin uninvolved by invasive carcinoma'),
((select id from structure_value_domains where domain_name='margin'), (select id from structure_permissible_values where value='Margin involved by invasive carcinoma'), 4,1, 'Margin involved by invasive carcinoma');

select id from structure_value_domains where domain_name='margin';

select * from structure_fields
where tablename='dxd_smintestines' and field='bile_duct_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin')
where tablename='dxd_smintestines' and field='bile_duct_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin')
where tablename='dxd_smintestines' and field='pancreatic_margin';

-- distance unit bile duct
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distance_unit')
where tablename='dxd_smintestines' and field='distance_unit_bile_duct';

-- Lymph-Vascular Invasion

insert into structure_permissible_values (value, language_alias) values
('Indeterminate', 'Indeterminate');

-- ___ Not identified
-- ___ Present
-- ___ Indeterminate


INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('lymph_vascular_invasion', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='lymph_vascular_invasion'), (select id from structure_permissible_values where value='Not identified'), 1,1, 'Not identified'),
((select id from structure_value_domains where domain_name='lymph_vascular_invasion'), (select id from structure_permissible_values where value='Present'), 2,1, 'Present'),
((select id from structure_value_domains where domain_name='lymph_vascular_invasion'), (select id from structure_permissible_values where value='Indeterminate'), 3,1, 'Indeterminate');

select id from structure_value_domains where domain_name='lymph_vascular_invasion';

select * from structure_fields
where tablename='dxd_smintestines' and field='lymph_vascular_invasion';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_smintestines' and field='lymph_vascular_invasion';


-- Primary Tumor (pT)
insert into structure_permissible_values (value, language_alias) values
('pTX', 'Cannot be assessed'),
('pT0', 'No evidence of primary tumor'),
('pTis', 'Carcinoma in situ'),
('pT1a', 'Tumor invades lamina propria'),
('pT1b', 'Tumor invades submucosa'),
('pT2', 'Tumor invades muscularis propria'),
('pT3', 'Tumor invades through the muscularis propria into the subserosa or into the nonperitonealized perimuscular tissue (mesentery or retroperitoneum) with extension 2 cm or less'),
('pT4a', 'Tumor penetrates the visceral peritoneum'),
('pT4b', 'Tumor directly invades other organs or structures');



INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('path_tstage_sm', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pTX'), 1,1, 'Cannot be assessed'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pT0'), 2,1, 'No evidence of primary tumor'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pTis'), 3,1, 'Carcinoma in situ'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pT1a'), 4,1, 'Tumor invades lamina propria'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pT1b'), 5,1, 'Tumor invades submucosa'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pT2'), 6,1, 'Tumor invades muscularis propria'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pT3'), 7,1, 'Tumor invades through the muscularis propria into the subserosa or into the nonperitonealized perimuscular tissue (mesentery or retroperitoneum) with extension 2 cm or less'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pT4a'), 8,1, 'Tumor penetrates the visceral peritoneum'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pT4b'), 9,1, 'Tumor directly invades other organs or structures');

select id from structure_value_domains where domain_name='path_tstage_sm';

select * from structure_fields
where tablename='diagnosis_masters_sm' and field='path_tstage';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_tstage_sm')
where tablename='diagnosis_masters_sm' and field='path_tstage';


-- Regional Lymph Nodes (pN)
insert into structure_permissible_values (value, language_alias) values
('pNX', 'Cannot be assessed'),
('pN0', 'No regional lymph node metastasis'),
('pN1', 'Metastasis in 1 to 3 regional lymph nodes'),
('pN2', 'Metastasis in 4 or more regional lymph nodes');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('path_nstage_sm', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_nstage_sm'), (select id from structure_permissible_values where value='pNX'), 1,1, 'Cannot be assessed'),
((select id from structure_value_domains where domain_name='path_nstage_sm'), (select id from structure_permissible_values where value='pN0'), 2,1, 'No regional lymph node metastasis'),
((select id from structure_value_domains where domain_name='path_nstage_sm'), (select id from structure_permissible_values where value='pN1'), 3,1, 'Metastasis in 1 to 3 regional lymph nodes'),
((select id from structure_value_domains where domain_name='path_nstage_sm'), (select id from structure_permissible_values where value='pN2'), 4,1, 'Metastasis in 4 or more regional lymph nodes');

select * from structure_fields
where tablename='diagnosis_masters_sm' and field='path_nstage';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_nstage_sm')
where tablename='diagnosis_masters_sm' and field='path_nstage';


-- Distant Metastasis (pM)
insert into structure_permissible_values (value, language_alias) values
('pM1', 'Distant metastasis');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('path_mstage_sm', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='path_mstage_sm'), (select id from structure_permissible_values where value='Not applicable'), 1,1, 'Not applicable'),
((select id from structure_value_domains where domain_name='path_mstage_sm'), (select id from structure_permissible_values where value='pM1'), 4,1, 'Distant metastasis');

select * from structure_fields
where tablename='diagnosis_masters_sm' and field='path_mstage';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='path_mstage_sm')
where tablename='diagnosis_masters_sm' and field='path_mstage';


-- Microsatellite instability grade
insert into structure_permissible_values (value, language_alias) values
('Stable', 'Stable'),
('Low','Low'),
('High','High');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('microsatellite_instability_grade', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='microsatellite_instability_grade'), (select id from structure_permissible_values where value='Stable'), 1,1, 'Stable'),
((select id from structure_value_domains where domain_name='microsatellite_instability_grade'), (select id from structure_permissible_values where value='Low'), 2,1, 'Low'),
((select id from structure_value_domains where domain_name='microsatellite_instability_grade'), (select id from structure_permissible_values where value='High'), 3,1, 'High');

select * from structure_fields
where tablename='dxd_smintestines' and field='microsatellite_instability_grade';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='microsatellite_instability_grade')
where tablename='dxd_smintestines' and field='microsatellite_instability_grade';

-- Immunohistochemistry_sm
insert into structure_permissible_values (value, language_alias) values
('Immunoreactive tumor cells present (nuclear positivity)', 'Immunoreactive tumor cells present (nuclear positivity)'),
('No immunoreactive tumor cells present','No immunoreactive tumor cells present');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) 
VALUES ('immunohistochemistry_sm', 'open', '', NULL);

insert into structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order,flag_active, language_alias)
values ((select id from structure_value_domains where domain_name='immunohistochemistry_sm'), (select id from structure_permissible_values where value='Immunoreactive tumor cells present (nuclear positivity)'), 1,1, 'Immunoreactive tumor cells present (nuclear positivity)'),
((select id from structure_value_domains where domain_name='immunohistochemistry_sm'), (select id from structure_permissible_values where value='No immunoreactive tumor cells present'), 2,1, 'No immunoreactive tumor cells present'),
((select id from structure_value_domains where domain_name='immunohistochemistry_sm'), (select id from structure_permissible_values where value='Pending'), 3,1, 'Pending'),
((select id from structure_value_domains where domain_name='immunohistochemistry_sm'), (select id from structure_permissible_values where value='Other'), 4,1, 'Other');

select * from structure_fields
where tablename='dxd_smintestines' and field='mlh1_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_smintestines' and field='mlh1_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_smintestines' and field='msh2_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_smintestines' and field='msh6_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_smintestines' and field='pms2_result';