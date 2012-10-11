
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'qc_tf_active_surveillance', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''active surveillances'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('active surveillances', '1', '50');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('prior to surgery','Prior to surgery','', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'active surveillances'), 1),
('presently','Presently','', 2, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'active surveillances'), 1),
('no','No','', 7, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'active surveillances'), 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'active_surveillance', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_active_surveillance') , '0', '', '', '', 'active sureveillance', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='active_surveillance' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_active_surveillance')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='active sureveillance' AND `language_tag`=''), '3', '18', 'other', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE qc_tf_dxd_cpcbn ADD COLUMN active_surveillance varchar(50) default NULL;
ALTER TABLE qc_tf_dxd_cpcbn_revs ADD COLUMN active_surveillance varchar(50) default NULL;
INSERT IGNORE INTO i18n (id,en) VALUES ('active sureveillance','Active sureveillance');

INSERT INTO structure_permissible_values (value, language_alias) VALUES("failed rp", "failed rp");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_date_biochemical_recurrence_definition"), (SELECT id FROM structure_permissible_values WHERE value="failed rp" AND language_alias="failed rp"), "1", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="qc_tf_first_psa_3" AND spv.language_alias="qc_tf_first_psa_3";
DELETE FROM structure_permissible_values WHERE value="qc_tf_first_psa_3" AND language_alias="qc_tf_first_psa_3";
INSERT IGNORE INTO i18n (id,en) VALUES ("failed rp","Failed RP");

ALTER TABLE txd_radiations ADD COLUMN qc_tf_type varchar(50);
ALTER TABLE txd_radiations_revs ADD COLUMN qc_tf_type varchar(50);
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'qc_tf_radiotherapy_type', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''radiotherapy types'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('radiotherapy types', '1', '50');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('curative','Curative','', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'radiotherapy types'), 1),
('palliative','Palliative','', 2, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'radiotherapy types'), 1),
('adjuvant','Adjuvant','', 7, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'radiotherapy types'), 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txd_radiations', 'qc_tf_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_radiotherapy_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='qc_tf_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_radiotherapy_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('salvage','Salvage','', 8, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'radiotherapy types'), 1);

INSERT INTO structures(`alias`) VALUES ('qc_tf_txe_drugs');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txe_drugs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE treatment_controls SET applied_protocol_control_id = NULL, extended_data_import_process = NULL, extend_tablename = 'txe_chemos', extend_form_alias = 'qc_tf_txe_drugs' WHERE detail_form_alias IN ('qc_tf_ed_hormonotherapy', 'qc_tf_txd_chemos');
UPDATE structures SET alias = 'qc_tf_txd_hormonotherapy' WHERE alias = 'qc_tf_ed_hormonotherapy';
UPDATE treatment_controls SET detail_form_alias = 'qc_tf_txd_hormonotherapy' WHERE detail_form_alias = 'qc_tf_ed_hormonotherapy';
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'other treatment', 'bone specific', 1, 'txe_chemos', 'qc_tf_txd_others', 'txe_chemos', 'qc_tf_txe_drugs', 0, NULL, NULL, 'all|chemotherapy', 0),
(null, 'other treatment', 'HR specific', 1, 'txe_chemos', 'qc_tf_txd_others', 'txe_chemos', 'qc_tf_txe_drugs', 0, NULL, NULL, 'all|chemotherapy', 0);
UPDATE treatment_controls SET databrowser_label = CONCAT(tx_method,'|',disease_site);
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txe_drugs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='drug_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list') AND `flag_confidential`='0');
INSERT INTO structures(`alias`) VALUES ('qc_tf_txd_others');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_others'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en) VALUES ('add drug','Add drug'),('other treatment','Other treatment'),('HR specific','HR specific'),('bone specific','bone specific');
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="steroid" AND language_alias="steroid");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="anti-emetic" AND language_alias="anti-emetic");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="type"), (SELECT id FROM structure_permissible_values WHERE value="HR" AND language_alias="HR"), "", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="type"), (SELECT id FROM structure_permissible_values WHERE value="bone" AND language_alias="bone"), "", "1");
UPDATE treatment_controls SET detail_tablename = 'txd_chemos' WHERE detail_tablename = 'txe_chemos';
UPDATE treatment_controls SET extend_form_alias = 'qc_tf_txe_horm_drugs' WHERE tx_method = 'hormonotherapy' AND disease_site = 'general';
UPDATE treatment_controls SET extend_form_alias = 'qc_tf_txe_chemo_drugs' WHERE tx_method = 'chemotherapy' AND disease_site = 'general';
UPDATE treatment_controls SET extend_form_alias = 'qc_tf_txe_bone_drugs' WHERE tx_method = 'other treatment' AND disease_site = 'bone specific';
UPDATE treatment_controls SET extend_form_alias = 'qc_tf_txe_HR_drugs' WHERE tx_method = 'other treatment' AND disease_site = 'HR specific';

