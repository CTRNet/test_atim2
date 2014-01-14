INSERT INTO i18n (id,en,fr) VALUES ('core_installname', 'CHUM - Transplant', 'CHUM - Transplant');
UPDATE groups SET flag_show_confidential = '1' WHERE id = 1;
UPDATE versions SET permissions_regenerated = 0;
UPDATE structure_permissible_values_custom_controls SET flag_active = 0;
UPDATE users SET flag_active = 1 WHERE id = 1;

-- -----------------------------------------------------------------------------------------------------------------------------
-- participants
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_detail`='0', `flag_summary`='0' ,`flag_index`='0'
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field` IN ('secondary_cod_icd10_code','race','title','language_preferred','marital_status','middle_name','cod_confirmation_source','','cod_icd10_code'));
ALTER TABLE participants ADD COLUMN chum_transplant_initials VARCHAR(10) DEFAULT NULL;
ALTER TABLE participants_revs ADD COLUMN chum_transplant_initials VARCHAR(10) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'chum_transplant_initials', 'input',  NULL , '0', 'size=5', '', '', 'initials', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_transplant_initials' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initials' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('initials','Initials','Initiales');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_transplant_initials' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations (structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE field = 'participant_identifier' AND model = 'Participant'), 'custom,/CHUM[0-9]{5}/', 'wrong participant identifier format - expected format CHUM00000');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_transplant_initials' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations (structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE field = 'chum_transplant_initials' AND model = 'Participant'), 'notEmpty');
ALTER TABLE participants
	ADD COLUMN chum_transplant_project_status VARCHAR(30) DEFAULT NULL,
	ADD COLUMN chum_transplant_project_status_date DATE DEFAULT NULL,
	ADD COLUMN chum_transplant_project_status_date_accuracy char(1) NOT NULL DEFAULT '',
	ADD COLUMN chum_transplant_project_status_reason VARCHAR(250) DEFAULT NULL;
