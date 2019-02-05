REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'iCord v0.2.1', '');

-- #422

UPDATE structure_formats 
SET `language_heading` = '', `display_order`=0
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'participants')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field`= 'participant_identifier');

UPDATE structure_formats
SET `language_heading` = 'clin_demographics', `display_order` = -1
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'participants')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field`= 'participant_type');

-- #426

ALTER TABLE `participants` CHANGE COLUMN `icord_pig_species` `icord_species` VARCHAR(100) DEFAULT NULL;

UPDATE structure_fields
SET `field` = 'icord_species'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_species' AND `type` = 'select';

UPDATE structure_value_domains
SET `domain_name` = 'icord_species', `source` = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Species\')'
WHERE `domain_name` = 'icord_pig_species';

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Species', 1, 200, 'clinical - demographics', 4, 4);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Species' AND `category` = 'clinical - demographics'), 'Pig (Sus scrofa domesticus)', 'Pig (Sus scrofa domesticus)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Species' AND `category` = 'clinical - demographics'), 'Mouse (Mus musculus)', 'Mouse (Mus musculus)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Species' AND `category` = 'clinical - demographics'), 'Rat (Rattus norvegicus)', 'Rat (Rattus norvegicus)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Species' AND `category` = 'clinical - demographics'), 'Monkey (Macaca mulatta)', 'Monkey (Macaca mulatta)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Species' AND `category` = 'clinical - demographics'), 'Other', 'Other', '', 0, 1, NOW(), 1, NOW(), 1, 0);

-- #427

ALTER TABLE `participants` CHANGE COLUMN `icord_pig_breed` `icord_breed` VARCHAR(100) DEFAULT NULL;
ALTER TABLE `participants_revs` CHANGE COLUMN `icord_pig_breed` `icord_breed` VARCHAR(100) DEFAULT NULL;

UPDATE structure_fields
SET `field` = 'icord_breed'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_breed' AND `type` = 'select';

UPDATE structure_value_domains
SET `domain_name` = 'icord_breed', `source` = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Breeds\')'
WHERE `domain_name` = 'icord_pig_breed';

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Breeds', 1, 200, 'clinical - demographics', 4, 4);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Breeds' AND `category` = 'clinical - demographics'), 'Yorkshire (pig)', 'Yorkshire (pig)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Breeds' AND `category` = 'clinical - demographics'), 'Yucatan miniature (pig)', 'Yucatan miniature (pig)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Breeds' AND `category` = 'clinical - demographics'), 'Sprague Dawley (rat)', 'Sprague Dawley (rat)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Breeds' AND `category` = 'clinical - demographics'), 'Long-Evans (rat)', 'Long-Evans (rat)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Breeds' AND `category` = 'clinical - demographics'), 'Wistar (rat)', 'Wistar (rat)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Breeds' AND `category` = 'clinical - demographics'), 'Fisher (rat)', 'Fisher (rat)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Breeds' AND `category` = 'clinical - demographics'), 'C57BL/6 (mouse)', 'C57BL/6 (mouse)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Breeds' AND `category` = 'clinical - demographics'), 'BALB/c (mouse)', 'BALB/c (mouse)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Breeds' AND `category` = 'clinical - demographics'), 'DBA/2 (mouse)', 'DBA/2 (mouse)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Breeds' AND `category` = 'clinical - demographics'), 'Rhesus Monkey (monkey)', 'Rhesus Monkey (monkey)', '', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Breeds' AND `category` = 'clinical - demographics'), 'Other', 'Other', '', 0, 1, NOW(), 1, NOW(), 1, 0);


-- #423
-- Moving Injury Details and Sex to Consent Form 

INSERT INTO consent_controls
(`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`)
VALUES
('iCord Consent', 1, 'cd_icord', 'cd_icord', 0, 'iCord Consent');

UPDATE consent_controls
SET `flag_active` = 0
WHERE `controls_type` = 'Consent National';

