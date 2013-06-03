
UPDATE `versions` SET branch_build_number = '5187' WHERE version_number = '2.5.4';

UPDATE aliquot_controls SET flag_active=true WHERE id IN(9);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(9);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(11, 34);

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(19, 7);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(41);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(29);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES ('tube','Tube','Tube');
INSERT IGNORE INTO i18n (id,en) VALUES ('cryovial','Cryovial'),('aluminium foil','Aluminium Foil');

ALTER TABLE `aliquot_controls` CHANGE aliquot_type aliquot_type enum('block','cell gel matrix','core','slide','tube','whatman paper','cryovial','aluminium foil') NOT NULL COMMENT 'Generic name.';
  
UPDATE aliquot_controls ac, sample_controls sc
SET ac.aliquot_type = 'cryovial', ac.databrowser_label = CONCAT(sc.sample_type,'|cryovial')
WHERE sc.id = ac.sample_control_id AND sc.sample_type IN ('pbmc', 'blood', 'serum', 'plasma', 'tissue') AND ac.flag_active = 1 AND ac.aliquot_type = 'tube';

SET @sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue');
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`)
(SELECT sample_control_id, 'tube', aliquot_type_precision, CONCAT(detail_form_alias,',muhc_tissue_tube_type'), detail_tablename, volume_unit, flag_active, comment, display_order,  'tissue|tube' FROM aliquot_controls WHERE aliquot_type = 'cryovial' AND sample_control_id = @sample_control_id);
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
(@sample_control_id, 'aluminium foil', '', 'muhc_ad_aluminium_foils', 'muhc_ad_aluminium_foils', NULL, 1, '', 0, 'tissue|aluminium foil');

SET @sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue');
SET @tube_control_id = (SELECT id FROM aliquot_controls WHERE aliquot_type = 'tube' AND sample_control_id = @sample_control_id);
SET @block_control_id = (SELECT id FROM aliquot_controls WHERE aliquot_type = 'block' AND sample_control_id = @sample_control_id);
SET @cryovial_control_id = (SELECT id FROM aliquot_controls WHERE aliquot_type = 'cryovial' AND sample_control_id = @sample_control_id);
SET @aluminium_foil_control_id = (SELECT id FROM aliquot_controls WHERE aliquot_type = 'aluminium foil' AND sample_control_id = @sample_control_id);

INSERT INTO `realiquoting_controls` (`parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`) 
VALUES
(@block_control_id, @block_control_id, 1),
(@block_control_id, @tube_control_id, 1),
(@block_control_id, @aluminium_foil_control_id, 1),

(@tube_control_id, @tube_control_id, 1),
(@tube_control_id, @block_control_id, 1),
(@tube_control_id, @aluminium_foil_control_id, 1),
(@tube_control_id, @cryovial_control_id, 1),

(@cryovial_control_id, @aluminium_foil_control_id, 1),
(@cryovial_control_id, @tube_control_id, 1),

(@aluminium_foil_control_id, @tube_control_id, 1),
(@aluminium_foil_control_id, @block_control_id, 1),
(@aluminium_foil_control_id, @aluminium_foil_control_id, 1),
(@aluminium_foil_control_id, @cryovial_control_id, 1);

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='block_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="OCT" AND language_alias="oct solution");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='block_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="paraffin" AND language_alias="paraffin");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='block_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="frozen" AND language_alias="frozen");
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Block Type')" WHERE domain_name = 'block_type';
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Block Type', '1', '30');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Block Type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('OCT', 'OCT', '', '1', @control_id),
('paraffin', 'Paraffin', '', '1', @control_id),
('frozen', 'Frozen', '', '1', @control_id),
('formalin', 'Formalin', '', '1', @control_id); 
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='storage method' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type') AND `flag_confidential`='0');

ALTER TABLE ad_tubes ADD COLUMN muhc_tube_type varchar(30) DEFAULT NULL;
ALTER TABLE ad_tubes_revs ADD COLUMN muhc_tube_type varchar(30) DEFAULT NULL;
INSERT structure_value_domains (domain_name,source) VALUES ('muhc_tube_type', "StructurePermissibleValuesCustom::getCustomDropdown('Tube type')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Tube type', '1', '30');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tube type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('15ml', '15ml', '', '1', @control_id),
('50ml', '50ml', '', '1', @control_id); 
INSERT INTO structures(`alias`) VALUES ('muhc_tissue_tube_type');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'muhc_tube_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_tube_type') , '0', '', '', '', 'tube type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_tissue_tube_type'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='muhc_tube_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_tube_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tube type' AND `language_tag`=''), '0', '201', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en) VALUES ('tube type','Tube Type');
ALTER TABLE sd_der_cell_cultures ADD COLUMN muhc_from_tissue_xenograft CHAR(1) DEFAULT '';
ALTER TABLE sd_der_cell_cultures_revs ADD COLUMN muhc_from_tissue_xenograft CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'muhc_from_tissue_xenograft', 'yes_no',  NULL , '0', '', '', '', 'tissue xenograft cells', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='muhc_from_tissue_xenograft' AND `type`='yes_no' AND `structure_value_domain`  IS NULL), '1', '444', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en) VALUES ('tissue xenograft cells','Tissue xenograft cells');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='cell_count_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='cell_viability' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en) VALUES ('treatment','Procedure');

CREATE TABLE IF NOT EXISTS `muhc_ad_aluminium_foils` (
  `aliquot_master_id` int(11) NOT NULL,
  `storage_method` varchar(50) DEFAULT NULL,
  KEY `FK_muhc_ad_aluminium_foils_aliquot_masters` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `muhc_ad_aluminium_foils_revs` (
  `aliquot_master_id` int(11) NOT NULL,
  `storage_method` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `muhc_ad_aluminium_foils`
  ADD CONSTRAINT `FK_muhc_ad_aluminium_foils_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`);
INSERT structure_value_domains (domain_name,source) VALUES ('muhc_tissue_storage_method_in_aluminium', "StructurePermissibleValuesCustom::getCustomDropdown('Tissue storage method in aluminium')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('Tissue storage method in aluminium', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue storage method in aluminium');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('formalin', 'Formalin', '', '1', @control_id); 
INSERT INTO structures(`alias`) VALUES ('muhc_ad_aluminium_foils');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'muhc_ad_aluminium_foils', 'storage_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_tissue_storage_method_in_aluminium') , '0', '', '', '', 'storage method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_ad_aluminium_foils'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='muhc_ad_aluminium_foils' AND `field`='storage_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_tissue_storage_method_in_aluminium')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage method' AND `language_tag`=''), '1', '1181', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'tx_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') , '0', '', '', '', 'procedure', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='tx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='procedure' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO i18n (id,en) VALUES ('treatments','Procedures');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(19);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(28);

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');

SET @coll_id = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 =  @coll_id AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('EventMaster'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id2 =  @coll_id AND id1 IN (SELECT id FROM datamart_structures WHERE model IN ('EventMaster'));

REPLACE INTO i18n (id,en) VALUES ('perfused liver','Fresh Tissue');

ALTER TABLE sd_der_cell_cultures ADD COLUMN muhc_cell_line CHAR(1) DEFAULT '';
ALTER TABLE sd_der_cell_cultures_revs ADD COLUMN muhc_cell_line CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'muhc_cell_line', 'yes_no',  NULL , '0', '', '', '', 'cell line', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='muhc_cell_line' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cell line' AND `language_tag`=''), '1', '448', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('cell line','Cell line');

-- - New Requests - 2013-04-24 ----------------------------------------------------------------------------------------------------------

INSERT INTO `storage_controls` (`storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, 
`display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
('cabinet', 'column', 'integer', 2, 'row','integer', 5, 
2, 5, 0, 1, 1, 0, 0, 1, 'storage_w_spaces', 'muhc_std_cabinets', 'cabinet', 0),
('cabinet drawer', 'row', 'integer', 7, NULL, NULL, NULL, 
7, 1, 1, 0, 1, 0, 0, 1, 'storage_w_spaces', 'muhc_std_cabinets', 'cabinet', 0);
CREATE TABLE IF NOT EXISTS `muhc_std_cabinets` (
  `storage_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `muhc_std_cabinets_revs` (
  `storage_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `muhc_std_cabinets`
  ADD CONSTRAINT `FK_muhc_std_cabinets_storage_masters` FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`);
