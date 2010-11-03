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

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('announcements', 'Announcements', 'Annonces');
