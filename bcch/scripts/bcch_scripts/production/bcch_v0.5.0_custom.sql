-- BCCH Customization Script
-- Version 0.5
-- ATiM Version: 2.6.5

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.5", '');

-- ============================================================================
-- Eventum ID:XXXX In Data Browser can't search Reproductive History by dates
-- BB-106
-- ============================================================================

UPDATE structure_formats SET `flag_search` = 1 WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'reproductivehistories') AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ReproductiveHistory' AND `tablename` = 'reproductive_histories' AND `field` = 'lnmp_date' AND `type` = 'date');

UPDATE structure_formats SET `flag_search` = 1
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'reproductivehistories')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ReproductiveHistory' AND `tablename` = 'reproductive_histories' AND `field` = 'date_captured' AND `type` = 'date');

-- ==============================================================================================================
-- Eventum ID:XXXX
-- BB-137: Issue with editing identifiers that are not linked to study
-- ==============================================================================================================

UPDATE misc_identifier_controls
SET `flag_link_to_study` = 1
WHERE `misc_identifier_name` = 'PHN' OR `misc_identifier_name` = 'MRN' OR `misc_identifier_name` = 'COG Registration' OR `misc_identifier_name` = 'CCBR Identifier';

UPDATE misc_identifiers
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN')
OR `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'MRN')
OR `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'COG Registration')
OR `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'CCBR Identifier');

UPDATE misc_identifiers_revs
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN')
OR `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'MRN')
OR `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'COG Registration')
OR `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'CCBR Identifier');

REPLACE INTO i18n (`id`, `en`) VALUES
('MRN', 'MRN');

-- ================================================
-- Eventum ID: XXXX
-- BB-141: CCBR Identifier Validation Error Message
-- ================================================

REPLACE INTO i18n (`id`, `en`) VALUES 
('ccbr validation error', 'CCBR Identifier must begin with CCBR and follow with numbers');

-- ==============================================================================================================
-- Eventum ID:XXXX
-- BB-114: Add a new field in Study Summary form called "Study Complete Title"
-- ==============================================================================================================

ALTER TABLE study_summaries
	ADD COLUMN `full_title` VARCHAR(255) DEFAULT NULL AFTER `title`;

ALTER TABLE study_summaries_revs
	ADD COLUMN `full_title` VARCHAR(255) DEFAULT NULL AFTER `title`;

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('Study', 'StudySummary', 'study_summaries', 'full_title', 'study_full_title', 'input', 'size=50', NULL, 'full_title_help', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`,
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`,
`flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'studysummaries'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model` = 'StudySummary' AND `tablename`='study_summaries' AND `field` = 'full_title' AND `language_label` = 'study_full_title'), 1, 2,
0, 0, 0, 0, 0,
1, 0, 1, 0, 1, 0,
0, 0, 0, 0, 1,
0, 0, 0, 1, 0, 0);

REPLACE INTO i18n (`id`, `en`) VALUES
('study_full_title', 'Study Complete Title'),
('full_title_help', 'The full and complete title of the study');

--  ==============================================================================================================
--	Eventum ID:XXXX
--  BB-142: Change the "Title" of Study to "Study Title Acronym"
--	==============================================================================================================

UPDATE structure_fields
SET language_label = 'study_title_acronym'
WHERE plugin = 'Study' AND model = 'StudySummary' AND tablename = 'study_summaries' AND field = 'title';

REPLACE INTO i18n (`id`, `en`) VALUES
('study_title_acronym', 'Study Title Acronym');

--  ==============================================================================================================
--	Eventum ID:XXXX  - Disease Site field in Family History triggers validation error
--  BB-113
--	==============================================================================================================

-- Reanble the field at the UI
UPDATE structure_formats
SET `flag_add` = 1, `flag_edit` = 1, `flag_search` = 1, `flag_addgrid`= 1, `flag_editgrid` = 1, `flag_summary` = 1, `flag_index` = 1, `flag_detail` = 1
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'familyhistories')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'FamilyHistory' AND `tablename` = 'family_histories' AND `field` = 'ccbr_disease_site');

-- Change column type from int to varchar(255)
ALTER TABLE family_histories MODIFY `ccbr_disease_site` VARCHAR(255);
ALTER TABLE family_histories_revs MODIFY `ccbr_disease_site` VARCHAR(255);

--  ==============================================================================================================
--	Eventum ID:XXXX  - Reports not returning the correct number of consent forms
--  BB-110
--	==============================================================================================================

-- Get the CCBR Consent Forms
INSERT INTO structure_fields
(`plugin`, `model`, `field`, `language_label`, `type`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('Datamart', 0, 'obtained_ccbr_consents_nbr', 'obtained ccbr consents', 'input', NULL, 'obtained_ccbr_consents_nbr_help', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`,
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
`flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'bank_activty_report'),
(SELECT `id` FROM structure_fields WHERE `plugin` = 'Datamart' AND `model` = 0 AND `field` = 'obtained_ccbr_consents_nbr' AND `type` = 'input'), 0, 4,
0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0,
0, 1, 0, 0);

REPLACE into i18n (`id`, `en`) VALUES
('obtained ccbr consents', 'Obtained Formal CCBR Consents'),
('obtained_ccbr_consents_nbr_help', 'The number of formal CCBR consents obtained over the total number of CCBR Consents');

-- Get the BCCH Consent Forms
INSERT INTO structure_fields
(`plugin`, `model`, `field`, `language_label`, `type`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('Datamart', 0, 'obtained_bcch_consents_nbr', 'obtained bcch consents', 'input', NULL, 'obtained_bcch_consents_nbr_help', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`,
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
`flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'bank_activty_report'),
(SELECT `id` FROM structure_fields WHERE `plugin` = 'Datamart' AND `model` = 0 AND `field` = 'obtained_bcch_consents_nbr' AND `type` = 'input'), 0, 5,
0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0,
0, 1, 0, 0);

REPLACE into i18n (`id`, `en`) VALUES
('obtained bcch consents', 'Obtained Formal BCCH Consents'),
('obtained_bcch_consents_nbr_help', 'The number of formal BCCH consents obtained over the total number of BCCH Consents');

-- Get the BCWH Consent Forms
INSERT INTO structure_fields
(`plugin`, `model`, `field`, `language_label`, `type`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('Datamart', 0, 'obtained_bcwh_consents_nbr', 'obtained bcwh consents', 'input', NULL, 'obtained_bcwh_consents_nbr_help', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`,
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
`flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'bank_activty_report'),
(SELECT `id` FROM structure_fields WHERE `plugin` = 'Datamart' AND `model` = 0 AND `field` = 'obtained_bcwh_consents_nbr' AND `type` = 'input'), 0, 6,
0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0,
0, 1, 0, 0);

REPLACE into i18n (`id`, `en`) VALUES
('obtained bcwh consents', 'Obtained Formal BCWH Consents'),
('obtained_bcwh_consents_nbr_help', 'The number of formal BCWH consents obtained over the total number of BCWH Consents');

-- Get the BCWH Maternal Consent Forms
INSERT INTO structure_fields
(`plugin`, `model`, `field`, `language_label`, `type`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('Datamart', 0, 'obtained_bcwh_maternal_consents_nbr', 'obtained bcwh maternal consents', 'input', NULL, 'obtained_bcwh_maternal_consents_nbr_help', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`, `display_column`, `display_order`,
`flag_override_label`, `flag_override_tag`, `flag_override_help`, `flag_override_type`, `flag_override_setting`, `flag_override_default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`,
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`,
`flag_index`, `flag_detail`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'bank_activty_report'),
(SELECT `id` FROM structure_fields WHERE `plugin` = 'Datamart' AND `model` = 0 AND `field` = 'obtained_bcwh_maternal_consents_nbr' AND `type` = 'input'), 0, 7,
0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0,
0, 1, 0, 0);

REPLACE into i18n (`id`, `en`) VALUES
('obtained bcwh maternal consents', 'Obtained Formal BCWH Maternal Consents'),
('obtained_bcwh_maternal_consents_nbr_help', 'The number of formal BCWH Maternal consents obtained over the total number of BCWH Maternal Consents');

--  =============================================================================
--	Eventum ID: #XXXX
--  BB-118: Make "Tissue Source" user customizable and display on collection tree
--	=============================================================================
-- Need debugging! User still can't edit the list!
-- Looks like this require debug mode!
UPDATE structure_value_domains
SET `override` = 'open', `source` = 'StructurePermissibleValuesCustom::getCustomDropDown(''Tissue Source'')'
WHERE `id` = (SELECT `structure_value_domain` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'SampleDetail' AND `tablename` = 'sd_spe_tissues' AND `field` = 'tissue_source' AND `type` = 'select');

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Tissue Source', 1, 50, 'inventory', 18, 18);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'brain', 'Brain', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'tonsils', 'Tonsils', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'adenoids', 'Adenoids', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'lung', 'Lung', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'kidney', 'Kidney', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'liver', 'Liver', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'breast', 'Breast', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'spleen', 'Spleen', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'skin', 'Skin', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'bone', 'Bone', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'muscle', 'Muscle', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'lymph node', 'Lymph Node', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'eye', 'Eye', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'stomach', 'Stomach', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'gi tract', 'GI Tract', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'colon', 'Colon', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'bowel', 'Bowel', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Tissue Source' AND `category`='inventory'), 'other', 'Other', 0, 1, NOW(), 1, NOW(), 1, 0);

ALTER TABLE sd_spe_tissues
	ADD COLUMN `tissue_source_other` VARCHAR(50) AFTER `tissue_source`;

ALTER TABLE sd_spe_tissues_revs
	ADD COLUMN `tissue_source_other` VARCHAR(50) AFTER `tissue_source`;

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'tissue_source_other', '', 'tissue source other', 'input', 'size=20', NULL, 'help_tissue_source_other', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERe `alias`='sd_spe_tissues'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source_other' AND `type` = 'input'),
1, 441, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 1, 0,
1, 0, 0, 1, 1, 0, 0);

REPLACE INTO i18n (`id`, `en`) VALUES
('tissue source other', 'If Other Tissue Source:'),
('help_tissue_source_other', 'If selected other in the dropdown, enter the tissue source in this text field.');


-- Display the field in collection tree view
INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'sample_masters_for_collection_tree_view'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field` = 'tissue_source' AND `language_label`='tissue source' AND `type`='select'),
0, 5, '', 0, 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0);

--  =============================================================================
--	Eventum ID: #XXXX
--  BB-120: Display SOP in Collection Tree View for Sample
--	=============================================================================

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'sample_masters_for_collection_tree_view'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field` = 'sop_master_id' AND `language_label`='sample sop' AND `type`='select'),
0, 4, '', 0, 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
1, 0, 0, 1, 0, 0, 0);

--  =============================================================================
--	Eventum ID: #XXXX
--  BB-129: Remove "Formal Consent" from Consent Form
--	=============================================================================

-- BCCH
-- Finished Checking

UPDATE `consent_masters`, `cd_bcch_consents`
SET `consent_masters`.`consent_status` = 'obtained'
WHERE `cd_bcch_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcch_consents`.`bcch_formal_consent` = 'consented';

UPDATE `consent_masters`, `cd_bcch_consents`
SET `consent_masters`.`consent_status` = 'withdrawn'
WHERE `cd_bcch_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcch_consents`.`bcch_formal_consent` = 'withdrawn';

UPDATE `consent_masters`, `cd_bcch_consents`
SET `consent_masters`.`consent_status` = 'denied'
WHERE `cd_bcch_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcch_consents`.`bcch_formal_consent` = 'declined';

UPDATE `consent_masters`, `cd_bcch_consents`
SET `consent_masters`.`consent_status` = 'pending'
WHERE `cd_bcch_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcch_consents`.`bcch_formal_consent` = ' '
AND `consent_masters`.`consent_status` = ' ';

UPDATE `consent_masters`, `cd_bcch_consents`
SET `consent_masters`.`consent_status` = 'pending'
WHERE `cd_bcch_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcch_consents`.`bcch_formal_consent` = ' '
AND `consent_masters`.`consent_status` IS NULL;

-- CCBR
-- Finished Checking

UPDATE `consent_masters`, `cd_ccbr_consents`
SET `consent_masters`.`consent_status` = 'obtained'
WHERE `cd_ccbr_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_ccbr_consents`.`ccbr_formal_consent` = 'consented'
AND `consent_masters`.`consent_status` IS NULL;

UPDATE `consent_masters`, `cd_ccbr_consents`
SET `consent_masters`.`consent_status` = 'obtained'
WHERE `cd_ccbr_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_ccbr_consents`.`ccbr_formal_consent` = 'consented'
AND `consent_masters`.`consent_status` = ' ';

UPDATE `consent_masters`, `cd_ccbr_consents`
SET `consent_masters`.`consent_status` = 'withdrawn'
WHERE `cd_ccbr_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_ccbr_consents`.`ccbr_formal_consent` = 'withdrawn'
AND `consent_masters`.`consent_status` IS NULL;

UPDATE `consent_masters`, `cd_ccbr_consents`
SET `consent_masters`.`consent_status` = 'denied'
WHERE `cd_ccbr_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_ccbr_consents`.`ccbr_formal_consent` = 'declined';

UPDATE `consent_masters`, `cd_ccbr_consents`
SET `consent_masters`.`consent_status` = 'pending'
WHERE `cd_ccbr_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_ccbr_consents`.`ccbr_formal_consent` = ' '
AND `consent_masters`.`consent_status` = ' ';

UPDATE `consent_masters`, `cd_ccbr_consents`
SET `consent_masters`.`consent_status` = 'pending'
WHERE `cd_ccbr_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_ccbr_consents`.`ccbr_formal_consent` = ' '
AND `consent_masters`.`consent_status` IS NULL;

-- BCWH
-- Finished Checking

UPDATE `consent_masters`, `cd_bcwh_consents`
SET `consent_masters`.`consent_status` = 'obtained'
WHERE `cd_bcwh_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcwh_consents`.`bcwh_formal_consent` = 'consented'
AND `consent_masters`.`consent_status` IS NULL;

UPDATE `consent_masters`, `cd_bcwh_consents`
SET `consent_masters`.`consent_status` = 'withdrawn'
WHERE `cd_bcwh_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcwh_consents`.`bcwh_formal_consent` = 'withdrawn'
AND `consent_masters`.`consent_status` IS NULL;

UPDATE `consent_masters`, `cd_bcwh_consents`
SET `consent_masters`.`consent_status` = 'denied'
WHERE `cd_bcwh_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcwh_consents`.`bcwh_formal_consent` = 'declined'
AND `consent_masters`.`consent_status` IS NULL;

UPDATE `consent_masters`, `cd_bcwh_consents`
SET `consent_masters`.`consent_status` = 'pending'
WHERE `cd_bcwh_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcwh_consents`.`bcwh_formal_consent` = ' '
AND `consent_masters`.`consent_status` IS NULL;


-- BCWH Maternal
-- Checked
UPDATE `consent_masters`, `cd_bcwh_maternal_consents`
SET `consent_masters`.`consent_status` = 'obtained'
WHERE `cd_bcwh_maternal_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcwh_maternal_consents`.`bcwh_maternal_formal_consent` = 'consented'
AND `consent_masters`.`consent_status` IS NULL;

