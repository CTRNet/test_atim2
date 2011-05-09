-- Terry fox CPCBN customization script
-- Run after 2.2.2 install
INSERT INTO i18n (id, en, fr) VALUES
('core_installname', 'CPCBN-TFRI', 'CPCBN-TFRI'),
('prostatite', 'Prostatite', 'Prostatite'),
('prostate cancer', 'Prostate cancer', 'Cancer de la prostate'),
('other cancer', 'Other cancer', 'Autre cancer'),
('qc_tf_first_psa_2', 'First PSA of at least 0.2 and rising', "Premier PSA d'au moins 0.2 et en augmentation"),
('qc_tf_first_psa_3', 'first PSA of at least 0.3 followed by another increase', "Premier PSA d'au moins 0.3 et suivi d'une autre augmentation"),
("diagnosis date", "Diagnosis date", "Date du diagnostic"),
("age at diagnosis", "Age at diagnosis", "Âge au diagnostic"),
("diagnostic tool", "Diagnostic tool", "Outil de diagnostic"),
("biopsy", "Biopsy", "Biopsie"),
("gleason score at biopsy", "Gleason score at biopsy", "Pointage de Gleason à la biopsie"),
("number of biopsies", "Number of biopsies", "Nombre de biopsies"),
("ptnm", "pTNM", "pTNM"),
("gleason sum rp", "Gleason sum RP", "Addition Gleason RP"),
("presence lymph node invasion", "Presence lymph node invasion", "Présence d'invasion de noeuds lymphatiques"),
("presence seminal invasion", "Presences seminal invasion", "Présence d'invasion séminale"),
("biochemical recurrence", "biochemical recurrence", "Récurrence biochimique"),
("date biochemical recurrence", "Date biochemical recurrence", "Date de récurrence biochimique"),
("date biochemical recurrence definition", "Date biochemical recurrence definition", "Date de définition de récurrence biochimique"),
("PSA follow by a treatment", "PSA follow by a treatment", "PSA suivi d'un traitement"),
("phoenix definition", "Phoenix definition", "Définition Phoenix"),
("development metastasis", "Development metastasis", "Dévelopement de métastases"),
("type of metastasis", "Type of metastasis", "Type de métastase"),
("lymph node", "Lymph node", "Noeud lymphatique"),
("date of metastasis diagnosis", "Date of metastasis diagnosis", "Date du diagnostic des métastases"),
("hormonorefractory", "Hormonorefractory", ""),
("HR", "HR", "HR"),
("not HR", "Not HR", "Pas HR");


UPDATE users SET flag_active=true;
UPDATE event_controls SET flag_active = false;
UPDATE diagnosis_controls SET flag_active = false;
UPDATE tx_controls SET flag_active = false;

SET foreign_key_checks=0;
DELETE FROM banks;
ALTER TABLE banks AUTO_INCREMENT=1;
SET foreign_key_checks=1;

ALTER TABLE banks
 ADD COLUMN misc_identifier_control_id INT DEFAULT NULL;

INSERT INTO misc_identifier_controls (misc_identifier_name, misc_identifier_name_abbrev, flag_once_per_participant) VALUES
('McGill-CPCBN', 'McGill-CPCBN', 1),
('CHUQ', 'CHUQ', 1);

INSERT INTO banks(`name`, `description`, `misc_identifier_control_id`, `created_by`, `created`, `modified_by`, `modified`) VALUES
('McGill-CPCBN', '', 1, 1, NOW(), 1, NOW()),
('CHUQ', '', 2, 1, NOW(), 1, NOW());

ALTER TABLE participants
 ADD COLUMN qc_tf_bank_id INT UNSIGNED NOT NULL,
 ADD COLUMN qc_tf_suspected_date_of_death DATE DEFAULT NULL,
 ADD COLUMN qc_tf_suspected_date_of_death_accuracy CHAR(1) DEFAULT '',
 ADD COLUMN qc_tf_last_contact DATE DEFAULT NULL,
 ADD COLUMN qc_tf_last_contact_accuracy CHAR(1) DEFAULT '',
 ADD COLUMN qc_tf_death_from_cancer CHAR(1) DEFAULT '',
 ADD COLUMN qc_tf_family_history VARCHAR(50),
 ADD COLUMN qc_tf_follow_up_months TINYINT UNSIGNED DEFAULT NULL;
