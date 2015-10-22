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

UPDATE versions SET branch_build_number = '6322' WHERE version_number = '2.6.6';
