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

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 2015-10-16 .....
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Change xeno-dna to dna // xeno-rna to rna

SELECT DISTINCT ParentSampleControl.sample_type AS parent, ChildSampleControl.sample_type AS child
FROM sample_masters AS ParentSampleMaster INNER JOIN sample_controls ParentSampleControl ON ParentSampleControl.id = ParentSampleMaster.sample_control_id
INNER JOIN sample_masters AS ChildSampleMaster ON ChildSampleMaster.parent_id = ParentSampleMaster.id INNER JOIN sample_controls ChildSampleControl ON ChildSampleControl.id = ChildSampleMaster.sample_control_id
WHERE ChildSampleControl.sample_type LIKE 'xeno-%';

SET @xeno_dna_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'xeno-dna');
SET @dna_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'dna');
SET @xeno_dna_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @xeno_dna_sample_control_id AND aliquot_type = 'tube');
SET @dna_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @dna_sample_control_id AND aliquot_type = 'tube');
UPDATE sample_masters SET sample_control_id = @dna_sample_control_id WHERE sample_control_id = @xeno_dna_sample_control_id;
UPDATE sample_masters_revs SET sample_control_id = @dna_sample_control_id WHERE sample_control_id = @xeno_dna_sample_control_id;
INSERT INTO sd_der_dnas (sample_master_id) (SELECT sample_master_id FROM sd_xeno_dnas);
DELETE FROM sd_xeno_dnas;
INSERT INTO sd_der_dnas_revs (sample_master_id, version_created) (SELECT sample_master_id, version_created FROM sd_xeno_dnas_revs ORDER BY version_id ASC);
DELETE FROM sd_xeno_dnas_revs;
UPDATE aliquot_masters SET aliquot_control_id =  @dna_tube_aliquot_control_id WHERE aliquot_control_id =  @xeno_dna_tube_aliquot_control_id;
UPDATE aliquot_masters_revs SET aliquot_control_id =  @dna_tube_aliquot_control_id WHERE aliquot_control_id =  @xeno_dna_tube_aliquot_control_id;

SET @xeno_rna_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'xeno-rna');
SET @rna_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'rna');
SET @xeno_rna_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @xeno_rna_sample_control_id AND aliquot_type = 'tube');
SET @rna_tube_aliquot_control_id = (SELECT id FROM aliquot_controls WHERE sample_control_id = @rna_sample_control_id AND aliquot_type = 'tube');
UPDATE sample_masters SET sample_control_id = @rna_sample_control_id WHERE sample_control_id = @xeno_rna_sample_control_id;
UPDATE sample_masters_revs SET sample_control_id = @rna_sample_control_id WHERE sample_control_id = @xeno_rna_sample_control_id;
INSERT INTO sd_der_rnas (sample_master_id) (SELECT sample_master_id FROM sd_xeno_rnas);
DELETE FROM sd_xeno_rnas;
INSERT INTO sd_der_rnas_revs (sample_master_id, version_created) (SELECT sample_master_id, version_created FROM sd_xeno_rnas_revs ORDER BY version_id ASC);
DELETE FROM sd_xeno_rnas_revs;
UPDATE aliquot_masters SET aliquot_control_id =  @rna_tube_aliquot_control_id WHERE aliquot_control_id =  @xeno_rna_tube_aliquot_control_id;
UPDATE aliquot_masters_revs SET aliquot_control_id =  @rna_tube_aliquot_control_id WHERE aliquot_control_id =  @xeno_rna_tube_aliquot_control_id;

-- Add tumore site to secondary display in diagnosis_tree_view

