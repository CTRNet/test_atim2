-- Version: v2.1.0
-- Description: This SQL script is an upgrade for ATiM v2.0.2A to 2.1.0 and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.1.0', `date_installed` = CURDATE(), `build_number` = '2068'
WHERE `versions`.`id` =1;

TRUNCATE `acos`;

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
("realiquot", "Realiquot", "Réaliquotter"),
("select an option for the field process batch set", "Select an option for the field process batch set", "Sélectionnez une option pour le champ manipuler groupe de données"),
("check at least one element from the batch set", "Check at least one element from the batch set", "Cochez au moins un élément du groupe de données"),
("an x coordinate needs to be defined", "An x coordinate needs to be defined", "Une coordonnée x doit être définie"),
("a y coordinate needs to be defined", "A y coordinate needs to be defined", "Une coordonnée y doit être définie"),
("exact search", "Exact search", "Recherche exacte"),
("you cannot create a user for that group because it has no permission", "You cannot create a user for that group because it has no permission", "Vous ne pouvez pas créer d'utilisateur pour ce groupe car il n'a aucune permission"),
("data browser", "Data browser", "Navigateur de données"),
("paste on all lines", "Paste on all lines", "Coller sur toutes les lignes"),
("or", "or", "ou"),
("range", "range", "intervalle"),
("specific", "specific", "spécifique"),
("no storage", "No storage", "Pas d'entreposage"),
("invalid decimal separator", "Invalid decimal separator", "Séparateur de décimales invalide"),
("if you were logged id, your session has expired.", "If you were logged in, your session has expired", "Si vous étiez connecté, votre session est expirée"),
("check all", "Check all", "Cocher tout"),
("uncheck all", "Uncheck all", "Décocher tout"),
("no filter", "No filter", "Sans filtre");

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('realiquot_with_volume', '', '', '1', '1', '1', '1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='realiquot_with_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  ), '1', '90', '', '0', '', '0', '', '0', '', '1', 'float', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_with_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='use_datetime' AND `structure_value_domain`  IS NULL  ), '1', '91', '', '1', 'use datetime', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_with_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='used_by' AND `language_label`='used by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff ')  AND `language_help`=''), '1', '92', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('realiquot_no_volume', '', '', '1', '1', '1', '1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='realiquot_no_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='use_datetime' AND `structure_value_domain`  IS NULL  ), '1', '91', '', '1', 'use datetime', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_no_volume'), (SELECT id FROM structure_fields WHERE `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='used_by' AND `language_label`='used by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff ')  AND `language_help`=''), '1', '92', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Add cDNA

CREATE TABLE IF NOT EXISTS `sd_der_cdnas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_sd_der_cdnas_sample_masters` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `sd_der_cdnas_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `sd_der_cdnas`
  ADD CONSTRAINT `FK_sd_der_cdnas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_type_code`, `sample_category`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(19, 'cdna', 'cDNA', 'derivative', 1, 'sd_undetailed_derivatives', 'sd_der_cdnas', 0);

INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`)
VALUES 
(null, (SELECT id FROM sample_controls WHERE sample_type LIKE 'rna'), (SELECT id FROM sample_controls WHERE sample_type LIKE 'cdna'),'1');

INSERT INTO `sample_to_aliquot_controls` (`id`, `sample_control_id`, `aliquot_control_id`, `flag_active`)
VALUES 
(null, (SELECT id FROM sample_controls WHERE sample_type LIKE 'cdna'), (SELECT id FROM aliquot_controls WHERE aliquot_type LIKE 'tube' AND form_alias LIKE 'ad_der_tubes_incl_ul_vol_and_conc' AND detail_tablename LIKE 'ad_tubes' AND volume_unit LIKE 'ul'), '1');

SET @sample_to_aliquot_control_id = LAST_INSERT_ID();

INSERT INTO `realiquoting_controls` (`id`, `parent_sample_to_aliquot_control_id`, `child_sample_to_aliquot_control_id`, `flag_active`)
VALUES 
(null, @sample_to_aliquot_control_id, @sample_to_aliquot_control_id, '1');

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('cdna', '', 'cDNA', 'DNAc');

-- Add new message for duplicated aliquot barcodes

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('please check following barcodes', '', 'Please check following barcodes: ', 'Veuillez contrôler les barcodes suivants: ');


-- datamart browser
INSERT INTO `menus` (`id` ,`parent_id` ,`is_root` ,`display_order` ,`language_title` ,`language_description` ,`use_link` ,`use_params` ,`use_summary` ,`flag_active` ,`created` ,`created_by` ,`modified` ,`modified_by`) VALUES 
('qry-CAN-1-1', 'qry-CAN-1', '0', '3', 'data browser', 'tool to browse data', '/datamart/browser/index', '', '', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


CREATE TABLE datamart_structures(
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
plugin VARCHAR(50) NOT NULL,
model VARCHAR(50) NOT NULL,
structure_id INT NOT NULL,
display_name VARCHAR(50) NOT NULL,
use_key VARCHAR(50) NOT NULL,
control_model VARCHAR(50) DEFAULT '',
control_master_model VARCHAR(50) DEFAULT '',
control_field VARCHAR(50) DEFAULT '',
FOREIGN KEY (`structure_id`) REFERENCES `structures`(`id`)
)Engine=InnoDb;

CREATE TABLE datamart_browsing_controls(
id1 INT UNSIGNED NOT NULL,
id2 INT UNSIGNED NOT NULL,
flag_active_1_to_2 BOOLEAN NOT NULL DEFAULT true,
flag_active_2_to_1 BOOLEAN NOT NULL DEFAULT true,
use_field VARCHAR(50) NOT NULL,
UNIQUE(id1, id2),
FOREIGN KEY (`id1`) REFERENCES `datamart_structures`(`id`),
FOREIGN KEY (`id2`) REFERENCES `datamart_structures`(`id`)
)Engine=InnoDb;

INSERT INTO datamart_structures (`id`, `plugin`, `model`, `structure_id`, `display_name`, `use_key`, `control_model`, `control_master_model`, `control_field`) VALUES
(1, 'Inventorymanagement', 'ViewAliquot', (SELECT id FROM structures WHERE alias='view_aliquot_joined_to_collection'), 'aliquots', 'aliquot_master_id', 'AliquotControl', 'AliquotMaster', 'aliquot_control_id'),
(2, 'Inventorymanagement', 'ViewCollection', (SELECT id FROM structures WHERE alias='view_collection'), 'collections', 'collection_id', '', '', ''),
(3, 'Storagelayout', 'StorageMaster', (SELECT id FROM structures WHERE alias='storagemasters'), 'storages', 'id', 'StorageControl', 'StorageMaster', 'storage_control_id'),
(4, 'Clinicalannotation', 'Participant', (SELECT id FROM structures WHERE alias='participants'), 'participants', 'id', '', '', ''),
(5, 'Inventorymanagement', 'ViewSample', (SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 'samples', 'sample_master_id', 'SampleControl', 'SampleMaster', 'sample_control_id'),
(6, 'Clinicalannotation', 'MiscIdentifier', (SELECT id FROM structures WHERE alias='miscidentifierssummary'), 'identification', 'id', '', '', '');

INSERT INTO datamart_browsing_controls(`id1`, `id2`, `use_field`) VALUES
(1, 3, 'ViewAliquot.storage_master_id'),
(2, 4, 'ViewCollection.participant_id'),
(1, 5, 'ViewAliquot.sample_master_id'),
(5, 2, 'ViewSample.collection_id'),
(6, 4, 'MiscIdentifier.participant_id');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('datamart_browser_options', '', '', NULL);
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('datamart_browser_start', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Datamart', 'Browser', '', 'search_for', 'action', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='datamart_browser_options') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='datamart_browser_start'), (SELECT id FROM structure_fields WHERE `model`='Browser' AND `tablename`='' AND `field`='search_for' AND `language_label`='action' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='datamart_browser_options')  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');

CREATE TABLE datamart_browsing_results(
  `id` int UNSIGNED AUTO_INCREMENT primary key,
  `user_id` int UNSIGNED NOT NULL,
  `parent_node_id` tinyint UNSIGNED,
  `browsing_structures_id` int UNSIGNED,
  `browsing_structures_sub_id` int UNSIGNED DEFAULT 0,
  `raw` boolean NOT NULL,
  `serialized_search_params` text NOT NULL,
  `id_csv` text NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL
#UNIQUE KEY (`user_id`, `parent_node_id`, `browsing_structures_id`, `id_csv`(200))
)Engine=InnoDb;

CREATE TABLE datamart_browsing_results_revs(
  `id` int UNSIGNED,
  `user_id` int UNSIGNED NOT NULL,
  `parent_node_id` tinyint UNSIGNED,
  `browsing_structures_id` int UNSIGNED,
  `browsing_structures_sub_id` int UNSIGNED DEFAULT 0,
  `raw` boolean NOT NULL,
  `serialized_search_params` text NOT NULL,
  `id_csv` text NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`version_id`)
)Engine=InnoDb;


-- eventum 953
INSERT INTO `menus` (`id` ,`parent_id` ,`is_root` ,`display_order` ,`language_title` ,`language_description` ,`use_link` ,`use_params` ,`use_summary` ,`flag_active` ,`created` ,`created_by` ,`modified` ,`modified_by`) VALUES 
('core_CAN_41_3', 'core_CAN_41', '0', '3', 'dropdowns', 'dropdowns', '/administrate/dropdowns/index', '', '', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

CREATE TABLE structure_permissible_values_custom_controls(
id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name varchar(50) NOT NULL
)Engine=InnoDb;

INSERT INTO structure_permissible_values_custom_controls VALUES
(1, 'staff'),
(2, 'laboratory sites'),
(3, 'collection sites'),
(4, 'specimen supplier departments'),
(5, 'tools');

CREATE TABLE structure_permissible_values_customs(
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  control_id int UNSIGNED NOT NULL,
  value varchar(50) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  FOREIGN KEY (`control_id`) REFERENCES `structure_permissible_values_custom_controls`(`id`),
  UNIQUE(control_id, value)
)Engine=InnoDb;

CREATE TABLE structure_permissible_values_customs_revs(
  id int UNSIGNED NOT NULL,
  control_id int UNSIGNED NOT NULL,
  value varchar(50) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`version_id`) 
)Engine=InnoDb;

CREATE TABLE datamart_browsing_indexes(
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `root_node_id` int UNSIGNED NOT NULL,
  `notes` text NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  FOREIGN KEY (`root_node_id`) REFERENCES `datamart_browsing_results`(`id`)
)Engine=InnoDb;

CREATE TABLE datamart_browsing_indexes_revs(
  `id` int UNSIGNED NOT NULL,
  `root_node_id` int UNSIGNED NOT NULL,
  `notes` text NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`version_id`)
)Engine=InnoDb;

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('datamart_browsing_indexes', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Datamart', 'BrowsingIndex', 'datamart_browsing_indexes', 'notes', 'notes', '', 'textarea', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Datamart', 'BrowsingIndex', 'datamart_browsing_indexes', 'created', 'created', '', 'datetime', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='datamart_browsing_indexes'), (SELECT id FROM structure_fields WHERE `model`='BrowsingIndex' AND `tablename`='datamart_browsing_indexes' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='datamart_browsing_indexes'), (SELECT id FROM structure_fields WHERE `model`='BrowsingIndex' AND `tablename`='datamart_browsing_indexes' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '0');

