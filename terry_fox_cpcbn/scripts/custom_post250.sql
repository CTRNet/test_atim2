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

UPDATE diagnosis_controls SET flag_active = 0  WHERE id = 2;

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
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site'), '1', '-4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type'), '1', '-3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_group' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_group_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_group' AND `language_tag`=''), '1', '-5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE event_controls SET flag_use_for_ccl = 0 WHERE detail_form_alias = 'qc_tf_ed_psa';


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
('treatment & biopsy', 'Treatment & Biopsy', 'Traitement & Biopsie');

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

UPDATE diagnosis_controls SET flag_active = 0 WHERE category IN ('recurrence','remission','progression','secondary') AND controls_type = 'undetailed';
UPDATE diagnosis_controls SET controls_type = 'biochemical recurrence' WHERE controls_type = 'biochemical' AND category = 'recurrence';
UPDATE diagnosis_controls SET flag_active = 0 WHERE category IN ('secondary') AND controls_type = 'undetailed';

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('biochemical recurrence','BCR','RBC'),
('a bcr has already been defined as first bcr for this cancer', 'A bcr has already been defined as first bcr for this cancer.', 'Une RBC a déjà été définie comme première RBC pour ce cancer.'),
('first biochemical recurrence','1st BCR','1ere RBC');

UPDATE diagnosis_controls SET controls_type = 'undetailed' WHERE controls_type = 'metastasis' AND category = 'secondary';

UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_metastasis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_metastasis' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_metastasis_type') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_biochemical') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_recurrence_bio' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_date_biochemical_recurrence_definition') AND `flag_confidential`='0');

ALTER TABLE qc_tf_dxd_recurrence_bio
  ADD COLUMN first_biochemical_recurrence tinyint(1) unsigned NOT NULL DEFAULT '0';
ALTER TABLE qc_tf_dxd_recurrence_bio_revs
  ADD COLUMN first_biochemical_recurrence tinyint(1) unsigned NOT NULL DEFAULT '0'; 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_tf_dxd_recurrence_bio', 'first_biochemical_recurrence', 'checkbox',  NULL , '0', '', '', '', 'first biochemical recurrence', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_biochemical'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_recurrence_bio' AND `field`='first_biochemical_recurrence' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='first biochemical recurrence' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

UPDATE `i18n` SET `en` = 'First PSA of at least 0.3 followed by another increase' WHERE `id` = 'qc_tf_first_psa_3';

ALTER TABLE qc_tf_dxd_cpcbn
	ADD COLUMN survival_in_months int(5),
	ADD COLUMN bcr_in_months int(5);	
ALTER TABLE qc_tf_dxd_cpcbn_revs
	ADD COLUMN survival_in_months int(5),
	ADD COLUMN bcr_in_months int(5);

UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='hormonorefractory_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_hormonorefractory_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='hormonorefractory_date_hr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'survival_in_months', 'integer',  NULL , '0', '', '', '', 'survival in months', ''),
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'bcr_in_months', 'integer',  NULL , '0', '', '', '', 'bcr in months', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='survival_in_months'), '2', '13', 'survival and bcr', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='bcr_in_months'), '2', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('survival and bcr','Survival & BCR', 'Survie & RBC'),
('survival in months','Survival (months)', 'Survie (mois)'),
('bcr in months','BCR (months)', 'RBC (mois)'),
('survival cannot be calculated on inaccurate dates','Survival cannot be calculated on inaccurate dates.',"La survie ne peut pas être calculée sur des dates inexactes"),
('survival cannot be calculated because dates are not chronological','Survival cannot be calculated because dates are not chronological.','La survie ne peut pas être calculée sur des dates non chronologiques.');

REPLACE INTO i18n (id,en,fr) VALUES ('biochemical recurrence','BCR','RBC');

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

UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site") AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value="other - primary unknown");

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_others'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '4', '', '1', 'age at diagnosis', '0', '', '1', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

