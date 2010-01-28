ALTER TABLE `ed_allsolid_lab_pathology`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_adverse_events_adverse_event`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_clinical_followup`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_clinical_presentation`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_lifestyle_base`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_protocol_followup`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_study_research`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_breast_lab_pathology`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_breast_screening_mammogram`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
ALTER TABLE `cd_nationals`
  ADD FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
/* Clinical Annotation */
-- /Diagnosis/
  UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =830 LIMIT 1 ;
  UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =831 LIMIT 1 ;
  UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =832 LIMIT 1 ;
  UPDATE `structure_fields` SET `language_label` = '',
  `language_tag` = 'summary',
  `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =833 LIMIT 1 ;

  UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =834 LIMIT 1 ;
  UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =835 LIMIT 1 ;
  UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =836 LIMIT 1 ;
  UPDATE `structure_fields` SET `language_label` = '',
  `language_tag` = 'summary',
  `setting` = 'size=1, maxlength=3' WHERE `structure_fields`.`id` =837 LIMIT 1 ;
    
-- flag Origin to index
    
UPDATE `structure_formats` SET `flag_index` = '1' WHERE `structure_formats`.`id` =2207 LIMIT 1 ;

DELETE FROM structure_formats
WHERE old_id = 'CAN-999-999-000-999-1004_CAN-999-999-000-999-1027';
 
--


DELETE FROM `structure_permissible_values` WHERE `language_alias` LIKE 'gr' AND `value` LIKE 'gr';
DELETE FROM `structure_permissible_values` WHERE `language_alias` LIKE 'cm' AND `value` LIKE 'cm';
DELETE FROM `structure_permissible_values` WHERE `language_alias` LIKE 'cm3' AND `value` LIKE 'cm3';
INSERT INTO `structure_permissible_values` (`id` ,`value` ,`language_alias`)
VALUES 
(NULL , 'gr', 'gr'), 
(NULL , 'cm', 'cm'),
(NULL , 'cm3', 'cm3');

DELETE FROM structure_value_domains WHERE domain_name = 'tissue_size_unit';
INSERT INTO `structure_value_domains` (`id` ,`domain_name` ,`override` ,`category`)
VALUES 
(NULL , 'tissue_size_unit', 'open', '');

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id IN (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'tissue_size_unit');
INSERT INTO `structure_value_domains_permissible_values` 
(`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`, `language_alias`) 
VALUES 
(NULL, (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'tissue_size_unit'), 
(SELECT id FROM `structure_permissible_values`  WHERE `value`  = 'gr' LIMIT 1), '1', 'yes', 'gr'),
(NULL, (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'tissue_size_unit'), 
(SELECT id FROM `structure_permissible_values`  WHERE `value`  = 'cm' LIMIT 1), '2', 'yes', 'cm'),
(NULL, (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'tissue_size_unit'), 
(SELECT id FROM `structure_permissible_values`  WHERE `value`  = 'cm3' LIMIT 1), '3', 'yes', 'cm3'),
(NULL, (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'tissue_size_unit'), 
(SELECT id FROM `structure_permissible_values`  WHERE `value`  = 'ml' LIMIT 1), '4', 'yes', 'ml');

UPDATE `structure_fields` 
SET `structure_value_domain` = (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'tissue_size_unit'),
type = 'select',
setting = null
WHERE old_id = 'CAN-999-999-000-999-1288';

DELETE FROM  `i18n` WHERE `id` IN ('gr', 'cm' ,'cm3');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('gr', 'global', 'gr', 'gr'),
('cm', 'global', 'cm', 'cm'),
('cm3', 'global', 'cm&#179;', 'cm&#179;');

DELETE FROM  `i18n` WHERE `id` IN (
'an aliquot can only be added once to an order',
'item exists for the deleted order line',
'add order line item',
'edit all',
'add order line',
'order_shipping_company',
'please check aliquots',
'selected aliquots for order',
'select order line',
'shipment',
'order_datetime_shipped',
'order item exists for the deleted shipment',
'no item has been defined as shipped',
'no unshipped item exists into this order line',
'no new item could be actualy added to the shipment',
'add items to shipment',
'your data has been removed - update the aliquot status data',
'order_order items',
'order_shipment items');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('an aliquot can only be added once to an order', 'global', 'An aliquot can only be added once to an order!', 'Un aliquot ne peut &ecirc;tre mis que dans une seule commande!'),
('item exists for the deleted order line', 'global', 'Your data cannot be deleted! <br>Item exists for the deleted order line.', 'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des articles existent pour votre ligne de commande.'),
('add order line item', 'global', 'Add Item', 'Ajouter Article'),
('edit all', 'global', 'Edit All', 'Modifier tout'),
('add order line', 'global', 'Add Order Line', 'Ajouter ligne de commande'),
('order_shipping_company', 'global', 'Shipping Company', 'Compagnie de transport'),
('please check aliquots', 'global', 'Please check aliquots', 'Veuillez v&eacute;rifier vos aliquots'),
('selected aliquots for order', 'global', 'Selected Aliquots for Order', 'Aliquots s&eacute;lectionn&eacute;s pour la commande'),
('select order line', 'global', 'Select Order Line', 'S&eacute;lectionner une ligne de commande'),
('shipment', 'global', 'Shipment', 'Envoi'),
('order_datetime_shipped', 'global', 'Shipping Date', 'Date d''envoi'),
('order item exists for the deleted shipment', 'global', 'Your data cannot be deleted! <br>Item exists for the deleted shipment.', 'Vos donn&eacute;es ne peuvent &ecirc;tre supprim&eacute;es! Des articles existent pour votre commande.'),
('no item has been defined as shipped', 'global', 'No item has been defined as shipped.', 'Aucun article n''a &eacute;t&eacute; d&ecirc;fini comme envoy&ecirc;.'),
('no unshipped item exists into this order line', 'global', 'No unshipped item exists into this order line.', 'Aucun article a envoyer existe dans votre ligne de commande.'),
('no new item could be actualy added to the shipment', 'global', 'No new item could be actualy added to the shipment.', 'Aucun nouvel article ne peut actuellement &ecirc;tre ajout&ecirc; &agrave; la commande.'),
('add items to shipment', 'global', 'Add Items to Shipment', 'Ajouter article &agrave; la commande'),
('your data has been removed - update the aliquot status data', 'global', 'Your data has been removed. Please update the status of the alqiuot.', 'Votre donn&ecirc;es &agrave; &ecirc;t&ecirc; enlever. Veuillez mettre &agrave; jour le statu de votre aliquot.'),
('order_order items', 'global', 'Items', 'Articles'),
('order_shipment items', 'global', 'Items', 'Articles');



UPDATE `structure_fields` 
SET `field` = 'in_stock',
`language_label` = 'aliquot in stock',
`language_help` = 'aliquot_in_stock_help' 
WHERE `old_id` = 'CAN-999-999-000-999-1103';

UPDATE `structure_fields` 
SET `field` = 'in_stock_detail',
`language_label` = 'aliquot in stock detail' 
WHERE `old_id` = 'CAN-999-999-000-999-1104';

UPDATE structure_value_domains 
SET domain_name = 'aliquot_in_stock_detail'
WHERE domain_name = 'aliquot_status_reason';

DELETE FROM `structure_permissible_values` WHERE `value` LIKE 'yes - available';
DELETE FROM `structure_permissible_values` WHERE `value` LIKE 'yes - not available';

INSERT INTO `structure_permissible_values` (`id` ,`value` ,`language_alias`)
VALUES 
(NULL , 'yes - available', 'yes - available'), 
(NULL , 'yes - not available', 'yes - not available');

DELETE FROM structure_value_domains WHERE domain_name = 'aliquot_in_stock_values';
INSERT INTO `structure_value_domains` (`id` ,`domain_name` ,`override` ,`category`)
VALUES 
(NULL , 'aliquot_in_stock_values', 'open', '');

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id IN (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'aliquot_in_stock_values');
INSERT INTO `structure_value_domains_permissible_values` 
(`id`, `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`, `language_alias`) 
VALUES 
(NULL, (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'aliquot_in_stock_values'), 
(SELECT id FROM `structure_permissible_values`  WHERE `value`  = 'yes - available' LIMIT 1), '1', 'yes', 'yes - available'),
(NULL, (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'aliquot_in_stock_values'), 
(SELECT id FROM `structure_permissible_values`  WHERE `value`  = 'yes - not available' LIMIT 1), '2', 'yes', 'yes - not available'),
(NULL, (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'aliquot_in_stock_values'), 
(SELECT id FROM `structure_permissible_values`  WHERE `value`  = 'no' LIMIT 1), '3', 'yes', 'no');

UPDATE `structure_fields` 
SET `structure_value_domain` = (SELECT id FROM `structure_value_domains` WHERE `domain_name`  = 'aliquot_in_stock_values')
WHERE old_id = 'CAN-999-999-000-999-1103';

DELETE FROM  `i18n` WHERE `id` IN ('aliquot_in_stock_help');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('aliquot_in_stock_help', 'global', 
'Status of an aliquot: <br> - ''Yes & Available'' => Aliquot exists physically into the bank and is available without restriction. <br> - ''Yes & Not Available'' => Aliquot exists physically into the bank but a restriction exists (reserved for and order, a study, on loan, etc). <br> - ''No'' => Aliquot doesn''t exist anymore because it has been either shipped or destroyed or used etc.', 
'Statu d''un aliquot : <br> - ''Oui & Disponible'' => Aliquot pr&eacute;sent physiquement dans la banque et disponible sans restriction. <br> - ''Oui & Non disponible'' => Aliquot pr&eacute;sent physiquement dans la banque mais une restriction existe (&ecirc;tre r&eacute;serv&eacute; pour une commande, une &eacute;tude, etc). <br> - ''Non'' => L''aliquot n''&eacute;xiste plus dans la banque parce qu''il a &eacute;t&eacute; utilis&eacute;, d&eacute;truit, exp&eacute;di&eacute;, etc.');

DELETE FROM  `i18n` WHERE `id` IN (
'aliquot in stock',
'aliquot in stock detail',
'yes - available', 
'yes - not available');

 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('aliquot in stock', 'global', 'In Stock', 'En stock'),
('aliquot in stock detail', 'global', 'Stock Detail', 'D&eacute;tail du stock'),
('yes - available', 'global', 'Yes & Available', 'Oui & Disponible'), 
('yes - not available', 'global', 'Yes & Not available', 'Oui & Non disponible');

UPDATE structure_formats 
SET language_label = 'new in stock value'
WHERE old_id IN ('CAN-999-999-000-999-1071_CAN-999-999-000-999-1103','CAN-999-999-000-999-1036_CAN-999-999-000-999-1103');

UPDATE structure_formats 
SET language_label = 'new in stock reason'
WHERE old_id IN ('CAN-999-999-000-999-1071_CAN-999-999-000-999-1104','CAN-999-999-000-999-1036_CAN-999-999-000-999-1104');

DELETE FROM  `i18n` WHERE `id` IN (
'new in stock value',
'new in stock reason');

 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('new in stock value', 'global', 'New ''In Stock'' Value', 'Nouvelle valeur ''En stock'''),
('new in stock reason', 'global', 'New Stock Detail', 'Nouveau d&eacute;tail du stock');


DELETE FROM  `i18n` WHERE `id` IN (
'your data has been removed - update the aliquot in stock data',
'your data has been deleted - update the aliquot in stock data',
'your data has been removed - update the aliquot status data');

 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('your data has been removed - update the aliquot in stock data', 'global', 
'Your data has been removed. <br>Please update the ''In Stock'' value for your aliquot if required.', 
'Votre donn&ecirc;e &agrave; &ecirc;t&ecirc; enlev&eacute;e. <br>Veuillez mettre &agrave; jour la valeur de la donn&eacute;e ''En stock'' de votre aliquot au besoin.');

 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('your data has been deleted - update the aliquot in stock data', 'global', 
'Your data has been deleted. <br>Please update the ''In Stock'' value for your aliquot if required.', 
'Votre donn&ecirc;e &agrave; &ecirc;t&ecirc; supprim&eacute;e. <br>Veuillez mettre &agrave; jour la valeur de la donn&eacute;e ''En stock'' de votre aliquot au besoin.');

DELETE FROM  `i18n` WHERE `id` IN ( 
'1- add order data',
'2- select order line',
'add aliquots to order: studied aliquots',
'add aliquots to order line');

 INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('1- add order data', 'global', '1- Add order data :', '1- Ajouter les donn&eacute;es de la commande :'),
('2- select order line', 'global', '2- Select order line :', '2 - S&eacute;lectionner la ligne de commande :'),
('add aliquots to order: studied aliquots', 'global', 'Add aliquots to order: Studied aliquots', 'Ajout des aliquots &agrave; une commande : Aliquots &eacute;tudi&eacute;s'),
('add aliquots to order line', 'global', 'Add Aliquots to Order Line', 'Ajoutez les aliquots &agrave; la ligne de commande');


