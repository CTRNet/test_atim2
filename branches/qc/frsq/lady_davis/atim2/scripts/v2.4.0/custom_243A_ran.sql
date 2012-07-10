INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_coll_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '160', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_type' AND `language_label`='sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id' AND `language_label`='parent sample code' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_master_parent_id') AND `language_help`='inv_sample_parent_id_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_category' AND `language_label`='category' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `language_help`='inv_sample_category_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `language_label`='is problematic' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='0' AND `structure_value_domain` IS NULL  AND `language_help`='inv_is_problematic_sample_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `language_label`='sample sop' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='' AND `field`='parent_sample_type' AND `language_label`='parent sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='generated_parent_sample_sample_type_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site' AND `language_label`='creation site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by' AND `language_label`='created by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime' AND `language_label`='creation date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='inv_creation_datetime_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='Generated' AND `tablename`='' AND `field`='coll_to_creation_spent_time_msg' AND `language_label`='collection to creation spent time' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='inv_coll_to_creation_spent_time_msg_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `language_label`='sample code' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='sample_code_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', '', 'qc_lady_storage_solution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_dna_storage_solution') , '0', '', '', '', 'storage solution', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='qc_lady_storage_solution' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_dna_storage_solution') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_sd_der_dnas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qc_lady_storage_solution' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_dna_storage_solution') AND `flag_confidential`='0');

-- 2012-04-17
UPDATE consent_controls SET controls_type='Tissue Repository and Database' WHERE id=1;
INSERT INTO consent_controls(controls_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) 
(SELECT 'Q-CROC-03 (Neo-Adjuvant)', flag_active, form_alias, detail_tablename, display_order, 'Q-CROC-03 (Neo-Adjuvant)' FROM consent_controls WHERE id=1);
INSERT INTO consent_controls(controls_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) 
(SELECT 'Q-CROC-03 (Metastatic)', flag_active, form_alias, detail_tablename, display_order, 'Q-CROC-03 (Metastatic)' FROM consent_controls WHERE id=1);

-- 2012-06-18
REPLACE INTO i18n(id, en, fr) VALUES
("the identifier expected format is %s", "The identifier expected format is %s.", "Le format de valeur attendu est %s."),  
("centri 1", "Centrifugation 1", "Centrifugation 1"),
("centri 2", "Centrifugation 2", "Centrifugation 2"),
("rpm", "RPM", "RPM"),
("g", "g", "g"),
("filtered", "Filtered", "Filtrée"),
("centri 1 duration min", "Centrifugation 1 duration (min.)", "Centrifugation 1 durée (min.)"), 
("centri 2 duration min", "Centrifugation 2 duration (min.)", "Centrifugation 2 durée (min.)"), 
("visit", "Visit", "Visite"),
("pre-chemotherapy", "Pre-Chemotherapy", "Pré-chimiothérapie"),
("post-chemotherapy", "Post-Chemotherapy", "Post-chimiothérapie"),
("may", "May", "Mai"),
("clinical status", "Clinical status", "Statut clinique"),
("banking #", "Banking #", "# de mise en banque"),
("neoadjuvant", "Neoadjuvant", "Néoadjuvant"), 
("adjuvant", "Adjuvant", "Adjuvant"),
("metastatic", "Metastatic", "Métastatique");

INSERT INTO misc_identifier_controls (misc_identifier_name, flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_confidential) VALUES
("NEO-xx", 1, 10, "", "", 1, 0),
("MET-xx", 1, 10, "", "", 1, 0);

ALTER TABLE collections
 ADD COLUMN qc_lady_banking_nbr INT UNSIGNED DEFAULT NULL,
 ADD COLUMN qc_lady_visit VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE collections_revs
 ADD COLUMN qc_lady_banking_nbr INT UNSIGNED DEFAULT NULL,
 ADD COLUMN qc_lady_visit VARCHAR(50) NOT NULL DEFAULT '';
 
