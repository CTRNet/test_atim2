UPDATE users SET flag_active = '1', `password` = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979', username = 'NicoEn' WHERE id = '1';
INSERT INTO i18n (id,en,fr) VALUES ('core_installname','QBCF-TFRI','QBCF-TFRI');

DELETE FROM banks;
INSERT INTO banks (id,name) VALUES (1,'CHUM-? #1'), (2,'CHUQ-? #2');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Clinical Annotation
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- mysql -u root tfriqbcf --default-character-set=utf8 < atim_v2.6.0_full_installation.sql
-- mysql -u root tfriqbcf --default-character-set=utf8 < atim_v2.6.1_upgrade.sql
-- mysql -u root tfriqbcf --default-character-set=utf8 < atim_v2.6.2_upgrade.sql
-- mysql -u root tfriqbcf --default-character-set=utf8 < atim_v2.6.3_upgrade.sql
-- mysql -u root tfriqbcf --default-character-set=utf8 < atim_v2.6.4_upgrade.sql
-- mysql -u root tfriqbcf --default-character-set=utf8 < atim_v2.6.5_upgrade.sql
-- mysql -u root tfriqbcf --default-character-set=utf8 < atim_v2.6.6_upgrade.sql

-- Participants
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `field` IN ('notes','vital_status','date_of_birth','date_of_death','participant_identifier','created','ids','last_modification'));

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE `participants` 
  ADD COLUMN `qc_tf_qbcf_bank_id` int(11) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_bank_participant_identifier` varchar(50) NOT NULL DEFAULT '',
  ADD COLUMN `qc_tf_qbcf_suspected_date_of_death` date DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_suspected_date_of_death_accuracy` char(1) DEFAULT '',
  ADD COLUMN `qc_tf_qbcf_last_contact` date DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_last_contact_accuracy` char(1) DEFAULT '',
  ADD COLUMN `qc_tf_qbcf_breast_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_ovarian_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_other_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_breast_cancer_previous_hist` varchar(50) DEFAULT NULL;
ALTER TABLE `participants_revs` 
  ADD COLUMN `qc_tf_qbcf_bank_id` int(11) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_bank_participant_identifier` varchar(50) NOT NULL DEFAULT '',
  ADD COLUMN `qc_tf_qbcf_suspected_date_of_death` date DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_suspected_date_of_death_accuracy` char(1) DEFAULT '',
  ADD COLUMN `qc_tf_qbcf_last_contact` date DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_last_contact_accuracy` char(1) DEFAULT '',
  ADD COLUMN `qc_tf_qbcf_breast_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_ovarian_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_other_cancer_fam_hist` varchar(50) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_breast_cancer_previous_hist` varchar(50) DEFAULT NULL;
ALTER TABLE `participants`
  ADD CONSTRAINT `FK_participants_banks` FOREIGN KEY (`qc_tf_qbcf_bank_id`) REFERENCES `banks` (`id`);
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_tf_qbcf_yes_no_unk", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_qbcf_yes_no_unk"), (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_qbcf_yes_no_unk"), (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_qbcf_yes_no_unk"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_suspected_date_of_death', 'date',  NULL , '0', '', '', '', 'supected date of death', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_last_contact', 'date',  NULL , '0', '', '', '', 'last contact', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_breast_cancer_fam_hist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk') , '0', '', '', '', 'family history of breast cancer', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_ovarian_cancer_fam_hist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk') , '0', '', '', '', 'family history of ovarian cancer', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_other_cancer_fam_hist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk') , '0', '', '', '', 'family history of other cancer', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_breast_cancer_previous_hist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk') , '0', '', '', '', 'previous history of breast disease', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_suspected_date_of_death' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='supected date of death' AND `language_tag`=''), '3', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_last_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last contact' AND `language_tag`=''), '3', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_breast_cancer_fam_hist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='family history of breast cancer' AND `language_tag`=''), '3', '10', 'cancer history', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_ovarian_cancer_fam_hist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='family history of ovarian cancer' AND `language_tag`=''), '3', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_other_cancer_fam_hist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='family history of other cancer' AND `language_tag`=''), '3', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_breast_cancer_previous_hist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='previous history of breast disease' AND `language_tag`=''), '3', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
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
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_bank_id', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='banks') , '0', '', '', '', 'bank', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_bank_participant_identifier', 'input',  NULL , '0', 'size=20', '', '', 'bank patient #', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bank' AND `language_tag`=''), '1', '0', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_bank_participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='bank patient #' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='qc_tf_qbcf_bank_id'), 'notEmpty', ''),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `field`='qc_tf_qbcf_bank_participant_identifier'), 'notEmpty', '');
REPLACE INTO i18n (id,en) VALUES ('participant identifier','ATiM Participant #');
INSERT INTO i18n (id,en) VALUES
('this bank participant identifier has already been assigned to a patient of this bank', 'This bank participant identifier has already been assigned to a patient of this bank'),
('your search will be limited to your bank', 'Your search will be limited to your bank');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_tf_qbcf_breast_cancer_previous_hist', "StructurePermissibleValuesCustom::getCustomDropdown('Breast Cancer Previous History')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Breast Cancer Previous History', 1, 50, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Breast Cancer Previous History');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('yes, invasive', 'Yes, invasive',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('yes, non invasive', 'Yes, non invasive',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('yes, LCIS / lobular neoplasia', 'Yes, LCIS / lobular neoplasia',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('no', 'No',  '', '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_breast_cancer_previous_hist')  WHERE model='Participant' AND tablename='participants' AND field='qc_tf_qbcf_breast_cancer_previous_hist' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk');

ALTER TABLE `participants` 
  ADD COLUMN `qc_tf_qbcf_gravida` int(3) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_para` int(3) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_aborta` int(3) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_menopause` varchar(50) DEFAULT NULL;
