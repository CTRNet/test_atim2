-- TFRI AML/MDS Custom Script
-- Version: v0.10
-- ATiM Version: v2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI MDS/AML Biobank v0.10 DEV', '');
	
-- ----------------------------------------------------------------------
-- Eventum ID:3081 EQ-5D New heading for Model Health State
-- ----------------------------------------------------------------------

-- Move calculated score to bottom in this new section
UPDATE structure_formats SET `display_order`='40', `language_heading`='aml model health state' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='calculated_score' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');	

ALTER TABLE `ed_tfri_study_eq_5d_health`
ADD `model_health_state` VARCHAR(255) NULL DEFAULT NULL AFTER `calculated_score`;

ALTER TABLE `ed_tfri_study_eq_5d_health_revs`
ADD `model_health_state` VARCHAR(255) NULL DEFAULT NULL AFTER `calculated_score`;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_tfri_study_eq_5d_health', 'model_health_state', 'input',  NULL , '0', '', '', '', 'model health state', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_tfri_study_eq_5d_health'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_tfri_study_eq_5d_health' AND `field`='model_health_state' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='model health state' AND `language_tag`=''), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('aml model health state', 'AML Model Health State', ''),
 ('model health state', 'Model Health State', '');
 
-- ----------------------------------------------------------------------
-- Eventum ID:3082 Consent form name
-- ----------------------------------------------------------------------
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('Site 1 - Informed Consent', 'Site 1 - Informed Consent Form', ''),
 ('Site 2 - Informed Consent', 'Site 2 - Informed Consent Form', ''),
 ('Site 3 - Informed Consent', 'Site 3 - Informed Consent Form', ''),
 ('Site 4 - Informed Consent', 'Site 4 - Informed Consent Form', ''),
 ('Site 5 - Informed Consent', 'Site 5 - Informed Consent Form', ''),
 ('Site 6 - Informed Consent', 'Site 6 - Informed Consent Form', '');


-- ----------------------------------------------------------------------
-- Eventum ID:3083 Menu change - Clinical Data - General
-- ----------------------------------------------------------------------
UPDATE `menus` SET `language_description` = 'tfri data general', `language_title` = 'tfri data general' WHERE `menus`.`id` = 'clin_CAN_4';

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('tfri data general', 'Data - General', '');