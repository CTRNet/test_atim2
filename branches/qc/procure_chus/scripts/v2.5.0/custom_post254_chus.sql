INSERT INTO i18n (id, en, fr) 
VALUES
("contact if need more information", "Contact if need more information", "Contacter si besoin d'informations supplémentaires"),
("contact if scientific discovery", "Contact if scientific discovery", "Contacter si découverte scientifique"),
("study on other disease", "Study on other disease", "Étude sur d'autre maladie"),
("contact if discovered on other diseases", "Contact if discovered on other diseases", "Contacter si découvertes sur d'autres maladies"),
("other contacts in case of death", "Other contacts in case of death", "Autres contacts en cas de décès");
ALTER TABLE procure_cd_sigantures
  ADD COLUMN procure_chus_contact_for_more_info char(1) DEFAULT '',
  ADD COLUMN procure_chus_contact_if_scientific_discovery char(1) DEFAULT '',
  ADD COLUMN procure_chus_study_on_other_diseases char(1) DEFAULT '',
  ADD COLUMN procure_chus_contact_if_discovery_on_other_diseases char(1) DEFAULT '',
  ADD COLUMN procure_chus_other_contacts_in_case_of_death char(1) DEFAULT '';
ALTER TABLE procure_cd_sigantures_revs
  ADD COLUMN procure_chus_contact_for_more_info char(1) DEFAULT '',
  ADD COLUMN procure_chus_contact_if_scientific_discovery char(1) DEFAULT '',
  ADD COLUMN procure_chus_study_on_other_diseases char(1) DEFAULT '',
  ADD COLUMN procure_chus_contact_if_discovery_on_other_diseases char(1) DEFAULT '',
  ADD COLUMN procure_chus_other_contacts_in_case_of_death char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chus_contact_for_more_info', 'yes_no',  NULL , '0', '', '', '', 'contact if need more information', ''),
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chus_contact_if_scientific_discovery', 'yes_no',  NULL , '0', '', '', '', 'contact if scientific discovery', ''),
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chus_study_on_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'study on other disease', ''),
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chus_contact_if_discovery_on_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'contact if discovered on other diseases', ''),
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chus_other_contacts_in_case_of_death', 'yes_no',  NULL , '0', '', '', '', 'other contacts in case of death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `tablename`='procure_cd_sigantures' AND `field`='procure_chus_contact_for_more_info'), '2', '30', 'details', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `tablename`='procure_cd_sigantures' AND `field`='procure_chus_contact_if_scientific_discovery'), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `tablename`='procure_cd_sigantures' AND `field`='procure_chus_study_on_other_diseases'), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `tablename`='procure_cd_sigantures' AND `field`='procure_chus_contact_if_discovery_on_other_diseases'), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `tablename`='procure_cd_sigantures' AND `field`='procure_chus_other_contacts_in_case_of_death'), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE storage_controls SET flag_active = 0 WHERE storage_type NOT IN ('room', 'freezer', 'rack16', 'shelf');
ALTER TABLE storage_masters CHANGE COLUMN short_label short_label varchar(60) DEFAULT NULL,  CHANGE COLUMN selection_label selection_label varchar(150) DEFAULT '';
ALTER TABLE storage_masters_revs CHANGE COLUMN short_label short_label varchar(60) DEFAULT NULL,  CHANGE COLUMN selection_label selection_label varchar(150) DEFAULT '';
INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, 
`display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) 
VALUES
(null, 'box40', 'position', 'integer', 40, NULL, NULL, NULL, 10, 4, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'box40', 1),
(null, 'box100 10x10', 'row', 'integer', 10, 'column', 'integer', 10, 10, 0, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'box100 10x10', 1),
(null, 'box30 3x10', 'row', 'integer', 3, 'column', 'integer', 10, 3, 0, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'box30 3x10', 1),
(null, 'box49 7x7', 'row', 'integer', 3, 'column', 'integer', 7, 7, 0, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'box49 7x7', 1);
INSERT IGNORE INTO i18n (id,en,fr)
 VALUES 
('box40','Box40 1-40', 'Boîte40 1-40'),
('box100 10x10','Box100 10x10', 'Boîte100 10x10'),
('box30 3x10','Box30 3x10', 'Boîte30 3x10'),
('box49 7x7','Box49 7x7', 'Boîte49 7x7');

ALTER TABLE ad_blocks
  ADD COLUMN procure_chus_classification_precision varchar(250),
  ADD COLUMN procure_chus_origin_of_slice_precision varchar(250);
ALTER TABLE ad_blocks_revs
  ADD COLUMN procure_chus_classification_precision varchar(250),
  ADD COLUMN procure_chus_origin_of_slice_precision varchar(250);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'procure_chus_classification_precision', 'input',  NULL , '0', 'size=20', '', '', 'classification precisions', ''), 
('InventoryManagement', 'AliquotDetail', '', 'procure_chus_origin_of_slice_precision', 'input',  NULL , '0', 'size=20', '', '', 'origin of slice precisions', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='procure_chus_classification_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='classification precisions' AND `language_tag`=''), '1', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='procure_chus_origin_of_slice_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='origin of slice precisions' AND `language_tag`=''), '1', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='84' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='procure_classification' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_block_classification') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='85' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='procure_chus_classification_precision' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='86' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='procure_dimensions' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='87' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='time_spent_collection_to_freezing_end_mn' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr)
VALUES
('classification precisions', 'Classification precisions', 'Précisions / classification'),
('origin of slice precisions', 'Origin precisions', 'Précisions / Origine');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'procure _slice origins');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('unclassifiable', 'Unclassifiable', 'Inclassable', '1', @control_id, NOW(), NOW(), 1, 1);	

-- Concentrated urine
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(10);
UPDATE aliquot_controls SET flag_active=true WHERE id IN(15);

UPDATE `storage_controls` SET coord_x_size = 7 WHERE storage_type = 'box49 7x7';

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- After 20130902
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE ad_tubes ADD COLUMN procure_chus_micro_rna char(1) DEFAULT '';
ALTER TABLE ad_tubes_revs ADD COLUMN procure_chus_micro_rna char(1) DEFAULT '';
INSERT INTO structures(`alias`) VALUES ('procure_chus_micro_rna');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'procure_chus_micro_rna', 'yes_no',  NULL , '0', '', '', '', 'micro rna', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_chus_micro_rna'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='procure_chus_micro_rna' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='micro rna' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('micro rna', 'miRNA', 'miARN');
UPDATE aliquot_controls SET detail_form_alias = CONCAT(detail_form_alias, ',procure_chus_micro_rna') WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'rna');

UPDATE aliquot_controls SET flag_active=true WHERE id IN(10);
UPDATE realiquoting_controls SET flag_active=true WHERE id IN(11);

ALTER TABLE collections ADD `procure_chus_collection_specimen_sample_control_id` int(11) DEFAULT null;
ALTER TABLE collections_revs ADD `procure_chus_collection_specimen_sample_control_id` int(11) DEFAULT null;
ALTER TABLE `collections`
  ADD CONSTRAINT `FK_procure_chus_sample_masters_sample_controls` FOREIGN KEY (`procure_chus_collection_specimen_sample_control_id`) REFERENCES `sample_controls` (`id`);
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'procure_chus_specimen_type_from_id', 'open', '', 'InventoryManagement.SampleControl::getSpecimenSampleTypePermissibleValuesFromId');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'procure_chus_collection_specimen_sample_control_id', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name = 'procure_chus_specimen_type_from_id') , '0', '', '', '', 'collection specimen type', ''),
('InventoryManagement', 'ViewCollection', '', 'procure_chus_collection_specimen_sample_control_id', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name = 'procure_chus_specimen_type_from_id') , '0', '', '', '', 'collection specimen type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_chus_collection_specimen_sample_control_id'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_chus_collection_specimen_sample_control_id' ), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='procure_chus_collection_specimen_sample_control_id'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE model = 'Collection' AND field = 'procure_chus_collection_specimen_sample_control_id'), 'notEmpty', "");
INSERT INTO i18n (id,en,fr) VALUES ('collection specimen type', 'Collected Specimens', 'Spécimens collectés');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_chus_collection_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_chus_specimen_type_from_id')  AND `flag_confidential`='0'), '0', '11', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_chus_collection_specimen_sample_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_chus_specimen_type_from_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection specimen type' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('there is a mismatch between the specimen type assigned to collection and the created specimen', "There is a mismatch between the specimen type assigned to collection and the created specimen", "Il ya une discordance entre le type d'échantillon attribué à la collection et l'échantillon créé");
UPDATE structure_formats SET `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_chus_collection_specimen_sample_control_id');
UPDATE structure_formats SET `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_chus_collection_specimen_sample_control_id');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='procure_chus_collection_specimen_sample_control_id');

UPDATE storage_controls SET flag_active = 1 WHERE storage_type = 'box';

ALTER TABLE participants ADD COLUMN procure_chus_abort char(1) DEFAULT '';
ALTER TABLE participants_revs ADD COLUMN procure_chus_abort char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_chus_abort', 'yes_no',  NULL , '0', '', '', '', 'participant abort', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_chus_abort' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='participant abort' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('participant abort', 'Abort', 'Abandon');
ALTER TABLE participants 
  ADD COLUMN  procure_chus_aborting_date date DEFAULT NULL, 
  ADD COLUMN procure_chus_aborting_date_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs 
  ADD COLUMN  procure_chus_aborting_date date DEFAULT NULL, 
  ADD COLUMN procure_chus_aborting_date_accuracy char(1) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_chus_aborting_date', 'date',  NULL , '0', '', '', '', 'aborting date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_chus_aborting_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aborting date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('aborting date', 'Aborting Date', 'Date d''abandon');
 
UPDATE menus set flag_active = 1 where use_link like '%clinical%' and use_link like '%contact%';
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `field` IN ('contact_type', 'phone'));
UPDATE structure_fields SET  `type`='input',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='contact_type') ,  `setting`='size=30' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='contact_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='contact_type');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='contact_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='contact_type') AND `flag_confidential`='0');


  


-- --------------------------------------------------------------------------------------
-- 2013-11-07
-- --------------------------------------------------------------------------------------

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_seminal_vesicles") AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value IN ("unilateral","bilateral"));
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_seminal_vesicles"), 
(SELECT id FROM structure_permissible_values WHERE value="present" AND language_alias="present"), "3", "1");

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='histology' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_histology') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'chus_histology_acinar_adenocarcinoma', 'checkbox',  NULL , '0', '', '', '', 'acinar adenocarcinoma/usual type', ''),
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'chus_histology_prostatic_ductal_adenocarcinoma', 'checkbox',  NULL , '0', '', '', '', 'prostatic ductal adenocarcinoma', ''),
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'chus_histology_mucinous_adenocarcinoma', 'checkbox',  NULL , '0', '', '', '', 'mucinous adenocarcinoma', ''),
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'chus_histology_signet_ring_cell_carcinoma', 'checkbox',  NULL , '0', '', '', '', 'signet-ring cell carcinoma', ''),
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'chus_histology_adenosquamous_carcinoma', 'checkbox',  NULL , '0', '', '', '', 'adenosquamous carcinoma', ''),
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'chus_histology_small_cell_carcinoma', 'checkbox',  NULL , '0', '', '', '', 'small cell carcinoma', ''),
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'chus_histology_sarcomatoid_carcinoma', 'checkbox',  NULL , '0', '', '', '', 'sarcomatoid carcinoma', ''),
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'chus_histology_other', 'checkbox',  NULL , '0', '', '', '', 'other specify', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='chus_histology_acinar_adenocarcinoma' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='acinar adenocarcinoma/usual type' AND `language_tag`=''), '2', '30', '1) histology', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='chus_histology_adenosquamous_carcinoma' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='adenosquamous carcinoma' AND `language_tag`=''), '2', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='chus_histology_mucinous_adenocarcinoma' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mucinous adenocarcinoma' AND `language_tag`=''), '2', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='chus_histology_other' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other specify' AND `language_tag`=''), '2', '38', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='chus_histology_prostatic_ductal_adenocarcinoma' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='prostatic ductal adenocarcinoma' AND `language_tag`=''), '2', '34', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='chus_histology_sarcomatoid_carcinoma' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sarcomatoid carcinoma' AND `language_tag`=''), '2', '35', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='chus_histology_signet_ring_cell_carcinoma' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='signet-ring cell carcinoma' AND `language_tag`=''), '2', '36', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='chus_histology_small_cell_carcinoma' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='small cell carcinoma' AND `language_tag`=''), '2', '37', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE procure_ed_lab_pathologies ADD COLUMN chus_histology_acinar_adenocarcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies ADD COLUMN chus_histology_adenosquamous_carcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies ADD COLUMN chus_histology_mucinous_adenocarcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies ADD COLUMN chus_histology_other tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies ADD COLUMN chus_histology_prostatic_ductal_adenocarcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies ADD COLUMN chus_histology_sarcomatoid_carcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies ADD COLUMN chus_histology_signet_ring_cell_carcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies ADD COLUMN chus_histology_small_cell_carcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies_revs ADD COLUMN chus_histology_acinar_adenocarcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies_revs ADD COLUMN chus_histology_adenosquamous_carcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies_revs ADD COLUMN chus_histology_mucinous_adenocarcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies_revs ADD COLUMN chus_histology_other tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies_revs ADD COLUMN chus_histology_prostatic_ductal_adenocarcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies_revs ADD COLUMN chus_histology_sarcomatoid_carcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies_revs ADD COLUMN chus_histology_signet_ring_cell_carcinoma tinyint(1) DEFAULT '0';
ALTER TABLE procure_ed_lab_pathologies_revs ADD COLUMN chus_histology_small_cell_carcinoma tinyint(1) DEFAULT '0';

ALTER TABLE procure_ed_lab_pathologies MODIFY COLUMN `histology_other_precision` varchar(150) DEFAULT NULL;
ALTER TABLE procure_ed_lab_pathologies_revs MODIFY COLUMN `histology_other_precision` varchar(150) DEFAULT NULL;

UPDATE structure_formats SET `flag_addgrid`='1', `flag_editgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE `versions` SET branch_build_number = '5470' WHERE version_number = '2.5.4';

