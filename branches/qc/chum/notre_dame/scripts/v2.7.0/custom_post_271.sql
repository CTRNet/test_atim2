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
ALTER TABLE order_items_revs DROP COLUMN shipping_name;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Raman consent & +
-- https://3.basecamp.com/3786377/buckets/4911238/todos/1115912377
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE cd_icm_generics
  ADD COLUMN acces_to_medical_records CHAR(1) DEFAULT NULL;
ALTER TABLE cd_icm_generics_revs
  ADD COLUMN acces_to_medical_records CHAR(1) DEFAULT NULL;
INSERT INTO structures(`alias`) VALUES ('qc_nd_cd_raman');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_icm_generics', 'contact_for_other_research', 'yes_no',  NULL , '0', '', '', '', 'communicate to participate in other research', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_icm_generics', 'acces_to_medical_records', 'yes_no',  NULL , '0', '', '', '', 'access to clinical records', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_cd_raman'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='contact_for_other_research' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='communicate to participate in other research' AND `language_tag`=''), '2', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_raman'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='acces_to_medical_records' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='access to clinical records' AND `language_tag`=''), '2', '9', 'agreements', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'chum - raman', 1, 'qc_nd_cd_raman', 'cd_icm_generics', 0, 'chum - raman');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('access to clinical records', 'Access to clinical records', "Accès au dossier médical"),
('chum - raman', 'CHUM -  Raman', 'CHUM - Raman');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'qc consent version');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("2017-10-10", "", "", '1', @control_id, NOW(), NOW(), 1, 1);
REPLACE INTO i18n (id,en,fr)
VALUES
('frsq - network', "FRQS - Network>", "FRQS - Réseau"),
('frsq', "FRQS>", "FRQS"),
('pre-frsq', "Pre-FRQS>", "Pré-FRQS"),
('frsq - gyneco', "FRQS - Gyneco/Ovary/Breast>", "FRQS - Gynéco/Ovaire/Sein"),
('ghadirian consent', "Dr Ghadirian's lab>", "Labo Dr Ghadirian");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Menopausal
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("not menopausal", "not menopausal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="menopause_status"), (SELECT id FROM structure_permissible_values WHERE value="not menopausal" AND language_alias="not menopausal"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="menopause_status"), (SELECT id FROM structure_permissible_values WHERE value="N/S" AND language_alias="N/S"), "5", "1");
INSERT IGNORE INTO i18n (id, en,fr) VALUES("not menopausal", "Not Menopausal", "Non ménopausée");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- CA125
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET  `type`='float_positive' WHERE model='EventDetail' AND tablename='qc_nd_ed_ca125s' AND field='value' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
ALTER TABLE qc_nd_ed_ca125s MODIFY value decimal(12,2) DEFAULT NULL;
ALTER TABLE qc_nd_ed_ca125s_revs MODIFY value decimal(12,2) DEFAULT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- sardo_import_summary
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE sardo_import_summary
   MODIFY data_type varchar(100) DEFAULT NULL;
ALTER TABLE sardo_import_summary
   MODIFY details varchar(1000) DEFAULT NULL;
   		
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7374' WHERE version_number = '2.7.1';
