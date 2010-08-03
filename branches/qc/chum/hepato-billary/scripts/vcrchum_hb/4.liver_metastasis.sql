DROP TABLE IF EXISTS `dxd_liver_metastases`;
CREATE TABLE IF NOT EXISTS `dxd_liver_metastases` (
  `id` int(10) NOT NULL auto_increment,
  `diagnosis_master_id` int(11) DEFAULT NULL ,
  
  -- Histologic Type 
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
  
  -- number of lesions
  `lesions_nbr` int(6) DEFAULT NULL,  
  
  -- main lesion size
  -- 	see master
  
  -- other lesion size
  `other_lesion_size_greatest_dimension` decimal (3,1)NULL DEFAULT NULL,
  `other_lesion_size_additional_dimension_a` decimal (3,1)NULL DEFAULT NULL,
  `other_lesion_size_additional_dimension_b` decimal (3,1)NULL DEFAULT NULL,
  `other_lesion_size_cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
  
  -- Localisation
  `tumor_site` varchar(50) DEFAULT NULL,
  `tumor_site_specify` varchar(250) DEFAULT NULL,
  
  -- percentage
  `necrosis_perc` decimal (3,1)NULL DEFAULT NULL,
  `viable_cells_perc` decimal (3,1)NULL DEFAULT NULL,
 
  -- Margins
  `surgical_resection_margin` varchar(10) DEFAULT NULL,
  `distance_of_tumor_from_closest_surgical_resection_margin` decimal (3,1)NULL DEFAULT NULL,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin` varchar(250) DEFAULT NULL,
  
  -- parenchyma
  `adjacent_liver_parenchyma` varchar(100) DEFAULT NULL,
  `adjacent_liver_parenchyma_specify` varchar(250) DEFAULT NULL,
    
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `dxd_liver_metastases` ADD CONSTRAINT `FK_dxd_liver_metastases_diagnosis_masters` 
FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 

DROP TABLE IF EXISTS `dxd_liver_metastases_revs`;
CREATE TABLE `dxd_liver_metastases_revs` (
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  
  -- Histologic Type 
  `histologic_type` varchar(100) DEFAULT NULL,
  `histologic_type_specify` varchar(250) DEFAULT NULL,
  
  -- number of lesions
  `lesions_nbr` int(6) DEFAULT NULL,  
  
  -- main lesion size
  -- 	see master
  
  -- other lesion size
  `other_lesion_size_greatest_dimension` decimal (3,1)NULL DEFAULT NULL,
  `other_lesion_size_additional_dimension_a` decimal (3,1)NULL DEFAULT NULL,
  `other_lesion_size_additional_dimension_b` decimal (3,1)NULL DEFAULT NULL,
  `other_lesion_size_cannot_be_determined` tinyint(1) NULL DEFAULT 0,  
  
  -- Localisation
  `tumor_site` varchar(50) DEFAULT NULL,
  `tumor_site_specify` varchar(250) DEFAULT NULL,
  
  -- percentage
  `necrosis_perc` decimal (3,1)NULL DEFAULT NULL,
  `viable_cells_perc` decimal (3,1)NULL DEFAULT NULL,
 
  -- Margins
  `surgical_resection_margin` varchar(10) DEFAULT NULL,
  `distance_of_tumor_from_closest_surgical_resection_margin` decimal (3,1)NULL DEFAULT NULL,
  `distance_unit` char(2) DEFAULT NULL, -- cm or mm
  `specify_margin` varchar(250) DEFAULT NULL,
  
  -- parenchyma
  `adjacent_liver_parenchyma` varchar(100) DEFAULT NULL,
  `adjacent_liver_parenchyma_specify` varchar(250) DEFAULT NULL,
    
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO diagnosis_controls (controls_type, flag_active, form_alias, detail_tablename)
VALUES
('liver metastasis', 1, 'dx_liver_metastases', 'dxd_liver_metastases');

INSERT IGNORE INTO i18n (id, en, fr) VALUES
('liver metastasis', 'Liver Metastasis', 'Métastases hépatiques');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('dx_liver_metastases', '', '', '0', '0', '0', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
  -- Histologic Type 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'histologic_type', 'histologic type', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
  -- number of lesions
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'lesions_nbr', 'lesions nbr', '', 'integer', '', '0',  NULL , '', 'open', 'open', 'open'), 
  -- main lesion size
-- ('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumor_size_greatest_dimension', 'tumor size greatest dimension', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
-- ('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'additional_dimension_a', 'additional dimension a', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
-- ('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'additional_dimension_b', '', 'additional dimension b', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
-- ('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
  -- other lesion size
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'other_lesion_size_greatest_dimension', 'other lesion greatest dimension', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'other_lesion_size_additional_dimension_a', 'other lesion additional dimension a', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'other_lesion_size_additional_dimension_b', '', 'additional dimension b', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'other_lesion_size_cannot_be_determined', 'other lesion cannot be determined', '', 'checkbox', '', '0',  NULL , '', 'open', 'open', 'open'), 
  -- Localisation
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'tumor_site', 'tumor site', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'tumor_site_specify', 'tumor site specify', '', 'input', '', '0',  NULL , '', 'open', 'open', 'open'),   
  -- percentage
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'necrosis_perc', 'necrosis percentage', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'viable_cells_perc', 'viable cells percentage', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
  -- Margins
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'surgical_resection_margin', 'surgical resection margin', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'distance_of_tumor_from_closest_surgical_resection_margin', 'distance of tumor from closest surgical resection margin', '', 'float', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'distance_unit', '', '', 'select', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'specify_margin', '', 'specify margin', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
  -- parenchyma
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'adjacent_liver_parenchyma', '', 'adjacent liver parenchyma', 'input', '', '0',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'adjacent_liver_parenchyma_specify', '', 'adjacent liver parenchyma specify', 'input', '', '0',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
  -- Histologic Type 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='histologic_type'), 
'1', '1', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='histologic_type_specify'), 
'1', '2', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
  -- number of lesions
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='lesions_nbr'), 
'1', '3', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
  -- main lesion size
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension'), 
'1', '4', '', '1', 'main lesion size greatest dimension', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a'), 
'1', '5', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b'), 
'1', '6', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='cannot_be_determined'), 
'1', '7', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
  -- other lesion size
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='other_lesion_size_greatest_dimension'), 
'1', '10', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='other_lesion_size_additional_dimension_a'), 
'1', '11', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='other_lesion_size_additional_dimension_b'), 
'1', '12', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='other_lesion_size_cannot_be_determined'), 
'1', '13', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
  -- Localisation
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='tumor_site'), 
'1', '15', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='tumor_site_specify'), 
'1', '16', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
  -- percentage
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='necrosis_perc'), 
'1', '20', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='viable_cells_perc'), 
'1', '21', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
  -- Margins
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='surgical_resection_margin'), 
'1', '25', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='distance_of_tumor_from_closest_surgical_resection_margin'), 
'1', '26', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='distance_unit'), 
'1', '27', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='specify_margin'), 
'1', '28', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
  -- parenchyma
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='adjacent_liver_parenchyma'), 
'1', '40', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='adjacent_liver_parenchyma_specify'), 
'1', '41', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
  -- notes
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes'), 
'1', '44', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1');

































INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='distance_unit' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0),
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='distance_unit_bile_duct' AND `type`='select' AND `setting`='' AND `default`='0' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='specimen'
where sfi.id=sfo.structure_field_id
and sfi.field='duodenum'
and sfo.structure_id=s.id
and s.alias='dx_liver_metastases'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor site'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_site'
and sfo.structure_id=s.id
and s.alias='dx_liver_metastases'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='tumor size'
where sfi.id=sfo.structure_field_id
and sfi.field='tumor_size_greatest_dimension'
and sfo.structure_id=s.id
and s.alias='dx_liver_metastases'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='margins'
where sfi.id=sfo.structure_field_id
and sfi.field='proximal_margin'
and sfo.structure_id=s.id
and s.alias='dx_liver_metastases'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='pathologic staging (pTNM)'
where sfi.id=sfo.structure_field_id
and sfi.field='path_tnm_descriptor_m'
and sfo.structure_id=s.id
and s.alias='dx_liver_metastases'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='additional pathologic findings'
where sfi.id=sfo.structure_field_id
and sfi.field='additional_path_none_identified'
and sfo.structure_id=s.id
and s.alias='dx_liver_metastases'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='ancillary Studies'
where sfi.id=sfo.structure_field_id
and sfi.field='microsatellite_instability'
and sfo.structure_id=s.id
and s.alias='dx_liver_metastases'; 

