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
UPDATE structure_formats SET `display_order`='1201' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));
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

INSERT INTO structures(`alias`) VALUES ('aliquot_type_selection');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('', '0', '', 'realiquot_into', '', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='realiquot_into') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_type_selection'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ids' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_type_selection'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='realiquot_into' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='realiquot_into')  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('realiquot_vol');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='realiquot_vol'), (SELECT id FROM structure_fields WHERE `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  ), '1', '5000', '', '1', 'parent used volume', '0', '', '0', '', '1', 'float', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('realiquot');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='realiquot'), (SELECT id FROM structure_fields WHERE `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  ), '1', '5100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0');

-- Update the tablename for EventDetail models
UPDATE `structure_fields` SET `tablename` = 'ed_breast_lab_pathologies'
WHERE `tablename` = 'ed_breast_lab_pathology';

UPDATE `structure_fields` SET `tablename` = 'ed_all_clinical_followups'
WHERE `tablename` = 'ed_all_clinical_followup';

UPDATE `structure_fields` SET `tablename` = 'ed_all_clinical_presentations'
WHERE `tablename` = 'ed_all_clinical_presentation';

UPDATE `structure_fields` SET `tablename` = 'ed_all_lifestyle_smokings'
WHERE `tablename` = 'ed_all_lifestyle_smoking';

UPDATE `structure_fields` SET `tablename` = 'ed_breast_screening_mammograms'
WHERE `tablename` = 'ed_breast_screening_mammogram';

-- Delete depricated annotation events. Forms are no longer in the system or in use.
DELETE FROM `event_controls`
WHERE `form_alias` = 'ed_all_adverse_events_adverse_event';

DELETE FROM `event_controls`
WHERE `form_alias` = 'ed_all_protocol_followup';

