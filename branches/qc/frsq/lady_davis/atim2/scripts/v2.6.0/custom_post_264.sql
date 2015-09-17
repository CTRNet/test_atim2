-- -------------------------------------------------------------------------------------------------------------------------
-- Inventory Configuration
-- -------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(195);

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(136, 180);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(27, 31);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Created xenograft derivative (tissue, blood, dna, rna, etc)
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT "New Sample Types: Created 'Xeno' derivatives to record any tissue, blood (plus all derivatives) collected from animal used for 'Xenograft' and different than human tissues plus all linked aliquots." AS '', 'Xeno-MESSAGE ###'
UNION ALL
SELECT "All controls will be disabled." AS '', 'Xeno-MESSAGE ###'
UNION ALL
SELECT "1- Comment line if already created in the custom version. 2- Activate sample_type and aliquot_type if required into your bank." AS '', 'Xeno-MESSAGE ###';

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
((SELECT id FROM structures WHERE alias='ad_xeno_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type'), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');

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
('xeno-pbmc', 'Xeno-Buffy coat', 'Xeno-Buffy coat'),
('xeno-plasma', 'Xeno-Plasma', 'Xeno-Plasma'),
('xeno-rna', 'Xeno-RNA', 'Xeno-ARN'),
('xeno-serum', 'Xeno-Serum', 'Xeno-Sérum'),
('xeno-tissue', 'Xeno-Tissue', 'Xeno-Tissu');

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(196, 199, 200, 201, 197, 202, 205);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(58, 62, 59, 60, 55, 57, 56, 54, 63, 64);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(63, 67, 64, 65, 59, 60, 61, 62, 56, 57, 58, 68, 69);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Xenograft new field
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'qc_lady_animal_id', 'input',  NULL , '0', 'size=15', '', '', 'animal id', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_xenografts'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qc_lady_animal_id' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='animal id' AND `language_tag`=''), '1', '444', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE sd_der_xenografts ADD COLUMN qc_lady_animal_id VARCHAR(20);
ALTER TABLE sd_der_xenografts_revs ADD COLUMN qc_lady_animal_id VARCHAR(20);
INSERT INTO i18n (id,en,fr) VALUES ('animal id', 'Animal ID', 'Animal ID');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6219' WHERE version_number = '2.6.4';

UPDATE versions SET branch_build_number = '6226' WHERE version_number = '2.6.4';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 2015-06-30 xeno tissue tube field
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('qc_lady_ad_xeno_tissue_tubes');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_ad_xeno_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_lady_storage_solution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tube_storage_solution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contains' AND `language_tag`=''), '1', '100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_ad_xeno_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_lady_storage_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tube_storage_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage method' AND `language_tag`=''), '1', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
UPDATE sample_controls sc, aliquot_controls ac
SET ac.detail_form_alias = 'qc_lady_ad_xeno_tissue_tubes'
WHERE sc.sample_type = 'xeno-tissue' AND ac.aliquot_type = 'tube'
AND sc.id = ac.sample_control_id;

UPDATE versions SET branch_build_number = '6233' WHERE version_number = '2.6.4';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 2015-09-17 clean up plasm tube CTAD flagged as EDTA
-- -----------------------------------------------------------------------------------------------------------------------------------

SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn' LIMIT 0 ,1);
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn' LIMIT 0 ,1);
SET @blood_control_id = (select id from sample_controls WHERE sample_type = 'blood');
SET @plasma_control_id = (select id from sample_controls WHERE sample_type = 'plasma');
SET @plasma_tube_control_id = (select id from aliquot_controls WHERE sample_control_id = @plasma_control_id AND aliquot_type = 'tube');
UPDATE sample_masters SampleMasterBlood, sd_spe_bloods SampleDetailBlood, sample_masters SampleMasterPlasma, aliquot_masters AliquotMasterPlasma
SET AliquotMasterPlasma.aliquot_label = 'CTAD',  AliquotMasterPlasma.modified =  @modified, AliquotMasterPlasma.modified_by = @modified_by
WHERE SampleMasterBlood.sample_control_id = @blood_control_id 
AND SampleMasterBlood.id = SampleDetailBlood.sample_master_id AND SampleDetailBlood.blood_type = 'CTAD'
AND SampleMasterBlood.id = SampleMasterPlasma.parent_id AND  SampleMasterPlasma.sample_control_id = @plasma_control_id
AND SampleMasterPlasma.id = AliquotMasterPlasma.sample_master_id AND AliquotMasterPlasma.deleted <> 1 AND AliquotMasterPlasma.aliquot_control_id = @plasma_tube_control_id
AND AliquotMasterPlasma.aliquot_label = 'EDTA';
INSERT INTO aliquot_masters_revs
(id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,
initial_volume,current_volume,in_stock,in_stock_detail,use_counter,study_summary_id,storage_datetime,
storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
modified_by,version_created)
(SELECT id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,
initial_volume,current_volume,in_stock,in_stock_detail,use_counter,study_summary_id,storage_datetime,
storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
modified_by,modified
FROM aliquot_masters WHERE aliquot_control_id = @plasma_tube_control_id AND modified_by = @modified_by AND modified = @modified);
INSERT INTO ad_tubes_revs
(aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,
qc_lady_storage_solution,qc_lady_hemoysis_color,qc_lady_hemoysis_color_other,qc_lady_storage_method,version_created)
(SELECT aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,
qc_lady_storage_solution,qc_lady_hemoysis_color,qc_lady_hemoysis_color_other,qc_lady_storage_method,modified
FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE aliquot_control_id = @plasma_tube_control_id AND modified_by = @modified_by AND modified = @modified);

