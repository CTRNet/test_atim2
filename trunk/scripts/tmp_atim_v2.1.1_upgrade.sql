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
ALTER TABLE structure_fields ADD COLUMN flag_confidential TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 AFTER field_control;

CREATE VIEW view_structure_formats_simplified AS 
SELECT sfo.id AS structure_format_id, sfi.id AS structure_field_id, sfo.structure_id AS structure_id,
sfi.plugin AS plugin, sfi.model AS model, sfi.tablename AS tablename, sfi.field AS field, sfi.structure_value_domain AS structure_value_domain,
sfi.flag_confidential AS flag_confidential,
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
(NULL , '1', 'realiquot', '/inventorymanagement/aliquot_masters/realiquotInit/creation/', '1');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('realiquot_into', '', '', 'Inventorymanagement.AliquotMaster::getRealiquotDropdown');

INSERT INTO structures(`alias`) VALUES ('aliquot_type_selection');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('', '0', '', 'realiquot_into', 'select children aliquot type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='realiquot_into') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_type_selection'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ids' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliquot_type_selection'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='realiquot_into' AND `language_label`='select children aliquot type' ), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

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
 
ALTER TABLE aliquot_review_masters_revs
 CHANGE aliquot_masters_id aliquot_master_id INT DEFAULT NULL;
 
ALTER TABLE datamart_batch_sets
 ADD COLUMN locked BOOLEAN NOT NULL DEFAULT false AFTER flag_use_query_results;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Datamart', 'BatchSet', 'datamart_batch_sets', 'locked', 'locked', '', 'checkbox', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='querytool_batch_set '), (SELECT id FROM structure_fields WHERE `model`='BatchSet' AND `tablename`='datamart_batch_sets' AND `field`='locked' AND `language_label`='locked' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

DELETE FROM structure_validations WHERE language_message IN('barcode size is limited', 'barcode is required') AND structure_field_id=(SELECT id FROM structure_fields WHERE field='created' AND model='AliquotMaster' AND type='datetime'); 


INSERT INTO structures(`alias`) VALUES ('in_stock_detail');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='in_stock_detail'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail')  ), '1', '1', '', '1', 'aliquot in stock detail', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='in_stock_detail'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  ), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0');

DROP VIEW view_structure_formats_simplified;
CREATE VIEW view_structure_formats_simplified AS 
SELECT str.alias AS structure_alias, sfo.id AS structure_format_id, sfi.id AS structure_field_id, sfo.structure_id AS structure_id,
sfi.plugin AS plugin, sfi.model AS model, sfi.tablename AS tablename, sfi.field AS field, sfi.structure_value_domain AS structure_value_domain, svd.domain_name AS structure_value_domain_name,
sfi.flag_confidential AS flag_confidential,
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
((SELECT id FROM datamart_structures WHERE model='ViewSample'), 'create aliquots', '/inventorymanagement/aliquot_masters/addInit/', true);

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
('samples & aliquots', 'Samples & Aliquots', 'Échantillons & Aliquots'),
('custom queries', 'Custom Queries', 'Requêtes personalisées');

UPDATE menus SET language_title='custom queries' WHERE id='qry-CAN-2';

DELETE FROM structure_permissible_values_customs WHERE value LIKE 'custom_laboratory_staff_%';
DELETE FROM structure_permissible_values_customs WHERE value LIKE 'custom_laboratory_site_%';
DELETE FROM structure_permissible_values_customs WHERE value LIKE 'collection_site_%';
DELETE FROM structure_permissible_values_customs WHERE value LIKE 'custom_supplier_dept_%';

DELETE FROM structure_permissible_values_customs_revs WHERE value LIKE 'custom_laboratory_staff_%';
DELETE FROM structure_permissible_values_customs_revs WHERE value LIKE 'custom_laboratory_site_%';
DELETE FROM structure_permissible_values_customs_revs WHERE value LIKE 'collection_site_%';
DELETE FROM structure_permissible_values_customs_revs WHERE value LIKE 'custom_supplier_dept_%';

DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE model = 'StructurePermissibleValuesCustom' AND field IN ('en', 'fr'));

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `use_link`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('err_cust_system_error', 1, 'system error', 'a system error has been detected', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);


UPDATE menus SET language_description = 'query tool data browser description' WHERE id = 'qry-CAN-1-1';
UPDATE menus SET language_description = 'query tool reports description' WHERE id = 'qry-CAN-1-2';
UPDATE menus SET language_description = 'query tool dadhoc description' WHERE id = 'qry-CAN-2';
UPDATE menus SET language_description = 'query tool batch sets description' WHERE id = 'qry-CAN-3';

INSERT IGNORE INTO i18n (id, en, fr) VALUES
('query tool data browser description', 
'Flexible tool used for running specific data research. The process enables the user to browse sequentially different data search forms.', 
'Outil flexible utilisé pour exécuter des recherches spécifiques de données. Le processus de navigation permet à l''utilisateur de parcourir successivement différents formulaires de recherche de données.'),

('query tool reports description', 
'Reports generated from recorded data.', 
'Rapports construits à partir des données enregistrées.'),

('query tool dadhoc description', 
'Custom queries used for searching specific data based on predefined criteria.', 
'Requêtes personnalisées utilisées pour rechercher des données spécifiques sur la base de critères prédéfinis.'),

('query tool batch sets description', 
'Dataset defined subsequently in order to process/analyze this data together: Data export, performing the same process on all, data sharing, etc..', 
'Ensemble de données défini ulterieurement dans le but de traiter/analyser ces données ensemble: Export de données, exécution d''un même processus sur l''ensemble des données, partage de données, etc.');

INSERT IGNORE INTO i18n (id, en, fr) VALUES 
('report','Report','Rapport'),
("link to current view", "Link to current view", "Lier à la vue courrante");

UPDATE structure_formats 
SET flag_summary = '0' 
WHERE structure_id = (SELECT id FROM structures WHERE alias='querytool_batch_set');

UPDATE structure_formats 
SET flag_summary = '1' 
WHERE structure_id = (SELECT id FROM structures WHERE alias='querytool_batch_set') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='BatchSet' AND `field` IN ('title', 'model', 'description'));

-- Fix issue 1275

ALTER TABLE participant_messages
 MODIFY `due_date` date  DEFAULT NULL;
ALTER TABLE participant_messages_revs
 MODIFY `due_date` date  DEFAULT NULL;

-- -----------------------------------------------------------------
-- change aliquot use data management
-- -----------------------------------------------------------------
 
-- 1- QC

ALTER TABLE quality_ctrl_tested_aliquots
	ADD `used_volume` decimal(10,5) DEFAULT NULL AFTER `aliquot_master_id`;
ALTER TABLE quality_ctrl_tested_aliquots_revs
	ADD `used_volume` decimal(10,5) DEFAULT NULL AFTER `aliquot_master_id`;

UPDATE quality_ctrl_tested_aliquots test_al, aliquot_uses al_use
SET test_al.used_volume = al_use.used_volume
WHERE test_al.aliquot_use_id  = al_use.id;

ALTER TABLE `quality_ctrl_tested_aliquots` DROP FOREIGN KEY FK_quality_ctrl_tested_aliquots_aliquot_uses; 
ALTER TABLE quality_ctrl_tested_aliquots DROP COLUMN aliquot_use_id;
ALTER TABLE quality_ctrl_tested_aliquots_revs DROP COLUMN aliquot_use_id;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'QualityCtrlTestedAliquot', 'quality_ctrl_tested_aliquots', 'used_volume', 'used volume', '', 'float_positive', 'size=5', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qctestedaliquots'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrlTestedAliquot' AND `tablename`='quality_ctrl_tested_aliquots' AND `field`='used_volume' AND `language_label`='used volume' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1');
-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qctestedaliquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='used_volume' AND `language_label`='used volume' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open');

DELETE FROM aliquot_uses WHERE use_recorded_into_table = 'quality_ctrl_tested_aliquots';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qctestedaliquots'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='id' ), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0');

