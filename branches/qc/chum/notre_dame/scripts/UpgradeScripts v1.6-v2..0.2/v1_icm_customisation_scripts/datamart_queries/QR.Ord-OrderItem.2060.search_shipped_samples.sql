-- FORMS --

DELETE FROM `forms`
WHERE `id` IN ('CAN-024-001-000-999-0036');

INSERT INTO `forms` 
(`id`, `alias`, `language_title`, `language_help`, 
`flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('CAN-024-001-000-999-0036', 'shipment_aliquots_search', '', '', 
0, 0, 0, 1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- FORM FIELDS --

-- FORM FORMATS --

DELETE FROM `form_formats`
WHERE `form_id` IN ('CAN-024-001-000-999-0036');

INSERT INTO `form_formats` (`id`, `form_id`, `field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`, `created`, `created_by`, `modified`, `modified_by`) VALUES 
/* AliquotMaster.label */
('CAN-024-001-000-999-0036_CAN-024-001-000-999-0009', 'CAN-024-001-000-999-0036', 'CAN-024-001-000-999-0009', 0, 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* Shipment.recipient */
('CAN-024-001-000-999-0036_CAN-999-999-000-999-1269', 'CAN-024-001-000-999-0036', 'CAN-999-999-000-999-1269', 0, 2, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Shipment.facility */
('CAN-024-001-000-999-0036_CAN-999-999-000-999-1270', 'CAN-024-001-000-999-0036', 'CAN-999-999-000-999-1270', 0, 3, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Shipment.datetime_shipped */
('CAN-024-001-000-999-0036_CAN-999-999-000-999-512 ', 'CAN-024-001-000-999-0036', 'CAN-999-999-000-999-512 ', 0, 1, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* SampleMaster.type */
('CAN-024-001-000-999-0036_CAN-999-999-000-999-1018', 'CAN-024-001-000-999-0036', 'CAN-999-999-000-999-1018', 0, 10, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'Specimen', 'sample_type' */
('CAN-024-001-000-999-0036_CAN-024-001-000-999-0123', 'CAN-024-001-000-999-0036', 'CAN-024-001-000-999-0123', 0, 15, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* 'ParentSample', 'sample_type' */
('CAN-024-001-000-999-0036_CAN-024-001-000-999-0124', 'CAN-024-001-000-999-0036', 'CAN-024-001-000-999-0124', 0, 16, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* AliquotMaster.type */
('CAN-024-001-000-999-0036_CAN-999-999-000-999-1102', 'CAN-024-001-000-999-0036', 'CAN-999-999-000-999-1102', 0, 12, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Collection.bank */
('CAN-024-001-000-999-0036_CAN-999-999-000-999-1223', 'CAN-024-001-000-999-0036', 'CAN-999-999-000-999-1223', 0, 12, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),

/* Shipment.shipment_code */
('CAN-024-001-000-999-0036_CAN-999-999-000-999-496', 'CAN-024-001-000-999-0036', 'CAN-999-999-000-999-496', 0, 31, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Shipment.shipped_by */
('CAN-024-001-000-999-0036_CAN-999-999-000-999-514', 'CAN-024-001-000-999-0036', 'CAN-999-999-000-999-514', 0, 32, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 1, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', ''),
/* Order.order_number */
('CAN-024-001-000-999-0036_CAN-999-999-000-999-355', 'CAN-024-001-000-999-0036', 'CAN-999-999-000-999-355', 0, 31, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 
0, 0, 0, 0, 0, 0, 0, 0, 1, 0, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- DATAMART ADHOC --

DELETE FROM `datamart_adhoc` 
WHERE `id` = 2060;

INSERT INTO `datamart_adhoc` 
(`id`, `description`, `model`, 
`form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, 
`sql_query_for_results`, 
`flag_use_query_results`, 
`created`, `created_by`, `modified`, `modified_by`) 
VALUES 
('2060', '<b>QR.Ord-OrderItem.2060</b>: <u>Search Shipment Aliquots / Recherche des aliquots d''un envoi</u><br>
List aliquots of shipments. / Liste les aliquots d''envois.<br>
<FONT COLOR="#347C17"><B>ORDER ITEM</B> - ORDER - <U>SHIPMENT</U> - <U>COLLECTION</U> - SAMPLE - ALIQUOT / <B>ARTICLE DE COMMANDE</B> - COMMANDE - <U>ENVOI</U> - <U>COLLECTION</U> - &Eacute;CHANTILLON - ALIQUOT</FONT>', 
'OrderItem', 
'shipment_aliquots_search', 'shipment_aliquots_search', 
'plugin order item detail=>/order/order_items/detail/%%Order.id%%/%%OrderLine.id%%/%%OrderItem.id%%/|plugin inventorymanagement aliquot detail=>/inventorymanagement/aliquot_masters/detailAliquotFromId/%%AliquotMaster.id%%/', 
'SELECT DISTINCT OrderItem.id, OrderLine.id, `Order`.id, AliquotMaster.id, Shipment.recipient, Shipment.facility, Shipment.datetime_shipped , SampleMaster.sample_type, Specimen.sample_type, ParentSample.sample_type, AliquotMaster.aliquot_type, AliquotMaster.aliquot_label, Collection.bank, Shipment.shipment_code, Shipment.shipped_by, `Order`.order_number FROM order_items AS OrderItem INNER JOIN shipments AS Shipment ON OrderItem.shipment_id = Shipment.id INNER JOIN order_lines AS OrderLine ON OrderItem.orderline_id = OrderLine.id INNER JOIN orders AS `Order` ON OrderLine.order_id = `Order`.id INNER JOIN aliquot_masters AS AliquotMaster ON OrderItem.aliquot_master_id = AliquotMaster.id INNER JOIN sample_masters AS SampleMaster ON AliquotMaster.sample_master_id = SampleMaster.id INNER JOIN sample_masters AS Specimen ON Specimen.id = SampleMaster.initial_specimen_sample_id INNER JOIN sample_masters AS ParentSample ON ParentSample.id = SampleMaster.parent_id INNER JOIN collections AS Collection ON SampleMaster.collection_id = Collection.id WHERE TRUE AND Shipment.recipient LIKE "%@@Shipment.recipient@@%" AND Shipment.facility LIKE "%@@Shipment.facility@@%" AND Shipment.datetime_shipped >= "@@Shipment.datetime_shipped_start@@" AND Shipment.datetime_shipped <= "@@Shipment.datetime_shipped_end@@" AND Collection.bank = "@@Collection.bank@@" AND Shipment.shipped_by = "@@Shipment.shipped_by@@" ORDER BY Shipment.datetime_shipped, Shipment.shipment_code, SampleMaster.sample_type;',
1, 
'0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '');

-- i18n --

DELETE FROM `i18n`
WHERE `id` IN ('plugin order item detail');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES 
('plugin order item detail', 'global', 'Order Item Details', 'Donn&eacute;es de l''article de la commande');





