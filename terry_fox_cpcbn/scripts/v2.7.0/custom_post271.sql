-- ----------------------------------------------------------------------------------------------------
-- Remove protocole for this version
-- ----------------------------------------------------------------------------------------------------
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

UPDATE versions SET branch_build_number = '7377' WHERE version_number = '2.7.1';
UPDATE versions SET branch_build_number = '7399' WHERE version_number = '2.7.1';

-- Add QC

UPDATE menus SET flag_active=true WHERE id IN('inv_CAN_2224', 'inv_CAN_224');
UPDATE menus SET flag_active=true WHERE id IN('inv_CAN_22241', 'inv_CAN_2241');
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'QualityCtrl')) 
OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'));
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewSample') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'QualityCtrl')) 
OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'ViewSample'));
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create quality control';

-- Aliquot Use Event
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse')) 
OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'));
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse')) 
OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquotUse') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'StudySummary'));
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create uses/events (aliquot specific)';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create use/event (applied to all)';
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='', `flag_add`='1', `flag_edit`='1', `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_internal_use_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='study_summary_title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_addgrid`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquotinternaluses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotInternalUse' AND `tablename`='aliquot_internal_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

-- Slide

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tissue_slide', 'qc_tf_cpcbn_thickness', 'integer_positive',  NULL , '0', '', '', '', 'thickness (um)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tissue_slide' AND `field`='qc_tf_cpcbn_thickness' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='thickness (um)' AND `language_tag`=''), '1', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '1');
ALTER TABLE ad_tissue_slides ADD COLUMN qc_tf_cpcbn_thickness INT(6) DEFAULT NULL;
ALTER TABLE ad_tissue_slides_revs ADD COLUMN qc_tf_cpcbn_thickness INT(6) DEFAULT NULL;
UPDATE structure_fields SET tablename = 'ad_tissue_slides' WHERE tablename = 'ad_tissue_slide';
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_slides') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tissue_slides' AND `field`='qc_tf_cpcbn_thickness');
UPDATE versions SET branch_build_number = '7434' WHERE version_number = '2.7.1';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'StudySummary')) 
OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary') AND id2 =(SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'));

UPDATE versions SET branch_build_number = '7435' WHERE version_number = '2.7.1';

-- ----------------------------------------------------------------------------------
-- 20190227 : New dev
-- -------------------------------------------------------------------------------------

-- Ethni

