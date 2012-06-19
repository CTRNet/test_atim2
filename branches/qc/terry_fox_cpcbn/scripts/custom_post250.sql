UPDATE misc_identifiers mi INNER JOIN misc_identifier_controls mic ON mi.misc_identifier_control_id=mic.id SET mi.flag_unique=1 WHERE mic.flag_unique=true AND mi.deleted=0;
ALTER TABLE ed_all_lifestyle_smokings DROP COLUMN years_quit_smoking;
ALTER TABLE ed_all_lifestyle_smokings_revs DROP COLUMN years_quit_smoking;

UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'notes', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'notes', ''),
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'bank', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_bank_id'), 'notEmpty');

ALTER TABLE participants 
  DROP COLUMN qc_tf_bank_id,
  ADD COLUMN `qc_tf_bank_id` int(11) DEFAULT NULL AFTER deleted;
  
ALTER TABLE `participants`
  ADD CONSTRAINT `FK_participants_aliquot_controls` FOREIGN KEY (`qc_tf_bank_id`) REFERENCES `banks` (`id`);

ALTER TABLE participants_revs 
  DROP COLUMN qc_tf_bank_id,
  ADD COLUMN `qc_tf_bank_id` int(11) DEFAULT NULL;
  
UPDATE structure_fields SET  `type`='yes_no' WHERE model='Participant' AND tablename='participants' AND field='qc_tf_death_from_prostate_cancer' AND `type`='y_n_u' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_column`='3', `language_heading`='family history and follow-up data' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_family_history' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_fam_hist_prostate_cancer') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_follow_up_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_suspected_date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_death_from_prostate_cancer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='24' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='23'  WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_last_contact' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `language_heading`='family history' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_family_history' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_fam_hist_prostate_cancer') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_follow_up_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='125' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_family_history' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_fam_hist_prostate_cancer') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE `groups` SET `flag_show_confidential` = '1' WHERE `id` =1;
  
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE banks SET misc_identifier_control_id = NULL;
UPDATE banks SET name = 'CHUM-Saad' WHERE id = 1;
UPDATE banks SET name = 'CHUQ-Lacombe' WHERE id = 2;
UPDATE banks SET name = 'McGill-Aprikian' WHERE id = 3;
UPDATE banks SET name = 'PMH-Fleshner' WHERE id = 4;
UPDATE banks SET name = 'VPC-Gleave' WHERE id = 5;

INSERT INTO `banks` (`id`, `name`, `description`, `misc_identifier_control_id`, `created_by`, `created`, `modified_by`, `modified`, `deleted`) VALUES
(null, 'PMH-Bristow', '', NULL, 1, NULL, 1, NULL, 0),
(null, 'Sunnybrook-Klotz', '', NULL, 1, NULL, 1, NULL, 0);

ALTER TABLE participants 
  ADD COLUMN `qc_tf_bank_participant_identifier`  varchar(50) NOT NULL DEFAULT '';
ALTER TABLE participants_revs
  ADD COLUMN `qc_tf_bank_participant_identifier`  varchar(50) NOT NULL DEFAULT '';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_bank_participant_identifier', 'input',  NULL , '0', 'size=20', '', '', 'bank patient #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_bank_participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='bank patient #' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_bank_participant_identifier' AND `type`='input'), 'notEmpty');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('bank patient #','Patient # (Bank)','# Patient (banque)'),
('prostate', 'Prostate','Prostate');

DELETE FROM misc_identifiers;
DELETE FROM misc_identifiers_revs;
DELETE FROM misc_identifier_controls;

SET @id = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 = @id OR id2 = @id;

UPDATE diagnosis_controls SET controls_type = 'prostate', databrowser_label = 'primary|prostate' WHERE controls_type = 'CPCBN';

UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_dx_tool') ,  `language_label`='diagnosis method' WHERE model='DiagnosisDetail' AND tablename='qc_tf_dxd_cpcbn' AND field='tool' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_dx_tool');
UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='tool' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_dx_tool') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_score' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_score_biopsy') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='score' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='ptnm' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ptnm') AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_tf_gleason_values", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("1", "1"),
("2", "2"),
("3", "3"),
('4','4'),
('5','5'),
('6','6'),
('7','7'),
('8','8'),
('9','9'),
('10','10');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_values"), 
(SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_values"), 
(SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_values"), 
(SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_values"), 
(SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_values"), 
(SELECT id FROM structure_permissible_values WHERE value="5" AND language_alias="5"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_values"), 
(SELECT id FROM structure_permissible_values WHERE value="6" AND language_alias="6"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_values"), 
(SELECT id FROM structure_permissible_values WHERE value="7" AND language_alias="7"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_values"), 
(SELECT id FROM structure_permissible_values WHERE value="8" AND language_alias="8"), "8", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_values"), 
(SELECT id FROM structure_permissible_values WHERE value="9" AND language_alias="9"), "9", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_values"), 
(SELECT id FROM structure_permissible_values WHERE value="10" AND language_alias="10"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_values"), 
(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "11", "1");
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values')  WHERE model='DiagnosisDetail' AND tablename='qc_tf_dxd_cpcbn' AND field='gleason_score' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_score_biopsy');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values')  WHERE model='DiagnosisDetail' AND tablename='qc_tf_dxd_cpcbn' AND field='gleason_score_rp' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_sum_rp');

DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("2a", "2a"),
("2b", "2b"),
("2c", "2c"),
("3a", "3a"),
("3b", "3b"),
("3c", "3c"),
('4','4'),
('4a','4a'),
('4b','4b');
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"), 
(SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"), 
(SELECT id FROM structure_permissible_values WHERE value="2a" AND language_alias="2a"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"), 
(SELECT id FROM structure_permissible_values WHERE value="2b" AND language_alias="2b"), "12", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"), 
(SELECT id FROM structure_permissible_values WHERE value="2c" AND language_alias="2c"), "13", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"), 
(SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "14", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"), 
(SELECT id FROM structure_permissible_values WHERE value="3a" AND language_alias="3a"), "15", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"), 
(SELECT id FROM structure_permissible_values WHERE value="3b" AND language_alias="3b"), "16", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"), 
(SELECT id FROM structure_permissible_values WHERE value="3c" AND language_alias="3c"), "17", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"), 
(SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "18", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"), 
(SELECT id FROM structure_permissible_values WHERE value="4a" AND language_alias="4a"), "19", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ptnm"), 
(SELECT id FROM structure_permissible_values WHERE value="4b" AND language_alias="4b"), "20", "1");
UPDATE structure_value_domains SET source = NULL WHERE domain_name="qc_tf_ptnm";

ALTER TABLE qc_tf_dxd_cpcbn
  CHANGE `gleason_score` `gleason_score_biopsy` varchar(10) NOT NULL DEFAULT '';
ALTER TABLE qc_tf_dxd_cpcbn_revs
  CHANGE `gleason_score` `gleason_score_biopsy` varchar(10) NOT NULL DEFAULT '';
UPDATE structure_fields SET field = 'gleason_score_biopsy', language_label = 'gleason score biopsy' WHERE tablename = 'qc_tf_dxd_cpcbn' AND field = 'gleason_score';
  
REPLACE INTO i18n (id,en,fr) VALUES 
('gleason score biopsy','Gleason Score Biopsy','Score Gleason - biopsie'),
('gleason sum rp','Gleason Sum RP','Somme Gleason - RP'),
('diagnosis method','Diagnosis Method','Méthode diagnostic');

ALTER TABLE participants ADD CONSTRAINT unique_bank_id UNIQUE (qc_tf_bank_id,qc_tf_bank_participant_identifier);

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('prostate cancer spread', 'Spread','Diffusion'),
('presence capsular penetration', 'Presence Capsular Penetration', 'Présence pénétration capsulaire'),
('hormonorefractory status','Hormonorefractory Status',''),
('date of hormonorefractory status diagnosis', 'Status Date', 'Date du statu'),
('this bank participant identifier has already been assigned to a patient of this bank', 'This bank patient # has already been assigned to a patient of this bank.', 'Ce # Patient de banque a déjà été assigné à un patient de la banque.');

UPDATE structure_formats SET `display_column`='2', `language_heading`='prostate cancer spread' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_lymph_node_invasion' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_capsular_penetration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_seminal_vesicle_invasion' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='margin' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_value_domains SET source = NULL  WHERE domain_name="qc_tf_hormonorefractory_status";

ALTER TABLE qc_tf_dxd_cpcbn ADD COLUMN `hormonorefractory_date_hr_accuracy` char(1) NOT NULL DEFAULT '' AFTER hormonorefractory_date_hr;
ALTER TABLE qc_tf_dxd_cpcbn_revs ADD COLUMN `hormonorefractory_date_hr_accuracy` char(1) NOT NULL DEFAULT '' AFTER hormonorefractory_date_hr;

ALTER TABLE qc_tf_dxd_cpcbn DROP COLUMN  number_of_biopsies;
ALTER TABLE qc_tf_dxd_cpcbn_revs DROP COLUMN  number_of_biopsies ;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='number_of_biopsies' AND `language_label`='number of biopsies' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='number_of_biopsies' AND `language_label`='number of biopsies' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='number_of_biopsies' AND `language_label`='number of biopsies' AND `language_tag`='' AND `type`='integer_positive' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

CREATE TABLE IF NOT EXISTS `qc_tf_dxd_others` (
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  `type` varchar(250) NOT NULL DEFAULT '',
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `qc_tf_dxd_others`
  ADD CONSTRAINT `FK_qc_tf_dxd_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

