UPDATE users SET flag_Active = 1;
UPDATE groups SET flag_show_confidential = 1;

-- -------------------------------------------------------------------------------- 
-- OVCARE project
-- Custom script to run after v241 upgrade script
-- -------------------------------------------------------------------------------- 

INSERT INTO i18n (id,en) VALUES ('core_installname', 'OvCaRe');


-- -------------------------------------------------------------------------------- 
-- CLINICAL ANNOTATION
-- --------------------------------------------------------------------------------

-- **** PROFILE ****

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_id = (SELECT id FROM structures WHERE alias = 'participants')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('cod_icd10_code', 'cod_confirmation_source', 'middle_name', 'marital_status', 'language_preferred', 'title', 'race', 'secondary_cod_icd10_code'));

UPDATE structure_formats SET `flag_edit_readonly`='1', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en,fr) VALUES ('participant identifier', 'VOA#', 'VOA#');
ALTER TABLE participants
  MODIFY `participant_identifier` int(11) DEFAULT NULL;
ALTER TABLE participants_revs
  MODIFY `participant_identifier` int(11) DEFAULT NULL;  
UPDATE structure_fields SET  `type`='integer_positive',  `setting`='size=20' WHERE model='Participant' AND tablename='participants' AND field='participant_identifier';  
UPDATE structure_fields SET  `type`='integer_positive', setting = 'size=20' WHERE model LIKE 'View%' AND field='participant_identifier';
REPLACE INTO i18n (id,en,fr) VALUEs ('error_participant identifier must be unique','Error - VOA# must be unique!','Erreur - Le VOA# du participant doit être unique!');

ALTER TABLE participants ADD COLUMN ovcare_last_followup_date date DEFAULT NULL AFTER vital_status;
ALTER TABLE participants_revs ADD COLUMN ovcare_last_followup_date date DEFAULT NULL AFTER vital_status;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'Participant', 'participants', 'ovcare_last_followup_date', 'date',  NULL , '0', '', '', '', 'ovcare last followup date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='ovcare_last_followup_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ovcare last followup date' AND `language_tag`=''), '3', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '1', '0');
INSERT INTO i18n (id,en) VALUES ('ovcare last followup date', 'Last Follow-Up Date');