-- Fix breast path report form. Two fields mistakenly dropped in previous version.
INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(NULL , '', 'Clinicalannotation', 'EventDetail', 'ed_breast_lab_pathologies', 'frozen_section', 'frozen section', '', 'input', 'size=20', '', NULL , 'help_frozen section', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(NULL , '', 'Clinicalannotation', 'EventDetail', 'ed_breast_lab_pathologies', 'resection_margins', 'resection_margin', '', 'input', 'size=20', '', NULL , 'help_resection margin', 'open', 'open', 'open', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

INSERT INTO `structure_formats` (`id`, `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(NULL, (SELECT `id` FROM `structures` WHERE `alias` = 'ed_breast_lab_pathology'), (SELECT `id` FROM `structure_fields` WHERE `tablename` = 'ed_breast_lab_pathologies' AND `field` = 'frozen_section'), '2', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
(NULL, (SELECT `id` FROM `structures` WHERE `alias` = 'ed_breast_lab_pathology'), (SELECT `id` FROM `structure_fields` WHERE `tablename` = 'ed_breast_lab_pathologies' AND `field` = 'resection_margins'), '2', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- Add value domain for Canadian Provinces and Territories
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(NULL , 'provinces', 'locked', '', NULL);
SET @VD_ID= LAST_INSERT_ID();

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'british columbia', 'british columbia');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 2, 1, 'british columbia');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'alberta', 'alberta');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 1, 1, 'alberta');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'saskatchewan', 'saskatchewan');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 12, 1, 'saskatchewan');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'manitoba', 'manitoba');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 3, 1, 'manitoba');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'ontario', 'ontario');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 9, 1, 'ontario');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'quebec', 'quebec');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 11, 1, 'quebec');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'nova scotia', 'nova scotia');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 7, 1, 'nova scotia');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'new brunswick', 'new brunswick');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 4, 1, 'new brunswick');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'newfoundland', 'newfoundland');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 5, 1, 'newfoundland');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'prince edward island', 'prince edward island');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 10, 1, 'prince edward island');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'yukon', 'yukon');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 13, 1, 'yukon');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'northwest territories', 'northwest territories');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 6, 1, 'northwest territories');

INSERT INTO `structure_permissible_values` (`id`, `value`, `language_alias`) VALUES
(NULL, 'nunavut', 'nunavut');
SET @PV_ID= LAST_INSERT_ID();
INSERT INTO `structure_value_domains_permissible_values` (`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `language_alias`) VALUES
(NULL, @VD_ID, @PV_ID, 8, 1, 'nunavut');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('british columbia', 'British Columbia', 'Colombie britannique'),
('alberta', 'Alberta', 'Alberta'), 
('saskatchewan', 'Saskatchewan', 'Saskatchewan'), 
('manitoba', 'Manitoba', 'Manitoba'), 
('ontario', 'Ontario', 'Ontario'), 
('quebec', 'Quebec', ''), 
('nova scotia', 'Nova Scotia', 'Nouvelle-Écosse'), 
('new brunswick', 'New Brunswick', 'Nouveau-Brunswick'), 
('newfoundland', 'Newfoundland', 'Terre-Neuve et Labrador'), 
('prince edward island', 'Prince Edward Island', 'l''île du Prince-Édouard'), 
('yukon', 'Yukon Territory', '(territoire du) Yukon'), 
('northwest territories', 'Northwest Territories', '(territoires du) Nord-Ouest'), 
('nunavut', 'Nunavut', 'Nunavut');

-- Link province value domain to contact form, user profile and study
UPDATE `structure_fields` 
SET `type` = 'select', `setting` = '', `value_domain_control` = 'locked', `structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'provinces')
WHERE `structure_fields`.`tablename` = 'users' AND `structure_fields`.`field` = 'region' AND `structure_fields`.`type` = 'input';

UPDATE `structure_fields` 
SET `type` = 'select', `setting` = '', `value_domain_control` = 'locked', `structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'provinces')
WHERE `structure_fields`.`tablename` = 'participant_contacts' AND `structure_fields`.`field` = 'region' AND `structure_fields`.`type` = 'input';

UPDATE `structure_fields` 
SET `type` = 'select', `setting` = '', `value_domain_control` = 'locked', `structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'provinces')
WHERE `structure_fields`.`tablename` = 'study_contacts' AND `structure_fields`.`field` = 'address_province' AND `structure_fields`.`type` = 'input';

ALTER TABLE aliquot_review_masters
 DROP FOREIGN KEY FK_aliquot_review_masters_aliquot_masters,
 CHANGE aliquot_masters_id aliquot_master_id INT DEFAULT NULL,
 ADD FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters`(`id`);
 
ALTER TABLE datamart_batch_sets
 ADD COLUMN locked BOOLEAN NOT NULL DEFAULT false AFTER flag_use_query_results;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Datamart', 'BatchSet', 'datamart_batch_sets', 'locked', 'locked', '', 'checkbox', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='querytool_batch_set '), (SELECT id FROM structure_fields WHERE `model`='BatchSet' AND `tablename`='datamart_batch_sets' AND `field`='locked' AND `language_label`='locked' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

DELETE FROM structure_validations WHERE language_message IN('barcode size is limited', 'barcode is required') AND structure_field_id=(SELECT id FROM structure_fields WHERE field='created' AND model='AliquotMaster' AND type='datetime'); 


INSERT INTO structures(`alias`) VALUES ('in_stock_detail');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='in_stock_detail'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail')  ), '1', '1', '', '1', 'in stock detail', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='in_stock_detail'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  ), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0');

DROP VIEW view_structure_formats_simplified;
CREATE VIEW view_structure_formats_simplified AS 
SELECT str.alias AS structure_alias, sfo.id AS structure_format_id, sfi.id AS structure_field_id, sfo.structure_id AS structure_id,
sfi.plugin AS plugin, sfi.model AS model, sfi.tablename AS tablename, sfi.field AS field, sfi.structure_value_domain AS structure_value_domain, svd.domain_name AS structure_value_domain_name,
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
INNER JOIN structure_fields AS sfi ON sfo.structure_field_id=sfi.id
INNER JOIN structures AS str ON str.id = sfo.structure_id
LEFT JOIN structure_value_domains AS svd ON svd.id = sfi.structure_value_domain;

-- derivatives in batch
INSERT INTO datamart_structure_functions (datamart_structure_id, label, link, flag_active) VALUES
((SELECT id FROM datamart_structures WHERE model='ViewSample'), 'create derivative', '/inventorymanagement/sample_masters/batchDerivativeInit/', true);
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('derivative', '', '', 'Inventorymanagement.SampleMaster::getDerivativesDropdown');

