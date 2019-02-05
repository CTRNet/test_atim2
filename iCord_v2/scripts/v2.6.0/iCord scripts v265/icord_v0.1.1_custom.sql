-- Stephen Fung
-- March 1st 2016

-- iCord Customization Script
-- Version: v0.1.1
-- ATiM Version: v2.6.5

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'iCord v0.1.1', '');

-- Add a field called Participant type

ALTER TABLE `participants` 
ADD COLUMN `participant_type` varchar(25) DEFAULT NULL AFTER `vital_status`;

ALTER TABLE `participants_revs` 
ADD COLUMN `participant_type` varchar(25) DEFAULT NULL AFTER `vital_status`; 

INSERT INTO `structure_value_domains` (`domain_name`, `source`)
VALUES
('participant_type', NULL);

INSERT INTO `structure_permissible_values` (`value`, `language_alias`)
VALUES
('camper','camper'),
('drainage','drainage'),
('pressure','pressure'),
('pigs','pigs');

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='participant_type'), (SELECT `id` FROM structure_permissible_values WHERE `value`='camper'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='participant_type'), (SELECT `id` FROM structure_permissible_values WHERE `value`='drainage'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='participant_type'), (SELECT `id` FROM structure_permissible_values WHERE `value`='pressure'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='participant_type'), (SELECT `id` FROM structure_permissible_values WHERE `value`='pigs'), 4, 1, 1);


INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'participant_type', 'participant type', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'participant_type'), 'help_participant_type', 0);


INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='participant_type' AND `type`='select'), 
1, 9, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('participant type', 'Participant Type', ''),
('camper', 'Camper', ''),
('drainage', 'Drainage', ''),
('pressure', 'Pressure', ''),
('pigs', 'Pigs', '');

-- New fields for Collection

ALTER TABLE `collections` 
ADD COLUMN `collection_timepoint` varchar(30) DEFAULT NULL AFTER `collection_site`,
ADD COLUMN `autopsy_location` varchar(30) DEFAULT NULL AFTER `collection_datetime_accuracy`,
ADD COLUMN `autopsy_datetime` datetime DEFAULT NULL AFTER `autopsy_location`,
ADD COLUMN `autopsy_datetime_accuracy` char(1) NOT NULL AFTER `autopsy_datetime`,
ADD COLUMN `value_of_quantity` int(11) DEFAULT NULL AFTER `autopsy_datetime_accuracy`,
ADD COLUMN `availability` varchar(30) DEFAULT NULL AFTER `value_of_quantity`,
ADD COLUMN `volume` varchar(30) DEFAULT NULL AFTER `availability`;

ALTER TABLE `collections_revs` 
ADD COLUMN `collection_timepoint` varchar(30) DEFAULT NULL AFTER `collection_site`,
ADD COLUMN `autopsy_location` varchar(30) DEFAULT NULL AFTER `collection_datetime_accuracy`,
ADD COLUMN `autopsy_datetime` datetime DEFAULT NULL AFTER `autopsy_location`,
ADD COLUMN `autopsy_datetime_accuracy` char(1) NOT NULL AFTER `autopsy_datetime`,
ADD COLUMN `value_of_quantity` int(11) DEFAULT NULL AFTER `autopsy_datetime_accuracy`,
ADD COLUMN `availability` varchar(30) DEFAULT NULL AFTER `value_of_quantity`,
ADD COLUMN `volume` varchar(30) DEFAULT NULL AFTER `availability`;

ALTER TABLE `view_collections` 
ADD COLUMN `collection_timepoint` varchar(30) DEFAULT NULL AFTER `collection_site`,
ADD COLUMN `autopsy_location` varchar(30) DEFAULT NULL AFTER `collection_datetime_accuracy`,
ADD COLUMN `autopsy_datetime` datetime DEFAULT NULL AFTER `autopsy_location`,
ADD COLUMN `autopsy_datetime_accuracy` char(1) NOT NULL AFTER `autopsy_datetime`,
ADD COLUMN `value_of_quantity` int(11) DEFAULT NULL AFTER `autopsy_datetime_accuracy`,
ADD COLUMN `availability` varchar(30) DEFAULT NULL AFTER `value_of_quantity`,
ADD COLUMN `volume` varchar(30) DEFAULT NULL AFTER `availability`;

INSERT INTO `structure_value_domains` (`domain_name`, `source`)
VALUES
('collection_timepoint', NULL),
('autopsy_location', NULL),
('collection_availability', NULL),
('collection_volume', NULL);

