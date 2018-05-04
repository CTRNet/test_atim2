-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Main Application Setup
--   - Name of the installation
--   - Manage initial users 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Installation name
-- ...............................................................

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'UHN - Main', 'UHN - Principal');

-- Manage Group And Users
-- ...............................................................

-- Inactivate all users except the 2 first one

UPDATE users SET username = CONCAT('Unused', '#', id), first_name = 'Unused', last_name = CONCAT('#',id), flag_active = 0, `password` = 'aedfwefwefafasfasfafwef234rq2345are', email = '' WHERE id > 2;

-- Manage Administartor User

UPDATE groups SET flag_show_confidential = '1' WHERE id = 1;
UPDATE users SET flag_active = '1', password_modified = NOW(), force_password_reset = 0 WHERE id = 1;

-- Create a system user for any data migration by script or API in the futur

UPDATE groups SET name = 'system', deleted = 1 WHERE id = 2;
UPDATE users SET username = 'system', first_name = '', last_name = '', flag_active = 0, `password` = 'aedfwefwefafasfasfafwef234rq2345are', email = '' WHERE id = 2;

SET @modified = (SELECT NOW() FROM users WHERE username = 'system');
SET @modified_by = (SELECT id FROM users WHERE username = 'system');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Set up the new inventory controls to match Ca-Tissue definitions
--   - Create the sample sub type (or sub class)
--   - Hide all sample and laiquot controls except tissue
--   - Create specimens 'fluid specimen'
--   - Create specimens derivatives 'fluid derivative', 'cell derivative', 'molecular derivative'
--   - Build all sample to sample controls links 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Sample sub type
-- ...............................................................

ALTER TABLE sample_masters 
   ADD COLUMN uhn_sample_sub_type varchar(250) DEFAULT NULL;
ALTER TABLE sample_masters_revs 
   ADD COLUMN uhn_sample_sub_type varchar(250) DEFAULT NULL;

-- Create custom drop down list (manageable into ATiM by administrator) of sample sub types for each type of sample

