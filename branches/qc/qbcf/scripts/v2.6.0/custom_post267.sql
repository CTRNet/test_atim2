UPDATE users SET flag_active = '1', `password` = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', username = 'NicoEn' WHERE id = '1';
UPDATE groups SET flag_show_confidential = 1 WHERE id = 1;
INSERT INTO i18n (id,en,fr) VALUES ('core_installname','QBCF','QBCF');

DELETE FROM banks;
INSERT INTO banks (id,name) VALUES (1,'CHUM#1'), (2,'CHUQ#2'), (3,'QBCF#3'),(4,'MUHC#4');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Clinical Annotation
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Participants
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `field` IN ('notes','vital_status','date_of_birth','date_of_death','participant_identifier','created','ids','last_modification'));

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE `participants` 
  ADD COLUMN `qbcf_bank_id` int(11) DEFAULT NULL,
  ADD COLUMN `qbcf_bank_participant_identifier` varchar(50) NOT NULL DEFAULT '',
  ADD COLUMN `qbcf_suspected_date_of_death` date DEFAULT NULL,
  ADD COLUMN `qbcf_suspected_date_of_death_accuracy` char(1) DEFAULT '',
  ADD COLUMN `qbcf_last_contact` date DEFAULT NULL,
  ADD COLUMN `qbcf_last_contact_accuracy` char(1) DEFAULT '',
  ADD COLUMN `qbcf_breast_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_ovarian_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_other_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_breast_cancer_previous_hist` varchar(50) DEFAULT NULL;
ALTER TABLE `participants_revs` 
  ADD COLUMN `qbcf_bank_id` int(11) DEFAULT NULL,
  ADD COLUMN `qbcf_bank_participant_identifier` varchar(50) NOT NULL DEFAULT '',
  ADD COLUMN `qbcf_suspected_date_of_death` date DEFAULT NULL,
  ADD COLUMN `qbcf_suspected_date_of_death_accuracy` char(1) DEFAULT '',
  ADD COLUMN `qbcf_last_contact` date DEFAULT NULL,
  ADD COLUMN `qbcf_last_contact_accuracy` char(1) DEFAULT '',
  ADD COLUMN `qbcf_breast_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_ovarian_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_other_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qbcf_breast_cancer_previous_hist` varchar(50) DEFAULT NULL;
ALTER TABLE `participants`
  ADD CONSTRAINT `FK_participants_banks` FOREIGN KEY (`qbcf_bank_id`) REFERENCES `banks` (`id`);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qbcf_yes_no_unk", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qbcf_yes_no_unk"), (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qbcf_yes_no_unk"), (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qbcf_yes_no_unk"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "3", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_suspected_date_of_death', 'date',  NULL , '0', '', '', '', 'supected date of death', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_last_contact', 'date',  NULL , '0', '', '', '', 'last contact', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_breast_cancer_fam_hist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk') , '0', '', '', '', 'family history of breast cancer', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_ovarian_cancer_fam_hist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk') , '0', '', '', '', 'family history of ovarian cancer', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_other_cancer_fam_hist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk') , '0', '', '', '', 'family history of other cancer', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_breast_cancer_previous_hist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk') , '0', '', '', '', 'previous history of breast disease', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_suspected_date_of_death' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='supected date of death' AND `language_tag`=''), '3', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_last_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact' AND `language_tag`=''), '3', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_breast_cancer_fam_hist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='family history of breast cancer' AND `language_tag`=''), '3', '10', 'cancer history', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_ovarian_cancer_fam_hist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='family history of ovarian cancer' AND `language_tag`=''), '3', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_other_cancer_fam_hist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='family history of other cancer' AND `language_tag`=''), '3', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_breast_cancer_previous_hist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='previous history of breast disease' AND `language_tag`=''), '3', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en)
VALUES
('supected date of death', 'Supected Date of Death'),
('last contact', 'Last Contact '),
('cancer history', 'Cancer History'),
("family history of breast cancer", "Family History of Breast Cancer"),
("family history of ovarian cancer", "Family History of Ovarian Cancer"),
("family history of other cancer", "Family History of Other Cancer"),
('bank patient #','Bank Patient #'),
('previous history of breast disease','Previous History of Breast Disease');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'bank', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_bank_participant_identifier', 'input',  NULL , '0', 'size=20', '', '', 'bank patient #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '1', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_bank_participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='bank patient #' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='qbcf_bank_id'), 'notEmpty', ''),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='qbcf_bank_participant_identifier'), 'notEmpty', '');
REPLACE INTO i18n (id,en) VALUES ('participant identifier','ATiM Participant #');
INSERT INTO i18n (id,en) VALUES
('this bank participant identifier has already been assigned to a patient of this bank', 'This bank participant identifier has already been assigned to a patient of this bank'),
('your search will be limited to your bank', 'Your search will be limited to your bank');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_breast_cancer_previous_hist', "StructurePermissibleValuesCustom::getCustomDropdown('Breast Cancer Previous History')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Breast Cancer Previous History', 1, 50, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Breast Cancer Previous History');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('yes, invasive', 'Yes, invasive',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('yes, non invasive/DCIS', 'Yes, non invasive/DCIS',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('yes, LCIS / lobular neoplasia', 'Yes, LCIS / lobular neoplasia',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('no', 'No',  '', '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_breast_cancer_previous_hist')  WHERE model='Participant' AND tablename='participants' AND field='qbcf_breast_cancer_previous_hist' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk');
ALTER TABLE `participants` 
  ADD COLUMN `qbcf_gravida` int(3) DEFAULT NULL,
  ADD COLUMN `qbcf_para` int(3) DEFAULT NULL,
  ADD COLUMN `qbcf_aborta` int(3) DEFAULT NULL,
  ADD COLUMN `qbcf_menopause` varchar(50) DEFAULT NULL;
ALTER TABLE `participants_revs` 
  ADD COLUMN `qbcf_gravida` int(3) DEFAULT NULL,
  ADD COLUMN `qbcf_para` int(3) DEFAULT NULL,
  ADD COLUMN `qbcf_aborta` int(3) DEFAULT NULL,
  ADD COLUMN `qbcf_menopause` varchar(50) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_gravida', 'integer_positive',  NULL , '0', 'size=3', '', '', 'gravida', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_para', 'integer_positive',  NULL , '0', 'size=3', '', '', 'para', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_aborta', 'integer_positive',  NULL , '0', 'size=3', '', '', 'aborta', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_menopause', 'integer_positive', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk') , '0', 'size=3', '', '', 'menopause', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_gravida' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='gravida' AND `language_tag`=''), '4', '70', 'reproductive history', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_para' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='para' AND `language_tag`=''), '4', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_aborta' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='aborta' AND `language_tag`=''), '4', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_menopause' AND `type`='integer_positive' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk')  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='menopause' AND `language_tag`=''), '4', '73', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('aborta', 'Aborta'),('menopause', 'Menopause');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk') ,  `setting`='' WHERE model='Participant' AND tablename='participants' AND field='qbcf_menopause' AND `type`='integer_positive' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_yes_no_unk');
 
UPDATE structure_formats SET `display_column`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_modification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

ALTER TABLE `participants` 
  ADD COLUMN `qbcf_gravidaplus_integer_unknown` char(1) DEFAULT '',
  ADD COLUMN `qbcf_paraplus_integer_unknown` char(1) DEFAULT '',
  ADD COLUMN `qbcf_abortaplus_integer_unknown` char(1) DEFAULT '';
ALTER TABLE `participants_revs` 
  ADD COLUMN `qbcf_gravidaplus_integer_unknown` char(1) DEFAULT '',
  ADD COLUMN `qbcf_paraplus_integer_unknown` char(1) DEFAULT '',
  ADD COLUMN `qbcf_abortaplus_integer_unknown` char(1) DEFAULT '';
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qbcf_integer_unknown", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("1", "unknown");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qbcf_integer_unknown"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="unknown"), "", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_gravidaplus_integer_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_paraplus_integer_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qbcf_abortaplus_integer_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_gravidaplus_integer_unknown'), '4', '70', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_paraplus_integer_unknown'), '4', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qbcf_abortaplus_integer_unknown'), '4', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("deceased from breast cancer", "deceased from breast cancer");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="health_status"), (SELECT id FROM structure_permissible_values WHERE value="deceased from breast cancer" AND language_alias="deceased from breast cancer"), "", "1");
INSERT INTO i18n (id,en) VALUEs ("deceased from breast cancer", "Deceased from breast cancer");

-- MiscIdentifier
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages/%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier');
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier');

-- Consent
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE consent_controls SET flag_active = 0;
UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ConsentMasters/%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster');
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster');

-- FamilyHistories
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories/%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'FamilyHistory') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'FamilyHistory');
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'FamilyHistory');

