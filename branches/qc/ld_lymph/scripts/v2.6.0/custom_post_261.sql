
UPDATE treatment_controls SET disease_site = '' WHERE flag_active = 1;
UPDATE event_controls SET disease_site = '' WHERE flag_active = 1;

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(189, 193);

UPDATE structure_formats SET `display_order`='1', `flag_override_label`='1', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='ld_lymph_specimen_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');

ALTER TABLE sd_spe_tissues ADD COLUMN ld_lymph_f_nbr varchar(20) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs ADD COLUMN ld_lymph_f_nbr varchar(20) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'ld_lymph_f_nbr', 'input',  NULL , '0', 'size=10', '', '', 'f number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='ld_lymph_f_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='f number' AND `language_tag`=''), '0', '322', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE specimen_details ADD COLUMN ld_lymph_mdl_mb_nbr varchar(20) DEFAULT NULL;
ALTER TABLE specimen_details_revs ADD COLUMN ld_lymph_mdl_mb_nbr varchar(20) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SpecimenDetail', 'specimen_details', 'ld_lymph_mdl_mb_nbr', 'input',  NULL , '0', 'size=10', '', '', 'mdl/mb number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='ld_lymph_mdl_mb_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='mdl/mb number' AND `language_tag`=''), '0', '321', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('f number','F#', 'F#'), ('mdl/mb number','MDL/MB#','MDL/MB#');

ALTER TABLE sd_spe_tissues ADD COLUMN ld_lymph_surgery_nbr varchar(20) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs ADD COLUMN ld_lymph_surgery_nbr varchar(20) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'ld_lymph_surgery_nbr', 'input',  NULL , '0', 'size=10', '', '', 'surgery number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='ld_lymph_surgery_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='surgery number' AND `language_tag`=''), '0', '323', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('surgery number','Surgery#', 'Chirurgie#');

UPDATE treatment_controls SET flag_use_for_ccl = 1 WHERE flag_active = 1;
UPDATE event_controls SET flag_use_for_ccl = 1 WHERE flag_active = 1;

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(24, 118);