-- 2-realiquoted to

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='in_stock_detail'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `language_label`='barcode' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '0', 'parent aliquot data update', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='in_stock_detail') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='in_stock' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values'));
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='in_stock_detail') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='in_stock_detail' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail'));

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='in_stock_detail'),
(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `field`='remove_from_storage' ), '1', '10', 
'', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('parent aliquot data update', 'Parent Aliquot Data For Update', 'Données aliquot parent pour mise à jour ');

ALTER TABLE realiquotings
	ADD `parent_used_volume` decimal(10,5) DEFAULT NULL AFTER `child_aliquot_master_id`,
	ADD `realiquoting_datetime` datetime DEFAULT NULL AFTER  `parent_used_volume`,
	ADD `realiquoted_by` varchar(50) DEFAULT NULL AFTER `realiquoting_datetime`;
ALTER TABLE realiquotings_revs
	ADD `parent_used_volume` decimal(10,5) DEFAULT NULL AFTER `child_aliquot_master_id`,
	ADD `realiquoting_datetime` datetime DEFAULT NULL AFTER  `parent_used_volume`,
	ADD `realiquoted_by` varchar(50) DEFAULT NULL AFTER `realiquoting_datetime`;

UPDATE realiquotings rlq, aliquot_uses al_use
SET rlq.parent_used_volume = al_use.used_volume, 
rlq.realiquoting_datetime = al_use.use_datetime, 
rlq.realiquoted_by = al_use.used_by
WHERE rlq.aliquot_use_id  = al_use.id;

ALTER TABLE `realiquotings` DROP FOREIGN KEY FK_realiquotings_aliquot_uses; 
ALTER TABLE realiquotings DROP COLUMN aliquot_use_id;
ALTER TABLE realiquotings_revs DROP COLUMN aliquot_use_id;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'Realiquoting', 'realiquotings', 'parent_used_volume', 'parent used volume', '', 'float_positive', 'size=5', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='children_aliquots_selection'), (SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `field`='parent_used_volume'), 
'1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0');
-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='children_aliquots_selection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='AliquotUse' AND `tablename`='aliquot_uses' AND `field`='used_volume' AND `language_label`='used volume' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open');

DELETE FROM aliquot_uses WHERE use_recorded_into_table = 'realiquotings';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'Realiquoting', 'realiquotings', 'realiquoting_datetime', 'realiquoting date', '', 'datetime', '', '',  NULL , ''), 
('Inventorymanagement', 'Realiquoting', 'realiquotings', 'realiquoted_by', 'realiquoted by', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoting_datetime' AND `type`='datetime' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='children_aliquots_selection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotUse' AND tablename='aliquot_uses' AND field='use_datetime' AND type='datetime' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoted_by' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='children_aliquots_selection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotUse' AND tablename='aliquot_uses' AND field='used_by' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));

UPDATE structure_formats 
SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoted_by' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') ) 
WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotUse' AND tablename='aliquot_uses' AND field='used_by' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));
UPDATE structure_formats 
SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='parent_used_volume' AND `type`='float_positive' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotUse' AND tablename='aliquot_uses' AND field='used_volume' AND type='float_positive' AND structure_value_domain  IS NULL );
UPDATE structure_formats 
SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoting_datetime' AND `type`='datetime' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotUse' AND tablename='aliquot_uses' AND field='use_datetime' AND type='datetime' AND structure_value_domain  IS NULL );

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('no volume has to be recorded when the volume unit field is empty', 'No volume has to be recorded when the volume unit field is empty!', 'Aucun volume ne doit être enregistré losque le champ ''unité'' est vide!'),
('no new aliquot could be actually defined as realiquoted child for the following parent aliquot(s)', 'No new aliquot could be actually defined as realiquoted child for the following parent aliquot(s)', 
'Aucun nouvel aliquot ne peut actuellement être défini comme aliquot ré-aliquoté ''enfant'' pour les aliquots ''parents'' suivants');

-- 3-source aliquot

ALTER TABLE source_aliquots
	ADD `used_volume` decimal(10,5) DEFAULT NULL AFTER `aliquot_master_id`;
ALTER TABLE source_aliquots_revs
	ADD `used_volume` decimal(10,5) DEFAULT NULL AFTER `aliquot_master_id`;

UPDATE source_aliquots s_al, aliquot_uses al_use
SET s_al.used_volume = al_use.used_volume
WHERE s_al.aliquot_use_id  = al_use.id;

ALTER TABLE `source_aliquots` DROP FOREIGN KEY FK_source_aliquots_aliquot_uses; 
ALTER TABLE source_aliquots DROP COLUMN aliquot_use_id;
ALTER TABLE source_aliquots_revs DROP COLUMN aliquot_use_id;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'SourceAliquot', 'aliquot_sources', 'used_volume', 'used volume', '', 'float_positive', 'size=5', '',  NULL , '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='SourceAliquot' AND `tablename`='aliquot_sources' AND `field`='used_volume' AND `type`='float_positive' AND `structure_value_domain` IS NULL ) WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotUse' AND tablename='aliquot_uses' AND field='used_volume' AND type='float_positive' AND structure_value_domain  IS NULL );

DELETE FROM aliquot_uses WHERE use_recorded_into_table = 'source_aliquots';

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sourcealiquots'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='id' ), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0');

-- 4 - shipment