-- ReproductiveHistories
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories/%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ReproductiveHistory') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'ReproductiveHistory');
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ReproductiveHistory');

-- ParticipantContacts
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts/%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact');
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact');

-- ParticipantMessages
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages/%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantMessage') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantMessage');
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'ParticipantMessage');

-- Diagnosis
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE diagnosis_controls SET flag_active = 0;

-- Primary

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'breast', 1, 'qbcf_dx_breasts', 'qbcf_dx_breasts', 0, 'breast', 0);
  						
CREATE TABLE IF NOT EXISTS `qbcf_dx_breasts` (
  `type_of_intervention` varchar(50) DEFAULT NULL,
  `laterality` varchar(50) DEFAULT NULL,
  `grade_notthingham_sbr_ee` varchar(50) DEFAULT NULL,
  `glandular_acinar_tubular_differentiation` varchar(50) DEFAULT NULL,
  `nuclear_pleomorphism` varchar(50) DEFAULT NULL,
  `mitotic_rate` varchar(50) DEFAULT NULL,
  `tumor_size` decimal(8,2) DEFAULT NULL,
  `margin_status` varchar(50) DEFAULT NULL,
  `number_of_positive_regional_ln` int(4) DEFAULT NULL,
  `total_number_of_regional_ln_analysed` int(4) DEFAULT NULL,
  `number_of_positive_regional_ln_category` varchar(50) DEFAULT NULL,
  `number_of_positive_sentinel_ln` int(4) DEFAULT NULL,
  `total_number_of_sentinel_ln_analysed` int(4) DEFAULT NULL,
  `number_of_positive_sentinel_ln_category` varchar(50) DEFAULT NULL,
  `er_overall` varchar(50) DEFAULT NULL,
  `er_intensity` varchar(50) DEFAULT NULL,
  `er_percent` decimal(4,1) DEFAULT NULL,
  `pr_overall` varchar(50) DEFAULT NULL,
  `pr_intensity` varchar(50) DEFAULT NULL,
  `pr_percent` decimal(4,1) DEFAULT NULL,
  `her2_ihc` varchar(50) DEFAULT NULL,
  `her2_fish` varchar(50) DEFAULT NULL,
  `her_2_status` varchar(50) DEFAULT NULL,
  `tnbc` varchar(50) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_dx_breasts_revs` (
  `type_of_intervention` varchar(50) DEFAULT NULL,
  `laterality` varchar(50) DEFAULT NULL,
  `grade_notthingham_sbr_ee` varchar(50) DEFAULT NULL,
  `glandular_acinar_tubular_differentiation` varchar(50) DEFAULT NULL,
  `nuclear_pleomorphism` varchar(50) DEFAULT NULL,
  `mitotic_rate` varchar(50) DEFAULT NULL,
  `tumor_size` decimal(8,2) DEFAULT NULL,
  `margin_status` varchar(50) DEFAULT NULL,
  `number_of_positive_regional_ln` int(4) DEFAULT NULL,
  `total_number_of_regional_ln_analysed` int(4) DEFAULT NULL,
  `number_of_positive_regional_ln_category` varchar(50) DEFAULT NULL,
  `number_of_positive_sentinel_ln` int(4) DEFAULT NULL,
  `total_number_of_sentinel_ln_analysed` int(4) DEFAULT NULL,
  `number_of_positive_sentinel_ln_category` varchar(50) DEFAULT NULL,
  `er_overall` varchar(50) DEFAULT NULL,
  `er_intensity` varchar(50) DEFAULT NULL,
  `er_percent` decimal(4,1) DEFAULT NULL,
  `pr_overall` varchar(50) DEFAULT NULL,
  `pr_intensity` varchar(50) DEFAULT NULL,
  `pr_percent` decimal(4,1) DEFAULT NULL,
  `her2_ihc` varchar(50) DEFAULT NULL,
  `her2_fish` varchar(50) DEFAULT NULL,
  `her_2_status` varchar(50) DEFAULT NULL,
  `tnbc` varchar(50) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_dx_breasts`
  ADD CONSTRAINT `qbcf_dx_breasts_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_type_of_intervention', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Type of intervention')"),
('qbcf_laterality', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Laterality')"),
('qbcf_clinical_anatomic_stage', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Clinical Anatomic Stage')"),
('qbcf_tnm_ct', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (cT)')"),
('qbcf_tnm_cn', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (cN)')"),
('qbcf_tnm_cm', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (cM)')"),
('qbcf_pathological_anatomic_stage', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Pathological Anatomic Stage')"),
('qbcf_tnm_pt', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (pT)')"),
('qbcf_tnm_pn', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (pN)')"),
('qbcf_tnm_pm', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (pM)')"),
('qbcf_morphology', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Morphology')"),
('qbcf_grade_notthingham_sbr_ee', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Grade Notthingham / SBR-EE')"),
('qbcf_glandular_acinar_tubular_differentiation', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Glandular (Acinar)/ Tubular Differentiation')"),
('qbcf_nuclear_pleomorphism', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Nuclear Pleomorphism')"),
('qbcf_mitotic_rate', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Mitotic Rate')"),
('qbcf_margin_status', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Margin Status')"),
('qbcf_number_of_positive_regional_ln_category', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Number of positive Regional LN (Category)')"),
('qbcf_number_of_positive_sentinel_ln_category', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Number of positive Sentinel LN (Category)')"),
('qbcf_er_overall', "StructurePermissibleValuesCustom::getCustomDropdown('DX : ER Overall  (From path report)')"),
('qbcf_er_intensity', "StructurePermissibleValuesCustom::getCustomDropdown('DX : ER Intensity')"),
('qbcf_pr_overall', "StructurePermissibleValuesCustom::getCustomDropdown('DX : PR Overall (in path report)')"),
('qbcf_pr_intensity', "StructurePermissibleValuesCustom::getCustomDropdown('DX : PR Intensity')"),
('qbcf_her2_ihc', "StructurePermissibleValuesCustom::getCustomDropdown('DX : HER2 IHC')"),
('qbcf_her2_fish', "StructurePermissibleValuesCustom::getCustomDropdown('DX : HER2 FISH ')"),
('qbcf_her_2_status', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Her 2 Status')"),
('qbcf_tnbc', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNBC')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('DX : Type of intervention', 1, 50, 'clinical - treatment'),
('DX : Laterality', 1, 50, 'clinical - diagnosis'),
('DX : Clinical Anatomic Stage', 1, 50, 'clinical - diagnosis'),
('DX : TNM (cT)', 1, 50, 'clinical - diagnosis'),
('DX : TNM (cN)', 1, 50, 'clinical - diagnosis'),
('DX : TNM (cM)', 1, 50, 'clinical - diagnosis'),
('DX : Pathological Anatomic Stage', 1, 50, 'clinical - diagnosis'),
('DX : TNM (pT)', 1, 50, 'clinical - diagnosis'),
('DX : TNM (pN)', 1, 50, 'clinical - diagnosis'),
('DX : TNM (pM)', 1, 50, 'clinical - diagnosis'),
('DX : Morphology', 1, 250, 'clinical - diagnosis'),
('DX : Grade Notthingham / SBR-EE', 1, 50, 'clinical - diagnosis'),
('DX : Glandular (Acinar)/ Tubular Differentiation', 1, 50, 'clinical - diagnosis'),
('DX : Nuclear Pleomorphism', 1, 50, 'clinical - diagnosis'),
('DX : Mitotic Rate', 1, 50, 'clinical - diagnosis'),
('DX : Tumor size', 1, 50, 'clinical - diagnosis'),
('DX : Margin Status', 1, 50, 'clinical - diagnosis'),
('DX : Number of positive Regional LN (Category)', 1, 50, 'clinical - diagnosis'),
('DX : Number of positive Sentinel LN (Category)', 1, 50, 'clinical - diagnosis'),
('DX : ER Overall  (From path report)', 1, 50, 'clinical - diagnosis'),
('DX : ER Intensity', 1, 50, 'clinical - diagnosis'),
('DX : PR Overall (in path report)', 1, 50, 'clinical - diagnosis'),
('DX : PR Intensity', 1, 50, 'clinical - diagnosis'),
('DX : HER2 IHC', 1, 50, 'clinical - diagnosis'),
('DX : HER2 FISH ', 1, 50, 'clinical - diagnosis'),
('DX : Her 2 Status', 1, 50, 'clinical - diagnosis'),
('DX : TNBC', 1, 50, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Type of intervention');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('biopsy', 'Biopsy',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('fine needle aspiration breast', 'Fine Needle Aspiration Breast',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('fine needle aspiration ln', 'Fine Needle Aspiration LN',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('dissection of lymph node', 'Dissection of lymph node',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unilateral partial mastectomy', 'Unilateral Partial Mastectomy',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('bilateral partial mastectomy', 'Bilateral Partial Mastectomy',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unilateral total mastectomy', 'Unilateral Total Mastectomy',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('bilateral total mastectomy', 'Bilateral Total Mastectomy',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('lumpectomy', 'Lumpectomy',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Laterality');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('left', 'Left',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('right', 'Right',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('bilateral', 'Bilateral',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Clinical Anatomic Stage');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('i', 'I',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ia', 'IA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ib', 'IB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ii', 'II',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iia', 'IIA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iib', 'IIB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iii', 'III',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiia', 'IIIA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiib', 'IIIB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiic', 'IIIC',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iv', 'IV',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('u', 'U',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('tx', 'TX',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('nx', 'NX',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mx', 'MX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (cT)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('t1', 'T1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('tmi', 'Tmi',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t1a', 'T1a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t1b', 'T1b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t1c', 'T1c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t2', 'T2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t3', 'T3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t4', 'T4',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('tx', 'TX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (cN)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('n0', 'N0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1', 'N1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2', 'N2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2a', 'N2a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2b', 'N2b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3', 'N3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3a', 'N3a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3b', 'N3b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3c', 'N3c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('nx', 'NX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (cM)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('m0', 'M0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('m0(i+)', 'M0(i+)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('m1', 'M1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mx', 'MX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Pathological Anatomic Stage');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('i', 'I',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ia', 'IA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ib', 'IB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ii', 'II',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iia', 'IIA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iib', 'IIB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iii', 'III',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiia', 'IIIA',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiib', 'IIIB',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iiic', 'IIIC',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('iv', 'IV',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('u', 'U',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('tx', 'TX',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('nx', 'NX',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mx', 'MX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (pT)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('t1', 'T1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('tmi', 'Tmi',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t1a', 'T1a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t1b', 'T1b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t1c', 'T1c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t2', 'T2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t3', 'T3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t4', 'T4',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('tx', 'TX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (pN)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('pn', 'pN',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n0', 'N0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n0(i-)', 'N0(i-)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n0(i+)', 'N0(i+)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n0(mol-)', 'N0(mol-)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n0(mol+)', 'N0(mol+)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1', 'N1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1mi', 'N1mi',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1a', 'N1a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1b', 'N1b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1c', 'N1c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2', 'N2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2a', 'N2a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2b', 'N2b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3', 'N3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3a', 'N3a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3b', 'N3b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3c', 'N3c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('nx', 'NX',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('nA', 'NA',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (pM)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('m0', 'M0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('m0(i+)', 'M0(i+)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('m1', 'M1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mx', 'MX',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Morphology');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('invasive ductal carcinoma (no special type or not otherwise specified)','Invasive ductal carcinoma (no special type or not otherwise specified)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('invasive lobular carcinoma','Invasive lobular carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('invasive carcinoma with ductal and lobular features (mixed type carcinoma)','Invasive carcinoma with ductal and lobular features (mixed type carcinoma)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('invasive mucinous carcinoma','Invasive mucinous carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('invasive medullary carcinoma','Invasive medullary carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('invasive papillary carcinoma','Invasive papillary carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('invasive micropapillary carcinoma','Invasive micropapillary carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('invasive tubular carcinoma','Invasive tubular carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('invasive cribriform carcinoma','Invasive cribriform carcinoma',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('invasive carcinoma, type cannot be determined','Invasive carcinoma, type cannot be determined',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('invasive ductal carcinoma pleiomorphic','Invasive ductal carcinoma pleiomorphic',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('invasive ductal carcinoma apocrine','Invasive ductal carcinoma apocrine',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('other','Other',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Grade Notthingham / SBR-EE');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('1','1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('2','2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3','3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('u','U',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Glandular (Acinar)/ Tubular Differentiation');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('1','1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('2','2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3','3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('u','U',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Nuclear Pleomorphism');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('1','1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('2','2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3','3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('u','U',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Mitotic Rate');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('1','1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('2','2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3','3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('u','U',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Margin Status');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('positive', 'Positive',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('negative', 'Negative',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown', 'Unknown',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Number of positive Regional LN (Category)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('0','0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1-3','1-3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('4+','4+',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown','Unknown',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Number of positive Sentinel LN (Category)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('0','0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1-3','1-3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('4+','4+',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown','Unknown',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : ER Overall  (From path report)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('positive','Positive',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('negative','Negative',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('equivocal','Equivocal',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown, not provided','Unknown, not provided',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : ER Intensity');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('negative/background','Negative/background',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('low','Low',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('moderate','Moderate',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('strong','Strong',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown, not provided','Unknown, not provided',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : PR Overall (in path report)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('positive','Positive',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('negative','Negative',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('equivocal','Equivocal',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown, not provided','Unknown, not provided',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : PR Intensity');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('negative/background','Negative/background',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('low','Low',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('moderate','Moderate',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('strong','Strong',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown, not provided','Unknown, not provided',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : HER2 IHC');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('positive','Positive',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('negative','Negative',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('equivocal','Equivocal',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown','Unknown',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : HER2 FISH ');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('positive','Positive',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('negative','Negative',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('equivocal','Equivocal',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown','Unknown',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Her 2 Status');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('positive','Positive',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('negative','Negative',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('equivocal','Equivocal',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown','Unknown',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNBC');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('yes','Yes',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('no','No',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('equivocal','Equivocal',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown','Unknown',  '', '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE structure_permissible_values_customs SET display_order = id WHERE control_id IN (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'DX : %');

INSERT INTO structures(`alias`) VALUES ('qbcf_dx_breasts');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'type_of_intervention', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention') , '0', '', '', '', 'type of intervention', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_laterality') , '0', '', '', '', 'laterality', '');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'clinical_anatomic_stage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_clinical_anatomic_stage') , '0', '', '', '', 'clinical stage', 'summary'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tnm_ct', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_ct') , '0', '', '', '', '', 't stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tnm_cn', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_cn') , '0', '', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tnm_cm', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_cm') , '0', '', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'pathological_anatomic_stage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pathological_anatomic_stage') , '0', '', '', '', 'pathological stage', 'summary'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tnm_pt', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pt') , '0', '', '', '', '', 't stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tnm_pn', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pn') , '0', '', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tnm_pm', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pm') , '0', '', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'morphology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_morphology') , '0', '', '', '', 'morphology', '');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'grade_notthingham_sbr_ee', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_grade_notthingham_sbr_ee') , '0', '', '', '', 'grade notthingham / sbr-ee', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'glandular_acinar_tubular_differentiation', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_glandular_acinar_tubular_differentiation') , '0', '', '', '', 'glandular (acinar)/ tubular differentiation', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'nuclear_pleomorphism', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_nuclear_pleomorphism') , '0', '', '', '', 'nuclear pleomorphism', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'mitotic_rate', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_mitotic_rate') , '0', '', '', '', 'mitotic rate', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'tumor_size', 'float_positive',  NULL , '0', '', '', '', 'tumor size (mm)', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'margin_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_margin_status') , '0', '', '', '', 'margin status', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'number_of_positive_regional_ln', 'integer_positive',  NULL , '0', '', '', '', 'number of positive regional ln', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'total_number_of_regional_ln_analysed', 'integer_positive',  NULL , '0', '', '', '', 'total number of regional ln analysed', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'number_of_positive_regional_ln_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_number_of_positive_regional_ln_category') , '0', '', '', '', 'number of positive regional ln (category)', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'number_of_positive_sentinel_ln', 'integer_positive',  NULL , '0', '', '', '', 'number of positive sentinel ln', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'total_number_of_sentinel_ln_analysed', 'integer_positive',  NULL , '0', '', '', '', 'total number of sentinel ln analysed', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'number_of_positive_sentinel_ln_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_number_of_positive_sentinel_ln_category') , '0', '', '', '', 'number of positive sentinel ln (category)', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'er_overall', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_er_overall') , '0', '', '', '', 'er overall  (from path report)', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'er_intensity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_er_intensity') , '0', '', '', '', 'er intensity', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'er_percent', 'float_positive',  NULL , '0', '', '', '', 'er percent', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'pr_overall', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pr_overall') , '0', '', '', '', 'pr overall (in path report)', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'pr_intensity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pr_intensity') , '0', '', '', '', 'pr intensity', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'pr_percent', 'float_positive',  NULL , '0', '', '', '', 'pr percent', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'her2_ihc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her2_ihc') , '0', '', '', '', 'her2 ihc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'her2_fish', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her2_fish') , '0', '', '', '', 'her2 fish', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'her_2_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her_2_status') , '0', '', '', '', 'her 2 status', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'tnbc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnbc') , '0', '', '', '', 'tnbc', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx'), '1', '9', '', '', '1', 'age at time of intervention', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='type_of_intervention' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_type_of_intervention')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type of intervention' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'); 
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_anatomic_stage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_clinical_anatomic_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='summary'), '1', '14', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tnm_ct' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_ct')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='t stage'), '1', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tnm_cn' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_cn')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '1', '16', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tnm_cm' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_cm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '1', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='pathological_anatomic_stage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pathological_anatomic_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='summary'), '1', '18', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tnm_pt' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pt')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='t stage'), '1', '19', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tnm_pn' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pn')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '1', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tnm_pm' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnm_pm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_morphology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='morphology' AND `language_tag`=''), '3', '22', 'morphology', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='grade_notthingham_sbr_ee' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_grade_notthingham_sbr_ee')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='grade notthingham / sbr-ee' AND `language_tag`=''), '3', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='glandular_acinar_tubular_differentiation' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_glandular_acinar_tubular_differentiation')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='glandular (acinar)/ tubular differentiation' AND `language_tag`=''), '3', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='nuclear_pleomorphism' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_nuclear_pleomorphism')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nuclear pleomorphism' AND `language_tag`=''), '3', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='mitotic_rate' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_mitotic_rate')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mitotic rate' AND `language_tag`=''), '3', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='tumor_size' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor size (mm)' AND `language_tag`=''), '3', '27', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='margin_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_margin_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='margin status' AND `language_tag`=''), '3', '28', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='number_of_positive_regional_ln' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive regional ln' AND `language_tag`=''), '3', '29', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='total_number_of_regional_ln_analysed' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total number of regional ln analysed' AND `language_tag`=''), '3', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='number_of_positive_regional_ln_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_number_of_positive_regional_ln_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive regional ln (category)' AND `language_tag`=''), '3', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='number_of_positive_sentinel_ln' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive sentinel ln' AND `language_tag`=''), '3', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='total_number_of_sentinel_ln_analysed' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total number of sentinel ln analysed' AND `language_tag`=''), '3', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='number_of_positive_sentinel_ln_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_number_of_positive_sentinel_ln_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive sentinel ln (category)' AND `language_tag`=''), '3', '34', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='er_overall' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_er_overall')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='er overall  (from path report)' AND `language_tag`=''), '4', '35', 'biomarkers', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='er_intensity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_er_intensity')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='er intensity' AND `language_tag`=''), '4', '36', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='er_percent' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='er percent' AND `language_tag`=''), '4', '37', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='pr_overall' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pr_overall')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pr overall (in path report)' AND `language_tag`=''), '4', '38', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='pr_intensity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_pr_intensity')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pr intensity' AND `language_tag`=''), '4', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='pr_percent' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pr percent' AND `language_tag`=''), '4', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='her2_ihc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her2_ihc')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her2 ihc' AND `language_tag`=''), '4', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='her2_fish' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her2_fish')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her2 fish' AND `language_tag`=''), '4', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='her_2_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_her_2_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her 2 status' AND `language_tag`=''), '4', '43', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='tnbc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tnbc')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tnbc' AND `language_tag`=''), '4', '44', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `field`='type_of_intervention'), 'notEmpty', '');
INSERT IGNORE INTO i18n (id,en)
VALUES
("type of intervention","Type of Intervention"),
("specimen sent to chum for tma construction","Specimen sent to CHUM for TMA construction"),
("laterality","Laterality"),
('biomarkers','Biomarkers'),
("morphology","Morphology"),
("grade notthingham / sbr-ee","Grade Notthingham / SBR-EE"),
("glandular (acinar)/ tubular differentiation","Glandular (Acinar)/ Tubular Differentiation"),
("nuclear pleomorphism","Nuclear Pleomorphism"),
("mitotic rate","Mitotic Rate"),
("tumor size (mm)","Tumor Size (mm)"),
("margin status","Margin Status"),
("number of positive regional ln","Number of Positive Regional LN"),
("total number of regional ln analysed","Total number of Regional LN analysed"),
("number of positive regional ln (category)","Number of positive Regional LN (Category)"),
("number of positive sentinel ln","Number of Positive Sentinel LN"),
("total number of sentinel ln analysed","Total number of Sentinel LN analysed"),
("number of positive sentinel ln (category)","Number of positive Sentinel LN (Category)"),
("er overall  (from path report)","ER Overall  (From path report)"),
("er intensity","ER Intensity"),
("er percent","ER Percent"),
("pr overall (in path report)","PR Overall (in path report)"),
("pr intensity","PR Intensity"),
("pr percent","PR Percent"),
("her2 ihc","HER2 IHC"),
("her2 fish","HER2 FISH"),
("her 2 status","Her 2 Status"),
("tnbc","TNBC"),
('age at time of intervention','Age at Time of Intervention');

UPDATE structure_fields SET field = 'clinical_tstage' WHERE field = 'tnm_ct' AND structure_value_domain IN (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qbcf_%');
UPDATE structure_fields SET field = 'clinical_nstage' WHERE field = 'tnm_cn' AND structure_value_domain IN (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qbcf_%');
UPDATE structure_fields SET field = 'clinical_mstage' WHERE field = 'tnm_cm' AND structure_value_domain IN (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qbcf_%');
UPDATE structure_fields SET field = 'clinical_stage_summary' WHERE field = 'clinical_anatomic_stage' AND structure_value_domain IN (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qbcf_%');
UPDATE structure_fields SET field = 'path_tstage' WHERE field = 'tnm_pt' AND structure_value_domain IN (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qbcf_%');
UPDATE structure_fields SET field = 'path_nstage' WHERE field = 'tnm_pn' AND structure_value_domain IN (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qbcf_%');
UPDATE structure_fields SET field = 'path_mstage' WHERE field = 'tnm_pm' AND structure_value_domain IN (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qbcf_%');
UPDATE structure_fields SET field = 'path_stage_summary' WHERE field = 'pathological_anatomic_stage' AND structure_value_domain IN (SELECT id FROM structure_value_domains WHERE domain_name LIKE 'qbcf_%');

ALTER TABLE diagnosis_masters 
  MODIFY morphology varchar(250) DEFAULT NULL,
  MODIFY clinical_tstage varchar(50) DEFAULT NULL,
  MODIFY clinical_nstage varchar(50) DEFAULT NULL,
  MODIFY clinical_mstage varchar(50) DEFAULT NULL,
  MODIFY clinical_stage_summary varchar(50) DEFAULT NULL,
  MODIFY path_tstage varchar(50) DEFAULT NULL,
  MODIFY path_nstage varchar(50) DEFAULT NULL,
  MODIFY path_mstage varchar(50) DEFAULT NULL,
  MODIFY path_stage_summary varchar(50) DEFAULT NULL;
ALTER TABLE diagnosis_masters_revs
  MODIFY morphology varchar(250) DEFAULT NULL,
  MODIFY clinical_tstage varchar(50) DEFAULT NULL,
  MODIFY clinical_nstage varchar(50) DEFAULT NULL,
  MODIFY clinical_mstage varchar(50) DEFAULT NULL,
  MODIFY clinical_stage_summary varchar(50) DEFAULT NULL,
  MODIFY path_tstage varchar(50) DEFAULT NULL,
  MODIFY path_nstage varchar(50) DEFAULT NULL,
  MODIFY path_mstage varchar(50) DEFAULT NULL,
  MODIFY path_stage_summary varchar(50) DEFAULT NULL;

ALTER TABLE `qbcf_dx_breasts` 
  ADD COLUMN `number_of_positive_regional_ln_integer_unknown` char(1) DEFAULT '' AFTER number_of_positive_regional_ln,
  ADD COLUMN `total_number_of_regional_ln_analysed_integer_unknown` char(1) DEFAULT '' AFTER total_number_of_regional_ln_analysed,
  ADD COLUMN `number_of_positive_sentinel_ln_integer_unknown` char(1) DEFAULT '' AFTER number_of_positive_sentinel_ln,
  ADD COLUMN `total_number_of_sentinel_ln_analysed_integer_unknown` char(1) DEFAULT '' AFTER total_number_of_sentinel_ln_analysed;
ALTER TABLE `qbcf_dx_breasts_revs` 
  ADD COLUMN `number_of_positive_regional_ln_integer_unknown` char(1) DEFAULT '' AFTER number_of_positive_regional_ln,
  ADD COLUMN `total_number_of_regional_ln_analysed_integer_unknown` char(1) DEFAULT '' AFTER total_number_of_regional_ln_analysed,
  ADD COLUMN `number_of_positive_sentinel_ln_integer_unknown` char(1) DEFAULT '' AFTER number_of_positive_sentinel_ln,
  ADD COLUMN `total_number_of_sentinel_ln_analysed_integer_unknown` char(1) DEFAULT '' AFTER total_number_of_sentinel_ln_analysed;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'number_of_positive_regional_ln_integer_unknown', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', '', 'total_number_of_regional_ln_analysed_integer_unknown', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', '', 'number_of_positive_sentinel_ln_integer_unknown', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', '', 'total_number_of_sentinel_ln_analysed_integer_unknown', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='number_of_positive_regional_ln_integer_unknown' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '3', '29', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='' AND `field`='total_number_of_regional_ln_analysed_integer_unknown' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '3', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='' AND `field`='number_of_positive_sentinel_ln_integer_unknown' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '3', '32', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='' AND `field`='total_number_of_sentinel_ln_analysed_integer_unknown' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '3', '33', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `tablename`='qbcf_dx_breasts' WHERE model='DiagnosisDetail' AND tablename='' AND field='total_number_of_regional_ln_analysed_integer_unknown' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown');
UPDATE structure_fields SET  `tablename`='qbcf_dx_breasts' WHERE model='DiagnosisDetail' AND tablename='' AND field='number_of_positive_sentinel_ln_integer_unknown' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown');
UPDATE structure_fields SET  `tablename`='qbcf_dx_breasts' WHERE model='DiagnosisDetail' AND tablename='' AND field='total_number_of_sentinel_ln_analysed_integer_unknown' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown');

ALTER TABLE `qbcf_dx_breasts` 
  ADD COLUMN `time_to_last_contact_months` int(5) DEFAULT NULL,
  ADD COLUMN `time_to_first_progression_months` int(5) DEFAULT NULL;
ALTER TABLE `qbcf_dx_breasts_revs` 
  ADD COLUMN `time_to_last_contact_months` int(5) DEFAULT NULL,
  ADD COLUMN `time_to_first_progression_months` int(5) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'time_to_last_contact_months', 'integer_positive',  NULL , '0', 'size=3', '', '', 'time to last contact/death (months)', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breasts', 'time_to_first_progression_months', 'integer_positive',  NULL , '0', 'size=3', '', '', 'time to first progression (months)', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='time_to_last_contact_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='time to last contact/death (months)' AND `language_tag`=''), '1', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_breasts'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='time_to_first_progression_months' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='time to first progression (months)' AND `language_tag`=''), '1', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='time_to_last_contact_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_dx_breasts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breasts' AND `field`='time_to_first_progression_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en)
VALUES
('time to last contact/death (months)', 'Time to Last Contact/Death (months)'), 
('time to first progression (months)', 'Time to First Progression (months)'),
('see diagnosis done on %s', 'See diagnosis done on %s');
INSERT IGNORE INTO i18n (id,en)
VALUES
("'time to first progression' cannot be calculated because dates are not chronological","'Time to First Progression' cannot be calculated because dates are not chronological"),
("'time to first progression' cannot be calculated on inaccurate dates", "'Time to First Progression' cannot be calculated on inaccurate dates"),
("at least one breast diagnosis date is unknown - the 'time to' values cannot be calculated for 'un-dated' diagnosis","At least one breast diagnosis date is unknown - The 'Time to' values cannot be calculated for 'un-dated' diagnosis"),
("'time to last contact' cannot be calculated on inaccurate dates", "'Time to Last Contact' cannot be calculated on inaccurate dates"),
("'time to last contact' cannot be calculated because dates are not chronological", "'Time to Last Contact' cannot be calculated because dates are not chronological"),
("'time to last contact' has been calculated with at least one unaccuracy date", "'Time to Last Contact' has been calculated with at least one unaccuracy date"),
("at least one breast progression diagnosis date is unknown", "At least one breast progression diagnosis date is unknown"),
("'time to first progression' has been calculated with at least one unaccuracy date","'Time to First Progression' has been calculated with at least one unaccuracy date"),
("the last contact or death date is unknown - the 'time to last contact' values cannot be calculated", "The last contact or death date is unknown - The 'Time to Last Contact' values cannot be calculated");

-- Progression

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'breast progression', 1, 'qbcf_dx_breast_progressions', 'qbcf_dx_breast_progressions', 0, 'breast progression', 0);
  						
CREATE TABLE IF NOT EXISTS `qbcf_dx_breast_progressions` (
  `site` varchar(250) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_dx_breast_progressions_revs` (
  `site` varchar(250) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_dx_breast_progressions`
  ADD CONSTRAINT `qbcf_dx_breast_progressions_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_diagnosis_progression_sites', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Progressions Sites')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('DX : Progressions Sites', 1, 250, 'clinical - diagnosis');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Progressions Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('bone', 'Bone', '1', @control_id, NOW(), NOW(), 1, 1),
('brain', 'Brain', '1', @control_id, NOW(), NOW(), 1, 1),
('liver', 'Liver', '1', @control_id, NOW(), NOW(), 1, 1),
('lung', 'Lung', '1', @control_id, NOW(), NOW(), 1, 1),
('lymph node - regional', 'Lymph Node - regional', '1', @control_id, NOW(), NOW(), 1, 1),
('lymph node - distal', 'Lymph Node - distal', '1', @control_id, NOW(), NOW(), 1, 1),
('skin', 'Skin', '1', @control_id, NOW(), NOW(), 1, 1),
('other', 'Other', '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE structure_permissible_values_customs SET display_order = id WHERE control_id IN (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'DX : Progressions Sites');

INSERT INTO structures(`alias`) VALUES ('qbcf_dx_breast_progressions');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_breast_progressions', 'site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_diagnosis_progression_sites') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dx_breast_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breast_progressions' AND `field`='site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_diagnosis_progression_sites')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breast_progressions' AND `field`='site' ), 'notEmpty', '');

INSERT INTO i18n (id,en) VALUES ('site','Site'), ('breast progression','Breast Progression');

-- Other cancer

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'other cancer', 1, 'qbcf_dx_other_cancers', 'qbcf_dx_other_cancers', 0, 'other cancer', 0);
  						