ALTER TABLE participants_revs
	ADD COLUMN chum_transplant_project_status VARCHAR(30) DEFAULT NULL,
	ADD COLUMN chum_transplant_project_status_date DATE DEFAULT NULL,
	ADD COLUMN chum_transplant_project_status_date_accuracy char(1) NOT NULL DEFAULT '',
	ADD COLUMN chum_transplant_project_status_reason VARCHAR(250) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("chum_transplant_project_status", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES ("in process", "in process"),("completed", "completed"),("discontinued", "discontinued"),("withdrawn", "withdrawn");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_project_status"), 
(SELECT id FROM structure_permissible_values WHERE value="in process" AND language_alias="in process"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_project_status"), 
(SELECT id FROM structure_permissible_values WHERE value="completed" AND language_alias="completed"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_project_status"), 
(SELECT id FROM structure_permissible_values WHERE value="discontinued" AND language_alias="discontinued"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_project_status"), 
(SELECT id FROM structure_permissible_values WHERE value="withdrawn" AND language_alias="withdrawn"), "4", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'chum_transplant_project_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_project_status') , '0', '', '', '', 'status', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'chum_transplant_project_status_date', 'date',  NULL , '0', '', '', '', 'status date', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'chum_transplant_project_status_reason', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'reason', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_transplant_project_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_project_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='status' AND `language_tag`=''), '3', '20', 'project status', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_transplant_project_status_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='status date' AND `language_tag`=''), '3', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_transplant_project_status_reason' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='reason' AND `language_tag`=''), '3', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sex') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='race') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
INSERT INTO structure_validations (structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE field = 'chum_transplant_project_status' AND model = 'Participant'), 'notEmpty');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('project status', 'Project Status', 'Statu de projet'), ('discontinued','Discontinued','Discontinué'),('reason','Reason','Raison');
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES ("pending", "pending");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_project_status"), 
(SELECT id FROM structure_permissible_values WHERE value="pending" AND language_alias="pending"), "3", "1");
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_transplant_initials' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit_readonly`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------
-- Misc Identifier
-- -----------------------------------------------------------------------------------------------------------------------------

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `reg_exp_validation`) 
VALUES 
(NULL, 'ND#', '1', '', NULL, 
'1', '1', '1', ''),
(NULL, 'SL#', '1', '', NULL, 
'1', '1', '1', ''),
(NULL, 'HD#', '1', '', NULL, 
'1', '1', '1', '');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('ND#', 'ND#', 'ND#'),('SL#', 'SL#', 'SL#'),('HD#', 'HD#', 'HD#');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field` IN ('effective_date', 'expiry_date', 'notes'));

-- -----------------------------------------------------------------------------------------------------------------------------
-- Contact
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='contact_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='contact_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='street' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='locality' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='region' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='provinces') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='country' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='mail_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='other_contact_type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_secondary_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='phone_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone_secondary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations (structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='relationship'), 'notEmpty');

-- -----------------------------------------------------------------------------------------------------------------------------
-- Consent
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE consent_controls SET flag_active = 0;
INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'transplant bank', 1, 'chum_transplant_cd_mains', 'chum_transplant_cd_mains', 0, 'transplant bank');
ALTER TABLE consent_masters MODIFY consent_signed_date DATETIME DEFAULT NULL;
ALTER TABLE consent_masters_revs MODIFY consent_signed_date DATETIME DEFAULT NULL;
UPDATE structure_fields SET type = 'datetime', setting = '' WHERE field = 'consent_signed_date' AND model = 'ConsentMaster';
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
CREATE TABLE IF NOT EXISTS `chum_transplant_cd_mains` (
  `consent_master_id` int(11) NOT NULL,
  revision_date DATE DEFAULT NULL,
  revision_date_accuracy char(1) NOT NULL DEFAULT '',  
  questionnaire_delivery_date DATE DEFAULT NULL,
  questionnaire_delivery_date_accuracy char(1) NOT NULL DEFAULT '',  
  questionnaire_reception_date DATE DEFAULT NULL,
  questionnaire_reception_date_accuracy char(1) NOT NULL DEFAULT '',  
  material_use_for_research_and_clinical_data_access char(1) default '',
  blood_collection char(1) default '',
  urine_collection char(1) default '',
  contact_for_more_information char(1) default '',
  research_on_other_disease char(1) default '',
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chum_transplant_cd_mains_revs` (
  `consent_master_id` int(11) NOT NULL,
  revision_date DATE DEFAULT NULL,
  revision_date_accuracy char(1) NOT NULL DEFAULT '',  
  questionnaire_delivery_date DATE DEFAULT NULL,
  questionnaire_delivery_date_accuracy char(1) NOT NULL DEFAULT '',  
  questionnaire_reception_date DATE DEFAULT NULL,
  questionnaire_reception_date_accuracy char(1) NOT NULL DEFAULT '',  
  material_use_for_research_and_clinical_data_access char(1) default '',
  blood_collection char(1) default '',
  urine_collection char(1) default '',
  contact_for_more_information char(1) default '',
  research_on_other_disease char(1) default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chum_transplant_cd_mains`
  ADD CONSTRAINT `chum_transplant_cd_mains_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('chum_transplant_cd_mains');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'chum_transplant_cd_mains', 'revision_date', 'date',  NULL , '0', '', '', '', 'revision date', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'chum_transplant_cd_mains', 'material_use_for_research_and_clinical_data_access', 'yes_no',  NULL , '0', '', '', '', 'material used for research and clinical data access', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'chum_transplant_cd_mains', 'blood_collection', 'yes_no',  NULL , '0', '', '', '', 'blood collection', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'chum_transplant_cd_mains', 'urine_collection', 'yes_no',  NULL , '0', '', '', '', 'urine collection', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'chum_transplant_cd_mains', 'contact_for_more_information', 'yes_no',  NULL , '0', '', '', '', 'contact for more information', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'chum_transplant_cd_mains', 'research_on_other_disease', 'yes_no',  NULL , '0', '', '', '', 'research on other disease', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'chum_transplant_cd_mains', 'questionnaire_delivery_date', 'date',  NULL , '0', '', '', '', 'delivery date', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'chum_transplant_cd_mains', 'questionnaire_reception_date', 'date',  NULL , '0', '', '', '', 'reception date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_transplant_cd_mains'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chum_transplant_cd_mains' AND `field`='revision_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='revision date' AND `language_tag`=''), '1', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_cd_mains'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chum_transplant_cd_mains' AND `field`='material_use_for_research_and_clinical_data_access' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='material used for research and clinical data access' AND `language_tag`=''), '2', '60', 'consent data', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_cd_mains'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chum_transplant_cd_mains' AND `field`='blood_collection' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='blood collection' AND `language_tag`=''), '2', '61', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_cd_mains'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chum_transplant_cd_mains' AND `field`='urine_collection' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='urine collection' AND `language_tag`=''), '2', '62', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_cd_mains'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chum_transplant_cd_mains' AND `field`='contact_for_more_information' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact for more information' AND `language_tag`=''), '2', '63', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_cd_mains'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chum_transplant_cd_mains' AND `field`='research_on_other_disease' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='research on other disease' AND `language_tag`=''), '2', '64', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_cd_mains'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chum_transplant_cd_mains' AND `field`='questionnaire_delivery_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='delivery date' AND `language_tag`=''), '2', '70', 'questionnaire', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_cd_mains'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chum_transplant_cd_mains' AND `field`='questionnaire_reception_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reception date' AND `language_tag`=''), '2', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('transplant bank','Transplant Bank','Banque de transplantation'),
