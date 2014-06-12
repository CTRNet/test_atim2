
UPDATE lab_type_laterality_match SET selected_type_code = 'Lx' WHERE selected_type_code = 'LA';
UPDATE sample_masters SET qc_nd_sample_label = REPLACE (qc_nd_sample_label, 'LA -', 'Lx -') WHERE qc_nd_sample_label LIKE '%LA -%';
UPDATE sample_masters_revs SET qc_nd_sample_label = REPLACE (qc_nd_sample_label, 'LA -', 'Lx -') WHERE qc_nd_sample_label LIKE '%LA -%';
UPDATE specimen_details SET type_code = 'Lx' WHERE type_code = 'LA';
UPDATE specimen_details_revs SET type_code = 'Lx' WHERE type_code = 'LA';

UPDATE lab_type_laterality_match SET selected_type_code = 'AS' WHERE selected_type_code = 'OV';
UPDATE sample_masters SET qc_nd_sample_label = REPLACE (qc_nd_sample_label, 'OV -', 'AS -') WHERE qc_nd_sample_label LIKE '%OV -%';
UPDATE sample_masters_revs SET qc_nd_sample_label = REPLACE (qc_nd_sample_label, 'OV -', 'AS -') WHERE qc_nd_sample_label LIKE '%OV -%';
UPDATE specimen_details SET type_code = 'AS' WHERE type_code = 'OV';
UPDATE specimen_details_revs SET type_code = 'AS' WHERE type_code = 'OV';

INSERT INTO banks (name, misc_identifier_control_id, created_by, created, modified_by, modified) 
VALUES
('Gynecologic/Gynécologique', (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'ovary bank no lab'), 9, NOW(), 9, NOW());
INSERT INTO banks_revs (name, misc_identifier_control_id, version_created, modified_by) (SELECT name, misc_identifier_control_id, modified, modified_by FROM banks WHERE name = 'Gynecologic/Gynécologique');
UPDATE misc_identifier_controls SET misc_identifier_name = 'ovary/gyneco bank no lab' WHERE misc_identifier_name = 'ovary bank no lab';
INSERT INTO i18n (id,en,fr) VALUES ('ovary/gyneco bank no lab', "'No Labo' of Ovary/Gyneco Banks", "'No Labo' des banques Ovaire/Gynéco");

SET @nbr_of_gyneco_patients_to_create = 43;
INSERT INTO participants (first_name, last_name, `modified`, `created`, `created_by`, `modified_by`, `last_modification`, `last_modification_ds_id`) 
(SELECT id, CONCAT('Tmp-Gyneco-',id), NOW(), NOW(), 9, 9, NOW(), 4 FROM acos WHERE id <= @nbr_of_gyneco_patients_to_create);
SET @misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'ovary/gyneco bank no lab');
INSERT INTO misc_identifiers (identifier_value, misc_identifier_control_id, participant_id, flag_unique, `modified`, `created`, `created_by`, `modified_by`)
(SELECT (50000 + first_name), @misc_identifier_control_id, id, 1, NOW(), NOW(), 9, 9 FROM participants WHERE last_name LIKE 'Tmp-Gyneco-%');
INSERT INTO misc_identifiers_revs (id, identifier_value, misc_identifier_control_id, participant_id, flag_unique, `modified_by`, `version_created`)
(SELECT id, identifier_value, misc_identifier_control_id, participant_id, flag_unique, `modified_by`, `modified` FROM misc_identifiers WHERE misc_identifier_control_id = @misc_identifier_control_id AND identifier_value > 49999);
UPDATE participants SET participant_identifier = id, first_name = last_name WHERE last_name LIKE 'Tmp-Gyneco-%';
INSERT INTO participants_revs (id, first_name, last_name, `version_created`, `modified_by`, `last_modification`, last_modification_ds_id, participant_identifier) 
(SELECT id, first_name, last_name, `modified`, `modified_by`, `last_modification`, last_modification_ds_id, participant_identifier FROM participants WHERE last_name LIKE 'Tmp-Gyneco-%');

