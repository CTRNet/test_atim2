REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'iCord v0.2.3', '');


-- Make barcode and Study ID Number Unique

INSERT INTO structure_validations
(`structure_field_id`, `rule`, `language_message`)
VALUES
((SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'AliquotMaster' AND `tablename` = 'aliquot_masters' AND `field` = 'barcode' AND `type` = 'input'), 'isUnique', 'barcode must be unique');


INSERT INTO structure_validations
(`structure_field_id`, `rule`, `language_message`)
VALUES
((SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'acquisition_label' AND `type` = 'input'), 'isUnique', 'study id number must be unique');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('barcode must be unique', 'Barcode must be unique', ''),
('study id number must be unique', 'Study ID Number must be unique', '');

-- Reactivate Collection timepoint and make it integer


UPDATE structure_formats
SET `flag_add` = 1, `flag_edit` = 1, `flag_search` = 0, `flag_summary` = 1, `flag_index`= 1, `flag_detail` = 0
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'collection_timepoint' AND `type` = 'select')
AND
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'collections');

UPDATE structure_formats
SET `flag_add` = 1, `flag_edit` = 1, `flag_search` = 0, `flag_summary` = 0, `flag_index`= 0, `flag_detail` = 0
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'collection_timepoint' AND `type` = 'select')
AND
`structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'linked_collections');


UPDATE structure_formats
SET `flag_add` = 1, `flag_edit` = 0, `flag_search` = 1, `flag_summary` = 0, `flag_index`= 1, `flag_detail` = 1
WHERE 
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = 'view_collections' AND `field` = 'collection_timepoint' AND `type` = 'select');


ALTER TABLE collections MODIFY `collection_timepoint` INT(11);
ALTER TABLE collections_revs MODIFY `collection_timepoint` INT(11);
ALTER TABLE view_collections MODIFY `collection_timepoint` INT(11);

UPDATE structure_fields
SET `type` = 'integer_positive'
WHERE `plugin` = 'InventoryManagement' AND `model` = 'Collection' AND `tablename` = 'collections' AND `field` = 'collection_timepoint';

UPDATE structure_fields
SET `type` = 'integer_positive'
WHERE `plugin` = 'InventoryManagement' AND `model` = 'ViewCollection' AND `tablename` = 'view_collections' AND `field` = 'collection_timepoint';

-- Make Form Version User Customizable

UPDATE structure_value_domains
SET `source` = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Consent Form Versions\')'
WHERE `domain_name` = 'custom_consent_from_verisons';




-- Create Study Form for each study

INSERT INTO structures
(`alias`, `description`)
VALUES
('cd_biobanks', 'Biobank Consent Form'),
('cd_campers', 'CAMPER Consent Form'),
('cd_csfs', 'CSF Consent Form'),
('cd_drainages', 'Drainage Consent Form'),
('cd_pressures', 'Pressure Consent Form');


INSERT INTO consent_controls
(`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`)
VALUES
('Biobank Consent', 1, 'cd_biobanks', 'cd_biobanks', 0, 'BioBank Consent'),
('CAMPER Consent', 1, 'cd_campers', 'cd_campers', 0, 'CAMPER Consent'),
('CSF Consent', 1, 'cd_csfs', 'cd_csfs', 0, 'CSF Consent'),
('Drainage Consent', 1, 'cd_drainages', 'cd_drainages', 0, 'Drainage Consent'),
('Pressure Consent', 1, 'cd_pressures', 'cd_pressures', 0, 'Pressure Consent');

UPDATE consent_controls
SET `flag_active` = 0
WHERE `controls_type` = 'iCord Consent' AND `detail_tablename` = 'cd_icord';

-- Biobank


CREATE TABLE `cd_biobanks` (
	`consent_master_id` INT(11) NOT NULL,
	`date_consent_withdrawn` DATE NULL DEFAULT NULL,
	`date_consent_withdrawn_accuracy` DATE NULL DEFAULT NULL,
	`sex` VARCHAR(10) NULL DEFAULT NULL,
	`person_consenting` VARCHAR(100) NULL DEFAULT NULL,
	`age_at_admission` INT(11) NULL DEFAULT NULL,
	`injury_datetime` DATETIME NULL DEFAULT NULL,
	`admission_neurological_lvl` VARCHAR(100) NULL DEFAULT NULL,
	`asia_grade` VARCHAR(10) NULL DEFAULT NULL,
	`admission_anatomical_lvl` TEXT NULL,
	`clinical_diagnosis` VARCHAR(100) NULL DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) NULL DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) NULL DEFAULT NULL,
	`neuro_diagnosis` TEXT NULL,
	`accident_detail` TEXT NULL,
	`death_manner` VARCHAR(255) NULL DEFAULT NULL,
	`death_cause` TEXT NULL,
	`autopsy_datetime` DATETIME NULL DEFAULT NULL,
	`postmortum_interval` INT(11) NULL DEFAULT NULL,
	INDEX `consent_master_id` (`consent_master_id`),
	CONSTRAINT `cd_biobanks_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

