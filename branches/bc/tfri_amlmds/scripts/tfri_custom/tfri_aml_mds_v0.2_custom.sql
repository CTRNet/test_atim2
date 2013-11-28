-- TFRI AML/MDS Custom Script
-- Version: v0.2
-- ATiM Version: v2.5.4

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'TFRI AML-MDS v0.2 DEV', '');
	
/*
	Eventum Issue: #2771 - Profile - Swap sections
*/

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_modification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_cause_of_death' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_cause_of_death') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_cause_of_death_other' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_site_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_screening_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_registration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_day_zero' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_registration_diagnosis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_profile_disease') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_other_diagnosis' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_english_french' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_chemo_start' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_standard_regimen' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_chemo_start_unknown' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_regimen_unknown' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');

/*
	Eventum Issue: #2772 - Profile - Help bubbles
*/

UPDATE structure_fields SET  `language_help`='tfri help cause of death' WHERE model='Participant' AND tablename='participants' AND field='tfri_cause_of_death_other' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sex') ,  `language_help`='tfri help gender' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');
UPDATE structure_fields SET  `language_help`='tfri help participant age' WHERE model='Participant' AND tablename='participants' AND field='tfri_age_at_registration' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='tfri help site number' WHERE model='Participant' AND tablename='participants' AND field='tfri_aml_site_number' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='tfri help screening code' WHERE model='Participant' AND tablename='participants' AND field='tfri_aml_screening_code' AND `type`='integer' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yesno') ,  `language_help`='tfri help english french' WHERE model='Participant' AND tablename='participants' AND field='tfri_aml_english_french' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesno');
UPDATE structure_fields SET  `language_help`='tfri help other diagnosis' WHERE model='Participant' AND tablename='participants' AND field='tfri_aml_other_diagnosis' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') ,  `language_help`='tfri help chemo start' WHERE model='Participant' AND tablename='participants' AND field='tfri_aml_chemo_start_unknown' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') ,  `language_help`='tfri help regimen' WHERE model='Participant' AND tablename='participants' AND field='tfri_aml_regimen_unknown' AND `type`='checkbox' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox');
UPDATE structure_fields SET  `language_help`='tfri help date registration' WHERE model='Participant' AND tablename='participants' AND field='tfri_aml_date_registration' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='tfri help date day zero' WHERE model='Participant' AND tablename='participants' AND field='tfri_aml_date_day_zero' AND `type`='date' AND structure_value_domain  IS NULL ;

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('tfri help cause of death', 'Select the one that best reflects the most significant factor in the death. Baseline disease is either the AML or MDS that participant was diagnosed with at study entry.', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('help_participant identifier', 'Must be an integer value between 1000 and 1600.', ''),
 ('tfri help gender', 'Select gender from Registration of Participant Form.', ''),
 ('tfri help participant age', 'Enter integer value of participant age from Registration of Participant Form.', ''),
 ('tfri help site number', 'Enter single digit integer value for the site number.', ''), 
 ('tfri help screening code', 'Enter screening code as assigned by the site.', ''),
 ('tfri help english french', 'Can this participant understand spoken English and/or French? (In regards to completion of study questionnaires)', ''),
 ('tfri help other diagnosis', 'Select diagnosis from Registration of Participant Form. Provide comment if other selected.', ''),
 ('tfri help chemo start', 'Planned start date of chemotherapy.', ''),
 ('tfri help regimen', 'Planned standard regimen.', ''),
 ('tfri help date registration', 'Date registration form received by SCO.', ''), 
 ('tfri help date day zero', 'Planned standard regimen.', '');   

/*
	Eventum Issue: #2774 - Profile - Increase size of COD Other field
*/	

UPDATE structure_fields SET  `setting`='size=50' WHERE model='Participant' AND tablename='participants' AND field='tfri_cause_of_death_other' AND `type`='input' AND structure_value_domain  IS NULL ;
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('tfri cause of death other', 'Other COD', '');

/*
	Eventum Issue: #2779 - Profile - Increase size of Other Dx field
*/	

UPDATE structure_fields SET  `setting`='size=50' WHERE model='Participant' AND tablename='participants' AND field='tfri_aml_other_diagnosis' AND `type`='input' AND structure_value_domain  IS NULL ;
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('tfri aml other diagnosis', 'Other Diagnosis', '');

/*
	Eventum Issue: #2775 - Label update - Gender
*/	

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('sex', 'Participant Gender', '');
	
/*
	Eventum Issue: #2778 - Profile - Heading change and order to match reg forms
*/		

UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_site_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='tfri study reg other sites' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_chemo_start' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_registration_diagnosis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_profile_disease') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='17' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_other_diagnosis' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='19' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='18' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_age_at_registration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_english_french' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_registration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='60' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_registration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='65' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_day_zero' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='tfri study dates' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='tfri_aml_date_registration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('clin_demographics', 'Study Registration - All Sites', ''),
 ('current status', 'DCF Section 10 - Cause of Death', ''),
 ('tfri study reg other sites', 'Study Registration - Sites 1,3,4,5', ''),
 ('tfri study dates', 'Acknowledgement of Registration', '');
 
