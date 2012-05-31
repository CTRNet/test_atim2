-- NPTTB Custom Script
-- Version: v0.1
-- ATiM Version: v2.4.3A

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'Clark H. Smith NPTTB - v0.1 DEV', '');
	
-- Activate base users for demo
UPDATE `users` SET `flag_active`=1 WHERE `id`='1';
UPDATE `users` SET `flag_active`=1 WHERE `id`='2';
UPDATE `users` SET `flag_active`=1 WHERE `id`='3';

-- =============================================================================== -- 
-- 								MENUS
-- =============================================================================== --

-- Disable reproductive history, screening, study and lifestyle

UPDATE `menus` SET `flag_active`=0 WHERE `id`='clin_CAN_68';
UPDATE `menus` SET `flag_active`=0 WHERE `id`='clin_CAN_30';
UPDATE `menus` SET `flag_active`=0 WHERE `id`='clin_CAN_27';
UPDATE `menus` SET `flag_active`=0 WHERE `id`='tool_CAN_100';

-- =============================================================================== -- 
-- 								CLINICAL:Profile
-- =============================================================================== --

-- Language Updates
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('npttb error participant identifier', 'Participant Identifier must be two uppercase letters, followed by 4 integer values.', '');

-- Hide un-needed fields
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sex') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='race') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Move date of death to column 1
UPDATE structure_formats SET `display_column`='1', `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Participant Identifer validation rule. Max 6 characters, 2 letter, 4 number

INSERT INTO structure_validations(`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
((SELECT id FROM structure_fields where field = 'participant_identifier' and plugin = 'Clinicalannotation' AND tablename = 'participants'), '/^[A-Z][A-Z][0-9][0-9][0-9][0-9]$/', '', 'npttb error participant identifier' );

-- ===============================================================================
-- 								CONSENT
-- ===============================================================================

-- Language Updates
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('npttb baker v2 25-mar-2003', 'NPTTB - Baker v2 (25-Mar-2003)', ''),
	('npttb baker v3 15-oct-2007', 'NPTTB - Baker v3 (15-Oct-2007)', ''),
	('npttb consent brain bank', 'NPTTB - Brain Bank', ''),
	('npttb autopsy', 'NPTTB - Autopsy', ''),
	('npttb sno calgary', 'NPTTB - SNO Calgary', ''),
	('npttb further contact', 'Further Information', ''),
	('npttb full name', 'Full Name', ''),
	('npttb relationship', 'Relationship', ''),
	('npttb contact details', 'Contact Details', ''),
	('npttb consent responses', 'Consent Responses', ''),
	('npttb contact future v2', '2 - Future Contact', ''),
	('npttb genetic research v2', '1 - Conduct Genetic Tests', ''),
	('npttb contact family v2', '3 - Contact Family', ''),
	('npttb share other centres v2', '4 - Share Tissue/Information Others Centres', ''),
	('npttb use tissue other v2', '5 - Use Tissue Other Diseases', ''),
	('npttb share other disease v2', '6 - Share Tissue/Information Research Other', ''),
	('npttb provide family v2', '7 - Provide Tissue Family', ''),
	('npttb list desires constraints v2', '8 - List Desires or Constraints', ''),
	('npttb conduct genetic', '1 - Conduct Genetic Research', ''),
	('npttb conduct genetic other', '2 - Conduct Research Other Diesease', ''),
	('npttb share other researchers', '3 - Share Information Other Researcher', ''),
	('npttb share other diseases', '4 - Share Information Other Researcher and Disease', ''),
	('npttb contact family', '5 - Contact Family', ''),
	('npttb provide family tissue', '6 - Provide Tissue for Family Research', ''),
	('consent person', 'Consent Person', ''),
	('npttb list wishes restrictions', '7 - List Wishes or Restrictions', ''),
	('npttb help npttb_2_conduct_genetic_other', 'Conduct genetic research with your DNA and/or tissue and review your health records for research on disorders other than brain tumours at one of the University of Calgary affiliated teaching institutions while maintaining your confidentiality', ''),
	('npttb help npttb_1_conduct_genetic', 'Conduct genetic research with your DNA and/or tissue, and review your health records for research on brain tumours at one of the University of Calgary affiliated teaching institutions while maintaining your confidentiality', ''),
	('npttb help npttb_3_share_other_researchers', 'Share your DNA and/or tissue and your relevant health information with other researchers for research in brain tumours while maintaining your confidentiality', ''),
	('npttb help npttb_4_share_other_diseases', 'Share your DNA and/or tissue and your relevant health information with other researchers for research on disorders other than yours, while maintaining your confidentiality', ''),
	('npttb help npttb_5_contact_family', 'Contact a family member in the future for research purposes if you are unavailable or unable to do so', ''),
	('npttb help npttb_6_provide_family_tissue', 'Provide tissue for use by other family members if they require it to do their own genetic studies', ''),
	('npttb help npttb_7_list_wishes_restrictions', 'List any other specific wishes or restrictions you have regarding the use of your tissue or records. Be as specific as possible. You may wish to discuss this with Drs. Forsyth or Hamilton', ''),
	('npttb help npttb_2_contact_future', 'Contact you in the future for research purposes', ''),
	('npttb help npttb_1_genetic_research', 'Conduct genetic tests for research purposes', ''),
	('npttb help npttb_3_contact_family', 'Contact a family member in the future for research purposes if you are unavailable or unable to', ''),
	('npttb help npttb_4_share_other_centres', 'Share tissue and some clinical information with other centres for research on diseases other than brain tumors while maintaining your confidentiality', ''),
	('npttb help npttb_5_use_tissue_other', 'Use the tissue for research on diseases other than brain tumors', ''),
	('npttb help npttb_6_share_other_disease', 'Share tissue and some clinical information (maintaining your confidentiality) for research on diseases other than brain tumors', ''),
	('npttb help npttb_7_provide_family', 'Provide tissue for use by other family members if they need it to do their own genetic studies', ''),
	('npttb help npttb_8_list_desires_constraints', 'List and specific desires or constraints you have regarding the use of your tissue or records (be specific as possible)', ''),
	('npttb brain store samples medical', 'Store Samples and Health Information', ''),
	('npttb brain conduct research', 'Conduct Research', ''),
	('npttb brain share samples healthinfo', 'Share Samples and Health Information', ''),
	('npttb help npttb_1_store_samples_medical', 'Collect and store your samples as described (tissue, blood, urine, spinal fluid and/or bone marrow as applicable), and review your health records for research at University of Calgary affiliated institutions while maintaining your confidentiality', ''),
	('npttb help npttb_2_conduct_research', 'Conduct research with your samples while maintaining your confidentiality. Such research always requires prior review by the Research Ethics Board', ''),
	('npttb help npttb_3_share_samples_healthinfo', 'Share your samples and relevant health information with other researchers while maintaining  your confidentiality', ''),
	('npttb brain contact name', 'Contact Name', ''),
	('npttb brain contact relationship', 'Relationship', ''),
	('npttb brain contact details', 'Contact Details', ''),
	('npttb help npttb_4_contact_name', 'Enter name of family member or representative', ''),
	('npttb help npttb_4_contact_relationship', 'Enter relationship to the contact', ''),
	('npttb help npttb_4_contact_details', 'Enter contact information', '');
	
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('npttb part 2 autopsy consent', 'Part II - Consent for Autopsy', ''),
	('npttb part 3 retention', 'Part III - Consent Retention of Organs/Tissue for Research', ''),
	('npttb autopsy consent', 'Permission For', ''),
	('npttb autopsy consent instructions', 'Specify Limitations', ''),
	('npttb autopsy retention', 'Consent for Education/Research', ''),
	('npttb autopsy retention instructions', 'Special Instructions or Limitations', ''),
	('npttb complete', 'Complete', ''),
	('npttb limited', 'Limited', ''),
	('npttb help autopsy consent', 'Indicate autopsy type permission was given for', ''),
	('npttb help autopsy instructions', 'If limited autopsy, specify limitations', ''),
	('npttb help autopsy retention', 'Indicate if consent given for research', ''),
	('npttb help retention instructions', 'Specify any special instructions or limitations', '');
	
REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('npttb form type', 'Form Type', ''),
	('npttb main', 'Main', ''),
	('npttb pediatric', 'Pediatric', ''),
	('npttb surrogate', 'Surrogate', ''),
	('npttb help form type', 'Indicate the type of form', '');				
	
	
-- Disable default consent form
UPDATE `consent_controls` SET `flag_active`=0 WHERE `controls_type` = 'Consent National';

-- Add control rows for bank consent forms
INSERT INTO `consent_controls` (`controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('npttb baker v2 25-mar-2003', 1, 'consent_masters,cd_npttb_consent_baker_v2', 'cd_npttb_consent_baker_v2', 3, 'npttb consent baker v2'),
('npttb baker v3 15-oct-2007', 1, 'consent_masters,cd_npttb_consent_baker_v3', 'cd_npttb_consent_baker_v3', 4, 'npttb consent baker v3'),
('npttb consent brain bank', 1, 'consent_masters,cd_npttb_consent_brain_bank', 'cd_npttb_consent_brain_bank', 5, 'npttb consent brain bank'),
('npttb autopsy', 1, 'consent_masters,cd_npttb_autopsy', 'cd_npttb_autopsy', 1, 'npttb consent autopsy'),
('npttb sno calgary', 1, 'consent_masters,cd_npttb_consent_sno_calgary', 'cd_npttb_consent_sno_calgary', 2, 'npttb consent sno calgary');

-- Structures
INSERT INTO `structures` (`alias`) VALUES ('cd_npttb_consent_baker_v2');
INSERT INTO `structures` (`alias`) VALUES ('cd_npttb_consent_baker_v3');
INSERT INTO `structures` (`alias`) VALUES ('cd_npttb_consent_brain_bank');
INSERT INTO `structures` (`alias`) VALUES ('cd_npttb_autopsy');
INSERT INTO `structures` (`alias`) VALUES ('cd_npttb_consent_sno_calgary');

-- Detail Tables Baker v2
CREATE TABLE `cd_npttb_consent_baker_v2` (
  `id` INT NOT NULL ,
  `npttb_1_genetic_research` VARCHAR(10) DEFAULT '' ,
  `npttb_2_contact_future` VARCHAR(10) DEFAULT '' ,
  `npttb_3_contact_family` VARCHAR(10) DEFAULT '' ,
  `npttb_4_share_other_centres` VARCHAR(10) DEFAULT '' ,
  `npttb_5_use_tissue_other` VARCHAR(10) DEFAULT '' ,
  `npttb_6_share_other_disease` VARCHAR(10) DEFAULT '' ,
  `npttb_7_provide_family` VARCHAR(10) DEFAULT '' ,
  `npttb_8_list_desires_constraints` VARCHAR(255) DEFAULT '' ,
  `consent_master_id` INT(11) NOT NULL ,
  `deleted` TINYINT(3) DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE TABLE `cd_npttb_consent_baker_v2_revs` (
  `id` INT(11) NOT NULL ,
  `npttb_1_genetic_research` VARCHAR(10) DEFAULT '' ,
  `npttb_2_contact_future` VARCHAR(10) DEFAULT '' ,
  `npttb_3_contact_family` VARCHAR(10) DEFAULT '' ,
  `npttb_4_share_other_centres` VARCHAR(10) DEFAULT '' ,
  `npttb_5_use_tissue_other` VARCHAR(10) DEFAULT '' ,
  `npttb_6_share_other_disease` VARCHAR(10) DEFAULT '' ,
  `npttb_7_provide_family` VARCHAR(10) DEFAULT '' ,
  `npttb_8_list_desires_constraints` VARCHAR(255) DEFAULT '' ,
  `consent_master_id` INT(11) NOT NULL ,
  `version_id` INT(11) DEFAULT 0 ,
  `version_created` DATETIME NOT NULL,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB;

-- Detail Tables Baker v3
CREATE TABLE `cd_npttb_consent_baker_v3` (
  `id` INT NOT NULL ,
  `npttb_1_conduct_genetic` VARCHAR(10) DEFAULT '' ,
  `npttb_2_conduct_genetic_other` VARCHAR(10) DEFAULT '' ,
  `npttb_3_share_other_researchers` VARCHAR(10) DEFAULT '' ,
  `npttb_4_share_other_diseases` VARCHAR(10) DEFAULT '' ,
  `npttb_5_contact_family` VARCHAR(10) DEFAULT '' ,
  `npttb_6_provide_family_tissue` VARCHAR(10) DEFAULT '' ,
  `npttb_7_list_wishes_restrictions` VARCHAR(255) DEFAULT '' ,
  `consent_master_id` INT(11) NOT NULL ,
  `deleted` TINYINT(3) DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE TABLE `cd_npttb_consent_baker_v3_revs` (
  `id` INT(11) NOT NULL ,
  `npttb_1_conduct_genetic` VARCHAR(10) DEFAULT '' ,
  `npttb_2_conduct_genetic_other` VARCHAR(10) DEFAULT '' ,
  `npttb_3_share_other_researchers` VARCHAR(10) DEFAULT '' ,
  `npttb_4_share_other_diseases` VARCHAR(10) DEFAULT '' ,
  `npttb_5_contact_family` VARCHAR(10) DEFAULT '' ,
  `npttb_6_provide_family_tissue` VARCHAR(10) DEFAULT '' ,
  `npttb_7_list_wishes_restrictions` VARCHAR(255) DEFAULT '' ,
  `consent_master_id` INT(11) NOT NULL ,
  `version_id` INT(11) DEFAULT 0 ,
  `version_created` DATETIME NOT NULL,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB;


-- Detail Tables Clark
CREATE TABLE `cd_npttb_consent_brain_bank` (
  `id` INT NOT NULL ,
  `npttb_1_store_samples_medical` VARCHAR(10) DEFAULT '' ,
  `npttb_2_conduct_research` VARCHAR(10) DEFAULT '' ,
  `npttb_3_share_samples_healthinfo` VARCHAR(10) DEFAULT '' ,
  `npttb_4_contact_name` VARCHAR(100) NULL ,
  `npttb_4_contact_relationship` VARCHAR(100) NULL ,
  `npttb_4_contact_details` TEXT NULL ,
  `npttb_form_type` VARCHAR(45) NULL,
  `consent_master_id` INT(11) NOT NULL ,
  `deleted` TINYINT(3) DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE TABLE `cd_npttb_consent_brain_bank_revs` (
  `id` INT(11) NOT NULL ,
  `npttb_1_store_samples_medical` VARCHAR(10) DEFAULT '' ,
  `npttb_2_conduct_research` VARCHAR(10) DEFAULT '' ,
  `npttb_3_share_samples_healthinfo` VARCHAR(10) DEFAULT '' ,
  `npttb_4_contact_name` VARCHAR(100) NULL ,
  `npttb_4_contact_relationship` VARCHAR(100) NULL ,
  `npttb_4_contact_details` TEXT NULL ,
  `npttb_form_type` VARCHAR(45) NULL,
  `consent_master_id` INT(11) NOT NULL ,
  `version_id` INT(11) DEFAULT 0 ,
  `version_created` DATETIME NOT NULL,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB;

-- Autopsy Consent
CREATE TABLE `cd_npttb_autopsy` (
  `id` INT NOT NULL ,
  `npttb_autopsy_consent` VARCHAR(10) DEFAULT '',
  `npttb_autopsy_consent_instructions` VARCHAR(255) DEFAULT '',
  `npttb_autopsy_retention` VARCHAR(10) DEFAULT '',
  `npttb_autopsy_retention_instructions` VARCHAR(255) DEFAULT '',	
  `consent_master_id` INT(11) NOT NULL ,
  `deleted` TINYINT(3) DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE TABLE `cd_npttb_autopsy_revs` (
  `id` INT(11) NOT NULL ,
  `npttb_autopsy_consent` VARCHAR(10) DEFAULT '',
  `npttb_autopsy_consent_instructions` VARCHAR(255) DEFAULT '',
  `npttb_autopsy_retention` VARCHAR(10) DEFAULT '',
  `npttb_autopsy_retention_instructions` VARCHAR(255) DEFAULT '',
  `consent_master_id` INT(11) NOT NULL ,
  `version_id` INT(11) DEFAULT 0 ,
  `version_created` DATETIME NOT NULL,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB;

-- SNO Calgary Consent
CREATE TABLE `cd_npttb_consent_sno_calgary` (
  `id` INT NOT NULL ,
  `npttb_1_conduct_genetic` VARCHAR(10) DEFAULT '' ,
  `npttb_2_conduct_genetic_mgmt` VARCHAR(10) DEFAULT '' ,
  `npttb_3_conduct_genetic_other_disorders` VARCHAR(10) DEFAULT '' ,
  `npttb_4_share_material_information` VARCHAR(10) DEFAULT '' ,
  `npttb_5_share_material_information_other` VARCHAR(10) DEFAULT '' ,
  `npttb_6_contact_family` VARCHAR(10) DEFAULT '' ,
  `npttb_7_provide_other_family` VARCHAR(10) DEFAULT '' ,
  `npttb_8_list_wishes_restrictions` VARCHAR(255) DEFAULT '' ,
  `consent_master_id` INT(11) NOT NULL ,
  `deleted` TINYINT(3) DEFAULT 0 ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE TABLE `cd_npttb_consent_sno_calgary_revs` (
  `id` INT(11) NOT NULL ,
  `npttb_1_conduct_genetic` VARCHAR(10) DEFAULT '' ,
  `npttb_2_conduct_genetic_mgmt` VARCHAR(10) DEFAULT '' ,
  `npttb_3_conduct_genetic_other_disorders` VARCHAR(10) DEFAULT '' ,
  `npttb_4_share_material_information` VARCHAR(10) DEFAULT '' ,
  `npttb_5_share_material_information_other` VARCHAR(10) DEFAULT '' ,
  `npttb_6_contact_family` VARCHAR(10) DEFAULT '' ,
  `npttb_7_provide_other_family` VARCHAR(10) DEFAULT '' ,
  `npttb_8_list_wishes_restrictions` VARCHAR(255) DEFAULT '' ,
  `consent_master_id` INT(11) NOT NULL ,
  `version_id` INT(11) DEFAULT 0 ,
  `version_created` DATETIME NOT NULL,
  PRIMARY KEY (`version_id`) )
ENGINE = InnoDB;

-- Value domain for form type
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_form_type", "", "", "");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("main", "npttb main");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_form_type"), (SELECT id FROM structure_permissible_values WHERE value="main" AND language_alias="npttb main"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("pediatric", "npttb pediatric");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_form_type"), (SELECT id FROM structure_permissible_values WHERE value="pediatric" AND language_alias="npttb pediatric"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("surrogate", "npttb surrogate");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_form_type"), (SELECT id FROM structure_permissible_values WHERE value="surrogate" AND language_alias="npttb surrogate"), "3", "1");


-- Add Surgeon/Operation Datetime to master form
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='surgeon' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '22', '', '0', '', '0', '', '1', '', '0', '', '1', 'size=40', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='operation_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '23', '', '0', '', '1', '', '1', '', '0', '', '0', '', '1', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_person' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '12', '', '1', 'consent person', '1', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- Build detail form baker v2
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v2', 'npttb_2_contact_future', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_2_contact_future', 'npttb contact future v2', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v2', 'npttb_1_genetic_research', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_1_genetic_research', 'npttb genetic research v2', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v2', 'npttb_3_contact_family', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_3_contact_family', 'npttb contact family v2', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v2', 'npttb_4_share_other_centres', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_4_share_other_centres', 'npttb share other centres v2', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v2', 'npttb_5_use_tissue_other', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_5_use_tissue_other', 'npttb use tissue other v2', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v2', 'npttb_6_share_other_disease', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_6_share_other_disease', 'npttb share other disease v2', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v2', 'npttb_7_provide_family', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_7_provide_family', 'npttb provide family v2', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v2', 'npttb_8_list_desires_constraints', 'textarea',  NULL , '0', '', '', 'npttb help npttb_8_list_desires_constraints', 'npttb list desires constraints v2', '');


INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v2' AND `field`='npttb_2_contact_future' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb contact future v2' AND `language_tag`=''), '2', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v2' AND `field`='npttb_1_genetic_research' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb genetic research v2' AND `language_tag`=''), '2', '50', 'npttb consent responses', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v2' AND `field`='npttb_3_contact_family' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb contact family v2' AND `language_tag`=''), '2', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v2' AND `field`='npttb_4_share_other_centres' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb share other centres v2' AND `language_tag`=''), '2', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v2' AND `field`='npttb_5_use_tissue_other' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb use tissue other v2' AND `language_tag`=''), '2', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v2' AND `field`='npttb_6_share_other_disease' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb share other disease v2' AND `language_tag`=''), '2', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v2' AND `field`='npttb_7_provide_family' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb provide family v2' AND `language_tag`=''), '2', '106', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v2'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v2' AND `field`='npttb_8_list_desires_constraints' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb list desires constraints v2' AND `language_tag`=''), '2', '107', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- Build detail form baker v3
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v3', 'npttb_2_conduct_genetic_other', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_2_conduct_genetic_other', 'npttb conduct genetic other', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v3', 'npttb_1_conduct_genetic', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_1_conduct_genetic', 'npttb conduct genetic', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v3', 'npttb_3_share_other_researchers', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_3_share_other_researchers', 'npttb share other researchers', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v3', 'npttb_4_share_other_diseases', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_4_share_other_diseases', 'npttb share other diseases', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v3', 'npttb_5_contact_family', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_5_contact_family', 'npttb contact family', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v3', 'npttb_6_provide_family_tissue', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_6_provide_family_tissue', 'npttb provide family tissue', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_baker_v3', 'npttb_7_list_wishes_restrictions', 'textarea',  NULL , '0', '', '', 'npttb help npttb_7_list_wishes_restrictions', 'npttb list wishes restrictions', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v3' AND `field`='npttb_2_conduct_genetic_other' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb conduct genetic other' AND `language_tag`=''), '2', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v3' AND `field`='npttb_1_conduct_genetic' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb conduct genetic' AND `language_tag`=''), '2', '100', 'npttb consent responses', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v3' AND `field`='npttb_3_share_other_researchers' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb share other researchers' AND `language_tag`=''), '2', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v3' AND `field`='npttb_4_share_other_diseases' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb share other diseases' AND `language_tag`=''), '2', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v3' AND `field`='npttb_5_contact_family' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb contact family' AND `language_tag`=''), '2', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v3' AND `field`='npttb_6_provide_family_tissue' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb provide family tissue' AND `language_tag`=''), '2', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_baker_v3'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_baker_v3' AND `field`='npttb_7_list_wishes_restrictions' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_label`='npttb list wishes restrictions' AND `language_tag`=''), '2', '107', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- Build Brain Bank consent form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_1_store_samples_medical', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_1_store_samples_medical', 'npttb brain store samples medical', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_2_conduct_research', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_2_conduct_research', 'npttb brain conduct research', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_3_share_samples_healthinfo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help npttb_3_share_samples_healthinfo', 'npttb brain share samples healthinfo', ''),
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_4_contact_name', 'input', NULL , '0', 'size=20', '', 'npttb help npttb_4_contact_name', 'npttb brain contact name', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_4_contact_relationship', 'input', NULL , '0', 'size=20', '', 'npttb help npttb_4_contact_relationship', 'npttb brain contact relationship', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_4_contact_details', 'textarea', NULL , '0', '', '', 'npttb help npttb_4_contact_details', 'npttb brain contact details', ''),
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_brain_bank', 'npttb_form_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_form_type') , '0', '', '', 'npttb help form type', 'npttb form type', ''); 


