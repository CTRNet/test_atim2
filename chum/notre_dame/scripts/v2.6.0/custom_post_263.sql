
UPDATE lab_type_laterality_match SET selected_type_code = 'Lx' WHERE selected_type_code = 'LA';
UPDATE sample_masters SET qc_nd_sample_label = REPLACE (qc_nd_sample_label, 'LA -', 'Lx -') WHERE qc_nd_sample_label LIKE '%LA -%';
UPDATE sample_masters_revs SET qc_nd_sample_label = REPLACE (qc_nd_sample_label, 'LA -', 'Lx -') WHERE qc_nd_sample_label LIKE '%LA -%';
UPDATE specimen_details SET type_code = 'Lx' WHERE type_code = 'LA';
UPDATE specimen_details_revs SET type_code = 'Lx' WHERE type_code = 'LA';

UPDATE lab_type_laterality_match SET selected_type_code = 'AS' WHERE selected_type_code = 'OV';
UPDATE sample_masters SET qc_nd_sample_label = REPLACE (qc_nd_sample_label, ' OV -', ' AS -') WHERE qc_nd_sample_label LIKE '% OV -%';
UPDATE sample_masters_revs SET qc_nd_sample_label = REPLACE (qc_nd_sample_label, ' OV -', ' AS -') WHERE qc_nd_sample_label LIKE '% OV -%';
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
(null, '', 'lab', 'her2/neu', 1, 'qc_nd_ed_her2_neu', 'qc_nd_ed_her2_neu', 0, 'lab|her2/neu', 0, 1, 1);
CREATE TABLE IF NOT EXISTS `qc_nd_ed_her2_neu` (
	result varchar(250),
	intensity varchar(10),
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_ed_her2_neu_revs` (
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
('her2/neu','HER2/NEU','HER2/NEU');
  
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

ALTER TABLE `qc_nd_ed_her2_neu` ADD COLUMN fish CHAR(1) DEFAULT '';
ALTER TABLE `qc_nd_ed_her2_neu_revs` ADD COLUMN fish CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_nd_ed_her2_neu', 'fish', 'yes_no',  NULL , '0', '', '', '', 'fish', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_ed_her2_neu'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_nd_ed_her2_neu' AND `field`='fish' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fish' AND `language_tag`=''), '2', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_nd_sardo_estrogen_receptor_results') WHERE structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_nd_sardo_progestin_receptor_results');
UPDATE structure_fields SET structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_nd_sardo_estrogen_receptor_intensities') WHERE structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name = 'qc_nd_sardo_progestin_receptor_intensities');
DELETE FROM structure_value_domains WHERE domain_name IN ('qc_nd_sardo_progestin_receptor_results', 'qc_nd_sardo_progestin_receptor_intensities');
DELETE FROM structure_permissible_values_custom_controls WHERE name IN ('SARDO : Progestin Receptor Results', 'SARDO : Progestin Receptor Intensities');
UPDATE structure_value_domains SET  domain_name = 'qc_nd_sardo_estrogen_progestin_receptor_results' WHERE domain_name = 'qc_nd_sardo_estrogen_receptor_results';
UPDATE structure_value_domains SET  domain_name = 'qc_nd_sardo_estrogen_progestin_receptor_intensities' WHERE domain_name = 'qc_nd_sardo_estrogen_receptor_intensities';
UPDATE structure_permissible_values_custom_controls SET name = 'SARDO : Estrogen/Progestin Receptor Results' WHERE name = 'SARDO : Estrogen Receptor Results';
UPDATE structure_permissible_values_custom_controls SET name = 'SARDO : Estrogen/Progestin Receptor Intensities' WHERE name = 'SARDO : Estrogen Receptor Intensities';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Estrogen/Progestin Receptor Results\')" WHERE domain_name = 'qc_nd_sardo_estrogen_progestin_receptor_results';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : Estrogen/Progestin Receptor Intensities\')" WHERE domain_name = 'qc_nd_sardo_estrogen_progestin_receptor_intensities';





INSERT INTO treatment_extend_controls (id, detail_tablename, detail_form_alias, flag_active, `type`, databrowser_label) VALUES
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_radio', 1, 'sardo treatment extend - radio', 'sardo treatment extend - radio'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_chir', 1, 'sardo treatment extend - chir', 'sardo treatment extend - chir'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_image', 1, 'sardo treatment extend - image', 'sardo treatment extend - image'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_biop', 1, 'sardo treatment extend - biop', 'sardo treatment extend - biop'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_horm', 1, 'sardo treatment extend - horm', 'sardo treatment extend - horm'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_chimio', 1, 'sardo treatment extend - chimio', 'sardo treatment extend - chimio'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_pal', 1, 'sardo treatment extend - pal', 'sardo treatment extend - pal'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_autre', 1, 'sardo treatment extend - autre', 'sardo treatment extend - autre'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_cyto', 1, 'sardo treatment extend - cyto', 'sardo treatment extend - cyto'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_protoc', 1, 'sardo treatment extend - protoc', 'sardo treatment extend - protoc'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_bilan', 1, 'sardo treatment extend - bilan', 'sardo treatment extend - bilan'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_revision', 1, 'sardo treatment extend - revision', 'sardo treatment extend - revision'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_immuno', 1, 'sardo treatment extend - immuno', 'sardo treatment extend - immuno'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_medic', 1, 'sardo treatment extend - medic', 'sardo treatment extend - medic'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_exam', 1, 'sardo treatment extend - exam', 'sardo treatment extend - exam'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_obs', 1, 'sardo treatment extend - obs', 'sardo treatment extend - obs'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_visite', 1, 'sardo treatment extend - visite', 'sardo treatment extend - visite'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_sympt', 1, 'sardo treatment extend - sympt', 'sardo treatment extend - sympt'),
(null, 'qc_nd_txe_sardos', 'qc_nd_txe_sardos_resume', 1, 'sardo treatment extend - resume', 'sardo treatment extend - resume');
INSERT INTO treatment_controls (id, tx_method, disease_site, flag_active, detail_tablename, detail_form_alias, display_order, databrowser_label, flag_use_for_ccl, treatment_extend_control_id) VALUES
(null, 'sardo treatment - radio', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_radio', 0, 'sardo treatment - radio', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_radio')),
(null, 'sardo treatment - chir', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_chir', 0, 'sardo treatment - chir', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_chir')),
(null, 'sardo treatment - image', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_image', 0, 'sardo treatment - image', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_image')),
(null, 'sardo treatment - biop', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_biop', 0, 'sardo treatment - biop', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_biop')),
(null, 'sardo treatment - horm', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_horm', 0, 'sardo treatment - horm', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_horm')),
(null, 'sardo treatment - chimio', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_chimio', 0, 'sardo treatment - chimio', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_chimio')),
(null, 'sardo treatment - pal', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_pal', 0, 'sardo treatment - pal', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_pal')),
(null, 'sardo treatment - autre', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_autre', 0, 'sardo treatment - autre', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_autre')),
(null, 'sardo treatment - cyto', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_cyto', 0, 'sardo treatment - cyto', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_cyto')),
(null, 'sardo treatment - protoc', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_protoc', 0, 'sardo treatment - protoc', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_protoc')),
(null, 'sardo treatment - bilan', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_bilan', 0, 'sardo treatment - bilan', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_bilan')),
(null, 'sardo treatment - revision', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_revision', 0, 'sardo treatment - revision', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_revision')),
(null, 'sardo treatment - immuno', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_immuno', 0, 'sardo treatment - immuno', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_immuno')),
(null, 'sardo treatment - medic', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_medic', 0, 'sardo treatment - medic', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_medic')),
(null, 'sardo treatment - exam', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_exam', 0, 'sardo treatment - exam', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_exam')),
(null, 'sardo treatment - obs', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_obs', 0, 'sardo treatment - obs', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_obs')),
(null, 'sardo treatment - visite', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_visite', 0, 'sardo treatment - visite', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_visite')),
(null, 'sardo treatment - sympt', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_sympt', 0, 'sardo treatment - sympt', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_sympt')),
(null, 'sardo treatment - resume', '', 1, 'qc_nd_txd_sardos', 'qc_nd_txd_sardos_resume', 0, 'sardo treatment - resume', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qc_nd_txe_sardos_resume'));
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_detail`='1', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
CREATE TABLE qc_nd_txd_sardos (
  patho_nbr varchar(100) DEFAULT null,
  results varchar(250) DEFAULT null,
  objectifs varchar(250) DEFAULT null,
  treatment_master_id int(11) NOT NULL,
  KEY tx_master_id (treatment_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE qc_nd_txd_sardos_revs (
  patho_nbr varchar(100) DEFAULT null,
  results varchar(250) DEFAULT null,
  objectifs varchar(250) DEFAULT null,
  treatment_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `qc_nd_txd_sardos`
  ADD CONSTRAINT qc_nd_txd_sardos_ibfk_1 FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters (id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'patho_nbr', 'input',  NULL , '0', 'size=10', '', '', 'patho nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structures(`alias`) 
VALUES 
('qc_nd_txd_sardos_radio'),
('qc_nd_txd_sardos_chir'),
('qc_nd_txd_sardos_image'),
('qc_nd_txd_sardos_biop'),
('qc_nd_txd_sardos_horm'),
('qc_nd_txd_sardos_chimio'),
('qc_nd_txd_sardos_pal'),
('qc_nd_txd_sardos_autre'),
('qc_nd_txd_sardos_cyto'),
('qc_nd_txd_sardos_protoc'),
('qc_nd_txd_sardos_bilan'),
('qc_nd_txd_sardos_revision'),
('qc_nd_txd_sardos_immuno'),
('qc_nd_txd_sardos_medic'),
('qc_nd_txd_sardos_exam'),
('qc_nd_txd_sardos_obs'),
('qc_nd_txd_sardos_visite'),
('qc_nd_txd_sardos_sympt'),
('qc_nd_txd_sardos_resume');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_radio'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_chir'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_image'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_biop'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_horm'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_chimio'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_pal'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_autre'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_cyto'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_protoc'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_bilan'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_revision'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_immuno'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_medic'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_exam'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_obs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_visite'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_sympt'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_resume'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_sardo_radio_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : RADIO Results\')"),
('qc_nd_sardo_chir_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : CHIR Results\')"),
('qc_nd_sardo_image_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : IMAGE Results\')"),
('qc_nd_sardo_biop_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : BIOP Results\')"),
('qc_nd_sardo_horm_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : HORM Results\')"),
('qc_nd_sardo_chimio_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : CHIMIO Results\')"),
('qc_nd_sardo_pal_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : PAL Results\')"),
('qc_nd_sardo_autre_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : AUTRE Results\')"),
('qc_nd_sardo_cyto_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : CYTO Results\')"),
('qc_nd_sardo_protoc_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : PROTOC Results\')"),
('qc_nd_sardo_bilan_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : BILAN Results\')"),
('qc_nd_sardo_revision_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : REVISION Results\')"),
('qc_nd_sardo_immuno_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : IMMUNO Results\')"),
('qc_nd_sardo_medic_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : MEDIC Results\')"),
('qc_nd_sardo_exam_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : EXAM Results\')"),
('qc_nd_sardo_obs_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : OBS Results\')"),
('qc_nd_sardo_visite_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : VISITE Results\')"),
('qc_nd_sardo_sympt_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : SYMPT Results\')"),
('qc_nd_sardo_resume_results', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : RESUME Results\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('SARDO : RADIO Results', 1, 250, 'clinical - treatment'),
('SARDO : CHIR Results', 1, 250, 'clinical - treatment'),
('SARDO : IMAGE Results', 1, 250, 'clinical - treatment'),
('SARDO : BIOP Results', 1, 250, 'clinical - treatment'),
('SARDO : HORM Results', 1, 250, 'clinical - treatment'),
('SARDO : CHIMIO Results', 1, 250, 'clinical - treatment'),
('SARDO : PAL Results', 1, 250, 'clinical - treatment'),
('SARDO : AUTRE Results', 1, 250, 'clinical - treatment'),
('SARDO : CYTO Results', 1, 250, 'clinical - treatment'),
('SARDO : PROTOC Results', 1, 250, 'clinical - treatment'),
('SARDO : BILAN Results', 1, 250, 'clinical - treatment'),
('SARDO : REVISION Results', 1, 250, 'clinical - treatment'),
('SARDO : IMMUNO Results', 1, 250, 'clinical - treatment'),
('SARDO : MEDIC Results', 1, 250, 'clinical - treatment'),
('SARDO : EXAM Results', 1, 250, 'clinical - treatment'),
('SARDO : OBS Results', 1, 250, 'clinical - treatment'),
('SARDO : VISITE Results', 1, 250, 'clinical - treatment'),
('SARDO : SYMPT Results', 1, 250, 'clinical - treatment'),
('SARDO : RESUME Results', 1, 250, 'clinical - treatment');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_radio_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chir_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_image_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_biop_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_horm_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chimio_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_pal_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_autre_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_cyto_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_protoc_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_bilan_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_revision_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_immuno_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_medic_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_exam_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_obs_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_visite_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_sympt_results') , '0', '', '', '', 'results', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'results', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_resume_results') , '0', '', '', '', 'results', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_radio'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_radio_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_chir'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chir_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_image'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_image_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_biop'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_biop_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_horm'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_horm_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_chimio'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chimio_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_pal'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_pal_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_autre'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_autre_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_cyto'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_cyto_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_protoc'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_protoc_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_bilan'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_bilan_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_revision'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_revision_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_immuno'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_immuno_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_medic'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_medic_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_exam'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_exam_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_obs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_obs_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_visite'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_visite_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_sympt'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_sympt_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_resume'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='results' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_resume_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='results' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_sardo_radio_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : RADIO Objectifs\')"),
('qc_nd_sardo_chir_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : CHIR Objectifs\')"),
('qc_nd_sardo_image_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : IMAGE Objectifs\')"),
('qc_nd_sardo_biop_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : BIOP Objectifs\')"),
('qc_nd_sardo_horm_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : HORM Objectifs\')"),
('qc_nd_sardo_chimio_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : CHIMIO Objectifs\')"),
('qc_nd_sardo_pal_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : PAL Objectifs\')"),
('qc_nd_sardo_autre_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : AUTRE Objectifs\')"),
('qc_nd_sardo_cyto_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : CYTO Objectifs\')"),
('qc_nd_sardo_protoc_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : PROTOC Objectifs\')"),
('qc_nd_sardo_bilan_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : BILAN Objectifs\')"),
('qc_nd_sardo_revision_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : REVISION Objectifs\')"),
('qc_nd_sardo_immuno_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : IMMUNO Objectifs\')"),
('qc_nd_sardo_medic_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : MEDIC Objectifs\')"),
('qc_nd_sardo_exam_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : EXAM Objectifs\')"),
('qc_nd_sardo_obs_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : OBS Objectifs\')"),
('qc_nd_sardo_visite_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : VISITE Objectifs\')"),
('qc_nd_sardo_sympt_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : SYMPT Objectifs\')"),
('qc_nd_sardo_resume_objectifs', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : RESUME Objectifs\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('SARDO : RADIO Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : CHIR Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : IMAGE Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : BIOP Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : HORM Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : CHIMIO Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : PAL Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : AUTRE Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : CYTO Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : PROTOC Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : BILAN Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : REVISION Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : IMMUNO Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : MEDIC Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : EXAM Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : OBS Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : VISITE Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : SYMPT Objectifs', 1, 250, 'clinical - treatment'),
('SARDO : RESUME Objectifs', 1, 250, 'clinical - treatment');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_radio_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chir_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_image_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_biop_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_horm_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chimio_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_pal_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_autre_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_cyto_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_protoc_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_bilan_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_revision_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_immuno_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_medic_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_exam_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_obs_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_visite_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_sympt_objectifs') , '0', '', '', '', 'objectifs', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txd_sardos', 'objectifs', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_resume_objectifs') , '0', '', '', '', 'objectifs', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_radio'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_radio_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_chir'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chir_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_image'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_image_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_biop'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_biop_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_horm'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_horm_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_chimio'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chimio_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_pal'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_pal_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_autre'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_autre_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_cyto'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_cyto_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_protoc'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_protoc_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_bilan'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_bilan_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_revision'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_revision_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_immuno'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_immuno_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_medic'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_medic_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_exam'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_exam_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_obs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_obs_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_visite'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_visite_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_sympt'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_sympt_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txd_sardos_resume'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='objectifs' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_resume_objectifs')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='objectifs' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
CREATE TABLE qc_nd_txe_sardos (
  treatment varchar(250) default null,
  treatment_extend_master_id int(11) NOT NULL,
  KEY FK_qc_nd_txe_sardos_treatment_extend_masters (treatment_extend_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE qc_nd_txe_sardos_revs (
  treatment varchar(250) default null,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  treatment_extend_master_id int(11) NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `qc_nd_txe_sardos`
  ADD CONSTRAINT FK_qc_nd_txe_sardos_treatment_extend_masters FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id);
INSERT INTO structures(`alias`) 
VALUES 
('qc_nd_txe_sardos_radio'),
('qc_nd_txe_sardos_chir'),
('qc_nd_txe_sardos_image'),
('qc_nd_txe_sardos_biop'),
('qc_nd_txe_sardos_horm'),
('qc_nd_txe_sardos_chimio'),
('qc_nd_txe_sardos_pal'),
('qc_nd_txe_sardos_autre'),
('qc_nd_txe_sardos_cyto'),
('qc_nd_txe_sardos_protoc'),
('qc_nd_txe_sardos_bilan'),
('qc_nd_txe_sardos_revision'),
('qc_nd_txe_sardos_immuno'),
('qc_nd_txe_sardos_medic'),
('qc_nd_txe_sardos_exam'),
('qc_nd_txe_sardos_obs'),
('qc_nd_txe_sardos_visite'),
('qc_nd_txe_sardos_sympt'),
('qc_nd_txe_sardos_resume');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_nd_sardo_radio_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : RADIO Treatments\')"),
('qc_nd_sardo_chir_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : CHIR Treatments\')"),
('qc_nd_sardo_image_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : IMAGE Treatments\')"),
('qc_nd_sardo_biop_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : BIOP Treatments\')"),
('qc_nd_sardo_horm_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : HORM Treatments\')"),
('qc_nd_sardo_chimio_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : CHIMIO Treatments\')"),
('qc_nd_sardo_pal_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : PAL Treatments\')"),
('qc_nd_sardo_autre_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : AUTRE Treatments\')"),
('qc_nd_sardo_cyto_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : CYTO Treatments\')"),
('qc_nd_sardo_protoc_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : PROTOC Treatments\')"),
('qc_nd_sardo_bilan_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : BILAN Treatments\')"),
('qc_nd_sardo_revision_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : REVISION Treatments\')"),
('qc_nd_sardo_immuno_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : IMMUNO Treatments\')"),
('qc_nd_sardo_medic_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : MEDIC Treatments\')"),
('qc_nd_sardo_exam_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : EXAM Treatments\')"),
('qc_nd_sardo_obs_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : OBS Treatments\')"),
('qc_nd_sardo_visite_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : VISITE Treatments\')"),
('qc_nd_sardo_sympt_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : SYMPT Treatments\')"),
('qc_nd_sardo_resume_treatments', "StructurePermissibleValuesCustom::getCustomDropdown(\'SARDO : RESUME Treatments\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('SARDO : RADIO Treatments', 1, 250, 'clinical - treatment'),
('SARDO : CHIR Treatments', 1, 250, 'clinical - treatment'),
('SARDO : IMAGE Treatments', 1, 250, 'clinical - treatment'),
('SARDO : BIOP Treatments', 1, 250, 'clinical - treatment'),
('SARDO : HORM Treatments', 1, 250, 'clinical - treatment'),
('SARDO : CHIMIO Treatments', 1, 250, 'clinical - treatment'),
('SARDO : PAL Treatments', 1, 250, 'clinical - treatment'),
('SARDO : AUTRE Treatments', 1, 250, 'clinical - treatment'),
('SARDO : CYTO Treatments', 1, 250, 'clinical - treatment'),
('SARDO : PROTOC Treatments', 1, 250, 'clinical - treatment'),
('SARDO : BILAN Treatments', 1, 250, 'clinical - treatment'),
('SARDO : REVISION Treatments', 1, 250, 'clinical - treatment'),
('SARDO : IMMUNO Treatments', 1, 250, 'clinical - treatment'),
('SARDO : MEDIC Treatments', 1, 250, 'clinical - treatment'),
('SARDO : EXAM Treatments', 1, 250, 'clinical - treatment'),
('SARDO : OBS Treatments', 1, 250, 'clinical - treatment'),
('SARDO : VISITE Treatments', 1, 250, 'clinical - treatment'),
('SARDO : SYMPT Treatments', 1, 250, 'clinical - treatment'),
('SARDO : RESUME Treatments', 1, 250, 'clinical - treatment');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_radio_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chir_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_image_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_biop_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_horm_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chimio_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_pal_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_autre_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_cyto_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_protoc_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_bilan_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_revision_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_immuno_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_medic_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_exam_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_obs_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_visite_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_sympt_treatments') , '0', '', '', '', 'treatment', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qc_nd_txe_sardos', 'treatment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_resume_treatments') , '0', '', '', '', 'treatment', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_radio'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_radio_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_chir'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chir_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_image'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_image_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_biop'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_biop_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_horm'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_horm_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_chimio'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_chimio_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_pal'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_pal_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_autre'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_autre_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_cyto'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_cyto_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_protoc'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_protoc_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_bilan'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_bilan_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_revision'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_revision_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_immuno'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_immuno_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_medic'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_medic_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_exam'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_exam_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_obs'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_obs_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_visite'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_visite_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_sympt'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_sympt_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='qc_nd_txe_sardos_resume'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_nd_txe_sardos' AND `field`='treatment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_resume_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='treatment' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO i18n (id,en,fr) 
VALUES 
('sardo treatment extend - radio', 'RADIO', 'RADIO'),
('sardo treatment extend - chir', 'SURG', 'CHIR'),
('sardo treatment extend - image', 'IMAGING', 'IMAGE'),
('sardo treatment extend - biop', 'BIOP', 'BIOP'),
('sardo treatment extend - horm', 'HORM', 'HORM'),
('sardo treatment extend - chimio', 'CHEMO', 'CHIMIO'),
('sardo treatment extend - pal', 'PAL', 'PAL'),
('sardo treatment extend - autre', 'OTHER', 'AUTRE'),
('sardo treatment extend - cyto', 'CYTO', 'CYTO'),
('sardo treatment extend - protoc', 'PROTOC', 'PROTOC'),
('sardo treatment extend - bilan', 'CHECKUP', 'BILAN'),
('sardo treatment extend - revision', 'REVISION', 'REVISION'),
('sardo treatment extend - immuno', 'IMMUNO', 'IMMUNO'),
('sardo treatment extend - medic', 'MEDIC', 'MEDIC'),
('sardo treatment extend - exam', 'EXAM', 'EXAM'),
('sardo treatment extend - obs', 'OBS', 'OBS'),
('sardo treatment extend - visite', 'VISIT', 'VISITE'),
('sardo treatment extend - sympt', 'SYMPT', 'SYMPT'),
('sardo treatment extend - resume', 'SUMMARY', 'RESUME');
INSERT INTO i18n (id,en,fr) 
VALUES 
('sardo treatment - radio', 'RADIO', 'RADIO'),
('sardo treatment - chir', 'SURG', 'CHIR'),
('sardo treatment - image', 'IMAGING', 'IMAGE'),
('sardo treatment - biop', 'BIOP', 'BIOP'),
('sardo treatment - horm', 'HORM', 'HORM'),
('sardo treatment - chimio', 'CHEMO', 'CHIMIO'),
('sardo treatment - pal', 'PAL', 'PAL'),
('sardo treatment - autre', 'OTHER', 'AUTRE'),
('sardo treatment - cyto', 'CYTO', 'CYTO'),
('sardo treatment - protoc', 'PROTOC', 'PROTOC'),
('sardo treatment - bilan', 'CHECKUP', 'BILAN'),
('sardo treatment - revision', 'REVISION', 'REVISION'),
('sardo treatment - immuno', 'IMMUNO', 'IMMUNO'),
('sardo treatment - medic', 'MEDIC', 'MEDIC'),
('sardo treatment - exam', 'EXAM', 'EXAM'),
('sardo treatment - obs', 'OBS', 'OBS'),
('sardo treatment - visite', 'VISIT', 'VISITE'),
('sardo treatment - sympt', 'SYMPT', 'SYMPT'),
('sardo treatment - resume', 'SUMMARY', 'RESUME');
INSERT INTO i18n (id,en,fr) 
VALUES 
('objectifs', 'Objectives', 'Objectifs'),
('patho nbr', 'Patho#', 'Patho#');
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/Treatment%';
DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'qc_nd_txd_sardos_%') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='qc_nd_txd_sardos' AND `field`='patho_nbr');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentExtendMasters%';
UPDATE menus SET use_summary = 'ClinicalAnnotation.TreatmentMaster::summary' WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters/detail/%';
UPDATE structure_fields SET  `model`='TreatmentExtendDetail' WHERE model='TreatmentDetail' AND tablename='qc_nd_txe_sardos' AND field='treatment';

ALTER TABLE participants ADD COLUMN qc_nd_last_contact_accuracy CHAR(1) NOT NULL DEFAULT 'c' AFTER qc_nd_last_contact;
ALTER TABLE participants_revs ADD COLUMN qc_nd_last_contact_accuracy CHAR(1) NOT NULL DEFAULT 'c' AFTER qc_nd_last_contact;
ALTER TABLE participants 
  ADD COLUMN  qc_nd_sardo_diff_date_of_death CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_vital_status CHAR(1) DEFAULT '';
ALTER TABLE participants_revs
  ADD COLUMN  qc_nd_sardo_diff_date_of_death CHAR(1) DEFAULT '',
  ADD COLUMN  qc_nd_sardo_diff_vital_status CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_diff_date_of_death', 'yes_no',  NULL , '0', '', '', '', 'date of death', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_diff_vital_status', 'yes_no',  NULL , '0', '', '', '', 'vital status', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_vital_status'), '4', '17', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_date_of_death'), '4', '17', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_fields SET  `language_label`='last modification (excepted SARDO imp)' WHERE model='Participant' AND tablename='participants' AND field='last_modification' AND `type`='datetime' AND structure_value_domain  IS NULL ;
REPLACE INTO i18n (id,en,fr) VALUES ('last modification (excepted SARDO imp)', 'Last Modification (Excepted SARDO Synch.)', 'Dernière Modification (Excepté SARDO Synch.)');

INSERT INTO i18n (id,en,fr) VALUES ('an infomration has already been recorded for this patient', 'An infomration has already been recorded for this patient', 'Des informations ont déjà été créées pour ce patient');

SELECT participant_id AS 'Participants with more than one repro history' FROM (SELECT count(*) AS record_nbr, participant_id FROM reproductive_histories WHERE deleted <> 1 GROUP BY participant_id) AS res WHERE res.record_nbr > 1;

ALTER TABLE participants 
  ADD COLUMN  qc_nd_sardo_diff_reproductive_history CHAR(1) DEFAULT '';
ALTER TABLE participants_revs
  ADD COLUMN  qc_nd_sardo_diff_reproductive_history CHAR(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_nd_sardo_diff_reproductive_history', 'yes_no',  NULL , '0', '', '', '', 'reproductive history', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_reproductive_history'), '4', '17', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'operative consent', 1, '', 'qc_nd_cd_operative_consents', 0, 'general');
CREATE TABLE IF NOT EXISTS `qc_nd_cd_operative_consents` (
  `consent_master_id` int(11) NOT NULL,
  KEY `qc_nd_cd_operative_consents_ibfk_1` (`consent_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_nd_cd_operative_consents_revs` (
  `consent_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_nd_cd_operative_consents`
  ADD CONSTRAINT `qc_nd_cd_operative_consents_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);
INSERT INTO i18n (id,en,fr) VALUES ('operative consent', 'Operative Consent', 'Consentement Opératoire');
SET @control_id = (SELECT id FROM consent_controls WHERE controls_type = 'operative consent');
INSERT INTO consent_masters (participant_id,consent_control_id,consent_status,consent_signed_date,consent_signed_date_accuracy,created,modified,created_by,modified_by)
(SELECT participant_id, @control_id, 'obtained', '1995-01-01', 'y', NOW(), NOW(), 9, 9
FROM misc_identifiers mi INNER JOIN misc_identifier_controls mic ON mic.id = mi.misc_identifier_control_id WHERE  mi.deleted <> 1 AND mic.misc_identifier_name = 'ovary/gyneco bank no lab' AND mi.identifier_value >= 1 AND mi.identifier_value <= 1094);
INSERT INTO consent_masters_revs (id,participant_id,consent_control_id,consent_status,consent_signed_date,consent_signed_date_accuracy,modified_by,version_created)
(SELECT id,participant_id,consent_control_id,consent_status,consent_signed_date,consent_signed_date_accuracy,modified_by,modified FROM consent_masters WHERE consent_control_id = @control_id);
INSERT INTO qc_nd_cd_operative_consents (consent_master_id) (SELECT id FROM consent_masters WHERE consent_control_id = @control_id);
INSERT INTO qc_nd_cd_operative_consents_revs (consent_master_id, version_created) (SELECT id, modified FROM consent_masters WHERE consent_control_id = @control_id);
UPDATE collections col, participants p, consent_masters cm
SET col.consent_master_id = cm.id
WHERE cm.consent_control_id = @control_id
AND cm.deleted <> 1
AND p.id = cm.participant_id
AND col.participant_id = p.id
AND col.collection_datetime <= '2001-06-01'
AND (col.consent_master_id IS NULL OR col.consent_master_id LIKE '')
AND col.deleted <> 1;
UPDATE collections_revs col, participants p, consent_masters cm
SET col.consent_master_id = cm.id
WHERE cm.consent_control_id = @control_id
AND cm.deleted <> 1
AND p.id = cm.participant_id
AND col.participant_id = p.id
AND col.collection_datetime <= '2001-06-01'
AND (col.consent_master_id IS NULL OR col.consent_master_id LIKE '');

DELETE FROM menus WHERE use_link LIKE '/administrate/qc_nd_sardo/index/';

UPDATE structure_formats SET `display_column`='2', `display_order`='61' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_grade') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='60' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dx_primary_sardos' AND `field`='figo' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_figo') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='30' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='35' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_topo') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='32' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_morphology_desc' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho_description') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='37' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_topography_desc' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_topo_description') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='31' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_morphology_key_words' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='36' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_topography_key_words' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='32' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dx_primary_sardos' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_laterality') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='50' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcT') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='51' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcN') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='52' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcM') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='53' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMcsummary') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='54' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpT') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='55' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpN') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='56' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpM') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='57' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_TNMpsummary') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='70' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dx_primary_sardos' AND `field`='codetnmg' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_tnmg') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='40' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_nd_dx_primary_sardos' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_laterality') AND `flag_confidential`='0');

ALTER TABLE qc_nd_ed_ca125s MODIFY value int(8) DEFAULT NULL;
ALTER TABLE qc_nd_ed_ca125s_revs MODIFY value int(8) DEFAULT NULL;
UPDATE structure_fields SET  `type`='integer_positive' WHERE model='EventDetail' AND tablename='qc_nd_ed_ca125s' AND field='value' AND `type`='float_positive' AND structure_value_domain  IS NULL ;

ALTER TABLE participants 
  ADD COLUMN  qc_nd_sardo_diff_hospital_nbr CHAR(1) DEFAULT '',
  DROP COLUMN  qc_nd_sardo_diff_hd_nbr,
  DROP COLUMN  qc_nd_sardo_diff_sl_nbr,
  DROP COLUMN  qc_nd_sardo_diff_nd_nbr;
ALTER TABLE participants_revs 
  ADD COLUMN  qc_nd_sardo_diff_hospital_nbr CHAR(1) DEFAULT '',
  DROP COLUMN  qc_nd_sardo_diff_hd_nbr,
  DROP COLUMN  qc_nd_sardo_diff_sl_nbr,
  DROP COLUMN  qc_nd_sardo_diff_nd_nbr;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_sl_nbr' AND `language_label`='saint-luc id nbr' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_nd_nbr' AND `language_label`='notre-dame id nbr' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_sl_nbr' AND `language_label`='saint-luc id nbr' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_nd_nbr' AND `language_label`='notre-dame id nbr' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_sl_nbr' AND `language_label`='saint-luc id nbr' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='qc_nd_sardo_diff_nd_nbr' AND `language_label`='notre-dame id nbr' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
UPDATE structure_fields SET field = 'qc_nd_sardo_diff_hospital_nbr', language_label = 'hospital nbr' WHERE field = 'qc_nd_sardo_diff_hd_nbr';

UPDATE structure_formats SET `display_order`='35' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='36' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_morphology_key_words' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='37' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_morphology_desc' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_morpho_description') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='31' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_topo') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='32' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_topography_key_words' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='33' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_nd_sardo_topography_desc' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_sardo_topo_description') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='2', `display_order`='75' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_nd_dx_primary_sardos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
