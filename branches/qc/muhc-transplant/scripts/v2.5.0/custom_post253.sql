
UPDATE users SET flag_active = 1 WHERE id = 1;
INSERT INTO i18n (id,en,fr) VALUES ('core_installname', 'MUHC - HPB & Transplant','MUHC - HPB & Transplant');

-- --------------------------------------------------------------------------------------------------------------------------
-- Banks
-- --------------------------------------------------------------------------------------------------------------------------

ALTER TABLE banks ADD COLUMN muhc_irb_nbr varchar(100) DEFAULT '';
ALTER TABLE banks_revs ADD COLUMN muhc_irb_nbr varchar(100) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'Bank', 'banks', 'muhc_irb_nbr', 'input',  NULL , '0', 'size=40', '', '', 'participant muhc irb nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='banks'), (SELECT id FROM structure_fields WHERE `model`='Bank' AND `tablename`='banks' AND `field`='muhc_irb_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='participant muhc irb nbr' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='banks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Bank' AND `tablename`='banks' AND `field`='description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `model`='Bank' AND `field`='muhc_irb_nbr'), 'notEmpty');
INSERT INTO structure_validations(structure_field_id, rule, `language_message`) VALUES ((SELECT id FROM structure_fields WHERE `model`='Bank' AND `field`='muhc_irb_nbr'), 'custom,/^[0-9]{2}\-[a-zA-Z]{3}\-[0-9]{3}?/', 'muhc_structure_validation_error_irb_format');
UPDATE menus SET language_title = 'muhc banks/projects' WHERE  use_link like '/Administrate/Banks/index';
INSERT IGNORE INTO i18n (id,en) VALUES ('participant muhc irb nbr','Participant IRB/REB#'),('muhc banks/projects','Banks/Projects'),('muhc_structure_validation_error_irb_format','IRB/REB# format expected : 00-AAA-000');
UPDATE structure_fields SET  `language_label`='muhc banks/projects' WHERE model='Bank' AND tablename='banks' AND field='name' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE banks SET name = 'HPB & Transplant', muhc_irb_nbr = '00-AAA-000', description = ''WHERE id = '1';
UPDATE banks_revs SET name = 'HPB & Transplant', muhc_irb_nbr = '00-AAA-000', description = ''WHERE id = '1';
UPDATE groups SET bank_id = 1;
INSERT INTO `banks` (`name`, `muhc_irb_nbr`) VALUES ('Liver Diseases BioBank', '11-SDR-066');
INSERT INTO `banks_revs` (`name`, `muhc_irb_nbr`, `id`) (SELECT `name`, `muhc_irb_nbr`, `id` FROM banks WHERE name = 'Liver Diseases BioBank');
INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `model`='Group' AND `field`='bank_id'), 'notEmpty');

