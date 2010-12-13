-- Version: v2.1.1
-- Description: This SQL script is an upgrade for ATiM v2.1.0A to 2.1.1 and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
INSERT INTO `versions` (version_number, date_installed, build_number) VALUES('2.1.1-Alpha', NOW(), '> 2198');

TRUNCATE `acos`; 

-- Change created field label for participant, collection, aliquot

UPDATE structure_fields SET language_label = 'created (into the system)', language_help = 'help_created'
WHERE field = 'created' AND tablename IN ('view_collections', 'view_aliquots', 'aliquot_masters', 'aliquot_uses', 'participants');
UPDATE structure_formats AS sfo, structure_fields AS sfi, structures AS str
SET sfo.flag_override_label = '0', sfo.language_label = ''
WHERE sfi.field = 'created' AND sfi.tablename IN ('view_collections', 'view_aliquots', 'aliquot_masters', 'aliquot_uses', 'participants') 
AND str.alias = 'participants'
AND sfi.id = sfo.structure_field_id AND str.id = sfo.structure_id;
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('created (into the system)', 'Created (into the system)', 'Créé (dans le système)');	

INSERT INTO structure_validations (structure_field_id, rule, flag_empty, flag_required, language_message) VALUES
((SELECT id FROM structure_fields WHERE model='StructurePermissibleValuesCustom' AND field='en'), 'notEmpty', 0, 1, 'value is required'),
((SELECT id FROM structure_fields WHERE model='StructurePermissibleValuesCustom' AND field='fr'), 'notEmpty', 0, 1, 'value is required');

ALTER TABLE `structure_formats` 
ADD `flag_addgrid` SET( '0', '1' ) NOT NULL DEFAULT '0' AFTER `flag_datagrid_readonly` ,
ADD `flag_addgrid_readonly` SET( '0', '1' ) NOT NULL DEFAULT '0' AFTER `flag_addgrid` ,
ADD `flag_editgrid` SET( '0', '1' ) NOT NULL DEFAULT '0' AFTER `flag_addgrid_readonly` ,
ADD `flag_editgrid_readonly` SET( '0', '1' ) NOT NULL DEFAULT '0' AFTER `flag_editgrid`,
ADD `flag_summary` SET( '0', '1' ) NOT NULL DEFAULT '0' AFTER `flag_editgrid_readonly`,
ADD `flag_batchedit` SET( '0', '1' ) NOT NULL DEFAULT '0' AFTER `flag_summary`,
ADD `flag_batchedit_readonly` SET( '0', '1' ) NOT NULL DEFAULT '0' AFTER `flag_batchedit`;


UPDATE structure_formats SET flag_addgrid=flag_datagrid, flag_editgrid=flag_datagrid, 
flag_addgrid_readonly=flag_datagrid_readonly, flag_editgrid_readonly=flag_datagrid_readonly;

UPDATE structure_formats SET flag_summary=flag_index;

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
sfo.flag_editgrid AS flag_editgrid, sfo.flag_editgrid_readonly AS flag_editgrid_readonly, 
sfo.flag_batchedit AS flag_batchedit, sfo.flag_batchedit_readonly AS flag_batchedit_readonly,
sfo.flag_index AS flag_index, sfo.flag_detail AS flag_detail,
sfo.flag_summary AS flag_summary, sfo.display_column AS display_column, sfo.display_order AS display_order, sfo.language_heading AS language_heading
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
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='detail_type' AND `type`='input' AND `structure_value_domain`  IS NULL  ), '0', '2', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='temp_unit' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code'));
UPDATE structure_formats SET `display_order`='1', `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='aliquot_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type'));

ALTER TABLE structures
 DROP flag_add_columns,
 DROP flag_edit_columns,
 DROP flag_search_columns,
 DROP flag_detail_columns;

-- adhoc actions dropdown
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('batchset_process', '', '', 'Datamart.Batchset::getActionsDropdown');
UPDATE structure_fields SET  `model`='0',  `language_label`='action',  `setting`='id=batchsetProcess', `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='batchset_process')  WHERE model='BatchSet' AND tablename='' AND field='process' AND `type`='select' AND structure_value_domain  IS NULL ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='querytool_adhoc_to_batchset'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='process' AND `language_label`='action' AND `language_tag`='' AND `type`='select' AND `setting`='id=batchsetProcess' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='batchset_process')  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Datamart', 'BatchSet', '', 'id', '', '', 'hidden', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='querytool_batchset_to_processes'), (SELECT id FROM structure_fields WHERE `model`='BatchSet' AND `tablename`='' AND `field`='id' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0');


