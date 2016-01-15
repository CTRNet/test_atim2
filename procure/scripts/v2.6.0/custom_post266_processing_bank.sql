-- ================================================================================================================================================================
-- User Update
-- ================================================================================================================================================================

UPDATE users SET deleted = 1 WHERE id > 1;
UPDATE users SET username = 'NicoEn', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id = 1;

-- ================================================================================================================================================================
-- Disable Report
-- ================================================================================================================================================================

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'procure barcode errors';

-- ================================================================================================================================================================
-- Storage
-- ================================================================================================================================================================

UPDATE storage_controls SET flag_active = 0 WHERE storage_type NOT IN ('nitrogen locator', 'fridge', 'freezer', 'shelf', 'box100');
INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, 
`display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'rack20 (5X4)', 'position', 'integer', 20, NULL, NULL, NULL, 
5, 4, 0, 0, 1, 0, 0, 1, '', 'std_racks', 'custom#storage types#rack20 (5X4)', 1),
(null, 'box100 1A-10J', 'column', 'integer', 10, 'row', 'alphabetical', 10, 
0, 0, 0, 0, 0, 0, 0, 1, '', 'std_boxs', 'custom#storage types#box100 1A-10J', 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('rack20 (5X4)','Rack 20 (5X4)','Râtelier 20 (5X4)',  '1', @control_id, NOW(), NOW(), 1, 1),
('box100 1A-10J','Box81 1A-10J','Boîte81 1A-10J',  '1', @control_id, NOW(), NOW(), 1, 1);

-- ================================================================================================================================================================
-- Quality Control
-- ================================================================================================================================================================

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("picogreen", "picogreen");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="quality_control_type"), (SELECT id FROM structure_permissible_values WHERE value="picogreen" AND language_alias="picogreen"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("280", "280");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="quality_control_unit"), (SELECT id FROM structure_permissible_values WHERE value="280" AND language_alias="280"), "", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("260", "260");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="quality_control_unit"), (SELECT id FROM structure_permissible_values WHERE value="260" AND language_alias="260"), "", "1");
UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="quality_control_unit") AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="ng/ul" AND language_alias="ng/ul");
INSERT INTO i18n (id,en,fr) VALUES("picogreen", "Picogreen", "Picogreen");

-- ================================================================================================================================================================
-- ================================================================================================================================================================

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

-- ================================================================================================================================================================
-- ================================================================================================================================================================

UPDATE datamart_reports SET flag_active = 0;
UPDATE datamart_reports SET flag_active = 1 WHERE name IN ('initial specimens display', 'all derivatives display', 'list all children storages', 'procure barcode errors');

-- ================================================================================================================================================================
-- ================================================================================================================================================================

UPDATE versions SET site_branch_build_number = xxxx WHERE version_number = '2.6.6';
UPDATE versions SET permissions_regenerated = 0;