('transplant','Transplant','Transplantation'),
('questionnaire','Questionnaire','Questionnaire'),
('urine collection','Urine Collection','Collection urine'),
('revision date','Revision Date', 'Date de révision'),
('consent data','Data','Données'),
('blood collection','Blood Collection','Colelction sang'),
('delivery date','Delivery Date','Date de révision'),
('material used for research and clinical data access', 'Material used for research and clinical data access', 'Matériel utilisé pour la recherche et accès aux données cliniques'),
('contact for more information','Contact for more information','Contacter pour plus d''informations'),
('research on other disease','Research on other disease','Recherche sur d''autres maladies');
UPDATE  structure_permissible_values_custom_controls SET flag_active = 1 WHERE name = 'consent form versions ';

-- -----------------------------------------------------------------------------------------------------------------------------
-- Diagnosis
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE diagnosis_controls SET flag_active = 0;
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters/%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id2 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster'));

-- -----------------------------------------------------------------------------------------------------------------------------
-- Annotation
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/%' AND use_link NOT LIKE '%/Study%' AND use_link NOT LIKE '%/Clinical/%';
UPDATE event_controls SET flag_active = 0;
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'study', 'other research protocol', 1, 'chum_transplant_ed_other_protocols', 'chum_transplant_ed_other_protocols', 0, 'other research protocol', 0, 1, 1);
CREATE TABLE IF NOT EXISTS `chum_transplant_ed_other_protocols` (
  `name` varchar(250) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chum_transplant_ed_other_protocols_revs` (
  `name` varchar(250) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chum_transplant_ed_other_protocols`
  ADD CONSTRAINT `chum_transplant_ed_other_protocols_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
INSERT INTO structures(`alias`) VALUES ('chum_transplant_ed_other_protocols');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'chum_transplant_ed_other_protocols', 'name', 'input',  NULL , '0', 'size=30', '', '', 'name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_transplant_ed_other_protocols'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_ed_other_protocols'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chum_transplant_ed_other_protocols' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('other research protocol','Other Research Protocol','Autre protocole de recherche');
INSERT INTO structure_validations (structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE field = 'name' AND tablename = 'chum_transplant_ed_other_protocols'), 'notEmpty');
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'clinical', 'biopsy', 1, 'chum_transplant_ed_biopsies', 'chum_transplant_ed_biopsies', 0, 'biopsy', 1, 0, 1);
CREATE TABLE IF NOT EXISTS `chum_transplant_ed_biopsies` (
  `results` text,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chum_transplant_ed_biopsies_revs` (
  `results` text,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chum_transplant_ed_biopsies`
  ADD CONSTRAINT `chum_transplant_ed_biopsies_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('chum_transplant_ed_biopsies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'chum_transplant_ed_biopsies', 'results', 'textarea',  NULL , '0', 'cols=40,rows=6', '', '', 'results', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_transplant_ed_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chum_transplant_ed_biopsies' AND `field`='results'), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('biopsy','Biopsy','Biopsie');
INSERT INTO structure_validations (structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE field = 'results' AND tablename = 'chum_transplant_ed_biopsies'), 'notEmpty');

-- -----------------------------------------------------------------------------------------------------------------------------
-- Treatment
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE treatment_controls SET flag_active = 0;
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`) VALUES
(null, 'transplant', '', 1, 'chum_transplant_txd_transplants', 'chum_transplant_txd_transplants', 0, NULL, NULL, 'transplant', 1, NULL);
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
CREATE TABLE IF NOT EXISTS `chum_transplant_txd_transplants` (
	donor_status VARCHAR(50) DEFAULT NULL,
	clampage_datetime DATETIME DEFAULT NULL,
	clampage_datetime_accuracy CHAR(1) NOT NULL DEFAULT '',
	serum_pre_transplant CHAR(1) DEFAULT '',
	previous_transplant INT(3) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chum_transplant_txd_transplants_revs` (
	donor_status VARCHAR(50) DEFAULT NULL,
	clampage_datetime DATETIME DEFAULT NULL,
	clampage_datetime_accuracy CHAR(1) NOT NULL DEFAULT '',
	serum_pre_transplant CHAR(1) DEFAULT '',
	previous_transplant INT(3) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chum_transplant_txd_transplants`
  ADD CONSTRAINT `chum_transplant_txd_transplants_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('chum_transplant_txd_transplants');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("chum_transplant_donor_status", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("cadaverous", "cadaverous");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_donor_status"), 
(SELECT id FROM structure_permissible_values WHERE value="alive" AND language_alias="alive"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_donor_status"), 
(SELECT id FROM structure_permissible_values WHERE value="cadaverous" AND language_alias="cadaverous"), "2", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'chum_transplant_txd_transplants', 'donor_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_donor_status') , '0', '', '', '', 'donor status', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'chum_transplant_txd_transplants', 'clampage_datetime', 'datetime',  NULL , '0', '', '', '', 'clampage datetime', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'chum_transplant_txd_transplants', 'previous_transplant', 'integer_positive',  NULL , '0', 'size=3', '', '', 'previous transplant', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'chum_transplant_txd_transplants', 'serum_pre_transplant', 'yes_no',  NULL , '0', '', '', '', 'serum pre transplant', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_transplant_txd_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chum_transplant_txd_transplants' AND `field`='donor_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_donor_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='donor status' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_txd_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chum_transplant_txd_transplants' AND `field`='clampage_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clampage datetime' AND `language_tag`=''), '1', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_txd_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chum_transplant_txd_transplants' AND `field`='previous_transplant' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='previous transplant' AND `language_tag`=''), '1', '14', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_txd_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chum_transplant_txd_transplants' AND `field`='serum_pre_transplant' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='serum pre transplant' AND `language_tag`=''), '1', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_transplant_txd_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '20', '', '', '0', '', '0', '', '1', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO structure_validations (structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `tablename`='chum_transplant_txd_transplants' AND `field`='donor_status'), 'notEmpty');
INSERT INTO structure_validations (structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `tablename`='chum_transplant_txd_transplants' AND `field`='previous_transplant'), 'notEmpty');
INSERT INTO i18n (id,en,fr)
VALUES
('donor status','Donor Status','Statu donneur'),
('cadaverous','Cadaverous','Cadavérique'),
('previous transplant','Previous Transplant(s)','Transplantation(s) précédentes'),
('clampage datetime','Clampage Date','Date du clampage'),
('serum pre transplant','Serum Pre-Transplant','Sérothèque prè');
INSERT INTO `treatment_extend_controls` (`id`, `detail_tablename`, `detail_form_alias`, `flag_active`, `type`, `databrowser_label`) VALUES
(null, 'chum_transplant_txe_transplants', 'chum_transplant_txe_transplants', 1, 'transplant additional data', 'transplant additional data');
UPDATE treatment_controls SET treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'chum_transplant_txe_transplants') WHERE detail_tablename = 'chum_transplant_txd_transplants';
CREATE TABLE IF NOT EXISTS `chum_transplant_txe_transplants` (
  `other_transplanted_organ` varchar(100) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  KEY `FK_chum_transplant_txe_transplants_treatment_extend_masters` (`treatment_extend_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chum_transplant_txe_transplants_revs` (
  `other_transplanted_organ` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chum_transplant_txe_transplants`
  ADD CONSTRAINT `FK_chum_transplant_txe_transplants_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('chum_transplant_txe_transplants');
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("chum_transplant_transplanted_organ", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Transplanted Organs\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Transplanted Organs', 1, 100, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Transplanted Organs');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('liver', 'Liver', 'Foie', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'chum_transplant_txe_transplants', 'other_transplanted_organ', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_transplanted_organ') , '0', '', '', '', 'other transplanted organ', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_transplant_txe_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='chum_transplant_txe_transplants' AND `field`='other_transplanted_organ' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_transplanted_organ')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other transplanted organ' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('other transplanted organ','Other Transplanted Organ','Autre organe transplanté');
ALTER TABLE chum_transplant_txd_transplants ADD donor_number VARCHAR(10) DEFAULt NULL;
ALTER TABLE chum_transplant_txd_transplants_revs ADD donor_number VARCHAR(10) DEFAULt NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'chum_transplant_txd_transplants', 'donor_number', 'input',  NULL , '0', '', '', '', 'donor number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_transplant_txd_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chum_transplant_txd_transplants' AND `field`='donor_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='donor number' AND `language_tag`=''), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en,fr) VALUES ('donor number','Donor #','Donneur #');
UPDATE treatment_extend_controls SET flag_active = 0 WHERE detail_tablename != 'chum_transplant_txe_transplants';
INSERT INTO structure_validations (structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE field = 'other_transplanted_organ' AND model = 'TreatmentExtendDetail'), 'notEmpty');

-- -----------------------------------------------------------------------------------------------------------------------------
-- FamilyHistories & ReproductiveHistories & ProtocolMasters & Drugs & SOP
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories%' OR use_link LIKE '/ClinicalAnnotation/ReproductiveHistories%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id2 IN (SELECT id FROM datamart_structures WHERE model IN ('FamilyHistory','ReproductiveHistory'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('FamilyHistory','ReproductiveHistory'));
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Protocol/ProtocolMasters%' OR use_link LIKE '/Drug/Drugs%' OR use_link LIKE '/Sop/SopMasters%'; 
    
-- -----------------------------------------------------------------------------------------------------------------------------
-- Link to collection & collecitons
-- -----------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'print barcodes';

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='transplant' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='biopsy', `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET 
flag_add = 0,
flag_edit = 0,
flag_search = 0,
flag_addgrid = 0,
flag_editgrid = 0,
flag_summary = 0,
flag_batchedit = 0,
flag_index = 0,
flag_detail = 0
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model` IN ('Collection', 'ViewAliquot', 'ViewCollection', 'ViewSample') AND `field` IN ('bank_id','sop_master_id','collection_property', 'collection_site'));
ALTER TABLE collections ADD COLUMN chum_transplant_type VARCHAR(50) DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN chum_transplant_type VARCHAR(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("chum_transplant_collection_type", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) 
VALUES
("donor time 0", "donor time 0"),
("recipient pre transplant", "recipient pre transplant"),
("recipient time 0", "recipient time 0"),
("recipient month 1", "recipient month 1"),
("recipient month 3", "recipient month 3"),
("recipient month 6", "recipient month 6"),
("recipient month 12", "recipient month 12"),
("recipient month 24", "recipient month 24"),
("recipient yearly", "recipient yearly"),
("recipient event", "recipient event");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_collection_type"), (SELECT id FROM structure_permissible_values WHERE value="donor time 0" AND language_alias="donor time 0"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_collection_type"), (SELECT id FROM structure_permissible_values WHERE value="recipient pre transplant" AND language_alias="recipient pre transplant"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_collection_type"), (SELECT id FROM structure_permissible_values WHERE value="recipient time 0" AND language_alias="recipient time 0"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_collection_type"), (SELECT id FROM structure_permissible_values WHERE value="recipient month 1" AND language_alias="recipient month 1"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_collection_type"), (SELECT id FROM structure_permissible_values WHERE value="recipient month 3" AND language_alias="recipient month 3"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_collection_type"), (SELECT id FROM structure_permissible_values WHERE value="recipient month 6" AND language_alias="recipient month 6"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_collection_type"), (SELECT id FROM structure_permissible_values WHERE value="recipient month 12" AND language_alias="recipient month 12"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_collection_type"), (SELECT id FROM structure_permissible_values WHERE value="recipient month 24" AND language_alias="recipient month 24"), "8", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_collection_type"), (SELECT id FROM structure_permissible_values WHERE value="recipient yearly" AND language_alias="recipient yearly"), "9", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chum_transplant_collection_type"), (SELECT id FROM structure_permissible_values WHERE value="recipient event" AND language_alias="recipient event"), "10", "1");
INSERT INTO i18n (id,en,fr) 
VALUES
("donor time 0", "Donor - Time 0", "Donneur - Temps 0"),
("recipient pre transplant", "Recipient - Pre-Transplant", "Receveur - Pré-Transplantation"),
("recipient time 0", "Recipient - Time 0", "Receveur - Temps 0"),
("recipient month 1", "Recipient - Month 1", "Receveur - Mois 1"),
("recipient month 3", "Recipient - Month 3", "Receveur - Mois 3"),
("recipient month 6", "Recipient - Month 6", "Receveur - Mois 6"),
("recipient month 12", "Recipient - Month 12", "Receveur - Mois 12"),
("recipient month 24", "Recipient - Month 24", "Receveur - Mois 24"),
("recipient yearly", "Recipient - Yearly", "Receveur - Annuel"),
("recipient event", "Recipient - Event", "Receveur - Évènement");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'chum_transplant_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type') , '0', '', '', '', 'type', ''),
('InventoryManagement', 'ViewCollection', '', 'chum_transplant_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'chum_transplant_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type') , '0', '', '', '', 'type', ''),
('InventoryManagement', 'ViewSample', '', 'chum_transplant_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_validations (structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE field = 'chum_transplant_type' AND model = 'Collection'), 'notEmpty');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='chum_transplant_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='chum_transplant_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='chum_transplant_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='chum_transplant_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'),
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='chum_transplant_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'donor_number', 'input',  NULL , '0', '', '', '', 'donor number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='donor_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='donor number' AND `language_tag`=''), '0', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en,fr) 
VALUES
('the transplant linked to the collection has to be selected','The transplant linked to the collection has to be selected', 'La greffe liée à la colelction doit être sélectionnée');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='chum_transplant_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '0', '10', 'collection', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chum_transplant_txd_transplants' AND `field`='donor_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='donor number' AND `language_tag`=''), '1', '303', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `language_heading`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='transplant' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='biopsy' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='chum_transplant_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='collections_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chum_transplant_txd_transplants' AND `field`='donor_number' AND `type`='input'), '1', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'donor_number', 'input',  NULL , '0', '', '', '', 'donor number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='donor_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='donor number' AND `language_tag`=''), '0', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='chum_transplant_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='donor_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'donor_number', 'input',  NULL , '0', '', '', '', 'donor number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='donor_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='donor number' AND `language_tag`=''), '0', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='chum_transplant_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- samples & aliquots

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 1, 12, 19, 131, 135, 23, 136, 2, 25, 119, 132, 190, 189, 142, 105, 112, 106, 143, 120, 124, 121, 141, 103, 109, 104, 144, 122, 127, 123, 192, 7, 130, 101, 102);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(11);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(12);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(188);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(3);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(33, 10);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(11, 34, 10);

