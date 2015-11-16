-- -------------------------------------------------------------------------------------------------------------------------------------
-- Datamart Configuration
-- -------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions SET flag_active = 1
WHERE datamart_structure_id IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('ParticipantMessage',
		'ParticipantContact',
		'ReproductiveHistory'))
AND label IN ('number of elements per participant');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Middle Name
-- -------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE participants SET middle_name = SUBSTRING(first_name, (LOCATE(' ',first_name) +1)), first_name = SUBSTRING(first_name, 1, (LOCATE(' ',first_name) - 1))
WHERE deleted <> 1 AND first_name REGEXP '^[\\.a-zA-Z0-9\-]+\ [\\.a-zA-Z0-9\-]+$';
UPDATE participants_revs SET middle_name = SUBSTRING(first_name, (LOCATE(' ',first_name) +1)), first_name = SUBSTRING(first_name, 1, (LOCATE(' ',first_name) - 1))
WHERE first_name REGEXP '^[\\.a-zA-Z0-9\-]+\ [\\.a-zA-Z0-9\-]+$';

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Clinical Path Review
-- -------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'clinical', 'ovary or endometrium path report', 1, 'ovcare_ed_ovary_endometrium_path_reports', 'ovcare_ed_path_reports', 0, 'ovary or endometrium path report', 0, 0, 1),
(null, '', 'clinical', 'other path report', 1, 'ovcare_ed_other_path_reports', 'ovcare_ed_path_reports', 0, 'other path report', 0, 0, 1);