UPDATE `consent_masters`, `cd_bcwh_maternal_consents`
SET `consent_masters`.`consent_status` = 'obtained'
WHERE `cd_bcwh_maternal_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcwh_maternal_consents`.`bcwh_maternal_formal_consent` = 'consented'
AND `consent_masters`.`consent_status` = ' ';

UPDATE `consent_masters`, `cd_bcwh_maternal_consents`
SET `consent_masters`.`consent_status` = 'withdrawn'
WHERE `cd_bcwh_maternal_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcwh_maternal_consents`.`bcwh_maternal_formal_consent` = 'withdrawn'
AND `consent_masters`.`consent_status` IS NULL;

UPDATE `consent_masters`, `cd_bcwh_maternal_consents`
SET `consent_masters`.`consent_status` = 'denied'
WHERE `cd_bcwh_maternal_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcwh_maternal_consents`.`bcwh_maternal_formal_consent` = 'declined'
AND `consent_masters`.`consent_status` IS NULL;

UPDATE `consent_masters`, `cd_bcwh_maternal_consents`
SET `consent_masters`.`consent_status` = 'pending'
WHERE `cd_bcwh_maternal_consents`.`consent_master_id` = `consent_masters`.`id`
AND `cd_bcwh_maternal_consents`.`bcwh_maternal_formal_consent` = ' '
AND `consent_masters`.`consent_status` IS NULL;

-- revs table

UPDATE `consent_masters_revs`, `consent_masters`
SET `consent_masters_revs`.`consent_status` = `consent_masters`.`consent_status`
WHERE `consent_masters_revs`.`id` = `consent_masters`.`id`;

-- Move the Consent Type field next to Consent status

UPDATE `structure_formats`
SET `display_order` = 7
WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'cd_ccbr_consents' OR `alias` = 'cd_bcch_consents' OR `alias` = 'cd_bcwh_consents' OR `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_ccbr_consents' AND `field` = 'ccbr_formal_consent_type' AND `type` = 'select');

UPDATE `structure_formats`
SET `display_order` = 7
WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'cd_ccbr_consents' OR `alias` = 'cd_bcch_consents' OR `alias` = 'cd_bcwh_consents' OR `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_formal_consent_type' AND `type` = 'select');

UPDATE `structure_formats`
SET `display_order` = 7
WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'cd_ccbr_consents' OR `alias` = 'cd_bcch_consents' OR `alias` = 'cd_bcwh_consents' OR `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_formal_consent_type' AND `type` = 'select');

UPDATE `structure_formats`
SET `display_order` = 7
WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'cd_ccbr_consents' OR `alias` = 'cd_bcch_consents' OR `alias` = 'cd_bcwh_consents' OR `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_formal_consent_type' AND `type` = 'select');

-- Add the Formal Consent text of the section

UPDATE `structure_formats`
SET `language_heading` = 'formal consent'
WHERE `structure_id` = (SELECT `id` FROM `structures` WHERE `alias` = 'consent_masters')
AND `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentMaster' AND `tablename` = 'consent_masters' AND `field` = 'form_version' AND `type` = 'select');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('formal consent', 'Formal Consent', '');

-- Remove the old formal consent field from display
UPDATE `structure_formats`
SET `flag_add`= 0 , `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'cd_ccbr_consents' OR `alias` = 'cd_bcch_consents' OR `alias` = 'cd_bcwh_consents' OR `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROm `structure_fields` WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_ccbr_consents' AND `field` = 'ccbr_formal_consent' AND `type` = 'select');

UPDATE `structure_formats`
SET `flag_add`= 0 , `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'cd_ccbr_consents' OR `alias` = 'cd_bcch_consents' OR `alias` = 'cd_bcwh_consents' OR `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROm `structure_fields` WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcch_consents' AND `field` = 'bcch_formal_consent' AND `type` = 'select');

UPDATE `structure_formats`
SET `flag_add`= 0 , `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'cd_ccbr_consents' OR `alias` = 'cd_bcch_consents' OR `alias` = 'cd_bcwh_consents' OR `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROm `structure_fields` WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_consents' AND `field` = 'bcwh_formal_consent' AND `type` = 'select');

UPDATE `structure_formats`
SET `flag_add`= 0 , `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE `structure_id` IN (SELECT `id` FROM `structures` WHERE `alias` = 'cd_ccbr_consents' OR `alias` = 'cd_bcch_consents' OR `alias` = 'cd_bcwh_consents' OR `alias` = 'cd_bcwh_maternal_consents')
AND `structure_field_id` = (SELECT `id` FROm `structure_fields` WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_bcwh_maternal_consents' AND `field` = 'bcwh_maternal_formal_consent' AND `type` = 'select');

--  =============================================================================
--	Eventum ID: #XXXX
--  BB-130: Add "Interrupted" to Consent Status
--	=============================================================================

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('interrupted', 'interrupted');

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'consent_status'), (SELECT `id` FROM `structure_permissible_values` WHERE `value` = 'interrupted'), 3, 1, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('interrupted', 'Interrupted', '');

-- Still need work
-- =============================================================================
-- Eventum ID: #XXXX
-- BB-139: Diagnosis Code Event Form
-- =============================================================================

-- Add notes to Event Masters table

ALTER TABLE event_masters
	ADD COLUMN `notes` text AFTER `reference_number`;

ALTER TABLE event_masters_revs
	ADD COLUMN `notes` text AFTER `reference_number`;

INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'EventMaster', 'event_masters', 'notes', 'notes', '', 'textarea', 'cols=40,rows=6', NULL, 'help_event_notes', 'open', 'open', 'open', 0);

-- Have coding module as "events"

CREATE TABLE `ed_bcch_dx_codes` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`code_source` varchar(80) DEFAULT NULL,
	`code_type` varchar(40) DEFAULT NULL,
	`code_value` varchar(40) DEFAULT NULL,
	`code_description` varchar(200) DEFAULT NULL,
	`code_validation` varchar(20) DEFAULT NULL,
	`event_master_id` int(11) DEFAULT NULL,
	PRIMARY KEY(`id`),
	CONSTRAINT `FK_ed_bcch_dx_codes_event_masters` FOREIGN KEY(`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_bcch_dx_codes_revs` (
	`id` int(11) NOT NULL,
	`code_source` varchar(80) DEFAULT NULL,
	`code_type` varchar(40) DEFAULT NULL,
	`code_value` varchar(40) DEFAULT NULL,
	`code_description` varchar(200) DEFAULT NULL,
	`code_validation` varchar(20) DEFAULT NULL,
	`event_master_id` int(11) DEFAULT NULL,
	`version_id` int(11) AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `event_controls`
(`disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`)
VALUES
('bcch', 'coding', 'diagnosis code', 1, 'ed_bcch_dx_codes', 'ed_bcch_dx_codes', 0, 'clinical|general|coding', 0, 0, 1);

INSERT INTO structure_value_domains (`domain_name`, `override`, `category`, `source`) VALUES
('bcch_dx_codes', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropDown(''Diagnosis Codes'')');

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Diagnosis Codes', 1, 50, 'clinical - event', 3, 3);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Diagnosis Codes' AND `category`='clinical - event'), 'icd-10-ca', 'ICD-10-CA', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Diagnosis Codes' AND `category`='clinical - event'), 'icd-10-who', 'ICD-10-WHO', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Diagnosis Codes' AND `category`='clinical - event'), 'icd-o-3', 'ICD-O-3', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name`='Diagnosis Codes' AND `category`='clinical - event'), 'snomed ct', 'SNOMED CT', 0, 1, NOW(), 1, NOW(), 1, 0);

INSERT INTO `structures` (`alias`, `description`) VALUES
('ed_bcch_dx_codes', NULL);

INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_bcch_dx_codes', 'code_source', 'code source', '', 'input', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcch_dx_codes', 'code_type', 'code type', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_dx_codes'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcch_dx_codes', 'code_value', 'code value', '', 'input', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcch_dx_codes', 'code_description', 'code description', '', 'input', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcch_dx_codes', 'code_validation', 'code validation', '', 'checkbox', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='yes_no_checkbox'), '', 'open', 'open', 'open', 0);

INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='ed_bcch_dx_codes'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcch_dx_codes' AND `field`='code_source' AND `type`='input'),
1, 1, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcch_dx_codes'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcch_dx_codes' AND `field`='code_type' AND `type`='select'),
1, 2, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcch_dx_codes'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcch_dx_codes' AND `field`='code_value' AND `type`='input'),
1, 3, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcch_dx_codes'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcch_dx_codes' AND `field`='code_description' AND `type`='input'),
1, 4, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcch_dx_codes'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcch_dx_codes' AND `field`='code_validation' AND `type`='checkbox'),
1, 5, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`)
VALUES
('clin_CAN_35', 'clin_CAN_4', 0, 8, 'coding', 'coding', '/ClinicalAnnotation/EventMasters/listall/Coding/%%Participant.id%%', 'ClinicalAnnotation.EventMaster::summary', 1, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('date of data entry', 'Data Entry Date', ''),
('code description', 'Description associated with the Code',''),
('code value', 'Code', ''),
('code source', 'Where did you see this code for this report?', ''),
('code type', 'Code Type', ''),
('code validation', 'Code validated by physician?', ''),
('bcch', 'BCCH', ''),
('Clinical Identifiers - bcch','Clinical Identifiers - BCCH',''),
('Clinical Identifiers - bcch', 'Clinical Identifiers - BCCH', ''),
('neonatal', 'Neonatal', ''),
('coding', 'Coding', ''),
('diagnosis code', 'Diagnosis Code', '');

UPDATE structure_formats
SET flag_add = 0, flag_edit = 0, flag_search = 0, flag_addgrid = 0, flag_editgrid= 0, flag_summary = 0, flag_index = 1, flag_detail = 0
WHERE structure_field_id = (SELECT id FROM structure_fields WHERE plugin = 'ClinicalAnnotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field = 'event_date')
AND structure_id = (SELECT id FROM structures WHERE alias = 'eventmasters');

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='ed_bcch_dx_codes'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'),
1, '-2', '', 1, 'date of data entry', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0);

-- Display Code Type and Value at Tree View --

INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='eventmasters'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcch_dx_codes' AND `field`='code_type' AND `type`='select'),
1, 4, '', 0, 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='eventmasters'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcch_dx_codes' AND `field`='code_value' AND `type`='input'),
1, 4, '', 0, 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='eventmasters'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcch_dx_codes' AND `field`='code_description' AND `type`='input'),
1, 4, '', 0, 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0);

--  =============================================================================
--	Eventum ID: #XXXX
--  BB-119: Oncology and Hematology Diagnosis Form
--	=============================================================================


-- Disable the old diagnosis form

UPDATE diagnosis_controls
SET flag_active = 0
WHERE category = 'primary'
AND (controls_type = 'benign blood disorder' OR controls_type = 'lymphoma' OR controls_type = 'leukemia' OR controls_type = 'solid tumour');

-- Oncology Form

CREATE TABLE `dxd_bcch_oncology` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`diagnosis_department` varchar(255) DEFAULT NULL,
	`final_diagnosis` varchar(255) DEFAULT NULL,
	`bone_marrow_involvement` varchar(45) DEFAULT NULL,
	`risk_group` varchar(45) DEFAULT NULL,
	`former_category` varchar(255) DEFAULT NULL,
	`diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
	PRIMARY KEY(`id`),
	CONSTRAINT `FK_dxd_bcch_oncology_diagnosis_masters` FOREIGN KEY(`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dxd_bcch_oncology_revs` (
	`id` int(11) NOT NULL,
	`diagnosis_department` varchar(255) DEFAULT NULL,
	`final_diagnosis` varchar(255) DEFAULT NULL,
	`bone_marrow_involvement` varchar(45) DEFAULT NULL,
	`risk_group` varchar(45) DEFAULT NULL,
	`former_category` varchar(255) DEFAULT NULL,
	`diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
	`version_id` int(11) NOT NULL AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `diagnosis_controls`
(`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`)
VALUES
('primary', 'oncology', 1, 'dx_primary,dx_bcch_oncology', 'dxd_bcch_oncology', 0, 'primary|oncology', 1);

INSERT INTO structures
(`alias`, `description`) VALUES
('dx_bcch_oncology', NULL);

INSERT INTO structure_value_domains
(`domain_name`, `source`)
VALUES
('bcch_departments', NULL);

INSERT INTO structure_permissible_values (`value`, `language_alias`)
VALUES
('surgical pathology', 'surgical pathology'),
('hematopathology', 'hematopathology');
-- radiology already exist

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_departments'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'surgical pathology'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_departments'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'hematopathology'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_departments'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'radiology'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_departments'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'surgical'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_departments'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'clinical'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_departments'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'surgical/clinical'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_departments'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'histology'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_departments'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'radio/lab'), 0, 1, 1);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_oncology', 'diagnosis_department', 'diagnosis department', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcch_departments'), 'help_diagnosis_department', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_oncology', 'final_diagnosis', 'final diagnosis', '', 'textarea', '', NULL, 'help_final_diagnosis', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_oncology', 'bone_marrow_involvement', 'bone marrow involvement', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown' AND `override` = 'open'), 'help_bone_marrow_involvement', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_oncology', 'risk_group', 'risk group', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_risk_groups'), 'help_risk_group', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_oncology', 'former_category', 'former category', '', 'input', 'size=30', NULL, 'help_former_category', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field` = 'diagnosis_department' AND `language_label`='diagnosis department' AND `type`='select'),
3, 1, 'pathology report logistics', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field` = 'final_diagnosis' AND `language_label`='final diagnosis' AND `type`='textarea'),
3, 2, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field` = 'bone_marrow_involvement' AND `language_label`='bone marrow involvement' AND `type`='select'),
3, 3, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field` = 'risk_group' AND `language_label`='risk group' AND `type`='select'),
3, 4, 'pathology report diagnosis', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field` = 'former_category' AND `language_label`='former category' AND `type`='input'),
3, 5, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

-- Make final diagnosis autocomplete

UPDATE structure_fields
SET `type` = 'autocomplete', `setting` = 'size=20,url=/CodingIcd/CodingIcdo3s/autocomplete/morpho'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'DiagnosisDetail' AND `tablename` = 'dxd_bcch_oncology' AND `field` = 'final_diagnosis';

REPLACE INTO i18n (`id`, `en`) VALUES
('oncology', 'Oncology'),
('diagnosis department', 'Diagnosis Department'),
('final diagnosis', 'Final Diagnosis'),
('bone marrow involvement', 'Bone Marrow Involvement'),
('risk group', 'Risk Group'),
('former category', 'Former Category'),
('surgical pathology', 'Surgical Pathology'),
('hematopathology', 'Hematopathology');

-- Disable survival time in months field
UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_primary')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months');

-- Disable ICD-10 field
UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='clinicalcollectionlinks')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code');

UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_primary')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code');

UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_secondary')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code');

UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_unknown_primary')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code');

UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='view_diagnosis')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code');

-- Disable topography field

UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='clinicalcollectionlinks')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography');

UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_primary')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography');

UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_secondary')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography');

UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='view_diagnosis')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography');

-- Disable Morphology field
UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_primary')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology');

UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit`=0, `flag_search`=0, `flag_summary`=0, `flag_index`=0, `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_secondary')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology');

-- Rearranging position

UPDATE `structure_formats`
SET `display_column`=1, `display_order`=10
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_oncology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field`='diagnosis_department');

UPDATE `structure_formats`
SET `display_column`=1, `display_order`=19
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_oncology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field`='final_diagnosis');

UPDATE `structure_formats`
SET `display_column`=1, `display_order`=17
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_oncology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field`='bone_marrow_involvement');