ALTER TABLE txd_radiations CHANGE qc_tf_dose qc_tf_dose_cg int(6);
ALTER TABLE txd_radiations_revs CHANGE qc_tf_dose c_tf_dose_cg int(6);
  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txd_radiations', 'qc_tf_dose_cg', 'input',  NULL , '0', 'size=6', '', '', 'dose cg', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_radiations' AND `field`='qc_tf_dose_cg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='dose cg' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_tf_disease_free_survival_start_events' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET type = 'integer_positive' WHERE field = 'qc_tf_dose_cg';

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_tf_disease_free_survival_start_events' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES ('dose cg', 'Dose (cg)','Dose (cg)'); 

ALTER TABLE qc_tf_dxd_cpcbn DROP COLUMN hormonorefractory_date_hr;
ALTER TABLE qc_tf_dxd_cpcbn DROP COLUMN hormonorefractory_date_hr_accuracy;
ALTER TABLE qc_tf_dxd_cpcbn_revs DROP COLUMN hormonorefractory_date_hr;
ALTER TABLE qc_tf_dxd_cpcbn_revs DROP COLUMN hormonorefractory_date_hr_accuracy;

DELETE FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'hormonorefractory_date_hr');
DELETE FROM structure_fields WHERE field = 'hormonorefractory_date_hr';

UPDATE structure_formats SET `display_order`='-3' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-4' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');

REPLACE i18n (id,en,fr) VALUES ('participant identifier','ATiM Participant #','# Participant ATiM');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '99', '', '0', '', '0', '', '1', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_ed_psa'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '100', '', '1', 'notes', '0', '', '0', '', '0', '', '1', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

UPDATE structure_value_domains_permissible_values SET flag_active = 0 
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site") 
AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value LIKE "male genital%");

INSERT INTO structure_permissible_values (value, language_alias) VALUES("male genital", "male genital");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"), (SELECT id FROM structure_permissible_values WHERE value="male genital" AND language_alias="male genital"), "", "1");

INSERT INTO i18n (id,en,fr) VALUES ('male genital','Male Genital','Appareil génital masculin');

UPDATE structure_value_domains_permissible_values SET flag_active = 0 
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site") 
AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value LIKE "Female Genital%");

UPDATE structure_value_domains_permissible_values SET flag_active = 0 
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site") 
AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value IN ("Other - Gross Metastatic Disease",'Digestive - Colorectal'));

INSERT INTO structure_permissible_values (value, language_alias) VALUES("digestive - colonic", "digestive - colonic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive - colonic" AND language_alias="digestive - colonic"), "", "1");
INSERT INTO i18n (id,en,fr) VALUES ('digestive - colonic','Digestive - Colonic','Digestif - Colonic');

INSERT INTO structure_permissible_values (value, language_alias) VALUES("digestive - rectal", "digestive - rectal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="ctrnet_submission_disease_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive - rectal" AND language_alias="digestive - rectal"), "", "1");
INSERT INTO i18n (id,en,fr) VALUES ('digestive - rectal','Digestive - Rectal','Digestif - Rectal');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 1, 12, 19, 131, 133, 135, 134, 23, 136, 20, 21, 13, 14, 2, 138, 25, 3, 119, 15, 16, 24, 4, 132, 17, 18, 5, 118, 6, 142, 105, 112, 113, 114, 106, 143, 120, 124, 125, 126, 121, 141, 103, 109, 110, 111, 104, 144, 122, 127, 128, 129, 123, 7, 130, 8, 9, 101, 102, 140, 11, 10);

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','FamilyHistory','ParticipantMessage','QualityCtrl','ParticipantContact','ReproductiveHistory'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id2 IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier','ConsentMaster','FamilyHistory','ParticipantMessage','QualityCtrl','ParticipantContact','ReproductiveHistory'));

UPDATE datamart_structure_functions SET flag_active = 0 WHERe label IN ('create derivative', 'create quality control', 'print barcodes');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');