-- Link to form
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_1_store_samples_medical' AND `type`='select' AND `language_label`='npttb brain store samples medical'), '2', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_2_conduct_research' AND `type`='select' AND `language_label`='npttb brain conduct research'), '2', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_3_share_samples_healthinfo' AND `type`='select' AND `language_label`='npttb brain share samples healthinfo'), '2', '110', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_4_contact_name' AND `type`='input' AND `language_label`='npttb brain contact name'), '2', '115', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_4_contact_relationship' AND `type`='input' AND `language_label`='npttb brain contact relationship'), '2', '120', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_4_contact_details' AND `type`='textarea' AND `language_label`='npttb brain contact details'), '2', '125', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='cd_npttb_consent_brain_bank'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_brain_bank' AND `field`='npttb_form_type' AND `type`='select' AND `language_label`='npttb form type'), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- Custom lookup values for form version
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'consent form versions'), 'autopsy', 'Autopsy', '', 1, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'consent form versions'), 'sno calgary', 'SNO Calgary', '', 2, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'consent form versions'), 'baker v2 25-mar-2003', 'Baker v2 25-Mar-2003', '', 3, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'consent form versions'), 'baker v3 15-oct-2007', 'Baker v3 15-Oct-2007', '', 4, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'consent form versions'), 'v1.0 aug-5-2008', 'v1.0 Aug-5-2008', '', 5, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'consent form versions'), 'v2.0 nov-19-2010', 'v2.0 Nov-19-2010', '', 6, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'consent form versions'), 'v3.0 may-6-2011', 'v3.0 May-6-2011', '', 7, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'consent form versions'), 'v4.0 nov-21-2011', 'v4.0 Nov-21-2011', '', 8, 1);

