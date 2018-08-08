-- -----------------------------------------------------------------------------------------------------------------------------------
-- shipping_name vs order_item_shipping_label
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE order_items SET order_item_shipping_label = shipping_name;
UPDATE order_items_revs SET order_item_shipping_label = shipping_name;
UPDATE order_items SET order_item_shipping_label = null WHERE order_item_shipping_label = 'NULL';
UPDATE order_items_revs SET order_item_shipping_label = null WHERE order_item_shipping_label = 'NULL';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='shipping_name' AND `language_label`='shipping name' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='shipping_name' AND `language_label`='shipping name' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='shipping_name' AND `language_label`='shipping name' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
ALTER TABLE order_items DROP COLUMN shipping_name;
ALTER TABLE order_items_revs DROP COLUMN shipping_name_revs;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = 'xxxxx' WHERE version_number = '2.7.1';
