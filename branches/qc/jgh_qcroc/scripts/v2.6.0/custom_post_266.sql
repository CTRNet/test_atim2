-- --------------------------------------------------------------------------------
-- Clinical Annotation
-- --------------------------------------------------------------------------------

-- Profile

ALTER TABLE participants 
  ADD COLUMN qcroc_initials VARCHAR(10) DEFAULT NULL,
  ADD COLUMN qcroc_site VARCHAR(50) DEFAULT NULL;
ALTER TABLE participants_revs
  ADD COLUMN qcroc_initials VARCHAR(10) DEFAULT NULL,
  ADD COLUMN qcroc_site VARCHAR(50) DEFAULT NULL;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qcroc_initials', 'input',  NULL , '1', 'size=5', '', '', 'initials', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qcroc_initials' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initials' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('initials', 'Initials', 'Initiales');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qcroc_participant_sites', "StructurePermissibleValuesCustom::getCustomDropdown('Participant Sites')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Participant Sites', 1, 50, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("Georges L. Dumont", '', '', '1', @control_id, NOW(), NOW(), 1, 1),
("Hopital Charles-LeMoyne", '', '', '1', @control_id, NOW(), NOW(), 1, 1),
("Hôpital du Sacre-Coeur de Montreal", '', '', '1', @control_id, NOW(), NOW(), 1, 1),
("Jewish General Hospital", '', '', '1', @control_id, NOW(), NOW(), 1, 1),
("Montreal General Hospital", '', '', '1', @control_id, NOW(), NOW(), 1, 1),
("Royal Victoria Hospital", '', '', '1', @control_id, NOW(), NOW(), 1, 1),
("St. Mary's Hospital", '', '', '1', @control_id, NOW(), NOW(), 1, 1),
("Sunnybrook Health Sciences Centre", '', '', '1', @control_id, NOW(), NOW(), 1, 1),
("University Hospital Leuven", '', '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qcroc_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_participant_sites') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qcroc_site'), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('site', 'Site', 'Site'); 

-- Identifiers

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qcroc_initials' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initials' AND `language_tag`=''), '0', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qcroc_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_participant_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '0', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='identifier name' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifierControl' AND `tablename`='misc_identifier_controls' AND `field`='misc_identifier_name' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='identifier_name_list') AND `flag_confidential`='0');

-- --------------------------------------------------------------------------------
-- Inventory
-- --------------------------------------------------------------------------------

-- Collection  

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='collection_site');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Specimen Collection Sites');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='qcroc_collection_visit'), 'notEmpty', '');

-- Sample

ALTER TABLE sd_spe_tissues
  CHANGE qcroc_histology qcroc_behavior varchar(50) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs
  CHANGE qcroc_histology qcroc_behavior varchar(50) DEFAULT NULL;
UPDATE structure_value_domains SET domain_name = 'qcroc_tissue_behavior', source = "StructurePermissibleValuesCustom::getCustomDropdown('Tissue Behaviors')" WHERE domain_name = 'qcroc_tissue_histology';
UPDATE structure_permissible_values_custom_controls SET name = 'Tissue Behaviors' WHERE name = 'Tissue Histologies';
UPDATE structure_fields SET  field='qcroc_behavior', `language_label`='behavior' WHERE model='SampleDetail' AND tablename='sd_spe_tissues' AND field='qcroc_histology';
INSERT IGNORE INTO i18n (id,en) VALUES ('behavior','Behavior');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue source' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qcroc_behavior' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_behavior')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='behavior' AND `language_tag`=''), '0', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='', `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='', `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qcroc_behavior' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_behavior') AND `flag_confidential`='0');

-- Block and slide

