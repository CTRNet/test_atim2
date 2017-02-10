-- BCCH Customization Script
-- Version 0.5.2
-- ATiM Version: 2.6.5

use atim_ccbr_dev;

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.5.2", '');
    
-- ==============================================================================================================
-- Eventum ID:XXXX  - New derivative type cell pellet
-- BB-165
-- ==============================================================================================================    

CREATE table `sd_der_cell_pellets` (
    `sample_master_id` int(11) NOT NULL,
    KEY `FK_sd_der_cell_pellets_sample_masters` (`sample_master_id`),
    CONSTRAINT `FK_sd_der_cell_pellets` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)  
);

CREATE table `sd_der_cell_pellets_revs` (
    `sample_master_id` int(11) NOT NULL,
    `version_id` int(11) NOT NULL AUTO_INCREMENT,
    `version_created` datetime NOT NULL,
    PRIMARY KEY (`version_id`)
);

INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`)
VALUES
('cell pellet', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_cell_pellets', 0, 'cell pellet');

INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`)
VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'blood'), (SELECT `id` FROM sample_controls WHERE `sample_type` = 'cell pellet'), 1, NULL),
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'bone marrow'), (SELECT `id` FROM sample_controls WHERE `sample_type` = 'cell pellet'), 1, NULL);


INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) 
VALUES 
((SELECT `id` FROM `sample_controls` where `sample_type` = 'cell pellet'), 'tube', '(ml)', 'ad_der_cell_tubes_incl_ml_vol', 'ad_tubes', 'ml', '1', 'Derivative tube requiring volume in ml specific for cells', '0', 'cell pellet|tube');

-- Connect DNA and RNA as derivatives of cell pellets

INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`)
VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'cell pellet'), (SELECT `id` FROM sample_controls WHERE `sample_type` = 'dna'), 1, NULL),
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'cell pellet'), (SELECT `id` FROM sample_controls WHERE `sample_type` = 'rna'), 1, NULL);

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('cell pellet', 'Cell Pellet', '');

UPDATE structures
SET `description` = 'Use this structures in the sample control table if the derivatives does not require fields in its own child table'
WHERE `alias` = 'sd_undetailed_derivatives';

-- ==============================================================================================================
-- Eventum ID:XXXX  
-- BB-167
-- ==============================================================================================================    

UPDATE `aliquot_masters` 
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE `aliquot_control_id` = (SELECT `id` FROM aliquot_controls WHERE `aliquot_type` = 'block' AND `detail_form_alias` = 'ad_spec_tiss_blocks' AND `detail_tablename` = 'ad_blocks')
AND `aliquot_label` LIKE '%C01444TI%';

UPDATE `aliquot_masters` 
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE `aliquot_control_id` = (SELECT `id` FROM aliquot_controls WHERE `aliquot_type` = 'block' AND `detail_form_alias` = 'ad_spec_tiss_blocks' AND `detail_tablename` = 'ad_blocks')
AND `aliquot_label` LIKE '%C01445TI%';

UPDATE `aliquot_masters` 
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE `aliquot_control_id` = (SELECT `id` FROM aliquot_controls WHERE `aliquot_type` = 'block' AND `detail_form_alias` = 'ad_spec_tiss_blocks' AND `detail_tablename` = 'ad_blocks')
AND `aliquot_label` LIKE '%C01469TI%';

UPDATE `aliquot_masters` 
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE `aliquot_control_id` = (SELECT `id` FROM aliquot_controls WHERE `aliquot_type` = 'block' AND `detail_form_alias` = 'ad_spec_tiss_blocks' AND `detail_tablename` = 'ad_blocks')
AND `aliquot_label` LIKE '%C01478TI%';

UPDATE `aliquot_masters` 
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE `aliquot_control_id` = (SELECT `id` FROM aliquot_controls WHERE `aliquot_type` = 'block' AND `detail_form_alias` = 'ad_spec_tiss_blocks' AND `detail_tablename` = 'ad_blocks')
AND `aliquot_label` LIKE '%C01484TI%';

UPDATE `aliquot_masters` 
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE `aliquot_control_id` = (SELECT `id` FROM aliquot_controls WHERE `aliquot_type` = 'block' AND `detail_form_alias` = 'ad_spec_tiss_blocks' AND `detail_tablename` = 'ad_blocks')
AND `aliquot_label` LIKE '%C01485TI%';

UPDATE `aliquot_masters` 
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE `aliquot_control_id` = (SELECT `id` FROM aliquot_controls WHERE `aliquot_type` = 'block' AND `detail_form_alias` = 'ad_spec_tiss_blocks' AND `detail_tablename` = 'ad_blocks')
AND `aliquot_label` LIKE '%C01486TI%';

UPDATE `aliquot_masters` 
SET `study_summary_id` = (SELECT `id` FROM study_summaries WHERE `title` = 'BCCHB')
WHERE `aliquot_control_id` = (SELECT `id` FROM aliquot_controls WHERE `aliquot_type` = 'block' AND `detail_form_alias` = 'ad_spec_tiss_blocks' AND `detail_tablename` = 'ad_blocks')
AND `aliquot_label` LIKE '%C01487TI%';

-- ==============================================================================================================
-- Eventum ID:XXXX  
-- BB-169
-- ==============================================================================================================  

-- Structures that need to have the date again
-- dx_progression
-- dx_recurrence
-- dx_remission
-- dx_secondary
-- dx_unknown_primary

INSERT INTO structure_formats
(`structure_id`, `structure_field_id`,
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `flag_override_tag`, `flag_override_help`,
`flag_override_type`, `flag_override_setting`, `flag_override_default`, `default`,
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_editgrid`, `flag_editgrid_readonly`,
`flag_summary`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_float`, `margin`) VALUES
((SELECT `id` FROM structures WHERE `alias` = 'dx_unknown_primary'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_progression'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_recurrence'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_remission'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0),
((SELECT `id` FROM structures WHERE `alias` = 'dx_secondary'),
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date'),
1, 3, '', 0, 0, 0,
0, 0, 0, '',
1, 0, 1, 0, 1, 0, 0, 0,
1, 0, 0, 1, 1, 0, 0);

-- ==============================================================================================================
-- Eventum ID:XXXX  
-- BB-166
-- ==============================================================================================================  

-- Use this SELECT statement for debugging
SELECT ed_bcch_dx_codes.id, ed_bcch_dx_codes.code_type, ed_bcch_dx_codes.code_value, ed_bcch_dx_codes.code_description, ed_bcch_dx_codes.event_master_id, event_masters.id, event_masters.event_control_id, event_masters.participant_id, event_masters.diagnosis_master_id, diagnosis_masters.diagnosis_control_id, dxd_bcch_oncology.former_category, dxd_bcch_oncology.final_diagnosis, participants.participant_identifier FROM event_masters, ed_bcch_dx_codes, diagnosis_masters, dxd_bcch_oncology, participants WHERE ed_bcch_dx_codes.event_master_id = event_masters.id AND diagnosis_masters.id = event_masters.diagnosis_master_id AND dxd_bcch_oncology.diagnosis_master_id = diagnosis_masters.id AND event_masters.participant_id = participants.id ORDER BY participants.participant_identifier ASC

-- Update the ed_bcch_dx_codes table

UPDATE `ed_bcch_dx_codes`, `coding_icd_o_3_morphology`
SET `ed_bcch_dx_codes`.`code_description` = `coding_icd_o_3_morphology`.`en_description`
WHERE `coding_icd_o_3_morphology`.`id` = `ed_bcch_dx_codes`.`code_value`
AND LENGTH(`ed_bcch_dx_codes`.`code_value`) > 4
AND `ed_bcch_dx_codes`.`code_value` IS NOT NULL;

UPDATE `dxd_bcch_oncology`, `diagnosis_masters`, `event_masters`, `ed_bcch_dx_codes`
SET `dxd_bcch_oncology`.`final_diagnosis` = `ed_bcch_dx_codes`.`code_description` 
WHERE LENGTH(`ed_bcch_dx_codes`.`code_value`) > 4
AND `ed_bcch_dx_codes`.`code_value` IS NOT NULL
AND `ed_bcch_dx_codes`.`event_master_id` = `event_masters`.`id` 
AND `diagnosis_masters`.`id` = `event_masters`.`diagnosis_master_id` 
AND `dxd_bcch_oncology`.`diagnosis_master_id` = `diagnosis_masters`.`id`;



-- Demonliazation

-- Participant Table --

-- First Name --

UPDATE `participants` SET `first_name` = cast(SHA1(`first_name`) AS CHAR(20) CHARACTER SET utf8);

-- Middle Name --

UPDATE `participants` SET `middle_name` = cast(SHA1(`middle_name`) AS CHAR(20) CHARACTER SET utf8);

-- Last Name --

UPDATE `participants` SET `last_name` = cast(SHA1(`last_name`) AS CHAR(20) CHARACTER SET utf8);

-- Date of Birth --

UPDATE `participants` SET `date_of_birth` = DATE_ADD(`date_of_birth`, INTERVAL FLOOR(1000*RAND()) DAY);

-- Parent or Guardian Name --

UPDATE `participants` SET `ccbr_parent_guardian_name` = cast(SHA1(`ccbr_parent_guardian_name`) AS CHAR(20) CHARACTER SET utf8);

-- Participant log tables --

UPDATE `participants`, `participants_revs`
SET `participants_revs`.`first_name` = `participants`.`first_name`,
`participants_revs`.`middle_name` = `participants`.`middle_name`,
`participants_revs`.`last_name` = `participants`.`last_name`,
`participants_revs`.`date_of_birth` = `participants`.`date_of_birth`,
`participants_revs`.`ccbr_parent_guardian_name` = `participants`.`ccbr_parent_guardian_name`
WHERE `participants`.`id` = `participants_revs`.`id`;

-- Identifiers Table --

-- COG --

UPDATE `misc_identifiers` SET `identifier_value` = CAST(SHA1(`identifier_value`) AS CHAR(6) CHARACTER SET UTF8)
WHERE `misc_identifier_control_id` = (SELECT `id` FROM `misc_identifier_controls` WHERE `misc_identifier_name` = 'COG Registration');

-- MRN --

UPDATE `misc_identifiers` SET `identifier_value` = FLOOR(10000000*RAND())
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'MRN');

-- PHN --

UPDATE `misc_identifiers` SET `identifier_value` = CONCAT(FLOOR(1000*RAND()), ' ', FLOOR(1000*RAND()), ' ', FLOOR(10000*RAND()))
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN');

UPDATE `misc_identifiers` SET `identifier_value` = CONCAT(FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), ' ', FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()), ' ', FLOOR(10*RAND()), FLOOR(10*RAND()), FLOOR(10*RAND()))
WHERE `misc_identifier_control_id` = (SELECT `id` FROM misc_identifier_controls WHERE `misc_identifier_name` = 'PHN');

-- Identifiers Revs Table --

UPDATE `misc_identifiers`, `misc_identifiers_revs`
SET `misc_identifiers_revs`.`identifier_value` = `misc_identifiers`.`identifier_value`
WHERE `misc_identifiers`.`id` = `misc_identifiers_revs`.`id`;

-- Participants Contact Information --

-- Contact Name


UPDATE `participant_contacts` SET `contact_name` = cast(SHA1(`contact_name`) AS CHAR(50) CHARACTER SET utf8);


-- Email Address

UPDATE `participant_contacts` SET `ccbr_email` = cast(SHA1(`ccbr_email`) AS CHAR(45) CHARACTER SET utf8);


-- Street

UPDATE `participant_contacts` SET `street` = cast(SHA1(`street`) AS CHAR(50) CHARACTER SET utf8);

-- City

UPDATE `participant_contacts` SET `locality` = cast(SHA1(`locality`) AS CHAR(50) CHARACTER SET utf8);

-- Postal Code

UPDATE `participant_contacts` SET `mail_code` = cast(SHA1(`mail_code`) AS CHAR(10) CHARACTER SET utf8);

-- Primary Phone Number

UPDATE `participant_contacts` SET `phone` = cast(SHA1(`phone`) AS CHAR(15) CHARACTER SET utf8);

-- Secondary Phone Number

UPDATE `participant_contacts` SET `phone_secondary` = cast(SHA1(`phone_secondary`) AS CHAR(30) CHARACTER SET utf8);

-- Participants Contact Log Table --

UPDATE `participant_contacts`, `participant_contacts_revs`
SET `participant_contacts_revs`.`contact_name` = `participant_contacts`.`contact_name`,
`participant_contacts_revs`.`ccbr_email` = `participant_contacts`.`ccbr_email`,
`participant_contacts_revs`.`street` = `participant_contacts`.`street`,
`participant_contacts_revs`.`locality` = `participant_contacts`.`locality`,
`participant_contacts_revs`.`mail_code` = `participant_contacts`.`mail_code`,
`participant_contacts_revs`.`phone` = `participant_contacts`.`phone`,
`participant_contacts_revs`.`phone_secondary` = `participant_contacts`.`phone_secondary`
WHERE `participant_contacts_revs`.`id` = `participant_contacts`.`id`;