ALTER TABLE participants 
  ADD COLUMN `qcroc_consent_date` date DEFAULT NULL,
  ADD COLUMN `qcroc_consent_date_accuracy` char(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs 
  ADD COLUMN `qcroc_consent_date` date DEFAULT NULL,
  ADD COLUMN `qcroc_consent_date_accuracy` char(1) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qcroc_consent_date', 'date',  NULL , '0', '', '', '', 'consent date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qcroc_consent_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='consent date' AND `language_tag`=''), '3', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en) VALUES ('consent date','Consent Date');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DROP TABLE qcroc_txd_liver_biopsies;
DROP TABLE qcroc_txd_liver_biopsies_revs;
DROP TABLE qcroc_txe_liver_biopsie_sedations;
DROP TABLE qcroc_txe_liver_biopsie_sedations_revs;

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qcroc_txd_liver_biopsy','qcroc_txe_liver_biopsie_sedation'));
DELETE FROM structures WHERE alias IN ('qcroc_txd_liver_biopsy','qcroc_txe_liver_biopsie_sedation');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE tablename IN ('qcroc_txd_liver_biopsies','qcroc_txe_liver_biopsie_sedations'));
DELETE FROM structure_fields WHERE tablename IN ('qcroc_txd_liver_biopsies','qcroc_txe_liver_biopsie_sedations');

DELETE FROM structure_permissible_values_customs WHERE control_id IN (SELECT id FROM structure_permissible_values_custom_controls WHERE name IN ('Biopsy : Reason if not performed', 'Biopsy : Instruments'));
DELETE FROM structure_permissible_values_custom_controls WHERE name IN ('Biopsy : Reason if not performed', 'Biopsy : Instruments');
DELETE FROM structure_value_domains WHERE domain_name IN ('qcroc_reasons_if_no_biopsy_performed','qcroc_biopsy_instruments');