ALTER TABLE participants ADD COLUMN qc_tf_ethnicity VARCHAR(50) DEFAULT NULL;
ALTER TABLE participants_revs ADD COLUMN qc_tf_ethnicity VARCHAR(50) DEFAULT NULL;
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Ethnicity', 1, 50, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Ethnicity');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("Caucasian", "", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("African", "", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("American", "", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Asian", "", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("Hispanic", "", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("other", "", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_customs SET en = value WHERE control_id = @control_id;
UPDATE structure_permissible_values_customs SET value = LOWER(value) WHERE control_id = @control_id;
UPDATE structure_permissible_values_custom_controls 
SET values_max_length = 50, values_used_as_input_counter = 6, values_counter = 6 WHERE name = 'Ethnicity';
INSERT INTO structure_value_domains (domain_name, override, category, source) 
values
('qc_tf_ethnicity', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Ethnicity\')');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_ethnicity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ethnicity') , '0', '', '', '', 'ethnicity', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_ethnicity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ethnicity')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ethnicity' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORe INTO i18n (id,en,fr)
VALUES
('ethnicity', 'Ethnicity', 'Ethnicité');

-- BMI

UPDATE menus SET flag_active=true WHERE id IN('clin_CAN_31');
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) 
VALUES 
(NULL, '', 'clinical', 'bmi', '1', 'qc_tf_ed_clinical_bmi', 'qc_tf_ed_clinical_bmis', '0', 'bmi', '0', '1', '1');
DROP TABLE IF EXISTS `qc_tf_ed_clinical_bmis`;
CREATE TABLE `qc_tf_ed_clinical_bmis` (
  `height_m` decimal(6,2) DEFAULT NULL,
  `weight_kg` decimal(6,2) DEFAULT NULL,
  `bmi` decimal(6,2) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `qc_tf_ed_clinical_bmis_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `qc_tf_ed_clinical_bmis_revs`;
CREATE TABLE `qc_tf_ed_clinical_bmis_revs` (
  `height_m` decimal(6,2) DEFAULT NULL,
  `weight_kg` decimal(6,2) DEFAULT NULL,
  `bmi` decimal(6,2) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO structures(`alias`) VALUES ('qc_tf_ed_clinical_bmi');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_tf_ed_clinical_bmis', 'height_m', 'float_positive',  NULL , '0', '', '', '', 'height (m)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_tf_ed_clinical_bmis', 'weight_kg', 'float_positive',  NULL , '0', '', '', '', 'weight (kg)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_tf_ed_clinical_bmis', 'bmi', 'float_positive',  NULL , '0', '', '', '', 'bmi', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ed_clinical_bmi'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '100', '', '0', '1', 'notes', '0', '', '0', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_clinical_bmi'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_clinical_bmis' AND `field`='height_m' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='height (m)' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_clinical_bmi'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_clinical_bmis' AND `field`='weight_kg' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='weight (kg)' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_clinical_bmi'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_clinical_bmis' AND `field`='bmi' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bmi' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bmi', 'BMI', ''),
('height (m)', 'Height (m)', ''),
('weight (kg)', 'Weight (kg)', '');

-- PHYSICAL STATUS

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) 
VALUES 
(NULL, '', 'clinical', 'physical status', '1', 'qc_tf_ed_physical_status', 'qc_tf_ed_physical_status', '0', 'physical status', '0', '1', '1');
DROP TABLE IF EXISTS `qc_tf_ed_physical_status`;
CREATE TABLE `qc_tf_ed_physical_status` (
  `ecog` varchar(2) DEFAULT NULL,
  `asa` varchar(4) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`),
  CONSTRAINT `qc_tf_ed_physical_status_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `qc_tf_ed_physical_status_revs`;
CREATE TABLE `qc_tf_ed_physical_status_revs` (
  `ecog` varchar(2) DEFAULT NULL,
  `asa` varchar(4) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('ECOG', 1, 2, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'ECOG');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("1", "", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2", "", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3", "", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4", "", "", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("5", "", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("0", "", "", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls 
SET values_max_length = 2, values_used_as_input_counter = 6, values_counter = 6 WHERE name = 'ECOG';
INSERT INTO structure_value_domains (domain_name, override, category, source) values
('qc_tf_ed_ecog', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'ECOG\')');
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('ASA', 1, 3, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'ASA');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("I", "", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("II", "", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("III", "", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls 
SET values_max_length = 3, values_used_as_input_counter = 3, values_counter = 3 WHERE name = 'ASA';
INSERT INTO structure_value_domains (domain_name, override, category, source) values
('qc_tf_ed_asa', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'ASA\')');
INSERT INTO structures(`alias`) VALUES ('qc_tf_ed_physical_status');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_tf_ed_physical_status', 'ecog', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ed_ecog') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_tf_ed_physical_status', 'asa', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ed_asa') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ed_physical_status'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '100', '', '0', '1', 'notes', '0', '', '0', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_physical_status'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_physical_status' AND `field`='ecog' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ed_ecog')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_ed_physical_status'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_physical_status' AND `field`='asa' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ed_asa')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('asa', 'ASA', ''),
('ecog', 'ECOG', ''),
('physical status', 'Physical Status', '');
UPDATE structure_fields SET `language_label`='ecog' WHERE model='EventDetail' AND tablename='qc_tf_ed_physical_status' AND field='ecog' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ed_ecog');
UPDATE structure_fields SET `language_label`='asa' WHERE model='EventDetail' AND tablename='qc_tf_ed_physical_status' AND field='asa' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ed_asa');

-- Last Contact

ALTER TABLE participants
  ADD COLUMN qc_tf_last_ct_ov_dept_visited varchar(250) DEFAULT NULL,
  ADD COLUMN qc_tf_last_ct_ov_evidence_of_pc_prog varchar(100) DEFAULT NULL,
  ADD COLUMN qc_tf_last_pc_rel_date date DEFAULT NULL,
  ADD COLUMN qc_tf_last_pc_rel_date_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_last_pc_rel_reason_for_visit varchar(100) DEFAULT NULL,
  ADD COLUMN qc_tf_last_pc_rel_evidence_of_pc_prog char(1) DEFAULT '';
ALTER TABLE participants_revs
  ADD COLUMN qc_tf_last_ct_ov_dept_visited varchar(250) DEFAULT NULL,
  ADD COLUMN qc_tf_last_ct_ov_evidence_of_pc_prog varchar(100) DEFAULT NULL,
  ADD COLUMN qc_tf_last_pc_rel_date date DEFAULT NULL,
  ADD COLUMN qc_tf_last_pc_rel_date_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN qc_tf_last_pc_rel_reason_for_visit varchar(100) DEFAULT NULL,
  ADD COLUMN qc_tf_last_pc_rel_evidence_of_pc_prog char(1) DEFAULT '';
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='last contact (overall)' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_last_contact' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("yesnounknown", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yesnounknown"), (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yesnounknown"), (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "0", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yesnounknown"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "2", "1");
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Reason for Last Contact PC', 1, 100, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Reason for Last Contact PC');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("psa", "PSA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("clinic", "Clinic", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("imaging", "Imaging", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls 
SET values_max_length = 100, values_used_as_input_counter = 3, values_counter = 3 WHERE name = 'Reason for Last Contact PC';
INSERT INTO structure_value_domains (domain_name, override, category, source) values
('reason_last_contact_pc', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Reason for Last Contact PC\')');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'participants', 'qc_tf_last_ct_ov_dept_visited', 'input',  NULL , '0', '', '', '', '', 'department visited'), 
('ClinicalAnnotation', 'EventDetail', 'participants', 'qc_tf_last_ct_ov_evidence_of_pc_prog', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesnounknown') , '0', '', '', '', '', 'evidence of progression'), 
('ClinicalAnnotation', 'EventDetail', 'participants', 'qc_tf_last_pc_rel_date', 'date',  NULL , '0', '', '', '', 'last contact (pc related)', ''), 
('ClinicalAnnotation', 'EventDetail', 'participants', 'qc_tf_last_pc_rel_reason_for_visit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='reason_last_contact_pc') , '0', '', '', '', '', 'reason for visit'), 
('ClinicalAnnotation', 'EventDetail', 'participants', 'qc_tf_last_pc_rel_evidence_of_pc_prog', 'select',  NULL , '0', '', '', '', '', 'evidence of progression');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='participants' AND `field`='qc_tf_last_ct_ov_dept_visited' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='department visited'), '2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='participants' AND `field`='qc_tf_last_ct_ov_evidence_of_pc_prog' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesnounknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='evidence of progression'), '2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='participants' AND `field`='qc_tf_last_pc_rel_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact (pc related)' AND `language_tag`=''), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='participants' AND `field`='qc_tf_last_pc_rel_reason_for_visit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='reason_last_contact_pc')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='reason for visit'), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='participants' AND `field`='qc_tf_last_pc_rel_evidence_of_pc_prog' AND `type`='select' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='evidence of progression'), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_column`='2', `display_order`='23' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='participants' AND `field`='qc_tf_last_pc_rel_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='23' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='participants' AND `field`='qc_tf_last_pc_rel_reason_for_visit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='reason_last_contact_pc') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='23' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='participants' AND `field`='qc_tf_last_pc_rel_evidence_of_pc_prog' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `type`='yes_no' WHERE model='EventDetail' AND tablename='participants' AND field='qc_tf_last_pc_rel_evidence_of_pc_prog' AND `type`='select' AND structure_value_domain  IS NULL ;
INSERT IGNORE i18n (id,en,fr)
VALUES
('last contact (overall)', 'Last Contact (Overall)', ''),
('department visited', 'Department Visited', ''),
('evidence of progression', 'Evidence of Progression', ''),
('last contact (pc related)', 'Last Contact (PC related)', ''),
('reason for visit', 'Visit Reason', ''),
('evidence of progression', 'Evidence of Progression', '');
UPDATE structure_fields SET model = 'Participant' WHERE model = 'EventDetail' AND tablename = 'participants' AND field LIKE 'qc_tf_%';

UPDATE versions SET branch_build_number = '7589' WHERE version_number = '2.7.1';