INSERT INTO `structure_permissible_values` (`value`, `language_alias`)
VALUES
('vgh','vgh'),
('post mortem','post mortem'),
('antemortem','antemortem'),
('<50 uL','<50 uL'),
('50-1000 uL','50-1000 uL'),
('>1000 uL','>1000 uL'),
('absent','absent');

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='collection_timepoint'), (SELECT `id` FROM structure_permissible_values WHERE `value`='post mortem'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='collection_timepoint'), (SELECT `id` FROM structure_permissible_values WHERE `value`='antemortem'), 2, 1, 1);

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='autopsy_location'), (SELECT `id` FROM structure_permissible_values WHERE `value`='vgh'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='autopsy_location'), (SELECT `id` FROM structure_permissible_values WHERE `value`='other'), 2, 1, 1);

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='collection_availability'), (SELECT `id` FROM structure_permissible_values WHERE `value`='present'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='collection_availability'), (SELECT `id` FROM structure_permissible_values WHERE `value`='absent'), 2, 1, 1);

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='collection_volume'), (SELECT `id` FROM structure_permissible_values WHERE `value`='<50 uL'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='collection_volume'), (SELECT `id` FROM structure_permissible_values WHERE `value`='50-1000 uL'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='collection_volume'), (SELECT `id` FROM structure_permissible_values WHERE `value`='>1000 uL'), 3, 1, 1);


INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('InventoryManagement', 'Collection', 'collections', 'collection_timepoint', 'collection timepoint', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'collection_timepoint'), 'help_collection_timepoint', 0),
('InventoryManagement', 'Collection', 'collections', 'autopsy_location', 'autopsy site', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'autopsy_location'), 'help_autopsy_location', 0),
('InventoryManagement', 'Collection', 'collections', 'autopsy_datetime', 'autopsy date', '', 'datetime', '', '', NULL, 'help_autopsy_datetime', 0),
('InventoryManagement', 'Collection', 'collections', 'value_of_quantity', 'value of quantity', '', 'integer_positive', '', '', NULL, 'help_value_of_quantity', 0),
('InventoryManagement', 'Collection', 'collections', 'availability', 'collection availability', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'collection_availability'), 'help_availability', 0),
('InventoryManagement', 'Collection', 'collections', 'volume', 'collection volume', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'collection_volume'), 'help_collection_volume', 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='collection_timepoint' AND `type`='select'), 
0, 11, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
1, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='autopsy_location' AND `type`='select'), 
0, 5, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
1, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='autopsy_datetime' AND `type`='datetime'), 
0, 6, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
1, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='value_of_quantity' AND `type`='integer_positive'), 
0, 19, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
1, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='availability' AND `type`='select'),
0, 21, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
1, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='volume' AND `type`='select'),
0, 23, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
1, 0, 1, 0, 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'linked_collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='collection_timepoint' AND `type`='select'), 
0, 11, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'linked_collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='autopsy_location' AND `type`='select'), 
0, 5, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'linked_collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='autopsy_datetime' AND `type`='datetime'), 
0, 6, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'linked_collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='value_of_quantity' AND `type`='integer_positive'), 
0, 19, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'linked_collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='availability' AND `type`='select'),
0, 21, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'linked_collections'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='Collection' AND `tablename`='collections' AND `field`='volume' AND `type`='select'),
0, 23, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0);

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('InventoryManagement', 'ViewCollection', 'view_collections', 'collection_timepoint', 'collection timepoint', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'collection_timepoint'), 'help_collection_timepoint', 0),
('InventoryManagement', 'ViewCollection', 'view_collections', 'autopsy_location', 'autopsy site', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'autopsy_location'), 'help_autopsy_location', 0),
('InventoryManagement', 'ViewCollection', 'view_collections', 'autopsy_datetime', 'autopsy date', '', 'datetime', '', '', NULL, 'help_autopsy_datetime', 0),
('InventoryManagement', 'ViewCollection', 'view_collections', 'value_of_quantity', 'value of quantity', '', 'integer_positive', '', '', NULL, 'help_value_of_quantity', 0),
('InventoryManagement', 'ViewCollection', 'view_collections', 'availability', 'collection availability', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'collection_availability'), 'help_availability', 0),
('InventoryManagement', 'ViewCollection', 'view_collections', 'volume', 'collection volume', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'collection_volume'), 'help_collection_volume', 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'view_collection'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='collection_timepoint' AND `type`='select'), 
1, 11, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'view_collection'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='autopsy_location' AND `type`='select'), 
1, 5, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'view_collection'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='autopsy_datetime' AND `type`='datetime'), 
1, 6, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'view_collection'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='value_of_quantity' AND `type`='integer_positive'), 
1, 19, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'view_collection'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='availability' AND `type`='select'),
1, 21, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'view_collection'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='volume' AND `type`='select'),
1, 23, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0);