CREATE TABLE `cd_biobanks_revs` (
	`consent_master_id` INT(11) NOT NULL,
	`date_consent_withdrawn` DATE NULL DEFAULT NULL,
	`date_consent_withdrawn_accuracy` DATE NULL DEFAULT NULL,
	`sex` VARCHAR(10) NULL DEFAULT NULL,
	`person_consenting` VARCHAR(100) NULL DEFAULT NULL,
	`age_at_admission` INT(11) NULL DEFAULT NULL,
	`injury_datetime` DATETIME NULL DEFAULT NULL,
	`admission_neurological_lvl` VARCHAR(100) NULL DEFAULT NULL,
	`asia_grade` VARCHAR(10) NULL DEFAULT NULL,
	`admission_anatomical_lvl` TEXT NULL,
	`clinical_diagnosis` VARCHAR(100) NULL DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) NULL DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) NULL DEFAULT NULL,
	`neuro_diagnosis` TEXT NULL,
	`accident_detail` TEXT NULL,
	`death_manner` VARCHAR(255) NULL DEFAULT NULL,
	`death_cause` TEXT NULL,
	`autopsy_datetime` DATETIME NULL DEFAULT NULL,
	`postmortum_interval` INT(11) NULL DEFAULT NULL,
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

UPDATE structure_fields 
SET `tablename` = 'cd_biobanks'
WHERE `tablename` = 'cd_icord';

UPDATE structure_formats
SET `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_biobanks')
WHERE `structure_id` = (SELECT `id` FROM structures WHERE `alias` = 'cd_icord');


-- CAMPER

CREATE TABLE `cd_campers` (
	`consent_master_id` INT(11) NOT NULL,
	`date_consent_withdrawn` DATE NULL DEFAULT NULL,
	`date_consent_withdrawn_accuracy` DATE NULL DEFAULT NULL,
	`sex` VARCHAR(10) NULL DEFAULT NULL,
	`study_type` VARCHAR(100) NULL DEFAULT NULL,
	`person_consenting` VARCHAR(100) NULL DEFAULT NULL,
	`age_at_admission` INT(11) NULL DEFAULT NULL,
	`injury_datetime` DATETIME NULL DEFAULT NULL,
	`admission_neurological_lvl` VARCHAR(100) NULL DEFAULT NULL,
	`asia_grade` VARCHAR(10) NULL DEFAULT NULL,
	`admission_anatomical_lvl` TEXT NULL,
	`clinical_diagnosis` VARCHAR(100) NULL DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) NULL DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) NULL DEFAULT NULL,
	`neuro_diagnosis` TEXT NULL,
	`accident_detail` TEXT NULL,
	INDEX `consent_master_id` (`consent_master_id`),
	CONSTRAINT `cd_campers_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

CREATE TABLE `cd_campers_revs` (
	`consent_master_id` INT(11) NOT NULL,
	`date_consent_withdrawn` DATE NULL DEFAULT NULL,
	`date_consent_withdrawn_accuracy` DATE NULL DEFAULT NULL,
	`sex` VARCHAR(10) NULL DEFAULT NULL,
	`study_type` VARCHAR(100) NULL DEFAULT NULL,
	`person_consenting` VARCHAR(100) NULL DEFAULT NULL,
	`age_at_admission` INT(11) NULL DEFAULT NULL,
	`injury_datetime` DATETIME NULL DEFAULT NULL,
	`admission_neurological_lvl` VARCHAR(100) NULL DEFAULT NULL,
	`asia_grade` VARCHAR(10) NULL DEFAULT NULL,
	`admission_anatomical_lvl` TEXT NULL,
	`clinical_diagnosis` VARCHAR(100) NULL DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) NULL DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) NULL DEFAULT NULL,
	`neuro_diagnosis` TEXT NULL,
	`accident_detail` TEXT NULL,
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'date_consent_withdrawn', 'date consent withdrawn', '', 'date', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'sex', 'sex', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'sex'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'person_consenting', 'person obtaining consent', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'person_consenting'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'age_at_admission', 'age at admission', '', 'integer_positive', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'injury_datetime', 'injury datetime', '', 'datetime', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'admission_neurological_lvl', 'admission - neurological level', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'neuro_injury_level'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'asia_grade', '', 'asia grade', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_asia_grade'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'admission_anatomical_lvl', 'admission - anatomical level', '', 'textarea', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'clinical_diagnosis', 'clinical diagnosis', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'clinical_diagnosis'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'injury_mechanism', 'injury mechanism', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'mechanism_injury'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'injury_mechanism_other', '', 'other', 'input', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_campers', 'neuro_diagnosis', 'neurological diagnosis', '', 'textarea', '', '', NULL, '', 0);


