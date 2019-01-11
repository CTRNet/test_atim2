-- ------------------------------------------------------
-- ATiM v2.6.4 Upgrade Script
-- version: 2.6.4.1
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

ALTER TABLE datamart_browsing_results MODIFY id_csv longtext NOT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3131: Participant Review Change Request (hook call, details, etc)
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'custom', '', 'chronology_details', 'input',  NULL , '0', '', '', '', 'details', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chronology'), (SELECT id FROM structure_fields WHERE `model`='custom' AND `tablename`='' AND `field`='chronology_details' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='details' AND `language_tag`=''), '0', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3123: Search browsing a file - Add control on source file 
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `pages` (`id`, `error_flag`, `language_title`, `language_body`, `use_link`, `created_by`, `modified_by`) 
VALUES
('err_submitted_file_extension', 1, 'error opening file', 'only .csv and .txt files can be submitted', '', '1', '1'),
('err_opening_submitted_file', 1, 'error opening file', 'the system is unable to read the submitted file', '', '1', '1');
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

SELECT "Application Change: DatamartAppController::$display_limit variable has been removed and replaced by core variable 'databrowser_and_report_results_display_limit'. Please review any custom process or report that uses this variable and that has to be updated." AS '### MESSAGE ###';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3135: StorageControl.changeActiveStatus(): Change rules checking that no StorageMaster is linked to the processed storage type 
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `i18n` (`id`, `en`, `fr`) 
VALUES
('this storage type has already been used to build a storage in the past - properties can not be changed anymore', 'This storage type has already been used to build storages in the past - Properties can not be changed anymore', 'Ce type d''entreposage a déjà été utilisé pour construire un entreposage - Les données ne peuvent plus être modifiées');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3115: Add treatment in batch
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT 'Application Change: Added new code to create treatment in batch. To use this functionality, please review all of your treatment creation processes (including both structures and hooks call) and change trreatment_controls data.' AS '### MESSAGE ###';
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