UPDATE structure_formats SET flag_add = 0, flag_add_readonly = 0, flag_edit = 0, flag_edit_readonly = 0, flag_search = 0, flag_search_readonly = 0, flag_add = 0, flag_add_readonly = 0, flag_edit = 0, flag_edit_readonly = 0, flag_search = 0, flag_search_readonly = 0, flag_addgrid = 0, flag_addgrid_readonly = 0, flag_editgrid = 0, flag_editgrid_readonly = 0, flag_batchedit = 0, flag_batchedit_readonly = 0, flag_index = 0, flag_detail = 0, flag_summary = 0, flag_addgrid = 0, flag_addgrid_readonly = 0, flag_editgrid = 0, flag_editgrid_readonly = 0, flag_batchedit = 0, flag_batchedit_readonly = 0, flag_index = 0, flag_detail = 0, flag_summary = 0
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='acquisition_label');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');

UPDATE structure_formats SET flag_add = 0, flag_add_readonly = 0, flag_edit = 0, flag_edit_readonly = 0, flag_search = 0, flag_search_readonly = 0, flag_add = 0, flag_add_readonly = 0, flag_edit = 0, flag_edit_readonly = 0, flag_search = 0, flag_search_readonly = 0, flag_addgrid = 0, flag_addgrid_readonly = 0, flag_editgrid = 0, flag_editgrid_readonly = 0, flag_batchedit = 0, flag_batchedit_readonly = 0, flag_index = 0, flag_detail = 0, flag_summary = 0, flag_addgrid = 0, flag_addgrid_readonly = 0, flag_editgrid = 0, flag_editgrid_readonly = 0, flag_batchedit = 0, flag_batchedit_readonly = 0, flag_index = 0, flag_detail = 0, flag_summary = 0
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='bank_id' AND model = 'Collection');

