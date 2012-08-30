
-- Previous forms corrections

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_grade_6to10') ,  `language_label`='gleason total' WHERE model='EventDetail' AND tablename='procure_ed_lab_diagnostic_information_worksheets' AND field='histologic_grade_gleason_total' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_grade_6to10');

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_grade_2to5", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_2to5"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_2to5"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_2to5"), (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_2to5"), (SELECT id FROM structure_permissible_values WHERE value="5" AND language_alias="5"), "5", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_grade_2to5_and_none", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_2to5_and_none"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="2"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_2to5_and_none"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="3"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_2to5_and_none"), (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="4"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_2to5_and_none"), (SELECT id FROM structure_permissible_values WHERE value="5" AND language_alias="5"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_grade_2to5_and_none"), (SELECT id FROM structure_permissible_values WHERE value="none" AND language_alias="none"), "6", "1");

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_grade_2to5')  WHERE model='EventDetail' AND tablename='procure_ed_lab_pathologies' AND field='histologic_grade_primary_pattern' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_grade_1to4');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_grade_2to5')  WHERE model='EventDetail' AND tablename='procure_ed_lab_pathologies' AND field='histologic_grade_secondary_pattern' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_grade_1to4');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_grade_2to5_and_none')  WHERE model='EventDetail' AND tablename='procure_ed_lab_pathologies' AND field='histologic_grade_tertiary_pattern' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='procure_grade_1to4_and_none');

REPLACE INTO i18n (id,en,fr) 
VALUES
('add medications', 'Add Medications', 'Ajouter médicaments'),
('medications', 'Medications', 'Médicaments'),
('histologic grade', 'Histologic Grade', 'Grade histologique'),
('highest percentage of tumoral zone of core','Highest pct of tumoral zone among collected samples',"Pct d'atteinte le plus élevé parmi les prélèvements"),
('number of collected cores',"Number of collected cores","Nombre de zones prélevées"),
('number of cores with cancer',"Number of cores with cancer","Nombre de zones atteintes"),
('gleason total','Gleason Total','Gleason total'),
('report date','Report Date','Date du rapport'),
('margins','Margins','Marges'),
('cannot be assessed','Cannot be assessed','Ne peuvent être évaluées');

ALTER TABLE procure_ed_lab_pathologies ADD COLUMN margins_extensive_base tinyint(1) DEFAULT '0' AFTER margins_extensive_bladder_neck;
ALTER TABLE procure_ed_lab_pathologies_revs ADD COLUMN margins_extensive_base tinyint(1) DEFAULT '0' AFTER margins_extensive_bladder_neck;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lab_pathologies', 'margins_extensive_base', 'checkbox',  NULL , '0', '', '', '', 'base', ''); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_extensive_base'), '3', '90', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_ed_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lab_pathologies' AND `field`='margins_extensive_base' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_form_identification' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='identification' AND `language_tag`=''), '1', '-6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_ed_diagnostic_information_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_form_identification' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='identification' AND `language_tag`=''), '1', '-6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_form_identification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES ("the identification value should be unique","The field 'Identification' must be unique","Le champ 'Identification' doit être unique");

UPDATE structure_fields SET  `language_label`='revised date',  `language_tag`='' WHERE model='ConsentDetail' AND tablename='procure_cd_sigantures' AND field='revised_date' AND `type`='date' AND structure_value_domain  IS NULL ;

-- ===============================================================================================================================================================================
--
-- F1 - Fiche de suivi du patient
--
-- ===============================================================================================================================================================================

UPDATE menus SET flag_active = 0 WHERE id IN ('clin_CAN_27','clin_CAN_33');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'procure', 'clinical', 'procure follow-up worksheet', 1, 'procure_ed_followup_worksheet', 'procure_ed_clinical_followup_worksheets', 0, 'procure follow-up worksheet', 1);