DELETE FROM structure_formats WHERE `display_column`='1' AND `display_order`='1' AND `language_heading`='' AND `flag_override_label`='0' AND `language_label`='' AND `flag_override_tag`='0' AND `language_tag`='' AND `flag_override_help`='0' AND `language_help`='' AND `flag_override_type`='0' AND `type`='' AND `flag_override_setting`='0' AND `setting`='' AND `flag_override_default`='0' AND `default`='' AND `flag_add`='1' AND `flag_add_readonly`='0' AND `flag_edit`='1' AND `flag_edit_readonly`='0' AND `flag_search`='1' AND `flag_search_readonly`='0' AND `flag_datagrid`='1' AND `flag_datagrid_readonly`='0' AND `flag_addgrid`='1' AND `flag_addgrid_readonly`='0' AND `flag_editgrid`='1' AND `flag_editgrid_readonly`='0' AND `flag_summary`='1' AND `flag_index`='1' AND `flag_detail`='1' AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Datamart' AND `model`='BatchSet' AND `tablename`='datamart_adhoc' AND `field`='id' AND `language_label`='action' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open');

DELETE FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model='BatchSet' AND field='title');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='querytool_adhoc_to_batchset') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Adhoc' AND tablename='datamart_adhoc' AND field='id' AND type='hidden' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='querytool_adhoc_to_batchset') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Adhoc' AND tablename='datamart_adhoc' AND field='sql_query_for_results' AND type='hidden' AND structure_value_domain  IS NULL );


-- storage parent_id dropdwon
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'sample_master_parent_id', 'open', '', 'Inventorymanagement.SampleMaster::getParentSampleDropdown');
UPDATE structure_fields SET structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='sample_master_parent_id') WHERE model='SampleMaster' AND field='parent_id';

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('storage_dropdown', '', '', 'StorageLayout.StorageMaster::getStoragesDropdown');
UPDATE structure_fields SET structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='storage_dropdown') WHERE plugin='Inventorymanagement' AND model='AliquotMaster' AND tablename='aliquot_masters' AND field='storage_master_id' AND type='select';