-- --------------------------------------------------------------------------------------------------------------------------
-- Profile
-- --------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field` NOT IN ('notes','last_modification','ids','created','last_chart_checked_date','date_of_birth','participant_identifier','sex'));
UPDATE structure_formats SET `display_column`='3', `display_order`='98', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
REPLACE INTO i18n (id,en) VALUEs ('participant identifier','Participant System Code');
UPDATE structure_fields SET  `language_label`='estimated date of birth' WHERE model='Participant' AND tablename='participants' AND field='date_of_birth' AND `type`='date' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en) VALUEs ('estimated date of birth','Estimated Date of Birth');
ALTER TABLE participants
  ADD COLUMN `muhc_precautions_none` char(1) DEFAULT '',
  ADD COLUMN `muhc_precautions_hepb` char(1) DEFAULT '',
  ADD COLUMN `muhc_precautions_hepc` char(1) DEFAULT '',
  ADD COLUMN `muhc_precautions_unknown` char(1) DEFAULT '',
  ADD COLUMN `muhc_precautions_other` char(1) DEFAULT '',
  ADD COLUMN `muhc_precautions_other_specify` text;
ALTER TABLE participants_revs
  ADD COLUMN `muhc_precautions_none` char(1) DEFAULT '',
  ADD COLUMN `muhc_precautions_hepb` char(1) DEFAULT '',
  ADD COLUMN `muhc_precautions_hepc` char(1) DEFAULT '',
  ADD COLUMN `muhc_precautions_unknown` char(1) DEFAULT '',
  ADD COLUMN `muhc_precautions_other` char(1) DEFAULT '',
  ADD COLUMN `muhc_precautions_other_specify` text; 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'muhc_precautions_none', 'yes_no',  NULL , '0', '', '', '', 'muhc precautions none', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'muhc_precautions_hepb', 'yes_no',  NULL , '0', '', '', '', 'muhc precautions hepb', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'muhc_precautions_hepc', 'yes_no',  NULL , '0', '', '', '', 'muhc precautions hepc', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'muhc_precautions_unknown', 'yes_no',  NULL , '0', '', '', '', 'muhc precautions unknown', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'muhc_precautions_other', 'yes_no',  NULL , '0', '', '', '', 'muhc precautions other', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'muhc_precautions_other_specify', 'textarea',  NULL , '0', 'rows=3,cols=30', '', '', 'specify', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='muhc_precautions_none' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='muhc precautions none' AND `language_tag`=''), '3', '52', 'precautions', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='muhc_precautions_hepb' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='muhc precautions hepb' AND `language_tag`=''), '3', '53', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='muhc_precautions_hepc' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='muhc precautions hepc' AND `language_tag`=''), '3', '54', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='muhc_precautions_unknown' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='muhc precautions unknown' AND `language_tag`=''), '3', '55', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='muhc_precautions_other' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='muhc precautions other' AND `language_tag`=''), '3', '56', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='muhc_precautions_other_specify' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='specify' AND `language_tag`=''), '3', '57', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES 
('precautions','Precautions'),
('muhc precautions none','None'),
('muhc precautions hepb','HepB'),
('muhc precautions hepc','HepC'),
('muhc precautions unknown','Unknown'),
('muhc precautions other','Other'),
('muhc irb reb nbr','IRB/REB#');

ALTER TABLE participants ADD COLUMN `muhc_consent` char(1) DEFAULT '';
ALTER TABLE participants_revs  ADD COLUMN `muhc_consent` char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'muhc_consent', 'yes_no',  NULL , '0', '', '', '', 'consent', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='muhc_consent' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='consent' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1', `flag_addgrid`='0', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE menus SET flag_active = 0 WHERE 
use_link LIKE '/ClinicalAnnotation/ConsentMasters%' 
OR use_link LIKE '/ClinicalAnnotation/FamilyHistories%' 
OR use_link LIKE '/ClinicalAnnotation/ReproductiveHistories%' 
OR use_link LIKE '/ClinicalAnnotation/ParticipantContacts%' ;

ALTER TABLE participants ADD COLUMN `muhc_participant_bank_id` int(11) DEFAULT NULL;
ALTER TABLE participants_revs ADD COLUMN `muhc_participant_bank_id` int(11) DEFAULT NULL;
ALTER TABLE `participants`
  ADD CONSTRAINT `muhc_participants_banks` FOREIGN KEY (`muhc_participant_bank_id`) REFERENCES `banks` (`id`);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'muhc_participant_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'bank/project irb', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='muhc_participant_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank/project irb' AND `language_tag`=''), '1', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en) VALUES ('bank/project irb', 'IRB/REB#'),('at least one participant is linked to that bank','At least one participant is linked to that bank');
INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='muhc_participant_bank_id'), 'notEmpty');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en) VALUES ('when other precaution exists, both other check box and specify text box should be completed',"When other precaution exists, both 'Other' check box and 'Specify' text box should be completed.");

-- --------------------------------------------------------------------------------------------------------------------------
-- Identifier
-- --------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO misc_identifier_controls (id ,misc_identifier_name ,flag_active ,display_order ,autoincrement_name ,misc_identifier_format ,flag_once_per_participant ,flag_confidential ,flag_unique ,pad_to_length ,reg_exp_validation ,user_readable_format)
VALUES 
(NULL , 'participant coded identifier', '1', '0', '', NULL , '0', '0', '0', '0', '', ''),
(NULL , 'quebec transplant qtx#', '1', '0', '', NULL , '0', '0', '0', '0', '', '');
INSERT INTO i18n (id,en) VALUES ('participant coded identifier','Participant Coded Identifier'),('quebec transplant qtx#','Quebec Transplant QTX#');

INSERT INTO structures(`alias`) VALUES ('muhc_coded_identifiers_summary');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', '0', '', 'coded_identifiers', 'textarea',  NULL , '0', '', '', '', 'coded identifiers', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_coded_identifiers_summary'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='coded_identifiers'), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO i18n (id,en) VALUES ('coded identifiers','Coded Identifiers');

-- --------------------------------------------------------------------------------------------------------------------------
-- Biopsy/Transplant/...
-- --------------------------------------------------------------------------------------------------------------------------

INSERT INTO `treatment_controls` (`tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`) VALUES
('transplant', 'muhc', 1, 'muhc_txd_transplants', 'muhc_txd_transplants', NULL, NULL, 0, NULL, NULL, 'transplant', 1),
('transplant explant', 'muhc', 1, 'muhc_txd_transplants', 'muhc_txd_transplants', NULL, NULL, 0, NULL, NULL, 'transplant explant', 1),
('transplant biopsy sampling', 'muhc', 1, 'muhc_txd_transplants', 'muhc_txd_transplant_biopsies', NULL, NULL, 0, NULL, NULL, 'transplant biopsy sampling', 1),
('biopsy', 'muhc', 1, 'muhc_txd_biopsies', 'muhc_txd_biopsies', NULL, NULL, 0, NULL, NULL, 'biopsy', 1),
('perfused liver', 'muhc', 1, 'muhc_txd_perfused_livers', 'muhc_txd_perfused_livers', NULL, NULL, 0, NULL, NULL, 'perfused liver', 1),
('resection', 'muhc', 1, 'muhc_resections', 'muhc_resections', NULL, NULL, 0, NULL, NULL, 'resection', 1);

CREATE TABLE IF NOT EXISTS `muhc_txd_transplants` (
  `clamp_time` TIME DEFAULT NULL,
  `biopsy_type` VARCHAR(50) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `muhc_txd_transplants_revs` (
  `clamp_time` TIME DEFAULT NULL,
  `biopsy_type` VARCHAR(50) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;
ALTER TABLE `muhc_txd_transplants`
  ADD CONSTRAINT `muhc_txd_transplants_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT structure_value_domains (domain_name,source) VALUES ('muhc_transplant_biopsies', "StructurePermissibleValuesCustom::getCustomDropdown('transplant biopsy type')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('transplant biopsy type', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'transplant biopsy type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('tru cut', 'Tru Cut', '', '1', @control_id),
('tru cut of each segment', 'Tru Cut of each segment', '', '1', @control_id),
('wedge biopsy', 'Wedge Biopsy', '', '1', @control_id),
('cubes', 'Cubes', '', '1', @control_id); 
INSERT INTO structures(`alias`) VALUES ('muhc_txd_transplant_biopsies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'muhc_txd_transplants', 'clamp_time', 'time',  NULL , '0', '', '', '', 'clamp time', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'muhc_txd_transplants', 'biopsy_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_transplant_biopsies') , '0', '', '', '', 'biopsy type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_txd_transplant_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='muhc_txd_transplants' AND `field`='clamp_time' AND `type`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clamp time' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_txd_transplant_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='muhc_txd_transplants' AND `field`='biopsy_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_transplant_biopsies')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy type' AND `language_tag`=''), '1', '13', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES
('clamp time','Clamp Time'),
('biopsy type','Biopsy Type'),
('transplant', 'Transplant'),
('transplant explant', 'Transplant Explant'),
('transplant biopsy sampling', 'Transplant Biopsy Sampling');
INSERT INTO structures(`alias`) VALUES ('muhc_txd_transplants');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_txd_transplants'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='muhc_txd_transplants' AND `field`='clamp_time' AND `type`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clamp time' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

CREATE TABLE IF NOT EXISTS `muhc_txd_biopsies` (
  `biopsy_type` VARCHAR(50) DEFAULT NULL,
  `biopsy_type_precision` VARCHAR(50) DEFAULT NULL,
  `gauge_nbr` VARCHAR(30) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `muhc_txd_biopsies_revs` (
  `biopsy_type` VARCHAR(50) DEFAULT NULL,
  `biopsy_type_precision` VARCHAR(50) DEFAULT NULL,
  `gauge_nbr` VARCHAR(30) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;
ALTER TABLE `muhc_txd_biopsies`
  ADD CONSTRAINT `muhc_txd_biopsies_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT structure_value_domains (domain_name,source) VALUES 
('muhc_biopsy_type', "StructurePermissibleValuesCustom::getCustomDropdown('biopsy type')"),
('muhc_biopsy_type_precision', "StructurePermissibleValuesCustom::getCustomDropdown('biopsy type precision')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('biopsy type', '1', '50'),('biopsy type precision', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'biopsy type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('percutaneous', 'Percutaneous', '', '1', @control_id),
('transjugular', 'Transjugular', '', '1', @control_id),
('intraoperative', 'Intraoperative', '', '1', @control_id); 
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'biopsy type precision');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('na', 'NA', '', '1', @control_id),
('ultrasound guided', 'Ultrasound guided', '', '1', @control_id),
('ct guided', 'CT guided', '', '1', @control_id),
('open', 'Open', '', '1', @control_id),
('laparoscopic', 'Laparoscopic', '', '1', @control_id); 
INSERT INTO structures(`alias`) VALUES ('muhc_txd_biopsies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'muhc_txd_biopsies', 'biopsy_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_biopsy_type') , '0', '', '', '', 'biopsy type', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'muhc_txd_biopsies', 'biopsy_type_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_biopsy_type_precision') , '0', '', '', '', '', 'biopsy type precision'), 
('ClinicalAnnotation', 'TreatmentDetail', 'muhc_txd_biopsies', 'gauge_nbr', 'input',  NULL , '0', 'size=10', '', '', 'gauge nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='muhc_txd_biopsies' AND `field`='biopsy_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_biopsy_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy type' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='muhc_txd_biopsies' AND `field`='biopsy_type_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_biopsy_type_precision')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='biopsy type precision'), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='muhc_txd_biopsies' AND `field`='gauge_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='gauge nbr' AND `language_tag`=''), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES
('biopsy type precision','-'),
('gauge nbr','Gauge#'),
('biopsy','Biopsy');

CREATE TABLE IF NOT EXISTS `muhc_txd_perfused_livers` (
   duration_of_perfusion_mn int(6) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `muhc_txd_perfused_livers_revs` (
   duration_of_perfusion_mn int(6) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;
ALTER TABLE `muhc_txd_perfused_livers`
  ADD CONSTRAINT `muhc_txd_perfused_livers_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('muhc_txd_perfused_livers');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'muhc_txd_perfused_livers', 'duration_of_perfusion_mn', 'input',  NULL , '0', 'size=6', '', '', 'duration of perfusion mn', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_txd_perfused_livers'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='muhc_txd_perfused_livers' AND `field`='duration_of_perfusion_mn' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='duration of perfusion mn' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('duration of perfusion mn','Duration of perfusion (mn)'),('perfused liver','Perfused Liver');
ALTER TABLE muhc_txd_perfused_livers ADD COLUMN person_perfusing VARCHAR(50) DEFAULT NULL;
ALTER TABLE muhc_txd_perfused_livers_revs ADD COLUMN person_perfusing VARCHAR(50) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'muhc_txd_perfused_livers', 'person_perfusing', 'input',  NULL , '0', 'size=30', '', '', 'person perfusing', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_txd_perfused_livers'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='muhc_txd_perfused_livers' AND `field`='person_perfusing' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='person perfusing' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('person perfusing','Person Perfusing');

CREATE TABLE IF NOT EXISTS `muhc_resections` (
   ischemia char(1) DEFAULT '',
  `treatment_master_id` int(11) NOT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `muhc_resections_revs` (
   ischemia char(1) DEFAULT '',
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;
ALTER TABLE `muhc_resections`
  ADD CONSTRAINT `muhc_resections_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('muhc_resections');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'muhc_resections', 'ischemia', 'yes_no',  NULL , '0', '', '', '', 'ischemia', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_resections'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='muhc_resections' AND `field`='ischemia' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ischemia' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('ischemia','Ischemia'),('resection','Resection'),('muhc','MUHC');

-- --------------------------------------------------------------------------------------------------------------------------
-- Clinical Collection Link
-- --------------------------------------------------------------------------------------------------------------------------

ALTER TABLE collections ADD COLUMN misc_identifier_id int(11) DEFAULT NULL;
ALTER TABLE collections_revs ADD COLUMN misc_identifier_id int(11) DEFAULT NULL;
ALTER TABLE `collections` ADD CONSTRAINT `collections_ibfk_misc_identifiers` FOREIGN KEY (`misc_identifier_id`) REFERENCES `misc_identifiers` (`id`);

UPDATE structure_formats 
SET flag_add = 0,flag_add_readonly = 0,flag_edit = 0,flag_edit_readonly = 0,flag_search = 0,flag_search_readonly = 0,flag_addgrid = 0,
flag_addgrid_readonly = 0,flag_editgrid = 0,flag_editgrid_readonly = 0,flag_summary = 0,flag_batchedit = 0,flag_batchedit_readonly = 0,
flag_index = 0,flag_detail = 0,flag_float = 0 WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'acquisition_label');

REPLACE INTO i18n (id,en) VALUES 
('collection bank', 'Collection IRB/REB#'),
('inv_collection_bank_defintion','IRB/REB# assigned to the products the day of collection. Should be the IRB/REB# of the bank/project that collected samples.');

INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `model`='Collection' AND `field`='bank_id'), 'notEmpty');

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
(null, '', 'InventoryManagement', 'ViewCollection', '', 'muhc_participant_coded_identifier', 'participant coded identifier', '', 'input', 'size=30', '', NULL, '', 'open', 'open', 'open', 0),
(null, '', 'InventoryManagement', 'ViewCollection', '', 'muhc_participant_bank_id', 'muhc participant irb reb nbr', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='banks'), '', 'open', 'open', 'open', 0);
SET @old_structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewCollection' AND field = 'participant_identifier');
SET @new_structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewCollection' AND field = 'muhc_participant_bank_id');
INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT `structure_id`, @new_structure_field_id, `display_column`, (`display_order`-1), `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @old_structure_field_id);
SET @new_structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewCollection' AND field = 'muhc_participant_coded_identifier');
INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT `structure_id`, @new_structure_field_id, `display_column`, (`display_order`+1), `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @old_structure_field_id);

UPDATE structure_fields SET language_help = 'muhc_participant_bank_id_help' WHERE model = 'ViewCollection' AND field = 'muhc_participant_bank_id';

INSERT INTO i18n (id,en) VALUES 
('muhc participant irb reb nbr', 'Participant IRB/REB#'), 
('muhc_participant_bank_id_help','IRB/REB# of the bank/project currently owner of the participant. This number can be different than the collection IRB/REB#.'),
('error_fk_frsq_number_linked_collection','The Participant Coded Identifier is linked to a collection. This one can not be deleted.');

UPDATE structure_formats SET `display_column`='1', `display_order`='14', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='15', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
(null, '', 'InventoryManagement', 'ViewSample', '', 'muhc_participant_coded_identifier', 'participant coded identifier', '', 'input', 'size=30', '', NULL, '', 'open', 'open', 'open', 0),
(null, '', 'InventoryManagement', 'ViewSample', '', 'muhc_participant_bank_id', 'muhc participant irb reb nbr', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='banks'), '', 'open', 'open', 'open', 0);
SET @old_structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewSample' AND field = 'participant_identifier');
SET @new_structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewSample' AND field = 'muhc_participant_bank_id');
INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT `structure_id`, @new_structure_field_id, `display_column`, (`display_order`-1), `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @old_structure_field_id);
SET @new_structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewSample' AND field = 'muhc_participant_coded_identifier');
INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT `structure_id`, @new_structure_field_id, `display_column`, (`display_order`+1), `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @old_structure_field_id);

UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='9999', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
(null, '', 'InventoryManagement', 'ViewAliquot', '', 'muhc_participant_coded_identifier', 'participant coded identifier', '', 'input', 'size=30', '', NULL, '', 'open', 'open', 'open', 0),
(null, '', 'InventoryManagement', 'ViewAliquot', '', 'muhc_participant_bank_id', 'muhc participant irb reb nbr', '', 'select', '', '', (SELECT id FROM structure_value_domains WHERE domain_name='banks'), '', 'open', 'open', 'open', 0);
SET @old_structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewAliquot' AND field = 'participant_identifier');
SET @new_structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewAliquot' AND field = 'muhc_participant_bank_id');
INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT `structure_id`, @new_structure_field_id, `display_column`, (`display_order`-1), `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @old_structure_field_id);
SET @new_structure_field_id = (SELECT id FROM structure_fields WHERE model = 'ViewAliquot' AND field = 'muhc_participant_coded_identifier');
INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`)
(SELECT `structure_id`, @new_structure_field_id, `display_column`, (`display_order`+1), `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float` FROM structure_formats WHERE structure_field_id = @old_structure_field_id);

UPDATE structure_formats SET `display_column`='1', `display_order`='1200', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='clinicalcollectionlinks'), (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '10', '', '1', 'participant coded identifier', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ------------------------------------------------------------------------------------------------------------------
-- Collections
-- ------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET
flag_add = '0',
flag_add_readonly = '0',
flag_edit = '0',
flag_edit_readonly = '0',
flag_search = '0',
flag_search_readonly = '0',
flag_addgrid = '0',
flag_addgrid_readonly = '0',
flag_editgrid = '0',
flag_editgrid_readonly = '0',
flag_summary = '0',
flag_batchedit = '0',
flag_batchedit_readonly = '0',
flag_index = '0',
flag_detail = '0',
flag_float = '0' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field = 'sop_master_id' AND (model LIKE '%Aliquot%' OR model LIKE '%Collection%' OR model LIKE '%Sample%' ));

ALTER TABLE collections 
  ADD COLUMN muhc_age_at_collection INT(6) DEFAULT NULL,
  ADD COLUMN muhc_collection_room VARCHAR(60) DEFAULT NULL;
ALTER TABLE collections_revs 
  ADD COLUMN muhc_age_at_collection INT(6) DEFAULT NULL,
  ADD COLUMN muhc_collection_room VARCHAR(60) DEFAULT NULL;	

ALTER TABLE collections
  MODIFY `collection_site` varchar(60) DEFAULT NULL;
ALTER TABLE collections_revs
  MODIFY `collection_site` varchar(60) DEFAULT NULL;
  
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('procedure location')" WHERE source = "StructurePermissibleValuesCustom::getCustomDropdown('specimen collection sites')";
UPDATE structure_permissible_values_custom_controls SET values_max_length = '60', name = 'procedure location' WHERE name = 'specimen collection sites';

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'procedure location');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('royal victoria hospital', 'Royal Victoria Hospital', '', '1', @control_id);

REPLACE INTO i18n (id,en) VALUES ('collection site','Procedure Location');

INSERT structure_value_domains (domain_name,source) VALUES ('muhc_collection_room', "StructurePermissibleValuesCustom::getCustomDropdown('procedure location (room)')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('procedure location (room)', '1', '60');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'procedure location (room)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('radiology', 'Radiology', '', '1', @control_id),
('operating room', 'Operating room', '', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'muhc_collection_room', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_collection_room') , '0', '', '', '', 'collection room', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='muhc_collection_room' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_collection_room')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection room' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'),
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='muhc_collection_room' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_collection_room')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection room' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

INSERT INTO i18n (id,en) VALUES ('collection room','Procedure Location (room)');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'muhc_collection_room', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_collection_room') , '0', '', '', '', 'collection room', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='muhc_collection_room' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_collection_room')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collection room' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='muhc_collection_room' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_collection_room') AND `flag_confidential`='0');

UPDATE structure_fields SET `language_label` = '', `language_tag` = 'collection room/dept' WHERE `language_label` = 'collection room'  AND field = 'muhc_collection_room';
UPDATE structure_fields SET `language_tag` = 'site' WHERE `language_label` = 'collection site'  AND field = 'collection_site';

INSERT INTO i18n (id,en) VALUES ('collection room/dept','Room/Dept.'),('site','Site');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'muhc_age_at_collection', 'integer_positive',  NULL , '0', 'size=3', '', '', 'age at collection', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='muhc_age_at_collection' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='age at collection' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', 'collections', 'muhc_age_at_collection', 'integer_positive',  NULL , '0', 'size=3', '', '', 'age at collection', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='collections' AND `field`='muhc_age_at_collection' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='age at collection' AND `language_tag`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_fields SET model = 'Collection' WHERE tablename = 'collections' AND field = 'muhc_age_at_collection';

INSERT INTO i18n (id,en) VALUES ('age at collection','Age at Collection');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='muhc_age_at_collection' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='age at collection' AND `language_tag`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

REPLACE INTO i18n (id,en) VALUES ('inv_collection_datetime_defintion','Date of the specimen collection (surgery date, biopsy date, excision date, blood draw date, etc).');

UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='muhc_age_at_collection' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ------------------------------------------------------------------------------------------------------------------
-- sample masters
-- ------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ------------------------------------------------------------------------------------------------------------------
-- Specimens
-- ------------------------------------------------------------------------------------------------------------------

ALTER TABLE specimen_details ADD COLUMN  muhc_person_collecting_specimen varchar(50) DEFAULT NULL;
ALTER TABLE specimen_details_revs ADD COLUMN  muhc_person_collecting_specimen varchar(50) DEFAULT NULL;

INSERT structure_value_domains (domain_name,source) VALUES ('muhc_person_collecting_specimen', "StructurePermissibleValuesCustom::getCustomDropdown('person collecting specimen')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('person collecting specimen', '1', '50');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SpecimenDetail', 'specimen_details', 'muhc_person_collecting_specimen', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_person_collecting_specimen') , '0', '', '', '', 'collecting by', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='muhc_person_collecting_specimen' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_person_collecting_specimen')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='collecting by' AND `language_tag`=''), '1', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_at_room_temp_mn' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en) VALUES ('collecting by','Person collecting specimen');
REPLACE INTO i18n (id,en) VALUES ('reception by','Harvesting by'),('reception date','Date/Time arrive at lab');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'laboratory staff');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('stephanie petrillo', 'Stephanie Petrillo', 'Stephanie Petrillo', '1', @control_id); 

UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name IN ('specimen supplier departments ','sop versions ','consent form versions');

UPDATE structure_formats SET `display_column`='0', `display_order`='502' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='501' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='500' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='muhc_person_collecting_specimen' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_person_collecting_specimen') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='503' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 142, 143, 141, 144, 140);

-- ------------------------------------------------------------------------------------------------------------------
-- Tissues
-- ------------------------------------------------------------------------------------------------------------------

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('tissue source')" WHERE domain_name = 'tissue_source_list';
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('tissue source', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'tissue source');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('liver', 'Liver', '', '1', @control_id);

ALTER TABLE sd_spe_tissues
  ADD COLUMN muhc_tissue_type VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_pathologist_reviewing VARCHAR(50) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs
  ADD COLUMN muhc_tissue_type VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_pathologist_reviewing VARCHAR(50) DEFAULT NULL;

INSERT structure_value_domains (domain_name,source) VALUES ('muhc_tissue_type', "StructurePermissibleValuesCustom::getCustomDropdown('tissue type')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('tissue type', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'tissue type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('normal', 'Normal', '', '1', @control_id),
('tumour', 'Tumour', '', '1', @control_id); 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'muhc_tissue_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_tissue_type') , '0', '', '', '', 'tissue type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_tissue_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_tissue_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue type' AND `language_tag`=''), '1', '445', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT structure_value_domains (domain_name,source) VALUES ('muhc_pathologist', "StructurePermissibleValuesCustom::getCustomDropdown('pathologist')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('pathologist', '1', '50');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'muhc_pathologist_reviewing', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_pathologist') , '0', '', '', '', 'pathologist reviewing', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_pathologist_reviewing' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_pathologist')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathologist reviewing' AND `language_tag`=''), '1', '445', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='pathology_reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en) VALUES ('pathologist reviewing','Pathologist Reviewing'),('tissue type','Tissue Type');

ALTER TABLE sd_spe_tissues
  ADD COLUMN muhc_transported_on_ice char(1) DEFAULT '',
  ADD COLUMN muhc_transported_in_sucrose_solution char(1) DEFAULT '';
ALTER TABLE sd_spe_tissues_revs
  ADD COLUMN muhc_transported_on_ice char(1) DEFAULT '',
  ADD COLUMN muhc_transported_in_sucrose_solution char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'muhc_transported_on_ice', 'yes_no',  NULL , '0', '', '', '', 'transported on ice', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'muhc_transported_in_sucrose_solution', 'yes_no',  NULL , '0', '', '', '', 'transported in sucrose solution', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_transported_on_ice' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='transported on ice' AND `language_tag`=''), '1', '450', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_transported_in_sucrose_solution' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='transported in sucrose solution' AND `language_tag`=''), '1', '451', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `language_heading`='specimen transport' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_transported_on_ice' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO i18n (id,en) VALUES  
('transported in sucrose solution','Transported in sucrose solution'),
('transported on ice','Transported on ice'),
('specimen transport','Specimen Transport');

ALTER TABLE sd_spe_tissues
  ADD COLUMN muhc_surgeon_radiologist VARCHAR(50) DEFAULT NULL;
ALTER TABLE sd_spe_tissues_revs
  ADD COLUMN muhc_surgeon_radiologist VARCHAR(50) DEFAULT NULL;

INSERT structure_value_domains (domain_name,source) VALUES ('muhc_surgeon_radiologist', "StructurePermissibleValuesCustom::getCustomDropdown('surgeon and radiologist')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('surgeon and radiologist', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'surgeon and radiologist');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('dr g arena', 'Dr G Arena', 'Dr G Arena', '1', @control_id),
('dr m hassanain', 'Dr M Hassanain', 'Dr M Hassanain', '1', @control_id),
('dr g zogopoulos', 'Dr G Zogopoulos', 'Dr G Zogopoulos', '1', @control_id),
('dr p chaudhury', 'Dr P Chaudhury', 'Dr P Chaudhury', '1', @control_id),
('dr p metrakos', 'Dr P Metrakos', 'Dr P Metrakos', '1', @control_id); 

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'muhc_surgeon_radiologist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_surgeon_radiologist') , '0', '', '', '', 'surgeon or radiologist', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_surgeon_radiologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_surgeon_radiologist')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surgeon or radiologist' AND `language_tag`=''), '0', '499', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('surgeon or radiologist','Surgeon/Radiologist'); 

ALTER TABLE sd_spe_tissues
  ADD COLUMN muhc_liver_segment VARCHAR(50) DEFAULT NULL;  
ALTER TABLE sd_spe_tissues_revs
  ADD COLUMN muhc_liver_segment VARCHAR(50) DEFAULT NULL;  
  
INSERT structure_value_domains (domain_name,source) VALUES ('muhc_liver_segment', "StructurePermissibleValuesCustom::getCustomDropdown('liver segment')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('liver segment', '1', '50');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'muhc_liver_segment', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_liver_segment') , '0', '', '', '', 'liver segment', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_liver_segment' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_liver_segment')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='liver segment' AND `language_tag`=''), '2', '502', 'specific liver data', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES
('specific liver data','Liver Data'),
('liver segment','Liver Segment');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'liver segment');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('na', 'NA', '', '1', @control_id),
('1', '', '', '1', @control_id),
('2', '', '', '1', @control_id),
('2/3', '', '', '1', @control_id),
('3', '', '', '1', @control_id),
('4', '', '', '1', @control_id),
('4a&4b', '', '', '1', @control_id),
('5', '', '', '1', @control_id),
('5/8', '', '', '1', @control_id),
('6', '', '', '1', @control_id),
('6/7', '', '', '1', @control_id),
('7', '', '', '1', @control_id),
('8', '', '', '1', @control_id); 

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(7, 130, 8, 9, 101, 102);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(9, 33, 10);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(9, 10);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE ad_tubes ADD COLUMN muhc_storage_solution VARCHAR(50) DEFAULT NULL;
ALTER TABLE ad_tubes_revs ADD COLUMN muhc_storage_solution VARCHAR(50) DEFAULT NULL;

UPDATE aliquot_controls SET detail_form_alias = 'muhc_tissue_tubes' WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue') AND aliquot_type = 'tube';

ALTER TABLE ad_tubes ADD COLUMN muhc_mn_in_isopentane INT(6) DEFAULT NULL;
ALTER TABLE ad_tubes_revs ADD COLUMN muhc_mn_in_isopentane INT(6) DEFAULT NULL;

INSERT INTO structures(`alias`) VALUES ('muhc_tissue_tubes');
INSERT structure_value_domains (domain_name,source) VALUES 
('muhc_tissue_storage_method', "StructurePermissibleValuesCustom::getCustomDropdown('tissue storage method')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES 
('tissue storage method', '1', '50');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'tissue storage method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('none', 'None', '', '1', @control_id),
('OCT', '', '', '1', @control_id),
('RNAlater', '', '', '1', @control_id),
('10% NBF', '', '', '1', @control_id),
('isopentane', 'Isopentane', '', '1', @control_id),
('frozen', 'Frozen', '', '1', @control_id),
('FFPE', '', '', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'muhc_storage_solution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_tissue_storage_method') , '0', '', '', '', 'storage method', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'muhc_mn_in_isopentane', 'integer_positive',  NULL , '0', 'size=3', '', '', 'mn in isopentane', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_rec_to_stor_spent_time_msg_defintion' AND `language_label`='reception to storage spent time' AND `language_tag`=''), '1', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='inv_coll_to_stor_spent_time_msg_defintion' AND `language_label`='collection to storage spent time' AND `language_tag`=''), '1', '60', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '61', '', '1', 'reception to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '60', '', '1', 'collection to storage spent time (min)', '0', '', '0', '', '1', 'integer_positive', '1', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='muhc_storage_solution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_tissue_storage_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage method' AND `language_tag`=''), '1', '1181', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_tissue_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='muhc_mn_in_isopentane' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='mn in isopentane' AND `language_tag`=''), '1', '1182', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO i18n (id,en) VALUES ('storage method','Storage Method'),('mn in isopentane','Mn in isopentane');

INSERT INTO structure_permissible_values (value, language_alias) VALUES("mg", "mg");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tissue_weight_unit"), (SELECT id FROM structure_permissible_values WHERE value="mg" AND language_alias="mg"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("mm3", "mm3");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="tissue_size_unit"), (SELECT id FROM structure_permissible_values WHERE value="mm3" AND language_alias="mm3"), "3", "1");
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('mg','mg','mg'),('mm3','mm3','mm3');

INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field`='tissue_source'), 'notEmpty');

