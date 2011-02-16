
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

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('parent aliquot data update', 'Parent Aliquot Data Update', 'Mise à jour données aliquot parent');

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
('no new aliquot could be actually defined as realiquoted child for the follwing parent aliquot(s)', 'No new aliquot could be actually defined as realiquoted child for the follwing parent aliquot(s)', 
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

DROP VIEW view_aliquot_uses;
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

INSERT INTO structure_validations (`structure_field_id`, `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message`) 
(SELECT (SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND `type`='autocomplete' AND structure_value_domain IS NULL ), `rule`, `flag_empty`, `flag_required`, `on_action`, `language_message` FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model='AliquotMaster' AND tablename='aliquot_masters' AND field='barcode' AND `type`='input' AND structure_value_domain  IS NULL ));

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