ALTER TABLE `order_items` DROP FOREIGN KEY FK_order_items_aliquot_uses; 
ALTER TABLE order_items DROP COLUMN aliquot_use_id;
ALTER TABLE order_items_revs DROP COLUMN aliquot_use_id;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='shippeditems'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='id' ), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Order', 'OrderItem', 'order_items', 'id', '', '', 'hidden', '', '',  NULL , ''), 
('Order', 'OrderLine', 'order_lines', 'id', '', '', 'hidden', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='id' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='id' AND `language_label`='' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0');

DELETE FROM aliquot_uses WHERE use_recorded_into_table = 'order_items';

-- 5 - path review

ALTER TABLE `aliquot_review_masters` DROP FOREIGN KEY FK_aliquot_review_masters_aliquot_uses; 
ALTER TABLE aliquot_review_masters DROP COLUMN aliquot_use_id;
ALTER TABLE aliquot_review_masters_revs DROP COLUMN aliquot_use_id;

UPDATE structure_fields SET field = 'aliquot_master_id' WHERE field = 'aliquot_masters_id';

DELETE FROM aliquot_uses WHERE use_recorded_into_table = 'aliquot_review_masters';

-- 6 - internal uses 

ALTER TABLE aliquot_uses DROP COLUMN use_definition;
ALTER TABLE aliquot_uses_revs DROP COLUMN use_definition;

RENAME TABLE aliquot_uses TO aliquot_internal_uses;
RENAME TABLE aliquot_uses_revs TO aliquot_internal_uses_revs;

ALTER TABLE aliquot_internal_uses DROP COLUMN use_recorded_into_table;
ALTER TABLE aliquot_internal_uses_revs DROP COLUMN use_recorded_into_table;

-- VIEW

DROP VIEW IF EXISTS view_aliquot_uses;
CREATE VIEW view_aliquot_uses AS 

SELECT aliq.id AS aliquot_master_id,
'sample derivative creation' AS use_definition, 
samp.sample_code AS use_code,
'' AS use_details,
source.used_volume,
aliq.aliquot_volume_unit,
der.creation_datetime AS use_datetime,
der.creation_by AS used_by,
source.created,
CONCAT('|inventorymanagement|aliquot_masters|listAllSourceAliquots|',samp.collection_id ,'|',samp.id) AS detail_url
FROM source_aliquots AS source
INNER JOIN sample_masters AS samp ON samp.id = source.sample_master_id  AND samp.deleted != 1
INNER JOIN derivative_details AS der ON samp.id = der.sample_master_id  AND der.deleted != 1
INNER JOIN aliquot_masters AS aliq ON aliq.id = source.aliquot_master_id AND aliq.deleted != 1
WHERE source.deleted != 1

UNION ALL

SELECT parent.id AS aliquot_master_id,
'realiquoted to' AS use_definition, 
child.barcode AS use_code,
'' AS use_details,
realiq.parent_used_volume AS used_volume,
parent.aliquot_volume_unit,
realiq.realiquoting_datetime AS use_datetime,
realiq.realiquoted_by AS used_by,
realiq.created,
CONCAT('|inventorymanagement|aliquot_masters|listAllRealiquotedParents|',child.collection_id,'|',child.sample_master_id,'|',child.id) AS detail_url
FROM realiquotings AS realiq
INNER JOIN aliquot_masters AS parent ON parent.id = realiq.parent_aliquot_master_id AND parent.deleted != 1
INNER JOIN aliquot_masters AS child ON child.id = realiq.child_aliquot_master_id AND child.deleted != 1
WHERE realiq.deleted != 1

UNION ALL

SELECT aliq.id AS aliquot_master_id,
'quality control' AS use_definition, 
qc.qc_code AS use_code,
'' AS use_details,
tested.used_volume,
aliq.aliquot_volume_unit,
qc.date AS use_datetime,
qc.run_by AS used_by,
tested.created,
CONCAT('|inventorymanagement|quality_ctrls|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',qc.id) AS detail_url
FROM quality_ctrl_tested_aliquots AS tested
INNER JOIN aliquot_masters AS aliq ON aliq.id = tested.aliquot_master_id AND aliq.deleted != 1
INNER JOIN quality_ctrls AS qc ON qc.id = tested.quality_ctrl_id AND qc.deleted != 1
WHERE tested.deleted != 1

UNION ALL

SELECT aliq.id AS aliquot_master_id,
'aliquot shipment' AS use_definition, 
sh.shipment_code AS use_code,
'' AS use_details,
'' AS used_volume,
'' AS aliquot_volume_unit,
sh.datetime_shipped AS use_datetime,
sh.shipped_by AS used_by,
sh.created,
CONCAT('|order|shipments|detail|',sh.order_id,'|',sh.id) AS detail_url
FROM order_items AS item
INNER JOIN aliquot_masters AS aliq ON aliq.id = item.aliquot_master_id AND aliq.deleted != 1
INNER JOIN shipments AS sh ON sh.id = item.shipment_id AND sh.deleted != 1
WHERE item.deleted != 1

UNION ALL

SELECT aliq.id AS aliquot_master_id,
'specimen review' AS use_definition, 
spr.review_code AS use_code,
'' AS use_details,
'' AS used_volume,
'' AS aliquot_volume_unit,
spr.review_date AS use_datetime,
'' AS used_by,
alr.created,
CONCAT('|inventorymanagement|specimen_reviews|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',spr.id) AS detail_url
FROM aliquot_review_masters AS alr
INNER JOIN aliquot_masters AS aliq ON aliq.id = alr.aliquot_master_id AND aliq.deleted != 1
INNER JOIN specimen_review_masters AS spr ON spr.id = alr.specimen_review_master_id AND spr.deleted != 1
WHERE alr.deleted != 1

UNION ALL

SELECT aliq.id AS aliquot_master_id,
'internal use' AS use_definition, 
aluse.use_code,
aluse.use_details,
aluse.used_volume,
aliq.aliquot_volume_unit,
aluse.use_datetime,
aluse.used_by,
aluse.created,
CONCAT('|inventorymanagement|aliquot_masters|detailAliquotInternalUse|',aliq.id,'|',aluse.id) AS detail_url
FROM aliquot_internal_uses AS aluse
INNER JOIN aliquot_masters AS aliq ON aliq.id = aluse.aliquot_master_id AND aliq.deleted != 1
WHERE aluse.deleted != 1;

INSERT INTO structures(`alias`) VALUES ('viewaliquotuses');

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, '', 'Inventorymanagement', 'ViewAliquotUse', 'view_aliquot_uses', 'use_definition', 'use', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'aliquot_use_definition'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null,'', 'Inventorymanagement', 'ViewAliquotUse', 'view_aliquot_uses', 'use_code', '', 'code', 'input', 'size=30', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewAliquotUse', 'view_aliquot_uses', 'use_details', 'details', '', 'textarea', 'cols=50,rows=5', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewAliquotUse', 'view_aliquot_uses', 'used_volume', 'used volume', '', 'float_positive', 'size=5', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewAliquotUse', 'view_aliquot_uses', 'aliquot_volume_unit', 'volume unit', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'aliquot_volume_unit'), '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewAliquotUse', 'view_aliquot_uses', 'use_datetime', 'date', '', 'datetime', '', '', NULL, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewAliquotUse', 'view_aliquot_uses', 'used_by', 'used by', '', 'select', '', '', 174, '', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(null, '', 'Inventorymanagement', 'ViewAliquotUse', 'view_aliquot_uses', 'created', 'created (into the system)', '', 'datetime', '', '', NULL, 'help_created', 'open', 'open', 'open', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_definition'), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_code'), '0', '1', '', '0', '', '1', ':', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_details'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='used_volume'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='aliquot_volume_unit'), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='used_by'), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='created'), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='viewaliquotuses'), 
(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_datetime'), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("specimen review", "specimen review");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="aliquot_use_definition"),  (SELECT id FROM structure_permissible_values WHERE value="specimen review" AND language_alias="specimen review"), "-1", "1");

UPDATE structures SET alias = 'aliquotinternaluses' WHERE alias = 'aliquotuses';
UPDATE structure_fields SET model = 'AliquotInternalUse' WHERE model = 'AliquotUse';
UPDATE structure_fields SET tablename = 'aliquot_internal_uses' WHERE tablename = 'aliquot_uses';
DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields 
WHERE `plugin`='Inventorymanagement' AND `model`='AliquotInternalUse' AND `field`='use_definition');
DELETE FROM structure_fields 
WHERE `plugin`='Inventorymanagement' AND `model`='AliquotInternalUse' AND `field`='use_definition';
UPDATE structure_fields SET language_label = 'aliquot internal use code', language_tag = '' WHERE field = 'use_code' AND `model`='AliquotInternalUse';
UPDATE structure_formats 
SET `flag_override_tag`='0', `language_tag`='' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotInternalUse' AND tablename='aliquot_internal_uses' AND field='use_code');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'aliquotuses_system_dependent');
DELETE FROM structures WHERE alias = 'aliquotuses_system_dependent';

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE model='AliquotInternalUse' AND field='use_code'), 'notEmpty', '', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('aliquot internal use code', 'Code', 'Code');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('derivative creation data exists for the deleted aliquot', '', 
'Your data cannot be deleted! <br>Derivative creation data exists for the deleted aliquot.', 
'Vos données ne peuvent être supprimées! <br>Des données création d''un dérivé existe pour votre aliquot.'),
('quality control data exists for the deleted aliquot', '', 
'Your data cannot be deleted! <br>Quality control data exists for the deleted aliquot.', 
'Vos données ne peuvent être supprimées! <br>Des données de contrôle de qualité existent pour votre aliquot.');

UPDATE structure_fields 
SET model = 'AliquotMaster', field = 'use_counter', type = 'integer_positive', setting = 'size=5'
WHERE model = 'Generated' AND field = 'aliquot_use_counter';

ALTER TABLE aliquot_masters
	ADD `use_counter` int(6) DEFAULT NULL AFTER `in_stock_detail`;
ALTER TABLE aliquot_masters_revs
	ADD `use_counter` int(6) DEFAULT NULL AFTER `in_stock_detail`;

UPDATE aliquot_masters as aliq, (SELECT aliquot_master_id, count(*) AS use_nbr FROM view_aliquot_uses GROUP BY aliquot_master_id) AS uses
SET aliq.use_counter = uses.use_nbr
WHERE aliq.id = uses.aliquot_master_id
AND aliq.deleted != 1;

