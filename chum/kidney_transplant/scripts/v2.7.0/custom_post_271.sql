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
-- Kidney Modifications
-- -----------------------------------------------------------------------------------------------------------------------------------


UPDATE structure_fields SET language_label = 'last modification' WHERE language_label = 'last modification (excepted SARDO imp)';
INSERT INTO i18n (id,en,fr)
VALUES 
('other kidney transplant bank no lab', "Other Kidney/Transplant Bank #","No banque Rein/Transplant - Autre");
  
  
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='collection' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');
 
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_rec_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_reports SET flag_active = 1 WHERE name = 'participant identifiers';

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='code_barre' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET field = 'kidney_transplant_bank_no_lab' WHERE field = 'chum_kidney_transp_bank_no_lab' AND model = '0';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'other_kidney_transplant_bank_no_lab', 'input',  NULL , '0', 'size=20', '', '', 'other kidney transplant bank no lab', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='other_kidney_transplant_bank_no_lab' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='other kidney transplant bank no lab' AND `language_tag`=''), '0', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO i18n (id,en,fr)
VALUES
('no labos [%s] matche other bank numbers', 
"No Labos [%s] matche 'Other Kidney/Transplant Bank #' that won't be linked to the data. Please use the Bank# assigned to data if required.", 
"Les No Labos [%s] correspondent à d'autres 'No banque Rein/Transplant' qui ne sont pas liés aux données. Utilisez le bon numéro de banque assignée aux données au besoin");
   		
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7385' WHERE version_number = '2.7.1';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Modification after first revision/test (20180828)
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Change Hospital Number Format

UPDATE misc_identifier_controls SET reg_exp_validation = '^((H)|(HD))[\\d]+$', user_readable_format = 'HD#', misc_identifier_format = 'HD' WHERE misc_identifier_name = 'hotel-dieu id nbr';
UPDATE misc_identifier_controls SET reg_exp_validation = '^((N)|(ND))[\\d]+$', user_readable_format = 'ND#', misc_identifier_format = 'ND' WHERE misc_identifier_name = 'notre-dame id nbr';
UPDATE misc_identifier_controls SET reg_exp_validation = '^((S)|(SL))[\\d]+$', user_readable_format = 'SL#', misc_identifier_format = 'SL' WHERE misc_identifier_name = 'saint-luc id nbr';

-- Remove SARDO menus

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Administrate/SardoMigrations/%';

-- Move collection visit_label to read only

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='visit_label' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_visit_label') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='visit_label' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_visit_label') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='visit_label' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_visit_label') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='visit_label' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_visit_label') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='visit_label' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_visit_label') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='visit_label' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_visit_label') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='visit_label' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_visit_label') AND `flag_confidential`='0');

-- Drop down list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Message Types');
DELETE FROM `structure_permissible_values_customs` WHERE control_id = @control_id AND value IN ('CA-125');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot Use and Event Types');
DELETE FROM `structure_permissible_values_customs` WHERE control_id = @control_id AND value IN ('CA-125','FACs','PDX','MDT','Redistribution par client');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Laboratory Staff');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("stephanie lariviere-beaudoin", "Stephanie Lariviere-Beaudoin", "Stephanie Lariviere-Beaudoin", '1', @control_id, NOW(), NOW(), 1, 1);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Specimen Collection Sites');
DELETE FROM `structure_permissible_values_customs` WHERE control_id = @control_id;
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('chum test centres', 'CHUM - Test Centres', 'CHUM - Centre de prélèvements', '1', @control_id, NOW(), NOW(), 1, 1),
("crchum 6th floor", "CRCHUM - 6th Floor", "CRCHUM - 6ème étage", '1', @control_id, NOW(), NOW(), 1, 1);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Specimen Supplier Departments');
DELETE FROM `structure_permissible_values_customs` WHERE control_id = @control_id;
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('chum test centres', 'CHUM - Test Centres', 'CHUM - Centre de prélèvements', '1', @control_id, NOW(), NOW(), 1, 1),
("crchum 6th floor", "CRCHUM - 6th Floor", "CRCHUM - 6ème étage", '1', @control_id, NOW(), NOW(), 1, 1);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Laboratory Sites');
DELETE FROM `structure_permissible_values_customs` WHERE control_id = @control_id;
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('12th floor lab - dr hebert', 'Dre Marie-Josée Hébert Laboratory', "Laboratoire Dre Marie-Josée Hébert", '1', @control_id, NOW(), NOW(), 1, 1);

