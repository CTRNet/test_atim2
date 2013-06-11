-- NPTTB Custom Script
-- Version: v0.6
-- ATiM Version: v2.5.2

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.6 DEV', '');
	
/*
	------------------------------------------------------------
	Eventum ID: 2552 - Add new specimen - CSF 
	------------------------------------------------------------
*/

-- Add new type to controls table
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
 ('csf', 'specimen', 'sd_spe_csf,specimens', 'sd_spe_csfs', 0, 'csf');

-- Create empty structure for new CSF type
INSERT INTO `structures` (`alias`) VALUES ('sd_spe_csf');

-- Build table and rev for CSF
CREATE TABLE `sd_spe_csfs` (
  `sample_master_id` int(11) NOT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  KEY `FK_sd_spe_csfs_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_csfs_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_spe_csfs_revs` (
  `sample_master_id` int(11) NOT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Enable for use
INSERT INTO `parent_to_derivative_sample_controls` (`derivative_sample_control_id`, `flag_active`) VALUES ((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf' AND `detail_form_alias` = 'sd_spe_csf,specimens'), '1');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('csf', 'CSF', '');

-- Add tables for CSF derivatives (supernataunt and cells)

CREATE TABLE `sd_der_csf_sups` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_csf_sups_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_csf_sups_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_der_csf_sups_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_der_csf_cells` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_csf_cells_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_csf_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_der_csf_cells_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Add new type to controls table
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('csf supernatant', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_csf_sups', '0', 'csf supernatant'),
('csf cells', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_csf_cells', '0', 'csf cells');

-- Enable for use
INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
 ((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf' AND `detail_form_alias` = 'sd_spe_csf,specimens'), (SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf supernatant' AND `detail_form_alias` = 'sd_undetailed_derivatives,derivatives'), '1'),
 ((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf' AND `detail_form_alias` = 'sd_spe_csf,specimens'), (SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf cells' AND `detail_form_alias` = 'sd_undetailed_derivatives,derivatives'), '1');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('csf cells', 'CSF Cells', ''),
	('csf supernatant', 'CSF Supernatant', '');


-- Aliquot for CSF specimen
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf' AND `detail_form_alias` = 'sd_spe_csf,specimens'), 'tube', '(ul)', 'ad_spec_tubes_incl_ul_vol', 'ad_tubes', 'ul', '1', 'Specimen tube requiring volume in ul', '0', 'csf|tube');

-- Structure for ul specimen tube
INSERT INTO `structures` (`alias`) VALUES ('ad_spec_tubes_incl_ul_vol');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='lot number' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '1', 'inv_coll_to_stor_spent_time_msg_defintion', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

 
-- Aliquot for CSF Cell
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf cells' AND `detail_form_alias` = 'sd_undetailed_derivatives,derivatives'), 'tube', '(ul)', 'ad_der_tubes_incl_ul_vol', 'ad_tubes', 'ul', '1', 'Derivative tube requiring volume in ul', '0', 'csf cells|tube');

-- Aliquot for CSF Supernatant
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf supernatant' AND `detail_form_alias` = 'sd_undetailed_derivatives,derivatives'), 'tube', '(ul)', 'ad_der_tubes_incl_ul_vol', 'ad_tubes', 'ul', '1', 'Derivative tube requiring volume in ul', '0', 'csf supernatant|tube');

-- Structure for ul derivative tube
INSERT INTO `structures` (`alias`) VALUES ('ad_der_tubes_incl_ul_vol');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='lot number' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '1', 'collection to storage spent time (min)', '0', '', '1', 'inv_coll_to_stor_spent_time_msg_defintion', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

/*
	------------------------------------------------------------
	Eventum ID: 2553 - Tissue Source field - Add values
	------------------------------------------------------------
*/

-- Add new custom field
ALTER TABLE `sd_spe_tissues` ADD COLUMN `npttb_tissue_source` VARCHAR(100) NULL DEFAULT NULL  AFTER `tissue_source` ;
ALTER TABLE `sd_spe_tissues_revs` ADD COLUMN `npttb_tissue_source` VARCHAR(100) NULL DEFAULT NULL  AFTER `tissue_source` ;

-- Create new custom tissue source value domain
INSERT INTO `structure_value_domains` (`domain_name`) VALUES ('npttb_tissue_source');

INSERT INTO structure_permissible_values (value, language_alias) VALUES("Abdominal Cavity", "npttb Abdominal Cavity");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Abdominal Cavity" AND language_alias="npttb Abdominal Cavity"), "10", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Adrenal Gland", "npttb Adrenal Gland");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Adrenal Gland" AND language_alias="npttb Adrenal Gland"), "20", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Appendix", "npttb Appendix");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Appendix" AND language_alias="npttb Appendix"), "30", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Biliary Tract", "npttb Biliary Tract");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Biliary Tract" AND language_alias="npttb Biliary Tract"), "40", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Bladder", "npttb Bladder");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Bladder" AND language_alias="npttb Bladder"), "50", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Blood", "npttb Blood");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Blood" AND language_alias="npttb Blood"), "60", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Bone", "npttb Bone");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Bone" AND language_alias="npttb Bone"), "70", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Bone Marrow", "npttb Bone Marrow");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Bone Marrow" AND language_alias="npttb Bone Marrow"), "90", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Brain", "npttb Brain");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Brain" AND language_alias="npttb Brain"), "100", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Breast", "npttb Breast");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Breast" AND language_alias="npttb Breast"), "110", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Colon", "npttb Colon");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Colon" AND language_alias="npttb Colon"), "120", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Ear", "npttb Ear");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Ear" AND language_alias="npttb Ear"), "130", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Endocrine Pancreas", "npttb Endocrine Pancreas");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Endocrine Pancreas" AND language_alias="npttb Endocrine Pancreas"), "140", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Epididymis", "npttb Epididymis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Epididymis" AND language_alias="npttb Epididymis"), "150", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Esophagus", "npttb Esophagus");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Esophagus" AND language_alias="npttb Esophagus"), "160", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Eye", "npttb Eye");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Eye" AND language_alias="npttb Eye"), "170", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Fallopian Tube", "npttb Fallopian Tube");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Fallopian Tube" AND language_alias="npttb Fallopian Tube"), "180", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Gallbladder", "npttb Gallbladder");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Gallbladder" AND language_alias="npttb Gallbladder"), "190", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Heart", "npttb Heart");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Heart" AND language_alias="npttb Heart"), "200", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Intestine", "npttb Intestine");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Intestine" AND language_alias="npttb Intestine"), "210", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Kidney ", "npttb Kidney ");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Kidney " AND language_alias="npttb Kidney "), "220", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Liver", "npttb Liver");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Liver" AND language_alias="npttb Liver"), "230", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Lung", "npttb Lung");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Lung" AND language_alias="npttb Lung"), "240", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Lymph Node", "npttb Lymph Node");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Lymph Node" AND language_alias="npttb Lymph Node"), "250", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Mediastinum", "npttb Mediastinum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Mediastinum" AND language_alias="npttb Mediastinum"), "260", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Meninges ", "npttb Meninges ");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Meninges " AND language_alias="npttb Meninges "), "270", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Mucosa-Associated Lymphoid Tissue", "npttb Mucosa-Associated Lymphoid Tissue");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Mucosa-Associated Lymphoid Tissue" AND language_alias="npttb Mucosa-Associated Lymphoid Tissue"), "280", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Musculoskeletal system ", "npttb Musculoskeletal system ");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Musculoskeletal system " AND language_alias="npttb Musculoskeletal system "), "290", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Nose", "npttb Nose");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Nose" AND language_alias="npttb Nose"), "300", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Oral Cavity", "npttb Oral Cavity");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Oral Cavity" AND language_alias="npttb Oral Cavity"), "310", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Orbit ", "npttb Orbit ");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Orbit " AND language_alias="npttb Orbit "), "320", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Ovary", "npttb Ovary");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Ovary" AND language_alias="npttb Ovary"), "330", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Parathyroid", "npttb Parathyroid");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Parathyroid" AND language_alias="npttb Parathyroid"), "340", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Penis", "npttb Penis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Penis" AND language_alias="npttb Penis"), "350", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Pericardial Cavity", "npttb Pericardial Cavity");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Pericardial Cavity" AND language_alias="npttb Pericardial Cavity"), "360", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Peritoneal Cavity", "npttb Peritoneal Cavity");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Peritoneal Cavity" AND language_alias="npttb Peritoneal Cavity"), "370", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Pineal", "npttb Pineal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Pineal" AND language_alias="npttb Pineal"), "380", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Pituitary", "npttb Pituitary");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Pituitary" AND language_alias="npttb Pituitary"), "390", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Pleural Cavity", "npttb Pleural Cavity");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Pleural Cavity" AND language_alias="npttb Pleural Cavity"), "400", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Prostate", "npttb Prostate");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Prostate" AND language_alias="npttb Prostate"), "410", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Salivary Gland", "npttb Salivary Gland");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Salivary Gland" AND language_alias="npttb Salivary Gland"), "420", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Seminal Vesicle", "npttb Seminal Vesicle");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Seminal Vesicle" AND language_alias="npttb Seminal Vesicle"), "430", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Skin", "npttb Skin");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Skin" AND language_alias="npttb Skin"), "440", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Small intestine", "npttb Small intestine");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Small intestine" AND language_alias="npttb Small intestine"), "450", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Soft tissue", "npttb Soft tissue");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Soft tissue" AND language_alias="npttb Soft tissue"), "460", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Spermatic Cord", "npttb Spermatic Cord");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Spermatic Cord" AND language_alias="npttb Spermatic Cord"), "470", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Spinal Cord", "npttb Spinal Cord");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Spinal Cord" AND language_alias="npttb Spinal Cord"), "480", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Spleen", "npttb Spleen");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Spleen" AND language_alias="npttb Spleen"), "490", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Stomach", "npttb Stomach");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Stomach" AND language_alias="npttb Stomach"), "500", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Testis ", "npttb Testis ");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Testis " AND language_alias="npttb Testis "), "510", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Thoracic Cavity", "npttb Thoracic Cavity");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Thoracic Cavity" AND language_alias="npttb Thoracic Cavity"), "520", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Thymus Gland", "npttb Thymus Gland");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Thymus Gland" AND language_alias="npttb Thymus Gland"), "530", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Thyroid", "npttb Thyroid");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Thyroid" AND language_alias="npttb Thyroid"), "540", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Tongue", "npttb Tongue");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Tongue" AND language_alias="npttb Tongue"), "550", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Tonsil", "npttb Tonsil");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Tonsil" AND language_alias="npttb Tonsil"), "560", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Trachea ", "npttb Trachea ");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Trachea " AND language_alias="npttb Trachea "), "570", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Ureter", "npttb Ureter");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Ureter" AND language_alias="npttb Ureter"), "580", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Urethra", "npttb Urethra");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Urethra" AND language_alias="npttb Urethra"), "590", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Uterus", "npttb Uterus");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Uterus" AND language_alias="npttb Uterus"), "600", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Vagina", "npttb Vagina");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Vagina" AND language_alias="npttb Vagina"), "610", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Vas Deferens", "npttb Vas Deferens");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Vas Deferens" AND language_alias="npttb Vas Deferens"), "620", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Vulva", "npttb Vulva");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_source"), (SELECT id FROM structure_permissible_values WHERE value="Vulva" AND language_alias="npttb Vulva"), "630", "1");

-- Translations for tissue source
REPLACE INTO `i18n` (`id`, `en`) VALUES
('npttb Abdominal Cavity', 'Abdominal Cavity'),
('npttb Adrenal Gland', 'Adrenal Gland'),
('npttb Appendix', 'Appendix'),
('npttb Biliary Tract', 'Biliary Tract'),
('npttb Bladder', 'Bladder'),
('npttb Blood', 'Blood'),
('npttb Bone', 'Bone'),
('npttb Bone Marrow', 'Bone Marrow'),
('npttb Brain', 'Brain'),
('npttb Breast', 'Breast'),
('npttb Colon', 'Colon'),
('npttb Ear', 'Ear'),
('npttb Endocrine Pancreas', 'Endocrine Pancreas'),
('npttb Epididymis', 'Epididymis'),
('npttb Esophagus', 'Esophagus'),
('npttb Eye', 'Eye'),
('npttb Fallopian Tube', 'Fallopian Tube'),
('npttb Gallbladder', 'Gallbladder'),
('npttb Heart', 'Heart'),
('npttb Intestine', 'Intestine'),
('npttb Kidney ', 'Kidney '),
('npttb Liver', 'Liver'),
('npttb Lung', 'Lung'),
('npttb Lymph Node', 'Lymph Node'),
('npttb Mediastinum', 'Mediastinum'),
('npttb Meninges ', 'Meninges '),
('npttb Mucosa-Associated Lymphoid Tissue', 'Mucosa-Associated Lymphoid Tissue'),
('npttb Musculoskeletal system ', 'Musculoskeletal system '),
('npttb Nose', 'Nose'),
('npttb Oral Cavity', 'Oral Cavity'),
('npttb Orbit ', 'Orbit '),
('npttb Ovary', 'Ovary'),
('npttb Parathyroid', 'Parathyroid'),
('npttb Penis', 'Penis'),
('npttb Pericardial Cavity', 'Pericardial Cavity'),
('npttb Peritoneal Cavity', 'Peritoneal Cavity'),
('npttb Pineal', 'Pineal'),
('npttb Pituitary', 'Pituitary'),
('npttb Pleural Cavity', 'Pleural Cavity'),
('npttb Prostate', 'Prostate'),
('npttb Salivary Gland', 'Salivary Gland'),
('npttb Seminal Vesicle', 'Seminal Vesicle'),
('npttb Skin', 'Skin'),
('npttb Small intestine', 'Small intestine'),
('npttb Soft tissue', 'Soft tissue'),
('npttb Spermatic Cord', 'Spermatic Cord'),
('npttb Spinal Cord', 'Spinal Cord'),
('npttb Spleen', 'Spleen'),
('npttb Stomach', 'Stomach'),
('npttb Testis ', 'Testis '),
('npttb Thoracic Cavity', 'Thoracic Cavity'),
('npttb Thymus Gland', 'Thymus Gland'),
('npttb Thyroid', 'Thyroid'),
('npttb Tongue', 'Tongue'),
('npttb Tonsil', 'Tonsil'),
('npttb Trachea ', 'Trachea '),
('npttb Ureter', 'Ureter'),
('npttb Urethra', 'Urethra'),
('npttb Uterus', 'Uterus'),
('npttb Vagina', 'Vagina'),
('npttb Vas Deferens', 'Vas Deferens'),
('npttb Vulva', 'Vulva');

-- Add to structure, turn off old tissue source
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_tissue_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_tissue_source') , '0', '', '', '', 'npttb tissue source', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_tissue_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_tissue_source')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb tissue source' AND `language_tag`=''), '1', '441', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('npttb tissue source', 'Tissue Source', '');

/*
	------------------------------------------------------------
	Eventum ID: 2554 - DNA/RNA new field - Storage Medium
	------------------------------------------------------------
*/

ALTER TABLE `sd_der_dnas` ADD COLUMN `npttb_storage_medium` VARCHAR(45) NULL DEFAULT NULL AFTER `sample_master_id` ;
ALTER TABLE `sd_der_dnas_revs` ADD COLUMN `npttb_storage_medium` VARCHAR(45) NULL DEFAULT NULL AFTER `sample_master_id` ;

ALTER TABLE `sd_der_rnas` ADD COLUMN `npttb_storage_medium` VARCHAR(45) NULL DEFAULT NULL AFTER `sample_master_id` ;
ALTER TABLE `sd_der_rnas_revs` ADD COLUMN `npttb_storage_medium` VARCHAR(45) NULL DEFAULT NULL AFTER `sample_master_id` ;

-- Value domain for storage medium types
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_storage_medium", "open", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("nuclease-free water", "npttb nuclease-free water");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_storage_medium"), (SELECT id FROM structure_permissible_values WHERE value="nuclease-free water" AND language_alias="npttb nuclease-free water"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Buffer AE", "npttb Buffer AE");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_storage_medium"), (SELECT id FROM structure_permissible_values WHERE value="Buffer AE" AND language_alias="npttb Buffer AE"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Buffer ALO", "npttb Buffer ALO");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_storage_medium"), (SELECT id FROM structure_permissible_values WHERE value="Buffer ALO" AND language_alias="npttb Buffer ALO"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Buffer EB", "npttb Buffer EB");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_storage_medium"), (SELECT id FROM structure_permissible_values WHERE value="Buffer EB" AND language_alias="npttb Buffer EB"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("other", "npttb other");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_storage_medium"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="npttb other"), "5", "1");

REPLACE INTO `i18n` (`id`, `en`) VALUES
('npttb nuclease-free water', 'Nuclease-free water'),
('npttb Buffer AE', 'Buffer AE'),
('npttb Buffer ALO', 'Buffer ALO'),
('npttb Buffer EB', 'Buffer EB'),
('npttb other', 'Other');

-- New structure for RNA/DNA aliquot
INSERT INTO `structures` (`alias`) VALUES ('npttb_dna_details');
INSERT INTO `structures` (`alias`) VALUES ('npttb_rna_details');

-- Add new structure DNA/RNA sample types
UPDATE `sample_controls` SET `detail_form_alias`='sd_undetailed_derivatives,derivatives,npttb_dna_details' WHERE `sample_type` = 'dna';
UPDATE `sample_controls` SET `detail_form_alias`='sd_undetailed_derivatives,derivatives,npttb_rna_details' WHERE `sample_type` = 'rna';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'sd_der_rnas', 'npttb_storage_medium', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_storage_medium') , '0', '', '', '', 'npttb storage medium', ''),
('InventoryManagement', 'AliquotDetail', 'sd_der_dnas', 'npttb_storage_medium', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_storage_medium') , '0', '', '', '', 'npttb storage medium', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='npttb_dna_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='sd_der_dnas' AND `field`='npttb_storage_medium' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_storage_medium')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb storage medium' AND `language_tag`=''), '1', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='npttb_rna_details'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='sd_der_rnas' AND `field`='npttb_storage_medium' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_storage_medium')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb storage medium' AND `language_tag`=''), '1', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`) VALUES
('npttb storage medium', 'Storage Medium');

/*
	------------------------------------------------------------
	Eventum ID: 2555 - Sample Preperation Method
	------------------------------------------------------------
*/

-- Add to table
ALTER TABLE `sd_der_dnas` ADD COLUMN `npttb_prep_method` VARCHAR(100) NULL DEFAULT NULL AFTER `npttb_storage_medium` ;
ALTER TABLE `sd_der_dnas_revs` ADD COLUMN `npttb_prep_method` VARCHAR(100) NULL DEFAULT NULL AFTER `npttb_storage_medium` ;

ALTER TABLE `sd_der_rnas` ADD COLUMN `npttb_prep_method` VARCHAR(100) NULL DEFAULT NULL AFTER `npttb_storage_medium` ;
ALTER TABLE `sd_der_rnas_revs` ADD COLUMN `npttb_prep_method` VARCHAR(100) NULL DEFAULT NULL AFTER `npttb_storage_medium` ;

-- Add value domain for preperation method
INSERT INTO `structure_value_domains` (`domain_name`) VALUES ('npttb_prep_method');
INSERT INTO structure_permissible_values (value, language_alias) VALUES("AllPrep - Qiagen", "npttb AllPrep - Qiagen");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_prep_method"), (SELECT id FROM structure_permissible_values WHERE value="AllPrep - Qiagen" AND language_alias="npttb AllPrep - Qiagen"), "1", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("DNeasy - Qiagen", "npttb DNeasy - Qiagen");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_prep_method"), (SELECT id FROM structure_permissible_values WHERE value="DNeasy - Qiagen" AND language_alias="npttb DNeasy - Qiagen"), "2", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("QIAamp - Qiagen", "npttb QIAamp - Qiagen");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_prep_method"), (SELECT id FROM structure_permissible_values WHERE value="QIAamp - Qiagen" AND language_alias="npttb QIAamp - Qiagen"), "3", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("miRNeasy - Qiagen", "npttb miRNeasy - Qiagen");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_prep_method"), (SELECT id FROM structure_permissible_values WHERE value="miRNeasy - Qiagen" AND language_alias="npttb miRNeasy - Qiagen"), "4", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("RLT - miRNeasy - Qiagen", "npttb RLT - miRNeasy - Qiagen");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_prep_method"), (SELECT id FROM structure_permissible_values WHERE value="RLT - miRNeasy - Qiagen" AND language_alias="npttb RLT - miRNeasy - Qiagen"), "5", "1");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("Ethanol Precipitation", "npttb Ethanol Precipitation");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_prep_method"), (SELECT id FROM structure_permissible_values WHERE value="Ethanol Precipitation" AND language_alias="npttb Ethanol Precipitation"), "6", "1");