UPDATE structure_formats SET `language_heading`='tissue data' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ('tissue data','Tissue Data');

UPDATE structure_formats SET display_column ='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND display_column ='2';
UPDATE structure_formats SET `display_column`='0', `display_order`='610' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_transported_on_ice' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='611' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='muhc_transported_in_sucrose_solution' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ------------------------------------------------------------------------------------------------------------------
-- Blood
-- ------------------------------------------------------------------------------------------------------------------

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="gel CSA" AND language_alias="gel CSA");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="heparin" AND language_alias="heparin");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='blood_type' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="ZCSA" AND language_alias="ZCSA");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("serum", "serum");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="blood_type"), (SELECT id FROM structure_permissible_values WHERE value="serum" AND language_alias="serum"), "", "1");

ALTER TABLE sd_spe_bloods
  ADD COLUMN muhc_person_drawing_blood VARCHAR(50) DEFAULT NULL;
ALTER TABLE sd_spe_bloods_revs
  ADD COLUMN muhc_person_drawing_blood VARCHAR(50) DEFAULT NULL; 
INSERT structure_value_domains (domain_name,source) VALUES ('muhc_person_drawing_blood', "StructurePermissibleValuesCustom::getCustomDropdown('person drawing blood')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('person drawing blood', '1', '50');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_person_drawing_blood', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_person_drawing_blood') , '0', '', '', '', 'person drawing blood', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_person_drawing_blood' ), '0', '499', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('person drawing blood','Person drawing blood'); 

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='blood_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='collected_tube_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE sd_spe_bloods
  ADD COLUMN muhc_type_of_procedure VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_patient_status VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_patient_status_precision VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_type_of_blood_draw VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_type_of_blood_draw_precision VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_inverted_8_times CHAR(1) DEFAULT '';
ALTER TABLE sd_spe_bloods_revs
  ADD COLUMN muhc_type_of_procedure VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_patient_status VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_patient_status_precision VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_type_of_blood_draw VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_type_of_blood_draw_precision VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_inverted_8_times CHAR(1) DEFAULT '';

INSERT structure_value_domains (domain_name,source) VALUES 
('muhc_type_of_blood_procedure', "StructurePermissibleValuesCustom::getCustomDropdown('type of blood procedure')"),
('muhc_patient_status_at_blood_draw', "StructurePermissibleValuesCustom::getCustomDropdown('patient status at blood draw')"),
('muhc_patient_status_at_blood_draw_precision', "StructurePermissibleValuesCustom::getCustomDropdown('patient status at blood draw precision')"),
('muhc_type_of_blood_draw', "StructurePermissibleValuesCustom::getCustomDropdown('type of blood draw')"),
('muhc_type_of_blood_draw_precision', "StructurePermissibleValuesCustom::getCustomDropdown('type of blood draw precision')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES 
('type of blood procedure', '1', '50'),('patient status at blood draw', '1', '50'),('patient status at blood draw precision', '1', '50'),('type of blood draw', '1', '50'),('type of blood draw precision', '1', '50');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'type of blood procedure');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('only blood draw', 'Only blood draw', '', '1', @control_id),
('blood draw during surgery', 'Blood draw during surgery', '', '1', @control_id),
('blood draw with biopsy', 'Blood draw with biopsy', '', '1', @control_id);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'patient status at blood draw');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('pre-anesthesia', 'Pre-Anesthesia', '', '1', @control_id),
('post-anesthesia', 'Post-Anesthesia', '', '1', @control_id),
('not applicable', 'Not applicable', '', '1', @control_id),
('during anesthesia', 'During Anesthesia', '', '1', @control_id),
('unknown', 'Unknown', '', '1', @control_id);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'patient status at blood draw precision');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('pre-incision', 'Pre-incision', '', '1', @control_id),
('post-incision', 'Post-incision', '', '1', @control_id),
('not applicable', 'Not applicable', '', '1', @control_id);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'type of blood draw');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('venous (arm)', 'Venous (Arm)', '', '1', @control_id),
('arterial (arterial line)', 'Arterial (Arterial Line)', '', '1', @control_id),
('venous (central line)', 'Venous (Central Line)', '', '1', @control_id);

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'type of blood draw precision');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES 
('directly into Vacutainer', 'Directly into Vacutainer', '', '1', @control_id),
('syringe transfer into Vacutainer', 'Syringe transfer into Vacutainer', '', '1', @control_id);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_type_of_procedure', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_type_of_blood_procedure') , '0', '', '', '', 'muhc type of procedure', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_patient_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_patient_status_at_blood_draw') , '0', '', '', '', 'muhc patient status', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_patient_status_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_patient_status_at_blood_draw_precision') , '0', '', '', '', 'muhc patient status precision', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_type_of_blood_draw', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_type_of_blood_draw') , '0', '', '', '', 'muhc type of blood draw', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_type_of_blood_draw_precision', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_type_of_blood_draw_precision') , '0', '', '', '', 'muhc type of blood draw precision', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_inverted_8_times', 'yes_no',  NULL , '0', '', '', '', 'muhc inverted 8 times', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_type_of_procedure' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_type_of_blood_procedure')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='muhc type of procedure' AND `language_tag`=''), '1', '430', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_patient_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_patient_status_at_blood_draw')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='muhc patient status' AND `language_tag`=''), '1', '431', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_patient_status_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_patient_status_at_blood_draw_precision')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='muhc patient status precision' AND `language_tag`=''), '1', '432', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_type_of_blood_draw' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_type_of_blood_draw')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='muhc type of blood draw' AND `language_tag`=''), '1', '433', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_type_of_blood_draw_precision' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_type_of_blood_draw_precision')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='muhc type of blood draw precision' AND `language_tag`=''), '1', '434', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_inverted_8_times' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='muhc inverted 8 times' AND `language_tag`=''), '1', '435', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO i18n (id,en) VALUES
('muhc type of procedure','Type of procedure'),
('muhc patient status','Patient Status at blood draw'),
('muhc patient status precision','-'),
('muhc type of blood draw','Type of blood draw'),
('muhc type of blood draw precision','-'),
('muhc inverted 8 times','Tubes inverted 8 times after collection');
UPDATE structure_fields SET language_tag = language_label WHERE field IN ('muhc_patient_status_precision','muhc_type_of_blood_draw_precision');
UPDATE structure_fields SET language_label = '' WHERE field IN ('muhc_patient_status_precision','muhc_type_of_blood_draw_precision');