INSERT INTO structures(`alias`) VALUES ('derivative_init');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'SampleMaster', 'sample_masters', 'sample_control_id', '', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='derivative') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='derivative_init'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_control_id' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='derivative')  AND `language_help`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET flag_addgrid='1' WHERE structure_id IN(SELECT id FROM structures WHERE alias IN(SELECT form_alias FROM sample_controls)) AND flag_add='1';
UPDATE structure_formats SET flag_addgrid_readonly='1' WHERE structure_id IN(SELECT id FROM structures WHERE alias IN(SELECT form_alias FROM sample_controls)) AND flag_add_readonly='1';

INSERT INTO structures(`alias`) VALUES ('sample_masters');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `language_label`='copy control' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `language_help`=''), '1', '10000', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0');
UPDATE sample_controls SET form_alias=CONCAT('sample_masters,', form_alias);

UPDATE structure_fields SET  `language_label`='',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='datamart_browser_options')  WHERE model='Browser' AND tablename='' AND field='search_for' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='datamart_browser_options');

DROP VIEW view_structures;

-- validation refactoring
INSERT INTO structure_validations (structure_field_id, rule, on_action, language_message) 
(SELECT structure_field_id, 'notEmpty', on_action, language_message FROM structure_validations WHERE flag_not_empty='1');
ALTER TABLE structure_validations
 DROP COLUMN flag_not_empty,
 DROP COLUMN flag_required; 
DELETE FROM structure_validations WHERE rule='' or rule LIKE ('maxLength%');

-- aliquots in batch (from samples)
INSERT INTO datamart_structure_functions (datamart_structure_id, label, link, flag_active) VALUES
((SELECT id FROM datamart_structures WHERE model='ViewSample'), 'create aliquots', '/inventorymanagement/aliquot_masters/batchAddInit/', true);

UPDATE structure_fields SET `default`='yes - available' WHERE field='in_stock' and model='AliquotMaster';

-- removing storage code from aliquot_masters
-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Storagelayout' AND `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='code' AND `language_label`='storage code' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open');

-- fixing storage type to use id
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Storagelayout', 'StorageMaster', 'storage_masters', 'storage_control_id', 'storage type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='storage_type') , '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_type') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='storagemasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='storage_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='storage_type'));
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_type') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='std_undetail_stg_with_surr_tmp') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='storage_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='storage_type'));
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_type') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='children_storages') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='storage_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='storage_type'));
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_type') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='std_incubators') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='storage_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='storage_type'));
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_type') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='std_rooms') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='storage_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='storage_type'));
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_type') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='storage_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='storage_type'));
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_type') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='storage_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='storage_type'));
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='storage_control_id' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='storage_type') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='storage_masters_for_storage_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='StorageMaster' AND tablename='storage_masters' AND field='storage_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='storage_type'));

UPDATE structure_fields SET `default`='yes - available' WHERE field='in_stock' and model='AliquotMaster';

UPDATE menus SET display_order = '1' WHERE use_link LIKE '/datamart/%' AND language_title LIKE 'data browser';
UPDATE menus SET display_order = '2' WHERE use_link LIKE '/datamart/%' AND language_title LIKE 'adhoc';
UPDATE menus SET display_order = '3' WHERE use_link LIKE '/datamart/%' AND language_title LIKE 'batch sets';
UPDATE menus SET display_order = '4' WHERE use_link LIKE '/datamart/%' AND language_title LIKE 'reports';
UPDATE menus SET use_link = '/datamart/browser/index' WHERE id = 'qry-CAN-1';

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('batch actions', 'Batch Actions', 'Traitement par lot'),
('batchset','Batchset','Lot de données'),
('create aliquots','Create Aliquots','Créer aliquots'),
('create derivative','Create Derivative' ,'Créer dérivés'),
('error_participant identifier required','The participant identifier is required!','L''identifiant du participant est requis!'),
('invalid date','Invalid Date','Date invalide'),
('invalid datetime','Invalid Datetime','Date et heure invalides'),
('no data matches your search parameters','No data matches your search parameters!','Aucune données ne correspond à vos critères de recherche!'),
('select an action','Select An Action','Sélectionner une action'),
('the string length must not exceed %d characters','The string length must not exceed %d characters!',
'La longueur de la chaîne de caractères ne doit pas dépasser %d caractères!'),
('this field is required','This field is required!','Ce champ est requis!'),
('you cannot browse to the requested entities because there is no [%s] matching your request',
'You cannot browse to the requested entities because there is no [%s] matching your request!',
'Vous ne pouvez pas naviguer vers les entités demandées parce qu''il n''y a pas de [%s] correspondant à votre requête!');