ALTER TABLE participants_revs
 ADD COLUMN qc_tf_bank_id INT UNSIGNED NOT NULL,
 ADD COLUMN qc_tf_suspected_date_of_death DATE DEFAULT NULL,
 ADD COLUMN qc_tf_suspected_date_of_death_accuracy CHAR(1) DEFAULT '',
 ADD COLUMN qc_tf_last_contact DATE DEFAULT NULL,
 ADD COLUMN qc_tf_last_contact_accuracy CHAR(1) DEFAULT '',
 ADD COLUMN qc_tf_death_from_cancer CHAR(1) DEFAULT '',
 ADD COLUMN qc_tf_family_history VARCHAR(50),
 ADD COLUMN qc_tf_follow_up_months TINYINT UNSIGNED DEFAULT NULL;
 
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('family history prostate cancer', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("prostatite", "prostatite");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="family history prostate cancer"),  (SELECT id FROM structure_permissible_values WHERE value="prostatite" AND language_alias="prostatite"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("prostate cancer", "prostate cancer");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="family history prostate cancer"),  (SELECT id FROM structure_permissible_values WHERE value="prostate cancer" AND language_alias="prostate cancer"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other cancer", "other cancer");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="family history prostate cancer"),  (SELECT id FROM structure_permissible_values WHERE value="other cancer" AND language_alias="other cancer"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("no", "no");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="family history prostate cancer"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="family history prostate cancer"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'qc_tf_suspected_date_of_death_accuracy', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy') , '0', '', '', '', '', 'accuracy'), 
('Clinicalannotation', 'Participant', 'participants', 'qc_tf_last_contact', 'date',  NULL , '0', '', '', '', 'last contact', ''), 
('Clinicalannotation', 'Participant', 'participants', 'qc_tf_death_from_cancer', 'yes_no',  NULL , '0', '', '', '', 'death from cancer', ''), 
('Clinicalannotation', 'Participant', 'participants', 'qc_tf_family_history', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='family history prostate cancer') , '0', '', '', '', 'family history', ''), 
('Clinicalannotation', 'Participant', 'participants', 'qc_tf_last_contact_accuracy', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy') , '0', '', '', '', '', 'accuracy');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_suspected_date_of_death_accuracy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='accuracy'), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_last_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact' AND `language_tag`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_death_from_cancer' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='death from cancer' AND `language_tag`=''), '1', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_family_history' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='family history prostate cancer')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='family history' AND `language_tag`=''), '1', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_last_contact_accuracy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='accuracy'), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_fields SET  `field`='qc_tf_suspected_date_of_death',  `type`='date',  `setting`='',  `language_label`='suspected date of death' WHERE model='Participant' AND tablename='participants' AND field='notes' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20', `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_suspected_date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_last_contact' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_death_from_cancer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_family_history' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='family history prostate cancer') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_suspected_date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'qc_tf_follow_up_months', 'integer_positive',  NULL , '0', '', '', '', 'follow up (months)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_follow_up_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='follow up (months)' AND `language_tag`=''), '1', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');


ALTER TABLE txd_surgeries
 ADD COLUMN qc_tf_type VARCHAR(50) DEFAULT '';
ALTER TABLE txd_surgeries_revs
 ADD COLUMN qc_tf_type VARCHAR(50) DEFAULT '';
INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_surgery_type', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("RP", "RP");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_surgery_type"),  (SELECT id FROM structure_permissible_values WHERE value="RP" AND language_alias="RP"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("biopsy", "biopsy");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_surgery_type"),  (SELECT id FROM structure_permissible_values WHERE value="biopsy" AND language_alias="biopsy"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("TURP", "TURP");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_surgery_type"),  (SELECT id FROM structure_permissible_values WHERE value="TURP" AND language_alias="TURP"), "1", "1");

