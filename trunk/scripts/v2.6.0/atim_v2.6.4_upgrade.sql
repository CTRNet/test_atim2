-- ------------------------------------------------------
-- ATiM v2.6.4 Upgrade Script
-- version: 2.6.4
--
-- For more information: 
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- ------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3114: Use of Manage reusable identifiers generates bug
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET use_link = '/Administrate/ReusableMiscIdentifiers/index' WHERE use_link = '/Administrate/MiscIdentifiers/index';
INSERT INTO i18n (id,en,fr) VALUES ('manage', 'Manage', 'Gérer');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue: Change datamart_browsing_results id_csv to allow system to keep more than 10000 records
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE datamart_browsing_results MODIFY  id_csv longtext NOT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3131: Participant Review Change Request (hook call, details, etc)
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'custom', '', 'chronology_details', 'input',  NULL , '0', '', '', '', 'details', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chronology'), (SELECT id FROM structure_fields WHERE `model`='custom' AND `tablename`='' AND `field`='chronology_details' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='details' AND `language_tag`=''), '0', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3123: Search browsing a file - Add control on source file 
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`) 
VALUES
('err_submitted_file_extension', 1, 'error opening file', 'only .csv and .txt files can be submitted'),
('err_opening_submitted_file', 1, 'error opening file', 'the system is unable to read the submitted file');
INSERT INTO i18n (id,en,fr) 
VALUES 
('error opening file', 'Error opening file', 'Erreur lors de l''ouverture du fichier'),
('only .csv and .txt files can be submitted', 'Only .csv and .txt files can be submitted', 'Seuls les fichiers .csv et .txt peuvent être soumis'),
('the system is unable to read the submitted file', 'The system is unable to read the submitted file', 'Le système n''a pas pu lire le fichier soumis');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3117: dx_recurrence structure is missing 
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO structures(`alias`) VALUES ('dx_recurrence');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3074: Add revisioning for users/groups 
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE users
 ADD COLUMN created_by int(10) unsigned NOT NULL,
 ADD COLUMN modified_by int(10) unsigned NOT NULL;
 
CREATE TABLE IF NOT EXISTS users_revs (
  id int(11) NOT NULL,
  username varchar(200) NOT NULL DEFAULT '',
  first_name varchar(50) DEFAULT NULL,
  last_name varchar(50) DEFAULT NULL,
  `password` varchar(255) NOT NULL DEFAULT '',
  email varchar(200) NOT NULL DEFAULT '',
  department varchar(50) DEFAULT NULL,
  job_title varchar(50) DEFAULT NULL,
  institution varchar(50) DEFAULT NULL,
  laboratory varchar(50) DEFAULT NULL,
  help_visible varchar(50) DEFAULT NULL,
  street varchar(50) DEFAULT NULL,
  city varchar(50) DEFAULT NULL,
  region varchar(50) DEFAULT NULL,
  country varchar(50) DEFAULT NULL,
  mail_code varchar(50) DEFAULT NULL,
  phone_work varchar(50) DEFAULT NULL,
  phone_home varchar(50) DEFAULT NULL,
  group_id int(11) NOT NULL DEFAULT '0',
  flag_active tinyint(1) NOT NULL,
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  password_modified datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE groups
 ADD COLUMN created_by int(10) unsigned NOT NULL,
 ADD COLUMN modified_by int(10) unsigned NOT NULL;
 
CREATE TABLE IF NOT EXISTS groups_revs (
  id int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  bank_id int(11) DEFAULT NULL,
  flag_show_confidential tinyint(1) unsigned NOT NULL DEFAULT '0',
  modified_by int(10) unsigned NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
 
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3049: Error in the 'viability (%)' translation in french
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('viability (%)', '', 'Viability (&#37;)', 'Viabilité (&#37;)');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3063: Add limit on batch processes
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('batch init - number of submitted records too big', 'The number of records submitted are too big to be managed in batch!','Le nombre de données soumises pour être traitées en lot est trop important!');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.4', NOW(),'???','n/a');