INSERT INTO structure_formats (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='sex' AND `type`='select'), 
2, 10, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='age_at_admission' AND `type`='integer_positive'), 
2, 12, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='injury_datetime' AND `type`='datetime'), 
2, 14, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='admission_neurological_lvl' AND `type`='select'), 
2, 16, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='asia_grade' AND `type`='select'), 
2, 18, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='admission_anatomical_lvl' AND `type`='textarea'), 
2, 20, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='clinical_diagnosis' AND `type`='select'), 
2, 22, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='injury_mechanism' AND `type`='select'), 
2, 24, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='injury_mechanism_other' AND `type`='input'), 
2, 26, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='neuro_diagnosis' AND `type`='textarea'), 
2, 28, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='person_consenting' AND `type`='select'), 
1, 43, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_campers'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_campers' AND `field`='date_consent_withdrawn' AND `type`='date'), 
1, 30, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0);



-- CSF Analysis

CREATE TABLE `cd_csfs` (
	`consent_master_id` INT(11) NOT NULL,
	`date_consent_withdrawn` DATE NULL DEFAULT NULL,
	`date_consent_withdrawn_accuracy` DATE NULL DEFAULT NULL,
	`sex` VARCHAR(10) NULL DEFAULT NULL,
	`study_type` VARCHAR(100) NULL DEFAULT NULL,
	`person_consenting` VARCHAR(100) NULL DEFAULT NULL,
	`age_at_admission` INT(11) NULL DEFAULT NULL,
	`injury_datetime` DATETIME NULL DEFAULT NULL,
	`admission_neurological_lvl` VARCHAR(100) NULL DEFAULT NULL,
	`asia_grade` VARCHAR(10) NULL DEFAULT NULL,
	`admission_anatomical_lvl` TEXT NULL,
	`clinical_diagnosis` VARCHAR(100) NULL DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) NULL DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) NULL DEFAULT NULL,
	`neuro_diagnosis` TEXT NULL,
	`accident_detail` TEXT NULL,
	INDEX `consent_master_id` (`consent_master_id`),
	CONSTRAINT `cd_csfs_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

CREATE TABLE `cd_csfs_revs` (
	`consent_master_id` INT(11) NOT NULL,
	`date_consent_withdrawn` DATE NULL DEFAULT NULL,
	`date_consent_withdrawn_accuracy` DATE NULL DEFAULT NULL,
	`sex` VARCHAR(10) NULL DEFAULT NULL,
	`study_type` VARCHAR(100) NULL DEFAULT NULL,
	`person_consenting` VARCHAR(100) NULL DEFAULT NULL,
	`age_at_admission` INT(11) NULL DEFAULT NULL,
	`injury_datetime` DATETIME NULL DEFAULT NULL,
	`admission_neurological_lvl` VARCHAR(100) NULL DEFAULT NULL,
	`asia_grade` VARCHAR(10) NULL DEFAULT NULL,
	`admission_anatomical_lvl` TEXT NULL,
	`clinical_diagnosis` VARCHAR(100) NULL DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) NULL DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) NULL DEFAULT NULL,
	`neuro_diagnosis` TEXT NULL,
	`accident_detail` TEXT NULL,
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'date_consent_withdrawn', 'date consent withdrawn', '', 'date', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'sex', 'sex', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'sex'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'person_consenting', 'person obtaining consent', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'person_consenting'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'age_at_admission', 'age at admission', '', 'integer_positive', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'injury_datetime', 'injury datetime', '', 'datetime', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'admission_neurological_lvl', 'admission - neurological level', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'neuro_injury_level'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'asia_grade', '', 'asia grade', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_asia_grade'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'admission_anatomical_lvl', 'admission - anatomical level', '', 'textarea', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'clinical_diagnosis', 'clinical diagnosis', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'clinical_diagnosis'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'injury_mechanism', 'injury mechanism', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'mechanism_injury'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'injury_mechanism_other', '', 'other', 'input', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_csfs', 'neuro_diagnosis', 'neurological diagnosis', '', 'textarea', '', '', NULL, '', 0);


INSERT INTO structure_formats (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='sex' AND `type`='select'), 
2, 10, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='age_at_admission' AND `type`='integer_positive'), 
2, 12, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='injury_datetime' AND `type`='datetime'), 
2, 14, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='admission_neurological_lvl' AND `type`='select'), 
2, 16, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='asia_grade' AND `type`='select'), 
2, 18, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='admission_anatomical_lvl' AND `type`='textarea'), 
2, 20, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='clinical_diagnosis' AND `type`='select'), 
2, 22, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='injury_mechanism' AND `type`='select'), 
2, 24, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='injury_mechanism_other' AND `type`='input'), 
2, 26, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='neuro_diagnosis' AND `type`='textarea'), 
2, 28, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='person_consenting' AND `type`='select'), 
1, 43, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_csfs'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_csfs' AND `field`='date_consent_withdrawn' AND `type`='date'), 
1, 30, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0);

-- Drainage

CREATE TABLE `cd_drainages` (
	`consent_master_id` INT(11) NOT NULL,
	`date_consent_withdrawn` DATE NULL DEFAULT NULL,
	`date_consent_withdrawn_accuracy` DATE NULL DEFAULT NULL,
	`sex` VARCHAR(10) NULL DEFAULT NULL,
	`study_type` VARCHAR(100) NULL DEFAULT NULL,
	`person_consenting` VARCHAR(100) NULL DEFAULT NULL,
	`age_at_admission` INT(11) NULL DEFAULT NULL,
	`injury_datetime` DATETIME NULL DEFAULT NULL,
	`admission_neurological_lvl` VARCHAR(100) NULL DEFAULT NULL,
	`asia_grade` VARCHAR(10) NULL DEFAULT NULL,
	`admission_anatomical_lvl` TEXT NULL,
	`clinical_diagnosis` VARCHAR(100) NULL DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) NULL DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) NULL DEFAULT NULL,
	`neuro_diagnosis` TEXT NULL,
	`accident_detail` TEXT NULL,
	INDEX `consent_master_id` (`consent_master_id`),
	CONSTRAINT `cd_drainages_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

