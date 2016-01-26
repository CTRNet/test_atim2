-- Missing i18n

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('wrong concentration unit', 'A Concentration Unit is not supported!', 'Une unité de concentration n''est pas supportée.'),
('aliquot barcode format errror - integer value expected','Identification (alq.) format errror. Integer value expected.',"Erreur de format de l'identification (alq.). Cette donnée doit être une valeur entière");

-- Order

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='short_title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='comments' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='institution' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='orders_institution') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='orders') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Order' AND `tablename`='orders' AND `field`='contact' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='orders_contact') AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_help`='',  `language_label`='study / project' WHERE model='Order' AND tablename='orders' AND field='default_study_summary_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list');
ALTER TABLE shipments ADD COLUMN procure_shipping_conditions VARCHAR(50);
ALTER TABLE shipments_revs ADD COLUMN procure_shipping_conditions VARCHAR(50);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_shipping_conditions", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Shipping Conditions\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('Shipping Conditions', 1, 50, 'order');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'Shipment', 'shipments', 'procure_shipping_conditions', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_shipping_conditions') , '0', '', '', '', 'shipping conditions', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='shipments'), (SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='procure_shipping_conditions' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_shipping_conditions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='shipping conditions' AND `language_tag`=''), '0', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) 
VALUES 
('shipping conditions','Shipping Conditions','Conditions d''envoie');
UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='datetime_received' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='shipments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Shipment' AND `tablename`='shipments' AND `field`='procure_shipping_conditions' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_shipping_conditions') AND `flag_confidential`='0');

ALTER TABLE order_items ADD COLUMN procure_shipping_aliquot_label VARCHAR(60);
ALTER TABLE order_items_revs ADD COLUMN procure_shipping_aliquot_label VARCHAR(60);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Order', 'OrderItem', 'order_items', 'procure_shipping_aliquot_label', 'input',  NULL , '0', 'size=30', '', '', 'procure shipping aliquot label', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='orderitems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='procure_shipping_aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='procure shipping aliquot label' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en,fr) 
VALUES 
('procure shipping aliquot label','Shipping Label','Étiquette d''envoie');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='shippeditems'), (SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='procure_shipping_aliquot_label' AND `type`='input'), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `flag_addgrid`='0', `flag_addgrid_readonly`='0', `flag_editgrid`='0', `flag_editgrid_readonly`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='shippeditems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='OrderItem' AND `tablename`='order_items' AND `field`='procure_shipping_aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Quality Control

SELECT 'Removed QualityCtrl Shipping to CRN information. Please review data if following count is not equal to 0' AS '### TODO ###';
SELECT count(*) 'Nbr of Quality Control with CRN info. To clean up before migration' FROM quality_ctrls
WHERE (procure_shippment_to_crn_date IS NOT NULL AND procure_shippment_to_crn_date NOT LIKE '')
OR (procure_shippment_to_crn_by IS NOT NULL AND procure_shippment_to_crn_by NOT LIKE '')
OR (procure_arrival_at_crn_date IS NOT NULL AND procure_arrival_at_crn_date NOT LIKE '')
OR (procure_arrival_at_crn_by IS NOT NULL AND procure_arrival_at_crn_by NOT LIKE '')
OR (procure_return_to_site_date IS NOT NULL AND procure_return_to_site_date NOT LIKE '')
OR (procure_return_to_site_by IS NOT NULL AND procure_return_to_site_by NOT LIKE '');
ALTER TABLE quality_ctrls
  DROP COLUMN procure_shippment_to_crn_date,
  DROP COLUMN procure_shippment_to_crn_date_accuracy,
  DROP COLUMN procure_shippment_to_crn_by,
  DROP COLUMN procure_arrival_at_crn_date,
  DROP COLUMN procure_arrival_at_crn_date_accuracy,
  DROP COLUMN procure_arrival_at_crn_by,
  DROP COLUMN procure_return_to_site_date,
  DROP COLUMN procure_return_to_site_date_accuracy,
  DROP COLUMN procure_return_to_site_by;
ALTER TABLE quality_ctrls_revs
  DROP COLUMN procure_shippment_to_crn_date,
  DROP COLUMN procure_shippment_to_crn_date_accuracy,
  DROP COLUMN procure_shippment_to_crn_by,
  DROP COLUMN procure_arrival_at_crn_date,
  DROP COLUMN procure_arrival_at_crn_date_accuracy,
  DROP COLUMN procure_arrival_at_crn_by,
  DROP COLUMN procure_return_to_site_date,
  DROP COLUMN procure_return_to_site_date_accuracy,
  DROP COLUMN procure_return_to_site_by;
 DELETE FROM structure_formats 
WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='QualityCtrl' AND `tablename`='quality_ctrls' 
AND `field` IN ('procure_shippment_to_crn_date','procure_shippment_to_crn_by','procure_arrival_at_crn_date','procure_arrival_at_crn_by','procure_return_to_site_date','procure_return_to_site_by'));
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='QualityCtrl' AND `tablename`='quality_ctrls' 
AND `field` IN ('procure_shippment_to_crn_date','procure_shippment_to_crn_by','procure_arrival_at_crn_date','procure_arrival_at_crn_by','procure_return_to_site_date','procure_return_to_site_by'));
DELETE FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='QualityCtrl' AND `tablename`='quality_ctrls' 
AND `field` IN ('procure_shippment_to_crn_date','procure_shippment_to_crn_by','procure_arrival_at_crn_date','procure_arrival_at_crn_by','procure_return_to_site_date','procure_return_to_site_by');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'procure_concentration', 'float_positive',  NULL , '0', 'size=5', '', '', 'aliquot concentration', ''), 
('InventoryManagement', 'QualityCtrl', 'quality_ctrls', 'procure_concentration_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='procure_concentration' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='aliquot concentration' AND `language_tag`=''), '0', '40', 'concentration - if applicable', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qualityctrls'), (SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='procure_concentration_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('concentration - if applicable', 'Concentration (If applicable)', 'Concentration (Si applicable)');
ALTER TABLE quality_ctrls
  ADD COLUMN `procure_concentration` decimal(10,2) DEFAULT NULL,
  ADD COLUMN `procure_concentration_unit` varchar(20) DEFAULT NULL;
ALTER TABLE quality_ctrls_revs
  ADD COLUMN `procure_concentration` decimal(10,2) DEFAULT NULL,
  ADD COLUMN `procure_concentration_unit` varchar(20) DEFAULT NULL;

UPDATE structure_formats SET `display_order`='50' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='procure_concentration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='51' WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='QualityCtrl' AND `tablename`='quality_ctrls' AND `field`='procure_concentration_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='concentration_unit') AND `flag_confidential`='0');

-- Path REview

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/InventoryManagement/SpecimenReviews%';
UPDATE aliquot_controls AC, sample_controls SC 
SET AC.flag_active=true 
WHERE AC.sample_control_id = SC.id AND AC.aliquot_type = 'slide' AND SC.sample_type = 'tissue';
UPDATE realiquoting_controls 
SET flag_active=true WHERE parent_aliquot_control_id = (SELECT AC.id FROM aliquot_controls AC INNER JOIN sample_controls SC ON AC.sample_control_id = SC.id WHERE AC.aliquot_type = 'block' AND SC.sample_type = 'tissue')
AND child_aliquot_control_id = (SELECT AC.id FROM aliquot_controls AC INNER JOIN sample_controls SC ON AC.sample_control_id = SC.id WHERE AC.aliquot_type = 'slide' AND SC.sample_type = 'tissue');

INSERT INTO `aliquot_review_controls` (`id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `aliquot_type_restriction`, `databrowser_label`) VALUES
(null, 'procure tissue slide review', 1, 'procure_ar_tissue_slides', 'procure_ar_tissue_slides', 'slide', 'procure tissue slide review');
INSERT INTO `specimen_review_controls` (`id`, `sample_control_id`, `aliquot_review_control_id`, `review_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`) VALUES
(null, (SELECT id FROM sample_controls WHERE sample_type = 'tissue'), (SELECT id FROM aliquot_review_controls WHERE review_type = 'procure tissue slide review'), 'prostate review', 1, 'procure_spr_prostate', 'procure_spr_prostate', 'tissue|prostate review');
CREATE TABLE IF NOT EXISTS `procure_ar_tissue_slides` (
  `aliquot_review_master_id` int(11) NOT NULL,
  gleason_grade varchar(5),
  gleason_sum int(3),
  KEY `FK_procure_ar_tissue_slides_aliquot_review_masters` (`aliquot_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `procure_ar_tissue_slides_revs` (
  `aliquot_review_master_id` int(11) NOT NULL,
  gleason_grade varchar(5),
  gleason_sum int(3),
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE IF NOT EXISTS `procure_spr_prostate` (
  `specimen_review_master_id` int(11) NOT NULL,
  KEY `FK_procure_spr_prostate_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `procure_spr_prostate_revs` (
  `specimen_review_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `procure_ar_tissue_slides`
  ADD CONSTRAINT `FK_procure_ar_tissue_slides_aliquot_review_masters` FOREIGN KEY (`aliquot_review_master_id`) REFERENCES `aliquot_review_masters` (`id`);
ALTER TABLE `procure_spr_prostate`
  ADD CONSTRAINT `FK_procure_spr_prostate_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);

UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='basis_of_specimen_review' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name) VALUES ('procure_gleason_grades');
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
('1+1','1+1'),
('1+2','1+2'),
('2+1','2+1'),
('2+2','2+2'),
('2+3','2+3'),
('2+4','2+4'),
('3+1','3+1'),
('3+2','3+2'),
('3+3','3+3'),
('3+4','3+4'),
('3+5','3+5'),
('4+2','4+2'),
('4+3','4+3'),
('4+4','4+4'),
('4+5','4+5'),
('5+3','5+3'),
('5+4','5+4'),
('5+5','5+5');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="1+1" AND language_alias="1+1"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="1+2" AND language_alias="1+2"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="2+1" AND language_alias="2+1"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="2+2" AND language_alias="2+2"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="2+3" AND language_alias="2+3"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="2+4" AND language_alias="2+4"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="3+1" AND language_alias="3+1"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="3+2" AND language_alias="3+2"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="3+3" AND language_alias="3+3"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="3+4" AND language_alias="3+4"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="3+5" AND language_alias="3+5"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="4+2" AND language_alias="4+2"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="4+3" AND language_alias="4+3"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="4+4" AND language_alias="4+4"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="4+5" AND language_alias="4+5"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="5+3" AND language_alias="5+3"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="5+4" AND language_alias="5+4"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="5+5" AND language_alias="5+5"), "", "1");
INSERT INTO structures(`alias`) VALUES ('procure_spr_prostate');
INSERT INTO structures(`alias`) VALUES ('procure_ar_tissue_slides');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotReviewDetail', 'procure_ar_tissue_slides', 'gleason_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_gleason_grades') , '0', '', '', '', 'gleason grade', ''), 
('InventoryManagement', 'AliquotReviewDetail', 'procure_ar_tissue_slides', 'gleason_sum', 'integer_positive',  NULL , '0', '', '', '', 'gleason sum', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='procure_ar_tissue_slides' AND `field`='gleason_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_gleason_grades')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason grade' AND `language_tag`=''), '0', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ar_tissue_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotReviewDetail' AND `tablename`='procure_ar_tissue_slides' AND `field`='gleason_sum' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason sum' AND `language_tag`=''), '0', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('gleason grade','Gleason Grade','Gleason - Grade'),('gleason sum','Gleason Sum','Gleason - Somme');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `field`='aliquot_master_id'), 'notEmpty');
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = '1', flag_active_2_to_1 = '1'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('SpecimenReviewMaster', 'AliquotReviewMaster'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('SpecimenReviewMaster', 'AliquotReviewMaster'));
INSERT INTO i18n (id,en,fr) 
VALUES
('prostate review','Prostate Review', 'Prostate - Révision'),
('procure tissue slide review','Slide Review','Révision de lame');