/*
	Eventum Issue: #2778 - Last name appearing on detail form
*/		
 
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

/*
	Eventum Issue: #2768 - Profile - Diagnosis drop down
*/

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_profile_disease"), (SELECT id FROM structure_permissible_values WHERE value="Other" AND language_alias="other"), "7", "1");


/*
	Eventum Issue: #2750 - Consent form creation
*/

-- Disable default form
UPDATE `consent_controls` SET `flag_active`='0' WHERE `controls_type`='Consent National';

-- Add control row
INSERT INTO `consent_controls` (`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES ('Site 1 - Informed Consent', '1', 'cd_tfri_site_1', 'cd_tfri_aml_mds', '1', 'Site 1 - Informed Consent');
INSERT INTO `consent_controls` (`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES ('Site 2 - Informed Consent', '1', 'cd_tfri_site_2', 'cd_tfri_aml_mds', '2', 'Site 2 - Informed Consent');
INSERT INTO `consent_controls` (`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES ('Site 3 - Informed Consent', '1', 'cd_tfri_site_3', 'cd_tfri_aml_mds', '3', 'Site 3 - Informed Consent');
INSERT INTO `consent_controls` (`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES ('Site 4 - Informed Consent', '1', 'cd_tfri_site_4', 'cd_tfri_aml_mds', '4', 'Site 4 - Informed Consent');
INSERT INTO `consent_controls` (`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES ('Site 5 - Informed Consent', '1', 'cd_tfri_site_5', 'cd_tfri_aml_mds', '5', 'Site 5 - Informed Consent');
INSERT INTO `consent_controls` (`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES ('Site 6 - Informed Consent', '1', 'cd_tfri_site_6', 'cd_tfri_aml_mds', '6', 'Site 6 - Informed Consent');

-- Add structure
INSERT INTO `structures` (`alias`) VALUES ('cd_tfri_site_1');
INSERT INTO `structures` (`alias`) VALUES ('cd_tfri_site_2');
INSERT INTO `structures` (`alias`) VALUES ('cd_tfri_site_3');
INSERT INTO `structures` (`alias`) VALUES ('cd_tfri_site_4');
INSERT INTO `structures` (`alias`) VALUES ('cd_tfri_site_5');
INSERT INTO `structures` (`alias`) VALUES ('cd_tfri_site_6');

-- Create detail and revs table
CREATE TABLE `cd_tfri_aml_mds` (
  `tfri_date_consent_local` DATE NULL DEFAULT NULL,
  `tfri_local_version_date`	DATE NULL DEFAULT NULL,
  `tfri_consent_aml_mds` VARCHAR(10) NULL DEFAULT NULL,
  `tfri_date_consent_aml_mds` DATE NULL DEFAULT NULL,
  `tfri_aml_mds_version_date` DATE NULL DEFAULT NULL,
  `tfri_consent_other_research` VARCHAR(10) NULL DEFAULT NULL,
  `tfri_date_other_research_consent` DATE NULL DEFAULT NULL,
  `tfri_version_date_other_research` DATE NULL DEFAULT NULL,
  `tfri_consent_intercellular` VARCHAR(10) NULL DEFAULT NULL,
  `tfri_date_consent_intercellular` DATE NULL DEFAULT NULL,
  `tfri_version_date_consent_intercellular` DATE NULL DEFAULT NULL, 
  `tfri_aml_mds_consent_type` VARCHAR(45) NULL DEFAULT NULL,
  `tfri_person_verifying` VARCHAR(200) NULL DEFAULT NULL,
  `tfri_reason_withdrawal` TEXT NULL DEFAULT NULL,
  `tfri_date_of_withdrawal` DATE NULL DEFAULT NULL,
  `tfri_withdrawal_person` VARCHAR(200) NULL DEFAULT NULL,
  `tfri_role` VARCHAR(200) NULL DEFAULT NULL,
  `consent_master_id` int(11) NOT NULL,
  KEY `consent_master_id` (`consent_master_id`),
  CONSTRAINT `cd_tfri_aml_mds_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cd_tfri_aml_mds_revs` (
  `tfri_date_consent_local` DATE NULL DEFAULT NULL,
  `tfri_local_version_date`	DATE NULL DEFAULT NULL,
  `tfri_consent_aml_mds` VARCHAR(10) NULL DEFAULT NULL,
  `tfri_date_consent_aml_mds` DATE NULL DEFAULT NULL,
  `tfri_aml_mds_version_date` DATE NULL DEFAULT NULL,
  `tfri_consent_other_research` VARCHAR(10) NULL DEFAULT NULL,
  `tfri_date_other_research_consent` DATE NULL DEFAULT NULL,
  `tfri_version_date_other_research` DATE NULL DEFAULT NULL,
  `tfri_consent_intercellular` VARCHAR(10) NULL DEFAULT NULL,
  `tfri_date_consent_intercellular` DATE NULL DEFAULT NULL,
  `tfri_version_date_consent_intercellular` DATE NULL DEFAULT NULL, 
  `tfri_aml_mds_consent_type` VARCHAR(45) NULL DEFAULT NULL,
  `tfri_person_verifying` VARCHAR(200) NULL DEFAULT NULL,
  `tfri_reason_withdrawal` TEXT NULL DEFAULT NULL,
  `tfri_date_of_withdrawal` DATE NULL DEFAULT NULL,
  `tfri_withdrawal_person` VARCHAR(200) NULL DEFAULT NULL,
  `tfri_role` VARCHAR(200) NULL DEFAULT NULL,
  `consent_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Value Domain for consent type
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("tfri_consent_type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("clinical", "tfri clinical");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_consent_type"), (SELECT id FROM structure_permissible_values WHERE value="clinical" AND language_alias="tfri clinical"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("research", "tfri research");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tfri_consent_type"), (SELECT id FROM structure_permissible_values WHERE value="research" AND language_alias="tfri research"), "2", "1");

-- Disable unneeded fields
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_consent_from_verisons') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Fix Notes text area
UPDATE structure_fields SET `setting`='cols=35,rows=6' WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='notes' AND `type`='textarea' AND structure_value_domain IS NULL ;
UPDATE structure_formats SET `display_order`='200' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Build Site 1 form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_date_consent_local', 'date',  NULL , '0', '', '', '', 'tfri date consent local', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_local_version_date', 'date',  NULL , '0', '', '', 'tfri help local consent date', '', 'tfri local version date'), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_date_consent_aml_mds', 'date',  NULL , '0', '', '', '', 'tfri date consent aml mds', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_aml_mds_version_date', 'date',  NULL , '0', '', '', 'tfri help mds aml consent date', '', 'tfri aml mds version date');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_local' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent local' AND `language_tag`=''), '1', '30', 'tfri informed consent summary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_local_version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help local consent date' AND `language_label`='' AND `language_tag`='tfri local version date'), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_aml_mds' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent aml mds' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_aml_mds_version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help mds aml consent date' AND `language_label`='' AND `language_tag`='tfri aml mds version date'), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_date_other_research_consent', 'date',  NULL , '0', '', '', '', 'tfri date other research consent', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_version_date_other_research', 'date',  NULL , '0', '', '', '', '', 'tfri version date other research');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_other_research_consent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date other research consent' AND `language_tag`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_version_date_other_research' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='tfri version date other research'), '1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_fields SET  `language_help`='tfri help other research' WHERE model='ConsentDetail' AND tablename='cd_tfri_aml_mds' AND field='tfri_version_date_other_research' AND `type`='date' AND structure_value_domain  IS NULL ;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_person_verifying', 'input',  NULL , '0', '', '', '', 'tfri person verifying', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_person_verifying' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri person verifying' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET  `language_help`='tfri help other research' WHERE model='ConsentDetail' AND tablename='cd_tfri_aml_mds' AND field='tfri_version_date_other_research' AND `type`='date' AND structure_value_domain  IS NULL ;

-- Withdrawal section
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_date_of_withdrawal', 'date',  NULL , '0', '', '', '', 'tfri date of withdrawal', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_withdrawal_person', 'input',  NULL , '0', '', '', '', 'tfri withdrawal person', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_of_withdrawal' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date of withdrawal' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_withdrawal_person' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri withdrawal person' AND `language_tag`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_reason_withdrawal', 'textarea',  NULL , '0', 'cols=35,rows=6', '', '', 'tfri reason withdrawal', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_1'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_reason_withdrawal' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=35,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='tfri reason withdrawal' AND `language_tag`=''), '1', '70', 'tfri participant withdrawal', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Build Site 2 form
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_local' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent local' AND `language_tag`=''), '1', '30', 'tfri informed consent summary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_local_version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help local consent date' AND `language_label`='' AND `language_tag`='tfri local version date'), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_aml_mds' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent aml mds' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_aml_mds_version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help mds aml consent date' AND `language_label`='' AND `language_tag`='tfri aml mds version date'), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_other_research_consent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date other research consent' AND `language_tag`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_version_date_other_research' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help other research' AND `language_label`='' AND `language_tag`='tfri version date other research'), '1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_person_verifying' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri person verifying' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Withdrawal section
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_of_withdrawal' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date of withdrawal' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_withdrawal_person' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri withdrawal person' AND `language_tag`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_reason_withdrawal' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=35,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='tfri reason withdrawal' AND `language_tag`=''), '1', '70', 'tfri participant withdrawal', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Build Site 3 form
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_local' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent local' AND `language_tag`=''), '1', '30', 'tfri informed consent summary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_local_version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help local consent date' AND `language_label`='' AND `language_tag`='tfri local version date'), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_aml_mds' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent aml mds' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_aml_mds_version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help mds aml consent date' AND `language_label`='' AND `language_tag`='tfri aml mds version date'), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_aml_mds_consent_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tfri_consent_type') , '0', '', '', 'tfri help mds aml consent type', 'tfri aml mds consent type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_aml_mds_consent_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tfri_consent_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help mds aml consent type' AND `language_label`='tfri aml mds consent type' AND `language_tag`=''), '1', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_person_verifying' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri person verifying' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET  `language_help`='tfri help other research' WHERE model='ConsentDetail' AND tablename='cd_tfri_aml_mds' AND field='tfri_version_date_other_research' AND `type`='date' AND structure_value_domain  IS NULL ;

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_other_research_consent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date other research consent' AND `language_tag`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_version_date_other_research' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help other research' AND `language_label`='' AND `language_tag`='tfri version date other research'), '1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Withdrawal section
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_of_withdrawal' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date of withdrawal' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_withdrawal_person' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri withdrawal person' AND `language_tag`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_reason_withdrawal' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=35,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='tfri reason withdrawal' AND `language_tag`=''), '1', '70', 'tfri participant withdrawal', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- Build Site 4 form
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_local' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent local' AND `language_tag`=''), '1', '30', 'tfri informed consent summary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_local_version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help local consent date' AND `language_label`='' AND `language_tag`='tfri local version date'), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_aml_mds' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent aml mds' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_aml_mds_version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help mds aml consent date' AND `language_label`='' AND `language_tag`='tfri aml mds version date'), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_person_verifying' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri person verifying' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_other_research_consent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date other research consent' AND `language_tag`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_version_date_other_research' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help other research' AND `language_label`='' AND `language_tag`='tfri version date other research'), '1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_date_consent_intercellular', 'date',  NULL , '0', '', '', '', 'tfri date consent intercellular', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_version_date_consent_intercellular', 'date',  NULL , '0', '', '', '', '', 'tfri version date consent intercellular');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_intercellular' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent intercellular' AND `language_tag`=''), '1', '47', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_version_date_consent_intercellular' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='tfri version date consent intercellular'), '1', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Withdrawal section
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_of_withdrawal' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date of withdrawal' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_withdrawal_person' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri withdrawal person' AND `language_tag`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_4'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_reason_withdrawal' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=35,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='tfri reason withdrawal' AND `language_tag`=''), '1', '70', 'tfri participant withdrawal', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');


-- Build Site 5 form
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_5'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_local' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent local' AND `language_tag`=''), '1', '30', 'tfri informed consent summary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_5'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_local_version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help local consent date' AND `language_label`='' AND `language_tag`='tfri local version date'), '1', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_5'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_aml_mds' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent aml mds' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_5'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_aml_mds_version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help mds aml consent date' AND `language_label`='' AND `language_tag`='tfri aml mds version date'), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_5'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_person_verifying' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri person verifying' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_5'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_other_research_consent' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date other research consent' AND `language_tag`=''), '1', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_5'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_version_date_other_research' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help other research' AND `language_label`='' AND `language_tag`='tfri version date other research'), '1', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Withdrawal section
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_5'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_of_withdrawal' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date of withdrawal' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_5'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_withdrawal_person' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri withdrawal person' AND `language_tag`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_5'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_reason_withdrawal' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=35,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='tfri reason withdrawal' AND `language_tag`=''), '1', '70', 'tfri participant withdrawal', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');


-- Build Site 6 form
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_6'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_consent_aml_mds' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date consent aml mds' AND `language_tag`=''), '1', '40', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_6'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_aml_mds_version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='tfri help mds aml consent date' AND `language_label`='' AND `language_tag`='tfri aml mds version date'), '1', '45', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_6'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_person_verifying' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri person verifying' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_tfri_aml_mds', 'tfri_consent_other_research', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'tfri consent other research', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_6'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_consent_other_research' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri consent other research' AND `language_tag`=''), '1', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Withdrawal section
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_6'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_date_of_withdrawal' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri date of withdrawal' AND `language_tag`=''), '1', '75', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='cd_tfri_site_6'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_withdrawal_person' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri withdrawal person' AND `language_tag`=''), '1', '80', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='cd_tfri_site_6'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_tfri_aml_mds' AND `field`='tfri_reason_withdrawal' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=35,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='tfri reason withdrawal' AND `language_tag`=''), '1', '70', 'tfri participant withdrawal', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');


-- Consent language updates
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
  ('Site 1 - Informed Consent', 'Site 1 - Informed Consent', ''),
  ('Site 2 - Informed Consent', 'Site 2 - Informed Consent', ''),
  ('Site 3 - Informed Consent', 'Site 3 - Informed Consent', ''),
  ('Site 4 - Informed Consent', 'Site 4 - Informed Consent', ''),
  ('Site 5 - Informed Consent', 'Site 5 - Informed Consent', ''),
  ('Site 6 - Informed Consent', 'Site 6 - Informed Consent', ''),    
  ('reason denied or withdrawn', 'Withdrawal Reason', ''),   
  ('tfri date consent aml mds', 'Consent Date - MDS/AML', ''),   
  ('tfri informed consent summary', 'Informed Consent Summary', ''),
  ('tfri date consent local', 'Consent Date - Local Bank', ''),
  ('tfri aml mds version date', 'Version Date - MDS/AML', ''),
  ('tfri local version date', 'Version Date - Local Bank', ''),
  ('tfri help local consent date', 'Enter date of consent for LOCAL CELL BANK and version date of consent signed. Not applicable to Site 6.', ''),
  ('tfri help mds aml consent date', 'Enter date of consent for MDS/AML STUDY and version date of consent signed.', ''),
  ('tfri date other research consent', 'Consent Date - Other Research', ''),    
  ('tfri version date other research', 'Version Date - Other Research', ''),  
  ('tfri help other research', 'Date of consent for OPTIONAL BANKING of MDS/AML STUDY biospecimens and/or data for OTHER RESEARCH', ''),  
  ('tfri person verifying', 'Person Verifying Consent', ''),
  ('tfri date of withdrawal', 'Date of Withdrawal', ''),
  ('tfri withdrawal person', 'Person Completing Withdrawal Form', ''),
  ('tfri participant withdrawal', 'Participant Withdrawal', ''),
  ('tfri reason withdrawal', 'Reason for Withdrawal', ''),
  ('tfri aml mds consent type', 'MDS/AML Study Consent Type', ''),
  ('tfri date consent intercellular', 'Consent Date - Intracellular Signaling', ''),
  ('tfri version date consent intercellular', 'Version Date - Intracellular Signaling', ''),  
  ('tfri clinical', 'Clinical', ''),
  ('tfri consent other research', 'Consent to Optional Other Research', ''),  
  ('tfri confirmation consent', 'Confirmation of Informed Consent', ''),
  ('tfri research', 'Research', '');

/*
	Eventum Issue: #2788 - Diagnosis - Disable all default forms
*/

UPDATE `diagnosis_controls` SET `flag_active`='0' WHERE `id`='1';
UPDATE `diagnosis_controls` SET `flag_active`='0' WHERE `id`='2';
UPDATE `diagnosis_controls` SET `flag_active`='0' WHERE `id`='15';
UPDATE `diagnosis_controls` SET `flag_active`='0' WHERE `id`='16';
UPDATE `diagnosis_controls` SET `flag_active`='0' WHERE `id`='17';
UPDATE `diagnosis_controls` SET `flag_active`='0' WHERE `id`='18';
UPDATE `diagnosis_controls` SET `flag_active`='0' WHERE `id`='19';

/*
	Eventum Issue: #2787 - Diagnosis - Create primary and recurrence forms
*/

-- Add new DX types
INSERT INTO `diagnosis_controls` (`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
('primary', 'aml', '1', 'dx_primary,dx_tfri_aml', 'dxd_tfri_aml', '1', 'primary|aml', '0'),
('primary', 'mds', '1', 'dx_primary,dx_tfri_mds', 'dxd_tfri_mds', '2', 'primary|mds', '0');

INSERT INTO `structures` (`alias`) VALUES ('dx_tfri_aml');
INSERT INTO `structures` (`alias`) VALUES ('dx_tfri_mds');

CREATE TABLE `dxd_tfri_aml` (
  `tfri_aml_recurrent_genetic` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_aml_aml_not_otherwise_categorized` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_aml_ambiguous_lineage` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_aml_b_lymphoblastic` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_aml_myeloid_proliferations` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_t_lymphoblastic` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_aml_transform_mds_mdp` VARCHAR(10) NULL DEFAULT NULL,
  `tfri_other_diagnosis` VARCHAR(255) NULL DEFAULT NULL,	
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dxd_tfri_aml_revs` (
  `tfri_aml_recurrent_genetic` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_aml_aml_not_otherwise_categorized` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_aml_ambiguous_lineage` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_aml_b_lymphoblastic` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_aml_myeloid_proliferations` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_t_lymphoblastic` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_aml_transform_mds_mdp` VARCHAR(10) NULL DEFAULT NULL,
  `tfri_other_diagnosis` VARCHAR(255) NULL DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dxd_tfri_mds` (
  `tfri_myelodysplastic_subtype` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_other_diagnosis` VARCHAR(255) NULL DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dxd_tfri_mds_revs` (
  `tfri_myelodysplastic_subtype` VARCHAR(255) NULL DEFAULT NULL,
  `tfri_other_diagnosis` VARCHAR(255) NULL DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Move notes field
UPDATE structure_fields SET  `setting`='cols=35,rows=6',  `language_help`='help_memo' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='notes' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='99', `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Diable primary common fields
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- MDS Form
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("mds_sub_type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("refractory anemia with unilineage dysplasia", "refractory anemia with unilineage dysplasia");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="refractory anemia with unilineage dysplasia" AND language_alias="refractory anemia with unilineage dysplasia"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("refractory anemia with ring sideroblasts", "refractory anemia with ring sideroblasts");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="refractory anemia with ring sideroblasts" AND language_alias="refractory anemia with ring sideroblasts"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("refractory cytopenia with multilineage dysplasia", "refractory cytopenia with multilineage dysplasia");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="refractory cytopenia with multilineage dysplasia" AND language_alias="refractory cytopenia with multilineage dysplasia"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("refractory anemia with excess blasts-1", "refractory anemia with excess blasts-1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="refractory anemia with excess blasts-1" AND language_alias="refractory anemia with excess blasts-1"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("refractory anemia with excess blasts-2", "refractory anemia with excess blasts-2");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="refractory anemia with excess blasts-2" AND language_alias="refractory anemia with excess blasts-2"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("myelodysplastic syndrome - unclassified", "myelodysplastic syndrome - unclassified");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="mds_sub_type"), (SELECT id FROM structure_permissible_values WHERE value="myelodysplastic syndrome - unclassified" AND language_alias="myelodysplastic syndrome - unclassified"), "6", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_tfri_mds', 'tfri_myelodysplastic_subtype', 'select',  (select `id` from `structure_value_domains` where `domain_name` = 'mds_sub_type') , '0', '', '', '', 'tfri myelodysplastic subtype', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_tfri_mds'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tfri_mds' AND `field`='tfri_myelodysplastic_subtype' AND `type`='select' AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tfri myelodysplastic subtype' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- AML Form

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
  ('AML', 'AML', ''),
  ('MDS', 'MDS', ''),
  ('tfri myelodysplastic subtype', 'Myelodysplastic Syndrome (MDS) Subtype', '');