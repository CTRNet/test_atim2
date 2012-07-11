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
(null, 'procure consent form signature', 1, 'procure_consent_form_siganture', 'procure_cd_sigantures', 0, 'procure consent form signature');
UPDATE consent_controls SET flag_active = 0 WHERE controls_type != 'procure consent form signature';

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
INSERT INTO `structure_validations` (`structure_field_id` , `rule` ) VALUES ((SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `field`='form_identification' AND `type`='input'), 'isUnique');

-- i18n

INSERT IGNORE INTO i18n (id,en,fr) VALUES
("procure consent form signature","F1 - Consent form signature worksheet","F1 - Fiche de signature du consentement"),
("consent form version","Consent from version","Version du consentement"),
("revision date","Revised date","Date de révision"),
("confirm that the identity of the patient has been verified","I confirm that the identity of the patient has been verified", "Je confirme que l'identité du participant a été vérifiée");

-- ===============================================================================================================================================================================
--
-- F1a - Fiche des médicaments
--
-- ===============================================================================================================================================================================

UPDATE treatment_controls SET flag_active = 0;

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `databrowser_label`) VALUES
(null, 'procure medication worksheet', 'procure', 1, 'procure_txd_medications', 'procure_txd_medications', 'procure_txe_medications', 'procure_txe_medications', 'procure medication worksheet');

-- drug 

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_drug_type", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
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
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'benign_hyperplasia_notes', 'textarea',  NULL , '0', 'size=30,rows=3', '', '', 'comments', ''),