UPDATE participants SET date_of_death = approximate_date_of_death, date_of_death_accuracy = approximate_date_of_death_accuracy WHERE approximate_date_of_death is not null AND date_of_death IS NULL AND approximate_date_of_death_accuracy != 'c';
UPDATE participants SET date_of_death = approximate_date_of_death, date_of_death_accuracy = 'd' WHERE approximate_date_of_death is not null AND date_of_death IS NULL AND approximate_date_of_death_accuracy = 'c';
UPDATE participants_revs SET date_of_death = approximate_date_of_death, date_of_death_accuracy = approximate_date_of_death_accuracy WHERE approximate_date_of_death is not null AND date_of_death IS NULL AND approximate_date_of_death_accuracy != 'c';
UPDATE participants_revs SET date_of_death = approximate_date_of_death, date_of_death_accuracy = 'd' WHERE approximate_date_of_death is not null AND date_of_death IS NULL AND approximate_date_of_death_accuracy = 'c';
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='approximate_date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='sardo_medical_record_number' AND `language_label`='sardo medical record number' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='sardo_medical_record_number' AND `language_label`='sardo medical record number' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='sardo_medical_record_number' AND `language_label`='sardo medical record number' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='1');
ALTER TABLE participants DROP COLUMN sardo_medical_record_number;
ALTER TABLE participants_revs DROP COLUMN sardo_medical_record_number;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE participants ADD COLUMN qc_nd_sardo_cause_of_death varchar(250) DEFAULT null;
ALTER TABLE participants_revs ADD COLUMN qc_nd_sardo_cause_of_death varchar(250) DEFAULT null;
INSERT INTO structure_value_domains (domain_name, source) VALUES ('qc_nd_sardo_cause_of_death', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Cause of death\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) VALUES ('SARDO : Cause of death', 1, 250, 'clinical');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_cause_of_death', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_cause_of_death') , '0', '', '', '', 'cause of death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_cause_of_death' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_cause_of_death')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cause of death' AND `language_tag`=''), '3', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_column`='3', `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='is_anonymous' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='anonymous_reason' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_anonymous_reason') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='22' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='anonymous_precision' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3', `display_order`='23' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_from_center' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE participants 
  CHANGE sardo_participant_id qc_nd_sardo_rec_number varchar(20) DEFAULT NULL,
  CHANGE last_sardo_import_date qc_nd_sardo_last_import date DEFAULT NULL;
ALTER TABLE participants_revs 
  CHANGE sardo_participant_id qc_nd_sardo_rec_number varchar(20) DEFAULT NULL,
  CHANGE last_sardo_import_date qc_nd_sardo_last_import date DEFAULT NULL;
UPDATE structure_fields SET field = 'qc_nd_sardo_rec_number' WHERE field = 'sardo_participant_id' AND tablename = 'participants';
UPDATE structure_fields SET field = 'qc_nd_sardo_last_import' WHERE field = 'last_sardo_import_date' AND tablename = 'participants';

ALTER TABLE participants 
  ADD COLUMN  qc_nd_sardo_diff_first_name CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_last_name CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_date_of_birth CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_sex CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_ramq CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_hd_nbr CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_sl_nbr CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_nd_nbr CHAR(1) DEFAULT '';
