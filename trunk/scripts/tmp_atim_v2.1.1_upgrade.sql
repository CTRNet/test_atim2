-- Version: v2.1.0A
-- Description: This SQL script is an upgrade for ATiM v2.1.0 to 2.1.0A and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.1.0A', NOW(), '> 2071');

TRUNCATE `acos`;

ALTER TABLE diagnosis_masters_revs
  MODIFY `path_mstage` varchar(15) DEFAULT NULL;

DELETE FROM structure_value_domains_permissible_values WHERE structure_permissible_value_id NOT IN (SELECT id FROM structure_permissible_values);
ALTER TABLE structure_value_domains_permissible_values MODIFY structure_permissible_value_id int(11) NOT NULL;
ALTER TABLE structure_value_domains_permissible_values ADD FOREIGN KEY (`structure_permissible_value_id`) REFERENCES `structure_permissible_values`(`id`);

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(''quality control tools'')' WHERE `domain_name` LIKE 'custom_laboratory_qc_tool';

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('announcements', 'Announcements', 'Annonces'),
("a specified %s already exists for that dropdown", "A specified %s already exists for that dropdown", "Un champ %s existe déjà pour ce menu déroulant"),
("you cannot declare the same %s more than once", "You cannot declare the same %s more than once", "Vous ne pouvez pas déclarer la même valeur plus d'une fois pour le champ %s"),
("%s cannot exceed %d characters", "%s cannot exceed %d characters", "Le champ %s ne dois pas excéder %s caractères");

ALTER TABLE `structure_permissible_values_custom_controls` ADD `values_max_length` TINYINT UNSIGNED NOT NULL;
UPDATE structure_permissible_values_custom_controls SET values_max_length=20;

INSERT INTO structure_validations (structure_field_id, rule, flag_empty, flag_required, language_message) VALUES
((SELECT id FROM structure_fields WHERE model='StructurePermissibleValuesCustom' AND field='en'), 'notEmpty', 0, 1, 'value is required'),
((SELECT id FROM structure_fields WHERE model='StructurePermissibleValuesCustom' AND field='fr'), 'notEmpty', 0, 1, 'value is required');

ALTER TABLE datamart_structures
 ADD COLUMN flag_active BOOLEAN NOT NULL DEFAULT true;
 