CREATE TABLE IF NOT EXISTS `qc_tf_dxd_others_revs` (
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  `type` varchar(250) NOT NULL DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'other', 1, 'dx_primary,qc_tf_dxd_others', 'qc_tf_dxd_others', 0, 'primary|other', 1);

INSERT INTO structures(`alias`) VALUES ('qc_tf_dxd_others');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_tf_dxd_others', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_others'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_others' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE diagnosis_controls SET flag_active = 0  WHERE id = 2;

UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site") AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value="other - primary unknown");

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_others'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '4', '', '1', 'age at diagnosis', '0', '', '1', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `display_column`='1',`display_order`='20', `language_heading`=''  WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_unknown_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DROP TABLE qc_tf_ed_biopsy;
DROP TABLE qc_tf_ed_biopsy_revs;

UPDATE event_controls SET flag_active = 0 WHERE event_type != 'psa';
UPDATE menus SET flag_active = 0 WHERE id = 'clin_CAN_31';
SET @link = (SELECT use_link FROM menus WHERE id = 'clin_CAN_28');
UPDATE menus SET use_link = @link WHERE id = 'clin_CAN_4';

UPDATE event_controls SET detail_tablename = 'qc_tf_ed_psa', detail_form_alias = 'qc_tf_ed_psa' WHERE event_type = 'psa';