UPDATE structure_formats SET 
flag_add = 0,
flag_edit = 0,
flag_search = 0,
flag_addgrid = 0,
flag_editgrid = 0,
flag_summary = 0,
flag_batchedit = 0,
flag_index = 0,
flag_detail = 0
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('is_problematic', 'sop_master_id'));

UPDATE  structure_permissible_values_custom_controls SET flag_active = 1 WHERE name = 'laboratory staff';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'laboratory staff');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('katia hamelin', 'Katia Hamelin', 'Katia Hamelin', '1', @control_id, NOW(), NOW(), 1, 1);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='pathology_reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_size_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_weight_unit') AND `flag_confidential`='0');

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissue Sources\')" WHERE domain_name='tissue_source_list';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Tissue Sources', 1, 50, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue Sources');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('liver', 'Liver', 'Foie', '1', @control_id, NOW(), NOW(), 1, 1),
('spleen', 'Spleen', 'Rate', '1', @control_id, NOW(), NOW(), 1, 1);

UPDATE structure_formats SET 
flag_add = 0,
flag_edit = 0,
flag_search = 0,
flag_addgrid = 0,
flag_editgrid = 0,
flag_summary = 0,
flag_batchedit = 0,
flag_index = 0,
flag_detail = 0
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('lot_number'));

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `flag_confidential`='0');

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="gel CSA" AND language_alias="gel CSA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="heparin" AND language_alias="heparin");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="ZCSA" AND language_alias="ZCSA");

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/SpecimenReviews%';
UPDATE aliquot_review_controls SET flag_active = 0;
UPDATE specimen_review_controls SET flag_active = 0;
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id2 IN (SELECT id FROM datamart_structures WHERE model IN ('SpecimenReviewMaster','AliquotReviewMaster'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('SpecimenReviewMaster','AliquotReviewMaster'));

UPDATE structure_formats SET `display_column`='1', `display_order`='1202', `flag_add`='0', `flag_addgrid`='0', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET language_label = 'aliquot barcode' WHERE language_label = 'barcode' AND model LIKE '%Aliquot%';
REPLACE INTO i18n (id,en, fr) VALUES ('aliquot barcode', 'Aliquot System Code', 'Aliquot - Code système');
INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE model='AliquotMaster' AND field='aliquot_label'), 'notEmpty');
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='40' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='children_aliquots_selection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1203', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1200', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='chum_transplant_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_transplant_collection_type') AND `flag_confidential`='0');