INSERT INTO `structure_value_domains` (`domain_name`) VALUES ('ovcare_vital_status');
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("alive/well", "alive/well"),
("alive/disease", "alive/disease"),
("dead/disease", "dead/disease"),
("dead/other", "dead/other"),
("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_vital_status"),  
(SELECT id FROM structure_permissible_values WHERE value="alive/well" AND language_alias="alive/well"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_vital_status"),  
(SELECT id FROM structure_permissible_values WHERE value="alive/disease" AND language_alias="alive/disease"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_vital_status"),  
(SELECT id FROM structure_permissible_values WHERE value="dead/disease" AND language_alias="dead/disease"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_vital_status"),  
(SELECT id FROM structure_permissible_values WHERE value="dead/other" AND language_alias="dead/other"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_vital_status"),  
(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "5", "1");
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_vital_status') WHERE model='Participant' AND tablename='participants' AND field='vital_status';
INSERT INTO i18n (id,en) VALUES
("alive/well", "Alive/Well"),
("alive/disease", "Alive/Disease"),
("dead/disease", "Dead/Disease"),
("dead/other", "Dead/Other");

ALTER TABLE participants ADD COLUMN ovcare_last_followup_date_accuracy char(1) NOT NULL DEFAULT '' AFTER ovcare_last_followup_date;
ALTER TABLE participants_revs ADD COLUMN ovcare_last_followup_date_accuracy char(1) NOT NULL DEFAULT '' AFTER ovcare_last_followup_date;


-- **** CONSENT ****

INSERT INTO `consent_controls` (`controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES ('ovcare', 1, 'consent_masters', 'cd_nationals', 0, 'ovcare');
INSERT INTO i18n (id,en) VALUES ('ovcare','OvCaRe');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE consent_controls SET flag_active = 0 WHERE controls_type != 'ovcare';


-- **** MISC IDENTIFIERS ****

UPDATE misc_identifier_controls SET flag_active = 0;
INSERT INTO `misc_identifier_controls` (`misc_identifier_name` ,`flag_active` , `flag_once_per_participant` , `flag_confidential`)
VALUES 
('medical record number', '1', '1', '1'),
('personal health number', '1', '1', '1');
INSERT INTO i18n (id,en) VALUES
('medical record number', 'Medical Record #'),
('personal health number', 'Personal Health #');
UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_id = (SELECT id FROM structures WHERE alias = 'miscidentifiers')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('effective_date', 'expiry_date', 'notes'));


-- **** Diagnosis ****

UPDATE diagnosis_controls SET flag_active = 0 WHERE category = 'primary' and controls_type IN ('blood','tissue');
UPDATE diagnosis_controls SET flag_compare_with_cap = 0;

INSERT INTO `diagnosis_controls` (`category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
('primary', 'ovcare', 1, 'diagnosismasters,dx_primary,ovcare_dx_primaries', 'ovcare_dxd_primaries', 0, 'primary|ovcare', 0);

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_id = (SELECT id FROM structures WHERE alias = 'dx_primary')
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('topography', 'dx_method', 'information_source', 'icd10_code'));

UPDATE structure_formats SET `flag_override_label` = 1, `language_label` = 'who code', `language_heading` = 'coding'
WHERE structure_id = (SELECT id FROM structures WHERE alias = 'dx_primary')
AND structure_field_id = (SELECT id FROM structure_fields WHERE model = 'DiagnosisMaster' AND field = 'morphology');

CREATE TABLE IF NOT EXISTS `ovcare_dxd_primaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',

	clinical_history text,
	clinical_diagnosis text,
	
	`initial_surgery_date` date DEFAULT NULL,
	`initial_surgery_date_accuracy` char(1) NOT NULL DEFAULT '',
	`initial_recurrence_date` date DEFAULT NULL,
	`initial_recurrence_date_accuracy` char(1) NOT NULL DEFAULT '',
	`progression_free_time_months` int(7) DEFAULT NULL,

	stage varchar(10) DEFAULT NULL,
	substage varchar(10) DEFAULT NULL,
	
	review_diagnosis text,
	review_grade varchar(10) DEFAULT NULL,
	review_comment text, 

  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ovcare_dxd_primaries_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',

	clinical_history text,
	clinical_diagnosis text,
	
	`initial_surgery_date` date DEFAULT NULL,
	`initial_surgery_date_accuracy` char(1) NOT NULL DEFAULT '',
	`initial_recurrence_date` date DEFAULT NULL,
	`initial_recurrence_date_accuracy` char(1) NOT NULL DEFAULT '',
	`progression_free_time_months` int(7) DEFAULT NULL,

	stage varchar(10) DEFAULT NULL,
	substage varchar(10) DEFAULT NULL,
	
	review_diagnosis text,
	review_grade varchar(10) DEFAULT NULL,
	review_comment text, 

  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ovcare_dxd_primaries`
  ADD CONSTRAINT `ovcare_dxd_primaries_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

INSERT INTO `structure_value_domains` (`domain_name`) VALUES ('ovcare_stage'), ('ovcare_review_grade'),('ovcare_substage');
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_stage"),  
(SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_review_grade"),  
(SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_review_grade"),  
(SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_review_grade"),  
(SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("A", "A"),("B", "B"),("C", "C");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_substage"),  
(SELECT id FROM structure_permissible_values WHERE value="A" AND language_alias="A"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_substage"),  
(SELECT id FROM structure_permissible_values WHERE value="B" AND language_alias="B"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_substage"),  
(SELECT id FROM structure_permissible_values WHERE value="C" AND language_alias="C"), "3", "1");

INSERT INTO structures(`alias`) VALUES ('ovcare_dx_primaries');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'clinical_history', 'textarea',  NULL , '0', 'rows=1,cols=30', '', '', 'clinical history', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'clinical_diagnosis', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'clinical diagnosis', ''), 

('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'initial_surgery_date', 'date',  NULL , '0', '', '', '', 'initial surgery date', ''),
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'initial_recurrence_date', 'date',  NULL , '0', '', '', '', 'initial recurrence date', ''),
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'progression_free_time_months', 'integer_positive',  NULL , '0', 'size=6', '', '', 'progression free time months', ''),

('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'stage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_stage') , '0', '', '', '', 'stage', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'substage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_substage') , '0', '', '', '', 'substage', ''), 

('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'review_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_review_grade') , '0', '', '', '', 'review grade', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'review_comment', 'textarea',  NULL , '0', 'rows=2,cols=20', '', '', 'review comment', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'review_diagnosis', 'textarea',  NULL , '0', 'rows=2,cols=20', '', '', 'review diagnosis', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='clinical_history' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=1,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='clinical history' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='clinical_diagnosis' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='clinical diagnosis' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 

((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field`='initial_surgery_date'), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field`='initial_recurrence_date'), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='progression_free_time_months'), '1', '14', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),

((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='stage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stage' AND `language_tag`=''), '2', '20', 'staging', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='substage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_substage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='substage' AND `language_tag`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 

((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='review_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_review_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='review grade' AND `language_tag`=''), '3', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='review_comment' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=20' AND `default`='' AND `language_help`='' AND `language_label`='review comment' AND `language_tag`=''), '3', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='review_diagnosis' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=20' AND `default`='' AND `language_help`='' AND `language_label`='review diagnosis' AND `language_tag`=''), '3', '40', 'review', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en) VALUES 
('clinical diagnosis','Clinical Diagnosis'),
('review comment','Review Comment'),
('review grade','Review Grade'),
('review diagnosis','Review Diagnosis'),
('review','Review'),
('substage','Substage'),
('stage','Stage'),
('who code','WHO Code'),
('progression free time months', 'Progression Free Time in Months'),
('initial surgery date', 'Initial Surgery Date'),
('initial recurrence date', 'Initial Recurrence Date');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='1', `language_help`='ovcare_help_survival' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET `language_help`='ovcare_initial_surgery_date' WHERE field = 'initial_surgery_date';
UPDATE structure_fields SET `language_help`='ovcare_initial_recurrence_date' WHERE field = 'initial_recurrence_date';
UPDATE structure_fields SET `language_help`='ovcare_progression_free_time_months' WHERE field = 'progression_free_time_months';

INSERT INTO i18n (id,en) VALUES 
('ovcare_initial_surgery_date', 'Date of the first surgery defined from list of surgeries whose date is not empty and that have been linked to this diagnosis.'),
('ovcare_initial_recurrence_date', 'Date of the first diagnosis recurrence defined from list of recurrences whose date is not empty and that have been linked to this diagnosis.'),
('ovcare_help_survival', 'Spent time (in months) between the intial surgery date and the last follow-up date.'),
('ovcare_progression_free_time_months', 'When the initial recurrence date is defined, this value is equal to the spent time (in months) between the intial surgery date and this recurrence date. When the initial recurrence date is not defined, this value is equal to the spent time (in months) between the intial surgery date and the last follow-up date.');

INSERT INTO i18n (id,en) VALUEs ('the dates accuracy is not sufficient: the field [%%field%%] can not be generated','The dates accuracy is not sufficient: the field [%%field%%] can not be generated!');


-- **** Treatment ****

-- chemotherapy

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'chemotherapy', 'ovcare', 1, 'txd_chemos', 'treatmentmasters,ovcare_txd_chemos', NULL, NULL, 0, NULL, NULL, 'ovcare|chemotherapy');
ALTER TABLE txd_chemos ADD COLUMN `ovcare_neoadjuvant`char(1) DEFAULT '' AFTER response;
ALTER TABLE txd_chemos_revs ADD COLUMN `ovcare_neoadjuvant`char(1) DEFAULT '' AFTER response;
INSERT INTO structures(`alias`) VALUES ('ovcare_txd_chemos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_chemos', 'ovcare_neoadjuvant', 'yes_no',  NULL , '0', '', '', '', 'neoadjuvant', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_response' AND `language_label`='response' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ovcare_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='ovcare_neoadjuvant' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='neoadjuvant' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

-- radiation

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'radiation', 'ovcare', 1, 'txd_radiations', 'treatmentmasters,ovcare_txd_radiations', NULL, NULL, 0, NULL, NULL, 'ovcare|radiation');
INSERT INTO structures(`alias`) VALUES ('ovcare_txd_radiations');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

-- surgery

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'surgery', 'ovcare', 1, 'txd_surgeries', 'treatmentmasters,ovcare_txd_surgeries', NULL, NULL, 0, NULL, NULL, 'ovcare|surgery');
ALTER TABLE txd_surgeries 
  ADD COLUMN `ovcare_procedure_performed` text AFTER path_num, 
  ADD COLUMN `ovcare_age_at_surgery` int(4) AFTER ovcare_procedure_performed,
  ADD COLUMN `ovcare_macroscopic_residual` char(1) DEFAULT '' AFTER ovcare_age_at_surgery;
ALTER TABLE txd_surgeries_revs 
  ADD COLUMN `ovcare_procedure_performed` text AFTER path_num, 
  ADD COLUMN `ovcare_age_at_surgery` int(4) AFTER ovcare_procedure_performed,
  ADD COLUMN `ovcare_macroscopic_residual` char(1) DEFAULT '' AFTER ovcare_age_at_surgery;
INSERT INTO structures(`alias`) VALUES ('ovcare_txd_surgeries');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'ovcare_procedure_performed', 'textarea',  NULL , '0', 'rows=2,cols=20', '', '', 'procedure performed', ''),
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'ovcare_age_at_surgery', 'integer_positive',  NULL , '0', 'size=6', '', '', 'age at surgery', ''),
('Clinicalannotation', 'TreatmentDetail', 'txd_surgeries', 'ovcare_macroscopic_residual', 'yes_no',  NULL , '0', '', '', '', 'macroscopic residual', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='path_num' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_path_num' AND `language_label`='pathology number' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'),
((SELECT id FROM structures WHERE alias='ovcare_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='ovcare_procedure_performed'), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='ovcare_age_at_surgery'), '1', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='ovcare_macroscopic_residual'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT INTO i18n (id,en) VALUEs ('procedure performed', 'Procedure Performed'),('macroscopic residual','Macroscopic Residual'),('age at surgery','Age at Surgery');
INSERT INTO i18n (id,en) VALUEs ('error in the dates definitions: the field [%%field%%] can not be generated','Error in the dates definitions: The field [%%field%%] can not be generated!');

UPDATE treatment_controls SET flag_active = 0 WHERE disease_site != 'ovcare';


-- **** EVENT ****

UPDATE menus SET flag_active = 0
WHERE use_link like '/clinicalannotation/event_masters%' AND language_title NOT IN ('lab', 'annotation');
SET @use_link = (SELECT use_link FROM menus WHERE id = 'clin_CAN_28');
UPDATE menus SET use_link = @use_link WHERE id = 'clin_CAN_4';
UPDATE event_controls SET flag_active = 0;
INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('ovcare', 'lab', 'experimental results', 1, 'eventmasters,ovcare_ed_lab_experimental_results', 'ovcare_ed_lab_experimental_results', 0, 'lab|ovcare|experimental results');
INSERT INTO i18n (id,en) VALUEs ('experimental results', 'Experimental Results');

UPDATE structure_fields SET `language_label`='last update date' WHERE model='EventMaster' AND tablename='event_masters' AND field='event_date' AND `type`='date' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en) VALUEs ('last update date', 'Last Update Date');

CREATE TABLE IF NOT EXISTS `ovcare_ed_lab_experimental_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `brca1_germline_nuc_acid` varchar(50) DEFAULT NULL,
  `brca1_germline_amino_acid` varchar(50) DEFAULT NULL,
  `brca1_somatic_nuc_acid` varchar(50) DEFAULT NULL,
  `brca1_vus` varchar(50) DEFAULT NULL,
  `brca2_germline_nuc_acid` varchar(50) DEFAULT NULL,
  `brca2_germline_amino_acid` varchar(50) DEFAULT NULL,
  `brca2_somatic_nuc_acid` varchar(50) DEFAULT NULL,
  `brca2_vus` varchar(50) DEFAULT NULL,
  `brca1_loh` varchar(50) DEFAULT NULL,
  `brca2_loh` varchar(50) DEFAULT NULL,
  `brca1_hypermethylation` varchar(50) DEFAULT NULL,
  `brca1_rna` varchar(50) DEFAULT NULL,
  `brca2_rna` varchar(50) DEFAULT NULL,
  `powerplex` varchar(50) DEFAULT NULL,
  `brca_array_wt1` varchar(50) DEFAULT NULL,
  `brca_array_p21` varchar(50) DEFAULT NULL,
  `brca_array_p53` varchar(50) DEFAULT NULL,
  `brca_array_cyclin_d1` varchar(50) DEFAULT NULL,
  `brca_array_brca1` varchar(50) DEFAULT NULL,
  `brca_array_p27` varchar(50) DEFAULT NULL,
  `brca_array_eef1a2` varchar(50) DEFAULT NULL,
  `brca_array_cycline` varchar(50) DEFAULT NULL,
  `brca_array_ecad` varchar(50) DEFAULT NULL,
  `brca_array_e2f1` varchar(50) DEFAULT NULL,
  `brca_array_p63` varchar(50) DEFAULT NULL,
  `brca_array_p16` varchar(50) DEFAULT NULL,
  `brca_array_egfr` varchar(50) DEFAULT NULL,
  `brca_array_pr` varchar(50) DEFAULT NULL,
  `brca_array_er` varchar(50) DEFAULT NULL,
  `brca_array_her2` varchar(50) DEFAULT NULL,
  `brca_array_cd_3` varchar(50) DEFAULT NULL,
  `brca_array_cd_117` varchar(50) DEFAULT NULL,
  `brca_array_foxp3` varchar(50) DEFAULT NULL,
  `brca_array_b_catenin_n` varchar(50) DEFAULT NULL,
  `brca_array_b_catenin_m` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_position128820745` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_position128822436` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_mean` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_sd` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_hebo_mrna_row1` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_hebo_mrna_row2` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_hebo_mrna_mean` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_hebo_mrna_sd` varchar(50) DEFAULT NULL,
  `brca_array_mip_pik3ca` varchar(50) DEFAULT NULL,
  `brca_array_qrt_pcr_pik3ca` varchar(50) DEFAULT NULL,
  `brca_array_qrt_pcr_pten` varchar(50) DEFAULT NULL,
  `brca_array_qrt_pcr_id4_rna` varchar(50) DEFAULT NULL,
  `brca_array_pakt` varchar(50) DEFAULT NULL,
  `brca1_somatic_amino_acid` varchar(50) DEFAULT NULL,
  `brca_array_ar` varchar(50) DEFAULT NULL,
  `08_001_core_id` varchar(50) DEFAULT NULL,
  `tma_blocks` varchar(50) DEFAULT NULL,
  `tma_ret` varchar(50) DEFAULT NULL,
  `tma_fascin` varchar(50) DEFAULT NULL,
  `tma_wt1` varchar(50) DEFAULT NULL,
  `tma_p53` varchar(50) DEFAULT NULL,
  `tma_p16` varchar(50) DEFAULT NULL,
  `tma_imp3` varchar(50) DEFAULT NULL,
  `tma_trka` varchar(50) DEFAULT NULL,
  `tma_trkb` varchar(50) DEFAULT NULL,
  `brca_array_mip_imp3` varchar(50) DEFAULT NULL,
  `brca_array_mip_imp3_bin` varchar(50) DEFAULT NULL,
  `brca_array_mip_imp3_hebo_mrna` varchar(50) DEFAULT NULL,
  `brca_array_mip_hace1` varchar(50) DEFAULT NULL,
  `brca_array_qrt_pcr_hace1` varchar(50) DEFAULT NULL,
  `tma_egfr` varchar(50) DEFAULT NULL,
  `tma_birc6` varchar(50) DEFAULT NULL,
  `tma_cyclind1` varchar(50) DEFAULT NULL,
  `brca_array_mip_emsy_position75861572` varchar(50) DEFAULT NULL,
  `brca_array_mip_emsy_position75921347` varchar(50) DEFAULT NULL,
  `brca_array_znf217_position51632374` varchar(50) DEFAULT NULL,
  `brca_array_mip_emsy_mean` varchar(50) DEFAULT NULL,
  `brca_array_mip_emsy_sd` varchar(50) DEFAULT NULL,
  `mda_cmyc_mean` varchar(50) DEFAULT NULL,
  `mda_cmyc_sd` varchar(50) DEFAULT NULL,
  `mda_cmyc_replicate_1` varchar(50) DEFAULT NULL,
  `mda_cmyc_replicate_2` varchar(50) DEFAULT NULL,
  `tma_cmyc` varchar(50) DEFAULT NULL,
  `tma_vegfr2` varchar(50) DEFAULT NULL,
  `tma_pdgfr_beta` varchar(50) DEFAULT NULL,
  `tma_mras` varchar(50) DEFAULT NULL,
  `tma_nasp` varchar(50) DEFAULT NULL,
  `tma_rb` varchar(50) DEFAULT NULL,
  `tma_vimentin` varchar(50) DEFAULT NULL,
  `tma_ckit` varchar(50) DEFAULT NULL,
  `tma_kiss1` varchar(50) DEFAULT NULL,
  `tma_e_cadherin` varchar(50) DEFAULT NULL,
  `tma_hif1_alpha` varchar(50) DEFAULT NULL,
  `tma_pthlh` varchar(50) DEFAULT NULL,
  `tma_ki67` varchar(50) DEFAULT NULL,
  `tma_s100` varchar(50) DEFAULT NULL,
  `tma_agr2_43` varchar(50) DEFAULT NULL,
  `spry2_clid_hsq035516` varchar(50) DEFAULT NULL,
  `spry4_clid_hsq027862` varchar(50) DEFAULT NULL,
  `spry1_clid_hsq043924` varchar(50) DEFAULT NULL,
  `spry1_clid_hsq011236` varchar(50) DEFAULT NULL,
  `spry1_clid_hsq043441` varchar(50) DEFAULT NULL,
  `ereg_clid_hsq025201` varchar(50) DEFAULT NULL,
  `erbb3_clid_hsq001349` varchar(50) DEFAULT NULL,
  `areg_clid_hsq045253` varchar(50) DEFAULT NULL,
  `errfi1_clid_hsq001603` varchar(50) DEFAULT NULL,
  `egfr_clid_hsq038313` varchar(50) DEFAULT NULL,
  `egfr_clid_hsq010863` varchar(50) DEFAULT NULL,
  `btc_clid_hsq035992` varchar(50) DEFAULT NULL,
  `tma_apoj` varchar(50) DEFAULT NULL,
  `tma_capg164` varchar(50) DEFAULT NULL,
  `tma_he4` varchar(50) DEFAULT NULL,
  `tma_hsp10` varchar(50) DEFAULT NULL,
  `tma_pigr` varchar(50) DEFAULT NULL,
  `tma_pkm2` varchar(50) DEFAULT NULL,
  `pde5a_clid_hsq039972` varchar(50) DEFAULT NULL,
  `tma_cd74` varchar(50) DEFAULT NULL,
  `tma_mif` varchar(50) DEFAULT NULL,
  `mif_clid_hsq038688` varchar(50) DEFAULT NULL,
  `cd74_clid_hsq040723` varchar(50) DEFAULT NULL,
  `cd74_clid_hsq045359` varchar(50) DEFAULT NULL,
  `tma_gpr54` varchar(50) DEFAULT NULL,
  `tma_cd44v6` varchar(50) DEFAULT NULL,
  `tma_hacel_sorensen` varchar(50) DEFAULT NULL,
  `tma_hnf_r_soslow` varchar(50) DEFAULT NULL,
  `tma_gdf15` varchar(50) DEFAULT NULL,
  `tma_ogp` varchar(50) DEFAULT NULL,
  `tma_pax8` varchar(50) DEFAULT NULL,
  `tma_mammaglobin_b` varchar(50) DEFAULT NULL,
  `tma_er` varchar(50) DEFAULT NULL,
  `tma_epcam` varchar(50) DEFAULT NULL,
  `tma_beta_catenin_nuclear` varchar(50) DEFAULT NULL,
  `tma_mesothelin` varchar(50) DEFAULT NULL,
  `tma_muc6` varchar(50) DEFAULT NULL,
  `tma_muc5` varchar(50) DEFAULT NULL,
  `tma_pten` varchar(50) DEFAULT NULL,
  `tma_skp2` varchar(50) DEFAULT NULL,
  `tma_her2` varchar(50) DEFAULT NULL,
  `tma_mdm2` varchar(50) DEFAULT NULL,
  `tma_nherf1` varchar(50) DEFAULT NULL,
  `tma_ezrin` varchar(50) DEFAULT NULL,
  `tma_pax2` varchar(50) DEFAULT NULL,
  `tma_pr` varchar(50) DEFAULT NULL,
  `tma_podocalyxin` varchar(50) DEFAULT NULL,
  `tma_hdac1` varchar(50) DEFAULT NULL,
  `tma_ca125` varchar(50) DEFAULT NULL,
  `tma_k_cadherin` varchar(50) DEFAULT NULL,
  `tma_p21` varchar(50) DEFAULT NULL,
  `tma_cd200` varchar(50) DEFAULT NULL,
  `tma_mmp7` varchar(50) DEFAULT NULL,
  `itgb7_clid_hsq031618` varchar(50) DEFAULT NULL,
  `ccl28_clid_hsq013417` varchar(50) DEFAULT NULL,
  `tro_clid_hsq006530` varchar(50) DEFAULT NULL,
  `tro_clid_hsq004393` varchar(50) DEFAULT NULL,
  `fkbp7_clid_hsq037241` varchar(50) DEFAULT NULL,
  `wdr72_clid_hsq009730` varchar(50) DEFAULT NULL,
  `tma_dal1` varchar(50) DEFAULT NULL,
  `tma_drosha` varchar(50) DEFAULT NULL,
  `tma_tgfb1` varchar(50) DEFAULT NULL,
  `tma_foxp3` varchar(50) DEFAULT NULL,
  `tma_cd20` varchar(50) DEFAULT NULL,
  `tma_tia1` varchar(50) DEFAULT NULL,
  `tma_hif1_intensity` varchar(50) DEFAULT NULL,
  `tma_hif1_percent` varchar(50) DEFAULT NULL,
  `tma_hif1_irs` varchar(50) DEFAULT NULL,
  `tma_ccl28_intensity` varchar(50) DEFAULT NULL,
  `tma_ccl28_percent` varchar(50) DEFAULT NULL,
  `tma_ccl28_irs` varchar(50) DEFAULT NULL,
  `kp_ir_pmol_l` varchar(50) DEFAULT NULL,
  `pde5a_expression_data` varchar(50) DEFAULT NULL,
  `tma_secretory_component_pigr` varchar(50) DEFAULT NULL,
  `tma_s100a1` varchar(50) DEFAULT NULL,
  `tma_dicer` varchar(50) DEFAULT NULL,
  `tma_p53_rescore` varchar(50) DEFAULT NULL,
  `tma_tff3` varchar(50) DEFAULT NULL,
  `tma_ps6rp` varchar(50) DEFAULT NULL,
  `tma_dkk1` varchar(50) DEFAULT NULL,
  `tma_cd8` varchar(50) DEFAULT NULL,
  `tma_foxl2` varchar(50) DEFAULT NULL,
  `tma_hnf1b_restain` varchar(50) DEFAULT NULL,
  `tma_mdm2_restain_08.05.09` varchar(50) DEFAULT NULL,
  `tma_phosphoeif4e` varchar(50) DEFAULT NULL,
  `tma_arid1a` varchar(50) DEFAULT NULL,
  `tma_opn` varchar(50) DEFAULT NULL,
  `tma_ezh2` varchar(50) DEFAULT NULL,
  `tma_hif1a` varchar(50) DEFAULT NULL,
  `tma_pstat` varchar(50) DEFAULT NULL,
  `tma_lyn` varchar(50) DEFAULT NULL,
  `tma_laminin_rp_score` varchar(50) DEFAULT NULL,
  `tma_laminin_rp_vessels` varchar(50) DEFAULT NULL,
  `tma_pcad_percent_positive` varchar(50) DEFAULT NULL,
  `tma_pcad_intensity` varchar(50) DEFAULT NULL,
  `tma_numb` varchar(50) DEFAULT NULL,
  `tma_mps1_mean_percent` varchar(50) DEFAULT NULL,
  `tma_mps1_max_percent` varchar(50) DEFAULT NULL,
  `tma_mps1_intensity` varchar(50) DEFAULT NULL,
  `tma_mps1_nuclear_staining` varchar(50) DEFAULT NULL,
  `brca1` varchar(50) DEFAULT NULL,
  `cd8_vgh` varchar(50) DEFAULT NULL,
  `cd8_victoria` varchar(50) DEFAULT NULL,
  `cd3_victoria` varchar(50) DEFAULT NULL,
  `cd3_vgh` varchar(50) DEFAULT NULL,
  `foxp3_victoria` varchar(50) DEFAULT NULL,
  `tia1_victoria` varchar(50) DEFAULT NULL,
  `cd20_victoria` varchar(50) DEFAULT NULL,
  `10_007_core_id` varchar(50) DEFAULT NULL,
  `tma_ephb4` varchar(50) DEFAULT NULL,
  `tma_survivin` varchar(50) DEFAULT NULL,
  `mdm2` varchar(50) DEFAULT NULL,
  `ndrg1` varchar(50) DEFAULT NULL,
  `serbp1` varchar(50) DEFAULT NULL,
  `anxa4` varchar(50) DEFAULT NULL,
  `p10` varchar(50) DEFAULT NULL,
  `p53` varchar(50) DEFAULT NULL,
  `cycline` varchar(50) DEFAULT NULL,
  `p21` varchar(50) DEFAULT NULL,
  `p27` varchar(50) DEFAULT NULL,
  `p16` varchar(50) DEFAULT NULL,
  `pakt` varchar(50) DEFAULT NULL,
  `cd8_vgh_rescore` varchar(50) DEFAULT NULL,
  `cd8_victoria_rescore` varchar(50) DEFAULT NULL,
  `cd3_victoria_rescore` varchar(50) DEFAULT NULL,
  `cd3_vgh_rescore` varchar(50) DEFAULT NULL,
  `tma_nkap` varchar(50) DEFAULT NULL,
  
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ovcare_ed_lab_experimental_results_revs` (
  `id` int(11) NOT NULL,
  
  `brca1_germline_nuc_acid` varchar(50) DEFAULT NULL,
  `brca1_germline_amino_acid` varchar(50) DEFAULT NULL,
  `brca1_somatic_nuc_acid` varchar(50) DEFAULT NULL,
  `brca1_vus` varchar(50) DEFAULT NULL,
  `brca2_germline_nuc_acid` varchar(50) DEFAULT NULL,
  `brca2_germline_amino_acid` varchar(50) DEFAULT NULL,
  `brca2_somatic_nuc_acid` varchar(50) DEFAULT NULL,
  `brca2_vus` varchar(50) DEFAULT NULL,
  `brca1_loh` varchar(50) DEFAULT NULL,
  `brca2_loh` varchar(50) DEFAULT NULL,
  `brca1_hypermethylation` varchar(50) DEFAULT NULL,
  `brca1_rna` varchar(50) DEFAULT NULL,
  `brca2_rna` varchar(50) DEFAULT NULL,
  `powerplex` varchar(50) DEFAULT NULL,
  `brca_array_wt1` varchar(50) DEFAULT NULL,
  `brca_array_p21` varchar(50) DEFAULT NULL,
  `brca_array_p53` varchar(50) DEFAULT NULL,
  `brca_array_cyclin_d1` varchar(50) DEFAULT NULL,
  `brca_array_brca1` varchar(50) DEFAULT NULL,
  `brca_array_p27` varchar(50) DEFAULT NULL,
  `brca_array_eef1a2` varchar(50) DEFAULT NULL,
  `brca_array_cycline` varchar(50) DEFAULT NULL,
  `brca_array_ecad` varchar(50) DEFAULT NULL,
  `brca_array_e2f1` varchar(50) DEFAULT NULL,
  `brca_array_p63` varchar(50) DEFAULT NULL,
  `brca_array_p16` varchar(50) DEFAULT NULL,
  `brca_array_egfr` varchar(50) DEFAULT NULL,
  `brca_array_pr` varchar(50) DEFAULT NULL,
  `brca_array_er` varchar(50) DEFAULT NULL,
  `brca_array_her2` varchar(50) DEFAULT NULL,
  `brca_array_cd_3` varchar(50) DEFAULT NULL,
  `brca_array_cd_117` varchar(50) DEFAULT NULL,
  `brca_array_foxp3` varchar(50) DEFAULT NULL,
  `brca_array_b_catenin_n` varchar(50) DEFAULT NULL,
  `brca_array_b_catenin_m` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_position128820745` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_position128822436` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_mean` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_sd` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_hebo_mrna_row1` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_hebo_mrna_row2` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_hebo_mrna_mean` varchar(50) DEFAULT NULL,
  `brca_array_mip_c_myc_hebo_mrna_sd` varchar(50) DEFAULT NULL,
  `brca_array_mip_pik3ca` varchar(50) DEFAULT NULL,
  `brca_array_qrt_pcr_pik3ca` varchar(50) DEFAULT NULL,
  `brca_array_qrt_pcr_pten` varchar(50) DEFAULT NULL,
  `brca_array_qrt_pcr_id4_rna` varchar(50) DEFAULT NULL,
  `brca_array_pakt` varchar(50) DEFAULT NULL,
  `brca1_somatic_amino_acid` varchar(50) DEFAULT NULL,
  `brca_array_ar` varchar(50) DEFAULT NULL,
  `08_001_core_id` varchar(50) DEFAULT NULL,
  `tma_blocks` varchar(50) DEFAULT NULL,
  `tma_ret` varchar(50) DEFAULT NULL,
  `tma_fascin` varchar(50) DEFAULT NULL,
  `tma_wt1` varchar(50) DEFAULT NULL,
  `tma_p53` varchar(50) DEFAULT NULL,
  `tma_p16` varchar(50) DEFAULT NULL,
  `tma_imp3` varchar(50) DEFAULT NULL,
  `tma_trka` varchar(50) DEFAULT NULL,
  `tma_trkb` varchar(50) DEFAULT NULL,
  `brca_array_mip_imp3` varchar(50) DEFAULT NULL,
  `brca_array_mip_imp3_bin` varchar(50) DEFAULT NULL,
  `brca_array_mip_imp3_hebo_mrna` varchar(50) DEFAULT NULL,
  `brca_array_mip_hace1` varchar(50) DEFAULT NULL,
  `brca_array_qrt_pcr_hace1` varchar(50) DEFAULT NULL,
  `tma_egfr` varchar(50) DEFAULT NULL,
  `tma_birc6` varchar(50) DEFAULT NULL,
  `tma_cyclind1` varchar(50) DEFAULT NULL,
  `brca_array_mip_emsy_position75861572` varchar(50) DEFAULT NULL,
  `brca_array_mip_emsy_position75921347` varchar(50) DEFAULT NULL,
  `brca_array_znf217_position51632374` varchar(50) DEFAULT NULL,
  `brca_array_mip_emsy_mean` varchar(50) DEFAULT NULL,
  `brca_array_mip_emsy_sd` varchar(50) DEFAULT NULL,
  `mda_cmyc_mean` varchar(50) DEFAULT NULL,
  `mda_cmyc_sd` varchar(50) DEFAULT NULL,
  `mda_cmyc_replicate_1` varchar(50) DEFAULT NULL,
  `mda_cmyc_replicate_2` varchar(50) DEFAULT NULL,
  `tma_cmyc` varchar(50) DEFAULT NULL,
  `tma_vegfr2` varchar(50) DEFAULT NULL,
  `tma_pdgfr_beta` varchar(50) DEFAULT NULL,
  `tma_mras` varchar(50) DEFAULT NULL,
  `tma_nasp` varchar(50) DEFAULT NULL,
  `tma_rb` varchar(50) DEFAULT NULL,
  `tma_vimentin` varchar(50) DEFAULT NULL,
  `tma_ckit` varchar(50) DEFAULT NULL,
  `tma_kiss1` varchar(50) DEFAULT NULL,
  `tma_e_cadherin` varchar(50) DEFAULT NULL,
  `tma_hif1_alpha` varchar(50) DEFAULT NULL,
  `tma_pthlh` varchar(50) DEFAULT NULL,
  `tma_ki67` varchar(50) DEFAULT NULL,
  `tma_s100` varchar(50) DEFAULT NULL,
  `tma_agr2_43` varchar(50) DEFAULT NULL,
  `spry2_clid_hsq035516` varchar(50) DEFAULT NULL,
  `spry4_clid_hsq027862` varchar(50) DEFAULT NULL,
  `spry1_clid_hsq043924` varchar(50) DEFAULT NULL,
  `spry1_clid_hsq011236` varchar(50) DEFAULT NULL,
  `spry1_clid_hsq043441` varchar(50) DEFAULT NULL,
  `ereg_clid_hsq025201` varchar(50) DEFAULT NULL,
  `erbb3_clid_hsq001349` varchar(50) DEFAULT NULL,
  `areg_clid_hsq045253` varchar(50) DEFAULT NULL,
  `errfi1_clid_hsq001603` varchar(50) DEFAULT NULL,
  `egfr_clid_hsq038313` varchar(50) DEFAULT NULL,
  `egfr_clid_hsq010863` varchar(50) DEFAULT NULL,
  `btc_clid_hsq035992` varchar(50) DEFAULT NULL,
  `tma_apoj` varchar(50) DEFAULT NULL,
  `tma_capg164` varchar(50) DEFAULT NULL,
  `tma_he4` varchar(50) DEFAULT NULL,
  `tma_hsp10` varchar(50) DEFAULT NULL,
  `tma_pigr` varchar(50) DEFAULT NULL,
  `tma_pkm2` varchar(50) DEFAULT NULL,
  `pde5a_clid_hsq039972` varchar(50) DEFAULT NULL,
  `tma_cd74` varchar(50) DEFAULT NULL,
  `tma_mif` varchar(50) DEFAULT NULL,
  `mif_clid_hsq038688` varchar(50) DEFAULT NULL,
  `cd74_clid_hsq040723` varchar(50) DEFAULT NULL,
  `cd74_clid_hsq045359` varchar(50) DEFAULT NULL,
  `tma_gpr54` varchar(50) DEFAULT NULL,
  `tma_cd44v6` varchar(50) DEFAULT NULL,
  `tma_hacel_sorensen` varchar(50) DEFAULT NULL,
  `tma_hnf_r_soslow` varchar(50) DEFAULT NULL,
  `tma_gdf15` varchar(50) DEFAULT NULL,
  `tma_ogp` varchar(50) DEFAULT NULL,
  `tma_pax8` varchar(50) DEFAULT NULL,
  `tma_mammaglobin_b` varchar(50) DEFAULT NULL,
  `tma_er` varchar(50) DEFAULT NULL,
  `tma_epcam` varchar(50) DEFAULT NULL,
  `tma_beta_catenin_nuclear` varchar(50) DEFAULT NULL,
  `tma_mesothelin` varchar(50) DEFAULT NULL,
  `tma_muc6` varchar(50) DEFAULT NULL,
  `tma_muc5` varchar(50) DEFAULT NULL,
  `tma_pten` varchar(50) DEFAULT NULL,
  `tma_skp2` varchar(50) DEFAULT NULL,
  `tma_her2` varchar(50) DEFAULT NULL,
  `tma_mdm2` varchar(50) DEFAULT NULL,
  `tma_nherf1` varchar(50) DEFAULT NULL,
  `tma_ezrin` varchar(50) DEFAULT NULL,
  `tma_pax2` varchar(50) DEFAULT NULL,
  `tma_pr` varchar(50) DEFAULT NULL,
  `tma_podocalyxin` varchar(50) DEFAULT NULL,
  `tma_hdac1` varchar(50) DEFAULT NULL,
  `tma_ca125` varchar(50) DEFAULT NULL,
  `tma_k_cadherin` varchar(50) DEFAULT NULL,
  `tma_p21` varchar(50) DEFAULT NULL,
  `tma_cd200` varchar(50) DEFAULT NULL,
  `tma_mmp7` varchar(50) DEFAULT NULL,
  `itgb7_clid_hsq031618` varchar(50) DEFAULT NULL,
  `ccl28_clid_hsq013417` varchar(50) DEFAULT NULL,
  `tro_clid_hsq006530` varchar(50) DEFAULT NULL,
  `tro_clid_hsq004393` varchar(50) DEFAULT NULL,
  `fkbp7_clid_hsq037241` varchar(50) DEFAULT NULL,
  `wdr72_clid_hsq009730` varchar(50) DEFAULT NULL,
  `tma_dal1` varchar(50) DEFAULT NULL,
  `tma_drosha` varchar(50) DEFAULT NULL,
  `tma_tgfb1` varchar(50) DEFAULT NULL,
  `tma_foxp3` varchar(50) DEFAULT NULL,
  `tma_cd20` varchar(50) DEFAULT NULL,
  `tma_tia1` varchar(50) DEFAULT NULL,
  `tma_hif1_intensity` varchar(50) DEFAULT NULL,
  `tma_hif1_percent` varchar(50) DEFAULT NULL,
  `tma_hif1_irs` varchar(50) DEFAULT NULL,
  `tma_ccl28_intensity` varchar(50) DEFAULT NULL,
  `tma_ccl28_percent` varchar(50) DEFAULT NULL,
  `tma_ccl28_irs` varchar(50) DEFAULT NULL,
  `kp_ir_pmol_l` varchar(50) DEFAULT NULL,
  `pde5a_expression_data` varchar(50) DEFAULT NULL,
  `tma_secretory_component_pigr` varchar(50) DEFAULT NULL,
  `tma_s100a1` varchar(50) DEFAULT NULL,
  `tma_dicer` varchar(50) DEFAULT NULL,
  `tma_p53_rescore` varchar(50) DEFAULT NULL,
  `tma_tff3` varchar(50) DEFAULT NULL,
  `tma_ps6rp` varchar(50) DEFAULT NULL,
  `tma_dkk1` varchar(50) DEFAULT NULL,
  `tma_cd8` varchar(50) DEFAULT NULL,
  `tma_foxl2` varchar(50) DEFAULT NULL,
  `tma_hnf1b_restain` varchar(50) DEFAULT NULL,
  `tma_mdm2_restain_08.05.09` varchar(50) DEFAULT NULL,
  `tma_phosphoeif4e` varchar(50) DEFAULT NULL,
  `tma_arid1a` varchar(50) DEFAULT NULL,
  `tma_opn` varchar(50) DEFAULT NULL,
  `tma_ezh2` varchar(50) DEFAULT NULL,
  `tma_hif1a` varchar(50) DEFAULT NULL,
  `tma_pstat` varchar(50) DEFAULT NULL,
  `tma_lyn` varchar(50) DEFAULT NULL,
  `tma_laminin_rp_score` varchar(50) DEFAULT NULL,
  `tma_laminin_rp_vessels` varchar(50) DEFAULT NULL,
  `tma_pcad_percent_positive` varchar(50) DEFAULT NULL,
  `tma_pcad_intensity` varchar(50) DEFAULT NULL,
  `tma_numb` varchar(50) DEFAULT NULL,
  `tma_mps1_mean_percent` varchar(50) DEFAULT NULL,
  `tma_mps1_max_percent` varchar(50) DEFAULT NULL,
  `tma_mps1_intensity` varchar(50) DEFAULT NULL,
  `tma_mps1_nuclear_staining` varchar(50) DEFAULT NULL,
  `brca1` varchar(50) DEFAULT NULL,
  `cd8_vgh` varchar(50) DEFAULT NULL,
  `cd8_victoria` varchar(50) DEFAULT NULL,
  `cd3_victoria` varchar(50) DEFAULT NULL,
  `cd3_vgh` varchar(50) DEFAULT NULL,
  `foxp3_victoria` varchar(50) DEFAULT NULL,
  `tia1_victoria` varchar(50) DEFAULT NULL,
  `cd20_victoria` varchar(50) DEFAULT NULL,
  `10_007_core_id` varchar(50) DEFAULT NULL,
  `tma_ephb4` varchar(50) DEFAULT NULL,
  `tma_survivin` varchar(50) DEFAULT NULL,
  `mdm2` varchar(50) DEFAULT NULL,
  `ndrg1` varchar(50) DEFAULT NULL,
  `serbp1` varchar(50) DEFAULT NULL,
  `anxa4` varchar(50) DEFAULT NULL,
  `p10` varchar(50) DEFAULT NULL,
  `p53` varchar(50) DEFAULT NULL,
  `cycline` varchar(50) DEFAULT NULL,
  `p21` varchar(50) DEFAULT NULL,
  `p27` varchar(50) DEFAULT NULL,
  `p16` varchar(50) DEFAULT NULL,
  `pakt` varchar(50) DEFAULT NULL,
  `cd8_vgh_rescore` varchar(50) DEFAULT NULL,
  `cd8_victoria_rescore` varchar(50) DEFAULT NULL,
  `cd3_victoria_rescore` varchar(50) DEFAULT NULL,
  `cd3_vgh_rescore` varchar(50) DEFAULT NULL,
  `tma_nkap` varchar(50) DEFAULT NULL,
  
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ovcare_ed_lab_experimental_results`
  ADD CONSTRAINT `ovcare_ed_lab_experimental_results_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('ovcare_ed_lab_experimental_results');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca1_germline_nuc_acid', 'input',  NULL , '0', 'size=10', '', '', 'brca1 germline nuc acid', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca1_germline_amino_acid', 'input',  NULL , '0', 'size=10', '', '', 'brca1 germline amino acid', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca1_somatic_nuc_acid', 'input',  NULL , '0', 'size=10', '', '', 'brca1 somatic nuc acid', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca1_vus', 'input',  NULL , '0', 'size=10', '', '', 'brca1 vus', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca2_germline_nuc_acid', 'input',  NULL , '0', 'size=10', '', '', 'brca2 germline nuc acid', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca2_germline_amino_acid', 'input',  NULL , '0', 'size=10', '', '', 'brca2 germline amino acid', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca2_somatic_nuc_acid', 'input',  NULL , '0', 'size=10', '', '', 'brca2 somatic nuc acid', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca2_vus', 'input',  NULL , '0', 'size=10', '', '', 'brca2 vus', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca1_loh', 'input',  NULL , '0', 'size=10', '', '', 'brca1 loh', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca2_loh', 'input',  NULL , '0', 'size=10', '', '', 'brca2 loh', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca1_hypermethylation', 'input',  NULL , '0', 'size=10', '', '', 'brca1 hypermethylation', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca1_rna', 'input',  NULL , '0', 'size=10', '', '', 'brca1 rna', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca2_rna', 'input',  NULL , '0', 'size=10', '', '', 'brca2 rna', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'powerplex', 'input',  NULL , '0', 'size=10', '', '', 'powerplex', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_wt1', 'input',  NULL , '0', 'size=10', '', '', 'brca array wt1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_p21', 'input',  NULL , '0', 'size=10', '', '', 'brca array p21', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_p53', 'input',  NULL , '0', 'size=10', '', '', 'brca array p53', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_cyclin_d1', 'input',  NULL , '0', 'size=10', '', '', 'brca array cyclin d1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_brca1', 'input',  NULL , '0', 'size=10', '', '', 'brca array brca1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_p27', 'input',  NULL , '0', 'size=10', '', '', 'brca array p27', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_eef1a2', 'input',  NULL , '0', 'size=10', '', '', 'brca array eef1a2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_cycline', 'input',  NULL , '0', 'size=10', '', '', 'brca array cycline', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_ecad', 'input',  NULL , '0', 'size=10', '', '', 'brca array ecad', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_e2f1', 'input',  NULL , '0', 'size=10', '', '', 'brca array e2f1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_p63', 'input',  NULL , '0', 'size=10', '', '', 'brca array p63', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_p16', 'input',  NULL , '0', 'size=10', '', '', 'brca array p16', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_egfr', 'input',  NULL , '0', 'size=10', '', '', 'brca array egfr', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_pr', 'input',  NULL , '0', 'size=10', '', '', 'brca array pr', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_er', 'input',  NULL , '0', 'size=10', '', '', 'brca array er', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_her2', 'input',  NULL , '0', 'size=10', '', '', 'brca array her2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_cd_3', 'input',  NULL , '0', 'size=10', '', '', 'brca array cd 3', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_cd_117', 'input',  NULL , '0', 'size=10', '', '', 'brca array cd 117', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_foxp3', 'input',  NULL , '0', 'size=10', '', '', 'brca array foxp3', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_b_catenin_n', 'input',  NULL , '0', 'size=10', '', '', 'brca array b_catenin_n', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_b_catenin_m', 'input',  NULL , '0', 'size=10', '', '', 'brca array b_catenin_m', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_c_myc_position128820745', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_c_myc position128820745', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_c_myc_position128822436', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_c_myc position128822436', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_c_myc_mean', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_c_myc mean', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_c_myc_sd', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_c_myc sd', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_c_myc_hebo_mrna_row1', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_c_myc hebo mrna row1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_c_myc_hebo_mrna_row2', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_c_myc hebo mrna row2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_c_myc_hebo_mrna_mean', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_c_myc hebo mrna mean', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_c_myc_hebo_mrna_sd', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_c_myc hebo mrna sd', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_pik3ca', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_pik3ca', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_qrt_pcr_pik3ca', 'input',  NULL , '0', 'size=10', '', '', 'brca array qrt_pcr_pik3ca', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_qrt_pcr_pten', 'input',  NULL , '0', 'size=10', '', '', 'brca array qrt_pcr_pten', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_qrt_pcr_id4_rna', 'input',  NULL , '0', 'size=10', '', '', 'brca array qrt_pcr_id4 rna', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_pakt', 'input',  NULL , '0', 'size=10', '', '', 'brca array pakt', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca1_somatic_amino_acid', 'input',  NULL , '0', 'size=10', '', '', 'brca1 somatic amino acid', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_ar', 'input',  NULL , '0', 'size=10', '', '', 'brca array ar', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', '08_001_core_id', 'input',  NULL , '0', 'size=10', '', '', '08_001 core id', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_blocks', 'input',  NULL , '0', 'size=10', '', '', 'tma blocks', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ret', 'input',  NULL , '0', 'size=10', '', '', 'tma_ret', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_fascin', 'input',  NULL , '0', 'size=10', '', '', 'tma_fascin', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_wt1', 'input',  NULL , '0', 'size=10', '', '', 'tma_wt1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_p53', 'input',  NULL , '0', 'size=10', '', '', 'tma_p53', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_p16', 'input',  NULL , '0', 'size=10', '', '', 'tma_p16', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_imp3', 'input',  NULL , '0', 'size=10', '', '', 'tma_imp3', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_trka', 'input',  NULL , '0', 'size=10', '', '', 'tma_trka', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_trkb', 'input',  NULL , '0', 'size=10', '', '', 'tma_trkb', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_imp3', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_imp3', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_imp3_bin', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_imp3 bin', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_imp3_hebo_mrna', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_imp3 hebo mrna', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_hace1', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_hace1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_qrt_pcr_hace1', 'input',  NULL , '0', 'size=10', '', '', 'brca array qrt_pcr_hace1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_egfr', 'input',  NULL , '0', 'size=10', '', '', 'tma_egfr', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_birc6', 'input',  NULL , '0', 'size=10', '', '', 'tma_birc6', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_cyclind1', 'input',  NULL , '0', 'size=10', '', '', 'tma_cyclind1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_emsy_position75861572', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_emsy position75861572', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_emsy_position75921347', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_emsy position75921347', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_znf217_position51632374', 'input',  NULL , '0', 'size=10', '', '', 'brca array znf217 position51632374', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_emsy_mean', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_emsy mean', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca_array_mip_emsy_sd', 'input',  NULL , '0', 'size=10', '', '', 'brca array mip_emsy sd', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'mda_cmyc_mean', 'input',  NULL , '0', 'size=10', '', '', 'mda cmyc mean', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'mda_cmyc_sd', 'input',  NULL , '0', 'size=10', '', '', 'mda cmyc sd', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'mda_cmyc_replicate_1', 'input',  NULL , '0', 'size=10', '', '', 'mda cmyc replicate 1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'mda_cmyc_replicate_2', 'input',  NULL , '0', 'size=10', '', '', 'mda cmyc replicate 2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_cmyc', 'input',  NULL , '0', 'size=10', '', '', 'tma_cmyc', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_vegfr2', 'input',  NULL , '0', 'size=10', '', '', 'tma_vegfr2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_pdgfr_beta', 'input',  NULL , '0', 'size=10', '', '', 'tma_pdgfr beta', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_mras', 'input',  NULL , '0', 'size=10', '', '', 'tma_mras', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_nasp', 'input',  NULL , '0', 'size=10', '', '', 'tma_nasp', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_rb', 'input',  NULL , '0', 'size=10', '', '', 'tma_rb', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_vimentin', 'input',  NULL , '0', 'size=10', '', '', 'tma_vimentin', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ckit', 'input',  NULL , '0', 'size=10', '', '', 'tma_ckit', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_kiss1', 'input',  NULL , '0', 'size=10', '', '', 'tma_kiss1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_e_cadherin', 'input',  NULL , '0', 'size=10', '', '', 'tma_e_cadherin', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_hif1_alpha', 'input',  NULL , '0', 'size=10', '', '', 'tma_hif1 alpha', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_pthlh', 'input',  NULL , '0', 'size=10', '', '', 'tma_pthlh', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ki67', 'input',  NULL , '0', 'size=10', '', '', 'tma_ki67', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_s100', 'input',  NULL , '0', 'size=10', '', '', 'tma_s100', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_agr2_43', 'input',  NULL , '0', 'size=10', '', '', 'tma_agr2_43', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'spry2_clid_hsq035516', 'input',  NULL , '0', 'size=10', '', '', 'spry2 clid: hsq035516', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'spry4_clid_hsq027862', 'input',  NULL , '0', 'size=10', '', '', 'spry4 clid: hsq027862', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'spry1_clid_hsq043924', 'input',  NULL , '0', 'size=10', '', '', 'spry1 clid: hsq043924', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'spry1_clid_hsq011236', 'input',  NULL , '0', 'size=10', '', '', 'spry1 clid: hsq011236', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'spry1_clid_hsq043441', 'input',  NULL , '0', 'size=10', '', '', 'spry1 clid: hsq043441', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'ereg_clid_hsq025201', 'input',  NULL , '0', 'size=10', '', '', 'ereg clid: hsq025201', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'erbb3_clid_hsq001349', 'input',  NULL , '0', 'size=10', '', '', 'erbb3 clid: hsq001349', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'areg_clid_hsq045253', 'input',  NULL , '0', 'size=10', '', '', 'areg clid: hsq045253', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'errfi1_clid_hsq001603', 'input',  NULL , '0', 'size=10', '', '', 'errfi1 clid: hsq001603', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'egfr_clid_hsq038313', 'input',  NULL , '0', 'size=10', '', '', 'egfr clid: hsq038313', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'egfr_clid_hsq010863', 'input',  NULL , '0', 'size=10', '', '', 'egfr clid: hsq010863', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'btc_clid_hsq035992', 'input',  NULL , '0', 'size=10', '', '', 'btc clid: hsq035992', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_apoj', 'input',  NULL , '0', 'size=10', '', '', 'tma_apoj', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_capg164', 'input',  NULL , '0', 'size=10', '', '', 'tma_capg164', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_he4', 'input',  NULL , '0', 'size=10', '', '', 'tma_he4', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_hsp10', 'input',  NULL , '0', 'size=10', '', '', 'tma_hsp10', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_pigr', 'input',  NULL , '0', 'size=10', '', '', 'tma_pigr', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_pkm2', 'input',  NULL , '0', 'size=10', '', '', 'tma_pkm2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'pde5a_clid_hsq039972', 'input',  NULL , '0', 'size=10', '', '', 'pde5a clid: hsq039972', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_cd74', 'input',  NULL , '0', 'size=10', '', '', 'tma_cd74', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_mif', 'input',  NULL , '0', 'size=10', '', '', 'tma_mif', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'mif_clid_hsq038688', 'input',  NULL , '0', 'size=10', '', '', 'mif clid: hsq038688', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cd74_clid_hsq040723', 'input',  NULL , '0', 'size=10', '', '', 'cd74 clid: hsq040723', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cd74_clid_hsq045359', 'input',  NULL , '0', 'size=10', '', '', 'cd74 clid: hsq045359', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_gpr54', 'input',  NULL , '0', 'size=10', '', '', 'tma_gpr54', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_cd44v6', 'input',  NULL , '0', 'size=10', '', '', 'tma_cd44v6', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_hacel_sorensen', 'input',  NULL , '0', 'size=10', '', '', 'tma_hacel_sorensen', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_hnf_r_soslow', 'input',  NULL , '0', 'size=10', '', '', 'tma_hnf_r_soslow', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_gdf15', 'input',  NULL , '0', 'size=10', '', '', 'tma_gdf15', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ogp', 'input',  NULL , '0', 'size=10', '', '', 'tma_ogp', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_pax8', 'input',  NULL , '0', 'size=10', '', '', 'tma_pax8', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_mammaglobin_b', 'input',  NULL , '0', 'size=10', '', '', 'tma_mammaglobin b', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_er', 'input',  NULL , '0', 'size=10', '', '', 'tma_er', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_epcam', 'input',  NULL , '0', 'size=10', '', '', 'tma_epcam', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_beta_catenin_nuclear', 'input',  NULL , '0', 'size=10', '', '', 'tma_beta_catenin nuclear', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_mesothelin', 'input',  NULL , '0', 'size=10', '', '', 'tma_mesothelin', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_muc6', 'input',  NULL , '0', 'size=10', '', '', 'tma_muc6', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_muc5', 'input',  NULL , '0', 'size=10', '', '', 'tma_muc5', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_pten', 'input',  NULL , '0', 'size=10', '', '', 'tma_pten', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_skp2', 'input',  NULL , '0', 'size=10', '', '', 'tma_skp2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_her2', 'input',  NULL , '0', 'size=10', '', '', 'tma_her2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_mdm2', 'input',  NULL , '0', 'size=10', '', '', 'tma_mdm2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_nherf1', 'input',  NULL , '0', 'size=10', '', '', 'tma_nherf1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ezrin', 'input',  NULL , '0', 'size=10', '', '', 'tma_ezrin', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_pax2', 'input',  NULL , '0', 'size=10', '', '', 'tma_pax2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_pr', 'input',  NULL , '0', 'size=10', '', '', 'tma_pr', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_podocalyxin', 'input',  NULL , '0', 'size=10', '', '', 'tma_podocalyxin', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_hdac1', 'input',  NULL , '0', 'size=10', '', '', 'tma_hdac1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ca125', 'input',  NULL , '0', 'size=10', '', '', 'tma_ca125', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_k_cadherin', 'input',  NULL , '0', 'size=10', '', '', 'tma_k_cadherin', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_p21', 'input',  NULL , '0', 'size=10', '', '', 'tma_p21', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_cd200', 'input',  NULL , '0', 'size=10', '', '', 'tma_cd200', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_mmp7', 'input',  NULL , '0', 'size=10', '', '', 'tma_mmp7', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'itgb7_clid_hsq031618', 'input',  NULL , '0', 'size=10', '', '', 'itgb7 clid: hsq031618', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'ccl28_clid_hsq013417', 'input',  NULL , '0', 'size=10', '', '', 'ccl28 clid: hsq013417', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tro_clid_hsq006530', 'input',  NULL , '0', 'size=10', '', '', 'tro clid: hsq006530', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tro_clid_hsq004393', 'input',  NULL , '0', 'size=10', '', '', 'tro clid: hsq004393', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'fkbp7_clid_hsq037241', 'input',  NULL , '0', 'size=10', '', '', 'fkbp7 clid: hsq037241', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'wdr72_clid_hsq009730', 'input',  NULL , '0', 'size=10', '', '', 'wdr72 clid: hsq009730', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_dal1', 'input',  NULL , '0', 'size=10', '', '', 'tma_dal1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_drosha', 'input',  NULL , '0', 'size=10', '', '', 'tma_drosha', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_tgfb1', 'input',  NULL , '0', 'size=10', '', '', 'tma_tgfb1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_foxp3', 'input',  NULL , '0', 'size=10', '', '', 'tma_foxp3', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_cd20', 'input',  NULL , '0', 'size=10', '', '', 'tma_cd20', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_tia1', 'input',  NULL , '0', 'size=10', '', '', 'tma_tia1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_hif1_intensity', 'input',  NULL , '0', 'size=10', '', '', 'tma_hif1 intensity', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_hif1_percent', 'input',  NULL , '0', 'size=10', '', '', 'tma_hif1 percent', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_hif1_irs', 'input',  NULL , '0', 'size=10', '', '', 'tma_hif1 irs', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ccl28_intensity', 'input',  NULL , '0', 'size=10', '', '', 'tma_ccl28 intensity', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ccl28_percent', 'input',  NULL , '0', 'size=10', '', '', 'tma_ccl28 percent', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ccl28_irs', 'input',  NULL , '0', 'size=10', '', '', 'tma_ccl28 irs', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'kp_ir_pmol_l', 'input',  NULL , '0', 'size=10', '', '', 'kp_ir pmol_l', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'pde5a_expression_data', 'input',  NULL , '0', 'size=10', '', '', 'pde5a expression data', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_secretory_component_pigr', 'input',  NULL , '0', 'size=10', '', '', 'tma_secretory component_pigr', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_s100a1', 'input',  NULL , '0', 'size=10', '', '', 'tma_s100a1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_dicer', 'input',  NULL , '0', 'size=10', '', '', 'tma_dicer', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_p53_rescore', 'input',  NULL , '0', 'size=10', '', '', 'tma_p53 rescore', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_tff3', 'input',  NULL , '0', 'size=10', '', '', 'tma_tff3', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ps6rp', 'input',  NULL , '0', 'size=10', '', '', 'tma_ps6rp', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_dkk1', 'input',  NULL , '0', 'size=10', '', '', 'tma_dkk1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_cd8', 'input',  NULL , '0', 'size=10', '', '', 'tma_cd8', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_foxl2', 'input',  NULL , '0', 'size=10', '', '', 'tma_foxl2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_hnf1b_restain', 'input',  NULL , '0', 'size=10', '', '', 'tma_hnf1b restain', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_mdm2_restain_08.05.09', 'input',  NULL , '0', 'size=10', '', '', 'tma_mdm2 restain 08.05.09', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_phosphoeif4e', 'input',  NULL , '0', 'size=10', '', '', 'tma_phosphoeif4e', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_arid1a', 'input',  NULL , '0', 'size=10', '', '', 'tma_arid1a', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_opn', 'input',  NULL , '0', 'size=10', '', '', 'tma_opn', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ezh2', 'input',  NULL , '0', 'size=10', '', '', 'tma_ezh2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_hif1a', 'input',  NULL , '0', 'size=10', '', '', 'tma_hif1a', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_pstat', 'input',  NULL , '0', 'size=10', '', '', 'tma_pstat', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_lyn', 'input',  NULL , '0', 'size=10', '', '', 'tma_lyn', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_laminin_rp_score', 'input',  NULL , '0', 'size=10', '', '', 'tma_laminin rp score', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_laminin_rp_vessels', 'input',  NULL , '0', 'size=10', '', '', 'tma_laminin rp vessels', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_pcad_percent_positive', 'input',  NULL , '0', 'size=10', '', '', 'tma_pcad percent positive', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_pcad_intensity', 'input',  NULL , '0', 'size=10', '', '', 'tma_pcad intensity', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_numb', 'input',  NULL , '0', 'size=10', '', '', 'tma_numb', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_mps1_mean_percent', 'input',  NULL , '0', 'size=10', '', '', 'tma_mps1 mean percent', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_mps1_max_percent', 'input',  NULL , '0', 'size=10', '', '', 'tma_mps1 max percent', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_mps1_intensity', 'input',  NULL , '0', 'size=10', '', '', 'tma_mps1 intensity', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_mps1_nuclear_staining', 'input',  NULL , '0', 'size=10', '', '', 'tma_mps1 nuclear staining', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'brca1', 'input',  NULL , '0', 'size=10', '', '', 'brca1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cd8_vgh', 'input',  NULL , '0', 'size=10', '', '', 'cd8 vgh', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cd8_victoria', 'input',  NULL , '0', 'size=10', '', '', 'cd8 victoria', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cd3_victoria', 'input',  NULL , '0', 'size=10', '', '', 'cd3 victoria', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cd3_vgh', 'input',  NULL , '0', 'size=10', '', '', 'cd3 vgh', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'foxp3_victoria', 'input',  NULL , '0', 'size=10', '', '', 'foxp3 victoria', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tia1_victoria', 'input',  NULL , '0', 'size=10', '', '', 'tia1 victoria', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cd20_victoria', 'input',  NULL , '0', 'size=10', '', '', 'cd20 victoria', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', '10_007_core_id', 'input',  NULL , '0', 'size=10', '', '', '10_007 core id', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_ephb4', 'input',  NULL , '0', 'size=10', '', '', 'tma_ephb4', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_survivin', 'input',  NULL , '0', 'size=10', '', '', 'tma_survivin', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'mdm2', 'input',  NULL , '0', 'size=10', '', '', 'mdm2', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'ndrg1', 'input',  NULL , '0', 'size=10', '', '', 'ndrg1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'serbp1', 'input',  NULL , '0', 'size=10', '', '', 'serbp1', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'anxa4', 'input',  NULL , '0', 'size=10', '', '', 'anxa4', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'p10', 'input',  NULL , '0', 'size=10', '', '', 'p10', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'p53', 'input',  NULL , '0', 'size=10', '', '', 'p53', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cycline', 'input',  NULL , '0', 'size=10', '', '', 'cycline', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'p21', 'input',  NULL , '0', 'size=10', '', '', 'p21', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'p27', 'input',  NULL , '0', 'size=10', '', '', 'p27', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'p16', 'input',  NULL , '0', 'size=10', '', '', 'p16', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'pakt', 'input',  NULL , '0', 'size=10', '', '', 'pakt', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cd8_vgh_rescore', 'input',  NULL , '0', 'size=10', '', '', 'cd8 vgh rescore', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cd8_victoria_rescore', 'input',  NULL , '0', 'size=10', '', '', 'cd8 victoria rescore', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cd3_victoria_rescore', 'input',  NULL , '0', 'size=10', '', '', 'cd3 victoria rescore', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'cd3_vgh_rescore', 'input',  NULL , '0', 'size=10', '', '', 'cd3 vgh rescore', ''), 
('Clinicalannotation', 'EventDetail', 'ovcare_ed_lab_experimental_results', 'tma_nkap', 'input',  NULL , '0', 'size=10', '', '', 'tma_nkap', ''); 

SET @structure_id = (SELECT id FROM structures WHERE alias = 'ovcare_ed_lab_experimental_results');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca1_germline_nuc_acid'), '1', '101', 'results', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca1_germline_amino_acid'), '1', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca1_somatic_nuc_acid'), '1', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca1_vus'), '1', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca2_germline_nuc_acid'), '1', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca2_germline_amino_acid'), '1', '106', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca2_somatic_nuc_acid'), '1', '107', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca2_vus'), '1', '108', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca1_loh'), '1', '109', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca2_loh'), '1', '110', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca1_hypermethylation'), '1', '111', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca1_rna'), '1', '112', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca2_rna'), '1', '113', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='powerplex'), '1', '114', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_wt1'), '1', '115', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_p21'), '1', '116', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_p53'), '1', '117', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_cyclin_d1'), '1', '118', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_brca1'), '1', '119', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_p27'), '1', '120', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_eef1a2'), '1', '121', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_cycline'), '1', '122', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_ecad'), '1', '123', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_e2f1'), '1', '124', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_p63'), '1', '125', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_p16'), '1', '126', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_egfr'), '1', '127', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_pr'), '1', '128', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_er'), '1', '129', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_her2'), '1', '130', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_cd_3'), '1', '131', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_cd_117'), '1', '132', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_foxp3'), '1', '133', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_b_catenin_n'), '1', '134', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_b_catenin_m'), '1', '135', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_c_myc_position128820745'), '1', '136', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_pik3ca'), '1', '137', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_qrt_pcr_pik3ca'), '1', '138', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_qrt_pcr_pten'), '1', '139', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_qrt_pcr_id4_rna'), '1', '140', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_ar'), '1', '141', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='08_001_core_id'), '1', '142', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_blocks'), '1', '143', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ret'), '1', '144', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_fascin'), '1', '145', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_wt1'), '1', '146', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_p53'), '1', '147', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_p16'), '1', '148', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_imp3'), '1', '149', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_trka'), '1', '150', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_trkb'), '1', '151', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_c_myc_position128822436'), '1', '152', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_c_myc_mean'), '1', '153', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_c_myc_sd'), '1', '154', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_c_myc_hebo_mrna_row1'), '1', '155', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_c_myc_hebo_mrna_row2'), '1', '156', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_c_myc_hebo_mrna_mean'), '1', '157', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_c_myc_hebo_mrna_sd'), '1', '158', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_imp3'), '1', '159', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_imp3_bin'), '1', '160', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_imp3_hebo_mrna'), '1', '161', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_hace1'), '1', '162', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_qrt_pcr_hace1'), '1', '163', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_egfr'), '1', '164', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_birc6'), '1', '165', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_cyclind1'), '1', '166', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_emsy_position75861572'), '1', '167', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_emsy_position75921347'), '1', '168', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_znf217_position51632374'), '1', '169', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_emsy_mean'), '1', '170', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_mip_emsy_sd'), '1', '171', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_cmyc'), '1', '172', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_vegfr2'), '1', '173', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_pdgfr_beta'), '1', '174', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'); 

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_mras'), '2', '201', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_nasp'), '2', '202', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_rb'), '2', '203', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_vimentin'), '2', '204', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ckit'), '2', '205', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_kiss1'), '2', '206', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_e_cadherin'), '2', '207', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_hif1_alpha'), '2', '208', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_pthlh'), '2', '209', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ki67'), '2', '210', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_s100'), '2', '211', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_agr2_43'), '2', '212', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='spry2_clid_hsq035516'), '2', '213', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='spry4_clid_hsq027862'), '2', '214', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='spry1_clid_hsq043924'), '2', '215', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='spry1_clid_hsq011236'), '2', '216', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='spry1_clid_hsq043441'), '2', '217', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='ereg_clid_hsq025201'), '2', '218', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='erbb3_clid_hsq001349'), '2', '219', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='areg_clid_hsq045253'), '2', '220', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='errfi1_clid_hsq001603'), '2', '221', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='egfr_clid_hsq038313'), '2', '222', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='egfr_clid_hsq010863'), '2', '223', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='btc_clid_hsq035992'), '2', '224', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_apoj'), '2', '225', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_capg164'), '2', '226', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_he4'), '2', '227', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_hsp10'), '2', '228', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_pigr'), '2', '229', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_pkm2'), '2', '230', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='pde5a_clid_hsq039972'), '2', '231', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_cd74'), '2', '232', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_mif'), '2', '233', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='mif_clid_hsq038688'), '2', '234', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cd74_clid_hsq040723'), '2', '235', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cd74_clid_hsq045359'), '2', '236', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_gpr54'), '2', '237', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_cd44v6'), '2', '238', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_hacel_sorensen'), '2', '239', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_hnf_r_soslow'), '2', '240', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_gdf15'), '2', '241', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ogp'), '2', '242', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_pax8'), '2', '243', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_mammaglobin_b'), '2', '244', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_er'), '2', '245', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_epcam'), '2', '246', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_beta_catenin_nuclear'), '2', '247', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_mesothelin'), '2', '248', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_muc6'), '2', '249', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_muc5'), '2', '250', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_pten'), '2', '251', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_skp2'), '2', '252', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_her2'), '2', '253', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_mdm2'), '2', '254', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_nherf1'), '2', '255', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ezrin'), '2', '256', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_pax2'), '2', '257', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_pr'), '2', '258', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_podocalyxin'), '2', '259', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_hdac1'), '2', '260', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ca125'), '2', '261', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_k_cadherin'), '2', '262', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_p21'), '2', '263', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_cd200'), '2', '264', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_mmp7'), '2', '265', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='itgb7_clid_hsq031618'), '2', '266', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='ccl28_clid_hsq013417'), '2', '267', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tro_clid_hsq006530'), '2', '268', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tro_clid_hsq004393'), '2', '269', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='fkbp7_clid_hsq037241'), '2', '270', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='wdr72_clid_hsq009730'), '2', '271', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_dal1'), '2', '272', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_drosha'), '2', '273', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_tgfb1'), '2', '274', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_foxp3'), '2', '275', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_cd20'), '2', '276', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_tia1'), '2', '277', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_hif1_intensity'), '2', '278', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_hif1_percent'), '2', '279', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_hif1_irs'), '2', '280', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ccl28_intensity'), '2', '281', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ccl28_percent'), '2', '282', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ccl28_irs'), '2', '283', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_phosphoeif4e'), '2', '284', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='kp_ir_pmol_l'), '3', '301', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='pde5a_expression_data'), '3', '302', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_secretory_component_pigr'), '3', '303', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_s100a1'), '3', '304', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_dicer'), '3', '305', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_p53_rescore'), '3', '306', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_tff3'), '3', '307', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ps6rp'), '3', '308', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_dkk1'), '3', '309', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_cd8'), '3', '310', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_foxl2'), '3', '311', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_hnf1b_restain'), '3', '312', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_mdm2_restain_08.05.09'), '3', '313', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_arid1a'), '3', '314', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_opn'), '3', '315', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ezh2'), '3', '316', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_hif1a'), '3', '317', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_pstat'), '3', '318', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_lyn'), '3', '319', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_laminin_rp_score'), '3', '320', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_laminin_rp_vessels'), '3', '321', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_pcad_percent_positive'), '3', '322', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_pcad_intensity'), '3', '323', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_numb'), '3', '324', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_mps1_mean_percent'), '3', '325', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_mps1_max_percent'), '3', '326', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_mps1_intensity'), '3', '327', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_mps1_nuclear_staining'), '3', '328', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca1'), '3', '329', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cd8_vgh'), '3', '330', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cd8_victoria'), '3', '331', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cd3_victoria'), '3', '332', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cd3_vgh'), '3', '333', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='foxp3_victoria'), '3', '334', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tia1_victoria'), '3', '335', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cd20_victoria'), '3', '336', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='10_007_core_id'), '3', '337', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_ephb4'), '3', '338', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_survivin'), '3', '339', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='mdm2'), '3', '340', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='ndrg1'), '3', '341', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='serbp1'), '3', '342', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='anxa4'), '3', '343', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='p10'), '3', '344', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='p53'), '3', '345', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cycline'), '3', '346', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='p21'), '3', '347', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='p27'), '3', '348', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='p16'), '3', '349', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='pakt'), '3', '350', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cd8_vgh_rescore'), '3', '351', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cd8_victoria_rescore'), '3', '352', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cd3_victoria_rescore'), '3', '353', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='cd3_vgh_rescore'), '3', '354', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='tma_nkap'), '3', '355', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='mda_cmyc_mean'), '4', '401', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='mda_cmyc_sd'), '4', '402', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='mda_cmyc_replicate_1'), '4', '403', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='mda_cmyc_replicate_2'), '4', '404', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca_array_pakt'), '4', '405', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
(@structure_id, (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_lab_experimental_results' AND `field`='brca1_somatic_amino_acid'), '4', '406', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_fields SET field = 'tma_mdm2_restain_08_05_09' WHERE field = 'tma_mdm2_restain_08.05.09';

ALTER TABLE `ovcare_ed_lab_experimental_results` 
  CHANGE `tma_mdm2_restain_08.05.09` `tma_mdm2_restain_08_05_09` varchar(50) DEFAULT NULL;
ALTER TABLE `ovcare_ed_lab_experimental_results_revs`
  CHANGE `tma_mdm2_restain_08.05.09` `tma_mdm2_restain_08_05_09` varchar(50) DEFAULT NULL;

INSERT IGNORE INTO i18n (id,en) VALUES
('results','Results'),
('brca1 germline nuc acid','BRCA1 Germline Nuc Acid'),
('brca1 germline amino acid','BRCA1 Germline Amino Acid'),
('brca1 somatic nuc acid','BRCA1 Somatic Nuc Acid'),
('brca1 vus','BRCA1 VUS'),
('brca2 germline nuc acid','BRCA2 Germline Nuc Acid'),
('brca2 germline amino acid','BRCA2 Germline Amino Acid'),
('brca2 somatic nuc acid','BRCA2 Somatic Nuc Acid'),
('brca2 vus','BRCA2 VUS'),
('brca1 loh','BRCA1 LOH'),
('brca2 loh','BRCA2 LOH'),
('brca1 hypermethylation','BRCA1 Hypermethylation'),
('brca1 rna','BRCA1 RNA'),
('brca2 rna','BRCA2 RNA'),
('powerplex','Powerplex'),
('brca array wt1','BRCA Array WT1'),
('brca array p21','BRCA Array p21'),
('brca array p53','BRCA Array p53'),
('brca array cyclin d1','BRCA Array Cyclin D1'),
('brca array brca1','BRCA Array BRCA1'),
('brca array p27','BRCA Array p27'),
('brca array eef1a2','BRCA Array EEF1a2'),
('brca array cycline','BRCA Array CyclinE'),
('brca array ecad','BRCA Array Ecad'),
('brca array e2f1','BRCA Array E2F1'),
('brca array p63','BRCA Array p63'),
('brca array p16','BRCA Array p16'),
('brca array egfr','BRCA Array EGFR'),
('brca array pr','BRCA Array PR'),
('brca array er','BRCA Array ER'),
('brca array her2','BRCA Array HER2'),
('brca array cd 3','BRCA Array CD 3'),
('brca array cd 117','BRCA Array CD 117'),
('brca array foxp3','BRCA Array FOXP3'),
('brca array b_catenin_n','BRCA Array B_Catenin_N'),
('brca array b_catenin_m','BRCA Array B_Catenin_M'),
('brca array mip_c_myc position128820745','BRCA Array MIP_C_Myc Position128820745'),
('brca array mip_c_myc position128822436','BRCA Array MIP_C_Myc Position128822436'),
('brca array mip_c_myc mean','BRCA Array MIP_C_Myc Mean'),
('brca array mip_c_myc sd','BRCA Array MIP_C_Myc SD'),
('brca array mip_c_myc hebo mrna row1','BRCA Array MIP_C_Myc HEBO mRNA Row1'),
('brca array mip_c_myc hebo mrna row2','BRCA Array MIP_C_Myc HEBO mRNA Row2'),
('brca array mip_c_myc hebo mrna mean','BRCA Array MIP_C_Myc HEBO mRNA Mean'),
('brca array mip_c_myc hebo mrna sd','BRCA Array MIP_C_Myc HEBO mRNA SD'),
('brca array mip_pik3ca','BRCA Array MIP_PIK3CA'),
('brca array qrt_pcr_pik3ca','BRCA Array qRT_PCR_PIK3CA'),
('brca array qrt_pcr_pten','BRCA Array qRT_PCR_PTEN'),
('brca array qrt_pcr_id4 rna','BRCA Array qRT_PCR_ID4 RNA'),
('brca array pakt','BRCA Array pAKT'),
('brca1 somatic amino acid','BRCA1 Somatic Amino Acid'),
('brca array ar','BRCA Array AR'),
('08_001 core id','08_001 Core ID'),
('tma blocks','TMA Blocks'),
('tma_ret','TMA_Ret'),
('tma_fascin','TMA_Fascin'),
('tma_wt1','TMA_WT1'),
('tma_p53','TMA_p53'),
('tma_p16','TMA_p16'),
('tma_imp3','TMA_IMP3'),
('tma_trka','TMA_TRKA'),
('tma_trkb','TMA_TRKB'),
('brca array mip_imp3','BRCA Array MIP_IMP3'),
('brca array mip_imp3 bin','BRCA Array MIP_IMP3 Bin'),
('brca array mip_imp3 hebo mrna','BRCA Array MIP_IMP3 HEBO mRNA'),
('brca array mip_hace1','BRCA Array MIP_Hace1'),
('brca array qrt_pcr_hace1','BRCA Array qRT_PCR_Hace1'),
('tma_egfr','TMA_EGFR'),
('tma_birc6','TMA_BIRC6'),
('tma_cyclind1','TMA_CyclinD1'),
('brca array mip_emsy position75861572','BRCA Array MIP_EMSY Position75861572'),
('brca array mip_emsy position75921347','BRCA Array MIP_EMSY Position75921347'),
('brca array znf217 position51632374','BRCA Array ZNF217 Position51632374'),
('brca array mip_emsy mean','BRCA Array MIP_EMSY Mean'),
('brca array mip_emsy sd','BRCA Array MIP_EMSY SD'),
('mda cmyc mean','MDA CMyc Mean'),
('mda cmyc sd','MDA CMyc SD'),
('mda cmyc replicate 1','MDA CMyc Replicate 1'),
('mda cmyc replicate 2','MDA CMyc Replicate 2'),
('tma_cmyc','TMA_CMyc'),
('tma_vegfr2','TMA_VEGFR2'),
('tma_pdgfr beta','TMA_PDGFR Beta'),
('tma_mras','TMA_MRAS'),
('tma_nasp','TMA_NASP'),
('tma_rb','TMA_Rb'),
('tma_vimentin','TMA_Vimentin'),
('tma_ckit','TMA_cKit'),
('tma_kiss1','TMA_KISS1'),
('tma_e_cadherin','TMA_E_Cadherin'),
('tma_hif1 alpha','TMA_HIF1 Alpha'),
('tma_pthlh','TMA_PTHLH'),
('tma_ki67','TMA_Ki67'),
('tma_s100','TMA_S100'),
('tma_agr2_43','TMA_AGR2_43'),
('spry2 clid: hsq035516','SPRY2 CLID: hSQ035516'),
('spry4 clid: hsq027862','SPRY4 CLID: hSQ027862'),
('spry1 clid: hsq043924','SPRY1 CLID: hSQ043924'),
('spry1 clid: hsq011236','SPRY1 CLID: hSQ011236'),
('spry1 clid: hsq043441','SPRY1 CLID: hSQ043441'),
('ereg clid: hsq025201','EREG CLID: hSQ025201'),
('erbb3 clid: hsq001349','ERBB3 CLID: hSQ001349'),
('areg clid: hsq045253','AREG CLID: hSQ045253'),
('errfi1 clid: hsq001603','ERRFI1 CLID: hSQ001603'),
('egfr clid: hsq038313','EGFR CLID: hSQ038313'),
('egfr clid: hsq010863','EGFR CLID: hSQ010863'),
('btc clid: hsq035992','BTC CLID: hSQ035992'),
('tma_apoj','TMA_APOJ'),
('tma_capg164','TMA_CAPG164'),
('tma_he4','TMA_HE4'),
('tma_hsp10','TMA_HSP10'),
('tma_pigr','TMA_PIGR'),
('tma_pkm2','TMA_PKM2'),
('pde5a clid: hsq039972','PDE5A CLID: hSQ039972'),
('tma_cd74','TMA_CD74'),
('tma_mif','TMA_MIF'),
('mif clid: hsq038688','MIF CLID: hSQ038688'),
('cd74 clid: hsq040723','CD74 CLID: hSQ040723'),
('cd74 clid: hsq045359','CD74 CLID: hSQ045359'),
('tma_gpr54','TMA_GPR54'),
('tma_cd44v6','TMA_CD44v6'),
('tma_hacel_sorensen','TMA_Hacel_Sorensen'),
('tma_hnf_r_soslow','TMA_HNF_R_Soslow'),
('tma_gdf15','TMA_GDF15'),
('tma_ogp','TMA_OGP'),
('tma_pax8','TMA_PAX8'),
('tma_mammaglobin b','TMA_Mammaglobin B'),
('tma_er','TMA_ER'),
('tma_epcam','TMA_EpCam'),
('tma_beta_catenin nuclear','TMA_Beta_Catenin Nuclear'),
('tma_mesothelin','TMA_Mesothelin'),
('tma_muc6','TMA_MUC6'),
('tma_muc5','TMA_MUC5'),
('tma_pten','TMA_PTEN'),
('tma_skp2','TMA_SKP2'),
('tma_her2','TMA_HER2'),
('tma_mdm2','TMA_MDM2'),
('tma_nherf1','TMA_NHERF1'),
('tma_ezrin','TMA_Ezrin'),
('tma_pax2','TMA_PAX2'),
('tma_pr','TMA_PR'),
('tma_podocalyxin','TMA_Podocalyxin'),
('tma_hdac1','TMA_HDAC1'),
('tma_ca125','TMA_CA125'),
('tma_k_cadherin','TMA_K_Cadherin'),
('tma_p21','TMA_p21'),
('tma_cd200','TMA_CD200'),
('tma_mmp7','TMA_MMP7'),
('itgb7 clid: hsq031618','ITGB7 CLID: hSQ031618'),
('ccl28 clid: hsq013417','CCL28 CLID: hSQ013417'),
('tro clid: hsq006530','TRO CLID: hSQ006530'),
('tro clid: hsq004393','TRO CLID: hSQ004393'),
('fkbp7 clid: hsq037241','FKBP7 CLID: hSQ037241'),
('wdr72 clid: hsq009730','WDR72 CLID: hSQ009730'),
('tma_dal1','TMA_Dal1'),
('tma_drosha','TMA_Drosha'),
('tma_tgfb1','TMA_TGFB1'),
('tma_foxp3','TMA_FoxP3'),
('tma_cd20','TMA_CD20'),
('tma_tia1','TMA_TIA1'),
('tma_hif1 intensity','TMA_HIF1 Intensity'),
('tma_hif1 percent','TMA_HIF1 Percent'),
('tma_hif1 irs','TMA_HIF1 IRS'),
('tma_ccl28 intensity','TMA_CCL28 Intensity'),
('tma_ccl28 percent','TMA_CCL28 Percent'),
('tma_ccl28 irs','TMA_CCL28 IRS'),
('kp_ir pmol_l','KP_IR pmol_l'),
('pde5a expression data','PDE5a Expression Data'),
('tma_secretory component_pigr','TMA_Secretory Component_PIGR'),
('tma_s100a1','TMA_S100A1'),
('tma_dicer','TMA_Dicer'),
('tma_p53 rescore','TMA_p53 Rescore'),
('tma_tff3','TMA_TFF3'),
('tma_ps6rp','TMA_pS6rp'),
('tma_dkk1','TMA_DKK1'),
('tma_cd8','TMA_CD8'),
('tma_foxl2','TMA_FOXL2'),
('tma_hnf1b restain','TMA_HNF1B Restain'),
('tma_mdm2 restain 08.05.09','TMA_MDM2 restain 08.05.09'),
('tma_phosphoeif4e','TMA_PhosphoEIF4E'),
('tma_arid1a','TMA_ARID1A'),
('tma_opn','TMA_OPN'),
('tma_ezh2','TMA_EZH2'),
('tma_hif1a','TMA_HIF1A'),
('tma_pstat','TMA_PSTAT'),
('tma_lyn','TMA_LYN'),
('tma_laminin rp score','TMA_Laminin RP Score'),
('tma_laminin rp vessels','TMA_Laminin RP Vessels'),
('tma_pcad percent positive','TMA_pcad Percent Positive'),
('tma_pcad intensity','TMA_pcad Intensity'),
('tma_numb','TMA_NUMB'),
('tma_mps1 mean percent','TMA_MPS1 Mean Percent'),
('tma_mps1 max percent','TMA_MPS1 Max Percent'),
('tma_mps1 intensity','TMA_MPS1 Intensity'),
('tma_mps1 nuclear staining','TMA_MPS1 Nuclear Staining'),
('brca1','BRCA1'),
('cd8 vgh','CD8 VGH'),
('cd8 victoria','CD8 Victoria'),
('cd3 victoria','CD3 Victoria'),
('cd3 vgh','CD3 VGH'),
('foxp3 victoria','FoxP3 Victoria'),
('tia1 victoria','TIA1 Victoria'),
('cd20 victoria','CD20 Victoria'),
('10_007 core id','10_007 Core ID'),
('tma_ephb4','TMA_EPHB4'),
('tma_survivin','TMA_Survivin'),
('mdm2','MDM2'),
('ndrg1','NDRG1'),
('serbp1','SERBP1'),
('anxa4','ANXA4'),
('p10','p10'),
('p53','p53'),
('cycline','CyclinE'),
('p21','p21'),
('p27','p27'),
('p16','p16'),
('pakt','pAKT'),
('cd8 vgh rescore','CD8 VGH Rescore'),
('cd8 victoria rescore','CD8 Victoria Rescore'),
('cd3 victoria rescore','CD3 Victoria Rescore'),
('cd3 vgh rescore','CD3 VGH Rescore'),
('tma_nkap','TMA_NKAP');


-- **** OTHER ****

UPDATE menus SET flag_active = 0
WHERE use_link like '/clinicalannotation/family_histories%'
OR use_link like '/clinicalannotation/participant_messages%'
OR use_link like '/clinicalannotation/participant_contacts%'
OR use_link like '/clinicalannotation/reproductive_histories%';


-- -------------------------------------------------------------------------------- 
-- INVENTORY MANAGEMENT
-- --------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(131, 25, 4, 142, 143, 141, 144, 130, 101, 102, 140);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(33);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(34);

UPDATE banks SET name = 'OvCaRe',  description = '' WHERE id = 1;

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'sop_master_id');


-- **** COLLECTION ****

ALTER TABLE collections 
   ADD COLUMN `ovcare_collection_type` varchar(50) AFTER collection_datetime_accuracy;
ALTER TABLE collections_revs 
   ADD COLUMN `ovcare_collection_type` varchar(50) AFTER collection_datetime_accuracy;

INSERT INTO `structure_permissible_values_custom_controls` VALUES (null,'ovcare collection types',1,50);
INSERT INTO `structure_value_domains` VALUES (null,'ovcare_collection_types','open','','StructurePermissibleValuesCustom::getCustomDropdown(\'ovcare collection types\')');
SET @cont_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'ovcare collection types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
('pre-surgical', 'PreSurgical', '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
('pre-surgical', 'PreSurgical', '', 1, @cont_id, @id, NOW());
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
('post-surgical', 'PostSurgical', '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
('post-surgical', 'PostSurgical', '', 1, @cont_id, @id, NOW());
INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `flag_confidential`) VALUES
('Inventorymanagement', 'Collection', 'collections', 'ovcare_collection_type', 'ovcare collection type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'ovcare_collection_types'), '', 0),
('Inventorymanagement', 'ViewAliquot', '', 'ovcare_collection_type', 'ovcare collection type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'ovcare_collection_types'), '', 0),
('Inventorymanagement', 'ViewCollection', '', 'ovcare_collection_type', 'ovcare collection type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'ovcare_collection_types'), '', 0),
('Inventorymanagement', 'ViewSample', '', 'ovcare_collection_type', 'ovcare collection type', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'ovcare_collection_types'), '', 0);
SET @model = 'Collection';
INSERT INTO structure_formats (structure_id, structure_field_id, display_column, display_order, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary)
(SELECT structure_id, (SELECT id FROM structure_fields WHERE field = 'ovcare_collection_type' AND model = @model), display_column, display_order, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary
FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'acquisition_label' AND model = @model));
SET @model = 'ViewAliquot';
INSERT INTO structure_formats (structure_id, structure_field_id, display_column, display_order, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary)
(SELECT structure_id, (SELECT id FROM structure_fields WHERE field = 'ovcare_collection_type' AND model = @model), display_column, display_order, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary
FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'acquisition_label' AND model = @model));
SET @model = 'ViewCollection';
INSERT INTO structure_formats (structure_id, structure_field_id, display_column, display_order, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary)
(SELECT structure_id, (SELECT id FROM structure_fields WHERE field = 'ovcare_collection_type' AND model = @model), display_column, display_order, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary
FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'acquisition_label' AND model = @model));
SET @model = 'ViewSample';
INSERT INTO structure_formats (structure_id, structure_field_id, display_column, display_order, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary)
(SELECT structure_id, (SELECT id FROM structure_fields WHERE field = 'ovcare_collection_type' AND model = @model), display_column, display_order, flag_add, flag_add_readonly, flag_edit, flag_edit_readonly, flag_search, flag_search_readonly, flag_addgrid, flag_addgrid_readonly, flag_editgrid, flag_editgrid_readonly, flag_batchedit, flag_batchedit_readonly, flag_index, flag_detail, flag_summary
FROM structure_formats WHERE structure_field_id = (SELECT id FROM structure_fields WHERE field = 'acquisition_label' AND model = @model));

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'acquisition_label');

UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='ovcare_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_collection_types') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='ovcare_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_collection_types') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='ovcare_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_collection_types') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='ovcare_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_collection_types') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='5' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='ovcare_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_collection_types') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='50' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='30' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='ovcare_collection_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_collection_types') AND `flag_confidential`='0');

DROP VIEW view_aliquots;
CREATE VIEW view_aliquots AS 
SELECT 
al.id AS aliquot_master_id,
al.sample_master_id AS sample_master_id,
al.collection_id AS collection_id, 
col.bank_id, 
al.storage_master_id AS storage_master_id,
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 
col.ovcare_collection_type,

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

al.created

FROM aliquot_masters AS al
INNER JOIN aliquot_controls AS alc ON al.aliquot_control_id = alc.id
INNER JOIN sample_masters AS samp ON samp.id = al.sample_master_id AND samp.deleted != 1
INNER JOIN sample_controls AS sampc ON samp.sample_control_id = sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id=parent_sampc.id
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
LEFT JOIN storage_masters AS stor ON stor.id = al.storage_master_id AND stor.deleted != 1
WHERE al.deleted != 1;

DROP VIEW view_samples;
CREATE VIEW view_samples AS 
SELECT 
samp.id AS sample_master_id,
samp.parent_id AS parent_sample_id,
samp.initial_specimen_sample_id,
samp.collection_id AS collection_id,