-- Custom lookup for person consenting
INSERT INTO `structure_value_domains` (`domain_name`, `source`) VALUES
('custom_npttb_person_consenting', 'StructurePermissibleValuesCustom::getCustomDropdown(\'npttb person consenting\')');

INSERT INTO `structure_permissible_values_custom_controls` (`name`, `flag_active`, `values_max_length`) VALUES ('npttb person consenting', 1, 50);

-- Active delegates
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'autopsy', 'Autopsy', '', 1, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'colleen anderson', 'Colleen Anderson', '', 2, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'crystal tellett', 'Crystal Tellett', '', 3, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'karen mazil', 'Karen Mazil', '', 4, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'kelly bullivant', 'Kelly Bullivant', '', 5, 1);

-- Past delegates
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'annabelle', 'Annabelle', '', 90, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'carla', 'Carla', '', 91, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'errin', 'Errin', '', 92, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'maddy', 'Maddy', '', 93, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'martin', 'Martin', '', 94, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'jane', 'Jane', '', 95, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'sherri', 'Sherri', '', 96, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'ruxandra', 'Ruxandra', '', 97, 0);

-- Infrequent
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr algiraigri', 'Dr. Algiraigri', '', 20, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr beaudry', 'Dr. Beaudry', '', 21, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr gulcher', 'Dr. Gulcher', '', 22, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr hader', 'Dr. Hader', '', 23, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr hamilton', 'Dr. Hamilton', '', 24, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr kelly', 'Dr. Kelly', '', 25, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr lafay-cousin', 'Dr. Lafay-Cousin', '', 26, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr steele', 'Dr. Steele', '', 27, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr strother', 'Dr. Strother', '', 28, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr truong', 'Dr. Truong', '', 29, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'dr wright', 'Dr. Wright', '', 30, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb person consenting'), 'gurpreet singh', 'Gurpreet Singh', '', 31, 1);

