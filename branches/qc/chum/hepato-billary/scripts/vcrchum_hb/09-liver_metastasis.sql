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
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'histologic_type', 'histologic type', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'histologic_type_specify', 'histologic type specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
  -- number of lesions
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'lesions_nbr', 'lesions nbr', '', 'integer', '', '',  NULL , '', 'open', 'open', 'open'), 
  -- main lesion size
-- ('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumor_size_greatest_dimension', 'tumor size greatest dimension', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
-- ('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'additional_dimension_a', 'additional dimension a', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
-- ('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'additional_dimension_b', '', 'additional dimension b', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
-- ('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'cannot_be_determined', 'cannot be determined', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
  -- other lesion size
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'other_lesion_size_greatest_dimension', 'other lesion greatest dimension', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'other_lesion_size_additional_dimension_a', 'other lesion additional dimension a', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'other_lesion_size_additional_dimension_b', '', 'additional dimension b', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'other_lesion_size_cannot_be_determined', 'other lesion cannot be determined', '', 'checkbox', '', '',  NULL , '', 'open', 'open', 'open'), 
  -- Localisation
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'tumor_site', 'tumor site', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'tumor_site_specify', 'tumor site specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'),   
  -- percentage
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'necrosis_perc', 'necrosis percentage', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'viable_cells_perc', 'viable cells percentage', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
  -- Margins
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'surgical_resection_margin', 'surgical resection margin', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'distance_of_tumor_from_closest_surgical_resection_margin', 'distance of tumor from closest surgical resection margin', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'distance_unit', '', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'specify_margin', '', 'specify margin', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
  -- parenchyma
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'adjacent_liver_parenchyma', 'adjacent liver parenchyma', '', 'select', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'DiagnosisDetail', 'dxd_liver_metastases', 'adjacent_liver_parenchyma_specify', 'adjacent liver parenchyma specify', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='dx_liver_metastases');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  ), 
'1', '0', '', '1', 'report date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
  -- Histologic Type 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='histologic_type'), 
'1', '1', 'histology', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='histologic_type_specify'), 
'1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
  -- percentage
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='necrosis_perc'), 
'1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='viable_cells_perc'), 
'1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
  -- number of lesions
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='lesions_nbr'), 
'1', '5', 'lesions', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
  -- main lesion size
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_greatest_dimension'), 
'1', '6', '', '1', 'main lesion size greatest dimension', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_a'), 
'1', '7', '', '1', 'main lesion additional dimension a', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='additional_dimension_b'), 
'1', '8', '', '0', '', '1', 'main lesion additional dimension b', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumor_size_cannot_be_determined'), 
'1', '9', '', '1', 'main lesion cannot be determined', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
  -- other lesion size
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='other_lesion_size_greatest_dimension'), 
'1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='other_lesion_size_additional_dimension_a'), 
'1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='other_lesion_size_additional_dimension_b'), 
'1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='other_lesion_size_cannot_be_determined'), 
'1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
  -- Localisation
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='tumor_site'), 
'1', '15', 'tumor site', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='tumor_site_specify'), 
'1', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
  -- Margins
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='surgical_resection_margin'), 
'1', '25', 'margins', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='distance_of_tumor_from_closest_surgical_resection_margin'), 
'1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='distance_unit'), 
'1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='specify_margin'), 
'1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
  -- parenchyma
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='adjacent_liver_parenchyma'), 
'1', '40', 'parenchyma', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='dx_liver_metastases'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='adjacent_liver_parenchyma_specify'), 
'1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
  -- notes