UPDATE structure_formats SET `language_heading`='blood draw procedure' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_type_of_procedure' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_type_of_blood_procedure') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='445' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_inverted_8_times' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='tube information' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='blood_type') AND `flag_confidential`='0');

ALTER TABLE sd_spe_bloods
  ADD COLUMN muhc_storage_time TIME DEFAULT NULL,
  ADD COLUMN muhc_storage_temperature VARCHAR(20) DEFAULT NULL,
  ADD COLUMN muhc_storage_temperature_other INT(6) DEFAULT NULL,
  ADD COLUMN muhc_transport_time TIME DEFAULT NULL,
  ADD COLUMN muhc_transport_temperature VARCHAR(20) DEFAULT NULL,
  ADD COLUMN muhc_transport_temperature_other INT(6) DEFAULT NULL;
ALTER TABLE sd_spe_bloods_revs
  ADD COLUMN muhc_storage_time TIME DEFAULT NULL,
  ADD COLUMN muhc_storage_temperature VARCHAR(20) DEFAULT NULL,
  ADD COLUMN muhc_storage_temperature_other INT(6) DEFAULT NULL,
  ADD COLUMN muhc_transport_time TIME DEFAULT NULL,
  ADD COLUMN muhc_transport_temperature VARCHAR(20) DEFAULT NULL,
  ADD COLUMN muhc_transport_temperature_other INT(6) DEFAULT NULL;

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("muhc_blood_tube_temperature", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("RT", "RT");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="muhc_blood_tube_temperature"), (SELECT id FROM structure_permissible_values WHERE value="RT" AND language_alias="RT"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("4°C", "4°C");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="muhc_blood_tube_temperature"), (SELECT id FROM structure_permissible_values WHERE value="4°C" AND language_alias="4°C"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("on ice", "on ice");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="muhc_blood_tube_temperature"), (SELECT id FROM structure_permissible_values WHERE value="on ice" AND language_alias="on ice"), "3", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="muhc_blood_tube_temperature"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "other", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_storage_time', 'time',  NULL , '0', '', '', '', 'storage', 'time'), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_storage_temperature', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_blood_tube_temperature') , '0', '', '', '', '', 'temperature abbreviation'), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_storage_temperature_other', 'integer',  NULL , '0', 'size=3', '', '', '', 'other (celsius)'), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_transport_time', 'time',  NULL , '0', '', '', '', 'transport', 'time'), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_transport_temperature', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_blood_tube_temperature') , '0', '', '', '', '', 'temperature abbreviation'), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_transport_temperature_other', 'integer',  NULL , '0', 'size=3', '', '', '', 'other (celsius)');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_storage_time' AND `type`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage' AND `language_tag`='time'), '2', '446', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_storage_temperature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_blood_tube_temperature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='temperature abbreviation'), '2', '447', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_storage_temperature_other' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='other (celsius)'), '2', '448', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_transport_time' AND `type`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='transport' AND `language_tag`='time'), '2', '449', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_transport_temperature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_blood_tube_temperature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='temperature abbreviation'), '2', '450', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_transport_temperature_other' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='other (celsius)'), '2', '451', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en) VALUES 
('blood draw procedure','Blood Draw Procedure'),
('tube information','Tube Information'),
('transport','Transport'),
('other (celsius)','Other (°C)'),
('on ice','On ice'),
('RT','RT'),
('4°C','4°C');