CREATE TABLE cd_icord (
	`consent_master_id` INT(11) NOT NULL,
	`sex` VARCHAR(10) DEFAULT NULL,
	`age_at_admission` INT(11) DEFAULT NULL,
	`injury_datetime` DATETIME DEFAULT NULL,
	`injury_lvl_neurological` VARCHAR(100) DEFAULT NULL,
	`asia_grade` VARCHAR(10) DEFAULT NULL,
	`injury_lvl_anatomical` VARCHAR(100) DEFAULT NULL,
	`clinical_diagnosis` TEXT DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) DEFAULT NULL,
	`neuro_diagnosis` TEXT DEFAULT NULL,
	`accident_detail` TEXT DEFAULT NULL,
	`death_manner` VARCHAR(255) DEFAULT NULL,
	`death_cause` TEXT DEFAULT NULL,
	`autopsy_datetime` DATETIME DEFAULT NULL,
	`postmortum_interval` INT(11) DEFAULT NULL,
	INDEX `consent_master_id` (`consent_master_id`),
	CONSTRAINT `cd_icord_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;


CREATE TABLE cd_icord_revs (
	`consent_master_id` INT(11) NOT NULL,
	`sex` VARCHAR(10) DEFAULT NULL,
	`age_at_admission` INT(11) DEFAULT NULL,
	`injury_datetime` DATETIME DEFAULT NULL,
	`injury_lvl_neurological` VARCHAR(100) DEFAULT NULL,
	`asia_grade` VARCHAR(10) DEFAULT NULL,
	`injury_lvl_anatomical` VARCHAR(100) DEFAULT NULL,
	`clinical_diagnosis` TEXT DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) DEFAULT NULL,
	`neuro_diagnosis` TEXT DEFAULT NULL,
	`accident_detail` TEXT DEFAULT NULL,
	`death_manner` VARCHAR(255) DEFAULT NULL,
	`death_cause` TEXT DEFAULT NULL,
	`autopsy_datetime` DATETIME DEFAULT NULL,
	`postmortum_interval` INT(11) DEFAULT NULL,
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

INSERT INTO structures (`alias`, `description`)
VALUES 
('cd_icord', 'iCord Consent Form');

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'sex', 'sex', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'sex'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'age_at_admission', 'age at admission', '', 'integer_positive', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'injury_datetime', 'injury datetime', '', 'datetime', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'injury_lvl_neurological', 'injury level - neurological', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'neuro_injury_level'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'asia_grade', '', 'asia grade', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_asia_grade'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'injury_lvl_anatomical', 'injury level - anatomical', '', 'textarea', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'clinical_diagnosis', 'clinical diagnosis', '', 'textarea', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'injury_mechanism', 'injury mechanism', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'mechanism_injury'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'injury_mechanism_other', '', 'other', 'input', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'neuro_diagnosis', 'neurological diagnosis', '', 'textarea', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'accident_detail', 'accidental details', '', 'textarea', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'death_manner', 'manner of death', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_manner_death'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'death_cause', 'causes of death', '', 'textarea', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'autopsy_datetime', 'Autopsy Datetime', '', 'datetime', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'postmortum_interval', 'postmortum interval', '', 'integer_positive', '', '', NULL, '', 0);


INSERT INTO `structure_formats` (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='sex' AND `type`='select'), 
2, 10, 'injury details', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='age_at_admission' AND `type`='integer_positive'), 
2, 12, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='injury_datetime' AND `type`='datetime'), 
2, 14, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='injury_lvl_neurological' AND `type`='select'), 
2, 16, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='asia_grade' AND `type`='select'), 
2, 18, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='injury_lvl_anatomical' AND `type`='textarea'), 
2, 20, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='clinical_diagnosis' AND `type`='textarea'), 
2, 22, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='injury_mechanism' AND `type`='select'), 
2, 24, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='injury_mechanism_other' AND `type`='input'), 
2, 26, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='neuro_diagnosis' AND `type`='textarea'), 
2, 28, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='accident_detail' AND `type`='textarea'), 
2, 30, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='death_manner' AND `type`='select'), 
2, 32, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='death_cause' AND `type`='textarea'), 
2, 34, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='autopsy_datetime' AND `type`='datetime'), 
2, 36, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='postmortum_interval' AND `type`='integer_positive'), 
2, 38, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
('injury details', 'Injury Details', ''),
('age at admission', 'Age at Admission', ''),
('injury datetime', 'Injury Datetime', ''),
('injury level - neurological', 'Injury Level - Neurological', ''),
('asia grade', 'ASIA Grade', ''),
('injury level - anatomical', 'Injury Level - Anatomical', ''),
('clinical diagnosis', 'Clinical Diagnosis', ''),
('injury mechanism', 'Injury Mechanism', ''),
('neurological diagnosis', 'Neurological Diagnosis', ''),
('accident details', 'Accident Details', ''),
('manner of death', 'Manner of Death', ''),
('casuses of death', 'Causes of Death', ''),
('autopsy datetime', 'Autopsy Datetime', ''),
('postmortum interval', 'Postmortum Interval', '');

-- Remove the above items from demographcis

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_age_at_admission');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_manner_of_death');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_datetime_autopsy');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_cause_of_death');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_accident_details');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_asia_grade');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_mechanism_of_injury');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_injury_level_anatomical');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_injury_level_neurological');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_clinical_dx');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_neurological_dx');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_injury_datetime');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
ANd `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_mechanism_of_injury_other');

