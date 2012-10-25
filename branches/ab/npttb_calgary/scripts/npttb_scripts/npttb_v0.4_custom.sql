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