REPLACE INTO `i18n` (`id`, `en`) VALUES
('npttb AllPrep - Qiagen', 'AllPrep - Qiagen'),
('npttb DNeasy - Qiagen', 'DNeasy - Qiagen'),
('npttb QIAamp - Qiagen', 'QIAamp - Qiagen'),
('npttb miRNeasy - Qiagen', 'miRNeasy - Qiagen'),
('npttb RLT - miRNeasy - Qiagen', 'RLT - miRNeasy - Qiagen'),
('npttb Ethanol Precipitation', 'Ethanol Precipitation');

-- Add field to DNA/RNA form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_der_rnas', 'npttb_prep_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_prep_method') , '0', '', '', '', 'npttb prep method', ''),
('InventoryManagement', 'SampleDetail', 'sd_der_dnas', 'npttb_prep_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_prep_method') , '0', '', '', '', 'npttb prep method', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='npttb_dna_details'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_dnas' AND `field`='npttb_prep_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_prep_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb prep method' AND `language_tag`=''), '1', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='npttb_rna_details'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='npttb_prep_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_prep_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb prep method' AND `language_tag`=''), '1', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`) VALUES
('npttb prep method', 'Preparation Method');


/*
	------------------------------------------------------------
	Eventum ID: 2556 - Aliquot Label should not be read-only
	------------------------------------------------------------
*/