DELETE FROM structure_formats 
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_postmortum_interal');








DELETE FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_age_at_admission';

DELETE FROM structure_fields 
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_manner_of_death';

DELETE FROM structure_fields 
 WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_datetime_autopsy';

DELETE FROM structure_fields 
 WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_cause_of_death';

DELETE FROM structure_fields 
 WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_accident_details';

DELETE FROM structure_fields 
 WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_asia_grade';

DELETE FROM structure_fields 
 WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_mechanism_of_injury';

DELETE FROM structure_fields 
 WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_injury_level_anatomical';

DELETE FROM structure_fields 
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_injury_level_neurological';

DELETE FROM structure_fields 
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_clinical_dx';

DELETE FROM structure_fields 
 WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_neurological_dx';

DELETE FROM structure_fields 
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_injury_datetime';

DELETE FROM structure_fields 
 WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_mechanism_of_injury_other';

DELETE FROM structure_fields 
 WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_postmortum_interal';

ALTER TABLE participants
DROP COLUMN `icord_age_at_admission`,
DROP COLUMN `icord_manner_of_death`,
DROP COLUMN `icord_datetime_autopsy`,
DROP COLUMN `icord_cause_of_death`,
DROP COLUMN `icord_accident_details`,
DROP COLUMN `icord_asia_grade`,
DROP COLUMN `icord_mechanism_of_injury`,
DROP COLUMN `icord_mechanism_of_injury_other`,
DROP COLUMN `icord_injury_level_anatomical`,
DROP COLUMN `icord_injury_level_neurological`,
DROP COLUMN `icord_clinical_dx`,
DROP COLUMN `icord_neurological_dx`,
DROP COLUMN `icord_injury_datetime`,
DROP COLUMN `icord_injury_datetime_accuracy`,
DROP COLUMN `icord_postmortum_interal`;

-- Hide the sex field in Participant Form

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE `structure_id` = (SELECT `id` FROM structures WHERe `alias` = 'participants')
AND `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'sex');


-- #428
-- Rename Pig ID to Animal ID

ALTER TABLE participants
	CHANGE COLUMN `icord_pig_id` `icord_animal_id` VARCHAR(100) DEFAULT NULL;

ALTER TABLE participants_revs
	CHANGE COLUMN `icord_pig_id` `icord_animal_id` VARCHAR(100) DEFAULT NULL;

UPDATE structure_fields
SET `field` = 'icord_animal_id', `language_label` = 'animal id'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_id';


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
('animal id', 'Animal ID', '');

-- #429
-- Create a field called common name 

ALTER TABLE participants
	ADD COLUMN `icord_common_name` VARCHAR(100) DEFAULT NULL AFTER `icord_breed`;

ALTER TABLE participants_revs
	ADD COLUMN `icord_common_name` VARCHAR(100) DEFAULT NULL AFTER `icord_breed`;


INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`)
VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'icord_common_name', 'animal common name', '', 'input', '', '', NULL, '', 0);


