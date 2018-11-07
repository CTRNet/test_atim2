-- ------------------------------------------------------
-- ATiM v2.6.5 Upgrade Script
-- version: 2.6.5.1
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

ALTER TABLE groups MODIFY deleted tinyint(3) unsigned NOT NULL DEFAULT '0';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3220: Unable to export report in CSV when the number of records is > databrowser_and_report_results_display_limit
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('lines','Lines','Lignes');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Created xenograft derivative (tissue, blood, dna, rna, etc)
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT "New Sample Types: Created 'Xeno' derivatives to record any tissue, blood (plus all derivatives) collected from animal used for 'Xenograft' and different than human tissues plus all linked aliquots." AS '### MESSAGE ###'
UNION ALL
SELECT "All controls will be disabled." AS '### MESSAGE ###'
UNION ALL
SELECT "1- Comment line if already created in the custom version. 2- Activate sample_type and aliquot_type if required into your bank." AS '### MESSAGE ###';

CREATE TABLE IF NOT EXISTS sd_xeno_blood_cells (
  sample_master_id int(11) NOT NULL,
  KEY FK_sd_xeno_blood_cells_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS sd_xeno_blood_cells_revs (
  sample_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `sd_xeno_blood_cells`
  ADD CONSTRAINT FK_sd_xeno_blood_cells_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

CREATE TABLE IF NOT EXISTS sd_xeno_dnas (
  sample_master_id int(11) NOT NULL,
  KEY FK_sd_xeno_dnas_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS sd_xeno_dnas_revs (
  sample_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `sd_xeno_dnas`
  ADD CONSTRAINT FK_sd_xeno_dnas_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

CREATE TABLE IF NOT EXISTS sd_xeno_pbmcs (
  sample_master_id int(11) NOT NULL,
  KEY FK_sd_xeno_pbmcs_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS sd_xeno_pbmcs_revs (
  sample_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `sd_xeno_pbmcs`
  ADD CONSTRAINT FK_sd_xeno_pbmcs_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

CREATE TABLE IF NOT EXISTS sd_xeno_plasmas (
  sample_master_id int(11) NOT NULL,
  KEY FK_sd_xeno_plasmas_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS sd_xeno_plasmas_revs (
  sample_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `sd_xeno_plasmas`
  ADD CONSTRAINT FK_sd_xeno_plasmas_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

CREATE TABLE IF NOT EXISTS sd_xeno_rnas (
  sample_master_id int(11) NOT NULL,
  KEY FK_sd_xeno_rnas_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS sd_xeno_rnas_revs (
  sample_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `sd_xeno_rnas`
  ADD CONSTRAINT FK_sd_xeno_rnas_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

CREATE TABLE IF NOT EXISTS sd_xeno_serums (
  sample_master_id int(11) NOT NULL,
  KEY FK_sd_xeno_serums_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS sd_xeno_serums_revs (
  sample_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `sd_xeno_serums`
  ADD CONSTRAINT FK_sd_xeno_serums_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

CREATE TABLE IF NOT EXISTS sd_xeno_bloods (
  sample_master_id int(11) NOT NULL,
  blood_type varchar(30) DEFAULT NULL,
  KEY FK_sd_xeno_bloods_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS sd_xeno_bloods_revs (
  sample_master_id int(11) NOT NULL,
  blood_type varchar(30) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `sd_xeno_bloods`
  ADD CONSTRAINT FK_sd_xeno_bloods_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

CREATE TABLE IF NOT EXISTS sd_xeno_tissues (
  sample_master_id int(11) NOT NULL,
  tissue_source varchar(50) DEFAULT NULL,
  tissue_laterality varchar(30) DEFAULT NULL,
  KEY FK_sd_xeno_tissues_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS sd_xeno_tissues_revs (
  sample_master_id int(11) NOT NULL,
  tissue_source varchar(50) DEFAULT NULL,
  tissue_laterality varchar(30) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
ALTER TABLE `sd_xeno_tissues`
  ADD CONSTRAINT FK_sd_xeno_tissues_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);

INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('xeno-blood', 'derivative', 'sd_xeno_bloods,derivatives', 'sd_xeno_bloods', 0, 'xeno-blood'),
('xeno-tissue', 'derivative', 'sd_xeno_tissues,derivatives', 'sd_xeno_tissues', 0, 'xeno-tissue'),
('xeno-blood cell', 'derivative', 'derivatives', 'sd_xeno_blood_cells', 0, 'xeno-blood cell'),
('xeno-pbmc', 'derivative', 'derivatives', 'sd_xeno_pbmcs', 0, 'xeno-pbmc'),
('xeno-plasma', 'derivative', 'derivatives', 'sd_xeno_plasmas', 0, 'xeno-plasma'),
('xeno-serum', 'derivative', 'derivatives', 'sd_xeno_serums', 0, 'xeno-serum'),
('xeno-dna', 'derivative', 'derivatives', 'sd_xeno_dnas', 0, 'xeno-dna'),
('xeno-rna', 'derivative', 'derivatives', 'sd_xeno_rnas', 0, 'xeno-rna');

INSERT INTO structures(`alias`) VALUES ('sd_xeno_tissues');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'tissue_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') , '0', '', '', '', 'tissue source', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_xeno_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue source' AND `language_tag`=''), '1', '441', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='sd_xeno_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '444', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structures(`alias`) VALUES ('sd_xeno_bloods');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_xeno_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='blood_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='blood tube type' AND `language_tag`=''), '1', '441', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'xenograft'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-blood'), 0, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'xenograft'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-tissue'), 0, NULL),

((SELECT id FROM sample_controls WHERE sample_type = 'xeno-blood'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-blood cell'), 0, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-blood'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-pbmc'), 0, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-blood'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-plasma'), 0, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-blood'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-serum'), 0, NULL),

((SELECT id FROM sample_controls WHERE sample_type = 'xeno-tissue'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-dna'), 0, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-pbmc'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-dna'), 0, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-blood cell'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-dna'), 0, NULL),

((SELECT id FROM sample_controls WHERE sample_type = 'xeno-tissue'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-rna'), 0, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-pbmc'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-rna'), 0, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-blood cell'), (SELECT id FROM sample_controls WHERE sample_type = 'xeno-rna'), 0, NULL);

INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-tissue'), 'tube', '', '', 'ad_tubes', NULL, 0, 'Specimen tube', 0, 'xeno-tissue|tube'),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-tissue'), 'block', NULL, 'ad_xeno_tiss_blocks', 'ad_blocks', NULL, 0, 'Tissue block', 0, 'xeno-tissue|block'),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-tissue'), 'slide', '', 'ad_xeno_tiss_slides', 'ad_tissue_slides', NULL, 0, 'Tissue slide', 0, 'xeno-tissue|slide'),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-tissue'), 'core', '', '', 'ad_tissue_cores', NULL, 0, 'Tissue core', 0, 'xeno-tissue|core'),

((SELECT id FROM sample_controls WHERE sample_type = 'xeno-blood'), 'tube', '(ml)', 'ad_xeno_tubes_incl_ml_vol', 'ad_tubes', 'ml', 0, 'Derivative tube requiring volume in ml', 0, 'xeno-blood|tube'),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-plasma'), 'tube', '(ml)', 'ad_xeno_tubes_incl_ml_vol,ad_hemolysis', 'ad_tubes', 'ml', 0, 'Derivative tube requiring volume in ml', 0, 'xeno-plasma|tube'),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-serum'), 'tube', '(ml)', 'ad_xeno_tubes_incl_ml_vol,ad_hemolysis', 'ad_tubes', 'ml', 0, 'Derivative tube requiring volume in ml', 0, 'xeno-serum|tube'),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-blood cell'), 'tube', '', 'ad_xeno_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', 0, 'Derivative tube requiring volume in ml specific for cells', 0, 'xeno-blood cell|tube'),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-pbmc'), 'tube', '', 'ad_xeno_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', 0, 'Derivative tube requiring volume in ml specific for cells', 0, 'xeno-pbmc|tube'),

((SELECT id FROM sample_controls WHERE sample_type = 'xeno-dna'), 'tube', '(ul + conc)', 'ad_xeno_tubes_incl_ul_vol_and_conc', 'ad_tubes', 'ul', 0, 'Derivative tube requiring volume in ul and concentration', 0, 'xeno-dna|tube'),
((SELECT id FROM sample_controls WHERE sample_type = 'xeno-rna'), 'tube', '(ul + conc)', 'ad_xeno_tubes_incl_ul_vol_and_conc', 'ad_tubes', 'ul', 0, 'Derivative tube requiring volume in ul and concentration', 0, 'xeno-rna|tube');

INSERT INTO structures(`alias`) VALUES ('ad_xeno_tiss_blocks');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_xeno_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='block type' AND `language_tag`=''), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structures(`alias`) VALUES ('ad_xeno_tiss_slides');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_xeno_tiss_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='immunochemistry' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='immunochemistry code' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structures(`alias`) VALUES ('ad_xeno_tubes_incl_ml_vol');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_xeno_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0');

INSERT INTO structures(`alias`) VALUES ('ad_xeno_cell_tubes_incl_ml_vol');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_xeno_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cell count' AND `language_tag`=''), '1', '75', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '76', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='concentration' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='aliquot concentration' AND `language_tag`=''), '1', '77', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_cell_tubes' AND `field`='concentration_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_concentration_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '78', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structures(`alias`) VALUES ('ad_xeno_tubes_incl_ul_vol_and_conc');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_xeno_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='current volume' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '72', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '74', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '1', '1', '1', '1', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='concentration' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='aliquot concentration' AND `language_tag`=''), '1', '75', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_xeno_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='concentration_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '76', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO `realiquoting_controls` (`parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) VALUES
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|tube'), 0, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|block'), 0, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|slide'), 0, NULL),

((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|block'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|block'), 0, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|block'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|slide'), 0, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|block'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|core'), 0, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|block'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-tissue|tube'), 0, NULL),

((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-blood|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-blood|tube'), 0, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-plasma|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-plasma|tube'), 0, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-serum|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-serum|tube'), 0, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-blood cell|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-blood cell|tube'), 0, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-pbmc|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-pbmc|tube'), 0, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-dna|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-dna|tube'), 0, NULL),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-rna|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'xeno-rna|tube'), 0, NULL);

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('xeno_tissue_source_list', "StructurePermissibleValuesCustom::getCustomDropdown('Xenograft Tissues Sources')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Xenograft Tissues Sources', 1, 50, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Xenograft Tissues Sources');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('liver', 'Liver',  'Foie', '1', @control_id, NOW(), NOW(), 1, 1),
('lung', 'Lung',  'Poumon', '1', @control_id, NOW(), NOW(), 1, 1),
('kidney', 'Kidney',  'Rein', '1', @control_id, NOW(), NOW(), 1, 1),
('pancreas', 'Pancreas',  'Pancréas', '1', @control_id, NOW(), NOW(), 1, 1),
('ovary', 'Ovary',  'Ovaire', '1', @control_id, NOW(), NOW(), 1, 1),
('intestine', 'Intestine',  'Intestin', '1', @control_id, NOW(), NOW(), 1, 1),
('heart', 'Heart',  'Coeur', '1', @control_id, NOW(), NOW(), 1, 1),
('diaphragm', 'Diaphragm',  'Diaphragme', '1', @control_id, NOW(), NOW(), 1, 1),
('subcutaneous tumor', 'Subcutaneous Tumor',  'Tumeur sous-cutanée', '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='xeno_tissue_source_list')  WHERE model='SampleDetail' AND tablename='' AND field='tissue_source' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list');

INSERT INTO i18n (id,en,fr)
VALUES
('xeno-blood', 'Xeno-Blood', 'Xeno-Sang'),
('xeno-blood cell', 'Xeno-Blood Cells', 'Xeno-Cellules de sang'),
('xeno-dna', 'Xeno-DNA', 'Xeno-ADN'),
('xeno-pbmc', 'Xeno-PBMC', 'Xeno-PBMC'),
('xeno-plasma', 'Xeno-Plasma', 'Xeno-Plasma'),
('xeno-rna', 'Xeno-RNA', 'Xeno-ARN'),
('xeno-serum', 'Xeno-Serum', 'Xeno-Sérum'),
('xeno-tissue', 'Xeno-Tissue', 'Xeno-Tissu');

-- ---------------------------------------------------------------------------------------------------------------------
-- Changed process to display all records linked to a study
-- ---------------------------------------------------------------------------------------------------------------------

SELECT "Changed way all records linked to a study are displayed. Please review code of StudySummary.listAllLinkedRecords() and change custom code if required." AS '### MESSAGE ###';

-- ---------------------------------------------------------------------------------------------------------------------
-- Issue #3247: Be able to link participant identifiers to a study
-- ---------------------------------------------------------------------------------------------------------------------

ALTER TABLE `misc_identifiers` ADD COLUMN `study_summary_id` int(11) DEFAULT NULL;
ALTER TABLE `misc_identifiers_revs` ADD COLUMN `study_summary_id` int(11) DEFAULT NULL;
ALTER TABLE `misc_identifiers`
  ADD CONSTRAINT `FK_misc_identifiers_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
ALTER TABLE misc_identifier_controls ADD COLUMN flag_link_to_study tinyint(1) DEFAULT '0';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'MiscIdentifier', 'misc_identifiers', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '0', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='miscidentifiers'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '0', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structures(`alias`) VALUES ('miscidentifiers_study');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='miscidentifiers_study'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '0', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `field`='study_summary_id'), 'notEmpty', '');

UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='incrementedmiscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifierControl' AND `tablename`='misc_identifier_controls' AND `field`='misc_identifier_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='incrementedmiscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='14' WHERE structure_id=(SELECT id FROM structures WHERE alias='incrementedmiscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifierControl' AND `tablename`='misc_identifier_controls' AND `field`='misc_identifier_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='12' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='14' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- Disable option
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

SELECT "Added option to link a MiscIdentifier to a study." AS '### MESSAGE ###'
UNION ALL
SELECT "To activate option: Run following queries and change value of the misc_identifier_controls.flag_link_to_study to 1." AS '### MESSAGE ###'
UNION ALL
SELECT "UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');" AS '### MESSAGE ###'
UNION ALL
SELECT "UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');" AS '### MESSAGE ###';

INSERT IGNORE INTO i18n (id,en,fr)
VALUES 
('study/project is assigned to a participant', 
'Your data cannot be deleted! This study/project is linked to a participant. ',
"Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à un patient. ");

-- ---------------------------------------------------------------------------------------------------------------------
-- Issue #3248: Be able to link consents to a study 
-- ---------------------------------------------------------------------------------------------------------------------

ALTER TABLE `consent_masters` ADD COLUMN `study_summary_id` int(11) DEFAULT NULL;
ALTER TABLE `consent_masters_revs` ADD COLUMN `study_summary_id` int(11) DEFAULT NULL;
ALTER TABLE `consent_masters`
  ADD CONSTRAINT `FK_consent_masters_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study', '');
INSERT INTO structures(`alias`) VALUES ('consent_masters_study');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters_study'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

SELECT "Added option to link a ConsentMaster to a study. (See structures 'consent_masters_study')." AS '### MESSAGE ###';

INSERT IGNORE INTO i18n (id,en,fr)
VALUES 
('study/project is assigned to a consent', 
'Your data cannot be deleted! This study/project is linked to a consent. ',
"Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à un consentement. ");

-- ---------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr)
VALUES
('your connection has been temporarily disabled',
'Due to too many invalid login attempts your account has been temporarily disabled',
"À la suite d'un trop grand nombre de tentatives infructueuses de connexion, votre compte a été temporairement désactivé.");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.5', NOW(),'6230','n/a');
