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
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('morphology', 'dx_method', 'information_source', 'topography'));

UPDATE structure_formats SET `flag_override_label` = 1, `language_label` = 'who code'
WHERE structure_id = (SELECT id FROM structures WHERE alias = 'dx_primary')
AND structure_field_id = (SELECT id FROM structure_fields WHERE model = 'DiagnosisMaster' AND field = 'icd10_code');

CREATE TABLE IF NOT EXISTS `ovcare_dxd_primaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',

	clinical_history text,
	clinical_diagnosis text,
	
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
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_substage"),  
(SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_substage"),  
(SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_substage"),  
(SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1");

INSERT INTO structures(`alias`) VALUES ('ovcare_dx_primaries');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'clinical_history', 'textarea',  NULL , '0', 'rows=1,cols=30', '', '', 'clinical history', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'clinical_diagnosis', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'clinical diagnosis', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'stage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_stage') , '0', '', '', '', 'stage', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'substage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_substage') , '0', '', '', '', 'substage', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'review_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_review_grade') , '0', '', '', '', 'review grade', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'review_comment', 'textarea',  NULL , '0', 'rows=2,cols=20', '', '', 'review comment', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'review_diagnosis', 'textarea',  NULL , '0', 'rows=2,cols=20', '', '', 'review diagnosis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='clinical_history' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=1,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='clinical history' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='clinical_diagnosis' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='clinical diagnosis' AND `language_tag`=''), '1', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='stage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stage' AND `language_tag`=''), '2', '20', 'staging', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='substage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_substage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='substage' AND `language_tag`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='review_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_review_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='review grade' AND `language_tag`=''), '3', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='review_comment' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=20' AND `default`='' AND `language_help`='' AND `language_label`='review comment' AND `language_tag`=''), '3', '42', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='review_diagnosis' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=20' AND `default`='' AND `language_help`='' AND `language_label`='review diagnosis' AND `language_tag`=''), '3', '40', 'review', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en) VALUES ('clinical diagnosis','Clinical Diagnosis'),('review comment','Review Comment'),('review grade','Review Grade'),('review diagnosis','Review Diagnosis'),('review','Review'),('substage','Substage'),('stage','Stage'),('who code','WHO Code');

ALTER TABLE ovcare_dxd_primaries ADD COLUMN `recurrent_disease` char(1) DEFAULT '' AFTER clinical_diagnosis;
ALTER TABLE ovcare_dxd_primaries_revs ADD COLUMN `recurrent_disease` char(1) DEFAULT '' AFTER clinical_diagnosis;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'recurrent_disease', 'yes_no',  NULL , '0', '', '', '', 'recurrent disease', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='recurrent_disease'), '1', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT INTO i18n (id,en) VALUES ('recurrent disease', 'Recurrent Disease');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE ovcare_dxd_primaries ADD COLUMN `progression_free_time_months` int(7) DEFAULT NULL AFTER recurrent_disease;
ALTER TABLE ovcare_dxd_primaries_revs ADD COLUMN `progression_free_time_months` char(1) DEFAULT NULL AFTER recurrent_disease;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ovcare_dxd_primaries', 'progression_free_time_months', 'integer_positive',  NULL , '0', 'size=6', '', '', 'progression free time months', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_dx_primaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_primaries' AND `field`='progression_free_time_months'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
INSERT INTO i18n (id,en) VALUES ('progression free time months', 'Progression Free Time (Months)');


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

-- **** OTHER ****

UPDATE menus SET flag_active = 0
WHERE use_link like '/clinicalannotation/event_masters%'
OR use_link like '/clinicalannotation/family_histories%'
OR use_link like '/clinicalannotation/participant_messages%'
OR use_link like '/clinicalannotation/participant_contacts%'
OR use_link like '/clinicalannotation/reproductive_histories%'
OR use_link like '/clinicalannotation/event_masters%';