INSERT INTO structure_formats (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_common_name' AND `type`='input'), 
3, 43, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 1, 0, 0);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
('animal common name', 'Animal Common Name', '');


-- Automatic SCI Participant Code
-- For Human starts wtih H
-- For Animal starts with A
-- Autoincrement

DELETE FROM structure_validations WHERE structure_field_id = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'participant_identifier');

UPDATE structure_formats
SET `flag_add_readonly` = 1, `flag_edit_readonly` = 1, 
`flag_addgrid_readonly` = 1, `flag_editgrid_readonly` = 1
WHERE 
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'participants')
AND
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'participant_identifier');




REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'iCord v0.2.1', '');

-- Change Participant Type Field to just Human and animal


DELETE FROM structure_value_domains_permissible_values
WHERE `structure_value_domain_id` = (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'participant_type');

INSERT INTO structure_permissible_values 
(`value`, `language_alias`)
VALUES
('human', 'human'),
('animal', 'animal');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES 
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'participant_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'human'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'participant_type'), (SELECT `id` FROM structure_permissible_values WHERE `value` = 'animal'), 0, 1, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('human', 'Human', ''),
('animal', 'Animal', '');

-- Make Participant Type Mandatory

INSERT INTO structure_validations
(`structure_field_id`, `rule`, `language_message`)
VALUES
((SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'participant_type' AND `type` = 'select'), 'notEmpty', 'participant type is required');



-- #436 
-- #437
-- Create Study Type Option and Person Obtaining Consent in the top of consent form 


ALTER TABLE cd_icord
	ADD COLUMN `study_type` VARCHAR(100) DEFAULT NULL AFTER `sex`,
	ADD COLUMN `person_consenting` VARCHAR(100) DEFAULT NULL AFTER `study_type`;

ALTER TABLE cd_icord_revs
	ADD COLUMN `study_type` VARCHAR(100) DEFAULT NULL AFTER `sex`,
	ADD COLUMN `person_consenting` VARCHAR(100) DEFAULT NULL AFTER `study_type`;

INSERT INTO structure_value_domains
(`domain_name`, `override`, `source`)
VALUES
('consent_study_type', 'open', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Study Type\')'),
('person_consenting', 'open', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Person Obtaining Consent\')');

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Study Type', 1, 100, 'clinical - consent', 5, 5),
('Person Obtaining Consent', 1, 100, 'clinical - consent', 7, 7);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Study Type'), 'CSF Analysis', 'CSF Analysis', 'CSF Analysis', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Study Type'), 'Drainage', 'Drainage', 'Drainage', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Study Type'), 'Pressure', 'Pressure', 'Pressure', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Study Type'), 'CAMPER', 'CAMPER', 'CAMPER', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Study Type'), 'Biobank', 'Biobank', 'Biobank', 0, 1, NOW(), 1, NOW(), 1, 0);


INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Person Obtaining Consent'), 'Brian Kwon', 'Brian Kwon', 'Brian Kwon', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Person Obtaining Consent'), 'Allan Aludino', 'Allan Aludino', 'Allan Aludino', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Person Obtaining Consent'), 'Lise Belanger', 'Lise Belanger', 'Lise Belanger', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Person Obtaining Consent'), 'Jiwan Gill', 'Jiwan Gill', 'Jiwan Gill', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Person Obtaining Consent'), 'Leanne Ritchie', 'Leanne Ritchie', 'Leanne Ritchie', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Person Obtaining Consent'), 'Angela Tsang', 'Angela Tsang', 'Angela Tsang', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Person Obtaining Consent'), 'Leilani Reichl', 'Leilani Reichl', 'Leilani Reichl', 0, 1, NOW(), 1, NOW(), 1, 0);

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'study_type', 'study type', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'consent_study_type'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'person_consenting', 'person obtaining consent', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'person_consenting'), '', 0);

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='study_type' AND `type`='select'), 
3, 43, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='person_consenting' AND `type`='select'), 
3, 43, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0);