-- Participant alive default value

UPDATE structure_fields SET `default`='alive' WHERE model='Participant' AND tablename='participants' AND field='vital_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='health_status');
UPDATE structure_fields SET `default`='crchum 6th floor' WHERE model='Collection' AND field='collection_site';
UPDATE structure_fields SET `default`='crchum 6th floor' WHERE model='SpecimenDetail' AND field='supplier_dept';
UPDATE structure_fields SET `default`='stephanie lariviere-beaudoin' WHERE model='SpecimenDetail' AND field='reception_by';
UPDATE structure_fields SET `default`='12th floor lab - dr hebert' WHERE model='DerivativeDetail' AND field='creation_site';
UPDATE structure_fields SET `default`='stephanie lariviere-beaudoin' WHERE model='DerivativeDetail' AND field='creation_by';

-- Change misc identifier 'kidney transplant bank no lab'

UPDATE misc_identifier_controls 
SET autoincrement_name = '', misc_identifier_format = '', reg_exp_validation = '^CHUM[0-9]{5}$', user_readable_format = 'CHUM00000', pad_to_length = 0
WHERE misc_identifier_name = 'kidney transplant bank no lab';
DELETE  FROM key_increments WHERE key_name='kidney transplant bank no lab';
UPDATE misc_identifier_controls 
SET autoincrement_name = '', misc_identifier_format = '', reg_exp_validation = '^CHUM[0-9]{5}$', user_readable_format = 'CHUM00000', pad_to_length = 0
WHERE misc_identifier_name = 'other kidney transplant bank no lab';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('kidney transplant bank no lab must be unique', 
"Kidney transplant bank no lab must be unique! Please check both 'Kidney/Transplant Bank #' and 'Other Kidney/Transplant Bank #'.", 
"No banque Rein/Transplant doit être unique! Veuillez vérifier les 'No banque Rein/Transplant' et les 'No banque Rein/Transplant - Autre'.");

-- Template init

UPDATE structure_formats SET `language_heading`='specimen' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_initial_storage_datetime_defintion' AND `language_label`='initial storage date' AND `language_tag`=''), '3', '1000', 'aliquot', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `language_heading`='derivative' WHERE structure_id=(SELECT id FROM structures WHERE alias='template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/StorageLayout/storage_masters/autocompleteLabel' AND `default`='' AND `language_help`='' AND `language_label`='storage' AND `language_tag`='storage selection label'), '3', '1100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- barcode

UPDATE structure_formats SET `flag_override_setting`='1', `setting`='size=30,placeholder=-- ATiM# --' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_validations 
WHERE structure_field_id = (SELECT id FROM structure_fields WHERE model = 'AliquotMaster' AND field = 'barcode') AND rule = 'notBlank';
INSERT INTO structure_validations (structure_field_id, rule, language_message)
VALUES
((SELECT id FROM structure_fields WHERE model = 'AliquotMaster' AND field = 'barcode'), 'custom,/^(?![Aa][Tt][Ii][Mm]#).*/', 'error barcode should be different than system barcode');
INSERT INTO i18n (id,en,fr)
VALUES
('error barcode should be different than system barcode', 
"The barcode value should not beginn as 'ATiM#'!", "La valeur du code-barres ne doit pas commencer par 'ATiM#'!");

-- biological hazard

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('aliquots of the collection present a confirmed biological hazard',
"Aliquots of the collection present a confirmed biological hazard!",
"Les aliquots de la collections présentent un risque biologique confirmé!"),
('no participant is linked to the collection - biological hazard can not be evaluated',
"No participant is linked to the collection! The biological hazard can not be evaluated!",
"Aucun participant n'est lié à la collection! Le risque biologique ne peut pas être évalué!"),
('at least one aliquot/sample is not linked to a collection - biological hazard can not be evaluated',
"At least one aliquot/sample is not linked to a collection! The biological hazard can not be evaluated!",
"Au moins un aliquot/échantillon n'est pas lié à un participant! Le risque biologique ne peut pas être évalué!"),
('at least one aliquot/sample presents a confirmed biological hazard',
"At least one aliquot/sample poses a confirmed biological hazard!", 
"Au moins une aliquote / échantillon présente un risque biologique confirmé!");



Aller chercher les RR1 dans le fichiers de commentaire pour les collections dont seules la reception des tubes à été enregistrés dans le fichier de Nelson.
Avoir un profil infirmier accès en writte mode a clinicalsupprimer cst CHUM RAMAN