ALTER TABLE `participants_revs` 
  ADD COLUMN `qc_tf_qbcf_gravida` int(3) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_para` int(3) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_aborta` int(3) DEFAULT NULL,
  ADD COLUMN `qc_tf_qbcf_menopause` varchar(50) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_gravida', 'integer_positive',  NULL , '0', 'size=3', '', '', 'gravida', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_para', 'integer_positive',  NULL , '0', 'size=3', '', '', 'para', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_aborta', 'integer_positive',  NULL , '0', 'size=3', '', '', 'aborta', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_menopause', 'integer_positive', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk') , '0', 'size=3', '', '', 'menopause', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_gravida' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='gravida' AND `language_tag`=''), '4', '70', 'reproductive history', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_para' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='para' AND `language_tag`=''), '4', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_aborta' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='aborta' AND `language_tag`=''), '4', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_menopause' AND `type`='integer_positive' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk')  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='menopause' AND `language_tag`=''), '4', '73', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('aborta', 'Aborta'),('menopause', 'Menopause');
 UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk') ,  `setting`='' WHERE model='Participant' AND tablename='participants' AND field='qc_tf_qbcf_menopause' AND `type`='integer_positive' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_yes_no_unk');
 
UPDATE structure_formats SET `display_column`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_modification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

ALTER TABLE `participants` 
  ADD COLUMN `qc_tf_qbcf_gravida_unknown` tinyint(1) NOT NULL DEFAULT '0',
  ADD COLUMN `qc_tf_qbcf_para_unknown` tinyint(1) NOT NULL DEFAULT '0',
  ADD COLUMN `qc_tf_qbcf_aborta_unknown` tinyint(1) NOT NULL DEFAULT '0';
ALTER TABLE `participants_revs` 
  ADD COLUMN `qc_tf_qbcf_gravida_unknown` tinyint(1) NOT NULL DEFAULT '0',
  ADD COLUMN `qc_tf_qbcf_para_unknown` tinyint(1) NOT NULL DEFAULT '0',
  ADD COLUMN `qc_tf_qbcf_aborta_unknown` tinyint(1) NOT NULL DEFAULT '0';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_gravida_unknown', 'checkbox',  NULL , '0', '', '', '', '', 'unknown'), 