-- Move Study Type and Person Obtaining Consent to column 1 of the consent form

UPDATE structure_formats
SET `display_column` = 1
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_icord' AND `field` = 'study_type')
AND
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_icord');

UPDATE structure_formats
SET `display_column` = 1
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_icord' AND `field` = 'person_consenting')
AND
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_icord');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('study type', 'Study Type', ''),
('person obtaining consent', 'Person Obtaining Consent', ''),
('accident details', 'Accident Details', ''),
('causes of death', 'Causes of Death', ''),
('autopsy Datetime', 'Autopsy Datetime', '');

-- Remove Status Date
-- Remove Reason Denied/Withdrawan

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentMaster' AND `tablename` = 'consent_masters' AND `field` = 'status_date')
AND
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'consent_masters');

UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentMaster' AND `tablename` = 'consent_masters' AND `field` = 'reason_denied')
AND
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'consent_masters');

-- Create Withdraw Date Field

ALTER TABLE cd_icord
ADD COLUMN `date_consent_withdrawn` DATE DEFAULT NULL AFTER `consent_master_id`,
ADD COLUMN `date_consent_withdrawn_accuracy` DATE DEFAULT NULL AFTER `date_consent_withdrawn`;

ALTER TABLE cd_icord_revs
ADD COLUMN `date_consent_withdrawn` DATE DEFAULT NULL AFTER `consent_master_id`,
ADD COLUMN `date_consent_withdrawn_accuracy` DATE DEFAULT NULL AFTER `date_consent_withdrawn`;


INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_icord', 'date_consent_withdrawn', 'date consent withdrawn', '', 'date', '', '', NULL, '', 0);

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_icord'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_icord' AND `field`='date_consent_withdrawn' AND `type`='date'), 
1, 30, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 1, 0, 0);

-- Amend Injury Details to Admission Details

UPDATE structure_formats
SET `language_heading` = 'admission details'
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_icord' AND `field` = 'sex' AND `type` = 'select')
AND
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_icord');

-- Amend injury level - neurological to Admission - Neurological Level
-- Amend injury level - anatomical to Admission - Anatomical Level

ALTER TABLE `cd_icord` CHANGE COLUMN `injury_lvl_neurological` `admission_neurological_lvl` VARCHAR(100) DEFAULT NULL;

ALTER TABLE `cd_icord_revs` CHANGE COLUMN `injury_lvl_neurological` `admission_neurological_lvl` VARCHAR(100) DEFAULT NULL;

ALTER TABLE `cd_icord` CHANGE COLUMN `injury_lvl_anatomical` `admission_anatomical_lvl` TEXT DEFAULT NULL;

ALTER TABLE `cd_icord_revs` CHANGE COLUMN `injury_lvl_anatomical` `admission_anatomical_lvl` TEXT DEFAULT NULL;


UPDATE structure_fields
SET `field` = 'admission_neurological_lvl', `language_label` = 'admission - neurological level'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_icord' AND `field` = 'injury_lvl_neurological' AND `type` = 'select';


UPDATE structure_fields
SET `field` = 'admission_anatomical_lvl', `language_label` = 'admission - anatomical level'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_icord' AND `field` = 'injury_lvl_anatomical' AND `type` = 'textarea';


REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('admission details', 'Admission Details', ''),
('admission - neurological level', 'Admission - Neurological Level', ''),
('admission - anatomical level', 'Admission - Anatomical Level', '');

-- Modify Clinical Diagnosis