ALTER TABLE participants_revs
  ADD COLUMN  qc_nd_sardo_diff_first_name CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_last_name CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_date_of_birth CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_sex CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_ramq CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_hd_nbr CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_sl_nbr CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_nd_nbr CHAR(1) DEFAULT ''; 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_diff_first_name', 'yes_no',  NULL , '0', '', '', '', 'first name', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_diff_last_name', 'yes_no',  NULL , '0', '', '', '', 'last name', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_diff_date_of_birth', 'yes_no',  NULL , '0', '', '', '', 'date of birth', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_diff_sex', 'yes_no',  NULL , '0', '', '', '', 'sex', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_diff_ramq', 'yes_no',  NULL , '0', '', '', '', 'ramq nbr', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_diff_hd_nbr', 'yes_no',  NULL , '0', '', '', '', 'hotel-dieu id nbr', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_diff_sl_nbr', 'yes_no',  NULL , '0', '', '', '', 'saint-luc id nbr', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_diff_nd_nbr', 'yes_no',  NULL , '0', '', '', '', 'notre-dame id nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_first_name' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='first name' AND `language_tag`=''), '4', '15', 'icm-sardo mismatches', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_last_name' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last name' AND `language_tag`=''), '4', '16', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_date_of_birth' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date of birth' AND `language_tag`=''), '4', '17', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_sex' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sex' AND `language_tag`=''), '4', '18', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_ramq' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ramq nbr' AND `language_tag`=''), '4', '19', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_hd_nbr' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hotel-dieu id nbr' AND `language_tag`=''), '4', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_sl_nbr' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='saint-luc id nbr' AND `language_tag`=''), '4', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_nd_nbr' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='notre-dame id nbr' AND `language_tag`=''), '4', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='98' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='99' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('icm-sardo mismatches', 'ICM-SARDO Mismatches', 'Différences ICM-SARDO');

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/%lab%';
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'procure', 'lab', 'ca125', 1, 'qc_nd_ed_ca125s', 'qc_nd_ed_ca125s', 0, 'lab|ca125', 0, 1, 1),
(null, 'procure', 'lab', 'psa', 1, 'qc_nd_ed_psas', 'qc_nd_ed_psas', 0, 'lab|psa', 0, 1, 1);
CREATE TABLE IF NOT EXISTS `qc_nd_ed_psas` (
  value float(8,3) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_ed_psas_revs` (
  value float(8,3) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_ed_psas`
  ADD CONSTRAINT `qc_nd_ed_psas_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
CREATE TABLE IF NOT EXISTS `qc_nd_ed_ca125s` (
  value float(8,2) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_ed_ca125s_revs` (
  value float(8,2) DEFAULT NULL,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_ed_ca125s`
  ADD CONSTRAINT `qc_nd_ed_ca125s_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_psas');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_psas', 'value', 'float_positive',  NULL , '0', 'size=6', '', '', 'value', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_psas'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '2', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_psas'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_psas' AND `field`='value' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='value' AND `language_tag`=''), '2', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_ca125s');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_ca125s', 'value', 'float_positive',  NULL , '0', 'size=6', '', '', 'value', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_ca125s'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '2', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_ca125s'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_ca125s' AND `field`='value' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='value' AND `language_tag`=''), '2', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('psa', 'PSA','APS');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_psas' AND `field`='value'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `tablename`='qc_nd_ed_ca125s' AND `field`='value'), 'notEmpty');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'lab', 'estrogen receptor report (RE)', 1, 'qc_nd_ed_estrogen_receptor_reports', 'qc_nd_ed_estrogen_receptor_reports', 0, 'lab|estrogen receptor report (RE)', 0, 1, 1);