('ClinicalAnnotation', 'Participant', 'participants', 'qc_tf_qbcf_para_unknown', 'checkbox',  NULL , '0', '', '', '', '', 'unknown'), 
('ClinicalAnnotation', 'Participant', '', 'qc_tf_qbcf_aborta_unknown', 'checkbox',  NULL , '0', '', '', '', '', 'unknown');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_gravida_unknown' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='unknown'), '4', '70', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_qbcf_para_unknown' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='unknown'), '4', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='' AND `field`='qc_tf_qbcf_aborta_unknown' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='unknown'), '4', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Diagnosis
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE diagnosis_controls SET flag_active = 0;
UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters/%';

-- Treatment
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE treatment_controls SET flag_active = 0;

-- Dx Treatment

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'qbcf diagnosis event', '', 1, 'qc_tf_qbcf_txd_diag_events', 'qc_tf_qbcf_txd_diag_events', 0, NULL, NULL, 'all|qbcf diagnosis event', 1, NULL, 0, 1);
CREATE TABLE IF NOT EXISTS `qc_tf_qbcf_txd_diag_events` (
  `type_of_intervention` varchar(50) DEFAULT NULL,
  `to_chum_for_tma_construction` tinyint(1) DEFAULT '0',
  `laterality` varchar(50) DEFAULT NULL,
  `clinical_anatomic_stage` varchar(50) DEFAULT NULL,
  `tnm_ct` varchar(50) DEFAULT NULL,
  `tnm_cn` varchar(50) DEFAULT NULL,
  `tnm_cm` varchar(50) DEFAULT NULL,
  `pathological_anatomic_stage` varchar(50) DEFAULT NULL,
  `tnm_pt` varchar(50) DEFAULT NULL,
  `tnm_pn` varchar(50) DEFAULT NULL,
  `tnm_pm` varchar(50) DEFAULT NULL,
  `morphology` varchar(250) DEFAULT NULL,
  `grade_notthingham_sbr_ee` varchar(50) DEFAULT NULL,
  `glandular_acinar_tubular_differentiation` varchar(50) DEFAULT NULL,
  `nuclear_pleomorphism` varchar(50) DEFAULT NULL,
  `mitotic_rate` varchar(50) DEFAULT NULL,
  `tumor_size` decimal(8,1) DEFAULT NULL,
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
  `treatment_master_id` int(11) NOT NULL,
  KEY `tx_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `qc_tf_qbcf_txd_diag_events_revs` (
  `type_of_intervention` varchar(50) DEFAULT NULL,
  `to_chum_for_tma_construction` tinyint(1) DEFAULT '0',
  `laterality` varchar(50) DEFAULT NULL,
  `clinical_anatomic_stage` varchar(50) DEFAULT NULL,
  `tnm_ct` varchar(50) DEFAULT NULL,
  `tnm_cn` varchar(50) DEFAULT NULL,
  `tnm_cm` varchar(50) DEFAULT NULL,
  `pathological_anatomic_stage` varchar(50) DEFAULT NULL,
  `tnm_pt` varchar(50) DEFAULT NULL,
  `tnm_pn` varchar(50) DEFAULT NULL,
  `tnm_pm` varchar(50) DEFAULT NULL,
  `morphology` varchar(250) DEFAULT NULL,
  `grade_notthingham_sbr_ee` varchar(50) DEFAULT NULL,
  `glandular_acinar_tubular_differentiation` varchar(50) DEFAULT NULL,
  `nuclear_pleomorphism` varchar(50) DEFAULT NULL,
  `mitotic_rate` varchar(50) DEFAULT NULL,
  `tumor_size` decimal(8,1) DEFAULT NULL,
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
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `qc_tf_qbcf_txd_diag_events`
  ADD CONSTRAINT `qc_tf_qbcf_txd_diag_events_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('qc_tf_qbcf_type_of_intervention', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Type of intervention')"),
('qc_tf_qbcf_laterality', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Laterality  ')"),
('qc_tf_qbcf_clinical_anatomic_stage', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Clinical Anatomic Stage')"),
('qc_tf_qbcf_tnm_ct', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (cT)')"),
('qc_tf_qbcf_tnm_cn', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (cN)')"),
('qc_tf_qbcf_tnm_cm', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (cM)')"),
('qc_tf_qbcf_pathological_anatomic_stage', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Pathological Anatomic Stage')"),
('qc_tf_qbcf_tnm_pt', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (pT)')"),
('qc_tf_qbcf_tnm_pn', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (pN)')"),
('qc_tf_qbcf_tnm_pm', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNM (pM)')"),
('qc_tf_qbcf_morphology', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Morphology')"),
('qc_tf_qbcf_grade_notthingham_sbr_ee', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Grade Notthingham / SBR-EE')"),
('qc_tf_qbcf_glandular_acinar_tubular_differentiation', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Glandular (Acinar)/ Tubular Differentiation')"),
('qc_tf_qbcf_nuclear_pleomorphism', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Nuclear Pleomorphism')"),
('qc_tf_qbcf_mitotic_rate', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Mitotic Rate')"),
('qc_tf_qbcf_margin_status', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Margin Status')"),
('qc_tf_qbcf_number_of_positive_regional_ln_category', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Number of positive Regional LN (Category)')"),
('qc_tf_qbcf_number_of_positive_sentinel_ln_category', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Number of positive Sentinel LN (Category)')"),
('qc_tf_qbcf_er_overall', "StructurePermissibleValuesCustom::getCustomDropdown('DX : ER Overall  (From path report)')"),
('qc_tf_qbcf_er_intensity', "StructurePermissibleValuesCustom::getCustomDropdown('DX : ER Intensity')"),
('qc_tf_qbcf_pr_overall', "StructurePermissibleValuesCustom::getCustomDropdown('DX : PR Overall (in path report)')"),
('qc_tf_qbcf_pr_intensity', "StructurePermissibleValuesCustom::getCustomDropdown('DX : PR Intensity')"),
('qc_tf_qbcf_her2_ihc', "StructurePermissibleValuesCustom::getCustomDropdown('DX : HER2 IHC')"),
('qc_tf_qbcf_her2_fish', "StructurePermissibleValuesCustom::getCustomDropdown('DX : HER2 FISH ')"),
('qc_tf_qbcf_her_2_status', "StructurePermissibleValuesCustom::getCustomDropdown('DX : Her 2 Status')"),
('qc_tf_qbcf_tnbc', "StructurePermissibleValuesCustom::getCustomDropdown('DX : TNBC')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('DX : Type of intervention', 1, 50, 'clinical - treatment'),
('DX : Laterality  ', 1, 50, 'clinical - treatment'),
('DX : Clinical Anatomic Stage', 1, 50, 'clinical - treatment'),
('DX : TNM (cT)', 1, 50, 'clinical - treatment'),
('DX : TNM (cN)', 1, 50, 'clinical - treatment'),
('DX : TNM (cM)', 1, 50, 'clinical - treatment'),
('DX : Pathological Anatomic Stage', 1, 50, 'clinical - treatment'),
('DX : TNM (pT)', 1, 50, 'clinical - treatment'),
('DX : TNM (pN)', 1, 50, 'clinical - treatment'),
('DX : TNM (pM)', 1, 50, 'clinical - treatment'),
('DX : Morphology', 1, 250, 'clinical - treatment'),
('DX : Grade Notthingham / SBR-EE', 1, 50, 'clinical - treatment'),
('DX : Glandular (Acinar)/ Tubular Differentiation', 1, 50, 'clinical - treatment'),
('DX : Nuclear Pleomorphism', 1, 50, 'clinical - treatment'),
('DX : Mitotic Rate', 1, 50, 'clinical - treatment'),
('DX : Tumor size', 1, 50, 'clinical - treatment'),
('DX : Margin Status', 1, 50, 'clinical - treatment'),
('DX : Number of positive Regional LN (Category)', 1, 50, 'clinical - treatment'),
('DX : Number of positive Sentinel LN (Category)', 1, 50, 'clinical - treatment'),
('DX : ER Overall  (From path report)', 1, 50, 'clinical - treatment'),
('DX : ER Intensity', 1, 50, 'clinical - treatment'),
('DX : PR Overall (in path report)', 1, 50, 'clinical - treatment'),
('DX : PR Intensity', 1, 50, 'clinical - treatment'),
('DX : HER2 IHC', 1, 50, 'clinical - treatment'),
('DX : HER2 FISH ', 1, 50, 'clinical - treatment'),
('DX : Her 2 Status', 1, 50, 'clinical - treatment'),
('DX : TNBC', 1, 50, 'clinical - treatment');
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
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Laterality  ');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('left', 'Left',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('right', 'Right',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('bilateral', 'Bilateral',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Clinical Anatomic Stage');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('0', '0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
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
('iv', 'IV',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (cT)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('t1', 'T1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mi', 'mi',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1a', '1a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1b', '1b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1c', '1c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t2', 'T2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t3', 'T3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t4', 'T4',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (cN)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('n0', 'N0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1', 'N1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2', 'N2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('2a', '2a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('2b', '2b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3', 'N3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3a', '3a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3b', '3b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3c', '3c',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (cM)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('m0', 'M0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('cm0(i+)', 'cM0(I+)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('m1"', 'M1"',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Pathological Anatomic Stage');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('0', '0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
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
('iv', 'IV',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (pT)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('t1', 'T1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('mi', 'mi',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1a', '1a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1b', '1b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('1c', '1c',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t2', 'T2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t3', 'T3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('t4', 'T4',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (pN)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('n0', 'N0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n1', 'N1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n2', 'N2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('2a', '2a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('2b', '2b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('n3', 'N3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3a', '3a',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3b', '3b',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('3c', '3c',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : TNM (pM)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('m0', 'M0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('cm0(i+)', 'cM0(I+)',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('m1"', 'M1"',  '', '1', @control_id, NOW(), NOW(), 1, 1);
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
('score 1','Score 1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('score 2','Score 2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('score 3','Score 3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('u','U',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Glandular (Acinar)/ Tubular Differentiation');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('score 1','Score 1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('score 2','Score 2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('score 3','Score 3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('u','U',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Nuclear Pleomorphism');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('score 1','Score 1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('score 2','Score 2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('score 3','Score 3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('u','U',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Mitotic Rate');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('score 1','Score 1',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('score 2','Score 2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('score 3','Score 3',  '', '1', @control_id, NOW(), NOW(), 1, 1),
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
('-2','-2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('4+','4+',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('unknown','Unknown',  '', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'DX : Number of positive Sentinel LN (Category)');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('0','0',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('-2','-2',  '', '1', @control_id, NOW(), NOW(), 1, 1),
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

INSERT INTO structures(`alias`) VALUES ('qc_tf_qbcf_txd_diag_events');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'type_of_intervention', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_type_of_intervention') , '0', '', '', '', 'type of intervention', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'to_chum_for_tma_construction', 'checkbox',  NULL , '0', '', '', '', 'specimen sent to chum for tma construction', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_laterality') , '0', '', '', '', 'laterality', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'clinical_anatomic_stage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_clinical_anatomic_stage') , '0', '', '', '', 'clinical stage', 'summary'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'tnm_ct', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_ct') , '0', '', '', '', '', 't stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'tnm_cn', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_cn') , '0', '', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'tnm_cm', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_cm') , '0', '', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'pathological_anatomic_stage', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_pathological_anatomic_stage') , '0', '', '', '', 'pathological stage', 'summary'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'tnm_pt', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_pt') , '0', '', '', '', '', 't stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'tnm_pn', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_pn') , '0', '', '', '', '', 'n stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'tnm_pm', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_pm') , '0', '', '', '', '', 'm stage'), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'morphology', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_morphology') , '0', '', '', '', 'morphology', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'grade_notthingham_sbr_ee', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_grade_notthingham_sbr_ee') , '0', '', '', '', 'grade notthingham / sbr-ee', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'glandular_acinar_tubular_differentiation', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_glandular_acinar_tubular_differentiation') , '0', '', '', '', 'glandular (acinar)/ tubular differentiation', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'nuclear_pleomorphism', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_nuclear_pleomorphism') , '0', '', '', '', 'nuclear pleomorphism', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'mitotic_rate', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_mitotic_rate') , '0', '', '', '', 'mitotic rate', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'tumor_size', 'float_positive',  NULL , '0', '', '', '', 'tumor size (mm)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'margin_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_margin_status') , '0', '', '', '', 'margin status', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'number_of_positive_regional_ln', 'integer_positive',  NULL , '0', '', '', '', 'number of positive regional ln', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'total_number_of_regional_ln_analysed', 'integer_positive',  NULL , '0', '', '', '', 'total number of regional ln analysed', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'number_of_positive_regional_ln_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_number_of_positive_regional_ln_category') , '0', '', '', '', 'number of positive regional ln (category)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'number_of_positive_sentinel_ln', 'integer_positive',  NULL , '0', '', '', '', 'number of positive sentinel ln', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'total_number_of_sentinel_ln_analysed', 'integer_positive',  NULL , '0', '', '', '', 'total number of sentinel ln analysed', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'number_of_positive_sentinel_ln_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_number_of_positive_sentinel_ln_category') , '0', '', '', '', 'number of positive sentinel ln (category)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'er_overall', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_er_overall') , '0', '', '', '', 'er overall  (from path report)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'er_intensity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_er_intensity') , '0', '', '', '', 'er intensity', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'er_percent', 'float_positive',  NULL , '0', '', '', '', 'er percent', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'pr_overall', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_pr_overall') , '0', '', '', '', 'pr overall (in path report)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'pr_intensity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_pr_intensity') , '0', '', '', '', 'pr intensity', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'pr_percent', 'float_positive',  NULL , '0', '', '', '', 'pr percent', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'her2_ihc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_her2_ihc') , '0', '', '', '', 'her2 ihc', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'her2_fish', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_her2_fish') , '0', '', '', '', 'her2 fish', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'her_2_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_her_2_status') , '0', '', '', '', 'her 2 status', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'tnbc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnbc') , '0', '', '', '', 'tnbc', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='type_of_intervention' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_type_of_intervention')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type of intervention' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='to_chum_for_tma_construction' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen sent to chum for tma construction' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='laterality' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='clinical_anatomic_stage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_clinical_anatomic_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='clinical stage' AND `language_tag`='summary'), '1', '14', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='tnm_ct' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_ct')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='t stage'), '1', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='tnm_cn' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_cn')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '1', '16', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='tnm_cm' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_cm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '1', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='pathological_anatomic_stage' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_pathological_anatomic_stage')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathological stage' AND `language_tag`='summary'), '1', '18', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='tnm_pt' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_pt')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='t stage'), '1', '19', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='tnm_pn' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_pn')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='n stage'), '1', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='tnm_pm' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnm_pm')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='m stage'), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='morphology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_morphology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='morphology' AND `language_tag`=''), '3', '22', 'morphology', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='grade_notthingham_sbr_ee' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_grade_notthingham_sbr_ee')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='grade notthingham / sbr-ee' AND `language_tag`=''), '3', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='glandular_acinar_tubular_differentiation' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_glandular_acinar_tubular_differentiation')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='glandular (acinar)/ tubular differentiation' AND `language_tag`=''), '3', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='nuclear_pleomorphism' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_nuclear_pleomorphism')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nuclear pleomorphism' AND `language_tag`=''), '3', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='mitotic_rate' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_mitotic_rate')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mitotic rate' AND `language_tag`=''), '3', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='tumor_size' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor size (mm)' AND `language_tag`=''), '3', '27', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='margin_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_margin_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='margin status' AND `language_tag`=''), '3', '28', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='number_of_positive_regional_ln' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive regional ln' AND `language_tag`=''), '3', '29', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='total_number_of_regional_ln_analysed' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total number of regional ln analysed' AND `language_tag`=''), '3', '30', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='number_of_positive_regional_ln_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_number_of_positive_regional_ln_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive regional ln (category)' AND `language_tag`=''), '3', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='number_of_positive_sentinel_ln' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive sentinel ln' AND `language_tag`=''), '3', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='total_number_of_sentinel_ln_analysed' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total number of sentinel ln analysed' AND `language_tag`=''), '3', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='number_of_positive_sentinel_ln_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_number_of_positive_sentinel_ln_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='number of positive sentinel ln (category)' AND `language_tag`=''), '3', '34', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='er_overall' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_er_overall')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='er overall  (from path report)' AND `language_tag`=''), '4', '35', 'biomarkers', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='er_intensity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_er_intensity')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='er intensity' AND `language_tag`=''), '4', '36', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='er_percent' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='er percent' AND `language_tag`=''), '4', '37', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='pr_overall' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_pr_overall')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pr overall (in path report)' AND `language_tag`=''), '4', '38', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='pr_intensity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_pr_intensity')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pr intensity' AND `language_tag`=''), '4', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='pr_percent' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pr percent' AND `language_tag`=''), '4', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='her2_ihc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_her2_ihc')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her2 ihc' AND `language_tag`=''), '4', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='her2_fish' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_her2_fish')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her2 fish' AND `language_tag`=''), '4', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='her_2_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_her_2_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='her 2 status' AND `language_tag`=''), '4', '43', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='tnbc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_qbcf_tnbc')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tnbc' AND `language_tag`=''), '4', '44', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

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
("tnbc","TNBC");

