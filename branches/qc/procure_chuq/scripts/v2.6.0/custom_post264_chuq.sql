-- Add prostate slice weight

ALTER TABLE sd_spe_tissues ADD COLUMN procure_chuq_collected_prostate_slice_weight_gr decimal(10,2);
ALTER TABLE sd_spe_tissues_revs ADD COLUMN procure_chuq_collected_prostate_slice_weight_gr decimal(10,2);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'procure_chuq_collected_prostate_slice_weight_gr', 'float_positive',  NULL , '0', '', '', '', 'collected prostate slice weight (gr)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='procure_sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='procure_chuq_collected_prostate_slice_weight_gr' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collected prostate slice weight (gr)' AND `language_tag`=''), '2', '463', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('collected prostate slice weight (gr)', 'Collected Prostate Slice Weight (gr)', 'Poids de la tranche prélevé (gr)');

-- Manage storage

UPDATE storage_controls SET flag_active = 0 WHERE storage_type NOT IN ('nitrogen locator', 'fridge', 'freezer', 'box', 'box81 1A-9I', 'box81', 'rack16', 'box49');
INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'box27 1A-9C', 'column', 'integer', 9, 'row', 'alphabetical', 3, 0, 0, 0, 0, 0, 0, 0, 1, '', 'std_boxs', 'custom#storage types#box27 1A-9C', 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('box27 1A-9C', 'Box27 1A-9C', 'Boîte27 1A-9C',  '1', @control_id, NOW(), NOW(), 1, 1);