-- Event ctrl summary
INSERT INTO structures(`alias`, `language_title`, `language_help`) VALUES ('event_summary', '', '');

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'EventControl', 'event_controls', 'event_group', 'event_group', '', 'input', '', '',  NULL , '', 'open', 'open', 'open'), 
('', 'Clinicalannotation', 'EventControl', 'event_controls', 'disease_site', 'event_form_type', '', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='event_summary'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_group' AND `language_label`='event_group' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='event_summary'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `language_label`='event_form_type' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

-- chronology date/time fix
INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Clinicalannotation', 'Generated', 'generated', 'time', 'time', '', 'time', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES 
((SELECT id FROM structures WHERE alias='chronology'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='generated' AND `field`='time' AND `language_label`='time' AND `language_tag`='' AND `type`='time' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_fields SET  `type`='date' WHERE model='Generated' AND tablename='generated' AND field='date' AND `type`='datetime' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chronology') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Generated' AND tablename='generated' AND field='event' AND type='input' AND structure_value_domain  IS NULL );

UPDATE structure_formats SET flag_summary=0 WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotmasters') AND structure_field_id IN (SELECT id FROM structure_fields WHERE plugin='Inventorymanagement' AND model='Generated' AND field IN('aliquot_use_counter', 'realiquoting_data'));

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='versions') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Version' AND tablename='versions' AND field='version_number' AND type='input-readonly' AND structure_value_domain  IS NULL );

ALTER TABLE structure_formats DROP flag_datagrid, DROP flag_datagrid_readonly; 


-- cleaning aliquots structures to master/detail
INSERT INTO structures (`alias`) VALUES('aliquot_masters');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`) 
(SELECT (SELECT id FROM structures WHERE alias='aliquot_masters'),`structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail` FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id IN(
SELECT id FROM structure_fields WHERE 
(plugin='Core' AND model='FunctionManagement' AND field='CopyCtrl')
OR (plugin='Inventorymanagement' AND ((model='AliquotMaster' AND field IN('storage_datetime', 'aliquot_label', 'barcode', 'storage_coord_x', 'storage_coord_y', 'stored_by', 'sop_master_id', 'study_master_id', 'aliquot_type', 'in_stock', 'in_stock_detail', 'storage_master_id', 'notes'))
					 OR(model='Generated' AND field='aliquot_use_counter')
					 OR(model='SampleMaster' AND field='sample_type')))
OR (plugin='StorageLayout' AND ((model='FunctionManagement' AND field='recorded_storage_selection_label')
					OR(model='StorageMaster' AND field IN('temperature', 'code', 'selection_label', 'temp_unit'))))));

DELETE FROM structure_formats WHERE structure_id IN(SELECT id FROM structures WHERE alias IN(SELECT form_alias FROM aliquot_controls)) AND structure_field_id IN(
SELECT id FROM structure_fields WHERE 
(plugin='Core' AND model='FunctionManagement' AND field='CopyCtrl')
OR (plugin='Inventorymanagement' AND ((model='AliquotMaster' AND field IN('storage_datetime', 'aliquot_label', 'barcode', 'storage_coord_x', 'storage_coord_y', 'stored_by', 'sop_master_id', 'study_master_id', 'aliquot_type', 'in_stock', 'in_stock_detail', 'storage_master_id', 'notes'))
					 OR(model='Generated' AND field='aliquot_use_counter')
					 OR(model='SampleMaster' AND field='sample_type')))
OR (plugin='StorageLayout' AND ((model='FunctionManagement' AND field='recorded_storage_selection_label')
					OR(model='StorageMaster' AND field IN('temperature', 'code', 'selection_label', 'temp_unit')))));

-- updating field positions
UPDATE structure_formats SET `display_order`='100' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='sample_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type'));
UPDATE structure_formats SET `display_order`='200' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='aliquot_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type'));
UPDATE structure_formats SET `display_order`='300' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='400' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='in_stock' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values'));
UPDATE structure_formats SET `display_order`='500' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='in_stock_detail' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail'));
UPDATE structure_formats SET `display_order`='600' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Generated' AND tablename='' AND field='aliquot_use_counter' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='700' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='selection_label' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='701' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='FunctionManagement' AND tablename='' AND field='recorded_storage_selection_label' AND type='autocomplete' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='800' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='storage_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='storage_dropdown'));
UPDATE structure_formats SET `display_order`='801' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='code' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='900' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='storage_coord_x' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='901' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='storage_coord_y' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='1000' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='storage_datetime' AND type='datetime' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='1100' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='temperature' AND type='float' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='1101' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='temp_unit' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code'));
UPDATE structure_formats SET `display_order`='1200' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='sop_master_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list'));
UPDATE structure_formats SET `display_order`='1300' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='notes' AND type='textarea' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `display_order`='10000' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='FunctionManagement' AND tablename='' AND field='CopyCtrl' AND type='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox'));

-- ad_spec_tubes
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
-- ad_spec_tubes_incl_ml_vol
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
-- ad_spec_tiss_blocks
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
-- ad_spec_tiss_slides
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='created' AND type='datetime' AND structure_value_domain  IS NULL );
-- ad_spec_whatman_papers
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_whatman_papers') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
-- ad_der_tubes_incl_ml_vol
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
-- ad_der_cell_slides
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
-- ad_der_tubes_incl_ul_vol_and_conc
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ul_vol_and_conc') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
-- ad_spec_tiss_cores
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_cores') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
-- ad_der_cel_gel_matrices
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cel_gel_matrices') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
-- ad_der_cell_cores
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_cores') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
-- ad_der_cell_tubes_incl_ml_vol
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_cell_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));

UPDATE aliquot_controls SET form_alias=CONCAT('aliquot_masters,',form_alias);
 
ALTER TABLE datamart_structures
 ADD index_link VARCHAR(255) NOT NULL DEFAULT '';
UPDATE datamart_structures SET index_link='/inventorymanagement/aliquot_masters/detail/%%ViewAliquot.collection_id%%/%%ViewAliquot.sample_master_id%%/%%ViewAliquot.aliquot_master_id%%' WHERE model='ViewAliquot';
UPDATE datamart_structures SET index_link='/inventorymanagement/collections/detail/%%ViewCollection.collection_id%%/' WHERE model='ViewCollection';
UPDATE datamart_structures SET index_link='/storagelayout/storage_masters/detail/%%StorageMaster.id%%/' WHERE model='StorageMaster';
UPDATE datamart_structures SET index_link='/clinicalannotation/participants/profile/%%Participant.id%%' WHERE model='Participant';
UPDATE datamart_structures SET index_link='/inventorymanagement/sample_masters/detail/%%ViewSample.collection_id%%/%%ViewSample.sample_master_id%%/' WHERE model='ViewSample';
UPDATE datamart_structures SET index_link='/clinicalannotation/misc_identifiers/detail/%%MiscIdentifier.participant_id%%/%%MiscIdentifier.id%%/' WHERE model='MiscIdentifier';
UPDATE datamart_structures SET index_link='/clinicalannotation/consent_masters/detail/%%ConsentMaster.participant_id%%/%%ConsentMaster.id%%/' WHERE model='ConsentMaster';
UPDATE datamart_structures SET index_link='/clinicalannotation/diagnosis_masters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/' WHERE model='DiagnosisMaster';
UPDATE datamart_structures SET index_link='/clinicalannotation/treatment_masters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/' WHERE model='TreatmentMaster';
UPDATE datamart_structures SET index_link='/clinicalannotation/family_histories/detail/%%FamilyHistory.participant_id%%/%%FamilyHistory.id%%/' WHERE model='FamilyHistory';
UPDATE datamart_structures SET index_link='/clinicalannotation/participant_messages/detail/%%ParticipantMessage.participant_id%%/%%ParticipantMessage.id%%/' WHERE model='ParticipantMessage';
UPDATE datamart_structures SET index_link='/clinicalannotation/event_masters/detail/%%EventMaster.event_group%%/%%EventMaster.participant_id%%/%%EventMaster.id%%/' WHERE model='EventMaster';
UPDATE datamart_structures SET index_link='/inventorymanagement/specimen_reviews/%%SpecimenReviewMaster.collection_id%%/%%SpecimenReviewMaster.sample_master_id%%/%%SpecimenReviewMaster.id%%/' WHERE model='SpecimenReviewMaster';

ALTER TABLE datamart_batch_sets
 ADD datamart_structure_id INT UNSIGNED AFTER `description`,
 ADD FOREIGN KEY (`datamart_structure_id`) REFERENCES `datamart_structures`(`id`);


-- fixing permission tree view
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('aco_state', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("", "inherit"),
("1", "allow"),
("-1", "deny");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="aco_state"),  (SELECT id FROM structure_permissible_values WHERE value="" AND language_alias="inherit"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="aco_state"),  (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="allow"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="aco_state"),  (SELECT id FROM structure_permissible_values WHERE value="-1" AND language_alias="deny"), "", "1");
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='aco_state')  WHERE model='Aco' AND tablename='acos' AND field='state' AND `type`='select' AND structure_value_domain  IS NULL ;

ALTER TABLE datamart_structures
 ADD batch_edit_link varchar(255) NOT NULL DEFAULT '';

-- participant batchedit
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('', '0', '', 'ids', '', '', 'hidden', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_index`, `flag_detail`, `flag_batchedit` ) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ids' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='vital_status' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='health_status'));
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='date_of_death' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='cod_icd10_code' AND type='autocomplete' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='marital_status' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status'));
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='language_preferred' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred'));
UPDATE structure_formats SET `flag_batchedit`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Participant' AND tablename='participants' AND field='last_chart_checked_date' AND type='date' AND structure_value_domain  IS NULL );