ALTER TABLE specimen_review_masters ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
ALTER TABLE specimen_review_masters_revs ADD COLUMN procure_created_by_bank CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SpecimenReviewMaster', 'specimen_review_masters', 'procure_created_by_bank', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') , '0', '', '', '', 'created by bank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='specimen_review_masters'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='procure_created_by_bank' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='created by bank' AND `language_tag`=''), '0', '9', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO i18n (id,en,fr) VALUES ("no aliquot to test exists","No aliquot to test exists.","Aucun aliquot à tester existe.");

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- BATCH ACTIONS & REPORT
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions SET flag_active = 1
WHERE datamart_structure_id IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('ConsentMaster',
		'SpecimenReviewMaster',
		'AliquotReviewMaster'))
AND label IN ('number of elements per participant');
UPDATE datamart_structure_functions SET flag_active = 0
WHERE datamart_structure_id IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('Participant'))
AND label IN ('edit');

UPDATE datamart_structure_functions SET flag_active = 0
WHERE datamart_structure_id IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('TmaSlide'))
OR label IN ('create tma slide');
																	
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Slide to block creation : inactivate
-- Block to block activated
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE realiquoting_controls SET flag_active=false WHERE id IN(9);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(48);

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Inactivate link collection to consent, treatment and event into databrowser
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('ConsentMaster', 'TreatmentMaster', 'EventMaster'))
AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('ViewCollection'));
UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id2 IN (SELECT id FROM datamart_structures WHERE model IN ('ConsentMaster', 'TreatmentMaster', 'EventMaster'))
AND id1 IN (SELECT id FROM datamart_structures WHERE model IN ('ViewCollection'));