DROP VIEW view_collections; 
CREATE VIEW `view_collections` AS select `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,
 `link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` AS `consent_master_id`,
 `mi`.`identifier_value` AS `participant_identifier`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` AS `collection_site`,
 `col`.`collection_datetime` AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
 `col`.`collection_property` AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,
 `col`.`deleted` AS `deleted`,`banks`.`name` AS `bank_name`,`col`.`created` AS `created`,`col`.`qc_lady_type` AS `qc_lady_type`,
 `col`.`qc_lady_follow_up` AS `qc_lady_follow_up`,`col`.`qc_lady_pre_op` AS `qc_lady_pre_op`,`sd`.`supplier_dept_grouped` AS `qc_lady_supplier_dept_grouped`,
 col.qc_lady_banking_nbr AS qc_lady_banking_nbr, col.qc_lady_visit AS qc_lady_visit  
 from (((((`collections` `col` 
 left join `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) 
 left join `participants` `part` on(((`link`.`participant_id` = `part`.`id`) and (`part`.`deleted` <> 1)))) 
 left join `banks` on(((`col`.`bank_id` = `banks`.`id`) and (`banks`.`deleted` <> 1)))) 
 left join `misc_identifiers` `mi` on(((`mi`.`participant_id` = `part`.`id`) and (`mi`.`misc_identifier_control_id` = 9)))) 
 left join `qc_lady_supplier_depts2` `sd` on((`sd`.`collection_id` = `col`.`id`))) 
 where (`col`.`deleted` <> 1);
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'Collection', 'collections', 'qc_lady_banking_nbr', 'integer_positive',  NULL , '0', '', '', '', 'banking #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_banking_nbr' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='banking #' AND `language_tag`=''), '1', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'ViewCollection', 'view_collections', 'qc_lady_banking_nbr', 'integer_positive',  NULL , '0', '', '', '', 'banking #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='qc_lady_banking_nbr' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='banking #' AND `language_tag`=''), '1', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

ALTER TABLE sd_spe_bloods
 ADD COLUMN qc_lady_clinical_status VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE sd_spe_bloods_revs
 ADD COLUMN qc_lady_clinical_status VARCHAR(50) NOT NULL DEFAULT '';

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_blood_clinical_status", "", "", "");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_blood_clinical_status"), (SELECT id FROM structure_permissible_values WHERE value="neoadjuvant" AND language_alias="neoadjuvant"), "0", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_blood_clinical_status"), (SELECT id FROM structure_permissible_values WHERE value="adjuvant" AND language_alias="adjuvant"), "0", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("metastatic", "metastatic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_blood_clinical_status"), (SELECT id FROM structure_permissible_values WHERE value="metastatic" AND language_alias="metastatic"), "0", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_spe_bloods', 'qc_lady_clinical_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_blood_clinical_status') , '0', '', '', '', 'clinical status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='qc_lady_clinical_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_blood_clinical_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical status' AND `language_tag`=''), '0', '510', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1');


INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_collection_visit", "", "", "");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pre-chemotherapy", "pre-chemotherapy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="pre-chemotherapy" AND language_alias="pre-chemotherapy"), "0", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("post-chemotherapy", "post-chemotherapy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="post-chemotherapy" AND language_alias="post-chemotherapy"), "0", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_collection_visit"), (SELECT id FROM structure_permissible_values WHERE value="surgery" AND language_alias="surgery"), "0", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'Collection', 'collections', 'qc_lady_visit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_visit') , '0', '', '', '', 'visit', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_visit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_visit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='visit' AND `language_tag`=''), '1', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'ViewCollection', 'view_collections', 'qc_lady_visit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_visit') , '0', '', '', '', 'visit', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='qc_lady_visit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_visit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='visit' AND `language_tag`=''), '1', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

ALTER TABLE sd_der_plasmas
 ADD COLUMN qc_lady_centri_1_unit VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_lady_centri_1,
 ADD COLUMN qc_lady_centri_2_unit VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_lady_centri_2,
 CHANGE qc_lady_centri_1_rpm qc_lady_centri_1 MEDIUMINT UNSIGNED DEFAULT NULL,
 CHANGE qc_lady_centri_2_rpm qc_lady_centri_2 MEDIUMINT UNSIGNED DEFAULT NULL;
ALTER TABLE sd_der_plasmas_revs
 ADD COLUMN qc_lady_centri_1_unit VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_lady_centri_1,
 ADD COLUMN qc_lady_centri_2_unit VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_lady_centri_2,
 CHANGE qc_lady_centri_1_rpm qc_lady_centri_1 MEDIUMINT UNSIGNED DEFAULT NULL,
 CHANGE qc_lady_centri_2_rpm qc_lady_centri_2 MEDIUMINT UNSIGNED DEFAULT NULL;
UPDATE sd_der_plasmas SET qc_lady_centri_1_unit='rpm' WHERE qc_lady_centri_1 IS NOT NULL;
UPDATE sd_der_plasmas_revs SET qc_lady_centri_1_unit='rpm' WHERE qc_lady_centri_1 IS NOT NULL;
UPDATE sd_der_plasmas SET qc_lady_centri_2_unit='rpm' WHERE qc_lady_centri_2 IS NOT NULL;
UPDATE sd_der_plasmas_revs SET qc_lady_centri_2_unit='rpm' WHERE qc_lady_centri_2 IS NOT NULL;


INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_centrifugation_unit", "", "", "");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("rpm", "rpm");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_centrifugation_unit"), (SELECT id FROM structure_permissible_values WHERE value="rpm" AND language_alias="rpm"), "0", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("g", "g");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_centrifugation_unit"), (SELECT id FROM structure_permissible_values WHERE value="g" AND language_alias="g"), "0", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_der_plasmas', 'qc_lady_centri_1_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_centrifugation_unit') , '0', '', '', '', '', 'unit'), 
('Inventorymanagement', 'SampleDetail', 'sd_der_plasmas', 'qc_lady_centri_2_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_centrifugation_unit') , '0', '', '', '', '', 'unit');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_plasmas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='qc_lady_centri_1_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_centrifugation_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='unit'), '1', '500', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='sd_der_plasmas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='qc_lady_centri_2_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_centrifugation_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='unit'), '1', '502', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0');
UPDATE structure_fields SET  `language_label`='centri 1', field='qc_lady_centri_1' WHERE model='SampleDetail' AND tablename='sd_der_plasmas' AND field='qc_lady_centri_1_rpm' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='centri 2', field='qc_lady_centri_2' WHERE model='SampleDetail' AND tablename='sd_der_plasmas' AND field='qc_lady_centri_2_rpm' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_plasmas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='qc_lady_centri_1' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_plasmas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='qc_lady_centri_1_duration_min' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_plasmas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='qc_lady_centri_2' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_plasmas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='qc_lady_centri_2_duration_min' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_plasmas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='qc_lady_filtered' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_plasmas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='qc_lady_centri_1_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_centrifugation_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_der_plasmas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='qc_lady_centri_2_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_centrifugation_unit') AND `flag_confidential`='0');

UPDATE aliquot_masters SET in_stock='yes - available' WHERE in_stock='available';
UPDATE aliquot_masters_revs SET in_stock='yes - available' WHERE in_stock='available';

INSERT INTO structure_permissible_values (value, language_alias) VALUES("formalin", "formalin");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_tissue_tube_storage_solution"), (SELECT id FROM structure_permissible_values WHERE value="formalin" AND language_alias="formalin"), "0", "1");

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');

-- 2012-06-19
UPDATE misc_identifiers SET misc_identifier_control_id=11 WHERE misc_identifier_control_id=10;
DELETE FROM misc_identifier_controls WHERE id=10;
UPDATE misc_identifier_controls SET misc_identifier_name='Q-CROC-03', flag_once_per_participant=0 WHERE id=11;

-- 2012-06-20
ALTER TABLE participants
 ADD COLUMN qc_lady_has_family_history CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs
 ADD COLUMN qc_lady_has_family_history CHAR(1) NOT NULL DEFAULT '';
 
UPDATE participants AS p
INNER JOIN family_histories AS fh ON fh.participant_id=p.id
SET p.qc_lady_has_family_history='y';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'qc_lady_has_family_history', 'yes_no',  NULL , '0', '', '', '', 'has family history', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_lady_has_family_history' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='has family history' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

ALTER TABLE family_histories
 ADD COLUMN qc_lady_breast_or_ovarian_cancer CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE family_histories_revs
 ADD COLUMN qc_lady_breast_or_ovarian_cancer CHAR(1) NOT NULL DEFAULT '';
 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'FamilyHistory', 'family_histories', 'qc_lady_breast_or_ovarian_cancer', 'yes_no',  NULL , '0', '', '', '', 'breast or ovarian cancer', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_lady_breast_or_ovarian_cancer' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='breast or ovarian cancer' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO event_controls (disease_site, event_group, event_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('general', 'screening', 'biopsy', 1, 'event_masters,qc_lady_screening_biopsy', 'qc_lady_screening_biopsy', 0, 'screening|general|biopsy'); 

CREATE TABLE qc_lady_screening_biopsy(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT NOT NULL,
 had_biopsy CHAR(1) NOT NULL DEFAULT '',
 deleted BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY (event_master_id) REFERENCES event_masters(id)
)Engine=InnoDb;
CREATE TABLE qc_lady_screening_biopsy_revs(
 id INT UNSIGNED NOT NULL,
 event_master_id INT NOT NULL,
 had_biopsy CHAR(1) NOT NULL DEFAULT '',
 version_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 version_created DATETIME NOT NULL
)Engine=InnoDb;

INSERT INTO structures(`alias`) VALUES ('qc_lady_screening_biopsy');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'qc_lady_screening_biopsy', 'had_biopsy', 'yes_no',  NULL , '0', '', '', '', 'had a biopsy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_screening_biopsy'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_screening_biopsy' AND `field`='had_biopsy' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='had a biopsy' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_banking_nbr' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='banking #' AND `language_tag`=''), '1', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_visit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_collection_visit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='visit' AND `language_tag`=''), '1', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
UPDATE structure_formats SET `flag_override_type`='0', `type`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_lady_follow_up' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_coll_follow_up') AND `flag_confidential`='0');