UPDATE structure_formats SET `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');

UPDATE structure_formats SET flag_add = 0, flag_add_readonly = 0, flag_edit = 0, flag_edit_readonly = 0, flag_search = 0, flag_search_readonly = 0, flag_add = 0, flag_add_readonly = 0, flag_edit = 0, flag_edit_readonly = 0, flag_search = 0, flag_search_readonly = 0, flag_addgrid = 0, flag_addgrid_readonly = 0, flag_editgrid = 0, flag_editgrid_readonly = 0, flag_batchedit = 0, flag_batchedit_readonly = 0, flag_index = 0, flag_detail = 0, flag_summary = 0, flag_addgrid = 0, flag_addgrid_readonly = 0, flag_editgrid = 0, flag_editgrid_readonly = 0, flag_batchedit = 0, flag_batchedit_readonly = 0, flag_index = 0, flag_detail = 0, flag_summary = 0
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='sop_master_id');
 
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'qc_tf_tissue_nature', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''tissue natures'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('tissue natures', '1', '50');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('benin','Benin','Bénin', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tissue natures'), 1),
('tumoral','Tumoral','Tumoral', 2, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tissue natures'), 1),
('unknown','Unknown','Inconnu', 7, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'tissue natures'), 1);
 
ALTER TABLE sd_spe_tissues
 ADD COLUMN qc_tf_collected_specimen_nature VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_tf_collected_specimen_type;
ALTER TABLE sd_spe_tissues_revs
 ADD COLUMN qc_tf_collected_specimen_nature VARCHAR(50) NOT NULL DEFAULT '' AFTER qc_tf_collected_specimen_type;
 
 INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SampleDetail', 'sd_spe_tissues', 'qc_tf_collected_specimen_nature', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tissue_nature') , '0', '', '', '', 'collected specimen nature', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='qc_tf_collected_specimen_nature' ), '1', '451', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');
 
INSERT INTO i18n (id,en,fr) VALUES 
('collected specimen nature','Nature', 'Nature'),
('collection type', 'Collection Type', 'Type de collection');

UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN(140, 11, 10);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(10, 1);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(11);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_permissible_values_customs_revs (id, `value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`)
(SELECT id, `value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input` FROM structure_permissible_values_customs);

UPDATE structure_value_domains SET domain_name = 'qc_tf_collection_type' WHERE domain_name = 'qc_tf_sample_collected_type';

ALTER TABLE sd_spe_tissues
 DROP COLUMN qc_tf_collected_specimen_type ;
ALTER TABLE sd_spe_tissues_revs
 DROP COLUMN qc_tf_collected_specimen_type ;

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'qc_tf_collected_specimen_type');
DELETE FROM structure_fields WHERE field = 'qc_tf_collected_specimen_type';

ALTER TABLE collections
 ADD COLUMN qc_tf_collection_type VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE collections_revs
 ADD COLUMN qc_tf_collection_type VARCHAR(50) NOT NULL DEFAULT '';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'qc_tf_collection_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_collection_type') , '0', '', '', '', 'collection type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_tf_collection_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_collection_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection type' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='qc_tf_collection_type' 
AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_collection_type')  AND `flag_confidential`='0'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='qc_tf_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_collection_type') AND `flag_confidential`='0');








-- -----------------------------------------------------------
-- VIEW
-- -----------------------------------------------------------

-- view_collections_view --

DROP VIEW IF EXISTS view_collections_view;
DROP VIEW IF EXISTS view_collections;
DROP TABLE IF EXISTS view_collections;

CREATE VIEW `view_collections_view` AS select 
`col`.`id` AS `collection_id`,
`col`.`sop_master_id` AS `sop_master_id`,
`col`.`participant_id` AS `participant_id`,
`col`.`diagnosis_master_id` AS `diagnosis_master_id`,
`col`.`consent_master_id` AS `consent_master_id`,
`col`.`treatment_master_id` AS `treatment_master_id`,
`col`.`event_master_id` AS `event_master_id`,

`part`.`participant_identifier` AS `participant_identifier`,
`part`.`qc_tf_bank_participant_identifier` AS `qc_tf_bank_participant_identifier`,
`part`.`qc_tf_bank_id` AS `bank_id`, 

`banks`.`name` AS `bank_name`,

`col`.`acquisition_label` AS `acquisition_label`,
`col`.`collection_site` AS `collection_site`,
`col`.`qc_tf_collection_type`, 
`col`.`collection_datetime` AS `collection_datetime`,
`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
`col`.`collection_property` AS `collection_property`,
`col`.`collection_notes` AS `collection_notes`,
`col`.`created` AS `created` 

from `collections` `col` 
left join `participants` `part` on `col`.`participant_id` = `part`.`id` and `part`.`deleted` <> 1 
left join `banks` on `part`.`qc_tf_bank_id` = `banks`.`id` and `banks`.`deleted` <> 1 where `col`.`deleted` <> 1;

CREATE TABLE view_collections (SELECT * FROM view_collections_view);

ALTER TABLE view_collections
 ADD PRIMARY KEY(collection_id),
 ADD KEY(bank_id),
 ADD KEY(qc_tf_collection_type),
 ADD KEY(sop_master_id),
 ADD KEY(participant_id),
 ADD KEY(diagnosis_master_id),
 ADD KEY(consent_master_id),
 ADD KEY(treatment_master_id),
 ADD KEY(event_master_id),
 ADD KEY(participant_identifier),
 ADD KEY(qc_tf_bank_participant_identifier),
 ADD KEY(acquisition_label),
 ADD KEY(collection_site),
 ADD KEY(collection_datetime),
 ADD KEY(collection_property),
 ADD KEY(created);

-- view_samples --

DROP VIEW IF EXISTS view_samples_view;
DROP VIEW IF EXISTS view_samples;
DROP TABLE IF EXISTS view_samples;

CREATE VIEW view_samples_view AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