UPDATE datamart_structures 
SET model = 'ViewAliquotUse', 
structure_id = (SELECT id FROM structures WHERE alias = 'viewaliquotuses'),
use_key = 'aliquot_master_id'
WHERE model = 'AliquotUse';
UPDATE datamart_browsing_controls SET use_field = 'ViewAliquotUse.aliquot_master_id' WHERE use_field = 'AliquotUse.aliquot_master_id';

-- -----------------------------------------------------------------
-- end change aliquot use data management
-- -----------------------------------------------------------------
INSERT INTO structures(`alias`) VALUES ('realiquot_with_vol');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='realiquot_with_vol'), 
(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoting_datetime' AND `language_label`='realiquoting date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1011', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_with_vol'), 
(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoted_by' AND `language_label`='realiquoted by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `language_help`=''), '1', '1012', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_with_vol'), 
(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='parent_used_volume' AND `language_label`='parent used volume' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1013', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_with_vol'), 
(SELECT id FROM structure_fields WHERE `model`='GeneratedParentAliquot' AND `tablename`='' AND `field`='aliquot_volume_unit' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit')  AND `language_help`=''), '1', '1014', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('realiquot_without_vol');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='realiquot_without_vol'), 
(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoting_datetime' AND `language_label`='realiquoting date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '1011', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquot_without_vol'), 
(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoted_by' AND `language_label`='realiquoted by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `language_help`=''), '1', '1012', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'realiquot');
DELETE FROM structures WHERE alias = 'realiquot';
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'realiquot_vol');
DELETE FROM structures WHERE alias = 'realiquot_vol';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'sample_master_id', 'sample master id', '', 'hidden', '', '',  NULL , ''), 
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'collection_id', 'collection id', '', 'hidden', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='in_stock_detail'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sample_master_id' AND `language_label`='sample master id' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='in_stock_detail'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='collection_id' AND `language_label`='collection id' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='in_stock_detail') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='in_stock_detail' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail'));

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('realiquoting process', 'Realiquoting Process', 'Processus de ré-aliquotage'),
('selection', 'Selection', 'Sélection'),
('select children aliquot type', 'Children Aliquot Type', 'Type de l''aliquot enfant'),
('creation', 'Creation', 'Création'),
('you cannot realiquot those elements together because they are of different types', 
'You cannot realiquot those elements together because they are not both same sample type and aliquot type! ', 
'Vous ne pouvez pas réalqiuoter ces éléments ensembles car ce ne sont pas et le même type d''échantillon et le même type d''aliquot!'),
('at least one child has not been defined', 'At least one child has not been defined!', 'Au moins un enfant doit être défini!'),
('at least one child has to be created', 'At least one child has to be created!', 'Au moins un enfant doit être créé!'),
('see # %s', 'See # %s!', 'Voir # %s!'),
("due to your restriction on confidential data, your search did not return confidential identifiers", "Due to your restriction on confidential data, your search did not return confidential identifiers", "Étant donné votre restriction sur les données confidentielles, les identifiants confidentiels ne sont pas inclus dans le résultat de votre recherche"),
("access denied", "Access denied", "Accès non autorisé"),
("you are not authorized to reach that page because you cannot input data into confidential fields", "You are not authorized to reach that page because you cannot input data into confidential fields", "Vous n'êtes pas autorisé à atteindre cette page car vous ne pouvez pas entrer d'information dans les champs confidentiels"),
("show confidential information", "Show confidential information", "Afficher l'information confidentielle"),
("permissions control panel", "Permissions control panel", "Panneau de contrôle des permissions"); 


ALTER TABLE groups ADD COLUMN flag_show_confidential TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 AFTER bank_id;
INSERT INTO structures(`alias`) VALUES ('permissions2');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Administrate', 'Group', 'groups', 'flag_show_confidential', 'show confidential information', '', 'checkbox', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='permissions2'), (SELECT id FROM structure_fields WHERE `model`='Group' AND `tablename`='groups' AND `field`='flag_show_confidential' AND `language_label`='show confidential information' AND `language_tag`='' AND `type`='checkbox' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='permissions') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Administrate' AND `model`='Permission' AND `tablename`='acos' AND `field`='name' AND `language_label`='name' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Administrate' AND `model`='Permission' AND `tablename`='acos' AND `field`='name' AND `language_label`='name' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Administrate' AND `model`='Permission' AND `tablename`='acos' AND `field`='name' AND `language_label`='name' AND `language_tag`='' AND `type`='hidden' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), 'add to order', '/order/order_items/addAliquotsInBatch/', 1);

DELETE FROM i18n WHERE id = 'temporary batch set';
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('temporary batch set', 'Temporary Batchset', 'Lot de données temporaire');

INSERT INTO `datamart_batch_processes` (`id`, `name`, `plugin`, `model`, `url`, `flag_active`) VALUES
(null, 'define realiquoted children', 'Inventorymanagement', 'AliquotMaster', '/inventorymanagement/aliquot_masters/defineRealiquotedChildren/', 1),
(null, 'define realiquoted children', 'Inventorymanagement', 'ViewAliquot', '/inventorymanagement/aliquot_masters/defineRealiquotedChildren/', 1),