UPDATE structure_formats SET `flag_float`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO i18n (id,en) VALUEs ('lot number','Lot#');

UPDATE structure_fields SET setting='size=10' WHERE field = 'lot_number';

UPDATE aliquot_controls SET detail_form_alias = CONCAT(detail_form_alias,',muhc_blood_tubes') WHERE sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'blood') AND aliquot_type = 'tube';

ALTER TABLE ad_tubes
  ADD COLUMN muhc_pmek_number varchar(30) DEFAULT NULL;
ALTER TABLE ad_tubes_revs
  ADD COLUMN muhc_pmek_number varchar(30) DEFAULT NULL;
INSERT INTO structures(`alias`) VALUES ('muhc_blood_tubes');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'muhc_pmek_number', 'input',  NULL , '0', 'size=10', '', '', 'pmek number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_blood_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='muhc_pmek_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='pmek number' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en) VALUES ('pmek number','PMEK#');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_validations(structure_field_id, rule) VALUES ((SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `field`='blood_type'), 'notEmpty');

UPDATE structure_formats SET display_column ='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND display_column ='2';
UPDATE structure_formats SET `display_column`='0', `display_order`='610' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_type_of_procedure' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_type_of_blood_procedure') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='611' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_patient_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_patient_status_at_blood_draw') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='612' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_patient_status_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_patient_status_at_blood_draw_precision') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='613' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_type_of_blood_draw' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_type_of_blood_draw') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='0', `display_order`='614' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_bloods') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_type_of_blood_draw_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_type_of_blood_draw_precision') AND `flag_confidential`='0');

