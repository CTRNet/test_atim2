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

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('viability (%)', 'Viability (&#37;)', 'Viabilité (&#37;)');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3063: Add limit on batch processes
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('batch init - number of submitted records too big', 'The number of records submitted are too big to be managed in batch!','Le nombre de données soumises pour être traitées en lot est trop important!');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3135: StorageControl.changeActiveStatus(): Change rules checking that no StorageMaster is linked to the processed storage type 
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `i18n` (`id`, `en`, `fr`) 
VALUES
('this storage type has already been used to build a storage in the past - properties can not be changed anymore', 'This storage type has already been used to build storages in the past - Properties can not be changed anymore', 'Ce type d''entreposage a déjà été utilisé pour construire un entreposage - Les données ne peuvent plus être modifiées');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3115: Add treatment in batch
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT 'New code to create treatment in batch: Please review all of your treatments creation processes including both structures and hooks and change control data if required' AS 'TODO';
INSERT INTO i18n (id,en,fr)
VALUES
('you need privileges to access this page','You need privileges  to access this page','Vous devez avoir des privilèges pour accéder à cette page');
ALTER TABLE treatment_controls
  ADD COLUMN use_addgrid tinyint(1) NOT NULL DEFAULT '0',
  ADD COLUMN use_detail_form_for_index tinyint(1) NOT NULL DEFAULT '0';
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND `flag_add`='1';
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='CopyCtrl' AND `type`='checkbox' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_checkbox')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='copy control' AND `language_tag`=''), '3', '10000', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3139: Add option to display details of treatments in index form 
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT 'New code to display details of treatments in index form : Please review all of structures of your treatments, hooks and change control data if required' AS 'TODO';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3118: Build report to list nbr of elements listed in Databrowser per patient
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `datamart_reports` (`id`, `name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `created`, `created_by`, `modified`, `modified_by`, `associated_datamart_structure_id`) 
VALUES
(null, 'elements number per participant', 'count the number of elements of a batchset or databrowser result form per participant', '', 'elements_number_per_participant', 'index', 'getElementsNumberPerParticipant', 1, NULL, 0, NULL, 0, (SELECT id FROM datamart_structures WHERE model = 'Participant'));
INSERT INTO `datamart_structure_functions` (`id`, `datamart_structure_id`, `label`, `link`, `flag_active`, `ref_single_fct_link`) VALUES
(null, (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'), 'elements number per participant', CONCAT('/Datamart/Reports/manageReport/', (SELECT id FROM datamart_reports WHERE name = 'elements number per participant')), 1, ''),
(null, (SELECT id FROM datamart_structures WHERE model = 'ViewCollection'), 'elements number per participant', CONCAT('/Datamart/Reports/manageReport/', (SELECT id FROM datamart_reports WHERE name = 'elements number per participant')), 1, ''),
(null, (SELECT id FROM datamart_structures WHERE model = 'ViewSample'), 'elements number per participant', CONCAT('/Datamart/Reports/manageReport/', (SELECT id FROM datamart_reports WHERE name = 'elements number per participant')), 1, ''),
(null, (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier'), 'elements number per participant', CONCAT('/Datamart/Reports/manageReport/', (SELECT id FROM datamart_reports WHERE name = 'elements number per participant')), 1, ''),
(null, (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster'), 'elements number per participant', CONCAT('/Datamart/Reports/manageReport/', (SELECT id FROM datamart_reports WHERE name = 'elements number per participant')), 1, ''),
(null, (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster'), 'elements number per participant', CONCAT('/Datamart/Reports/manageReport/', (SELECT id FROM datamart_reports WHERE name = 'elements number per participant')), 1, ''),
(null, (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster'), 'elements number per participant', CONCAT('/Datamart/Reports/manageReport/', (SELECT id FROM datamart_reports WHERE name = 'elements number per participant')), 1, ''),
(null, (SELECT id FROM datamart_structures WHERE model = 'EventMaster'), 'elements number per participant', CONCAT('/Datamart/Reports/manageReport/', (SELECT id FROM datamart_reports WHERE name = 'elements number per participant')), 1, '');
INSERT INTO structures(`alias`) VALUES ('elements_number_per_participant');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'elements_number', 'integer_positive',  NULL , '0', 'size=5', '', '', 'elements number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='elements_number_per_participant'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '1', '1', '', '0', '1', 'first name', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='elements_number_per_participant'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1'), '1', '3', '', '0', '1', 'last name', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='elements_number_per_participant'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier'), '1', '-1', 'clin_demographics', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='elements_number_per_participant'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='elements_number' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='elements number' AND `language_tag`=''), '1', '1000', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `language_heading`='data' WHERE structure_id=(SELECT id FROM structures WHERE alias='elements_number_per_participant') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='elements_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('number of %s per participant', 'Number of %s per participant', 'Nombre de %s par participant'),
('elements number', 'Elements Number', 'Nombre d''éléments'),
('the selected report can only be launched from a batchset or a databrowser node', 'The selected report can only be launched from a Batchset or Databrowser Node', "Le rapport sélectionné ne peut être lancé qu'à partir d'un 'Lot de données' (ou d'un Noeud du 'Navigateur de Données')"),
('elements number per participant', 'Elements number per participant', "Nombre d'éléments par participant"),
('count the number of elements of a batchset or databrowser result form per participant', 'Count the number of elements of a Batchset (or Databrowser Node) per participant', "Compte le nombre d'éléments d'un 'Lot de données' (ou d'un Noeud du 'Navigateur de Données') par participant");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3142: Add drug in batch 
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='drugs') AND `flag_add`='1';
UPDATE structure_fields SET  `setting`='cols=40,rows=2' WHERE model='Drug' AND tablename='drugs' AND field='description' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='size=40' WHERE model='Drug' AND tablename='drugs' AND field='generic_name' AND `type`='input' AND structure_value_domain  IS NULL ;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.4', NOW(),'???','n/a');
