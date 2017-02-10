-- BCCH Customization Script
-- Version 0.2
-- ATiM Version: 2.6.3
-- Stephen Fung
-- sfung1@cfri.ca

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.2", '');

-- ==========================================================================
-- Eventum ID #3201 - Patch for Last modification date
-- ==========================================================================

UPDATE participants
SET `last_modification`=NOW()
WHERE `last_modification`='0000-00-00 00:00:00';

UPDATE participants_revs
SET `last_modification`=NOW()
WHERE `last_modification`='0000-00-00 00:00:00';

--  =========================================================================
--	Eventum ID: #3202 - Enable volume (mL) for Blood Aliquots
--										- Old Data Migration
--	=========================================================================

UPDATE structure_formats
SET `flag_add`=1, `flag_edit`=1, `flag_search`=1, `flag_addgrid`=1, `flag_index`=1, `flag_detail`=1
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='ad_spec_tubes_incl_ml_vol')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive');

UPDATE structure_formats
SET `flag_summary`=1, `flag_index`=1, `flag_detail`=1
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='ad_spec_tubes_incl_ml_vol')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='current_volume' AND `type`='float');

UPDATE structure_formats
SET `flag_detail`=1
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='ad_spec_tubes_incl_ml_vol')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select')
AND `display_order`=72;

UPDATE structure_formats
SET `flag_add`=1, `flag_add_readonly`=1, `flag_edit`=1, `flag_edit_readonly`=1, `flag_addgrid`=1, `flag_addgrid_readonly`=1, `flag_editgrid`=1, `flag_editgrid_readonly`=1, `flag_detail`=1
WHERE `structure_id`=(SELECT `id` FROM structures WHERE `alias`='ad_spec_tubes_incl_ml_vol')
AND `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='volume_unit' AND `type`='select')
AND `display_order`=74;

--  =========================================================================
--	Eventum ID: #3203 - Enable volume (mL) for Bone Marrow Aliquots
--										- Old Data Migration
--	=========================================================================

UPDATE aliquot_controls
SET `flag_active`=0
WHERE `sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='bone marrow' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_bone_marrows')
AND `detail_tablename`='ad_tubes'
AND `detail_form_alias`='ad_ccbr_spec_tubes_incl_cell_count';

UPDATE aliquot_controls
SET `flag_active`=1
WHERE `sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='bone marrow' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_bone_marrows')
AND `detail_tablename`='ad_tubes'
AND `detail_form_alias`='ad_spec_tubes_incl_ml_vol';

--  =========================================================================
--	Eventum ID: #3204 - Enable Cell Count for Expanded Cells
--										- Old Data Migration
--	=========================================================================

UPDATE aliquot_controls
SET `flag_active`=0
WHERE `sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr expanded cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_expanded_cells')
AND `detail_tablename`='ad_tubes'
AND `detail_form_alias`='ad_ccbr_spec_tubes_incl_cell_count';

INSERT INTO aliquot_controls
(`sample_control_id`,
`aliquot_type`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr expanded cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_expanded_cells'),
'tube', 'ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', 1, 'Derivative tube requiring volume in ml specific for cells', 0, 'expanded cell|tube');

--  =========================================================================
--	Eventum ID: #3160 - New sample type (Swab)
--	=========================================================================