ALTER TABLE ad_whatman_papers
  ADD COLUMN muhc_lot_nbr VARCHAR(30) DEFAULT NULL,
  ADD COLUMN muhc_person_processing VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_datetime_card_completed DATETIME DEFAULT NULL,
  ADD COLUMN muhc_datetime_card_sealed DATETIME DEFAULT NULL;
ALTER TABLE ad_whatman_papers_revs
  ADD COLUMN muhc_lot_nbr VARCHAR(30) DEFAULT NULL,
  ADD COLUMN muhc_person_processing VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_datetime_card_completed DATETIME DEFAULT NULL,
  ADD COLUMN muhc_datetime_card_sealed DATETIME DEFAULT NULL;  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_whatman_papers', 'muhc_lot_nbr', 'input',  NULL , '0', 'size=10', '', '', 'lot number', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_whatman_papers', 'muhc_person_processing', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'person processing', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_whatman_papers', 'muhc_datetime_card_completed', 'datetime',  NULL , '0', '', '', '', 'date card completed', ''), 
('InventoryManagement', 'AliquotDetail', 'ad_whatman_papers', 'muhc_datetime_card_sealed', 'datetime',  NULL , '0', '', '', '', 'date card sealed', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_whatman_papers'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='muhc_lot_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='lot number' AND `language_tag`=''), '1', '70', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_whatman_papers'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='muhc_person_processing' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='person processing' AND `language_tag`=''), '1', '71', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_whatman_papers'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='muhc_datetime_card_completed' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date card completed' AND `language_tag`=''), '1', '72', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_whatman_papers'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_whatman_papers' AND `field`='muhc_datetime_card_sealed' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date card sealed' AND `language_tag`=''), '1', '73', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_whatman_papers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='used_blood_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_whatman_papers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='used_blood_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES
('person processing','Person Processing'), 
('date card completed','Date Card Completed'), 
('date card sealed','Date Card Sealed');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(25, 3, 119, 19, 131, 133, 135, 134, 23, 136, 20, 21, 15, 16, 24, 132, 17, 18, 118);