UPDATE `structure_formats`
SET `display_column`=1, `display_order`=15
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_oncology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field`='risk_group');

UPDATE `structure_formats`
SET `display_column`=2
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_oncology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_oncology' AND `field`='former_category');


UPDATE `structure_formats`
SET `display_column`=2
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='diagnosismasters')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes');

-- Add age at diagnosis to oncology form

INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `type`='integer_positive'),
1, 9, '', 0, 1, 'ccbr age at dx years', 1,
1, 'integer', 1, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `type`='integer'),
1, 9, '', 0, 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `type`='integer'),
1, 9, '', 0, 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `type`='integer'),
1, 9, '', 0, 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0);

UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit_readonly`=1, `flag_editgrid_readonly`=1, `flag_summary`=0, `flag_batchedit_readonly`=1
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_oncology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename` = 'dxd_bcch_oncology' AND `field` = 'former_category');

-- Copying values from leukemia, lymphoma to oncology
INSERT INTO `dxd_bcch_oncology` (`diagnosis_master_id`, `former_category`)
SELECT `diagnosis_master_id`, 'Leukemia' FROM `dxd_ccbr_leukemia`;

INSERT INTO `dxd_bcch_oncology` (`diagnosis_master_id`, `former_category`)
SELECT `diagnosis_master_id`, 'Lymphoma' FROM `dxd_ccbr_lymphoma`;

INSERT INTO `dxd_bcch_oncology` (`diagnosis_master_id`, `former_category`)
SELECT `diagnosis_master_id`, 'Solid Tumour' FROM `dxd_ccbr_solid_tumour`;

-- Move risk group data and department
UPDATE `dxd_bcch_oncology`, `diagnosis_masters`
SET `dxd_bcch_oncology`.`risk_group` = `diagnosis_masters`.`ccbr_risk_group`
WHERE `diagnosis_masters`.`id` = `dxd_bcch_oncology`.`diagnosis_master_id`;

-- copy department data for hematopathology
UPDATE `dxd_bcch_oncology`, `diagnosis_masters`
SET `dxd_bcch_oncology`.`diagnosis_department` = 'hematopathology'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_oncology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'hematopatholgy';

UPDATE `dxd_bcch_oncology`, `diagnosis_masters`
SET `dxd_bcch_oncology`.`diagnosis_department` = 'clinical'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_oncology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'clinial';

UPDATE `dxd_bcch_oncology`, `diagnosis_masters`
SET `dxd_bcch_oncology`.`diagnosis_department` = 'surgical'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_oncology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'surgical';

UPDATE `dxd_bcch_oncology`, `diagnosis_masters`
SET `dxd_bcch_oncology`.`diagnosis_department` = 'surgical/clinical'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_oncology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'surgical/clinical';

UPDATE `dxd_bcch_oncology`, `diagnosis_masters`
SET `dxd_bcch_oncology`.`diagnosis_department` = 'radiology'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_oncology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'radiology';

UPDATE `dxd_bcch_oncology`, `diagnosis_masters`
SET `dxd_bcch_oncology`.`diagnosis_department` = 'histology'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_oncology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'histology';

UPDATE `dxd_bcch_oncology`, `diagnosis_masters`
SET `dxd_bcch_oncology`.`diagnosis_department` = 'radio/lab'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_oncology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'radio/lab';

UPDATE `diagnosis_masters`
SET `diagnosis_control_id` = (SELECT `id` FROM `diagnosis_controls` WHERE `category` = 'primary' AND `controls_type` = 'oncology' AND `detail_tablename` = 'dxd_bcch_oncology')
WHERE `id` IN (SELECT `diagnosis_master_id` FROM `dxd_bcch_oncology`);

-- Move the morphology text to final diagnosis

UPDATE `dxd_bcch_oncology`, `diagnosis_masters`
SET `dxd_bcch_oncology`.`final_diagnosis` = `diagnosis_masters`.`morphology`
WHERE `dxd_bcch_oncology`.`diagnosis_master_id` = `diagnosis_masters`.`id`;

UPDATE `dxd_bcch_oncology`, `coding_icd_o_3_morphology`
SET `dxd_bcch_oncology`.`final_diagnosis` = `coding_icd_o_3_morphology`.`en_description`
WHERE `dxd_bcch_oncology`.`final_diagnosis` = `coding_icd_o_3_morphology`.`id`
AND `dxd_bcch_oncology`.`final_diagnosis` IN (SELECT `id` FROM `coding_icd_o_3_morphology`);

UPDATE `dxd_bcch_oncology`, `diagnosis_masters`
SET `dxd_bcch_oncology`.`final_diagnosis` = `diagnosis_masters`.`icd10_code`
WHERE `dxd_bcch_oncology`.`diagnosis_master_id` = `diagnosis_masters`.`id`;

UPDATE `dxd_bcch_oncology`, `coding_icd10_who`
SET `dxd_bcch_oncology`.`final_diagnosis` = `coding_icd10_who`.`en_title`
WHERE `dxd_bcch_oncology`.`final_diagnosis` = `coding_icd10_who`.`id`
AND `dxd_bcch_oncology`.`final_diagnosis` IN (SELECT `id` FROM `coding_icd10_who`);

INSERT INTO dxd_bcch_oncology_revs (`id`, `diagnosis_department`, `final_diagnosis`, `bone_marrow_involvement`, `risk_group`, `former_category`, `diagnosis_master_id`)
SELECT `id`, `diagnosis_department`, `final_diagnosis`, `bone_marrow_involvement`, `risk_group`, `former_category`, `diagnosis_master_id` FROM `dxd_bcch_oncology`;

UPDATE `dxd_bcch_oncology_revs`
SET `version_created` = NOW();

-- Add Other option for Final Diagnosis in Oncology

INSERT INTO coding_icd_o_3_morphology (`id`, `en_description`, `fr_description`, `translated`, `source`) VALUES
(00000, 'Other', 'Autre', '1', 'CFRI');

-- Create Hematology form

CREATE TABLE `dxd_bcch_hematology` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`diagnosis_department` varchar(255) DEFAULT NULL,
	`final_diagnosis` varchar(255) DEFAULT NULL,
	`blood_disorder` varchar(55) DEFAULT NULL,
	`blood_disorder_other` varchar(255) DEFAULT NULL,
	`bone_marrow_involvement` varchar(45) DEFAULT NULL,
	`risk_group` varchar(45) DEFAULT NULL,
	`former_category` varchar(255) DEFAULT NULL,
	`diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
	PRIMARY KEY(`id`),
	CONSTRAINT `FK_dxd_bcch_hematology_diagnosis_masters` FOREIGN KEY(`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dxd_bcch_hematology_revs` (
	`id` int(11) NOT NULL,
	`diagnosis_department` varchar(255) DEFAULT NULL,
	`final_diagnosis` varchar(255) DEFAULT NULL,
	`blood_disorder` varchar(55) DEFAULT NULL,
	`blood_disorder_other` varchar(255) DEFAULT NULL,
	`bone_marrow_involvement` varchar(45) DEFAULT NULL,
	`risk_group` varchar(45) DEFAULT NULL,
	`former_category` varchar(255) DEFAULT NULL,
	`diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
	`version_id` int(11) NOT NULL AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `diagnosis_controls`
(`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`)
VALUES
('primary', 'hematology', 1, 'dx_primary,dx_bcch_hematology', 'dxd_bcch_hematology', 0, 'primary|hematology', 1);

INSERT INTO structures (`alias`, `description`) VALUES
('dx_bcch_hematology', NULL);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_hematology', 'diagnosis_department', 'diagnosis department', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcch_departments'), 'help_diagnosis_department', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_hematology', 'final_diagnosis', 'final diagnosis', '', 'textarea', '', NULL, 'help_final_diagnosis', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_hematology', 'blood_disorder', 'blood disorder diagnosis', '', 'select', '', (SELECT `id` FROm structure_value_domains WHERe `domain_name` = 'ccbr_blood_disorders'), 'help_blood_disorder', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_hematology', 'blood_disorder_other', '', 'blood disorder diagnosis other', 'input', 'size=30', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_hematology', 'bone_marrow_involvement', 'bone marrow involvement', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown' AND `override` = 'open'), 'help_bone_marrow_involvement', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_hematology', 'risk_group', 'risk group', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_risk_groups'), 'help_risk_group', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_hematology', 'former_category', 'former category', '', 'input', 'size=30', NULL, 'help_former_category', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field` = 'diagnosis_department' AND `language_label`='diagnosis department' AND `type`='select'),
3, 1, 'pathology report logistics', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field` = 'final_diagnosis' AND `language_label`='final diagnosis' AND `type`='textarea'),
3, 2, '', 0, 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field` = 'blood_disorder' AND `type`='select'),
3, 3, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field` = 'blood_disorder_other' AND `type`='input'),
3, 4, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field` = 'bone_marrow_involvement' AND `language_label`='bone marrow involvement' AND `type`='select'),
3, 5, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field` = 'risk_group' AND `language_label`='risk group' AND `type`='select'),
3, 6, 'pathology report diagnosis', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field` = 'former_category' AND `language_label`='former category' AND `type`='input'),
3, 7, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

UPDATE `structure_formats`
SET `display_column`=1, `display_order`=10
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field`='diagnosis_department');

UPDATE `structure_formats`
SET `display_column`=1, `display_order`=21
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field`='final_diagnosis');

UPDATE `structure_formats`
SET `display_column`=1, `display_order`=17
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field`='bone_marrow_involvement');

UPDATE `structure_formats`
SET `display_column`=1, `display_order`=15
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field`='risk_group');

UPDATE `structure_formats`
SET `display_column`=1, `display_order`=19
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field`='blood_disorder');

UPDATE `structure_formats`
SET `display_column`=1, `display_order`=19
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field`='blood_disorder_other');

UPDATE `structure_formats`
SET `display_column`=2
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_hematology' AND `field`='former_category');

REPLACE INTO i18n (`id`, `en`) VALUES
('hematology', 'Hematology'),
('pathology report logistics', 'Pathology Report Logistics'),
('report format', 'Report Format'),
('pathology report diagnosis', 'Pathology Report Diagnosis'),
('blood disorder diagnosis', 'Blood Disorder Diagnosis'),
('blood disorder diagnosis other', 'If Other'),
('help_final_diagnosis', 'Copy the text from the final diagnosis field of the pathology report here');


INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `type`='integer_positive'),
1, 9, '', 0, 1, 'ccbr age at dx years', 1,
1, 'integer', 1, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `type`='integer'),
1, 9, '', 0, 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `type`='integer'),
1, 9, '', 0, 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `type`='integer'),
1, 9, '', 0, 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0);

UPDATE `structure_formats`
SET `flag_add`=0, `flag_edit_readonly`=1, `flag_editgrid_readonly`=1, `flag_summary`=0, `flag_batchedit_readonly`=1
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_hematology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename` = 'dxd_bcch_hematology' AND `field` = 'former_category');

-- Rename information source to pathology report format

UPDATE `structure_fields`
SET `language_label` = 'report format'
WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename` = 'diagnosis_masters' AND `field` = 'information_source' AND `language_label` = 'information_source' AND `type` = 'select';

-- migrate data from benign blood disorder to hematology

INSERT INTO `dxd_bcch_hematology` (`diagnosis_master_id`, `former_category`)
SELECT `diagnosis_master_id`, 'Benign Blood Disorder' FROM `dxd_ccbr_benign_blood`;

-- Move risk group data and department
UPDATE `dxd_bcch_hematology`, `diagnosis_masters`
SET `dxd_bcch_hematology`.`risk_group` = `diagnosis_masters`.`ccbr_risk_group`
WHERE `diagnosis_masters`.`id` = `dxd_bcch_hematology`.`diagnosis_master_id`;

-- copy department data for hematopathology
UPDATE `dxd_bcch_hematology`, `diagnosis_masters`
SET `dxd_bcch_hematology`.`diagnosis_department` = 'hematopathology'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_hematology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'hematopatholgy';

UPDATE `dxd_bcch_hematology`, `diagnosis_masters`
SET `dxd_bcch_hematology`.`diagnosis_department` = 'clinical'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_hematology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'clinial';

UPDATE `dxd_bcch_hematology`, `diagnosis_masters`
SET `dxd_bcch_hematology`.`diagnosis_department` = 'surgical'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_hematology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'surgical';

UPDATE `dxd_bcch_hematology`, `diagnosis_masters`
SET `dxd_bcch_hematology`.`diagnosis_department` = 'surgical/clinical'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_hematology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'surgical/clinical';

UPDATE `dxd_bcch_hematology`, `diagnosis_masters`
SET `dxd_bcch_hematology`.`diagnosis_department` = 'radiology'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_hematology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'radiology';

UPDATE `dxd_bcch_hematology`, `diagnosis_masters`
SET `dxd_bcch_hematology`.`diagnosis_department` = 'histology'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_hematology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'histology';

UPDATE `dxd_bcch_hematology`, `diagnosis_masters`
SET `dxd_bcch_hematology`.`diagnosis_department` = 'radio/lab'
WHERE `diagnosis_masters`.`id` = `dxd_bcch_hematology`.`diagnosis_master_id`
AND `diagnosis_masters`.`dx_method` = 'radio/lab';

UPDATE `diagnosis_masters`
SET `diagnosis_control_id` = (SELECT `id` FROM `diagnosis_controls` WHERE `category` = 'primary' AND `controls_type` = 'hematology' AND `detail_tablename` = 'dxd_bcch_hematology')
WHERE `id` IN (SELECT `diagnosis_master_id` FROM `dxd_bcch_hematology`);

-- Move the morphology text to final diagnosis

UPDATE `dxd_bcch_hematology`, `diagnosis_masters`
SET `dxd_bcch_hematology`.`final_diagnosis` = `diagnosis_masters`.morphology
WHERE `dxd_bcch_hematology`.`diagnosis_master_id` = `diagnosis_masters`.`id`;

UPDATE `dxd_bcch_hematology`, `coding_icd_o_3_morphology`
SET `dxd_bcch_hematology`.`final_diagnosis` = `coding_icd_o_3_morphology`.`en_description`
WHERE `dxd_bcch_hematology`.`final_diagnosis` = `coding_icd_o_3_morphology`.`id`
AND `dxd_bcch_hematology`.`final_diagnosis` IN (SELECT `id` FROM `coding_icd_o_3_morphology`);

UPDATE `dxd_bcch_hematology`, `diagnosis_masters`
SET `dxd_bcch_hematology`.`final_diagnosis` = `diagnosis_masters`.`icd10_code`
WHERE `dxd_bcch_hematology`.`diagnosis_master_id` = `diagnosis_masters`.`id`;

UPDATE `dxd_bcch_hematology`, `coding_icd10_who`
SET `dxd_bcch_hematology`.`final_diagnosis` = `coding_icd10_who`.`en_title`
WHERE `dxd_bcch_hematology`.`final_diagnosis` = `coding_icd10_who`.`id`
AND `dxd_bcch_hematology`.`final_diagnosis` IN (SELECT `id` FROM `coding_icd10_who`);

INSERT INTO dxd_bcch_hematology_revs (`id`, `diagnosis_department`, `final_diagnosis`, `bone_marrow_involvement`, `risk_group`, `former_category`, `diagnosis_master_id`)
SELECT `id`, `diagnosis_department`, `final_diagnosis`, `bone_marrow_involvement`, `risk_group`, `former_category`, `diagnosis_master_id` FROM `dxd_bcch_hematology`;

