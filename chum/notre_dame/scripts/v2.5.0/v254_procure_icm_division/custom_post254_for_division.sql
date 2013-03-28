-- -------------------------------------------------------------------------------------------------------
--
-- STEP 1 OF PROCURE ICM DIVISION
--
-- To RUN on v2.5.4 ICM
--
-- -------------------------------------------------------------------------------------------------------

ALTER TABLE ad_blocks ADD COLUMN procure_origin_of_slice varchar(50) DEFAULT null;
ALTER TABLE ad_blocks_revs ADD COLUMN procure_origin_of_slice varchar(50) DEFAULT null;

INSERT INTO structure_value_domains (domain_name, override, category, source)
VALUES
("procure_slice_origins", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'procure _slice origins\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length)
VALUES
('procure _slice origins', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'procure _slice origins');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('RA', 'RA', 'RA', '1', @control_id, NOW(), NOW(), 1, 1),
('RP', 'RP', 'RP', '1', @control_id, NOW(), NOW(), 1, 1),
('LA', 'LA', 'LA', '1', @control_id, NOW(), NOW(), 1, 1),
('LP', 'LP', 'LP', '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'procure_origin_of_slice', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_slice_origins') , '0', '', '', '', 'origin of slice', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='procure_origin_of_slice' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_slice_origins')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='origin of slice' AND `language_tag`=''), '1', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='procure_origin_of_slice' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_slice_origins') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUES ('origin of slice', 'Origin of slice', 'Origine de la tranche');

-- -------------------------------------------------------------------------------------------------------

ALTER TABLE ad_blocks ADD COLUMN tumor_presence char(1) DEFAULT '';
ALTER TABLE ad_blocks_revs ADD COLUMN tumor_presence char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'tumor_presence', 'yes_no',  NULL , '0', '', '', '', 'tumor presence', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='tumor_presence' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor presence' AND `language_tag`=''), '1', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

 INSERT INTO i18n (id,en,fr) VALUES ('tumor presence', 'Tumor Presence', 'Présence tumeur');