UPDATE versions SET branch_build_number = '6270' WHERE version_number = '2.6.4';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 2015-09-17 Moved xeno-tissue to xenograffe
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_lady_storage_solution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tube_storage_solution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contains' AND `language_tag`=''), '1', '100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_lady_storage_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tissue_tube_storage_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage method' AND `language_tag`=''), '1', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_xenograft_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

SET @xenograft_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'xenograft');

SET @xenograft_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @xenograft_sample_control_id AND aliquot_type = 'tube');
SET @xenograft_block_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @xenograft_sample_control_id AND aliquot_type = 'block');
SET @xenograft_slide_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @xenograft_sample_control_id AND aliquot_type = 'slide');
SET @xenograft_core_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @xenograft_sample_control_id AND aliquot_type = 'core');

SET @xenograft_tissue_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'xeno-tissue');

SET @xenograft_tissue_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @xenograft_tissue_sample_control_id AND aliquot_type = 'tube');
SET @xenograft_tissue_block_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @xenograft_tissue_sample_control_id AND aliquot_type = 'block');
SET @xenograft_tissue_slide_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @xenograft_tissue_sample_control_id AND aliquot_type = 'slide');
SET @xenograft_tissue_core_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @xenograft_tissue_sample_control_id AND aliquot_type = 'core');

-- Link all xeno-dna/rna of xenograft-tissue to xeno

UPDATE sample_masters SampleMasterXeno, sample_masters SampleMasterXenoTissue, sample_masters SampleMasterXenoDnaRna
SET SampleMasterXenoDnaRna.parent_id = SampleMasterXenoTissue.parent_id, SampleMasterXenoDnaRna.parent_sample_type = 'xenograft'
WHERE SampleMasterXeno.sample_control_id = @xenograft_sample_control_id
AND SampleMasterXenoTissue.sample_control_id = @xenograft_tissue_sample_control_id AND SampleMasterXenoTissue.parent_id = SampleMasterXeno.id
AND SampleMasterXenoDnaRna.parent_id = SampleMasterXenoTissue.id;
UPDATE sample_masters SampleMasterXeno, sample_masters SampleMasterXenoTissue, sample_masters_revs SampleMasterXenoDnaRna
SET SampleMasterXenoDnaRna.parent_id = SampleMasterXenoTissue.parent_id, SampleMasterXenoDnaRna.parent_sample_type = 'xenograft'
WHERE SampleMasterXeno.sample_control_id = @xenograft_sample_control_id
AND SampleMasterXenoTissue.sample_control_id = @xenograft_tissue_sample_control_id AND SampleMasterXenoTissue.parent_id = SampleMasterXeno.id
AND SampleMasterXenoDnaRna.parent_id = SampleMasterXenoTissue.id;

-- Move xeno tissue aliquot to link them to parent_id

UPDATE sample_masters SampleMasterXenoTissue, aliquot_masters AliquotMasterXenoTissue
SET AliquotMasterXenoTissue.sample_master_id =  SampleMasterXenoTissue.parent_id
WHERE SampleMasterXenoTissue.sample_control_id = @xenograft_tissue_sample_control_id
AND AliquotMasterXenoTissue.sample_master_id = SampleMasterXenoTissue.id;
UPDATE sample_masters SampleMasterXenoTissue, aliquot_masters_revs AliquotMasterXenoTissue
SET AliquotMasterXenoTissue.sample_master_id =  SampleMasterXenoTissue.parent_id
WHERE SampleMasterXenoTissue.sample_control_id = @xenograft_tissue_sample_control_id
AND AliquotMasterXenoTissue.sample_master_id = SampleMasterXenoTissue.id;