(null, 'realiquot', 'Inventorymanagement', 'AliquotMaster', '/inventorymanagement/aliquot_masters/realiquotInit/creation/', 1),
(null, 'realiquot', 'Inventorymanagement', 'ViewAliquot', '/inventorymanagement/aliquot_masters/realiquotInit/creation/', 1);

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/rtbform%';
INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `use_link`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('err_rtb_system_error', 1, 'system error', 'a system error has been detected', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `pages` (
`id` ,
`error_flag` ,
`language_title` ,
`language_body` ,
`use_link` ,
`created` ,
`created_by` ,
`modified` ,
`modified_by`
)
VALUES (
'err_confidential',  '0',  'access denied',  'you are not authorized to reach that page because you cannot input data into confidential fields',  '',  'NOW()',  '',  'NOW()',  ''
);

ALTER TABLE misc_identifier_controls ADD COLUMN flag_confidential TINYINT(1) UNSIGNED NOT NULL DEFAULT 1;

INSERT INTO `datamart_batch_processes` (`id`, `name`, `plugin`, `model`, `url`, `flag_active`) VALUES
(null, 'create derivative', 'Inventorymanagement', 'SampleMaster', '/inventorymanagement/sample_masters/batchDerivativeInit/', 1),
(null, 'create derivative', 'Inventorymanagement', 'ViewSample', '/inventorymanagement/sample_masters/batchDerivativeInit/', 1),

(null, 'create aliquots', 'Inventorymanagement', 'SampleMaster', '/inventorymanagement/aliquot_masters/addInit/', 1),
(null, 'create aliquots', 'Inventorymanagement', 'ViewSample', '/inventorymanagement/aliquot_masters/addInit/', 1);

UPDATE structure_fields SET language_label = 'select a derivative type'
WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_control_id' AND `language_label`='' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='derivative');

UPDATE structure_formats SET `flag_detail`='1',`flag_edit`='1',`flag_edit_readonly`='1'  WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewSample' AND tablename='' AND field='sample_type' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type'));
UPDATE structure_formats SET `flag_detail`='1',`flag_edit`='1',`flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewSample' AND tablename='' AND field='sample_code' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_detail`='1',`flag_edit`='1',`flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewSample' AND tablename='' AND field='acquisition_label' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_detail`='1',`flag_edit`='1',`flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='ViewSample' AND tablename='' AND field='participant_identifier' AND type='input' AND structure_value_domain  IS NULL );

UPDATE structure_formats SET `flag_addgrid`='0' 
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model='SampleMaster' AND tablename='sample_masters' AND field='notes' AND type='textarea' AND structure_value_domain  IS NULL );

INSERT IGNORE INTO i18n (id,en,fr) VALUES
("batch init no data", '', ''),
("you cannot create derivatives for this sample type", 'You cannot create derivatives for this sample type!', 'Aucun dérivé ne peut être créé pour ce type d''échantillon!'),
("you must select elements with a common type", 'You must select elements with a common type!', 'Vous devez sélectionner des éléments ayant le même type!'),
('you are not authorized to reach that page because you cannot input data into confidential fields', 
'You are not authorized to reach that page because you cannot input data into confidential fields!', 
'Vous n''êtes pas authorisé à afficher cette page car vous n''avez pas la permission de saisir des données confidentielles!'),
('select a derivative type', 'Derivative Type', 'Type du dérivé '),
('derivative creation process', 'Derivative Creation Process', 'Processus de création de dérivés'),
("you must select a derivative type", 'You must select a derivative type!', 'Vous devez sélectionner un type de dérivé'),
('aliquot creation batch process', 'Aliquot Creation Batch Process', 'Processus de création des aliquots par lots'),
('you need to select an aliquot type', 'You need to select an aliquot type!','Vous devez sélectionner un type d''aliquot'),
('at least one aliquot has to be created', 'At least one aliquot has to be created!', 'Au moins un aliquot doit être créé!');

ALTER TABLE consent_masters DROP COLUMN consent_master_id;

-- -----------------------------------------------------------------------------------
-- Lab Book
-- -----------------------------------------------------------------------------------

ALTER TABLE derivative_details
 ADD COLUMN lab_book_master_id int(11) DEFAULT NULL AFTER creation_datetime,
 ADD COLUMN sync_with_lab_book TINYINT(1) DEFAULT 0 AFTER lab_book_master_id;
ALTER TABLE derivative_details_revs
 ADD COLUMN lab_book_master_id int(11) DEFAULT NULL AFTER creation_datetime,
 ADD COLUMN sync_with_lab_book TINYINT(1) DEFAULT 0 AFTER lab_book_master_id;

INSERT INTO structures(`alias`) VALUES ('derivative_lab_book');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'DerivativeDetail', 'derivative_details', 'lab_book_master_code', 'autocomplete',  NULL , '0', '', '', '', 'derivative lab book', ''), 
('Inventorymanagement', 'DerivativeDetail', 'derivative_details', 'sync_with_lab_book', 'checkbox',  NULL , '0', '', '', '', 'synchronize with lab book', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='derivative_lab_book'), 
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='lab_book_master_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='derivative lab book' AND `language_tag`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='derivative_lab_book'), 
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='sync_with_lab_book' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='synchronize with lab book' AND `language_tag`=''), '1', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0');
UPDATE structure_fields SET  `language_label`='',  `language_tag`='synchronize with lab book' WHERE model='SampleDetail' AND tablename='derivative_details' AND field='sync_with_lab_book' AND `type`='checkbox' AND structure_value_domain  IS NULL ;


UPDATE sample_controls SET form_alias=CONCAT(form_alias, ',derivative_lab_book') WHERE sample_category='derivative';
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivative_init') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='derivative') AND `flag_confidential`='0');
-- UPDATE structure_formats SET `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivative_lab_book') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='lab_book_master_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
-- UPDATE structure_formats SET `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivative_lab_book') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='sync_with_lab_book' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

CREATE TABLE IF NOT EXISTS `lab_book_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_type` varchar(30) NOT NULL DEFAULT '',
  `flag_active` tinyint(1) NOT NULL DEFAULT '1',
  `form_alias` varchar(255) NOT NULL,
  `detail_tablename` varchar(255) NOT NULL,
  `databrowser_label` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sample_type` (`book_type`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `lab_book_controls` (`id`, `book_type`, `flag_active`, `detail_tablename`, `form_alias`, `databrowser_label`) 
VALUES
(null, 'dna extraction', 0, 'lbd_dna_extractions', 'lbd_dna_extractions', 'dna extraction'),
(null, 'slide creation', 1, 'lbd_slide_creations', 'lbd_slide_creations', 'slide creation');

CREATE TABLE IF NOT EXISTS `lab_book_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `lab_book_control_id` int(11) NOT NULL DEFAULT '0',
  `code` varchar(60) NOT NULL DEFAULT '',
  `notes` text,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `lab_book_masters_revs` (
  `id` int(11) NOT NULL,
  
  `lab_book_control_id` int(11) NOT NULL DEFAULT '0',
  `code` varchar(60) NOT NULL DEFAULT '',
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

ALTER TABLE `lab_book_masters`
  ADD CONSTRAINT `FK_lab_book_masters_masters_lab_book_controls` FOREIGN KEY (`lab_book_control_id`) REFERENCES `lab_book_controls` (`id`);

CREATE TABLE IF NOT EXISTS `lbd_dna_extractions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lab_book_master_id` int(11) DEFAULT NULL,
  
  `creation_site` varchar(30) DEFAULT NULL,
  `creation_by` varchar(50) DEFAULT NULL,
  `creation_datetime` datetime DEFAULT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=35 ;

ALTER TABLE `lbd_dna_extractions`
  ADD CONSTRAINT `FK_lbd_slide_creations_sops` FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`),
  ADD CONSTRAINT `FK_lbd_dna_extractions_lab_book_masters` FOREIGN KEY (`lab_book_master_id`) REFERENCES `lab_book_masters` (`id`);

