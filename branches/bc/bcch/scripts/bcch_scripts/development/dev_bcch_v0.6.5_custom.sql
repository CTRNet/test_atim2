-- BCCH Customization Script
-- Version 0.6.5
-- ATiM Version: 2.6.7

use atim_ccbr_dev;

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.6.5", '');


-- Modify Secondary Identifiers to be Alphabetically ordered

UPDATE misc_identifier_controls
SET `display_order`= 10
WHERE `misc_identifier_name` != 'PHN'
AND `misc_identifier_name` != 'MRN'
AND `misc_identifier_name` != 'COG Registration'
AND `misc_identifier_name` != 'CCBR Identifier';

-- Add Pedvas Related Secondary Identifiers

INSERT INTO misc_identifier_controls
(`misc_identifier_name`, `flag_active`, `display_order`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `flag_link_to_study`)
VALUES
('PEDVAS Lab ID', 1, 10, NULL, 1, 1, 1, 0, 1),
('PEDVAS Brainworks ID', 1, 10, NULL, 0, 1, 1, 0, 1),
('PEDVAS Pediatric Prospective ID', 1, 10, NULL, 0, 1, 1, 0, 1),
('PEDVAS Pediatric Restrospective ID', 1, 10, NULL, 0, 1, 1, 0, 1),
('PEDVAS DCVAS Cohort 1 ID', 1, 10, NULL, 0, 1, 1, 0, 1),
('PEDVAS DCVAS Cohort 2 ID', 1, 10, NULL, 0, 1, 1, 0, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('PEDVAS Lab ID', 'PEDVAS Lab ID', ''),
('PEDVAS Brainworks ID', 'PEDVAS Brainworks ID', ''),
('PEDVAS Pediatric Prospective ID', 'PEDVAS Pediatric Prospective ID', ''),
('PEDVAS Pediatric Restrospective ID', 'PEDVAS Pediatric Restrospective ID', ''),
('PEDVAS DCVAS Cohort 1 ID', 'PEDVAS DCVAS Cohort 1 ID', ''),
('PEDVAS DCVAS Cohort 2 ID', 'PEDVAS DCVAS Cohort 2 ID', '');


-- Consent Form

CREATE TABLE `cd_pedvas` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
    `consent_type` VARCHAR(20) DEFAULT NULL,
    `date_of_verbal_consent` DATE DEFAULT NULL,
    `date_of_assent` DATE DEFAULT NULL,
    `status_date` DATE DEFAULT NULL,
    `date_consent_signed` DATE DEFAULT NULL,
    `consent_store_material` VARCHAR(30) DEFAULT NULL,
    `consent_future_followup` VARCHAR(30) DEFAULT NULL,
    `consent_future_research` VARCHAR(30) DEFAULT NULL,
    `consent_other_research` VARCHAR(30) DEFAULT NULL,
    `consent_leftover_research_samples_usage` VARCHAR(30) DEFAULT NULL,
    `consent_leftover_diagnostic_samples_usage` VARCHAR(30) DEFAULT NULL,
	`consent_master_id` INT(11) NOT NULL,
	PRIMARY KEY (`id`),
    INDEX `consent_master_id` (`consent_master_id`),
    CONSTRAINT `cd_pedvas_consent_masters` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

CREATE TABLE `cd_pedvas_revs` (
    `consent_type` VARCHAR(20) DEFAULT NULL,
    `date_of_verbal_consent` DATE DEFAULT NULL,
    `date_of_assent` DATE DEFAULT NULL,
    `status_date` DATE DEFAULT NULL,
    `date_consent_signed` DATE DEFAULT NULL,
    `consent_store_material` VARCHAR(30) DEFAULT NULL,
    `consent_future_followup` VARCHAR(30) DEFAULT NULL,
    `consent_future_research` VARCHAR(30) DEFAULT NULL,
    `consent_other_research` VARCHAR(30) DEFAULT NULL,
    `consent_leftover_research_samples_usage` VARCHAR(30) DEFAULT NULL,
    `consent_leftover_diagnostic_samples_usage` VARCHAR(30) DEFAULT NULL,
	`consent_master_id` INT(11) NOT NULL,
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

INSERT INTO consent_controls
(`controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`)
VALUES
('PEDVAS Consent', 1, 'cd_pedvas', 'cd_pedvas', 5, 'PEDVAS Consent');


INSERT INTO structures (`alias`, `description`)
VALUES
('cd_pedvas', 'Use for PEDVAS Consent Forms');

INSERT INTO structure_value_domains (`domain_name`, `override`, `category`, `source`)
VALUES
('open_closed', 'open', '', '');

INSERT INTO structure_permissible_values (`value`, `language_alias`)
VALUES
('open' , 'open'),
('closed', 'closed');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'open_closed'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'open'), 1, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'open_closed'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'closed'), 2, 1, 1);


INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_pedvas', 'consent_type', 'Consent Type', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'open_closed'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pedvas', 'date_of_verbal_consent', 'Date of Verbal Consent', '', 'date', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pedvas', 'date_of_assent', 'Date of Assent', '', 'date', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pedvas', 'status_date', 'Status Date', '', 'date', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pedvas', 'date_consent_signed', 'Date Consent Signed', '', 'date', '', NULL, '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pedvas', 'consent_store_material', 'Store Material at BCCH Research Institute', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'yesno'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pedvas', 'consent_future_followup', 'Contact Future Followup', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'yesno'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pedvas', 'consent_future_research', 'Contact Future Research', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'yesno'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pedvas', 'consent_other_research', 'Contact Other Research', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'yesno'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pedvas', 'consent_leftover_research_samples_usage', 'Use of Leftover Research Samples', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'yesno'), '', 'open', 'open', 'open', 0),
('ClinicalAnnotation', 'ConsentDetail', 'cd_pedvas', 'consent_leftover_diagnostic_samples_usage', 'Use of Leftover Diagnostic Samples', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'yesno'), '', 'open', 'open', 'open', 0);


INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='cd_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pedvas' AND `field`='consent_type'),
1, 5, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pedvas' AND `field`='date_of_verbal_consent'),
1, 10, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pedvas' AND `field`='date_of_assent'),
1, 12, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pedvas' AND `field`='status_date'),
1, 14, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pedvas' AND `field`='date_consent_signed'),
1, 16, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pedvas' AND `field`='consent_store_material'),
2, 10, 'General Consent', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pedvas' AND `field`='consent_future_followup'),
2, 12, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pedvas' AND `field`='consent_future_research'),
2, 14, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pedvas' AND `field`='consent_other_research'),
2, 16, 'Optional Consent', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pedvas' AND `field`='consent_leftover_research_samples_usage'),
2, 18, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='cd_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='ConsentDetail' AND `tablename`='cd_pedvas' AND `field`='consent_leftover_diagnostic_samples_usage'),
2, 20, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0);

-- Diagnosis