UPDATE structure_formats SET `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


/*
	------------------------------------------------------------
	Eventum ID: 2560 - Acquisition Label Validation
	------------------------------------------------------------
*/	

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES
 ((SELECT `id` FROM structure_fields WHERE field = 'acquisition_label' AND `tablename` = 'collections'), '/^\\A\\w{2}\\s{1}\\d{2}(-)\\d{5}$/', 'npttb error acquisition label');

REPLACE INTO `i18n` (`id`, `en`) VALUES
('npttb error acquisition label', 'Acquisition label must be AA DD-DDDDD');


/*
	------------------------------------------------------------
	Eventum ID: 2561 - Collection Site Values
	------------------------------------------------------------
*/	
	
INSERT INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`) VALUES
 ((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen collection sites'), 'Foothills Hospital', 'Foothills Hospital', '2', '1', '2013-05-08 10:45:09', '1', '2013-05-08 10:45:09', '1'),
 ((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen collection sites'), "Children's Hospital", "Children's Hospital", '1', '1', '2013-05-08 10:45:09', '1', '2013-05-08 10:45:09', '1');
	
/*
	------------------------------------------------------------
	Eventum ID: 2562 - Collection bank - set default
	------------------------------------------------------------
*/	

UPDATE `banks` SET `name`='NPTTB', `description`='Clark H. Smith Neurologic and Pediatric Tumor and Related Tissue Bank' WHERE `id`='1';


/*
	------------------------------------------------------------
	Eventum ID: 2563 - Add sample prep method to Bone Marrow
	------------------------------------------------------------
*/

ALTER TABLE `sd_spe_bone_marrows` ADD COLUMN `npttb_prep_method` VARCHAR(100) NULL DEFAULT NULL AFTER `collected_volume_unit` ;
ALTER TABLE `sd_spe_bone_marrows_revs` ADD COLUMN `npttb_prep_method` VARCHAR(100) NULL DEFAULT NULL AFTER `collected_volume_unit` ;

-- Add value domain
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_bm_prep_method", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("RBC lysis", "npttb rbc lysis");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_bm_prep_method"), (SELECT id FROM structure_permissible_values WHERE value="RBC lysis" AND language_alias="npttb rbc lysis"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("media", "npttb media");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_bm_prep_method"), (SELECT id FROM structure_permissible_values WHERE value="media" AND language_alias="npttb media"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("no media", "npttb no media");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_bm_prep_method"), (SELECT id FROM structure_permissible_values WHERE value="no media" AND language_alias="npttb no media"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'sd_spe_bone_marrows', 'npttb_prep_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_bm_prep_method') , '0', '', '', '', 'npttb prep method', '');

-- Enable structure for bone marrow fields
UPDATE `sample_controls` SET `detail_form_alias`='specimens, sd_spe_bone_marrows' WHERE `sample_type`='bone marrow';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_bone_marrows', 'npttb_prep_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_bm_prep_method') , '0', '', '', '', 'npttb prep method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bone_marrows'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bone_marrows' AND `field`='npttb_prep_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_bm_prep_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb prep method' AND `language_tag`=''), '1', '444', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`) VALUES
('npttb rbc lysis', 'RBC Lysis'),
('npttb media', 'Media'),
('npttb no media', 'No media');


/*
	------------------------------------------------------------
	Eventum ID: 2564 - Lab Staff and Supplier Dept Values
	------------------------------------------------------------
*/

INSERT INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`) VALUES
 ((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'laboratory staff'), 'colleen anderson', 'Colleen Anderson', '1', '1', '2013-05-08 10:45:09', '1', '2013-05-08 10:45:09', '1'),
 ((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'laboratory staff'), "jen chan", "Jen Chan", '2', '1', '2013-05-08 10:45:09', '1', '2013-05-08 10:45:09', '1');