DELETE FROM treatment_controls WHERE detail_tablename = 'qcroc_txd_liver_biopsies';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters%';
UPDATE treatment_controls SET flag_active = 0;

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column` = '1', `display_order` = '23' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'qcroc_banking_nbr');
UPDATE structure_formats SET `display_column` = '2' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('collection_notes','collection_property'));
UPDATE structure_formats SET `display_column` = '2' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field ='created' AND model LIKE '%collection%');

ALTER TABLE collections
   ADD COLUMN qcroc_biopsy_type varchar(50) DEFAULT NULL,
   ADD COLUMN qcroc_liver_segment varchar(50) DEFAULT NULL,
   ADD COLUMN qcroc_lesion_size_sup_2_cm char(1) DEFAULT '',
   ADD COLUMN qcroc_lesion_size_cm decimal(8,2) DEFAULT NULL,
   ADD COLUMN qcroc_radiologist varchar(100) DEFAULT NULL,
   ADD COLUMN qcroc_coordinator varchar(100) DEFAULT NULL;

ALTER TABLE collections_revs
   ADD COLUMN qcroc_biopsy_type varchar(50) DEFAULT NULL,
   ADD COLUMN qcroc_liver_segment varchar(50) DEFAULT NULL,
   ADD COLUMN qcroc_lesion_size_sup_2_cm char(1) DEFAULT '',
   ADD COLUMN qcroc_lesion_size_cm decimal(8,2) DEFAULT NULL,
   ADD COLUMN qcroc_radiologist varchar(100) DEFAULT NULL,
   ADD COLUMN qcroc_coordinator varchar(100) DEFAULT NULL;
   
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qcroc_liver_segment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_liver_segments') , '0', '', '', '', 'liver segment', ''), 
('InventoryManagement', 'Collection', 'collections', 'qcroc_lesion_size_sup_2_cm', 'yes_no',  NULL , '0', '', '', '', 'lesion size > 2cm', ''), 
('InventoryManagement', 'Collection', 'collections', 'qcroc_lesion_size_cm', 'float_positive',  NULL , '0', 'size=3', '', '', '', 'lesion size specify cm'), 
('InventoryManagement', 'Collection', 'collections', 'qcroc_radiologist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_radiologists') , '0', '', '', '', 'radiologist', ''), 
('InventoryManagement', 'Collection', 'collections', 'qcroc_coordinator', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_coordinators') , '0', '', '', '', 'coordinator', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_liver_segment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_liver_segments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='liver segment' AND `language_tag`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_lesion_size_sup_2_cm' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lesion size > 2cm' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_lesion_size_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='lesion size specify cm'), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_radiologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_radiologists')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiologist' AND `language_tag`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_coordinator' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_coordinators')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coordinator' AND `language_tag`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qcroc_biopsy_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types') , '0', '', '', '', 'biopsy type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_biopsy_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy type' AND `language_tag`=''), '1', '29', 'biopsy', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES 
('lesion size > 2cm', 'Lesion size > 2cm'),
('lesion size specify cm', 'specify (cm)'),
('biopsy type','Type');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_biopsy_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy type' AND `language_tag`=''), '1', '29', 'biopsy', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_liver_segment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_liver_segments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='liver segment' AND `language_tag`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_lesion_size_sup_2_cm' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lesion size > 2cm' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_lesion_size_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='lesion size specify cm'), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_radiologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_radiologists')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiologist' AND `language_tag`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_coordinator' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_coordinators')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coordinator' AND `language_tag`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qcroc_liver_segment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_liver_segments') , '0', '', '', '', 'liver segment', ''), 
('InventoryManagement', 'ViewCollection', '', 'qcroc_lesion_size_sup_2_cm', 'yes_no',  NULL , '0', '', '', '', 'lesion size > 2cm', ''), 
('InventoryManagement', 'ViewCollection', '', 'qcroc_lesion_size_cm', 'float_positive',  NULL , '0', 'size=3', '', '', '', 'lesion size specify cm'), 
('InventoryManagement', 'ViewCollection', '', 'qcroc_radiologist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_radiologists') , '0', '', '', '', 'radiologist', ''), 
('InventoryManagement', 'ViewCollection', '', 'qcroc_coordinator', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_coordinators') , '0', '', '', '', 'coordinator', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_liver_segment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_liver_segments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='liver segment' AND `language_tag`=''), '1', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_lesion_size_sup_2_cm' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lesion size > 2cm' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_lesion_size_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='lesion size specify cm'), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_radiologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_radiologists')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiologist' AND `language_tag`=''), '1', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qcroc_coordinator' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_coordinators')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coordinator' AND `language_tag`=''), '1', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_liver_segment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_liver_segments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='liver segment' AND `language_tag`=''), '0', '43', 'biopsy', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_biopsy_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types')  AND `flag_confidential`='0'), '0', '44', '', '1', 'type', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qcroc_cycle' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qcroc_tissue_storage_solution", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Biopsy : Tissue storage solution\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Biopsy : Tissue storage solution', 1, 100);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Biopsy : Tissue storage solution');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('formalin', 'Formalin', '', '1', @control_id, NOW(), NOW(), 1, 1),
('rnalater', 'RNAlater', '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'qcroc_tissue_storage_solution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_storage_solution') , '0', '', '', '', 'storage solution', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qcroc_tissue_storage_solution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_storage_solution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage solution' AND `language_tag`=''), '1', '440', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE sd_spe_tissues ADD COLUMN qcroc_tissue_storage_solution VARCHAR(100) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs ADD COLUMN qcroc_tissue_storage_solution VARCHAR(100) DEFAULT NULL;
UPDATE structure_fields SET language_label = 'storage solution' WHERE field = 'qcroc_tissue_storage_solution';
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `field`='qcroc_tissue_storage_solution'), 'notEmpty', '', '');
INSERT INTO i18n (id,en) VALUES ('storage solution','Storage Solution');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en)
VALUES
('qcroc placed in stor sol within 5mn','Was tissue placed in solution within 5min'),
('qcroc placed in stor sol within 5mn reason','If >5min, provide a reason');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qcroc_tissue_storage_solution' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_tissue_storage_solution')  AND `flag_confidential`='0'), '0', '2', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_addgrid`='1', `flag_editgrid`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type') AND `flag_confidential`='0');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES 
((SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type')), 'notEmpty', '', ''),
((SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field`='blood_type'), 'notEmpty', '', '');

DELETE FROM structure_validations WHERE structure_field_id = (SELECT id FROM structure_fields WHERE `tablename`='qcroc_ad_tissue_tubes' AND `field`='tube_type');
DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE `tablename`='qcroc_ad_tissue_tubes' AND `field`='tube_type');
DELETE FROM structure_fields WHERE `tablename`='qcroc_ad_tissue_tubes' AND `field`='tube_type';
ALTER TABLE qcroc_ad_tissue_tubes DROP COLUMN tube_type;
ALTER TABLE qcroc_ad_tissue_tubes_revs DROP COLUMN tube_type;
DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="qcroc_tissue_tube_type");
DELETE FROM structure_value_domains WHERE domain_name="qcroc_tissue_tube_type";

UPDATE structure_formats SET `language_heading`='tissue tube data' WHERE structure_id=(SELECT id FROM structures WHERE alias='qcroc_ad_tissue_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='qcroc_ad_tissue_tubes' AND `field`='time_placed_at_4c' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en) VALUES ('carrot longer than 1 cm','Carrot longer than 1cm');
UPDATE structure_fields SET  `setting`='size=2' WHERE model='AliquotDetail' AND tablename='ad_blocks' AND field='qcroc_fragment_nbr_specify' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='size=12' WHERE model='AliquotDetail' AND tablename='ad_blocks' AND field='qcroc_sizes_mm' AND `type`='input' AND structure_value_domain  IS NULL ;
ALTER TABLE ad_blocks
	ADD COLUMN qcroc_carrot_cut_during_processing  char(1) DEFAULT '',
	ADD COLUMN qcroc_max_carrot_size_mm decimal(8,2) DEFAULT NULL;
ALTER TABLE ad_blocks_revs
	ADD COLUMN qcroc_carrot_cut_during_processing  char(1) DEFAULT '',
	ADD COLUMN qcroc_max_carrot_size_mm decimal(8,2) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'qcroc_carrot_cut_during_processing', 'yes_no',  NULL , '0', '', '', '', 'carrot cut during processing', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_blocks', 'qcroc_max_carrot_size_mm', 'float_positive',  NULL , '0', '', '', '', 'total carrot size mm', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qcroc_carrot_cut_during_processing' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='carrot cut during processing' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_blocks' AND `field`='qcroc_max_carrot_size_mm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total carrot size mm' AND `language_tag`=''), '1', '74', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('carrot cut during processing','Carrot cut during processing'),('total carrot size mm','Total carrot size (mm)');
	
ALTER TABLE collections 
  ADD COLUMN `qcroc_collection_date_accuracy`  char(1) NOT NULL DEFAULT '';
ALTER TABLE collections_revs
  ADD COLUMN `qcroc_collection_date_accuracy`  char(1) NOT NULL DEFAULT '';
ALTER TABLE aliquot_masters
  	ADD COLUMN qcroc_transfer_date_sample_received_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE aliquot_masters_revs
  	ADD COLUMN qcroc_transfer_date_sample_received_accuracy char(1) NOT NULL DEFAULT ''; 
  	
REPLACE INTO i18n (id,en) VALUES ('time remained in rna later (days)', 'Time sample remained in RNALater (days)');	

ALTER TABLE aliquot_masters
	ADD COLUMN qcroc_transfer_shipping_date_accuracy  char(1) NOT NULL DEFAULT '';
ALTER TABLE aliquot_masters_revs
	ADD COLUMN qcroc_transfer_shipping_date_accuracy  char(1) NOT NULL DEFAULT '';

DELETE FROM i18n WHERE id IN ('collection date can not be estimated when the time is set for at least one specimen',
'specimen collection time can not be set when collection date is estimated',
'time sample remained in rnalater has been calulcated on estimated dates',
'unable to calculate time sample remained in rnalater with estimated dates',
'unable to calculate time sample remained in rnalater',
'see tissue tube(s) # %s',
'unable to calculate time sample remained in rnalater on estimated collection dates');
INSERT INTO i18n (id,en) VALUES
('collection date can not be estimated when the time is set for at least one specimen', 'Collection date can not be estimated when the time is set'),
('specimen collection time can not be set when collection date is estimated','Specimen collection time can not be set when collection date is estimated'),
('time sample remained in rnalater has been calulcated on estimated dates','Time sample remained in rnalater has been calulcated on estimated dates'),
('unable to calculate time sample remained in rnalater on estimated collection dates','Unable to calculate time sample remained in rnalater on estimated collection dates'),
('unable to calculate time sample remained in rnalater','Unable to calculate time sample remained in rnalater'),
('see tissue tube(s) # %s','See tissue tube(s) # %s');

SELECT 'TODO: qualityctrls_volume_for_detail?' AS msg;
SELECT 'TODO: SHOULD SAMPLE ID MOVED TO SAMPLE LEVEL?' AS msg;
SELECT 'TODO: Add path review in batch?' AS msg;