CREATE TABLE `dxd_pedvas` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
    `physician_diagnosis` VARCHAR(300) DEFAULT NULL,
	`diagnosis_master_id` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
    INDEX `diagnosis_master_id` (`diagnosis_master_id`),
	CONSTRAINT `dxd_pedvas_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

CREATE TABLE `dxd_pedvas_revs` (
	`diagnosis_master_id` INT(11) NOT NULL,
    `physician_diagnosis` VARCHAR(300) DEFAULT NULL,
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

INSERT INTO diagnosis_controls
(`category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`)
VALUES
('primary', 'pedvas', 1, 'dx_primary,dx_pedvas', 'dxd_pedvas', 0, 'primary|pedvas', 1);

INSERT INTO structure_value_domains
(`domain_name`, `override`, `source`)
VALUES
('pedvas_physician_diagnosis', 'open', NULL);

INSERT INTO structure_permissible_values
(`value`, `language_alias`)
VALUES
('Microscopic Polyangilitis', 'Microscopic Polyangilitis (MPA)'),
('Eosinophil Granulomatosis', 'Eosinophil Granulomatosis (EGPA/CSS)'),
('Granulomatosis with Polyangiitis', 'Granulomatosis with Polyangiitis (GPA)'),
('Limited Granulomatosis with Polyangiitis', 'limited Granulomatosis with Polyangiitis (lim GPA)'),
('Polyarteritis Nodosa', 'Polyarteritis Nodosa (PAN)'),
('Cutaneous Polyarteritis Nodosa', 'Cutaneous Polyarteritis Nodosa (cPAN)'),
('Takayasu\'s Arteritis', 'Takayasu\'s Arteritis (TA)'),
('ANCA Positive Pauci-Immune Glomerulonephritis', 'ANCA Positive Pauci-Immune Glomerulonephritis (ANCA+ glomerulonephritis)'),
('Unclassified Primary Vasculitis', 'Unclassified Primary Vasculitis (UCV)'),
('PACNS Small Vessel', 'PACNS Small Vessel (sv-PACNS)'),
('PACNS Progressive Large Vessel', 'PACNS Progressive Large Vessel (P lv PACNS)'),
('PACNS Non-Progressive Large Vessel', 'PACNS Non-Progressive Large Vessel (NP lv PACNS)'),
('PACNS Primary CNS Vasculitis', 'PACNS Primary CNS Vasculitis');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
('pedvas', 'PEDVAS', 'PEDVAS'),
('Microscopic Polyangilitis (MPA)', "Microscopic Polyangilitis (MPA)", ''),
('Eosinophil Granulomatosis (EGPA/CSS)', "Eosinophil Granulomatosis (EGPA/CSS)", ''),
('Granulomatosis with Polyangiitis (GPA)', "Granulomatosis with Polyangiitis (GPA)", ''),
('limited Granulomatosis with Polyangiitis (lim GPA)', "limited Granulomatosis with Polyangiitis (lim GPA)", ''),
('Polyarteritis Nodosa (PAN)', "Polyarteritis Nodosa (PAN)", ''),
('Cutaneous Polyarteritis Nodosa (cPAN)', "Cutaneous Polyarteritis Nodosa (cPAN)", ''),
('Takayasu\'s Arteritis (TA)', "Takayasu\'s Arteritis (TA)", ''),
('ANCA Positive Pauci-Immune Glomerulonephritis (ANCA+ glomerulonephritis)', "ANCA Positive Pauci-Immune Glomerulonephritis (ANCA+ glomerulonephritis)", ''),
('Unclassified Primary Vasculitis (UCV)', "Unclassified Primary Vasculitis (UCV)", ''),
('PACNS Small Vessel (sv-PACNS)', "PACNS Small Vessel (sv-PACNS)", ''),
('PACNS Progressive Large Vessel (P lv PACNS)', "PACNS Progressive Large Vessel (P lv PACNS)", ''),
('PACNS Non-Progressive Large Vessel (NP lv PACNS)', "PACNS Non-Progressive Large Vessel (NP lv PACNS)", ''),
('PACNS Primary CNS Vasculitis', "PACNS Primary CNS Vasculitis", '');


INSERT INTo structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'Microscopic Polyangilitis'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'Eosinophil Granulomatosis'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'Granulomatosis with Polyangiitis'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'Limited Granulomatosis with Polyangiitis'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'Polyarteritis Nodosa'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'Cutaneous Polyarteritis Nodosa'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'Takayasu\'s Arteritis'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'ANCA Positive Pauci-Immune Glomerulonephritis'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'Unclassified Primary Vasculitis'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'PACNS Small Vessel'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'PACNS Progressive Large Vessel'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'PACNS Non-Progressive Large Vessel'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'PACNS Primary CNS Vasculitis'), 0, 1, 1);

INSERT INTO structures
(`alias`, `description`)
VALUES
('dx_pedvas', 'Diagnosis Details for PEDVAS');


INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'dxd_pedvas', 'physician_diagnosis', 'Physician Diagnosis', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_physician_diagnosis'), '', 'open', 'open', 'open', 0);


INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='dx_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx'),
1, 9, '', 0, '', 1, 'ccbr age at dx years', 1,
1, 'integer', 1, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_months'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_weeks'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='ccbr_age_at_dx_days'),
1, 9, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 1, 1, 1, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='dx_pedvas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='dxd_pedvas' AND `field`='physician_diagnosis'),
1, 10, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0);





-- Add Haemolyzed Condition Indicator to Serum, Plasma and Blood

ALTER TABLE sd_spe_bloods
    ADD COLUMN `haemolyzed` VARCHAR(20) DEFAULT NULL AFTER `blood_type`;

ALTER TABLE sd_spe_bloods_revs
    ADD COLUMN `haemolyzed` VARCHAR(20) DEFAULT NULL AFTER `blood_type`;

ALTER TABLE sd_der_plasmas
    ADD COLUMN `haemolyzed` VARCHAR(20) DEFAULT NULL AFTER `sample_master_id`;

ALTER TABLE sd_der_plasmas_revs
    ADD COLUMN `haemolyzed` VARCHAR(20) DEFAULT NULL AFTER `sample_master_id`;

ALTER TABLE sd_der_serums
    ADD COLUMN `haemolyzed` VARCHAR(20) DEFAULT NULL AFTER `sample_master_id`;    

ALTER TABLE sd_der_serums_revs
    ADD COLUMN `haemolyzed` VARCHAR(20) DEFAULT NULL AFTER `sample_master_id`;

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'haemolyzed', 'Haemolyzed', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcch_yes_no_select'), '', 'open', 'open', 'open', 0),
('InventoryManagement', 'SampleDetail', 'sd_der_plasmas', 'haemolyzed', 'Haemolyzed', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcch_yes_no_select'), '', 'open', 'open', 'open', 0),  
('InventoryManagement', 'SampleDetail', 'sd_der_serums', 'haemolyzed', 'Haemolyzed', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'bcch_yes_no_select'), '', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`,
`flag_override_type`, `type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='sd_spe_bloods'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='haemolyzed'),
1, 500, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='sd_der_plasmas'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_plasmas' AND `field`='haemolyzed'),
1, 500, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='sd_der_serums'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SampleDetail' AND `tablename`='sd_der_serums' AND `field`='haemolyzed'),
1, 500, '', 0, '', 0, '', 0,
0, '', 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 0, 1, 0, 0);


-- Update the tube type in blood

INSERT INTO structure_permissible_values
(`value`, `language_alias`)
VALUES
('tempus', 'tempus'),
('bd p100', 'bd p100'),
('norgen preservatives', 'norgen preservatives'),
('og-575', 'og-575'),
('og-500', 'og-500');

UPDATE structure_value_domains_permissible_values
SET `display_order` = 0
WHERE `structure_value_domain_id` = (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_type');

INSERT INTO structure_value_domains_permissible_values
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`, `use_as_input`)
VALUES
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_type'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'tempus'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_type'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'bd p100'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_type'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'norgen preservatives'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_type'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'og-575'), 0, 1, 1),
((SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'blood_type'), (SELECT `id` FROm structure_permissible_values WHERE `value` = 'og-500'), 0, 1, 1);