part.qc_tf_bank_id AS bank_id, 
col.sop_master_id, 
col.participant_id, 
col.qc_tf_collection_type,

part.participant_identifier,
part.qc_tf_bank_participant_identifier, 

col.acquisition_label, 

specimenc.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_sampc.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
sampc.sample_type,
samp.sample_control_id,
samp.sample_code,
sampc.sample_category,

IF(specimen_details.reception_datetime IS NULL, NULL,
 IF(col.collection_datetime IS NULL, -1,
 IF(col.collection_datetime_accuracy != 'c' OR specimen_details.reception_datetime_accuracy != 'c', -2,
 IF(col.collection_datetime > specimen_details.reception_datetime, -3,
 TIMESTAMPDIFF(MINUTE, col.collection_datetime, specimen_details.reception_datetime))))) AS coll_to_rec_spent_time_msg,
 
IF(derivative_details.creation_datetime IS NULL, NULL,
 IF(col.collection_datetime IS NULL, -1,
 IF(col.collection_datetime_accuracy != 'c' OR derivative_details.creation_datetime_accuracy != 'c', -2,
 IF(col.collection_datetime > derivative_details.creation_datetime, -3,
 TIMESTAMPDIFF(MINUTE, col.collection_datetime, derivative_details.creation_datetime))))) AS coll_to_creation_spent_time_msg 

FROM sample_masters as samp
INNER JOIN sample_controls as sampc ON samp.sample_control_id=sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN specimen_details ON specimen_details.sample_master_id=samp.id
LEFT JOIN derivative_details ON derivative_details.sample_master_id=samp.id
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id = parent_sampc.id
LEFT JOIN participants AS part ON col.participant_id = part.id AND part.deleted != 1
WHERE samp.deleted != 1;

CREATE TABLE view_samples (SELECT * FROM view_samples_view);

ALTER TABLE view_samples
 ADD PRIMARY KEY(sample_master_id),
 ADD KEY(parent_sample_id),
 ADD KEY(initial_specimen_sample_id),
 ADD KEY(collection_id),
 ADD KEY(bank_id),
 ADD KEY(qc_tf_collection_type),
 ADD KEY(sop_master_id),
 ADD KEY(participant_id),
 ADD KEY(participant_identifier),
 ADD KEY(qc_tf_bank_participant_identifier),
 ADD KEY(acquisition_label),
 ADD KEY(initial_specimen_sample_type),
 ADD KEY(initial_specimen_sample_control_id),
 ADD KEY(parent_sample_type),
 ADD KEY(parent_sample_control_id),
 ADD KEY(sample_type),
 ADD KEY(sample_control_id),
 ADD KEY(sample_code),
 ADD KEY(sample_category),
 ADD KEY(coll_to_creation_spent_time_msg),
 ADD KEY(coll_to_rec_spent_time_msg);
 
-- view_aliquots --

DROP VIEW IF EXISTS view_aliquots_view;
DROP VIEW IF EXISTS view_aliquots;
DROP TABLE IF EXISTS view_aliquots;

CREATE VIEW view_aliquots_view AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
part.qc_tf_bank_id AS bank_id, 
al.storage_master_id AS storage_master_id,
col.participant_id, 
col.qc_tf_collection_type,

part.participant_identifier, 
part.qc_tf_bank_participant_identifier,

col.acquisition_label, 

specimenc.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_sampc.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
sampc.sample_type,
samp.sample_control_id,

al.barcode,
al.aliquot_label,
alc.aliquot_type,
al.aliquot_control_id,
al.in_stock,

stor.code,
stor.selection_label,
al.storage_coord_x,
al.storage_coord_y,

stor.temperature,
stor.temp_unit,

al.created,

