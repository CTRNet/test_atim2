-- PedVas Custom Script
-- Version: v0.4
-- ATiM Version: v2.5.2

-- This script must be run against a v2.5.2 ATiM database with all previous custom scripts applied.
-- NOTE: PedVas wished to keep data entered on the development site. Be sure to run this update on that version!


-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'PedVas - v0.4 DEV', '');

/*
	------------------------------------------------------------
	Eventum ID: 2765 - Treatment - Disable all default types
	------------------------------------------------------------
*/

UPDATE `treatment_controls` SET `flag_active`='1' WHERE `tx_method`='chemotherapy';
UPDATE `treatment_controls` SET `flag_active`='0' WHERE `tx_method`='radiation';
UPDATE `treatment_controls` SET `flag_active`='0' WHERE `tx_method`='surgery';
UPDATE `treatment_controls` SET `flag_active`='0' WHERE `tx_method`='surgery without extension';

/*
	------------------------------------------------------------
	Eventum ID: 2761 - Storage config
	------------------------------------------------------------
*/

UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='cupboard';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='incubator';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='fridge';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='box';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='box81 1A-9I';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='box81';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='box25';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='box100 1A-20E';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='TMA-blc 23X15';
UPDATE `storage_controls` SET `flag_active`='0' WHERE `storage_type`='TMA-blc 29X21';


/*
	------------------------------------------------------------
	Eventum ID: 2765 - New treatment type - Medications
	------------------------------------------------------------
*/

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES ('medication', 'general', '1', 'txd_pv_medications', 'txd_pv_medications', 'txe_pv_medications', 'txe_pv_medications', '0', '1', 'importDrugFromChemoProtocol', 'all|medication');

INSERT INTO `structures` (`alias`) VALUES ('txd_pv_medications');
INSERT INTO `structures` (`alias`) VALUES ('txe_pv_medications');