UPDATE `dxd_bcch_hematology_revs`
SET `version_created` = NOW();

-- Remove Diagnosis Method from view

UPDATE `structure_formats`
SET `flag_add` = 0, `flag_edit` = 0, `flag_summary` = 0, `flag_detail` = 0
WHERE `structure_field_id` = (SELECT `id` FROM `structure_fields` WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'DiagnosisMaster' AND `tablename` = 'diagnosis_masters' AND `field` = 'dx_method');

-- Copying old icd-o-3 code to new table
-- Here
ALTER TABLE `event_masters`
	ADD `code_value` VARCHAR(50) AFTER `diagnosis_master_id`;

INSERT INTO `event_masters` (`event_control_id`, `event_date`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`, `diagnosis_master_id`, `code_value`)
SELECT (SELECT `id` FROM `event_controls` WHERE `disease_site` = 'bcch' AND `event_group` = 'coding' AND `event_type` = 'diagnosis code' AND `detail_tablename` = 'ed_bcch_dx_codes'),
`diagnosis_masters`.`dx_date`, NOW(), 1, NOW(), 1, `diagnosis_masters`.`participant_id`, `diagnosis_masters`.`id`, `diagnosis_masters`.`morphology` FROM `diagnosis_masters`
WHERE `diagnosis_masters`.`morphology` != ' '
OR `diagnosis_masters`.`morphology` IS NOT NULL;

INSERT INTO `event_masters` (`event_control_id`, `event_date`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`, `diagnosis_master_id`, `code_value`)
SELECT (SELECT `id` FROM `event_controls` WHERE `disease_site` = 'bcch' AND `event_group` = 'coding' AND `event_type` = 'diagnosis code' AND `detail_tablename` = 'ed_bcch_dx_codes'),
`diagnosis_masters`.`dx_date`, NOW(), 1, NOW(), 1, `diagnosis_masters`.`participant_id`, `diagnosis_masters`.`id`, `diagnosis_masters`.`icd10_code` FROM `diagnosis_masters`
WHERE `diagnosis_masters`.`icd10_code` != ' '
OR `diagnosis_masters`.`icd10_code` IS NOT NULL;

INSERT INTO `event_masters_revs` (`id`, `event_control_id`, `event_date`, `modified_by`, `participant_id`, `diagnosis_master_id`, `version_created`)
SELECT `id`, `event_control_id`, `event_date`, `modified_by`, `participant_id`, `diagnosis_master_id`, NOW() FROM `event_masters`
WHERE `event_masters`.`event_control_id` = (SELECT `id` FROM `event_controls` WHERE `disease_site` = 'bcch' AND `event_group` = 'coding' AND `event_type` = 'diagnosis code' AND `detail_tablename` = 'ed_bcch_dx_codes');

INSERT INTO `ed_bcch_dx_codes` (`code_type`, `code_value`, `event_master_id`)
SELECT 'icd-o-3', `code_value`, `id` FROM `event_masters`
WHERE `event_masters`.`event_control_id` = (SELECT `id` FROM `event_controls` WHERE `disease_site` = 'bcch' AND `event_group` = 'coding' AND `event_type` = 'diagnosis code' AND `detail_tablename` = 'ed_bcch_dx_codes');

INSERT INTO `ed_bcch_dx_codes_revs` (`id`, `code_type`, `code_value`, `event_master_id`, `version_created`)
SELECT `id`, `code_type`, `code_value`, `event_master_id`, NOW() FROM `ed_bcch_dx_codes`;

ALTER TABLE `event_masters`
	DROP `code_value`;


-- Make final diagnosis mandatory

INSERT INTO structure_validations (`structure_field_id`, `rule`) VALUES
((SELECT `id` FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='DiagnosisDetail' AND tablename='dxd_bcch_oncology' AND field='final_diagnosis' AND type='autocomplete'), 'notEmpty'),
((SELECT `id` FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='DiagnosisDetail' AND tablename='dxd_bcch_hematology' AND field='blood_disorder' AND type='select'), 'notEmpty');

--  =============================================================================
--	Eventum ID: #XXXX
--  BB-128 Primary form: Pregnancy
--	=============================================================================

CREATE TABLE `dxd_bcwh_pregnancies` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`exp_delivery_date` date DEFAULT NULL,
    `exp_delivery_date_accuracy` char(1),
	`ivf_concenption` varchar(20) DEFAULT NULL,
	`gravida` int(11) DEFAULT NULL,
	`term_births` int(11) DEFAULT NULL,
	`preterm_births` int(11) DEFAULT NULL,
	`abortions` int(11) DEFAULT NULL,
	`living_children` int(11) DEFAULT NULL,
	`current_parity` varchar(45) DEFAULT NULL,
	`tobacco_usage` varchar(20) DEFAULT NULL,
	`alcohol_usage` varchar(20) DEFAULT NULL,
	`substance_usage` varchar(20) DEFAULT NULL,
	`rubella_status` varchar(20) DEFAULT NULL,
	`mmr_status` varchar(20) DEFAULT NULL,
	`rh_globulin_status` varchar(20) DEFAULT NULL,
	`hep_b_status` varchar(20) DEFAULT NULL,
	`other_comm_disease_status` varchar(20) DEFAULT NULL,
	`other_comm_disease_desc` varchar(100) DEFAULT NULL,
	`placenta_abruption` varchar(20) DEFAULT NULL,
	`anemia` varchar(20) DEFAULT NULL,
	`cervical_insuff` varchar(20) DEFAULT NULL,
	`intra_amniotic` varchar(20) DEFAULT NULL,
	`ectopic_preg` varchar(20) DEFAULT NULL,
	`erythro_fetalis` varchar(20) DEFAULT NULL,
	`diabetes` varchar(20) DEFAULT NULL,
    `gestational_diabetes` varchar(20) DEFAULT NULL,
	`hyper_gravidarum` varchar(20) DEFAULT NULL,
	`hypertension` varchar(20) DEFAULT NULL,
	`iugr` varchar(20) DEFAULT NULL,
	`oligohydramnios` varchar(20) DEFAULT NULL,
	`pemphigoid_gestationis` varchar(20) DEFAULT NULL,
	`placenta_previa` varchar(20) DEFAULT NULL,
	`polyhydramnios` varchar(20) DEFAULT NULL,
	`preeclampsis_eclampsia` varchar(20) DEFAULT NULL,
	`prom` varchar(20) DEFAULT NULL,
	`puppp`	varchar(20) DEFAULT NULL,
	`vasa_previa` varchar(20) DEFAULT NULL,
	`other_complications` varchar(100) DEFAULT NULL,
	`diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
	PRIMARY KEY(`id`),
	CONSTRAINT `FK_dxd_bcwh_pregnancies_diagnosis_masters` FOREIGN KEY(`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dxd_bcwh_pregnancies_revs` (
	`id` int(11) NOT NULL,
	`exp_delivery_date` date DEFAULT NULL,
    `exp_delivery_date_accuracy` char(1),
	`ivf_concenption` varchar(20) DEFAULT NULL,
	`gravida` int(11) DEFAULT NULL,
	`term_births` int(11) DEFAULT NULL,
	`preterm_births` int(11) DEFAULT NULL,
	`abortions` int(11) DEFAULT NULL,
	`living_children` int(11) DEFAULT NULL,
	`current_parity` varchar(45) DEFAULT NULL,
	`tobacco_usage` varchar(20) DEFAULT NULL,
	`alcohol_usage` varchar(20) DEFAULT NULL,
	`substance_usage` varchar(20) DEFAULT NULL,
	`rubella_status` varchar(20) DEFAULT NULL,
	`mmr_status` varchar(20) DEFAULT NULL,
	`rh_globulin_status` varchar(20) DEFAULT NULL,
	`hep_b_status` varchar(20) DEFAULT NULL,
	`other_comm_disease_status` varchar(20) DEFAULT NULL,
	`other_comm_disease_desc` varchar(100) DEFAULT NULL,
	`placenta_abruption` varchar(20) DEFAULT NULL,
	`anemia` varchar(20) DEFAULT NULL,
	`cervical_insuff` varchar(20) DEFAULT NULL,
	`intra_amniotic` varchar(20) DEFAULT NULL,
	`ectopic_preg` varchar(20) DEFAULT NULL,
	`erythro_fetalis` varchar(20) DEFAULT NULL,
	`diabetes` varchar(20) DEFAULT NULL,
    `gestational_diabetes` varchar(20) DEFAULT NULL,
	`hyper_gravidarum` varchar(20) DEFAULT NULL,
	`hypertension` varchar(20) DEFAULT NULL,
	`iugr` varchar(20) DEFAULT NULL,
	`oligohydramnios` varchar(20) DEFAULT NULL,
	`pemphigoid_gestationis` varchar(20) DEFAULT NULL,
	`placenta_previa` varchar(20) DEFAULT NULL,
	`polyhydramnios` varchar(20) DEFAULT NULL,
	`preeclampsis_eclampsia` varchar(20) DEFAULT NULL,
	`prom` varchar(20) DEFAULT NULL,
	`puppp`	varchar(20) DEFAULT NULL,
	`vasa_previa` varchar(20) DEFAULT NULL,
	`other_complications` varchar(100) DEFAULT NULL,
	`diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
	`version_id` int(11) NOT NULL AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `diagnosis_controls`
(`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`)
VALUES
('primary', 'pregnancy', 1, 'dx_primary,dx_bcwh_pregnancies', 'dxd_bcwh_pregnancies', 0, 'primary|pregnancy', 1);

INSERT INTO structures (`alias`, `description`) VALUES
('dx_bcwh_pregnancies', NULL);

INSERT INTO `structure_value_domains` (`domain_name`) VALUES
('bcwh_current_parity'), 
('preg_tobacco_usage'),
('preg_alcohol_usage'),
('preg_substance_uasge'),
('bcwh_rubella_status'),
('bcwh_mmr_status'),
('bcwh_rh_globulin_status'),
('bcwh_hep_b_status'),
('bcwh_other_comm_disease_status'),
('bcwh_diabetes_status'),
('bcwh_gestational_diabetes');

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('singleton', 'singleton'),
('twins', 'twins');
-- the phrase multiple already exists in the system

INSERT INTO `structure_value_domains_permissible_values`
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_current_parity'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'singleton' AND `language_alias` = 'Singleton'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_current_parity'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'twins' AND `language_alias` = 'Twins'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_current_parity'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'multiple' AND `language_alias` = 'Multiple'), 3, 1, 1);

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('non_smoker', 'non smoker'),
('quit_before_preg', 'quit before pregnancy'),
('quit_during_preg', 'quit during pregnancy'),
('current_smoker', 'current smoker');

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('non_drinker', 'non drinker');

INSERT INTO `structure_value_domains_permissible_values`
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_tobacco_usage'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'non_smoker'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_tobacco_usage'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'quit_before_preg'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_tobacco_usage'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'quit_during_preg'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_tobacco_usage'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'current_smoker'), 4, 1, 1);

INSERT INTO `structure_value_domains_permissible_values`
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_alcohol_usage'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'non_drinker'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_alcohol_usage'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'quit_before_preg'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_alcohol_usage'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'quit_during_preg'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_alcohol_usage'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'other' group by `value`), 4, 1, 1);

INSERT INTO `structure_value_domains_permissible_values`
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_substance_uasge'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'yes' AND `language_alias`='bcwh_yes'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_substance_uasge'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'no' AND `language_alias`='bcwh_no'), 2, 1, 1);

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('immune', 'immune'),
('non_immune', 'non immune');

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('given', 'given');

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('positive_carrier', 'positive/carrier');

INSERT INTO `structure_value_domains_permissible_values`
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_rubella_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'immune'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_rubella_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'non_immune'), 2, 1, 1);

INSERT INTO `structure_value_domains_permissible_values`
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_mmr_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'yes' AND `language_alias`='bcwh_yes'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_mmr_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'no' AND `language_alias`='bcwh_no'), 2, 1, 1);

INSERT INTO `structure_value_domains_permissible_values`
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_rh_globulin_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'given' AND `language_alias`='given'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_rh_globulin_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'n/a' AND `language_alias`='n/a'), 2, 1, 1);

INSERT INTO `structure_value_domains_permissible_values`
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_hep_b_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'negative' AND `language_alias`='negative'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_hep_b_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'positive_carrier' AND `language_alias`='positive/carrier'), 2, 1, 1);

INSERT INTO `structure_value_domains_permissible_values`
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_other_comm_disease_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'yes' AND `language_alias`='bcwh_yes'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_other_comm_disease_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'no' AND `language_alias`='bcwh_no'), 2, 1, 1);

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('type_1', 'type 1'),
('type_2', 'type 2'),
('gestational', 'gestational'),
('no_history_of_diabetes', 'no history of diabetes');

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('insulin', 'insulin'),
('diet_control', 'diet control');

INSERT INTO `structure_value_domains_permissible_values`
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_diabetes_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'type_1' AND `language_alias`='type 1'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_diabetes_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'type_2' AND `language_alias`='type 2'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_diabetes_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'gestational' AND `language_alias`='gestational'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_diabetes_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'no_history_of_diabetes' AND `language_alias`='no history of diabetes'), 4, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_diabetes_status'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'unknown' AND `language_alias`='ccbr_unknown'), 5, 1, 1);

INSERT INTO `structure_value_domains_permissible_values`
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_gestational_diabetes'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'insulin' AND `language_alias`='insulin'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_gestational_diabetes'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'diet_control' AND `language_alias`='diet control'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_gestational_diabetes'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'unknown' AND `language_alias`='ccbr_unknown'), 3, 1, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('singleton', 'Singleton', ''),
('twins', 'Twins', '');

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'exp_delivery_date', 'expected delivery date', '', 'date', '', '', NULL, 'help_exp_delivery_date', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'ivf_concenption', 'ivf conception', '', 'y_n_u', '', 'u', NULL, 'help_ivf_conception', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'gravida', 'gravida', '', 'integer_positive', '', '', NULL, 'help_gravida', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'term_births', 'term births', '', 'integer_positive', '', '', NULL, 'help_term_births', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'preterm_births', 'preterm births', '', 'integer_positive', '', '', NULL, 'help_preterm_births', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'abortions', 'abortions', '', 'integer_positive', '', '', NULL, 'help_abortions', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'living_children', 'living children', '', 'integer_positive', '', '', NULL, 'help_living_children', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'current_parity', 'current parity', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_current_parity'), 'help_current_parity', 'open', 'open', 'open', 0),

('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'tobacco_usage', 'tobacco usage', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_tobacco_usage'), 'help_tobacco_usage', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'alcohol_usage', 'alcohol usage', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_alcohol_usage'), 'help_alcohol_usage', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'substance_usage', 'substance usage', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'preg_substance_uasge'), 'help_substance_usage', 'open', 'open', 'open', 0),

('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'rubella_status', 'rubella status', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_rubella_status'), 'help_rubella_status', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'mmr_status', 'mmr status', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_mmr_status'), 'help_mmr_status', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'rh_globulin_status', 'rh immune globulin status', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_rh_globulin_status'), 'help_rh_globulin_status', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'hep_b_status', 'hepatitis b status', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_hep_b_status'), 'help_hep_b_status', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'other_comm_disease_status', 'exposure to other communicable disease', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_other_comm_disease_status'), 'help_other_comm_diseases', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'other_comm_disease_desc', '', 'exposure to other communicable disease other', 'input', '', '', NULL, 'help_other_comm_diseases_desc', 'open', 'open', 'open', 0),

