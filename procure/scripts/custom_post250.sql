UPDATE misc_identifiers mi INNER JOIN misc_identifier_controls mic ON mi.misc_identifier_control_id=mic.id SET mi.flag_unique=1 WHERE mic.flag_unique=true AND mi.deleted=0;
ALTER TABLE ed_all_lifestyle_smokings DROP COLUMN years_quit_smoking;
ALTER TABLE ed_all_lifestyle_smokings_revs DROP COLUMN years_quit_smoking;

UPDATE users SET flag_active = 1;
UPDATE `groups` SET `flag_show_confidential` = '1';

INSERT INTO i18n (id,en,fr) VALUES ('core_installname','PROCURE','PROCURE');

-- ===============================================================================================================================================================================
--
-- PROFILE & IDENTIFICATION
--
-- ===============================================================================================================================================================================

UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');

INSERT INTO `procure`.`misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`) 
VALUES 
(NULL, 'RAMQ', '1', '1', '1', '1'),
(NULL, 'hospital number', '1', '1', '1', '1');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) 
VALUES 
('participant identifier','Identification ','Identification '),
('the identification format is wrong','Le format de l''identification n''est pas supporté!','The identification format is wrong!'),
('hospital number','Hospital Number','Numéro hospitalier'),
('RAMQ','RAMQ','RAMQ');

-- ===============================================================================================================================================================================
--
-- F1 - Signature consentement
--
-- ===============================================================================================================================================================================

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'consent form signature', 1, 'procure_consent_form_siganture', 'procure_cd_sigantures', 0, 'consent form signature');
UPDATE consent_controls SET flag_active = 0 WHERE controls_type != 'consent form signature';

-- master

ALTER TABLE consent_masters MODIFY `consent_signed_date` datetime DEFAULT NULL;
ALTER TABLE consent_masters_revs MODIFY `consent_signed_date` datetime DEFAULT NULL;

UPDATE structure_fields SET  `language_label`='consent form version' WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='form_version' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='custom_consent_from_verisons');
UPDATE structure_fields SET  `type`='datetime' WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='consent_signed_date' ;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='status_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('french','French','Française', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'consent form versions'), 1),
('english','English','Anglaise', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'consent form versions'), 1);

-- detail