INSERT INTO diagnosis_controls (controls_type ,flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('CPCBN', 1, 'qc_tf_dxd_cpcbn', 'qc_tf_dxd_cpcbn', 1, 'CPCBN');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_gleason_score_biopsy', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("1", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_score_biopsy"),  (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2", "2");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_score_biopsy"),  (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("3", "3");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_score_biopsy"),  (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("4", "4");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_score_biopsy"),  (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("5", "5");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_score_biopsy"),  (SELECT id FROM structure_permissible_values WHERE value="5" AND language_alias="5"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("6", "6");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_score_biopsy"),  (SELECT id FROM structure_permissible_values WHERE value="6" AND language_alias="6"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("7", "7");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_score_biopsy"),  (SELECT id FROM structure_permissible_values WHERE value="7" AND language_alias="7"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("8", "8");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_score_biopsy"),  (SELECT id FROM structure_permissible_values WHERE value="8" AND language_alias="8"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("9", "9");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_score_biopsy"),  (SELECT id FROM structure_permissible_values WHERE value="9" AND language_alias="9"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_score_biopsy"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_ptnm', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Ia", "Ia");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"),  (SELECT id FROM structure_permissible_values WHERE value="Ia" AND language_alias="Ia"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Ib", "Ib");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"),  (SELECT id FROM structure_permissible_values WHERE value="Ib" AND language_alias="Ib"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Ic", "Ic");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"),  (SELECT id FROM structure_permissible_values WHERE value="Ic" AND language_alias="Ic"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("IIa", "IIa");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"),  (SELECT id FROM structure_permissible_values WHERE value="IIa" AND language_alias="IIa"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("IIb", "IIb");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"),  (SELECT id FROM structure_permissible_values WHERE value="IIb" AND language_alias="IIb"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("IIc", "IIc");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"),  (SELECT id FROM structure_permissible_values WHERE value="IIc" AND language_alias="IIc"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("IIIa", "IIIa");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"),  (SELECT id FROM structure_permissible_values WHERE value="IIIa" AND language_alias="IIIa"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("IIIb", "IIIb");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"),  (SELECT id FROM structure_permissible_values WHERE value="IIIb" AND language_alias="IIIb"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("IIIc", "IIIc");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"),  (SELECT id FROM structure_permissible_values WHERE value="IIIc" AND language_alias="IIIc"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("IV", "IV");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"),  (SELECT id FROM structure_permissible_values WHERE value="IV" AND language_alias="IV"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_gleason_sum_rp', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("2", "2");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_sum_rp"),  (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("3", "3");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_sum_rp"),  (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("4", "4");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_sum_rp"),  (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("5", "5");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_sum_rp"),  (SELECT id FROM structure_permissible_values WHERE value="5" AND language_alias="5"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("6", "6");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_sum_rp"),  (SELECT id FROM structure_permissible_values WHERE value="6" AND language_alias="6"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("7", "7");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_sum_rp"),  (SELECT id FROM structure_permissible_values WHERE value="7" AND language_alias="7"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("8", "8");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_sum_rp"),  (SELECT id FROM structure_permissible_values WHERE value="8" AND language_alias="8"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("9", "9");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_sum_rp"),  (SELECT id FROM structure_permissible_values WHERE value="9" AND language_alias="9"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("10", "10");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_sum_rp"),  (SELECT id FROM structure_permissible_values WHERE value="10" AND language_alias="10"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_sum_rp"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_date_biochemical_recurrence_definition', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("Phoenix definition", "phoenix definition");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_date_biochemical_recurrence_definition"),  (SELECT id FROM structure_permissible_values WHERE value="Phoenix definition" AND language_alias="phoenix definition"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("qc_tf_first_psa_2", "qc_tf_first_psa_2");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_date_biochemical_recurrence_definition"),  (SELECT id FROM structure_permissible_values WHERE value="qc_tf_first_psa_2" AND language_alias="qc_tf_first_psa_2"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("qc_tf_first_psa_3", "qc_tf_first_psa_3");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_date_biochemical_recurrence_definition"),  (SELECT id FROM structure_permissible_values WHERE value="qc_tf_first_psa_3" AND language_alias="qc_tf_first_psa_3"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("PSA follow by a  treatment", "PSA follow by a  treatment");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_date_biochemical_recurrence_definition"),  (SELECT id FROM structure_permissible_values WHERE value="PSA follow by a  treatment" AND language_alias="PSA follow by a  treatment"), "1", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_metastasis_type', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("no", "no");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_metastasis_type"),  (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("lymph node", "lymph node");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_metastasis_type"),  (SELECT id FROM structure_permissible_values WHERE value="lymph node" AND language_alias="lymph node"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("bone", "bone");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_metastasis_type"),  (SELECT id FROM structure_permissible_values WHERE value="bone" AND language_alias="bone"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("lung", "lung");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_metastasis_type"),  (SELECT id FROM structure_permissible_values WHERE value="lung" AND language_alias="lung"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("liver", "liver");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_metastasis_type"),  (SELECT id FROM structure_permissible_values WHERE value="liver" AND language_alias="liver"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("other", "other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_metastasis_type"),  (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_metastasis_type"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_hormonorefractory_status', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("HR", "HR");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_hormonorefractory_status"),  (SELECT id FROM structure_permissible_values WHERE value="HR" AND language_alias="HR"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("not HR", "not HR");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_hormonorefractory_status"),  (SELECT id FROM structure_permissible_values WHERE value="not HR" AND language_alias="not HR"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_hormonorefractory_status"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "1", "1");

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('qc_tf_dx_tool', '', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("biopsy", "biopsy");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_dx_tool"),  (SELECT id FROM structure_permissible_values WHERE value="biopsy" AND language_alias="biopsy"), "", "");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("RP", "RP");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_dx_tool"),  (SELECT id FROM structure_permissible_values WHERE value="RP" AND language_alias="RP"), "", "");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("TRUS", "TRUS");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_dx_tool"),  (SELECT id FROM structure_permissible_values WHERE value="TRUS" AND language_alias="TRUS"), "", "");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("PSA+DRE", "PSA+DRE");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_dx_tool"),  (SELECT id FROM structure_permissible_values WHERE value="PSA+DRE" AND language_alias="PSA+DRE"), "", "");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_dx_tool"),  (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "", "");