UPDATE `structure_fields` SET `structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE domain_name = 'custom_npttb_person_consenting') WHERE tablename = 'consent_masters' AND `field` = 'consent_person';

-- Custom lookup for surgeon
INSERT INTO `structure_value_domains` (`domain_name`, `source`) VALUES
('custom_npttb_surgeon', 'StructurePermissibleValuesCustom::getCustomDropdown(\'npttb surgeon\')');

INSERT INTO `structure_permissible_values_custom_controls` (`name`, `flag_active`, `values_max_length`) VALUES ('npttb surgeon', 1, 50);

UPDATE `structure_fields` SET `structure_value_domain` = (SELECT `id` FROM `structure_value_domains` WHERE `domain_name` = 'custom_npttb_surgeon') WHERE tablename = 'consent_masters' AND `field` = 'surgeon';
UPDATE `structure_fields` SET `type` = 'select', `setting` = '' WHERE tablename = 'consent_masters' AND `field` = 'surgeon';

UPDATE structure_formats SET `flag_override_setting`='0', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='surgeon' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_npttb_surgeon') AND `flag_confidential`='0');

-- Main list
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr beaudry', 'Dr. Beaudry', '', 1, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr gallagher', 'Dr. Gallagher', '', 2, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr hader', 'Dr. Hader', '', 3, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr hamilton', 'Dr. Hamilton', '', 4, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr starreveld', 'Dr. Starreveld', '', 5, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr sutherland', 'Dr. Sutherland', '', 6, 1);

-- Occasional list
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr algiraigri', 'Dr. Algiraigri', '', 20, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr amendy', 'Dr. Amendy', '', 21, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr anderson', 'Dr. Anderson', '', 22, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr brauer', 'Dr. Brauer', '', 23, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr eccles', 'Dr. Eccles', '', 24, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr gelfand', 'Dr. Gelfand', '', 25, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr guilcher', 'Dr. Guilcher', '', 26, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr jacobs', 'Dr. Jacobs', '', 27, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr kiefer', 'Dr. Kiefer', '', 28, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr kiss', 'Dr. Kiss', '', 29, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr lafay-cousin', 'Dr. Lafay-Cousin', '', 30, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr lewis', 'Dr. Lewis', '', 31, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr lwu', 'Dr. Lwu', '', 32, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr midha', 'Dr. Midha', '', 33, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr park', 'Dr. Park', '', 34, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr puloski', 'Dr. Puloski', '', 35, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr siglet', 'Dr. Siglet', '', 36, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr steele', 'Dr. Steele', '', 37, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr truong', 'Dr. Truong', '', 38, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr wong', 'Dr. Wong', '', 39, 1),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr wright', 'Dr. Wright', '', 40, 1);

-- Past list
INSERT INTO `structure_permissible_values_customs` (`control_id`,`value`,`en`,`fr`,`display_order`,`use_as_input`) VALUES
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr alant', 'Dr. Alant', '', 88, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr bacchus', 'Dr. Bacchus', '', 89, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr brindle', 'Dr. Brindle', '', 90, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr cenic', 'Dr. Cenic', '', 91, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr du plessis', 'Dr. Du Plessis', '', 92, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr hurlbert', 'Dr. Hurlbert', '', 93, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr louw', 'Dr. Louw', '', 94, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr macrae', 'Dr. MacRae', '', 95, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr macdougall', 'Dr. MacDougall', '', 96, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr myles', 'Dr. Myles', '', 97, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr omahen', 'Dr. Omahen', '', 98, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr parney', 'Dr. Parney', '', 99, 0),
((SELECT `id` FROM `structure_permissible_values_custom_controls` WHERE `name` = 'npttb surgeon'), 'dr yeung', 'Dr. Yeung', '', 100, 0);

-- Value domain for Autopsy Form
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("npttb_autopsy_consent", "", "", "");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("complete", "npttb complete");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_autopsy_consent"), (SELECT id FROM structure_permissible_values WHERE value="complete" AND language_alias="npttb complete"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("limited", "npttb limited");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_autopsy_consent"), (SELECT id FROM structure_permissible_values WHERE value="limited" AND language_alias="npttb limited"), "2", "1");

-- Build autopsy form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_autopsy', 'npttb_autopsy_consent', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_autopsy_consent') , '0', '', '', 'npttb help autopsy consent', 'npttb autopsy consent', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_autopsy', 'npttb_autopsy_consent_instructions', 'textarea',  NULL , '0', '', '', 'npttb help autopsy instructions', 'npttb autopsy consent instructions', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_autopsy', 'npttb_autopsy_retention', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help autopsy retention', 'npttb autopsy retention', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_autopsy', 'npttb_autopsy_retention_instructions', 'textarea',  NULL , '0', '', '', 'npttb help retention instructions', 'npttb autopsy retention instructions', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_npttb_autopsy'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_autopsy' AND `field`='npttb_autopsy_consent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_autopsy_consent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help autopsy consent' AND `language_label`='npttb autopsy consent' AND `language_tag`=''), '2', '1', 'npttb part 2 autopsy consent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_autopsy'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_autopsy' AND `field`='npttb_autopsy_consent_instructions' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help autopsy instructions' AND `language_label`='npttb autopsy consent instructions' AND `language_tag`=''), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_autopsy'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_autopsy' AND `field`='npttb_autopsy_retention' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help autopsy retention' AND `language_label`='npttb autopsy retention' AND `language_tag`=''), '2', '3', 'npttb part 3 retention', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_autopsy'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_autopsy' AND `field`='npttb_autopsy_retention_instructions' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help retention instructions' AND `language_label`='npttb autopsy retention instructions' AND `language_tag`=''), '2', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
		
-- Build SNO form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_sno_calgary', 'npttb_1_conduct_genetic', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help 1 conduct genetic', 'npttb 1 conduct genetic', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_sno_calgary', 'npttb_2_conduct_genetic_mgmt', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help 2 conduct genetic mgmt', 'npttb 2 conduct genetic mgmt', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_sno_calgary', 'npttb_3_conduct_genetic_other_disorders', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help 3 conduct genetic other disorders', 'npttb 3 conduct genetic other disorders', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_sno_calgary', 'npttb_4_share_material_information', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help 4 share material information', 'npttb 4 share material information', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_sno_calgary', 'npttb_5_share_material_information_other', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help 5 share material information other', 'npttb 5 share material information other', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_sno_calgary', 'npttb_6_contact_family', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help 6 contact family', 'npttb 6 contact family', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_sno_calgary', 'npttb_7_provide_other_family', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', 'npttb help 7 provide other family', 'npttb 7 provide other family', ''), 
('Clinicalannotation', 'ConsentDetail', 'cd_npttb_consent_sno_calgary', 'npttb_8_list_wishes_restrictions', 'textarea',  NULL , '0', '', '', 'npttb help 8 list wishes restrictions', 'npttb 8 list wishes restrictions', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_sno_calgary'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_sno_calgary' AND `field`='npttb_1_conduct_genetic' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help 1 conduct genetic' AND `language_label`='npttb 1 conduct genetic' AND `language_tag`=''), '2', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_sno_calgary'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_sno_calgary' AND `field`='npttb_2_conduct_genetic_mgmt' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help 2 conduct genetic mgmt' AND `language_label`='npttb 2 conduct genetic mgmt' AND `language_tag`=''), '2', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_sno_calgary'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_sno_calgary' AND `field`='npttb_3_conduct_genetic_other_disorders' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help 3 conduct genetic other disorders' AND `language_label`='npttb 3 conduct genetic other disorders' AND `language_tag`=''), '2', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_sno_calgary'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_sno_calgary' AND `field`='npttb_4_share_material_information' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help 4 share material information' AND `language_label`='npttb 4 share material information' AND `language_tag`=''), '2', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_sno_calgary'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_sno_calgary' AND `field`='npttb_5_share_material_information_other' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help 5 share material information other' AND `language_label`='npttb 5 share material information other' AND `language_tag`=''), '2', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_sno_calgary'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_sno_calgary' AND `field`='npttb_6_contact_family' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help 6 contact family' AND `language_label`='npttb 6 contact family' AND `language_tag`=''), '2', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_sno_calgary'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_sno_calgary' AND `field`='npttb_7_provide_other_family' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help 7 provide other family' AND `language_label`='npttb 7 provide other family' AND `language_tag`=''), '2', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='cd_npttb_consent_sno_calgary'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_npttb_consent_sno_calgary' AND `field`='npttb_8_list_wishes_restrictions' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='npttb help 8 list wishes restrictions' AND `language_label`='npttb 8 list wishes restrictions' AND `language_tag`=''), '2', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('npttb 1 conduct genetic', '1 - Conduct Genetic Research', ''),
	('npttb 2 conduct genetic mgmt', '2 - Conduct Genetic Research for MGMT', ''),
	('npttb 3 conduct genetic other disorders', '3 - Conduct Genetic Research Other Disorders', ''),
	('npttb 4 share material information', '4 - Share DNA and Health Info for Brain Research', ''),
	('npttb 5 share material information other', '5 - Share DNA and Health Info Other Disorders', ''),
	('npttb 6 contact family', '6 - Contact Family Member', ''),
	('npttb 7 provide other family', '7 - Provide Tissue for Family Use', ''),
	('npttb 8 list wishes restrictions', '8 - List Specific Wishes or Restrictions', ''),
	('npttb help 1 conduct genetic', 'Conduct genetic research with your DNA and/or tissue, and review your health records for research on brain tumours at one of the U of C affiliated teaching institutions while maintaining your confidentiality.', ''),
	('npttb help 2 conduct genetic mgmt', 'Conduct genetic research with your DNA for MGMT tissue analysis.', ''),
	('npttb help 3 conduct genetic other disorders', 'Conduct genetic research with your DNA and/or tissue and review your health records for research on disorders other than brain tumours at one of the U of C affiliated teaching institutions while maintaining your confidentiality.', ''),
	('npttb help 4 share material information', 'Share your DNA and/or tissue and your relevant health information with other researchers for research on disorders other than yours, while maintaining your confidentiality.', ''),
	('npttb help 5 share material information other', 'Share your DNA and/or tissue and your relevant health information with other researchers for research on disorders other than yours, while maintaining your confidentiality.', ''),
	('npttb help 6 contact family', 'Contact a family member in the future for research purposes if you are unavailable or unable to do so.', ''),
	('npttb help 7 provide other family', 'Provide tissue for use by other family members if they require it to do their own genetic studies.', ''),
	('npttb help 8 list wishes restrictions', 'List any specific wishes or restrictions you have regarding the use of your tissue or records. Be as specific as possible. You may wish to discuss this with Drs. Forsyth or Hamilton.', '');	
						


-- =============================================================================== -- 
-- 								Misc Identifiers
-- =============================================================================== --

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
	('Pathology Case Number', 'Pathology Case Number', ''),
	('npbttb Pathology Case Number validation error', 'Validation error - pathology case number must be AA DD-DDDDD', '');

-- Add control row for pathology case number
INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`) VALUES ('Pathology Case Number', 1, 1, 0, 0);
INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `display_order`, `flag_once_per_participant`, `flag_confidential`) VALUES ('TTB Number', 1, 2, 1, 0);