CREATE TABLE `sd_spe_swabs` (
  `sample_master_id` int(11) NOT NULL,
  `ccbr_swab_location` varchar(255) DEFAULT NULL,
  KEY `FK_sd_spe_swabss_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_swabs_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_spe_swabs_revs` (
  `sample_master_id` int(11) NOT NULL,
  `ccbr_swab_location` varchar(255) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Add structure
INSERT INTO `structures` (`alias`) VALUES ('sd_spe_swabs');

-- Add swab location field to detail form
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
 ('ccbr swab', 'specimen', 'sd_spe_swabs,specimens', 'sd_spe_swabs', '0', 'swab');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr swab', "Swab", '');

-- Value domain for swab location
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ccbr_swab_location", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("buccal", "buccal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_swab_location"), (SELECT id FROM structure_permissible_values WHERE value="buccal" AND language_alias="buccal"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("cervix", "cervix");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_swab_location"), (SELECT id FROM structure_permissible_values WHERE value="cervix" AND language_alias="cervix"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("vagina", "vagina");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ccbr_swab_location"), (SELECT id FROM structure_permissible_values WHERE value="vagina" AND language_alias="vagina"), "3", "1");

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('buccal', "Buccal", ''),
('cervix', "Cervix", ''),
('vagina', "Vagina", '');

-- Add swab location to detail form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_swabs', 'ccbr_swab_location', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ccbr_swab_location') , '0', '', '', '', 'ccbr swab location', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES
((SELECT id FROM structures WHERE alias='sd_spe_swabs'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_swabs' AND `field`='ccbr_swab_location' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ccbr_swab_location')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ccbr swab location' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr swab location', "Swab Location", '');

-- Enable new sample type
INSERT INTO `parent_to_derivative_sample_controls` (`derivative_sample_control_id`, `flag_active`) VALUES ((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'ccbr swab'), '1');

-- Add aliquot
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `detail_form_alias`, `detail_tablename`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
 ((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'ccbr swab'), 'tube', 'ad_spec_tubes', 'ad_tubes', '1', 'Specimen tube', '0', 'swab|tube');

REPLACE INTO i18n (`id`, `en`) VALUES
('swab', 'Swab');

--  =========================================================================
--	Eventum ID: #3191 - Adding dropdown menu for referral clinic
--	=========================================================================

-- Adding the new field to the participant tables

ALTER TABLE participants
ADD COLUMN ccbr_referral_clinic VARCHAR(45) DEFAULT NULL
AFTER ccbr_relationship_other;

ALTER TABLE participants_revs
ADD COLUMN ccbr_referral_clinic VARCHAR(45) DEFAULT NULL
AFTER ccbr_relationship_other;

INSERT INTO structure_value_domains
(`domain_name`, `override`, `source`)
VALUES
('custom ccbr referral clinic', 'open', 'StructurePermissibleValuesCustom::getCustomDropDown(''ccbr referral clinic'')');

-- Custom permissible values so users can change the drop down at the UI
INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('ccbr referral clinic', 1, 50, 'clinical - consent', 100, 100);

-- this line may not be required for now
INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='ccbr referral clinic' AND `category`='clinical - consent'),
 'BCCH Clinic', 'BCCH Clinic', 0, 1, NOW(), 1, NOW(), 1, 0);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `structure_value_domain`, `validation_control`, `value_domain_control`, `field_control`)
VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'ccbr_referral_clinic', 'ccbr referral clinic', '', 'select',
 (SELECT `id` FROM structure_value_domains WHERE `domain_name`='custom ccbr referral clinic' AND `override`='open'),
  'open', 'open', 'open');

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
	`display_column`, `display_order`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`,
`flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`,
`flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='participants'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='ccbr_referral_clinic'
AND `language_label`='ccbr referral clinic' AND `type`='select' AND `structure_value_domain`=(SELECT `id` FROM structure_value_domains WHERE `domain_name`='custom ccbr referral clinic' AND `override`='open')),
1, 9,
0, 0, 0, 0, 0, 0,
1, 0, 1, 0, 0,
0, 0, 0, 0, 0,
0, 0, 0, 0, 1,
0, 0);

REPLACE INTO i18n (`id`, `en`) VALUES
('ccbr referral clinic', 'Referral Clinic');

--  =========================================================================
--	Eventum ID: #3205 - Add Mononuclear Cells Derivative
--  Primary derivatives for both Blood and Bone Marrow
--  Replaces the PBMC derivatives for Blood
--	=========================================================================

CREATE TABLE sd_der_ccbr_mononuclear_cells (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_ccbr_mononuclear_cells_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_ccbr_mononuclear_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE sd_der_ccbr_mononuclear_cells_revs (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO sample_controls (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`)
VALUES
('ccbr mononuclear cells', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_ccbr_mononuclear_cells', 0, 'mononuclear cell');

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`)
VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'bone marrow' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_bone_marrows'),
 (SELECT `id` FROM sample_controls WHERE `sample_type` = 'ccbr mononuclear cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_mononuclear_cells'), 1),
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'blood' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_bloods'),
 (SELECT `id` FROM sample_controls WHERE `sample_type` = 'ccbr mononuclear cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_mononuclear_cells'), 1);