UPDATE  structure_permissible_values_custom_controls SET flag_active = 1 WHERE name = 'aliquot use and event types';

UPDATE  structure_permissible_values_custom_controls SET flag_active = 1 WHERE name IN ('storage types','storage coordinate titles');
INSERT INTO storage_controls (storage_type, coord_x_title, coord_x_type, coord_x_size, display_x_size, reverse_x_numbering, display_y_size, reverse_y_numbering, set_temperature, check_conflicts, databrowser_label, flag_active, is_tma_block, detail_tablename, detail_form_alias) 
VALUES 
('box100 1-100', 'position', 'integer', 100, 10, '0', 10, '0', '0', 1, 'custom#storage types#box100 1-100', '0', '0', 'std_customs', '')
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'storage types');
INSERT INTO structure_permissible_values_customs (control_id, value, en, fr) 
VALUES 
(@control_id, 'box100 1-100', 'Box100 1-100', 'Boîte100 1-100');
UPDATE storage_controls SET `flag_active` = '0';
UPDATE storage_controls SET `flag_active` = '1' WHERE storage_type IN (
'room',
'nitrogen locator',
'fridge',
'freezer',
'box',
'box81 1A-9I',
'box81',
'rack16',
'rack10',
'rack24',
'shelf',
'rack11',
'rack9',
'box25',
'box100 1A-20E', 'box100 1-100');

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='col_copy_binding_opt' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="participant only");














exit
-- Permettre de matcher des collections donors.
-- Voire au niveau de realiquot... si on voit bien l'information du donneur.
-- Créer les labels par defaut.