-- 953, transfering existing values into the new table
INSERT INTO structure_permissible_values_customs(control_id, value)
(SELECT '1', value FROM structure_permissible_values WHERE id IN (SELECT structure_permissible_value_id FROM structure_value_domains_permissible_values WHERE structure_value_domain_id=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')));
INSERT INTO structure_permissible_values_customs(control_id, value)
(SELECT '2', value FROM structure_permissible_values WHERE id IN (SELECT structure_permissible_value_id FROM structure_value_domains_permissible_values WHERE structure_value_domain_id=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site')));
INSERT INTO structure_permissible_values_customs(control_id, value)
(SELECT '3', value FROM structure_permissible_values WHERE id IN (SELECT structure_permissible_value_id FROM structure_value_domains_permissible_values WHERE structure_value_domain_id=(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site')));
INSERT INTO structure_permissible_values_customs(control_id, value)
(SELECT '4', value FROM structure_permissible_values WHERE id IN (SELECT structure_permissible_value_id FROM structure_value_domains_permissible_values WHERE structure_value_domain_id=(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept')));
INSERT INTO structure_permissible_values_customs(control_id, value)
(SELECT '5', value FROM structure_permissible_values WHERE id IN (SELECT structure_permissible_value_id FROM structure_value_domains_permissible_values WHERE structure_value_domain_id=(SELECT id FROM structure_value_domains WHERE domain_name='custom_tool')));
INSERT INTO structure_permissible_values_customs_revs(id, control_id, value)
(SELECT id, control_id, value FROM structure_permissible_values_customs);

-- 953, updating source
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getDropdownStaff' WHERE domain_name='custom_laboratory_staff';
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getDropdownLaboratorySites' WHERE domain_name='custom_laboratory_site';
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getDropdownCollectionSites' WHERE domain_name='custom_collection_site';
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getDropdownSpecimenSupplierDepartments' WHERE domain_name='custom_specimen_supplier_dept';
UPDATE structure_value_domains SET source='StructurePermissibleValuesCustom::getDropdownToors' WHERE domain_name='custom_tool';

-- 953, new structures for display and input
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('administrate_dropdowns', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Administrate', 'StructurePermissibleValuesCustomControl', 'structure_permissible_values_custom_controls', 'name', 'name', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='administrate_dropdowns'), (SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustomControl' AND `tablename`='structure_permissible_values_custom_controls' AND `field`='name' AND `language_label`='name' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('administrate_dropdown_values', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Administrate', 'StructurePermissibleValuesCustom', 'structure_permissible_values_customs', 'value', 'value', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='administrate_dropdown_values'), (SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustom' AND `tablename`='structure_permissible_values_customs' AND `field`='value' AND `language_label`='value' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

-- 953, removing associations from value_domains_permissible_values and clearing unused values from permissible_values
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id IN(SELECT id FROM structure_value_domains WHERE domain_name IN('custom_laboratory_staff', 'custom_laboratory_site', 'custom_collection_site', 'custom_specimen_supplier_dept', 'custom_tool'));
DELETE spv FROM structure_permissible_values AS spv
LEFT JOIN structure_value_domains_permissible_values AS assoc ON spv.id=assoc.structure_permissible_value_id
WHERE assoc.id IS NULL;

-- expanding batch set to support the databrowser
ALTER TABLE `datamart_batch_sets` ADD `lookup_key_name` VARCHAR( 50 ) NOT NULL DEFAULT 'id' AFTER `model`;

-- search participants by created date
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  ), '4', '15', '', '1', 'created', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '1', '1');

-- adding range param for identifiers value search
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=30,class=range' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifierssummary') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='MiscIdentifier' AND tablename='misc_identifiers' AND field='identifier_value');

-- Update participant menus linked to inventory

SET @link_to_collection_url = (SELECT use_link FROM menus WHERE id = 'clin_CAN_67');
UPDATE menus SET language_title = 'participant inventory', use_link = @link_to_collection_url, language_description = NULL
WHERE id = 'clin_CAN_57'; -- products

UPDATE menus SET language_title = 'participant samples and aliquots list', language_description = NULL, display_order = 2
WHERE id = 'clin_CAN_571'; --  tree view

UPDATE menus SET language_title = 'participant collections list', language_description = NULL, display_order = 1, parent_id = 'clin_CAN_57', use_summary = null
WHERE id = 'clin_CAN_67'; --  link to collection

DELETE FROM `i18n` WHERE `id` IN ('participant inventory', 'participant samples and aliquots list', 'participant collections list');
INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
VALUES 
('participant inventory', '', 'Inventory', 'Inventaire'),
('participant samples and aliquots list', '', 'Summary', 'Résumé'),
('participant collections list', '', 'Participant Collections', 'Collections du participant');

-- Update views to avoid bug generated during QC customisation
-- Drop group by in aliquot_views being time consuming

DROP VIEW view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

samp.initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type,
samp.sample_code,
samp.sample_category,
samp.deleted

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
WHERE samp.deleted != 1;

DROP VIEW view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

samp.initial_specimen_sample_type, 	
parent_samp.sample_type AS parent_sample_type,
samp.sample_type,

al.barcode,
al.aliquot_type,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1;

SET FOREIGN_KEY_CHECKS=0;
UPDATE structures SET alias = 'collections_for_collection_tree_view' WHERE alias = 'collection_tree_view';
UPDATE structures SET alias = 'view_aliquot_joined_to_sample_and_collection' WHERE alias = 'view_aliquot_joined_to_collection';
-- UPDATE datamart_browsing_structures SET structure_alias = 'view_aliquot_joined_to_sample_and_collection' WHERE structure_alias = 'view_aliquot_joined_to_collection';
SET FOREIGN_KEY_CHECKS=1;

SET @stuctrue_field_id = (SELECT id FROM structure_fields WHERE model LIKE 'ViewAliquot' AND field LIKE 'aliquot_use_counter');
DELETE FROM structure_formats WHERE structure_field_id = @stuctrue_field_id;
DELETE FROM structure_fields WHERE id = @stuctrue_field_id;

-- Update collection menus

UPDATE menus SET language_title = 'collection samples and aliquots management'
WHERE id = 'inv_CAN_21'; -- collection products

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
('collection samples and aliquots management', 'Samples & Aliquots', 'Échantillons & Aliquots'),
('model import failed', 'Model import failed', "Échec d'import du modèle"),
('the import for model [%1$s] failed', 'The import for model [%1$s] failed', "L'import du modèle [%1$s] a échoué"),
('internal error', 'Internal error', 'Erreur interne'),
("an internal error was found on [%1$s]", "An internal error was found on [%1$s]", "Une erreur interne a été trouvée sur [%1$s]"),
("browse", "Browse", "Naviguer"),
("create batchset", "Create batchset", "Créer un ensemble de données"),
("storages", "Storages", "Entreposages"),
("new", "New", "Nouveau"),
("action", "Action", "Action"),
("you must select an action", "You must select an action", "Vous devez sélectionner une action"),
("you need to select at least one item", "You need to select at least one item", "Vous devez sélectionner au moins un item"),
("you cannot browse to the requested entities because some intermediary elements do not exist", "You cannot browse to the requested entities because some intermediary elements do not exist", "Vous ne pouvez pas naviguer aux entités demandées car certains éléments intermédiares n'existent pas"),
("language", "Language", "Langue"),
("language preferred", "Language preferred", "Langue préférée"),
("address", "Address", "Adresse"),
("contacts", "Contacts", "Contacts"),
("tmp on ice", "Transported on ice", "Transporté sur glace"),
("see parent storage", "Parent storage", "Entreposage parent"),
("storage", "Storage", "Entreposage"),
("save", "Save", "Enregistrer"),
("new batchset", "New batchset", "Nouvel ensemble de données"),
("add to compatible batchset", "Add to compatible batchset", "Ajouter à un ensble de données compatible"),
("the used volume is higher than the remaining volume", "The used volume is higher than the remaining volume", "Le volume utilisé est supérieur au volume restant"),
("do you wish to proceed?", "Do you wish to proceed?", "Souhaitez-vous continuer?"),
("out of", "out of", "de");



INSERT INTO `pages` (`id` ,`error_flag` ,`language_title` ,`language_body` ,`use_link` ,`created` ,`created_by` ,`modified` ,`modified_by`) VALUES 
('err_model_import_failed', '1', 'model import failed', 'the import for model [%1$s] failed', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
('err_internal', '1', 'internal error', 'an internal error was found on [%1$s]', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Header text for permissions form
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('permission control panel', 'Permission Control Panel', 'Panneau de contrôle des permissions'),
('note: permission changes will not take effect until the user logs out of the system.', 'NOTE: Permission changes will not take effect until the user logs out of the system.', "NOTE: L'utilisateur doit se déconnecter avant que le changement de permission entre en vigueur.");


-- Replace "street" to "address"
UPDATE structure_fields SET  `language_label`='address' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='street';
UPDATE structure_fields SET  `language_label`='address' WHERE model='User' AND tablename='users' AND field='street';

UPDATE `menus` SET `language_title` = 'contacts', `language_description` = 'contacts' WHERE `menus`.`id` = 'clin_CAN_26';

-- Modiy Protocol tools and treatment according to new business rules

CREATE TABLE IF NOT EXISTS `pd_surgeries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `protocol_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_pd_chemos_protocol_masters` (`protocol_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `pd_surgeries`
  ADD CONSTRAINT `FK_pd_surgeries_protocol_masters` FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);

CREATE TABLE IF NOT EXISTS `pd_surgeries_revs` (
  `id` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `protocol_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `protocol_controls` 
	CHANGE `extend_tablename` `extend_tablename` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL ,
	CHANGE `extend_form_alias` `extend_form_alias` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL;

INSERT INTO `protocol_controls` (`id`, `tumour_group`, `type`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) 
VALUES
(null, 'all', 'surgery', 'pd_surgeries', 'pd_surgeries', null, null, NULL, 0, NULL, 0, 1);

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('pd_surgeries', '', '', '1', '1', '1', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='pd_surgeries'),
(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='name' AND `language_label`='name' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_surgeries'),
(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='cols=40,rows=6' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='pd_surgeries'),
(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='code' AND `language_label`='code' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_surgeries'),
(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='tumour_group' AND `language_label`='tumour group' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol tumour group')  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='pd_surgeries'),
(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol type')  AND `language_help`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '1', '1');

UPDATE menus SET language_title = 'precision', language_description = 'precision' WHERE id = 'proto_CAN_83';

INSERT IGNORE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('no additional data has to be defined for this type of protocol', '', 'No additional data has to be defined for this type of protocol!', 'Pas de données additionnelles pour ce type de protocole!');

ALTER TABLE `tx_controls` 
	CHANGE `extend_tablename` `extend_tablename` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL ,
	CHANGE `extend_form_alias` `extend_form_alias` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL;

INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `allow_administration`) VALUES
(null, 'surgery without extend', 'all', 1, 'txd_surgeries', 'txd_surgeries', null, null, 0, 0);

ALTER TABLE `tx_controls` 
	ADD `applied_protocol_control_id` int(11) DEFAULT NULL AFTER `display_order`,
  	ADD CONSTRAINT `FK_tx_controls_protocol_controls` FOREIGN KEY (`applied_protocol_control_id`) REFERENCES `protocol_controls` (`id`);
  	
UPDATE `tx_controls`
	SET applied_protocol_control_id = (SELECT id FROM protocol_controls WHERE tumour_group = 'all' AND type = 'chemotherapy') WHERE tx_method = 'chemotherapy' AND disease_site = 'all';
	
UPDATE `tx_controls`
	SET applied_protocol_control_id = (SELECT id FROM protocol_controls WHERE tumour_group = 'all' AND type = 'surgery') WHERE tx_method IN ('surgery', 'surgery without extend') AND disease_site = 'all';

ALTER TABLE `tx_controls` 
	DROP `allow_administration`,
	ADD `extended_data_import_process` varchar(50) DEFAULT NULL AFTER `applied_protocol_control_id`;
	
UPDATE `tx_controls`
	SET extended_data_import_process = 'importDrugFromChemoProtocol' WHERE tx_method = 'chemotherapy' AND disease_site = 'all';

ALTER TABLE structure_fields
DROP KEY `unique_fields`,
ADD UNIQUE KEY `unique_fields` (`field`, `type`, `model`,`tablename`, `structure_value_domain`);

-- order aliquot barcode autocomplete;
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'barcode', 'barcode', '', 'autocomplete', 'url=/inventorymanagement/aliquot_masters/autocompleteBarcode', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_validations (`structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`) 
(SELECT (SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND `type`='autocomplete' AND structure_value_domain IS NULL ), `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message` FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND `type`='input' AND structure_value_domain  IS NULL ));
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `type`='autocomplete' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='input' AND structure_value_domain  IS NULL );
	
-- Change query tool dropdown label
UPDATE structure_fields SET  `language_label`='action' WHERE model='BatchSet' AND tablename='datamart_adhoc' AND field='id' AND `type`='select' AND structure_value_domain  IS NULL ;


-- Fix estrogen field that had the wrong tablename specified
UPDATE `structure_fields` SET `tablename` = 'ed_breast_lab_pathology' WHERE `field` = 'estrogen';

-- Remove ALL SOLID TUMOURS form from Annotation and related structure tables
DELETE FROM `event_controls` WHERE `disease_site`='all solid tumours' AND `event_group`='lab' AND `event_type`='pathology' LIMIT 1;
DELETE FROM `structure_formats` 
WHERE `structure_field_id` IN (SELECT `id` FROM `structure_fields` WHERE tablename = 'ed_allsolid_lab_pathology' AND plugin = 'Clinicalannotation' AND `model` = 'EventDetail');
DELETE FROM `structure_formats` WHERE `structure_id` = (SELECT `id` FROM `structures` WHERE `alias` = 'ed_allsolid_lab_pathology');
DELETE FROM `structures` WHERE `alias` = 'ed_allsolid_lab_pathology';
DELETE FROM `structure_validations` WHERE `structure_field_id` IN (SELECT `id` FROM `structure_fields` WHERE tablename = 'ed_breast_lab_pathology' AND field = 'estrogen'); 
DELETE FROM `structure_fields` WHERE tablename = 'ed_allsolid_lab_pathology' AND plugin = 'Clinicalannotation' AND `model` = 'EventDetail';
DELETE FROM `i18n` WHERE `id` = 'estrogens amount is required.';

-- eventum 961 (for misc identifiers)
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'MiscIdentifier', 'misc_identifiers', 'misc_identifier_control_id', 'misc identifier control id', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') , 'help_identifier name', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='miscidentifierssummary'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='misc_identifier_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') ), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifierssummary') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='MiscIdentifier' AND tablename='misc_identifiers' AND field='identifier_name' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list'));

-- eventum 852 (used volume check)
UPDATE structure_fields SET `type`='float' WHERE plugin='Inventorymanagement' AND model='AliquotMaster' AND field='current_volume' AND tablename='aliquot_masters';
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotuses'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  ), '0', '3', '', '1', '', '1', 'out of', '0', '', '0', '', '1', '', '0', '', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0');

-- Fix drug and material detail menu option
UPDATE `menus` SET `use_link` = '/drug/drugs/detail/%%Drug.id%%' WHERE `menus`.`id` = 'drug_CAN_97';
UPDATE `menus` SET `use_link` = '/material/materials/detail/%%Material.id%%' WHERE `menus`.`id` = 'mat_CAN_02';

-- Move participant created field to column 2
UPDATE `structure_formats`
SET `display_column` = 3, `display_order` = 99
WHERE `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `plugin`='Clinicalannotation' AND `model`='Participant' AND `field`='created' AND `tablename`='participants') AND
`structure_id` = (SELECT `id` FROM `structures` WHERE `alias` = 'participants');

-- refactoring sample flag_active to only be contained within one table. Same for aliquot
INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`)
(SELECT NULL, id, flag_active FROM sample_controls WHERE sample_category='specimen');
UPDATE parent_to_derivative_sample_controls as pdsc
INNER JOIN sample_controls sc ON pdsc.parent_sample_control_id=sc.id OR pdsc.derivative_sample_control_id=sc.id
SET pdsc.flag_active=0 WHERE sc.flag_active=0;
ALTER TABLE sample_controls 
DROP flag_active;

UPDATE sample_to_aliquot_controls as sac
INNER JOIN aliquot_controls ac ON sac.aliquot_control_id=ac.id
SET sac.flag_active=0 WHERE ac.flag_active=0;
ALTER TABLE aliquot_controls 
DROP flag_active;

-- Add search on control id instead control name for identifier

SET FOREIGN_KEY_CHECKS=0;

UPDATE structures
SET alias = 'miscidentifiers_for_participant_search' 
WHERE alias = 'miscidentifierssummary';

-- UPDATE datamart_browsing_structures
-- SET structure_alias = 'miscidentifiers_for_participant_search'
-- WHERE structure_alias = 'miscidentifierssummary';

SET FOREIGN_KEY_CHECKS=1;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'identifier_name_list_from_id', 'open', '', 'Clinicalannotation.MiscIdentifierControl::getMiscIdentifierNamePermissibleValuesFromId');

UPDATE structure_fields 
SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'identifier_name_list_from_id'),
language_label = 'identifier name'
WHERE field = 'misc_identifier_control_id';

-- reporting
INSERT INTO `menus` (`id` ,`parent_id` ,`is_root` ,`display_order` ,`language_title` ,`language_description` ,`use_link` ,`use_params` ,`use_summary` ,`flag_active` ,`created` ,`created_by` ,`modified` ,`modified_by`) VALUES 
('qry-CAN-1-2', 'qry-CAN-1', '0', '3', 'reports', 'reports', '/datamart/reports/index', '', '', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

CREATE TABLE datamart_reports(
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50) NOT NULL DEFAULT '',
`description` TEXT NOT NULL,
`datamart_structure_id` INT UNSIGNED NULL,
`function` VARCHAR(50) NULL,
`serialized_representation` TEXT,
`created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
`created_by` int(10) unsigned NOT NULL,
`modified` datetime DEFAULT NULL,
`modified_by` int(10) unsigned NOT NULL,
FOREIGN KEY (`datamart_structure_id`) REFERENCES `datamart_structures`(`id`)
)Engine=InnoDb;

CREATE TABLE datamart_reports_revs(
`id` INT UNSIGNED NOT NULL,
`name` VARCHAR(50) NOT NULL DEFAULT '',
`description` TEXT NOT NULL,
`datamart_structure_id` INT UNSIGNED NULL,
`function` VARCHAR(50) NULL,
`serialized_representation` TEXT,
`created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
`created_by` int(10) unsigned NOT NULL,
`modified` datetime DEFAULT NULL,
`modified_by` int(10) unsigned NOT NULL,
`version_id` int(11) NOT NULL AUTO_INCREMENT,
`version_created` datetime NOT NULL,
`deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
`deleted_date` datetime DEFAULT NULL,
PRIMARY KEY (`version_id`)
)Engine=InnoDb;

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('reports', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Datamart', 'Report', 'datamart_reports', 'name', 'name', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Datamart', 'Report', 'datamart_reports', 'description', 'description', '', 'textarea', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='reports'), (SELECT id FROM structure_fields WHERE `model`='Report' AND `tablename`='datamart_reports' AND `field`='name' AND `language_label`='name' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='reports'), (SELECT id FROM structure_fields WHERE `model`='Report' AND `tablename`='datamart_reports' AND `field`='description' AND `language_label`='description' AND `language_tag`='' AND `type`='textarea' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('report_structures', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Datamart', 'DatamartStructure', 'datamart_report_structures', 'display_name', 'display name', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='report_structures'), (SELECT id FROM structure_fields WHERE `model`='DatamartStructure' AND `tablename`='datamart_report_structures' AND `field`='display_name' AND `language_label`='display name' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');


-- Add search on control id instead control name for sample

DROP VIEW view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,
samp.sample_code,
samp.sample_category,
samp.deleted

FROM sample_masters as samp
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
WHERE samp.deleted != 1;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'specimen_sample_type_from_id', 'open', '', 'Inventorymanagement.SampleControl::getSpecimenSampleTypePermissibleValuesFromId');

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'Inventorymanagement', 'ViewSample', '', 'sample_control_id', 'sample type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'sample_type_from_id'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewSample', '', 'parent_sample_control_id', 'parent sample type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'sample_type_from_id'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewSample', '', 'initial_specimen_sample_control_id', 'initial specimen type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'specimen_sample_type_from_id'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `field`='sample_control_id' ), 
'0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `field`='parent_sample_control_id' ), 
'0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `field`='initial_specimen_sample_control_id' ), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '0', '0'); 

UPDATE structure_formats
SET flag_search = '0'
WHERE structure_id = (SELECT id FROM structures WHERE alias='view_sample_joined_to_collection')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `field` IN ('initial_specimen_sample_type', 'parent_sample_type', 'sample_type'));

-- Add constraint on sample controls

ALTER TABLE `sample_controls` 
	CHANGE `sample_category` `sample_category` ENUM( 'specimen', 'derivative' ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL; 

ALTER TABLE `tx_controls` 
	CHANGE `extend_tablename` `extend_tablename` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL ,
	CHANGE `extend_form_alias` `extend_form_alias` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL;

ALTER TABLE `sample_controls` ADD UNIQUE (`sample_type`);

-- Add constraint on sample controls

ALTER TABLE `aliquot_controls` 
	CHANGE `aliquot_type` `aliquot_type` ENUM( 'block', 'cell gel matrix', 'core', 'slide', 'tube', 'whatman paper' ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Generic name.';

ALTER TABLE `aliquot_controls` 
  	ADD `aliquot_type_precision` varchar(30) DEFAULT NULL  COMMENT 'Use to differentiate two aliquot controls having the same aliquot_type in case they can be used for the same sample type. (Ex: tissue tube (5ml) and tissue tube (cryogenic)).' AFTER `aliquot_type` ;

UPDATE aliquot_controls SET aliquot_type_precision = 'cells' WHERE aliquot_type = 'core' AND form_alias = 'ad_der_cell_cores';
UPDATE aliquot_controls SET aliquot_type_precision = 'tissue' WHERE aliquot_type = 'core' AND form_alias = 'ad_spec_tiss_cores';

UPDATE aliquot_controls SET aliquot_type_precision = 'cells' WHERE aliquot_type = 'slide' AND form_alias = 'ad_der_cell_slides';
UPDATE aliquot_controls SET aliquot_type_precision = 'tissue' WHERE aliquot_type = 'slide' AND form_alias = 'ad_spec_tiss_slides';

UPDATE aliquot_controls SET aliquot_type_precision = 'cells' WHERE aliquot_type = 'tube' AND form_alias = 'ad_der_cell_tubes_incl_ml_vol';
UPDATE aliquot_controls SET aliquot_type_precision = 'specimen tube' WHERE aliquot_type = 'tube' AND form_alias = 'ad_spec_tubes';
UPDATE aliquot_controls SET aliquot_type_precision = 'derivative tube (ml)' WHERE aliquot_type = 'tube' AND form_alias = 'ad_der_tubes_incl_ml_vol';
UPDATE aliquot_controls SET aliquot_type_precision = 'derivative tube (ul + conc)' WHERE aliquot_type = 'tube' AND form_alias = 'ad_der_tubes_incl_ul_vol_and_conc';
UPDATE aliquot_controls SET aliquot_type_precision = 'specimen tube (ml)' WHERE aliquot_type = 'tube' AND form_alias = 'ad_spec_tubes_incl_ml_vol';

INSERT IGNORE INTO i18n (id, en, fr)
VALUES
('cells', 'Cells', 'Cellules'),
('tissue', 'Tissue', 'Tissu'),
('specimen tube', 'Specimen', 'Spécimen'),
('specimen tube (ml)', 'Specimen (ml)', 'Spécimen (ml)'),
('derivative tube (ml)', 'Derivative (ml)', 'Dérivé (ml)'),
('derivative tube (ul + conc)', 'Derivative (ul + conc°)', 'Dérivé (ul + conc°)');

-- Add search on control id instead control name for aliquot (except aliquot type)

DROP VIEW view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 

specimen.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_samp.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
samp.sample_type,
samp.sample_control_id,

al.barcode,
al.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created,
al.deleted

FROM aliquot_masters as al
INNER JOIN sample_masters as samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters as specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_masters as parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1;

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'Inventorymanagement', 'ViewAliquot', '', 'aliquot_control_id', 'aliquot type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'aliquot_type_from_id'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'Inventorymanagement', 'ViewAliquot', '', 'sample_control_id', 'sample type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'sample_type_from_id'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewAliquot', '', 'parent_sample_control_id', 'parent sample type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'sample_type_from_id'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewAliquot', '', 'initial_specimen_sample_control_id', 'initial specimen type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'specimen_sample_type_from_id'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `field`='sample_control_id' ), 
'0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `field`='parent_sample_control_id' ), 
'0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `field`='initial_specimen_sample_control_id' ), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `field`='aliquot_control_id' ), 
'0', '9', '', '1', 'specific aliquot type', '0', '', '0', '', '0', '', '0', '', '0', '', 
'0', '0', '0', '0', '1', '0', '0', '0', '0', '0'); 

INSERT IGNORE INTO i18n (id, en, fr)
VALUES
('specific aliquot type', 'Aliquot Type (Specific)', 'Type d''aliquot (précis)');

UPDATE structure_formats
SET flag_search = '0'
WHERE structure_id = (SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' 
AND `field` IN ('initial_specimen_sample_type', 'parent_sample_type', 'sample_type'));

--
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('date_range', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', '', '0', '', 'date_from', 'from', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'),
('', '', '0', '', 'action', 'action', '', 'select', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='date_range'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='date_from' AND `language_label`='from' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='date_range'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='action' AND `language_label`='action' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0');

INSERT INTO `datamart_reports` (`id` ,`name` ,`description` ,`datamart_structure_id` ,`function` ,`serialized_representation` ,`created` ,`created_by` ,`modified` ,`modified_by`) VALUES 
(NULL , 'number of consents obtained by month', 'shows the number of consents obtained by month for a specified date range' , NULL , 'nb_consent_by_month', NULL , '0000-00-00 00:00:00', '', NULL , ''),
(NULL , 'number of samples acquired', 'shows the number of samples acquired for a specified date range' , NULL , 'samples_by_type', NULL , '0000-00-00 00:00:00', '', NULL , '');

UPDATE structure_fields SET type='float_positive' WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='input' AND `structure_value_domain` IS NULL; 

-- Pathology review

DROP TABLE IF EXISTS `path_collection_reviews`;
DROP TABLE IF EXISTS `path_collection_reviews_revs`;

DROP TABLE IF EXISTS `review_masters`;
DROP TABLE IF EXISTS `review_masters_revs`;

DROP TABLE IF EXISTS `rd_bloodcellcounts`;
DROP TABLE IF EXISTS `rd_bloodcellcounts_revs`;
DROP TABLE IF EXISTS `rd_blood_cells`;
DROP TABLE IF EXISTS `rd_blood_cells_revs`;
DROP TABLE IF EXISTS `rd_breastcancertypes`;
DROP TABLE IF EXISTS `rd_breastcancertypes_revs`;
DROP TABLE IF EXISTS `rd_breast_cancers`;
DROP TABLE IF EXISTS `rd_breast_cancers_revs`;
DROP TABLE IF EXISTS `rd_coloncancertypes`;
DROP TABLE IF EXISTS `rd_coloncancertypes_revs`;
DROP TABLE IF EXISTS `rd_genericcancertypes`;
DROP TABLE IF EXISTS `rd_genericcancertypes_revs`;
DROP TABLE IF EXISTS `rd_ovarianuteruscancertypes`;
DROP TABLE IF EXISTS `rd_ovarianuteruscancertypes_revs`;

DROP TABLE IF EXISTS `ar_breast_tissue_slides_revs`;
DROP TABLE IF EXISTS `ar_breast_tissue_slides`;
DROP TABLE IF EXISTS `aliquot_review_masters_revs`;
DROP TABLE IF EXISTS `aliquot_review_masters`;
DROP TABLE IF EXISTS `spr_breast_cancer_types_revs`;
DROP TABLE IF EXISTS `spr_breast_cancer_types`;
DROP TABLE IF EXISTS `specimen_review_masters_revs`;
DROP TABLE IF EXISTS `specimen_review_masters`;

DROP TABLE IF EXISTS `specimen_review_controls`;
DROP TABLE IF EXISTS `aliquot_review_controls`;
DROP TABLE IF EXISTS `review_controls`;

CREATE TABLE IF NOT EXISTS `aliquot_review_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `review_type` varchar(100) NOT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `aliquot_type_restriction` enum('all', 'block','cell gel matrix','core','slide','tube','whatman paper') NOT NULL DEFAULT 'all' COMMENT 'Allow to link specific aliquot type to the specimen review.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `review_type` (`review_type`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `specimen_review_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_control_id` int(11) NOT NULL,
  `aliquot_review_control_id` int(11) DEFAULT NULL,
  `specimen_sample_type` varchar(30) NOT NULL,
  `review_type` varchar(100) NOT NULL,
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,  PRIMARY KEY (`id`),
  UNIQUE KEY `review_type` (`sample_control_id`, `specimen_sample_type`, `review_type`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `specimen_review_controls`
  ADD CONSTRAINT `FK_specimen_review_controls_sample_controls` FOREIGN KEY (`sample_control_id`) REFERENCES `sample_controls` (`id`);
ALTER TABLE `specimen_review_controls`
  ADD CONSTRAINT `FK_specimen_review_controls_specimen_review_controls` FOREIGN KEY (`aliquot_review_control_id`) REFERENCES `specimen_review_controls` (`id`);

INSERT INTO `aliquot_review_controls`
(`review_type`, `flag_active`,  `form_alias`, `detail_tablename`, `aliquot_type_restriction`)
VALUES
('breast tissue slide review', '1', 'ar_breast_tissue_slides', 'ar_breast_tissue_slides', 'slide');

INSERT INTO `specimen_review_controls`
(`sample_control_id`, `specimen_sample_type`, `review_type`, 
`aliquot_review_control_id`, `flag_active`, `form_alias`, `detail_tablename`)
VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'tissue' AND sample_category = 'specimen'), 'tissue', 'breast review', 
(SELECT id FROM aliquot_review_controls WHERE review_type = 'breast tissue slide review'), '1', 'spr_breast_cancer_types','spr_breast_cancer_types'),
((SELECT id FROM sample_controls WHERE sample_type = 'tissue' AND sample_category = 'specimen'), 'tissue', 'breast review (simple)', 
null, '1', 'spr_breast_cancer_types','spr_breast_cancer_types');

CREATE TABLE IF NOT EXISTS `specimen_review_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `specimen_review_control_id` int(11) NOT NULL DEFAULT '0',
  `specimen_sample_type` varchar(30) NOT NULL,
  `review_type` varchar(100) NOT NULL,
  `collection_id` int(11) DEFAULT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `review_code` varchar(100) NOT NULL,  
  `review_date` date DEFAULT NULL,
  `review_status` varchar(20) DEFAULT NULL,
  `pathologist` varchar(50) DEFAULT NULL,
  `notes` text,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `specimen_review_masters`
  ADD CONSTRAINT `FK_specimen_review_masters_specimen_review_controls` FOREIGN KEY (`specimen_review_control_id`) REFERENCES `specimen_review_controls` (`id`);
ALTER TABLE `specimen_review_masters`
  ADD CONSTRAINT `FK_specimen_review_masters_collections` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`);
ALTER TABLE `specimen_review_masters`
  ADD CONSTRAINT `FK_specimen_review_masters_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);
  
CREATE TABLE IF NOT EXISTS `specimen_review_masters_revs` (
  `id` int(11) NOT NULL,
  
  `specimen_review_control_id` int(11) NOT NULL DEFAULT '0',
  `specimen_sample_type` varchar(30) NOT NULL,
  `review_type` varchar(100) NOT NULL,
  `collection_id` int(11) DEFAULT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `review_code` varchar(100) NOT NULL,  
  `review_date` date DEFAULT NULL,
  `review_status` varchar(20) DEFAULT NULL,
  `pathologist` varchar(50) DEFAULT NULL,
  `notes` text,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `spr_breast_cancer_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `specimen_review_master_id` int(11) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,  
  `other_type` varchar(250) DEFAULT NULL, 
  `tumour_grade_score_tubules` decimal(5,1) DEFAULT NULL,  
  `tumour_grade_score_nuclear` decimal(5,1) DEFAULT NULL,  
  `tumour_grade_score_mitosis` decimal(5,1) DEFAULT NULL,  
  `tumour_grade_score_total` decimal(5,1) DEFAULT NULL,  
  `tumour_grade_category` varchar(100) DEFAULT NULL,  
  
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `spr_breast_cancer_types`
  ADD CONSTRAINT `FK_spr_breast_cancer_types_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);
  
CREATE TABLE IF NOT EXISTS `spr_breast_cancer_types_revs` (
  `id` int(11) NOT NULL,
  
  `specimen_review_master_id` int(11) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,  
  `other_type` varchar(250) DEFAULT NULL, 
  `tumour_grade_score_tubules` decimal(5,1) DEFAULT NULL,  
  `tumour_grade_score_nuclear` decimal(5,1) DEFAULT NULL,  
  `tumour_grade_score_mitosis` decimal(5,1) DEFAULT NULL,  
  `tumour_grade_score_total` decimal(5,1) DEFAULT NULL,  
  `tumour_grade_category` varchar(100) DEFAULT NULL,   
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `aliquot_review_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `aliquot_review_control_id` int(11) NOT NULL DEFAULT '0',
  `specimen_review_master_id` int(11) DEFAULT NULL,
  `aliquot_masters_id` int(11) DEFAULT NULL,  
  `review_code` varchar(100) NOT NULL,
  `basis_of_specimen_review` tinyint(1) NOT NULL DEFAULT '0', 
  
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `aliquot_review_masters`
  ADD CONSTRAINT `FK_aliquot_review_masters_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);
ALTER TABLE `aliquot_review_masters`
  ADD CONSTRAINT `FK_aliquot_review_masters_aliquot_masters` FOREIGN KEY (`aliquot_masters_id`) REFERENCES `aliquot_masters` (`id`);
ALTER TABLE `aliquot_review_masters`
  ADD CONSTRAINT `FK_aliquot_review_masters_aliquot_review_controls` FOREIGN KEY (`aliquot_review_control_id`) REFERENCES `aliquot_review_controls` (`id`);
  
CREATE TABLE IF NOT EXISTS `aliquot_review_masters_revs` (
  `id` int(11) NOT NULL,
  
  `aliquot_review_control_id` int(11) NOT NULL DEFAULT '0',
  `specimen_review_master_id` int(11) DEFAULT NULL,
  `aliquot_masters_id` int(11) DEFAULT NULL,  
  `review_code` varchar(100) NOT NULL,
  `basis_of_specimen_review` tinyint(1) NOT NULL DEFAULT '0', 
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ar_breast_tissue_slides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `aliquot_review_master_id` int(11) DEFAULT NULL,
  `type` varchar(100) NOT NULL, 
  `length` decimal(5,1) DEFAULT NULL,
  `width` decimal(5,1) DEFAULT NULL,  
  `invasive_percentage` decimal(5,1) DEFAULT NULL,
  `in_situ_percentage` decimal(5,1) DEFAULT NULL,
  `normal_percentage` decimal(5,1) DEFAULT NULL,
  `stroma_percentage` decimal(5,1) DEFAULT NULL,
  `necrosis_inv_percentage` decimal(5,1) DEFAULT NULL,
  `necrosis_is_percentage` decimal(5,1) DEFAULT NULL,
  `inflammation` int(4) DEFAULT NULL,
  `quality_score` int(4) DEFAULT NULL,
  
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ar_breast_tissue_slides`
  ADD CONSTRAINT `FK_ar_breast_tissue_slides_aliquot_review_masters` FOREIGN KEY (`aliquot_review_master_id`) REFERENCES `aliquot_review_masters` (`id`);
  
CREATE TABLE IF NOT EXISTS `ar_breast_tissue_slides_revs` (
  `id` int(11) NOT NULL,
  
  `aliquot_review_master_id` int(11) DEFAULT NULL,
  `type` varchar(100) NOT NULL, 
  `length` decimal(5,1) DEFAULT NULL,
  `width` decimal(5,1) DEFAULT NULL,  
  `invasive_percentage` decimal(5,1) DEFAULT NULL,
  `in_situ_percentage` decimal(5,1) DEFAULT NULL,
  `normal_percentage` decimal(5,1) DEFAULT NULL,
  `stroma_percentage` decimal(5,1) DEFAULT NULL,
  `necrosis_inv_percentage` decimal(5,1) DEFAULT NULL,
  `necrosis_is_percentage` decimal(5,1) DEFAULT NULL,
  `inflammation` int(4) DEFAULT NULL,
  `quality_score` int(4) DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('inv_CAN_225', 'inv_CAN_21', 0, 5, 'specimen review', NULL, '/inventorymanagement/specimen_reviews/listAll/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%', '', 'Inventorymanagement.SampleMaster::specimenSummary', 1, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT IGNORE INTO i18n (id, en, fr)
VALUE ('specimen review', 'Path Review', 'Rapport d''histologie');

-- build spr_breast_cancer_types

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('specimen_review_status', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("in progress", "in progress");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="specimen_review_status"),  (SELECT id FROM structure_permissible_values WHERE value="in progress" AND language_alias="in progress"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("done", "done");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="specimen_review_status"),  (SELECT id FROM structure_permissible_values WHERE value="done" AND language_alias="done"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="specimen_review_status"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('breast_review_type', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("ductal", "ductal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="breast_review_type"),  (SELECT id FROM structure_permissible_values WHERE value="ductal" AND language_alias="ductal"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("lobular", "lobular");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="breast_review_type"),  (SELECT id FROM structure_permissible_values WHERE value="lobular" AND language_alias="lobular"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("d-l mix", "d-l mix");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="breast_review_type"),  (SELECT id FROM structure_permissible_values WHERE value="d-l mix" AND language_alias="d-l mix"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("tubular", "tubular");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="breast_review_type"),  (SELECT id FROM structure_permissible_values WHERE value="tubular" AND language_alias="tubular"), "4", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("mucinous", "mucinous");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="breast_review_type"),  (SELECT id FROM structure_permissible_values WHERE value="mucinous" AND language_alias="mucinous"), "5", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("dcis", "dcis");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="breast_review_type"),  (SELECT id FROM structure_permissible_values WHERE value="dcis" AND language_alias="dcis"), "6", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="breast_review_type"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "7", "1");

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('spr_breast_cancer_types', '', '', '1', '1', '0', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'SpecimenReviewMaster', 'specimen_review_masters', 'review_code', 'review code', '', 'input', 'size=30', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'SpecimenReviewMaster', 'specimen_review_masters', 'specimen_sample_type', 'specimen review type', '', 'input', 'size=30', '', (SELECT id FROM structure_value_domains WHERE domain_name='sample_type') , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'SpecimenReviewMaster', 'specimen_review_masters', 'review_type', '', '-', 'input', 'size=30', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'SpecimenReviewMaster', 'specimen_review_masters', 'review_date', 'review date', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'SpecimenReviewMaster', 'specimen_review_masters', 'review_status', 'review status', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'SpecimenReviewMaster', 'specimen_review_masters', 'pathologist', 'pathologist', '', 'input', 'size=30', '', (SELECT id FROM structure_value_domains WHERE domain_name=' NULL') , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'SpecimenReviewMaster', 'specimen_review_masters', 'notes', 'notes', '', 'textarea', 'cols=40,rows=6', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'type', 'type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='breast_review_type') , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'tumour_grade_score_tubules', 'tumour grade score tubules', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'tumour_grade_score_nuclear', 'tumour grade score nuclear', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'tumour_grade_score_mitosis', 'tumour grade score mitosis', '', 'float', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'tumour_grade_score_total', 'tumour grade score total', '', 'float', '', '',  NULL , '', 'open', 'open', 'open');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='spr_breast_cancer_types');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `language_label`='review code' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='specimen_sample_type' AND `language_label`='specimen review type' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `language_help`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_type' AND `language_label`='' AND `language_tag`='-' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_date' AND `language_label`='review date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `language_label`='review status' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status')  AND `language_help`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='pathologist' AND `language_label`='pathologist' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='cols=40,rows=6' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='type' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='breast_review_type')  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='tumour_grade_score_tubules' AND `language_label`='tumour grade score tubules' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='tumour_grade_score_nuclear' AND `language_label`='tumour grade score nuclear' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='tumour_grade_score_mitosis' AND `language_label`='tumour grade score mitosis' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='tumour_grade_score_total' AND `language_label`='tumour grade score total' AND `language_tag`='' AND `type`='float' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('specimen_review_masters', '', '', '1', '1', '0', '1');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='specimen_review_masters'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `language_label`='review code' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimen_review_masters'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='specimen_sample_type' AND `language_label`='specimen review type' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `language_help`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimen_review_masters'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_type' AND `language_label`='' AND `language_tag`='-' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimen_review_masters'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_date' AND `language_label`='review date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimen_review_masters'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `language_label`='review status' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status')  AND `language_help`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimen_review_masters'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='pathologist' AND `language_label`='pathologist' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimen_review_masters'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='cols=40,rows=6' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `language_label`='review code'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'specimen_type_for_review', 'open', '', 'Inventorymanagement.SpecimenReviewControl::getSpecimenTypePermissibleValues'),
(null, 'specimen_review_type', 'open', '', 'Inventorymanagement.SpecimenReviewControl::getReviewTypePermissibleValues');

UPDATE structure_fields
SET `type` = 'select', 
`setting` = '', 
`structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name = 'specimen_type_for_review')
WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='specimen_sample_type';

UPDATE structure_fields
SET `type` = 'select', `setting` = '', `structure_value_domain` = (SELECT id FROM structure_value_domains WHERE domain_name = 'specimen_review_type')
WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_type';

INSERT IGNORE INTO i18n (id, en, fr)
VALUE
('no path review exists for this type of sample', 'No path review exists for this type of sample!', 'Aucun rapport d''histologie n''est défini pour ce type d''échantillon!'),
('review code', 'Review Code', 'Code du Rapport'),
('specimen review type', 'Review Type', 'Type de rapport'),
('review date', 'Date', 'Date'),
('review status', 'Status', 'Statu'),
('pathologist', 'Pathologist', 'Pathologiste'),
('tumour grade score tubules', 'Tubules', 'Tubules'),
('tumour grade score nuclear', 'Nuclear', 'Nucléaire'),
('tumour grade score mitosis', 'Mitosis', 'Mitose'),
('d-l mix', 'D-L Mix', 'D-L Mix'),
('score', 'Score', 'Score'),
('category', 'Category', 'Catégorie'),
('tumour grade category', 'Category', 'Catégorie'),
('well diff', 'Well Diff', 'Bien différencié'),
('poor diff', 'Poor Diff', 'Peu différencié'),
('mod diff', 'Mod Diff', 'Modérément différencié'),
('in progress', 'In Progress', 'En cours'),
('tumour grade score total', 'Score total', 'Score total'),
('done', 'Done', 'Finalisé'),
('breast review', 'Breast Review', 'Rapport histologique du sein'),
('breast review (simple)', 'Breast Review (Simple)', 'Rapport histologique du sein (simple)');

UPDATE structure_formats
SET `flag_add` = '0', `flag_edit` = '0'
WHERE structure_id = (SELECT id FROM structures WHERE alias='spr_breast_cancer_types')
AND structure_field_id IN (SELECT id FROM structure_fields 
WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field` IN ('specimen_sample_type', 'review_type'));

UPDATE structure_formats
SET `language_heading` = 'type'
WHERE structure_id = (SELECT id FROM structures WHERE alias='spr_breast_cancer_types')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`  = 'type');

UPDATE structure_formats
SET `language_heading` = 'score'
WHERE structure_id = (SELECT id FROM structures WHERE alias='spr_breast_cancer_types')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`  = 'tumour_grade_score_tubules');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'ar_breast_tissue_slides', 'SpecimenReviewDetail', 'spr_breast_cancer_types', 'tumour_grade_category', 'tumour grade category', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='tumour_grade_category') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='spr_breast_cancer_types'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='spr_breast_cancer_types' AND `field`='tumour_grade_category' AND `language_label`='tumour grade category' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour_grade_category')  AND `language_help`=''), '1', '16', 'category', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1');

-- ar_breast_tissue_slides

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('ar_breast_tissue_slides', '', '', '1', '1', '0', '1');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ar_breast_tumor_type', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("tumor", "tumor");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ar_breast_tumor_type"),  (SELECT id FROM structure_permissible_values WHERE value="tumor" AND language_alias="tumor"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("normal", "normal");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ar_breast_tumor_type"),  (SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="normal"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="ar_breast_tumor_type"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "3", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('aliquots_list_for_review', '', '', 'Inventorymanagement.AliquotReviewMaster::getAliquotListForReview');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ar_breast_tissue_slides');
DELETE FROM structure_fields WHERE tablename IN ( 'aliquot_review_masters' , 'ar_breast_tissue_slides');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'AliquotReviewMaster', 'aliquot_review_masters', 'review_code', 'review code', '', 'input', 'size=30', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewMaster', 'aliquot_review_masters', 'basis_of_specimen_review', 'basis of specimen review', '', 'checkbox', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewDetail', 'ar_breast_tissue_slides', 'type', 'type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='ar_breast_tumor_type') , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewDetail', 'ar_breast_tissue_slides', 'length', 'length', '', 'float', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewDetail', 'ar_breast_tissue_slides', 'width', 'width', '', 'float', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewDetail', 'ar_breast_tissue_slides', 'invasive_percentage', 'invasive percentage', '', 'float', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewDetail', 'ar_breast_tissue_slides', 'in_situ_percentage', 'in situ percentage', '', 'float', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewDetail', 'ar_breast_tissue_slides', 'normal_percentage', 'normal percentage', '', 'float', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewDetail', 'ar_breast_tissue_slides', 'stroma_percentage', 'stroma percentage', '', 'float', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewDetail', 'ar_breast_tissue_slides', 'necrosis_inv_percentage', 'necrosis inv percentage', '', 'float', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewDetail', 'ar_breast_tissue_slides', 'necrosis_is_percentage', 'necrosis is percentage', '', 'float', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewDetail', 'ar_breast_tissue_slides', 'inflammation', 'inflammation review score', '', 'integer', 'size=3', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Inventorymanagement', 'AliquotReviewDetail', 'ar_breast_tissue_slides', 'quality_score', 'quality review score', '', 'integer', 'size=3', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'AliquotReviewMaster', 'aliquot_review_masters', 'aliquot_masters_id', 'reviewed aliquot', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='aliquots_list_for_review') , '', 'open', 'open', 'open');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ar_breast_tissue_slides');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code'), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='basis_of_specimen_review'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='type'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='length'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='width' ), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='invasive_percentage' ), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='in_situ_percentage' ), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='normal_percentage' ), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='stroma_percentage' ), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='necrosis_inv_percentage' ), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='necrosis_is_percentage' ), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='inflammation' ), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='ar_breast_tissue_slides' AND `field`='quality_score' ), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='aliquot_masters_id'), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

INSERT IGNORE INTO i18n (id, en, fr)
VALUE
('tumor', 'Tumor', 'Tumeur'),
('reviewed aliquot', 'Aliquot', 'Aliquot'),
('basis of specimen review', 'Used for Score', 'Utilisé pour le score'),
('length', 'Length', 'Long.'),
('width', 'Width', 'Larg.'),
('invasive percentage', 'INV%', 'INV%'),
('in situ percentage', 'IS%', 'IS%'),
('normal percentage', 'N%', 'N%'),
('stroma percentage', 'STR%', 'STR%'),
('necrosis inv percentage', 'Nec % INV', 'Nec % INV'),
('necrosis is percentage', 'Nec % IS', 'Nec % IS'),
('inflammation review score', 'Inf (0-3)', 'Inf (0-3)'),
('quality review score', 'QC (1-3)', 'QC (1-3)');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), 
(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl'), '0', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'AliquotReviewMaster', 'aliquot_review_masters', 'id', 'aliquot_review_master_id', '', 'input', 'size=5', '', NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ar_breast_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='id'), '0', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT IGNORE INTO i18n (id, en, fr)
VALUE
('aliquot_review_master_id', 'System Code', 'Code Système'),
('aliquot review', 'Aliquot Review', 'Analyse d''aliquot');

-- View structure

DROP VIEW IF EXISTS view_structures;
CREATE VIEW view_structures AS  
SELECT 
strct.alias,
field.plugin,
field.model,
field.tablename,
field.field,
domain.domain_name as structure_value_domain,

format.display_column, 
format.display_order, 

CONCAT(format.flag_add, CONCAT('|', format.flag_add_readonly)) AS 'add',
CONCAT(format.flag_edit, CONCAT('|', format.flag_edit_readonly)) AS 'edit', 
CONCAT(format.flag_search, CONCAT('|', format.flag_search_readonly)) AS 'search',
CONCAT(format.flag_datagrid, CONCAT('|', format.flag_datagrid_readonly)) AS 'datagrid',

format.flag_index as 'index', 
format.flag_detail AS 'detail', 


format.language_heading, 
field.language_label,
CONCAT(format.flag_override_label, '->', format.language_label) AS 'override_language_label',
field.language_tag,
CONCAT(format.flag_override_tag, '->', format.language_tag) AS 'override_tag',
field.type,
CONCAT(format.flag_override_type, '->', format.type) AS 'override_stype',
field.setting,
CONCAT(format.flag_override_setting, '->', format.setting) AS 'override_setting',
field.default,
CONCAT(format.flag_override_default,'->', format.default) AS 'override_default', 
field.language_help, 
CONCAT(format.flag_override_help, '->', format.language_help) AS 'override_help'

FROM structures AS strct
LEFT JOIN structure_formats AS format ON format.structure_id = strct.id
LEFT JOIN structure_fields AS field ON field.id = format.structure_field_id
LEFT JOIN structure_value_domains AS domain ON domain.id = field.structure_value_domain
ORDER BY strct.alias, format.display_column ASC, format.display_order ASC;


-- reset aliquot use fields position

UPDATE structures stc, structure_formats sfo, structure_fields sfi SET display_order = '5' 
WHERE stc.alias = 'aliquotuses' AND stc.id = sfo.structure_id
AND sfi.field = 'aliquot_volume_unit' AND sfo.structure_field_id = sfi.id;
UPDATE structures stc, structure_formats sfo, structure_fields sfi SET display_order = '4' 
WHERE stc.alias = 'aliquotuses' AND stc.id = sfo.structure_id
AND sfi.field = 'current_volume' AND sfo.structure_field_id = sfi.id;
UPDATE structures stc, structure_formats sfo, structure_fields sfi SET display_order = '6' 
WHERE stc.alias = 'aliquotuses' AND stc.id = sfo.structure_id
AND sfi.field = 'use_datetime' AND sfo.structure_field_id = sfi.id;
UPDATE structures stc, structure_formats sfo, structure_fields sfi SET display_order = '7' 
WHERE stc.alias = 'aliquotuses' AND stc.id = sfo.structure_id
AND sfi.field = 'used_by' AND sfo.structure_field_id = sfi.id;
UPDATE structures stc, structure_formats sfo, structure_fields sfi SET display_order = '10' 
WHERE stc.alias = 'aliquotuses' AND stc.id = sfo.structure_id
AND sfi.field = 'study_summary_id' AND sfo.structure_field_id = sfi.id;

-- Add reviewed aliquot to aliquot use table

ALTER TABLE `aliquot_review_masters`
  ADD `aliquot_use_id` int(11) DEFAULT NULL AFTER `aliquot_masters_id`;
ALTER TABLE `aliquot_review_masters_revs`
  ADD `aliquot_use_id` int(11) DEFAULT NULL AFTER `aliquot_masters_id`;
ALTER TABLE `aliquot_review_masters`
  ADD CONSTRAINT `FK_aliquot_review_masters_aliquot_uses` FOREIGN KEY (`aliquot_use_id`) REFERENCES `aliquot_uses` (`id`);
  

UPDATE `structure_fields` SET `setting`='size=4' WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field LIKE 'storage\_coord\__';

ALTER TABLE `users` CHANGE `active` `flag_active` boolean not null;

-- display current volume in aliquot use in edit form
  
UPDATE structures stc, structure_formats sfo, structure_fields sfi 
SET flag_edit = '1', flag_edit_readonly = '1'
WHERE stc.alias = 'aliquotuses' AND stc.id = sfo.structure_id
AND sfi.field = 'current_volume' AND sfo.structure_field_id = sfi.id;

-- reset aliquot use system dependent fields position

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotuses_system_dependent'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float' AND `structure_value_domain`  IS NULL  ), '0', '3', '', '1', '', '1', 'out of', '0', '', '0', '', '1', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0');

UPDATE structures stc, structure_formats sfo, structure_fields sfi SET display_order = '5' 
WHERE stc.alias = 'aliquotuses_system_dependent' AND stc.id = sfo.structure_id
AND sfi.field = 'aliquot_volume_unit' AND sfo.structure_field_id = sfi.id;
UPDATE structures stc, structure_formats sfo, structure_fields sfi SET display_order = '4' 
WHERE stc.alias = 'aliquotuses_system_dependent' AND stc.id = sfo.structure_id
AND sfi.field = 'current_volume' AND sfo.structure_field_id = sfi.id;
UPDATE structures stc, structure_formats sfo, structure_fields sfi SET display_order = '6' 
WHERE stc.alias = 'aliquotuses_system_dependent' AND stc.id = sfo.structure_id
AND sfi.field = 'use_datetime' AND sfo.structure_field_id = sfi.id;
UPDATE structures stc, structure_formats sfo, structure_fields sfi SET display_order = '7' 
WHERE stc.alias = 'aliquotuses_system_dependent' AND stc.id = sfo.structure_id
AND sfi.field = 'used_by' AND sfo.structure_field_id = sfi.id;
UPDATE structures stc, structure_formats sfo, structure_fields sfi SET display_order = '10' 
WHERE stc.alias = 'aliquotuses_system_dependent' AND stc.id = sfo.structure_id
AND sfi.field = 'study_summary_id' AND sfo.structure_field_id = sfi.id;

INSERT IGNORE INTO i18n (id, en, fr)
VALUE
('no volume has to be recorded for this aliquot type', 'No volume has to be recorded for this aliquot type!', 'Aucun volume doit être enregistré pour ce type d''aliquot!'),
('work directly on aliquot to change aliquot information (status, used volume, etc)', 
'Please work directly on aliquot to change aliquot information like ''status'', ''used volume'', etc (if required)!', 
'Veuillez travailler directement sur l''aliquot pour modifier des données de l''aliquot telles que le statu, le volume utilisée, etc (si requis)!');

UPDATE structures stc, structure_formats sfo, structure_fields sfi 
SET flag_index = '0'
WHERE stc.alias = 'ar_breast_tissue_slides' AND stc.id = sfo.structure_id
AND sfi.field = 'id' AND sfo.structure_field_id = sfi.id;

-- adding search form to aliquot uses
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotUse' AND tablename='aliquot_uses' AND field='use_definition' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_use_definition'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotUse' AND tablename='aliquot_uses' AND field='use_datetime' AND type='datetime' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotUse' AND tablename='aliquot_uses' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotUse' AND tablename='aliquot_uses' AND field='used_by' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotUse' AND tablename='aliquot_uses' AND field='used_volume' AND type='input' AND structure_value_domain  IS NULL );

-- adding search form to consents
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='consent_control_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='status_date' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='process_status' AND type='select' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='date_first_contact' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='form_version' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='consent_status' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status'));

-- adding search form to diagnosis
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='dx_date' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_icd10_code' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_number' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='dx_origin' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='origin'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='diagnosis_control_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type_list'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='morphology' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='morphology'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='dx_nature' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature'));

-- adding search form to treatment
UPDATE structure_fields SET  `language_label`='type',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list')  WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='disease_site' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='', `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='tx_method' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='tx_intent' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='intent'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='start_date' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='finish_date' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='protocol_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='target_site_icdo' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='', `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='TreatmentMaster' AND tablename='tx_masters' AND field='disease_site' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list'));

-- adding search form to family histories
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='FamilyHistory' AND tablename='family_histories' AND field='relation' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='relation'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='FamilyHistory' AND tablename='family_histories' AND field='family_domain' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='domain'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='FamilyHistory' AND tablename='family_histories' AND field='previous_primary_code' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='FamilyHistory' AND tablename='family_histories' AND field='previous_primary_code_system' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='FamilyHistory' AND tablename='family_histories' AND field='primary_icd10_code' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='FamilyHistory' AND tablename='family_histories' AND field='age_at_dx' AND type='number' AND structure_value_domain  IS NULL );

-- adding search form to participant messages
UPDATE structure_formats SET `flag_override_default`='0', `default`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantmessages') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ParticipantMessage' AND tablename='participant_messages' AND field='expiry_date' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantmessages') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ParticipantMessage' AND tablename='participant_messages' AND field='date_requested' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantmessages') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ParticipantMessage' AND tablename='participant_messages' AND field='due_date' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantmessages') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ParticipantMessage' AND tablename='participant_messages' AND field='message_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='message_type'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantmessages') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ParticipantMessage' AND tablename='participant_messages' AND field='title' AND type='input' AND structure_value_domain  IS NULL );

-- adding search form to quality controls
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_type'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='tool' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_qc_tool'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='run_id' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='score' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='unit' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_unit'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='conclusion' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='quality_control_conclusion'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='QualityCtrl' AND tablename='quality_ctrls' AND field='qc_code' AND type='input' AND structure_value_domain  IS NULL );

INSERT INTO datamart_structures (`id`, `plugin`, `model`, `structure_id`, `display_name`, `use_key`, `control_model`, `control_master_model`, `control_field`) VALUES
(7, 'Inventorymanagement', 'AliquotUse', (SELECT id FROM structures WHERE alias='aliquotuses'), 'aliquot uses', 'id', '', '', ''),
(8, 'Clinicalannotation', 'ConsentMaster', (SELECT id FROM structures WHERE alias='consent_masters'), 'consents', 'id', '', '', ''),
(9, 'Clinicalannotation', 'DiagnosisMaster', (SELECT id FROM structures WHERE alias='diagnosismasters'), 'diagnosis', 'id', '', '', ''),
(10, 'Clinicalannotation', 'TreatmentMaster', (SELECT id FROM structures WHERE alias='treatmentmasters'), 'treatments', 'id', '', '', ''),
(11, "Clinicalannotation", "FamilyHistory", (SELECT id FROM structures WHERE alias='familyhistories'), 'family histories' , 'id', '', '', ''),
(12, "Clinicalannotation", "ParticipantMessage", (SELECT id FROM structures WHERE alias='participantmessages'), 'participant messages', 'id', '', '', ''),
(13, 'Inventorymanagement', "QualityCtrl", (SELECT id FROM structures WHERE alias='qualityctrls'), 'quality controls', 'id', '', '', '');

INSERT INTO datamart_browsing_controls(`id1`, `id2`, `use_field`) VALUES
(7, 1, 'AliquotUse.aliquot_master_id'),
(8, 4, 'ConsentMaster.participant_id'),
(9, 4, 'DiagnosisMaster.participant_id'),
(10, 4, 'TreatmentMaster.participant_id'),
(11, 4, 'FamilyHistory.participant_id'),
(12, 4, 'ParticipantMessage.participant_id'),
(13, 5, 'QualityCtrl.sample_master_id');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
("aliquot uses", "Aliquot uses", "Utilisations d'aliquot"),
("consents", "Consents", "Consentements"),
("treatments", "Treatments", "Traitements"),
("family histories", "Family histories", "Historiques familiale"),
("participant messages", "Participant messages", "Messages des participants"),
("select an element to start browsing with", "Select an element to start browsing with", "Sélectionnez un élément sur lequel démarrer la naviguation"),
("enter search parameters", "Enter search parameters", "Entrez les critères de recherche"),
("browsing", "Browsing", "Navigation"),
("displaying search results", "Displaying search results", "Affichage des résultats de la recherche"),
("direct access", "Direct access", "Accès direct"),
("drilldown", "Drilldown", "Filtre"),
("that user is disabled", "That user is disabled", "Cet utilisateur est désactivé"),
('undo', 'Undo', 'annuler'),
("your session has expired", "Your session has expired", "Votre session est expirée"),
("that username is disabled", "That username is disabled", "Ce nom d'utilisateur est désactivé"),
("the query returned too many results", "The query returned too many results", "La requête a retourné trop de résultats"),
("try refining the search parameters", "Try refining the search parameters", "Essayer de raffiner les paramètres de recherche"),
("if you browse further ahead, all matches of the current set will be used", "If you browse further ahead, all matches of the current set will be used", "Si vous continuer de naviguer, toutes les résultats de l'ensemble présent seront utilisées");

-- user login audit trail
CREATE TABLE user_login_attempts(
`id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
`username` VARCHAR(50) NOT NULL DEFAULT '',
`ip_addr` VARCHAR(15) NOT NULL,
`succeed` BOOLEAN NOT NULL,
`attempt_time` TIMESTAMP NOT NULL DEFAULT NOW()
)Engine=InnoDb;

-- database sessions instead of php
CREATE TABLE cake_sessions (
  id varchar(255) NOT NULL default '',
  data text,
  expires int(11) default NULL,
  PRIMARY KEY  (id)
);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_information source', 'Defines the source of data for the current record.', ''),
('reports', 'Reports', ''),
('a date range is required', 'A date range is required.', ''),
('visualize', 'Visualize', ''),
('activity report index', 'Activity Report Index', ''),
('activity report index description', 'Below is a list of common reports banks may wish to run for informational and management purposes.', ''),
('report title', 'Report Title', ''),
('add new diagnosis', 'Add New Diagnosis', ''),
('identifier name', 'Identifier Name', ''),
('edit diagnosis record', 'Edit Diagnosis Record', ''),
('change diagnosis group', 'Change Diagnosis Group', ''),
('obtained consents', 'Obtained Consents', ''),
('consents by month', 'Consents by Month', ''),
('consents by month description', 'Returns a count of all consents captured over the date range specified grouped by month.', '');

UPDATE `i18n` SET `en` = 'Data Browser', `fr` = 'Navigateur de Données'
WHERE `id` = 'data browser';

UPDATE `structure_fields` SET `language_label` = 'title'
WHERE `structure_fields`.`tablename` = 'datamart_reports' AND `structure_fields`.`field` = 'name';

-- Profile help field updates
UPDATE `structure_fields` SET `language_help` = 'help_name_title' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participants' AND `field` = 'title';

UPDATE `structure_fields` SET `language_help` = 'help_first_name' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participants' AND `field` = 'first_name';

UPDATE `structure_fields` SET `language_help` = 'help_middle_name' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participants' AND `field` = 'middle_name';

UPDATE `structure_fields` SET `language_help` = 'help_last_name' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participants' AND `field` = 'last_name';

UPDATE `structure_fields` SET `language_help` = 'help_cod_icd10_code' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participants' AND `field` = 'cod_icd10_code';

UPDATE `structure_fields` SET `language_help` = 'help_secondary_cod_icd10_code' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participants' AND `field` = 'secondary_cod_icd10_code';

UPDATE `structure_fields` SET `language_help` = 'help_created' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participants' AND `field` = 'created';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_participant identifier', 'Unique alphanumeric identifier used to uniquely identify the participant within ATiM. May be adopted from another system, generated or assigned.', ''),
('help_name_title', 'An honorific form of address, commencing a name, used when addressing a person by name, whether by mail, by phone, or in person, as represented by text.', ''),
('help_first_name', 'The participant''s identifying name within the family group or by which the person is socially identified.', ''),
('help_middle_name', 'The middle name of the participant as listed on the patient record or report.', ''),
('help_last_name', 'That part of a name a person usually has in common with some other members of his/her family, as distinguished from his/her given names.', ''),
('help_date of birth', 'The date of birth of the participant.', ''),
('help_race', 'The participant''s self declared racial origination, independent of ethnic origination.', ''),
('help_sex', 'Sex is the biological distinction between male and female. Where there is an inconsistency between anatomical and chromosomal characteristics, sex is based on anatomical characteristics.', ''),
('help_marital status', 'A person''s current relationship status in terms of a couple relationship or, for those not in a couple relationship, the existence of a current or previous registered marriage.', ''),
('help_language preferred', 'The language (including sign language) most preferred by the person for communication.', ''),
('help_last chart checked', 'Date the participant''s chart (electronic or paper file) was last checked for new or updated clinical information.', ''),
('help_date of death', 'The date of death of the participant.', ''),
('help_cod_icd10_code', 'The disease or injury which initiated the train of morbid events leading directly to a person''s death or the circumstances of the accident or violence which produced the fatal injury, as represented by a code.', ''),
('help_secondary_cod_icd10_code', 'Any secondary disease, injury, circumstance of accident or violence which may have contributed to the person''s death as represented by a code.', ''),
('help_confirmation source', 'The person, organization or other reporting agency where the vital status information was obtained.', ''),
('help_created', 'Datetime stamp of when the record was first created in the system.', '');


-- Consent help field updates
UPDATE `structure_fields` SET `language_help` = 'help_consent_signed_date' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'consent_signed_date';

UPDATE `structure_fields` SET `language_help` = 'help_consent_method' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'consent_method';

UPDATE `structure_fields` SET `language_help` = 'help_consent_status' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'consent_status';

UPDATE `structure_fields` SET `language_help` = 'help_form_version' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'form_version';

UPDATE `structure_fields` SET `language_help` = 'help_status_date' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'status_date';

UPDATE `structure_fields` SET `language_help` = 'help_process_status' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'process_status';

UPDATE `structure_fields` SET `language_help` = 'help_reason_denied' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'reason_denied';

UPDATE `structure_fields` SET `language_help` = 'help_surgeon' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'surgeon';

UPDATE `structure_fields` SET `language_help` = 'help_notes' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'notes';

UPDATE `structure_fields` SET `language_help` = 'help_operation_date' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'operation_date';

UPDATE `structure_fields` SET `language_help` = 'help_route_of_referral' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'route_of_referral';

UPDATE `structure_fields` SET `language_help` = 'help_consent_person' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'consent_person';

UPDATE `structure_fields` SET `language_help` = 'help_translator_indicator' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'translator_indicator';

UPDATE `structure_fields` SET `language_help` = 'help_translator_signature' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'translator_signature';

UPDATE `structure_fields` SET `language_help` = 'help_date_first_contact' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'date_first_contact';

UPDATE `structure_fields` SET `language_help` = 'help_date_of_referral' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'date_of_referral';

UPDATE `structure_fields` SET `language_help` = 'help_facility' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'consent_masters' AND `field` = 'facility';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_consent_signed_date', 'Date on which the participant signed and authorized consent to participate in the banking program.', ''),
('help_consent_method', 'Method by which informed consent was obtained.', ''),
('help_consent_status', 'Indication of the participants status in the informed consent process.', ''),
('help_form_version', 'The version of the consent document in which the participant acknowledged participation by signing the document.', ''),
('help_status_date', 'Date on which the Consent Status field was last updated in the system.', ''),
('help_process_status', 'Current step of the consent process.', ''),
('help_reason_denied', 'Description of the reason(s) for participant denial or withdrawal of participation.', ''),
('help_surgeon', 'Name of the surgeon performing the surgery where materials for donation may be obtained.', ''),
('help_notes', 'Text summary information used to add other relevant information for the current record.', ''),
('help_operation_date', 'Date of the surgery being done of which materials for donation may be obtained.', ''),
('help_route_of_referral', 'Indicates the entity (agency, person, etc) which introduced the participant to the biobanking program.', ''),
('help_consent person', 'Name of biobank staff member leading the participant through the informed consent process.', ''),
('help_translator_indicator', 'Indicates whether a translator, legally acceptable representative or impartial witness was used.', ''),
('help_translator_signature', 'Indicates whether a signature was obtained from a translator, legally acceptable representative or impartial witness.', ''),
('help_date_of_referral', 'Date the participant was referred to the bio-banking program by the surgical office or self-referred.', ''),
('help_date_first_contact', 'Date on which the participant was approached to donate to the biobank.', ''),
('help_facility', 'Building or place that provides a particular service or is used for a particular industry.', '');

-- Fix case for diagnosis control values
UPDATE `diagnosis_controls` SET `controls_type` = 'tissue' 
WHERE `controls_type` = 'Tissue';

UPDATE `diagnosis_controls` SET `controls_type` = 'blood' 
WHERE `controls_type` = 'Blood';

-- Diagnosis help field updates

UPDATE `structure_fields` SET `public_identifier` = 'DE-91', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'ajcc_edition';

UPDATE `structure_fields` SET `public_identifier` = 'DE-89', `value_domain_control` = 'extend', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'dx_method';

UPDATE `structure_fields` SET `public_identifier` = 'DE-84', `value_domain_control` = 'extend', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'dx_nature';

UPDATE `structure_fields` SET `public_identifier` = 'DE-83', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'dx_date';

UPDATE `structure_fields` SET  `public_identifier` = 'DE-82', `value_domain_control` = 'extend', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'dx_origin';

UPDATE `structure_fields` SET `public_identifier` = 'DE-101', `field_control` = 'locked', `type` = 'integer_positive'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'survival_time_months';

UPDATE `structure_fields` SET `public_identifier` = 'DE-90', `type` = 'integer_positive', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'age_at_dx';

UPDATE `structure_fields` SET `public_identifier` = 'DE-88', `value_domain_control` = 'extend', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'tumour_grade';

UPDATE `structure_fields` SET `public_identifier` = 'DE-80', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'primary_number';

UPDATE `structure_fields` SET `public_identifier` = 'DE-95', `language_help` = 'help_clinical_stage_summary', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'clinical_stage_summary';

UPDATE `structure_fields` SET `public_identifier` = 'DE-102', `value_domain_control` = 'extend', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'dxd_tissues' AND `field` = 'laterality';

UPDATE `structure_fields` SET `public_identifier` = 'DE-87'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'previous_primary_code_system';

UPDATE `structure_fields` SET `public_identifier` = 'DE-86'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'previous_primary_code';

UPDATE `structure_fields` SET `public_identifier` = 'DE-4'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'dx_date_accuracy';

UPDATE `structure_fields` SET `public_identifier` = 'DE-81', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'dx_identifier';

UPDATE `structure_fields` SET `public_identifier` = 'DE-25' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'age_at_dx_accuracy';

UPDATE `structure_fields` SET `public_identifier` = 'DE-18' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'notes';

UPDATE `structure_fields` SET `public_identifier` = 'DE-129' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'information_source';

UPDATE `structure_fields` SET `public_identifier` = 'DE-85', `value_domain_control` = 'locked', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'primary_icd10_code';

UPDATE `structure_fields` SET `public_identifier` = 'DE-92', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'clinical_tstage';

UPDATE `structure_fields` SET `public_identifier` = 'DE-93', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'clinical_nstage';

UPDATE `structure_fields` SET `public_identifier` = 'DE-94', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'clinical_mstage';

UPDATE `structure_fields` SET `public_identifier` = 'DE-97', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'path_tstage';

UPDATE `structure_fields` SET `public_identifier` = 'DE-98', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'path_nstage';

UPDATE `structure_fields` SET `public_identifier` = 'DE-99', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'path_mstage';

UPDATE `structure_fields` SET `public_identifier` = 'DE-100', `language_help` = 'help_path_stage_summary', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'path_stage_summary';

UPDATE `structure_fields` SET `public_identifier` = 'DE-96', `value_domain_control` = 'extend', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'collaborative_staged';

UPDATE `structure_fields` SET `value_domain_control` = 'locked', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'morphology';

UPDATE `structure_fields` SET `value_domain_control` = 'locked', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'diagnosis_masters' AND `field` = 'topography';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_ajcc edition', 'Edition of the AJCC staging manual used to stage the tumour.', ''),
('help_dx method', 'Most definitive method by which the diagnosis of this tumour was established.', ''),
('help_dx nature', 'Indicates the nature of the disease coded in the registry abstract.', ''),
('help_dx date', 'The date on which a patient is diagnosed with a particular condition or disease by most definitive method of diagnosis.', ''),
('help_dx origin', 'Indicates whether the diagnosis is a primary, secondary (metastatic) or unknown tumour type.', ''),
('help_survival time', 'Length of time in months the participant has survived since the original date of diagnosis.', ''),
('help_age at dx', 'The individual''s age, in years, at the time of diagnosis.', ''),
('help_tumour grade', 'Code to represent the grade or differentiation of the tumour.', ''),
('help_primary number', 'A counter indicating the number of primary malignant tumours a patient has had that are known by the bank.', ''),
('dx_laterality', 'The side of the body in which the tumour is located in paired organs or skin sites.', ''),
('help_previous primary code system', 'Previous, or alternative, coding system used to represent the disease or condition.', ''),
('help_previous primary code', 'Code representing the disease or condition according to an older, or alternative, disease coding system.', ''),
('help_dx identifier', 'Unique identifier for each diagnosis in the system. Generated by the system at time of record creation.', ''),
('help_primary code', 'The disease or condition as represented by an ICD-10 code.', ''),
('help_path_stage_summary', 'The anatomical extent of disease by pathological classification based on the previously coded T, N and M stage categories, as represented by a code.', ''),
('help_collaborative staged', 'Indicates whether or not the tumour was staged using the Collaborative Staging System.', ''),
('help_morphology', 'Records the type of cell that has become neoplastic and its biologic activity using ICD-O-3 codes.', ''),
('help_topography', 'The topography code indicates the site of origin of a neoplasm.', ''),
('help_clinical_stage_summary', 'The anatomical extent of disease at diagnosis based on the previously coded T, N and M stage categories, as represented by a code.', '');

-- simple search form
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('simple_search', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', '', '0', '', 'term', 'search for', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='simple_search'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='term' AND `language_label`='search for' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0');

-- icd10 fr result
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('codingicd10_fr', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Codingicd10', 'CodingIcd10', 'coding_icd10', 'fr_title', 'title', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Codingicd10', 'CodingIcd10', 'coding_icd10', 'fr_sub_title', 'sub-title', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Codingicd10', 'CodingIcd10', 'coding_icd10', 'fr_description', 'description', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Codingicd10', 'CodingIcd10', 'coding_icd10', 'id', 'icd10 code', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='codingicd10_fr'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd10' AND `tablename`='coding_icd10' AND `field`='fr_title' AND `language_label`='title' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='codingicd10_fr'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd10' AND `tablename`='coding_icd10' AND `field`='fr_sub_title' AND `language_label`='sub-title' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='codingicd10_fr'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd10' AND `tablename`='coding_icd10' AND `field`='fr_description' AND `language_label`='description' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='codingicd10_fr'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd10' AND `tablename`='coding_icd10' AND `field`='id' AND `language_label`='icd10 code' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- icd10 en result
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('codingicd10_en', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Codingicd10', 'CodingIcd10', 'coding_icd10', 'en_title', 'title', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Codingicd10', 'CodingIcd10', 'coding_icd10', 'en_description', 'description', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Codingicd10', 'CodingIcd10', 'coding_icd10', 'en_sub_title', 'sub-title', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='codingicd10_en'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd10' AND `tablename`='coding_icd10' AND `field`='en_title' AND `language_label`='title' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='codingicd10_en'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd10' AND `tablename`='coding_icd10' AND `field`='en_description' AND `language_label`='description' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='codingicd10_en'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd10' AND `tablename`='coding_icd10' AND `field`='en_sub_title' AND `language_label`='sub-title' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='codingicd10_en'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd10' AND `tablename`='coding_icd10' AND `field`='id' AND `language_label`='icd10 code' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- participant icd10
UPDATE structure_fields SET  `type`='autocomplete',  `setting`='size=10,url=/codingicd/CodingIcd10s/autocomplete/who,tool=/codingicd/CodingIcd10s/tool/who',  `structure_value_domain`= NULL  WHERE model='Participant' AND tablename='participants' AND field='secondary_cod_icd10_code' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10');
UPDATE structure_fields SET  `type`='autocomplete',  `setting`='size=10,url=/codingicd/CodingIcd10s/autocomplete/who,tool=/codingicd/CodingIcd10s/tool/who',  `structure_value_domain`= NULL  WHERE model='Participant' AND tablename='participants' AND field='cod_icd10_code' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10');

-- dx icd10
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'primary_icd10_code', 'primary disease code', '', 'autocomplete', 'size=10,url=/codingicd/CodingIcd10s/autocomplete,tool=/codingicd/CodingIcd10s/tool/who', '',  NULL , 'help_primary code', 'open', 'open', 'open');
INSERT INTO structure_validations (`structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`) 
(SELECT (SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_icd10_code' AND `type`='autocomplete' AND structure_value_domain IS NULL ), `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message` FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_icd10_code' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10'))) ;
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code' AND `type`='autocomplete' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_icd10_code' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10'));

INSERT INTO structure_validations (`structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`) 
(SELECT (SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_icd10_code' AND `type`='autocomplete' AND structure_value_domain IS NULL ), `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message` FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_icd10_code' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10'))) ;
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code' AND `type`='autocomplete' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_icd10_code' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10'));

INSERT INTO structure_validations (`structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`) 
(SELECT (SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_icd10_code' AND `type`='autocomplete' AND structure_value_domain IS NULL ), `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message` FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_icd10_code' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10'))) ;
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code' AND `type`='autocomplete' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_icd10_code' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10'));

UPDATE structure_fields SET  `type`='autocomplete',  `structure_value_domain`= NULL, `setting`='size=10,url=/codingicd/CodingIcd10s/autocomplete/who,tool=/codingicd/CodingIcd10s/tool/who' WHERE model='FamilyHistory' AND tablename='family_histories' AND field='primary_icd10_code' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='icd10');

-- Help information update for Family History

UPDATE `structure_fields` SET `language_help` = 'help_relation', `value_domain_control` = 'extend', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'family_histories' AND `field` = 'relation';

UPDATE `structure_fields` SET `language_help` = 'help_family_domain', `value_domain_control` = 'extend', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'family_histories' AND `field` = 'family_domain';

UPDATE `structure_fields` SET `language_help` = 'help_previous_primary_code_system'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'family_histories' AND `field` = 'previous_primary_code_system';

UPDATE `structure_fields` SET `language_help` = 'help_previous_primary_code'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'family_histories' AND `field` = 'previous_primary_code';

UPDATE `structure_fields` SET `language_help` = 'help_primary_icd10_code', `value_domain_control` = 'locked', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'family_histories' AND `field` = 'primary_icd10_code';

UPDATE `structure_fields` SET `type` = 'integer_positive', `language_help` = 'help_age_at_dx', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'family_histories' AND `field` = 'age_at_dx';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_relation', 'Type of relationship to the participant.', ''),
('help_family_domain', 'Defines how the participant is related to the family member.', ''),
('help_previous_primary_code_system', 'The disease coding system used prior to, or instead of, ICD-10.', ''),
('help_previous_primary_code', 'The disease or condition code used prior to, or instead of, ICD-10.', ''),
('help_primary_icd10_code', 'The disease or condition as represented by an ICD-10 code.', ''),
('help_age_at_dx', 'Age at which the related family member''s condition or disease was diagnosised', '');

-- Help information update for Reproductive History

UPDATE `structure_fields` SET `public_identifier` = 'DE-26' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'date_captured';

UPDATE `structure_fields` SET `public_identifier` = 'DE-40', `type` = 'integer_positive', `field_control` = 'locked'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'gravida';

UPDATE `structure_fields` SET `public_identifier` = 'DE-39', `type` = 'integer_positive', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'para';

UPDATE `structure_fields` SET `public_identifier` = 'DE-35', `value_domain_control` = 'extend', `field_control` = 'locked'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'menopause_status';

UPDATE `structure_fields` SET `public_identifier` = 'DE-34', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'lnmp_date';

UPDATE `structure_fields` SET `public_identifier` = 'DE-27', `value_domain_control` = 'extend', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'ovary_removed_type';

UPDATE `structure_fields` SET `public_identifier` = 'DE-32', `value_domain_control` = 'locked', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'hysterectomy';

UPDATE `structure_fields` SET `public_identifier` = 'DE-37', `value_domain_control` = 'locked', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'hormonal_contraceptive_use';

UPDATE `structure_fields` SET `public_identifier` = 'DE-30', `value_domain_control` = 'locked', `field_control` = 'locked'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'hrt_use';

UPDATE `structure_fields` SET `public_identifier` = 'DE-38', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'years_on_hormonal_contraceptives';

UPDATE `structure_fields` SET `public_identifier` = 'DE-36', `value_domain_control` = 'extend', `field_control` = 'locked'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'menopause_onset_reason';

UPDATE `structure_fields` SET `public_identifier` = 'DE-31', `value_domain_control` = 'locked', `field_control` = 'locked'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'hrt_years_used';

UPDATE `structure_fields` SET `public_identifier` = 'DE-4'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'lnmp_accuracy';

UPDATE `structure_fields` SET `public_identifier` = 'DE-29', `type` = 'integer_positive', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'age_at_menopause';

UPDATE `structure_fields` SET `public_identifier` = 'DE-28', `type` = 'integer_positive', `field_control` = 'locked'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'age_at_menarche';

UPDATE `structure_fields` SET `public_identifier` = 'DE-33', `type` = 'integer_positive', `field_control` = 'locked'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'hysterectomy_age';

UPDATE `structure_fields` SET `public_identifier` = 'DE-41', `type` = 'integer_positive', `field_control` = 'locked'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'age_at_first_parturition';

UPDATE `structure_fields` SET `public_identifier` = 'DE-42', `type` = 'integer_positive', `field_control` = 'locked'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'age_at_last_parturition';

UPDATE `structure_fields` SET `public_identifier` = 'DE-25' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'menopause_age_accuracy';

UPDATE `structure_fields` SET `public_identifier` = 'DE-25'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'hysterectomy_age_accuracy';

UPDATE `structure_fields` SET `public_identifier` = 'DE-25'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'age_at_menarche_accuracy';

UPDATE `structure_fields` SET `public_identifier` = 'DE-25'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'first_parturition_accuracy';

UPDATE `structure_fields` SET `public_identifier` = 'DE-25'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'reproductive_histories' AND `field` = 'last_parturition_accuracy';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_date captured', 'Date the reproductive history was collected or updated from clinical information.', ''),
('help_gravida', 'The number of times where a female conceived and became pregnant regardless of outcome.', ''),
('help_para', 'The total number of previous pregnancies the female participant has had resulting in live birth.', ''),
('help_menopause status', 'The menopausal status of the participant.', ''),
('help_lmnp date', 'By a women''s recollection, the date she last had a menstrual period.', ''),
('help_ovary removed', 'Information related to the type of ovary that was removed.', ''),
('help_hysterectomy indicator', 'Indicators whether or not the participant had a hysterectomy.', ''),
('help_hormone replacement', 'Indicator to represent a person''s history of treatment with estrogens or estrogen/progesterone.', ''),
('help_hormonal contraceptive', 'Indicates whether the participant has used hormonal contraceptives in order to block ovulation and prevent the occurence of pregnancy.', ''),
('help_years on hormonal', 'Represents the cumulative number of years that hormonal contraceptives were used by the individual.', ''),
('help_menopause reason', 'Explanation of why menstral periods ceased.', ''),
('help_age at menopause', 'By a woman''s recollection, the age at the time of menopause expressed in number of years since birth.', ''),
('help_age at menarche', 'By a woman''s recollection, the age at the time of first menstrual period, expressed in number of years since birth.', ''),
('help_hysterectomy age', 'By a woman''s recollection, the age the hysterectomy was performed expressed in number of years since birth.', ''),
('help_age at first parturition', 'Age at completion of first fullterm pregnancy expressed in number of years since mother''s birth.', ''),
('help_age at last parturition', 'Age at completion of last fullterm pregnancy expressed in number of years since mother''s birth.', ''),
('help_hrt years used', 'The category in total years that a female has taken hormone replacements.', '');

-- Help information update for Treatment
UPDATE `structure_fields` SET `public_identifier` = 'DE-45', `language_help` = 'help_tx_intent', `value_domain_control` = 'extend', `field_control` = 'locked'   
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'tx_masters' AND `field` = 'tx_intent';

UPDATE `structure_fields` SET `public_identifier` = 'DE-43', `language_help` = 'help_tx_method', `value_domain_control` = 'extend', `field_control` = 'locked'    
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'tx_masters' AND `field` = 'tx_method';

UPDATE `structure_fields` SET `public_identifier` = 'DE-46', `language_help` = 'help_start_date', `field_control` = 'locked'   
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'tx_masters' AND `field` = 'start_date';

UPDATE `structure_fields` SET `public_identifier` = 'DE-47', `language_help` = 'help_finish_date', `field_control` = 'locked'   
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'tx_masters' AND `field` = 'finish_date';

UPDATE `structure_fields` SET `public_identifier` = 'DE-44', `language_help` = 'help_target_site_icdo', `value_domain_control` = 'locked', `field_control` = 'locked'   
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'tx_masters' AND `field` = 'target_site_icdo';

UPDATE `structure_fields` SET `public_identifier` = 'DE-48', `language_help` = 'help_facility'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'tx_masters' AND `field` = 'facility';

UPDATE `structure_fields` SET `public_identifier` = 'DE-18', `language_help` = 'help_notes'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'tx_masters' AND `field` = 'notes';

UPDATE `structure_fields` SET `public_identifier` = 'DE-129', `language_help` = 'help_information_source'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'tx_masters' AND `field` = 'information_source';

UPDATE `structure_fields` SET `public_identifier` = 'DE-4'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'tx_masters' AND `field` = 'start_date_accuracy';

UPDATE `structure_fields` SET `public_identifier` = 'DE-4'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'tx_masters' AND `field` = 'finish_date_accuracy';

UPDATE `structure_fields` SET `public_identifier` = 'DE-49', `language_help` = 'help_protocol_name', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'tx_masters' AND `field` = 'protocol_master_id';

UPDATE `structure_fields` SET `public_identifier` = 'DE-51', `language_help` = 'help_chemo_completed', `value_domain_control` = 'locked', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'txd_chemos' AND `field` = 'chemo_completed';

UPDATE `structure_fields` SET `public_identifier` = 'DE-50', `language_help` = 'help_response', `value_domain_control` = 'extend', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'txd_chemos' AND `field` = 'response';

UPDATE `structure_fields` SET `public_identifier` = 'DE-54', `type` = 'integer_positive', `setting` = 'size=5', `language_help` = 'help_completed_cycles', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'txd_chemos' AND `field` = 'completed_cycles';

UPDATE `structure_fields` SET `public_identifier` = 'DE-53', `type` = 'integer_positive', `setting` = 'size=5', `language_help` = 'help_num_cycles', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'txd_chemos' AND `field` = 'num_cycles';

UPDATE `structure_fields` SET `public_identifier` = 'DE-52', `type` = 'integer_positive', `setting` = 'size=5', `language_help` = 'help_length_cycles', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'txd_chemos' AND `field` = 'length_cycles';

UPDATE `structure_fields` SET `public_identifier` = 'DE-59', `language_help` = 'help_dose'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'txe_chemos' AND `field` = 'dose';

UPDATE `structure_fields` SET `public_identifier` = 'DE-58', `language_help` = 'help_method', `value_domain_control` = 'extend', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'txe_chemos' AND `field` = 'method';

UPDATE `structure_fields` SET `public_identifier` = 'DE-57', `language_help` = 'help_drug_id', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'txe_chemos' AND `field` = 'drug_id';

UPDATE `structure_fields` SET `public_identifier` = 'DE-60', `language_help` = 'help_path_num', `field_control` = 'locked'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'txd_surgeries' AND `field` = 'path_num';

UPDATE `structure_fields` SET `public_identifier` = 'DE-61', `language_help` = 'help_surgical_procedure' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'txe_surgeries' AND `field` = 'surgical_procedure';

UPDATE `structure_fields` SET `public_identifier` = 'DE-55', `language_help` = 'help_rad_completed', `value_domain_control` = 'locked', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'txd_radiations' AND `field` = 'rad_completed';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_tx_intent', 'The intention of the treatment for cancer for the particular participant.', ''),
('help_tx_method', 'The type of treatment given to the participant.', ''),
('help_finish_date', 'Date on which the treatment was completed or ceased for the participant.', ''),
('help_target_site_icdo', 'The site or region of cancer which is the target of a particular treatment, as represented by an ICDO-3 code.', ''),
('help_information_source', 'Defines the source of data for the current record.', ''),
('help_protocol_name', 'Name (or code) of treatment protocol that the participant was on.', ''),
('help_chemo_completed', 'Indicates whether the chemotherapy treatment plan was completed.', ''),
('help_response', 'The response of the tumour at the completion of the initial treatment modalities.', ''),
('help_completed_cycles', 'The total numeric count of chemotherapy cycles completed.', ''),
('help_num_cycles', 'The total numeric count of chemotherapy cycles ordered.', ''),
('help_length_cycles', 'The number of days in each chemotherapy cycle.', ''),
('help_dose', 'Prescribed amount of the therapeutic agent administered', ''),
('help_method', 'Primary method of administration for the prescribed therapeutic agent.', ''),
('help_drug_id', 'Generic name for the therapeutic agent administered.', ''),
('help_path_num', 'Alphanumeric indentifier corresponding to the pathology report generated from the participant''s surgery.', ''),
('help_surgical_procedure', 'Name or code of the surgical operation performed on the day of treatment.', ''),
('help_rad_completed', 'Indicates whether the radiotherapy treatment was completed.', ''),
('help_start_date', 'Date on which the treatment began for the participant.', '');

-- Contact form help updates
UPDATE `structure_fields` SET `public_identifier` = 'DE-103', `language_help` = 'help_contact_type', `field_control` = 'locked' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'contact_type';

UPDATE `structure_fields` SET `public_identifier` = 'DE-104'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'other_contact_type';

UPDATE `structure_fields` SET `public_identifier` = 'DE-109', `language_help` = 'help_region' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'region';

UPDATE `structure_fields` SET `public_identifier` = 'DE-105'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'effective_date';

UPDATE `structure_fields` SET `public_identifier` = 'DE-107', `language_help` = 'help_street'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'street';

UPDATE `structure_fields` SET `public_identifier` = 'DE-106' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'expiry_date';

UPDATE `structure_fields` SET `public_identifier` = 'DE-110', `language_help` = 'help_country'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'country';

UPDATE `structure_fields` SET `public_identifier` = 'DE-108', `language_help` = 'help_locality'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'locality';

UPDATE `structure_fields` SET `public_identifier` = 'DE-111', `language_help` = 'help_mail_code'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'mail_code';

UPDATE `structure_fields` SET `public_identifier` = 'DE-18', `language_help` = 'help_notes'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'notes';

UPDATE `structure_fields` SET `public_identifier` = 'DE-112', `language_help` = 'help_contact_name'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'contact_name';

UPDATE `structure_fields` SET `public_identifier` = 'DE-113', `language_help` = 'help_phone_type' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'phone_type';

UPDATE `structure_fields` SET `public_identifier` = 'DE-115', `language_help` = 'help_phone_secondary_type'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'phone_secondary_type';

UPDATE `structure_fields` SET `public_identifier` = 'DE-114', `language_help` = 'help_phone' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'phone';

UPDATE `structure_fields` SET `public_identifier` = 'DE-116', `language_help` = 'help_phone'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_contacts' AND `field` = 'phone_secondary';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_contact_type', 'Means through which a patient/participant or family is contacted for follow-up or survival information.', ''),
('clin_help_other contact type', 'Other means through which a patient/participant or family is contacted for follow-up or survival information.', ''),
('help_region', 'Any demarcated area of the earth; may be determined by both natural and human boundaries.', ''),
('help_effective date', 'Date the contact record became effective.', ''),
('help_street', 'Street address/post office box number/rural route number, group number.', ''),
('help_expiry date', 'The date of service contact between a health service provider and patient/client has ended', ''),
('help_country', 'Country in which the contact resides.', ''),
('help_locality', 'City in which the contact resides.', ''),
('help_mail_code', 'Postal code corresponding to the client''s address', ''),
('help_contact_name', 'The identifying label given to the contact.', ''),
('help_phone_type', 'Indicates the primary type of telephone contact number.', ''),
('help_phone_secondary_type', 'Indicates the type of additional telephone contact number.', ''),
('help_phone', 'A sequence of decimal digits (0-9) that is used for identifying a destination telephone line or other device in a telephone network from within the same city as the destination.', '');

-- Help info update for messages
UPDATE `structure_fields` SET `public_identifier` = 'DE-124', `language_help` = 'help_message_description'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_messages' AND `field` = 'description';

UPDATE `structure_fields` SET `public_identifier` = 'DE-125', `language_help` = 'help_message_due_date' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_messages' AND `field` = 'due_date';

UPDATE `structure_fields` SET `public_identifier` = 'DE-122', `language_help` = 'help_message_author' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_messages' AND `field` = 'author';

UPDATE `structure_fields` SET `public_identifier` = 'DE-128', `language_help` = 'help_message_type' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_messages' AND `field` = 'message_type';

UPDATE `structure_fields` SET `public_identifier` = 'DE-127', `language_help` = 'help_message_title'  
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_messages' AND `field` = 'title';

UPDATE `structure_fields` SET `public_identifier` = 'DE-126', `language_help` = 'help_message_expiry_date'
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_messages' AND `field` = 'expiry_date';

UPDATE `structure_fields` SET `public_identifier` = 'DE-123', `language_help` = 'help_message_date_requested' 
WHERE `plugin` = 'Clinicalannotation' AND `tablename` = 'participant_messages' AND `field` = 'date_requested';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_message_description', 'A summary of a short communication transmitted by words, signals, or other means from one person, station or group to another.', ''),
('help_message_expiry_date', 'The date when a message no longer applies; expires.', ''),
('help_message_date_requested', 'The date on which a document or digital message was created.', ''),
('help_message_due_date', 'The date on which a message or digital correspondence requests a response or an action completed.', ''),
('help_message_author', 'The author of document or digital message of correspondence.', ''),
('help_message_type', 'Category, if applicable, for the digital message of correspondence.', ''),
('help_message_title', 'The title of a short written, or electronic piece of communication.', '');

-- adding created field to aliquot uses search/index/detail
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'AliquotUse', 'aliquot_uses', 'created', 'created', '', 'datetime', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='aliquotuses'), (SELECT id FROM structure_fields WHERE `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1');

-- adding created field to view aliquots search/index
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'ViewAliquot', 'view_aliquots', 'created', 'created', '', 'datetime', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0');

-- update view_collection
DROP VIEW view_collections;
CREATE VIEW `view_collections` AS SELECT `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,
`link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` AS `consent_master_id`,
`part`.`participant_identifier` AS `participant_identifier`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` AS `collection_site`,
`col`.`collection_datetime` AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
`col`.`collection_property` AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,`col`.`deleted` AS `deleted`,`banks`.`name` AS `bank_name`,
`col`.`created` AS `created` 
FROM (((`collections` `col` left join `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) 
LEFT JOIN `participants` `part` ON(((`link`.`participant_id` = `part`.`id`) AND (`part`.`deleted` <> 1)))) 
LEFT JOIN `banks` ON(((`col`.`bank_id` = `banks`.`id`) AND (`banks`.`deleted` <> 1)))) 
WHERE (`col`.`deleted` <> 1);

-- added created field to view_collection search/index
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'ViewCollection', 'view_collections', 'created', 'created', '', 'datetime', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0');

-- adding created search/index/detail to all aliquots structures
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'created', 'created', '', 'datetime', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_validations (`structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`) 
(SELECT (SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='created' AND `type`='datetime' AND structure_value_domain IS NULL ), `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message` FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND `type`='input' AND structure_value_domain  IS NULL )) ;
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `type`='datetime' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_cores') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='input' AND structure_value_domain  IS NULL );

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_cell_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '79', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '77', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ad_spec_tiss_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ad_spec_tiss_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ad_spec_tubes '), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'),
((SELECT id FROM structures WHERE alias='ad_spec_whatman_papers'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1');

-- Fix issue 910 : Users table, field "active" problem 
UPDATE structure_fields 
SET  `field`='flag_active' WHERE model='User' AND tablename='users' AND field='active';

-- Help information for preferences form
UPDATE `structure_fields` SET `plugin` = 'Administrate', `language_help` = 'help_define_decimal_separator' 
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_decimal_separator';

UPDATE `structure_fields` SET `language_help` = 'help_define_show_help' 
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_show_help';

UPDATE `structure_fields` SET `language_help` = 'help_config_language' 
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'config_language';

UPDATE `structure_fields` SET `language_help` = 'help_define_date_format' 
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_date_format';

UPDATE `structure_fields` SET `language_help` = 'help_define_csv_separator' 
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_csv_separator';

UPDATE `structure_fields` SET `language_help` = 'help_define_show_summary' 
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_show_summary';

UPDATE `structure_fields` SET `language_help` = 'help_define_time_format' 
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_time_format';

UPDATE `structure_fields` SET `language_help` = 'help_define_datetime_input_type' 
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_datetime_input_type';

UPDATE `structure_fields` SET `language_help` = 'help_define_show_advanced_controls' 
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_show_advanced_controls';

UPDATE `structure_fields` SET `language_help` = 'help_define_pagination_amount' 
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_pagination_amount';

UPDATE `structure_fields` SET `language_help` = 'help_flag_active', `language_label` = 'account status' 
WHERE `model` = 'User' AND `tablename` = 'users' AND `field` = 'flag_active';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_define_decimal_separator', 'ATiM supports both period (.) and comma (,) for use as a decimal separator.', ''),
('help_define_time_format', 'Set to locked to disable the account. Changing this setting will not take effect until logout.', ''),
('help_flag_active', 'Setting this value will enable or disable the help information bubbles throughout the application.', ''),
('help_config_language', 'Select your preferred language for use within ATiM.', ''),
('help_define_date_format', 'Select your preferred date format for display and input. Note that all values will be saved to the database using the YYYY-MM-DD format regardless of your user preference.', ''),
('help_define_csv_separator', 'When exporting data to file from the Query Tool this value is used as a separator between fields.', ''),
('help_define_show_summary', 'Enable or disable the Summary tab found on the top right corner of the main window.', ''),
('help_define_time_format', 'Select a 12 hour or 24 hour clock for time display.', ''),
('help_define_datetime_input_type', 'Sets how date information is captured throughout the application. Selecting textual will allow direct input of date values where dropdown will force a select drop down list.', ''),
('help_define_show_advanced_controls', 'Toggles the advanced search options on all search forms. This includes the AND/OR options and toggles for exact matches vs pattern matching on text field searches.', ''),
('help_define_pagination_amount', 'Sets the number of results to display per page on index forms.', '');

-- Fix some case issues on field labels
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('time format', 'Time Format', 'Format de L''heure'),
('account status', 'Account Status', ''),
('decimal separator', 'Decimal Separator', 'Séparateur de Décimales'),
('datetime input type', 'Datetime Input Method', 'Foramat des Champs Dates et Heures'),
('show advanced controls', 'Show Advanced Controls', 'Afficher les Contrôles Avancés');

-- Update validations for preferences form
SELECT `id` FROM `structure_fields` WHERE `model` = '' AND `tablename` = '' AND `field` = '';

UPDATE `structure_validations` SET `language_message` = 'validation_req_define_show_help' 
WHERE `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_show_help');

UPDATE `structure_validations` SET `language_message` = 'validation_req_config_language' 
WHERE `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'config_language');

UPDATE `structure_validations` SET `language_message` = 'validation_req_flag_active' 
WHERE `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `model` = 'User' AND `tablename` = 'users' AND `field` = 'flag_active');

INSERT INTO `structure_validations` (`rule`, `flag_empty`, `flag_required`, `language_message`, `structure_field_id`)
VALUES ('notEmpty', 0, 0, 'validation_req_define_csv_separator', (SELECT `id` FROM `structure_fields` WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_csv_separator'));

INSERT INTO `structure_validations` (`rule`, `flag_empty`, `flag_required`, `language_message`, `structure_field_id`)
VALUES ('notEmpty', 0, 0, 'validation_req_define_date_format', (SELECT `id` FROM `structure_fields` WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_date_format'));

INSERT INTO `structure_validations` (`rule`, `flag_empty`, `flag_required`, `language_message`, `structure_field_id`)
VALUES ('notEmpty', 0, 0, 'validation_req_define_time_format', (SELECT `id` FROM `structure_fields` WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_time_format'));

INSERT INTO `structure_validations` (`rule`, `flag_empty`, `flag_required`, `language_message`, `structure_field_id`)
VALUES ('notEmpty', 0, 0, 'validation_req_define_pagination_amount', (SELECT `id` FROM `structure_fields` WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_pagination_amount'));

INSERT INTO `structure_validations` (`rule`, `flag_empty`, `flag_required`, `language_message`, `structure_field_id`)
VALUES ('notEmpty', 0, 0, 'validation_req_define_decimal_separator', (SELECT `id` FROM `structure_fields` WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_decimal_separator'));

INSERT INTO `structure_validations` (`rule`, `flag_empty`, `flag_required`, `language_message`, `structure_field_id`)
VALUES ('notEmpty', 0, 0, 'validation_req_define_datetime_input_type', (SELECT `id` FROM `structure_fields` WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_datetime_input_type'));

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('validation_req_define_show_help', 'The field CSV Separator is required!', ''),
('validation_req_config_language', 'The field Language is required!', ''),
('validation_req_flag_active', 'The field Account Status is required!', ''),
('validation_req_define_csv_separator', 'The field CSV Separator is required!', ''),
('validation_req_define_date_format', 'The field Date Format is required!', ''),
('validation_req_define_time_format', 'The field Time Format is required!', ''),
('validation_req_define_pagination_amount', 'The field Pagination is required!', ''),
('validation_req_define_decimal_separator', 'The field Decimal Separator is required!', ''),
('validation_req_define_datetime_input_type', 'The field Datetime Input Method is required!', '');

-- Fix value domain for checkbox fields on customize forms
UPDATE `structure_fields` SET `structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'yes_no_checkbox')
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_show_help';

UPDATE `structure_fields` SET `structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'yes_no_checkbox')
WHERE `model` = 'Config' AND `tablename` = 'configs' AND `field` = 'define_show_summary';

-- Delete structure_validations for float and integer field

UPDATE structure_fields field, structure_validations val
SET field.type = 'integer_positive'
WHERE (val.rule = 'custom,/^([0-9]+)$/' OR val.rule = 'custom,/^([0-9]+)?$/')
AND field.id = val.structure_field_id;

UPDATE structure_fields field, structure_validations val
SET field.type = 'float_positive'
WHERE val.rule LIKE  'custom,/^([0-9]+(\\\\.[0-9]+)?)?$/'
AND field.id = val.structure_field_id;

UPDATE structure_fields field, structure_validations val
SET field.type = 'float'
WHERE val.rule LIKE  'custom,/^([-]?[0-9]+(\\\\.[0-9]+)?)?$/'
AND field.id = val.structure_field_id;

UPDATE structure_fields SET setting = 'size=5'
WHERE type LIKE 'float%' OR type LIKE 'integer%';

DELETE FROM structure_validations WHERE rule LIKE 'custom,/^([0-9]+)$/' OR rule LIKE 'custom,/^([0-9]+)?$/' 
OR rule LIKE 'custom,/^([0-9]+(\\\\.[0-9]+)?)?$/' OR rule LIKE 'custom,/^([-]?[0-9]+(\\\\.[0-9]+)?)?$/';

-- Update field types to float for automatic validation

UPDATE `structure_fields` SET `type` = 'float', setting = 'size=5'
WHERE `model` = 'EventDetail' AND `tablename` = 'ed_all_clinical_presentation' AND `field` = 'weight';

UPDATE `structure_fields` SET `type` = 'float', setting = 'size=5'
WHERE `model` = 'EventDetail' AND `tablename` = 'ed_all_clinical_presentation' AND `field` = 'height';
 
-- Change orderline selection to add aliquot to order

INSERT IGNORE INTO `i18n` (`id`, `en`, `fr`) VALUES
('no order line to complete is actually defined', 'No order line to complete is actually defined!', 'Aucune ligne de commande à compléter n''est actuellement définie!'); 
 
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES ('order_lines_to_addAliquotsInBatch', '', '', '1', '1', '0', '1');

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias='order_lines_to_addAliquotsInBatch');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='order_lines_to_addAliquotsInBatch'), 
(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='order_number'), 
'0', '1', '', '1', 'order', '1', 'number', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='order_lines_to_addAliquotsInBatch'), 
(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='short_title'), 
'0', '2', '', '1', '', '1', 'title', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='order_lines_to_addAliquotsInBatch'), 
(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='date_order_placed'), 
'0', '3', '', '1', '', '1', 'order_date order placed', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 

((SELECT id FROM structures WHERE alias='order_lines_to_addAliquotsInBatch'), 
(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='sample_control_id'), 
'0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='order_lines_to_addAliquotsInBatch'), 
(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='aliquot_control_id'), 
'0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='order_lines_to_addAliquotsInBatch'), 
(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='sample_aliquot_precision'), 
'0', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),  
((SELECT id FROM structures WHERE alias='order_lines_to_addAliquotsInBatch'), 
(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='status'), 
'0', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
 
INSERT IGNORE INTO `i18n` (`id`, `en`, `fr`) VALUES
('aliquot storage data were deleted (if required)', 'Aliquot storage data were deleted (if required)!', 'Les données d''entreposage ont été supprimées (au besoin)!');

INSERT IGNORE INTO `i18n` (`id`, `en`, `fr`) VALUES
('an aliquot being not in stock can not be linked to a storage', 'An aliquot flagged ''Not in stock'' cannot also have storage location and label completed.', 'Un aliquot non en stock ne peut être attaché à un entreposage!');

INSERT IGNORE INTO `i18n` (`id`, `en`, `fr`) VALUES
('reload form', 'Reload Form', 'Ré-afficher le formulaire');

UPDATE structure_fields
SET language_label = 'number of elements'
WHERE field LIKE 'count_of_BatchId';

INSERT IGNORE INTO `i18n` (`id`, `en`, `fr`) VALUES
('number of elements', 'number of elements', 'Nombre d''éléments');

DELETE FROM `i18n` WHERE id IN ('account status','reports');
INSERT IGNORE INTO `i18n` (`id`, `en`, `fr`) VALUES
('reports', 'Reports', 'Rapports'),
('account status', 'Account Status', 'Statu du compte');

-- Add tranlsation to custom drop down list plus upgrade custom drop down list

UPDATE menus
SET language_title = 'custom dropdown list management', language_description = 'custom dropdown list management'
WHERE language_title = 'dropdowns' AND language_description = 'dropdowns';

INSERT IGNORE INTO i18n (id,en,fr)
VALUES ('custom dropdown list management', 'Dropdown List Configuration', 'Gestion des listes de valeurs');

ALTER TABLE structure_permissible_values_customs
	ADD `en` varchar(255) DEFAULT '' AFTER `value`,
	ADD `fr` varchar(255) DEFAULT '' AFTER `en`;

ALTER TABLE structure_permissible_values_customs_revs
	ADD `en` varchar(255) DEFAULT '' AFTER `value`,
	ADD `fr` varchar(255) DEFAULT '' AFTER `en`;

ALTER TABLE structure_permissible_values_custom_controls
	ADD `flag_active` tinyint(1) NOT NULL DEFAULT '1' AFTER `name`;
	
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) 
VALUES
('', 'Administrate', 'StructurePermissibleValuesCustom', 'structure_permissible_values_customs', 'en', 'english translation', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Administrate', 'StructurePermissibleValuesCustom', 'structure_permissible_values_customs', 'fr', 'french translation', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='administrate_dropdown_values'), 
(SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustom' AND `tablename`='structure_permissible_values_customs' AND `field`='en'),
'1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='administrate_dropdown_values'), 
(SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustom' AND `tablename`='structure_permissible_values_customs' AND `field`='fr'),
'1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '1', '0');

UPDATE structure_fields
SET language_label = 'value in database'
WHERE field LIKE 'value' AND model LIKE 'StructurePermissibleValuesCustom';

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE field LIKE 'value' AND model LIKE 'StructurePermissibleValuesCustom'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);

INSERT IGNORE INTO `i18n` (`id`, `en`, `fr`) VALUES
('value in database', 'Value in Database', 'Valeur en base de données'),    	     	  
('english translation', 'English Translation', 'Traduction anglaise'), 
('french translation', 'French Translation', 'Traduction française'),
("you are about to remove element(s) from the batch set", "You are about to remove element(s) from the batch set", "Vous êtes sur le point de retirer des éléments du groupe de données"),
("selection label updated", "Selection label updated", "Label de sélection mis à jour"),
("the aliquot with barcode [%s] has reached a volume bellow 0", "The aliquot with barcode [%s] has reached a volume bellow 0.", "L'aliquot avec le code barre [%s] a atteint un volume inférieur à 0."),
("the batch set contains %d entries but only %d are returned by the query", "The batch set contains %d entries but only %d are returned by the query", "L'ensemble de données contient %d entrées mais seulement %d sont retournées par la requête");

INSERT IGNORE INTO `i18n` (`id`, `en`, `fr`) VALUES
('a specified value already exists for that dropdown', 'A specified value already exists for that dropdown!', 'Une valeur existe déjà pour cette liste!');

UPDATE structure_formats
SET `flag_edit` = '1', `flag_edit_readonly` = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='administrate_dropdown_values')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='StructurePermissibleValuesCustom' AND `tablename`='structure_permissible_values_customs' AND `field`='value');

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `use_link`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('err_admin_record_err', 1, 'data creation - update error', 'an error occurred during the creation or the update of the data', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

ALTER TABLE `structure_permissible_values_custom_controls` ADD UNIQUE (`name`);

DELETE FROM `structure_value_domains_permissible_values` WHERE 	structure_value_domain_id IN (
	SELECT id FROM  `structure_value_domains` 
	WHERE domain_name IN ('custom_laboratory_qc_tool', 'custom_collection_site', 'custom_laboratory_staff', 'custom_specimen_supplier_dept', 'custom_laboratory_site')
);

UPDATE structure_permissible_values_custom_controls SET name = 'laboratory staff' WHERE name = 'staff';
UPDATE structure_permissible_values_custom_controls SET name = 'laboratory sites' WHERE name = 'laboratory sites';
UPDATE structure_permissible_values_custom_controls SET name = 'specimen collection sites' WHERE name = 'collection sites';
UPDATE structure_permissible_values_custom_controls SET name = 'specimen supplier departments' WHERE name = 'specimen supplier departments';
UPDATE structure_permissible_values_custom_controls SET name = 'quality control tools' WHERE name = 'tools';

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('quality control tools')" WHERE source = 'StructurePermissibleValuesCustom::getDropdownQcTools';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('specimen collection sites')" WHERE source = 'StructurePermissibleValuesCustom::getDropdownCollectionSites';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('laboratory staff')" WHERE source = 'StructurePermissibleValuesCustom::getDropdownStaff';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('specimen supplier departments')" WHERE source = 'StructurePermissibleValuesCustom::getDropdownSpecimenSupplierDepartments';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('laboratory sites')" WHERE source = 'StructurePermissibleValuesCustom::getDropdownLaboratorySites';

-- moving topography before morphology in dx
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='topography' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='topography' AND type='input' AND structure_value_domain  IS NULL );
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'topography', 'topography', '', 'autocomplete', 'size=10,url=/codingicd/CodingIcdo3s/autocomplete/topo,tool=/codingicd/CodingIcdo3s/tool/topo', '',  NULL , 'help_topography', 'open', 'open', 'open');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `type`='autocomplete' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='topography' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=10,url=/codingicd/CodingIcdo3s/autocomplete/topo,tool=/codingicd/CodingIcdo3s/tool/topo' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='topography' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `type`='autocomplete' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='topography' AND type='input' AND structure_value_domain  IS NULL );


INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('codingicd_en', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Codingicd', 'CodingIcd', '', 'id', 'id', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Codingicd', 'CodingIcd', '', 'en_title', 'title', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Codingicd', 'CodingIcd', '', 'en_sub_title', 'sub-title', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Codingicd', 'CodingIcd', '', 'en_description', 'description', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='codingicd_en'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd' AND `tablename`='' AND `field`='id' AND `language_label`='id' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='codingicd_en'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd' AND `tablename`='' AND `field`='en_title' AND `language_label`='title' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='codingicd_en'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd' AND `tablename`='' AND `field`='en_sub_title' AND `language_label`='sub-title' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='codingicd_en'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd' AND `tablename`='' AND `field`='en_description' AND `language_label`='description' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('codingicd_fr', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Codingicd', 'CodingIcd', '', 'fr_title', 'title', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Codingicd', 'CodingIcd', '', 'fr_sub_title', 'sub-title', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Codingicd', 'CodingIcd', '', 'fr_description', 'description', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='codingicd_fr'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd' AND `tablename`='' AND `field`='id' AND `language_label`='id' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='codingicd_fr'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd' AND `tablename`='' AND `field`='fr_title' AND `language_label`='title' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='codingicd_fr'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd' AND `tablename`='' AND `field`='fr_sub_title' AND `language_label`='sub-title' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='codingicd_fr'), (SELECT id FROM structure_fields WHERE `model`='CodingIcd' AND `tablename`='' AND `field`='fr_description' AND `language_label`='description' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `flag_override_setting`='0', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='topography' AND type='autocomplete' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=10,tool=/codingicd/CodingIcd10s/tool/who' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='primary_icd10_code' AND type='input' AND structure_value_domain  IS NULL );

UPDATE structure_fields SET  `type`='autocomplete',  `setting`='size=10,tool=/codingicd/CodingIcd10s/tool/who,url=/codingicd/CodingIcd10s/autocomplete/who' WHERE model='FamilyHistory' AND tablename='family_histories' AND field='primary_icd10_code' AND `type`='input' AND structure_value_domain  IS NULL ;

-- validateIcd10CodeWho as default rule for icd10 fields
UPDATE structure_validations SET rule='validateIcd10WhoCode' WHERE rule='validateIcd10Code';

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'morphology', 'morphology', '', 'autocomplete', 'size=10,url=/codingicd/CodingIcdo3s/autocomplete/morpho,tool=/codingicd/CodingIcdo3s/tool/morpho', '', (SELECT id FROM structure_value_domains WHERE domain_name='morphology') , 'help_morphology', 'open', 'open', 'open');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='autocomplete' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='morphology') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='morphology' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='morphology'));
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='autocomplete' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='morphology') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='morphology' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='morphology'));

-- Add batch set title

ALTER TABLE datamart_batch_sets
	ADD `title` varchar(50) NOT NULL DEFAULT 'unknown' AFTER `group_id`,
	CHANGE `description` `description` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL;

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Datamart', 'BatchSet', 'datamart_batch_sets', 'title', 'title', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE field LIKE 'title' AND model LIKE 'BatchSet'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='querytool_batch_set'), 
(SELECT id FROM structure_fields WHERE field LIKE 'title' AND model LIKE 'BatchSet'), 
'1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'); 
UPDATE structure_formats SET display_order = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='querytool_batch_set')
AND structure_field_id = (SELECT id FROM structure_fields WHERE field LIKE 'model' AND model LIKE 'BatchSet');

delete from i18n where id = 'share set with group';
INSERT IGNORE INTO i18n (`id`, `en`, `fr`) VALUES ('share set with group', 'Share Set With Group', 'Ensembles de données accessible au groupe');
update i18n set en = 'Number of Elements' where id = 'number of elements';

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Datamart', 'BatchSet', 'datamart_batch_sets', 'created', 'created', '', 'adtetime', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='querytool_batch_set'), 
(SELECT id FROM structure_fields WHERE field LIKE 'created' AND model LIKE 'BatchSet'), 
'1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'); 

UPDATE structure_formats SET flag_index = '0'
WHERE structure_id = (SELECT id FROM structures WHERE alias='querytool_batch_set')
AND structure_field_id = (SELECT id FROM structure_fields WHERE field LIKE 'description' AND model LIKE 'BatchSet');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='querytool_adhoc_to_batchset'), 
(SELECT id FROM structure_fields WHERE field LIKE 'title' AND model LIKE 'BatchSet'), 
'1', '2', '', '1', 'new batchset title', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1'); 

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE field LIKE 'id' AND model LIKE 'BatchSet'), 'notEmpty', '0', '0', '', 'value is required', '0000-00-00 00:00:00', 0, '2010-02-12 00:00:00', 0);


INSERT IGNORE INTO i18n (`id`, `en`, `fr`) 
VALUES 
('new batchset title', 'New Batchset Title', 'Titre du nouvel ensembles de données'),
('remove as favourite', 'Remove As Favourite', 'Supprimer des favoris'),
('back to search', 'Back to Search', 'Réafficher Recherche'),
('query information', 'Query Data', 'Données de la requête'),
('batchset information', 'Batchset Data', 'Ensemble de données - Information'),
('queries list', 'Queries List', 'List des requêtes');

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `use_link`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('err_datamart_system_error', 1, 'system error', 'a system error has been detected', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'morphology', 'morphology', '', 'autocomplete', 'size=10,url=/codingicd/CodingIcdo3s/autocomplete/morpho,tool=/codingicd/CodingIcdo3s/tool/morpho', '',  NULL , 'help_morphology', 'open', 'open', 'open');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='autocomplete' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='morphology' AND type='autocomplete' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='morphology'));
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='autocomplete' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='morphology' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='morphology'));

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='autocomplete' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='morphology' AND type='autocomplete' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='morphology'));
-- Delete obsolete structure fields
DELETE FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='morphology' AND `type`='autocomplete' AND structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='morphology');
DELETE FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='topography' AND `type`='autocomplete' AND structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='morphology');

