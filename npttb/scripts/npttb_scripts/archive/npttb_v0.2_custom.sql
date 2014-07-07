-- NPTTB Custom Script
-- Version: v0.2
-- ATiM Version: v2.4.3A

-- This script must be run against a v2.4.3A ATiM database with the previous dev script applied (v0.1)

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.2 DEV', '');

/*
	------------------------------------------------------------
	Eventum ID: 2282 - Misc Identifier - Medical Record Number
	------------------------------------------------------------
*/

-- Create new control value for MRN number
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('Medical Record Number', 'Medical Record Number', ''),
	('MRN (Pre-2008)', 'MRN (Pre-2008)', ''),
	('TTB Number', 'TTB Number', ''),
	('npbttb MRN validation error', 'Medical Record Number invalid. Must be 12 digits.', ''),
	('npbttb MRN (Pre-2008) validation error', 'MRN (Pre-2008) is invalid', '');

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`) VALUES ('Medical Record Number', 1, 3, 1, 0);
INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`) VALUES ('MRN (Pre-2008)', 1, 4, 1, 0);

/*
	------------------------------------------------------------
	Eventum ID: 2253 - Consent - Add material flags
	------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('npttb material use', 'Material Use', ''),
	('npttb use tissue', 'Tissue', ''),
	('npttb use blood', 'Blood', ''),
	('npttb use urine', 'Urine', ''),
	('npttb use csf', 'CSF', ''),
	('npttb use bone marrow', 'Bone Marrow', ''),
	('npttb help use tissue', 'Indicates whether or not the participant has not consented for tissue use', ''),
	('npttb help use blood', 'Indicates whether or not the participant has not consented for blood use', ''),
	('npttb help use csf', 'Indicates whether or not the participant has not consented for CSF use', ''),
	('npttb help use urine', 'Indicates whether or not the participant has not consented for urine use', ''),
	('npttb help use bone marrow', 'Indicates whether or not the participant has not consented for bone marrow use', '');		
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_use_tissue', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help use tissue', 'npttb use tissue', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_use_blood', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help use blood', 'npttb use blood', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_use_urine', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help use urine', 'npttb use urine', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_use_csf', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help use csf', 'npttb use csf', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_use_bone_marrow', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help use bone marrow', 'npttb use bone marrow', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_use_tissue' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help use tissue' AND `language_label`='npttb use tissue' AND `language_tag`=''), '2', '200', 'npttb material use', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_use_blood' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help use blood' AND `language_label`='npttb use blood' AND `language_tag`=''), '2', '210', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_use_urine' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help use urine' AND `language_label`='npttb use urine' AND `language_tag`=''), '2', '220', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_use_csf' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help use csf' AND `language_label`='npttb use csf' AND `language_tag`=''), '2', '230', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_use_bone_marrow' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help use bone marrow' AND `language_label`='npttb use bone marrow' AND `language_tag`=''), '2', '240', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

/*
	------------------------------------------------------------
	Eventum ID: 2097 - Treatment - Surgery
	------------------------------------------------------------
*/

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('npttb surgeon', 'Surgeon', ''),
	('npttb age at surgery', 'Age at Surgery', '');

-- Add new columns for custom surgery fields
ALTER TABLE `txd_surgeries` 
	ADD COLUMN `npttb_surgeon` VARCHAR(100) NULL DEFAULT NULL AFTER `primary` ,
	ADD COLUMN `npttb_age_at_surgery` INT(11) NULL DEFAULT NULL AFTER `npttb_surgeon` ;
	
ALTER TABLE `txd_surgeries_revs` 
	ADD COLUMN `npttb_surgeon` VARCHAR(100) NULL DEFAULT NULL AFTER `primary` ,
	ADD COLUMN `npttb_age_at_surgery` INT(11) NULL DEFAULT NULL AFTER `npttb_surgeon` ;	

INSERT INTO `structure_permissible_values_custom_controls` (`name`, `flag_active`, `values_max_length`) VALUES ('npttb surgery surgeon', 1, 50);
INSERT INTO `structure_value_domains` (domain_name, override, category, source) VALUES ("custom_npttb_surgery surgeon", "", "", "StructurePermissibleValuesCustom::getCustomDropdown('npttb surgery surgeon')");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'npttb_surgeon', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_npttb_surgery surgeon') , '0', '', '', '', 'npttb surgeon', ''), 
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'npttb_age_at_surgery', 'integer',  NULL , '0', '', '', '', 'npttb age at surgery', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='npttb_surgeon' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_npttb_surgery surgeon')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb surgeon' AND `language_tag`=''), '1', '15', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='npttb_age_at_surgery' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttb age at surgery' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- Turn age at surgery off add form
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='npttb_age_at_surgery' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');