ALTER TABLE qc_tf_qbcf_txd_diag_events ADD COLUMN age_at_time_of_intervention INT(3) DEFAULT NULL;
ALTER TABLE qc_tf_qbcf_txd_diag_events_revs ADD COLUMN age_at_time_of_intervention INT(3) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_qbcf_txd_diag_events', 'age_at_time_of_intervention', 'integer_positive',  NULL , '0', '', '', '', 'age at time of intervention', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_qbcf_txd_diag_events'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_qbcf_txd_diag_events' AND `field`='age_at_time_of_intervention' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='age at time of intervention' AND `language_tag`=''), '1', '9', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('age at time of intervention','Age at Time of Intervention');

INSERT INTO i18n (id,en) VALUES ('qbcf diagnosis event', 'Aspiration, Biopsy, etc');

INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `field`='type_of_intervention'), 'notEmpty', '')

-- Chemotherapy

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'qbcf diagnosis event', '', 1, 'qc_tf_qbcf_txd_diag_events', 'qc_tf_qbcf_txd_diag_events', 0, NULL, NULL, 'all|qbcf diagnosis event', 1, NULL, 0, 1);




























exit




ALTER TABLE treatment_masters
  ADD COLUMN qc_tf_qbcf_suspected tinyint(1) DEFAULT '0';
ALTER TABLE treatment_masters
  ADD COLUMN qc_tf_qbcf_suspected tinyint(1) DEFAULT '0';
  
  
   










-- All Other Sub-Modules That Should Be Hidden
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ConsentMasters/%';
UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories/%';
UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts/%';
UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages/%';
UPDATE menus SET flag_Active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories/%';











































UPDATE versions SET branch_build_number = '63..' WHERE version_number = '2.6.6';