col.bank_id, 
col.sop_master_id, 
link.participant_id, 
link.diagnosis_master_id, 
link.consent_master_id,

part.participant_identifier, 

col.acquisition_label, 
col.ovcare_collection_type,

specimenc.sample_type AS initial_specimen_sample_type,
specimen.sample_control_id AS initial_specimen_sample_control_id,
parent_sampc.sample_type AS parent_sample_type,
parent_samp.sample_control_id AS parent_sample_control_id,
sampc.sample_type,
samp.sample_control_id,
samp.sample_code,
sampc.sample_category

FROM sample_masters as samp
INNER JOIN sample_controls as sampc ON samp.sample_control_id=sampc.id
INNER JOIN collections AS col ON col.id = samp.collection_id AND col.deleted != 1
LEFT JOIN sample_masters AS specimen ON samp.initial_specimen_sample_id = specimen.id AND specimen.deleted != 1
LEFT JOIN sample_controls AS specimenc ON specimen.sample_control_id = specimenc.id
LEFT JOIN sample_masters AS parent_samp ON samp.parent_id = parent_samp.id AND parent_samp.deleted != 1
LEFT JOIN sample_controls AS parent_sampc ON parent_samp.sample_control_id = parent_sampc.id
LEFT JOIN clinical_collection_links AS link ON col.id = link.collection_id AND link.deleted != 1
LEFT JOIN participants AS part ON link.participant_id = part.id AND part.deleted != 1
WHERE samp.deleted != 1;

