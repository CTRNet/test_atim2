-- ------------------------------------------------------
-- ATiM xxxxx Data Script
-- version: 2.7.2
-- ------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Hide 'Consent National' fields
-- ................................................................................
-- Fields :
--     - Person Handling Consent
--     - Process Status
--     - Facilty 
--     - Facility Other
--     - Operation Date
-- --------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='cd_nationals') 
AND structure_field_id IN (
  SELECT id FROM structure_fields 
  WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field` IN ('operation_date', 'process_status', 'consent_person', 'facility', 'facility_other')
);

-- --------------------------------------------------------------------------------
-- Create a 'Study Consent'
-- ................................................................................
-- Let user to create specific consents a participant has to signed to be part of 
-- a study.
-- --------------------------------------------------------------------------------

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_link_to_study`) 
VALUES
(null, 'study consent', 1, 'consent_masters_study', 'cd_nationals', 0, 'study consent', '1');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('study consent', 'Sudy Consent', 'Consentement d''étude');

-- --------------------------------------------------------------------------------
-- Create a demo 'Bank Consent'
-- ................................................................................
-- Consent with following fields`
--     - agreements
--     - biological material use
--     - use of urine
--     - use of blood
--     - use of faeces
--     - acces to medical records
--     - questionnaire
--     - allow questionnaire
--     - stop questionnaire
--     - stop questionnaire date
--     - urine blood use for followup
--     - stop followup
--     - stop followup date
--     - contact agreement
--     - contact for additional data
--     - inform significant discovery
--     - research other disease
--     - inform discovery on other disease
-- --------------------------------------------------------------------------------

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) 
VALUES
(null, 'ctrnet demo - consent bank', 1, 'ctrnet_demo_cd_bank', 'ctrnet_demo_cd_banks', 0, 'ctrnet demo - consent bank');

DROP TABLE IF EXISTS `ctrnet_demo_cd_banks`;
CREATE TABLE `ctrnet_demo_cd_banks` (
  `consent_master_id` int(11) NOT NULL,
  `use_of_biological_material`char(1) DEFAULT '',
  `use_of_urine` char(1) DEFAULT '',
  `use_of_blood` char(1) DEFAULT '',
  `use_of_faeces` char(1) DEFAULT '',
  `allow_questionnaire` char(1) DEFAULT '',
  `stop_questionnaire` char(1) DEFAULT '',
  `stop_questionnaire_date` date DEFAULT NULL,
  `stop_questionnaire_date_accuracy` char(1) NOT NULL DEFAULT '',
  `urine_blood_use_for_followup` char(1) DEFAULT '',
  `stop_followup` char(1) DEFAULT '',
  `stop_followup_date` date DEFAULT NULL,
  `stop_followup_date_accuracy` char(1) NOT NULL DEFAULT '',
  `acces_to_medical_records` char(1) DEFAULT NULL,
  `contact_for_additional_data` char(1) DEFAULT '',
  `inform_significant_discovery` char(1) DEFAULT '',
  `research_other_disease` char(1) DEFAULT '',
  `inform_discovery_on_other_disease` char(1) DEFAULT '',
  KEY `consent_master_id` (`consent_master_id`),
  CONSTRAINT `ctrnet_demo_cd_banks_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ctrnet_demo_cd_banks_revs`;
CREATE TABLE IF NOT EXISTS `ctrnet_demo_cd_banks_revs` (
  `consent_master_id` int(11) NOT NULL,
  `use_of_biological_material`char(1) DEFAULT '',
  `use_of_urine` char(1) DEFAULT '',
  `use_of_blood` char(1) DEFAULT '',
  `use_of_faeces` char(1) DEFAULT '',
  `allow_questionnaire` char(1) DEFAULT '',
  `stop_questionnaire` char(1) DEFAULT '',
  `stop_questionnaire_date` date DEFAULT NULL,
  `stop_questionnaire_date_accuracy` char(1) NOT NULL DEFAULT '',
  `urine_blood_use_for_followup` char(1) DEFAULT '',
  `stop_followup` char(1) DEFAULT '',
  `stop_followup_date` date DEFAULT NULL,
  `stop_followup_date_accuracy` char(1) NOT NULL DEFAULT '',
  `acces_to_medical_records` char(1) DEFAULT NULL,
  `contact_for_additional_data` char(1) DEFAULT '',
  `inform_significant_discovery` char(1) DEFAULT '',
  `research_other_disease` char(1) DEFAULT '',
  `inform_discovery_on_other_disease` char(1) DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ctrnet_demo_cd_bank');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'use_of_biological_material', 'yes_no',  NULL , '0', '', '', '', 'biological material use', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'use_of_urine', 'yes_no',  NULL , '0', '', '', '', 'use of urine', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'use_of_blood', 'yes_no',  NULL , '0', '', '', '', 'use of blood', ''),
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'use_of_faeces', 'yes_no',  NULL , '0', '', '', '', 'use of faeces', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'acces_to_medical_records', 'yes_no',  NULL , '0', '', '', '', 'acces to medical records', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'allow_questionnaire', 'yes_no',  NULL , '0', '', '', '', 'allow questionnaire', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'stop_questionnaire', 'yes_no',  NULL , '0', '', '', '', 'stop questionnaire', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'stop_questionnaire_date', 'date',  NULL , '0', '', '', '', 'stop questionnaire date', ''),
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'urine_blood_use_for_followup', 'yes_no',  NULL , '0', '', '', '', 'urine blood use for followup', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'stop_followup', 'yes_no',  NULL , '0', '', '', '', 'stop followup', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'stop_followup_date', 'date',  NULL , '0', '', '', '', 'stop followup date', ''),
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'contact_for_additional_data', 'yes_no',  NULL , '0', '', '', '', 'contact for additional data', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'inform_significant_discovery', 'yes_no',  NULL , '0', '', '', '', 'inform significant discovery', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'research_other_disease', 'yes_no',  NULL , '0', '', '', '', 'research other disease', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'ctrnet_demo_cd_banks', 'inform_discovery_on_other_disease', 'yes_no',  NULL , '0', '', '', '', 'inform discovery on other disease', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='use_of_biological_material' AND `type`='yes_no'), 
'2', '10', 'agreements', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='use_of_urine' AND `type`='yes_no'), 
'2', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='use_of_blood' AND `type`='yes_no'), 
'2', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='use_of_faeces' AND `type`='yes_no'), 
'2', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='acces_to_medical_records' AND `type`='yes_no'), 
'2', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='allow_questionnaire' AND `type`='yes_no'), 
'2', '20', 'questionnaire', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='stop_questionnaire' AND `type`='yes_no'), 
'2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='stop_questionnaire_date' AND `type`='date'), 
'2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='urine_blood_use_for_followup' AND `type`='yes_no'), 
'2', '30', 'followup', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='stop_followup' AND `type`='yes_no'), 
'2', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='stop_followup_date' AND `type`='date'), 
'2', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='contact_for_additional_data' AND `type`='yes_no'), 
'2', '40', 'contact agreement', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='inform_significant_discovery' AND `type`='yes_no'), 
'2', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='research_other_disease' AND `type`='yes_no'), 
'2', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ctrnet_demo_cd_bank'), 
(SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='ctrnet_demo_cd_banks' AND `field`='inform_discovery_on_other_disease' AND `type`='yes_no'), 
'2', '43', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
("ctrnet demo - consent bank", "CTRNet Demo - Bank Consent", "CTRNet Démo - Consentement des banques"),
("acces to medical records", "Acces to Medical Records", "Accès au dossier médical"),
("agreements", "Agreements", "Autorisations"),
("allow questionnaire", "Allow Questionnaire", "Autorise questionnaire"),
("biological material use", "Biological Material Use", "Utilisation du materiel biologique"),
("contact agreement", "Contact Agreement", "Autorisation de contact"),
("contact for additional data", "Contact for additional data", "Contact pour données suplémentaires"),
("inform discovery on other disease", "Inform discovery on other disease", "Informer des découvertes sur autre maladie"),
("inform significant discovery", "Inform of disease significant discovery", "Informer des découvertes importantes sur la maladie"),
("questionnaire", "Questionnaire", "Questionnaire"),
("research other disease", "Research On Other Diseases", "Recherche sur autres maladies"),
("stop followup", "Stop Followup", "Arrêt du suivi"),
("stop followup date", "Stop Date", "Date d'arrêt"),
("stop questionnaire", "Stop Questionnaire", "Arrêt du questionnaire"),
("stop questionnaire date", "Stop Date", "Date d'arrêt"),
("urine blood use for followup", "Urine/Blood Use For Followup", "Utilisation urine/sang pour suivi"),
("use of blood", "Use of Blood", "Utilisation du sang"),
("use of faeces", "Use of Faeces", "Utilisation matières fécales"),
("use of urine", "Use of Urine", "Utilisation de l'urine");

-- --------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;