INSERT INTO `structure_permissible_values_customs` (`control_id`, `value`, `en`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`) VALUES
 ((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen supplier departments'), 'ACH - Pathology Departmen', 'ACH - Pathology Department', '1', '1', '2013-05-08 10:45:09', '1', '2013-05-08 10:45:09', '1'),
 ((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen supplier departments'), "FMC - Pathology Department", "FMC - Pathology Department", '2', '1', '2013-05-08 10:45:09', '1', '2013-05-08 10:45:09', '1'),
 ((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'specimen supplier departments'), "weiss lab", "Weiss Lab", '3', '1', '2013-05-08 10:45:09', '1', '2013-05-08 10:45:09', '1');

 
/*
	------------------------------------------------------------
	Eventum ID: 2582 - Tissue Tube Aliquot - # Pieces
	------------------------------------------------------------
*/

-- Add custom field to table
ALTER TABLE `ad_tubes` ADD COLUMN `npttb_num_pieces` INT(11) NULL AFTER `hemolysis_signs` ;
ALTER TABLE `ad_tubes_revs` ADD COLUMN `npttb_num_pieces` INT(11) NULL AFTER `hemolysis_signs` ;

-- Add structure field for number of pieces
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'npttb_num_pieces', 'integer',  NULL , '0', 'size=10', '', '', 'npttb num pieces', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='npttb_num_pieces' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='npttb num pieces' AND `language_tag`=''), '1', '301', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `flag_addgrid`='1', `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='npttb_num_pieces' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`) VALUES
('npttb num pieces', 'Number of pieces');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='npttb_num_pieces' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

/*
	------------------------------------------------------------
	Eventum ID: 2583 - Urine Aliquot - Additive
	------------------------------------------------------------
*/

-- Add custom field to table
ALTER TABLE `ad_tubes` ADD COLUMN `npttb_urine_additive` VARCHAR(50) NULL AFTER `hemolysis_signs` ;
ALTER TABLE `ad_tubes_revs` ADD COLUMN `npttb_urine_additive` VARCHAR(50) NULL AFTER `hemolysis_signs` ;

-- Create custom structure
INSERT INTO `structures` (`alias`) VALUES ('npttb_urine_tube');

-- Add structure to urine tube
UPDATE `aliquot_controls` SET `detail_form_alias`='ad_spec_tubes_incl_ml_vol,npttb_urine_tube' WHERE `databrowser_label`='urine|tube';

-- Value domain for additive options
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_urine_additives", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("NaAz", "npttb NaAz");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_urine_additives"), (SELECT id FROM structure_permissible_values WHERE value="NaAz" AND language_alias="npttb NaAz"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("none", "npttb none");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_urine_additives"), (SELECT id FROM structure_permissible_values WHERE value="none" AND language_alias="npttb none"), "2", "1");

-- Add field to new custom urine tube
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'npttb_urine_additive', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_urine_additives') , '0', '', '', '', 'npttb urine additive', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='npttb_urine_tube'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='npttb_urine_additive' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_urine_additives')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb urine additive' AND `language_tag`=''), '1', '400', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `flag_addgrid`='1', `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='npttb_urine_tube') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='npttb_urine_additive' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_urine_additives') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`) VALUES
('npttb urine additive', 'Urine Additive'),
('npttb NaAz', 'NaAz'),
('npttb none', 'None');