DROP TABLE IF EXISTS `view_collections`;
DROP VIEW IF EXISTS `view_collections`;
CREATE VIEW `view_collections` AS select `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,`link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` AS `consent_master_id`,`part`.`participant_identifier` AS `participant_identifier`, `col`.`ovcare_collection_type` AS `ovcare_collection_type`, `col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` AS `collection_site`,`col`.`collection_datetime` AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,`col`.`collection_property` AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,`col`.`deleted` AS `deleted`,`banks`.`name` AS `bank_name`,`col`.`created` AS `created` from (((`collections` `col` left join `clinical_collection_links` `link` on(((`col`.`id` = `link`.`collection_id`) and (`link`.`deleted` <> 1)))) left join `participants` `part` on(((`link`.`participant_id` = `part`.`id`) and (`part`.`deleted` <> 1)))) left join `banks` on(((`col`.`bank_id` = `banks`.`id`) and (`banks`.`deleted` <> 1)))) where (`col`.`deleted` <> 1);

INSERT INTO i18n (id,en,fr) VALUES ('ovcare collection type', 'Type', '');

INSERT INTO `structure_validations` (`id`, `structure_field_id`, `rule`, `on_action`, `language_message`) VALUES
(null, (SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='bank_id'), 'notEmpty', '', '');


-- **** SAMPLE ****

SET @cont_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'laboratory staff');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
('steve kalloger', 'Steve Kalloger', '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
('steve kalloger', 'Steve Kalloger', '', 1, @cont_id, @id, NOW());

-- Tissue --

INSERT INTO `structure_permissible_values_custom_controls` VALUES (null,'ovcare tissue sources',1,50);
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'ovcare tissue sources\')' WHERE domain_name = 'tissue_source_list';
SET @cont_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'ovcare tissue sources');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
('ovary', 'Ovary', '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
('ovary', 'Ovary', '', 1, @cont_id, @id, NOW());
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
('endometrial', 'Endometrial', '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
('endometrial', 'Endometrial', '', 1, @cont_id, @id, NOW());
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
('omentum', 'Omentum', '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
('omentum', 'Omentum', '', 1, @cont_id, @id, NOW());

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'patho_dpt_block_code');

-- DNA RNA --

UPDATE sample_controls SET form_alias = CONCAT(form_alias,',ovcare_dna_rna_extract_method') WHERE sample_type IN ('dna','rna');

ALTER TABLE sd_der_dnas 
	ADD COLUMN `ovcare_extraction_method` varchar(50) AFTER sample_master_id,
	ADD COLUMN `ovcare_enzyme_tx` varchar(50) AFTER ovcare_extraction_method;
ALTER TABLE sd_der_dnas_revs 
	ADD COLUMN `ovcare_extraction_method` varchar(50) AFTER sample_master_id,
	ADD COLUMN `ovcare_enzyme_tx` varchar(50) AFTER ovcare_extraction_method;
ALTER TABLE sd_der_rnas 
	ADD COLUMN `ovcare_extraction_method` varchar(50) AFTER sample_master_id,
	ADD COLUMN `ovcare_enzyme_tx` varchar(50) AFTER ovcare_extraction_method;
ALTER TABLE sd_der_rnas_revs 
	ADD COLUMN `ovcare_extraction_method` varchar(50) AFTER sample_master_id,
	ADD COLUMN `ovcare_enzyme_tx` varchar(50) AFTER ovcare_extraction_method;

INSERT INTO `structure_permissible_values_custom_controls` VALUES (null,'ovcare dna rna extraction methods',1,50);
INSERT INTO `structure_value_domains` VALUES (null,'ovcare_dna_rna_extraction_methods','open','','StructurePermissibleValuesCustom::getCustomDropdown(\'ovcare dna rna extraction methods\')');
SET @cont_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'ovcare dna rna extraction methods');
SET @new_val = ('Trizol');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('Phenol Chloroform');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('DNA FFPE Tissue kit');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('RNeasy Kit (Qiagen)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('puregene Kit (Qiagen)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('RNeasy FFPE Kit (Qiagen)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('m48 Kit (Qiagen)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('mirVana (Ambion) ');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('DNeasy Blood & Tissue Kit (Qiagen)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());

INSERT INTO `structure_permissible_values_custom_controls` VALUES (null,'ovcare dna rna enzyme txs',1,50);
INSERT INTO `structure_value_domains` VALUES (null,'ovcare_dna_rna_enzyme_txs','open','','StructurePermissibleValuesCustom::getCustomDropdown(\'ovcare dna rna enzyme txs\')');
SET @cont_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'ovcare dna rna enzyme txs');
SET @new_val = ('None');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('Other');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('RNAse Column');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('RNAse');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('DNAse Column');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('DNAse (Source RNA)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());
SET @new_val = ('RNAse H');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
(LOWER(@new_val), @new_val, '', 1, @cont_id, @id, NOW());

INSERT INTO structures (alias) VALUES ('ovcare_dna_rna_extract_method');
INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `flag_confidential`) VALUES
('Inventorymanagement', 'SampleDetail', '', 'ovcare_extraction_method', 'extraction method', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'ovcare_dna_rna_extraction_methods'), '', 0),
('Inventorymanagement', 'SampleDetail', '', 'ovcare_enzyme_tx', 'enzyme tx', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'ovcare_dna_rna_enzyme_txs'), '', 0);
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias = 'ovcare_dna_rna_extract_method'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field`='ovcare_extraction_method'), '1', '500', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias = 'ovcare_dna_rna_extract_method'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field`='ovcare_enzyme_tx'), '1', '501', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en) VALUES ('extraction method','Extraction Method'),('enzyme tx','Enzyme Tx');


-- **** ALIQUOT ****

UPDATE structure_formats 
SET `flag_add`='0',`flag_add_readonly`='0',`flag_edit`='0',`flag_edit_readonly`='0',`flag_search`='0',`flag_search_readonly`='0',`flag_addgrid`='0',`flag_addgrid_readonly`='0',`flag_editgrid`='0',`flag_editgrid_readonly`='0',`flag_summary`='0',`flag_batchedit`='0',`flag_batchedit_readonly`='0',`flag_index`='0',`flag_detail` = '0'
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'lot_number' AND model = 'AliquotDetail');

-- Tissue tube --

SET @tissue_tube_control_id = (SELECT id from aliquot_controls WHERE aliquot_type = 'tube' and sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue' ));
UPDATE aliquot_controls SET form_alias = CONCAT(form_alias,',ovcare_tissue_tube_storage_method') WHERE id = @tissue_tube_control_id;

ALTER TABLE ad_tubes ADD COLUMN `ovcare_storage_method` varchar(50) AFTER hemolysis_signs;
ALTER TABLE ad_tubes_revs ADD COLUMN `ovcare_storage_method` varchar(50) AFTER hemolysis_signs;

INSERT INTO `structure_permissible_values_custom_controls` VALUES (null,'ovcare tissue tube storage methods',1,50);
INSERT INTO `structure_value_domains` VALUES (null,'ovcare_tissue_tube_storage_methods','open','','StructurePermissibleValuesCustom::getCustomDropdown(\'ovcare tissue tube storage methods\')');
SET @cont_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'ovcare tissue tube storage methods');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
('snap frozen', 'Snap Frozen', '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
('snap frozen', 'Snap Frozen', '', 1, @cont_id, @id, NOW());
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
('ethanol', 'Ethanol', '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
('ethanol', 'Ethanol', '', 1, @cont_id, @id, NOW());
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
('other', 'Other', '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
('other', 'Other', '', 1, @cont_id, @id, NOW());
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) VALUES 
('none (fresh)', 'None (Fresh)', '', 1, @cont_id);
SET @id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs_revs` (`value`, `en`, `fr`, `use_as_input`, `control_id`,`id`, `version_created`) 
VALUES 
('none (fresh)', 'None (Fresh)', '', 1, @cont_id, @id, NOW());