-- ------------------------------------------------------------------------------------------------------------------------------------------
-- See blood in tree view
-- ------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='blood_type') AND `flag_confidential`='0');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Set tissue patho report number to confidential
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET flag_confidential = 1 WHERE `field` LIKE 'procure_report_number';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Fix bug on procure_transferred_aliquots_details form : copy/past duplicated
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_addgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_transferred_aliquots_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Remove TmaSlide from databrowser
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls 
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('TmaSlide'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('TmaSlide'));

-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6332' WHERE version_number = '2.6.6';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Display Aliquot Label in index view, list, etc...
-- ----------------------------------------------------------------------------------------------------------------------------------------

SET @flag_aliquot_label = (SELECT flag_detail FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label'));
UPDATE structure_formats SET `flag_edit`=@flag_aliquot_label, `flag_edit_readonly`=@flag_aliquot_label, `flag_search`=@flag_aliquot_label, `flag_index`=@flag_aliquot_label WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='200', `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`=@flag_aliquot_label, `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`=@flag_aliquot_label WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_storage_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`=@flag_aliquot_label, `flag_addgrid_readonly`=@flag_aliquot_label, `flag_editgrid`=@flag_aliquot_label, `flag_editgrid_readonly`=@flag_aliquot_label WHERE structure_id=(SELECT id FROM structures WHERE alias='children_aliquots_selection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`=@flag_aliquot_label, `flag_edit_readonly`=@flag_aliquot_label WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`=@flag_aliquot_label, `flag_edit_readonly`=@flag_aliquot_label, `flag_index`=@flag_aliquot_label WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`=@flag_aliquot_label, `flag_detail`=@flag_aliquot_label WHERE structure_id=(SELECT id FROM structures WHERE alias='qualityctrls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`=@flag_aliquot_label, `flag_edit_readonly`=@flag_aliquot_label, `flag_addgrid`=@flag_aliquot_label, `flag_addgrid_readonly`=@flag_aliquot_label, `flag_editgrid`=@flag_aliquot_label, `flag_editgrid_readonly`=@flag_aliquot_label, `flag_index`=@flag_aliquot_label WHERE structure_id=(SELECT id FROM structures WHERE alias='sourcealiquots') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`=@flag_aliquot_label, `flag_index`=@flag_aliquot_label WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Aliquot Barcode And Label Update
-- ----------------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('at least one aliquot procure identification does not match the collection visit', 'At least one aliquot procure identification does not match the collection visit.', 'Au moins une identification d''aliquot ne correspond pas à la visite de la collection.');
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), 'update aliquot barcode (and label)', '/InventoryManagement/AliquotMasters/editBarcodeAndLabel/', 1, '');