INSERT INTO i18n (id,en) VALUES ('cabinet', 'Cabinet'),('cabinet drawer','Cabinet Drawer');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'muhc_treatment_method_from_id', 'open', '', 'ClinicalAnnotaion.TreatmentControl::getMethodFromIds');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'TreatmentMaster', 'treatment_masters', 'treatment_control_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_treatment_method_from_id') , '0', '', '', '', 'procedure', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='treatment_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_treatment_method_from_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='procedure' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue source' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_tissue_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_tissue_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue type' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_tissue_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_tissue_type') AND `flag_confidential`='0');

UPDATE storage_controls SET coord_x_size = 1, coord_y_size = 6, display_x_size = 0, display_y_size = 0, reverse_x_numbering = 0, reverse_y_numbering= 0 WHERE storage_type = 'cabinet';
UPDATE storage_controls SET databrowser_label = storage_type where storage_type like '%cabinet%';

ALTER TABLE sd_spe_tissues
	ADD COLUMN muhc_perfused char(1) default '',
	ADD COLUMN muhc_intra_operative_biopsy char(1) default '';
ALTER TABLE sd_spe_tissues_revs
	ADD COLUMN muhc_perfused char(1) default '',
	ADD COLUMN muhc_intra_operative_biopsy char(1) default '';	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'muhc_perfused', 'yes_no',  NULL , '0', '', '', '', 'perfused', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'muhc_intra_operative_biopsy', 'yes_no',  NULL , '0', '', '', '', 'intra operative biopsy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_perfused' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='perfused' AND `language_tag`=''), '1', '442', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_intra_operative_biopsy' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='intra operative biopsy' AND `language_tag`=''), '1', '443', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
