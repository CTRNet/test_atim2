-- ------------------------------------------------------
-- ATiM v2.6.6 Upgrade Script
-- version: 2.6.6
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('content','Content','Contenu');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('lines','Lines','Lignes');
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Update system table deleting unused fields (created, etc) or changing unnecessary fields default value
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE datamart_reports 
  DROP COLUMN created, 
  DROP COLUMN created_by, 
  DROP COLUMN modified, 
  DROP COLUMN modified_by;
ALTER TABLE pages 
  DROP COLUMN created, 
  DROP COLUMN created_by, 
  DROP COLUMN modified, 
  DROP COLUMN modified_by;
ALTER TABLE structure_validations
 MODIFY `language_message` text DEFAULT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #2702 create batch process to add one internal use to many aliquots
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Change edit aliquot in batch to be consistent

UPDATE i18n SET en = 'New (Selection Label)' WHERE en = 'New (selection label)';
UPDATE structure_fields SET  `type`='checkbox' WHERE model='FunctionManagement' AND tablename='' AND field='remove_in_stock_detail' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='checkbox' WHERE model='FunctionManagement' AND tablename='' AND field='remove_study_summary_id' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='checkbox' WHERE model='FunctionManagement' AND tablename='' AND field='remove_sop_master_id' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_type`='1', `type`='checkbox' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `language_label`='aliquot in stock' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='yes - available' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') AND `language_help`='aliquot_in_stock_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'FunctionManagement', '', 'in_stock', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values') , '0', '', '', 'aliquot_in_stock_help', 'aliquot in stock', 'new value');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliquot_master_edit_in_batchs'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='in_stock' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  AND `flag_confidential`='0' AND `setting`='' AND `language_help`='aliquot_in_stock_help' AND `language_label`='aliquot in stock' AND `language_tag`='new value'), '0', '400', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('all changes will be applied to the all','All changes will be applied to the all.','Toutes les modifications seront appliquées à l''ensemble'),
("keep the 'new value' field empty to not change data and use the 'erase/remove' checkbox to erase the data",
"Keep the 'New Value' field empty to not change data and use the 'Erase/Remove' checkbox to erase the data.",
"Garder le champ 'nouvelle valeur' vide pour ne pas modifier les données et utilisez la case 'Éffacer/Enlever 'pour effacer les données.");

-- Add in stock detail 

SET @flag_Active = (SELECT flag_active FROM datamart_structure_functions WHERE label = 'create uses/events (aliquot specific)');
UPDATE datamart_structure_functions SET flag_active = @flag_Active WHERE label = 'create use/event (applied to all)';
INSERT INTO structures(`alias`) VALUES ('aliq_in_stock_details_for_use_in_batch_process');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='in_stock' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='aliquot_in_stock_help' AND `language_label`='aliquot in stock' AND `language_tag`='new value'), '1', '400', 'aliquots data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail')  AND `flag_confidential`='0'), '1', '500', '', '0', '0', '', '1', 'new value', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_in_stock_detail' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='or delete data'), '1', '501', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '701', '', '0', '0', '', '1', 'new storage selection label', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='remove_from_storage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '702', '', '0', '0', '', '1', 'or remove', '0', '', '1', 'checkbox', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliq_in_stock_details_for_use_in_batch_process');
INSERT INTO i18n (id,en,fr) VALUES ('aliquots data','Aliquots Data', 'Données des aliquots');

UPDATE structure_fields SET language_tag = 'or erase data' WHERE language_tag = 'or delete data' AND field LIKE 'remove_%';
INSERT INTO i18n (id,en,fr) VALUES ('or erase data', 'Or Erase Data', 'Ou effacer les données'); 

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Order line optional

ALTER TABLE order_items ADD COLUMN `order_id` int(11) DEFAULT NULL;
ALTER TABLE order_items_revs ADD COLUMN `order_id` int(11) DEFAULT NULL;
UPDATE order_items oi, order_lines ol SET oi.order_id = ol.order_id WHERE oi.order_line_id = ol.id;
UPDATE order_items_revs oi, order_lines ol SET oi.order_id = ol.order_id WHERE oi.order_line_id = ol.id;
ALTER TABLE order_items MODIFY `order_id` int(11) NOT NULL;
ALTER TABLE order_items_revs  MODIFY `order_id` int(11) NOT NULL;
ALTER TABLE `order_items` ADD CONSTRAINT `FK_order_items_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);
UPDATE structure_formats SET `language_heading`='shipment' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='shipment_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structures(`alias`) VALUES ('orderitems_and_lines');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_and_lines'), (SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='sample_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='product type' AND `language_tag`=''), '0', '36', 'line', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_and_lines'), (SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='aliquot_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type_from_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '0', '37', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_and_lines'), (SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='sample_aliquot_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='sample_aliquot_type_precision_help' AND `language_label`='' AND `language_tag`='sample aliquot type precision'), '0', '38', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='orderitems_and_lines'), (SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='date_required' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='order_date_required' AND `language_tag`=''), '0', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Order line: creation in add grid

UPDATE structure_formats SET flag_addgrid = flag_add, flag_addgrid_readonly = flag_add_readonly WHERE structure_id = (SELECT id FROM structures WHERE alias='orderlines');
SELECT "Changed order line creation form type from 'add' to 'addgrid': OrderLine.add() to review if custom code exists" AS '### TODO ####';
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderlines'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '3', '1000', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0');