CREATE TABLE IF NOT EXISTS `lbd_dna_extractions_revs` (
  `id` int(11) NOT NULL,
  `lab_book_master_id` int(11) DEFAULT NULL,
  
  `creation_site` varchar(30) DEFAULT NULL,
  `creation_by` varchar(50) DEFAULT NULL,
  `creation_datetime` datetime DEFAULT NULL,
  `sop_master_id` int(11) DEFAULT NULL,
    
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=84 ;

CREATE TABLE IF NOT EXISTS `lbd_slide_creations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lab_book_master_id` int(11) DEFAULT NULL,
  
  `realiquoting_datetime` datetime DEFAULT NULL,
  `realiquoted_by` varchar(50) DEFAULT NULL,
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=35 ;

CREATE TABLE IF NOT EXISTS `lbd_slide_creations_revs` (
  `id` int(11) NOT NULL,
  `lab_book_master_id` int(11) DEFAULT NULL,
  
  `realiquoting_datetime` datetime DEFAULT NULL,
  `realiquoted_by` varchar(50) DEFAULT NULL,
    
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=84 ;

ALTER TABLE `lbd_slide_creations`
  ADD CONSTRAINT `FK_lbd_slide_creations_lab_book_masters` FOREIGN KEY (`lab_book_master_id`) REFERENCES `lab_book_masters` (`id`);

DELETE FROM menus WHERE id like 'procd_%';
INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_params`, `use_summary`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('procd_CAN_01', 'core_CAN_33', 1, 9, 'lab book', 'lab book description', '/labbook/lab_book_masters/index/', '', '', 1, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('procd_CAN_02', 'procd_CAN_01', 0, 1, 'detail', NULL, '/labbook/lab_book_masters/detail/%%LabBookMaster.id%%', '', 'Labbook.LabBookMaster::summary', 1, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO structures(`alias`) VALUES ('labbookmasters');
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'lab_book_type', 'open', '', 'Labbook.LabBookControl::getLabBookTypePermissibleValuesFromId');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Labbook', 'LabBookMaster', 'lab_book_masters', 'code', 'code', '', 'input', 'size=10', '',  NULL , ''), 
('Labbook', 'LabBookMaster', 'lab_book_masters', 'lab_book_control_id', 'type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='lab_book_type') , ''), 
('Labbook', 'LabBookMaster', 'lab_book_masters', 'created', 'created', '', 'datetime', '', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='labbookmasters'), (SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='code' AND `language_label`='code' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='labbookmasters'), (SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='lab_book_control_id' AND `language_label`='type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='lab_book_type')  AND `language_help`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='labbookmasters'), (SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='created' AND `language_label`='created' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');

ALTER TABLE lbd_slide_creations
	ADD `blade_temperature` decimal(10,5) DEFAULT NULL AFTER `realiquoted_by`,
	ADD `duration_mn` int(6) DEFAULT NULL AFTER `blade_temperature`,
	ADD `sections_nbr` int(6) DEFAULT NULL AFTER `duration_mn`;
ALTER TABLE lbd_slide_creations_revs
	ADD `blade_temperature` decimal(10,5) DEFAULT NULL AFTER `realiquoted_by`,
	ADD `duration_mn` int(6) DEFAULT NULL AFTER `blade_temperature`,
	ADD `sections_nbr` int(6) DEFAULT NULL AFTER `duration_mn`;
	
INSERT INTO structures(`alias`) VALUES ('lbd_slide_creations');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Labbook', 'LabBookMaster', 'lab_book_masters', 'notes', 'notes', '', 'textarea', 'rows=2,cols=60', '',  NULL , ''), 
('Labbook', 'LabBookDetail', 'lbd_slide_creations', 'realiquoted_by', 'realiquoted by', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , ''), 
('Labbook', 'LabBookDetail', 'lbd_slide_creations', 'realiquoting_datetime', 'date', '', 'datetime', '', '',  NULL , ''),
('Labbook', 'LabBookDetail', 'lbd_slide_creations', 'duration_mn', 'duration (mn)', '', 'integer', 'size=3', '',  NULL , ''), 
('Labbook', 'LabBookDetail', 'lbd_slide_creations', 'sections_nbr', 'sections nbr', '', 'integer', 'size=3', '',  NULL , ''), 
('Labbook', 'LabBookDetail', 'lbd_slide_creations', 'blade_temperature', 'blade temperature', '', 'float', 'size=3', '',  NULL , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='lbd_slide_creations'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='code' AND `language_label`='code' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_slide_creations'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookDetail' AND `tablename`='lbd_slide_creations' AND `field`='realiquoted_by' AND `language_label`='realiquoted by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `language_help`=''), 
'0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_slide_creations'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookDetail' AND `tablename`='lbd_slide_creations' AND `field`='realiquoting_datetime' AND `language_label`='date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_slide_creations'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookDetail' AND `tablename`='lbd_slide_creations' AND `field`='blade_temperature' AND `language_label`='blade temperature' AND `language_tag`='' AND `type`='float' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_slide_creations'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookDetail' AND `tablename`='lbd_slide_creations' AND `field`='duration_mn' AND `language_label`='duration (mn)' AND `language_tag`='' AND `type`='integer' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_slide_creations'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookDetail' AND `tablename`='lbd_slide_creations' AND `field`='sections_nbr' AND `language_label`='sections nbr' AND `language_tag`='' AND `type`='integer' AND `setting`='size=3' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_slide_creations'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=2,cols=60' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), 
'0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(null, (SELECT id FROM structure_fields WHERE model='LabBookMaster' AND field='code'), 'notEmpty', '', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `use_link`, `created`, `created_by`, `modified`, `modified_by`) VALUES
('err_lab_book_funct_param_missing', 1, 'parameter missing', 'a paramater used by the executed function has not been set', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('err_lab_book_no_data', 1, 'data not found', 'no data exists for the specified id', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
('err_lab_book_system_error', 1, 'system error', 'a system error has been detected', '', '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('lab book','Lab Book','Cahier de laboratoire'),
('blade temperature', 'Blade Temperature', 'Température de la lame'),
('duration (mn)','Duration (mn)','Durée (mn)'),
('sections nbr','Sections Nbr', 'Nombre de sections'),
('slide creation','Slide Creation','Création de lame');

UPDATE lab_book_controls SET flag_active = '1';

INSERT INTO structures(`alias`) VALUES ('lbd_dna_extractions');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Labbook', 'LabBookDetail', 'lbd_dna_extractions', 'creation_datetime', 'date', '', 'datetime', '', '',  NULL , ''), 
('Labbook', 'LabBookDetail', 'lbd_dna_extractions', 'creation_site', 'creation site', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') , ''), 
('Labbook', 'LabBookDetail', 'lbd_dna_extractions', 'creation_by', 'created by', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , ''), 
('Labbook', 'LabBookDetail', 'lbd_dna_extractions', 'sop_master_id', 'sample sop', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='lbd_dna_extractions'), (SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='code' AND `language_label`='code' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_dna_extractions'), (SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=2,cols=60' AND `default`='' AND `structure_value_domain`  IS NULL  AND `language_help`=''), '0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_dna_extractions'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookDetail' AND `tablename`='lbd_dna_extractions' AND `field`='creation_datetime'), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_dna_extractions'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookDetail' AND `tablename`='lbd_dna_extractions' AND `field`='creation_site'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_dna_extractions'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookDetail' AND `tablename`='lbd_dna_extractions' AND `field`='creation_by'), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_dna_extractions'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookDetail' AND `tablename`='lbd_dna_extractions' AND `field`='sop_master_id'), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_type_selection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ids' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_type_selection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='realiquot_into' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='realiquot_into') AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_label`='',  `language_tag`='synchronize with lab book' WHERE model='DerivativeDetail' AND tablename='derivative_details' AND field='sync_with_lab_book' AND `type`='checkbox' AND structure_value_domain  IS NULL ;

ALTER TABLE realiquotings
 ADD COLUMN lab_book_master_id int(11) DEFAULT NULL AFTER realiquoted_by,
 ADD COLUMN sync_with_lab_book TINYINT(1) DEFAULT 0 AFTER lab_book_master_id;
ALTER TABLE realiquotings_revs
 ADD COLUMN lab_book_master_id int(11) DEFAULT NULL AFTER realiquoted_by,
 ADD COLUMN sync_with_lab_book TINYINT(1) DEFAULT 0 AFTER lab_book_master_id;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='lbd_dna_extractions'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='lab_book_control_id'), 
'0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='lbd_slide_creations'), 
(SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='lab_book_control_id'), 
'0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'); 

ALTER TABLE parent_to_derivative_sample_controls
	ADD `lab_book_control_id` int(11) NULL AFTER flag_active;

ALTER TABLE `parent_to_derivative_sample_controls`
  ADD CONSTRAINT `FK_parent_to_derivative_sample_controls_lab_book_controls` FOREIGN KEY (`lab_book_control_id`) REFERENCES `lab_book_controls` (`id`);

UPDATE parent_to_derivative_sample_controls link, sample_controls samp
SET link.lab_book_control_id = (SELECT id FROM lab_book_controls WHERE book_type = 'dna extraction')
WHERE samp.id = link.derivative_sample_control_id
AND samp.sample_type = 'dna';

INSERT IGNORE INTO i18n (id,en,fr) VALUES
('lab book creation', 'Lab Book Creation', 'Création du cahier de laboratoire'),
('skip lab book creation', 'Skip Creation', 'Passer la création'),
('synchronize with lab book', 'Keep Synchronized', 'Garder Synchronisé'),
('derivative lab book', 'Lab Book', 'Cahier de laboratoire'),
('a lab book should be selected to synchronize', 'A lab book should be selected to synchronize data!', 'Un cahier de laboratoire doit être sélectionné pour synchronizer les données!');

ALTER TABLE realiquoting_controls
	ADD `lab_book_control_id` int(11) NULL AFTER flag_active;

ALTER TABLE `realiquoting_controls`
  ADD CONSTRAINT `FK_realiquoting_controls_lab_book_controls` FOREIGN KEY (`lab_book_control_id`) REFERENCES `lab_book_controls` (`id`);

SET @parent_sample_to_aliquot_control_id = (SELECT link.id
FROM sample_to_aliquot_controls AS link
INNER JOIN sample_controls AS samp ON link.sample_control_id = samp.id
INNER JOIN aliquot_controls AS al ON link.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'block');