CREATE TABLE qc_tf_dxd_cpcbn(
 id INT AUTO_INCREMENT PRIMARY KEY,
 diagnosis_master_id INT,
 diagnosis_tool VARCHAR(50) DEFAULT '',
 gleason_score_at_biopsy VARCHAR(50) NOT NULL DEFAULT '',
 number_of_biopsies TINYINT UNSIGNED DEFAULT NULL,
 ptnm VARCHAR(50) NOT NULL DEFAULT '',
 gleason_sum_rp VARCHAR(50) NOT NULL DEFAULT '',
 presence_lymph_node_invasion CHAR(1) NOT NULL DEFAULT '', 
 presence_capsular_penetration CHAR(1) NOT NULL DEFAULT '',
 presence_seminal_invasion CHAR(1) NOT NULL DEFAULT '',
 margin CHAR(1) NOT NULL DEFAULT '',
 date_biochemical_recurrence DATE DEFAULT NULL,
 date_biochemical_recurrence_accuracy CHAR(1) DEFAULT '',
 date_biochemical_recurrence_definition VARCHAR(50) DEFAULT '',
 type_of_metastasis VARCHAR(50) DEFAULT '',
 date_of_metastasis_dx DATE DEFAULT NULL,
 hormonorefractory_status VARCHAR(50) DEFAULT '',
 date_of_hormonorefractory_status_dx DATE DEFAULT NULL,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  FOREIGN KEY (diagnosis_master_id) REFERENCES `diagnosis_masters`(`id`)
)Engine=InnoDb;
CREATE TABLE qc_tf_dxd_cpcbn_revs(
 id INT,
 diagnosis_master_id INT,
 diagnosis_tool VARCHAR(50) DEFAULT '',
 gleason_score_at_biopsy VARCHAR(50) NOT NULL DEFAULT '',
 number_of_biopsies TINYINT UNSIGNED DEFAULT NULL,
 ptnm VARCHAR(50) NOT NULL DEFAULT '',
 gleason_sum_rp VARCHAR(50) NOT NULL DEFAULT '',
 presence_lymph_node_invasion CHAR(1) NOT NULL DEFAULT '', 
 presence_capsular_penetration CHAR(1) NOT NULL DEFAULT '',
 presence_seminal_invasion CHAR(1) NOT NULL DEFAULT '',
 margin CHAR(1) NOT NULL DEFAULT '',
 date_biochemical_recurrence DATE DEFAULT NULL,
 date_biochemical_recurrence_accuracy CHAR(1) DEFAULT '',
 date_biochemical_recurrence_definition VARCHAR(50) DEFAULT '',
 type_of_metastasis VARCHAR(50) DEFAULT '',
 date_of_metastasis_dx DATE DEFAULT NULL,
 hormonorefractory_status VARCHAR(50) DEFAULT '',
 date_of_hormonorefractory_status_dx DATE DEFAULT NULL,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
 `version_id` int(11) NOT NULL AUTO_INCREMENT,
 `version_created` datetime NOT NULL,
 PRIMARY KEY (`version_id`) 
)Engine=InnoDb;