-- ALTER TABLE ad_blocks 
--   ADD COLUMN qcroc_creation_date DATE DEFAULT NULL,
--   ADD COLUMN qcroc_creation_date_accuracy char(1) NOT NULL DEFAULT '';
-- ALTER TABLE ad_blocks_revs 
--   ADD COLUMN qcroc_creation_date DATE DEFAULT NULL,
--   ADD COLUMN qcroc_creation_date_accuracy char(1) NOT NULL DEFAULT '';
-- INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
-- ('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'qcroc_creation_date', 'date',  NULL , '0', '', '', '', 'creation date', '');
-- INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
-- ((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qcroc_creation_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation date' AND `language_tag`=''), '1', '69', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

-- ALTER TABLE ad_tissue_slides 
--   ADD COLUMN qcroc_creation_date DATE DEFAULT NULL,
--   ADD COLUMN qcroc_creation_date_accuracy char(1) NOT NULL DEFAULT '';
-- ALTER TABLE ad_tissue_slides_revs 
--   ADD COLUMN qcroc_creation_date DATE DEFAULT NULL,
--   ADD COLUMN qcroc_creation_date_accuracy char(1) NOT NULL DEFAULT '';
-- INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
-- ('InventoryManagement', 'AliquotDetail', 'ad_tissue_slides', 'qcroc_creation_date', 'date',  NULL , '0', '', '', '', 'creation date', '');
-- INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
-- ((SELECT id FROM structures WHERE alias='ad_spec_tiss_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tissue_slides' AND `field`='qcroc_creation_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation date' AND `language_tag`=''), '1', '69', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

-- Path review

REPLACE INTO i18n (id,en,fr)
VALUES	
('tumor percentage','&#37; Tumor','&#37; Tumeur'),
('normal percentage', '&#37; Normal', '&#37; Normal'),
('fibrosis percentage', '&#37; Fibrosis', '&#37; Fibrose'),
('necrosis percentage','&#37; Necrosis','&#37; Nécrose');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qcroc_ar_tissue_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotReviewDetail' AND `tablename`='qcroc_ar_tissue_slides' AND `field`='sample_pct_fibrosis' AND `language_label`='fibrosis percentage' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotReviewDetail' AND `tablename`='qcroc_ar_tissue_slides' AND `field`='sample_pct_fibrosis' AND `language_label`='fibrosis percentage' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='AliquotReviewDetail' AND `tablename`='qcroc_ar_tissue_slides' AND `field`='sample_pct_fibrosis' AND `language_label`='fibrosis percentage' AND `language_tag`='' AND `type`='float_positive' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE qcroc_ar_tissue_slides DROP COLUMN sample_pct_fibrosis;
ALTER TABLE qcroc_ar_tissue_slides_revs DROP COLUMN sample_pct_fibrosis;

UPDATE structure_formats SET `flag_search`='1', `flag_addgrid`='1', `flag_editgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='review_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotReviewMaster' AND `tablename`='aliquot_review_masters' AND `field`='aliquot_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquots_list_for_review') AND `flag_confidential`='0');
UPDATE structure_fields SET  `setting`='size=5' WHERE model='AliquotReviewMaster' AND tablename='aliquot_review_masters' AND field='review_code' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO i18n (id,en) VALUES ('Tissue Slide','Tissue Slide');

-- DNA

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_der_dnas', 'qcroc_eluate', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'eluate', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_sd_der_dnas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_dnas' AND `field`='qcroc_eluate' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='eluate' AND `language_tag`=''), '1', '503', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE sd_der_dnas ADD COLUMN qcroc_eluate text;
ALTER TABLE sd_der_dnas_revs ADD COLUMN qcroc_eluate text;
INSERT INTO i18n (id,en,fr) VALUES ('eluate', 'Eluate', 'Éluat');

-- RNA

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_der_rnas', 'qcroc_eluate', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'eluate', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_sd_der_rnas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_rnas' AND `field`='qcroc_eluate' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='eluate' AND `language_tag`=''), '1', '503', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE sd_der_rnas ADD COLUMN qcroc_eluate text;
ALTER TABLE sd_der_rnas_revs ADD COLUMN qcroc_eluate text;

-- --------------------------------------------------------------------------------
-- Structure Function
-- --------------------------------------------------------------------------------

UPDATE datamart_structure_functions SET flag_active = 0
WHERE label = 'list all related diagnosis';

-- --------------------------------------------------------------------------------