((SELECT id FROM structures WHERE alias='dx_cap_report_smintestines'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes'), 
'1', '44', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1');

INSERT IGNORE INTO i18n (id, en, fr)
VALUES
('adjacent liver parenchyma', 'Adjacent Liver Parenchyma', ''),
('adjacent liver parenchyma specify', 'Specify', ''),
('distance of tumor from closest surgical resection margin', 'Distance of Tumor from Closest Surgical Resection Margin', ''),
('necrosis percentage', 'Necrosis %', ''),
('viable cells percentage', 'Viable Cells %', ''),
('lesions', 'Lesions', ''),
('lesions nbr', 'Lesions Nbr', ''),
('main lesion additional dimension a', 'Main Lesion Additional Dimensions (cm)', ''),
('main lesion additional dimension b', 'x', 'x'),
('main lesion cannot be determined', 'Main Lesion Cannot Be Determined', ''),
('main lesion size greatest dimension', 'Main Lesion Greatest Dimension (cm)', ''),

('other lesion additional dimension a', 'Other Lesion Additional Dimensions (cm)', ''),
('other lesion cannot be determined', 'Other Lesion Greatest Dimension (cm)', ''),
('other lesion greatest dimension', 'Other Lesion Additional Dimensions (cm)', ''),
('parenchyma', 'Parenchyma', ''),
('surgical resection margin', 'Surgical Resection Margin', '');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_liver_metastases' AND `field`='distance_unit' ), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

UPDATE structure_fields
SET structure_value_domain=(select id from structure_value_domains where domain_name='distance_unit')
WHERE tablename ='dxd_liver_metastases' and field = 'distance_unit';

INSERT INTO `structure_value_domains` 
(`domain_name`, `override`, `category`, `source`) 
VALUES 
('qc_hb_liver_metastasis_hitologic_type', 'open', '', null);

UPDATE structure_fields
SET structure_value_domain=(select id from structure_value_domains where domain_name='qc_hb_liver_metastasis_hitologic_type')
WHERE `tablename`='dxd_liver_metastases' AND `field`='histologic_type';

INSERT INTO `structure_value_domains` 
(`domain_name`, `override`, `category`, `source`) 
VALUES 
('qc_hb_positive_negative', 'open', '', null);

UPDATE structure_fields
SET structure_value_domain=(select id from structure_value_domains where domain_name='qc_hb_positive_negative')
WHERE `tablename`='dxd_liver_metastases' AND `field`='surgical_resection_margin';

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active, language_alias)
VALUES 
((select id from structure_value_domains where domain_name='qc_hb_positive_negative'), 
(select id from structure_permissible_values where value='positive'),1, 1,'positive'),
((select id from structure_value_domains where domain_name='qc_hb_positive_negative'), 
(select id from structure_permissible_values where value='negative'), 3,1, 'negative');

INSERT INTO `structure_value_domains` 
(`domain_name`, `override`, `category`, `source`) 
VALUES 
('qc_hb_viable_cells_perc', 'open', '', null);

UPDATE structure_fields
SET structure_value_domain=(select id from structure_value_domains where domain_name='qc_hb_viable_cells_perc')
WHERE `tablename`='dxd_liver_metastases' AND `field`='viable_cells_perc';

INSERT INTO structure_permissible_values (value, language_alias) VALUES
('0-49%', '0-49%'),
('50-99%', '50-99%'),
('100%', '100%');

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active, language_alias)
VALUES 
((select id from structure_value_domains where domain_name='qc_hb_viable_cells_perc'), 
(select id from structure_permissible_values where value='0-49%'),1, 1,'0-49%'),
((select id from structure_value_domains where domain_name='qc_hb_viable_cells_perc'), 
(select id from structure_permissible_values where value='50-99%'), 2,1, '50-99%'),
((select id from structure_value_domains where domain_name='qc_hb_viable_cells_perc'), 
(select id from structure_permissible_values where value='100%'), 3,1, '100%');

UPDATE structure_fields
SET structure_value_domain=(select id from structure_value_domains where domain_name='yes_no_checkbox')
WHERE `tablename`='dxd_liver_metastases' AND `field`='other_lesion_size_cannot_be_determined';

INSERT INTO `structure_value_domains` 
(`domain_name`, `override`, `category`, `source`) 
VALUES 
('qc_hb_adjacent_liver_parenchyma', 'open', '', null);

UPDATE structure_fields
SET structure_value_domain=(select id from structure_value_domains where domain_name='qc_hb_adjacent_liver_parenchyma')
WHERE `tablename`='dxd_liver_metastases' AND `field`='adjacent_liver_parenchyma';

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
('normal', 'normal'),
('steatosis', 'steatosis'),
('steatosis hepatitis', 'steatosis hepatitis'),
('chronic hepatitis', 'chronic hepatitis'),
('cirrhosis', 'cirrhosis'),
('other', 'other');

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active, language_alias)
VALUES 
((select id from structure_value_domains where domain_name='qc_hb_adjacent_liver_parenchyma'), 
(select id from structure_permissible_values where value='normal'),1, 1,'normal'),
((select id from structure_value_domains where domain_name='qc_hb_adjacent_liver_parenchyma'), 
(select id from structure_permissible_values where value='steatosis'),2, 1,'steatosis'),
((select id from structure_value_domains where domain_name='qc_hb_adjacent_liver_parenchyma'), 
(select id from structure_permissible_values where value='steatosis hepatitis'),3, 1,'steatosis hepatitis'),
((select id from structure_value_domains where domain_name='qc_hb_adjacent_liver_parenchyma'), 
(select id from structure_permissible_values where value='chronic hepatitis'),4, 1,'chronic hepatitis'),
((select id from structure_value_domains where domain_name='qc_hb_adjacent_liver_parenchyma'), 
(select id from structure_permissible_values where value='cirrhosis'),5, 1,'cirrhosis'),
((select id from structure_value_domains where domain_name='qc_hb_adjacent_liver_parenchyma'), 
(select id from structure_permissible_values where value='other'),6, 1,'other');

INSERT IGNORE INTO i18n (id, en, fr)
VALUES
('steatosis', 'Steatosis', 'Stéatose'),
('steatosis hepatitis', 'Steatosis Hepatitis', 'Stéatohépatite'),
('chronic hepatitis', 'cChronic Hepatitis', 'Hépatite Chronique');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);