CREATE TABLE IF NOT EXISTS `procure_ed_clinical_followup_worksheets` (
  `id_confirmation_date` date DEFAULT NULL,
  `id_confirmation_date_accuracy` char(1) NOT NULL DEFAULT '',
  `patient_identity_verified` tinyint(1) DEFAULT '0',
  biochemical_recurrence char(1) DEFAULT '',
  clinical_recurrence char(1) DEFAULT '',
  clinical_recurrence_type varchar(50) DEFAULT NULL, 
  clinical_recurrence_site varchar(50) DEFAULT NULL,
  surgery_for_metastases char(1) DEFAULT '', 
  surgery_site varchar(250) DEFAULT NULL, 
  `surgery_date` date DEFAULT NULL,
  `surgery_date_accuracy` char(1) NOT NULL DEFAULT '',
  
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `procure_ed_clinical_followup_worksheets_revs` (
  `id_confirmation_date` date DEFAULT NULL,
  `id_confirmation_date_accuracy` char(1) NOT NULL DEFAULT '',
  `patient_identity_verified` tinyint(1) DEFAULT '0',
  biochemical_recurrence char(1) DEFAULT '',
  clinical_recurrence char(1) DEFAULT '',
  clinical_recurrence_type varchar(50) DEFAULT NULL, 
  clinical_recurrence_site varchar(50) DEFAULT NULL,
  surgery_for_metastases char(1) DEFAULT '', 
  surgery_site varchar(250) DEFAULT NULL, 
  `surgery_date` date DEFAULT NULL,
  `surgery_date_accuracy` char(1) NOT NULL DEFAULT '',
	
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `procure_ed_clinical_followup_worksheets`
  ADD CONSTRAINT `procure_ed_clinical_followup_worksheets_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('procure_ed_followup_worksheet');
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_followup_clinical_recurrence_types", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'procure followup clinical recurrence types\')"),
("procure_followup_clinical_recurrence_sites", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'procure followup clinical recurrence sites\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('procure followup clinical recurrence types', 1, 50),
('procure followup clinical recurrence sites', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'procure followup clinical recurrence types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('local', 'Local', 'Locale', '1', @control_id, NOW(), NOW(), 1, 1),
('regional', 'Regional', 'Régionale', '1', @control_id, NOW(), NOW(), 1, 1),
('distant', 'Distant', 'À distance', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'procure followup clinical recurrence sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('liver', 'Liver', 'Foie', '1', @control_id, NOW(), NOW(), 1, 1),
('lungs', 'Lungs', 'Poumons', '1', @control_id, NOW(), NOW(), 1, 1),
('bones', 'Bones', 'Os', '1', @control_id, NOW(), NOW(), 1, 1),
('others', 'Others', 'Autres', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'patient_identity_verified', 'checkbox',  NULL , '0', '', '', '', 'confirm that the identity of the patient has been verified', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'id_confirmation_date', 'date',  NULL , '0', '', '', '', '', 'date'), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'biochemical_recurrence', 'yes_no',  NULL , '0', '', '', '', 'biochemical recurrence >= 0.2ng/ml', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'clinical_recurrence', 'yes_no',  NULL , '0', '', '', '', 'clinical recurrence', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'clinical_recurrence_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_types') , '0', '', '', '', 'type', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'clinical_recurrence_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_sites') , '0', '', '', '', 'site', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'surgery_for_metastases', 'yes_no',  NULL , '0', '', '', '', 'surgery for metastases', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'surgery_site', 'input',  NULL , '0', '', '', '', 'site', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheets', 'surgery_date', 'date',  NULL , '0', '', '', '', 'date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_form_identification' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='identification' AND `language_tag`=''), '1', '-6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '5', '', '1', 'visite date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='patient_identity_verified' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='id_confirmation_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='date'), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='biochemical_recurrence' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biochemical recurrence >= 0.2ng/ml' AND `language_tag`=''), '1', '11', 'biochemical recurrence', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical recurrence' AND `language_tag`=''), '1', '20', 'clinical recurrence', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='clinical_recurrence_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_clinical_recurrence_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '70', 'comments', '1', 'comments', '0', '', '0', '', '0', '', '1', 'rows=3,cols=30', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='surgery_for_metastases' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surgery for metastases' AND `language_tag`=''), '1', '30', 'surgery', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='surgery_site' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='surgery_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- ********************* DEATH **************************

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='death (follow-up worksheet)' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');

ALTER TABLE participants ADD COLUMN procure_cause_of_death varchar(50) DEFAULT NULL AFTER date_of_death_accuracy;
ALTER TABLE participants_revs ADD COLUMN procure_cause_of_death varchar(50) DEFAULT NULL AFTER date_of_death_accuracy;

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("procure_cause_of_death", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("secondary to prostate cancer", "secondary to prostate cancer"),
("independent of prostate cancer", "independent of prostate cancer"),
("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="secondary to prostate cancer" AND language_alias="secondary to prostate cancer"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="independent of prostate cancer" AND language_alias="independent of prostate cancer"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "3", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_cause_of_death', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_cause_of_death') , '0', '', '', '', 'cause of death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_cause_of_death' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_cause_of_death')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cause of death' AND `language_tag`=''), '3', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- ********************* APS **************************************

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'procure', 'lab', 'procure follow-up worksheet - aps', 1, 'procure_ed_followup_worksheet_aps', 'procure_ed_clinical_followup_worksheet_aps', 0, 'procure follow-up worksheet - aps', 1);

CREATE TABLE IF NOT EXISTS `procure_ed_clinical_followup_worksheet_aps` (
  `total_ngml` decimal(10,2) DEFAULT NULL, 
  followup_event_master_id int(11) DEFAULT NULL,

  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `procure_ed_clinical_followup_worksheet_aps_revs` (
  `total_ngml` decimal(10,2) DEFAULT NULL, 
  followup_event_master_id int(11) DEFAULT NULL,
	
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `procure_ed_clinical_followup_worksheet_aps_revs`
  ADD CONSTRAINT `procure_ed_clinical_followup_worksheet_aps_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`),
  ADD CONSTRAINT `procure_ed_clinical_followup_worksheet_aps_ibfk_2` FOREIGN KEY (`followup_event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('procure_ed_followup_worksheet_aps');

INSERT INTO `structure_value_domains` (`domain_name`, `override`, `category`, `source`) VALUES
('procure_followup_event_master_id', '', '', 'ClinicalAnnotation.EventMaster::getFollowupIdentificationFromId');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_aps', 'total_ngml', 'float_positive',  NULL , '0', 'size=5', '', '', 'total ng/ml', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_aps', 'followup_event_master_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id') , '0', '', '', '', 'follow-up worksheet identification', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_aps'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_aps'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_aps' AND `field`='total_ngml' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='total ng/ml' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_aps'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_aps' AND `field`='followup_event_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='follow-up worksheet identification' AND `language_tag`=''), '1', '-6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_aps'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '70', 'comments', '1', 'comments', '0', '', '0', '', '0', '', '1', 'rows=3,cols=30', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO `structure_validations` (`structure_field_id` , `rule` ) VALUES ((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `field`='total_ngml'), 'notEmpty');