INSERT INTO structures(`alias`) VALUES ('procure_aliquot_barcode_and_label_update');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30,class=range file' AND `default`='' AND `language_help`='' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '-1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='procure_visit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_collection_visit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='visit' AND `language_tag`=''), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot type' AND `language_tag`=''), '0', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '1', 'size=30,class=file', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='in_stock' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='aliquot_in_stock_help' AND `language_label`='aliquot in stock' AND `language_tag`=''), '0', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='selection_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='stor_selection_label_defintion' AND `language_label`='storage' AND `language_tag`=''), '0', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='storage_coord_x' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=11' AND `default`='' AND `language_help`='' AND `language_label`='position into storage' AND `language_tag`=''), '0', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='storage_coord_y' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=11' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='aliquot procure identification' AND `language_tag`=''), '0', '50', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '51', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `language_heading`='new data' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_aliquot_barcode_and_label_update') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('update aliquot barcode (and label)', 'Update Aliquot Identifications (and Labels)', 'Modifier identifications et étiquettes'),
('aliquot barcode (and label) update', 'Aliquot Identifications (and Labels) Update', 'Modification des identifications et étiquettes'),
('you can not edit 2 aliquots with the same barcode','You can not edit 2 aliquots with the same identification','Vous ne pouvez pas modified deux aliquots avec la même identification'),
('you are editing aliquots that have already been sent to processing site', 'You are editing aliquots that have already been sent to processing site', 'Vous modifiez des aliquots qui ont été déjà envoyés au site de traitement'),
('new data', 'New Data', 'Nouvelles Données');