CREATE TABLE `cd_drainages_revs` (
	`consent_master_id` INT(11) NOT NULL,
	`date_consent_withdrawn` DATE NULL DEFAULT NULL,
	`date_consent_withdrawn_accuracy` DATE NULL DEFAULT NULL,
	`sex` VARCHAR(10) NULL DEFAULT NULL,
	`study_type` VARCHAR(100) NULL DEFAULT NULL,
	`person_consenting` VARCHAR(100) NULL DEFAULT NULL,
	`age_at_admission` INT(11) NULL DEFAULT NULL,
	`injury_datetime` DATETIME NULL DEFAULT NULL,
	`admission_neurological_lvl` VARCHAR(100) NULL DEFAULT NULL,
	`asia_grade` VARCHAR(10) NULL DEFAULT NULL,
	`admission_anatomical_lvl` TEXT NULL,
	`clinical_diagnosis` VARCHAR(100) NULL DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) NULL DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) NULL DEFAULT NULL,
	`neuro_diagnosis` TEXT NULL,
	`accident_detail` TEXT NULL,
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;


INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'date_consent_withdrawn', 'date consent withdrawn', '', 'date', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'sex', 'sex', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'sex'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'person_consenting', 'person obtaining consent', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'person_consenting'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'age_at_admission', 'age at admission', '', 'integer_positive', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'injury_datetime', 'injury datetime', '', 'datetime', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'admission_neurological_lvl', 'admission - neurological level', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'neuro_injury_level'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'asia_grade', '', 'asia grade', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_asia_grade'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'admission_anatomical_lvl', 'admission - anatomical level', '', 'textarea', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'clinical_diagnosis', 'clinical diagnosis', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'clinical_diagnosis'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'injury_mechanism', 'injury mechanism', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'mechanism_injury'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'injury_mechanism_other', '', 'other', 'input', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_drainages', 'neuro_diagnosis', 'neurological diagnosis', '', 'textarea', '', '', NULL, '', 0);


INSERT INTO structure_formats (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='sex' AND `type`='select'), 
2, 10, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='age_at_admission' AND `type`='integer_positive'), 
2, 12, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='injury_datetime' AND `type`='datetime'), 
2, 14, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='admission_neurological_lvl' AND `type`='select'), 
2, 16, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='asia_grade' AND `type`='select'), 
2, 18, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='admission_anatomical_lvl' AND `type`='textarea'), 
2, 20, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='clinical_diagnosis' AND `type`='select'), 
2, 22, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='injury_mechanism' AND `type`='select'), 
2, 24, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='injury_mechanism_other' AND `type`='input'), 
2, 26, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='neuro_diagnosis' AND `type`='textarea'), 
2, 28, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='person_consenting' AND `type`='select'), 
1, 43, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_drainages'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_drainages' AND `field`='date_consent_withdrawn' AND `type`='date'), 
1, 30, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0);