INSERT INTO structures(`alias`) VALUES ('qc_lady_diagnosis_tree_view');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_diagnosis_tree_view'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_secondaries' AND `field`='qc_lady_tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Add pdx identifier

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`) VALUES
('pdx', 1, 10, '', '', 0, 0, 1, 0, '', '');
INSERT IGNORE (id,en,fr) VALUES ('pdx','PDX','PDX');

-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6314' WHERE version_number = '2.6.4';

-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_lady_last_event_recorded', 'date',  NULL , '0', '', '', '', 'last event date recorded', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_lady_last_event_recorded' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last event date recorded' AND `language_tag`=''), '3', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_lady_last_contact_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) VALUES ('last event date recorded', 'Last Event Date Recorded', 'Derniere date d''évenement enregistré');
ALTER TABLE participants 
  ADD COLUMN qc_lady_last_event_recorded DATE DEFAULT NULL,
  ADD COLUMN qc_lady_last_event_recorded_accuracy CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs
  ADD COLUMN qc_lady_last_event_recorded DATE DEFAULT NULL,
  ADD COLUMN qc_lady_last_event_recorded_accuracy CHAR(1) NOT NULL DEFAULT '';

SET @modified_by = (SELECT id fROM users WHERE id = 1);
SET @modified = (SELECT NOW() fROM users WHERE id = 1);
UPDATE participants, (
	SELECT MAX(final_date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
		SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
			select concat(date_of_death,'#',IFNULL(date_of_death_accuracy,'c')) as date_and_accuracy, id as participant_id FROM participants WHERE date_of_death IS NOT NULL AND deleted <> 1
		) Res GROUP BY participant_id
		UNION ALL 
		SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
			select concat(qc_lady_last_contact_date,'#','c') as date_and_accuracy, id as participant_id FROM participants WHERE qc_lady_last_contact_date IS NOT NULL AND deleted <> 1
		) Res GROUP BY participant_id
		UNION ALL 
		SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
			select concat(consent_signed_date,'#',IFNULL(consent_signed_date_accuracy,'c')) as date_and_accuracy, participant_id FROM consent_masters WHERE consent_signed_date IS NOT NULL AND deleted <> 1
		) Res GROUP BY participant_id
		UNION ALL 
		SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
			select concat(status_date,'#',IFNULL(status_date_accuracy,'c')) as date_and_accuracy, participant_id FROM consent_masters WHERE status_date IS NOT NULL AND deleted <> 1
		) Res GROUP BY participant_id
		UNION ALL 
		SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
			select concat(dx_date,'#',IFNULL(dx_date_accuracy,'c')) as date_and_accuracy, participant_id FROM diagnosis_masters WHERE dx_date IS NOT NULL AND deleted <> 1
		) Res GROUP BY participant_id
		UNION ALL 
		SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
			select concat(event_date,'#',IFNULL(event_date_accuracy,'c')) as date_and_accuracy, participant_id FROM event_masters WHERE event_date IS NOT NULL AND deleted <> 1
		) Res GROUP BY participant_id
		UNION ALL 
		SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
			select concat(start_date,'#',IFNULL(start_date_accuracy,'c')) as date_and_accuracy, participant_id FROM treatment_masters WHERE start_date IS NOT NULL AND deleted <> 1
		) Res GROUP BY participant_id
		UNION ALL 
		SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
			select concat(finish_date,'#',IFNULL(finish_date_accuracy,'c')) as date_and_accuracy, participant_id FROM treatment_masters WHERE finish_date IS NOT NULL AND deleted <> 1
		) Res GROUP BY participant_id
		UNION ALL 
		SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
			select concat(SUBSTR(collection_datetime,1,10),'#',IFNULL(collection_datetime_accuracy,'c')) as date_and_accuracy, participant_id FROM collections WHERE collection_datetime IS NOT NULL AND (collection_datetime_accuracy IS NULL OR collection_datetime_accuracy NOT IN ('h', 'i')) AND deleted <> 1
		) Res GROUP BY participant_id
		UNION ALL 
		SELECT max(date_and_accuracy) AS final_date_and_accuracy, participant_id FROM (
			select concat(SUBSTR(collection_datetime,1,10),'#','c') as date_and_accuracy, participant_id FROM collections WHERE collection_datetime IS NOT NULL AND collection_datetime_accuracy IN ('h', 'i') AND deleted <> 1
		) Res GROUP BY participant_id		
	) ResPerParticipant GROUP BY participant_id
) ResFinal
SET qc_lady_last_event_recorded = SUBSTR(final_date_and_accuracy,1,10), 
qc_lady_last_event_recorded_accuracy = SUBSTR(final_date_and_accuracy,12,1),
modified = @modified,
modified_by = @modified_by
WHERE ResFinal.participant_id = participants.id;
INSERT INTO participants_revs (id,title,first_name,middle_name,last_name,date_of_birth,date_of_birth_accuracy,
marital_status,language_preferred,sex,race,vital_status,notes,date_of_death,date_of_death_accuracy,cod_icd10_code,secondary_cod_icd10_code,cod_confirmation_source,
participant_identifier,last_chart_checked_date,last_chart_checked_date_accuracy,last_modification,last_modification_ds_id,
qc_lady_spouse_name,qc_lady_last_contact_date,qc_lady_sardo_data_migration_date,qc_lady_last_event_recorded,qc_lady_last_event_recorded_accuracy,modified_by,version_created)
(SELECT id,title,first_name,middle_name,last_name,date_of_birth,date_of_birth_accuracy,
marital_status,language_preferred,sex,race,vital_status,notes,date_of_death,date_of_death_accuracy,cod_icd10_code,secondary_cod_icd10_code,cod_confirmation_source,
participant_identifier,last_chart_checked_date,last_chart_checked_date_accuracy,last_modification,last_modification_ds_id,
qc_lady_spouse_name,qc_lady_last_contact_date,qc_lady_sardo_data_migration_date,qc_lady_last_event_recorded,qc_lady_last_event_recorded_accuracy,modified_by,modified
FROM participants WHERE modified = @modified AND modified_by = @modified_by);

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6345' WHERE version_number = '2.6.4';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2016-11-25
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_blood_markers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'clinical', 'genetic marker', 1, 'qc_lady_genetic_markers', 'qc_lady_genetic_markers', 0, 'genetic marker', 0, 1, 1);
CREATE TABLE IF NOT EXISTS `qc_lady_genetic_markers` (
  `event_master_id` int(11) NOT NULL,
  `marker` varchar(100) DEFAULT NULL,
  `result` varchar(10) DEFAULT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;CREATE TABLE IF NOT EXISTS `qc_lady_genetic_markers_revs` (
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `marker` varchar(100) DEFAULT NULL,
  `result` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=405 ;
ALTER TABLE `qc_lady_genetic_markers`
  ADD CONSTRAINT `qc_lady_genetic_markers_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);


