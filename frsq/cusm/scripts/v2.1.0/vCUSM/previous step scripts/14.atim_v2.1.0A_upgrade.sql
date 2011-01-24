-- Version: v2.1.0A
-- Description: This SQL script is an upgrade for ATiM v2.1.0 to 2.1.0A and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = '2.1.0A', `date_installed` = NOW(), `build_number` = '2133'
WHERE `versions`.`id` =1;

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
("%s cannot exceed %d characters", "%s cannot exceed %d characters", "Le champ %s ne dois pas excéder %s caractères"),
("nothing to browse to", "Nothing to browse to", "Aucun élément à naviguer");

ALTER TABLE `structure_permissible_values_custom_controls` ADD `values_max_length` TINYINT UNSIGNED NOT NULL;
UPDATE structure_permissible_values_custom_controls SET values_max_length=20;

ALTER TABLE diagnosis_masters
  MODIFY `path_mstage` varchar(15) DEFAULT NULL;

-- Fix issue 1178: Mismatch between main tables and revs tables

ALTER TABLE dxd_cap_report_ampullas MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_colon_biopsies MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_colon_rectum_resections MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_distalexbileducts MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_gallbladders MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_intrahepbileducts MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_pancreasendos MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_pancreasexos MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_perihilarbileducts MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE dxd_cap_report_smintestines MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE dxd_cap_report_ampullas_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_colon_biopsies_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_colon_rectum_resections_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_distalexbileducts_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_gallbladders_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_hepatocellular_carcinomas_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_intrahepbileducts_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_pancreasendos_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_pancreasexos_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_perihilarbileducts_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;
ALTER TABLE dxd_cap_report_smintestines_revs ADD `version_created` datetime NOT NULL AFTER `version_id`;