('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'placenta_abruption', 'placenta abruption', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_placenta_abruption', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'anemia', 'anemia', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_anemia', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'cervical_insuff', 'cervical insufficiency', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_cervical_insuff', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'intra_amniotic', 'intra-amniotic infection', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_intra_amniotic', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'ectopic_preg', 'ectopic pregnancy', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_ectopic_preg', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'erythro_fetalis', 'erythroblastosis fetalis', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_erythro_fetalis', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'diabetes', 'diabetes', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_diabetes_status'), 'help_diabetes', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'gestational_diabetes', '', 'gestational diabetes', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcwh_gestational_diabetes'), 'help_gestational_diabetes', 'open', 'open', 'open', 0),

('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'hyper_gravidarum', 'hyperemesis gravidarum', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_hyper_gravidarum', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'hypertension', 'hypertension', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_hypertension', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'iugr', 'iugr', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_iugr', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'oligohydramnios', 'oligohydramnios', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_oligohydramnios', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'pemphigoid_gestationis', 'pemphigoid gestationis', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_pemphigoid_gestationis', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'placenta_previa', 'placenta previa', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_placenta_previa', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'polyhydramnios', 'polyhydramnios', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_polyhydramnios', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'preeclampsis_eclampsia', 'preeclampsia and eclampsia', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_preeclampsis_eclampsia', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'prom', 'prom', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_prom', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'puppp', 'pruritic urticarial papules and plaques of pregenancy', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_puppp', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'vasa_previa', 'vasa previa', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown'), 'help_vasa_previa', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'other_complications', 'other complications', '', 'input', '', '', NULL, 'help_other_complications', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'exp_delivery_date' AND `language_label`='expected delivery date' AND `type`='date'),
1, 15, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'ivf_concenption' AND `language_label`='ivf conception' AND `type`='y_n_u'),
1, 17, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'gravida' AND `language_label`='gravida' AND `type`='integer_positive'),
1, 19, 'gtpal - before delivery', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'term_births' AND `language_label`='term births' AND `type`='integer_positive'),
1, 21, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'preterm_births' AND `language_label`='preterm births' AND `type`='integer_positive'),
1, 21, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'abortions' AND `language_label`='abortions' AND `type`='integer_positive'),
1, 21, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'living_children' AND `language_label`='living children' AND `type`='integer_positive'),
1, 21, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),

((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'tobacco_usage' AND `language_label`='tobacco usage' AND `type`='select'),
1, 25, 'lifestyle', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'alcohol_usage' AND `language_label`='alcohol usage' AND `type`='select'),
1, 27, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'substance_usage' AND `language_label`='substance usage' AND `type`='select'),
1, 29, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),

((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'rubella_status' AND `type`='select'),
1, 33, 'communicable diseases', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'mmr_status' AND `type`='select'),
1, 35, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'rh_globulin_status' AND `type`='select'),
1, 37, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'hep_b_status' AND `type`='select'),
1, 39, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'other_comm_disease_status' AND `type`='select'),
1, 41, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'other_comm_disease_desc' AND `type`='input'),
1, 43, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),


((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'anemia' AND `language_label`='anemia' AND `type`='select'),
2, 27, 'pregnancy complications', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'cervical_insuff' AND `language_label`='cervical insufficiency' AND `type`='select'),
2, 29, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'intra_amniotic' AND `language_label`='intra-amniotic infection' AND `type`='select'),
2, 31, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'ectopic_preg' AND `language_label`='ectopic pregnancy' AND `type`='select'),
2, 33, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'erythro_fetalis' AND `language_label`='erythroblastosis fetalis' AND `type`='select'),
2, 35, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'diabetes' AND `language_label`='diabetes' AND `type`='select'),
2, 37, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'gestational_diabetes' AND `language_label`='' AND `type`='select'),
2, 37, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),

((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'hyper_gravidarum' AND `language_label`='hyperemesis gravidarum' AND `type`='select'),
2, 39, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'hypertension' AND `language_label`='hypertension' AND `type`='select'),
2, 41, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'iugr' AND `language_label`='iugr' AND `type`='select'),
2, 43, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'oligohydramnios' AND `language_label`='oligohydramnios' AND `type`='select'),
2, 45, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'pemphigoid_gestationis' AND `language_label`='pemphigoid gestationis' AND `type`='select'),
2, 47, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'placenta_abruption' AND `language_label`='placenta abruption' AND `type`='select'),
2, 48, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'placenta_previa' AND `language_label`='placenta previa' AND `type`='select'),
2, 49, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'polyhydramnios' AND `language_label`='polyhydramnios' AND `type`='select'),
2, 51, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'preeclampsis_eclampsia' AND `language_label`='preeclampsia and eclampsia' AND `type`='select'),
2, 53, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'prom' AND `language_label`='prom' AND `type`='select'),
2, 55, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'puppp' AND `language_label`='pruritic urticarial papules and plaques of pregenancy' AND `type`='select'),
2, 57, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'vasa_previa' AND `language_label`='vasa previa' AND `type`='select'),
2, 59, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'other_complications' AND `language_label`='other complications' AND `type`='input'),
2, 61, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

-- Add age at diagnosis

INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `type`='integer_positive'),
1, 9, '', 1, 'bcwh age at first encounter', 1, 'ccbr age at dx years', 1,
1, 'integer', 1, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `type`='integer'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `type`='integer'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `type`='integer'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('expected delivery date', 'Expected Delivery Date', ''),
('ivf conception', 'IVF Concenption', ''),
('first pregnancy', 'First Pregnancy', ''),
('type of pregnancy', 'Pregnancy Type', ''),
('pregnancy', 'Pregnancy', ''),
('blood loss', 'Estimated Blood Loss (mL)', ''),
('gtpal - before delivery', 'GTPAL (Before Delivery)', ''),
('gtpal - after delivery', 'GTPAL (After Delivery)', ''),
('gravida', 'G', ''),
('term births', 'T', ''),
('preterm births', 'P', ''),
('abortions', 'A', ''),
('living children', 'L', ''),
('pregnancy complications', 'Pregnancy Complications', ''),
('placenta abruption', 'Placenta Abruption', ''),
('anemia', 'Anemia', ''),
('cervical insufficiency', 'Cervical Insufficiency', ''),
('intra-amniotic infection', 'Intra-Amniotic Infection', ''),
('ectopic pregnancy', 'Ectopic Pregnancy', ''),
('erythroblastosis fetalis', 'Erythroblastosis Fetalis', ''),
('diabetes', 'Diabetes', ''),
('gestational diabetes', 'Gestational Diabetes', ''),
('insulin', 'Insulin', ''),
('diet control', 'Diet Control', ''),
('hyperemesis gravidarum', 'Hyperemesis Gravidarum', ''),
('hypertension', 'Hypertension', ''),
('iugr', 'Intrauterine Growth Restriction (IUGR)', ''),
('oligohydramnios', 'Oligohydramnios', ''),
('polyhydramnios', 'Polyhydramnios', ''),
('pemphigoid gestationis', 'Pemphigoid Gestationis', ''),
('placenta previa', 'Placenta Previa', ''),
('preeclampsia and eclampsia', 'Preeclampsia and Eclampsia', ''),
('prom','Premature Rupture of Membranes (PROM)', ''),
('pruritic urticarial papules and plaques of pregenancy', 'Pruritic Urticarial Papules and Plaques of Pregenancy (PUPPP)', ''),
('vasa previa', 'Vasa Previa', ''),
('other complications', 'Other Complications', ''),
('date of first encounter at BCWH', 'Date of First Visist at BCWH', ''),
('bcwh age at first encounter', 'Age of Participant at First Visit', '');

-- move notes to the botton of column one

UPDATE `structure_formats`
SET `display_column` = 1, `language_heading` = 'notes'
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'diagnosismasters')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'DiagnosisMaster' AND `tablename` = 'diagnosis_masters' AND `field` = 'notes');


--  =============================================================================
--	Eventum ID: #XXXX
--  BB-132 Secondary diagnosis form: Delivery
--	=============================================================================

CREATE TABLE `dxd_bcwh_deliveries` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`delivery_person` varchar(20) DEFAULT NULL,
	`delivery_location` varchar(20) DEFAULT NULL,
	`delivery_svd` varchar(20) DEFAULT NULL, 
	`delivery_vbac` varchar(20) DEFAULT NULL,
	`delivery_vacuum` varchar(20) DEFAULT NULL,
	`delivery_forceps` varchar(20) DEFAULT NULL,	
	`delivery_cesarean` varchar(20) DEFAULT NULL,
	`c_section_type` varchar(50) DEFAULT NULL,
	`delivery_type_reason` varchar(255) DEFAULT NULL,	
	`induction_arm` varchar(20) DEFAULT NULL,
	`induction_foley` varchar(20) DEFAULT NULL,
	`induction_oxytocin` varchar(20) DEFAULT NULL,
	`induction_prostaglandin` varchar(20) DEFAULT NULL,
	`anaesthesia_usage` varchar(20) DEFAULT NULL,
	`anaesthesia_agent` varchar(25) DEFAULT NULL,
	`anaesthesia_type` varchar(20) DEFAULT NULL,
	`antibiotics_usage` varchar(20) DEFAULT NULL,
	`antibiotics_type` varchar(20) DEFAULT NULL,
	`blood_loss_volume` varchar(20) DEFAULT NULL,
    `blood_loss_volume_exact` varchar(40) DEFAULT NULL,
	`blood_loss_intervention` varchar(20) DEFAULT NULL,
	`blood_loss_procedure` varchar(20) DEFAULT NULL,
	`diagnosis_master_id` int(11),
	PRIMARY KEY(`id`),
	CONSTRAINT `FK_dxd_bcwh_deliveries_diagnosis_masters` FOREIGN KEY(`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `dxd_bcwh_deliveries_revs` (
	`id` int(11) NOT NULL,
	`delivery_person` varchar(20) DEFAULT NULL,
	`delivery_location` varchar(20) DEFAULT NULL,
	`delivery_svd` varchar(20) DEFAULT NULL,
	`delivery_vbac` varchar(20) DEFAULT NULL,
	`delivery_forceps` varchar(20) DEFAULT NULL,
	`delivery_vacuum` varchar(20) DEFAULT NULL,
	`delivery_cesarean` varchar(20) DEFAULT NULL,
	`c_section_type` varchar(50) DEFAULT NULL,
	`delivery_type_reason` varchar(255) DEFAULT NULL,
	`induction_arm` varchar(20) DEFAULT NULL,
	`induction_foley` varchar(20) DEFAULT NULL,
	`induction_oxytocin` varchar(20) DEFAULT NULL,
	`induction_prostaglandin` varchar(20) DEFAULT NULL,
	`anaesthesia_usage` varchar(20) DEFAULT NULL,
	`anaesthesia_agent` varchar(25) DEFAULT NULL,
	`anaesthesia_type` varchar(20) DEFAULT NULL,
	`antibiotics_usage` varchar(20) DEFAULT NULL,
	`antibiotics_type` varchar(20) DEFAULT NULL,
	`blood_loss_volume` varchar(20) DEFAULT NULL,
    `blood_loss_volume_exact` varchar(40) DEFAULT NULL,
	`blood_loss_intervention` varchar(20) DEFAULT NULL,
	`blood_loss_procedure` varchar(20) DEFAULT NULL,
	`diagnosis_master_id` int(11),
	`version_id` int(11) AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `diagnosis_controls`
(`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`)
VALUES
('secondary', 'delivery', 1, 'dx_bcwh_deliveries', 'dxd_bcwh_deliveries', 0, 'secondary|delivery', 1);

INSERT INTO `structures` (`alias`, `description`) VALUES
('dx_bcwh_deliveries', NULL);

INSERT INTO `structure_value_domains` (`domain_name`) VALUES
('c_section_situation'),
('delivery_person'),
('delivery_location'),
('anaesthesia_agent'),
('anaesthesia_type'),
('antibiotics_type'),
('blood_loss_volume'),
('blood_loss_intervention'),
('blood_loss_procedure');

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('elective', 'elective'),
('urgent', 'urgent'),
('emergent', 'emergent'),
('physician', 'physician'),
('resident', 'resident'),
('nurse', 'nurse'),
('midwife', 'midwife'),
('hospital', 'hospital'),
('entonox', 'Entonox'),
('opioids', 'Opioids'),
('pudendal', 'Pundendal'),
('epidural', 'Epidural'),
('spinal', 'Spinal'),
('combined', 'Combined'),
('general', 'General'),
('intrapartum', 'Intrapartum'),
('intraoperative', 'Intraoperative'),
('< 500 mL', '< 500 mL'),
('500-1000 mL', '500-1000 mL'),
('> 1000 mL', '> 1000 mL'),
('medication', 'medication'),
('blood products', 'blood products');

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'c_section_situation'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'elective'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'c_section_situation'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'urgent'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'c_section_situation'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'emergent'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'delivery_person'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'physician' group by value), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'delivery_person'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'resident' group by value), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'delivery_person'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'nurse' group by value), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'delivery_person'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'midwife'), 4, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'delivery_person'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'unknown' group by value), 5, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'delivery_location'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'hospital'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'delivery_location'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'home'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'delivery_location'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'other' group by value), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'anaesthesia_agent'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'entonox'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'anaesthesia_agent'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'opioids'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'anaesthesia_agent'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'pudendal'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'anaesthesia_agent'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'other' group by value), 4, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'anaesthesia_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'epidural'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'anaesthesia_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'spinal'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'anaesthesia_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'combined'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'anaesthesia_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'general' group by value), 4, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'antibiotics_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'intrapartum'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'antibiotics_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'intraoperative'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'antibiotics_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'other' group by value), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_volume'), (SELECT `id` FROM structure_permissible_values WHERE `value` = '< 500 mL'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_volume'), (SELECT `id` FROM structure_permissible_values WHERE `value` = '500-1000 mL'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_volume'), (SELECT `id` FROM structure_permissible_values WHERE `value` = '> 1000 mL'), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_intervention'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'yes' group by value), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_intervention'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'no' group by value), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_intervention'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'unknown' group by value), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_procedure'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'medication'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_procedure'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'blood products'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_procedure'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'other' group by value), 3, 1, 1);


INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'delivery_person', 'delivery person', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'delivery_person'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'delivery_location', 'delivery location', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'delivery_location'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'delivery_svd', 'vaginal delivery', '', 'yes_no', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'delivery_vbac', 'induced labor', '', 'yes_no', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'delivery_forceps', 'forceps delivery', '', 'yes_no', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'delivery_vacuum', 'vacuum extraction', '', 'yes_no', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'delivery_cesarean', 'cesarean section', '', 'yes_no', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'c_section_type', 'c section situation', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'c_section_situation'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'delivery_type_reason', 'delivery type reason', '', 'textarea', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'induction_arm', 'arm induction', '', 'y_n_u', '', 'u', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'induction_foley', 'foley induction', '', 'y_n_u', '', 'u', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'induction_oxytocin', 'oxytocin induction', '', 'y_n_u', '', 'u', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'induction_prostaglandin', 'prostaglandin induction', '', 'y_n_u', '', 'u', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'anaesthesia_usage', 'anaesthesia usage', '', 'y_n_u', '', 'u', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'anaesthesia_agent', 'anaesthesia agent', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'anaesthesia_agent'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'anaesthesia_type', 'anaesthesia type', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'anaesthesia_type'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'antibiotics_usage', 'antibiotics usage', '', 'y_n_u', '', 'u', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'antibiotics_type', 'antibiotics type', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'antibiotics_type'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'blood_loss_volume', 'blood loss volume', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_volume'), 'help_blood_loss', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'blood_loss_volume_exact', '', 'blood loss volume exact', 'input', '', '', NULL, 'help_blood_loss', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'blood_loss_intervention', 'blood loss intervention', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_intervention'), 'help_blood_loss_intervention', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'blood_loss_procedure', 'blood loss procedure', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_loss_procedure'), 'help_blood_loss_procedure', 'open', 'open', 'open', 0);


INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='delivery_person' AND `type`='select'),
1, 10, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='delivery_location' AND `type`='select'),
1, 12, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='delivery_svd' AND `type`='yes_no'),
1, 25, 'delivery details', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='delivery_vbac' AND `type`='yes_no'),
1, 27, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='delivery_forceps' AND `type`='yes_no'),
1, 29, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='delivery_vacuum' AND `type`='yes_no'),
1, 31, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='delivery_cesarean' AND `type`='yes_no'),
1, 33, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='c_section_type' AND `type`='select'),
1, 35, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='delivery_type_reason' AND `type`='textarea'),
1, 37, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='induction_arm' AND `type`='y_n_u'),
2, 15, 'delivery induction details', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='induction_foley' AND `type`='y_n_u'),
2, 17, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='induction_oxytocin' AND `type`='y_n_u'),
2, 19, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='induction_prostaglandin' AND `type`='y_n_u'),
2, 21, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='anaesthesia_usage' AND `type`='y_n_u'),
2, 25, 'anaesthesia', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='anaesthesia_agent' AND `type`='select'),
2, 27, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='anaesthesia_type' AND `type`='select'),
2, 29, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='antibiotics_usage' AND `type`='y_n_u'),
2, 33, 'antibiotics', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='antibiotics_type' AND `type`='select'),
2, 35, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='blood_loss_volume' AND `type`='select'),
2, 41, 'estimated blood loss', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='blood_loss_volume_exact' AND `type`='input'),
2, 41, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='blood_loss_intervention' AND `type`='select'),
2, 43, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field`='blood_loss_procedure' AND `type`='select'),
2, 345, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