INSERT INTO structures(`alias`) VALUES ('qc_tf_dxd_cpcbn');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'diagnosis_tool', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_dx_tool') , '0', '', '', '', 'diagnosis tool', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'gleason_score_at_biopsy', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_score_biopsy') , '0', '', '', '', 'gleason score at biopsy', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'number_of_biopsies', 'integer_positive',  NULL , '0', '', '', '', 'number of biopsies', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'ptnm', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ptnm') , '0', '', '', '', 'ptnm', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'gleason_sum_rp', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_sum_rp') , '0', '', '', '', 'gleason sum rp', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'date_biochemical_recurrence', 'date',  NULL , '0', '', '', '', 'date biochemical recurrence', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'date_biochemical_recurrence_accuracy', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy') , '0', '', '', '', '', 'accuracy'), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'date_biochemical_recurrence_definition', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_date_biochemical_recurrence_definition') , '0', '', '', '', 'date biochemical recurrence definition', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'type_of_metastasis', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_metastasis_type') , '0', '', '', '', 'type of metastasis', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'date_of_metastasis_dx', 'date',  NULL , '0', '', '', '', 'date of metastasis diagnosis', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'hormonorefractory_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_hormonorefractory_status') , '0', '', '', '', 'hormonorefractory status', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'diagnosis_masters', 'age_at_dx', 'integer_positive',  NULL , '0', '', '', '', 'age at diagnosis', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'date_of_hormonorefractory_status_dx', 'date',  NULL , '0', '', '', '', 'date of hormonorefractory status diagnosis', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'presence_lymph_node_invasion', 'yes_no', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_sum_rp') , '0', '', '', '', 'presence lymph node invasion', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'presence_capsular_penetration', 'yes_no', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_sum_rp') , '0', '', '', '', 'presence capsular penetration', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'presence_seminal_invasion', 'yes_no', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_sum_rp') , '0', '', '', '', 'presence seminal invasion', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'margin', 'yes_no', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_sum_rp') , '0', '', '', '', 'margin', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '1', 'diagnosis date', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date_accuracy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy')  AND `flag_confidential`='0'), '1', '2', '', '0', '', '1', 'accuracy', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='diagnosis_tool' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_dx_tool')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis tool' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_score_at_biopsy' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_score_biopsy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason score at biopsy' AND `language_tag`=''), '1', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='number_of_biopsies' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of biopsies' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='ptnm' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ptnm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ptnm' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_sum_rp' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_sum_rp')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason sum rp' AND `language_tag`=''), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='date_biochemical_recurrence' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date biochemical recurrence' AND `language_tag`=''), '2', '12', 'biochemical recurrence', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='date_biochemical_recurrence_accuracy' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='accuracy'), '2', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='date_biochemical_recurrence_definition' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_date_biochemical_recurrence_definition')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date biochemical recurrence definition' AND `language_tag`=''), '2', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='type_of_metastasis' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_metastasis_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type of metastasis' AND `language_tag`=''), '2', '15', 'development of metastasis', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='date_of_metastasis_dx' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date of metastasis diagnosis' AND `language_tag`=''), '2', '16', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='hormonorefractory_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_hormonorefractory_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hormonorefractory status' AND `language_tag`=''), '2', '17', 'hormonorefractory', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='age at diagnosis' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='date_of_hormonorefractory_status_dx' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date of hormonorefractory status diagnosis' AND `language_tag`=''), '2', '18', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_lymph_node_invasion' AND `type`='yes_no' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_sum_rp')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='presence lymph node invasion' AND `language_tag`=''), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_capsular_penetration' AND `type`='yes_no' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_sum_rp')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='presence capsular penetration' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_seminal_invasion' AND `type`='yes_no' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_sum_rp')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='presence seminal invasion' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='margin' AND `type`='yes_no' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_sum_rp')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='margin' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'qc_tf_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_surgery_type') , '0', '', '', '', 'qc tf type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_surgery_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='qc tf type' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='facility' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='facility') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='protocol_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='path_num' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='finish_date_accuracy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='date_accuracy') AND `flag_confidential`='0');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_surgery_type') ,  `language_label`='type' WHERE model='TreatmentDetail' AND tablename='txd_surgeries' AND field='qc_tf_type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_surgery_type');