UPDATE treatment_controls SET flag_active = 0 WHERE tx_method NOT IN ('hormonotherapy','chemotherapy');
UPDATE treatment_controls SET detail_form_alias = 'qc_tf_ed_hormonotherapy' WHERE detail_tablename = 'qc_tf_txd_hormonotherapies';

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'surgery', 'RP', 1, 'qc_tf_txd_surgeries', 'qc_tf_txd_surgeries', NULL, NULL, 0, 2, NULL, 'RP|surgery', 1),
(null, 'surgery', 'TURP', 1, 'qc_tf_txd_surgeries', 'qc_tf_txd_surgeries', NULL, NULL, 0, 2, NULL, 'TURP|surgery', 1),
(null, 'biopsy', 'general', 1, 'qc_tf_txd_biopsies', 'qc_tf_txd_biopsies', '', '', 0, 2, NULL, 'general|biopsy', 1);

ALTER TABLE txd_surgeries DROP COLUMN qc_tf_type;
ALTER TABLE txd_surgeries_revs DROP COLUMN qc_tf_type;
DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'qc_tf_type' AND tablename = 'txd_surgeries');
DELETE FROM structure_fields WHERE field = 'qc_tf_type' AND tablename = 'txd_surgeries';

ALTER TABLE treatment_masters
  ADD COLUMN qc_tf_disease_free_survival_start_events tinyint(1) unsigned NOT NULL DEFAULT '0';
ALTER TABLE treatment_masters_revs
  ADD COLUMN qc_tf_disease_free_survival_start_events tinyint(1) unsigned NOT NULL DEFAULT '0'; 

ALTER TABLE qc_tf_dxd_cpcbn DROP COLUMN deleted;
ALTER TABLE qc_tf_dxd_metastasis DROP COLUMN deleted;
ALTER TABLE qc_tf_dxd_recurrence_bio DROP COLUMN deleted;
ALTER TABLE qc_tf_ed_psa DROP COLUMN deleted;
ALTER TABLE qc_tf_ed_psa_revs DROP COLUMN deleted;
ALTER TABLE qc_tf_txd_hormonotherapies DROP COLUMN deleted;
ALTER TABLE qc_tf_txd_hormonotherapies_revs DROP COLUMN deleted;

ALTER TABLE `qc_tf_ed_cpcbn`
  DROP `created`,
  DROP `created_by`,
  DROP `modified`,
  DROP `modified_by`,
  DROP `deleted`,
  DROP `deleted_date`;
ALTER TABLE `qc_tf_ed_cpcbn_revs`
  DROP `created`,
  DROP `created_by`,
  DROP `modified`,
  DROP `modified_by`,
  DROP `deleted`,
  DROP `deleted_date`,
  DROP `version_id`,
  DROP `version_created`;

UPDATE treatment_controls SET detail_tablename = 'txd_surgeries' WHERE detail_tablename = 'qc_tf_txd_surgeries';

