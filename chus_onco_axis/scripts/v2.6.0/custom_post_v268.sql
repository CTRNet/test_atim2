
UPDATE users SET flag_active = '1', `password` = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', username = 'NicoEn' WHERE id = '1';
UPDATE groups SET flag_show_confidential = 1 WHERE id = 1;
INSERT INTO i18n (id,en,fr) VALUES ('core_installname','ONCO Axis','Axe Cancer');

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Drug & protocol
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- Drug¸

ALTER TABLE drugs MODIFY generic_name varchar(100) NOT NULL;
ALTER TABLE drugs_revs MODIFY generic_name varchar(100) NOT NULL;
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("immunotherapy", "immunotherapy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="type"), (SELECT id FROM structure_permissible_values WHERE value="immunotherapy" AND language_alias="immunotherapy"), "2", "1");
INSERT IGNORE INTO i18n (id, en, fr) 
VALUES
("immunotherapy", "Immunotherapy", "Immuno-thérapie"),
("hormonotherapy", "Hormonotherapy", "Hormono-thérapie"),
('radiotherapy','Radiotherapy','Radio-thérapie');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='drugs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='type') AND `flag_confidential`='0');

-- protocol : systemic therapy

UPDATE protocol_controls SET flag_active = 0;
UPDATE protocol_extend_controls SET flag_active = 0;

CREATE TABLE IF NOT EXISTS `chus_pd_systemic_therapies` (
  `protocol_master_id` int(11) NOT NULL,
  KEY `FK_pd_chemos_protocol_masters` (`protocol_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chus_pd_systemic_therapies_revs` (
  `protocol_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chus_pd_systemic_therapies`
  ADD CONSTRAINT `FK_chus_pd_systemic_therapiess_protocol_masters` FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);
  
CREATE TABLE IF NOT EXISTS `chus_pe_systemic_therapies` (
  `method` varchar(50) DEFAULT NULL,
  `dose` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `protocol_extend_master_id` int(11) NOT NULL,
  KEY `FK_chus_pe_systemic_therapies_drugs` (`drug_id`),
  KEY `FK_chus_pe_systemic_therapies_protocol_extend_masters` (`protocol_extend_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chus_pe_systemic_therapies_revs` (
  `method` varchar(50) DEFAULT NULL,
  `dose` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `drug_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `protocol_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chus_pe_systemic_therapies`
  ADD CONSTRAINT `FK_chus_pe_systemic_therapies_protocol_extend_masters` FOREIGN KEY (`protocol_extend_master_id`) REFERENCES `protocol_extend_masters` (`id`),
  ADD CONSTRAINT `FK_chus_pe_systemic_therapies_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);

INSERT INTO protocol_extend_controls (detail_tablename, detail_form_alias, flag_active)
VALUES
('chus_pe_systemic_therapies', 'chus_pe_systemic_therapies', '1'); 
INSERT INTO protocol_controls (tumour_group, type, detail_tablename, detail_form_alias, flag_active, protocol_extend_control_id)
VALUES
('all', 'systemic therapy', 'chus_pd_systemic_therapies', '', 1, (SELECT id FROM protocol_extend_controls  WHERE detail_tablename = 'chus_pe_systemic_therapies'));

UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `setting`='rows=10,cols=60',  `language_label`='summary' WHERE model='ProtocolMaster' AND tablename='protocol_masters' AND field='notes' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('chus_pd_systemic_therapies');

INSERT INTO structures(`alias`) VALUES ('chus_pe_systemic_therapies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Protocol', 'ProtocolExtendDetail', 'chus_pe_systemic_therapies', 'method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') , '0', '', '', '', 'method', ''), 
('Protocol', 'ProtocolExtendDetail', 'chus_pe_systemic_therapies', 'dose', 'input',  NULL , '0', 'size=10', '', '', 'dose', ''), 
('Protocol', 'ProtocolExtendDetail', 'chus_pe_systemic_therapies', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='drug_list') , '0', '', '', '', 'drug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_pe_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='chus_pe_systemic_therapies' AND `field`='method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_pe_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='chus_pe_systemic_therapies' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_pe_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='chus_pe_systemic_therapies' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO i18n (id,en)
VALUES
('systemic therapy','Systemic Therapy');

-- protocol radiotherapy

INSERT INTO protocol_controls (tumour_group, type, detail_tablename, detail_form_alias, flag_active, protocol_extend_control_id)
VALUES
('all', 'radiotherapy', 'chus_pd_radiotherapies', '', 1, NULL);
CREATE TABLE IF NOT EXISTS `chus_pd_radiotherapies` (
  `protocol_master_id` int(11) NOT NULL,
  KEY `FK_pd_chemos_protocol_masters` (`protocol_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chus_pd_radiotherapies_revs` (
  `protocol_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chus_pd_radiotherapies`
  ADD CONSTRAINT `FK_chus_pd_radiotherapiess_protocol_masters` FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);
  
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Clinical Collection 
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- Profile
-- -----------------------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr) VALUES ('participant identifier', 'Biobank Patient ID', 'ID Patient - Biobanque');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');

ALTER TABLE participants
  ADD COLUMN chus_status_date date  DEFAULT NULL;
ALTER TABLE participants_revs
  ADD COLUMN chus_status_date date  DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'chus_status_date', 'date',  NULL , '0', '', '', '', 'vital status date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chus_status_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='vital status date' AND `language_tag`=''), '3', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) 
VALUES 
('vital status date', 'Status Date', 'Date du statut');

ALTER TABLE participants ADD COLUMN chus_contact_status varchar(50) default null;
ALTER TABLE participants_revs ADD COLUMN chus_contact_status varchar(50) default null;
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("chus_contact_status", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("contact allowed", "contact allowed"),('lost to follow-up','lost to follow-up'),('no further recontact','no further recontact');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_contact_status"), (SELECT id FROM structure_permissible_values WHERE value="contact allowed" AND language_alias="contact allowed"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_contact_status"), (SELECT id FROM structure_permissible_values WHERE value="lost to follow-up" AND language_alias="lost to follow-up"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_contact_status"), (SELECT id FROM structure_permissible_values WHERE value="no further recontact" AND language_alias="no further recontact"), "", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'chus_contact_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_contact_status') , '0', '', '', '', 'contact status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chus_contact_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_contact_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact status' AND `language_tag`=''), '3', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('contact status', 'Contact Status', 'Statut du contact'),
("contact allowed", "Contact allowed", 'Contact permis'),
('lost to follow-up','Lost to follow-up', 'Perdu de vue'),
('no further recontact','No further recontact', 'Ne plus contacter');

UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1', `flag_addgrid_readonly`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Misc Identifiers
-- -----------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`) 
VALUES
('hospital card number', 1, '', '', 1, 1, 1, 0, '', ''),
('health insurance number', 1, '', '', 1, 1, 1, 0, '', '');
INSERT INTO i18n (id,en,fr) 
VALUES 
('health insurance number', 'Health Insurance Card Number', 'Numéro carte assurance maladie'),
('hospital card number', 'Hospital Card Number', 'Numéro carte hôpital');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, flag_link_to_study) 
VALUES
('patient study id', 1, '', '', 0, 0, 0, 0, '', '', '1');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) 
VALUES 
('patient study id', 'Patient Study ID', 'ID Patient - Étude');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

-- Consent
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE consent_controls SET flag_active = 0;
INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'chus onco axis', 1, 'chus_cd_onco_axis', 'chus_cd_onco_axis', 0, 'chus onco axis');

CREATE TABLE IF NOT EXISTS `chus_cd_onco_axis` (
  `consent_master_id` int(11) NOT NULL,  
  allow_other_diseases_related_projects char(1) default '',
  keep_sample_data_if_unfit char(1) default '',
  preferred_contact_method varchar(20) default null,
  other_contact_if_not_reachable varchar(50) default null,
  other_contact_relationship varchar(50) default null,
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chus_cd_onco_axis_revs` (
  `consent_master_id` int(11) NOT NULL,
  allow_other_diseases_related_projects char(1) default '',
  keep_sample_data_if_unfit char(1) default '',
  preferred_contact_method varchar(20) default null,
  other_contact_if_not_reachable varchar(50) default null,
  other_contact_relationship varchar(50) default null,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chus_cd_onco_axis`
  ADD CONSTRAINT `chus_cd_onco_axis_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_cd_onco_axis');
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("chus_contact_method", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("phone", "phone"),('email','email'),('mail','mail');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_contact_method"), (SELECT id FROM structure_permissible_values WHERE value="phone" AND language_alias="phone"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_contact_method"), (SELECT id FROM structure_permissible_values WHERE value="email" AND language_alias="email"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_contact_method"), (SELECT id FROM structure_permissible_values WHERE value="mail" AND language_alias="mail"), "", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'chus_cd_onco_axis', 'allow_other_diseases_related_projects', 'yes_no',  NULL , '0', '', '', '', 'allow other disease-related projects', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'chus_cd_onco_axis', 'keep_sample_data_if_unfit', 'yes_no',  NULL , '0', '', '', '', 'keep sample and data if unfit', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'chus_cd_onco_axis', 'preferred_contact_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_contact_method') , '0', '', '', '', 'contact method', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'chus_cd_onco_axis', 'other_contact_if_not_reachable', 'input',  NULL , '0', '', '', '', 'other contact if not reachable', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'chus_cd_onco_axis', 'other_contact_relationship', 'input',  NULL , '0', '', '', '', 'relationship', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_cd_onco_axis'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chus_cd_onco_axis' AND `field`='allow_other_diseases_related_projects' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='allow other disease-related projects' AND `language_tag`=''), '2', '50', 'data', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_cd_onco_axis'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chus_cd_onco_axis' AND `field`='keep_sample_data_if_unfit' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='keep sample and data if unfit' AND `language_tag`=''), '2', '52', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_cd_onco_axis'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chus_cd_onco_axis' AND `field`='preferred_contact_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_contact_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact method' AND `language_tag`=''), '2', '53', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_cd_onco_axis'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chus_cd_onco_axis' AND `field`='other_contact_if_not_reachable' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other contact if not reachable' AND `language_tag`=''), '2', '60', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_cd_onco_axis'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='chus_cd_onco_axis' AND `field`='other_contact_relationship' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='relationship' AND `language_tag`=''), '2', '61', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('chus onco axis', 'CHUS Onco Axis', 'CHUS - Axe cancer'),
('phone','Phone','Téléphone'),
('digestive disease', 'Digestive Disease', 'Maladie Digestive'),
('contact method','Contact Method','Méthode de contact'),
('other contact if not reachable','Other contact if not reachable','Autre contact is pas joignable'),
('allow other disease-related projects','Allow other disease-related projects','Permet autre projet en lien avec des maladies'),
('keep sample and data if unfit','Keep sample and data if unfit or died','Garder échantillons et données si inapte ou mort'),
('preferred contact method', 'Preferred Method of Communication', 'Méthode de communication souhaitée');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'consent form versions');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('digestive disease v1.0 2016-01-18', 'Digestive Disease - V1.0 - Jan 18th, 2016',  'Maladie Digestive - V1.0 - 18 Jan 2016', '1', @control_id, NOW(), NOW(), 1, 1);

UPDATE structure_fields SET  `flag_confidential`='1' WHERE model='ConsentDetail' AND tablename='chus_cd_onco_axis' AND field='other_contact_if_not_reachable' AND `type`='input' AND structure_value_domain  IS NULL ;

ALTER TABLE consent_masters ADD chus_language varchar(30) default null;
ALTER TABLE consent_masters_revs ADD chus_language varchar(30) default null;
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("chus_cd_languages", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("french", "french"),('english','english');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_cd_languages"), (SELECT id FROM structure_permissible_values WHERE value="french" AND language_alias="french"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_cd_languages"), (SELECT id FROM structure_permissible_values WHERE value="english" AND language_alias="english"), "", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'chus_language', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_cd_languages') , '0', '', '', '', 'language', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='chus_language' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_cd_languages')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='language' AND `language_tag`=''), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
REPLACE INTO i18n (id,en,fr) 
VALUES 
('english','English','Anglais'),('french','French','Français');

UPDATE structure_fields SET  `language_label`='',  `language_tag`='relationship' WHERE model='ConsentDetail' AND tablename='chus_cd_onco_axis' AND field='other_contact_relationship' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `tablename`='consent_masters' AND `field`='consent_status'), 'notEmpty', '');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `tablename`='consent_masters' AND `field`='form_version'), 'notEmpty', ''),
((SELECT id FROM structure_fields WHERE `tablename`='consent_masters' AND `field`='status_date'), 'notEmpty', '');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='chus_cd_languages') ,  `language_label`='' WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='chus_language' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_cd_languages');