CREATE TABLE IF NOT EXISTS `qbcf_dx_other_cancers` (
  `site` varchar(250) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_dx_other_cancers_revs` (
  `site` varchar(250) DEFAULT NULL,
  `diagnosis_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_dx_other_cancers`
  ADD CONSTRAINT `qbcf_dx_other_cancers_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);
INSERT INTO i18n(id,en) VALUES ('other cancer','Other Cancer');

INSERT INTO structures(`alias`) VALUES ('qbcf_dx_other_cancers');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qbcf_dx_other_cancers', 'site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_dx_other_cancers'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '9', '', '0', '1', 'age at time of intervention', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_dx_other_cancers'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_other_cancers' AND `field`='site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_other_cancers' AND `field`='site'), 'notEmpty', '');

UPDATE structure_value_domains_permissible_values SET flag_active = 0 
WHERE structure_value_domain_id = (select id from structure_value_domains where domain_name = 'ctrnet_submission_disease_site') 
AND structure_permissible_value_id = (select id from structure_permissible_values where value like 'breast - breast');

ALTER TABLE qbcf_dx_other_cancers CHANGE site disease_site  varchar(250) DEFAULT NULL;
ALTER TABLE qbcf_dx_other_cancers_revs CHANGE site disease_site  varchar(250) DEFAULT NULL;
UPDATE structure_fields SET field = 'disease_site' WHERE field = 'site' AND tablename = 'qbcf_dx_other_cancers';