REPLACE INTO i18n (id,en) VALUES  ('pbmc','Buffy Coat');

ALTER TABLE sd_spe_bloods
  ADD COLUMN muhc_correctly_conserved_before_processing CHAR(1) DEFAULT '',
  ADD COLUMN muhc_paxgene_person_processing VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_paxgen_storage_at_minus_20 datetime DEFAULT NULL;
ALTER TABLE sd_spe_bloods_revs
  ADD COLUMN muhc_correctly_conserved_before_processing CHAR(1) DEFAULT '',
  ADD COLUMN muhc_paxgene_person_processing VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_paxgen_storage_at_minus_20 datetime DEFAULT NULL; 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_correctly_conserved_before_processing', 'yes_no',  NULL , '0', '', '', 'blood_correctly_conserved_before_processing_help', 'correctly conserved before processing', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_paxgene_person_processing', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'person processing paxgene tubes', ''), 
('InventoryManagement', 'SampleDetail', 'sd_spe_bloods', 'muhc_paxgen_storage_at_minus_20', 'datetime', (SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') , '0', '', '', '', 'paxgen tube put at -20', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_correctly_conserved_before_processing' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='blood_correctly_conserved_before_processing_help' AND `language_label`='correctly conserved before processing' AND `language_tag`=''), '1', '455', 'tube processing', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_paxgene_person_processing' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='person processing paxgene tubes' AND `language_tag`=''), '1', '456', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='sd_spe_bloods'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_bloods' AND `field`='muhc_paxgen_storage_at_minus_20' AND `type`='datetime' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='paxgen tube put at -20' AND `language_tag`=''), '1', '457', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en) VALUES
('correctly conserved before processing','Correctly conserved before processing (see help)'),
('blood_correctly_conserved_before_processing_help','- Plasma (lavender) Vacutainer(s) kept at 4ºC until processing, unless processed immediately.<br>- Serum (red) Vacutainer(s) kept at room temperature for 30-90 minutes before processing.<br>- PAXgene Vacutainer kept at room temperature for 2 hours before processing.'),
('person processing paxgene tubes','PAXene: Person processing'),
('paxgen tube put at -20','PAXene: Date put at -20°C'),
('tube processing','Tube Processing');