ALTER TABLE datamart_structures
 MODIFY control_model VARCHAR(50) NOT NULL DEFAULT '',
 MODIFY control_master_model VARCHAR(50) NOT NULL DEFAULT '',
 MODIFY control_field VARCHAR(50) NOT NULL DEFAULT '';

CREATE TABLE datamart_structure_functions(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 datamart_structure_id INT UNSIGNED NOT NULL,
 label VARCHAR(250) NOT NULL DEFAULT '',
 link VARCHAR(250) NOT NULL DEFAULT '',
 flag_active BOOLEAN NOT NULL DEFAULT true,
 FOREIGN KEY (`datamart_structure_id`) REFERENCES `datamart_structures`(`id`)
)Engine=InnoDb;

INSERT INTO datamart_structure_functions (datamart_structure_id, label, link, flag_active) VALUES
((SELECT id FROM datamart_structures WHERE model='Participant'), 'edit', '/clinicalannotation/Participants/batchEdit/', true),
((SELECT id FROM datamart_structures WHERE model='ViewAliquot'), 'define realiquoted children', '/inventorymanagement/aliquot_masters/defineRealiquotedChildren/', true);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'id', '', '', 'hidden', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='children_aliquots_selection'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='id' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0');

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('previous versions', '', 'Installation History', '');