-- Add age at diagnosis to delivery

INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `type`='integer_positive'),
1, 9, '', 1, 'bcwh age at delivery', 1, 'ccbr age at dx years', 1,
1, 'integer', 1, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `type`='integer'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `type`='integer'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `type`='integer'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('delivery information', 'Delivery Information', ''),
('vaginal delivery', 'Vaginal Delivery', ''),
('induced labor', 'Induced Labor', ''),
('episiotomy', 'Episiotomy', ''),
('amniotomy', 'Amniotomy', ''),
('forceps delivery', 'Forceps Delivery', ''),
('vacuum extraction', 'Vacuum Extraction', ''),
('cesarean section', 'Cesarean Section', ''),
('c section situation', 'C-section Situation', ''),
('delivery type reason', 'Reason for Delivery Type', ''),
('elective', 'Elective', ''),
('emergency', 'Emergency', ''),
('urgent', 'Urgent', ''),
('emergent', 'Emergent', ''),
('delivery methods', 'Delivery Methods', ''),
('gestational age', 'Gestational Age', ''),
('delivery', 'Delivery', ''),
('delivery date', 'Delivery Date', ''),
('bcwh age at delivery', 'Age of Mother at Delivery', ''),
('delivery person', 'Delivered by:', ''),
('physician', 'Physician', ''),
('nurse', 'Nurse', ''),
('resident', 'Resident', ''),
('midwife', 'Midwife', ''),
('delivery location', 'Place of Birth:', ''),
('hospital', 'Hospital', ''),
('estimated blood loss', 'Estimated Blood Loss', ''),
('blood loss volume', 'Volume', ''),
('blood loss volume exact', 'Exact Volume (mL):', ''),
('< 500 mL', '< 500 mL', ''),
('500-1000 mL', '500-1000 mL', ''),
('> 1000 mL', '> 1000 mL', ''),
('blood loss intervention', 'Intervention Required?', ''),
('blood loss procedure', 'Intervention Procedure', ''),
('medication', 'Medication', ''),
('blood products', 'Blood Products', ''),
('type 1', 'Type 1', ''),
('type 2', 'Type 2', ''),
('gestational', 'Gestataional', ''),
('no history of diabetes', 'No History of Diabetes', '');


--  =============================================================================
--	Eventum ID: #XXXX
--  BB-133 Secondary Diagnosis Form: Abortion
--	=============================================================================

-- induced reason

CREATE TABLE `dxd_abortions` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`abortion_type` varchar(20) DEFAULT NULL,
	`induced_reason` varchar(20) DEFAULT NULL,
	`diagnosis_master_id` int(11),
	PRIMARY KEY(`id`),
	CONSTRAINT `FK_dxd_abortions_diagnosis_masters` FOREIGN KEY(`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dxd_abortions_revs` (
	`id` int(11) NOT NULL,
	`abortion_type` varchar(20) DEFAULT NULL,
	`induced_reason` varchar(40) DEFAULT NULL,
	`diagnosis_master_id` int(11),
	`version_id` int(11) AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `diagnosis_controls`
(`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`)
VALUES
('secondary', 'abortion', 1, 'dx_abortions', 'dxd_abortions', 0, 'secondary|abortions', 1);

INSERT INTO `structures` (`alias`, `description`) VALUES
('dx_abortions', NULL);

INSERT INTO `structure_value_domains` (`domain_name`, `override`) VALUES
('abortion_type', 'open'),
('induced_abortion_reason', 'open');

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('induced', 'Induced'),
('spontaneous', 'spontaneous'),
('therapeutic', 'therapeutic');

-- error in subquery return more than one row
INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'abortion_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'induced'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'abortion_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'spontaneous'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'abortion_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'unknown' group by `value`), 3, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'induced_abortion_reason'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'elective'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'induced_abortion_reason'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'therapeutic'), 2, 1, 1);

INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_abortions', 'abortion_type', 'abortion type', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'abortion_type'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_abortions', 'induced_reason', 'induced reason', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'induced_abortion_reason'), '', 'open', 'open', 'open', 0);

INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_abortions'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_abortions' AND `field`='abortion_type' AND `type`='select'),
1, 10, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_abortions'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_abortions' AND `field`='induced_reason' AND `type`='select'),
1, 11, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_abortions'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='notes' AND `type`='textarea'),
1, 99, 'notes', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

-- Age at abortion procedure

INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_abortions'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `type`='integer_positive'),
1, 9, '', 1, 'bcwh age at abortion procedure', 1, 'ccbr age at dx years', 1,
1, 'integer', 1, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_abortions'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `type`='integer'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_abortions'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `type`='integer'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_abortions'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `type`='integer'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0);


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('induced abortion', 'Induced Abortion', ''),
('induced reason', 'Elective or Therapeutic?', ''),
('spontaneous abortion', 'Spontaneous Abortion', ''),
('therapeutic', 'Therapeutic', ''),
('date of the procedure', 'Abortion Procedure Date', ''),
('bcwh age at abortion procedure', 'Age of Participant at the Procedure', ''),
('abortion type', 'Induced or Spontaneous?', ''),
('abortion', 'Abortion', ''),
('Induced', 'Induced', ''),
('spontaneous', 'Spontaneous', '');

--  =============================================================================
--	Eventum ID: #XXXX
--  BB-127 Live Births
--	=============================================================================

-- Put the MRN field in the EventMaster Table
ALTER TABLE event_masters 
	ADD COLUMN `mrn` varchar(20) DEFAULT NULL AFTER reference_number;
	
ALTER TABLE event_masters_revs 
	ADD COLUMN `mrn` varchar(20) DEFAULT NULL AFTER reference_number;
	
INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'EventMaster', 'event_masters', 'mrn', 'mrn', '', 'input', '', NULL, '', 'open', 'open', 'open', 0);
	
INSERT INTO structure_validations (structure_field_id, rule, on_action, language_message)
VALUES
((SELECT id FROM structure_fields WHERE plugin = 'ClinicalAnnotation' AND model = 'EventMaster' AND tablename = 'event_masters' AND field = 'mrn' AND type = 'input'), 'isUnique', '', 'mrn must be unique');

CREATE TABLE `ed_bcwh_live_births` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`time_of_birth` time DEFAULT NULL,
	`gestational_age_week` int(11) DEFAULT NULL,
    `gestational_age_day` int(11) DEFAULT NULL,
	`sex` varchar(20) DEFAULT NULL,
	`biobank_id` varchar(40) DEFAULT NULL,
	`apgar_score_1min` int(11) DEFAULT NULL,
	`apgar_score_5min` int(11) DEFAULT NULL,
	`apgar_score_10min` int(11) DEFAULT NULL,
	`birth_weight` varchar(40) DEFAULT NULL,
	`cord_blood_ph` varchar(40) DEFAULT NULL,
	`genetic_syndromes` varchar(20) DEFAULT NULL,
	`congenital_birth_defects` varchar(20) DEFAULT NULL,
	`neonatal_infection` varchar(20) DEFAULT NULL,
	`newborn_screening_results` varchar(20) DEFAULT NULL,
	`group_b_strep_expo` varchar(20) DEFAULT NULL,
	`hep_b_prophy` varchar(20) DEFAULT NULL,
	`tobacco_expo` varchar(20) DEFAULT NULL,
	`alcohol_expo` varchar(20) DEFAULT NULL,
	`substances_expo` varchar(20) DEFAULT NULL,		
	`event_master_id` int(11) DEFAULT NULL,
	PRIMARY KEY(`id`),
	CONSTRAINT `FK_ed_bcwh_live_births_event_masters` FOREIGN KEY(`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_bcwh_live_births_revs` (
	`id` int(11) NOT NULL,
	`time_of_birth` time DEFAULT NULL,
	`gestational_age_week` int(11) DEFAULT NULL,
    `gestational_age_day` int(11) DEFAULT NULL,
	`sex` varchar(20) DEFAULT NULL,
	`biobank_id` varchar(40) DEFAULT NULL,
	`apgar_score_1min` int(11) DEFAULT NULL,
	`apgar_score_5min` int(11) DEFAULT NULL,
	`apgar_score_10min` int(11) DEFAULT NULL,
	`birth_weight` varchar(40) DEFAULT NULL,
	`cord_blood_ph` varchar(40) DEFAULT NULL,
	`genetic_syndromes` varchar(20) DEFAULT NULL,
	`congenital_birth_defects` varchar(20) DEFAULT NULL,
	`neonatal_infection` varchar(20) DEFAULT NULL,
	`newborn_screening_results` varchar(20) DEFAULT NULL,
	`group_b_strep_expo` varchar(20) DEFAULT NULL,
	`hep_b_prophy` varchar(20) DEFAULT NULL,
	`tobacco_expo` varchar(20) DEFAULT NULL,
	`alcohol_expo` varchar(20) DEFAULT NULL,
	`substances_expo` varchar(20) DEFAULT NULL,
	`event_master_id` int(11) DEFAULT NULL,
	`version_id` int(11) AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `event_controls`
(`disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`)
VALUES
('bcwh', 'neonatal', 'live births', 1, 'ed_bcwh_live_births', 'ed_bcwh_live_births', 0, 'clinical|bcwh|livebirths', 0, 0, 1);

INSERT INTO `structures` (`alias`, `description`) VALUES
('ed_bcwh_live_births', NULL);

INSERT INTO `structure_value_domains` (`domain_name`, `override`) VALUES
('newborn_screening_results', 'open');
-- subquery return more than one row
INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'newborn_screening_results'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'normal' group by `value`), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'newborn_screening_results'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'abnormal'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'newborn_screening_results'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'unknown' group by `value`), 3, 1, 1);

INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'time_of_birth', 'time of birth', '', 'time', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'gestational_age_week', 'gestational age week', '', 'integer_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'gestational_age_day', '', 'gestational age day', 'integer_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'sex', 'sex', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'sex'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'mrn', 'mrn', '', 'input', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'biobank_id', 'biobank identifier', '', 'input', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'apgar_score_1min', '1 min apgar score', '', 'integer_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'apgar_score_5min', '5 min apgar score', '', 'integer_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'apgar_score_10min', '10 min apgar score', '', 'integer_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'birth_weight', 'birth weight', '', 'float_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'cord_blood_ph', 'cord blood ph', '', 'float_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'genetic_syndromes', 'genetic syndromes', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown' AND `override` = 'open'), 'help_genetic_syndromes', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'congenital_birth_defects', 'congenital birth defects', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown' AND `override` = 'open'), 'help_congenital_birth_defects', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'neonatal_infection', 'neonatal infection', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'ccbr_yesnounknown' AND `override` = 'open'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'newborn_screening_results', 'newborn screening results', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'newborn_screening_results' AND `override` = 'open'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'group_b_strep_expo', 'group b strep exposure', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'yesno' AND `override` = 'locked'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'hep_b_prophy', 'hep b prophylaxis', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'yesno' AND `override` = 'locked'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'tobacco_expo', 'tobacoo in utero exposure', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'yesno' AND `override` = 'locked'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'alcohol_expo', 'alcohol in utero exposure', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'yesno' AND `override` = 'locked'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_live_births', 'substances_expo', 'substances in utero exposure', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'yesno' AND `override` = 'locked'), '', 'open', 'open', 'open', 0);

INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='time_of_birth' AND `type`='time'),
1, 6, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='gestational_age_week' AND `type`='integer_positive'),
1, 8, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='gestational_age_day' AND `type`='integer_positive'),
1, 8, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='sex' AND `type`='select'),
1, 11, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='mrn' AND `type`='input'),
1, 13, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='biobank_id' AND `type`='input'),
1, 15, '', 0, 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='birth_weight' AND `type`='float_positive'),
1, 19, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='cord_blood_ph' AND `type`='float_positive'),
1, 21, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='apgar_score_1min' AND `type`='integer_positive'),
1, 23, 'apgar score', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='apgar_score_5min' AND `type`='integer_positive'),
1, 25, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='apgar_score_10min' AND `type`='integer_positive'),
1, 27, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='notes' AND `type`='textarea'),
1, 99, 'notes', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='genetic_syndromes' AND `type`='select'),
2, 21, 'newborn abnormalities', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='congenital_birth_defects' AND `type`='select'),
2, 23, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='neonatal_infection' AND `type`='select'),
2, 25, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='newborn_screening_results' AND `type`='select'),
2, 27, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),

((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='group_b_strep_expo' AND `type`='select'),
2, 31, 'communicable diseases', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='hep_b_prophy' AND `type`='select'),
2, 33, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),