INSERT INTO structures(`alias`) VALUES ('qc_lady_genetic_markers');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_lady_genetic_markers', "StructurePermissibleValuesCustom::getCustomDropdown('Genetic Markers')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Genetic Markers', 1, 100, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Genetic Markers');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('BRCA_1', '',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('BRCA_2', '',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_lady_genetic_marker_results', "StructurePermissibleValuesCustom::getCustomDropdown('Genetic Marker Results')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Genetic Marker Results', 1, 100, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Genetic Marker Results');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('yes', 'Yes',  'Ou', '1', @control_id, NOW(), NOW(), 1, 1),
('no', 'No',  'Non', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown', 'Unknown', 'Inconnu',  '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_genetic_markers', 'marker', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_genetic_markers') , '0', '', '', '', 'marker', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_genetic_markers', 'result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_genetic_marker_results') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_genetic_markers'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '1', 'cols=40,rows=1', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_genetic_markers'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_genetic_markers' AND `field`='marker'), '2', '140', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_genetic_markers'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_genetic_markers' AND `field`='result'), '2', '141', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_genetic_markers' AND `field`='marker'), 'notEmpty');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_genetic_markers' AND `field`='result'), 'notEmpty');
INSERT INTO i18n (id,en,fr)
VALUES 
('marker', 'Marker', 'Marqueur'),
('genetic marker', 'Genetic Marker', 'Marqueur génétique');

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6598' WHERE version_number = '2.6.4';

-- --------------------------------------------------------------------------------------------------------------------------------------------
-- Upgrade 20170907
-- --------------------------------------------------------------------------------------------------------------------------------------------

-- Treatment

UPDATE treatment_controls SET tx_method = 'hormonotherapy (endocrine)', databrowser_label = 'hormonotherapy (endocrine)' WHERE tx_method = 'hormonotherapy' AND flag_active = '1';
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('hormonotherapy (endocrine)', 'Hormonotherapy (endocrine)', 'Hormonotherapie (endocrine)');

