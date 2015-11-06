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
UPDATE structure_permissible_values_custom_controls SET name = 'Path Report Type', category = 'annotation - annotation' WHERE name = 'Path Review Type';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Path Report Type')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('Path Review Type')";
UPDATE structure_permissible_values_custom_controls SET category = 'annotation - annotation' WHERE name = 'Pathologist';

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
















































-- ---------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = '6xxx' WHERE version_number = '2.6.4';