-- Customize links directly to user preferences instead of profile page
UPDATE `menus` SET `use_link` = '/customize/preferences/index/' WHERE `menus`.`id` = 'core_CAN_42';

DELETE FROM `i18n` WHERE `i18n`.`id` = 'login_help';
INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('login_help', '', 'Enter your username and password to access ATiM. Please contact your system administrator if you have forgotten your login credentials.', '');

-- Increased range on age at menopause validation.
UPDATE `structure_validations` SET `rule` = 'range,9,101'
WHERE `structure_validations`.`structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `field` = 'age_at_menopause' AND `tablename` = 'reproductive_histories');

UPDATE `i18n` SET `en` = 'Error - Age at menopause must be between 10 and 100!',
`fr` = 'Erreur - Âge de la ménopause doit être entre 10 et 100!'
WHERE `i18n`.`id` = 'error_range_ageatmenopause';

-- Remove picture field from research study form
DELETE FROM `structure_formats` WHERE `structure_formats`.`structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `tablename` = 'ed_all_study_research' AND `field` = 'file_name');
DELETE FROM `structure_fields` WHERE `tablename` = 'ed_all_study_research' AND `field` = 'file_name';

-- Fix tablename change for event study
UPDATE `structure_fields` SET `tablename` = 'ed_all_study_researches' WHERE `tablename` = 'ed_all_study_research';
UPDATE `event_controls` SET `detail_tablename` = 'ed_all_study_researches' 
WHERE `form_alias` = 'ed_all_study_research' AND `detail_tablename` = 'ed_all_study_research';

-- Dropping provider tables
DROP TABLE `providers`;
DROP TABLE `providers_revs`;


-- realiquot in batch
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`)VALUES 
(NULL , '1', 'realiquot', '/inventorymanagement/aliquot_masters/realiquotInit/', '1');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('realiquot_into', '', '', 'Inventorymanagement.AliquotMaster::getRealiquotDropdown');

INSERT INTO structures(`alias`) VALUES ('realiquot_init');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('', '0', '', 'realiquot_into', '', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='realiquot_into') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='realiquot_init'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ids' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_init'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='realiquot_into' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='realiquot_into')  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('realiquot_vol');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='realiquot_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  ), '1', '5000', '', '1', 'parent used volume', '0', '', '0', '', '1', 'float', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('realiquot');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='realiquot'), (SELECT id FROM structure_fields WHERE `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  ), '1', '5100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0');