ALTER TABLE ad_whatman_papers
  ADD COLUMN muhc_datetime_card_completed_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN muhc_datetime_card_sealed_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE ad_whatman_papers_revs
  ADD COLUMN muhc_datetime_card_completed_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN muhc_datetime_card_sealed_accuracy char(1) NOT NULL DEFAULT '';  
ALTER TABLE sd_spe_bloods
  ADD COLUMN muhc_paxgen_storage_at_minus_20_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE sd_spe_bloods_revs
  ADD COLUMN muhc_paxgen_storage_at_minus_20_accuracy char(1) NOT NULL DEFAULT ''; 

INSERT INTO i18n (id,en) VALUES ('paxgene tube fields should only be completed when type selected is equal to paxgene','Paxgene tube fields should only be completed when type selected is equal to paxgene.');

REPLACE INTO i18n (id,en) VALUES ('created by','Processing By'),('creation date','Process date');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='derivatives') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_der_tubes_incl_ml_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='lot_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structures(`alias`) VALUES ('muhc_blood_processing');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("muhc_centrifugation_spin_force_unit", "", "", NULL);
INSERT INTO structure_permissible_values (value, language_alias) VALUES("G", "spin_force_G");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="muhc_centrifugation_spin_force_unit"), (SELECT id FROM structure_permissible_values WHERE value="G" AND language_alias="spin_force_G"), "", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("RPM", "spin_force_RPM");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="muhc_centrifugation_spin_force_unit"), (SELECT id FROM structure_permissible_values WHERE value="RPM" AND language_alias="spin_force_RPM"), "", "1");
INSERT structure_value_domains (domain_name,source) VALUES ('muhc_centrifugation_machine', "StructurePermissibleValuesCustom::getCustomDropdown('blood centrifugation machine')");
INSERT INTO structure_permissible_values_custom_controls (name,flag_active, values_max_length) VALUES ('blood centrifugation machine', '1', '50');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', '', 'muhc_centrifugation_machine', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_centrifugation_machine') , '0', '', '', '', 'machine', ''), 
('InventoryManagement', 'SampleDetail', '', 'muhc_centrifugation_spin_duration_mn', 'integer_positive',  NULL , '0', 'size=6', '', '', 'spin duration mn', ''), 
('InventoryManagement', 'SampleDetail', '', 'muhc_centrifugation_temperature_celsius', 'float_positive',  NULL , '0', 'size=6', '', '', 'temperature celsius', ''), 
('InventoryManagement', 'SampleDetail', '', 'muhc_centrifugation_spin_force', 'integer_positive',  NULL , '0', 'size=6', '', '', 'spin force', ''), 
('InventoryManagement', 'SampleDetail', '', 'muhc_centrifugation_spin_force_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='muhc_centrifugation_spin_force_unit') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='muhc_blood_processing'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample sop' AND `language_tag`=''), '1', '410', 'centrifugation', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_blood_processing'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='muhc_centrifugation_machine' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_centrifugation_machine')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='machine' AND `language_tag`=''), '1', '411', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_blood_processing'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='muhc_centrifugation_spin_duration_mn' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='spin duration mn' AND `language_tag`=''), '1', '412', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_blood_processing'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='muhc_centrifugation_temperature_celsius' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='temperature celsius' AND `language_tag`=''), '1', '413', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_blood_processing'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='muhc_centrifugation_spin_force' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=6' AND `default`='' AND `language_help`='' AND `language_label`='spin force' AND `language_tag`=''), '1', '414', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='muhc_blood_processing'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='muhc_centrifugation_spin_force_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='muhc_centrifugation_spin_force_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '415', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE sd_der_pbmcs
  ADD COLUMN muhc_centrifugation_machine VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_duration_mn int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_temperature_celsius  decimal(5,2) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force_unit VARCHAR(10) DEFAULT NULL;
ALTER TABLE sd_der_pbmcs_revs
  ADD COLUMN muhc_centrifugation_machine VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_duration_mn int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_temperature_celsius  decimal(5,2) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force_unit VARCHAR(10) DEFAULT NULL;
ALTER TABLE sd_der_plasmas
  ADD COLUMN muhc_centrifugation_machine VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_duration_mn int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_temperature_celsius  decimal(5,2) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force_unit VARCHAR(10) DEFAULT NULL;
ALTER TABLE sd_der_plasmas_revs
  ADD COLUMN muhc_centrifugation_machine VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_duration_mn int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_temperature_celsius  decimal(5,2) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force_unit VARCHAR(10) DEFAULT NULL;    
ALTER TABLE sd_der_serums
  ADD COLUMN muhc_centrifugation_machine VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_duration_mn int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_temperature_celsius  decimal(5,2) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force_unit VARCHAR(10) DEFAULT NULL;
ALTER TABLE sd_der_serums_revs
  ADD COLUMN muhc_centrifugation_machine VARCHAR(50) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_duration_mn int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_temperature_celsius  decimal(5,2) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force int(6) DEFAULT NULL,
  ADD COLUMN muhc_centrifugation_spin_force_unit VARCHAR(10) DEFAULT NULL;  	
UPDATE sample_controls SET detail_form_alias = CONCAT(detail_form_alias, ',muhc_blood_processing') WHERE sample_type IN ('serum','plasma','pbmc');
INSERT INTO i18n (id,en) VALUES 
('centrifugation','Centrifugation'),
('machine','Machine'),
('spin duration mn','Spin Duration (mn)'),
('temperature celsius','Temperature (°C)'),
('spin force','Spin Force'),
('spin_force_G','G'),
('spin_force_RPM','RPM');

-- ------------------------------------------------------------------------------------------------------------------
-- SOP
-- ------------------------------------------------------------------------------------------------------------------

UPDATE sop_controls SET flag_active = 0;
INSERT INTO sop_controls (id,sop_group,type,detail_tablename,detail_form_alias,flag_active) VALUES (null,'Blood Processing','Inventory','sopd_inventory_alls','sopd_inventory_all','1');

-- ------------------------------------------------------------------------------------------------------------------
-- Study
-- ------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');
ALTER TABLE study_summaries ADD COLUMN muhc_irb_nbr varchar(100) DEFAULT '';
ALTER TABLE study_summaries_revs ADD COLUMN muhc_irb_nbr varchar(100) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'muhc_irb_nbr', 'input',  NULL , '0', 'size=30', '', '', 'muhc irb reb nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='muhc_irb_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='muhc irb reb nbr' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule) 
VALUES 
((SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `field`='title'), 'notEmpty'),
((SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `field`='muhc_irb_nbr'), 'notEmpty');