-- datamart menu
UPDATE menus SET use_link='/menus/datamart/' WHERE id='qry-CAN-1'; 
UPDATE menus SET language_description='allows you to browse from one data type to another through various search forms. This tool is flexible and made for general use.' WHERE id='qry-CAN-1-1';
UPDATE menus SET language_description='allows you to build result sets with custom queries. This tool is not flexible.' WHERE id='qry-CAN-2';
UPDATE menus SET language_description='lists the already created batch sets' WHERE id='qry-CAN-3';
UPDATE menus SET language_description='allows you to generate various reports based on ATiM data' WHERE id='qry-CAN-1-2 ';

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('storage_master_id') AND tablename IN ('aliquot_masters','tma_slides'));
DELETE FROM structure_fields WHERE field IN ('storage_master_id') AND tablename IN ('aliquot_masters','tma_slides');

DELETE FROM i18n WHERE id IN ('an aliquot being not in stock can not be linked to a storage',
'only sample core can be stored into tma block',
'an x coordinate does not match format',
'an y coordinate does not match format',
'an x coordinate needs to be defined',
'an y coordinate needs to be defined',
'no x coordinate has to be recorded when no storage is selected',
'no y coordinate has to be recorded when no storage is selected',
'more than one storages matche the selection label [%s]',
'no storage matches the selection label [%s]',
'the barcode [%s] has already been recorded',
'you can not record barcode [%s] twice','no aliquot has been defined as source aliquot',
'see line %s');

INSERT IGNORE INTO i18n (id,en,fr) VALUES
	('an aliquot being not in stock can not be linked to a storage', 'An aliquot flagged ''Not in stock'' cannot also have storage location and label completed.', 'Un aliquot non en stock ne peut être attaché à un entreposage!'),
('only sample core can be stored into tma block','Only sample core can be stored into tma block!', 'Seules les cores d''échantillons peuvent être entreposés dans des blocs de TMA!'),
	('an x coordinate does not match format', 'An x coordinate does not match format!', 'Le format d''une coordonnée x n''est pas bon!'),
	('an y coordinate does not match format', 'An y coordinate does not match format!', 'Le format d''une coordonnée y n''est pas bon!'),
	('an x coordinate needs to be defined', 'An x coordinate needs to be defined!', 'Une coordonnée x doit être définie!'),
	('an y coordinate needs to be defined', 'An y coordinate needs to be defined!', 'Une coordonnée y doit être définie!'),
	('no x coordinate has to be recorded when no storage is selected', 'No x coordinate has to be recorded when no storage is selected!', 'Aucune coordonnée x ne doit être enregistrée si l''entreposage n''est pas sélectionné!'),
	('no y coordinate has to be recorded when no storage is selected', 'No y coordinate has to be recorded when no storage is selected!', 'Aucune coordonnée y ne doit être enregistrée si l''entreposage n''est pas sélectionné!'),
('more than one storages matche the selection label [%s]', 'More than one storages matche the selection label [%s]!', 'Plus d''un entreposage correspond à l''identifiant de sélection [%s]!'),
	('no storage matches the selection label [%s]', 'No storage matches the selection label [%s]!', 'Aucun entreposage ne correspond à l''identifiant de sélection [%s]!'),
('the barcode [%s] has already been recorded', 'The barcode [%s] has already been recorded!', 'Le barcode [%s] a déjà été enregistré!'),
('no aliquot has been defined as source aliquot', 'No aliquot has been defined as source aliquot!', 'Aucun aliquot n''a été défini comme aliquot source!'),
	('you can not record barcode [%s] twice', 'You can not record barcode [%s] twice!', 'Vous ne pouvez enregistrer le barcode [%s] deux fois!'),
	('see line %s', 'See ligne(s) %s!', 'Voir ligne(s) %s!');	 	

DELETE FROM `structure_validations`
WHERE `rule` LIKE 'custom,/^(?!err!).*$/';

ALTER TABLE storage_masters
 DROP COLUMN coord_x_order,
 DROP COLUMN coord_y_order; 
ALTER TABLE storage_masters_revs
 DROP COLUMN coord_x_order,
 DROP COLUMN coord_y_order; 
ALTER TABLE tma_slides
 DROP COLUMN coord_x_order,
 DROP COLUMN coord_y_order;  
ALTER TABLE tma_slides_revs
 DROP COLUMN coord_x_order,
 DROP COLUMN coord_y_order;  
