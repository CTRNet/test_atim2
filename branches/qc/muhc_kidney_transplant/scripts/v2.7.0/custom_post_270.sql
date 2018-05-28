-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'MUHC - Kidney Transplant', 'CUSM - Transplantation rénale');
UPDATE groups SET flag_show_confidential = '1' WHERE id = 1;
UPDATE users SET flag_active = '1', password_modified = NOW(), force_password_reset = '0' WHERE id = 1;

UPDATE users SET flag_active = 0, username = 'MigrationScript', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id = 2;
UPDATE groups SET name = 'System' WHERE id = 2;
SET @modified = (SELECT NOW() FROM users WHERE id = '2');
SET @modified_by = (SELECT id FROM users WHERE id = '2');

UPDATE users SET flag_active = 0, password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id > 2;

UPDATE `banks` SET name = 'Kidney Transplant' WHERE id = 1;

-- Menus Update - Unused features/functionnalities at step 1
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Protocol%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Drug%';
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/Sop%';

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ConsentMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories/%';

-- Participant Profile
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0', `flag_batchedit`='0'
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('title', 'middle_name', 'cod_confirmation_source', 'secondary_cod_icd10_code', 'language_preferred'));

-- Participant Identifier
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) 
VALUES
(null, 'ramq nbr', 1, 10, '', '', 
1, 1, 1, 0, '', '', 0),
(null, 'MGH-MRN', 1, 15, '', '', 
1, 1, 1, 0, '', '', 0),
(null, 'RVC-MRN', 1, 15, '', '', 
1, 1, 1, 0, '', '', 0);

INSERT IGNORE  into i18n (id,en,fr)
VALUES
('ramq nbr', 'RAMQ', 'RAMQ'),
('MGH-MRN', 'MGH-MRN', 'MGH-MRN'),
('RVC-MRN', 'RVC-MRN', 'RVC-MRN');

-- Add study to identifier forms

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, flag_link_to_study) 
VALUES
('patient study id', 1, '', '', 0, 0, 0, 0, '', '', '1');
INSERT INTO i18n (id,en,fr) 
VALUES 
('patient study id', 'Patient Study ID', 'ID Patient - Étude');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Activate StudySummary to MiscIdentifier databrowser link

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Collections
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Hide unused fields

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0', `flag_batchedit`='0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('acquisition_label'));
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0', `flag_batchedit`='0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('sop_master_id') AND model LIKE '%collection%');

-- Bank field not blank

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='Collection'  AND `field`='bank_id'), 'notBlank', '');
UPDATE structure_fields SET `default` = '1' WHERE `model`='Collection'  AND `field`='bank_id';

-- Add collection type

ALTER TABLE collections
  ADD COLUMN `cusm_kidney_collection_type` varchar(200) DEFAULT NULL;
ALTER TABLE collections_revs
  ADD COLUMN `cusm_kidney_collection_type` varchar(200) DEFAULT NULL;
  
INSERT INTO structure_value_domains (domain_name, source) VALUES ('cusm_kidney_collection_types', "StructurePermissibleValuesCustom::getCustomDropdown('Collection Types')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Collection Types', 1, 200, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Collection Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('pre-tx (native kidney)', 'Pre-Tx (native kidney)',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('post-tx', 'Post-Tx',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('family member', 'Family member',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('tx donor', 'Tx donor',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('healthy control', 'Healthy control',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);
  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'cusm_kidney_collection_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_kidney_collection_types') , '0', '', '', '', 'collection type', ''),
('InventoryManagement', 'ViewCollection', '', 'cusm_kidney_collection_type', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='cusm_kidney_collection_types') , '0', '', '', '', 'collection type', ''), 
('InventoryManagement', 'ViewSample', '', 'cusm_kidney_collection_type', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='cusm_kidney_collection_types') , '0', '', '', '', 'collection type', ''),
('InventoryManagement', 'ViewAliquot', '', 'cusm_kidney_collection_type', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='cusm_kidney_collection_types') , '0', '', '', '', 'collection type', '');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='Collection'  AND `field`='cusm_kidney_collection_type'), 'notBlank', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_kidney_collection_type' AND `type`='select' ), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='cusm_kidney_collection_type' AND `type`='select'), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_kidney_collection_type' AND `type`='select'), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_kidney_collection_type' AND `type`='select'), '0', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='cusm_kidney_collection_type' AND `type`='select'), '0', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='cusm_kidney_collection_type' AND `type`='select'), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='cusm_kidney_collection_type' AND `type`='select'), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('collection type', 'Collection Type', 'Type de collection');