-- Disable dates
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- =============================================================================== -- 
-- 								CLINICAL:Treatment
-- =============================================================================== --

-- Surgery: Hide protocol and intent

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `flag_confidential`='0');

-- Increase size of pathology number
UPDATE structure_fields SET  `setting`='size=20' WHERE model='TreatmentDetail' AND tablename='txd_surgeries' AND field='path_num' AND `type`='input' AND structure_value_domain  IS NULL ;

-- Disable treatment types (Surgery without extend, chemo, radiotherapy)
UPDATE `treatment_controls` SET `flag_active`=0 WHERE `tx_method`='chemotherapy';
UPDATE `treatment_controls` SET `flag_active`=0 WHERE `tx_method`='radiation';
UPDATE `treatment_controls` SET `flag_active`=0 WHERE `tx_method`='surgery without extension';


-- =============================================================================== -- 
-- 								CLINICAL:Diagnosis
-- =============================================================================== --

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
 ('npttb tissue', 'NPTTB Tissue', ''),
 ('npttn ttb diagnosis', 'TTB Diagnosis', ''),
 ('npttb path final dx', 'Final Path Report', '');
 
REPLACE INTO `i18n` (`en`, `id`) VALUES
("Atypical Teratoid Rhabdoid Tumor", "npttb Atypical Teratoid Rhabdoid Tumor"),
("Astrocytoma, diffuse (II)", "npttb Astrocytoma, diffuse (II)"),
("Astrocytoma, anaplastic (III)", "npttb Astrocytoma, anaplastic (III)"),
("Astrocytoma, glioblastoma (IV)", "npttb Astrocytoma, glioblastoma (IV)"),
("Astrocytoma, glioblastoma (IV) with oligo component", "npttb Astrocytoma, glioblastoma (IV) with oligo component"),
("Astrocytoma, gliosarcoma (IV)", "npttb Astrocytoma, gliosarcoma (IV)"),
("Astrocytoma, giant cell glioblastoma (IV)", "npttb Astrocytoma, giant cell glioblastoma (IV)"),
("Astrocytoma, pilocytic (I)", "npttb Astrocytoma, pilocytic (I)"),
("Astrocytoma, pilomyxoid", "npttb Astrocytoma, pilomyxoid"),
("Astrocytoma with treatment effect", "npttb Astrocytoma with treatment effect"),
("Choriocarcinoma", "npttb Choriocarcinoma"), 
("Choroid Plexus Papilloma", "npttb Choroid Plexus Papilloma"),
("Choroid Plexus Carcinoma", "npttb Choroid Plexus Carcinoma"),
("Craniopharyngioma, Adamantinomatous", "npttb Craniopharyngioma, Adamantinomatous"),
("Craniopharyngioma, Papillary", "npttb Craniopharyngioma, Papillary"),
("Dysembyroplastic neuroepithalial tumor", "npttb Dysembyroplastic neuroepithalial tumor"),
("Embryonal Carcinoma", "npttb Embryonal Carcinoma"),
("Ependymoma (II)", "npttb Ependymoma (II)"),
("Ependymoma, anaplastic (III)","npttb Ependymoma, anaplastic (III)"),
("Ependymoma, myxopapillary","npttb Ependymoma, myxopapillary");

REPLACE INTO `i18n` (`en`, `id`) VALUES
("Gangliocytoma", "npttb Gangliocytoma"),
("Ganglioglioma", "npttb Ganglioglioma"),
("Germinoma", "npttb Germinoma"), 
("Glioma, brainstem", "npttb Glioma, brainstem"),
("Glioma, chordoid", "npttb Glioma, chordoid"),
("Glioma, not otherwise specified", "npttb Glioma, not otherwise specified"),
("Glioneuronal tumor, not otherwise specified", "npttb Glioneuronal tumor, not otherwise specified"),
("Hemangioblastoma", "npttb Hemangioblastoma"),
("Hemangiopericytoma, solitary fibrous tumor", "npttb Hemangiopericytoma, solitary fibrous tumor"),
("Malignant Peripheral Nerve Sheath Tumor", "npttb Malignant Peripheral Nerve Sheath Tumor"),
("Medulloblastoma, classic", "npttb Medulloblastoma, classic"),
("Medulloblastoma, desmoplastic", "npttb Medulloblastoma, desmoplastic"),
("Medulloblastoma, extensive nodularity", "npttb Medulloblastoma, extensive nodularity"),
("Medulloblastoma, large cell / anaplastic", "npttb Medulloblastoma, large cell / anaplastic"),
("Medulloblastoma, not otherwise specified", "npttb Medulloblastoma, not otherwise specified"),
("Melanocytoma", "npttb Melanocytoma"),
("Meningioma (I)", "npttb Meningioma (I)"),
("Meningioma, atypical (II)", "npttb Meningioma, atypical (II)"),
("Meningioma, chordoid (II)", "npttb Meningioma, chordoid (II)"),
("Meningioma, clear cell (II)", "npttb Meningioma, clear cell (II)"),
("Meningioma, malignant (III)", "npttb Meningioma, malignant (III)"),
("Meningioma, papillary (III)", "npttb Meningioma, papillary (III)"),
("Meningioma, rhabdoid (III)", "npttb Meningioma, rhabdoid (III)"),
("Mixed Germ Cell Tumor", "npttb Mixed Germ Cell Tumor"),
("Neuroblastoma", "npttb Neuroblastoma"),
("Neuroblastoma, olfactory", "npttb Neuroblastoma, olfactory"),
("Neurocytoma", "npttb Neurocytoma"),
("Neurofibroma", "npttb Neurofibroma"), 
("Neurofibroma, plexiform", "npttb Neurofibroma, plexiform"),
("Neuroma", "npttb Neuroma"),
("Oligodendroglioma (II)", "npttb Oligodendroglioma (II)"),
("Oligodendroglioma, anaplastic (III)","npttb Oligodendroglioma, anaplastic (III)"),
("Oligodendroglioma, anaplastic with necrosis (IV)","npttb Oligodendroglioma, anaplastic with necrosis (IV)"),
("Oligoastrocytoma (II)", "npttb Oligoastrocytoma (II)"),
("Oligoastrocytoma, anaplastic (III)","npttb Oligoastrocytoma, anaplastic (III)"),
("Perineurioma", "npttb Perineurioma"),
("Pineal Parenchymal Tumor of Intermediate Differentiation", "npttb Pineal Parenchymal Tumor of Intermediate Differentiation"),
("Pineoblastoma", "npttb Pineoblastoma"),
("Pineocytoma", "npttb Pineocytoma"),
("Pituitary Adenoma", "npttb Pituitary Adenoma"),
("Primitive Neuroectodermal Tumor, not otherwise specified", "npttb Primitive Neuroectodermal Tumor, not otherwise specified"),
("Retinoblastoma", "npttb Retinoblastoma"),
("Schwannoma", "npttb Schwannoma"),
("Subependymoma", "npttb Subependymoma"),
("Yolk Sac Tumor", "npttb Yolk Sac Tumor");