ALTER TABLE aliquot_masters
 DROP COLUMN coord_x_order,
 DROP COLUMN coord_y_order;  
ALTER TABLE aliquot_masters_revs
 DROP COLUMN coord_x_order,
 DROP COLUMN coord_y_order; 
	
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('click to continue', 'Click to continue', 'Cliquez pour continuer');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Storagelayout', 'StorageMaster', '', 'layout_description', 'storage layout description', '', 'textarea', 'rows=2,cols=60', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp'), 
(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='' AND `field`='layout_description'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='std_undetail_stg_with_surr_tmp'), 
(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='' AND `field`='layout_description'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='std_rooms'), 
(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='' AND `field`='layout_description'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='std_incubators'), 
(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='' AND `field`='layout_description'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='std_tma_blocks'), 
(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='' AND `field`='layout_description'), 
'0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model = 'Generated' AND field IN ('coord_x_title', 'coord_x_type', 'coord_x_size', 'coord_y_title', 'coord_y_type', 'coord_y_size'));
DELETE FROM structure_fields WHERE model = 'Generated' AND field IN ('coord_x_title', 'coord_x_type', 'coord_x_size', 'coord_y_title', 'coord_y_type', 'coord_y_size');

UPDATE structure_fields
SET type = 'input', setting = 'size=4', language_label = 'position into parent storage'
WHERE tablename = 'storage_masters' AND field = 'parent_storage_coord_x';
UPDATE structure_fields
SET type = 'input', setting = 'size=4'
WHERE tablename = 'storage_masters' AND field = 'parent_storage_coord_y';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp'), 
(SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='FunctionManagement' AND `field`='recorded_storage_selection_label' ), 
'0', '12', '', '1', 'parent storage', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp'), 
(SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='parent_storage_coord_x' ), 
'0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='std_undetail_stg_with_tmp'), 
(SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='parent_storage_coord_y' ), 
'0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='std_undetail_stg_with_surr_tmp'), 
(SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='FunctionManagement' AND `field`='recorded_storage_selection_label' ), 
'0', '12', '', '1', 'parent storage', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='std_undetail_stg_with_surr_tmp'), 
(SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='parent_storage_coord_x' ), 
'0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='std_undetail_stg_with_surr_tmp'), 
(SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='parent_storage_coord_y' ), 
'0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='std_rooms'), 
(SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='FunctionManagement' AND `field`='recorded_storage_selection_label' ), 
'0', '12', '', '1', 'parent storage', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='std_rooms'), 
(SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='parent_storage_coord_x' ), 
'0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='std_rooms'), 
(SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='parent_storage_coord_y' ), 
'0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='std_incubators'), 
(SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='FunctionManagement' AND `field`='recorded_storage_selection_label' ), 
'0', '12', '', '1', 'parent storage', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='std_incubators'), 
(SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='parent_storage_coord_x' ), 
'0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='std_incubators'), 
(SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='parent_storage_coord_y' ), 
'0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='std_tma_blocks'), 
(SELECT id FROM structure_fields WHERE `plugin`='Storagelayout' AND `model`='FunctionManagement' AND `field`='recorded_storage_selection_label' ), 
'0', '12', '', '1', 'parent storage', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='std_tma_blocks'), 
(SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='parent_storage_coord_x' ), 
'0', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='std_tma_blocks'), 
(SELECT id FROM structure_fields WHERE `tablename`='storage_masters' AND `field`='parent_storage_coord_y' ), 
'0', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `tablename` LIKE 'storage_masters' AND `field` LIKE 'parent_id');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `tablename` LIKE 'storage_masters' AND `field` LIKE 'parent_id');
DELETE FROM structure_fields WHERE `tablename` LIKE 'storage_masters' AND `field` LIKE 'parent_id';

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('std_2_dim_position_selection', 'std_1_dim_position_selection'));
DELETE FROM structure_fields WHERE `field` LIKE 'parent_coord_x_title' AND `field` LIKE 'parent_coord_y_title';

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('storage layout description', 'Layout Description', 'Description de l''entreposage'),
('parent storage','Parent Storage','Entreposage Parent'),
('position into parent storage','Position Into Parent Storage','Position dans l''entreposage parent');

