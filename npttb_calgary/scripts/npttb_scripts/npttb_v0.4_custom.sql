-- NPTTB Custom Script
-- Version: v0.4
-- ATiM Version: v2.5.2

-- This script must be run against a v2.5.2 ATiM database with all previous custom scripts applied.

/*
	------------------------------------------------------------
	Eventum ID: 2322 - Consent - Fix form version
	------------------------------------------------------------
*/

-- Add form version field to detail form cd_npttb_consent_brain_bank
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_consent_from_verisons')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_form_version' AND `language_label`='form_version' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Remove form version from consent masters
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_consent_from_verisons') AND `flag_confidential`='0');


/*
	------------------------------------------------------------
	Eventum ID: 2413 - Consent - FK error on revs table
	------------------------------------------------------------
*/

-- Fix autoincrement for all detail consent tables
ALTER TABLE `cd_npttb_autopsy_revs` CHANGE COLUMN `version_id` `version_id` INT(11) NOT NULL AUTO_INCREMENT  ;
ALTER TABLE `cd_npttb_consent_baker_v2_revs` CHANGE COLUMN `version_id` `version_id` INT(11) NOT NULL AUTO_INCREMENT  ;
ALTER TABLE `cd_npttb_consent_baker_v3_revs` CHANGE COLUMN `version_id` `version_id` INT(11) NOT NULL AUTO_INCREMENT  ;
ALTER TABLE `cd_npttb_consent_brain_bank_revs` CHANGE COLUMN `version_id` `version_id` INT(11) NOT NULL AUTO_INCREMENT  ;
ALTER TABLE `cd_npttb_consent_sno_calgary_revs` CHANGE COLUMN `version_id` `version_id` INT(11) NOT NULL AUTO_INCREMENT  ;

/*
	------------------------------------------------------------
	Eventum ID: 2246 - Surgery Path Number Validation
	------------------------------------------------------------
*/

UPDATE `structure_validations` SET `rule`='/^\\A\\w{2}\\s{1}\\d{2}(-)\\d{4}$/' WHERE `id`= (SELECT `id` FROM `structure_fields` WHERE model = 'TreatmentDetail' AND tablename = 'txd_surgeries' AND field = 'path_num');

/*
	------------------------------------------------------------
	Eventum ID: 2330 - Treatment -> Surgery -> Age at Surgery
	------------------------------------------------------------
*/

-- Add column to master table
ALTER TABLE `treatment_masters` ADD COLUMN `npttb_age_at_tx` INT(11) NULL DEFAULT NULL  AFTER `notes` ;
ALTER TABLE `treatment_masters_revs` ADD COLUMN `npttb_age_at_tx` INT(11) NULL DEFAULT NULL  AFTER `notes` ;

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='npttb_age_at_surgery' AND `language_label`='npttb age at surgery' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='npttb_age_at_surgery' AND `language_label`='npttb age at surgery' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='npttb_age_at_surgery' AND `language_label`='npttb age at surgery' AND `language_tag`='' AND `type`='integer' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- Add field to surgery form
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('npttb age treatment', 'Age at Treatment', '');
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'npttb_age_at_tx', 'integer',  NULL , '0', '', '', '', 'npttb age treatment', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='npttb_age_at_tx' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb age treatment' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
	
	