-- Contact
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES('treating physician','treating physician');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="contact_type"), (SELECT id FROM structure_permissible_values WHERE value="treating physician" AND language_alias="treating physician"), "", "1");
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('treating physician','Treating Physician','Médecin traitant');
UPDATE structure_value_domains_permissible_values SET flag_active = 1 WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="contact_type") 
AND structure_permissible_value_id = (SELECT id FROM structure_permissible_values WHERE value="family doctor" AND language_alias="family doctor");

ALTER TABLE participant_contacts
  ADD COLUMN chus_preferred_contact_method varchar(30) default null,
  ADD COLUMN chus_email varchar(100) default null;
ALTER TABLE participant_contacts_revs
  ADD COLUMN chus_preferred_contact_method varchar(30) default null,
  ADD COLUMN chus_email varchar(100) default null;

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("chus_preferred_contact_method", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("email", "email"),('mail','mail'),('phone','phone');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_preferred_contact_method"), (SELECT id FROM structure_permissible_values WHERE value="phone" AND language_alias="phone"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_preferred_contact_method"), (SELECT id FROM structure_permissible_values WHERE value="mail" AND language_alias="mail"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_preferred_contact_method"), (SELECT id FROM structure_permissible_values WHERE value="email" AND language_alias="email"), "", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'chus_preferred_contact_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_preferred_contact_method') , '0', '', '', '', 'communication preferred method', ''), 
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'chus_email', 'input',  NULL , '0', 'size=15', '', '', 'email', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='chus_preferred_contact_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_preferred_contact_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='communication preferred method' AND `language_tag`=''), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='chus_email' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='email' AND `language_tag`=''), '2', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('communication preferred method', 'Communication Preferred Method', 'Méthode de communication préférée'),
('email','Email','Courriel');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `field`='contact_type'), 'notEmpty', ''),
((SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `field`='contact_name'), 'notEmpty', '');

-- Family History
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET `language_label`='',  `language_tag`='-' WHERE model='FamilyHistory' AND tablename='family_histories' AND field='relation' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='relation');
UPDATE structure_fields SET `language_label`='relation' WHERE model='FamilyHistory' AND tablename='family_histories' AND field='family_domain' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='domain');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
      