SELECT 'Allow only administrator to update aliquot identification (barcode) and label' AS '### TODO ###';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Add Month Into Follow-up Report
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_order`= (`display_order` * 10) WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_followups_report_result');
UPDATE structure_formats SET `display_order`=(`display_order` + 5) WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_followups_report_result') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field` LIKE 'procure_%_first_collection_date');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
(SELECT 'Datamart', '0', '', REPLACE(field, '_date', '_month'), 'integer',  NULL , '0', '', '', '', 'month', '' FROM structure_fields WHERE model = '0' AND field LIKE 'procure_%_followup_worksheet_date');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
(SELECT 'Datamart', '0', '', REPLACE(field, '_date', '_month'), 'integer',  NULL , '0', '', '', '', 'month', '' FROM structure_fields WHERE model = '0' AND field LIKE 'procure_%_medication_worksheet_date');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
(SELECT 'Datamart', '0', '', REPLACE(field, '_date', '_month'), 'integer',  NULL , '0', '', '', '', 'month', '' FROM structure_fields WHERE model = '0' AND field LIKE 'procure_%_first_collection_date');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_index`)
(SELECT sfo.structure_id, sfi_m.id, sfo.display_column, (sfo.display_order+1), '1'
FROM structure_fields sfi_d, structure_fields sfi_m, structure_formats sfo
WHERE sfo.structure_field_id = sfi_d.id
AND sfi_d.field LIKE 'procure_%_followup_worksheet_date' 
AND sfi_m.field LIKE 'procure_%_followup_worksheet_month'
AND SUBSTRING(sfi_d.field, 1, 10) = SUBSTRING(sfi_m.field, 1, 10));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_index`)
(SELECT sfo.structure_id, sfi_m.id, sfo.display_column, (sfo.display_order+1), '1'
FROM structure_fields sfi_d, structure_fields sfi_m, structure_formats sfo
WHERE sfo.structure_field_id = sfi_d.id
AND sfi_d.field LIKE 'procure_%_medication_worksheet_date' 
AND sfi_m.field LIKE 'procure_%_medication_worksheet_month'
AND SUBSTRING(sfi_d.field, 1, 10) = SUBSTRING(sfi_m.field, 1, 10));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_index`)
(SELECT sfo.structure_id, sfi_m.id, sfo.display_column, (sfo.display_order+1), '1'
FROM structure_fields sfi_d, structure_fields sfi_m, structure_formats sfo
WHERE sfo.structure_field_id = sfi_d.id
AND sfi_d.field LIKE 'procure_%_first_collection_date' 
AND sfi_m.field LIKE 'procure_%_first_collection_month'
AND SUBSTRING(sfi_d.field, 1, 10) = SUBSTRING(sfi_m.field, 1, 10));
UPDATE structure_fields SET language_label = '', language_tag = '' WHERE model = '0' AND (field LIKE 'procure_%_medication_worksheet_month' OR field LIKE 'procure_%_first_collection_month' OR field LIKE 'procure_%_followup_worksheet_month');
INSERT INTO i18n (id,en,fr) VALUES ('months','Months','Mois');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Barcode Error List
-- ----------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `associated_datamart_structure_id`, `limit_access_from_datamart_structrue_function`) VALUES
(null, 'procure barcode errors', 'procure barcode errors description', 'procure_barcode_errors_list', 'procure_barcode_errors_list,view_aliquot_joined_to_sample_and_collection', 'index', 'procureGetListOfBarcodeErrors', 1, (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), 0);
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('procure barcode errors', 'PROCURE - Wrong Aliquot Identifiers Formats', 'PROCURE - Mauvais format d''identifiants d''aliquots'),
('procure barcode errors description', 'List all wrong aliquot identifiers formats based on participant identifier and visit.', 'Liste tous les mauvais formats d''identifiants d''aliquots selon l''identifieant du patient et la visite.');

INSERT INTO structures(`alias`) VALUES ('procure_barcode_errors_list');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_barcode_error', 'input',  NULL , '0', '', '', '', 'error', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_barcode_errors_list'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30,class=range file' AND `default`='' AND `language_help`='' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '-1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_barcode_errors_list'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_barcode_error' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='error' AND `language_tag`=''), '0', '100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('error','Error','Erreur'),
("duplicated", "Duplicated", 'Dupliqué'),
("wrong visit", "Wrong Visit", "Mauvaise visiste"),
("wrong participant identifier", "Wrong Participant Identifier", "Mauvais identifiant de patient"),
("wrong suffix (-AAA)", "Wrong Suffix (-AAA)", "Mauvais suffix (-AAA)"),
("wrong format", "Wrong Format", "Mauvais format");

SELECT "Please run 'PROCURE - Wrong Aliquot Identifiers Formats' to list any barcode error." AS MSG;

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('aliquot barcode format errror - should begin with the participant identifier and the visit PS0P0000 V00 -AAA', 
'Identification (alq.) format errror. This one should start with the participant identification and the visit (PS0P0000 V00 -AAA)', 
'Erreur de format de l''identification (alq.). Cette donnée doit commencer avec l''identifiant du patient puis le numéro de visit (PS0P0000 V00 -AAA)');

-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6342' WHERE version_number = '2.6.6';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE participants CHANGE procure_proc_site_participant_identifier procure_participant_attribution_number INT(10);
ALTER TABLE participants_revs CHANGE procure_proc_site_participant_identifier procure_participant_attribution_number INT(10);
UPDATE structure_fields SET language_label = 'procure participant attribution number' WHERE language_label = 'procure processing site participant identifier';
UPDATE structure_fields SET field = 'procure_participant_attribution_number' WHERE field = 'procure_proc_site_participant_identifier';
INSERT INTO i18n (id,en,fr) VALUES ('procure participant attribution number', 'Attribution  #', '# Attribution');

UPDATE structure_formats SET `display_order`='199' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES ("you have been redirected to the 'add transferred aliquots' form",
"You have been redirected to the 'Add Transferred Aliquots' form",
"Vous avez été redirigé vers l'écran de 'Creation des aliquots transférés");

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'Xenograft%';
SELECT 'Set flag_active = 0 to unused structure_permissible_values_custom_controls (see list below)' AS '### TODO ###';
SELECT st.alias, sfi.field, ctrl.name AS 'List control name'
FROM structures st
INNER JOIN structure_formats sfo ON sfo.structure_id = st.id
INNER JOIN structure_fields sfi ON sfi.id = sfo.structure_field_id
INNER JOIN structure_value_domains svd ON svd.id = sfi.structure_value_domain
INNER JOIN structure_permissible_values_custom_controls ctrl ON svd.source LIKE CONCAT('%',ctrl.name,'%')
WHERE sfo.flag_detail = 1 AND svd.source LIKE 'StructurePermissibleValuesCustom::getCustomDropdown%' AND ctrl.flag_active = 1
ORDER BY ctrl.name;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("s","system option");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="s" AND language_alias="system option"), "", "1");
INSERT INTO i18n (id,en,fr) VALUES ("system option","Sys","Sys");
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('you can not select the system option as bank sending sample', 'You can not select the ''System'' as bank sending sample', 'Vous ne pouvez pas choisir le ''Système'' comme banque ayant envoyé les échantillons'),
('at least one data is linked to the sample of the aliquot - delete all records then delete the aliquot of the sample', 
'At least one data is linked to the sample of the aliquot. Please delete all records first, then the trsnferred aliquot then the sample.', 
"Au moins une données est liée à l'échantillon de l'aliquot. Veuillez supprimer tous les enregistrements, puis l'aliquot transféré et enfin l'échantillon.");

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `display_order`='101', `flag_override_label`='1', `language_label`='', `flag_override_tag`='1', `language_tag`='site' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='101', `flag_override_label`='1', `language_label`='site', `flag_override_tag`='1', `language_tag`='site' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='procure_created_by_bank' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS procure_banks_data_merge_messages;
CREATE TABLE IF NOT EXISTS `procure_banks_data_merge_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  message_nbr int(10) default null,
  title varchar(250) default null,
  description varchar(500) default null,
  details varchar(250) default null,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