SET @child_sample_to_aliquot_control_id = (SELECT link.id
FROM sample_to_aliquot_controls AS link
INNER JOIN sample_controls AS samp ON link.sample_control_id = samp.id
INNER JOIN aliquot_controls AS al ON link.aliquot_control_id = al.id
WHERE samp.sample_type = 'tissue' AND al.aliquot_type = 'slide');

UPDATE realiquoting_controls 
SET lab_book_control_id = (SELECT id FROM lab_book_controls WHERE book_type = 'slide creation')
WHERE parent_sample_to_aliquot_control_id = @parent_sample_to_aliquot_control_id
AND child_sample_to_aliquot_control_id = @child_sample_to_aliquot_control_id;

ALTER TABLE `derivative_details`
	ADD CONSTRAINT `FK_derivative_details_lab_book_masters` FOREIGN KEY (`lab_book_master_id`) REFERENCES `lab_book_masters` (`id`);
ALTER TABLE `realiquotings`
	ADD CONSTRAINT `FK_realiquotings_lab_book_masters` FOREIGN KEY (`lab_book_master_id`) REFERENCES `lab_book_masters` (`id`);

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) 
VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='code' ), 'isUnique', '', 'lab book code must be unique');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('lab book code must be unique', 'The lab book code must be unique!', 'Le code du cahier de laboratoire doit être unique!'),
('deleted lab book is linked to a derivative', 
'Your data cannot be deleted! <br>Derivative data are linked to the deleted lab book.', 
'Vos données ne peuvent être supprimées! <br>Des dérivés sont attachés à votre cahier de laboratoire.'),
('deleted lab book is linked to a realiquoted aliquot', 
'Your data cannot be deleted! <br>Realiquoted aliquots are linked to the deleted lab book.', 
'Vos données ne peuvent être supprimées! <br>Des aliquot ''réaliquotés'' sont attachés à votre cahier de laboratoire.');

INSERT INTO structures(`alias`) VALUES ('lab_book_derivatives_summary');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'GeneratedParentSample', '', 'sample_code', 'parent sample code', '', 'input', '', '',  NULL , '');
 
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='lab_book_derivatives_summary');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='lab_book_derivatives_summary'), 
(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label'), 
'0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='lab_book_derivatives_summary'), 
(SELECT id FROM structure_fields WHERE `model`='GeneratedParentSample' AND `tablename`='' AND `field`='sample_type'), 
'0', '5', '', '1', 'parent sample', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='lab_book_derivatives_summary'), 
(SELECT id FROM structure_fields WHERE `model`='GeneratedParentSample' AND `tablename`='' AND `field`='sample_code'), 
'0', '6', '', '1', '', '1', ':', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='lab_book_derivatives_summary'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type'), 
'0', '7', '', '1', 'sample', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='lab_book_derivatives_summary'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' ), 
'0', '8', '', '1', '', '1', ':', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='lab_book_derivatives_summary'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' ), 
'0', '9', '', '0', '', '0', '', '0', '', '0', '', '1', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='lab_book_derivatives_summary'), 
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `field`='creation_datetime'), 
'0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='lab_book_derivatives_summary'), 
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `field`='creation_by' ), 
'0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='lab_book_derivatives_summary'), 
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `field`='creation_site'), 
'0', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='lab_book_derivatives_summary'), 
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='sync_with_lab_book'), 
'0', '30', '', '1', 'synchronize with lab book', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0');

INSERT INTO structures(`alias`) VALUES ('lab_book_realiquotings_summary');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'Realiquoting', 'realiquotings', 'sync_with_lab_book', 'checkbox',  NULL , '0', '', '', '', '', 'synchronize with lab book');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'AliquotMasterChildren', 'aliquot_masters', 'aliquot_type', 'aliquot type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') , ''), 
('Inventorymanagement', 'AliquotMasterChildren', 'aliquot_masters', 'barcode', 'barcode', '', 'input', 'size=30', '',  NULL , '');

DELETE FROM  structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary'), 
(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label'), 
'0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type'), 
'0', '5', '', '1', 'sample', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary'), 
(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code'), 
'0', '6', '', '1', '', '1', ':', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='aliquot_type'), 
'0', '7', '', '1', 'parent aliquot', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `type`='input' AND `field`='barcode' ), 
'0', '8', '', '1', '', '1', ':', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMasterChildren' AND `field`='aliquot_type'), 
'0', '10', '', '1', 'aliquot', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMasterChildren' AND `type`='input' AND `field`='barcode' ), 
'0', '11', '', '1', '', '1', ':', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary'), 
(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `field`='realiquoting_datetime'), 
'0', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary'), 
(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `field`='realiquoted_by' ), 
'0', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary'), 
(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `field`='sync_with_lab_book'), 
'0', '30', '', '1', 'synchronize with lab book', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('sample', 'Sample', 'Échantillon'),
('sample', 'Sample', 'Échantillon'),
('parent aliquot', 'Parent Aliquot', 'Aliquot Parent'),
('parent sample', 'Parent Sample', 'Échantillon Parent'),
('edit synchronization option', 'Change Synchronization Options', 'Modifier paramêtres de synchronisation'),
('dna extraction', 'DNA Extraction', 'Extraction d''ADN');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'Realiquoting', '', 'id', '', '', 'hidden', '', '',  NULL , ''),
('Inventorymanagement', 'DerivativeDetail', '', 'id', '', '', 'hidden', '', '',  NULL , '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='lab_book_realiquotings_summary'), 
(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `field`='id'), 
'0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='lab_book_derivatives_summary'), 
(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `field`='id'), 
'0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0');


-- delete structure_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='lbd_dna_extractions') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Labbook' AND `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='code' AND `language_label`='code' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='lbd_dna_extractions') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Labbook' AND `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=2,cols=60' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='lbd_slide_creations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Labbook' AND `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='code' AND `language_label`='code' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='lbd_slide_creations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Labbook' AND `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=2,cols=60' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE lab_book_controls SET form_alias=CONCAT('labbookmasters,', form_alias);

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='labbookmasters'), (SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '100', '', '1', 'lab book notes', '0', '', '0', '', '1', 'input', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_formats SET `display_order`='0', `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='labbookmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='200' WHERE structure_id=(SELECT id FROM structures WHERE alias='labbookmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='lab_book_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='lab_book_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='300' WHERE structure_id=(SELECT id FROM structures WHERE alias='labbookmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='LabBookMaster' AND `tablename`='lab_book_masters' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


INSERT IGNORE INTO i18n (id,en,fr) VALUES 
("lab book notes", "Lab book notes", "Notes du cahier de laboratoire");


INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', '0', '', 'sync_with_lab_book_now', 'checkbox',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='derivative_lab_book'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='sync_with_lab_book_now' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1');
UPDATE structure_fields SET  `setting`='url=/labbook/lab_book_masters/autocomplete/' WHERE model='DerivativeDetail' AND tablename='derivative_details' AND field='lab_book_master_code' AND `type`='autocomplete' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0', display_column=1 WHERE structure_id=(SELECT id FROM structures WHERE alias='derivative_lab_book') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='sync_with_lab_book_now' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_tag`='synchronize now' WHERE model='0' AND tablename='' AND field='sync_with_lab_book_now' AND `type`='checkbox' AND structure_value_domain  IS NULL ;



UPDATE menus SET parent_id = 'sto_CAN_01' WHERE parent_id = 'sto_CAN_09';
DELETE FROM menus WHERE id = 'sto_CAN_09';
UPDATE menus SET display_order = '4' WHERE id = 'sto_CAN_06';
UPDATE menus SET display_order = '2' WHERE id = 'sto_CAN_10';
UPDATE menus SET display_order = '3', language_title = 'storage content layout' WHERE id = 'sto_CAN_05';
UPDATE i18n SET en = 'Content (Tree View)', fr = 'Contenu (Vue hiérarc.)' WHERE id = 'storage content tree view';

DELETE FROM i18n WHERE id =  'storage content layout';
INSERT IGNORE INTO i18n (id,en,fr) VALUES 
( 'storage content layout', 'Content (Layout)', 'Contenu (Plan)');