UPDATE structure_formats
SET `display_order` = 25
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'view_collection')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `type`='datetime');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('autopsy site', 'Autopsy Site', ''),
('vgh', 'VGH', ''),
('autopsy date', 'Autopsy Date', ''),
('collection timepoint', 'Collection Timepoint', ''),
('post mortem', 'Post Mortem', ''),
('antemortem', 'Antemortem', ''),
('value of quantity', 'Value of Quantity', ''),
('collection availability', 'Collection Availability', ''),
('absent', 'Absent', ''),
('collection volume', 'Collection Volume', ''),
('<50 uL', '<50 uL', ''),
('50-1000 uL', '50-1000 uL', ''),
('>1000 uL', '>1000 uL', '');

-- Add building and room number to room in storages

ALTER TABLE `std_rooms` 
ADD COLUMN `building` varchar(100) DEFAULT NULL AFTER `storage_master_id`,
ADD COLUMN `room_num` varchar(60) DEFAULT NULL AFTER `floor`;

ALTER TABLE `std_rooms_revs` 
ADD COLUMN `building` varchar(100) DEFAULT NULL AFTER `storage_master_id`,
ADD COLUMN `room_num` varchar(60) DEFAULT NULL AFTER `floor`;

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('StorageLayout', 'StorageDetail', 'std_rooms', 'building', 'building', '', 'input', 'size=20', '', NULL, '', 0),
('StorageLayout', 'StorageDetail', 'std_rooms', 'room_num', 'room number', '', 'input', 'size=20', '', NULL, '', 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'std_rooms'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='StorageLayout' AND `model`='StorageDetail' AND `tablename`='std_rooms' AND `field`='building' AND `type`='input'), 
1, 29, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'std_rooms'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='StorageLayout' AND `model`='StorageDetail' AND `tablename`='std_rooms' AND `field`='room_num' AND `type`='input'), 
1, 32, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('building', 'Building', ''),
('room number', 'Room Number', '');

-- Add fields to participant form for pigs

ALTER TABLE `participants` 
ADD COLUMN `icord_injury_datetime_accuracy` char(1) NOT NULL AFTER `icord_injury_datetime`,
ADD COLUMN `icord_pig_species` varchar(50) DEFAULT NULL AFTER `icord_postmortum_interal`,
ADD COLUMN `icord_pig_breed` varchar(50) DEFAULT NULL AFTER `icord_pig_species`,
ADD COLUMN `icord_pig_id` varchar(50) DEFAULT NULL AFTER `icord_pig_breed`,
ADD COLUMN `icord_pig_body_weight` int(11) DEFAULT NULL AFTER `icord_pig_id`,
ADD COLUMN `icord_pig_injury_type` varchar(50) DEFAULT NULL AFTER `icord_pig_body_weight`,
ADD COLUMN `icord_pig_injury_height` varchar(50) DEFAULT NULL AFTER `icord_pig_injury_type`,
ADD COLUMN `icord_pig_injury_force` int(11) DEFAULT NULL AFTER `icord_pig_injury_height`,
ADD COLUMN `icord_pig_compression` varchar(25) DEFAULT NULL AFTER `icord_pig_injury_force`,
ADD COLUMN `icord_pig_compression_time` varchar(25) DEFAULT NULL AFTER `icord_pig_compression`,
ADD COLUMN `icord_pig_surgery_detail` text DEFAULT NULL AFTER `icord_pig_compression_time`,
ADD COLUMN `icord_pig_sacrifice_datetime` datetime DEFAULT NULL AFTER `icord_pig_surgery_detail`,
ADD COLUMN `icord_pig_sacrifice_datetime_accuracy` char(1) DEFAULT NULL AFTER `icord_pig_sacrifice_datetime`;