CREATE TABLE IF NOT EXISTS `qc_nd_ed_estrogen_receptor_reports` (
	result varchar(250),
	percentage float(8,1) DEFAULT NULL,
	intensity varchar(10),
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_ed_estrogen_receptor_reports_revs` (
  value float(8,3) DEFAULT NULL,
  	result varchar(250),
	percentage float(8,1) DEFAULT NULL,
	intensity varchar(10),
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_ed_estrogen_receptor_reports`
  ADD CONSTRAINT `qc_nd_ed_estrogen_receptor_reports_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_estrogen_receptor_reports');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_sardo_estrogen_receptor_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Estrogen Receptor Results\')"),
('qc_nd_sardo_estrogen_receptor_intensities', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Estrogen Receptor Intensities\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('SARDO : Estrogen Receptor Results', 1, 250, 'clinical - annotation'),
('SARDO : Estrogen Receptor Intensities', 1, 10, 'clinical - annotation');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_estrogen_receptor_reports', 'result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_estrogen_receptor_results') , '0', '', '', '', 'result', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_estrogen_receptor_reports', 'percentage', 'float_positive',  NULL , '0', '', '', '', 'percentage', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_estrogen_receptor_reports', 'intensity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_estrogen_receptor_intensities') , '0', '', '', '', 'intensity', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_estrogen_receptor_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '2', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_estrogen_receptor_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_estrogen_receptor_reports' AND `field`='result' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_estrogen_receptor_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '2', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_estrogen_receptor_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_estrogen_receptor_reports' AND `field`='percentage' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='percentage' AND `language_tag`=''), '2', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_estrogen_receptor_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_estrogen_receptor_reports' AND `field`='intensity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_estrogen_receptor_intensities')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='intensity' AND `language_tag`=''), '2', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES 
('estrogen receptor report (RE)','Estrogen Receptor Report (RE)','Rapport récepteurs aux oestrogènes (RE)'),
('percentage','Percentage','Pourcentage'),
('intensity','Intensity','Intensité');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'lab', 'progestin receptor report (RP)', 1, 'qc_nd_ed_progestin_receptor_reports', 'qc_nd_ed_progestin_receptor_reports', 0, 'lab|progestin receptor report (RP)', 0, 1, 1);
CREATE TABLE IF NOT EXISTS `qc_nd_ed_progestin_receptor_reports` (
	result varchar(250),
	percentage float(8,1) DEFAULT NULL,
	intensity varchar(10),
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_ed_progestin_receptor_reports_revs` (
  value float(8,3) DEFAULT NULL,
  	result varchar(250),
	percentage float(8,1) DEFAULT NULL,
	intensity varchar(10),
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_ed_progestin_receptor_reports`
  ADD CONSTRAINT `qc_nd_ed_progestin_receptor_reports_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_progestin_receptor_reports');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_sardo_progestin_receptor_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Progestin Receptor Results\')"),
('qc_nd_sardo_progestin_receptor_intensities', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Progestin Receptor Intensities\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('SARDO : Progestin Receptor Results', 1, 250, 'clinical - annotation'),
('SARDO : Progestin Receptor Intensities', 1, 10, 'clinical - annotation');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_progestin_receptor_reports', 'result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_progestin_receptor_results') , '0', '', '', '', 'result', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_progestin_receptor_reports', 'percentage', 'float_positive',  NULL , '0', '', '', '', 'percentage', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_progestin_receptor_reports', 'intensity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_progestin_receptor_intensities') , '0', '', '', '', 'intensity', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_progestin_receptor_reports'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '2', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_progestin_receptor_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_progestin_receptor_reports' AND `field`='result' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_progestin_receptor_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '2', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_progestin_receptor_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_progestin_receptor_reports' AND `field`='percentage' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='percentage' AND `language_tag`=''), '2', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_progestin_receptor_reports'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_progestin_receptor_reports' AND `field`='intensity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_progestin_receptor_intensities')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='intensity' AND `language_tag`=''), '2', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES 
('progestin receptor report (RP)','Progestin Receptor Report (RP)','Rapport Récepteurs aux progestatifs (RP)');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'lab', 'her2/neu', 1, 'qc_nd_ed_her2_neu', 'qc_nd_ed_her2_neu', 0, 'lab|her2/neu', 0, 1, 1),
(null, '', 'lab', 'her2/neu - FISH', 1, 'qc_nd_ed_her2_neu', 'qc_nd_ed_her2_neu', 0, 'lab|her2/neu - FISH', 0, 1, 1);
CREATE TABLE IF NOT EXISTS `qc_nd_ed_her2_neu` (
	result varchar(250),
	intensity varchar(10),
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_ed_her2_neu_revs` (
  value float(8,3) DEFAULT NULL,
  	result varchar(250),
	intensity varchar(10),
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_ed_her2_neu`
  ADD CONSTRAINT `qc_nd_ed_her2_neu_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_nd_ed_her2_neu');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_sardo_her2_neu_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : HER2/NEU Results\')"),
('qc_nd_sardo_her2_neu_intensities', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : HER2/NEU Intensities\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('SARDO : HER2/NEU Results', 1, 250, 'clinical - annotation'),
('SARDO : HER2/NEU Intensities', 1, 10, 'clinical - annotation');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_her2_neu', 'result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_her2_neu_results') , '0', '', '', '', 'result', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_her2_neu', 'intensity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_her2_neu_intensities') , '0', '', '', '', 'intensity', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_her2_neu'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '2', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_her2_neu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_her2_neu' AND `field`='result' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_her2_neu_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '2', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_ed_her2_neu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_her2_neu' AND `field`='intensity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_her2_neu_intensities')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='intensity' AND `language_tag`=''), '2', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES 
('her2/neu','HER2/NEU','HER2/NEU'),
('her2/neu - FISH', 'HER2/NEU - FISH', 'HER2/NEU - FISH');
  
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE event_controls SET databrowser_label = concat(event_group, '|',event_type);
UPDATE event_controls SET disease_site = '';
UPDATE menus set use_link = '/ClinicalAnnotation/EventMasters/listall/lab/%%Participant.id%%' WHERE id = 'clin_CAN_4';

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/Diagnosis%';
INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) 
VALUES
(null, 'primary', 'sardo', 1, 'qc_nd_dx_primary_sardos', 'qc_nd_dx_primary_sardos', 0, 'primary|sardo', 0);
INSERT INTO structures(`alias`) VALUES ('qc_nd_dx_primary_sardos');
ALTER TABLE diagnosis_masters 
  ADD COLUMN qc_nd_sardo_morphology_desc VARCHAR(250),
  ADD COLUMN qc_nd_sardo_topography_desc VARCHAR(250);
ALTER TABLE diagnosis_masters_revs
  ADD COLUMN qc_nd_sardo_morphology_desc VARCHAR(250),
  ADD COLUMN qc_nd_sardo_topography_desc VARCHAR(250);
ALTER TABLE diagnosis_masters 
  ADD COLUMN `survival_time_months` int(11) DEFAULT NULL;
ALTER TABLE diagnosis_masters_revs 
  ADD COLUMN `survival_time_months` int(11) DEFAULT NULL; 
CREATE TABLE IF NOT EXISTS `qc_nd_dx_primary_sardos` (
  `diagnosis_master_id` int(11) NOT NULL,
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `figo` varchar(10) NOT NULL DEFAULT '',
  `codetnmg` varchar(10) NOT NULL DEFAULT '',
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_dx_primary_sardos_revs` (
  `diagnosis_master_id` int(11) NOT NULL,
  `laterality` varchar(50) NOT NULL DEFAULT '',
  `figo` varchar(10) NOT NULL DEFAULT '',
  `codetnmg` varchar(10) NOT NULL DEFAULT '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_dx_primary_sardos`
  ADD CONSTRAINT `qc_nd_dx_primary_sardos_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_sardo_morpho', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Morpho Codes\')"),
('qc_nd_sardo_morpho_description', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Morpho Descriptions\')"),
('qc_nd_sardo_topo', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Topo Codes\')"),
('qc_nd_sardo_topo_description', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Topo Descriptions\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('SARDO : Morpho Codes', 1, 50, 'clinical - diagnosis'),
('SARDO : Morpho Descriptions', 1, 250, 'clinical - diagnosis'),
('SARDO : Topo Codes', 1, 50, 'clinical - diagnosis'),
('SARDO : Topo Descriptions', 1, 250, 'clinical - diagnosis');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'morphology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho') , '0', '', '', '', 'morphology', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'topography', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_topo') , '0', '', '', '', 'topography', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_nd_sardo_morphology_desc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho_description') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_nd_sardo_topography_desc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_topo_description') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_nd_sardo_morphology_desc', 'input',  NULL , '0', 'size=10', '', '', '', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'qc_nd_sardo_topography_desc', 'input',  NULL , '0', 'size=10', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='morphology' AND `language_tag`=''), '2', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_topo')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='topography' AND `language_tag`=''), '2', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_survival time' AND `language_label`='survival time months' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_morphology_desc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho_description')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_topography_desc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_topo_description')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_morphology_desc' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_topography_desc' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_sardo_laterality', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Laterality\')"),
('qc_nd_sardo_grade', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Grade\')"),
('qc_nd_sardo_TNMcT', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : TNMcT\')"),
('qc_nd_sardo_TNMcN', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : TNMcN\')"),
('qc_nd_sardo_TNMcM', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : TNMcM\')"),
('qc_nd_sardo_TNMcsummary', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : TNMc Summary\')"),
('qc_nd_sardo_TNMpT', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : TNMpT\')"),
('qc_nd_sardo_TNMpN', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : TNMpN\')"),
('qc_nd_sardo_TNMpM', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : TNMpM\')"),
('qc_nd_sardo_TNMpsummary', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : TNMp Summary\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('SARDO : Grade', 1, 150, 'clinical - diagnosis'),
('SARDO : TNMcT', 1, 10, 'clinical - diagnosis'),
('SARDO : TNMcN', 1, 5, 'clinical - diagnosis'),
('SARDO : TNMcM', 1, 5, 'clinical - diagnosis'),
('SARDO : TNMc Summary', 1, 5, 'clinical - diagnosis'),
('SARDO : TNMpT', 1, 20, 'clinical - diagnosis'),
('SARDO : TNMpN', 1, 20, 'clinical - diagnosis'),
('SARDO : TNMpM', 1, 20, 'clinical - diagnosis'),
('SARDO : TNMp Summary', 1, 5, 'clinical - diagnosis'),
('SARDO : Laterality', 1, 50, 'clinical - diagnosis');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_nd_dx_primary_sardos', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_laterality') , '0', '', '', 'dx_laterality', 'laterality', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_grade') , '0', '', '', 'help_tumour grade', 'tumour grade', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcT') , '0', '', '', '', 'clinical stage', 't stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcN') , '0', '', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcM') , '0', '', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_stage_summary', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcsummary') , '0', '', '', '', '', 'summary'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_tstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpT') , '0', '', '', '', 'pathological stage', 't stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_nstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpN') , '0', '', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_mstage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpM') , '0', '', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'path_stage_summary', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpsummary') , '0', '', '', '', '', 'summary');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dx_primary_sardos' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '2', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tumour grade' AND `language_label`='tumour grade' AND `language_tag`=''), '1', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcT')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='t stage'), '2', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcN')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcM')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcsummary')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='summary'), '2', '34', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpT')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='t stage'), '2', '35', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpN')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '2', '36', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpM')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '2', '37', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpsummary')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='summary'), '2', '38', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='16' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='15' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dx_primary_sardos' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_laterality') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='17' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_morphology_desc' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='18' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_morphology_desc' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho_description') AND `flag_confidential`='0');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_sardo_figo', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : FIGO\')"),
('qc_nd_sardo_tnmg', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : TNMg\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('SARDO : FIGO', 1, 10, 'clinical - diagnosis'),
('SARDO : TNMg', 1, 10, 'clinical - diagnosis');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_nd_dx_primary_sardos', 'figo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_figo') , '0', '', '', '', 'figo', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_nd_dx_primary_sardos', 'codetnmg', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_tnmg') , '0', '', '', '', 'tnmg', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dx_primary_sardos' AND `field`='figo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_figo')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='figo' AND `language_tag`=''), '1', '31', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dx_primary_sardos' AND `field`='codetnmg' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_tnmg')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tnmg' AND `language_tag`=''), '2', '39', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster')) AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster')) AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('Participant'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('EventMaster')) AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('TreatmentMaster')) AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('Participant'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('TreatmentMaster')) AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('DiagnosisMaster'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('TreatmentExtendMaster')) AND id2 IN (SELECT id FROM datamart_structures WHERE model IN ('TreatmentMaster'));
INSERT INTO i18n (id,en,fr) VALUES ('sardo', 'SARDO', 'SARDO'),('tnmg', 'TNMg', 'TNMg');
UPDATE structure_fields SET field = 'qc_nd_sardo_morphology_key_words' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='qc_nd_sardo_morphology_desc' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET field = 'qc_nd_sardo_topography_key_words' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='qc_nd_sardo_topography_desc' AND `type`='input' AND structure_value_domain  IS NULL ;
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_topography_desc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_topo_description')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dx_primary_sardos' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '1', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field` IN ('icd10_code','topography'));
UPDATE structure_formats SET `flag_override_label`='1', language_label = '-' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field` IN ('qc_nd_sardo_topography_desc'));
INSERT INTO i18n (id,en,fr) VALUES ('no event can be linked to a diagnosis because diagnosis data comes from SARDO','No annotation can be linked to a diagnosis because diagnosis data comes from SARDO','Aucune annotation ne peut être liée à un diagnostic car les données de diagnostic proviennent de SARDO');
