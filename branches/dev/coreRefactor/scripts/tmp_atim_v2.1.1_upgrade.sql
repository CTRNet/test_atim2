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
("%s cannot exceed %d characters", "%s cannot exceed %d characters", "Le champ %s ne dois pas excéder %s caractères"),
("nothing to browse to", "Nothing to browse to", "Aucun élément à naviguer");

ALTER TABLE `structure_permissible_values_custom_controls` ADD `values_max_length` TINYINT UNSIGNED NOT NULL;
UPDATE structure_permissible_values_custom_controls SET values_max_length=20;

INSERT INTO structure_validations (structure_field_id, rule, flag_empty, flag_required, language_message) VALUES
((SELECT id FROM structure_fields WHERE model='StructurePermissibleValuesCustom' AND field='en'), 'notEmpty', 0, 1, 'value is required'),
((SELECT id FROM structure_fields WHERE model='StructurePermissibleValuesCustom' AND field='fr'), 'notEmpty', 0, 1, 'value is required');

ALTER TABLE `structure_formats` 
ADD `flag_addgrid` SET( '0', '1' ) NOT NULL DEFAULT '0' AFTER `flag_datagrid_readonly` ,
ADD `flag_addgrid_readonly` SET( '0', '1' ) NOT NULL DEFAULT '0' AFTER `flag_addgrid` ,
ADD `flag_editgrid` SET( '0', '1' ) NOT NULL DEFAULT '0' AFTER `flag_addgrid_readonly` ,
ADD `flag_editgrid_readonly` SET( '0', '1' ) NOT NULL DEFAULT '0' AFTER `flag_editgrid`;

UPDATE structure_formats SET flag_addgrid=flag_datagrid, flag_editgrid=flag_datagrid, 
flag_addgrid_readonly=flag_datagrid_readonly, flag_editgrid_readonly=flag_datagrid_readonly;

CREATE VIEW view_structure_formats_simplified AS 
SELECT sfo.id AS structure_format_id, sfi.id AS structure_field_id, sfo.structure_id AS structure_id,
sfi.plugin AS plugin, sfi.model AS model, sfi.tablename AS tablename, sfi.field AS field, sfi.structure_value_domain AS structure_value_domain,
IF(sfo.flag_override_label = '1', sfo.language_label, sfi.language_label) AS language_label,
IF(sfo.flag_override_tag = '1', sfo.language_tag, sfi.language_tag) AS language_tag,
IF(sfo.flag_override_help = '1', sfo.language_help, sfi.language_help) AS language_help,
IF(sfo.flag_override_type = '1', sfo.type, sfi.type) AS `type`,
IF(sfo.flag_override_setting = '1', sfo.setting, sfi.setting) AS setting,
IF(sfo.flag_override_default = '1', sfo.default, sfi.default) AS `default`,
sfo.flag_add AS flag_add, sfo.flag_add_readonly AS flag_add_readonly, sfo.flag_edit AS flag_edit, sfo.flag_edit_readonly AS flag_edit_readonly,
sfo.flag_search AS flag_search, sfo.flag_search_readonly AS flag_search_readonly, sfo.flag_addgrid AS flag_addgrid, sfo.flag_addgrid_readonly AS flag_addgrid_readonly,
sfo.flag_editgrid AS flag_editgrid, sfo.flag_editgrid_readonly AS flag_editgrid_readonly, sfo.flag_index AS flag_index, sfo.flag_detail AS flag_detail,  
sfo.display_column AS display_column, sfo.display_order AS display_order, sfo.language_heading AS language_heading
FROM structure_formats AS sfo
INNER JOIN structure_fields AS sfi ON sfo.structure_field_id=sfi.id;

ALTER TABLE structure_validations
 CHANGE COLUMN flag_empty flag_not_empty BOOLEAN NOT NULL;
UPDATE structure_validations SET flag_not_empty=IF(LOCATE('notEmpty', rule), 1, 0);
UPDATE structure_validations SET rule=REPLACE(rule, 'notEmpty,', '');
UPDATE structure_validations SET rule=REPLACE(rule, ',notEmpty', '');
UPDATE structure_validations SET rule=REPLACE(rule, 'notEmpty', '');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', '0', '', 'detail_type', 'detail type', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='detail_type' AND `language_label`='detail type' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='sample_code' AND type='input' AND structure_value_domain  IS NULL );





CRASH - TODO merge rules