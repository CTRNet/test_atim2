
UPDATE `versions` SET branch_build_number = '5186' WHERE version_number = '2.5.4';

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

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
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
