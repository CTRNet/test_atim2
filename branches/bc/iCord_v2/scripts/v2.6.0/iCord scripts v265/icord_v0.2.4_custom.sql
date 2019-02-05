REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'iCord v0.2.4', '');


REPLACE INTO `i18n` (`id`, `en`, `fr`)
VALUES 
('compression time (minutes)', 'Compression Time (Minutes)', ''),
('injury level', 'Injury Level', ''),
('surgery datetime', 'Surgery Date and Time', '');



-- Elevate Plasma and Serum

CREATE TABLE `sd_spe_serums` (
	`sample_master_id` INT(11) NOT NULL,
    `blood_type` VARCHAR(30) NULL DEFAULT NULL,
	`collected_tube_nbr` INT(4) NULL DEFAULT NULL,
	`collected_volume` DECIMAL(10,5) NULL DEFAULT NULL,
	`collected_volume_unit` VARCHAR(20) NULL DEFAULT NULL,
	INDEX `FK_sd_spe_serums_sample_masters` (`sample_master_id`),
	CONSTRAINT `FK_sd_spe_serums_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;


CREATE TABLE `sd_spe_serums_revs` (
	`sample_master_id` INT(11) NOT NULL,
    `blood_type` VARCHAR(30) NULL DEFAULT NULL,
	`collected_tube_nbr` INT(4) NULL DEFAULT NULL,
	`collected_volume` DECIMAL(10,5) NULL DEFAULT NULL,
	`collected_volume_unit` VARCHAR(20) NULL DEFAULT NULL,
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;


CREATE TABLE `sd_spe_plasmas` (
	`sample_master_id` INT(11) NOT NULL,
    `blood_type` VARCHAR(30) NULL DEFAULT NULL,
	`collected_tube_nbr` INT(4) NULL DEFAULT NULL,
	`collected_volume` DECIMAL(10,5) NULL DEFAULT NULL,
	`collected_volume_unit` VARCHAR(20) NULL DEFAULT NULL,
	INDEX `FK_sd_spe_plasmas_sample_masters` (`sample_master_id`),
	CONSTRAINT `FK_sd_spe_plasmas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;


CREATE TABLE `sd_spe_plasmas_revs` (
	`sample_master_id` INT(11) NOT NULL,
    `blood_type` VARCHAR(30) NULL DEFAULT NULL,
	`collected_tube_nbr` INT(4) NULL DEFAULT NULL,
	`collected_volume` DECIMAL(10,5) NULL DEFAULT NULL,
	`collected_volume_unit` VARCHAR(20) NULL DEFAULT NULL,
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

INSERT INTO structures
(`alias`, `description`)
VALUES
('sd_spe_plasmas', ''),
('sd_spe_serums', '');

UPDATE sample_controls 
SET `sample_category` = 'specimen', `detail_form_alias` = 'sd_spe_serums,specimens', `detail_tablename`='sd_spe_serums'
WHERE `sample_type` = 'serum' AND `sample_category` = 'derivative';

UPDATE sample_controls 
SET `sample_category` = 'specimen', `detail_form_alias` = 'sd_spe_plasmas,specimens', `detail_tablename`='sd_spe_plasmas'
WHERE `sample_type` = 'plasma' AND `sample_category` = 'derivative';


UPDATE sample_controls
SET `display_order` = 0;

UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 0
WHERE `parent_sample_control_id` = (SELECT `id` FROM sample_controls WHERE `sample_type` = 'blood' AND `sample_category` = 'specimen' AND `detail_tablename` = 'sd_spe_bloods');

UPDATE parent_to_derivative_sample_controls
SET `flag_active` = 0
WHERE `derivative_sample_control_id` = (SELECT `id` FROM sample_controls WHERE `sample_type` = 'blood' AND `sample_category` = 'specimen' AND `detail_tablename` = 'sd_spe_bloods')
AND `parent_sample_control_id` IS NULL;

INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`)
VALUES
(NULL, (SELECT `id` FROM sample_controls WHERE `sample_type` = 'plasma'), 1, NULL),
(NULL, (SELECT `id` FROM sample_controls WHERE `sample_type` = 'serum'), 1, NULL);

-- Remove Study Type from Biobank Consent

DELETE FROM structure_formats
WHERE
`structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_biobanks' AND `field` = 'study_type' AND `type` = 'select');

DELETE FROM structure_fields
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'ConsentDetail' AND `tablename` = 'cd_biobanks' AND `field` = 'study_type' AND `type` = 'select';

-- Hide Last Chart Check Date
UPDATE structure_formats
SET `flag_detail` = 0
WHERE `structure_field_id` = (SELECT `id` FROM structure_fields WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'last_chart_checked_date');

-- Sifter #498

UPDATE structure_fields
SET `language_label` = 'compression time (minutes)', `type` = 'input'
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_compression_time';

-- Insert Surgery Datetime to  Participant

ALTER TABLE participants
	ADD COLUMN `icord_surgery_datetime` DATETIME NULL DEFAULT NULL AFTER `icord_pig_sacrifice_datetime_accuracy`,
	ADD COLUMN `icord_surgery_datetime_accuracy` CHAR(1) NOT NULL DEFAULT '' AFTER `icord_surgery_datetime`;

ALTER TABLE participants_revs
	ADD COLUMN `icord_surgery_datetime` DATETIME NULL DEFAULT NULL AFTER `icord_pig_sacrifice_datetime_accuracy`,
	ADD COLUMN `icord_surgery_datetime_accuracy` CHAR(1) NOT NULL DEFAULT '' AFTER `icord_surgery_datetime`;


INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`)
VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'icord_surgery_datetime', 'surgery datetime', '', 'datetime', '', '', NULL, '', 0);


INSERT INTO structure_formats (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_surgery_datetime' AND `type`='datetime'), 
3, 45, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0);

-- New values for Specimen Drawn Site Dropdown 
-- (User can add these options)

INSERT INTO structure_permissible_values_customs
(`control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`)
VALUES
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Specimen Drawn Sites'), 'Pig-CSF Rostral', 'Pig-CSF Rostral', 'Pig-CSF Rostral', 0, 1, NOW(), 0, NOW(), 0, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Specimen Drawn Sites'), 'Pig-CSF Caudal', 'Pig-CSF Caudal', 'Pig-CSF Caudal', 0, 1, NOW(), 0, NOW(), 0, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Specimen Drawn Sites'), 'Pig Jugular Vein', 'Pig Jugular Vein', 'Pig Jugular Vein', 0, 1, NOW(), 0, NOW(), 0, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Specimen Drawn Sites'), 'Pig-IP Proximal', 'Pig-IP Proximal', 'Pig-IP Proximal', 0, 1, NOW(), 0, NOW(), 0, 0),
((SELECT `id` FROM structure_permissible_values_custom_controls WHERE `name` = 'Specimen Drawn Sites'), 'Pig-PI Distal', 'Pig-PI Distal', 'Pig-PI Distal', 0, 1, NOW(), 0, NOW(), 0, 0);




-- Create a field called Injury Level

ALTER TABLE participants
	ADD COLUMN `icord_injury_level` VARCHAR(200) DEFAULT NULL AFTER `icord_pig_injury_type`;
ALTER TABLE participants_revs
	ADD COLUMN `icord_injury_level` VARCHAR(200) DEFAULT NULL AFTER `icord_pig_injury_type`;


INSERT INTO structure_fields (`plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`,`flag_confidential`)
VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'icord_injury_level', 'injury level', '', 'input', '', '', NULL, '', 0);


INSERT INTO structure_formats (`structure_id`, `structure_field_id`, 
`display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, 
`flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, 
`flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, 
`flag_index`, `flag_detail`, `flag_summary`, `flag_float`, `margin`)
VALUES
((SELECT `id` FROM structures WHERE `alias` = 'participants'), 
(SELECT `id` FROM structure_fields WHERE `plugin`='ClinicalAnnotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='icord_injury_level' AND `type`='input'), 
3, 46, '', 0, '', 0, '', 0, '', 
0, '', 0, '', 0, '', 
1, 0, 1, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0);

-- Sifter 533

ALTER TABLE participants
	MODIFY `icord_pig_body_weight` DECIMAL(5,2),
	MODIFY `icord_pig_injury_force` DECIMAL(5,2);

ALTER TABLE participants_revs
	MODIFY `icord_pig_body_weight` DECIMAL(5,2),
	MODIFY `icord_pig_injury_force` DECIMAL(5,2);

-- Sifter 563

ALTER TABLE participants
	MODIFY `icord_pig_compression_time` DECIMAL(7,2);

ALTER TABLE participants_revs
	MODIFY `icord_pig_compression_time` DECIMAL(7,2);

UPDATE structure_fields
SET `type` = 'float_positive', `structure_value_domain` = NULL
WHERE `plugin` = 'ClinicalAnnotation' AND `model` = 'Participant' AND `tablename` = 'participants' AND `field` = 'icord_pig_compression_time' AND `type` = 'input';