-- PedVas Custom Script
-- Version: v0.2
-- ATiM Version: v2.5.2

-- This script must be run against a v2.5.2 ATiM database with all previous custom scripts applied.

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'PedVas - v0.2 DEV', '');
	
-- Fix Diagnosis language translations
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('pv diagnosis type', 'Diagnosis Type', ''),
 ('pedvas', 'PedVas Diagnosis', '');

 /*
	------------------------------------------------------------
	Eventum ID: 2477 - Fix quote issue on Diagnosis Type drop down	
	------------------------------------------------------------
*/
/* not working
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	("granulomatosis with polyangiitis (wegener’s granulomatosis)", "Granulomatosis with polyangiitis (Wegener\'s granulomatosis)", ''),
	("limited granulomatosis with polyangiitis (limited wegener’s granulomatosis))", "Limited granulomatosis with polyangiitis (Limited Wegener\'s granulomatosis)", ''),
	("takayasu’s arteritis", "Takayasu\'s arteritis", '');
*/

 /*
	------------------------------------------------------------
	Eventum ID: 2478 - Add year to profile	
	------------------------------------------------------------
*/
	
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE `participants` ADD COLUMN `pv_birth_year` INT(10) NULL AFTER `pv_subject_type` ;
ALTER TABLE `participants_revs` ADD COLUMN `pv_birth_year` INT(10) NULL AFTER `pv_subject_type` ;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'pv_birth_year', 'integer',  NULL , '0', '', '', '', 'pv birth year', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='pv_birth_year' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pv birth year' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('pv birth year', 'Birth Year', '');
	
 /*
	------------------------------------------------------------
	Eventum ID: 2479 - Consent - Fix assent/formal consent dropdown	
	------------------------------------------------------------
*/

INSERT INTO structure_permissible_values (value, language_alias) VALUES("obtained (assent)", "obtained (assent)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="consent_status"), (SELECT id FROM structure_permissible_values WHERE value="obtained (assent)" AND language_alias="obtained (assent)"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("obtained (formal)", "obtained (formal)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="consent_status"), (SELECT id FROM structure_permissible_values WHERE value="obtained (formal)" AND language_alias="obtained (formal)"), "3", "1");

DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="obtained" AND spv.language_alias="obtained";
DELETE FROM structure_permissible_values WHERE value="obtained" AND language_alias="obtained";

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('obtained (assent)', 'Obtained - Assent', ''),
	('obtained (formal)', 'Obtained - Formal', '');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_pv_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_assent_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_pv_consents') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_pv_consents' AND `field`='pv_date_assent' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