INSERT INTO structures (alias) VALUES ('ovcare_tissue_tube_storage_method');
INSERT INTO `structure_fields` (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `flag_confidential`) VALUES
('Inventorymanagement', 'AliquotDetail', 'ad_tubes', 'ovcare_storage_method', 'storage method', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name = 'ovcare_tissue_tube_storage_methods'), '', 0);
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias = 'ovcare_tissue_tube_storage_method'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='ovcare_storage_method'), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_editgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_tissue_tube_storage_method') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='ovcare_storage_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tissue_tube_storage_methods') AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ('storage method','storage method');


-- **** PATH REVIEW ****

UPDATE specimen_review_controls SET flag_active = 0;
UPDATE aliquot_review_controls SET flag_active = 0;

INSERT INTO `specimen_review_controls` (`sample_control_id`, `aliquot_review_control_id`, `review_type`, `flag_active`, `form_alias`, `detail_tablename`, `databrowser_label`) VALUES
((SELECT id FROM sample_controls WHERE sample_type = 'tissue'), NULL, 'gross image', 1, 'ovcare_spr_tissue_gross_images', 'ovcare_spr_tissue_gross_images', 'tissue|gross image');

CREATE TABLE IF NOT EXISTS `ovcare_spr_tissue_gross_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `specimen_review_master_id` int(11) DEFAULT NULL,
  file_type VARCHAR(5) NOT NULL DEFAULT '',
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_ovcare_spr_tissue_gross_images_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ovcare_spr_tissue_gross_images_revs` (
  `id` int(11) NOT NULL,
  `specimen_review_master_id` int(11) DEFAULT NULL,
  file_type VARCHAR(5) NOT NULL DEFAULT '',
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ovcare_spr_tissue_gross_images`
  ADD CONSTRAINT `FK_ovcare_spr_tissue_gross_images_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('ovcare_spr_tissue_gross_images');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_spr_tissue_gross_images'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='review code' AND `language_tag`=''), '0', '1', '', '1', 'title', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ovcare_spr_tissue_gross_images'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewControl' AND `tablename`='specimen_review_controls' AND `field`='sample_control_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_type_for_review')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen review type' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_spr_tissue_gross_images'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewControl' AND `tablename`='specimen_review_controls' AND `field`='review_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_spr_tissue_gross_images'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='review date' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ovcare_spr_tissue_gross_images'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO i18n (id,en) VALUES ('gross image','Gross Image');

ALTER TABLE ovcare_spr_tissue_gross_images
	ADD COLUMN file_name VARCHAR(250) DEFAULT '' AFTER specimen_review_master_id;
ALTER TABLE ovcare_spr_tissue_gross_images_revs
	ADD COLUMN file_name VARCHAR(250) DEFAULT '' AFTER specimen_review_master_id;
	 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SpecimenReviewDetail', 'ovcare_spr_tissue_gross_images', 'file_name', 'input',  NULL , '0', '', '', '', 'file name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_spr_tissue_gross_images'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ovcare_spr_tissue_gross_images' AND `field`='file_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='file name' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT INTO i18n (id,en) VALUES ('a file with the same file name [%%file_name%%] has already be downloaded','A file with the same file name [%%file_name%%] has already be downloaded!'),('file name','File Name');

-- -------------------------------------------------------------------------------- 
-- TOOLS
-- --------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/sop/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/protocol/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/drug/%';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', '0', '', 'file_input', 'file',  NULL , '0', '', '', '', 'image', ''), 
('', '0', '', 'file_link', 'input',  NULL , '0', '', '', '', 'image', ''); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_spr_tissue_gross_images'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='file_input' AND `type`='file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='image' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_spr_tissue_gross_images'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='file_link' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='image' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'); 

REPLACE INTO i18n (id, en, fr) VALUES
('image', 'Image', 'Image'),
("this is not a valid image file", "This is not a valid image file.", "Ce n'est pas un fichier d'image valide.");

UPDATE structure_fields SET model = 'OvcareFunctionManagement' WHERE field IN ('file_input', 'file_link');

UPDATE structure_formats SET display_column = 2 WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('file_input', 'file_link'));

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimen_review_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='pathologist' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