ALTER TABLE `participants_revs` 
ADD COLUMN `icord_injury_datetime_accuracy` char(1) NOT NULL AFTER `icord_injury_datetime`,
ADD COLUMN `icord_pig_species` varchar(50) DEFAULT NULL AFTER `icord_postmortum_interal`,
ADD COLUMN `icord_pig_breed` varchar(50) DEFAULT NULL AFTER `icord_pig_species`,
ADD COLUMN `icord_pig_id` varchar(50) DEFAULT NULL AFTER `icord_pig_breed`,
ADD COLUMN `icord_pig_body_weight` int(11) DEFAULT NULL AFTER `icord_pig_id`,
ADD COLUMN `icord_pig_injury_type` varchar(50) DEFAULT NULL AFTER `icord_pig_body_weight`,
ADD COLUMN `icord_pig_injury_height` varchar(50) DEFAULT NULL AFTER `icord_pig_injury_type`,
ADD COLUMN `icord_pig_injury_force` int(11) DEFAULT NULL AFTER `icord_pig_injury_height`,
ADD COLUMN `icord_pig_compression` varchar(25) DEFAULT NULL AFTER `icord_pig_injury_force`,
ADD COLUMN `icord_pig_compression_time` varchar(25) DEFAULT NULL AFTER `icord_pig_compression`,
ADD COLUMN `icord_pig_surgery_detail` text DEFAULT NULL AFTER `icord_pig_compression_time`,
ADD COLUMN `icord_pig_sacrifice_datetime` datetime DEFAULT NULL AFTER `icord_pig_surgery_detail`,
ADD COLUMN `icord_pig_sacrifice_datetime_accuracy` char(1) DEFAULT NULL AFTER `icord_pig_sacrifice_datetime`;

-- domain for dropdown fields
INSERT INTO structure_value_domains (`domain_name`, `override`, `source`) 
VALUES
('icord_pig_species', 'open', NULL),
('icord_pig_breed', 'open', NULL),
('icord_pig_injury_type', 'open', NULL),
('icord_pig_injury_height', 'open', NULL),
('icord_pig_compression', 'open', NULL),
('icrod_pig_compression_time', 'open', NULL);