CREATE TABLE IF NOT EXISTS `procure_cd_sigantures` (
  `consent_master_id` int(11) NOT NULL,
 
  `form_identification` varchar(50) DEFAULT NULL,
  `revision_date` date DEFAULT NULL,
  `revision_date_accuracy` char(1) NOT NULL DEFAULT '',
  `patient_identity_verified` tinyint(1) DEFAULT '0',
  
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `procure_cd_sigantures_revs` (
  `consent_master_id` int(11) NOT NULL,
  
  `form_identification` varchar(50) DEFAULT NULL,
  `revision_date` date DEFAULT NULL,
  `revision_date_accuracy` char(1) NOT NULL DEFAULT '',
  `patient_identity_verified` tinyint(1) DEFAULT '0',
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `procure_cd_sigantures`
  ADD CONSTRAINT `procure_cd_sigantures_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);
  
INSERT INTO structures(`alias`) VALUES ('procure_consent_form_siganture');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'revision_date', 'date',  NULL , '0', '', '', '', 'revision date', ''),
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'patient_identity_verified', 'checkbox',  NULL , '0', '', '', '', 'confirm that the identity of the patient has been verified', ''),
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_signatures', 'form_identification', 'input',  NULL , '0', 'size=30', '', '', 'identification', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='revision_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='revision date' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_sigantures' AND `field`='patient_identity_verified'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_signatures' AND `field`='form_identification' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='identification' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO `structure_validations` (`structure_field_id` , `rule` ) VALUES ((SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='procure_cd_signatures' AND `field`='form_identification' AND `type`='input'), 'notEmpty');

-- i18n

INSERT IGNORE INTO i18n (id,en,fr) VALUES
("consent form signature","F1 - Consent form signature worksheet","F1 - Fiche de signature du consentement"),
("consent form version","Consent from version","Version du consentement"),
("revision date","Revised date","Date de révision"),
("confirm that the identity of the patient has been verified","I confirm that the identity of the patient has been verified", "Je confirme que l'identité du participant a été vérifiée");

-- ===============================================================================================================================================================================
--
-- F1a - Fiche des médicaments
--
-- ===============================================================================================================================================================================


INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `databrowser_label`) VALUES
(null, 'medication worksheet', 'procure', 1, 'procure_txd_medications', 'procure_txd_medications', 'procure_txe_medications', 'procure_txe_medications', 'procure|medication worksheet');

-- drug 

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_drug_type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) 
VALUES
("prostate", "prostate"),
("other diseases", "other diseases"),
("open sale", "open sale");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type"), (SELECT id FROM structure_permissible_values WHERE value="prostate" AND language_alias="prostate"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type"), (SELECT id FROM structure_permissible_values WHERE value="other diseases" AND language_alias="other diseases"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_drug_type"), (SELECT id FROM structure_permissible_values WHERE value="open sale" AND language_alias="open sale"), "3", "1");

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_drug_type') WHERE model='Drug' AND field='type' AND `type`='select';

INSERT INTO `drugs` (`generic_name`, `type`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('Avodart', 'prostate', NOW(), NOW(), 1, 1),
('Proscar', 'prostate', NOW(), NOW(), 1, 1),
('Flomax', 'prostate', NOW(), NOW(), 1, 1),
('Xatral', 'prostate', NOW(), NOW(), 1, 1),
('Cipro', 'prostate', NOW(), NOW(), 1, 1),

('Aspirine', 'open sale', NOW(), NOW(), 1, 1),
('Advil', 'open sale', NOW(), NOW(), 1, 1),
('Tylenol', 'open sale', NOW(), NOW(), 1, 1),
('Vitamines', 'open sale', NOW(), NOW(), 1, 1);

INSERT INTO `drugs_revs` (`generic_name`, `type`,`modified_by`, `id`) SELECT `generic_name`, `type`, NOW(), `id` FROM drugs;

REPLACE INTO i18n  (id,fr,en) VALUES ('open sale','','Open sale'),('prostate','Prostate','Prostate');

-- master

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- detail

CREATE TABLE IF NOT EXISTS `procure_txd_medications` (
  `form_identification` varchar(50) DEFAULT NULL,
  `patient_identity_verified` tinyint(1) DEFAULT '0',
  `patient_identity_check_date` date DEFAULT NULL,
  `patient_identity_check_date_accuracy` char(1) NOT NULL DEFAULT '',

  `medication_for_prostate_cancer` char(1) DEFAULT '',
  `medication_for_benign_prostatic_hyperplasia` char(1) DEFAULT '',
  `medication_for_prostatitis` char(1) DEFAULT '',

  `benign_hyperplasia` char(1) DEFAULT '',
  `benign_hyperplasia_place_and_date` varchar(50) DEFAULT NULL,
  `benign_hyperplasia_notes` text,

  `prescribed_drugs_for_other_diseases` char(1) DEFAULT '',
  `list_of_drugs_for_other_diseases` char(1) DEFAULT '',
  `photocopy_of_drugs_for_other_diseases` char(1) DEFAULT '',
  `dosages_of_drugs_for_other_diseases` char(1) DEFAULT '',
   
  `open_sale_drugs` char(1) DEFAULT '',

  `treatment_master_id` int(11) NOT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `procure_txd_medications_revs` (
  `form_identification` varchar(50) DEFAULT NULL,
  `patient_identity_verified` tinyint(1) DEFAULT '0',
  `patient_identity_check_date` date DEFAULT NULL,
  `patient_identity_check_date_accuracy` char(1) NOT NULL DEFAULT '',

  `medication_for_prostate_cancer` char(1) DEFAULT '',
  `medication_for_benign_prostatic_hyperplasia` char(1) DEFAULT '',
  `medication_for_prostatitis` char(1) DEFAULT '',

  `benign_hyperplasia` char(1) DEFAULT '',
  `benign_hyperplasia_place_and_date` varchar(50) DEFAULT NULL,
  `benign_hyperplasia_notes` text,

  `prescribed_drugs_for_other_diseases` char(1) DEFAULT '',
  `list_of_drugs_for_other_diseases` char(1) DEFAULT '',
  `photocopy_of_drugs_for_other_diseases` char(1) DEFAULT '',
  `dosages_of_drugs_for_other_diseases` char(1) DEFAULT '',
   
  `open_sale_drugs` char(1) DEFAULT '',
  
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


ALTER TABLE `procure_txd_medications`
  ADD CONSTRAINT `procure_txd_medications_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('procure_txd_medications');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'form_identification', 'input',  NULL , '0', 'size=30', '', '', 'identification', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'patient_identity_verified', 'checkbox',  NULL , '0', '', '', '', 'confirm that the identity of the patient has been verified', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'patient_identity_check_date', 'date',  NULL , '0', '', '', '', 'patient identity check date', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'medication_for_prostate_cancer', 'yes_no',  NULL , '0', '', '', '', 'medication for prostate cancer', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'medication_for_benign_prostatic_hyperplasia', 'yes_no',  NULL , '0', '', '', '', 'medication for benign prostatic hyperplasia', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'medication_for_prostatitis', 'yes_no',  NULL , '0', '', '', '', 'medication for prostatitis', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'benign_hyperplasia', 'yes_no',  NULL , '0', '', '', '', 'benign hyperplasia', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'benign_hyperplasia_place_and_date', 'input',  NULL , '0', 'size=30', '', '', 'benign hyperplasia place and date', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'benign_hyperplasia_notes', 'textarea',  NULL , '0', 'size=30,rows=3', '', '', 'notes', ''),

('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'prescribed_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'prescribed drugs for other diseases', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'list_of_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'list of drugs for other diseases', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'photocopy_of_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'photocopy of drugs for other diseases', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'dosages_of_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'dosages of drugs for other diseases', ''), 

('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'open_sale_drugs', 'yes_no',  NULL , '0', '', '', '', 'open sale drugs', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='form_identification' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='identification' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='patient_identity_verified' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='patient_identity_check_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='patient identity check date' AND `language_tag`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='medication_for_prostate_cancer' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='medication for prostate cancer' AND `language_tag`=''), '1', '30', 'prostate medication', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='medication_for_benign_prostatic_hyperplasia' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='medication for benign prostatic hyperplasia' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='medication_for_prostatitis' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='medication for prostatitis' AND `language_tag`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='benign_hyperplasia' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='benign hyperplasia' AND `language_tag`=''), '2', '40', 'benign prostatic hyperplasia', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='benign_hyperplasia_place_and_date' AND `type`='input'), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='benign_hyperplasia_notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30,rows=3' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='prescribed_drugs_for_other_diseases'), '2', '51', 'prescribed medication for other diseases', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='list_of_drugs_for_other_diseases'), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='photocopy_of_drugs_for_other_diseases'), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='dosages_of_drugs_for_other_diseases'), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='open_sale_drugs'), '2', '60', 'medications and supplements on open sale', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO `structure_validations` (`structure_field_id` , `rule` ) VALUES ((SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='form_identification'), 'notEmpty');