-- Clinical Collection Link

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model` IN ('Collection','ViewCollection'));

-- Sample
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN('141', '23', '136', '188', '102', '194', '7', '130', '101', '144', '220', '137', '142', '10', '3', '25', '143', '203');
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN('187', '216', '228', '218', '217');
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN('132');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/SpecimenReviews/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/Quality%';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0', `flag_batchedit`='0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('sop_master_id') AND model LIKE '%sample%');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0', `flag_batchedit`='0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('sop_master_id', 'lot_number') AND model LIKE '%aliquot%');

-- Blood

UPDATE structure_value_domains AS svd 
INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id 
INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id 
SET `flag_active`="0" WHERE svd.domain_name='blood_type';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Blood Types')" WHERE domain_name='blood_type';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Blood Types', 1, 30, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Blood Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('edta', 'EDTA',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('heparin', 'Heparin',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('sst', 'SST',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);

-- Plasma

UPDATE aliquot_controls SET volume_unit = 'ul' WHERE sample_control_id = (select id FROm sample_controls WHERE sample_type = 'plasma');

-- Urine

INSERT INTO sample_controls(sample_type, sample_category, detail_form_alias, detail_tablename, databrowser_label)
VALUES
('urine pellet', 'derivative', 'sd_undetailed_derivatives,derivatives', 'cusm_kid_sd_der_urine_pellets', 'urine pellet');
INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id,derivative_sample_control_id , flag_active)
VALUES
((SELECT id FROM sample_controls WHERE sample_type LIKE 'urine'), (SELECT id FROM sample_controls WHERE sample_type LIKE 'urine pellet'),1);
INSERT INTO aliquot_controls (sample_control_id, aliquot_type, detail_form_alias, detail_tablename, flag_active, databrowser_label, volume_unit)
VALUES
((SELECT id FROM sample_controls WHERE sample_type LIKE 'urine pellet'), 'tube', 'ad_der_tubes_incl_ml_vol', 'ad_tubes', '1', 'urine pellet|tube', 'ml');
INSERT INTO realiquoting_controls (parent_aliquot_control_id, child_aliquot_control_id, flag_active)
VALUES
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'urine pellet|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'urine pellet|tube'), '1');

INSERT INTO i18n (id,en,fr)
VALUES
('urine pellet', 'Urine Pellet', 'Culot urine');
REPLACE INTO i18n (id,en,fr)
VALUES
('centrifuged urin', 'Centrifuged Urine (supernatant)', 'Urine centrifugée (surnageant)');

CREATE TABLE `cusm_kid_sd_der_urine_pellets` (
  `sample_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `cusm_kid_sd_der_urine_pellets_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `cusm_kid_sd_der_urine_pellets`
  ADD KEY `FK_cusm_kid_sd_der_urine_pellets_sample_masters` (`sample_master_id`);
ALTER TABLE `cusm_kid_sd_der_urine_pellets_revs`
  ADD PRIMARY KEY (`version_id`);
ALTER TABLE `cusm_kid_sd_der_urine_pellets_revs`
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `cusm_kid_sd_der_urine_pellets`
  ADD CONSTRAINT `FK_cusm_kid_sd_der_urine_pellets_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);

-- Other

