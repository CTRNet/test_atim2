-- Version: v2.1.0
-- Description: This SQL script is an upgrade for ATiM v2.0.2A to 2.1.0 and must be run against
-- an existing ATiM installation. Be sure to backup your database before running this script!

-- Update version information
UPDATE `versions` 
SET `version_number` = 'v2.1.0 (Alpha)', `date_installed` = CURDATE(), `build_number` = ''
WHERE `versions`.`id` =1;

-- Add cDNA

CREATE TABLE IF NOT EXISTS `sd_der_cdnas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_sd_der_cdnas_sample_masters` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `sd_der_cdnas_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `sd_der_cdnas`
  ADD CONSTRAINT `FK_sd_der_cdnas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_type_code`, `sample_category`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(19, 'cdna', 'cDNA', 'derivative', 1, 'sd_undetailed_derivatives', 'sd_der_cdnas', 0);

INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`)
VALUES 
(null, (SELECT id FROM sample_controls WHERE sample_type LIKE 'rna'), (SELECT id FROM sample_controls WHERE sample_type LIKE 'cdna'),'1');

INSERT INTO `sample_to_aliquot_controls` (`id`, `sample_control_id`, `aliquot_control_id`, `flag_active`)
VALUES 
(null, (SELECT id FROM sample_controls WHERE sample_type LIKE 'cdna'), (SELECT id FROM aliquot_controls WHERE aliquot_type LIKE 'tube' AND form_alias LIKE 'ad_der_tubes_incl_ul_vol_and_conc' AND detail_tablename LIKE 'ad_tubes' AND volume_unit LIKE 'ul'), '1');

SET @sample_to_aliquot_control_id = LAST_INSERT_ID();

INSERT INTO `realiquoting_controls` (`id`, `parent_sample_to_aliquot_control_id`, `child_sample_to_aliquot_control_id`, `flag_active`)
VALUES 
(null, @sample_to_aliquot_control_id, @sample_to_aliquot_control_id, '1');

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('cdna', '', 'cDNA', 'DNAc');

-- Add new message for duplicated aliquot barcodes

INSERT INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES ('please check following barcodes', '', 'Please check following barcodes: ', 'Veuillez contrôler les barcodes suivants: ');