ALTER TABLE family_histories ADD COLUMN chus_diagnosis_value varchar(100) DEFAULT NULL;
ALTER TABLE family_histories_revs ADD COLUMN chus_diagnosis_value varchar(100) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('chus_family_history_diagnosis', "StructurePermissibleValuesCustom::getCustomDropdown('Family History Diagnosis')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Family History Diagnosis', 1, 100, 'clinical - family history');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Family History Diagnosis');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('none', 'None',  'Aucun', '1', @control_id, NOW(), NOW(), 1, 1),
('colorectal cancer', 'Colorectal Cancer',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FamilyHistory', 'family_histories', 'chus_diagnosis_value', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_family_history_diagnosis') , '0', '', '', '', 'diagnosis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='chus_diagnosis_value' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_family_history_diagnosis')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `language_label`='',  `language_tag`='coding' WHERE model='FamilyHistory' AND tablename='family_histories' AND field='primary_icd10_code' AND `type`='autocomplete' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `field`='chus_diagnosis_value'), 'notEmpty', '');

-- Reproductive History
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories/%';
         
-- diagnosis
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE diagnosis_controls SET flag_active = 0 WHERE category = 'primary' AND controls_type != 'primary diagnosis unknown';

-- other primary

INSERT INTO diagnosis_controls (category, controls_type, flag_active, detail_form_alias, detail_tablename, databrowser_label)
VALUES
('primary','other','1','dx_primary,dx_tissues','dxd_tissues', 'primary|other');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='collaborative_staged' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_type`='1', `type`='input', `flag_override_setting`='1', `setting`='size=5' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_type`='1', `type`='input', `flag_override_setting`='1', `setting`='size=5', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ajcc_edition' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ajcc edition') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='staging' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ajcc_edition' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ajcc edition') AND `flag_confidential`='0');

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("bilateral", "bilateral");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="laterality"), (SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "", "1");

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Diagnosis Method')" WHERE domain_name = 'dx_method';
UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="dx_method");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Diagnosis Method', 1, 20, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Diagnosis Method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('medical imaging', 'Medical Imaging',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('pathology', 'Pathology',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('treating physician', 'Treating Physician',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown', 'Unknown',  '', '1', @control_id, NOW(), NOW(), 1, 1);

UPDATE structure_formats SET `language_heading`='morphology', `flag_override_label`='1', `language_label`='code' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='disease', `flag_override_label`='1', `language_label`='code' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='topography', `flag_override_label`='1', `language_label`='code' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_tissues' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='collaborative_staged' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ajcc_edition' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ajcc edition') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='disease', `flag_override_label`='1', `language_label`='code' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_unknown_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Digestive System