-- ********************* clinical event **************************************

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'procure', 'clinical', 'procure follow-up worksheet - clinical event', 1, 'procure_ed_followup_worksheet_clinical_event', 'procure_ed_clinical_followup_worksheet_clinical_events', 0, 'procure follow-up worksheet - clinical event', 1);

CREATE TABLE IF NOT EXISTS `procure_ed_clinical_followup_worksheet_clinical_events` (
  `type` varchar(50) DEFAULT NULL, 
  followup_event_master_id int(11) DEFAULT NULL,

  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `procure_ed_clinical_followup_worksheet_clinical_events_revs` (
  `type` varchar(50) DEFAULT NULL, 
  followup_event_master_id int(11) DEFAULT NULL,
	
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `procure_ed_clinical_followup_worksheet_clinical_events_revs`
  ADD CONSTRAINT `procure_ed_clinical_followup_worksheet_clinical_events_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`),
  ADD CONSTRAINT `procure_ed_clinical_followup_worksheet_clinical_events_ibfk_2` FOREIGN KEY (`followup_event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_followup_exam_types", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'procure followup exam types\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('procure followup exam types', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'procure followup exam types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('bone scintigraphy', 'Bone scintigraphy', 'Scintigraphie osseuse', '1', @control_id, NOW(), NOW(), 1, 1),
('CT-scan', 'CT-scan', 'CT-scan', '1', @control_id, NOW(), NOW(), 1, 1),
('PET-scan', 'PET-Scan', 'TEP-scan', '1', @control_id, NOW(), NOW(), 1, 1),
('MRI', 'MRI', 'IRM', '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO structures(`alias`) VALUES ('procure_ed_followup_worksheet_clinical_event');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_clinical_events', 'followup_event_master_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id') , '0', '', '', '', 'follow-up worksheet identification', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_clinical_followup_worksheet_clinical_events', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_types') , '0', '', '', '', 'exam', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_clinical_events' AND `field`='followup_event_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='follow-up worksheet identification' AND `language_tag`=''), '1', '-6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '70', 'comments', '1', 'interpretation', '0', '', '0', '', '0', '', '1', 'rows=3,cols=30', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_followup_worksheet_clinical_event'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_clinical_events' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_exam_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='exam' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO `structure_validations` (`structure_field_id` , `rule` ) VALUES ((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheet_clinical_events' AND `field`='type'), 'notEmpty');

-- ********************* Treatment **************************************

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`) VALUES
('procure follow-up worksheet - treatment', 'procure', 1, 'procure_txd_followup_worksheet_treatments', 'procure_txd_followup_worksheet_treatment', NULL,NULL, 0, NULL, NULL, 'procure follow-up worksheet - treatment', 0);

CREATE TABLE IF NOT EXISTS `procure_txd_followup_worksheet_treatments` (
  `treatment_type` varchar(50) DEFAULT NULL, 
  `type` varchar(250) DEFAULT NULL, 
  `dosage` varchar(50) DEFAULT NULL, 
  followup_event_master_id int(11) DEFAULT NULL,
  
  `treatment_master_id` int(11) NOT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `procure_txd_followup_worksheet_treatments_revs` (
  `treatment_type` varchar(50) DEFAULT NULL, 
  `type` varchar(250) DEFAULT NULL, 
  `dosage` varchar(50) DEFAULT NULL, 
  followup_event_master_id int(11) DEFAULT NULL,
    
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `procure_txd_followup_worksheet_treatments`
  ADD CONSTRAINT `procure_txd_followup_worksheet_treatments_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`),
  ADD CONSTRAINT `procure_txd_followup_worksheet_treatments_ibfk_2` FOREIGN KEY (`followup_event_master_id`) REFERENCES `event_masters` (`id`);

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `display_order`='-5' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_form_identification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_medications'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_form_identification' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='identification' AND `language_tag`=''), '1', '-5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `display_order`='-5' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='procure_form_identification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_followup_treatment_types", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'procure followup medical treatment types\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('procure followup medical treatment types', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'procure followup medical treatment types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('radiotherapy', 'Radiotherapy', 'Radiothérapie', '1', @control_id, NOW(), NOW(), 1, 1),
('radiotherapy + hormonotherapy', 'Radiotherapy + Hormonotherapy', 'Radiothérapie + hormonothérapie', '1', @control_id, NOW(), NOW(), 1, 1),
('antalgic radiotherapy', 'Antalgic Radiotherapy', 'Radiothérapie antalgique', '1', @control_id, NOW(), NOW(), 1, 1),
('hormonotherapy', 'Hormonotherapy', 'Hormonothérapie', '1', @control_id, NOW(), NOW(), 1, 1),
('chemotherapy', 'Chemotherapy', 'Chimiothérapie', '1', @control_id, NOW(), NOW(), 1, 1),
('experimental treatment', 'Experimental Treatment', 'Traitement expérimental', '1', @control_id, NOW(), NOW(), 1, 1),
('other treatment', 'Other Treatment', 'Autre traitement', '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO structures(`alias`) VALUES ('procure_txd_followup_worksheet_treatment');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'followup_event_master_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id') , '0', '', '', '', 'follow-up worksheet identification', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'type', 'input',  NULL , '0', '', '', '', 'type', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'treatment_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_treatment_types') , '0', '', '', '', 'treatment type', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'dosage', 'input',  NULL , '0', '', '', '', 'dosage', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='followup_event_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_event_master_id')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='follow-up worksheet identification' AND `language_tag`=''), '1', '-5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_start_date' AND `language_label`='date/start date' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '-3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='treatment_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_followup_treatment_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment type' AND `language_tag`=''), '1', '-4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='dosage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dosage' AND `language_tag`=''), '1', '-2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO `structure_validations` (`structure_field_id` , `rule` ) VALUES ((SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type'), 'notEmpty');

-- ************************************** i18n ******************************

REPLACE INTO i18n (id,en,fr) VALUES
('procure follow-up worksheet', "F1 - Follow-up Worksheet","F1 - Fiche de suivi du patient"),
('visite date','Visite date','Date visite'),
('secondary to prostate cancer','Secondary to prostate cancer','Secondaire au cancer de la prostate'),
('independent of prostate cancer','Independent of prostate cancer','Indépendant du cancer de la prostate'),

('death (follow-up worksheet)','Death (F1 - Follow-up Worksheet)','Décès (F1 - Fiche de suivi du patient)'),
('procure follow-up worksheet - aps', "F1 - Follow-up Worksheet :: APS","F1 - Fiche de suivi du patient :: APS"),
('follow-up worksheet identification','Follow-up Worksheet Identification','Identification fiche de suivi'),
('biochemical recurrence >= 0.2ng/ml','Biochemical Recurrence (>=0.2ng/ml)','Récidive biochimique (>=0.2ng/ml)'),
('biochemical recurrence','Biochemical Recurrence','Récidive biochimique'),
('at least one APS or treatment or clinical event is linked to that followup form','At least one APS, treatment or clinical event is defined for htis followup form','Au moins un APS, traitement ou événement clinique est défini pour ce formulaire de suivi'),

('procure follow-up worksheet - clinical event', "F1 - Follow-up Worksheet :: Clinical Event","F1 - Fiche de suivi du patient :: Événement clinique"),
('exam','Exam','Examen'),
('clinical recurrence','Clinical Recurrence','Récidive clinique'),
('site','Site','Site'),
('interpretation','Interpretation','Interprétation'),
('procure follow-up worksheet - treatment', "F1 - Follow-up Worksheet :: Medical Treatments","F1 - Fiche de suivi du patient :: Traitements médicaux"),
('dosage','Dosage','Posologie'),
('treatment type','Treatment Type','Type de traitement'),
('surgery for metastases','Surgery for Metastases','Chirurgie pour métastases');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');

-- ===============================================================================================================================================================================
--
-- F2 - Fiche d'administration du questionnaire
--
-- ===============================================================================================================================================================================

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'procure', 'lifestyle', 'procure questionnaire administration worksheet', 1, 'procure_ed_questionnaire_administration_worksheet', 'procure_ed_lifestyle_quest_admin_worksheets', 0, 'procure questionnaire administration worksheet', 1);

CREATE TABLE IF NOT EXISTS `procure_ed_lifestyle_quest_admin_worksheets` (
  `patient_identity_verified` tinyint(1) DEFAULT '0',

  delivery_date date DEFAULT NULL,
  `delivery_date_accuracy` char(1) NOT NULL DEFAULT '',
  delivery_site_method varchar(50) DEFAULT NULL,

  method_to_complete varchar(50) DEFAULT NULL,

  recovery_date date DEFAULT NULL,
 `recovery_date_accuracy` char(1) NOT NULL DEFAULT '',
  recovery_method varchar(50) DEFAULT NULL,

  verification_date date DEFAULT NULL,
 `verification_date_accuracy` char(1) NOT NULL DEFAULT '', 
  verification_result varchar(50) DEFAULT NULL,
  
  revision_date date DEFAULT NULL,
 `revision_date_accuracy` char(1) NOT NULL DEFAULT '', 
  revision_method varchar(50) DEFAULT NULL,
   
  version varchar(50) DEFAULT NULL,
  version_date date DEFAULT NULL,
  
  spent_time_delivery_to_recovery int(6) DEFAULT NULL,
  
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `procure_ed_lifestyle_quest_admin_worksheets_revs` (
  `patient_identity_verified` tinyint(1) DEFAULT '0',

  delivery_date date DEFAULT NULL,
  `delivery_date_accuracy` char(1) NOT NULL DEFAULT '',
  delivery_site_method varchar(50) DEFAULT NULL,

  method_to_complete varchar(50) DEFAULT NULL,

  recovery_date date DEFAULT NULL,
 `recovery_date_accuracy` char(1) NOT NULL DEFAULT '',
  recovery_method varchar(50) DEFAULT NULL,

  verification_date date DEFAULT NULL,
 `verification_date_accuracy` char(1) NOT NULL DEFAULT '', 
  verification_result varchar(50) DEFAULT NULL,
  
  revision_date date DEFAULT NULL,
 `revision_date_accuracy` char(1) NOT NULL DEFAULT '', 
  revision_method varchar(50) DEFAULT NULL,
   
  version varchar(50) DEFAULT NULL,
  version_date date DEFAULT NULL,
  
  spent_time_delivery_to_recovery int(6) DEFAULT NULL,
	
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `procure_ed_lifestyle_quest_admin_worksheets`
  ADD CONSTRAINT `procure_ed_lifestyle_quest_admin_worksheets_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_questionnaire_delivery_site_and_method", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'questionnaire delivery site and method\')"),
("procure_method_to_complete_questionnaire", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'method to complete questionnaire\')"),
("procure_questionnaire_recovery_method", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'questionnaire recovery method\')"),
("procure_questionnaire_verification_result", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'questionnaire verification result\')"),
("procure_questionnaire_revision_method", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'questionnaire revision method\')"),
("procure_questionnaire_version", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'questionnaire version\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('questionnaire delivery site and method', 1, 50),
('method to complete questionnaire', 1, 50),
('questionnaire recovery method', 1, 50),
('questionnaire verification result', 1, 50),
('questionnaire revision method', 1, 50),
('questionnaire version', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'questionnaire delivery site and method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('urologist office', 'Urologist Office', 'Bureau de l''urologue', '1', @control_id, NOW(), NOW(), 1, 1),
('pre-op clinic', 'Pre-op Clinic', 'Clinique pré-opératoire', '1', @control_id, NOW(), NOW(), 1, 1),
('during hospitalisation', 'During Hospitalisation', 'Lors de l''hospitalisation', '1', @control_id, NOW(), NOW(), 1, 1),
('e-mail', 'E-mail', 'Courriel', '1', @control_id, NOW(), NOW(), 1, 1),
('mail', 'Mail', 'Courrier', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'method to complete questionnaire');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('alone', 'Alone', 'Seul', '1', @control_id, NOW(), NOW(), 1, 1),
('with a family member', 'With a Family Member', 'Avec membre(s) de la famille', '1', @control_id, NOW(), NOW(), 1, 1),
('with the biobank personnel', 'With the Biobank Personnel', 'Avec personnel de la Biobanque', '1', @control_id, NOW(), NOW(), 1, 1),
('at home', 'At Home', 'À la maison', '1', @control_id, NOW(), NOW(), 1, 1),
('in the hospital', 'In the Hospital', 'À l''hôpital', '1', @control_id, NOW(), NOW(), 1, 1),
('online', 'Online', 'En ligne', '1', @control_id, NOW(), NOW(), 1, 1),
('phone', 'Phone', 'Téléphone', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'questionnaire recovery method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('directly', 'Directly', 'Directement', '1', @control_id, NOW(), NOW(), 1, 1),
('mail', 'Mail', 'Courrier', '1', @control_id, NOW(), NOW(), 1, 1),
('internal mail', 'Internal Mail', 'Courrier Interne', '1', @control_id, NOW(), NOW(), 1, 1),
('e-mail', 'E-mail', 'Courriel', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'questionnaire verification result');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('complete', 'Complete', 'Complet', '1', @control_id, NOW(), NOW(), 1, 1),
('incomplete', 'Incomplete', 'Incomplet', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'questionnaire revision method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('with the participant', 'With the Participant', 'Avec le participant', '1', @control_id, NOW(), NOW(), 1, 1),
('directly', 'Directly', 'Directement', '1', @control_id, NOW(), NOW(), 1, 1),
('phone', 'Phone', 'Par téléphone', '1', @control_id, NOW(), NOW(), 1, 1),
('e-mail', 'E-mail', 'Par courriel', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'questionnaire version');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('french', 'French', 'Française', '1', @control_id, NOW(), NOW(), 1, 1),
('english', 'English', 'Anglaise', '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO structures(`alias`) VALUES ('procure_ed_questionnaire_administration_worksheet');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'delivery_date', 'date',  NULL , '0', '', '', '', 'date', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'delivery_site_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_delivery_site_and_method') , '0', '', '', '', 'site/method', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'method_to_complete', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_method_to_complete_questionnaire') , '0', '', '', '', 'method', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'recovery_date', 'date',  NULL , '0', '', '', '', 'date', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'recovery_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_recovery_method') , '0', '', '', '', 'method', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'verification_date', 'date',  NULL , '0', '', '', '', 'date', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'verification_result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_verification_result') , '0', '', '', '', 'result', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'revision_date', 'date',  NULL , '0', '', '', '', 'date', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'revision_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_revision_method') , '0', '', '', '', 'method', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'version', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_version') , '0', '', '', '', 'version', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'version_date', 'date',  NULL , '0', '', '', '', 'date', ''), 
('ClinicalAnnotation', 'EventDetail', 'procure_ed_lifestyle_quest_admin_worksheets', 'spent_time_delivery_to_recovery', 'integer_positive',  NULL , '0', '', '', '', 'time spent between receipt and recovery of questionnaire', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='procure_form_identification' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='identification' AND `language_tag`=''), '1', '-6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_clinical_followup_worksheets' AND `field`='patient_identity_verified' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='delivery_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '20', 'questionnaire given to the participant', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='delivery_site_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_delivery_site_and_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site/method' AND `language_tag`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='method_to_complete' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_method_to_complete_questionnaire')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '25', 'questionnaire completed by the participant', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='recovery_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '30', 'questionnaire recovered by the Biobank personnel', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='recovery_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_recovery_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='verification_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '35', 'questionnaire verified by the Biobank personnel', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='verification_result' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_verification_result')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '1', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='revision_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '40', 'questionnaire revised by the Biobank personnel', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='revision_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_revision_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='version' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_questionnaire_version')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='version' AND `language_tag`=''), '1', '45', 'version of questionnaire', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='version_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '46', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_lifestyle_quest_admin_worksheets' AND `field`='spent_time_delivery_to_recovery' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='time spent between receipt and recovery of questionnaire' AND `language_tag`=''), '1', '47', 'Time spent', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_ed_questionnaire_administration_worksheet'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '2', '70', 'comments', '1', 'comments', '0', '', '0', '', '0', '', '1', 'rows=3,cols=30', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO i18n (id,en,fr) VALUES
('procure questionnaire administration worksheet', "F2 - Questionnaire Administration Worksheet","F2 - Fiche d'administration du questionnaire"),

('questionnaire completed by the participant','Completed by the Participant','Complété par le participant'),
('questionnaire given to the participant','Given to the Participant','Remis au participant'),
('questionnaire recovered by the Biobank personnel','Recovered by the Biobank Personnel','Receuilli par le personnel de la Biobanque'),
('questionnaire revised by the Biobank personnel','Revised by the Biobank Personnel','Revisé par le personnel de la Biobanque'),
('questionnaire verified by the Biobank personnel','Verified by the Biobank Personnel','Vérifié par le personnel de la Biobanque'),
('site/method','Site/Method','Site/Méthode'),
('Time spent','Time spent','Temps écoulé'),
('time spent between receipt and recovery of questionnaire','Time spent between receipt and recovery of questionnaire (days)','Temps écoulé entre remise et récupération du questionnaire (jours)'),
('version of questionnaire','Version of questionnaire','Version du questionnaire');

-- ===============================================================================================================================================================================
-- 
-- INVENTORY
-- 
-- ===============================================================================================================================================================================

-- ******************* COLLECTION *********************************************

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ( 'sop_master_id','acquisition_label','collection_property','collection_site'));
UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'bank_id' AND model IN ('Collection','ViewAliquot','ViewCollection','ViewSample'));

REPLACE INTO i18n (id,en,fr) VALUES
('inv_collection_datetime_defintion','Collection time of either blood, urine or prostate','Temps de collection du sang de l''urine ou de la prostate');

ALTER TABLE collections ADD `procure_patient_identity_verified` tinyint(1) DEFAULT '0';
ALTER TABLE collections_revs ADD `procure_patient_identity_verified` tinyint(1) DEFAULT '0';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'procure_patient_identity_verified', 'checkbox',  NULL , '0', '', '', '', 'confirm that the identity of the patient has been verified', ''),
('InventoryManagement', 'ViewCollection', '', 'procure_patient_identity_verified', 'checkbox',  NULL , '0', '', '', '', 'confirm that the identity of the patient has been verified', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_patient_identity_verified' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='procure_patient_identity_verified' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='procure_patient_identity_verified' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='confirm that the identity of the patient has been verified' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0' 
WHERE structure_id = (SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE field = 'collection_datetime');

INSERT INTO structure_permissible_values (value, language_alias) VALUES("2", "participant");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="col_copy_binding_opt"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="participant"), "2", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="2" AND spv.language_alias="participant only";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="6" AND spv.language_alias="all (participant, consent, diagnosis and treatment/annotation)";
DELETE FROM structure_permissible_values WHERE value="2" AND language_alias="participant only";
DELETE FROM structure_permissible_values WHERE value="6" AND language_alias="all (participant, consent, diagnosis and treatment/annotation)";

UPDATE structure_fields SET  `default`='2' WHERE model='FunctionManagement' AND tablename='' AND field='col_copy_binding_opt' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='col_copy_binding_opt');

-- ******************* TEMPLATE *********************************************

INSERT INTO `templates` (`id`, `flag_system`, `name`, `owner`, `visibility`, `flag_active`, `owning_entity_id`, `visible_entity_id`) VALUES
(1, 1, 'Urine', 'user', 'user', 1, 1, 1),
(2, 1, 'Blood/Sang', 'user', 'user', 1, 1, 1),
(3, 1, 'Tissue/Tissu', 'user', 'user', 1, 1, 1);

INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`) VALUES
(1, NULL, 1, 5, 4, 1),
(2, 1, 1, 5, 15, 1),
(3, 2, 1, 1, 14, 2),
(4, NULL, 2, 5, 2, 1),
(5, 4, 2, 1, 3, 3),
(6, 4, 2, 5, 10, 1),
(7, 6, 2, 1, 17, 5),
(8, NULL, 2, 5, 2, 1),
(9, 8, 2, 1, 3, 1),
(10, NULL, 2, 5, 2, 1),
(11, 10, 2, 1, 3, 3),
(14, NULL, 3, 5, 3, 1),
(15, 14, 3, 1, 9, 8),
(16, 4, 2, 1, 11, 1),
(17, 10, 2, 5, 9, 1),
(18, 17, 2, 1, 16, 5),
(19, 10, 2, 5, 8, 1),
(20, 19, 2, 1, 37, 3);


-- ******************* INVENTORY CONFIGURATION *********************************************

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 1, 12, 19, 131, 135, 2, 25, 3, 119, 132, 142, 105, 112, 106, 143, 120, 124, 121, 141, 103, 109, 104, 144, 122, 127, 123, 7, 130, 101, 102, 10);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(33, 10, 1);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(11, 34, 46, 1, 10);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(24, 118);

-- ******************* BLOOD *********************************************

ALTER TABLE sd_spe_bloods
	ADD COLUMN procure_collection_site varchar(250) DEFAULT NULL,
	ADD COLUMN procure_collection_without_incident tinyint(1) DEFAULT '0',
	ADD COLUMN procure_tubes_inverted_8_10_times tinyint(1) DEFAULT '0',
	ADD COLUMN procure_tubes_correclty_stored tinyint(1) DEFAULT '0';
ALTER TABLE sd_spe_bloods_revs
	ADD COLUMN procure_collection_site varchar(250) DEFAULT NULL,
	ADD COLUMN procure_collection_without_incident tinyint(1) DEFAULT '0',
	ADD COLUMN procure_tubes_inverted_8_10_times tinyint(1) DEFAULT '0',
	ADD COLUMN procure_tubes_correclty_stored tinyint(1) DEFAULT '0';	
	
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0' 
WHERE structure_field_id NOT IN (SELECT id FROM structure_fields WHERE field = 'reception_datetime') 
AND structure_id=(SELECT id FROM structures WHERE alias='specimens');
UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0' 
WHERE structure_field_id NOT IN (SELECT id FROM structure_fields WHERE field = 'blood_type') 
AND structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods');
INSERT INTO structure_permissible_values (value, language_alias) VALUES("k2-EDTA", "k2-EDTA");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="k2-EDTA" AND language_alias="k2-EDTA"), "2", "1");
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="unknown" AND spv.language_alias="unknown";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="EDTA" AND spv.language_alias="EDTA";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="gel CSA" AND spv.language_alias="gel CSA";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="heparin" AND spv.language_alias="heparin";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id WHERE spv.value="ZCSA" AND spv.language_alias="ZCSA";
DELETE FROM structure_permissible_values WHERE value="EDTA" AND language_alias="EDTA";
DELETE FROM structure_permissible_values WHERE value="gel CSA" AND language_alias="gel CSA";
DELETE FROM structure_permissible_values WHERE value="heparin" AND language_alias="heparin";
DELETE FROM structure_permissible_values WHERE value="ZCSA" AND language_alias="ZCSA";
INSERT INTO structure_permissible_values (value, language_alias) VALUES("serum", "serum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="serum"), "2", "1");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="3" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="k2-EDTA" AND language_alias="k2-EDTA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="1" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="serum");
INSERT INTO `structure_validations` (`structure_field_id` , `rule` ) VALUES ((SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field`='blood_type'), 'notEmpty');

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("procure_blood_collection_sites", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'blood collection sites\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('blood collection sites', 1, 250);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'blood collection sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('clinic', 'In the clinic', 'En clinique', '1', @control_id, NOW(), NOW(), 1, 1),
('operating room', 'In operating room', 'En salle d''opération', '1', @control_id, NOW(), NOW(), 1, 1),
('before anestesia', 'Before anestesia', 'Lors de la pré-anesthésie', '1', @control_id, NOW(), NOW(), 1, 1),
('after anesthesia', 'After anesthesia', 'Après anesthésie', '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'procure_collection_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_blood_collection_sites') , '0', '', '', '', 'blood collection was done', ''), 
('InventoryManagement', 'SampleDetail', '', 'procure_collection_without_incident', 'checkbox',  NULL , '0', '', '', '', 'without incident', ''), 
('InventoryManagement', 'SampleDetail', '', 'procure_tubes_inverted_8_10_times', 'checkbox',  NULL , '0', '', '', '', 'tubes_inverted 8 10 times', ''), 
('InventoryManagement', 'SampleDetail', '', 'procure_tubes_correclty_stored', 'checkbox',  NULL , '0', '', '', 'procure_tubes_correclty_stored_help', 'procure blood tubes correclty stored', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='procure_collection_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_blood_collection_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='blood collection was done' AND `language_tag`=''), '1', '450', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='procure_collection_without_incident' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='without incident' AND `language_tag`=''), '1', '451', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='procure_tubes_inverted_8_10_times' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tubes_inverted 8 10 times' AND `language_tag`=''), '1', '452', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='procure_tubes_correclty_stored' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='procure_tubes_correclty_stored_help' AND `language_label`='procure blood tubes correclty stored' AND `language_tag`=''), '1', '453', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

REPLACE INTO i18n (id,en,fr)
VALUES 
('k2-EDTA','K2-EDTA','K2-EDTA'),
('blood collection was done','The blood collection was done','Le prélèvement a été effectué'),
('without incident','Without incident','Sans incident'),
('tubes_inverted 8 10 times','All tubes were immediately inverted 8-10 times after collection','Les tubes ont été immédiatement inversés 8-10 fois suivant le prélèvement'),
('procure blood tubes correclty stored','Good temporary storage conditions (see help)','Bonnes conditions de stockage temporaire (voir aide)'),
('procure_tubes_correclty_stored_help',
'EDTA tubes were immediately placed in the cold. Serum tubes were kept at room temperature for 1 hour. The PAXgene tube was kept at room temperature for 2 hours.',
'Les tubes EDTA ont été immédiatement mis au froid. Les tubes sérum ont été conservés à la température ambiante pendant 1 heure. Le tube PAXgene a été conservé à la température ambiante pendant 2 heures.');

UPDATE structure_fields SET language_label = 'aliquot procure identification' WHERE model LIKE '%Aliquot%' AND field = 'barcode' AND language_label = 'barcode';
UPDATE structure_formats SET language_label = 'used aliquot procure identification' WHERE language_label = 'used aliquot barcode';
UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='aliquot_label');
UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='lot_number' AND model LIKE '%aliquot%');

UPDATE structure_formats SET `display_column`='1', `display_order`='1199' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='1200' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr)
VALUES 
('aliquot procure identification','Identification','Identification'),
('used aliquot procure identification','Used Aliquot Identification','Identification de l''aliquot utilisé');

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('creation_site', 'creation_by') AND model LIKE 'DerivativeDetail');
UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('cell_count','concentration', 'cell_count_unit', 'cell_viability', 'concentration_unit') AND model LIKE 'AliquotDetail');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_whatman_papers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='used_blood_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_whatman_papers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='used_blood_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');


todo
ALTER TABLE ad_whatman_papers
	ADD COLUMN procure_card_completed_at time DEFAULT NULL,
	ADD COLUMN `procure_card_sealed_date` date DEFAULT NULL,
	ADD COLUMN `procure_card_sealed_date_accuracy` char(1) NOT NULL DEFAULT '';
ALTER TABLE ad_whatman_papers_revs
	ADD COLUMN procure_card_completed_at time DEFAULT NULL,
	ADD COLUMN `procure_card_sealed_date` date DEFAULT NULL,
	ADD COLUMN `procure_card_sealed_date_accuracy` char(1) NOT NULL DEFAULT '';








INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', '', 'procure_card_sealed_date', 'datetime',  NULL , '0', '', '', '', 'procure card sealed on', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_whatman_papers'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='procure_card_sealed_date' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='procure card sealed on' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '1', '1', '0', '0');

		