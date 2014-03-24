-- ----------------------------------------------------------
-- Procure Slice Origine
-- ----------------------------------------------------------

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Procure Slice Origine\')" WHERE domain_name = 'procure_slice_origins';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Procure Slice Origine', 1, 50, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Procure Slice Origine');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('RA', 'RA', 'RA', '1', @control_id, NOW(), NOW(), 1, 1),
('RP', 'RP', 'RP', '1', @control_id, NOW(), NOW(), 1, 1),
('LA', 'LA', 'LA', '1', @control_id, NOW(), NOW(), 1, 1),
('LP', 'LP', 'LP', '1', @control_id, NOW(), NOW(), 1, 1);