INSERT INTO event_controls (event_group, event_type, flag_active, form_alias, detail_tablename, display_order, databrowser_label) VALUES
('clinical', 'CPCBN', 1, 'qc_tf_ed_cpcbn', 'qc_tf_ed_cpcbn', 0, 'clinical|all|CPCBN');

ALTER TABLE event_masters 
 ADD COLUMN event_date_accuracy CHAR(1) DEFAULT '';
ALTER TABLE event_masters_revs 
 ADD COLUMN event_date_accuracy CHAR(1) DEFAULT '';

CREATE TABLE qc_tf_ed_cpcbn(
 id INT AUTO_INCREMENT PRIMARY KEY,
 event_master_id INT,
 event_end_date DATE DEFAULT NULL,
 event_end_date_accuracy CHAR(1) DEFAULT '',
 psa_ng_on_ml FLOAT UNSIGNED DEFAULT NULL,
 radiotherapy CHAR(1) DEFAULT '',
 radiotherapy_dose VARCHAR(50) DEFAULT '',
 tx_precision1 VARCHAR(50) DEFAULT '',
 tx_precision2 VARCHAR(50) DEFAULT '',
 tx_precision3 VARCHAR(50) DEFAULT '',
 tx_precision4 VARCHAR(50) DEFAULT '',
 hormonotherapy VARCHAR(1) DEFAULT '',
 chemiotherapy VARCHAR(1) DEFAULT '',
 notes text NOT NULL,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  FOREIGN KEY (event_master_id) REFERENCES `event_masters`(`id`)
)Engine=InnoDb;
CREATE TABLE qc_tf_ed_cpcbn_revs(
 id INT,
 event_master_id INT,
 event_end_date DATE DEFAULT NULL,
 event_end_date_accuracy CHAR(1) DEFAULT '',
 psa_ng_on_ml FLOAT UNSIGNED DEFAULT NULL,
 radiotherapy CHAR(1) DEFAULT '',
 radiotherapy_dose VARCHAR(50) DEFAULT '',
 tx_precision1 VARCHAR(50) DEFAULT '',
 tx_precision2 VARCHAR(50) DEFAULT '',
 tx_precision3 VARCHAR(50) DEFAULT '',
 tx_precision4 VARCHAR(50) DEFAULT '',
 hormonotherapy VARCHAR(1) DEFAULT '',
 chemiotherapy VARCHAR(1) DEFAULT '',
 notes text NOT NULL,
 `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
 `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `version_created` datetime NOT NULL,
  FOREIGN KEY (event_master_id) REFERENCES `event_masters`(`id`)
)Engine=InnoDb;