('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'prescribed_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'prescribed drugs for other diseases', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'list_of_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'list of drugs for other diseases', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'photocopy_of_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'photocopy of drugs for other diseases', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'dosages_of_drugs_for_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'dosages of drugs for other diseases', ''), 

('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_medications', 'open_sale_drugs', 'yes_no',  NULL , '0', '', '', '', 'open sale drugs', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='form_identification' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='identification' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='patient_identity_verified' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='patient_identity_check_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='patient identity check date' AND `language_tag`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '23', '', '1', 'comments', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='medication_for_prostate_cancer' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='medication for prostate cancer' AND `language_tag`=''), '1', '30', 'prostate medication', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='medication_for_benign_prostatic_hyperplasia' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='medication for benign prostatic hyperplasia' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='medication_for_prostatitis' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='medication for prostatitis' AND `language_tag`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 

((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='benign_hyperplasia' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='benign hyperplasia' AND `language_tag`=''), '2', '40', 'benign prostatic hyperplasia', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='benign_hyperplasia_place_and_date' AND `type`='input'), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='benign_hyperplasia_notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30,rows=3' AND `default`='' AND `language_help`='' AND `language_label`='comments' AND `language_tag`=''), '2', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='prescribed_drugs_for_other_diseases'), '2', '51', 'prescribed medication for other diseases', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='list_of_drugs_for_other_diseases'), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='photocopy_of_drugs_for_other_diseases'), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='dosages_of_drugs_for_other_diseases'), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='open_sale_drugs'), '2', '60', 'medications and supplements on open sale', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO `structure_validations` (`structure_field_id` , `rule` ) VALUES ((SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_medications' AND `field`='form_identification'), 'notEmpty');
INSERT INTO `structure_validations` (`structure_field_id` , `rule` ) VALUES ((SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `field`='form_identification' AND `type`='input'), 'isUnique');

-- i18n

REPLACE INTO i18n  (id,fr,en) VALUES
("procure medication worksheet","F1a - Fiche des médicaments","F1a - Medication worksheet"),
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

-- ===============================================================================================================================================================================
--
-- F12 - Rapport de pathologie
--
-- ===============================================================================================================================================================================

UPDATE event_controls SET flag_Active = 0;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'procure', 'lab', 'procure pathology report', 1, 'procure_ed_pathology', 'procure_ed_lab_pathologies', 0, 'procure pathology report', 1);

DROP TABLE IF EXISTS procure_ed_lab_pathologies;
DROP TABLE IF EXISTS procure_ed_lab_pathologies_revs;

CREATE TABLE IF NOT EXISTS `procure_ed_lab_pathologies` (
	`form_identification` varchar(50) DEFAULT NULL,
  
  	path_number varchar(50) DEFAULT NULL,
	pathologist_name varchar(250) DEFAULT NULL,
	
	prostate_weight_gr decimal(10,2) DEFAULT NULL, 
	prostate_length_cm decimal(10,2) DEFAULT NULL, 
	prostate_width_cm decimal(10,2) DEFAULT NULL, 
	prostate_thickness_cm decimal(10,2) DEFAULT NULL, 
	
	right_seminal_vesicle_length_cm decimal(10,2) DEFAULT NULL, 
	right_seminal_vesicle_width_cm decimal(10,2) DEFAULT NULL, 
	right_seminal_vesicle_thickness_cm decimal(10,2) DEFAULT NULL, 
	left_seminal_vesicle_length_cm decimal(10,2) DEFAULT NULL, 
	left_seminal_vesicle_width_cm decimal(10,2) DEFAULT NULL, 
	left_seminal_vesicle_thickness_cm decimal(10,2) DEFAULT NULL,     
   
	histology varchar(50) DEFAULT NULL,
	histology_other_precision varchar(50) DEFAULT NULL,
      
	tumour_location_right_anterior tinyint(1) DEFAULT '0',
	tumour_location_left_anterior tinyint(1) DEFAULT '0',
	tumour_location_right_posterior tinyint(1) DEFAULT '0',
	tumour_location_left_posterior tinyint(1) DEFAULT '0',
	tumour_location_apex tinyint(1) DEFAULT '0',
	tumour_location_base tinyint(1) DEFAULT '0',
	tumour_location_bladder_neck tinyint(1) DEFAULT '0',
  
 	tumour_volume varchar(50) DEFAULT NULL,
  
	histologic_grade_primary_pattern varchar(50) DEFAULT NULL,
	histologic_grade_secondary_pattern varchar(50) DEFAULT NULL,
	histologic_grade_tertiary_pattern varchar(50) DEFAULT NULL,
    histologic_grade_gleason_score varchar(50) DEFAULT NULL,
    
    margins varchar(50) DEFAULT NULL,
    margins_focal_or_extensive varchar(50) DEFAULT NULL,
    margins_extensive_anterior_left tinyint(1) DEFAULT '0',
    margins_extensive_anterior_right tinyint(1) DEFAULT '0',
    margins_extensive_posterior_left tinyint(1) DEFAULT '0',
    margins_extensive_posterior_right tinyint(1) DEFAULT '0',
    margins_extensive_apical_anterior_left tinyint(1) DEFAULT '0',
    margins_extensive_apical_anterior_right tinyint(1) DEFAULT '0',
    margins_extensive_apical_posterior_left tinyint(1) DEFAULT '0',
    margins_extensive_apical_posterior_right tinyint(1) DEFAULT '0',
    margins_extensive_bladder_neck tinyint(1) DEFAULT '0',
    margins_gleason_score varchar(50) DEFAULT NULL,
    
    extra_prostatic_extension varchar(50) DEFAULT NULL,
    extra_prostatic_extension_precision varchar(50) DEFAULT NULL,
    
    extra_prostatic_extension_right_anterior tinyint(1) DEFAULT '0',
    extra_prostatic_extension_left_anterior tinyint(1) DEFAULT '0',
    extra_prostatic_extension_right_posterior tinyint(1) DEFAULT '0',
    extra_prostatic_extension_left_posterior tinyint(1) DEFAULT '0',
    extra_prostatic_extension_apex tinyint(1) DEFAULT '0',
    extra_prostatic_extension_base tinyint(1) DEFAULT '0',
    extra_prostatic_extension_bladder_neck tinyint(1) DEFAULT '0',
    extra_prostatic_extension_seminal_vesicles varchar(50) DEFAULT NULL,
    
	pathologic_staging_version varchar(50) DEFAULT NULL,
	pathologic_staging_pt varchar(50) DEFAULT NULL,
	pathologic_staging_pn_collected char(1) DEFAULT '',
	pathologic_staging_pn varchar(50) DEFAULT NULL,
	pathologic_staging_pn_lymph_node_examined int(6) DEFAULT NULL,
	pathologic_staging_pn_lymph_node_involved int(6) DEFAULT NULL,
	pathologic_staging_pm varchar(50) DEFAULT NULL,
  
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `procure_ed_lab_pathologies_revs` (
	`form_identification` varchar(50) DEFAULT NULL,
  
  	path_number varchar(50) DEFAULT NULL,
	pathologist_name varchar(250) DEFAULT NULL,
	
	prostate_weight_gr decimal(10,2) DEFAULT NULL, 
	prostate_length_cm decimal(10,2) DEFAULT NULL, 
	prostate_width_cm decimal(10,2) DEFAULT NULL, 
	prostate_thickness_cm decimal(10,2) DEFAULT NULL, 
	
	right_seminal_vesicle_length_cm decimal(10,2) DEFAULT NULL, 
	right_seminal_vesicle_width_cm decimal(10,2) DEFAULT NULL, 
	right_seminal_vesicle_thickness_cm decimal(10,2) DEFAULT NULL, 
	left_seminal_vesicle_length_cm decimal(10,2) DEFAULT NULL, 
	left_seminal_vesicle_width_cm decimal(10,2) DEFAULT NULL, 
	left_seminal_vesicle_thickness_cm decimal(10,2) DEFAULT NULL,     
   
	histology varchar(50) DEFAULT NULL,
	histology_other_precision varchar(50) DEFAULT NULL,
      
	tumour_location_right_anterior tinyint(1) DEFAULT '0',
	tumour_location_left_anterior tinyint(1) DEFAULT '0',
	tumour_location_right_posterior tinyint(1) DEFAULT '0',
	tumour_location_left_posterior tinyint(1) DEFAULT '0',
	tumour_location_apex tinyint(1) DEFAULT '0',
	tumour_location_base tinyint(1) DEFAULT '0',
	tumour_location_bladder_neck tinyint(1) DEFAULT '0',
  
 	tumour_volume varchar(50) DEFAULT NULL,
  
	histologic_grade_primary_pattern varchar(50) DEFAULT NULL,
	histologic_grade_secondary_pattern varchar(50) DEFAULT NULL,
	histologic_grade_tertiary_pattern varchar(50) DEFAULT NULL,
    histologic_grade_gleason_score varchar(50) DEFAULT NULL,
    
    margins varchar(50) DEFAULT NULL,
    margins_focal_or_extensive varchar(50) DEFAULT NULL,
    margins_extensive_anterior_left tinyint(1) DEFAULT '0',
    margins_extensive_anterior_right tinyint(1) DEFAULT '0',
    margins_extensive_posterior_left tinyint(1) DEFAULT '0',
    margins_extensive_posterior_right tinyint(1) DEFAULT '0',
    margins_extensive_apical_anterior_left tinyint(1) DEFAULT '0',
    margins_extensive_apical_anterior_right tinyint(1) DEFAULT '0',
    margins_extensive_apical_posterior_left tinyint(1) DEFAULT '0',
    margins_extensive_apical_posterior_right tinyint(1) DEFAULT '0',
    margins_extensive_bladder_neck tinyint(1) DEFAULT '0',
    margins_gleason_score varchar(50) DEFAULT NULL,
    
    extra_prostatic_extension varchar(50) DEFAULT NULL,
    extra_prostatic_extension_precision varchar(50) DEFAULT NULL,
    
    extra_prostatic_extension_right_anterior tinyint(1) DEFAULT '0',
    extra_prostatic_extension_left_anterior tinyint(1) DEFAULT '0',
    extra_prostatic_extension_right_posterior tinyint(1) DEFAULT '0',
    extra_prostatic_extension_left_posterior tinyint(1) DEFAULT '0',
    extra_prostatic_extension_apex tinyint(1) DEFAULT '0',
    extra_prostatic_extension_base tinyint(1) DEFAULT '0',
    extra_prostatic_extension_bladder_neck tinyint(1) DEFAULT '0',
    extra_prostatic_extension_seminal_vesicles varchar(50) DEFAULT NULL,
    
	pathologic_staging_version varchar(50) DEFAULT NULL,
	pathologic_staging_pt varchar(50) DEFAULT NULL,
	pathologic_staging_pn_collected char(1) DEFAULT '',
	pathologic_staging_pn varchar(50) DEFAULT NULL,
	pathologic_staging_pn_lymph_node_examined int(6) DEFAULT NULL,
	pathologic_staging_pn_lymph_node_involved int(6) DEFAULT NULL,
	pathologic_staging_pm varchar(50) DEFAULT NULL,
	
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `procure_ed_lab_pathologies`
  ADD CONSTRAINT `procure_ed_lab_pathologies_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('procure_ed_pathology');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_histology", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("acinar adenocarcinoma/usual type", "acinar adenocarcinoma/usual type"),
("prostatic ductal adenocarcinoma", "prostatic ductal adenocarcinoma"),
("sarcomatoid carcinoma", "sarcomatoid carcinoma"),
("other specify", "other specify");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_histology"), (SELECT id FROM structure_permissible_values WHERE value="acinar adenocarcinoma/usual type" AND language_alias="acinar adenocarcinoma/usual type"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_histology"), (SELECT id FROM structure_permissible_values WHERE value="prostatic ductal adenocarcinoma" AND language_alias="prostatic ductal adenocarcinoma"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_histology"), (SELECT id FROM structure_permissible_values WHERE value="mucinous adenocarcinoma" AND language_alias="mucinous adenocarcinoma"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_histology"), (SELECT id FROM structure_permissible_values WHERE value="signet-ring cell carcinoma" AND language_alias="signet-ring cell carcinoma"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_histology"), (SELECT id FROM structure_permissible_values WHERE value="adenosquamous carcinoma" AND language_alias="adenosquamous carcinoma"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_histology"), (SELECT id FROM structure_permissible_values WHERE value="small cell carcinoma" AND language_alias="small cell carcinoma"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_histology"), (SELECT id FROM structure_permissible_values WHERE value="sarcomatoid carcinoma" AND language_alias="sarcomatoid carcinoma"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_histology"), (SELECT id FROM structure_permissible_values WHERE value="other specify" AND language_alias="other specify"), "8", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_tumour_volume", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("low", "tumour volume low"),
("moderate", "tumour volume moderate"),
("high", "tumour volume high");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_tumour_volume"), (SELECT id FROM structure_permissible_values WHERE value="low" AND language_alias="tumour volume low"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_tumour_volume"), (SELECT id FROM structure_permissible_values WHERE value="moderate" AND language_alias="tumour volume moderate"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_tumour_volume"), (SELECT id FROM structure_permissible_values WHERE value="high" AND language_alias="tumour volume high"), "3", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_grade", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade"), (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "4", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_grade_and_none", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_and_none"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_and_none"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_and_none"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_and_none"), (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_and_none"), (SELECT id FROM structure_permissible_values WHERE value="none" AND language_alias="none"), "5", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_margins", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("cannot be assessed","cannot be assessed"),
("negative","negative"),
("positive","positive");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_margins"), 
(SELECT id FROM structure_permissible_values WHERE value="cannot be assessed" AND language_alias="cannot be assessed"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_margins"), 
(SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_margins"), 
(SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "3", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_margins_positive_precision", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("focal","focal: cancer touching ink in less equal than 3mm and in one slide only"),
("extensive","extensive");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_margins_positive_precision"), 
(SELECT id FROM structure_permissible_values WHERE value="focal" AND language_alias="focal: cancer touching ink in less equal than 3mm and in one slide only"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_margins_positive_precision"), 
(SELECT id FROM structure_permissible_values WHERE value="extensive" AND language_alias="extensive"), "3", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_extra_prostatic_extension", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("absent","absent"),
("present","present");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_extra_prostatic_extension"), 
(SELECT id FROM structure_permissible_values WHERE value="absent" AND language_alias="absent"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_extra_prostatic_extension"), 
(SELECT id FROM structure_permissible_values WHERE value="present" AND language_alias="present"), "3", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_extra_prostatic_extension_precision", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("focal","focal: cancer in peri-prostatic tissue in an area less than one 40X field in one slide only"),
("established","established");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_extra_prostatic_extension_precision"), 
(SELECT id FROM structure_permissible_values WHERE value="focal" AND language_alias="focal: cancer in peri-prostatic tissue in an area less than one 40X field in one slide only"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_extra_prostatic_extension_precision"), 
(SELECT id FROM structure_permissible_values WHERE value="established" AND language_alias="established"), "3", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_seminal_vesicles", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("absent","absent"),
("present","present");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_seminal_vesicles"), 
(SELECT id FROM structure_permissible_values WHERE value="absent" AND language_alias="absent"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_seminal_vesicles"), 
(SELECT id FROM structure_permissible_values WHERE value="present" AND language_alias="present"), "3", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_pathologic_staging_pt", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("pTx","pTx: insufficient data"),
("pT2","pT2: organ confined"),
("pT2a","pT2a: unilateral, involving one-half of one side or less"),
("pT2b","pT2b: unilateral, involving more than one-half of one side but not both"),
("pT2c","pT2c: bilateral disease"),
("pT2+","pT2+: positive surgical margins, otherwise organ-confined"),
("pT3a","pT3a: extraprostatic extension"),
("pT3b","pT3b: seminal vesicle invasion"),
("pT4","pT4: invasion of other adjacent structures such as bladder and/or rectum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pt"),(SELECT id FROM structure_permissible_values WHERE value="pTx" AND language_alias="pTx: insufficient data"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pt"),(SELECT id FROM structure_permissible_values WHERE value="pT2" AND language_alias="pT2: organ confined"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pt"),(SELECT id FROM structure_permissible_values WHERE value="pT2a" AND language_alias="pT2a: unilateral, involving one-half of one side or less"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pt"),(SELECT id FROM structure_permissible_values WHERE value="pT2b" AND language_alias="pT2b: unilateral, involving more than one-half of one side but not both"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pt"),(SELECT id FROM structure_permissible_values WHERE value="pT2c" AND language_alias="pT2c: bilateral disease"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pt"),(SELECT id FROM structure_permissible_values WHERE value="pT2+" AND language_alias="pT2+: positive surgical margins, otherwise organ-confined"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pt"),(SELECT id FROM structure_permissible_values WHERE value="pT3a" AND language_alias="pT3a: extraprostatic extension"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pt"),(SELECT id FROM structure_permissible_values WHERE value="pT3b" AND language_alias="pT3b: seminal vesicle invasion"), "8", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pt"),(SELECT id FROM structure_permissible_values WHERE value="pT4" AND language_alias="pT4: invasion of other adjacent structures such as bladder and/or rectum"), "9", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_pathologic_staging_pn", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("pNx","pNx: inufficient data"),
("pN0","pN0: no regional lymph node metastasis"),
("pN1","pN1: metastasis in regional lymph node(s)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pn"),(SELECT id FROM structure_permissible_values WHERE value="pNx" AND language_alias="pNx: inufficient data"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pn"),(SELECT id FROM structure_permissible_values WHERE value="pN0" AND language_alias="pN0: no regional lymph node metastasis"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pn"),(SELECT id FROM structure_permissible_values WHERE value="pN1" AND language_alias="pN1: metastasis in regional lymph node(s)"), "3", "1");

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_pathologic_staging_pm", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("pMx","pMx: insufficient data"),
("pM0","pM0: none"),
("pM1","pM1: distant metastasis"),
("pM1a","pM1a: non-regional lymph node(s)"),
("pM1b","pM1b: bone"),
("pM1c","pM1c: other sites");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pm"),(SELECT id FROM structure_permissible_values WHERE value="pMx" AND language_alias="pMx: insufficient data"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pm"),(SELECT id FROM structure_permissible_values WHERE value="pM0" AND language_alias="pM0: none"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pm"),(SELECT id FROM structure_permissible_values WHERE value="pM1" AND language_alias="pM1: distant metastasis"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pm"),(SELECT id FROM structure_permissible_values WHERE value="pM1a" AND language_alias="pM1a: non-regional lymph node(s)"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pm"),(SELECT id FROM structure_permissible_values WHERE value="pM1b" AND language_alias="pM1b: bone"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_pathologic_staging_pm"),(SELECT id FROM structure_permissible_values WHERE value="pM1c" AND language_alias="pM1c: other sites"), "6", "1");

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='procure_ed_pathology');
DELETE FROM structure_fields WHERE tablename = 'procure_ed_lab_pathologies';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'form_identification', 'input',  NULL , '0', 'size=30', '', '', 'identification', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'path_number', 'input',  NULL , '0', 'size=10', '', '', 'path report number', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'pathologist_name', 'input',  NULL , '0', 'size=30', '', '', 'pathologist name', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'prostate_weight_gr', 'float_positive',  NULL , '0', 'size=4', '', '', 'prostate', 'weight gr'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'prostate_length_cm', 'float_positive',  NULL , '0', 'size=4', '', '', '', 'length cm'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'prostate_width_cm', 'float_positive',  NULL , '0', 'size=4', '', '', '', 'width cm'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'prostate_thickness_cm', 'float_positive',  NULL , '0', 'size=4', '', '', '', 'thickness cm'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'right_seminal_vesicle_length_cm', 'float_positive',  NULL , '0', 'size=4', '', '', 'right seminal vesicle', 'length cm'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'right_seminal_vesicle_width_cm', 'float_positive',  NULL , '0', 'size=4', '', '', '', 'width cm'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'right_seminal_vesicle_thickness_cm', 'float_positive',  NULL , '0', 'size=4', '', '', '', 'thickness cm'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'left_seminal_vesicle_length_cm', 'float_positive',  NULL , '0', 'size=4', '', '', 'left seminal vesicle', 'length cm'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'left_seminal_vesicle_width_cm', 'float_positive',  NULL , '0', 'size=4', '', '', '', 'width cm'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'left_seminal_vesicle_thickness_cm', 'float_positive',  NULL , '0', 'size=4', '', '', '', 'thickness cm'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'histology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_histology') , '0', '', '', '', 'histology', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'histology_other_precision', 'input',  NULL , '0', 'size=30', '', '', 'other precision', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'tumour_location_right_anterior', 'checkbox',  NULL , '0', '', '', '', 'anterior', 'right'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'tumour_location_left_anterior', 'checkbox',  NULL , '0', '', '', '', '', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'tumour_location_right_posterior', 'checkbox',  NULL , '0', '', '', '', 'posterior', 'right'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'tumour_location_left_posterior', 'checkbox',  NULL , '0', '', '', '', '', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'tumour_location_apex', 'checkbox',  NULL , '0', '', '', '', 'apex', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'tumour_location_base', 'checkbox',  NULL , '0', '', '', '', 'base', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'tumour_location_bladder_neck', 'checkbox',  NULL , '0', '', '', '', 'bladder neck', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'tumour_volume', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_tumour_volume') , '0', '', '', '', 'tumour volume', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'histologic_grade_primary_pattern', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_grade') , '0', '', '', '', 'primary pattern', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'histologic_grade_secondary_pattern', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_grade') , '0', '', '', '', 'secondary pattern', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'histologic_grade_tertiary_pattern', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_grade_and_none') , '0', '', '', '', 'tertiary pattern', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'histologic_grade_gleason_score', 'input',  NULL , '0', 'size=5', '', '', 'total gleason score', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_margins') , '0', '', '', '', 'margins', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_focal_or_extensive', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_margins_positive_precision') , '0', '', '', '', 'positive precision', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_extensive_anterior_left', 'checkbox',  NULL , '0', '', '', '', 'anterior', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_extensive_anterior_right', 'checkbox',  NULL , '0', '', '', '', '', 'right'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_extensive_posterior_left', 'checkbox',  NULL , '0', '', '', '', 'posterior', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_extensive_posterior_right', 'checkbox',  NULL , '0', '', '', '', '', 'right'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_extensive_apical_anterior_left', 'checkbox',  NULL , '0', '', '', '', 'apical anterior', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_extensive_apical_anterior_right', 'checkbox',  NULL , '0', '', '', '', '', 'right'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_extensive_apical_posterior_left', 'checkbox',  NULL , '0', '', '', '', 'apical posterior', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_extensive_apical_posterior_right', 'checkbox',  NULL , '0', '', '', '', '', 'right'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_extensive_bladder_neck', 'checkbox',  NULL , '0', '', '', '', 'bladder neck', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_gleason_score', 'input',  NULL , '0', 'size=5', '', '', 'margins gleason score', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'extra_prostatic_extension', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_extra_prostatic_extension') , '0', '', '', '', 'extra prostatic extension', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'extra_prostatic_extension_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_extra_prostatic_extension_precision') , '0', '', '', '', 'extra prostatic extension precision', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'extra_prostatic_extension_right_anterior', 'checkbox',  NULL , '0', '', '', '', 'anterior', 'right'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'extra_prostatic_extension_left_anterior', 'checkbox',  NULL , '0', '', '', '', '', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'extra_prostatic_extension_right_posterior', 'checkbox',  NULL , '0', '', '', '', 'posterior', 'right'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'extra_prostatic_extension_left_posterior', 'checkbox',  NULL , '0', '', '', '', '', 'left'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'extra_prostatic_extension_apex', 'checkbox',  NULL , '0', '', '', '', 'apex', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'extra_prostatic_extension_base', 'checkbox',  NULL , '0', '', '', '', 'base', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'extra_prostatic_extension_bladder_neck', 'checkbox',  NULL , '0', '', '', '', 'bladder neck', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'extra_prostatic_extension_seminal_vesicles', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_seminal_vesicles') , '0', '', '', '', 'seminal vesicles', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'pathologic_staging_version', 'input',  NULL , '0', 'size=10', '', '', 'version', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'pathologic_staging_pt', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_pathologic_staging_pt') , '0', '', '', '', 'primary tumour (pt)', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'pathologic_staging_pn_collected', 'yes_no',  NULL , '0', '', '', '', 'regional lymph nodes collected', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'pathologic_staging_pn', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_pathologic_staging_pn') , '0', '', '', '', 'regional lymph nodes (pn)', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'pathologic_staging_pn_lymph_node_examined', 'integer_positive',  NULL , '0', 'size=3', '', '', 'specify number of lymph nodes', 'examined'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'pathologic_staging_pn_lymph_node_involved', 'integer_positive',  NULL , '0', 'size=3', '', '', '', 'involved'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'pathologic_staging_pm', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_pathologic_staging_pm') , '0', '', '', '', 'distant metastasis (pm)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='form_identification'), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='path_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='path report number' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '10', '', '1', 'comments', '0', '', '0', '', '0', '', '1', 'cols=30,rows=3', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='pathologist_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='pathologist name' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='prostate_weight_gr' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='prostate' AND `language_tag`='weight gr'), '1', '20', 'measurements', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='prostate_length_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='length cm'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='prostate_width_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='width cm'), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='prostate_thickness_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='thickness cm'), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='right_seminal_vesicle_length_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='right seminal vesicle' AND `language_tag`='length cm'), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='right_seminal_vesicle_width_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='width cm'), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='right_seminal_vesicle_thickness_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='thickness cm'), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='left_seminal_vesicle_length_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='left seminal vesicle' AND `language_tag`='length cm'), '1', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='left_seminal_vesicle_width_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='width cm'), '1', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='left_seminal_vesicle_thickness_cm' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='thickness cm'), '1', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histology' AND `language_tag`=''), '2', '40', '1) histology', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='histology_other_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='other precision' AND `language_tag`=''), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_location_right_anterior' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='anterior' AND `language_tag`='right'), '2', '50', '2) tumour location', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_location_left_anterior' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='left'), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_location_right_posterior' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='posterior' AND `language_tag`='right'), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_location_left_posterior' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='left'), '2', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_location_apex' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='apex' AND `language_tag`=''), '2', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_location_base' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='base' AND `language_tag`=''), '2', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_location_bladder_neck' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bladder neck' AND `language_tag`=''), '2', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='tumour_volume' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_tumour_volume')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumour volume' AND `language_tag`=''), '2', '60', '3) tumour volume', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='histologic_grade_primary_pattern' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='primary pattern' AND `language_tag`=''), '2', '70', '4) histologic grade', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='histologic_grade_secondary_pattern' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='secondary pattern' AND `language_tag`=''), '2', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='histologic_grade_tertiary_pattern' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_grade_and_none')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tertiary pattern' AND `language_tag`=''), '2', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='histologic_grade_gleason_score' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='total gleason score' AND `language_tag`=''), '2', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_margins')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='margins' AND `language_tag`=''), '3', '80', '5) margins', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_focal_or_extensive' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_margins_positive_precision')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='positive precision' AND `language_tag`=''), '3', '81', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_extensive_anterior_left' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='anterior' AND `language_tag`='left'), '3', '82', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_extensive_anterior_right' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='right'), '3', '83', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_extensive_posterior_left' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='posterior' AND `language_tag`='left'), '3', '84', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_extensive_posterior_right' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='right'), '3', '85', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_extensive_apical_anterior_left' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='apical anterior' AND `language_tag`='left'), '3', '86', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_extensive_apical_anterior_right' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='right'), '3', '87', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_extensive_apical_posterior_left' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='apical posterior' AND `language_tag`='left'), '3', '88', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_extensive_apical_posterior_right' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='right'), '3', '89', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_extensive_bladder_neck' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bladder neck' AND `language_tag`=''), '3', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_gleason_score' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='margins gleason score' AND `language_tag`=''), '3', '91', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_extra_prostatic_extension')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='extra prostatic extension' AND `language_tag`=''), '3', '100', '6) extra prostatic extension', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_extra_prostatic_extension_precision')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='extra prostatic extension precision' AND `language_tag`=''), '3', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_right_anterior' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='anterior' AND `language_tag`='right'), '3', '102', '7) location of extra-prostatic extension', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_left_anterior' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='left'), '3', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_right_posterior' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='posterior' AND `language_tag`='right'), '3', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_left_posterior' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='left'), '3', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_apex' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='apex' AND `language_tag`=''), '3', '106', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_base' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='base' AND `language_tag`=''), '3', '107', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_bladder_neck' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bladder neck' AND `language_tag`=''), '3', '108', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='extra_prostatic_extension_seminal_vesicles' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_seminal_vesicles')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='seminal vesicles' AND `language_tag`=''), '3', '109', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='pathologic_staging_version' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='version' AND `language_tag`=''), '3', '120', '8) pathologic staging', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='pathologic_staging_pt' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_pathologic_staging_pt')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='primary tumour (pt)' AND `language_tag`=''), '3', '121', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='pathologic_staging_pn_collected' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='regional lymph nodes collected' AND `language_tag`=''), '3', '122', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='pathologic_staging_pn' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_pathologic_staging_pn')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='regional lymph nodes (pn)' AND `language_tag`=''), '3', '123', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='pathologic_staging_pn_lymph_node_examined' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='specify number of lymph nodes' AND `language_tag`='examined'), '3', '124', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='pathologic_staging_pn_lymph_node_involved' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='involved'), '3', '125', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='pathologic_staging_pm' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_pathologic_staging_pm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='distant metastasis (pm)' AND `language_tag`=''), '3', '126', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- i18n 	Pathology report number

REPLACE INTO i18n (id,en,fr) VALUES
('procure pathology report', "F12 - Pathology report","F12 - Rapport de pathologie"),
('path report number','Pathology report number','Numéro du rapport de pathologie'),
('pathologist name','Pathologist first/last name','Nom/Prénom pathologiste:'),
('comments','Comments','Commentaires'),

('measurements', "Measurements","Dimensions"),
('weight gr', "Weight (gr)","Poids (gr)"),
('length cm', "Length (cm)","Longueur (cm)"),
('width cm', "Width (cm)","Largeur (cm)"),
('thickness cm', "Thickness (cm)","Épaisseur (cm)"),
('right seminal vesicle', "Right seminal vesicle","Vésicule séminale droite"),
('left seminal vesicle', "Left seminal vesicle","Vésicule séminale gauche"),

('acinar adenocarcinoma/usual type', "Acinar adenocarcinoma/usual type", "Adénocarcinome acinaire ou du type usuel"),
('prostatic ductal adenocarcinoma', "Prostatic ductal adenocarcinoma", "Adénocarcinome canalaire"),
('mucinous adenocarcinoma', "Mucinous adenocarcinoma", "Adénocarcinome mucineux"),
('signet-ring cell carcinoma', "Signet-ring cell carcinoma", "Carcinome à cellules indépendantes"),
('adenosquamous carcinoma', "Adenosquamous carcinoma", "Carcinome adénosquameux"),
('small cell carcinoma', "Small cell carcinoma", "Carcinome à petites cellules"),
('sarcomatoid carcinoma', "Sarcomatoid carcinoma", "Carcinome sarcomatoïde"),
('other specify', "Other (specify)", "Autre (spécifiez)"),

("1) histology","1) Histology (check what applies)","1) Histologie (Cochez tout ce qui s'applique)"),
("other precision","Other precision","Autre précision"),
("2) tumour location", "2) Tumour location (check all that apply)", "2) Localisation de la tumeur (cochez ce qui s'applique)"),
("anterior","Anterior","Antérieur"),
("posterior","Posterior","Postérieur"),
("apex","Apex","Apex"),
("base","Base","Base"),
("bladder neck","Bladder neck","Col vésical"),

("3) tumour volume", "3) Tumour volume (check what applies)", "3) Volume tumoral total (cochez ce qui s'applique)"),
("tumour volume", "Volume", "Volume"),
("tumour volume low", "Low (<30pc)", "Atteinte légère (<30pc)"),
("tumour volume moderate", "Moderate (30-60pc)", "Atteinte modérée (30-60pc)"),
("tumour volume high", "High (>60pc)", "Atteinte extensive (>60pc)"),

("4) histologic grade", "4) Histologic grade", "4) Patron histologique"),
("primary pattern", "Primary pattern", "Patron primaire"),
("secondary pattern", "Secondary pattern", "Patron secondaire"),
("tertiary pattern", "Tertiary pattern", "Patron tertiaire"),
("total gleason score", "Gleason score", "Score de Gleason"),

("focal: cancer touching ink in less equal than 3mm and in one slide only","Focal: cancer touching ink in =< and in one slide only","Focale:cancer touchant l'encre (=<3mm) dans une lame seulement"),

("5) margins","5) Margins (check what applies)","5) Marges (cochez ce qui s'applique)"),
("extensive","Extensive","Extensive"),
("positive precision","Precision (positive)","Précision (positive)"),
("apical anterior","Apical region anterior","Région apicale antérieur"),
("apical posterior","Apical region posterior","Région apicale postérieure"),
("margins gleason score","Gleason score at margins","Score de Gleason aux marges"),

("6) extra prostatic extension","6) Extra-prostatic extension","6) Extension extraprostatique"),
("absent","Absent","Absente"),
("present","Present","Présente"),
("focal: cancer in peri-prostatic tissue in an area less than one 40X field in one slide only","Focal: cancer in peri-prostatic tissue in an area less than one 40X field in one slide only","Focale: dans tissu périprostatique sur une surface inférieure à un champ 40X pour une lame seulement"),
("established","Established","Établie"),

("extra prostatic extension","Extension","Extension"),
("extra prostatic extension precision","Precision (extension)","Précision (extension)"),

("7) location of extra-prostatic extension","7) Location of extra-prostatic extension (check all that apply)","7) Localisation de l'extension extraprostatique (cochez ce qui s'applique)"),
("seminal vesicles","Seminal vesicles","Vésicules séminales"),

("8) pathologic staging","8) Pathologic staging","8) Stade pathologique"),
("version","Version","Version"),
("primary tumour (pt)","Primary tumour (pT)","Tumeur primaire (pT)"),
("regional lymph nodes collected","Regional lymph nodes collected","Adénopathies régionales/ganglions collectés"),
("regional lymph nodes (pn)","Regional lymph nodes (pN)","Adénopathies régionales/ganglions (pN)"),
("specify number of lymph nodes","Specify number","Spécifiez le nombre"),
("examined","Examined","Examiné(s)"),
("involved","Involved","Atteint(s)"),
("distant metastasis (pm)","Distant metastasis","Métastase(s) à distance (pM)"),

("pTx: insufficient data","pTx: Insufficient data","pTx: Renseignements insuffisants"),
("pT2: organ confined","pT2:Organ confined","pT2: Confinée à la prostate"),
("pT2a: unilateral, involving one-half of one side or less","pT2a: Unilateral, involving one-half of one side or less","pT2a: Unilatérale, envahissant la moitié ou moins d'un lobe"),
("pT2b: unilateral, involving more than one-half of one side but not both","pT2b: Unilateral, involving more than one-half of one side but not both","pT2b: Unilatérale, envahissant plus de la moitié d'un lobe mais pas les deux"),
("pT2c: bilateral disease","pT2c: Bilateral disease","pT2c: Bilatérale"),
("pT2+: positive surgical margins, otherwise organ-confined","pT2+: Positive surgical margins, otherwise organ-confined","pT2+: Confinée à la prostate avec des marges chirurgicales positives"),
("pT3a: extraprostatic extension","pT3a: Extraprostatic extension","pT3a: Avec extension extra-prostatique"),
("pT3b: seminal vesicle invasion","pT3b: Seminal vesicle invasion","pT3b: Avec envahissement de la paroi musculaire d'une ou des vésicules séminales"),
("pT4: invasion of other adjacent structures such as bladder and/or rectum","pT4: Invasion of other adjacent structures such as bladder and/or rectum","pT4: Tumeur fixée au bassin ou envahissant d'autres structures adjacentes telles que le rectum et/ou la vessie"),
					
("pNx: inufficient data","pNx: Inufficient data","pNx: Renseignements insuffisants"),
("pN0: no regional lymph node metastasis","pN0: No regional lymph node metastasis","pN0: Pas d'atteinte des ganglions lymphatiques régionaux"),
("pN1: metastasis in regional lymph node(s)","pN1: Metastasis in regional lymph node (s)","pN1: Atteinte des ganglions lymphatiques régionaux"),
					
("pMx: insufficient data","pMx: Insufficient data","pMx:Renseignement insuffisants"),
("pM0: none","pM0: None","pM0: Aucune"),
("pM1: distant metastasis","pM1: distant metastasis","pM1: Métastases à distance"),
("pM1a: non-regional lymph node(s)","pM1a: Non-regional lymph node(s)","pM1a: Ganglions lymphatiques non régionaux"),
("pM1b: bone","pM1b: Bone","pM1b: Os"),
("pM1c: other sites","pM1c: Other sites","pM1c: Autre(s) site(s)");

REPLACE INTO i18n (id,en,fr) VALUES
('pm1: distant metastasis',"pM1: Distant metastasis","pM1: Métastases à distance"),
('pn0: no regional lymph node metastasis',"pN0: No regional lymph node metastasis","pN0: Pas d'atteinte des ganglions lymphatiques régionaux");

UPDATE structure_formats SET `display_order`='-6' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='form_identification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `structure_validations` (`structure_field_id` , `rule` ) VALUES ((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `field`='form_identification' AND `type`='input'), 'notEmpty');
INSERT INTO `structure_validations` (`structure_field_id` , `rule` ) VALUES ((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `field`='form_identification' AND `type`='input'), 'isUnique');





