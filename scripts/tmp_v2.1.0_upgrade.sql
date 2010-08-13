-- Version: v2.1.0
-- Description: This SQL script is an upgrade for ATiM v2.0.2A to 2.1.0 and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.1.0 (Alpha)', `date_installed` = CURDATE(), `build_number` = ''
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
("invalid decimal separator", "Invalid decimal separator", "Séparateur de décimales invalide");

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

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('cdna', '', 'cDNA', 'DNAc');

-- Add new message for duplicated aliquot barcodes

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('please check following barcodes', '', 'Please check following barcodes: ', 'Veuillez contrôler les barcodes suivants: ');


-- datamart browser
INSERT INTO `menus` (`id` ,`parent_id` ,`is_root` ,`display_order` ,`language_title` ,`language_description` ,`use_link` ,`use_params` ,`use_summary` ,`flag_active` ,`created` ,`created_by` ,`modified` ,`modified_by`) VALUES 
('qry-CAN-1-1', 'qry-CAN-1', '0', '3', 'data browser', 'tool to browse data', '/datamart/browser/index', '', '', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');


CREATE TABLE datamart_structures(
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
plugin VARCHAR(50) NOT NULL,
model VARCHAR(50) NOT NULL,
structure_id INT NOT NULL,
results_structure_alias VARCHAR(255) NOT NULL,
display_name VARCHAR(50) NOT NULL,
use_key VARCHAR(50) NOT NULL,
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

INSERT INTO datamart_structures (`id`, `plugin`, `model`, `structure_id`, `display_name`, `use_key`) VALUES
(1, 'Inventorymanagement', 'ViewAliquot', (SELECT id FROM structures WHERE alias='view_aliquot_joined_to_collection'), 'aliquots', 'aliquot_master_id'),
(2, 'Inventorymanagement', 'ViewCollection', (SELECT id FROM structures WHERE alias='view_collection'), 'collections', 'collection_id'),
(3, 'Storagelayout', 'StorageMaster', (SELECT id FROM structures WHERE alias='storagemasters'), 'storages', 'id'),
(4, 'Clinicalannotation', 'Participant', (SELECT id FROM structures WHERE alias='participants'), 'participants', 'id'),
(5, 'Inventorymanagement', 'ViewSample', (SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), 'samples', 'sample_master_id'),
(6, 'Clinicalannotation', 'MiscIdentifier', (SELECT id FROM structures WHERE alias='miscidentifierssummary'), 'identification', 'id');

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
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) 
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

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
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

INSERT INTO i18n (id, en, fr)
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