-- validations for icdo3
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`) VALUES
((SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL LIMIT 1), 'validateIcdo3TopoCode', '1', '0', '', 'invalid topography code'),
((SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL LIMIT 1), 'validateIcdo3MorphoCode', '1', '0', '', 'invalid morphology code');

INSERT IGNORE INTO i18n (`id`, `en`, `fr`) VALUES ('elements', 'Elements', 'Éléments'), ('actions', 'Actions', 'Actions'), ('result', 'Result', 'Résultat');

UPDATE structure_formats SET flag_detail = '1', flag_index = '1', display_order = '9'
WHERE structure_id = (SELECT id FROM structures WHERE alias='querytool_batch_set')
AND structure_field_id = (SELECT id FROM structure_fields WHERE field LIKE 'share_set_with_group' AND model LIKE 'BatchSet');

ALTER TABLE datamart_batch_sets
	ADD `share_set_with_group` varchar(5) NOT NULL DEFAULT 'no' AFTER `group_id`;
	
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'users_list', 'open', '', 'User::getUsersList');	
INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'Datamart', 'BatchSet', 'datamart_batch_sets', 'created_by', 'created by', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'users_list'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='querytool_batch_set'), 
(SELECT id FROM structure_fields WHERE field LIKE 'created_by' AND model LIKE 'BatchSet'), 
'1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '1', '1'); 

INSERT IGNORE INTO i18n (`id`, `en`, `fr`) VALUES 
('all batch sets', 'All Batchsets', 'Tous les ensembles de données'),
('delete in batch', 'Delete Batchsets', 'Suppression en groupe');

-- Allow form version field to use any characters instead of floats only.
ALTER TABLE `rtbforms` CHANGE `frmVersion` `frmVersion` VARCHAR( 255 ) DEFAULT NULL;
ALTER TABLE `rtbforms_revs` CHANGE `frmVersion` `frmVersion` VARCHAR( 255 ) DEFAULT NULL; 

INSERT IGNORE INTO i18n (`id`, `en`, `fr`) VALUES
('protocol is defined as protocol of at least one participant treatment', 'Unable to delete - This protocol is linked to existing treatment records.', 'Le protocole est définie comme étant le protocole d''au moins un traitement de participant!'),
('error_fk_participant_linked_collection', 'Unable to delete - Linked collection record exists for this participant', ''),
('error_fk_participant_linked_consent', 'Unable to delete - Linked consent record exists for this participant', ''),
('error_fk_participant_linked_diagnosis', 'Unable to delete - Linked diagnosis record exists for this participant', ''),
('error_fk_participant_linked_treatment', 'Unable to delete - Linked treatment record exists for this participant', ''),
('error_fk_participant_linked_familyhistory', 'Unable to delete - Linked family history exists for this participant', ''),
('error_fk_participant_linked_reproductive', 'Unable to delete - Linked reproductive history record exists for this participant', ''),
('error_fk_participant_linked_contacts', 'Unable to delete - Linked contact record exists for this participant', ''),
('error_fk_participant_linked_identifiers', 'Unable to delete - Linked identifier record exists for this participant', ''),
('error_fk_participant_linked_messages', 'Unable to delete - Linked message record exists for this participant', ''),
('error_fk_participant_linked_events', 'Unable to delete - Linked annotation event record exists for this participant', '');

ALTER TABLE `tx_masters`
  DROP FOREIGN KEY `FK_tx_masters_tx_controls` ;
ALTER TABLE tx_masters
  	CHANGE `treatment_control_id` `tx_control_id` int(11) NOT NULL DEFAULT '0';
ALTER TABLE tx_masters  	
	ADD CONSTRAINT `FK_tx_masters_tx_controls` FOREIGN KEY (`tx_control_id`) REFERENCES `tx_controls` (`id`);
ALTER TABLE tx_masters_revs
  	CHANGE `treatment_control_id` `tx_control_id` int(11) NOT NULL DEFAULT '0';  

ALTER TABLE aliquot_controls
 ADD COLUMN databrowser_label VARCHAR(50) NOT NULL DEFAULT '';
UPDATE aliquot_controls SET databrowser_label=comment;

ALTER TABLE sample_controls
 ADD COLUMN databrowser_label VARCHAR(50) NOT NULL DEFAULT '';
UPDATE sample_controls SET databrowser_label=sample_type;

ALTER TABLE storage_controls
 ADD COLUMN databrowser_label VARCHAR(50) NOT NULL DEFAULT '';
UPDATE storage_controls SET databrowser_label=storage_type;

DROP TABLE coding_icdo_3;

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'morphology', 'morphology', '', 'input', '', '',  NULL , 'help_morphology', 'open', 'open', 'open');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='input' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='morphology' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='morphology'));

INSERT IGNORE INTO i18n (`id`, `en`, `fr`) VALUES
('only sample core can be stored into tma block','Only sample core can be stored into tma block!', 'Seules les cores d''échantillons peuvent être entreposés dans des blocs de TMA!'),
('you can find help about permissions %s', "You can find help about permissions <a href='%s' target='blank'>here</a>", "Vous pouvez trouver de l'aider sur les permissions <a href='%s' target='blank'>ici</a>");

CREATE TABLE external_links(
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
link text,
UNIQUE(`name`)
)Engine=InnoDb;

INSERT INTO external_links (name, link) VALUES
('permissions_help', 'http://www.ctrnet.ca/mediawiki/index.php/Permissions_configuration');

-- Set structure_formats.flag_search = '1' for all forms used into the databrowser

UPDATE aliquot_controls SET databrowser_label = aliquot_type;

-- ad_spec_whatman_papers
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_spec_whatman_papers')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
);

-- ad_der_cel_gel_matrices
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
  OR (field IN ('cell_count_unit', 'cell_count') AND model LIKE 'AliquotDetail')
);

-- ad_der_cell_slides
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_der_cell_slides')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
  OR (field IN ('immunochemistry') AND model LIKE 'AliquotDetail')
);

-- ad_der_tubes_incl_ml_vol
SET @first_id = (SELECT id FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('created') AND model LIKE 'AliquotMaster')
) LIMIT 0,1);
DELETE FROM structure_formats WHERE  id = @first_id;
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
  OR (field IN ('current_volume') AND model LIKE 'AliquotMaster')
);

-- ad_spec_tubes
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_spec_tubes')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
);

-- ad_spec_tubes_incl_ml_vol
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
  OR (field IN ('current_volume') AND model LIKE 'AliquotMaster')
);

-- ad_spec_tiss_blocks
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
  OR (field IN ('block_type') AND model LIKE 'AliquotDetail')
);

-- ad_spec_tiss_slides
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_spec_tiss_slides')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
  OR (field IN ('immunochemistry') AND model LIKE 'AliquotDetail')
);

-- ad_der_tubes_incl_ul_vol_and_conc
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
  OR (field IN ('current_volume') AND model LIKE 'AliquotMaster')
  OR (field IN ('concentration', 'concentration_unit') AND model LIKE 'AliquotDetail')
);

-- ad_spec_tiss_cores
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_spec_tiss_cores')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
);

-- ad_der_cell_cores
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_der_cell_cores')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'created' AND model LIKE 'AliquotMaster');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_cell_cores'), 
(SELECT id FROM structure_fields WHERE field LIKE 'created' AND model LIKE 'AliquotMaster'), 
'1', '77', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '1', '1'); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_cell_cores'), 
(SELECT id FROM structure_fields WHERE field LIKE 'barcode' AND model LIKE 'AliquotMaster' AND type = 'input'), 
'0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '1', '0', '1', '0', '1', '1'); 
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_der_cell_cores')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
);

-- ad_der_cell_tubes_incl_ml_vol
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('barcode', 'in_stock', 'in_stock_detail', 'storage_datetime', 'study_summary_id', 'created') AND model LIKE 'AliquotMaster') 
  OR (field IN ('temp_unit', 'temperature', 'code', 'selection_label') AND model LIKE 'StorageMaster')
  OR (field IN ('current_volume') AND model LIKE 'AliquotMaster')
  OR (field IN ('concentration', 'concentration_unit', 'cell_count', 'cell_count_unit') AND model LIKE 'AliquotDetail')
);

UPDATE datamart_structures SET control_model = '', control_master_model = '', control_field = '' WHERE plugin = 'Storagelayout' AND model = 'StorageMaster';

-- 	sd_spe_ascites
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_spe_ascites')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code') AND model LIKE 'SampleMaster') 
  OR (field IN ('supplier_dept', 'reception_by', 'reception_datetime') AND model LIKE 'SpecimenDetail')
);

-- 	sd_spe_bloods
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_spe_bloods')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code') AND model LIKE 'SampleMaster') 
  OR (field IN ('supplier_dept', 'reception_by', 'reception_datetime') AND model LIKE 'SpecimenDetail')
  OR (field IN ('blood_type') AND model LIKE 'SampleDetail')
);

-- 	sd_spe_cystic_fluids
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_spe_cystic_fluids')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code') AND model LIKE 'SampleMaster') 
  OR (field IN ('supplier_dept', 'reception_by', 'reception_datetime') AND model LIKE 'SpecimenDetail')
);

-- 	sd_spe_peritoneal_washes
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_spe_peritoneal_washes')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code') AND model LIKE 'SampleMaster') 
  OR (field IN ('supplier_dept', 'reception_by', 'reception_datetime') AND model LIKE 'SpecimenDetail')
);

-- 	sd_spe_pericardial_fluids
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_spe_pericardial_fluids')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code') AND model LIKE 'SampleMaster') 
  OR (field IN ('supplier_dept', 'reception_by', 'reception_datetime') AND model LIKE 'SpecimenDetail')
);

-- 	sd_spe_pleural_fluids
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_spe_pleural_fluids')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code') AND model LIKE 'SampleMaster') 
  OR (field IN ('supplier_dept', 'reception_by', 'reception_datetime') AND model LIKE 'SpecimenDetail')
);

-- 	sd_spe_tissues
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_spe_tissues')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code') AND model LIKE 'SampleMaster') 
  OR (field IN ('supplier_dept', 'reception_by', 'reception_datetime') AND model LIKE 'SpecimenDetail')
  OR (field IN ('tissue_source', 'tissue_laterality', 'pathology_reception_datetime') AND model LIKE 'SampleDetail')
);

-- 	sd_spe_urines
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_spe_urines')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code') AND model LIKE 'SampleMaster') 
  OR (field IN ('supplier_dept', 'reception_by', 'reception_datetime') AND model LIKE 'SpecimenDetail')
  OR (field IN ('urine_aspect', 'pellet_signs') AND model LIKE 'SampleDetail')
);

-- 	sd_der_cell_cultures
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_der_cell_cultures')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code', 'initial_specimen_sample_type') AND model LIKE 'SampleMaster') 
  OR (field IN ('creation_datetime', 'creation_by', 'creation_site') AND model LIKE 'DerivativeDetail')
  OR (field IN ('culture_status', 'cell_passage_number') AND model LIKE 'SampleDetail')
);

-- 	sd_der_plasmas
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_der_plasmas')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code', 'initial_specimen_sample_type') AND model LIKE 'SampleMaster') 
  OR (field IN ('creation_datetime', 'creation_by', 'creation_site') AND model LIKE 'DerivativeDetail')
  OR (field IN ('hemolysis_signs') AND model LIKE 'SampleDetail')
);

-- 	sd_der_serums
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_der_serums')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code', 'initial_specimen_sample_type') AND model LIKE 'SampleMaster') 
  OR (field IN ('creation_datetime', 'creation_by', 'creation_site') AND model LIKE 'DerivativeDetail')
  OR (field IN ('hemolysis_signs') AND model LIKE 'SampleDetail')
);

-- 	sd_undetailed_derivatives
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='sd_undetailed_derivatives')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('sample_code', 'initial_specimen_sample_type') AND model LIKE 'SampleMaster') 
  OR (field IN ('creation_datetime', 'creation_by', 'creation_site') AND model LIKE 'DerivativeDetail')
);

UPDATE datamart_structures SET control_model = 'TreatmentControl', control_master_model = 'TreatmentMaster', control_field = 'tx_control_id' WHERE plugin = 'Clinicalannotation' AND model = 'TreatmentMaster';
ALTER TABLE `tx_controls`
  ADD `databrowser_label` varchar(50) NOT NULL DEFAULT '' AFTER `extended_data_import_process`;
UPDATE tx_controls SET databrowser_label = CONCAT(disease_site,'|',tx_method);

-- txd_chemos
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='txd_chemos')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('tx_intent', 'target_site_icdo', 'protocol_master_id', 'start_date') AND model LIKE 'TreatmentMaster') 
  OR (field IN ('chemo_completed', 'response', 'num_cycles', 'length_cycles', 'completed_cycles') AND model LIKE 'TreatmentDetail')
);
UPDATE structure_formats SET flag_index = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='txd_chemos')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('tx_method', 'tx_intent', 'target_site_icdo', 'protocol_master_id', 'start_date') AND model LIKE 'TreatmentMaster') 
  OR (field IN ('chemo_completed', 'response', 'num_cycles', 'length_cycles', 'completed_cycles') AND model LIKE 'TreatmentDetail')
);

-- txd_radiations
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='txd_radiations')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('tx_intent', 'target_site_icdo', 'protocol_master_id', 'start_date') AND model LIKE 'TreatmentMaster') 
  OR (field IN ('rad_completed') AND model LIKE 'TreatmentDetail')
);
UPDATE structure_formats SET flag_index = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='txd_radiations')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('tx_method', 'tx_intent', 'target_site_icdo', 'protocol_master_id', 'start_date') AND model LIKE 'TreatmentMaster') 
  OR (field IN ('rad_completed') AND model LIKE 'TreatmentDetail')
);

-- txd_surgeries
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='txd_surgeries')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('tx_intent', 'target_site_icdo', 'protocol_master_id', 'start_date') AND model LIKE 'TreatmentMaster') 
  OR (field IN ('path_num') AND model LIKE 'TreatmentDetail')
);
UPDATE structure_formats SET flag_index = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='txd_surgeries')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('tx_method', 'tx_intent', 'target_site_icdo', 'protocol_master_id', 'start_date') AND model LIKE 'TreatmentMaster') 
  OR (field IN ('path_num') AND model LIKE 'TreatmentDetail')
); 

UPDATE datamart_structures SET control_model = 'ConsentControl', control_master_model = 'ConsentMaster', control_field = 'consent_control_id' WHERE plugin = 'Clinicalannotation' AND model = 'ConsentMaster';
ALTER TABLE `consent_controls`
  ADD `databrowser_label` varchar(50) NOT NULL DEFAULT '' AFTER `display_order`;
UPDATE consent_controls SET databrowser_label = controls_type;

-- cd_nationals
UPDATE structure_formats SET flag_search = '1',  flag_index = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='cd_nationals')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('date_first_contact', 'form_version', 'consent_status', 'status_date', 'consent_signed_date') AND model LIKE 'ConsentMaster')
);

UPDATE datamart_structures SET control_model = 'DiagnosisControl', control_master_model = 'DiagnosisMaster', control_field = 'diagnosis_control_id' WHERE plugin = 'Clinicalannotation' AND model = 'DiagnosisMaster';
ALTER TABLE `diagnosis_controls`
  ADD `databrowser_label` varchar(50) NOT NULL DEFAULT '' AFTER `display_order`;
UPDATE diagnosis_controls SET databrowser_label = controls_type;

-- dx_bloods
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='dx_bloods')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('dx_origin', 'dx_date', 'dx_nature', 'tumour_grade', 'primary_icd10_code', 'topography', 'morphology') AND model LIKE 'DiagnosisMaster')
);
-- dx_tissues
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='dx_tissues')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('dx_origin', 'dx_date', 'dx_nature', 'tumour_grade', 'primary_icd10_code', 'topography', 'morphology') AND model LIKE 'DiagnosisMaster')
);

-- fixe issue 1108

UPDATE structure_value_domains SET source = 'Storagelayout.StorageControl::getStorageTypePermissibleValues' WHERE source = 'StorageLayout.StorageControl::getStorageTypePermissibleValues';
UPDATE structure_value_domains SET source = 'Storagelayout.StorageMaster::getParentStoragePermissibleValues' WHERE source = 'StorageLayout.StorageMaster::getParentStoragePermissibleValues';

-- Add  event into databrowser

INSERT INTO `datamart_structures` 
(`id`, `plugin`, `model`, `structure_id`, `display_name`, `use_key`, `control_model`, `control_master_model`, `control_field`) 
VALUES
(null, 'Clinicalannotation', 'EventMaster', (SELECT id FROM structures WHERE alias = 'eventmasters'), 'annotation', 'id', 'EventControl', 'EventMaster', 'event_control_id');
ALTER TABLE `event_controls`
  ADD `databrowser_label` varchar(50) NOT NULL DEFAULT '' AFTER `display_order`;
UPDATE event_controls SET databrowser_label = concat(event_group,'|',disease_site,'|',event_type);

INSERT INTO datamart_browsing_controls (id1, id2, flag_active_1_to_2 ,flag_active_2_to_1, use_field)
VALUES
((SELECT id FROM datamart_structures WHERE model = 'EventMaster'), (SELECT id FROM datamart_structures WHERE model = 'Participant'), '1', '1', 'EventMaster.participant_id');

UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='eventmasters')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('event_date', 'disease_site', 'event_type') AND model LIKE 'EventMaster')
);

-- 	ed_breast_lab_pathology

UPDATE structure_formats SET flag_search = '1',flag_index = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_breast_lab_pathology')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('event_date') AND model LIKE 'EventMaster') 
  OR (field IN ('tumour_type', 'grade', 'multifocal', 'vascular_lymph_invasion', 'extra_nodal_invasion', 'level_nodal_involvement') AND model LIKE 'EventDetail')
); 

-- 	ed_all_lifestyle_smoking
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('smoking_status', 'pack_years') AND model LIKE 'EventDetail')
); 
UPDATE structure_formats SET flag_index = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_all_lifestyle_smoking')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('event_date') AND model LIKE 'EventMaster') 
  OR (field IN ('smoking_status', 'pack_years') AND model LIKE 'EventDetail')
); 

-- 	ed_all_clinical_followup
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_all_clinical_followup')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('vital_status') AND model LIKE 'EventDetail')
); 
UPDATE structure_formats SET flag_index = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_all_clinical_followup')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('event_date') AND model LIKE 'EventMaster') 
  OR (field IN ('vital_status') AND model LIKE 'EventDetail')
); 

-- 	ed_all_clinical_presentation
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_all_clinical_presentation')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('weight', 'height') AND model LIKE 'EventDetail')
); 
UPDATE structure_formats SET flag_index = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_all_clinical_presentation')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('event_date') AND model LIKE 'EventMaster') 
  OR (field IN ('weight','height') AND model LIKE 'EventDetail')
); 

-- 	ed_breast_screening_mammogram
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_breast_screening_mammogram')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('result') AND model LIKE 'EventDetail')
); 
UPDATE structure_formats SET flag_index = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_breast_screening_mammogram')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('event_date') AND model LIKE 'EventMaster') 
  OR (field IN ('result') AND model LIKE 'EventDetail')
); 

-- 	ed_all_study_research
UPDATE structure_formats SET flag_search = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_all_study_research')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('field_one') AND model LIKE 'EventDetail')
); 
UPDATE structure_formats SET flag_index = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='ed_all_study_research')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('event_date') AND model LIKE 'EventMaster') 
  OR (field IN ('field_one') AND model LIKE 'EventDetail')
); 

-- Add  specimen review into databrowser

INSERT INTO `datamart_structures` 
(`id`, `plugin`, `model`, `structure_id`, `display_name`, `use_key`, `control_model`, `control_master_model`, `control_field`) 
VALUES
(null, 'Inventorymanagement', 'SpecimenReviewMaster', (SELECT id FROM structures WHERE alias = 'specimen_review_masters'), 'specimen review', 'id', 'SpecimenReviewControl', 'SpecimenReviewMaster', 'specimen_review_control_id ');
ALTER TABLE `specimen_review_controls`
  ADD `databrowser_label` varchar(50) NOT NULL DEFAULT '' AFTER `detail_tablename`;
UPDATE specimen_review_controls SET databrowser_label = concat(specimen_sample_type,'|',review_type);
INSERT INTO datamart_browsing_controls (id1, id2, flag_active_1_to_2 ,flag_active_2_to_1, use_field)
VALUES
((SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster'), (SELECT id FROM datamart_structures WHERE model = 'ViewSample'), '1', '1', 'SpecimenReviewMaster.sample_master_id');

UPDATE structure_formats SET flag_search = '0'
WHERE structure_id = (SELECT id FROM structures WHERE alias='spr_breast_cancer_types')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('notes','review_type','specimen_sample_type') AND model LIKE 'SpecimenReviewMaster')
); 
UPDATE structure_formats SET flag_index = '1'
WHERE structure_id = (SELECT id FROM structures WHERE alias='spr_breast_cancer_types'); 
UPDATE structure_formats SET flag_index = '0'
WHERE structure_id = (SELECT id FROM structures WHERE alias='spr_breast_cancer_types')
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE (field IN ('notes','review_type','specimen_sample_type') AND model LIKE 'SpecimenReviewMaster')
); 

-- ALTER TABLE 

ALTER TABLE `datamart_adhoc`
  ADD `title` varchar(50) NOT NULL DEFAULT '' AFTER `id`;
UPDATE datamart_adhoc set title = concat('adhoc_',id);
ALTER TABLE `datamart_adhoc`
  ADD UNIQUE(`title`);

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Datamart', 'Adhoc', 'datamart_adhoc', 'title', 'title', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='querytool_adhoc'), 
(SELECT id FROM structure_fields WHERE `model`='Adhoc' AND `tablename`='datamart_adhoc' AND `field`='title'), 
'1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '1');

-- Report upgrade

DROP TABLE IF EXISTS datamart_reports_revs;
ALTER TABLE datamart_reports
  ADD `form_alias_for_search` varchar(255) DEFAULT NULL AFTER `description`,
  ADD `form_alias_for_results` varchar(255) DEFAULT NULL AFTER `form_alias_for_search`,
  ADD `form_type_for_results` enum('detail','index') NOT NULL AFTER `form_alias_for_results`,
  ADD `flag_active` tinyint(1) NOT NULL DEFAULT '1' AFTER `function`,
  DROP FOREIGN KEY `datamart_reports_ibfk_1`,
  DROP COLUMN `datamart_structure_id`,
  DROP COLUMN `serialized_representation`;

DELETE FROM `datamart_reports`;
INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, 'bank activity report', 'number of new participants created, consents obtained and participants having samples collected', 'report_date_range_definition', 'bank_activty_report', 'detail', 'bankActiviySummary', '0000-00-00 00:00:00', 0, NULL, 0),
(null, 'specimens collection/derivatives creation', 'n/a', 'report_datetime_range_definition', 'specimen_and_derivative_creation_summary', 'index', 'sampleAndDerivativeCreationSummary', '0000-00-00 00:00:00', 0, NULL, 0),
(null, 'bank activity report (per period)', 'number of new participants created, consents obtained and participants having samples collected', 'report_date_range_and_period_definition', 'bank_activty_report', 'detail', 'bankActiviySummaryPerPeriod', '0000-00-00 00:00:00', 0, NULL, 0);

INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) 
VALUES 
('report_date_range_definition', '', '', '1', '1', '1', '1'),
('report_datetime_range_definition', '', '', '1', '1', '1', '1'),
('bank_activty_report', '', '', '1', '1', '1', '1'),
('specimen_and_derivative_creation_summary', '', '', '1', '1', '1', '1'),
('report_date_range_and_period_definition', '', '', '1', '1', '1', '1');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("year", "year"),("month", "month");
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('date_range_period', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="date_range_period"),  
(SELECT id FROM structure_permissible_values WHERE value="year" AND language_alias="year"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="date_range_period"),  
(SELECT id FROM structure_permissible_values WHERE value="month" AND language_alias="month"), "1", "1");

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) 
VALUES 
('', 'Datamart', '0', '', 'report_date_range', 'date range', '', 'date', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Datamart', '0', '', 'report_datetime_range', 'date range', '', 'datetime', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Datamart', '0', '', 'new_participants_nbr', 'created participants', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Datamart', '0', '', 'obtained_consents_nbr', 'obtained consents', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Datamart', '0', '', 'new_collections_nbr', 'participants having collected samples', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Datamart', '0', '', 'created_samples_nbr', 'number of new samples', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Datamart', '0', '', 'matching_participant_number', 'matching participant number', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'),
('', 'Datamart', '0', '', 'report_date_range_period', 'date range period', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name = 'date_range_period') , '', 'open', 'open', 'open');
 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='report_date_range_definition'), 
(SELECT id FROM structure_fields WHERE field LIKE 'report_date_range' AND model LIKE '0'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='report_datetime_range_definition'), 
(SELECT id FROM structure_fields WHERE field LIKE 'report_datetime_range' AND model LIKE '0'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
 ((SELECT id FROM structures WHERE alias='bank_activty_report'), 
(SELECT id FROM structure_fields WHERE field LIKE 'new_participants_nbr' AND model LIKE '0'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='bank_activty_report'), 
(SELECT id FROM structure_fields WHERE field LIKE 'obtained_consents_nbr' AND model LIKE '0'), 
'0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'),
((SELECT id FROM structures WHERE alias='bank_activty_report'), 
(SELECT id FROM structure_fields WHERE field LIKE 'new_collections_nbr' AND model LIKE '0'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='specimen_and_derivative_creation_summary'), 
(SELECT id FROM structure_fields WHERE field LIKE 'sample_category' AND model LIKE 'SampleMaster'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='specimen_and_derivative_creation_summary'), 
(SELECT id FROM structure_fields WHERE field LIKE 'sample_type' AND model LIKE 'SampleMaster'), 
'0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='specimen_and_derivative_creation_summary'), 
(SELECT id FROM structure_fields WHERE field LIKE 'created_samples_nbr' AND plugin LIKE 'Datamart'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='specimen_and_derivative_creation_summary'), 
(SELECT id FROM structure_fields WHERE field LIKE 'matching_participant_number' AND plugin LIKE 'Datamart'), 
'0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='report_date_range_and_period_definition'), 
(SELECT id FROM structure_fields WHERE field LIKE 'report_date_range' AND model LIKE '0'), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='report_date_range_and_period_definition'), 
(SELECT id FROM structure_fields WHERE field LIKE 'report_date_range_period' AND model LIKE '0'), 
'0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'); 
 
INSERT IGNORE into i18n (id, en, fr) VALUES
('bank activity report', 'Bank Activity Report', 'Rapport d''activité'),
('bank activity report (per period)', 'Bank Activity Report (Per Period)', 'Rapport d''activité (Par période)'),
('date range period', 'Period', 'Période'),
('no perido has been defined','No perido has been defined!','Aucune période n''a été définie!'),
('number of new participants created, consents obtained and participants having samples collected', 
'Number of created participants, obtained consents and participants having samples collected.', 
'Nombre de participants créés, de consentements obtenus et d participants dont les échantillons ont été collectés.'),
('created participants', 'Created Participants', 'Participants créés'),
('number of report columns will be too big, please redefine parameters', 'The number of report columns will be too big, please redefine parameters!', 'Le nombre de colonnes de votre rapport est trop important, redéfinissez les valeurs de recherche!'),
('obtained consents', 'Obtained Consents', 'Consentements Obtenus'),
('date range', 'Date Range', 'Intervalle de dates'),
('participants having collected samples', 'Participants Having Collected Samples', 'Participants ayant échantillons collectés'),
('specimens collection/derivatives creation', 'Specimens Collection/Derivatives Creation', 'Collections des spécimens/Creations de dérivés'),
('number of new samples', 'Number of New Samples', 'Nombre de nouveaux échantillons'),
('matching participant number', 'Matching Participant Number', 'Nombre de participants correspondants');

UPDATE menus SET use_summary = 'Datamart.Report::summary' WHERE id = 'qry-CAN-1-2';

INSERT IGNORE into i18n (id, en, fr) VALUES
('adverse_events','Adverse Events','Effets indésirables'),
('followup', 'Follow-Up','Suivi'),
('adverse_event','Adverse Event','Effet indésirable');
 
UPDATE structure_fields SET plugin = 'Inventorymanagement' WHERE model = 'SpecimenReviewDetail' AND field = 'tumour_grade_category' AND plugin = 'ar_breast_tissue_slides';

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qry_diagnosis_results', 'qry_diagnosis_search', 'tma_slide_content_search'));
DELETE FROM structures WHERE alias IN ('qry_diagnosis_results', 'qry_diagnosis_search', 'tma_slide_content_search');

UPDATE structure_formats SET structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' AND field = 'primary_icd10_code' AND type = 'autocomplete')
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'clinicalcollectionlinks')
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' AND field = 'primary_icd10_code' AND type = 'select');

DELETE FROM structure_validations WHERE structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' AND field = 'primary_icd10_code' AND type = 'select');
DELETE FROM structure_fields WHERE tablename = 'diagnosis_masters' AND field = 'primary_icd10_code' AND type = 'select';

UPDATE structure_formats 
SET structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' AND field = 'morphology' AND type = 'autocomplete')
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'clinicalcollectionlinks')
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' AND field = 'morphology' AND type = 'input');

UPDATE structure_formats 
SET structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' AND field = 'topography' AND type = 'autocomplete')
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'diagnosismasters')
AND structure_field_id = (SELECT id FROM structure_fields WHERE tablename = 'diagnosis_masters' AND field = 'topography' AND type = 'input');

DELETE FROM structure_fields WHERE tablename = 'diagnosis_masters' AND field IN ('topography', 'morphology') AND type IN ('select', 'input');

INSERT IGNORE into i18n (id, en, fr) VALUES 
('obtained consents', 'Obtained Consents', 'Consentement obtenu'),

('add new diagnosis', 'Add New Diagnosis', 'Ajouter un nouveau diagnostic'),
('search for','Search For', 'Rechercher'),
('back', 'Back', 'Recommencer'),

('icdo3 morphology code picker', 'ICD-O-3 Morphology Code Picker', 'Sélection code morphologique ICD-O-3'),
('search for an icdo3 morphology code', 'Search For An ICD-O-3 Morphology Code', 'Rechercher code morphologique ICD-O-3'),
('select an icdo3 morphology code', 'Select An ICD-O-3 Morphology Code', 'Sélectionner code morphologique ICD-O-3'),

('icdo3 topography code picker', 'ICD-O-3 Topography Code Picker', 'Sélection code topographique ICD-O-3'),
('search for an icdo3 topography code', 'Search For An ICD-O-3 Topography Code', 'Rechercher code topographique ICD-O-3'),
('select an icdo3 topography code', 'Select An ICD-O-3 Topography Code', 'Sélectionner code topographique ICD-O-3'),

('icd10 code picker', 'ICD-10 Code Picker', 'Sélection code ICD-10'),
('search for an icd10 code', 'Search For An ICD-10 Code', 'Rechercher code ICD-10'),
('select an icd10 code', 'Select An ICD-10 Code', 'Sélectionner code  ICD-10'),

('sub-title', 'Sub-Title', 'Sous-titre');

UPDATE structure_fields SET language_label = 'code' WHERE model LIKE 'CodingIcd%' AND field LIKE 'id';

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `type`='autocomplete' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='topography' AND type='input' AND structure_value_domain  IS NULL );
-- Delete obsolete structure fields
DELETE FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='topography' AND `type`='input' AND structure_value_domain IS NULL ;

UPDATE structure_formats SET `flag_add` = '0', `flag_add_readonly` = '0', `flag_edit` = '0', `flag_edit_readonly` = '0', `flag_search` = '0', `flag_search_readonly` = '0', `flag_datagrid` = '0', `flag_datagrid_readonly` = '0', `flag_index` = '0', `flag_detail` = '0'
WHERE structure_field_id = (SELECT id FROM structure_fields WHERE `field` LIKE 'target_site_icdo');

ALTER TABLE datamart_batch_sets
  ADD `sharing_status` varchar(50) DEFAULT 'user' AFTER `share_set_with_group`;
UPDATE datamart_batch_sets SET sharing_status = 'group' WHERE share_set_with_group = 'yes';
ALTER TABLE datamart_batch_sets  
  DROP COLUMN share_set_with_group;
  
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) 
VALUES
("user", "private"),
("group", "share with the group"),
("all", "public");
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) 
VALUES ('batch_sets_sharing_status', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="batch_sets_sharing_status"),  
(SELECT id FROM structure_permissible_values WHERE value="user" AND language_alias="private"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="batch_sets_sharing_status"),  
(SELECT id FROM structure_permissible_values WHERE value="group" AND language_alias="share with the group"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="batch_sets_sharing_status"),  
(SELECT id FROM structure_permissible_values WHERE value="all" AND language_alias="public"), "3", "1");

UPDATE structure_fields SET field = 'sharing_status', language_label = 'batchset sharing status', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name="batch_sets_sharing_status") 
WHERE field = 'share_set_with_group' AND tablename = 'datamart_batch_sets';

INSERT IGNORE into i18n (id, en, fr) VALUES 
('private', 'Private', 'Privé'),
('public', 'Public', 'Publique'),
('batchset sharing status', 'Batchset Status', 'Statu de l''ensemble de données'),
('your are not allowed to work on this batchset', 'Your are not allowed to work on this batchset!', 'Vous n''êtes pas authorisé à travailler sur cet ensemble de données!'),
('share with the group', 'Share With The Group', 'Partager avec le groupe');


ALTER TABLE aliquot_review_masters MODIFY `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00';
ALTER TABLE ar_breast_tissue_slides MODIFY `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00';
ALTER TABLE datamart_browsing_indexes_revs ADD `version_created` datetime NOT NULL;
ALTER TABLE datamart_browsing_results_revs MODIFY id INT UNSIGNED NOT NULL;
ALTER TABLE datamart_browsing_results_revs ADD `version_created` datetime NOT NULL;
ALTER TABLE spr_breast_cancer_types MODIFY `created` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00';
ALTER TABLE structure_permissible_values_customs_revs ADD `version_created` datetime NOT NULL;

INSERT IGNORE INTO i18n (id, en, fr) VALUES
("available", "Available", "Disponible"),
("base", "Base", "Base"),
("breast_cancer_type", "Breast cancer type", "Type de cancer du sein"),
("colon_cancer_type", "Colon cancer type", "Type de cancer du colon"),
("date created", "Date created", "Date de création"),
("date_expiry", "Expiration date", "Date d'expiration"),
("diagnosis identifier", "Diagnosis identifier", "Identifiant de diagnostic"),
("First name is required.", "First name is required.", "Le prénom est requis."),
("frozen tissue", "Frozen tissue", "Tissu congelé"),
("if you were logged id, your session expired.", "If you were logged in, your session expired.", "Si vous étiez connecté, votre session est expirée."),
("institutional", "Institutional", "Institutionel"),
("invalid cause of death code", "Invalid cause of death code", "Code de cause de décès invalide"),
("invalid morphology code", "Invalid morphology code", "Code de morphologie invalide"),
("invalid primary disease code", "Invalid primary disease code", "Code de décès primaire invalide"),
("invalid secondary cause of death code", "Invalid secondary cause of death code", "Code de seconde cause de décès invalide"),
("invalid topography code", "Invalid topography code", "Code de topographie invalide"),
("modified", "Modified", "Modifié"),
("multiple", "Multiple", "Multiple"),
("not available", "Not available", "Non disponible"),
("operating room", "Operating room", "Salle d'opération"),
("page %d", "page %d", "page %d"),
("paraffin block", "Paraffin block", "Bloc de paraffine"),
("position into", "Position into", "Position dans"),
("product type is required.", "Product type is required", "Le type de produit est requis"),
("requested", "Requested", "Demandé"),
("saved", "Saved", "Enregistré");

-- event_control
UPDATE event_controls SET detail_tablename='ed_breast_lab_pathologies' WHERE detail_tablename='ed_breast_lab_pathology';
RENAME TABLE  ed_breast_lab_pathology TO ed_breast_lab_pathologies;
RENAME TABLE  ed_breast_lab_pathology_revs TO ed_breast_lab_pathologies_revs;
UPDATE event_controls SET detail_tablename='ed_all_clinical_followups' WHERE detail_tablename='ed_all_clinical_followup';
RENAME TABLE ed_all_clinical_followup TO ed_all_clinical_followups;
RENAME TABLE ed_all_clinical_followup_revs TO ed_all_clinical_followups_revs;
UPDATE event_controls SET detail_tablename='ed_all_clinical_presentations' WHERE detail_tablename='ed_all_clinical_presentation';
RENAME TABLE ed_all_clinical_presentation TO ed_all_clinical_presentations;
RENAME TABLE ed_all_clinical_presentation_revs TO ed_all_clinical_presentations_revs;
UPDATE event_controls SET detail_tablename='ed_all_lifestyle_smokings' WHERE detail_tablename='ed_all_lifestyle_smoking';
RENAME TABLE ed_all_lifestyle_smoking TO ed_all_lifestyle_smokings;
RENAME TABLE ed_all_lifestyle_smoking_revs TO ed_all_lifestyle_smokings_revs;
UPDATE event_controls SET detail_tablename='ed_all_adverse_events_adverse_events' WHERE detail_tablename='ed_all_adverse_events_adverse_event';
RENAME TABLE ed_all_adverse_events_adverse_event TO ed_all_adverse_events_adverse_events;
RENAME TABLE ed_all_adverse_events_adverse_event_revs TO ed_all_adverse_events_adverse_events_revs;
UPDATE event_controls SET detail_tablename='ed_breast_screening_mammograms' WHERE detail_tablename='ed_breast_screening_mammogram';
RENAME TABLE ed_breast_screening_mammogram TO ed_breast_screening_mammograms;
RENAME TABLE ed_breast_screening_mammogram_revs TO ed_breast_screening_mammograms_revs;
UPDATE event_controls SET detail_tablename='ed_all_protocol_followups' WHERE detail_tablename='ed_all_protocol_followup';
RENAME TABLE ed_all_protocol_followup TO ed_all_protocol_followups;
RENAME TABLE ed_all_protocol_followup_revs TO ed_all_protocol_followups_revs;
UPDATE event_controls SET detail_tablename='ed_all_study_research' WHERE detail_tablename='ed_all_study_researches';
RENAME TABLE ed_all_study_research TO ed_all_study_researches; 
RENAME TABLE ed_all_study_research_revs TO ed_all_study_researches_revs;

-- sop_control
UPDATE sop_controls SET detail_tablename='sopd_general_alls' WHERE detail_tablename='sopd_general_all';
RENAME TABLE sopd_general_all TO sopd_general_alls;
RENAME TABLE sopd_general_all_revs TO sopd_general_alls_revs;
UPDATE sop_controls SET detail_tablename='sopd_inventory_alls' WHERE detail_tablename='sopd_inventory_all';
RENAME TABLE sopd_inventory_all TO sopd_inventory_alls;
RENAME TABLE sopd_inventory_all_revs TO sopd_inventory_alls_revs;

ALTER TABLE datamart_batch_processes
  ADD `flag_active` tinyint(1) NOT NULL DEFAULT '1' AFTER `url`;
INSERT INTO datamart_batch_processes (id,name,plugin,model,url) VALUES
(null, 'add to order', 'Inventorymanagement', 'AliquotMaster', '/order/order_items/addAliquotsInBatch/'),
(null, 'add to order', 'Inventorymanagement', 'ViewAliquot', '/order/order_items/addAliquotsInBatch/');
  
INSERT IGNORE INTO i18n (id, en, fr) VALUES
('please check aliquots', 'Please check aliquots', 'veuillez vérifier l''aliquot'); 
  
  
  
  
