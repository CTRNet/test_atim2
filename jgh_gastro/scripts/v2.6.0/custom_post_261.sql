-- --------------------------------------------------------------------------------------------------------
-- ADD ANNOTATION
-- --------------------------------------------------------------------------------------------------------

UPDATE event_controls SET flag_active = 0 WHERE event_group = 'lab' AND event_type LIKE 'cap report%' AND id NOT IN (select distinct event_control_id from event_masters where deleted <> 1);

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'colorectal', 'lab', 'immunohistochemistry', 1, 'qc_gastro_ed_immunohistochemistry', 'qc_gastro_ed_immunohistochemistry', 0, 'immunohistochemistry', 0);
CREATE TABLE IF NOT EXISTS `qc_gastro_ed_immunohistochemistry` (
	marker varchar(50) default null,
	result varchar(50) default null,
	precisions varchar(50) default null,
	path_num varchar(50) default null,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_gastro_ed_immunohistochemistry_revs` (
	marker varchar(50) default null,
	result varchar(50) default null,
	precisions varchar(50) default null,
	path_num varchar(50) default null,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_gastro_ed_immunohistochemistry`
  ADD CONSTRAINT `qc_gastro_ed_immunohistochemistry_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_gastro_ed_immunohistochemistry');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_gastro_immunohistochemistry_makers", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Immunohistochemistry Makers\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Immunohistochemistry Makers', 1, 50);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_gastro_immunohistochemistry_results", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Immunohistochemistry Results\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Immunohistochemistry Results', 1, 50);
SET @control_id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('negative', 'Negative', '', '1', @control_id, NOW(), NOW(), 1, 1),
('prositive', 'Prositive', '', '1', @control_id, NOW(), NOW(), 1, 1),
('non-contributory', 'Non-Contributory', '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_gastro_ed_immunohistochemistry', 'marker', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_immunohistochemistry_makers') , '0', '', '', '', 'marker', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_gastro_ed_immunohistochemistry', 'result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_immunohistochemistry_results') , '0', '', '', '', 'result', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_gastro_ed_immunohistochemistry', 'precisions', 'input',  NULL , '0', '', '', '', 'precisions', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_gastro_ed_immunohistochemistry', 'path_num', 'input',  NULL , '0', 'size=10', '', '', 'pathology number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_ed_immunohistochemistry'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_immunohistochemistry' AND `field`='marker' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_immunohistochemistry_makers')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='marker' AND `language_tag`=''), '2', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_ed_immunohistochemistry'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_immunohistochemistry' AND `field`='result' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_immunohistochemistry_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '2', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_ed_immunohistochemistry'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_immunohistochemistry' AND `field`='precisions' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precisions' AND `language_tag`=''), '2', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_ed_immunohistochemistry'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_immunohistochemistry' AND `field`='path_num' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='pathology number' AND `language_tag`=''), '2', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'colorectal', 'lab', 'molecular testing', 1, 'qc_gastro_ed_molecular_testing', 'qc_gastro_ed_molecular_testing', 0, 'molecular testing', 0);
CREATE TABLE IF NOT EXISTS `qc_gastro_ed_molecular_testing` (
	test varchar(50) default null,
	result varchar(50) default null,
	precisions varchar(50) default null,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_gastro_ed_molecular_testing_revs` (
	test varchar(50) default null,
	result varchar(50) default null,
	precisions varchar(50) default null,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_gastro_ed_molecular_testing`
  ADD CONSTRAINT `qc_gastro_ed_molecular_testing_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_gastro_ed_molecular_testing');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_gastro_molecular_tests", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Molecular Tests\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Molecular Tests', 1, 50);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_gastro_molecular_test_results", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Molecular Test Results\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Molecular Test Results', 1, 50);
SET @control_id = LAST_INSERT_ID();
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('negative', 'Negative', '', '1', @control_id, NOW(), NOW(), 1, 1),
('prositive', 'Prositive', '', '1', @control_id, NOW(), NOW(), 1, 1),
('indeterminate', 'Indeterminate', '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_gastro_ed_molecular_testing', 'test', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_molecular_tests') , '0', '', '', '', 'test', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_gastro_ed_molecular_testing', 'result', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_molecular_test_results') , '0', '', '', '', 'result', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_gastro_ed_molecular_testing', 'precisions', 'input',  NULL , '0', '', '', '', 'precisions', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_ed_molecular_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_molecular_testing' AND `field`='test' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_molecular_tests')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='test' AND `language_tag`=''), '2', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_ed_molecular_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_molecular_testing' AND `field`='result' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_molecular_test_results')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '2', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_ed_molecular_testing'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_molecular_testing' AND `field`='precisions' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precisions' AND `language_tag`=''), '2', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`) VALUES
(null, 'colorectal', 'lab', 'biochemical test', 1, 'qc_gastro_ed_biochemical_test', 'qc_gastro_ed_biochemical_test', 0, 'biochemical test', 0);
CREATE TABLE IF NOT EXISTS `qc_gastro_ed_biochemical_test` (
	test varchar(50) default null,
	result varchar(50) default null,
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_gastro_ed_biochemical_test_revs` (
	test varchar(50) default null,
	result varchar(50) default null,
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_gastro_ed_biochemical_test`
  ADD CONSTRAINT `qc_gastro_ed_biochemical_test_ibfk_12` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('qc_gastro_ed_biochemical_test');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_gastro_biochemical_tests", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Biochemical Tests\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Biochemical Tests', 1, 50);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_gastro_ed_biochemical_test', 'test', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_biochemical_tests') , '0', '', '', '', 'test', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_gastro_ed_biochemical_test', 'result', 'input',  NULL , '0', '', '', '', 'result', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_ed_biochemical_test'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_biochemical_test' AND `field`='test' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_biochemical_tests')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='test' AND `language_tag`=''), '2', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_ed_biochemical_test'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_biochemical_test' AND `field`='result' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '2', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('marker','Marker','Marqueur'),
('precisions','Precisions','Précisions');

UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation' WHERE name = 'Molecular Test Results';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation' WHERE name = 'Immunohistochemistry Results';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation' WHERE name = 'Immunohistochemistry Makers';

UPDATE event_controls SET use_addgrid = 1, use_detail_form_for_index = 1 WHERE flag_active = 1 AND event_group = 'lab';
UPDATE event_controls SET databrowser_label = CONCAT(event_group,'|',event_type), disease_site = '' WHERE flag_active = '1';
UPDATE event_controls SET databrowser_label = event_type, disease_site = '' WHERE flag_active = '1' AND event_type = 'lifestyle';

UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_ed_immunohistochemistry') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_immunohistochemistry' AND `field`='marker' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_immunohistochemistry_makers') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_ed_immunohistochemistry') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_immunohistochemistry' AND `field`='result' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_gastro_immunohistochemistry_results') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_ed_immunohistochemistry') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_immunohistochemistry' AND `field`='precisions' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_ed_immunohistochemistry') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_gastro_ed_immunohistochemistry' AND `field`='path_num' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('molecular testing','molecular testing','Test moléculaire'),
('biochemical test','Biochemical Test','Test biochimique');


UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_ed_biochemical_test') ;

INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('test','Test','Test');

UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation' WHERE name = 'Molecular Tests';
UPDATE structure_permissible_values_custom_controls SET category = 'clinical - annotation' WHERE name = 'Biochemical Tests';

UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_gastro_ed_molecular_testing') ;

-- --------------------------------------------------------------------------------------------------------
-- CONSENTEMENT
-- --------------------------------------------------------------------------------------------------------

ALTER TABLE qc_gastro_cd_consents CHANGE qc_gastro_bio_material qc_gastro_left_over_bio_material char(1) NOT NULL DEFAULT '';
ALTER TABLE qc_gastro_cd_consents_revs CHANGE qc_gastro_bio_material qc_gastro_left_over_bio_material char(1) NOT NULL DEFAULT '';
UPDATE structure_fields SET field = 'qc_gastro_left_over_bio_material', language_label = 'left over biological material storage and use' WHERE field = 'qc_gastro_bio_material' AND tablename = 'qc_gastro_cd_consents';
INSERT INTO i18n (id,en,fr)
VALUES ('left over biological material storage and use','Left over biological material storage and use','Entreposage et utilisation de matériel biologique restant');

ALTER TABLE qc_gastro_cd_consents 
ADD COLUMN qc_gastro_access_to_archived_tissue char(1) NOT NULL DEFAULT '',
ADD COLUMN qc_gastro_biopsy_extra_piece_collection char(1) NOT NULL DEFAULT '';
ALTER TABLE qc_gastro_cd_consents_revs 
ADD COLUMN qc_gastro_access_to_archived_tissue char(1) NOT NULL DEFAULT '',
ADD COLUMN qc_gastro_biopsy_extra_piece_collection char(1) NOT NULL DEFAULT '';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'qc_gastro_cd_consents', 'qc_gastro_access_to_archived_tissue', 'yes_no',  NULL , '0', '', '', '', 'access to archived tissue', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'qc_gastro_cd_consents', 'qc_gastro_biopsy_extra_piece_collection', 'yes_no',  NULL , '0', '', '', '', 'biopsy extra piece collection', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_gastro_cd_consents' AND `field`='qc_gastro_access_to_archived_tissue' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='access to archived tissue' AND `language_tag`=''), '2', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_gastro_cd_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_gastro_cd_consents' AND `field`='qc_gastro_biopsy_extra_piece_collection' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy extra piece collection' AND `language_tag`=''), '2', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO i18n (id,en) VALUES ('access to archived tissue','Access to archived tissue'),('biopsy extra piece collection','Biopsy extra piece collection');
























PARTICIPANT IDENTIFIER REPORT
----------------------------------------------------------------------------------------------------------
Queries to desactivate 'Participant Identifiers' demo report
----------------------------------------------------------------------------------------------------------
UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');

TODO
----------------------------------------------------------------------------------------------------------
Added new relationsips into databrowser
Please flag inactive relationsips if required (see queries below). Don't forget Collection to Annotation, Treatment,Consent, etc if not requried.
SELECT str1.model AS model_1, str2.model AS model_2, use_field FROM datamart_browsing_controls ctrl, datamart_structures str1, datamart_structures str2 WHERE str1.id = ctrl.id1 AND str2.id = ctrl.id2 AND (ctrl.flag_active_1_to_2 = 1 OR ctrl.flag_active_2_to_1 = 1);
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = 0 WHERE fct.datamart_structure_id = str.id AND/OR str.model IN ('Model1', 'Model2', 'Model...');
Please flag inactive datamart structure functions if required (see queries below).
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...'));
Please change datamart_structures_relationships_en(and fr).png in appwebrootimgdataBrowser
----------------------------------------------------------------------------------------------------------