UPDATE sample_masters SampleMasterXeno, aliquot_masters AliquotMasterXeno
SET AliquotMasterXeno.aliquot_control_id = @xenograft_tube_aliquot_control_id
WHERE SampleMasterXeno.sample_control_id = @xenograft_sample_control_id
AND AliquotMasterXeno.sample_master_id = SampleMasterXeno.id
AND AliquotMasterXeno.aliquot_control_id = @xenograft_tissue_tube_aliquot_control_id;
UPDATE sample_masters SampleMasterXeno, aliquot_masters AliquotMasterXeno
SET AliquotMasterXeno.aliquot_control_id = @xenograft_block_aliquot_control_id
WHERE SampleMasterXeno.sample_control_id = @xenograft_sample_control_id
AND AliquotMasterXeno.sample_master_id = SampleMasterXeno.id
AND AliquotMasterXeno.aliquot_control_id = @xenograft_tissue_block_aliquot_control_id;
UPDATE sample_masters SampleMasterXeno, aliquot_masters AliquotMasterXeno
SET AliquotMasterXeno.aliquot_control_id = @xenograft_slide_aliquot_control_id
WHERE SampleMasterXeno.sample_control_id = @xenograft_sample_control_id
AND AliquotMasterXeno.sample_master_id = SampleMasterXeno.id
AND AliquotMasterXeno.aliquot_control_id = @xenograft_tissue_slide_aliquot_control_id;
UPDATE sample_masters SampleMasterXeno, aliquot_masters AliquotMasterXeno
SET AliquotMasterXeno.aliquot_control_id = @xenograft_core_aliquot_control_id
WHERE SampleMasterXeno.sample_control_id = @xenograft_sample_control_id
AND AliquotMasterXeno.sample_master_id = SampleMasterXeno.id
AND AliquotMasterXeno.aliquot_control_id = @xenograft_tissue_core_aliquot_control_id;

UPDATE sample_masters SampleMasterXeno, aliquot_masters_revs AliquotMasterXeno
SET AliquotMasterXeno.aliquot_control_id = @xenograft_tube_aliquot_control_id
WHERE SampleMasterXeno.sample_control_id = @xenograft_sample_control_id
AND AliquotMasterXeno.sample_master_id = SampleMasterXeno.id
AND AliquotMasterXeno.aliquot_control_id = @xenograft_tissue_tube_aliquot_control_id;
UPDATE sample_masters SampleMasterXeno, aliquot_masters_revs AliquotMasterXeno
SET AliquotMasterXeno.aliquot_control_id = @xenograft_block_aliquot_control_id
WHERE SampleMasterXeno.sample_control_id = @xenograft_sample_control_id
AND AliquotMasterXeno.sample_master_id = SampleMasterXeno.id
AND AliquotMasterXeno.aliquot_control_id = @xenograft_tissue_block_aliquot_control_id;
UPDATE sample_masters SampleMasterXeno, aliquot_masters_revs AliquotMasterXeno
SET AliquotMasterXeno.aliquot_control_id = @xenograft_slide_aliquot_control_id
WHERE SampleMasterXeno.sample_control_id = @xenograft_sample_control_id
AND AliquotMasterXeno.sample_master_id = SampleMasterXeno.id
AND AliquotMasterXeno.aliquot_control_id = @xenograft_tissue_slide_aliquot_control_id;
UPDATE sample_masters SampleMasterXeno, aliquot_masters_revs AliquotMasterXeno
SET AliquotMasterXeno.aliquot_control_id = @xenograft_core_aliquot_control_id
WHERE SampleMasterXeno.sample_control_id = @xenograft_sample_control_id
AND AliquotMasterXeno.sample_master_id = SampleMasterXeno.id
AND AliquotMasterXeno.aliquot_control_id = @xenograft_tissue_core_aliquot_control_id;

DELETE FROM sd_xeno_tissues;
DELETE FROM derivative_details WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE sample_control_id =  @xenograft_tissue_sample_control_id);
DELETE FROM sample_masters WHERE sample_control_id =  @xenograft_tissue_sample_control_id;
DELETE FROM sd_xeno_tissues_revs;
DELETE FROM derivative_details_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE sample_control_id =  @xenograft_tissue_sample_control_id);
DELETE FROM sample_masters_revs WHERE sample_control_id =  @xenograft_tissue_sample_control_id;

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6271' WHERE version_number = '2.6.4';