ALTER TABLE `cd_icord` CHANGE COLUMN `clinical_diagnosis` `clinical_diagnosis` VARCHAR(100) DEFAULT NULL;

ALTER TABLE `cd_icord_revs` CHANGE COLUMN `clinical_diagnosis` `clinical_diagnosis` VARCHAR(100) DEFAULT NULL;

INSERT INTO structure_value_domains 
(`domain_name`, `override`, `category`, `source`)
VALUES
('clinical_diagnosis', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''Clinical Diagnosis'')');

INSERT INTo structure_permissible_values_custom_controls 
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Clinical Diagnosis', 1, 100, 'clinical - consent', 6, 6);

INSERT INTO structure_permissible_values_customs 
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Clinical Diagnosis'), 'Trauma - Other', 'Trauma - Other', 'Trauma - Other', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Clinical Diagnosis'), 'Trauma - Cervical', 'Trauma - Cervical', 'Trauma - Cervical', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Clinical Diagnosis'), 'Trauma - Thoracolumbar', 'Trauma - Thoracolumbar', 'Trauma - Thoracolumbar', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Clinical Diagnosis'), 'Trauma - Major', 'Trauma - Major', 'Trauma - Major', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Clinical Diagnosis'), 'Trauma - Spondylo', 'Trauma - Spondylo', 'Trauma - Spondylo', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Clinical Diagnosis'), 'Degenerative', 'Degenerative', 'Degenerative', 0, 1, NOW(), 1, NOW(), 1, 0);


UPDATE structure_fields
SET `type` = 'select', `structure_value_domain` = (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'clinical_diagnosis')
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_icord' AND `field` = 'clinical_diagnosis' AND `type` = 'textarea';

-- Remove Neurological Diangosis
-- Remove Accident details


UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_icord' AND `field` = 'neuro_diagnosis')
AND
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_icord');


UPDATE structure_formats
SET `flag_add` = 0, `flag_edit` = 0, `flag_search` = 0, `flag_summary` = 0, `flag_index` = 0, `flag_detail` = 0
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_icord' AND `field` = 'accident_detail')
AND
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_icord');


-- Make dropdown of Injury Mechanism user customizable

DELETE FROM structure_value_domains_permissible_values
WHERE `structure_value_domain_id` = (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'mechanism_injury');

UPDATE structure_value_domains
SET `source` = 'StructurePermissibleValuesCustom::getCustomDropdown(''Injury Mechanism'')'
WHERE `domain_name` = 'mechanism_injury';

INSERT INTo structure_permissible_values_custom_controls 
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('Injury Mechanism', 1, 100, 'clinical - consent', 6, 6);

INSERT INTO structure_permissible_values_customs 
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Injury Mechanism'), 'Transport', 'Transport', 'Transport', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Injury Mechanism'), 'Fall', 'Fall', 'Fall', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Injury Mechanism'), 'Assault - Blunt', 'Assault - Blunt', 'Assault - Blunt', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Injury Mechanism'), 'Assault - Penetration', 'Assault - Penetration', 'Assault - Penetration', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Injury Mechanism'), 'Sports', 'Sports', 'Sports', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Injury Mechanism'), 'Other Traumatic Cause', 'Other Traumatic Cause', 'Other Traumatic Cause', 0, 1, NOW(), 1, NOW(), 1, 0);



REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('date consent withdrawn', 'Date Consent Withdrawn', ''),
('Autopsy Datetime', 'Autopsy Datetime', ''),
('iCord Consent', 'iCord Consent', ''),
('clinical - demographics', 'Clinical - Demographics', '');

-- Leave only Obtained and Withdrawn in the Consent Status Box

UPDATE structure_value_domains_permissible_values
SET `flag_active` = 0
WHERE `structure_value_domain_id` = (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'consent_status')
AND
(
`structure_permissible_value_id` != (SELECT `id` FROM structure_permissible_values WHERE `value` = 'obtained') 
AND
`structure_permissible_value_id` != (SELECT `id` FROM structure_permissible_values WHERE `value` = 'withdrawn')
);