REPLACE INTO i18n (id,en) VALUES ('perfused liver','Perfused Liver');
INSERT INTO i18n (id,en) VALUES ('perfused','Perfused'), ('intra operative biopsy','Intra-Operative Biopsy');

SELECT participant_id AS 'participant ids with perfused procedures 'FROM treatment_masters WHERE treatment_control_id = @perfusion_treatment_control_id and deleted <> 1;
SELECT sm.sample_code AS 'tissue sample code changed to perfused = yes'
FROM sample_masters sm 
INNER JOIN sd_spe_tissues sd ON sd.sample_master_id = sm.id AND sm.deleted != 1
INNER JOIN collections col ON col.id = sm.collection_id
INNER JOIN treatment_masters tm ON tm.id = col.treatment_master_id AND tm.deleted != 1 AND tm.treatment_control_id = @perfusion_treatment_control_id;
UPDATE sample_masters sm, sd_spe_tissues sd, collections col, treatment_masters tm
SET sd.muhc_perfused = 'y'
WHERE sd.sample_master_id = sm.id AND sm.deleted != 1
AND col.id = sm.collection_id
AND tm.id = col.treatment_master_id AND tm.deleted != 1 AND tm.treatment_control_id = @perfusion_treatment_control_id;
UPDATE collections col, treatment_masters tm
SET col.treatment_master_id = null
WHERE col.deleted != 1
AND tm.id = col.treatment_master_id AND tm.deleted != 1 AND tm.treatment_control_id = @perfusion_treatment_control_id;
UPDATE treatment_masters SET deleted = 1 WHERE treatment_control_id = @perfusion_treatment_control_id;
UPDATE treatment_controls SET flag_active = 0 WHERE id = @perfusion_treatment_control_id;

UPDATE menus SET display_order = 4 WHERE id = 'clin_CAN_75';
UPDATE menus SET display_order = 5 WHERE id = 'clin_CAN_4';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Generated', '', 'muhc_tissue_precision', 'input',  NULL , '0', '', '', '', 'tissue precision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='muhc_tissue_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue precision' AND `language_tag`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('muhc_tissue_summary');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_tissue_summary'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '444', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='muhc_tissue_summary'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_tissue_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_tissue_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue type' AND `language_tag`=''), '1', '445', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='muhc_tissue_summary'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_perfused' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='perfused' AND `language_tag`=''), '1', '442', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='muhc_tissue_summary'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_intra_operative_biopsy' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='intra operative biopsy' AND `language_tag`=''), '1', '443', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');

UPDATE versions SET permissions_regenerated = 0;
UPDATE `versions` SET branch_build_number = '5269' WHERE version_number = '2.5.4';