INSERT INTO sample_controls (sample_type, sample_category, detail_form_alias, detail_tablename, display_order, databrowser_label) VALUES
('other fluid', 'specimen', 'ld_lymph_sd_spe_other_fluids,specimens', 'ld_lymph_sd_spe_other_fluids', 0, 'other fluid'),
('other fluid cell suspension', 'derivative', 'sd_undetailed_derivatives,derivatives', 'ld_lymph_sd_der_other_fl_cell_susps', 0, 'other fluid cell suspension'),
('other fluid supernatant', 'derivative', 'sd_undetailed_derivatives,derivatives', 'ld_lymph_sd_der_other_fl_sups', 0, 'other fluid supernatant'),
('other fluid pellet', 'derivative', 'sd_undetailed_derivatives,derivatives', 'ld_lymph_sd_der_other_fl_pellets', 0, 'other fluid pellet');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active, lab_book_control_id) VALUES
(NULL, (SELECT id FROM sample_controls WHERE sample_type = 'other fluid'), 1, NULL);
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active, lab_book_control_id) VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'other fluid'), (SELECT id FROM sample_controls WHERE sample_type = 'other fluid cell suspension'), 1, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'other fluid'), (SELECT id FROM sample_controls WHERE sample_type = 'other fluid supernatant'), 1, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'other fluid'), (SELECT id FROM sample_controls WHERE sample_type = 'other fluid pellet'), 1, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'other fluid cell suspension'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), 1, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'other fluid cell suspension'), (SELECT id FROM sample_controls WHERE sample_type = 'rna'), 1, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'other fluid pellet'), (SELECT id FROM sample_controls WHERE sample_type = 'dna'), 1, NULL),
((SELECT id FROM sample_controls WHERE sample_type = 'other fluid pellet'), (SELECT id FROM sample_controls WHERE sample_type = 'rna'), 1, NULL);
CREATE TABLE ld_lymph_sd_spe_other_fluids (
  type varchar(50) NOT NULL,
  sample_master_id int(11) NOT NULL,
  KEY FK_ld_lymph_sd_spe_other_fluids_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE ld_lymph_sd_spe_other_fluids_revs (
  type varchar(50) NOT NULL,
  sample_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `ld_lymph_sd_spe_other_fluids`
  ADD CONSTRAINT FK_ld_lymph_sd_spe_other_fluids_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);
CREATE TABLE ld_lymph_sd_der_other_fl_cell_susps (
  sample_master_id int(11) NOT NULL,
  KEY FK_ld_lymph_sd_der_other_fl_cell_susps_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE ld_lymph_sd_der_other_fl_cell_susps_revs (
  sample_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `ld_lymph_sd_der_other_fl_cell_susps`
  ADD CONSTRAINT FK_ld_lymph_sd_der_other_fl_cell_susps_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);
CREATE TABLE ld_lymph_sd_der_other_fl_sups (
  sample_master_id int(11) NOT NULL,
  KEY FK_ld_lymph_sd_der_other_fl_sups_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE ld_lymph_sd_der_other_fl_sups_revs (
  sample_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `ld_lymph_sd_der_other_fl_sups`
  ADD CONSTRAINT FK_ld_lymph_sd_der_other_fl_sups_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);
CREATE TABLE ld_lymph_sd_der_other_fl_pellets (
  sample_master_id int(11) NOT NULL,
  KEY FK_ld_lymph_sd_der_other_fl_pellets_sample_masters (sample_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE ld_lymph_sd_der_other_fl_pellets_revs (
  sample_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `ld_lymph_sd_der_other_fl_pellets`
  ADD CONSTRAINT FK_ld_lymph_sd_der_other_fl_pellets_sample_masters FOREIGN KEY (sample_master_id) REFERENCES sample_masters (id);
INSERT INTO i18n (id,en) VALUES 
('other fluid','Other Fluid'),
('other fluid cell suspension','Other Fluid Cell Suspension'),
('other fluid supernatant','Other Fluid Supernatant'),
('other fluid pellet','Other Fluid Pellet');
INSERT INTO structures(`alias`) VALUES ('ld_lymph_sd_spe_other_fluids');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ld_lymph_sd_spe_other_fluid_types", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Other Fluid Types\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Other Fluid Types', 1, 50, 'inventory');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_sd_spe_other_fluid_types') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_sd_spe_other_fluids'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_sd_spe_other_fluid_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '441', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_sd_spe_other_fluid_types') AND `field`='type'), 'notEmpty');
INSERT INTO aliquot_controls (sample_control_id, aliquot_type, aliquot_type_precision, detail_form_alias, detail_tablename, volume_unit, flag_active, `comment`, display_order, databrowser_label) 
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'other fluid'), 'tube', '(ml)', 'ad_spec_tubes_incl_ml_vol', 'ad_tubes', 'ml', 0, 'Specimen tube requiring volume in ml', 0, 'other fluid|tube');
SET @control_id = LAST_INSERT_ID(); 
INSERT INTO realiquoting_controls (parent_aliquot_control_id, child_aliquot_control_id, flag_active) VALUES (@control_id,@control_id,1);
INSERT INTO aliquot_controls (sample_control_id, aliquot_type, aliquot_type_precision, detail_form_alias, detail_tablename, volume_unit, flag_active, `comment`, display_order, databrowser_label) 
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'other fluid cell suspension'), 'tube', '(ml)', 'ad_der_tubes_incl_ml_vol', 'ad_tubes', 'ml', 0, 'Derivative tube requiring volume in ml', 0, 'other fluid cell suspension|tube');
SET @control_id = LAST_INSERT_ID(); 
INSERT INTO realiquoting_controls (parent_aliquot_control_id, child_aliquot_control_id, flag_active) VALUES (@control_id,@control_id,1);
INSERT INTO aliquot_controls (sample_control_id, aliquot_type, aliquot_type_precision, detail_form_alias, detail_tablename, volume_unit, flag_active, `comment`, display_order, databrowser_label) 
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'other fluid pellet '), 'tube', '(ml)', 'ad_der_tubes_incl_ml_vol', 'ad_tubes', 'ml', 0, 'Derivative tube requiring volume in ml', 0, 'other fluid pellet |tube');
SET @control_id = LAST_INSERT_ID(); 
INSERT INTO realiquoting_controls (parent_aliquot_control_id, child_aliquot_control_id, flag_active) VALUES (@control_id,@control_id,1);
INSERT INTO aliquot_controls (sample_control_id, aliquot_type, aliquot_type_precision, detail_form_alias, detail_tablename, volume_unit, flag_active, `comment`, display_order, databrowser_label) 
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'other fluid supernatant'), 'tube', '(ml)', 'ad_der_tubes_incl_ml_vol', 'ad_tubes', 'ml', 0, 'Derivative tube requiring volume in ml', 0, 'other fluid supernatant|tube');
SET @control_id = LAST_INSERT_ID(); 
INSERT INTO realiquoting_controls (parent_aliquot_control_id, child_aliquot_control_id, flag_active) VALUES (@control_id,@control_id,1);