UPDATE menus SET use_summary = 'Storagelayout.StorageMaster::summary' WHERE id IN ('sto_CAN_05', 'sto_CAN_10');

UPDATE datamart_structures SET `index_link` = '/inventorymanagement/specimen_reviews/detail/%%SpecimenReviewMaster.collection_id%%/%%SpecimenReviewMaster.sample_master_id%%/%%SpecimenReviewMaster.id%%/' WHERE model = 'SpecimenReviewMaster';
UPDATE datamart_structures SET `index_link` = '/inventorymanagement/quality_ctrls/detail/%%SampleMaster.collection_id%%/%%QualityCtrl.sample_master_id%%/%%QualityCtrl.id%%/' WHERE model = 'QualityCtrl';


INSERT INTO structures(`alias`) VALUES ('realiquoting_lab_book');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'Realiquoting', 'realiquotings', 'lab_book_master_code', 'integer',  NULL , '0', '', '', '', 'lab book code', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='realiquoting_lab_book'), (SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='lab_book_master_code' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lab book code' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='realiquoting_lab_book'), (SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='sync_with_lab_book' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '1', 'sync with lab book', '1', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='', `flag_override_tag`='1', `language_tag`='sync with lab book' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquoting_lab_book') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='sync_with_lab_book' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `type`='autocomplete',  `setting`='url=/labbook/lab_book_masters/autocomplete/' WHERE model='Realiquoting' AND tablename='realiquotings' AND field='lab_book_master_code' AND `type`='integer' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND type='autocomplete' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='OrderItem' AND tablename='order_items' AND field='date_added' AND type='date' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='OrderItem' AND tablename='order_items' AND field='added_by' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='OrderItem' AND tablename='order_items' AND field='status' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='order_item_status'));
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Shipment' AND tablename='shipments' AND field='shipment_code' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Shipment' AND tablename='shipments' AND field='recipient' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Shipment' AND tablename='shipments' AND field='facility' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Shipment' AND tablename='shipments' AND field='shipping_account_nbr' AND type='input' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Shipment' AND tablename='shipments' AND field='datetime_shipped' AND type='datetime' AND structure_value_domain  IS NULL );
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='Shipment' AND tablename='shipments' AND field='shipped_by' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff'));

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('add order' , 'Add Order' , 'Ajouter Commande'),
('order item' , 'Order Item' , 'Article de Commande'),
('lab book description', 
'Allows to track data linked to a set of inventory entities created during a batch process (realiquoting, derivatives creation, etc) and that can be applied to the all. This tool can be used to synchronize all data of these entities created in batch.',
'Permet l''enregistrement de données liées à des entités de l''inventaire créés durant le même processus (realiquotiage en lot, dérivés créés en lot, etc) et qui s''appliquent à l''ensemble des entités. Cette outil peut être utilisé pour synchroniser les données de ces entités créés en lot.');

UPDATE structure_fields SET setting = 'rows=3,cols=30' WHERE field LIKE 'notes';
UPDATE structure_formats SET flag_override_type = '0', type = '' WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field LIKE 'notes' AND model LIKE 'LabBookMaster');

DELETE FROM i18n WHERE id IN (
'no lab book can be applied to the current item(s)',
'click submit to continue',
'if no lab book has to be defined for this process, keep fields empty and click submit to continue',
'lab book selection',
'add lab book (pop-up)',
'derivative type selection',
'invalid lab book code',
'the selected lab book cannot be applied to the current item(s)');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('no lab book can be applied to the current item(s)','No lab book can be applied to the current item(s)!','Aucun cahier de laboratoire ne peut être appliqué à ces données!'),
('click submit to continue','Click submit to continue.','Cliquer sur ''Envoyer'' pour continuer.'),
('if no lab book has to be defined for this process, keep fields empty and click submit to continue',
'If no lab book has to be defined for this process, keep fields empty and click submit to continue.',
'Si aucun cahier de laboratoire ne doit être défini pour ce processus, gader les champs vide et cliquer sur ''Envoyer''.'),
('lab book selection','Lab Book Selection','Sélection du cahier de laboratoire'),
('add lab book (pop-up)','Add Lab Book (pop-up)','Ajouter cahier de labo. (pop-up)'),
('derivative type selection','Derivative Type Selection','Sélection type de dérivé'),

('invalid lab book code','Invalid lab book code!','Code de cahier de laboratoire invalide!'),
('the selected lab book cannot be applied to the current item(s)',
'The selected lab book cannot be applied to the current item(s)!','Le cahier de laboratoire sélectionné ne peut être appliqué à ces données!');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('search start from', 'Search Start From', 'Recherche a partir de');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivative_lab_book') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DerivativeDetail' AND tablename='derivative_details' AND field='lab_book_master_code' AND type='autocomplete' AND structure_value_domain  IS NULL );
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'lab_book_code_from_id', 'open', '', 'Labbook.LabBookMaster::getLabBookPermissibleValuesFromId');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`) VALUES
('Inventorymanagement', 'DerivativeDetail', 'derivative_details', 'lab_book_master_id', 'derivative lab book', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='lab_book_code_from_id') , '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='derivative_lab_book'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='lab_book_master_id' AND `language_label`='derivative lab book' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='lab_book_code_from_id')  AND `language_help`=''), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivative_lab_book') AND structure_field_id=(SELECT id FROM structure_fields WHERE model='DerivativeDetail' AND tablename='derivative_details' AND field='lab_book_master_code' AND type='autocomplete' AND structure_value_domain  IS NULL );

UPDATE structure_fields SET  `language_tag`='synchronize with lab book now' WHERE model='0' AND tablename='' AND field='sync_with_lab_book_now' AND `type`='checkbox' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_column`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='derivative_lab_book') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='0' 
AND tablename='' AND field='sync_with_lab_book_now' AND type='checkbox' AND structure_value_domain  IS NULL );

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('synchronize with lab book now', 'Synch. Now', 'Synch. Auj.'),
('to synchronize with a lab book, you need to define a lab book to use', 
'To synchronize with a lab book, you need to define a lab book to use!', 
'Pour synchroniser avec un cahier de laboratoire, vous devez en définir un!'),
('aliquot type selection','Aliquot Type Selection','Sélection type d''aliquot');

UPDATE structure_fields SET language_label = 'keep synchronized with lab book', language_tag = '' WHERE field = 'sync_with_lab_book' AND model IN ('DerivativeDetail', 'Realiquoting');
UPDATE structure_fields SET language_label = 'lab book code' WHERE field = 'lab_book_master_code' AND model IN ('DerivativeDetail', 'Realiquoting');

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='', `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquoting_lab_book') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='sync_with_lab_book' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `language_tag`='', `language_label`='synchronize with lab book now' WHERE model='0' AND tablename='' AND field='sync_with_lab_book_now' AND `type`='checkbox' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('you must select an aliquot type','You must select an aliquot type!','Vous devez sélectionner un type d''aliquot'),
('no lab book can be defined for that realiquoting','No lab book can be defined for that realiquoting process!','Aucun cahier de laboratoire ne peut être attaché à ce processus de réaliquotage!');

UPDATE datamart_batch_processes SET url = '/inventorymanagement/aliquot_masters/realiquotInit/definition/' WHERE url = '/inventorymanagement/aliquot_masters/defineRealiquotedChildren/';
UPDATE datamart_structure_functions SET link = '/inventorymanagement/aliquot_masters/realiquotInit/definition/' WHERE link = '/inventorymanagement/aliquot_masters/defineRealiquotedChildren/';

UPDATE structure_formats SET `display_column`='1' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'ad_%') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='study_summary_id' AND type='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list'));

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('see book code', 'Lab Book', 'Cahier de labo.'),
('lab book code', 'Lab Book', 'Cahier de laboratoire'),
('keep synchronized with lab book', 'Keep Synchronized', 'Garder Synchronisé');