((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='tobacco_expo' AND `type`='select'),
2, 37, 'in utero exposure', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='alcohol_expo' AND `type`='select'),
2, 39, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_live_births' AND `field`='substances_expo' AND `type`='select'),
2, 41, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0);

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`)
VALUES
('clin_CAN_36', 'clin_CAN_4', 0, 9, 'neonatal', 'neonatal', '/ClinicalAnnotation/EventMasters/listall/Neonatal/%%Participant.id%%', 'ClinicalAnnotation.EventMaster::summary', 1, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('neonatal information', 'Neonatal Information', ''),
('bcwh', 'BCWH', ''),
('newborn information', 'Newborn Information', ''),
('mrn', 'MRN', ''),
('MRN', 'MRN', ''),
('biobank identifier', 'BioBank Identifier', ''),
('delivery physician', 'Delivery Physician', ''),
('birth weight', 'Birth Weight (g)', ''),
('physical abnormalities', 'Physical Abnormalities', ''),
('cord blood ph', 'Cord Blood pH', ''),
('apgar score', 'Apgar Score', ''),
('1 min apgar score', 'Apgar Score at 1 min', ''),
('5 min apgar score', 'Apgar Score at 5 min', ''),
('10 min apgar score', 'Apgar Score at 10 min', ''),
('newborn abnormalities', 'Newborn Abnormalities', ''),
('genetic syndromes', 'Genetic Syndromes', ''),
('congenital birth defects', 'Congenital Birth Defects', ''),
('neonatal infection', 'Neonatal Infection', ''),
('newborn screening results', 'Newborn Screening Results', ''),
('mrn must be unique', 'MRN must be unique in the database', ''),
('gestational age week', 'Gestational Age (Weeks)', ''),
('gestational age day', 'Days:', '');

--  =============================================================================
--	Eventum ID: #XXXX
--  BB-134 Stillbirths Event Form
--	=============================================================================

CREATE TABLE `ed_bcwh_stillbirths` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`time_of_birth` time DEFAULT NULL,
	`gestational_age_week` int(11) DEFAULT NULL,
    `gestational_age_day` int(11) DEFAULT NULL,
	`sex` varchar(20) DEFAULT NULL,
	`biobank_id` varchar(40) DEFAULT NULL,
	`apgar_score_1min` int(11) DEFAULT NULL,
	`apgar_score_5min` int(11) DEFAULT NULL,
	`apgar_score_10min` int(11) DEFAULT NULL,
	`birth_weight` varchar(40) DEFAULT NULL,
	`cord_blood_ph` varchar(40) DEFAULT NULL,
	`type` varchar(20) DEFAULT NULL,
	`event_master_id` int(11) DEFAULT NULL,
	PRIMARY KEY(`id`),
	CONSTRAINT `FK_ed_bcwh_stillbirths_event_masters` FOREIGN KEY(`event_master_id`) REFERENCES `event_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ed_bcwh_stillbirths_revs` (
	`id` int(11) NOT NULL,
	`time_of_birth` time DEFAULT NULL,
	`gestational_age_week` int(11) DEFAULT NULL,
    `gestational_age_day` int(11) DEFAULT NULL,
	`sex` varchar(20) DEFAULT NULL,
	`biobank_id` varchar(40) DEFAULT NULL,
	`apgar_score_1min` int(11) DEFAULT NULL,
	`apgar_score_5min` int(11) DEFAULT NULL,
	`apgar_score_10min` int(11) DEFAULT NULL,
	`birth_weight` varchar(40) DEFAULT NULL,
	`cord_blood_ph` varchar(40) DEFAULT NULL,
	`type` varchar(20) DEFAULT NULL,
	`event_master_id` int(11) DEFAULT NULL,
	`version_id` int(11) AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `event_controls`
(`disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`)
VALUES
('bcwh', 'neonatal', 'stillbirths', 1, 'ed_bcwh_stillbirths', 'ed_bcwh_stillbirths', 0, 'clinical|bcwh|stillbirths', 0, 0, 1);

INSERT INTO `structures` (`alias`, `description`) VALUES
('ed_bcwh_stillbirths', NULL);

INSERT INTO `structure_value_domains` (`domain_name`, `override`) VALUES
('stillbirth_types', 'open');

INSERT INTO `structure_permissible_values` (`value`, `language_alias`) VALUES
('antepartum', 'antepartum');

INSERT INTO `structure_value_domains_permissible_values` (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`) VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'stillbirth_types'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'antepartum' group by `value`), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'stillbirth_types'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'intrapartum'), 2, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'stillbirth_types'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'unknown' group by `value`), 3, 1, 1);


INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'time_of_birth', 'time of birth', '', 'time', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'gestational_age_week', 'gestational age week', '', 'integer_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'gestational_age_day', '', 'gestational age day', 'integer_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'sex', 'sex', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'sex'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'mrn', 'mrn', '', 'input', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'biobank_id', 'biobank identifier', '', 'input', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'apgar_score_1min', '1 min apgar score', '', 'integer_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'apgar_score_5min', '5 min apgar score', '', 'integer_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'apgar_score_10min', '10 min apgar score', '', 'integer_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'birth_weight', 'birth weight', '', 'float_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'cord_blood_ph', 'cord blood ph', '', 'float_positive', '', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'EventDetail', 'ed_bcwh_stillbirths', 'type', 'fetal death type', '', 'select', '', 'unknown', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'stillbirth_types'), 'help_fetal_death_type', 'open', 'open', 'open', 0);


INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_stillbirths' AND `field`='time_of_birth' AND `type`='time'),
1, 6, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_stillbirths' AND `field`='gestational_age_week' AND `type`='integer_positive'),
1, 8, 'newborn information', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_stillbirths' AND `field`='gestational_age_day' AND `type`='integer_positive'),
1, 8, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_stillbirths' AND `field`='sex' AND `type`='select'),
1, 11, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='mrn' AND `type`='input'),
1, 13, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_stillbirths' AND `field`='biobank_id' AND `type`='input'),
1, 15, '', 0, 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_stillbirths' AND `field`='birth_weight' AND `type`='float_positive'),
1, 19, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_stillbirths' AND `field`='cord_blood_ph' AND `type`='float_positive'),
1, 21, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_stillbirths' AND `field`='apgar_score_1min' AND `type`='integer_positive'),
1, 23, 'apgar score', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_stillbirths' AND `field`='apgar_score_5min' AND `type`='integer_positive'),
1, 25, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_stillbirths' AND `field`='apgar_score_10min' AND `type`='integer_positive'),
1, 27, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='notes' AND `type`='textarea'),
1, 99, 'notes', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventDetail' AND `tablename`='ed_bcwh_stillbirths' AND `field`='type' AND `type`='select'),
2, 7, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0);


INSERT INTO structure_validations (structure_field_id, rule, on_action, language_message)
VALUES
((SELECT id FROM structure_fields WHERE plugin = 'ClinicalAnnotation' AND model = 'EventDetail' AND tablename = 'ed_bcwh_stillbirths' AND field = 'mrn' AND type = 'input'), 'isUnique', '', 'mrn must be unique');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('fetal death', 'Fetal Death', ''),
('fetal death type', 'Antepartum or Intrapartum?', ''),
('antepartum', 'Antepartum', ''),
('intrapartum', 'Intrapartum', ''),
('mrn', 'MRN', ''),
('time of birth', 'Time of Birth', ''),
('live births', 'Live Births', '');

--  =============================================================================
--	Eventum ID: #XXXX
--  BB-138 Renaming the diganosis master date field in all the diagnosis forms
--	=============================================================================

UPDATE structure_formats
SET flag_add = 0, flag_edit = 0, flag_search = 0, flag_summary = 0, flag_index = 0, flag_detail = 0
WHERE structure_field_id = (SELECT id FROM structure_fields WHERE plugin = 'ClinicalAnnotation' AND model = 'DiagnosisMaster' AND tablename = 'diagnosis_masters' AND field = 'dx_date')
AND structure_id = (SELECT id FROM structures WHERE alias = 'diagnosismasters');

-- Oncology and Hematology
INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_oncology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_hematology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

-- Pregnancy Form

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 1, 'date of first encounter at bcwh', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

-- Delivery Form

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 1, 'delivery date', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

-- Abortion Form

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_abortions'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 1, 'date of the procedure', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

-- live births and Stillbirths

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_live_births'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'),
1, '-2', '', 1, 'date of birth', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='ed_bcwh_stillbirths'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'),
1, '-2', '', 1, 'date of birth', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('date of first encounter at bcwh', 'Date of First Visit at BCWH', ''),
('delivery date', 'Delivery Date', ''),
('date of the procedure', 'Date of the Procedure', ''),
('date of birth', 'Date of Birth', '');

--  =========================================================================
--	Eventum ID: #XXXX
--  BB-117: Incorrect table name for ccbr_relationship_other field in the structure_fields table
--	=========================================================================

UPDATE structure_fields
SET `tablename` = 'participants'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `field` = 'ccbr_relationship_other' AND `language_tag` = 'ccbr relationship other' AND `type`='input' AND `setting` = 'size=30';

-- ============================================================================
-- Eventum ID: #XXXX
-- BB-145: Make permission to contact fields in participant contacts searchable
-- ============================================================================

UPDATE structure_formats 
SET flag_search = 1
WHERE structure_id = (SELECT id FROM structures WHERE alias = 'participantcontacts')
AND structure_field_id = (SELECT id FROM structure_fields WHERE plugin = 'ClinicalAnnotation' AND model = 'ParticipantContact' AND tablename = 'participant_contacts' AND field = 'contact_permission_research' AND type = 'yes_no');

UPDATE structure_formats 
SET flag_search = 1
WHERE structure_id = (SELECT id FROM structures WHERE alias = 'participantcontacts')
AND structure_field_id = (SELECT id FROM structure_fields WHERE plugin = 'ClinicalAnnotation' AND model = 'ParticipantContact' AND tablename = 'participant_contacts' AND field = 'contact_permission_admin' AND type = 'yes_no');

-- ============================================================================
-- Eventum ID: #XXXX
-- BB-149: SWAVE1 Identifier
-- ============================================================================

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `misc_identifier_format`, `flag_once_per_participant`, `flag_unique`, `pad_to_length`, `flag_link_to_study`)
VALUES
('SWAVE1 ID', 1, 13, NULL, 1, 1, 0, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('SWAVE1 ID', 'SWAVE1 ID', '');

-- ==============================================================================
-- Bug Fixes
-- ==============================================================================

DELETE FROM structure_formats
WHERE structure_id = (SELECT `id` FROM structures WHERE alias='dx_abortions')
AND structure_field_id = (SELECT `id` FROM structure_fields WHERE plugin='ClinicalAnnotation' AND model='EventMaster' AND tablename='event_masters' AND field='notes' AND type='textarea');

-- ==============================================================================
-- Bug Fixes - After review with Adam
-- ==============================================================================

-- Add PowerChart to Report Format

INSERT INTO structure_permissible_values
(`value`, `language_alias`)
VALUES
('powerchart', 'powerchart');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'information_source' AND `override` = 'open'), (SELECT `id` FROM structure_permissible_values WHERE `value` ='powerchart' AND `language_alias`='powerchart'), 6, 1, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('powerchart', 'PowerChart', '');

-- Make Diagnosis Date Mandatory

INSERT INTO structure_validations (`structure_field_id`, `rule`, `on_action`, `language_message`)
VALUES
((SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `type`='date'), 'notEmpty', '', 'Date is required');

-- Add permission to receive newsletter

ALTER TABLE participant_contacts
    ADD COLUMN `contact_permission_newsletter` VARCHAR(20) DEFAULT NULL AFTER `contact_permission_admin`;
    
ALTER TABLE participant_contacts_revs
    ADD COLUMN `contact_permission_newsletter` VARCHAR(20) DEFAULT NULL AFTER `contact_permission_admin`;
    
INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'contact_permission_newsletter', 'contact permission for newsletter', '', 'yes_no', '', '', NULL, 'help_contact_permission_newsletter', 'open', 'open', 'open', 0);
 
INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='participantcontacts'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='contact_permission_newsletter' AND `type`='yes_no'),
1, 8, '', 0, '', 0, 0,
0, 0, 1, 'n',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('contact permission for newsletter', 'Permission to Contact for Newsletter', '');

-- Take title off the index

UPDATE structure_formats
SET `flag_index` = 0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'participants')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename`='participants' AND `field`='title' AND `type` = 'select');

-- ==============================================================================
-- Bug Fixes - After review with Ashton
-- ==============================================================================

ALTER TABLE `dxd_bcwh_pregnancies`
    MODIFY `diabetes` VARCHAR(60);

ALTER TABLE `dxd_bcwh_pregnancies_revs`
    MODIFY `diabetes` VARCHAR(60);

    
ALTER TABLE `dxd_bcwh_deliveries`
    ADD COLUMN `gravida` int(11) DEFAULT NULL AFTER `blood_loss_procedure`,
    ADD COLUMN `term_births` int(11) DEFAULT NULL AFTER `gravida`,
    ADD COLUMN `preterm_births` int(11) DEFAULT NULL AFTER `term_births`,
    ADD COLUMN `abortions` int(11) DEFAULT NULL AFTER `preterm_births`,
    ADD COLUMN `living_children` int(11) DEFAULT NULL AFTER `abortions`;
    
ALTER TABLE `dxd_bcwh_deliveries_revs`
    ADD COLUMN `gravida` int(11) DEFAULT NULL AFTER `blood_loss_procedure`,
    ADD COLUMN `term_births` int(11) DEFAULT NULL AFTER `gravida`,
    ADD COLUMN `preterm_births` int(11) DEFAULT NULL AFTER `term_births`,
    ADD COLUMN `abortions` int(11) DEFAULT NULL AFTER `preterm_births`,
    ADD COLUMN `living_children` int(11) DEFAULT NULL AFTER `abortions`;

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'gravida', 'gravida', '', 'integer_positive', '', NULL, 'help_gravida', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'term_births', 'term births', '', 'integer_positive', '', NULL, 'help_term_births', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'preterm_births', 'preterm births', '', 'integer_positive', '', NULL, 'help_preterm_births', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'abortions', 'abortions', '', 'integer_positive', '', NULL, 'help_abortions', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_deliveries', 'living_children', 'living children', '', 'integer_positive', '', NULL, 'help_living_children', 'open', 'open', 'open', 0);
    

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field` = 'gravida' AND `language_label`='gravida' AND `type`='integer_positive'),
1, 15, 'gtpal - after delivery', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field` = 'term_births' AND `language_label`='term births' AND `type`='integer_positive'),
1, 16, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field` = 'preterm_births' AND `language_label`='preterm births' AND `type`='integer_positive'),
1, 17, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field` = 'abortions' AND `language_label`='abortions' AND `type`='integer_positive'),
1, 18, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_deliveries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_deliveries' AND `field` = 'living_children' AND `language_label`='living children' AND `type`='integer_positive'),
1, 19, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);


--  =============================================================================
--  Eventum ID: #XXXX
--  Neurology Diagnosis Form
--  =============================================================================

-- Migrate data from reproductive histories

CREATE TABLE `dxd_bcch_neurology` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`diagnosis_department` varchar(88) DEFAULT NULL,
	`diagnosis_master_id` int(11) NOT NULL DEFAULT 0,
	PRIMARY KEY(`id`),
	CONSTRAINT `FK_dxd_bcch_neurology_diagnosis_masters` FOREIGN KEY(`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dxd_bcch_neurology_revs` (
	`id` int(11) NOT NULL,
	`diagnosis_department` varchar(88) DEFAULT NULL,
	`version_id` int(11) NOT NULL AUTO_INCREMENT,
	`version_created` datetime NOT NULL,
	PRIMARY KEY(`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `diagnosis_controls`
(`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`)
VALUES
('primary', 'neurology', 1, 'dx_primary,dx_bcch_neurology', 'dxd_bcch_neurology', 0, 'primary|neurology', 1);