-- i18n

REPLACE INTO i18n  (id,fr,en) VALUES
("medication worksheet","F1a - Fiche des médicaments","F1a - Medication worksheet"),
("procure","PROCURE","PROCURE"),

("patient identity check date","Date","Date"),

("prostate medication","Médication pour la prostate","Prostate medication"),
("medication for prostate cancer","Le patient prend-il des médicaments pour le cancer de la prostate","Does the patient take medication for prostate cancer"),
("medication for benign prostatic hyperplasia","Le patient prend-il des médicaments pour l'hyperplastie bénigne de la prostate","Does the patient take medication for benign prostatic hyperplasia"),
("medication for prostatitis","Le patient prend-il des médicaments pour une prostatie","Does the patient take medication for prostatitis"),

("benign prostatic hyperplasia","Hyperplasie bénigne de la prostate","Benign prostate hyperplasia"),
("benign hyperplasia","Le patient a-t-il subi une chirurgie pour l'hyperplasie bénigne de la prostate","Did the patient have surgery for benign prostatoc hyperplasia"),
("benign hyperplasia place and date","Hyperplasie bénigne: lieu et date","Benign hyperplasia: place and date"),

('prescribed medication for other diseases',"Médicaments prescrits pour autres maladies","Prescribed medication for other diseases"),
('prescribed drugs for other diseases',"Le patient prend-il des médicaments sous ordonnance","Does the patient take prescribed drugs"),
('list of drugs for other diseases',"Le patient dispose-t-il d'une liste de ces médicaments","Does the patient have a list of these drugs"),
('photocopy of drugs for other diseases',"Une copie de cette liste est jointe à la fiche F1a","A photocopy of this list is atached to the F1a worksheet"),
('dosages of drugs for other diseases',"Cette liste contient la posologie des médicaments","This list contains dosages of the drugs"),

("medications and supplements on open sale","Médicaments et suppléments en vente libre","Medications and supplements on open sale"),
("open sale drugs","La patient prend-il des médicaments ou des suppléments en vente libre","Does the patient take medications and supplements on open sale");

-- extend

CREATE TABLE IF NOT EXISTS `procure_txe_medications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `dose` varchar(50) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  
  `drug_id` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_procure_txe_medications_drugs` (`drug_id`),
  KEY `FK_procure_txe_medications_tx_masters` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `procure_txe_medications_revs` (
  `id` int(11) NOT NULL,
  
  `dose` varchar(50) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  
  `drug_id` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


ALTER TABLE `procure_txe_medications`
  ADD CONSTRAINT `procure_txe_medications_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`),
  ADD CONSTRAINT `FK_procure_txe_medications_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);

INSERT INTO structures(`alias`) VALUES ('procure_txe_medications');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'procure_txe_medications', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='drug_list') , '0', '', '', 'help_drug_id', 'medication', ''), 
('ClinicalAnnotation', 'TreatmentExtend', 'procure_txe_medications', 'dose', 'input',  NULL , '0', 'size=10', '', 'help_dose', 'dose', ''), 
('ClinicalAnnotation', 'TreatmentExtend', 'procure_txe_medications', 'duration', 'input',  NULL , '0', 'size=20', '', '', 'duration', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txe_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='procure_txe_medications' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='medication' AND `language_tag`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_txe_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='procure_txe_medications' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_dose' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_txe_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='procure_txe_medications' AND `field`='duration' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='duration' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');

-- i18n
	
REPLACE INTO i18n  (id,fr,en) VALUES
("medication","Médicaments","Medication"),
("duration","Durée","Duration");