DROP TABLE IF EXISTS procure_banks_data_merge_messages_revs;
CREATE TABLE IF NOT EXISTS `procure_banks_data_merge_messages_revs` (
  `id` int(11) NOT NULL,
  message_nbr int(10) default null,
  title varchar(250) default null,
  description varchar(500) default null,
  details varchar(250) default null,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `default_required_date_accuracy` char(1) DEFAULT 'c',
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`) VALUES
('core_CAN_41_procure_merge', 'core_CAN_41', 0, 7, 'procure banks data merge summary', '', '/Administrate/ProcureBanksDataMergeSummary/listAll/', '', 1, 1);

INSERT INTO structures(`alias`) VALUES ('procure_banks_data_merge_summary');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Generated', '', 'procure_banks_data_merge_date', 'date',  NULL , '0', '', '', '', 'last banks data merge process', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_banks_data_merge_summary'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='procure_banks_data_merge_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last banks data merge process' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structures(`alias`) VALUES ('procure_banks_data_merge_messages');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'ProcureBanksDataMergeMessage', 'procure_banks_data_merge_messages', 'details', 'input',  NULL , '0', '', '', '', 'detail', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_banks_data_merge_messages'), (SELECT id FROM structure_fields WHERE `model`='ProcureBanksDataMergeMessage' AND `tablename`='procure_banks_data_merge_messages' AND `field`='details' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='detail' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO i18n (id,en,fr)
VALUES 
('last banks data merge process', 'Last Banks Data Merge', 'Dernière fusion des données des banques'),
('procure banks data merge summary', 'Banks Data Merge Summary', 'Résumé de la fusion des données des banques');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '6381' WHERE version_number = '2.6.6';
UPDATE versions SET site_branch_build_number = '?' WHERE version_number = '2.6.6';
UPDATE versions SET permissions_regenerated = 0;

-- ----------------------------------------------------------------------------------------------------------------------------------------
