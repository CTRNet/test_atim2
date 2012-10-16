
UPDATE users SET flag_active = 1;
INSERT INTO i18n (id,en,fr) VALUES ('core_installname', 'Q-CROC','Q-CROC');

-- -------------------------------------------------------------------------------------------
-- CLINICAL ANNOTATION
-- -------------------------------------------------------------------------------------------

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'participants') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE field IN ('ids','created','participant_identifier','notes') AND model = 'Participant');

ALTER TABLE participants ADD COLUMN `qcroc_initials` varchar(10) DEFAULT NULL AFTER participant_identifier;
ALTER TABLE participants_revs ADD COLUMN `qcroc_initials` varchar(10) DEFAULT NULL AFTER participant_identifier;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qcroc_initials', 'input',  NULL , '0', 'size=6', '', '', 'initials', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qcroc_initials' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='initials' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qcroc_initials'), 'notEmpty', '', '');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('initials','Initials','Initiales');

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ConsentMasters%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/Participants/chronology/%';

UPDATE consent_controls SET flag_active = 0;
UPDATE event_controls SET flag_active = 0;
UPDATE diagnosis_controls SET flag_active = 0;
UPDATE misc_identifier_controls SET flag_active = 0;

UPDATE treatment_controls SET flag_active = 0;
INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`) VALUES
('biopsy', 'liver', 1, 'qcroc_txd_liver_biopsies', 'qcroc_txd_liver_biopsy', 'qcroc_txe_liver_biopsie_sedations', 'qcroc_txe_liver_biopsie_sedation', 0, NULL, NULL, 'biopsy|liver', 1);

ALTER TABLE treatment_masters ADD COLUMN qcroc_biopsy_type varchar(50) DEFAULT NULL;
ALTER TABLE treatment_masters_revs ADD COLUMN qcroc_biopsy_type varchar(50) DEFAULT NULL;

CREATE TABLE IF NOT EXISTS `qcroc_txd_liver_biopsies` (
   biopsy_performed char(1) DEFAULT '',
   reason_if_not_performed varchar(250) DEFAULT NULL,
   other_reason_if_not_performed varchar(250) DEFAULT NULL,

   instrument varchar(250) DEFAULT NULL,
   other_instrument_specify varchar(250) DEFAULT NULL,
   liver_segment varchar(50) DEFAULT NULL,
   lesion_size decimal(8,2) DEFAULT NULL,
   radiologist varchar(100) DEFAULT NULL,
   coordinator varchar(100) DEFAULT NULL,

  `treatment_master_id` int(11) NOT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `qcroc_txd_liver_biopsies_revs` (
   biopsy_performed char(1) DEFAULT '',
   reason_if_not_performed varchar(250) DEFAULT NULL,
   other_reason_if_not_performed varchar(250) DEFAULT NULL,

   instrument varchar(250) DEFAULT NULL,
   other_instrument_specify varchar(250) DEFAULT NULL,
   liver_segment varchar(50) DEFAULT NULL,
   lesion_size decimal(8,2) DEFAULT NULL,
   radiologist varchar(100) DEFAULT NULL,
   coordinator varchar(100) DEFAULT NULL,

  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qcroc_txd_liver_biopsies`
  ADD CONSTRAINT `qcroc_txd_liver_biopsies_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('qcroc_txd_liver_biopsy');

INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qcroc_reasons_if_no_biopsy_performed", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Biopsy : Reason if not performed\')"),
("qcroc_biopsy_instruments", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Biopsy : Instruments\')"),
("qcroc_liver_segments", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Biopsy : Liver segments\')"),
("qcroc_biopsy_radiologists", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Biopsy : Radiologists\')"),
("qcroc_biopsy_coordinators", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Biopsy : Coordinators\')"),
("qcroc_biopsy_types", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Biopsy : Types\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) 
VALUES 
('Biopsy : Reason if not performed', 1, 250),
('Biopsy : Instruments', 1, 250),
('Biopsy : Liver segments', 1, 50),
('Biopsy : Types', 1, 50),
('Biopsy : Radiologists', 1, 100),
('Biopsy : Coordinators', 1, 100);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Biopsy : Reason if not performed');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('technical issues', 'Procedure was not performed due to technical issues', '', '1', @control_id, NOW(), NOW(), 1, 1),
('pt refused', 'Pt refused', '', '1', @control_id, NOW(), NOW(), 1, 1),
('other', 'Other', '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Biopsy : Instruments');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('18-gauge side-notch Tru-cut needle', '18-gauge side-notch Tru-cut needle', '', '1', @control_id, NOW(), NOW(), 1, 1),
('18-gauge biopince', '18-gauge biopince', '', '1', @control_id, NOW(), NOW(), 1, 1),
('18-gauge biopince Francine-type', '18-gauge biopince Francine-type', '', '1', @control_id, NOW(), NOW(), 1, 1),
('other', 'Other', '', '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE structure_permissible_values_customs SET display_order = id WHERE control_id IN (SELECT id FROM structure_permissible_values_custom_controls WHERE name IN ('Biopsy : Instruments', 'Biopsy : Reason if not performed'));
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Biopsy : Liver segments');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, display_order) 
VALUES 
('I', '', '', '1', @control_id, '1'),
('II', '', '', '1', @control_id, '2'),
('III', '', '', '1', @control_id, '3'),
('IVa', '', '', '1', @control_id, '4'),
('IVb', '', '', '1', @control_id, '5'),
('V', '', '', '1', @control_id, '6'),
('VI', '', '', '1', @control_id, '7'),
('VII', '', '', '1', @control_id, '8'),
('VIII', '', '', '1', @control_id, '9');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Biopsy : Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, display_order) 
VALUES 
('pre', 'Pre', '', '1', @control_id, '1'),
('post', 'Post', '', '1', @control_id, '2');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qcroc_txd_liver_biopsies', 'biopsy_performed', 'yes_no',  NULL , '0', '', '', '', 'biopsy performed', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qcroc_txd_liver_biopsies', 'reason_if_not_performed', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_reasons_if_no_biopsy_performed') , '0', '', '', '', 'reason if biopsy not performed', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qcroc_txd_liver_biopsies', 'other_reason_if_not_performed', 'input',  NULL , '0', 'size=30', '', '', 'other reason if not performed', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qcroc_txd_liver_biopsies', 'instrument', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_instruments') , '0', '', '', '', 'instrument', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qcroc_txd_liver_biopsies', 'other_instrument_specify', 'input',  NULL , '0', 'size=30', '', '', '', 'other specify'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qcroc_txd_liver_biopsies', 'liver_segment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_liver_segments') , '0', '', '', '', 'liver segment', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qcroc_txd_liver_biopsies', 'lesion_size', 'float_positive',  NULL , '0', '', '', '', 'lesion size', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qcroc_txd_liver_biopsies', 'radiologist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_radiologists') , '0', '', '', '', 'radiologist', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qcroc_txd_liver_biopsies', 'coordinator', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_coordinators') , '0', '', '', '', 'coordinator', ''),
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'qcroc_biopsy_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_txd_liver_biopsy'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='biopsy_performed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy performed' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_txd_liver_biopsy'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='reason_if_not_performed' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_reasons_if_no_biopsy_performed')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reason if biopsy not performed' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_txd_liver_biopsy'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='other_reason_if_not_performed' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='other reason if not performed' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_txd_liver_biopsy'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='instrument' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_instruments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='instrument' AND `language_tag`=''), '2', '47', 'biopsy details', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_txd_liver_biopsy'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='other_instrument_specify' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='other specify'), '2', '48', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_txd_liver_biopsy'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='liver_segment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_liver_segments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='liver segment' AND `language_tag`=''), '2', '49', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_txd_liver_biopsy'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='lesion_size' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lesion size' AND `language_tag`=''), '2', '50', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_txd_liver_biopsy'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='radiologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_radiologists')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiologist' AND `language_tag`=''), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qcroc_txd_liver_biopsy'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qcroc_txd_liver_biopsies' AND `field`='coordinator' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_coordinators')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='coordinator' AND `language_tag`=''), '2', '52', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qcroc_txd_liver_biopsy'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qcroc_biopsy_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qcroc_biopsy_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `tablename`='treatment_masters' AND `field` IN ('qcroc_biopsy_type')), 'notEmpty', '', '');

CREATE TABLE IF NOT EXISTS `qcroc_txe_liver_biopsie_sedations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `drug_id` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `qcroc_txe_liver_biopsie_sedations_revs` (
  `id` int(11) NOT NULL,
   `drug_id` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `qcroc_txe_liver_biopsie_sedations`
  ADD CONSTRAINT `qcroc_txe_liver_biopsie_sedations_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`),
  ADD CONSTRAINT `FK_qcroc_txe_liver_biopsie_sedations_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);

INSERT INTO structures(`alias`) VALUES ('qcroc_txe_liver_biopsie_sedation');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtend', 'qcroc_txe_liver_biopsie_sedations', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='drug_list') , '0', '', '', 'help_drug_id', 'sedation', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qcroc_txe_liver_biopsie_sedation'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='qcroc_txe_liver_biopsie_sedations' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='sedation' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="steroid" AND language_alias="steroid");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="anti-emetic" AND language_alias="anti-emetic");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="chemotherapy" AND language_alias="chemotherapy");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="hormonal" AND language_alias="hormonal");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("sedation", "sedation");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="type"), (SELECT id FROM structure_permissible_values WHERE value="sedation" AND language_alias="sedation"), "", "1");
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='Drug' AND `field` IN ('type')), 'notEmpty', '', '');

INSERT IGNORE INTO i18n (id,en) VALUES 
('biopsy', 'Biopsy'),
('biopsy details', 'Biopsy details'),
('biopsy performed', 'Biopsy performed'),
('coordinator', 'Coordinator'),
('instrument', 'Instrument'),
('lesion size', 'Lesion size'),
('liver', 'Liver'),
('liver segment', 'Liver segment'),
('other reason if not performed', 'Other reason if not performed'),
('radiologist', 'Radiologist'),
('reason if biopsy not performed', 'Reason if biopsy not performed'),
('SOP', 'SOP'),
('sop#', 'SOP#'),
('sedations','Sedations'),
('sedation','Sedation'),
('sop deviations', 'Deviations'),
('sop followed', 'SOP followed');

-- SOP

UPDATE structure_formats SET flag_add= '0', flag_add_readonly= '0', flag_edit= '0', flag_edit_readonly= '0', flag_search= '0', flag_search_readonly= '0', flag_addgrid= '0', flag_addgrid_readonly= '0', flag_editgrid= '0', flag_editgrid_readonly= '0', flag_batchedit= '0', flag_batchedit_readonly= '0', flag_index= '0', flag_detail= '0', flag_summary= '0'
WHERE structure_id IN (SELECT id FROM structures WHERE alias = 'sopmasters') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('title','scope','purpose','expiry_date','status'));
INSERT INTO `sop_controls` (`sop_group`, `type`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `created`, `created_by`, `modified`, `modified_by`, `flag_active`) VALUES
('biopsy', '', 'sopd_general_alls', 'sopd_general_all', '', '', 0, NULL, 0, NULL, 0, 1);
UPDATE sop_controls SET flag_Active = 0 WHERE sop_group != 'biopsy';
INSERT INTO i18n (id,en) VALUES ('sop is assigned to a biopsy', 'SOP is assigned to a biopsy');
INSERT INTO `structure_validations` (`structure_field_id`, `rule`, `on_action`, `language_message`) VALUES 
((SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `field` IN ('version')), 'notEmpty', '', ''),
((SELECT id FROM structure_fields WHERE `model`='SopMaster' AND `field` IN ('activated_date')), 'notEmpty', '', '');