INSERT INTO structure_value_domains (domain_name, source) 
VALUES
('uhn_tissue_sub_types', "StructurePermissibleValuesCustom::getCustomDropdown('Tissue Sub Types')"),
('uhn_fluid_sub_types', "StructurePermissibleValuesCustom::getCustomDropdown('Fluid Sub Types')"),
('uhn_cell_sub_types', "StructurePermissibleValuesCustom::getCustomDropdown('Cell Sub Types')"),
('uhn_molecular_sub_types', "StructurePermissibleValuesCustom::getCustomDropdown('Molecular Sub Types')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Tissue Sub Types', 1, 250, 'inventory'),
('Fluid Sub Types', 1, 250, 'inventory'),
('Cell Sub Types', 1, 250, 'inventory'),
('Molecular Sub Types', 1, 250, 'inventory');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue Sub Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
-- ('core', 'Core',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('cryopreserved tissue', 'Cryopreserved Tissue',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('fixed tissue', 'Fixed Tissue',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
-- ('fixed tissue block', 'Fixed Tissue Block',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
-- ('fixed tissue slide', 'Fixed Tissue Slide',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('fresh tissue', 'Fresh Tissue',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('frozen tissue', 'Frozen Tissue',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
-- ('frozen tissue block', 'Frozen Tissue Block',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
-- ('frozen tissue slide', 'Frozen Tissue Slide',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('microdissected', 'Microdissected',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('not specified', 'Not Specified',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('organoid', 'Organoid',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('xenograft ', 'Xenograft ',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Fluid Sub Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('50/50', '50/50',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('aimv', 'AIMV',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('amniotic fluid', 'Amniotic Fluid',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('bile', 'Bile',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('body cavity fluid', 'Body Cavity Fluid',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('bone marrow plasma', 'Bone Marrow Plasma',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('buccal swab', 'Buccal Swab',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('cm', 'CM',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('cerebrospinal fluid', 'Cerebrospinal Fluid',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('endotoxin', 'Endotoxin',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('feces', 'Feces',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('feeder wash', 'Feeder Wash',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('gastric fluid', 'Gastric Fluid',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('imdm', 'IMDM',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('lavage', 'Lavage',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('milk', 'Milk',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('not specified', 'Not Specified',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('paxgene', 'Paxgene',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('paxgenedna', 'PaxgeneDNA',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('pericardial fluid', 'Pericardial Fluid',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('plasma', 'Plasma',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('sup of 1e6', 'SUP of 1E6',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('saliva', 'Saliva',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('serum', 'Serum',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('sputum', 'Sputum',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('stat gram', 'Stat Gram',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('sterility', 'Sterility',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('supernatant', 'Supernatant',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('sweat', 'Sweat',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('synovial cells', 'Synovial Cells',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('synovial cells trizol', 'Synovial Cells Trizol',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('synovial fluid', 'Synovial Fluid',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('tempus tube', 'Tempus Tube',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('throat swab', 'Throat Swab',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('urine', 'Urine',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('vitreous fluid', 'Vitreous Fluid',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('whole blood', 'Whole Blood',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('whole bone marrow', 'Whole Bone Marrow',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('whole urine', 'Whole Urine',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Cell Sub Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('buffy coat', 'Buffy coat',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('cryopreserved cells', 'Cryopreserved Cells',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('culture', 'Culture',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('enz do', 'ENZ DO',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('engrafting cells', 'Engrafting Cells',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('feeders only', 'Feeders Only',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
-- ('fixed cell block', 'Fixed Cell Block',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
-- ('frozen cell block', 'Frozen Cell Block',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('fixed cell', 'Fixed Cell',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('frozen cell', 'Frozen Cell',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('frozen cell pellet', 'Frozen Cell Pellet',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('hla', 'HLA',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('mycoplasma', 'Mycoplasma',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('neutrophils', 'Neutrophils',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('non cryopreserved cells', 'Non Cryopreserved Cells',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('not specified', 'Not Specified',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('pbmc', 'PBMC',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('pbsc', 'PBSC',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('sfmc', 'SFMC',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('sup+cells', 'SUP+Cells',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
-- ('slide', 'Slide',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('sterility', 'Sterility',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('urine pellet', 'Urine Pellet',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Molecular Sub Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('dna', 'DNA',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('not specified', 'Not Specified',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('rna', 'RNA',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('rna, cytoplasmic', 'RNA, cytoplasmic',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('rna, nuclear', 'RNA, nuclear',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('rna, poly-a enriched', 'RNA, poly-A enriched',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('total nucleic acid', 'Total Nucleic Acid',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('whole genome amplified dna', 'Whole Genome Amplified DNA',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('cdna', 'cDNA',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('plasmid dna', 'plasmid DNA',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('protein', 'protein',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'uhn_sample_sub_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_tissue_sub_types') , '0', '', '', '', 'sample sub type', ''),
('InventoryManagement', 'SampleMaster', 'sample_masters', 'uhn_sample_sub_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_fluid_sub_types') , '0', '', '', '', 'sample sub type', ''),
('InventoryManagement', 'SampleMaster', 'sample_masters', 'uhn_sample_sub_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_cell_sub_types') , '0', '', '', '', 'sample sub type', ''),
('InventoryManagement', 'SampleMaster', 'sample_masters', 'uhn_sample_sub_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_molecular_sub_types') , '0', '', '', '', 'sample sub type', '');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
(SELECT id, 'notBlank', '' FROM structure_fields WHERE `model`='SampleMaster'  AND `field`='uhn_sample_sub_type');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('sample sub type', 'Sub Type', 'Sous type');

-- Add sample sub type in any forms containing sample_type field

INSERT INTO structure_value_domains (domain_name, source) 
VALUES
('uhn_all_sub_types', "InventoryManagement.SampleControl::getSampleSubTypes");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('InventoryManagement', 'SampleMaster', '', 'uhn_sample_sub_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_all_sub_types') , '0', '', '', '', 'sample sub type', ''),
('InventoryManagement', 'ViewSample', '', 'uhn_sample_sub_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_all_sub_types') , '0', '', '', '', 'sample sub type', ''),
('InventoryManagement', 'ViewAliquot', '', 'uhn_sample_sub_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_all_sub_types') , '0', '', '', '', 'sample sub type', '');
-- view_sample_joined_to_collection
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='uhn_sample_sub_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_all_sub_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sub type' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
-- sample_masters_for_collection_tree_view
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) 
VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='' AND `field`='uhn_sample_sub_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_all_sub_types')  AND `flag_confidential`='0'), '0', '1', '', '0', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='blood_type') AND `flag_confidential`='0');
-- view_aliquot_joined_to_sample_and_collection
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='uhn_sample_sub_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_all_sub_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sub type' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
-- view_aliquot_joined_to_sample
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='uhn_sample_sub_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_all_sub_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sub type' AND `language_tag`=''), '0', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
-- shippeditems
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='shippeditems'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='uhn_sample_sub_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_all_sub_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sub type' AND `language_tag`=''), '0', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
-- orderitems_plus
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_plus'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='uhn_sample_sub_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_all_sub_types')  AND `flag_confidential`='0'), '0', '21', '', '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_plus') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');

-- Hide all sample and aliquot types unlinked to a tissue sample
-- ...............................................................

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE derivative_sample_control_id != (SELECT id FROM sample_controls WHERE sample_type = 'tissue');
UPDATE aliquot_controls SET flag_active =false WHERE sample_control_id != (SELECT id FROM sample_controls WHERE sample_type = 'tissue');

-- Create fluid specimen + tube
-- ...............................................................

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) 
VALUES
(null, 'fluid specimen', 'specimen', 'uhn_sd_fluids,specimens', 'uhn_sd_fluids', 1, 'fluid specimen');
INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'fluid specimen'), 'tube', '(ml)', 'ad_spec_tubes', 'ad_tubes', 'ml', 1, 'Specimen tube requiring volume in ml', 0, 'fluid specimen|tube');
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'fluid specimen' AND Aq.aliquot_type = 'tube'),
(SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'fluid specimen' AND Aq.aliquot_type = 'tube'), 1, NULL);
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('fluid specimen', 'Fluid (Specimen)', 'Fluide (Spécimen)');

-- Create missing table (see sample_controls.detail_tablename)

DROP TABLE IF EXISTS `uhn_sd_fluids`;
CREATE TABLE `uhn_sd_fluids` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_uhn_sd_fluids_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_uhn_sd_fluids_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `uhn_sd_fluids_revs`;
CREATE TABLE `uhn_sd_fluids_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Create missing structure/form (see sample_controls.detail_form_alias)

INSERT INTO structures(`alias`) VALUES ('uhn_sd_fluids');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_sd_fluids'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='uhn_sample_sub_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_fluid_sub_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sub type' AND `language_tag`=''), '0', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1');

-- Create fluid derivative + tube
-- ...............................................................

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) 
VALUES
(null, 'fluid derivative', 'derivative', 'uhn_sd_fluids,derivatives', 'uhn_sd_fluids', 1, 'fluid derivative');
INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'fluid derivative'), 'tube', '(ml)', 'ad_spec_tubes', 'ad_tubes', 'ml', 1, 'Specimen tube requiring volume in ml', 0, 'fluid derivative|tube');
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'fluid derivative' AND Aq.aliquot_type = 'tube'),
(SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'fluid derivative' AND Aq.aliquot_type = 'tube'), 1, NULL);
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('fluid derivative', 'Fluid (Derivative)', 'Fluide (Dérivé)');

-- Create cell derivative + tube & slide & block
-- ...............................................................

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) 
VALUES
(null, 'cell derivative', 'derivative', 'uhn_sd_cells,derivatives', 'uhn_sd_cells', 1, 'cell derivative');
INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'cell derivative'), 'tube', '', 'ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', 1, 'Derivative tube requiring volume in ml specific for cells', 0, 'cell derivative|tube'),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'cell derivative'), 'slide', '', 'ad_der_cell_slides', 'ad_cell_slides', NULL, 1, 'Cells slide', 0, 'cell derivative|slide'),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'cell derivative'), 'block', '', 'uhn_ad_der_cells', 'ad_blocks', '', 1, '', 0, 'cell derivative|block');
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'cell derivative' AND Aq.aliquot_type = 'tube'),
(SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'cell derivative' AND Aq.aliquot_type = 'tube'), 1, NULL);
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'cell derivative' AND Aq.aliquot_type = 'slide'),
(SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'cell derivative' AND Aq.aliquot_type = 'slide'), 1, NULL);
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'cell derivative' AND Aq.aliquot_type = 'block'),
(SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'cell derivative' AND Aq.aliquot_type = 'block'), 1, NULL);
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'cell derivative' AND Aq.aliquot_type = 'tube'),
(SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'cell derivative' AND Aq.aliquot_type = 'block'), 1, NULL);
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'cell derivative' AND Aq.aliquot_type = 'block'),
(SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'cell derivative' AND Aq.aliquot_type = 'slide'), 1, NULL);
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('cell derivative', 'Cell', 'Cell');

-- Create missing table (see sample_controls.detail_tablename)

DROP TABLE IF EXISTS `uhn_sd_cells`;
CREATE TABLE `uhn_sd_cells` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_uhn_sd_cells_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_uhn_sd_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `uhn_sd_cells_revs`;
CREATE TABLE `uhn_sd_cells_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Create missing structure/form (see sample_controls/aliquot_controls.detail_form_alias) 

INSERT INTO structures(`alias`) VALUES ('uhn_sd_cells');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_sd_cells'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='uhn_sample_sub_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_cell_sub_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sub type' AND `language_tag`=''), '0', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1');

INSERT INTO structures(`alias`) VALUES ('uhn_ad_der_cell_blocks');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_ad_der_cell_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='block type' AND `language_tag`=''), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ad_der_cell_blocks'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ad_der_cell_blocks'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ad_der_cell_blocks'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ad_der_cell_blocks'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- Create molecular derivative + tube
-- ...............................................................

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) 
VALUES
(null, 'molecular derivative', 'derivative', 'uhn_sd_moleculars,derivatives', 'uhn_sd_moleculars', 1, 'molecular derivative');
INSERT INTO `aliquot_controls` (`id`, `sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'molecular derivative'), 'tube', '(ul + conc)', 'ad_der_tubes_incl_ul_vol_and_conc', 'ad_tubes', 'ul', 1, 'Derivative tube requiring volume in ul and concentration', 0, 'molecular derivative|tube');
INSERT INTO `realiquoting_controls` (`id`, `parent_aliquot_control_id`, `child_aliquot_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'molecular derivative' AND Aq.aliquot_type = 'tube'),
(SELECT Aq.id FROM sample_controls Smp INNER JOIN aliquot_controls Aq ON Smp.id = Aq.sample_control_id WHERE Smp.sample_type = 'molecular derivative' AND Aq.aliquot_type = 'tube'), 1, NULL);
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('molecular derivative', 'Molecular', 'Moleculaire');

-- Create missing table (see sample_controls.detail_tablename)

DROP TABLE IF EXISTS `uhn_sd_moleculars`;
CREATE TABLE `uhn_sd_moleculars` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_uhn_sd_moleculars_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_uhn_sd_moleculars_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `uhn_sd_moleculars_revs`;
CREATE TABLE `uhn_sd_moleculars_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Create missing structure/form (see sample_controls.detail_form_alias) 

INSERT INTO structures(`alias`) VALUES ('uhn_sd_moleculars');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_sd_moleculars'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='uhn_sample_sub_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_molecular_sub_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sub type' AND `language_tag`=''), '0', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1');

-- Add sample sub type to tissue
-- ...............................................................

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='uhn_sample_sub_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_tissue_sub_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sub type' AND `language_tag`=''), '0', '101', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1');

-- Create sample to sample links for the derivatives created above
-- ...............................................................

-- Activate fluid specimen plus fluid specimen to fluid derivative, cell derivative, molecular derivative
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, null, (SELECT id FROM sample_controls WHERE sample_type = 'fluid specimen'), 1, NULL);
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'fluid specimen'), (SELECT id FROM sample_controls WHERE sample_type = 'fluid derivative'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'fluid specimen'), (SELECT id FROM sample_controls WHERE sample_type = 'cell derivative'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'fluid specimen'), (SELECT id FROM sample_controls WHERE sample_type = 'molecular derivative'), 1, NULL);
-- Activate tissue to fluid derivative, cell derivative, molecular derivative
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tissue'), (SELECT id FROM sample_controls WHERE sample_type = 'fluid derivative'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tissue'), (SELECT id FROM sample_controls WHERE sample_type = 'cell derivative'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tissue'), (SELECT id FROM sample_controls WHERE sample_type = 'molecular derivative'), 1, NULL);
-- Activate fluid derivative to fluid derivative, cell derivative, molecular derivative
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'fluid derivative'), (SELECT id FROM sample_controls WHERE sample_type = 'fluid derivative'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'fluid derivative'), (SELECT id FROM sample_controls WHERE sample_type = 'cell derivative'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'fluid derivative'), (SELECT id FROM sample_controls WHERE sample_type = 'molecular derivative'), 1, NULL);
-- Activate cell derivative derivative to fluid derivative, cell derivative, molecular derivative
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'cell derivative'), (SELECT id FROM sample_controls WHERE sample_type = 'fluid derivative'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'cell derivative'), (SELECT id FROM sample_controls WHERE sample_type = 'cell derivative'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'cell derivative'), (SELECT id FROM sample_controls WHERE sample_type = 'molecular derivative'), 1, NULL);
-- Activate molecular derivative to fluid derivative, cell derivative, molecular derivative
INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`) 
VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'molecular derivative'), (SELECT id FROM sample_controls WHERE sample_type = 'fluid derivative'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'molecular derivative'), (SELECT id FROM sample_controls WHERE sample_type = 'cell derivative'), 1, NULL),
(null, (SELECT id FROM sample_controls WHERE sample_type = 'molecular derivative'), (SELECT id FROM sample_controls WHERE sample_type = 'molecular derivative'), 1, NULL);


















UPDATE versions SET branch_build_number = '9999' WHERE version_number = '2.7.0';