INSERT INTO structures
(`alias`, `description`) VALUES
('dx_bcch_neurology', NULL);

INSERT INTO structure_permissible_values
(`value`, `language_alias`)
VALUES
('neurology', 'neurology');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_departments'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'neurology'), 0, 1, 1);

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcch_neurology', 'diagnosis_department', 'diagnosis department', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcch_departments'), 'help_diagnosis_department', 'open', 'open', 'open', 0);

INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_neurology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `type`='integer_positive'),
1, 9, '', 0, 1, 'ccbr age at dx years', 1,
1, 'integer', 1, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_neurology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months' AND `type`='integer'),
1, 9, '', 0, 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_neurology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks' AND `type`='integer'),
1, 9, '', 0, 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_neurology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days' AND `type`='integer'),
1, 9, '', 0, 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
0, 0, 0, 1, 1, 0, 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcch_neurology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_neurology' AND `field` = 'diagnosis_department' AND `language_label`='diagnosis department' AND `type`='select'),
3, 1, 'pathology report logistics', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

UPDATE `structure_formats`
SET `display_column`=1, `display_order`=10
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='dx_bcch_neurology')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcch_neurology' AND `field`='diagnosis_department');

-- Add Neurology Form

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_bcch_neurology'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('neurology', 'Neurology', '');

--  =============================================================================
--  Bug fixes after Naveen's review
--  =============================================================================

-- Make Study Title acronym from 6 char to 10 char
-- BB-155
UPDATE structure_validations
SET `rule` = 'between,1,10', `language_message` = 'ccbr study title must be between 1 to 10 letters'
WHERE `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `type`='input')
AND `rule` = 'between,1,6';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('ccbr study title must be between 1 to 10 letters', 'Study Title Acronym must be between 1 to 10 letters', '');

-- BB-156

UPDATE structure_formats
SET `flag_detail`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias`='bank_activty_report')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin`='Datamart' AND `model`=0 AND `field`='obtained_consents_nbr' and `type`='input');

-- Add a data entry date field for Pregnancy

ALTER TABLE dxd_bcwh_pregnancies
	ADD COLUMN `data_entry_date` date DEFAULT NULL AFTER `exp_delivery_date_accuracy`,
    ADD COLUMN `data_entry_date_accuracy` CHAR(1) DEFAULT NULL AFTER `data_entry_date`;
    
ALTER TABLE dxd_bcwh_pregnancies_revs 
	ADD COLUMN `data_entry_date` date DEFAULT NULL AFTER `exp_delivery_date_accuracy`,
    ADD COLUMN `data_entry_date_accuracy` CHAR(1) DEFAULT NULL AFTER `data_entry_date`;
    
INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_bcwh_pregnancies', 'data_entry_date', 'data entry date', '', 'date', '', NULL, 'help_data_entry_date', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'dx_bcwh_pregnancies'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_bcwh_pregnancies' AND `field` = 'data_entry_date' AND `language_label`='data entry date' AND `type`='date'),
1, 16, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('data entry date', 'Data Entry Date', '');

-- Make English translation field mandatory
-- BB-158

INSERT INTO structure_validations
(`structure_field_id`, `rule`, `language_message`)
VALUES
((SELECT `id` FROM structure_fields WHERE `plugin`='Administrate' AND `model`='StructurePermissibleValuesCustom' AND `tablename`='structure_permissible_values_customs' AND `field` = 'en' AND `type` = 'input'), 'notEmpty', 'english display message cannot be empty');

-- Make Aliquot study field mandatory

INSERT INTO structure_validations
(`structure_field_id`, `rule`, `language_message`)
VALUES
((SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field` = 'study_summary_id' AND `type` = 'select'), 'notEmpty', 'you must select a study');

-- Disable Reproductive History from UI

UPDATE menus
SET `flag_active` = 0
WHERE `language_title` = 'reproductive history' AND `use_link` = '/ClinicalAnnotation/ReproductiveHistories/listall/%%Participant.id%%';

-- Re-enable date fields in various event forms

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'ed_ccbr_lab_cytogenetics'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'),
1, '-2', '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'ed_ccbr_lab_immunophenotypes'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'),
1, '-2', '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'ed_ccbr_lab_cbc_bone_marrows'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'),
1, '-2', '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'ed_all_comorbidities'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'),
1, '-2', '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'ed_ccbr_lab_chemo_responses'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'),
1, '-2', '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'ed_ccbr_lab_karyotypes'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date'),
1, '-2', '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0);


--  =============================================================================
--  Eventum ID: #XXXX
--  Migrate Reproductive History data to Pregnancy Diagnosis
--  =============================================================================

INSERT INTO `diagnosis_masters` (`dx_date`, `dx_date_accuracy`, `diagnosis_control_id`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
SELECT `date_captured`, `date_captured_accuracy`, (SELECT `id` FROM `diagnosis_controls` WHERE `category` = 'primary' AND `controls_type` = 'pregnancy' AND `detail_tablename` = 'dxd_bcwh_pregnancies'), `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted` FROM `reproductive_histories` ORDER BY `id` ASC;

INSERT INTO `dxd_bcwh_pregnancies`(`diagnosis_master_id`, `data_entry_date`, `data_entry_date_accuracy`)
SELECT `id`, `dx_date`, `dx_date_accuracy` FROM `diagnosis_masters` WHERE `diagnosis_control_id` = (SELECT `id` FROM `diagnosis_controls` WHERE `category` = 'primary' AND `controls_type` = 'pregnancy' AND `detail_tablename` = 'dxd_bcwh_pregnancies');

UPDATE `diagnosis_masters` 
SET `primary_id` = `id`, `dx_date`= NULL, `dx_date_accuracy` = NULL
WHERE `diagnosis_control_id` = (SELECT `id` FROM `diagnosis_controls` WHERE `category` = 'primary' AND `controls_type` = 'pregnancy' AND `detail_tablename` = 'dxd_bcwh_pregnancies');

INSERT INTO `diagnosis_masters_revs` (`id`, `primary_id`, `parent_id`,  `diagnosis_control_id`, `participant_id`, `modified_by`, `version_created`)
SELECT `id`, `primary_id`, `parent_id`,  `diagnosis_control_id`, `participant_id`, 0, NOW() FROM `diagnosis_masters` WHERE `diagnosis_control_id` = (SELECT `id` FROM `diagnosis_controls` WHERE `category` = 'primary' AND `controls_type` = 'pregnancy' AND `detail_tablename` = 'dxd_bcwh_pregnancies') ORDER BY `id` ASC;

INSERT INTO `dxd_bcwh_pregnancies_revs` (`id`, `data_entry_date`, `data_entry_date_accuracy`, `diagnosis_master_id`, `version_created`)
SELECT `id`, `data_entry_date`, `data_entry_date_accuracy`, `diagnosis_master_id`, NOW() FROM `dxd_bcwh_pregnancies`; 

--  =============================================================================
--  Eventum ID: #XXXX
--  BB-159
--  =============================================================================

UPDATE aliquot_masters_revs
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE aliquot_masters_revs.id IN (SELECT `id` FROM aliquot_masters WHERE `study_summary_id` IS NULL AND `created` < '2014-11-01 00:00:00');

UPDATE aliquot_masters
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE `study_summary_id` IS NULL 
AND `created` < '2014-11-01 00:00:00';

--  =============================================================================
--  Eventum ID: #XXXX
--  BB-161
--  =============================================================================

ALTER TABLE study_summaries
	ADD COLUMN `require_separate_cosent` VARCHAR(8) DEFAULT NULL AFTER `service_storage`;
    
ALTER TABLE study_summaries_revs
	ADD COLUMN `require_separate_cosent` VARCHAR(8) DEFAULT NULL AFTER `service_storage`;

INSERT INTO structure_value_domains
(`domain_name`, `override`, `source`)
VALUES
('bcch_yes_no_select', 'open', NULL);

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_yes_no_select'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'no' AND `language_alias` = 'bcch_no'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_yes_no_select'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'yes' AND `language_alias` = 'bcch_yes'), 2, 1, 1);


INSERT INTO `structure_fields`
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('Study', 'StudySummary', 'study_summaries', 'require_separate_cosent', 'require separate consent form', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name`='bcch_yes_no_select'), '', 'open', 'open', 'open', 0);

INSERT INTO `structure_formats`
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='studysummaries'),
(SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='require_separate_cosent' AND `type`='select'),
2, 0, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

INSERT INTO structure_validations
(`structure_field_id`, `rule`, `language_message`)
VALUES
((SELECT `id` FROM structure_fields WHERE `plugin`='Study' AND `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='require_separate_cosent' AND `type`='select'), 'notEmpty', 'Require separate consent form cannot be empty');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('require separate consent form', 'Does this study have a separate consent form?', '');

--  =============================================================================
--  After review with Tamsin, Disable Abortion Form from user access
--  =============================================================================

UPDATE diagnosis_controls
SET `flag_active`=0
WHERE `category` = 'secondary' AND `controls_type` = 'abortion' AND `detail_tablename`='dxd_abortions';

-- ============================================================================
-- Translation 
-- ============================================================================

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('Hematology', 'Hematology', ''),
('Oncology', 'Oncology', ''),
('Pregnancy', 'Pregnancy', ''),
('Unknown', 'Unknown', ''),
('unknown', 'Unknown', ''),
('hematology', 'Hematology', ''),
('oncology', 'Oncology', ''),
('pregnancy', 'Pregnancy', ''),
('stillbirths', 'Stillbirths', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('tobacco usage', 'Tobacco Usage', ''),
('alcohol usage', 'Alcohol Usage', ''),
('substance usage', 'Substance(s) Usage', ''),
('quit before pregnancy', 'Quit Before Pregnancy', ''),
('quit during pregnancy', 'Quit During Pregnancy', ''),
('current smoker', 'Current Smoker', ''),
('non smoker', 'Non Smoker', ''),
('non drinker', 'Non Drinker', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('communicable diseases', 'Communicable Diseases', ''),
('rubella status', 'Rubella Status', ''),
('immune', 'Immune', ''),
('non immune', 'Non-immune', ''),
('mmr status', 'MMR Given', ''),
('rh immune globulin status', 'Rh Immune Globulin', ''),
('hepatitis b status', 'Hepatitis B', ''),
('exposure to other communicable disease', 'Exposure to other diseases (HSV, Hep. C) ', ''),
('exposure to other communicable disease other', 'If Yes, Specify:', ''),
('given', 'Given', ''),
('positive/carrier', 'Positive/Carrier', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('delivery details', 'Delivery Details', ''),
('delivery induction details', 'Labour Inductions', ''),
('arm induction', 'Assisted Rupture of Membrane (ARM)', ''),
('foley induction', 'Foley', ''),
('oxytocin induction', 'Oxytocin', ''),
('prostaglandin induction', 'Prostaglandin', ''),
('anaesthesia', 'Anaesthesia', ''),
('anaesthesia usage', 'Anaesthesia Usage', ''),
('anaesthesia agent', 'Anaesthesia Agent', ''),
('Entonox', 'Entonox', ''),
('Opioids', 'Opioids', ''),
('Pundendal', 'Pundendal', ''),
('anaesthesia type', 'Type of Anaesthesia', ''),
('Epidural', 'Epidural', ''),
('Spinal', 'Spinal', ''),
('Combined', 'Combined', ''),
('General', 'General', ''),
('antibiotics', 'Prophylactic Antibiotics', ''),
('antibiotics usage', 'Antibiotics Usage', ''),
('antibiotics type', 'Type of Antibiotics', ''),
('Intrapartum', 'Intrapartum', ''),
('Intraoperative', 'Intraoperative', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('group b strep exposure', 'Group B Strep Exposure', ''),
('hep b prophylaxis', 'Hep B Prophylaxis', ''),
('in utero exposure', 'In Utero Exposure', ''),
('tobacoo in utero exposure', 'Tobacco', ''),
('alcohol in utero exposure', 'Alcohol', ''),
('substances in utero exposure', 'Substances', '');

-- help messages

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_fetal_death_type', 'occurring not long before childbirth; the period from the onset of labor to the end of the third stage of labor', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_genetic_syndromes', 'Diseases or conditions caused by an absent or defective gene or by a chromosomal aberration, as in Down Syndrome.', ''),
('help_congenital_birth_defects', 'structural or functional anomalies (e.g. metabolic disorders) that occur during intrauterine life and can be identified prenatally, at birth or later in life.', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('help_anemia', 'a condition marked by a deficiency of red blood cells or of hemoglobin in the blood, resulting in pallor and weariness.', ''),
('help_cervical_insuff', 'a medical condition in which a pregnant womans cervix begins to dilate (widen) and efface (thin) before her pregnancy has reached term. The inability of the uterine cervix to retain a pregnancy in the absence of the signs and symptoms of clinical contractions, or labor,or both in the second trimester.', ''),
('help_intra_amniotic', '(formerly called chorioamnionitis) is infection of the chorion, amnion, amniotic fluid, placenta, or a combination.', ''),
('help_ectopic_preg', 'a pregnancy in which the fetus develops outside the uterus, typically in a Fallopian tube', ''),
('help_erythro_fetalis', '(aka hemolytic disease of the newborn) the abnormal presence of erythroblasts in the blood', ''),
('help_diabetes', 'a metabolic disease in which the body’s inability to produce any or enough insulin causes elevated levels of glucose in the blood', ''),
('help_hyper_gravidarum', 'persistent severe vomiting leading to weight loss and dehydration, as a condition occurring during pregnancy', ''),
('help_hypertension', 'abnormally high blood pressure.', ''),
('help_iugr', 'a fetal weight that is below the 10th percentile for gestational age as determined through an ultrasound. This can also be called small-for gestational age (SGA) or fetal growth restriction.', ''),
('help_oligohydramnios', 'a condition in pregnancy characterized by a deficiency of amniotic fluid. It is the opposite of polyhydramnios.', ''),
('help_pemphigoid_gestationis', '(PG) is a dermatosis of pregnancy, being an autoimmune blistering skin disease that occurs during pregnancy, typically in the second or third trimester, and/or immediately following pregnancy', ''),
('help_placenta_abruption', '(also known as abruptio placentae) is a complication of pregnancy, wherein the placental lining has separated from the uterus of the mother prior to delivery. It is the most common pathological cause of late pregnancy bleeding.', ''),
('help_placenta_previa', 'a condition in which the placenta partially or wholly blocks the neck of the uterus, thus interfering with normal delivery of a baby.', ''),
('help_polyhydramnios', 'the excessive accumulation of amniotic fluid', ''),
('help_preeclampsis_eclampsia', 'a life-threatening complication of pregnancy, is a condition that causes a pregnant woman, usually previously diagnosed with preeclampsia (high blood pressure and protein in the urine), to develop seizures or coma', ''),
('help_prom', '(aka pre-labor rupture of membranes) is a condition that can occur in pregnancy. It is defined as rupture of membranes (breakage of the amniotic sac), commonly called breaking of the mothers water(s), more than 1 hour before the onset of labor', ''),
('help_puppp', 'a chronic hives-like rash that strikes some women during pregnancy. Although extremely annoying for its sufferers (because of the itch), it presents no long-term risk for either the mother or unborn child. PUPPP frequently ', ''),
('help_vasa_previa', 'a condition which arises when fetal blood vessels implant into the placenta in a way that covers the internal os of the uterus', '');