INSERT INTO structures(`alias`) VALUES ('qc_tf_txe_horm_drugs'),('qc_tf_txe_chemo_drugs'),('qc_tf_txe_bone_drugs'),('qc_tf_txe_HR_drugs');
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES
(null, 'horm_drug_list', '', '', 'Drug.Drug::getHormDrugPermissibleValues'),
(null, 'chemo_drug_list', '', '', 'Drug.Drug::getChemoDrugPermissibleValues'),
(null, 'bone_drug_list', '', '', 'Drug.Drug::getBoneDrugPermissibleValues'),
(null, 'HR_drug_list', '', '', 'Drug.Drug::getHrDrugPermissibleValues');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'txe_chemos', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='horm_drug_list') , '0', '', '', 'help_drug_id', 'drug', ''),
('ClinicalAnnotation', 'TreatmentExtend', 'txe_chemos', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chemo_drug_list') , '0', '', '', 'help_drug_id', 'drug', ''),
('ClinicalAnnotation', 'TreatmentExtend', 'txe_chemos', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bone_drug_list') , '0', '', '', 'help_drug_id', 'drug', ''),
('ClinicalAnnotation', 'TreatmentExtend', 'txe_chemos', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='HR_drug_list') , '0', '', '', 'help_drug_id', 'drug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txe_horm_drugs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='horm_drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_tf_txe_chemo_drugs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemo_drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_tf_txe_bone_drugs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bone_drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='qc_tf_txe_HR_drugs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_chemos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='HR_drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');

INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='horm_drug_list') AND `model`='TreatmentExtend' AND `field`='drug_id'), 'notEmpty');
INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='chemo_drug_list') AND `model`='TreatmentExtend' AND `field`='drug_id'), 'notEmpty');
INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='bone_drug_list') AND `model`='TreatmentExtend' AND `field`='drug_id'), 'notEmpty');
INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='HR_drug_list') AND `model`='TreatmentExtend' AND `field`='drug_id'), 'notEmpty');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Protocol/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Sop/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Datamart/Adhocs%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers%';

SET FOREIGN_KEY_CHECKS=0;
TRUNCATE drugs;
TRUNCATE drugs_revs;
SET FOREIGN_KEY_CHECKS=1;

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/SpecimenReviews%';
UPDATE specimen_review_controls SET flag_active = '0';
UPDATE aliquot_review_controls SET flag_active = '0';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('SpecimenReviewMaster'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('SpecimenReviewMaster'));

ALTER TABLE txd_radiations_revs CHANGE c_tf_dose_cg qc_tf_dose_cg int(6);

ALTER TABLE qc_tf_dxd_cpcbn DROP COLUMN id;
ALTER TABLE qc_tf_dxd_cpcbn_revs DROP COLUMN id;
ALTER TABLE qc_tf_dxd_metastasis DROP COLUMN id;
ALTER TABLE qc_tf_dxd_metastasis_revs DROP COLUMN id;

ALTER TABLE qc_tf_dxd_recurrence_bio DROP COLUMN id;
ALTER TABLE qc_tf_dxd_recurrence_bio_revs DROP COLUMN id;
ALTER TABLE qc_tf_ed_cpcbn DROP COLUMN id;
ALTER TABLE qc_tf_ed_cpcbn_revs DROP COLUMN id;
ALTER TABLE qc_tf_ed_psa DROP COLUMN id;
ALTER TABLE qc_tf_ed_psa_revs DROP COLUMN id;
ALTER TABLE qc_tf_txd_biopsies DROP COLUMN id;
ALTER TABLE qc_tf_txd_biopsies_revs DROP COLUMN id;
ALTER TABLE qc_tf_txd_hormonotherapies DROP COLUMN id;
ALTER TABLE qc_tf_txd_hormonotherapies_revs DROP COLUMN id;

ALTER TABLE qc_tf_ed_psa_revs MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT, MODIFY `version_created` datetime NOT NULL;
ALTER TABLE qc_tf_txd_biopsies_revs MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT, MODIFY `version_created` datetime NOT NULL;
ALTER TABLE qc_tf_txd_hormonotherapies_revs MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT, MODIFY `version_created` datetime NOT NULL;

DROP TABLE qc_tf_ed_cpcbn;
CREATE TABLE IF NOT EXISTS `qc_tf_ed_cpcbn` (
  `event_master_id` int(11) NOT NULL,
  `event_end_date` date DEFAULT NULL,
  `event_end_date_accuracy` char(1) DEFAULT '',
  `psa_ng_on_ml` float unsigned DEFAULT NULL,
  `radiotherapy` char(1) DEFAULT '',
  `radiotherapy_dose` varchar(50) DEFAULT '',
  `tx_precision1` varchar(50) DEFAULT '',
  `tx_precision2` varchar(50) DEFAULT '',
  `tx_precision3` varchar(50) DEFAULT '',
  `tx_precision4` varchar(50) DEFAULT '',
  `hormonotherapy` varchar(1) DEFAULT '',
  `chemiotherapy` varchar(1) DEFAULT '',
  `notes` text NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `qc_tf_ed_cpcbn`
  ADD CONSTRAINT `qc_tf_ed_cpcbn_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

DROP TABLE qc_tf_ed_cpcbn_revs;
CREATE TABLE IF NOT EXISTS `qc_tf_ed_cpcbn_revs` (
  `event_master_id` int(11) NOT NULL,
  `event_end_date` date DEFAULT NULL,
  `event_end_date_accuracy` char(1) DEFAULT '',
  `psa_ng_on_ml` float unsigned DEFAULT NULL,
  `radiotherapy` char(1) DEFAULT '',
  `radiotherapy_dose` varchar(50) DEFAULT '',
  `tx_precision1` varchar(50) DEFAULT '',
  `tx_precision2` varchar(50) DEFAULT '',
  `tx_precision3` varchar(50) DEFAULT '',
  `tx_precision4` varchar(50) DEFAULT '',
  `hormonotherapy` varchar(1) DEFAULT '',
  `chemiotherapy` varchar(1) DEFAULT '',
  `notes` text NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

TRUNCATE acos;