DROP TABLE IF EXISTS chus_topography_coding;
CREATE TABLE `chus_topography_coding` (
  `code` varchar(250) NULL,
  `category` varchar(250) NULL,
  `description` varchar(250) NULL,
  PRIMARY KEY `chus_topography_coding_code` (`code`),
  FULLTEXT KEY `chus_topography_coding_category` (`category`),
  FULLTEXT KEY `chus_topography_coding_description` (`description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS chus_morphology_coding;
CREATE TABLE `chus_morphology_coding` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tumour_type` varchar(250) NULL,
  `tumour_cell_origin` varchar(250) NULL,
  `tumour_category` varchar(250) NULL,
  `morphology_code` varchar(250) NULL,
  `behaviour_code` varchar(250) NULL,
  `morphology_description` varchar(250) NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `chus_morphology_coding_tumour_type` (`tumour_type`),
  FULLTEXT KEY `chus_morphology_coding_tumour_cell_origin` (`tumour_cell_origin`),
  FULLTEXT KEY `chus_morphology_coding_tumour_category` (`tumour_category`),
  FULLTEXT KEY `chus_morphology_coding_morphology_code` (`morphology_code`),
  FULLTEXT KEY `chus_morphology_coding_behaviour_code` (`behaviour_code`),
  FULLTEXT KEY `chus_morphology_coding_morphology_description` (`morphology_description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO diagnosis_controls (category, controls_type, flag_active, detail_form_alias, detail_tablename, databrowser_label)
VALUES
('primary','digestive system','1','chus_dx_digestive_system_tumors','chus_dx_digestive_system_tumors', 'primary|digestive system');

DROP TABLE IF EXISTS chus_dx_digestive_system_tumors;
DROP TABLE IF EXISTS chus_dx_digestive_system_tumors_revs;
CREATE TABLE `chus_dx_digestive_system_tumors` (
  diagnosis_master_id int(11) NOT NULL,
  laterality varchar(50) NOT NULL DEFAULT '',
  topography_category varchar(250) NULL,
  topography_description varchar(250) NULL,
  morphology_id int(11) NULL,
  morphology_tumour_type varchar(250) NULL,
  morphology_tumour_cell_origin varchar(250) NULL,
  morphology_tumour_category varchar(250) NULL,
  morphology_behaviour_code varchar(250) NULL,
  morphology_description varchar(250) NULL,  
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE chus_dx_digestive_system_tumors_revs (
  diagnosis_master_id int(11) NOT NULL,
  laterality varchar(50) NOT NULL DEFAULT '',
  topography_category varchar(250) NULL,
  topography_description varchar(250) NULL,
  morphology_id int(11) NULL,
  morphology_tumour_type varchar(250) NULL,
  morphology_tumour_cell_origin varchar(250) NULL,
  morphology_tumour_category varchar(250) NULL,
  morphology_behaviour_code varchar(250) NULL,
  morphology_description varchar(250) NULL,  
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;
ALTER TABLE chus_dx_digestive_system_tumors
  ADD CONSTRAINT FK_chus_dx_digestive_system_tumors_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

INSERT INTO structures(`alias`) VALUES ('chus_dx_digestive_system_tumors');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('chus_topography_category', "ClinicalAnnotation.DiagnosisMaster::getChusTopographyValues('category')"),
('chus_morphology_tumour_type', "ClinicalAnnotation.DiagnosisMaster::getChusMorphologyValues('tumour_type')"),
('chus_morphology_tumour_cell_origin', "ClinicalAnnotation.DiagnosisMaster::getChusMorphologyValues('tumour_cell_origin')"),
('chus_morphology_tumour_category', "ClinicalAnnotation.DiagnosisMaster::getChusMorphologyValues('tumour_category')"),
('chus_morphology_behaviour_code', "ClinicalAnnotation.DiagnosisMaster::getChusMorphologyValues('behaviour_code')");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'chus_dx_digestive_system_tumors', 'topography_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_topography_category') , '0', '', '', '', '', 'category'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'chus_dx_digestive_system_tumors', 'topography_description', 'input',  NULL , '0', '', '', '', '', 'description'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'chus_dx_digestive_system_tumors', 'morphology_tumour_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_type') , '0', '', '', '', '', 'type'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'chus_dx_digestive_system_tumors', 'morphology_tumour_cell_origin', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_cell_origin') , '0', '', '', '', '', 'cell origin'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'chus_dx_digestive_system_tumors', 'morphology_tumour_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_category') , '0', '', '', '', '', 'category'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'chus_dx_digestive_system_tumors', 'morphology_behaviour_code', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_behaviour_code') , '0', '', '', '', '', 'behavior code'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'chus_dx_digestive_system_tumors', 'morphology_description', 'input',  NULL , '0', '', '', '', '', 'description'), 
('ClinicalAnnotation', 'FunctionManagement', '', 'chus_autocomplete_digestive_topography', 'autocomplete',  NULL , '0', 'url=/ClinicalAnnotation/DiagnosisMasters/autocompleteChusTopography', '', '', 'topography', ''), 
('ClinicalAnnotation', 'FunctionManagement', '', 'chus_autocomplete_digestive_morphology', 'autocomplete',  NULL , '0', 'url=/ClinicalAnnotation/DiagnosisMasters/autocompleteChusMorphology', '', '', 'morphology', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='help_primary code' AND `language_label`='disease code' AND `language_tag`=''), '2', '1', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '2', '', '0', '0', '', '0', '', '0', '', '1', 'input', '1', 'size=10', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '6', '', '0', '0', '', '0', '', '0', '', '1', 'input', '1', 'size=10', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx method' AND `language_label`='dx_method' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dx_digestive_system_tumors' AND `field`='topography_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_topography_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='category'), '2', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dx_digestive_system_tumors' AND `field`='topography_description' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='description'), '2', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dx_digestive_system_tumors' AND `field`='morphology_tumour_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='type'), '2', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dx_digestive_system_tumors' AND `field`='morphology_tumour_cell_origin' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_cell_origin')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='cell origin'), '2', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dx_digestive_system_tumors' AND `field`='morphology_tumour_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='category'), '2', '9', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dx_digestive_system_tumors' AND `field`='morphology_behaviour_code' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_behaviour_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='behavior code'), '2', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dx_digestive_system_tumors' AND `field`='morphology_description' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='description'), '2', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='chus_autocomplete_digestive_topography' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/ClinicalAnnotation/DiagnosisMasters/autocompleteChusTopography' AND `default`='' AND `language_help`='' AND `language_label`='topography' AND `language_tag`=''), '2', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='chus_autocomplete_digestive_morphology' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/ClinicalAnnotation/DiagnosisMasters/autocompleteChusMorphology' AND `default`='' AND `language_help`='' AND `language_label`='morphology' AND `language_tag`=''), '2', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("chus_tumor_grade", "", "", NULL),
("chus_tnm_pt", "", "", NULL),
("chus_tnm_pn", "", "", NULL),
("chus_tnm_pm", "", "", NULL),
("chus_tnm_ps", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("gx", "gx (unknown)"),
("g1", "g1 (well differentiated)"),
("g2", "g2 (moderately differentiated)"),
("g3", "g3 (poorly differentiated)"),
("g4", "g4 (undifferentiated)");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tumor_grade"), (SELECT id FROM structure_permissible_values WHERE value="gx" AND language_alias="gx (unknown)"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tumor_grade"), (SELECT id FROM structure_permissible_values WHERE value="g1" AND language_alias="g1 (well differentiated)"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tumor_grade"), (SELECT id FROM structure_permissible_values WHERE value="g2" AND language_alias="g2 (moderately differentiated)"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tumor_grade"), (SELECT id FROM structure_permissible_values WHERE value="g3" AND language_alias="g3 (poorly differentiated)"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tumor_grade"), (SELECT id FROM structure_permissible_values WHERE value="g4" AND language_alias="g4 (undifferentiated)"), "5", "1");
INSERT IGNORE INTO i18n (id,en)
VALUES
("gx (unknown)", "Gx (Unknown)"),
("g1 (well differentiated)", "G1 (Well differentiated)"),
("g2 (moderately differentiated)", "G2 (Moderately differentiated)"),
("g3 (poorly differentiated)", "G3 (Poorly differentiated)"),
("g4 (undifferentiated)", "G4 (Undifferentiated)");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("Tx", "Tx (unknown)"),
("T0", "T0"),
("Tis", "Tis"),
("T1", "T1"),
("T1mi", "T1mi"),
("T1a", "T1a"),
("T1b", "T1b"),
("T1c", "T1c"),
("T2", "T2"),
("T2a", "T2a"),
("T2b", "T2b"),
("T3", "T3"),
("T3a", "T3a"),
("T3b", "T3b"),
("T4", "T4"),
("T4a", "T4a"),
("T4b", "T4b"),
("T4c", "T4c"),
("T4d", "T4d");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="Tx" AND language_alias="Tx (unknown)"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T0" AND language_alias="T0"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="Tis" AND language_alias="Tis"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T1" AND language_alias="T1"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T1mi" AND language_alias="T1mi"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T1a" AND language_alias="T1a"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T1b" AND language_alias="T1b"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T1c" AND language_alias="T1c"), "8", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T2" AND language_alias="T2"), "9", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T2a" AND language_alias="T2a"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T2b" AND language_alias="T2b"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T3" AND language_alias="T3"), "12", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T3a" AND language_alias="T3a"), "13", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T3b" AND language_alias="T3b"), "14", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T4" AND language_alias="T4"), "15", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T4a" AND language_alias="T4a"), "16", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T4b" AND language_alias="T4b"), "17", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T4c" AND language_alias="T4c"), "18", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pt"), (SELECT id FROM structure_permissible_values WHERE value="T4d" AND language_alias="T4d"), "19", "1");
INSERT IGNORE INTO i18n (id,en)
VALUES
("Tx (unknown)", "Tx (Unknown)"),
("T0", "T0"),
("Tis", "Tis"),
("T1", "T1"),
("T1mi", "T1mi"),
("T1a", "T1a"),
("T1b", "T1b"),
("T1c", "T1c"),
("T2", "T2"),
("T2a", "T2a"),
("T2b", "T2b"),
("T3", "T3"),
("T3a", "T3a"),
("T3b", "T3b"),
("T4", "T4"),
("T4a", "T4a"),
("T4b", "T4b"),
("T4c", "T4c"),
("T4d", "T4d");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("Nx", "Nx (unknown)"),
("N0", "N0"),
("N1", "N1"),
("N1a", "N1a"),
("N1b", "N1b"),
("N1c", "N1c"),
("N2", "N2"),
("N2a", "N2a"),
("N2b", "N2b"),
("N3", "N3"),
("N3a", "N3a"),
("N3b", "N3b"),
("N3c", "N3c");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="Nx" AND language_alias="Nx (unknown)"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N0" AND language_alias="N0"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N1" AND language_alias="N1"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N1a" AND language_alias="N1a"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N1b" AND language_alias="N1b"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N1c" AND language_alias="N1c"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N2" AND language_alias="N2"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N2a" AND language_alias="N2a"), "8", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N2b" AND language_alias="N2b"), "9", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N3" AND language_alias="N3"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N3a" AND language_alias="N3a"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N3b" AND language_alias="N3b"), "12", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pn"), (SELECT id FROM structure_permissible_values WHERE value="N3c" AND language_alias="N3c"), "13", "1");
INSERT IGNORE INTO i18n (id,en)
VALUES
("Nx (unknown)", "Nx (Unknown)"),
("N0", "N0"),
("N1", "N1"),
("N1a", "N1a"),
("N1b", "N1b"),
("N1c", "N1c"),
("N2", "N2"),
("N2a", "N2a"),
("N2b", "N2b"),
("N3", "N3"),
("N3a", "N3a"),
("N3b", "N3b"),
("N3c", "N3c");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("Mx", "Mx (unknown)"),
("M0", "M0"),
("M1", "M1"),
("M1a", "M1a"),
("M1b", "M1b");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pm"), (SELECT id FROM structure_permissible_values WHERE value="Mx" AND language_alias="Mx (unknown)"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pm"), (SELECT id FROM structure_permissible_values WHERE value="M0" AND language_alias="M0"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pm"), (SELECT id FROM structure_permissible_values WHERE value="M1" AND language_alias="M1"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pm"), (SELECT id FROM structure_permissible_values WHERE value="M1a" AND language_alias="M1a"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_pm"), (SELECT id FROM structure_permissible_values WHERE value="M1b" AND language_alias="M1b"), "5", "1");
INSERT IGNORE INTO i18n (id,en)
VALUES
("Mx (unknown)", "Mx (Unknown)"),
("M0", "M0"),
("M1", "M1"),
("M1a", "M1a"),
("M1b", "M1b");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("s0", "stage 0 (in situ)"),
("sI", "stage I"),
("sIA", "stage IA"),
("sIB", "stage IB"),
("sIC", "stage IC"),
("sII", "stage II"),
("sIIA", "stage IIA"),
("sIIB", "stage IIB"),
("sIIC", "stage IIC"),
("sIII", "stage III"),
("sIIIA", "stage IIIA"),
("sIIIB", "stage IIIB"),
("sIIIC", "stage IIIC"),
("sIV", "stage IV"),
("sIVA", "stage IVA"),
("sIVB", "stage IVB"),
("sIVC", "stage IVC"),
("gI", "group I"),
("gIA", "group IA"),
("gIB", "group IB"),
("gII", "group II"),
("gIIIA", "group IIIA"),
("gIIIB", "group IIIB"),
("gIV", "group IV"),
("unk", "unknown");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="s0" AND language_alias="stage 0 (in situ)"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sI" AND language_alias="stage I"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIA" AND language_alias="stage IA"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIB" AND language_alias="stage IB"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIC" AND language_alias="stage IC"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sII" AND language_alias="stage II"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIIA" AND language_alias="stage IIA"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIIB" AND language_alias="stage IIB"), "8", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIIC" AND language_alias="stage IIC"), "9", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIII" AND language_alias="stage III"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIIIA" AND language_alias="stage IIIA"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIIIB" AND language_alias="stage IIIB"), "12", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIIIC" AND language_alias="stage IIIC"), "13", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIV" AND language_alias="stage IV"), "14", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIVA" AND language_alias="stage IVA"), "15", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIVB" AND language_alias="stage IVB"), "16", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="sIVC" AND language_alias="stage IVC"), "17", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="gI" AND language_alias="group I"), "18", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="gIA" AND language_alias="group IA"), "19", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="gIB" AND language_alias="group IB"), "20", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="gII" AND language_alias="group II"), "21", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="gIIIA" AND language_alias="group IIIA"), "22", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="gIIIB" AND language_alias="group IIIB"), "23", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="gIV" AND language_alias="group IV"), "24", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_tnm_ps"), (SELECT id FROM structure_permissible_values WHERE value="unk" AND language_alias="unknown"), "25", "1");
INSERT IGNORE INTO i18n (id,en)
VALUES
("stage 0 (in situ)", "Stage 0 (in situ)"),
("stage I", "Stage I"),
("stage IA", "Stage IA"),
("stage IB", "Stage IB"),
("stage IC", "Stage IC"),
("stage II", "Stage II"),
("stage IIA", "Stage IIA"),
("stage IIB", "Stage IIB"),
("stage IIC", "Stage IIC"),
("stage III", "Stage III"),
("stage IIIA", "Stage IIIA"),
("stage IIIB", "Stage IIIB"),
("stage IIIC", "Stage IIIC"),
("stage IV", "Stage IV"),
("stage IVA", "Stage IVA"),
("stage IVB", "Stage IVB"),
("stage IVC", "Stage IVC"),
("group I", "Group I"),
("group IA", "Group IA"),
("group IB", "Group IB"),
("group II", "Group II"),
("group IIIA", "Group IIIA"),
("group IIIB", "Group IIIB"),
("group IV", "Group IV"),
("unknown", "Unknown");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'chus_dx_digestive_system_tumors', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', 'dx_laterality', 'laterality', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_tumor_grade') , '0', '', '', 'help_tumour grade', 'tumour grade', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_pt') , '0', '', '', '', 'pathological stage', 't stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_pn') , '0', '', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_pm') , '0', '', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_stage_summary', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_ps') , '0', '', '', 'help_path_stage_summary', '', 'summary');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dx_digestive_system_tumors' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '2', '99', 'tissue specific', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_tumor_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tumour grade' AND `language_label`='tumour grade' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ajcc_edition' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ajcc edition')  AND `flag_confidential`='0'), '2', '16', 'staging', '0', '0', '', '0', '', '0', '', '1', 'input', '1', 'size=5', '0', '', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '19', '', '0', '0', '', '0', '', '0', '', '0', '', '1', 'size=1,maxlength=3', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '1', 'size=1,maxlength=3', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '1', 'size=1,maxlength=3', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '1', 'size=1,maxlength=3', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_pt')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='t stage'), '2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_pn')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_pm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_ps')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_path_stage_summary' AND `language_label`='' AND `language_tag`='summary'), '2', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

ALTER TABLE diagnosis_masters ADD COLUMN chus_multiple_primary_tumors char(1) default '';
ALTER TABLE diagnosis_masters_revs ADD COLUMN chus_multiple_primary_tumors char(1) default '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnDiagnosisMasternotation', 'DiagnosisMaster', 'diagnosis_masters', 'chus_multiple_primary_tumors', 'yes_no',  NULL , '0', '', '', '', 'multiple primary tumors', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='chus_multiple_primary_tumors' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='multiple primary tumors' AND `language_tag`=''), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='chus_multiple_primary_tumors' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='multiple primary tumors' AND `language_tag`=''), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
REPLACE INTO i18n (id,en)
VALUES
('multiple primary tumors','Multiple Primary Tumors');
INSERT IGNORE INTO i18n (id,en)
VALUES
('digestive system', 'Digestive System'),
('behavior code', 'Behavior Code'),
('cell origin', 'Cell Origin');
REPLACE INTO i18n (id,en,fr) 
VALUES
('disease','Disease','Maladie'),
('ajcc edition', 'Edition', 'Edition');

UPDATE structure_fields SET `language_label`='category' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='topography_category' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_topography_category');
UPDATE structure_fields SET  `language_label`='description' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='topography_description' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET `language_label`='type' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='morphology_tumour_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_type');
UPDATE structure_fields SET `language_label`='cell origin' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='morphology_tumour_cell_origin' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_cell_origin');
UPDATE structure_fields SET `language_label`='category' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='morphology_tumour_category' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_category');
UPDATE structure_fields SET `language_label`='behavior code' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='morphology_behaviour_code' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_behaviour_code');
UPDATE structure_fields SET  `language_label`='description' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='morphology_description' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='topography', `flag_override_label`='1', `language_label`='code' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='morphology', `flag_override_label`='1', `language_label`='code' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='topography' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='chus_autocomplete_digestive_topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='morphology' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='chus_autocomplete_digestive_morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_tag`='' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='topography_category' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_topography_category');
UPDATE structure_fields SET  `language_tag`='' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='topography_description' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_tag`='' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='morphology_tumour_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_type');
UPDATE structure_fields SET  `language_tag`='' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='morphology_tumour_cell_origin' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_cell_origin');
UPDATE structure_fields SET  `language_tag`='' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='morphology_tumour_category' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_tumour_category');
UPDATE structure_fields SET  `language_tag`='' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='morphology_behaviour_code' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chus_morphology_behaviour_code');
UPDATE structure_fields SET  `language_tag`='' WHERE model='DiagnosisDetail' AND tablename='chus_dx_digestive_system_tumors' AND field='morphology_description' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dx_digestive_system_tumors' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ajcc_edition' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ajcc edition') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_pt') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_pn') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_pm') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_tnm_ps') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='disease', `flag_override_label`='1', `language_label`='code' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_digestive_system_tumors') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('more than one topography value matches the following data [%s]', 
'More than one topography data matches the following value [%s]', 'Plus d''un code de topographie correspond à la valeur [%s]'),
('more than one morphology value matches the following data [%s]', 
'More than one morphology data matches the following value [%s]', 'Plus d''un code de morphologie correspond à la valeur [%s]'),
('no topography value matches the following data [%s]', 
'No topography data matches the following value [%s]', 'Aucun code de topographie correspond à la valeur [%s]'),
('no morphology value matches the following data [%s]', 
'No morphology data matches the following value [%s]', 'Aucun code de morphologie correspond à la valeur [%s]');

-- Progression / Recurrence / Remission

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method') AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx method' AND `language_label`='dx_method' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

-- Secondary

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('chus_scopndary_icd10_codes', "ClinicalAnnotation.DiagnosisMaster::getSecondaryIcd10Codes");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'icd10_code', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_scopndary_icd10_codes') , '0', '', '', 'help_primary code', 'disease code', '');
INSERT INTO structure_validations (`structure_field_id`, `rule`, `on_action`, `language_message`) 
(SELECT (SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='icd10_code' AND `type`='select' AND structure_value_domain=(SELECT id FROM structure_value_domains WHERE domain_name='chus_scopndary_icd10_codes') ), `rule`, `on_action`, `language_message` FROM structure_validations WHERE structure_field_id=(SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='icd10_code' AND `type`='autocomplete' AND structure_value_domain  IS NULL )) ;
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='chus_scopndary_icd10_codes') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='morphology', `flag_override_label`='1', `language_label`='code' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='disease', `flag_override_label`='1', `language_label`='code' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_scopndary_icd10_codes') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='topography', `flag_override_label`='1', `language_label`='code' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
ALTER TABLE dxd_secondaries ADD COLUMN laterality varchar(50) NOT NULL DEFAULT '';
ALTER TABLE dxd_secondaries_revs ADD COLUMN laterality varchar(50) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_secondaries', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', 'dx_laterality', 'laterality', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_secondary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='dxd_secondaries' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '3', '99', 'tissue specific', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_value_domains SET domain_name = 'chus_secondary_icd10_codes' WHERE domain_name = 'chus_scopndary_icd10_codes';

-- View diagnosis

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography');

-- event
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE event_controls SET flag_active = 0;
UPDATE menus SET flag_active = 0 WHERE use_link NOT LIKE '/ClinicalAnnotation/EventMasters/listall/Clinical/%' AND use_link LIKE '/ClinicalAnnotation/Event%';

-- Medical History

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'clinical', 'medical history', 1, 'chus_ed_medical_history', 'chus_ed_medical_history', 0, 'clinical|medical history', 0, 1, 1);

CREATE TABLE IF NOT EXISTS `chus_ed_medical_history` (
  type varchar(100) DEFAULT NULL,
  icd10_code varchar(10) DEFAULT NULL,
  yes_no char(1) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chus_ed_medical_history_revs` (
  type varchar(100) DEFAULT NULL,
  icd10_code varchar(10) DEFAULT NULL,
  yes_no char(1) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chus_ed_medical_history`
  ADD CONSTRAINT `chus_ed_medical_history_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_ed_medical_history');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('chus_ed_medical_history_diagnosis', "StructurePermissibleValuesCustom::getCustomDropdown('Medical History Diagnosis')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Medical History Diagnosis', 1, 100, '	clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Medical History Diagnosis');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('infectious hepatitis', 'Infectious hepatitis',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('hiv', 'HIV',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('stem cell transplant', 'Stem cell transplant',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('inflammatory bowel disease ', 'Inflammatory bowel disease ',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('digestive disease', 'Digestive disease',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'chus_ed_medical_history', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_ed_medical_history_diagnosis') , '0', '', '', '', 'diagnosis', ''), 
('ClinicalAnnotation', 'EventDetail', 'chus_ed_medical_history', 'yes_no', 'yes_no',  NULL , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'EventDetail', 'chus_ed_medical_history', 'icd10_code', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who', '', '', 'precision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_medical_history'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_medical_history' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_ed_medical_history_diagnosis')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis' AND `language_tag`=''), '1', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_medical_history'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_medical_history' AND `field`='yes_no' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_medical_history'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_medical_history' AND `field`='icd10_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '1', '9', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `language_tag`='diagnosed' WHERE model='EventDetail' AND tablename='chus_ed_medical_history' AND field='yes_no' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_medical_history' AND `field`='type'), 'notEmpty', '');
UPDATE structure_fields SET  `default`='n',  `language_tag`='diagnosed' WHERE model='EventDetail' AND tablename='chus_ed_medical_history' AND field='yes_no' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('medical history','Medical History','Historique médicale'),
('diagnosed','Diagnosed','Diagnostiqué');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_medical_history'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '31', '', '', '1', 'precision', '0', '', '0', '', '0', '', '1', 'rows=1,cols=30', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `language_label`='coding' WHERE model='EventDetail' AND tablename='chus_ed_medical_history' AND field='icd10_code' AND `type`='autocomplete' AND structure_value_domain  IS NULL ;

-- pathology report

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'clinical', 'pathology report', 1, 'chus_ed_pathology_report', 'chus_ed_pathology_report', 0, 'clinical|pathology report', 1, 1, 1);
CREATE TABLE IF NOT EXISTS `chus_ed_pathology_report` (
  report_number varchar(20) DEFAULT NULL,
  tumor_size varchar(20) DEFAULT NULL,
  data text DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chus_ed_pathology_report_revs` (
  report_number varchar(20) DEFAULT NULL,
  tumor_size varchar(20) DEFAULT NULL,
  data text DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chus_ed_pathology_report`
  ADD CONSTRAINT `chus_ed_pathology_report_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('chus_ed_pathology_report');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'chus_ed_pathology_report', 'report_number', 'input',  NULL , '0', '', '', '', 'pathology report number', ''), 
('ClinicalAnnotation', 'EventDetail', 'chus_ed_pathology_report', 'tumor_size', 'input',  NULL , '0', '', '', '', 'tumor size', ''), 
('ClinicalAnnotation', 'EventDetail', 'chus_ed_pathology_report', 'data', 'input',  NULL , '0', '', '', '', 'copy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_pathology_report'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_pathology_report' AND `field`='report_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathology report number' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_pathology_report'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_pathology_report' AND `field`='tumor_size' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor size' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_ed_pathology_report'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_pathology_report' AND `field`='data' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy' AND `language_tag`=''), '2', '10', 'report', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE event_controls SET use_addgrid = '0' WHERE event_type = 'pathology report';
UPDATE structure_fields SET  `type`='textarea',  `setting`='rows=20,cols=60',  `language_label`='data' WHERE model='EventDetail' AND tablename='chus_ed_pathology_report' AND field='data';
INSERT IGNORE INTO i18n(id,en,fr)
VALUES
('pathology report','Pathology Report','Rapport Pathologie'),
('pathology report number','Report #', 'Rapport #');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `tablename`='chus_ed_pathology_report' AND `field`='report_number'), 'notEmpty', '');
UPDATE structure_fields SET  `flag_confidential`='1' WHERE model='EventDetail' AND tablename='chus_ed_pathology_report' AND field='report_number' AND `type`='input' AND structure_value_domain  IS NULL ;

-- treatment_controls
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE treatment_controls SET flag_active = 0;
UPDATE treatment_extend_controls SET flag_active = 0;

-- Digestive System Surgery

INSERT INTO treatment_extend_controls (detail_tablename, detail_form_alias, flag_active, type, databrowser_label) VALUES
('chus_txe_digestive_system_surgeries_biopsies', 'chus_txe_digestive_system_surgeries_biopsies', 1, 'biopsy surgery site', 'biopsy surgery site');
INSERT INTO treatment_controls (tx_method, disease_site, flag_active, detail_tablename, detail_form_alias, 
display_order, applied_protocol_control_id, extended_data_import_process, databrowser_label, flag_use_for_ccl, treatment_extend_control_id, use_addgrid, use_detail_form_for_index) 
VALUES
('surgery', 'digestive system', 1, 'chus_txd_digestive_system_surgeries_biopsies', 'chus_txd_digestive_system_surgeries', 
0, NULL, NULL, 'digestive system|surgery', 1, (SELECT id FROM treatment_extend_controls WHERE type = 'biopsy surgery site'), 0, 1);

CREATE TABLE IF NOT EXISTS chus_txd_digestive_system_surgeries_biopsies (
  resection_margin varchar(50) DEFAULT NULL,
  treatment_master_id int(11) NOT NULL,
  KEY tx_master_id (treatment_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS chus_txd_digestive_system_surgeries_biopsies_revs (
  resection_margin varchar(50) DEFAULT NULL,
  treatment_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
ALTER TABLE chus_txd_digestive_system_surgeries_biopsies
  ADD CONSTRAINT chus_txd_digestive_system_surgeries_biopsies_ibfk_1 FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters (id);
INSERT INTO structures(`alias`) VALUES ('chus_txd_digestive_system_surgeries');
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("chus_resection_margin", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("Rx", "Rx (no resection)"), 
("R0", "R0 (complete tumor resection)"), 
("R1", "R1 (incomplete resection with microscopic residual)"), 
("R2", "R2 (incomplete resection with gross residual)"), 
("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_resection_margin"), (SELECT id FROM structure_permissible_values WHERE value="Rx" AND language_alias="Rx (no resection)"), "2", "1"), 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_resection_margin"), (SELECT id FROM structure_permissible_values WHERE value="R0" AND language_alias="R0 (complete tumor resection)"), "3", "1"), 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_resection_margin"), (SELECT id FROM structure_permissible_values WHERE value="R1" AND language_alias="R1 (incomplete resection with microscopic residual)"), "4", "1"), 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_resection_margin"), (SELECT id FROM structure_permissible_values WHERE value="R2" AND language_alias="R2 (incomplete resection with gross residual)"), "5", "1"), 
((SELECT id FROM structure_value_domains WHERE domain_name="chus_resection_margin"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "6", "1");
INSERT IGNORE INTO i18n (id, en) 
VALUES
('resection margin','Resection Margin'),
("Rx (no resection)", "Rx (No resection)"), 
("R0 (complete tumor resection)", "R0 (Complete tumor resection)"), 
("R1 (incomplete resection with microscopic residual)", "R1 (Incomplete resection with microscopic residual)"), 
("R2 (incomplete resection with gross residual)", "R2 (Incomplete resection with gross residual)");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', '', 'resection_margin', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_resection_margin') , '0', '', '', '', 'resection margin', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_digestive_system_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_digestive_system_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='resection_margin' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_resection_margin')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='resection margin' AND `language_tag`=''), '1', '40', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

CREATE TABLE IF NOT EXISTS `chus_txe_digestive_system_surgeries_biopsies` (
  `surgical_site` varchar(50) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chus_txe_digestive_system_surgeries_biopsies_revs` (
  `surgical_site` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chus_txe_digestive_system_surgeries_biopsies`
  ADD CONSTRAINT `FK_chus_txe_dig_syst_surgeries_biopsies_tx_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('chus_txe_digestive_system_surgeries_biopsies');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('chus_digestive_surgery_biopsy_site', "StructurePermissibleValuesCustom::getCustomDropdown('Digestive Surgery/Biopsy Sites')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Digestive Surgery/Biopsy Sites', 1, 50, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Digestive Surgery/Biopsy Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('oesophagus', "Oesophagus",  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('oesophagogastric junction', "Oesophagogastric junction",  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('stomach', "Stomach",  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('ampullary region', "Ampullary region",  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('small intestine', "Small intestine",  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('appendix', "Appendix",  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('colon and rectum', "Colon and rectum",  '', '1', @control_id, NOW(), NOW(), 1, 1),
('anal canal', "Anal canal",  '', '1', @control_id, NOW(), NOW(), 1, 1),
('liver and intrahepatic bile ducts', "Liver and intrahepatic bile ducts",  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('gallbladder and extrahepatic bile ducts', "Gallbladder and extrahepatic bile ducts",  '', '1', @control_id, NOW(), NOW(), 1, 1), 
('pancreas', "Pancreas",  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'chus_txe_digestive_system_surgeries_biopsies', 'surgical_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_digestive_surgery_biopsy_site') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txe_digestive_system_surgeries_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='chus_txe_digestive_system_surgeries_biopsies' AND `field`='surgical_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_digestive_surgery_biopsy_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='chus_txe_digestive_system_surgeries_biopsies' AND `field`='surgical_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_digestive_surgery_biopsy_site')), 'notEmpty', '');
INSERT IGNORE INTO i18n (id, en, fr) 
VALUES
('site','Site','Site'),
('biopsy surgery site','Surgery/Biopsy Site','Site chirurgie/biopsie');

-- Digestive System Biopsy

INSERT INTO treatment_controls (tx_method, disease_site, flag_active, detail_tablename, detail_form_alias, 
display_order, applied_protocol_control_id, extended_data_import_process, databrowser_label, flag_use_for_ccl, treatment_extend_control_id, use_addgrid, use_detail_form_for_index) 
VALUES
('biopsy', 'digestive system', 1, 'chus_txd_digestive_system_surgeries_biopsies', 'chus_txd_digestive_system_biopsies', 
0, NULL, NULL, 'digestive system|biopsy', 1, (SELECT id FROM treatment_extend_controls WHERE type = 'biopsy surgery site'), 0, 1);
INSERT INTO structures(`alias`) VALUES ('chus_txd_digestive_system_biopsies');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_digestive_system_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id, en, fr) 
VALUES
('biopsy','Biopsy','Biopsie');

-- Systemic therapy

INSERT INTO treatment_extend_controls (detail_tablename, detail_form_alias, flag_active, type, databrowser_label) VALUES
('chus_txe_systemic_therapies', 'chus_txe_systemic_therapies', 1, 'systemic therapy drug', 'systemic therapy drug');
INSERT INTO treatment_controls (tx_method, disease_site, flag_active, detail_tablename, detail_form_alias, 
display_order, applied_protocol_control_id, extended_data_import_process, databrowser_label, flag_use_for_ccl, treatment_extend_control_id, use_addgrid, use_detail_form_for_index) 
VALUES
('systemic therapy', 'general', 1, 'chus_txd_systemic_therapies', 'chus_txd_systemic_therapies', 
0, (SELECT id FROM protocol_controls WHERE type = 'systemic therapy') , 'importDrugFromChemoProtocol', 'general|systemic therapy', 0, (SELECT id FROM treatment_extend_controls WHERE type = 'systemic therapy drug'), 0, 1);
CREATE TABLE IF NOT EXISTS `chus_txd_systemic_therapies` (
  `completed` varchar(50) DEFAULT NULL,
  `response` varchar(50) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chus_txd_systemic_therapies_revs` (
  `completed` varchar(50) DEFAULT NULL,
  `response` varchar(50) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chus_txd_systemic_therapies`
  ADD CONSTRAINT `chus_txd_systemic_therapies_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
CREATE TABLE IF NOT EXISTS chus_txe_systemic_therapies (
  dose varchar(50) DEFAULT NULL,
  method varchar(50) DEFAULT NULL,
  drug_id int(11) NULL,
  treatment_extend_master_id int(11) NOT NULL,
  KEY tx_master_id (treatment_extend_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS chus_txe_systemic_therapies_revs (
  dose varchar(50) DEFAULT NULL,
  method varchar(50) DEFAULT NULL,
  drug_id int(11) NULL,
  treatment_extend_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
ALTER TABLE chus_txe_systemic_therapies
  ADD CONSTRAINT chus_txe_systemic_therapies_ibfk_1 FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id),
  ADD CONSTRAINT chus_txe_systemic_therapies_ibfk_2 FOREIGN KEY (drug_id) REFERENCES drugs (id);
INSERT INTO structures(`alias`) VALUES ('chus_txd_systemic_therapies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'chus_txd_systemic_therapies', 'response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='response') , '0', '', '', 'help_response', 'response', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'chus_txd_systemic_therapies', 'completed', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'completed', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_intent' AND `language_label`='intent' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_protocol_name' AND `language_label`='protocol' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_systemic_therapies' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_response' AND `language_label`='response' AND `language_tag`=''), '2', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_systemic_therapies' AND `field`='completed' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='completed' AND `language_tag`=''), '2', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structures(`alias`) VALUES ('chus_txe_systemic_therapies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'chus_txe_systemic_therapies', 'dose', 'input',  NULL , '0', 'size=10', '', 'help_dose', 'dose', ''), 
('ClinicalAnnotation', 'TreatmentExtendDetail', 'chus_txe_systemic_therapies', 'method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') , '0', '', '', 'help_method', 'method', ''), 
('ClinicalAnnotation', 'TreatmentExtendDetail', 'chus_txe_systemic_therapies', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='drug_list') , '0', '', '', 'help_drug_id', 'drug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txe_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='chus_txe_systemic_therapies' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_dose' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txe_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='chus_txe_systemic_therapies' AND `field`='method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_method' AND `language_label`='method' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txe_systemic_therapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='chus_txe_systemic_therapies' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO i18n (id,en) VALUES ('systemic therapy drug','Systemic Therpay Drug');

-- radio therapy

INSERT INTO treatment_extend_controls (detail_tablename, detail_form_alias, flag_active, type, databrowser_label) VALUES
('chus_txe_digestive_system_radiotherapies', 'chus_txe_digestive_system_radiotherapies', 1, 'radiotherapy site', 'radiotherapy site');
INSERT INTO treatment_controls (tx_method, disease_site, flag_active, detail_tablename, detail_form_alias, 
display_order, applied_protocol_control_id, extended_data_import_process, databrowser_label, flag_use_for_ccl, treatment_extend_control_id, use_addgrid, use_detail_form_for_index) 
VALUES
('radiotherapy', 'digestive system', 1, 'chus_txd_digestive_system_radiotherapies', 'chus_txd_digestive_system_radiotherapies', 
0, (SELECT id FROM protocol_controls WHERE type = 'radiotherapy'), NULL, 'digestive system|radiotherapy', 1, (SELECT id FROM treatment_extend_controls WHERE type = 'radiotherapy site'), 0, 1);
CREATE TABLE IF NOT EXISTS chus_txd_digestive_system_radiotherapies (
  `completed` varchar(50) DEFAULT NULL,
  `response` varchar(50) DEFAULT NULL,
  treatment_master_id int(11) NOT NULL,
  KEY tx_master_id (treatment_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS chus_txd_digestive_system_radiotherapies_revs (
  `completed` varchar(50) DEFAULT NULL,
  `response` varchar(50) DEFAULT NULL,
  treatment_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;
ALTER TABLE chus_txd_digestive_system_radiotherapies
  ADD CONSTRAINT chus_txd_digestive_system_radiotherapies_ibfk_1 FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters (id);
CREATE TABLE IF NOT EXISTS `chus_txe_digestive_system_radiotherapies` (
  `site` varchar(50) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `chus_txe_digestive_system_radiotherapies_revs` (
  `site` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `chus_txe_digestive_system_radiotherapies`
  ADD CONSTRAINT `FK_chus_txe_dig_syst_radiotherapies_tx_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('chus_txd_digestive_system_radiotherapies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'chus_txd_digestive_system_radiotherapies', 'response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='response') , '0', '', '', 'help_response', 'response', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'chus_txd_digestive_system_radiotherapies', 'completed', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'completed', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_digestive_system_radiotherapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_intent' AND `language_label`='intent' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_digestive_system_radiotherapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_digestive_system_radiotherapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_digestive_system_radiotherapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_protocol_name' AND `language_label`='protocol' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_digestive_system_radiotherapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_digestive_system_radiotherapies' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_response' AND `language_label`='response' AND `language_tag`=''), '2', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_txd_digestive_system_radiotherapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='chus_txd_digestive_system_radiotherapies' AND `field`='completed' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='completed' AND `language_tag`=''), '2', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_value_domains SET domain_name = 'chus_digestive_surgery_biopsy_site', source = "StructurePermissibleValuesCustom::getCustomDropdown('Digestive System Treatment Sites')" WHERE domain_name = 'chus_digestive_surgery_biopsy_site';
UPDATE structure_permissible_values_custom_controls SET name = 'Digestive System Treatment Sites' WHERE name = 'Digestive Surgery/Biopsy Sites';
INSERT INTO structures(`alias`) VALUES ('chus_txe_digestive_system_radiotherapies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'chus_txe_digestive_system_radiotherapies', 'site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_digestive_surgery_biopsy_site') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txe_digestive_system_radiotherapies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='chus_txe_digestive_system_radiotherapies' AND `field`='site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_digestive_surgery_biopsy_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `tablename`='chus_txe_digestive_system_radiotherapies' AND `field`='site'), 'notEmpty', '');

-- final clean up

UPDATE treatment_controls SET flag_use_for_ccl = 0 WHERE tx_method NOT IN ('surgery','biopsy') AND flag_active = 1;



SELECT * FROM treatment_controls WHERE flag_active = 1;


-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Collection
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- Clinical Collection Link 

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');








aide code topo et morpho
history
redirect apres add chir biopsie systemic treatment pour avoir le add precision
dans detail annotation ne pas afficher le links to collection si pas de uss_ccl







xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('xeno_tissue_source_list', "StructurePermissibleValuesCustom::getCustomDropdown('Xenograft Tissues Sources')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Xenograft Tissues Sources', 1, 50, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Xenograft Tissues Sources');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('liver', 'Liver',  'Foie', '1', @control_id, NOW(), NOW(), 1, 1),

mysql -u root chusoncoaxis --default-character-set=utf8 < atim_v2.6.0_full_installation.sql
mysql -u root chusoncoaxis --default-character-set=utf8 < atim_v2.6.1_upgrade.sql
mysql -u root chusoncoaxis --default-character-set=utf8 < atim_v2.6.2_upgrade.sql
mysql -u root chusoncoaxis --default-character-set=utf8 < atim_v2.6.3_upgrade.sql
mysql -u root chusoncoaxis --default-character-set=utf8 < atim_v2.6.4_upgrade.sql
mysql -u root chusoncoaxis --default-character-set=utf8 < atim_v2.6.5_upgrade.sql
mysql -u root chusoncoaxis --default-character-set=utf8 < atim_v2.6.6_upgrade.sql
mysql -u root chusoncoaxis --default-character-set=utf8 < atim_v2.6.7_upgrade.sql
mysql -u root chusoncoaxis --default-character-set=utf8 < atim_v2.6.8_upgrade.sql
mysql -u root chusoncoaxis --default-character-set=utf8 <  custom_post_v268.sql
mysql -u root chusoncoaxis --default-character-set=utf8 <  custom_post_v268_data.sql