update structure_formats sfo inner join structure_fields sfi inner join structures s
set sfo.language_heading='clinical history'
where sfi.id=sfo.structure_field_id
and sfi.field='familial_adenomatous_polyposis_coli'
and sfo.structure_id=s.id
and s.alias='dx_liver_metastases'; 

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
('additional path other specfy', 'Specify', ''),
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
where tablename='dxd_liver_metastases' and field='procedure';


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
where tablename='dxd_liver_metastases' and field='macroscopic_tumor_perforation';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='macroscopic_tumor_perforation')
where tablename='dxd_liver_metastases' and field='macroscopic_tumor_perforation';

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
where tablename='dxd_liver_metastases' and field='microscopic_tumor_extension';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='microscopic_tumor_extension')
where tablename='dxd_liver_metastases' and field='microscopic_tumor_extension';

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
where tablename='dxd_liver_metastases' and field='proximal_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='proximal_margin')
where tablename='dxd_liver_metastases' and field='proximal_margin';

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
where tablename='dxd_liver_metastases' and field='distal_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distal_margin')
where tablename='dxd_liver_metastases' and field='distal_margin';


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
where tablename='dxd_liver_metastases' and field='radial_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='radial_margin')
where tablename='dxd_liver_metastases' and field='radial_margin';

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
where tablename='dxd_liver_metastases' and field='distance_unit';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distance_unit')
where tablename='dxd_liver_metastases' and field='distance_unit';

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
where tablename='dxd_liver_metastases' and field='bile_duct_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin')
where tablename='dxd_liver_metastases' and field='bile_duct_margin';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='margin')
where tablename='dxd_liver_metastases' and field='pancreatic_margin';

-- distance unit bile duct
update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='distance_unit')
where tablename='dxd_liver_metastases' and field='distance_unit_bile_duct';

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
where tablename='dxd_liver_metastases' and field='lymph_vascular_invasion';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='lymph_vascular_invasion')
where tablename='dxd_liver_metastases' and field='lymph_vascular_invasion';


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
values ((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='ptx'), 1,1, 'cannot be assessed'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt0'), 2,1, 'no evidence of primary tumor'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='ptis'), 3,1, 'carcinoma in situ'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt1a'), 4,1, 'tumor invades lamina propria'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt1b'), 5,1, 'tumor invades submucosa'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt2'), 6,1, 'tumor invades muscularis propria'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt3'), 7,1, 'tumor invades through the muscularis propria into the subserosa or into the nonperitonealized perimuscular tissue (mesentery or retroperitoneum) with extension 2 cm or less'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt4a'), 8,1, 'tumor penetrates the visceral peritoneum'),
((select id from structure_value_domains where domain_name='path_tstage_sm'), (select id from structure_permissible_values where value='pt4b'), 9,1, 'tumor directly invades other organs or structures');

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
where tablename='dxd_liver_metastases' and field='microsatellite_instability_grade';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='microsatellite_instability_grade')
where tablename='dxd_liver_metastases' and field='microsatellite_instability_grade';

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
where tablename='dxd_liver_metastases' and field='mlh1_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_liver_metastases' and field='mlh1_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_liver_metastases' and field='msh2_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_liver_metastases' and field='msh6_result';

update structure_fields
set structure_value_domain=(select id from structure_value_domains where domain_name='immunohistochemistry_sm')
where tablename='dxd_liver_metastases' and field='pms2_result';

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
-- WHERE structure_id = (SELECT id FROM structures WHERE alias='dx_liver_metastases');

update structures
set flag_add_columns = 0, flag_edit_columns =0
where alias = 'dx_liver_metastases';

UPDATE structures AS str, structure_formats AS stfo, structure_fields AS sf 
SET stfo.flag_index = '0'
WHERE str.alias = 'dx_liver_metastases'
AND str.id = stfo.structure_id 
AND stfo.structure_field_id = sf.id
AND sf.field NOT IN ('dx_date', 'tumor_site', 'tumour_grade', 'histologic_type');