-- Drop down field values
INSERT INTO `structure_permissible_values` (`value`, `language_alias`)
VALUES
('pig','pig'),
('yorkshire pig','yorkshire pig'),
('yucatan minipig','yucatan minipig'),
('sprague dawley','sprague dawley'),
('long evens','long evens'),
('5 cm','5 cm'),
('10 cm','10 cm'),
('20 cm','20 cm'),
('40 cm','40 cm'),
('50 cm','50 cm'),
('5 min','5 min');

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_species'), (SELECT `id` FROM structure_permissible_values WHERE `value`='pig'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_species'), (SELECT `id` FROM structure_permissible_values WHERE `value`='other'), 2, 1, 1);

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_breed'), (SELECT `id` FROM structure_permissible_values WHERE `value`='yorkshire pig'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_breed'), (SELECT `id` FROM structure_permissible_values WHERE `value`='yucatan minipig'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_breed'), (SELECT `id` FROM structure_permissible_values WHERE `value`='sprague dawley'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_breed'), (SELECT `id` FROM structure_permissible_values WHERE `value`='long evens'), 4, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_breed'), (SELECT `id` FROM structure_permissible_values WHERE `value`='other'), 5, 1, 1);

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_injury_type'), (SELECT `id` FROM structure_permissible_values WHERE `value`='contusion'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_injury_type'), (SELECT `id` FROM structure_permissible_values WHERE `value`='compression'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_injury_type'), (SELECT `id` FROM structure_permissible_values WHERE `value`='contusion+compression'), 3, 1, 1);

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_injury_height'), (SELECT `id` FROM structure_permissible_values WHERE `value`='5 cm'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_injury_height'), (SELECT `id` FROM structure_permissible_values WHERE `value`='10 cm'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_injury_height'), (SELECT `id` FROM structure_permissible_values WHERE `value`='20 cm'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_injury_height'), (SELECT `id` FROM structure_permissible_values WHERE `value`='40 cm'), 4, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_injury_height'), (SELECT `id` FROM structure_permissible_values WHERE `value`='50 cm'), 5, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_injury_height'), (SELECT `id` FROM structure_permissible_values WHERE `value`='other'), 6, 1, 1);

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_compression'), (SELECT `id` FROM structure_permissible_values WHERE `value`='yes'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icord_pig_compression'), (SELECT `id` FROM structure_permissible_values WHERE `value`='no'), 2, 1, 1);

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icrod_pig_compression_time'), (SELECT `id` FROM structure_permissible_values WHERE `value`='5 min'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icrod_pig_compression_time'), (SELECT `id` FROM structure_permissible_values WHERE `value`='1 hr'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icrod_pig_compression_time'), (SELECT `id` FROM structure_permissible_values WHERE `value`='3 hr'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='icrod_pig_compression_time'), (SELECT `id` FROM structure_permissible_values WHERE `value`='other'), 4, 1, 1);

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'icord_pig_species', 'species', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_pig_species'), '', 0),
('ClinicalAnnotation', 'Participant', 'participants', 'icord_pig_breed', 'breed', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_pig_breed'), '', 0),
('ClinicalAnnotation', 'Participant', 'participants', 'icord_pig_id', 'pig id', '', 'input', '', '', NULL, '', 0),
('ClinicalAnnotation', 'Participant', 'participants', 'icord_pig_body_weight', 'body weight', '', 'float_positive', '', '', NULL, '', 0),
('ClinicalAnnotation', 'Participant', 'participants', 'icord_pig_injury_type', 'injury type', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_pig_injury_type'), '', 0),
('ClinicalAnnotation', 'Participant', 'participants', 'icord_pig_injury_height', 'injury height', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_pig_injury_height'), '', 0),
('ClinicalAnnotation', 'Participant', 'participants', 'icord_pig_injury_force', 'injury force', '', 'float_positive', '', '', NULL, '', 0),
('ClinicalAnnotation', 'Participant', 'participants', 'icord_pig_compression', 'compression', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_pig_compression'), '', 0),
('ClinicalAnnotation', 'Participant', 'participants', 'icord_pig_compression_time', 'compression time', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icrod_pig_compression_time'), '', 0),
('ClinicalAnnotation', 'Participant', 'participants', 'icord_pig_surgery_detail', 'surgery detail', '', 'textarea', 'row=3,cols=30', '', NULL, '', 0),
('ClinicalAnnotation', 'Participant', 'participants', 'icord_pig_sacrifice_datetime', 'sacrafice datetime', '', 'datetime', '', '', NULL, '', 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_pig_species' AND `type`='select'), 
3, 40, 'animal specific data', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_pig_breed' AND `type`='select'), 
3, 42, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_pig_id' AND `type`='input'), 
3, 44, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_pig_body_weight' AND `type`='float_positive'), 
3, 46, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_pig_injury_type' AND `type`='select'), 
3, 48, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_pig_injury_height' AND `type`='select'), 
3, 50, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_pig_injury_force' AND `type`='float_positive'), 
3, 52, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_pig_compression' AND `type`='select'), 
3, 54, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_pig_compression_time' AND `type`='select'), 
3, 55, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_pig_surgery_detail' AND `type`='textarea'), 
3, 56, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_pig_sacrifice_datetime' AND `type`='datetime'), 
3, 58, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('yorkshire pig','Yorkshire pig', ''),
('yucatan minipig','Yucatan Minipig', ''),
('sprague dawley','Sprague Dawley', ''),
('long evens','Long Evens', ''),
('5 min','5 min', ''),
('5 cm','5 cm', ''),
('10 cm','10 cm', ''),
('20 cm','20 cm', ''),
('40 cm','40 cm', ''),
('50 cm','50 cm', ''),
('pig','Pig', ''),
('animal specific data','Animal Specific Data', ''),
('pig id','Pig ID', ''),
('body weight','Body Weight', ''),
('surgery detail','Surgery Detail', ''),
('sacrafice datetime','Sacrafice Datetime', '');

-- Add timepoint to samples

ALTER TABLE `sample_masters`
ADD COLUMN `icord_vial_id` varchar(30) DEFAULT NULL AFTER `notes`,
ADD COLUMN `icord_approx_timepoint` int(11) DEFAULT NULL AFTER `icord_vial_id`,
ADD COLUMN `icord_actual_timepoint` decimal(5,2) DEFAULT NULL AFTER `icord_approx_timepoint`;

ALTER TABLE `sample_masters_revs`
ADD COLUMN `icord_vial_id` varchar(30) DEFAULT NULL AFTER `notes`,
ADD COLUMN `icord_approx_timepoint` int(11) DEFAULT NULL AFTER `icord_vial_id`,
ADD COLUMN `icord_actual_timepoint` decimal(5,2) DEFAULT NULL AFTER `icord_approx_timepoint`;

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'icord_vial_id', 'vial id', '', 'input', '', '', NULL, '', 0),
('InventoryManagement', 'SampleMaster', 'sample_masters', 'icord_approx_timepoint', 'approximate timepoint', '', 'integer_positive', '', '', NULL, '', 0),
('InventoryManagement', 'SampleMaster', 'sample_masters', 'icord_actual_timepoint', 'actual timepoint', '', 'float_positive', '', '', NULL, '', 0);

INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'sample_masters'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='icord_vial_id' AND `type`='input'), 
0, 350, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'sample_masters'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='icord_approx_timepoint' AND `type`='integer_positive'), 
0, 352, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'sample_masters'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='icord_actual_timepoint' AND `type`='float_positive'), 
0, 354, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('vial id','Vial ID', ''),
('approximate timepoint','Apporximate Timepoint', ''),
('actual timepoint','Actual Timepoint', '');

-- Add Spinal Cord to Tissue Type