/*
	------------------------------------------------------------
	Eventum ID: 2615 - Change Acquisition Label
	------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`) VALUES
('acquisition_label', 'SM Number');

/*
	------------------------------------------------------------
	Eventum ID: 2613 - Tissue Type
	------------------------------------------------------------
*/

ALTER TABLE `sd_spe_tissues` ADD COLUMN `npttb_tissue_type` VARCHAR(45) NULL DEFAULT NULL AFTER `tissue_weight_unit` ;
ALTER TABLE `sd_spe_tissues_revs` ADD COLUMN `npttb_tissue_type` VARCHAR(45) NULL DEFAULT NULL AFTER `tissue_weight_unit` ;

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_tissue_type", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_type"), (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="normal"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_type"), (SELECT id FROM structure_permissible_values WHERE value="malignant" AND language_alias="malignant"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_tissue_type"), (SELECT id FROM structure_permissible_values WHERE value="benign" AND language_alias="benign"), "3", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'npttb_tissue_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_tissue_type') , '0', '', '', '', 'npttb tissue type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='npttb_tissue_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_tissue_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb tissue type' AND `language_tag`=''), '1', '442', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');


REPLACE INTO `i18n` (`id`, `en`) VALUES
('npttb tissue type', 'Tissue Type');


/*
	------------------------------------------------------------
	Eventum ID: 2611 - Treatment Facility
	------------------------------------------------------------
*/

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='facility' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="Building A" AND language_alias="building a");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='facility' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="Building B" AND language_alias="building b");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("ACH - Surgical Suite", "ACH - Surgical Suite");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="facility"), (SELECT id FROM structure_permissible_values WHERE value="ACH - Surgical Suite" AND language_alias="ACH - Surgical Suite"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("FMC - Main Surgical Suite", "FMC - Main Surgical Suite");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="facility"), (SELECT id FROM structure_permissible_values WHERE value="FMC - Main Surgical Suite" AND language_alias="FMC - Main Surgical Suite"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("McCaig Day Surgery", "McCaig Day Surgery");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="facility"), (SELECT id FROM structure_permissible_values WHERE value="McCaig Day Surgery" AND language_alias="McCaig Day Surgery"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("McCaig Minor Surgery", "McCaig Minor Surgery");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="facility"), (SELECT id FROM structure_permissible_values WHERE value="McCaig Minor Surgery" AND language_alias="McCaig Minor Surgery"), "6", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="facility"), (SELECT id FROM structure_permissible_values WHERE value="Other" AND language_alias="Other"), "7", "1");


/*
	------------------------------------------------------------
	Eventum ID: 2614 - Hide Lot Number
	------------------------------------------------------------
*/

-- ad_spec_tubes
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ad_spec_tubes_incl_ml_vol
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ad_der_tubes_incl_ml_vol
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ad_der_tubes_incl_ul_vol_and_conc
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ad_der_cell_tubes_incl_ml_vol
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ad_spec_tubes_incl_ul_vol
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ad_der_tubes_incl_ul_vol
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');