-- Order Item: creation in add grid

UPDATE structure_formats SET flag_addgrid = flag_add, flag_addgrid_readonly = flag_add_readonly WHERE structure_id = (SELECT id FROM structures WHERE alias='orderitems');
SELECT "Changed order item creation form type from 'add' to 'addgrid': OrderItem.add() to review if custom code exists" AS '### TODO ####';
UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('add items to order','Add Items to Order','Ajouter des articles à la commande'),
('add items to line','Add Items to Line','Ajouter des articles à la ligne'),
('order item exists for the deleted order', 'Your data cannot be deleted! <br>Order items exist for the deleted order.',"Vos données ne peuvent être supprimées! Des lignes de commandes existent pour votre commande."),
('remove from order','Remove From Order', 'Enlever de la commande'),
('new items', 'New Items', 'Nouveaux articles'),
('no unshipped item exists into this order','No unshipped item exists into this order.','Aucun article a envoyer existe dans votre commande.'),
('no order to complete is actually defined','No order to complete is actually defined!','Aucune commande à compléter n''est actuellment définie!'),
('edit all order items','Edit All Items','Modifier Articles'),
('studied aliquots', 'Studied Alquots', 'Aliquots sélectionnés'),
("a valid order or order line has to be selected",'A valid order or order line has to be selected.','Une ligne de commande ou une commande valide doit être sélectionnée');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('add aliquots to order', 'Add Aliquots to Order', 'Ajout d''aliquots dans une commande'),
('order item data', 'Order Item Data', 'Données liées à l''article de commande'),
('copy for new shipment','Copy for New Shipment','Copier pour nouvel envoi'),
('%%order_objects%% selection','%%order_objects%% Selection', 'Sélection d''une %%order_objects%%');

-- Order Item: listall

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems_plus'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot type' AND `language_tag`=''), '0', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Shipment

SET @flag_aliquot_barcode = (SELECT flag_detail FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode'));
SET @flag_aliquot_label = (SELECT flag_detail FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label'));
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '1', '', '0', '0', '', '0', '', '0', '', '1', 'autocomplete', '1', 'url=/InventoryManagement/AliquotMasters/autocompleteBarcode', '0', '', '0', '0', '0', '0', '0', '0', @flag_aliquot_barcode, @flag_aliquot_barcode, @flag_aliquot_barcode, @flag_aliquot_barcode, '0', '0', @flag_aliquot_barcode, @flag_aliquot_barcode, '0', '0'), 
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='date_added' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='order_date_added' AND `language_tag`=''), '0', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='added_by' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='order_added_by' AND `language_tag`=''), '0', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', @flag_aliquot_label, @flag_aliquot_label, @flag_aliquot_label, @flag_aliquot_label, '0', '0', @flag_aliquot_label, @flag_aliquot_label, '0', '0'),
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot type' AND `language_tag`=''), '0', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '1', '1', '0', '0');

SELECT 'Function Shipment.formatDataForShippedItemsSelection() has been updated. Please review customised function if exists.' AS '### TODO ###';

UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_and_lines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_and_lines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='aliquot_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_and_lines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='sample_aliquot_precision' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_addgrid_readonly`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems_and_lines') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderLine' AND `tablename`='order_lines' AND `field`='date_required' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('remove from shipment','Remove From Shipment','Enlever de l''envoi');

-- Databrowser Update

INSERT INTO `datamart_structures` (`id`, `plugin`, `model`, `structure_id`, `adv_search_structure_alias`, `display_name`, `control_master_model`, `index_link`, `batch_edit_link`) 
VALUES
(null, 'Order', 'Order', (SELECT id FROM structures WHERE alias = 'orders'), NULL, 'order', '', '/Order/Orders/detail/%%Order.id%%/', '');
SET @flag_active = (SELECT flag_active_1_to_2 FROM datamart_browsing_controls WHERE use_field = 'shipment_id');
INSERT INTO `datamart_browsing_controls` (`id1`, `id2`, `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
((SELECT id FROM datamart_structures WHERE model = 'Shipment'), (SELECT id FROM datamart_structures WHERE model = 'Order'), @flag_active, @flag_active, 'order_id'),
((SELECT id FROM datamart_structures WHERE model = 'OrderItem'), (SELECT id FROM datamart_structures WHERE model = 'Order'), @flag_active, @flag_active, 'order_id');

INSERT INTO `key_increments` (`key_name`, `key_value`)
VALUES('atim_internal_file', 1);

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`) VALUES
('err_file_not_found', 1, 'file_not_found', 'file_not_found_err_msg'),
('err_file_not_auth', 1, 'file_not_auth', 'file_not_auth_msg');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('file_not_found','File not found','Fichier introuvable'),
('file_not_found_err_msg', "The file you are trying to get was not found (%1$s)",
                           "Le fichier que vous tentez d'obtenir est introuvable (%1$s)"),
('file_not_auth', 'File unauthorized', 'Fichier non authorisé'),
('file_not_auth_msg', 'You are not authorized to open file (%1$s)',
                      "Vous n'êtes pas authorisé à ouvrir le fichier (%1$s)"),
('open the file', 'open the file', 'ouvrir le fichier');
















-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.6', NOW(),'???','n/a');