UPDATE structure_formats SET flag_edit = '0', flag_edit_readonly = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'selection_label' AND tablename = 'storage_masters')
AND structure_id IN (SELECT id FROM structures WHERE alias IN ('std_tma_blocks', 'std_incubators', 'std_rooms', 'std_undetail_stg_with_tmp', 'std_undetail_stg_with_surr_tmp'));

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('you can not define a tma block as a parent storage',
'You can not define a tma block as a parent storage!', 'Un bloc TMA ne peut être défini comme un entreposage ''parent''!'),
('you can not store your storage inside itself', 
'You can not store your storage inside itself!', 'L''entreposage étudié ne peut pas être entreposé à l''interieur de lui même!');

ALTER TABLE storage_controls
DROP COLUMN form_alias_for_children_pos;

INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id, derivative_sample_control_id, flag_active)
VALUES ((SELECT id FROM sample_controls WHERE sample_type = 'cell culture'),(SELECT id FROM sample_controls WHERE sample_type = 'protein'),0);

SET @domain_id = (SELECT id FROM `structure_value_domains` WHERE `domain_name` LIKE 'quality_control_type');
SET @value = 'agarose gel';
UPDATE `structure_value_domains_permissible_values` SET display_order = '1' WHERE `structure_value_domain_id` = @domain_id AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value = @value AND language_alias = @value);
SET @value = 'bioanalyzer';
UPDATE `structure_value_domains_permissible_values` SET display_order = '2' WHERE `structure_value_domain_id` = @domain_id AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value = @value AND language_alias = @value);
SET @value = 'pcr';
UPDATE `structure_value_domains_permissible_values` SET display_order = '5' WHERE `structure_value_domain_id` = @domain_id AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value = @value AND language_alias = @value);
SET @value = 'spectrophotometer';
UPDATE `structure_value_domains_permissible_values` SET display_order = '6' WHERE `structure_value_domain_id` = @domain_id AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value = @value AND language_alias = @value);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("immunohistochemistry", "immunohistochemistry");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="quality_control_type"),  (SELECT id FROM structure_permissible_values WHERE value="immunohistochemistry" AND language_alias="immunohistochemistry"), "4", "1");

ALTER TABLE quality_ctrls
	ADD `qc_type_precision` varchar(250) DEFAULT NULL AFTER `type`;
ALTER TABLE quality_ctrls_revs
	ADD `qc_type_precision` varchar(250) DEFAULT NULL AFTER `type`;

INSERT INTO structure_fields(`public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`) VALUES
('', 'Inventorymanagement', 'QualityCtrl', 'quality_ctrls', 'qc_type_precision', '', 'qc type precision', 'input', '', '',  NULL , '', 'open', 'open', 'open');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, 
`language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_index`, `flag_detail`) 
VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='qc_type_precision' AND `language_label`='' AND `language_tag`='qc type precision' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '10', 
'', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', 
'1', '0', '1', '0', '1', '0', '1', '1');
	
INSERT IGNORE INTO i18n (id, en, fr) VALUES
('immunohistochemistry', 'Immunohistochemistry', "Immunohistochimie"),
('qc type precision', 'Precision', "Précision");

UPDATE structure_formats SET display_order = '9' WHERE structure_id = (SELECT id FROM structures WHERE alias='qualityctrls') 
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='type');

INSERT IGNORE INTO i18n (id, en, fr) VALUES
('no aliquot displayed', 'No aliquot displayed', 'Aucun aliquot affiché'),
('only samples', 'Only Samples', 'Échantillons seulement'),
('samples & aliquots', 'Samples & Aliquots', 'Échantillons & Aliquots');

DELETE FROM structure_permissible_values_customs WHERE value LIKE 'custom_laboratory_staff_%';
DELETE FROM structure_permissible_values_customs WHERE value LIKE 'custom_laboratory_site_%';
DELETE FROM structure_permissible_values_customs WHERE value LIKE 'collection_site_%';
DELETE FROM structure_permissible_values_customs WHERE value LIKE 'custom_supplier_dept_%';

DELETE FROM structure_permissible_values_customs_revs WHERE value LIKE 'custom_laboratory_staff_%';
DELETE FROM structure_permissible_values_customs_revs WHERE value LIKE 'custom_laboratory_site_%';
DELETE FROM structure_permissible_values_customs_revs WHERE value LIKE 'collection_site_%';
DELETE FROM structure_permissible_values_customs_revs WHERE value LIKE 'custom_supplier_dept_%';

DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model = 'StructurePermissibleValuesCustom' AND field IN ('en', 'fr'))