-- PedVas Site

ALTER TABLE `specimen_details` 
    ADD COLUMN `pedvas_collection_site` VARCHAR(100) DEFAULT NULL AFTER `reception_datetime_accuracy`;

ALTER TABLE `specimen_details_revs` 
    ADD COLUMN `pedvas_collection_site` VARCHAR(100) DEFAULT NULL AFTER `reception_datetime_accuracy`;

INSERT INTO structure_value_domains
(`domain_name`, `override`, `category`, `source`)
VALUES
('pedvas_collection_site', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropDown(\'PEDVAS Collection Sites\')');

INSERT INTO structure_permissible_values_custom_controls
(`name`, `flag_active`, `values_max_length`, `category`, `values_used_as_input_counter`, `values_counter`)
VALUES
('PEDVAS Collection Sites', 1, 100, 'inventory', 12, 12);

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Calgary', 'Calgary', 'Calgary', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Belgrade', 'Belgrade', 'Belgrade', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Muenster', 'Muenster', 'Muenster', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Saskatoon', 'Saskatoon', 'Saskatoon', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Augusta', 'Augusta', 'Augusta', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Indianapolis', 'Indianapolis', 'Indianapolis', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Hackesack', 'Hackesack', 'Hackesack', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Salk Lake City', 'Salk Lake City', 'Salk Lake City', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Gainsville', 'Gainsville', 'Gainsville', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Bangkok', 'Bangkok', 'Bangkok', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Liverpool', 'Liverpool', 'Liverpool', 0, 1, NOW(), 1, NOW(), 1, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Newcastle', 'Newcastle', 'Newcastle', 0, 1, NOW(), 1, NOW(), 1, 0);

INSERT INTO structure_permissible_values_customs_revs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `modified_by`, `version_created`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Calgary', 'Calgary', 'Calgary', 0, 1, 1, NOW()),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Belgrade', 'Belgrade', 'Belgrade', 0, 1, 1, NOW()),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Muenster', 'Muenster', 'Muenster', 0, 1, 1, NOW()),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Saskatoon', 'Saskatoon', 'Saskatoon', 0, 1, 1, NOW()),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Augusta', 'Augusta', 'Augusta', 0, 1, 1, NOW()),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Indianapolis', 'Indianapolis', 'Indianapolis', 0, 1, 1, NOW()),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Hackesack', 'Hackesack', 'Hackesack', 0, 1, 1, NOW()),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Salk Lake City', 'Salk Lake City', 'Salk Lake City', 0, 1, 1, NOW()),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Gainsville', 'Gainsville', 'Gainsville', 0, 1, 1, NOW()),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Bangkok', 'Bangkok', 'Bangkok', 0, 1, 1, NOW()),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Liverpool', 'Liverpool', 'Liverpool', 0, 1, 1, NOW()),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'PEDVAS Collection Sites'), 'Newcastle', 'Newcastle', 'Newcastle', 0, 1, 1, NOW());


INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('InventoryManagement', 'SpecimenDetail', 'specimen_details', 'pedvas_collection_site', 'pedvas collection site', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_collection_site'), '', 'open', 'open', 'open', 0);



INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='specimens'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='pedvas_collection_site'),
1, 510, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 1, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='template_init_structure'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='pedvas_collection_site'),
1, 510, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 1, 0, 1, 0, 0, 0, 0,
1, 0, 0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='report_initial_specimens_criteria_and_result'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='pedvas_collection_site'),
0, 50, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 1, 0, 0, 0, 0,
1, 0, 0, 0, 0, 0, 0);



ALTER TABLE `derivative_details` 
    ADD COLUMN `pedvas_collection_site` VARCHAR(100) DEFAULT NULL AFTER `creation_datetime_accuracy`;

ALTER TABLE `derivative_details_revs` 
    ADD COLUMN `pedvas_collection_site` VARCHAR(100) DEFAULT NULL AFTER `creation_datetime_accuracy`;

INSERT INTO structure_fields
(`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`)
VALUES
('InventoryManagement', 'DerivativeDetail', 'derivative_details', 'pedvas_collection_site', 'pedvas collection site', '', 'select', '', (SELECT `id` FROM structure_value_domains WHERE `domain_name` = 'pedvas_collection_site'), '', 'open', 'open', 'open', 0);

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias`='derivatives'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='pedvas_collection_site'),
1, 510, '', 0, '', 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 1, 0, 0,
1, 0, 0, 0, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='lab_book_derivatives_summary'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='pedvas_collection_site'),
1, 510, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 1, 0, 1, 0, 0, 0, 0,
1, 0, 0, 0, 0, 0, 0),
((SELECT `id` FROM structures WHERE `alias`='report_list_all_derivatives_criteria_and_result'),
(SELECT `id` FROM structure_fields WHERE `plugin`='InventoryManagement' AND `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='pedvas_collection_site'),
0, 50, '', 0, '', 0, 0,
0, 0, 0, '',
0, 0, 0, 0, 1, 0, 0, 0, 0,
1, 0, 0, 0, 0, 0, 0);



-- ============================================================================
-- BB-236
-- CANTBI Secondary Identifier
-- ============================================================================

INSERT INTO misc_identifier_controls
(`misc_identifier_name`, `flag_active`, `display_order`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `flag_link_to_study`)
VALUES
('CANTBI ID', 1, 10, NULL, 1, 1, 1, 0, 1);

REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('CANTBI ID', 'CANTBI ID', '');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
('Physician Diagnosis', 'Physician Diagnosis', ''),
('Consent Type', "Consent Type", ''),
('PEDVAS Consent', "PEDVAS Consent", ''),
('open', "open", ''),
('closed', "closed", ''),
('Date of Verbal Consent', 'Date of Verbal Consent', ''),
('Date of Assent', 'Date of Assent', ''),
('Status Date', 'Status Date', ''),
('Date Consent Signed', 'Date Consent Signed', ''),
('General Consent', 'General Consent', ''),
('Store Material at BCCH Research Institute', 'Store Material at BCCH Research Institute', ''),
('Contact Future Followup', 'Contact Future Followup', ''),
('Contact Future Research', 'Contact Future Research', ''),
('Optional Consent', 'Optional Consent', ''),
('Contact Other Research', 'Contact Other Research', ''),
('Use of Leftover Research Samples', 'Use of Leftover Research Samples', ''),
('Use of Leftover Diagnostic Samples', 'Use of Leftover Diagnostic Samples', ''),
('pedvas collection site', 'Pedvas Collection Site', ''),
('Haemolyzed', "Haemolyzed", ''),
('tempus', 'Tempus', ''),
('bd p100', 'BD P100', ''),
('norgen preservatives', 'Norgen Preservatives', ''),
('og-575', 'OG-575', ''),
('og-500', 'OG-500', '');


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES 
('open', 'Open', ''),
('closed', "Closed", '');

