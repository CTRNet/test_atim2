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
("specific", "specific", "spécifique");

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


CREATE TABLE datamart_browsing_structures(
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
plugin VARCHAR(50) NOT NULL,
model VARCHAR(50) NOT NULL,
structure_alias VARCHAR(255) NOT NULL,
results_structure_alias VARCHAR(255) NOT NULL,
display_name VARCHAR(50) NOT NULL,
use_key VARCHAR(50) NOT NULL,
FOREIGN KEY (`structure_alias`) REFERENCES `structures`(`alias`)
)Engine=InnoDb;

CREATE TABLE datamart_browsing_controls(
id1 INT UNSIGNED NOT NULL,
id2 INT UNSIGNED NOT NULL,
flag_active_1_to_2 BOOLEAN NOT NULL DEFAULT true,
flag_active_2_to_1 BOOLEAN NOT NULL DEFAULT true,
use_field VARCHAR(50) NOT NULL,
UNIQUE(id1, id2),
FOREIGN KEY (`id1`) REFERENCES `datamart_browsing_structures`(`id`),
FOREIGN KEY (`id2`) REFERENCES `datamart_browsing_structures`(`id`)
)Engine=InnoDb;

INSERT INTO datamart_browsing_structures (`id`, `plugin`, `model`, `structure_alias`, `display_name`, `use_key`) VALUES
(1, 'Inventorymanagement', 'ViewAliquot', 'view_aliquot_joined_to_collection', 'aliquots', 'aliquot_master_id'),
(2, 'Inventorymanagement', 'ViewCollection', 'view_collection', 'collections', 'collection_id'),
(3, 'Storagelayout', 'StorageMaster', 'storagemasters', 'storages', 'id'),
(4, 'Clinicalannotation', 'Participant', 'participants', 'participants', 'id'),
(5, 'Inventorymanagement', 'ViewSample', 'view_sample_joined_to_collection', 'samples', 'sample_master_id'),
(6, 'Clinicalannotation', 'MiscIdentifier', 'miscidentifierssummary', 'identifiers', 'id');

INSERT INTO datamart_browsing_controls(`id1`, `id2`, `use_field`) VALUES
(1, 2, 'ViewAliquot.collection_id'),
(1, 3, 'ViewAliquot.storage_master_id'),
(2, 4, 'ViewCollection.participant_id'),
(1, 5, 'ViewAliquot.sample_master_id'),
(5, 2, 'ViewSample.collection_id'),
(6, 4, 'MiscIdentifier.participant_id');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('datamart_browser_options', '', '', 'Datamart.Browser::getDropdownOptions');
INSERT INTO structures(`alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES ('datamart_browser_start', '', '', '1', '1', '1', '1');
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Datamart', 'Browser', '', 'search_for', 'search for', '', 'select', '', '',  (SELECT id FROM structure_value_domains WHERE domain_name='datamart_browser_options') , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='datamart_browser_start'), (SELECT id FROM structure_fields WHERE `model`='Browser' AND `tablename`='' AND `field`='search_for' AND `language_label`='search for' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='datamart_browser_options')  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');

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
  `deleted_date` datetime DEFAULT NULL,
UNIQUE KEY (`user_id`, `parent_node_id`, `browsing_structures_id`, `id_csv`(200))
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