SELECT 'Application Change: Added new code to display details of treatments in index form : Please review all of structures of your treatments, hooks and change control data if required' AS '### MESSAGE ###';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3142: Add drug in batch 
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='drugs') AND `flag_add`='1';
UPDATE structure_fields SET  `setting`='cols=40,rows=2' WHERE model='Drug' AND tablename='drugs' AND field='description' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `setting`='size=40' WHERE model='Drug' AND tablename='drugs' AND field='generic_name' AND `type`='input' AND structure_value_domain  IS NULL ;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 'tisue block' to 'tissue block' realiquoting control
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT "New Realiquoting Control: Created 'tisue block' to 'tissue block' realiquoting link but set it as 'disabled'. 1- Comment line if already created in the custom version. 2- Activate link if you link has to be used in your bank." AS '### MESSAGE ###';
SET @control_id = (SELECT ac.id FROM aliquot_controls ac INNER JOIN sample_controls sc ON sc.id = ac.sample_control_id WHERE sample_type = 'tissue' AND aliquot_type = 'block');
INSERT INTO realiquoting_controls (parent_aliquot_control_id,child_aliquot_control_id,flag_active) VALUES (@control_id,@control_id,0);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue #3175: Add Xenograft Derivative
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT "New Sample Type: Created 'Xenograft' derivative. 1- Comment line if already created in the custom version. 2- Disable sample_type if this sample type is not supported into your bank." AS '### MESSAGE ###';
INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'xenograft', 'derivative', 'sd_der_xenografts,derivatives', 'sd_der_xenografts', 0, 'xenograft');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('xenograft', 'Xenograft', 'Xénogreffe');
CREATE TABLE IF NOT EXISTS `sd_der_xenografts` (
  `sample_master_id` int(11) NOT NULL,
  species varchar(50),
  implantation_site varchar(50),
  laterality varchar(30)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `sd_der_xenografts_revs` (
  `sample_master_id` int(11) NOT NULL,
  species varchar(50),
  implantation_site varchar(50),
  laterality varchar(30),
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `sd_der_xenografts`
  ADD CONSTRAINT `FK_sd_der_xenografts_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('sd_der_xenografts');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('xenograft_species', "StructurePermissibleValuesCustom::getCustomDropdown('Xenograft Species')"),
('xenograft_implantation_sites', "StructurePermissibleValuesCustom::getCustomDropdown('Xenograft Implantation Sites')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Xenograft Species', 1, 50, 'inventory'),
('Xenograft Implantation Sites', 1, 50, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Xenograft Species');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('mouse', 'Mouse',  'Souris', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Xenograft Implantation Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('liver', 'Liver',  'Foie', '1', @control_id, NOW(), NOW(), 1, 1),
('mammary fat pad', 'Mammary Fat Pad',  'Tissu graisseux mammaire', '1', @control_id, NOW(), NOW(), 1, 1),
('flank', 'Flank',  'Flanc', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'species', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='xenograft_species') , '0', '', '', '', 'species', ''), 
('InventoryManagement', 'SampleDetail', '', 'implantation_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='xenograft_implantation_sites') , '0', '', '', '', 'implantation site', ''), 
('InventoryManagement', 'SampleDetail', '', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tissue_laterality') , '0', '', '', '', 'laterality', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_der_xenografts'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='species' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='xenograft_species')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='species' AND `language_tag`=''), '1', '444', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='sd_der_xenografts'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='implantation_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='xenograft_implantation_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='implantation site' AND `language_tag`=''), '1', '445', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_der_xenografts'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '446', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES 
('species', 'Species', 'Espèce'),
('implantation site','Implantation Site','Site d''implantation');
SET @control_id = (SELECT id FROM sample_controls WHERE sample_type = 'xenograft');
INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) 
(SELECT id, @control_id, '1' FROM sample_controls WHERE sample_type IN ('tissue','cell culture'));
INSERT INTO `parent_to_derivative_sample_controls` (`parent_sample_control_id`, `derivative_sample_control_id`, `flag_active`) 
(SELECT @control_id, id, '1' FROM sample_controls WHERE sample_type IN ('dna','rna','cell culture', 'protein','xenograft'));
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES
(@control_id, 'tube', '', 'ad_der_xenograft_tubes', 'ad_tubes', NULL, 1, '', 0, 'xenograft|tube'),
(@control_id, 'block', NULL, 'ad_der_xenograft_blocks', 'ad_blocks', NULL, 1, '', 0, 'xenograft|block'),
(@control_id, 'slide', '', 'ad_der_xenograft_slides', 'ad_xenograft_slides', NULL, 1, '', 0, 'xenograft|slide'),
(@control_id, 'core', '', 'ad_der_xenograft_cores', 'ad_xenograft_cores', NULL, 1, '', 0, 'xenograft|core');
INSERT INTO structures(`alias`) VALUES ('ad_der_xenograft_tubes');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='lot number' AND `language_tag`=''), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structures(`alias`) VALUES ('ad_der_xenograft_blocks');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='block type' AND `language_tag`=''), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='ad_der_xenograft_blocks'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_creat_to_stor_spent_time_msg_defintion' AND `language_label`='creation to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_blocks'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '59', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_blocks'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='creat_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '0', '1', 'creation to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_blocks'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '59', '', '0', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO structures(`alias`) VALUES ('ad_der_xenograft_slides');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_der_xenograft_slides'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='immunochemistry' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='immunochemistry code' AND `language_tag`=''), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structures(`alias`) VALUES ('ad_der_xenograft_cores');
CREATE TABLE IF NOT EXISTS `ad_xenograft_cores` (
  `aliquot_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `ad_xenograft_cores_revs` (
  `aliquot_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE IF NOT EXISTS `ad_xenograft_slides` (
  `aliquot_master_id` int(11) NOT NULL,
  `immunochemistry` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `ad_xenograft_slides_revs` (
  `aliquot_master_id` int(11) NOT NULL,
  `immunochemistry` varchar(30) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `ad_xenograft_cores`
  ADD CONSTRAINT `FK_ad_xenograft_cores_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`);
ALTER TABLE `ad_xenograft_slides`
  ADD CONSTRAINT `FK_ad_xenograft_slides_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`);
INSERT INTO realiquoting_controls (parent_aliquot_control_id, child_aliquot_control_id, flag_active) 
VALUES 
((SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_tubes'),(SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_tubes'), '1'),
((SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_tubes'),(SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_blocks'), '1'),
((SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_tubes'),(SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_slides'), '1'),
((SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_blocks'),(SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_blocks'), '1'),
((SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_blocks'),(SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_tubes'), '1'),
((SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_blocks'),(SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_slides'), '1'),
((SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_blocks'),(SELECT id FROM aliquot_controls WHERE detail_form_alias = 'ad_der_xenograft_cores'), '1');

-- -----------------------------------------------------------------------------------------------------------------------------------
--	Issue: #3189 - New sample type (Cord Blood)
-- -----------------------------------------------------------------------------------------------------------------------------------=

SELECT "New Sample Type: Created 'Cord Blood' specimen. 1- Comment line if already created in the custom version. 2- Disable sample_type if this sample type is not supported into your bank." AS '### MESSAGE ###';

CREATE TABLE `sd_spe_cord_bloods` (
  `sample_master_id` int(11) NOT NULL,
  KEY `FK_sd_spe_swabss_sample_masters` (`sample_master_id`),
  CONSTRAINT `FK_sd_spe_cord_bloods` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sd_spe_cord_bloods_revs` (
  `sample_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Add structure
INSERT INTO `structures` (`alias`) VALUES ('sd_spe_cord_bloods');

-- Add control row
INSERT INTO `sample_controls` (`sample_type`, `sample_category`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
 ('cord blood', 'specimen', 'sd_spe_cord_bloods,specimens', 'sd_spe_cord_bloods', '0', 'cord blood');

REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('cord blood', "Cord Blood", 'Sang de cordon');

-- Enable new sample type
INSERT INTO `parent_to_derivative_sample_controls` (`derivative_sample_control_id`, `flag_active`) VALUES ((SELECT `id` FROM `sample_controls` WHERE `sample_type` = 'cord blood'), '1');

-- Create aliquot tube for cord blood
INSERT INTO `aliquot_controls` (`sample_control_id`, `aliquot_type`, `aliquot_type_precision`, `detail_form_alias`, `detail_tablename`, `volume_unit`, `flag_active`, `comment`, `display_order`, `databrowser_label`) VALUES 
((SELECT `id` FROM `sample_controls` where `sample_type` = 'cord blood'), 'tube', '(ul + conc)', 'ad_spec_tubes_incl_ul_vol_and_conc', 'ad_tubes', 'ul', '1', 'Specimen tube requiring volume in ul and concentration', '0', 'cord blood|tube');

-- Add new specimen tube for cord blood
INSERT INTO `structures` (`alias`) VALUES ('ad_spec_tubes_incl_ul_vol_and_conc');

-- Add cell count fields
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `field`='cell_count' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cell count' AND `language_tag`=''), '1', '451', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `field`='cell_count_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='cell_count_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_tag`=''), '1', '452', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- Add volume fields
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ul_vol_and_conc'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='initial_volume' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='initial volume' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
--	Issue: #3187 - Add a message after patient merge to ask user to delete patient profile 
-- -----------------------------------------------------------------------------------------------------------------------------------=

INSERT INTO i18n (id,en,fr) 
VALUES 
('delete unmerged identifiers and profile of the merged participant',
'Delete unmerged identifiers and profile of the merged participant',
'Supprimer les identificateurs non fusionnées et le profil du participant fusionné');

-- -----------------------------------------------------------------------------------------------------------------------------------
--	Issue: #3172 - Collectoin Tree View - Display realiquoting date + order per date 
-- -----------------------------------------------------------------------------------------------------------------------------------=

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' limit 0 ,1), '0', '100', '', '0', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structures(`alias`) VALUES ('realiquoting_data_for_collection_tree_view');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='realiquoting_data_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoting_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_realiquoting_datetime_defintion' AND `language_label`='realiquoting date' AND `language_tag`=''), '0', '100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- -----------------------------------------------------------------------------------------------------------------------------------
--	Issue: #3118 - Report to list patient having a nbr of element listed in Databrowser
-- -----------------------------------------------------------------------------------------------------------------------------------=

ALTER TABLE datamart_reports ADD COLUMN limit_access_from_datamart_structrue_function tinyint(1) NOT NULL DEFAULT '0';
INSERT INTO `datamart_reports` (`name`, `description`, `form_alias_for_search`, `form_alias_for_results`, `form_type_for_results`, `function`, `flag_active`, `associated_datamart_structure_id`, limit_access_from_datamart_structrue_function, created_by, modified_by) VALUES
('number of elements per participant', 'number_of_elements_per_participant_description', '', 'number_of_elements_per_participant', 'index', 'countNumberOfElementsPerParticipants', 1, (SELECT id FROM datamart_structures WHERE model = 'Participant'), 1, '1', '1');
SET @control_id = (SELECT id FROM datamart_reports WHERE name = 'number of elements per participant');
INSERT INTO `datamart_structure_functions` (`datamart_structure_id`, `label`, `link`, `flag_active`) 
(SELECT id, 'number of elements per participant', CONCAT('/Datamart/Reports/manageReport\/', @control_id), 1
FROM datamart_structures WHERE model IN ('MiscIdentifier',
'ConsentMaster',
'DiagnosisMaster',
'TreatmentMaster',
'EventMaster',
'ReproductiveHistory',
'FamilyHistory',
'ParticipantMessage',
'ParticipantContact',
'ViewCollection',
'TreatmentExtendMaster',
'ViewAliquot',
'ViewSample',
'QualityCtrl',
'SpecimenReviewMaster',
'ViewAliquotUse',
'AliquotReviewMaster'));
INSERT INTO structures(`alias`) VALUES ('number_of_elements_per_participant');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'first_name', 'input',  NULL , '0', 'size=20', '', 'help_first_name', 'first name', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'last_name', 'input',  NULL , '0', 'size=30', '', 'help_last_name', 'last name', ''), 
('ClinicalAnnotation', 'Generated', '', 'nbr_of_elements', 'integer_positive',  NULL , '0', '', '', '', 'number of elements', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='number_of_elements_per_participant'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='help_first_name' AND `language_label`='first name' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='number_of_elements_per_participant'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='help_last_name' AND `language_label`='last name' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='number_of_elements_per_participant'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='help_participant identifier' AND `language_label`='participant identifier' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='number_of_elements_per_participant'), (SELECT id FROM structure_fields WHERE `model`='Generated' AND `tablename`='' AND `field`='nbr_of_elements' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of elements' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO i18n (id,en,fr)
VALUES 
('number of elements per participant', 'Number of elements per participant', 'Nombre d''éléments par patient'), 
('number_of_elements_per_participant_description', "Count the number of elements displayed in the previous list (Batchset, Databrowser Node) grouped by participant",
"Compte le nombre d'éléments affichés dans la liste précédente (lot de données, Noeud du 'Navigateur de Données') par participant");
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('number of %s per participant', 'Number of %s per participant', 'Nombre de %s par participant'),
('number of elements', 'Number of Elements', 'Nombre d''éléments'),
('the selected report can only be launched from a batchset or a databrowser node', 'The selected report can only be launched from a Batchset or Databrowser Node', "Le rapport sélectionné ne peut être lancé qu'à partir d'un 'Lot de données' (ou d'un Noeud du 'Navigateur de Données')");

-- -----------------------------------------------------------------------------------------------------------------------------------
--	Alter table aliquot_masters field use_counter to set default value to 0 and update function newVersionSetup() (to be consistent with Issue: #3107)
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_masters SET `use_counter` = '0' WHERE `use_counter` IS NULL;
UPDATE aliquot_masters_revs SET `use_counter` = '0' WHERE `use_counter` IS NULL;
ALTER TABLE aliquot_masters MODIFY `use_counter` int(6) NOT NULL DEFAULT '0';
ALTER TABLE aliquot_masters_revs MODIFY `use_counter` int(6) NOT NULL DEFAULT '0';
  
-- -----------------------------------------------------------------------------------------------------------------------------------
--	Added message to remove Hook and Custom code versions files initially committed for test (to be consistent with Issue: #3079) 
-- -----------------------------------------------------------------------------------------------------------------------------------
 
SELECT "Please delete files /app/Plugin/Administrate/Controller/Custom/VersionsController.php and /app/Plugin/Administrate/Model/Custom/Version.php if they exist on the customized version (see issue #3079)." AS '### MESSAGE ###';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Versions table
-- -----------------------------------------------------------------------------------------------------------------------------------

update versions set permissions_regenerated = 0;
INSERT INTO `versions` (version_number, date_installed, trunk_build_number, branch_build_number) 
VALUES('2.6.4', NOW(),'6115','n/a');