-- Pressure

CREATE TABLE `cd_pressures` (
	`consent_master_id` INT(11) NOT NULL,
	`date_consent_withdrawn` DATE NULL DEFAULT NULL,
	`date_consent_withdrawn_accuracy` DATE NULL DEFAULT NULL,
	`sex` VARCHAR(10) NULL DEFAULT NULL,
	`study_type` VARCHAR(100) NULL DEFAULT NULL,
	`person_consenting` VARCHAR(100) NULL DEFAULT NULL,
	`age_at_admission` INT(11) NULL DEFAULT NULL,
	`injury_datetime` DATETIME NULL DEFAULT NULL,
	`admission_neurological_lvl` VARCHAR(100) NULL DEFAULT NULL,
	`asia_grade` VARCHAR(10) NULL DEFAULT NULL,
	`admission_anatomical_lvl` TEXT NULL,
	`clinical_diagnosis` VARCHAR(100) NULL DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) NULL DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) NULL DEFAULT NULL,
	`neuro_diagnosis` TEXT NULL,
	`accident_detail` TEXT NULL,
	INDEX `consent_master_id` (`consent_master_id`),
	CONSTRAINT `cd_pressures_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

CREATE TABLE `cd_pressures_revs` (
	`consent_master_id` INT(11) NOT NULL,
	`date_consent_withdrawn` DATE NULL DEFAULT NULL,
	`date_consent_withdrawn_accuracy` DATE NULL DEFAULT NULL,
	`sex` VARCHAR(10) NULL DEFAULT NULL,
	`study_type` VARCHAR(100) NULL DEFAULT NULL,
	`person_consenting` VARCHAR(100) NULL DEFAULT NULL,
	`age_at_admission` INT(11) NULL DEFAULT NULL,
	`injury_datetime` DATETIME NULL DEFAULT NULL,
	`admission_neurological_lvl` VARCHAR(100) NULL DEFAULT NULL,
	`asia_grade` VARCHAR(10) NULL DEFAULT NULL,
	`admission_anatomical_lvl` TEXT NULL,
	`clinical_diagnosis` VARCHAR(100) NULL DEFAULT NULL,
	`injury_mechanism` VARCHAR(255) NULL DEFAULT NULL,
	`injury_mechanism_other` VARCHAR(255) NULL DEFAULT NULL,
	`neuro_diagnosis` TEXT NULL,
	`accident_detail` TEXT NULL,
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'date_consent_withdrawn', 'date consent withdrawn', '', 'date', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'sex', 'sex', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'sex'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'person_consenting', 'person obtaining consent', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'person_consenting'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'age_at_admission', 'age at admission', '', 'integer_positive', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'injury_datetime', 'injury datetime', '', 'datetime', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'admission_neurological_lvl', 'admission - neurological level', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'neuro_injury_level'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'asia_grade', '', 'asia grade', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'icord_asia_grade'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'admission_anatomical_lvl', 'admission - anatomical level', '', 'textarea', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'clinical_diagnosis', 'clinical diagnosis', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'clinical_diagnosis'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'injury_mechanism', 'injury mechanism', '', 'select', '', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'mechanism_injury'), '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'injury_mechanism_other', '', 'other', 'input', '', '', NULL, '', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pressures', 'neuro_diagnosis', 'neurological diagnosis', '', 'textarea', '', '', NULL, '', 0);


INSERT INTO structure_formats (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='sex' AND `type`='select'), 
2, 10, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='age_at_admission' AND `type`='integer_positive'), 
2, 12, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='injury_datetime' AND `type`='datetime'), 
2, 14, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='admission_neurological_lvl' AND `type`='select'), 
2, 16, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='asia_grade' AND `type`='select'), 
2, 18, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='admission_anatomical_lvl' AND `type`='textarea'), 
2, 20, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='clinical_diagnosis' AND `type`='select'), 
2, 22, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='injury_mechanism' AND `type`='select'), 
2, 24, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='injury_mechanism_other' AND `type`='input'), 
2, 26, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='neuro_diagnosis' AND `type`='textarea'), 
2, 28, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='person_consenting' AND `type`='select'), 
1, 43, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'cd_pressures'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pressures' AND `field`='date_consent_withdrawn' AND `type`='date'), 
1, 30, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
1, 1, 1, 0, 0);