CREATE TABLE `cusm_kid_sd_others` (
  `sample_master_id` int(11) NOT NULL,
  type_precision varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `cusm_kid_sd_others_revs` (
  `sample_master_id` int(11) NOT NULL,
  type_precision varchar(250) DEFAULT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `cusm_kid_sd_others`
  ADD KEY `FK_cusm_kid_sd_others_sample_masters` (`sample_master_id`);
ALTER TABLE `cusm_kid_sd_others_revs`
  ADD PRIMARY KEY (`version_id`);
ALTER TABLE `cusm_kid_sd_others_revs`
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `cusm_kid_sd_others`
  ADD CONSTRAINT `FK_cusm_kid_sd_others_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);

INSERT INTO sample_controls(sample_type, sample_category, detail_form_alias, detail_tablename, databrowser_label)
VALUES
('other-specimen', 'specimen', 'cusm_kid_sd_other_specimens,specimens', 'cusm_kid_sd_others', 'other-specimen'),
('other-derivative', 'derivative', 'sd_undetailed_derivatives,derivatives,cusm_kid_sd_other_derivatives', 'cusm_kid_sd_others', 'other-specimen');

INSERT INTO parent_to_derivative_sample_controls (parent_sample_control_id,derivative_sample_control_id , flag_active)
VALUES
(NULL, (SELECT id FROM sample_controls WHERE sample_type LIKE 'other-specimen'),1),
((SELECT id FROM sample_controls WHERE sample_type LIKE 'other-specimen'), (SELECT id FROM sample_controls WHERE sample_type LIKE 'other-derivative'),1),
((SELECT id FROM sample_controls WHERE sample_type LIKE 'other-derivative'), (SELECT id FROM sample_controls WHERE sample_type LIKE 'other-derivative'),1);

INSERT INTO aliquot_controls (sample_control_id, aliquot_type, detail_form_alias, detail_tablename, flag_active, databrowser_label, volume_unit)
VALUES
((SELECT id FROM sample_controls WHERE sample_type LIKE 'other-specimen'), 'tube', 'ad_spec_tubes', 'ad_tubes', '1', 'other-specimen|tube', ''),
((SELECT id FROM sample_controls WHERE sample_type LIKE 'other-derivative'), 'tube', 'cusm_kid_ad_der_others', 'ad_tubes', '1', 'other-derivative|tube', '');
INSERT INTO realiquoting_controls (parent_aliquot_control_id, child_aliquot_control_id, flag_active)
VALUES
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'other-specimen|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'other-specimen|tube'), '1'),
((SELECT id FROM aliquot_controls WHERE databrowser_label = 'other-derivative|tube'), (SELECT id FROM aliquot_controls WHERE databrowser_label = 'other-derivative|tube'), '1');
INSERT INTO structures(`alias`) VALUES ('cusm_kid_ad_der_others');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_kid_ad_der_others'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_kid_ad_der_others'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_kid_ad_der_others'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='cusm_kid_ad_der_others'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('cusm_kid_sd_other_specimens');
INSERT INTO structures(`alias`) VALUES ('cusm_kid_sd_other_derivatives');

INSERT INTO structure_value_domains (domain_name, source)
 VALUES 
 ('cusm_kid_sd_other_specimen_precisions', "StructurePermissibleValuesCustom::getCustomDropdown('Other Specimen Precisions')"),
 ('cusm_kid_sd_other_derivative_precisions', "StructurePermissibleValuesCustom::getCustomDropdown('Other Derivative Precisions')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Other Specimen Precisions', 1, 250, 'inventory'),
('Other Derivative Precisions', 1, 250, 'inventory');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'cusm_kid_sd_others', 'type_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_kid_sd_other_specimen_precisions') , '0', '', '', '', 'precision', ''),
('InventoryManagement', 'SampleDetail', 'cusm_kid_sd_others', 'type_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='cusm_kid_sd_other_derivative_precisions') , '0', '', '', '', 'precision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cusm_kid_sd_other_specimens'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='cusm_kid_sd_others' AND `field`='type_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_kid_sd_other_specimen_precisions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '0', '349', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='cusm_kid_sd_other_derivatives'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='cusm_kid_sd_others' AND `field`='type_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cusm_kid_sd_other_derivative_precisions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '0', '349', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0', `flag_batchedit`='0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('sop_master_id', 'lot_number') AND model LIKE '%aliquot%');

INSERT INTO i18n (id,en,fr)
VALUES
('other-specimen', 'Other (Spec.)', 'Autre (spec.)'),
('other-derivative', 'Other (Der.)', 'Autre (der.)');

-- Other
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Inactivate custom drop down list not used

UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'xenog%';
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'SOP Versions';
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'Quality Control Tools';
UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name LIKE 'Consent Form Versions';

-- Study

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');

-- DataBrowser and Report

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'FamilyHistory') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ReproductiveHistory') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentExtendMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0' WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'AliquotReviewMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'SpecimenReviewMaster');
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 27 AND id2 =25) OR (id1 = 25 AND id2 =27);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 27 AND id2 =23) OR (id1 = 23 AND id2 =27);

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'report_5_name';
UPDATE datamart_reports SET flag_active = '0' WHERE name = 'list all related diagnosis';
UPDATE datamart_reports SET flag_active = '0' WHERE name = 'participant identifiers';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create quality control';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'create quality control';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewCollection' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'participant identifiers report';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ConsentMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'FamilyHistory' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'QualityCtrl' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'EventMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'SpecimenReviewMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ReproductiveHistory' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentExtendMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'AliquotReviewMaster' AND label = 'number of elements per participant';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'create participant message (applied to all)';

-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7103' WHERE version_number = '2.7.0';