CREATE TABLE IF NOT EXISTS `ovcare_ed_path_reports` (
  `diagnosis_report`char(1) DEFAULT 'n',
  `path_report_type` varchar(100) DEFAULT NULL,
  `pathologist` varchar(100) DEFAULT NULL,
  `tumour_grade` varchar(150) DEFAULT NULL,
  `figo` varchar(10) DEFAULT NULL,
  `stage` varchar(10) DEFAULT NULL,  
  `histopathology` varchar(100) DEFAULT NULL,
  `ovarian_histology` varchar(100) DEFAULT NULL,
  `uterine_histology` varchar(100) DEFAULT NULL,
  `benign_lesions_precursor_presence` varchar(100) DEFAULT NULL,
  `fallopian_tube_lesions` varchar(100) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `ovcare_ed_path_reports_revs` (
  `diagnosis_report`char(1) DEFAULT 'n',
  `path_report_type` varchar(100) DEFAULT NULL,
  `pathologist` varchar(100) DEFAULT NULL,
  `tumour_grade` varchar(150) DEFAULT NULL,
  `figo` varchar(10) DEFAULT NULL,
  `stage` varchar(10) DEFAULT NULL,  
  `histopathology` varchar(100) DEFAULT NULL,
  `ovarian_histology` varchar(100) DEFAULT NULL,
  `uterine_histology` varchar(100) DEFAULT NULL,
  `benign_lesions_precursor_presence` varchar(100) DEFAULT NULL,
  `fallopian_tube_lesions` varchar(100) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=99 ;
ALTER TABLE `ovcare_ed_path_reports`
  ADD CONSTRAINT `ovcare_ed_path_reports_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
  
INSERT INTO structures(`alias`) VALUES ('ovcare_ed_ovary_endometrium_path_reports');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'path_report_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_review_type') , '0', '', '', '', 'path report type', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'pathologist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist_reviewed') , '0', '', '', '', 'pathologist', ''),
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade') , '0', '', '', '', 'tumor grade', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'figo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo') , '0', '', '', '', 'figo', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'ovarian_histology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology') , '0', '', '', '', 'ovarian', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'uterine_histology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology') , '0', '', '', '', 'uterine', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'histopathology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology') , '0', '', '', '', 'general', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'benign_lesions_precursor_presence', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence') , '0', '', '', '', 'presence of benign lesions precursor', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'fallopian_tube_lesions', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions') , '0', '', '', '', 'fallopian tube lesions', ''),
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'diagnosis_report', 'yes_no', NULL , '0', '', '', '', 'diagnosis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='path_report_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='path report type' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='pathologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist_reviewed')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathologist' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor grade' AND `language_tag`=''), '2', '25', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='figo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='figo' AND `language_tag`=''), '2', '29', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='ovarian_histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ovarian' AND `language_tag`=''), '2', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='uterine_histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='uterine' AND `language_tag`=''), '2', '61', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='histopathology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='general' AND `language_tag`=''), '2', '59', 'histopathology', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='benign_lesions_precursor_presence' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='presence of benign lesions precursor' AND `language_tag`=''), '2', '70', 'lesions', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='fallopian_tube_lesions' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fallopian tube lesions' AND `language_tag`=''), '2', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='diagnosis_report' AND `type`='yes_no' AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis' AND `language_tag`=''), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en) VALUES 
('ovary or endometrium path report', 'Ovary/Endometrium Path Report'),
('other path report', 'Other Path Report'),
('path report type','Type');

INSERT INTO structures(`alias`) VALUES ('ovcare_ed_other_path_reports');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'tumour_grade', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') , '0', 'size=5', '', 'help_tumour grade', 'tumour grade', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'stage', 'input',  NULL , '0', 'size=5', '', '', 'stage', ''), 
('ClinicalAnnotation', 'EventDetail', 'ovcare_ed_path_reports', 'histopathology', 'input',  NULL , '0', 'size=30', '', '', 'histopathology', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='tumour_grade' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade')  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_tumour grade' AND `language_label`='tumour grade' AND `language_tag`=''), '2', '25', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='stage' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='stage' AND `language_tag`=''), '2', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='histopathology' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='histopathology' AND `language_tag`=''), '2', '27', 'histopathology', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '-2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='path_report_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='path report type' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='pathologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist_reviewed')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathologist' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_other_path_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='diagnosis_report' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis' AND `language_tag`=''), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_value_domains SET domain_name = 'ovcare_path_report_type' WHERE domain_name = 'ovcare_path_review_type';
UPDATE structure_value_domains SET domain_name = 'ovcare_pathologist' WHERE domain_name = 'ovcare_pathologist_reviewed';
UPDATE structure_permissible_values_custom_controls SET name = 'Path Report Type', category = 'clinicalannotation - annotation' WHERE name = 'Path Review Type';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Path Report Type')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('Path Review Type')";
UPDATE structure_permissible_values_custom_controls SET category = 'clinicalannotation - annotation' WHERE name = 'Pathologist';

SET @dx_control_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'ovary or endometrium tumor');
SET @ev_control_id = (SELECT id FROM event_controls WHERE event_type = 'ovary or endometrium path report');

INSERT INTO event_masters (event_control_id, participant_id, diagnosis_master_id, event_date, event_date_accuracy, created, created_by, modified, modified_by, deleted)
(SELECT @ev_control_id, participant_id, id, ovcare_date_reviewed, ovcare_date_reviewed_accuracy, created, created_by, modified, modified_by, deleted 
FROM diagnosis_masters DiagnosisMaster
INNER JOIN ovcare_dxd_ovaries_endometriums DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
WHERE diagnosis_control_id = @dx_control_id
AND ((ovcare_date_reviewed IS NOT NULL AND ovcare_date_reviewed NOT LIKE '')
 OR (ovcare_path_review_type IS NOT NULL AND ovcare_path_review_type NOT LIKE '')
 OR (ovcare_pathologist_reviewed IS NOT NULL AND ovcare_pathologist_reviewed NOT LIKE '')
 OR (tumour_grade IS NOT NULL AND tumour_grade NOT LIKE '')
 OR (figo IS NOT NULL AND figo NOT LIKE '')
 OR (histopathology IS NOT NULL AND histopathology NOT LIKE '')
 OR (ovarian_histology IS NOT NULL AND ovarian_histology NOT LIKE '')
 OR (uterine_histology IS NOT NULL AND uterine_histology NOT LIKE '')
 OR (benign_lesions_precursor_presence IS NOT NULL AND benign_lesions_precursor_presence NOT LIKE '')
 OR (fallopian_tube_lesions IS NOT NULL AND fallopian_tube_lesions NOT LIKE '')));

INSERT INTO ovcare_ed_path_reports (event_master_id, diagnosis_report, path_report_type, pathologist, tumour_grade, figo, histopathology, ovarian_histology, uterine_histology, benign_lesions_precursor_presence, fallopian_tube_lesions)
(SELECT EventMaster.id, 'y', ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, figo, histopathology, ovarian_histology, uterine_histology, benign_lesions_precursor_presence, fallopian_tube_lesions
FROM event_masters EventMaster 
INNER JOIN diagnosis_masters DiagnosisMaster ON DiagnosisMaster.id = EventMaster.diagnosis_master_id
INNER JOIN ovcare_dxd_ovaries_endometriums DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
WHERE EventMaster.event_control_id = @ev_control_id AND DiagnosisMaster.diagnosis_control_id = @dx_control_id);

CREATE TABLE IF NOT EXISTS `ovcare_tmp_migration` (
  `id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL DEFAULT '0',
  `ovcare_date_reviewed` date DEFAULT NULL,
  `ovcare_date_reviewed_accuracy` char(1) NOT NULL DEFAULT '',
  `modified_by` int(10) unsigned NOT NULL,
  `version_created` datetime NOT NULL,
  `ovcare_path_review_type` varchar(100) DEFAULT NULL,
  `ovcare_pathologist_reviewed` varchar(100) DEFAULT NULL,
  `tumour_grade` varchar(150) DEFAULT NULL,
  `figo` varchar(10) DEFAULT NULL,
  `histopathology` varchar(100) DEFAULT NULL,
  `ovarian_histology` varchar(100) DEFAULT NULL,
  `uterine_histology` varchar(100) DEFAULT NULL,
  `benign_lesions_precursor_presence` varchar(100) DEFAULT NULL,
  `fallopian_tube_lesions` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

INSERT INTO ovcare_tmp_migration (
SELECT DISTINCT id, participant_id, ovcare_date_reviewed, ovcare_date_reviewed_accuracy, DiagnosisMaster.modified_by, DiagnosisMaster.version_created,
ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, figo, histopathology, ovarian_histology, uterine_histology, benign_lesions_precursor_presence, fallopian_tube_lesions, null
FROM diagnosis_masters_revs DiagnosisMaster
INNER JOIN ovcare_dxd_ovaries_endometriums_revs DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id AND DiagnosisMaster.version_created = DiagnosisDetail.version_created
WHERE DiagnosisMaster.id IN (SELECT diagnosis_master_id FROM event_masters WHERE event_control_id IN (@ev_control_id))
ORDER BY DiagnosisMaster.version_id ASC);

INSERT INTO event_masters_revs (id, event_control_id, participant_id, diagnosis_master_id, event_date, event_date_accuracy, modified_by, version_created)
(SELECT EventMaster.id, @ev_control_id, TMP.participant_id, TMP.id, TMP.ovcare_date_reviewed, TMP.ovcare_date_reviewed_accuracy, TMP.modified_by, TMP.version_created 
FROM ovcare_tmp_migration TMP
INNER JOIN event_masters EventMaster ON TMP.id = EventMaster.diagnosis_master_id
WHERE EventMaster.event_control_id = @ev_control_id
ORDER BY version_id ASC);

INSERT INTO ovcare_ed_path_reports_revs (event_master_id, diagnosis_report, path_report_type, pathologist, tumour_grade, figo, histopathology, ovarian_histology, uterine_histology, benign_lesions_precursor_presence, fallopian_tube_lesions, version_created)
(SELECT EventMaster.id, 'y', ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, figo, histopathology, ovarian_histology, uterine_histology, benign_lesions_precursor_presence, fallopian_tube_lesions, TMP.version_created 
FROM ovcare_tmp_migration TMP
INNER JOIN event_masters EventMaster ON TMP.id = EventMaster.diagnosis_master_id AND EventMaster.event_control_id = @ev_control_id
ORDER BY version_id ASC);

DROP TABLE ovcare_tmp_migration;

SET @dx_control_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'other');
SET @ev_control_id = (SELECT id FROM event_controls WHERE event_type = 'other path report');

INSERT INTO event_masters (event_control_id, participant_id, diagnosis_master_id, event_date, event_date_accuracy, created, created_by, modified, modified_by, deleted)
(SELECT @ev_control_id, participant_id, id, ovcare_date_reviewed, ovcare_date_reviewed_accuracy, created, created_by, modified, modified_by, deleted 
FROM diagnosis_masters DiagnosisMaster
INNER JOIN ovcare_dxd_others DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
WHERE diagnosis_control_id = @dx_control_id
AND ((ovcare_date_reviewed IS NOT NULL AND ovcare_date_reviewed NOT LIKE '')
 OR (ovcare_path_review_type IS NOT NULL AND ovcare_path_review_type NOT LIKE '')
 OR (ovcare_pathologist_reviewed IS NOT NULL AND ovcare_pathologist_reviewed NOT LIKE '')
 OR (tumour_grade IS NOT NULL AND tumour_grade NOT LIKE '')
 OR (stage IS NOT NULL AND stage NOT LIKE '')
 OR (histopathology IS NOT NULL AND histopathology NOT LIKE '')));

INSERT INTO ovcare_ed_path_reports (event_master_id, diagnosis_report, path_report_type, pathologist, tumour_grade, stage, histopathology)
(SELECT EventMaster.id, 'y', ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, stage, histopathology
FROM event_masters EventMaster 
INNER JOIN diagnosis_masters DiagnosisMaster ON DiagnosisMaster.id = EventMaster.diagnosis_master_id
INNER JOIN ovcare_dxd_others DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
WHERE EventMaster.event_control_id = @ev_control_id AND DiagnosisMaster.diagnosis_control_id = @dx_control_id);

CREATE TABLE IF NOT EXISTS `ovcare_tmp_migration` (
  `id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL DEFAULT '0',
  `ovcare_date_reviewed` date DEFAULT NULL,
  `ovcare_date_reviewed_accuracy` char(1) NOT NULL DEFAULT '',
  `modified_by` int(10) unsigned NOT NULL,
  `version_created` datetime NOT NULL,
  `ovcare_path_review_type` varchar(100) DEFAULT NULL,
  `ovcare_pathologist_reviewed` varchar(100) DEFAULT NULL,
  `tumour_grade` varchar(150) DEFAULT NULL,
  `stage` varchar(10) DEFAULT NULL,
  `histopathology` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

INSERT INTO ovcare_tmp_migration (
SELECT DISTINCT id, participant_id, ovcare_date_reviewed, ovcare_date_reviewed_accuracy, DiagnosisMaster.modified_by, DiagnosisMaster.version_created,
ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, stage, histopathology, null
FROM diagnosis_masters_revs DiagnosisMaster
INNER JOIN ovcare_dxd_others_revs DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id AND DiagnosisMaster.version_created = DiagnosisDetail.version_created
WHERE DiagnosisMaster.id IN (SELECT diagnosis_master_id FROM event_masters WHERE event_control_id IN (@ev_control_id))
ORDER BY DiagnosisMaster.version_id ASC);

INSERT INTO event_masters_revs (id, event_control_id, participant_id, diagnosis_master_id, event_date, event_date_accuracy, modified_by, version_created)
(SELECT EventMaster.id, @ev_control_id, TMP.participant_id, TMP.id, TMP.ovcare_date_reviewed, TMP.ovcare_date_reviewed_accuracy, TMP.modified_by, TMP.version_created 
FROM ovcare_tmp_migration TMP
INNER JOIN event_masters EventMaster ON TMP.id = EventMaster.diagnosis_master_id
WHERE EventMaster.event_control_id = @ev_control_id
ORDER BY version_id ASC);

INSERT INTO ovcare_ed_path_reports_revs (event_master_id, diagnosis_report, path_report_type, pathologist, tumour_grade, stage, histopathology, version_created)
(SELECT EventMaster.id, 'y', ovcare_path_review_type, ovcare_pathologist_reviewed, tumour_grade, stage, histopathology, TMP.version_created 
FROM ovcare_tmp_migration TMP
INNER JOIN event_masters EventMaster ON TMP.id = EventMaster.diagnosis_master_id AND EventMaster.event_control_id = @ev_control_id
ORDER BY version_id ASC);

DROP TABLE ovcare_tmp_migration;

ALTER TABLE ovcare_dxd_others 
  DROP COLUMN stage, 
  DROP COLUMN histopathology;
ALTER TABLE ovcare_dxd_others_revs 
  DROP COLUMN stage, 
  DROP COLUMN histopathology;
ALTER TABLE ovcare_dxd_ovaries_endometriums 
  DROP COLUMN figo, 
  DROP COLUMN ovarian_histology, 
  DROP COLUMN uterine_histology, 
  DROP COLUMN histopathology, 
  DROP COLUMN benign_lesions_precursor_presence, 
  DROP COLUMN fallopian_tube_lesions;
ALTER TABLE ovcare_dxd_ovaries_endometriums_revs 
  DROP COLUMN figo, 
  DROP COLUMN ovarian_histology, 
  DROP COLUMN uterine_histology, 
  DROP COLUMN histopathology, 
  DROP COLUMN benign_lesions_precursor_presence, 
  DROP COLUMN fallopian_tube_lesions;
ALTER TABLE diagnosis_masters 
  DROP COLUMN ovcare_date_reviewed, 
  DROP COLUMN ovcare_date_reviewed_accuracy, 
  DROP COLUMN ovcare_path_review_type, 
  DROP COLUMN ovcare_pathologist_reviewed;
ALTER TABLE diagnosis_masters_revs 
  DROP COLUMN ovcare_date_reviewed, 
  DROP COLUMN ovcare_date_reviewed_accuracy, 
  DROP COLUMN ovcare_path_review_type, 
  DROP COLUMN ovcare_pathologist_reviewed;
UPDATE diagnosis_masters SET tumour_grade = '';
UPDATE diagnosis_masters_revs SET tumour_grade = '';

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_path_review_type' AND `language_label`='path review type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_report_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_date_reviewed' AND `language_label`='date reviewed' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_pathologist_reviewed' AND `language_label`='pathologist reviewed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_date_reviewed' AND `language_label`='date reviewed' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_pathologist_reviewed' AND `language_label`='pathologist reviewed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_date_reviewed' AND `language_label`='date reviewed' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_pathologist_reviewed' AND `language_label`='pathologist reviewed' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-88' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumour grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='tumour grade') AND `language_help`='help_tumour grade' AND `validation_control`='open' AND `value_domain_control`='extend' AND `field_control`='locked' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='stage' AND `language_label`='stage' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dxd_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='histopathology' AND `language_label`='histopathology' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='stage' AND `language_label`='stage' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='histopathology' AND `language_label`='histopathology' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='stage' AND `language_label`='stage' AND `language_tag`='' AND `type`='input' AND `setting`='size=5' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_others' AND `field`='histopathology' AND `language_label`='histopathology' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumor grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='figo' AND `language_label`='figo' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='ovarian_histology' AND `language_label`='ovarian' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='uterine_histology' AND `language_label`='uterine' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='histopathology' AND `language_label`='general' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='benign_lesions_precursor_presence' AND `language_label`='presence of benign lesions precursor' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='fallopian_tube_lesions' AND `language_label`='fallopian tube lesions' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');-- Delete obsolete structure fields and validations
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumor grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='figo' AND `language_label`='figo' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='ovarian_histology' AND `language_label`='ovarian' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='uterine_histology' AND `language_label`='uterine' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='histopathology' AND `language_label`='general' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='benign_lesions_precursor_presence' AND `language_label`='presence of benign lesions precursor' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='fallopian_tube_lesions' AND `language_label`='fallopian tube lesions' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumor grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='figo' AND `language_label`='figo' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='ovarian_histology' AND `language_label`='ovarian' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='uterine_histology' AND `language_label`='uterine' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='histopathology' AND `language_label`='general' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='benign_lesions_precursor_presence' AND `language_label`='presence of benign lesions precursor' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='fallopian_tube_lesions' AND `language_label`='fallopian tube lesions' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en) 
VALUES 
('this type of path report can not be linked to this type of diagnosis', 'This type of path report can not be linked to this type of diagnosis!'),
('only one report can be flagged as diagnosis report per diagnosis', 'Only one report can be flagged as diagnosis report per diagnosis!');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- AliquotMaster.study_summary_id update
-- -------------------------------------------------------------------------------------------------------------------------------------

SET @modified_by = (SELECT id FROM users WHERE username = 'migration');
SET @modified = (SELECT NOW() FROM users WHERE username = 'migration');
ALTER TABLE participants ADD COLUMN tmp_link_aliquot_to_study_summary_id int(11) DEFAULT '0';

-- 'Endometriosis'

SET @studied_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Endometriosis'
	) Res
);
SET @updated_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Endometriosis'
		AND EventMaster.participant_id NOT IN (
			SELECT DISTINCT EventMaster.participant_id
			FROM event_masters EventMaster 
			INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
			INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
			WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')
		)
	) Res
);
SELECT CONCAT("Updated aliquots of ", @updated_participants, " participants from a set of ", @studied_participants," participants linked to study annotation 'Endometriosis'.") AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT "Patient ID linked to 'Endometriosis' and other study ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium') that could be updated." AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT CONCAT(participant_identifier, ' (participant_id=',Participant.id,')') AS "Study-Aliquot Link Creation Message"
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Endometriosis'
AND EventMaster.participant_id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')
);
SET @study_summary_id = (SELECT id FROM study_summaries WHERE title = 'Endometriosis');
UPDATE participants SET tmp_link_aliquot_to_study_summary_id = @study_summary_id WHERE id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Endometriosis'
	AND EventMaster.participant_id NOT IN (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Intratumoural Heterogenity','ITH-Ovary','ITH-Endometrium')
	)
);

-- 'Intratumoural Heterogenity'

SET @studied_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Intratumoural Heterogenity'
	) Res
);
SET @updated_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Intratumoural Heterogenity'
		AND EventMaster.participant_id NOT IN (
			SELECT DISTINCT EventMaster.participant_id
			FROM event_masters EventMaster 
			INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
			INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
			WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')
		)
	) Res
);
SELECT CONCAT("Updated aliquots of ", @updated_participants, " participants from a set of ", @studied_participants," participants linked to study annotation 'Intratumoural Heterogenity'.") AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT "Patient ID linked to 'Intratumoural Heterogenity' and other study ('Endometriosis','ITH-Ovary','ITH-Endometrium') that could be updated." AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT CONCAT(participant_identifier, ' (participant_id=',Participant.id,')') AS "Study-Aliquot Link Creation Message"
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Intratumoural Heterogenity'
AND EventMaster.participant_id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')
);
SET @study_summary_id = (SELECT id FROM study_summaries WHERE title = 'Intratumoural Heterogenity');
UPDATE participants SET tmp_link_aliquot_to_study_summary_id = @study_summary_id WHERE id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'Intratumoural Heterogenity'
	AND EventMaster.participant_id NOT IN (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary','ITH-Endometrium')
	)
);

-- 'ITH-Ovary'

SET @studied_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Ovary'
	) Res
);
SET @updated_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Ovary'
		AND EventMaster.participant_id NOT IN (
			SELECT DISTINCT EventMaster.participant_id
			FROM event_masters EventMaster 
			INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
			INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
			WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Endometrium')
		)
	) Res
);
SELECT CONCAT("Updated aliquots of ", @updated_participants, " participants from a set of ", @studied_participants," participants linked to study annotation 'ITH-Ovary'.") AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT "Patient ID linked to 'ITH-Ovary' and other study ('Endometriosis','ITH-Endometrium') that could be updated." AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT CONCAT(participant_identifier, ' (participant_id=',Participant.id,')') AS "Study-Aliquot Link Creation Message"
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Ovary'
AND EventMaster.participant_id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Endometrium')
);
SET @study_summary_id = (SELECT id FROM study_summaries WHERE title = 'ITH-Ovary');
UPDATE participants SET tmp_link_aliquot_to_study_summary_id = @study_summary_id WHERE id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Ovary'
	AND EventMaster.participant_id NOT IN (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Endometrium')
	)
);

-- 'ITH-Endometrium'

SET @studied_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Endometrium'
	) Res
);
SET @updated_participants = (
	SELECT count(*) FROM (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Endometrium'
		AND EventMaster.participant_id NOT IN (
			SELECT DISTINCT EventMaster.participant_id
			FROM event_masters EventMaster 
			INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
			INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
			WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary')
		)
	) Res
);
SELECT CONCAT("Updated aliquots of ", @updated_participants, " participants from a set of ", @studied_participants," participants linked to study annotation 'ITH-Endometrium'.") AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT "Patient ID linked to 'ITH-Endometrium' and other study ('Endometriosis','ITH-Ovary') that could be updated." AS "Study-Aliquot Link Creation Message"
UNION ALL
SELECT DISTINCT CONCAT(participant_identifier, ' (participant_id=',Participant.id,')') AS "Study-Aliquot Link Creation Message"
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id
INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Endometrium'
AND EventMaster.participant_id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary')
);
SET @study_summary_id = (SELECT id FROM study_summaries WHERE title = 'ITH-Endometrium');
UPDATE participants SET tmp_link_aliquot_to_study_summary_id = @study_summary_id WHERE id IN (
	SELECT DISTINCT EventMaster.participant_id
	FROM event_masters EventMaster 
	INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
	INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
	WHERE EventMaster.deleted <> 1 AND StudySummary.title = 'ITH-Endometrium'
	AND EventMaster.participant_id NOT IN (
		SELECT DISTINCT EventMaster.participant_id
		FROM event_masters EventMaster 
		INNER JOIN ovcare_ed_study_inclusions EventDetail ON EventDetail.event_master_id = EventMaster.id
		INNER JOIN study_summaries StudySummary ON StudySummary.id = EventDetail.study_summary_id
		WHERE EventMaster.deleted <> 1 AND StudySummary.title IN ('Endometriosis','ITH-Ovary')
	)
);

-- End of process

UPDATE participants Participant,
collections Collection, 
sample_masters SampleMaster, 
aliquot_masters AliquotMaster
SET AliquotMaster.study_summary_id = Participant.tmp_link_aliquot_to_study_summary_id, 
AliquotMaster.modified = @modified, 
AliquotMaster.modified_by = @modified_by
WHERE Participant.tmp_link_aliquot_to_study_summary_id != '0'
AND Participant.id = Collection.participant_id
AND SampleMaster.collection_id = Collection.id
AND AliquotMaster.sample_master_id = SampleMaster.id
AND AliquotMaster.deleted <> 1 
AND AliquotMaster.study_summary_id IS NULL;

ALTER TABLE participants DROP COLUMN tmp_link_aliquot_to_study_summary_id;

INSERT INTO aliquot_masters_revs (id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id,
initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy,
storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, ovcare_clinical_aliquot, 
modified_by, version_created)
(SELECT id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id,
initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy,
storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, ovcare_clinical_aliquot, 
modified_by, modified FROM aliquot_masters WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_tubes_revs (aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, 
cell_viability, hemolysis_signs, ovcare_storage_method, ocvare_tissue_section, version_created) 
(SELECT aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, 
cell_viability, hemolysis_signs, ovcare_storage_method, ocvare_tissue_section, modified 
FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_blocks_revs (aliquot_master_id, block_type, patho_dpt_block_code, ocvare_tissue_section, version_created) 
(SELECT aliquot_master_id, block_type, patho_dpt_block_code, ocvare_tissue_section, modified 
FROM aliquot_masters INNER JOIN ad_blocks ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_tissue_slides_revs (aliquot_master_id, immunochemistry, ocvare_tissue_section, version_created) 
(SELECT aliquot_master_id, immunochemistry, ocvare_tissue_section, modified 
FROM aliquot_masters INNER JOIN ad_tissue_slides ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_tissue_cores_revs (aliquot_master_id, version_created) 
(SELECT aliquot_master_id, modified FROM aliquot_masters INNER JOIN ad_tissue_cores ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_whatman_papers_revs (aliquot_master_id, used_blood_volume, used_blood_volume_unit, version_created) 
(SELECT aliquot_master_id, used_blood_volume, used_blood_volume_unit, modified FROM aliquot_masters INNER JOIN ad_whatman_papers ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

INSERT INTO ad_cell_slides_revs (aliquot_master_id, immunochemistry, version_created) 
(SELECT aliquot_master_id, immunochemistry, modified FROM aliquot_masters INNER JOIN ad_cell_slides ON id = aliquot_master_id WHERE modified_by = @modified_by AND modified = @modified);

-- -------------------------------------------------------------------------------------------------------------------------------------
-- AliquotInternalUse.study_summary_id update
-- -------------------------------------------------------------------------------------------------------------------------------------

SET @modified_by = (SELECT id FROM users WHERE username = 'migration');
SET @modified = (SELECT NOW() FROM users WHERE username = 'migration');

-- TFRI COEUR

SET @study_summary_id = (SELECT id FROM study_summaries WHERE title = 'TFRI COEUR');
UPDATE participants Participant,
event_masters EventMaster,
ovcare_ed_study_inclusions EventDetail,
collections Collection,
aliquot_masters AliquotMaster,
aliquot_internal_uses AliquotInternalUse
SET AliquotInternalUse.study_summary_id = @study_summary_id,
AliquotInternalUse.modified = @modified, 
AliquotInternalUse.modified_by = @modified_by
WHERE Participant.id = EventMaster.participant_id
AND EventDetail.event_master_id = EventMaster.id
AND Participant.id = Collection.participant_id
AND AliquotMaster.collection_id = Collection.id
AND AliquotMaster.deleted <> 1 
AND AliquotInternalUse.aliquot_master_id = AliquotMaster.id
AND AliquotInternalUse.deleted <> 1 
AND AliquotInternalUse.study_summary_id IS NULL
AND AliquotInternalUse.use_code = 'To Cecile LePage';

INSERT INTO aliquot_internal_uses_revs (id, aliquot_master_id, type, use_code, use_details, used_volume, use_datetime, use_datetime_accuracy, duration, duration_unit, used_by, study_summary_id, 
ovcare_tissue_section_thickness, ovcare_tissue_section_numbers, modified_by, version_created)
(SELECT id, aliquot_master_id, type, use_code, use_details, used_volume, use_datetime, use_datetime_accuracy, duration, duration_unit, used_by, study_summary_id, 
ovcare_tissue_section_thickness, ovcare_tissue_section_numbers, modified_by, modified FROM aliquot_internal_uses WHERE modified = @modified AND modified_by = @modified_by);

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Blood creation default values
-- -------------------------------------------------------------------------------------------------------------------------------------

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_plasma_serum' AND `language_label`='storage datetime (plasma serum)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_plasma_serum' AND `language_label`='storage datetime (plasma serum)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_plasma_serum' AND `language_label`='storage datetime (plasma serum)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', '0', '', 'ovcare_creation_datetime_buffy_coat', 'datetime',  NULL , '0', '', '', '', 'creation datetime (buffy coat)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovcare_creation_datetime_buffy_coat' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation datetime (buffy coat)' AND `language_tag`=''), '1', '52', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_blood_template_init_structure') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_buffy_coat' AND `language_label`='storage datetime (buffy coat)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_buffy_coat' AND `language_label`='storage datetime (buffy coat)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='InventoryManagement' AND `model`='0' AND `tablename`='' AND `field`='ovcare_storage_datetime_buffy_coat' AND `language_label`='storage datetime (buffy coat)' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ('creation datetime (buffy coat)', 'Creation Datetime (Buffy Coat)');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Tissue Section thickness
-- -------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE aliquot_internal_uses CHANGE ovcare_tissue_section_thickness ovcare_tissue_section_thickness_um decimal(6,2) DEFAULT NULL;
ALTER TABLE aliquot_internal_uses_revs CHANGE ovcare_tissue_section_thickness ovcare_tissue_section_thickness_um decimal(6,2) DEFAULT NULL;
UPDATE structure_fields SET field = 'ovcare_tissue_section_thickness_um', language_label = 'section thickness (um)' WHERE field = 'ovcare_tissue_section_thickness';
INSERT INTO i18n (id,en,fr) VALUES ('section thickness (um)', 'Section Thickness (um)', '');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Cell Line
-- -------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE sd_der_cell_cultures ADD COLUMN ovcare_cell_line char(1) DEFAULT '';
ALTER TABLE sd_der_cell_cultures_revs ADD COLUMN ovcare_cell_line char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'ovcare_cell_line', 'yes_no',  NULL , '0', '', '', '', 'cell line', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_cell_cultures'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='ovcare_cell_line' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cell line' AND `language_tag`=''), '1', '444', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('cell line', 'Cell Line');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Reports
-- -------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_datetime_range_definition') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ctrnet_calatogue_submission_file_params') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

INSERT INTO `datamart_reports` (`name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `associated_datamart_structure_id`, `limit_access_from_datamart_structrue_function`) VALUES
('ovcare cases received - monthly report', 'ovcare cases received description - monthly report', 'ovcare_cases_received_monthly_report', 'ovcare_cases_received_monthly_report_result', 'detail', 'ovcareCasesReceivedMonthlyReport', 1, NULL, 0),
('ovcare cases received - annual report', 'ovcare cases received description - annual report', 'ovcare_cases_received_annual_report', 'ovcare_cases_received_annual_report_result', 'detail', 'ovcareCasesReceivedAnnualReport', 1, NULL, 0);
INSERT IGNORE INTO i18n (id,en)
VALUES
('ovcare cases received - monthly report', 'OvCaRe - Cases Received Monthly Report'),
('ovcare cases received - annual report', 'OvCaRe - Cases Received Annual Report'),
('ovcare cases received description - monthly report',
'Count the number of patients (cases) with specimens collected during a specific year. The data will be detailed per month and specimen type. Results can also be split per study.'),
('ovcare cases received description - annual report',
'Count the number of patients (cases) with specimens collected during a specific year. The data will be detailed per year and specimen type. Results can also be split per study.');

INSERT INTO structures(`alias`) VALUES ('ovcare_cases_received_monthly_report');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("ovcare_year_list", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("2000", "2000"),
("2020", "2020"),
("2019", "2019"),
("2018", "2018"),
("2017", "2017"),
("2016", "2016"),
("2015", "2015"),
("2014", "2014"),
("2013", "2013"),
("2012", "2012"),
("2011", "2011"),
("2010", "2010"),
("2009", "2009"),
("2008", "2008"),
("2007", "2007"),
("2006", "2006"),
("2005", "2005"),
("2004", "2004"),
("2003", "2003"),
("2002", "2002"),
("2001", "2001"),
("2000", "2000"),
("1999", "1999");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2020" AND language_alias="2020"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2019" AND language_alias="2019"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2018" AND language_alias="2018"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2017" AND language_alias="2017"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2016" AND language_alias="2016"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2015" AND language_alias="2015"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2014" AND language_alias="2014"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2013" AND language_alias="2013"), "8", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2012" AND language_alias="2012"), "9", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2011" AND language_alias="2011"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2010" AND language_alias="2010"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2009" AND language_alias="2009"), "12", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2008" AND language_alias="2008"), "13", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2007" AND language_alias="2007"), "14", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2006" AND language_alias="2006"), "15", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2005" AND language_alias="2005"), "16", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2004" AND language_alias="2004"), "17", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2003" AND language_alias="2003"), "18", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2002" AND language_alias="2002"), "19", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2001" AND language_alias="2001"), "20", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="2000" AND language_alias="2000"), "21", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ovcare_year_list"), (SELECT id FROM structure_permissible_values WHERE value="1999" AND language_alias="1999"), "22", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('Datamart', '0', '', 'year', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ovcare_year_list') , '0', '', '', '', 'year', ''),
('Datamart', '0', '', 'study_summary_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='study_list') , '0', '', '', '', 'study / project', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='year' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_year_list')), '0', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT IGNORE INTO i18n (id,en) 
VALUES 
('only one year can be selected','Only one year can be selected'),
('please select the year of this report','Please select the year of this report!');
INSERT INTO structures(`alias`) VALUES ('ovcare_cases_received_monthly_report_result');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('Datamart', '0', '', 'ovcare_month_1', 'input',  NULL , '0', '', '', '', 'jan', ''),
('Datamart', '0', '', 'ovcare_month_2', 'input',  NULL , '0', '', '', '', 'feb', ''),
('Datamart', '0', '', 'ovcare_month_3', 'input',  NULL , '0', '', '', '', 'mar', ''),
('Datamart', '0', '', 'ovcare_month_4', 'input',  NULL , '0', '', '', '', 'apr', ''),
('Datamart', '0', '', 'ovcare_month_5', 'input',  NULL , '0', '', '', '', 'may', ''),
('Datamart', '0', '', 'ovcare_month_6', 'input',  NULL , '0', '', '', '', 'jun', ''),
('Datamart', '0', '', 'ovcare_month_7', 'input',  NULL , '0', '', '', '', 'jul', ''),
('Datamart', '0', '', 'ovcare_month_8', 'input',  NULL , '0', '', '', '', 'aug', ''),
('Datamart', '0', '', 'ovcare_month_9', 'input',  NULL , '0', '', '', '', 'sep', ''),
('Datamart', '0', '', 'ovcare_month_10', 'input',  NULL , '0', '', '', '', 'oct', ''),
('Datamart', '0', '', 'ovcare_month_11', 'input',  NULL , '0', '', '', '', 'nov', ''),
('Datamart', '0', '', 'ovcare_month_12', 'input',  NULL , '0', '', '', '', 'dec', ''),
('Datamart', '0', '', 'ovcare_total', 'input',  NULL , '0', '', '', '', 'total', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_1'), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_2'), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_3'), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_4'), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_5'), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_6'), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_7'), '1', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_8'), '1', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_9'), '1', '9', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_10'), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_11'), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_month_12'), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_monthly_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_total'), '1', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO structures(`alias`) VALUES ('ovcare_cases_received_annual_report');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='study_summary_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='study / project' AND `language_tag`=''), '0', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO structures(`alias`) VALUES ('ovcare_cases_received_annual_report_result');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('Datamart', '0', '', 'ovcare_year_2020', 'input',  NULL , '0', '', '', '', '2020', ''),
('Datamart', '0', '', 'ovcare_year_2019', 'input',  NULL , '0', '', '', '', '2019', ''),
('Datamart', '0', '', 'ovcare_year_2018', 'input',  NULL , '0', '', '', '', '2018', ''),
('Datamart', '0', '', 'ovcare_year_2017', 'input',  NULL , '0', '', '', '', '2017', ''),
('Datamart', '0', '', 'ovcare_year_2016', 'input',  NULL , '0', '', '', '', '2016', ''),
('Datamart', '0', '', 'ovcare_year_2015', 'input',  NULL , '0', '', '', '', '2015', ''),
('Datamart', '0', '', 'ovcare_year_2014', 'input',  NULL , '0', '', '', '', '2014', ''),
('Datamart', '0', '', 'ovcare_year_2013', 'input',  NULL , '0', '', '', '', '2013', ''),
('Datamart', '0', '', 'ovcare_year_2012', 'input',  NULL , '0', '', '', '', '2012', ''),
('Datamart', '0', '', 'ovcare_year_2011', 'input',  NULL , '0', '', '', '', '2011', ''),
('Datamart', '0', '', 'ovcare_year_2010', 'input',  NULL , '0', '', '', '', '2010', ''),
('Datamart', '0', '', 'ovcare_year_2009', 'input',  NULL , '0', '', '', '', '2009', ''),
('Datamart', '0', '', 'ovcare_year_2008', 'input',  NULL , '0', '', '', '', '2008', ''),
('Datamart', '0', '', 'ovcare_year_2007', 'input',  NULL , '0', '', '', '', '2007', ''),
('Datamart', '0', '', 'ovcare_year_2006', 'input',  NULL , '0', '', '', '', '2006', ''),
('Datamart', '0', '', 'ovcare_year_2005', 'input',  NULL , '0', '', '', '', '2005', ''),
('Datamart', '0', '', 'ovcare_year_2004', 'input',  NULL , '0', '', '', '', '2004', ''),
('Datamart', '0', '', 'ovcare_year_2003', 'input',  NULL , '0', '', '', '', '2003', ''),
('Datamart', '0', '', 'ovcare_year_2002', 'input',  NULL , '0', '', '', '', '2002', ''),
('Datamart', '0', '', 'ovcare_year_2001', 'input',  NULL , '0', '', '', '', '2001', ''),
('Datamart', '0', '', 'ovcare_year_2000', 'input',  NULL , '0', '', '', '', '2000', ''),
('Datamart', '0', '', 'ovcare_year_other', 'input',  NULL , '0', '', '', '', 'other', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2020'), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2019'), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2018'), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2017'), '1', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2016'), '1', '14', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2015'), '1', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2014'), '1', '16', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2013'), '1', '17', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2012'), '1', '18', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2011'), '1', '19', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2010'), '1', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2009'), '1', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2008'), '1', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2007'), '1', '23', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2006'), '1', '24', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2005'), '1', '25', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2004'), '1', '26', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2003'), '1', '27', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2002'), '1', '28', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2001'), '1', '29', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_2000'), '1', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_year_other'), '1', '32', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ovcare_cases_received_annual_report_result'), (SELECT id FROM structure_fields WHERE `field`='ovcare_total'), '1', '40', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- -------------------------------------------------------------------------------------------------------------------------------------
-- Diagnosis Creation In Batch
-- -------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('ovcare_diagnosis_details_file');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FunctionManagement', '', 'ovcare_diagnosis_details_file', 'file',  NULL , '0', '', '', '', 'file', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_diagnosis_details_file'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='ovcare_diagnosis_details_file' AND `type`='file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='file' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_diagnosis_details_file'), (SELECT id FROM structure_fields WHERE `model`='Config' AND `tablename`='configs' AND `field`='define_csv_separator' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '', '0', '', '0', '', '1', '', '0', '', '0', '', '1', '', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

-- diagnosismasters
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '10', '10000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '1', '1', '0', '0', '0', '0', '0', '0');
-- dx_primary
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_history' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_clinical_diagnosis' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ovcare_tumor_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_site') AND `flag_confidential`='0');
-- ovcare_dx_ovaries_endometriums
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_laterality') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='censor' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_dx_ovaries_endometriums') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ovcare_dxd_ovaries_endometriums' AND `field`='progression_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_dx_progression_status') AND `flag_confidential`='0');
-- ovcare_ed_ovary_endometrium_path_reports_for_batch_creation
INSERT INTO structures(`alias`) VALUES ('ovcare_ed_ovary_endometrium_path_reports_for_batch_creation');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '3', '-2', 'path report', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '3', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='path_report_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_path_report_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='path report type' AND `language_tag`=''), '3', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='pathologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_pathologist')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathologist' AND `language_tag`=''), '3', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_tumor_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor grade' AND `language_tag`=''), '4', '25', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='figo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_figo')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='figo' AND `language_tag`=''), '4', '29', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='ovarian_histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_ovarian_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ovarian' AND `language_tag`=''), '4', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='uterine_histology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_uterine_histology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='uterine' AND `language_tag`=''), '4', '61', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='histopathology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_histopathology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='general' AND `language_tag`=''), '4', '59', 'histopathology', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='benign_lesions_precursor_presence' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_benign_lesions_precursor_presence')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='presence of benign lesions precursor' AND `language_tag`=''), '4', '70', 'lesions', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='fallopian_tube_lesions' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovcare_fallopian_tube_lesions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fallopian tube lesions' AND `language_tag`=''), '4', '71', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='diagnosis_report' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis' AND `language_tag`=''), '3', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='rows=3,cols=30' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FunctionManagement', '', 'ovcare_participant_voa', 'input',  NULL , '0', 'size=5', '', '', 'VOA#', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='ovcare_participant_voa' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='VOA#' AND `language_tag`=''), '0', '-10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ovcare_ed_path_reports' AND `field`='diagnosis_report' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='ovcare_participant_voa' ), 'notEmpty', '');
UPDATE structure_formats SET `flag_override_label`='1', `language_label`='path report date' WHERE structure_id=(SELECT id FROM structures WHERE alias='ovcare_ed_ovary_endometrium_path_reports_for_batch_creation') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en)
VALUES
('wrong csv file format - check csv separator or the list of missing fields', 'Wrong csv file format, check CSV separator or the list of missing fields'),
('no file has been selected','No file has been selected'),
('created %dx% diagnosis and %pr% path reports','Created %dx% diagnosis and %pr% path reports'),
('voa# unknown','VOA# unknown'),
('2 voa# are assigned to the same patient','2 VOA# are assigned to the same patient'),
('either ovary or endometrium tumor site should be selected', 'Either ovary or endometrium tumor site should be selected.'),
('diagnosis creation in batch','Diagnosis Creation in Batch'),
('file', 'File'),
('skip', 'Skip'),
('path report date', 'Path Report Date'),
('value [%s] is not value supported', 'Value [%s] is not a value supported'),
('create dx in batch', 'Create Diagnosis In Batch');






















-- ---------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6xxx' WHERE version_number = '2.6.4';