-- Applied to all

UPDATE structure_formats 
SET `flag_search`='0', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model` LIKE 'Diagnosis%' AND `field` IN ('controls_type', 'dx_date'));
UPDATE structure_formats 
SET `flag_override_label` = '1', `language_label` = 'diagnosis', flag_override_tag = '1', language_tag = ''
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model` LIKE 'Diagnosis%' AND `field` IN ('controls_type'));
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_diagnosis'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_breast_progressions' AND `field`='site' AND `type`='select' ), '1', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_diagnosis'), 
(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qbcf_dx_other_cancers' AND `field`='disease_site' AND `type`='select' ), '1', '21', '', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster'))
AND (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection'));
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster'))
AND (id1 = (SELECT id FROM datamart_structures WHERE model = 'Participant') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant'));
UPDATE datamart_structure_functions SET flag_active = 1 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster') AND label = 'number of elements per participant';
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');

-- EventMaster
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/%';
UPDATE event_controls SET flag_active = 0;
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster');
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'EventMaster');

-- TreatmentMaster
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE treatment_controls SET flag_active = 0;
UPDATE treatment_extend_controls SET flag_active = 0;

INSERT INTO `treatment_extend_controls` (`id`, `detail_tablename`, `detail_form_alias`, `flag_active`, `type`, `databrowser_label`) VALUES
(null, 'qbcf_txe_chemos', 'qbcf_txe_chemos', 1, 'chemotherapy drug', 'chemotherapy drug'),
(null, 'qbcf_txe_hormonos', 'qbcf_txe_hormonos', 1, 'hormonotherapy drug', 'hormonotherapy drug'),
(null, 'qbcf_txe_immunos', 'qbcf_txe_immunos', 1, 'immunotherapy drug', 'immunotherapy drug'),
(null, 'qbcf_txe_bone_specifics', 'qbcf_txe_bone_specifics', 1, 'bone specific drug', 'bone specific drug');
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'chemotherapy', '', 1, 'qbcf_txd_chemos', 'qbcf_txd_chemos', 0, null, '', 'chemotherapy', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qbcf_txe_chemos'), 0, 1),
(null, 'hormonotherapy', '', 1, 'qbcf_txd_hormonos', 'qbcf_txd_hormonos', 0, null, '', 'hormonotherapy', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qbcf_txe_hormonos'), 0, 1),
(null, 'immunotherapy', '', 1, 'qbcf_txd_immunos', 'qbcf_txd_immunos', 0, null, '', 'immunotherapy', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qbcf_txe_immunos'), 0, 1),
(null, 'bone specific therapy', '', 1, 'qbcf_txd_bone_specifics', 'qbcf_txd_bone_specifics', 0, null, '', 'bone specific therapy', 0, (SELECT id FROM treatment_extend_controls WHERE detail_form_alias = 'qbcf_txe_bone_specifics'), 0, 1),
(null, 'radiotherapy', '', 1, 'qbcf_txd_radios', 'qbcf_txd_radios', 0, null, '', 'radiotherapy', 0, null, 1, 1);
INSERT INTO i18n (id,en)
VALUES 
('bone specific therapy','Bone Specific Therapy'),('hormonotherapy','Hormonotherapy'),('radiotherapy','Radiotherapy');
INSERT IGNORE INTO i18n (id,en)
VALUES 
('chemotherapy drug','Chemotherapy Drug'),('hormonotherapy drug','Hormonotherapy Drug'),('immunotherapy drug','Immunotherapy Drug'),('bone specific drug','Bone Specific Drug');

ALTER TABLE treatment_masters 
  ADD COLUMN qbcf_clinical_trial_protocol_number VARCHAR(100) DEFAULT NULL,
  ADD COLUMN  `qbcf_suspected_finish_date` TINYINT(1) DEFAULT '0';
ALTER TABLE treatment_masters_revs 
  ADD COLUMN qbcf_clinical_trial_protocol_number VARCHAR(100) DEFAULT NULL,
  ADD COLUMN  `qbcf_suspected_finish_date` TINYINT(1) DEFAULT '0';

-- chemos

CREATE TABLE IF NOT EXISTS `qbcf_txd_chemos` (
  `num_cycles` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_txd_chemos_revs` (
  `num_cycles` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_txd_chemos`
  ADD CONSTRAINT `qbcf_txd_chemos_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
CREATE TABLE IF NOT EXISTS `qbcf_txe_chemos` (
  `drug_id` int(11) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_txe_chemos_revs` (
  `drug_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_txe_chemos`
  ADD CONSTRAINT `FK_qbcf_txe_chemos_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`),
  ADD CONSTRAINT `FK_qbcf_txe_chemos_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);
INSERT INTO structures(`alias`) VALUES ('qbcf_txd_chemos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_chemos', 'num_cycles', 'integer_positive',  NULL , '0', 'size=5', '', 'help_num_cycles', 'number cycles', ''), 
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'qbcf_clinical_trial_protocol_number', 'input',  NULL , '0', '', '', '', 'protocol', ''), 
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'qbcf_suspected_finish_date', 'checkbox',  NULL , '0', '', '', '', 'suspected finish date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_chemos' AND `field`='num_cycles' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_num_cycles' AND `language_label`='number cycles' AND `language_tag`=''), '2', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qbcf_clinical_trial_protocol_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qbcf_suspected_finish_date'), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUEs ('suspected finish date','Finish Date (suspected)');
INSERT INTO structures(`alias`) VALUES ('qbcf_txe_chemos');
INSERT INTO structure_value_domains (domain_name, source) VALUES ('qbcf_chemo_drug_list', 'Drug.Drug::getChemoDrugPermissibleValues');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'qbcf_txe_chemos', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list') , '0', '', '', 'help_drug_id', 'drug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txe_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_chemos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_chemo_drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_chemos' AND `field`='drug_id'), 'notEmpty', '');

-- hormonos

CREATE TABLE IF NOT EXISTS `qbcf_txd_hormonos` (
  `num_cycles` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_txd_hormonos_revs` (
  `num_cycles` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_txd_hormonos`
  ADD CONSTRAINT `qbcf_txd_hormonos_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
CREATE TABLE IF NOT EXISTS `qbcf_txe_hormonos` (
  `drug_id` int(11) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_txe_hormonos_revs` (
  `drug_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_txe_hormonos`
  ADD CONSTRAINT `FK_qbcf_txe_hormonos_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`),
  ADD CONSTRAINT `FK_qbcf_txe_hormonos_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);
INSERT INTO structures(`alias`) VALUES ('qbcf_txd_hormonos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_hormonos', 'num_cycles', 'integer_positive',  NULL , '0', 'size=5', '', 'help_num_cycles', 'number cycles', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_hormonos' AND `field`='num_cycles' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_num_cycles' AND `language_label`='number cycles' AND `language_tag`=''), '2', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qbcf_clinical_trial_protocol_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qbcf_suspected_finish_date'), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structures(`alias`) VALUES ('qbcf_txe_hormonos');
INSERT INTO structure_value_domains (domain_name, source) VALUES ('qbcf_hormono_drug_list', 'Drug.Drug::getHormonoDrugPermissibleValues');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'qbcf_txe_hormonos', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_hormono_drug_list') , '0', '', '', 'help_drug_id', 'drug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_hormonos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_hormono_drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_hormonos' AND `field`='drug_id'), 'notEmpty', '');

-- immunos

CREATE TABLE IF NOT EXISTS `qbcf_txd_immunos` (
  `num_cycles` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_txd_immunos_revs` (
  `num_cycles` int(11) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_txd_immunos`
  ADD CONSTRAINT `qbcf_txd_immunos_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
CREATE TABLE IF NOT EXISTS `qbcf_txe_immunos` (
  `drug_id` int(11) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_txe_immunos_revs` (
  `drug_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_txe_immunos`
  ADD CONSTRAINT `FK_qbcf_txe_immunos_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`),
  ADD CONSTRAINT `FK_qbcf_txe_immunos_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);
INSERT INTO structures(`alias`) VALUES ('qbcf_txd_immunos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_immunos', 'num_cycles', 'integer_positive',  NULL , '0', 'size=5', '', 'help_num_cycles', 'number cycles', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_immunos' AND `field`='num_cycles' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='help_num_cycles' AND `language_label`='number cycles' AND `language_tag`=''), '2', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qbcf_clinical_trial_protocol_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qbcf_suspected_finish_date'), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structures(`alias`) VALUES ('qbcf_txe_immunos');
INSERT INTO structure_value_domains (domain_name, source) VALUES ('qbcf_immuno_drug_list', 'Drug.Drug::getImmunoDrugPermissibleValues');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'qbcf_txe_immunos', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_immuno_drug_list') , '0', '', '', 'help_drug_id', 'drug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txe_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_immunos' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_immuno_drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_immunos' AND `field`='drug_id'), 'notEmpty', '');

-- bone specific

CREATE TABLE IF NOT EXISTS `qbcf_txd_bone_specifics` (
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_txd_bone_specifics_revs` (
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_txd_bone_specifics`
  ADD CONSTRAINT `qbcf_txd_bone_specifics_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
CREATE TABLE IF NOT EXISTS `qbcf_txe_bone_specifics` (
  `drug_id` int(11) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_txe_bone_specifics_revs` (
  `drug_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_txe_bone_specifics`
  ADD CONSTRAINT `FK_qbcf_txe_bone_specifics_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`),
  ADD CONSTRAINT `FK_qbcf_txe_bone_specifics_drugs` FOREIGN KEY (`drug_id`) REFERENCES `drugs` (`id`);
INSERT INTO structures(`alias`) VALUES ('qbcf_txd_bone_specifics');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txd_bone_specifics'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_bone_specifics'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_bone_specifics'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qbcf_clinical_trial_protocol_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_bone_specifics'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qbcf_suspected_finish_date'), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structures(`alias`) VALUES ('qbcf_txe_bone_specifics');
INSERT INTO structure_value_domains (domain_name, source) VALUES ('qbcf_bone_specific_drug_list', 'Drug.Drug::getBoneSpecificDrugPermissibleValues');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'qbcf_txe_bone_specifics', 'drug_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_bone_specific_drug_list') , '0', '', '', 'help_drug_id', 'drug', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txe_bone_specifics'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_bone_specifics' AND `field`='drug_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_bone_specific_drug_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_drug_id' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='qbcf_txe_bone_specifics' AND `field`='drug_id'), 'notEmpty', '');

-- Add unknown cycle number unknown

ALTER TABLE `qbcf_txd_chemos` ADD COLUMN `num_cycles_integer_unknown` char(1) DEFAULT '';
ALTER TABLE `qbcf_txd_chemos_revs` ADD COLUMN `num_cycles_integer_unknown` char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_chemos', 'num_cycles_integer_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_chemos' AND `field`='num_cycles_integer_unknown'), '2', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

ALTER TABLE `qbcf_txd_hormonos` ADD COLUMN `num_cycles_integer_unknown` char(1) DEFAULT '';
ALTER TABLE `qbcf_txd_hormonos_revs` ADD COLUMN `num_cycles_integer_unknown` char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_hormonos', 'num_cycles_integer_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_hormonos' AND `field`='num_cycles_integer_unknown'), '2', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

ALTER TABLE `qbcf_txd_immunos` ADD COLUMN `num_cycles_integer_unknown` char(1) DEFAULT '';
ALTER TABLE `qbcf_txd_immunos_revs` ADD COLUMN `num_cycles_integer_unknown` char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_immunos', 'num_cycles_integer_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_immunos' AND `field`='num_cycles_integer_unknown'), '2', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

-- disease_site

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');

-- radiotherpay

CREATE TABLE IF NOT EXISTS `qbcf_txd_radios` (
  `type` varchar(50) DEFAULT NULL,
  `num_cycles_conventional` int(5) DEFAULT NULL,
  `num_cycles_conventional_integer_unknown` char(1) DEFAULT '',
  `dose_conventional` decimal(8,2) DEFAULT NULL,
  `dose_conventional_decimal_unknown` char(1) DEFAULT '',
  `num_cycles_boost` int(5) DEFAULT NULL,
  `num_cycles_boost_integer_unknown` char(1) DEFAULT '',
  `dose_boost` decimal(8,2) DEFAULT NULL,
  `dose_boost_decimal_unknown` char(1) DEFAULT '',
  `num_cycles_brachytherapy` int(5) DEFAULT NULL,
  `num_cycles_brachytherapy_integer_unknown` char(1) DEFAULT '',
  `dose_brachytherapy` decimal(8,2) DEFAULT NULL,
  `dose_brachytherapy_decimal_unknown` char(1) DEFAULT '',
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_txd_radios_revs` (
  `type` varchar(50) DEFAULT NULL,
  `num_cycles_conventional` int(5) DEFAULT NULL,
  `num_cycles_conventional_integer_unknown` char(1) DEFAULT '',
  `dose_conventional` decimal(8,2) DEFAULT NULL,
  `dose_conventional_decimal_unknown` char(1) DEFAULT '',
  `num_cycles_boost` int(5) DEFAULT NULL,
  `num_cycles_boost_integer_unknown` char(1) DEFAULT '',
  `dose_boost` decimal(8,2) DEFAULT NULL,
  `dose_boost_decimal_unknown` char(1) DEFAULT '',
  `num_cycles_brachytherapy` int(5) DEFAULT NULL,
  `num_cycles_brachytherapy_integer_unknown` char(1) DEFAULT '',
  `dose_brachytherapy` decimal(8,2) DEFAULT NULL,
  `dose_brachytherapy_decimal_unknown` char(1) DEFAULT '',
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_txd_radios`
  ADD CONSTRAINT `qbcf_txd_radios_ibfk_2` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('qbcf_txd_radios');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_txd_radio_types', "StructurePermissibleValuesCustom::getCustomDropdown('Tx : Radiotherapy Types')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Tx : Radiotherapy Types', 1, 50, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tx : Radiotherapy Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('neo-adjuvant', 'Neo-Adjuvant',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('adjuvant', 'Adjuvant',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('palliative', 'Palliative',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown', 'Unknown',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_txd_radio_types') , '0', '', '', '', 'type', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'num_cycles_conventional', 'integer_positive',  NULL , '0', 'size=3', '', '', 'conventional', 'number of cycles'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'num_cycles_conventional_integer_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'dose_conventional', 'float_positive',  NULL , '0', 'size=3', '', '', '', 'dose'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'dose_conventional_decimal_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'num_cycles_boost', 'integer_positive',  NULL , '0', 'size=3', '', '', 'boost', 'number of cycles'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'num_cycles_boost_integer_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'dose_boost', 'float_positive',  NULL , '0', 'size=3', '', '', '', 'dose'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'dose_boost_decimal_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'num_cycles_brachytherapy', 'integer_positive',  NULL , '0', 'size=3', '', '', 'brachytherapy', 'number of cycles'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'num_cycles_brachytherapy_integer_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', ''),
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'dose_brachytherapy', 'float_positive',  NULL , '0', 'size=3', '', '', '', 'dose'),
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_radios', 'dose_brachytherapy_decimal_unknown', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_integer_unknown') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_txd_radio_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='num_cycles_conventional' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='conventional' AND `language_tag`='number of cycles'), '1', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='num_cycles_conventional_integer_unknown'), '1', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='dose_conventional' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='dose'), '1', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='dose_conventional_decimal_unknown'), '1', '23', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='num_cycles_boost' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='boost' AND `language_tag`='number of cycles'), '1', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='num_cycles_boost_integer_unknown'), '1', '31', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='dose_boost' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='dose'), '1', '32', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='dose_boost_decimal_unknown'), '1', '33', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='num_cycles_brachytherapy' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='brachytherapy' AND `language_tag`='number of cycles'), '1', '40', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='num_cycles_brachytherapy_integer_unknown'), '1', '41', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='dose_brachytherapy' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='dose'), '1', '42', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='qbcf_txd_radios'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_radios' AND `field`='dose_brachytherapy_decimal_unknown'), '1', '43', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en)
VALUES
('conventional', 'Conventional'),
('boost', 'Boost'),
('number of cycles', 'Nbr of Cycles');

-- other cancer treatment

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'other cancer', '', 1, 'qbcf_txd_other_cancers', 'qbcf_txd_other_cancers', 0, null, '', 'other cancer', 0, null, 1, 1);

CREATE TABLE IF NOT EXISTS `qbcf_txd_other_cancers` (
  `cancer_site` varchar(250) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qbcf_txd_other_cancers_revs` (
  `cancer_site` varchar(250) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qbcf_txd_other_cancers`
  ADD CONSTRAINT `qbcf_txd_other_cancers_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('qbcf_txd_other_cancers');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_txd_other_cancer_treatments', "StructurePermissibleValuesCustom::getCustomDropdown('Tx : Other Cancer Treatment')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Tx : Other Cancer Treatment', 1, 100, 'clinical - treatment');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tx : Other Cancer Treatment');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('surgery', 'Surgery',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('radiation', 'Radiation',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('hormonotherapy', 'Hormonotherapy',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('chemotherapy', 'Chemotherapy',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('immunotherapy', 'Immunotherapy',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_other_cancers', 'cancer', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') , '0', '', '', '', 'cancer', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qbcf_txd_other_cancers', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_txd_other_cancer_treatments') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qbcf_txd_other_cancers'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_other_cancers'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_other_cancers'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_other_cancers' AND `field`='cancer' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cancer' AND `language_tag`=''), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qbcf_txd_other_cancers'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_other_cancers' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_txd_other_cancer_treatments')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qbcf_txd_other_cancers');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_other_cancers' AND `field`='cancer'), 'notEmpty', ''),
((SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qbcf_txd_other_cancers' AND `field`='type'), 'notEmpty', '');
INSERT IGNORE INTO i18n (id,en) VALUES ('other cancer','Other Cancer'),('cancer','Cancer');
UPDATE structure_fields SET field = 'cancer_site' WHERE field = 'cancer' AND tablename = 'qbcf_txd_other_cancers';

-- Chronology
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='chronology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='custom' AND `tablename`='' AND `field`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tool
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Standard Operating Procedures
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Sop/%';

-- Protocols
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Protocol/%';
UPDATE protocol_controls SET flag_active = 0;

-- Drug
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("bone specific", "bone specific"),
("immunotherapy", "immunotherapy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="type"), 
(SELECT id FROM structure_permissible_values WHERE value="bone specific" AND language_alias="bone specific"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="type"), 
(SELECT id FROM structure_permissible_values WHERE value="immunotherapy" AND language_alias="immunotherapy"), "", "1");
UPDATE structure_value_domains_permissible_values 
SET flag_active = 0
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="type")
AND structure_permissible_value_id NOT IN (SELECT id FROM structure_permissible_values WHERE value IN ("immunotherapy", 'bone specific', 'chemotherapy', 'hormonal'));
INSERT INTO i18n (id,en) VALUES ('immunotherapy', 'Immunotherapy'),('bone specific', 'Bone Specific');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='type'), 'notEmpty', '');

-- Bank
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO i18n (id,en)
VALUES
('this bank is linked to at least one tissue and flagged as provider','This bank is linked to at least one tissue and flagged as provider'),
('at least one participant is linked to that bank','At least one participant is linked to that bank');
			
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inventory
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Clinical Collection Link
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='diagnosis', `flag_override_label`='1', `language_label`='diagnosis', `flag_override_tag`='0', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisControl' AND `tablename`='diagnosis_controls' AND `field`='controls_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='diagnosis_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');

-- Inventory Configuration
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 138, 203, 188, 142, 143, 141, 144, 192, 7, 130, 8, 9, 101, 102, 194, 140);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(10, 1);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(11, 46);

-- Collection
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr)
VALUES 
('independent collection', 'Collection of controls (Independent)', 'Collection de contrôles (indépendante)');
INSERT INTO i18n (id,en,fr)  
VALUES 
('no field has to be completed','No field has to be completed','Aucun champ ne doit être complété');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

-- Sample
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_laterality') AND `flag_confidential`='0');

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qbcf_tissue_natures', "StructurePermissibleValuesCustom::getCustomDropdown('Tissue Natures')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Tissue Natures', 1, 15, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue Natures');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('tumor', 'Tumor',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('adjacent normal', 'Adjacent Normal',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('inflammation', 'Inflammation',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleDetail', 'sd_spe_tissues', 'tissue_nature', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tissue_natures') , '0', '', '', '', 'nature', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sd_spe_tissues'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tissue_natures')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nature' AND `language_tag`=''), '1', '445', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_addgrid`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') AND `flag_confidential`='0');
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Tissue Sources')", `override`="" WHERE domain_name='tissue_source_list';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Tissue Sources', 1, 50, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue Sources');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('breast', 'Breast',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('ovary', 'Ovary',  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO i18n (id,en) VALUES ('tissue source of a participant tissue should be a breast','Tissue source of a participant tissue should be a breast');

-- Add control infromation

ALTER TABLE sample_masters 
  ADD COLUMN qbcf_is_tma_sample_control char(1) default 'n',
  ADD COLUMN qbcf_tma_sample_control_code varchar(50);
ALTER TABLE sample_masters_revs 
  ADD COLUMN qbcf_is_tma_sample_control char(1) default 'n',
  ADD COLUMN qbcf_tma_sample_control_code varchar(50);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'SampleMaster', 'sample_masters', 'qbcf_is_tma_sample_control', 'yes_no',  NULL , '0', '', '', '', 'control', ''), 
('InventoryManagement', 'SampleMaster', 'sample_masters', 'qbcf_tma_sample_control_code', 'input',  NULL , '0', 'size=20', '', '', 'control name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qbcf_is_tma_sample_control'), '1', '700', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qbcf_tma_sample_control_code'), '1', '701', 'control details', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en)  
VALUES 
('bank of the control', 'Provider'),
('control name','Code'), 
('control details', 'Control Details (If applicable)'),
('control', 'Control'),
('the code of a control is required','The code of a control is required'),
('no control data has to be set for a participant tissue','No control data has to be set for a participant tissue');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qbcf_is_tma_sample_control' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qbcf_tma_sample_control_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- View update : sample_masters_for_collection_tree_view

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='blood_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_nature'), '0', '1', '', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='qbcf_tma_sample_control_code'), '0', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list')  AND `flag_confidential`='0'), '0', '0', '', '', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');

-- View update : view_sample_joined_to_collection

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'qbcf_is_tma_sample_control', 'yes_no',  NULL , '0', '', '', '', 'control', ''), 
('InventoryManagement', 'ViewSample', '', 'qbcf_tma_sample_control_code', 'input',  NULL , '0', 'size=20', '', '', 'control name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qbcf_is_tma_sample_control'), '1', '1000', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='qbcf_tma_sample_control_code'), '1', '1001', 'control details', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='parent_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='parent_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Aliquot
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n(id,en) VALUES ('aliquot barcode', 'Aliquot QBCF#');
REPLACE INTO i18n (id,en) VALUES ('aliquot label','Aliquot Bank Label');
UPDATE structure_fields SET language_label = 'aliquot barcode' WHERE field = 'barcode' and model like '%aliqu%' AND language_label = 'barcode';
UPDATE structure_fields SET language_tag = 'aliquot barcode' WHERE field = 'barcode' and model like '%aliqu%' AND language_tag = 'barcode';

UPDATE structure_formats SET `flag_add`='0', `flag_addgrid`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquot_without_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoted_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

-- aliquot_masters

UPDATE structure_formats SET `display_order`='98', `flag_add`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='aliquot_label'), 'notEmpty', '');

-- block

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '99', '', '', '1', 'block id', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0');

-- core

ALTER TABLE ad_tissue_cores 
	ADD COLUMN `qbcf_core_nature_site` varchar(50) NOT NULL DEFAULT '',
	ADD COLUMN `qbcf_core_nature_revised` varchar(50) NOT NULL DEFAULT '',
	ADD COLUMN `qbcf_core_nature_precision` varchar(100) NOT NULL DEFAULT '';
ALTER TABLE ad_tissue_cores_revs
	ADD COLUMN `qbcf_core_nature_site` varchar(50) NOT NULL DEFAULT '',
	ADD COLUMN `qbcf_core_nature_revised` varchar(50) NOT NULL DEFAULT '',
	ADD COLUMN `qbcf_core_nature_precision` varchar(100) NOT NULL DEFAULT '';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue Natures');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("uninformative", "Uninformative",  '', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', '', 'qbcf_core_nature_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tissue_natures') , '0', '', '', '', 'nature - site', ''), 
('InventoryManagement', 'AliquotDetail', '', 'qbcf_core_nature_revised', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tissue_natures') , '0', '', '', '', 'nature - revised', ''), 
('InventoryManagement', 'AliquotDetail', '', 'qbcf_core_nature_precision', 'input',  NULL , '0', '', '', '', 'precision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qbcf_core_nature_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tissue_natures')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nature - site' AND `language_tag`=''), '1', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qbcf_core_nature_revised' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qbcf_tissue_natures')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nature - revised' AND `language_tag`=''), '1', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='qbcf_core_nature_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '1', '73', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO i18n (id,en) 
VALUES
('nature - site', 'Nature - Site'),
('nature - revised', 'Nature - Revised'),
('uninformative','Uninformative');

-- View

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='parent_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='parent_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='temperature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='temp_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'qbcf_bank_participant_identifier', 'input',  NULL , '0', 'size=20', '', '', 'bank patient #', ''), 
('InventoryManagement', 'ViewAliquot', '', 'qbcf_is_tma_sample_control', 'yes_no',  NULL , '0', '', '', '', 'control', ''), 
('InventoryManagement', 'ViewAliquot', '', 'qbcf_tma_sample_control_code', 'input',  NULL , '0', 'size=20', '', '', 'control name', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qbcf_bank_participant_identifier' ), '0', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qbcf_is_tma_sample_control'), '0', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='qbcf_tma_sample_control_code'), '1', '1001', 'control details', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_value_domains (domain_name, source) VALUES ('qbcf_banks_for_controls', 'Administrate.Bank::getBankPermissibleValuesForControls');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type') AND `flag_confidential`='0');

-- Use

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') ,  `language_label`='' WHERE model='ViewAliquotUse' AND tablename='view_aliquot_uses' AND field='aliquot_volume_unit' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='use_details' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='used_volume' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='aliquot_volume_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_volume_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='used_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='duration' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='duration_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='duration_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='viewaliquotuses') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquotUse' AND `tablename`='view_aliquot_uses' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list_for_view') AND `flag_confidential`='0');

-- Quality Ctrl
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/InventoryManagement/QualityCtrls%';
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl');
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id = (SELECT id FROM datamart_structures WHERE model = 'QualityCtrl');

-- Path Review
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE specimen_review_controls SET flag_active = 0;
UPDATE aliquot_review_controls SET flag_active = 0;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Study
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Study/%';
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/Study/StudySummaries%';
REPLACE INTO i18n (id,en,fr) VALUES ('study_title','Study/Biomarker Name','');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Storage
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE storage_controls SET flag_active = 0 WHERE storage_type NOT IN ('box');

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'TMA-blc 29X29', 'column', 'integer', 29, 'row', 'integer', 29, 0, 0, 0, 0, 0, 0, 1, 1, 'std_tma_blocks', 'std_tma_blocks', 'custom#storage types#TMA-blc 29X29', 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types ');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('TMA-blc 29X29', 'TMA-block 29X29',  'TMA-bloc 29X29', '1', @control_id, NOW(), NOW(), 1, 1);

ALTER TABLE storage_masters  
  MODIFY short_label varchar(50) DEFAULT NULL,
  MODIFY selection_label varchar(110) DEFAULT NULL;
ALTER TABLE storage_masters_revs
  MODIFY short_label varchar(50) DEFAULT NULL,
  MODIFY selection_label varchar(110) DEFAULT NULL;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageDetail' AND `tablename`='std_tma_blocks' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_sop_list') AND `flag_confidential`='0');