CREATE TABLE `qc_lady_txd_others` (
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `qc_lady_txd_others_revs` (
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `qc_lady_txe_others` (
  `dose` varchar(50) DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `qc_lady_txe_others_revs` (
  `dose` varchar(50) DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `qc_lady_txd_others`
  ADD KEY `qc_lady_txd_others_ibfk_1` (`treatment_master_id`);
ALTER TABLE `qc_lady_txd_others_revs`
  ADD PRIMARY KEY (`version_id`);
ALTER TABLE `qc_lady_txe_others`
  ADD KEY `FK_qc_lady_txe_others_drugs` (`drug_id`),
  ADD KEY `FK_qc_lady_txe_others_treatment_extend_masters` (`treatment_extend_master_id`);
ALTER TABLE `qc_lady_txe_others_revs`
  ADD PRIMARY KEY (`version_id`);
ALTER TABLE `qc_lady_txd_others_revs`
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=251;
ALTER TABLE `qc_lady_txe_others_revs`
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=215;
ALTER TABLE `qc_lady_txd_others`
  ADD CONSTRAINT `qc_lady_txd_others_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
ALTER TABLE `qc_lady_txe_others`
  ADD CONSTRAINT `FK_qc_lady_txe_others_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`),
  ADD CONSTRAINT `FK_qc_lady_txe_others_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`);

INSERT INTO `treatment_extend_controls` (`id`, `detail_tablename`, `detail_form_alias`, `flag_active`, `type`, `databrowser_label`) VALUES
(null, 'qc_lady_txe_others', 'qc_lady_txe_others', 1, 'antibody-based drug', 'antibody-based drug'),
(null, 'qc_lady_txe_others', 'qc_lady_txe_others', 1, 'small molecule-based inhibitor drug', 'small molecule-based inhibitor drug');

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'antibody-based', '', 1, 'qc_lady_txd_others', 'qc_lady_txd_others', 0, NULL, NULL, 'antibody-based', 0, (SELECT id FROM treatment_extend_controls WHERE type = 'antibody-based drug'), 0, 0),
(null, 'small molecule-based inhibitor', '', 1, 'qc_lady_txd_others', 'qc_lady_txd_others', 0, NULL, NULL, 'antibody-based', 0, (SELECT id FROM treatment_extend_controls WHERE type = 'small molecule-based inhibitor drug'), 0, 0);

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('antibody-based drug', 'Antibody-based Drug', 'Molécule à base d''anticorps'),
('small molecule-based inhibitor drug', 'Small Molecule-Based Inhibitor Drug', 'Molécule d''inhibiteur à petite molécule'),
('antibody-based', 'Antibody-based (-ab)', 'À base d''Anticorps (-ab)'),
('small molecule-based inhibitor', 'Small Molecule-Based Inhibitor (-ib)', 'Inhibiteur à petite molécule (-ib)');

INSERT INTO structures(`alias`) VALUES ('qc_lady_txd_others');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_others'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_intent' AND `language_label`='intent' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_others'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_others'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structures(`alias`) VALUES ('qc_lady_txe_others');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txe_others'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qc_lady_txe_immunos' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_dose' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txe_others'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qc_lady_txe_immunos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '1', '0', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('antibody-based', 'Antibody-based', 'À base d''anticorps'),
('small molecule-based inhibitor', 'Small Molecule-Based Inhibitor', 'Inhibiteur à petite molécule');
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("antibody-based", "antibody-based"),("small molecule-based inhibitor", "small molecule-based inhibitor");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="type"), 
(SELECT id FROM structure_permissible_values WHERE value="antibody-based" AND language_alias="antibody-based"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="type"), 
(SELECT id FROM structure_permissible_values WHERE value="small molecule-based inhibitor" AND language_alias="small molecule-based inhibitor"), "1", "1");

CREATE TABLE `qc_lady_txd_clinical_trials` (
  `treatment_master_id` int(11) NOT NULL,
  protocol varchar(250) DEFAULT null,
  placebo char(1) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `qc_lady_txd_clinical_trials_revs` (
  `treatment_master_id` int(11) NOT NULL,
  protocol varchar(250) DEFAULT null,
  placebo char(1) DEFAULT '',
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `qc_lady_txd_clinical_trials`
  ADD KEY `qc_lady_txd_clinical_trials_ibfk_1` (`treatment_master_id`);
ALTER TABLE `qc_lady_txd_clinical_trials_revs`
  ADD PRIMARY KEY (`version_id`);
ALTER TABLE `qc_lady_txd_clinical_trials_revs`
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=251;
ALTER TABLE `qc_lady_txd_clinical_trials`
  ADD CONSTRAINT `qc_lady_txd_clinical_trials_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, 
`flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'clinical trial', '', 1, 'qc_lady_txd_clinical_trials', 'qc_lady_txd_clinical_trials', 0, NULL, NULL, 'clinical trial', 
0, null, 1, 1);
INSERT INTO structures(`alias`) VALUES ('qc_lady_txd_clinical_trials');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_lady_clinical_trial_protocols', "StructurePermissibleValuesCustom::getCustomDropdown('Clinical Trials Protocols')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Clinical Trials Protocols', 1, 250, 'clinical - treatment');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_clinical_trials', 'protocol', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_clinical_trial_protocols') , '0', '', '', '', 'protocol', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_clinical_trials', 'placebo', 'yes_no',  NULL , '0', '', '', '', 'placebo', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_clinical_trials'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_clinical_trials'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_clinical_trials'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_clinical_trials' AND `field`='protocol' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_clinical_trial_protocols')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_clinical_trials'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_clinical_trials' AND `field`='placebo' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='placebo' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('clinical trial', 'Clinical Trial', 'Étude clinique'), ('placebo', 'Placebo', 'Placebo');;
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_clinical_trials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_clinical_trials' AND `field`='protocol' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_clinical_trial_protocols') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_clinical_trials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_clinical_trials' AND `field`='placebo' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_clinical_trials') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats 
SET flag_index = '1' 
WHERE flag_detail = '1' 
AND structure_id IN (SELECT id FROM structures WHERE alias IN ('txd_chemos', 'txd_radiations', 'txd_surgeries', 'txd_surgeries', 'qc_lady_txd_hormonos', 'qc_lady_txd_biopsy_surgeries', 'qc_lady_txd_patho_evaluations', 'qc_lady_txd_biopsy_surgeries', 
'qc_lady_txd_immunos', 'qc_lady_txd_others', 'qc_lady_txd_others', 'qc_lady_txd_clinical_trials'));
UPDATE structure_formats 
SET flag_search = '1' 
WHERE flag_detail = '1' 
AND structure_id IN (SELECT id FROM structures WHERE alias IN ('txd_chemos', 'txd_radiations', 'txd_surgeries', 'txd_surgeries', 'qc_lady_txd_hormonos', 'qc_lady_txd_biopsy_surgeries', 'qc_lady_txd_patho_evaluations', 'qc_lady_txd_biopsy_surgeries', 
'qc_lady_txd_immunos', 'qc_lady_txd_others', 'qc_lady_txd_others', 'qc_lady_txd_clinical_trials'))
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE field = 'notes');
UPDATE structure_formats 
SET flag_search = '0' 
WHERE flag_detail = '1' 
AND structure_id IN (SELECT id FROM structures WHERE alias IN ('txd_chemos', 'txd_radiations', 'txd_surgeries', 'txd_surgeries', 'qc_lady_txd_hormonos', 'qc_lady_txd_biopsy_surgeries', 'qc_lady_txd_patho_evaluations', 'qc_lady_txd_biopsy_surgeries', 
'qc_lady_txd_immunos', 'qc_lady_txd_others', 'qc_lady_txd_others', 'qc_lady_txd_clinical_trials'))
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'notes');

-- Add Treatment Precisions in treatment_masters

INSERT INTO structures(`alias`) VALUES ('qc_lady_treatmentmasters_precisions');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Generated', '', 'qc_lady_treatment_precisions', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'precisons', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_treatmentmasters_precisions'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='qc_lady_treatment_precisions' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='precisons' AND `language_tag`=''), '1', '100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('precisons', 'Precisons', 'Précisons');

-- triple negative

ALTER TABLE qc_lady_txd_biopsy_surgeries ADD COLUMN triple_negative_ccl char(1) DEFAULT '';
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs ADD COLUMN triple_negative_ccl char(1) DEFAULT '';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Generated', 'qc_lady_txd_biopsy_surgeries', 'triple_negative_ccl', 'yes_no',  NULL , '0', '', '', '', 'triple negative', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='triple_negative_ccl' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='triple negative' AND `language_tag`=''), '2', '142', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET model = 'TreatmentDetail' WHERE `model`='Generated' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='triple_negative_ccl';

UPDATE qc_lady_txd_biopsy_surgeries SET er_receptor_ccl = '' WHERE er_receptor_ccl IS NULL;
UPDATE qc_lady_txd_biopsy_surgeries SET pr_receptor_ccl = '' WHERE pr_receptor_ccl IS NULL;
UPDATE qc_lady_txd_biopsy_surgeries SET her2_receptor_ccl = '' WHERE her2_receptor_ccl IS NULL;
UPDATE qc_lady_txd_biopsy_surgeries SET fish_ccl = '' WHERE fish_ccl IS NULL;

SET @modified_by = (SELECT id from users where username = 'NicoEn' AND id = 1);
SET @modified = (SELECT NOW() from users where username = 'NicoEn' AND id = 1);

UPDATE treatment_masters TreatmentMaster, qc_lady_txd_biopsy_surgeries TreatmentDetail
SET triple_negative_ccl = 'y'
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.er_receptor_ccl = 'negative'
AND TreatmentDetail.pr_receptor_ccl = 'negative'
AND (TreatmentDetail.her2_receptor_ccl = 'negative' OR TreatmentDetail.fish_ccl = 'negative');

UPDATE treatment_masters TreatmentMaster, qc_lady_txd_biopsy_surgeries TreatmentDetail
SET triple_negative_ccl = 'n'
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.deleted <> 1
AND (TreatmentDetail.er_receptor_ccl IN ('positive', 'equivocal')
OR TreatmentDetail.pr_receptor_ccl IN ('positive', 'equivocal'));

UPDATE treatment_masters TreatmentMaster, qc_lady_txd_biopsy_surgeries TreatmentDetail
SET triple_negative_ccl = 'n'
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.deleted <> 1
AND triple_negative_ccl != 'y'
AND ((TreatmentDetail.her2_receptor_ccl != 'negative' AND TreatmentDetail.fish_ccl IN ('positive', 'equivocal'))
OR (TreatmentDetail.fish_ccl != 'negative' AND TreatmentDetail.her2_receptor_ccl IN ('positive', 'equivocal')));

UPDATE treatment_masters TreatmentMaster, qc_lady_txd_biopsy_surgeries TreatmentDetail
SET modified_by =  @modified_by, modified =  @modified
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.deleted <> 1 AND  triple_negative_ccl IN ('y','n');

INSERT INTO treatment_masters_revs(id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes, protocol_master_id,  
participant_id, diagnosis_master_id, qc_lady_laterality, modified_by, version_created)
(SELECT id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes, protocol_master_id,  
participant_id, diagnosis_master_id, qc_lady_laterality, modified_by, modified FROM treatment_masters WHERE modified = @modified AND modified_by = @modified_by);

INSERT INTO qc_lady_txd_biopsy_surgeries_revs (morphology, topography, histological_grade, tumor_size_mm_x, tumor_size_mm_y, dimension_of_residual_tumor_bed_area_mm_x, dimension_of_residual_tumor_bed_area_mm_y, overal_cancer_cellularity_pct, 
in_situ_disease_pct, nbr_of_lymph_nodes_positive, largest_lymph_node_metastasis_diatmeter_mm, rcb_list, rcb_score, ki67_pct, er_receptor_pct, er_receptor_ccl, pr_receptor_pct, pr_receptor_ccl, her2_receptor_ccl, her2_receptor_score, 
fish_ratio, treatment_master_id, path_tstage, path_nstage, path_mstage, path_stage_summary, ki67_performed, fish_ccl, lymph_node_collection, lymph_node_ccl, patho_nbr, morphology_precision, 
her2_receptor_antibody, residual_disease, oncotype_dx, pcr, other_staining, other_staining_notes, consistent_with_primary, triple_negative_ccl, version_created)
(SELECT morphology, topography, histological_grade, tumor_size_mm_x, tumor_size_mm_y, dimension_of_residual_tumor_bed_area_mm_x, dimension_of_residual_tumor_bed_area_mm_y, overal_cancer_cellularity_pct, 
in_situ_disease_pct, nbr_of_lymph_nodes_positive, largest_lymph_node_metastasis_diatmeter_mm, rcb_list, rcb_score, ki67_pct, er_receptor_pct, er_receptor_ccl, pr_receptor_pct, pr_receptor_ccl, her2_receptor_ccl, her2_receptor_score, 
fish_ratio, treatment_master_id, path_tstage, path_nstage, path_mstage, path_stage_summary, ki67_performed, fish_ccl, lymph_node_collection, lymph_node_ccl, patho_nbr, morphology_precision, 
her2_receptor_antibody, residual_disease, oncotype_dx, pcr, other_staining, other_staining_notes, consistent_with_primary, triple_negative_ccl, modified
FROM treatment_masters INNER JOIN qc_lady_txd_biopsy_surgeries ON id = treatment_master_id WHERE modified = @modified AND modified_by = @modified_by);

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6836' WHERE version_number = '2.6.4';