IF(al.storage_datetime IS NULL, NULL,
 IF(col.collection_datetime IS NULL, -1,
 IF(col.collection_datetime_accuracy != 'c' OR al.storage_datetime_accuracy != 'c', -2,
 IF(col.collection_datetime > al.storage_datetime, -3,
 TIMESTAMPDIFF(MINUTE, col.collection_datetime, al.storage_datetime))))) AS coll_to_stor_spent_time_msg,
IF(al.storage_datetime IS NULL, NULL,
 IF(specimen_details.reception_datetime IS NULL, -1,
 IF(specimen_details.reception_datetime_accuracy != 'c' OR al.storage_datetime_accuracy != 'c', -2,
 IF(specimen_details.reception_datetime > al.storage_datetime, -3,
 TIMESTAMPDIFF(MINUTE, specimen_details.reception_datetime, al.storage_datetime))))) AS rec_to_stor_spent_time_msg,
IF(al.storage_datetime IS NULL, NULL,
 IF(derivative_details.creation_datetime IS NULL, -1,
 IF(derivative_details.creation_datetime_accuracy != 'c' OR al.storage_datetime_accuracy != 'c', -2,
 IF(derivative_details.creation_datetime > al.storage_datetime, -3,
 TIMESTAMPDIFF(MINUTE, derivative_details.creation_datetime, al.storage_datetime))))) AS creat_to_stor_spent_time_msg,
 
IF(LENGTH(al.notes) > 0, "y", "n") AS has_notes


FROM aliquot_masters AS al
INNER JOIN aliquot_controls AS alc ON al.aliquot_control_id = alc.id
INNER JOIN sample_masters AS samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN sample_controls AS sampc ON samp.sample_control_id = sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id=parent_sampc.id
LEFT JOIN participants AS part ON col.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
LEFT JOIN specimen_details ON al.sample_master_id=specimen_details.sample_master_id
LEFT JOIN derivative_details ON al.sample_master_id=derivative_details.sample_master_id
WHERE al.deleted != 1;

CREATE TABLE view_aliquots (SELECT * FROM view_aliquots_view);

ALTER TABLE view_aliquots
 ADD PRIMARY KEY(aliquot_master_id),
 ADD KEY(sample_master_id),
 ADD KEY(collection_id),
 ADD KEY(bank_id),
 ADD KEY(qc_tf_collection_type),
 ADD KEY(storage_master_id),
 ADD KEY(participant_id),
 ADD KEY(participant_identifier),
 ADD KEY(qc_tf_bank_participant_identifier),
 ADD KEY(acquisition_label),
 ADD KEY(initial_specimen_sample_type),
 ADD KEY(initial_specimen_sample_control_id),
 ADD KEY(parent_sample_type),
 ADD KEY(parent_sample_control_id),
 ADD KEY(barcode),
 ADD KEY(aliquot_label),
 ADD KEY(aliquot_type),
 ADD KEY(aliquot_control_id),
 ADD KEY(in_stock),
 ADD KEY(code),
 ADD KEY(selection_label),
 ADD KEY(temperature),
 ADD KEY(temp_unit),
 ADD KEY(created),
 ADD KEY(has_notes);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qc_tf_bank_participant_identifier', 'input',  NULL , '0', 'size=30', '', '', 'bank patient #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='qc_tf_bank_participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='bank patient #' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'qc_tf_bank_participant_identifier', 'input',  NULL , '0', 'size=20', '', '', 'bank patient #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qc_tf_bank_participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='bank patient #' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'qc_tf_bank_participant_identifier', 'input',  NULL , '0', 'size=20', '', '', 'bank patient #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection '), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qc_tf_bank_participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='bank patient #' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'qc_tf_collection_type', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_collection_type') , '0', '', '', '', 'collection type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `field`='qc_tf_collection_type'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'qc_tf_collection_type', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_collection_type') , '0', '', '', '', 'collection type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `field`='qc_tf_collection_type'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'qc_tf_collection_type', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_collection_type') , '0', '', '', '', 'collection type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection '), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `field`='qc_tf_collection_type'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');