INSERT INTO aliquot_controls
(`sample_control_id`, `aliquot_type`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`)
VALUES
 ((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'ccbr mononuclear cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_mononuclear_cells'),
'tube', 'ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', 1, 'Derivative tube requiring volume in ml specific for cells', 0, 'mononuclear cell|tube');

REPLACE INTO i18n (`id`, `en`) VALUES
('ccbr mononuclear cells', 'Mononuclear Cells'),
('mononuclear cell', 'Mononuclear Cells');

--  =========================================================================
--	Eventum ID: #3206 - Add Buffy Coat Derivative
--  Buffy Coat replaces the Blood Cell derivative
--  Does not require data migration
--	=========================================================================

CREATE TABLE sd_der_ccbr_buffy_coats (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_der_ccbr_buffy_coats_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_der_ccbr_buffy_coats_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE sd_der_ccbr_buffy_coats_revs (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO sample_controls (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`)
VALUES
('ccbr buffy coat', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_ccbr_buffy_coats', 0, 'buffy coat');

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`)
VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'bone marrow' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_bone_marrows'),
 (SELECT `id` FROM sample_controls WHERE `sample_type` = 'ccbr buffy coat' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_buffy_coats'), 1),
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'blood' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_bloods'),
 (SELECT `id` FROM sample_controls WHERE `sample_type` = 'ccbr buffy coat' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_buffy_coats'), 1);

INSERT INTO aliquot_controls
(`sample_control_id`, `aliquot_type`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`)
VALUES
 ((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'ccbr buffy coat' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_buffy_coats'),
'tube', 'ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', 1, 'Derivative tube requiring volume in ml specific for cells', 0, 'buffy coat|tube');

REPLACE INTO i18n (`id`, `en`) VALUES
('ccbr buffy coat', 'Buffy Coat');

-- Diable Blood Cells

UPDATE parent_to_derivative_sample_controls
SET `flag_active`=0
WHERE `parent_sample_control_id` IN (SELECT `id` FROM sample_controls WHERE `sample_type`='blood' OR `sample_type`='bone marrow')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='blood cell' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_blood_cells');

--  =========================================================================
--	Eventum ID: #3207 - Add RNA as primary derivative
--	=========================================================================

UPDATE parent_to_derivative_sample_controls
SET flag_active=1
WHERE `parent_sample_control_id` IN (SELECT `id` FROM sample_controls WHERE `sample_type`='blood' OR `sample_type`='tissue')
AND `derivative_sample_control_id` = (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas');

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`)
VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'bone marrow' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_bone_marrows'),
 (SELECT `id` FROM sample_controls WHERE `sample_type` = 'rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'), 1),
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'csf' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_csfs'),
 (SELECT `id` FROM sample_controls WHERE `sample_type` = 'rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'), 1),
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'saliva' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_salivas'),
 (SELECT `id` FROM sample_controls WHERE `sample_type` = 'rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'), 1);

-- 2015-03-25

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr swab' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_swabs'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1);

REPLACE INTO i18n (`id`, `en`) VALUES
('rna', 'RNA');

--  =========================================================================
--	Eventum ID: #3207 - Add RNA as secondary derivatives
--	=========================================================================

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='csf cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_csf_cells'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr buffy coat' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_buffy_coats'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr mononuclear cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_mononuclear_cells'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr stem cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_stem_cells'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr leukapheresis' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_leukapheresis'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr expanded cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_expanded_cells'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='csf supernatant' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_csf_sups'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='serum' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_serums'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='tissue suspension' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_tiss_sups'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='tissue lysate' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_tiss_lysates'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1);

UPDATE parent_to_derivative_sample_controls
SET `flag_active`=1
WHERE `parent_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='bone marrow suspension' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_bone_marrow_susps')
AND `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas');

-- 2015-03-25
INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='plasma' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_plasmas'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1);

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='tissue suspension' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_tiss_susps'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas'),1);



--  =========================================================================
--	Eventum ID: #3208 - Add DNA as primary and secondary derivatives
--	=========================================================================

-- Enable DNA as primary derivative for Blood
UPDATE parent_to_derivative_sample_controls
SET `flag_active`=1
WHERE `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas')
AND `parent_sample_control_id` IN (SELECT `id` FROM sample_controls WHERE `sample_type`='blood' OR `sample_category`='specimen');

-- Enable DNA as primary derivatives for the other specimen
INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='bone marrow' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_bone_marrows'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='csf' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_csfs'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1);

-- Enable DNA as secondary derivatives for the following primary derivatives
INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='csf cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_csf_cells'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr buffy coat' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_buffy_coats'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr mononuclear cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_mononuclear_cells'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr stem cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_stem_cells'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr leukapheresis' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_leukapheresis'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr expanded cells' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_ccbr_expanded_cells'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='csf supernatant' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_csf_sups'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='serum' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_serums'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='tissue suspension' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_tiss_sups'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1),
((SELECT `id` FROM sample_controls WHERE `sample_type`='tissue lysate' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_tiss_lysates'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1);

-- 2015-03-25
INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='plasma' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_plasmas'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1);

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='tissue suspension' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_tiss_susps'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1);

INSERT INTO parent_to_derivative_sample_controls (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type`='ccbr swab' AND `sample_category`='specimen' AND `detail_tablename`='sd_spe_swabs'),
 (SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas'),1);


-- Remove DNA and RNA as specimen

DELETE FROM parent_to_derivative_sample_controls
WHERE `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='dna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_dnas') AND `parent_sample_control_id` IS NULL;

DELETE FROM parent_to_derivative_sample_controls
WHERE `derivative_sample_control_id`=(SELECT `id` FROM sample_controls WHERE `sample_type`='rna' AND `sample_category`='derivative' AND `detail_tablename`='sd_der_rnas') AND `parent_sample_control_id` IS NULL;

--  ==============================================================================
--	Eventum ID: #3211 - Expand the tube type for Blood and Bone Marrow Samples
--  JIRA ID: BB-39
--	==============================================================================

-- Bone Marrow 

INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES
('Lithium Heparin', 'ccbr lithium heparin'),
('Sodium Heparin', 'ccbr sodium heparin');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='ccbr_bm_tube_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='Lithium Heparin' AND `language_alias`='ccbr lithium heparin'),
 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='ccbr_bm_tube_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='Sodium Heparin' AND `language_alias`='ccbr sodium heparin'),
 4, 1, 1);

REPLACE into i18n (`id`, `en`) VALUES
('ccbr lithium heparin', 'Lithium Heparin'),
('ccbr sodium heparin', 'Sodium Heparin');

-- Blood

INSERT INTO structure_permissible_values (`value`, `language_alias`) VALUES
('PAXgene RNA', 'ccbr paxgene RNA'),
('PAXgene DNA', 'ccbr paxgene DNA'),
('Red Top', 'ccbr red top'),
('SST', 'ccbr sst');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='blood_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='Lithium Heparin' AND `language_alias`='ccbr lithium heparin'),
 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='blood_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='Sodium Heparin' AND `language_alias`='ccbr sodium heparin'),
 4, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='blood_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='PAXgene RNA' AND `language_alias`='ccbr paxgene RNA'),
 5, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='blood_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='PAXgene DNA' AND `language_alias`='ccbr paxgene DNA'),
 6, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='blood_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='Red Top' AND `language_alias`='ccbr red top'),
 7, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='blood_type'), 
 (SELECT `id` FROM structure_permissible_values WHERE `value`='SST' AND `language_alias`='ccbr sst'),
 8, 1, 1);

REPLACE into i18n (`id`, `en`) VALUES
('ccbr paxgene RNA', 'PAXgene RNA'),
('ccbr paxgene DNA', 'PAXgene DNA'),
('ccbr red top', 'Red Top'),
('ccbr sst', 'SST');