-- Disable diagnosis types
UPDATE `diagnosis_controls` SET `flag_active`=0 WHERE `controls_type`='blood';
UPDATE `diagnosis_controls` SET `flag_active`=0 WHERE `controls_type`='tissue';

-- Create new diagnois
INSERT INTO `diagnosis_controls` (`category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
 ('primary', 'npttb tissue', 1, 'diagnosismasters,dx_primary,dx_npttb_tissue', 'dxd_npttb_tissue', 0, 'primary|npttb tissue', 1);

-- New structure
INSERT INTO `structures` (`alias`) VALUES ('dx_npttb_tissue');

-- Create detail table
CREATE TABLE `dxd_npttb_tissue` (
	`id` INT NOT NULL AUTO_INCREMENT ,
	`diagnosis_master_id` INT NOT NULL ,
	`npttb_path_final_dx` VARCHAR(100),
	`npttn_ttb_diagnosis` VARCHAR(100),
	`deleted` TINYINT NOT NULL DEFAULT 0 ,
	PRIMARY KEY (`id`) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dxd_npttb_tissue_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` INT NOT NULL ,
  `npttb_path_final_dx` VARCHAR(100),
  `npttn_ttb_diagnosis` VARCHAR(100),
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Value domain for final diagnosis  
INSERT INTO `structure_value_domains` (`domain_name`, `override`) VALUES ('npttb_final_diagnosis', 'open');

-- Permissible Values for Final Diagnosis
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Atypical Teratoid Rhabdoid Tumor", "npttb Atypical Teratoid Rhabdoid Tumor");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Atypical Teratoid Rhabdoid Tumor" AND language_alias="npttb Atypical Teratoid Rhabdoid Tumor"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Astrocytoma, diffuse (II)", "npttb Astrocytoma, diffuse (II)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Astrocytoma, diffuse (II)" AND language_alias="npttb Astrocytoma, diffuse (II)"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Astrocytoma, anaplastic (III)", "npttb Astrocytoma, anaplastic (III)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Astrocytoma, anaplastic (III)" AND language_alias="npttb Astrocytoma, anaplastic (III)"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Astrocytoma, glioblastoma (IV)", "npttb Astrocytoma, glioblastoma (IV)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Astrocytoma, glioblastoma (IV)" AND language_alias="npttb Astrocytoma, glioblastoma (IV)"), "4", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Astrocytoma, glioblastoma (IV) with oligo component", "npttb Astrocytoma, glioblastoma (IV) with oligo component");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Astrocytoma, glioblastoma (IV) with oligo component" AND language_alias="npttb Astrocytoma, glioblastoma (IV) with oligo component"), "5", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Astrocytoma, gliosarcoma (IV)", "npttb Astrocytoma, gliosarcoma (IV)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Astrocytoma, gliosarcoma (IV)" AND language_alias="npttb Astrocytoma, gliosarcoma (IV)"), "6", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Astrocytoma, giant cell glioblastoma (IV)", "npttb Astrocytoma, giant cell glioblastoma (IV)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Astrocytoma, giant cell glioblastoma (IV)" AND language_alias="npttb Astrocytoma, giant cell glioblastoma (IV)"), "7", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Astrocytoma, pilocytic (I)", "npttb Astrocytoma, pilocytic (I)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Astrocytoma, pilocytic (I)" AND language_alias="npttb Astrocytoma, pilocytic (I)"), "8", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Astrocytoma, pilomyxoid", "npttb Astrocytoma, pilomyxoid");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Astrocytoma, pilomyxoid" AND language_alias="npttb Astrocytoma, pilomyxoid"), "9", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Astrocytoma with treatment effect", "npttb Astrocytoma with treatment effect");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Astrocytoma with treatment effect" AND language_alias="npttb Astrocytoma with treatment effect"), "10", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Choriocarcinoma", "npttb Choriocarcinoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Choriocarcinoma" AND language_alias="npttb Choriocarcinoma"), "11", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Choroid Plexus Papilloma", "npttb Choroid Plexus Papilloma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Choroid Plexus Papilloma" AND language_alias="npttb Choroid Plexus Papilloma"), "12", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Choroid Plexus Carcinoma", "npttb Choroid Plexus Carcinoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Choroid Plexus Carcinoma" AND language_alias="npttb Choroid Plexus Carcinoma"), "13", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Craniopharyngioma, Adamantinomatous", "npttb Craniopharyngioma, Adamantinomatous");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Craniopharyngioma, Adamantinomatous" AND language_alias="npttb Craniopharyngioma, Adamantinomatous"), "14", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Craniopharyngioma, Papillary", "npttb Craniopharyngioma, Papillary");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Craniopharyngioma, Papillary" AND language_alias="npttb Craniopharyngioma, Papillary"), "15", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Dysembyroplastic neuroepithalial tumor", "npttb Dysembyroplastic neuroepithalial tumor");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Dysembyroplastic neuroepithalial tumor" AND language_alias="npttb Dysembyroplastic neuroepithalial tumor"), "16", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Embryonal Carcinoma", "npttb Embryonal Carcinoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Embryonal Carcinoma" AND language_alias="npttb Embryonal Carcinoma"), "17", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Ependymoma (II)", "npttb Ependymoma (II)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Ependymoma (II)" AND language_alias="npttb Ependymoma (II)"), "18", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Ependymoma, anaplastic (III)", "npttb Ependymoma, anaplastic (III)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Ependymoma, anaplastic (III)" AND language_alias="npttb Ependymoma, anaplastic (III)"), "19", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Ependymoma, myxopapillary", "npttb Ependymoma, myxopapillary");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Ependymoma, myxopapillary" AND language_alias="npttb Ependymoma, myxopapillary"), "20", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Gangliocytoma", "npttb Gangliocytoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Gangliocytoma" AND language_alias="npttb Gangliocytoma"), "21", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Ganglioglioma", "npttb Ganglioglioma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Ganglioglioma" AND language_alias="npttb Ganglioglioma"), "22", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Germinoma", "npttb Germinoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Germinoma" AND language_alias="npttb Germinoma"), "23", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Glioma, brainstem", "npttb Glioma, brainstem");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Glioma, brainstem" AND language_alias="npttb Glioma, brainstem"), "24", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Glioma, chordoid", "npttb Glioma, chordoid");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Glioma, chordoid" AND language_alias="npttb Glioma, chordoid"), "25", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Glioma, not otherwise specified", "npttb Glioma, not otherwise specified");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Glioma, not otherwise specified" AND language_alias="npttb Glioma, not otherwise specified"), "26", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Glioneuronal tumor, not otherwise specified", "npttb Glioneuronal tumor, not otherwise specified");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Glioneuronal tumor, not otherwise specified" AND language_alias="npttb Glioneuronal tumor, not otherwise specified"), "27", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Hemangioblastoma", "npttb Hemangioblastoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Hemangioblastoma" AND language_alias="npttb Hemangioblastoma"), "28", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Hemangiopericytoma, solitary fibrous tumor", "npttb Hemangiopericytoma, solitary fibrous tumor");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Hemangiopericytoma, solitary fibrous tumor" AND language_alias="npttb Hemangiopericytoma, solitary fibrous tumor"), "29", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Malignant Peripheral Nerve Sheath Tumor", "npttb Malignant Peripheral Nerve Sheath Tumor");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Malignant Peripheral Nerve Sheath Tumor" AND language_alias="npttb Malignant Peripheral Nerve Sheath Tumor"), "30", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Medulloblastoma, classic", "npttb Medulloblastoma, classic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Medulloblastoma, classic" AND language_alias="npttb Medulloblastoma, classic"), "31", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Medulloblastoma, desmoplastic", "npttb Medulloblastoma, desmoplastic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Medulloblastoma, desmoplastic" AND language_alias="npttb Medulloblastoma, desmoplastic"), "32", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Medulloblastoma, extensive nodularity", "npttb Medulloblastoma, extensive nodularity");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Medulloblastoma, extensive nodularity" AND language_alias="npttb Medulloblastoma, extensive nodularity"), "33", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Medulloblastoma, large cell / anaplastic", "npttb Medulloblastoma, large cell / anaplastic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Medulloblastoma, large cell / anaplastic" AND language_alias="npttb Medulloblastoma, large cell / anaplastic"), "34", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Medulloblastoma, not otherwise specified", "npttb Medulloblastoma, not otherwise specified");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Medulloblastoma, not otherwise specified" AND language_alias="npttb Medulloblastoma, not otherwise specified"), "35", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Melanocytoma", "npttb Melanocytoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Melanocytoma" AND language_alias="npttb Melanocytoma"), "36", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Meningioma (I)", "npttb Meningioma (I)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Meningioma (I)" AND language_alias="npttb Meningioma (I)"), "37", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Meningioma, atypical (II)", "npttb Meningioma, atypical (II)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Meningioma, atypical (II)" AND language_alias="npttb Meningioma, atypical (II)"), "38", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Meningioma, chordoid (II)", "npttb Meningioma, chordoid (II)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Meningioma, chordoid (II)" AND language_alias="npttb Meningioma, chordoid (II)"), "39", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Meningioma, clear cell (II)", "npttb Meningioma, clear cell (II)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Meningioma, clear cell (II)" AND language_alias="npttb Meningioma, clear cell (II)"), "40", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Meningioma, malignant (III)", "npttb Meningioma, malignant (III)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Meningioma, malignant (III)" AND language_alias="npttb Meningioma, malignant (III)"), "41", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Meningioma, papillary (III)", "npttb Meningioma, papillary (III)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Meningioma, papillary (III)" AND language_alias="npttb Meningioma, papillary (III)"), "42", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Meningioma, rhabdoid (III)", "npttb Meningioma, rhabdoid (III)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Meningioma, rhabdoid (III)" AND language_alias="npttb Meningioma, rhabdoid (III)"), "43", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Mixed Germ Cell Tumor", "npttb Mixed Germ Cell Tumor");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Mixed Germ Cell Tumor" AND language_alias="npttb Mixed Germ Cell Tumor"), "44", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Neuroblastoma", "npttb Neuroblastoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Neuroblastoma" AND language_alias="npttb Neuroblastoma"), "45", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Neuroblastoma, olfactory", "npttb Neuroblastoma, olfactory");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Neuroblastoma, olfactory" AND language_alias="npttb Neuroblastoma, olfactory"), "46", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Neurocytoma", "npttb Neurocytoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Neurocytoma" AND language_alias="npttb Neurocytoma"), "47", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Neurofibroma", "npttb Neurofibroma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Neurofibroma " AND language_alias="npttb Neurofibroma "), "48", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Neurofibroma, plexiform", "npttb Neurofibroma, plexiform");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Neurofibroma, plexiform" AND language_alias="npttb Neurofibroma, plexiform"), "49", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Neuroma", "npttb Neuroma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Neuroma" AND language_alias="npttb Neuroma"), "50", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Oligodendroglioma (II)", "npttb Oligodendroglioma (II)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Oligodendroglioma (II)" AND language_alias="npttb Oligodendroglioma (II)"), "51", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Oligodendroglioma, anaplastic (III)", "npttb Oligodendroglioma, anaplastic (III)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Oligodendroglioma, anaplastic (III)" AND language_alias="npttb Oligodendroglioma, anaplastic (III)"), "52", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Oligodendroglioma, anaplastic with necrosis (IV)", "npttb Oligodendroglioma, anaplastic with necrosis (IV)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Oligodendroglioma, anaplastic with necrosis (IV)" AND language_alias="npttb Oligodendroglioma, anaplastic with necrosis (IV)"), "53", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Oligoastrocytoma (II)", "npttb Oligoastrocytoma (II)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Oligoastrocytoma (II)" AND language_alias="npttb Oligoastrocytoma (II)"), "54", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Oligoastrocytoma, anaplastic (III)", "npttb Oligoastrocytoma, anaplastic (III)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Oligoastrocytoma, anaplastic (III)" AND language_alias="npttb Oligoastrocytoma, anaplastic (III)"), "55", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Perineurioma", "npttb Perineurioma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Perineurioma " AND language_alias="npttb Perineurioma "), "56", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Pineal Parenchymal Tumor of Intermediate Differentiation", "npttb Pineal Parenchymal Tumor of Intermediate Differentiation");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Pineal Parenchymal Tumor of Intermediate Differentiation" AND language_alias="npttb Pineal Parenchymal Tumor of Intermediate Differentiation"), "57", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Pineoblastoma", "npttb Pineoblastoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Pineoblastoma" AND language_alias="npttb Pineoblastoma"), "58", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Pineocytoma", "npttb Pineocytoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Pineocytoma" AND language_alias="npttb Pineocytoma"), "59", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Pituitary Adenoma", "npttb Pituitary Adenoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Pituitary Adenoma" AND language_alias="npttb Pituitary Adenoma"), "60", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Primitive Neuroectodermal Tumor, not otherwise specified", "npttb Primitive Neuroectodermal Tumor, not otherwise specified");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Primitive Neuroectodermal Tumor, not otherwise specified " AND language_alias="npttb Primitive Neuroectodermal Tumor, not otherwise specified "), "61", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Retinoblastoma", "npttb Retinoblastoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Retinoblastoma" AND language_alias="npttb Retinoblastoma"), "62", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Schwannoma", "npttb Schwannoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Schwannoma" AND language_alias="npttb Schwannoma"), "63", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Subependymoma ", "npttb Subependymoma");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Subependymoma" AND language_alias="npttb Subependymoma"), "64", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("Yolk Sac Tumor ", "npttb Yolk Sac Tumor");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="npttb_final_diagnosis"), (SELECT id FROM structure_permissible_values WHERE value="Yolk Sac Tumor" AND language_alias="npttb Yolk Sac Tumor"), "65", "1");

-- Add fields to dx detail form
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'dxd_npttb_tissue', 'npttb_path_final_dx', 'input',  NULL , '0', 'size=50', '', 'npttb help path final', 'npttb path final dx', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'dxd_npttb_tissue', 'npttn_ttb_diagnosis', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='npttb_final_diagnosis') , '0', '', '', '', 'npttn ttb diagnosis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='dx_npttb_tissue'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttb_path_final_dx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=50' AND `default`='' AND `language_help`='npttb help path final' AND `language_label`='npttb path final dx' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_npttb_tissue'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_npttb_tissue' AND `field`='npttn_ttb_diagnosis' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='npttb_final_diagnosis')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='npttn ttb diagnosis' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
