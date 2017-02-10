-- BCCH Customization Script
-- Version 0.6.1
-- ATiM Version: 2.6.7

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.6.1", '');

--  =============================================================================
--	Eventum ID: #XXXX
--  BB-214 Urine Supernatant Derivative
--	=============================================================================

CREATE TABLE `sd_der_urine_sups` (
	`sample_master_id` INT(11) NOT NULL,
	INDEX `FK_sd_der_urine_sups_sample_masters` (`sample_master_id`),
	CONSTRAINT `FK_sd_der_urine_sups_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

CREATE TABLE `sd_der_urine_sups_revs` (
	`sample_master_id` INT(11) NOT NULL,
	`version_id` INT(11) NOT NULL AUTO_INCREMENT,
	`version_created` DATETIME NOT NULL,
	PRIMARY KEY (`version_id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

INSERT INTO sample_controls
(`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`)
VALUES
('urine supernatant', 'derivative', 'sd_undetailed_derivatives,derivatives', 'sd_der_urine_sups', 0, 'urine supernatant');

INSERT INTO parent_to_derivative_sample_controls
(`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`, `lab_book_control_id`)
VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'urine' AND `sample_category` = 'specimen' AND `detail_tablename` = 'sd_spe_urines'), (SELECT `id` FROM sample_controls WHERE `sample_type` = 'urine supernatant' AND `sample_category` = 'derivative' AND `detail_tablename` = 'sd_der_urine_sups'), 1, NULL);

INSERT INTO aliquot_controls
(`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`)
VALUES
((SELECT `id` FROM sample_controls WHERE `sample_type` = 'urine supernatant' AND `sample_category` = 'derivative' AND `detail_tablename` = 'sd_der_urine_sups'), 'tube', '(ml)', 'ad_der_tubes_incl_ml_vol', 'ad_tubes', 'ml', 1, 'Derivative tube requiring volume in ml', 0, 'urine supernatant|tube');

REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('urine supernatant', 'Urine Supernatant', '');