CREATE TABLE `txd_pv_medications` (
  `pv_medication_completed` varchar(50) DEFAULT NULL,
  `response` varchar(50) DEFAULT NULL,
  `num_cycles` int(11) DEFAULT NULL,
  `length_cycles` int(11) DEFAULT NULL,
  `completed_cycles` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  KEY `tx_master_id` (`treatment_master_id`),
  CONSTRAINT `txd_medications_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `txd_pv_medications_revs` (
  `pv_medication_completed` varchar(50) DEFAULT NULL,
  `response` varchar(50) DEFAULT NULL,
  `num_cycles` int(11) DEFAULT NULL,
  `length_cycles` int(11) DEFAULT NULL,
  `completed_cycles` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `txe_pv_medications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dose` varchar(50) DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_txe_medications_drugs` (`drug_id`),
  KEY `FK_txe_medications_tx_masters` (`treatment_master_id`),
  CONSTRAINT `FK_txe_medications_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`),
  CONSTRAINT `txe_medications_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `txe_pv_medications_revs` (
  `id` int(11) NOT NULL,
  `dose` varchar(50) DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Build detail table
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txd_pv_medications', 'pv_medication_completed', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'pv medication completed', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_pv_medications', 'response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='response') , '0', '', '', '', 'response', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_pv_medications', 'num_cycles', 'integer_positive',  NULL , '0', 'size=5', '', '', 'number cycles', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_pv_medications', 'length_cycles', 'integer_positive',  NULL , '0', 'size=5', '', '', 'length cycles', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_pv_medications', 'completed_cycles', 'integer_positive',  NULL , '0', 'size=5', '', '', 'completed cycles', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txd_pv_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_pv_medications' AND `field`='pv_medication_completed' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv medication completed' AND `language_tag`=''), '2', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txd_pv_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_pv_medications' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='response' AND `language_tag`=''), '2', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txd_pv_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_pv_medications' AND `field`='num_cycles' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='number cycles' AND `language_tag`=''), '2', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txd_pv_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_pv_medications' AND `field`='length_cycles' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='length cycles' AND `language_tag`=''), '2', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txd_pv_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_pv_medications' AND `field`='completed_cycles' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='completed cycles' AND `language_tag`=''), '2', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txd_pv_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txd_pv_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txd_pv_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_protocol_name' AND `language_label`='protocol' AND `language_tag`=''), '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('pv medication completed', 'Medication Completed', '');

-- Build Extended Table
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'txe_pv_medications', 'dose', 'input',  NULL , '0', 'size=10', '', '', 'dose', ''), 
('ClinicalAnnotation', 'TreatmentExtend', 'txe_pv_medications', 'method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') , '0', '', '', '', 'method', ''), 
('ClinicalAnnotation', 'TreatmentExtend', 'txe_pv_medications', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='drug_list') , '0', '', '', '', 'drug', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txe_pv_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_pv_medications' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_pv_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_pv_medications' AND `field`='method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='txe_pv_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='txe_pv_medications' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');


/*
	------------------------------------------------------------
	Eventum ID: 2762 - Presentation Form - Infection Status
	------------------------------------------------------------
*/

ALTER TABLE `ed_all_clinical_presentations` 
ADD COLUMN `pv_other_infection_detail` VARCHAR(255) NULL DEFAULT NULL AFTER `pv_other_infection`;

ALTER TABLE `ed_all_clinical_presentations_revs` 
ADD COLUMN `pv_other_infection_detail` VARCHAR(255) NULL DEFAULT NULL AFTER `pv_other_infection`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_all_clinical_presentations', 'pv_other_infection_detail', 'input',  NULL , '0', 'size=50', '', '', '', 'pv other infection detail');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_all_clinical_presentation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_presentations' AND `field`='pv_other_infection_detail' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='pv other infection detail'), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_formats SET `language_heading`='pv_infections' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_presentation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_presentations' AND `field`='pv_hepatitis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('pv other infection detail', 'Specify Other Infection(s)', ''),
 ('pv infections', 'Infections', '');

/*
	------------------------------------------------------------
	Eventum ID: 2764 - Saliva and Blood tube types
	------------------------------------------------------------
*/	
	
ALTER TABLE `sd_spe_salivas` 
ADD COLUMN `pv_saliva_tube_other` VARCHAR(255) NULL DEFAULT NULL AFTER `pv_saliva_tube`;

CREATE TABLE `sd_spe_salivas_revs` (
  `sample_master_id` int(11) NOT NULL,
  `pv_saliva_tube` varchar(45) DEFAULT NULL,
  `pv_saliva_tube_other` VARCHAR(255) NULL DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1;

ALTER TABLE `sd_spe_bloods` 
ADD COLUMN `pv_blood_tube_other` VARCHAR(255) NULL DEFAULT NULL AFTER `collected_volume_unit`;

ALTER TABLE `sd_spe_bloods_revs` 
ADD COLUMN `pv_blood_tube_other` VARCHAR(255) NULL DEFAULT NULL AFTER `collected_volume_unit`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_salivas', 'pv_saliva_tube_other', 'input',  NULL , '0', 'size=30', '', '', '', 'pv saliva tube other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_salivas'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_salivas' AND `field`='pv_saliva_tube_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='pv saliva tube other'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'pv_blood_tube_other', 'input',  NULL , '0', 'size=30', '', '', '', 'pv blood tube other');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='pv_blood_tube_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='pv blood tube other'), '1', '442', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('pv saliva tube other', 'Saliva Tube Other', ''),
 ('pv blood tube other', 'Blood Tube Other', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('K2-EDTA', 'K2-EDTA', ''),
 ('P100 Plasma', 'P100 Plasma', ''),
 ('PAXgene DNA', 'PAXgene DNA', ''),
 ('PAXgene RNA', 'PAXgene RNA', ''),
 ('Tempus RNA', 'Tempus RNA', ''),
 ('Serum', 'Serum', '');   

/*
	------------------------------------------------------------
	Eventum ID: 2759 - Collection form - unable to edit custom fields
	------------------------------------------------------------
*/

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='pv_visit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='pv_visit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv visit' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='pv_medication_sampling' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv medication sampling' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='pv_date_shipment' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv date shipment' AND `language_tag`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');


/*
	------------------------------------------------------------
	Eventum ID: 2763 - Annotation Form - Disable all unused forms
	------------------------------------------------------------
*/

UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='35';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='36';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='37';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='38';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='39';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='40';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='41';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='42';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='43';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='44';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='45';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='50';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='34';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='32';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='30';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='18';
UPDATE `event_controls` SET `flag_active`='0' WHERE `id`='20';