UPDATE menus SET use_link = @link WHERE id = 'clin_CAN_4';
UPDATE menus SET language_title = 'treatment & biopsy' WHERE id = 'clin_CAN_75';

INSERT INTO structures(`alias`) VALUES ('qc_tf_txd_surgeries');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'qc_tf_disease_free_survival_start_events', 'checkbox',  NULL , '0', '', '', '', 'disease free survival start event', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_tf_disease_free_survival_start_events' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='disease free survival start event' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ed_hormonotherapy'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_tf_disease_free_survival_start_events' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='disease free survival start event' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structures(`alias`) VALUES ('qc_tf_txd_biopsies');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_tf_disease_free_survival_start_events' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='disease free survival start event' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

CREATE TABLE IF NOT EXISTS `qc_tf_txd_biopsies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `samples_number` int(4),
  `treatment_master_id` int(11) NOT NULL,
  `created` date NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` date NOT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `treatment_master_id` (`treatment_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `qc_tf_txd_biopsies_revs` (
  `id` int(10) unsigned NOT NULL,
  `samples_number` int(4),
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `version_created` date NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

ALTER TABLE `qc_tf_txd_biopsies`
  ADD CONSTRAINT `qc_tf_txd_biopsies_ibfk_2` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies', 'samples_number', 'integer_positive',  NULL , '0', 'size=3', '', '', 'samples number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='samples_number' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='samples number' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'radiation', 'general', 1, 'txd_radiations', 'qc_tf_txd_radiations', '', '', 0, 2, NULL, 'general|radiation', 1);

INSERT INTO structures(`alias`) VALUES ('qc_tf_txd_radiations');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_tf_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_tf_disease_free_survival_start_events' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='disease free survival start event' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE treatment_controls SET flag_active = 0 WHERE tx_method = 'chemotherapy';
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'chemotherapy', 'general', 1, 'txd_chemos', 'qc_tf_txd_chemos', 'txe_chemos', 'txe_chemos', 0, 1, 'importDrugFromChemoProtocol', 'all|chemotherapy', 0);

INSERT INTO structures(`alias`) VALUES ('qc_tf_txd_chemos');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_tf_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_tf_disease_free_survival_start_events' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='disease free survival start event' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type'), '1', '-3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_group' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_group_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_group' AND `language_tag`=''), '1', '-5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE event_controls SET flag_use_for_ccl = 0 WHERE detail_form_alias = 'qc_tf_ed_psa';

ALTER TABLE qc_tf_ed_psa
  ADD COLUMN first_biochemical_recurrence tinyint(1) unsigned NOT NULL DEFAULT '0';
ALTER TABLE qc_tf_ed_psa_revs
  ADD COLUMN first_biochemical_recurrence tinyint(1) unsigned NOT NULL DEFAULT '0'; 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_tf_ed_psa', 'first_biochemical_recurrence', 'checkbox',  NULL , '0', '', '', '', 'first biochemical recurrence', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ed_psa'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_psa' AND `field`='first_biochemical_recurrence' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='first biochemical recurrence' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

REPLACE INTO i18n (id,en,fr) VALUES ('first biochemical recurrence','First BCR','1ère RBC');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
("a treatment or biopsy has already been defined as the 'disease free survival start event' for this cancer",
'A treatment or biopsy has already been defined as the DFS beginning for this cancer.',
"Un traitement ou une biopsie a déjà été défini comme le début de l'ILB pour ce cancer."),
( 'samples number', 'Samples Number', 'Nombre d''échantillons'),
('disease free survival start event', 'DFS Start', 'Début ILB'),
('RP','RP','RP'),
('RP','RP','RP'),
('TURP','TURP','TURP'),
('hormonotherapy','Hormonotherapy','Hormonothérapie'),
('hormonotherapy','Hormonotherapy','Hormonothérapie'),
('treatment & biopsy', 'Treatment & Biopsy', 'Traitement & Biopsie'),
("a psa event has already been defined as first bcr for this cancer", "A psa event has already been defined as first biochemical relapse for this cancer.","Une mesure de PSA a déjà été défini comme première rechute biochimique pour ce cancer.");

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages/%';

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_tf_disease_free_survival_start_events' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), 
(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_tf_disease_free_survival_start_events' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='disease free survival start event' AND `language_tag`=''), 
'1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

ALTER TABLE participants DROP COLUMN qc_tf_follow_up_months;
ALTER TABLE participants_revs DROP COLUMN qc_tf_follow_up_months;

DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'qc_tf_follow_up_months');
DELETE FROM structure_fields WHERE field = 'qc_tf_follow_up_months';


