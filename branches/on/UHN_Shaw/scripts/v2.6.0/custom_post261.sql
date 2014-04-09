UPDATE users SET flag_active = 1 WHERE id = 1;

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='uhn_brca_result')  WHERE model='Participant' AND tablename='participants' AND field='uhn_brca_1_positif' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesnounknown');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='uhn_brca_result')  WHERE model='Participant' AND tablename='participants' AND field='uhn_brca_2_positif' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='yesnounknown');

DROP TABLE uhn_dxd_secondary_ovaries;
DELETE FROM diagnosis_controls WHERE detail_tablename LIKE 'uhn_dxd_secondary_ovaries';
DELETE FROM diagnosis_controls WHERE detail_form_alias LIKE 'uhn_dxd_secondary_others';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_dxd_secondary_others');
DELETE FROM structures WHERE alias='uhn_dxd_secondary_others';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_dxd_secondary_ovaries');
DELETE FROM structures WHERE alias='uhn_dxd_secondary_ovaries';
DELETE FROM diagnosis_controls WHERE detail_form_alias LIKE 'uhn_dxd_primary_ovaries' AND controls_type IN ('cervical', 'vulvar');
UPDATE diagnosis_controls SET flag_active = 0 WHERE category = 'recurrence';

UPDATE structure_fields SET `language_label`='histologic type 1' WHERE model='DiagnosisDetail' AND tablename='uhn_dxd_primary_ovaries' AND field='histologic_type_1' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_ovarian_diagnosis_histologic_type_1');
UPDATE structure_fields SET `language_tag`='histologic type 2' WHERE model='DiagnosisDetail' AND tablename='uhn_dxd_primary_ovaries' AND field='histologic_type_2' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_ovarian_diagnosis_histologic_type_2');
UPDATE structure_fields SET `language_tag`='histologic type precision' WHERE model='DiagnosisDetail' AND tablename='uhn_dxd_primary_ovaries' AND field='histologic_type_precision' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='uhn_ovarian_diagnosis_location') ,  `language_label`='diagnosis location' WHERE model='DiagnosisDetail' AND tablename='uhn_dxd_primary_ovaries' AND field='location' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_ovarian_diagnosis_location');
UPDATE structure_fields SET  `language_tag`='diagnosis location precision' WHERE model='DiagnosisDetail' AND tablename='uhn_dxd_primary_ovaries' AND field='location_precision' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE i18n SET id = 'histologic type 1' WHERE id LIKE '%histologic type 1';
UPDATE i18n SET id = 'histologic type 2' WHERE id LIKE '%histologic type 2';
UPDATE i18n SET id = 'histologic type precision' WHERE id LIKE '%histologic type precision';
UPDATE i18n SET id = 'diagnosis location' WHERE id LIKE '%diagnosis location';
UPDATE i18n SET id = 'diagnosis location precision' WHERE id LIKE '%diagnosis location precision';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Ovarian Histologic Type\')" WHERE domain_name = 'uhn_ovarian_diagnosis_histologic_type_1';
UPDATE structure_permissible_values_custom_controls SET name = 'Ovarian Histologic Type', category = 'clinical - diagnosis' WHERE name = 'Histologic Type';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Ovarian Diagnosis Method\')", domain_name = 'uhn_ovarian_diagnosis_method' WHERE domain_name = 'uhn_diagnosis_method';
UPDATE structure_permissible_values_custom_controls SET name = 'Ovarian Diagnosis Method', category = 'clinical - diagnosis' WHERE name = 'Diagnosis Method';
UPDATE structure_permissible_values_custom_controls SET name = 'Ovarian Histologic Type Precision', category = 'clinical - diagnosis' WHERE name = 'Histologic Type Precision';
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Ovarian Diagnosis Method');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id AND value LIKE '%biopsy%';
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('biopsy', 'Biopsy', '', '1', @control_id);
CREATE TABLE uhn_dxd_primary_ovaries_revs (
  diagnosis_master_id int(11) NOT NULL,
  laterality varchar(50) DEFAULT NULL,
  location varchar(50) DEFAULT NULL,
  location_precision varchar(250) DEFAULT NULL,
  histologic_type_1 varchar(100) DEFAULT NULL,
  histologic_type_2 varchar(100) DEFAULT NULL,
  histologic_type_precision varchar(250) DEFAULT NULL,
  figo varchar(10) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE uhn_dxd_primary_endometriums (
  diagnosis_master_id int(11) NOT NULL,
  laterality varchar(50) DEFAULT NULL,
  location varchar(50) DEFAULT NULL,
  location_precision varchar(250) DEFAULT NULL,
  histologic_type_1 varchar(100) DEFAULT NULL,
  histologic_type_2 varchar(100) DEFAULT NULL,
  histologic_type_precision varchar(250) DEFAULT NULL,
  figo varchar(10) DEFAULT NULL,
  KEY diagnosis_master_id (diagnosis_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE uhn_dxd_primary_endometriums_revs (
  diagnosis_master_id int(11) NOT NULL,
  laterality varchar(50) DEFAULT NULL,
  location varchar(50) DEFAULT NULL,
  location_precision varchar(250) DEFAULT NULL,
  histologic_type_1 varchar(100) DEFAULT NULL,
  histologic_type_2 varchar(100) DEFAULT NULL,
  histologic_type_precision varchar(250) DEFAULT NULL,
  figo varchar(10) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `uhn_dxd_primary_endometriums`
  ADD CONSTRAINT FK_uhn_dxd_primary_endometriums_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);
UPDATE diagnosis_controls SET detail_form_alias  = 'uhn_dxd_primary_endometriums', detail_tablename = 'uhn_dxd_primary_endometriums' WHERE controls_type = 'endometrium';

INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_endometrium_diagnosis_method", "StructurePermissibleValuesCustom::getCustomDropdown(\'Endometrium Diagnosis Method\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Endometrium Diagnosis Method', 'clinical - diagnosis', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Endometrium Diagnosis Method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('endometrial biopsy', 'Endometrial Biopsy', '', '1', @control_id);
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_endometrium_diagnosis_location", "StructurePermissibleValuesCustom::getCustomDropdown(\'Endometrium Diagnosis Location\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Endometrium Diagnosis Location', 'clinical - diagnosis', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Endometrium Diagnosis Location');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('germ cell', 'Germ Cell', '', '1', @control_id),
('epithelial', 'Epithelial', '', '1', @control_id),
('sexcord stromal', 'Sexcord Stromal', '', '1', @control_id),
('other', 'Other', '', '1', @control_id);
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_endometrium_diagnosis_histologic_type_1", "StructurePermissibleValuesCustom::getCustomDropdown(\'Endometrium Histologic Type\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Endometrium Histologic Type', 'clinical - diagnosis', 1, 100);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Endometrium Histologic Type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('benign', 'Benign', '', '1', @control_id),
('carcinoma', 'Carcinoma', '', '1', @control_id),
('hyperplasia no atypia', 'Hyperplasia no atypia', '', '1', @control_id),
('hyperplasia atypia', 'Hyperplasia atypia', '', '1', @control_id);
-- histologic_type_2
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_endometrium_diagnosis_histologic_type_2", "StructurePermissibleValuesCustom::getCustomDropdown(\'Endometrium Histologic Type Precision\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Endometrium Histologic Type Precision', 'clinical - diagnosis', 1, 100);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Endometrium Histologic Type Precision');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('low grade serous carcinoma', 'LGSC', '', '1', @control_id),
('high grade serous carcinoma', 'HGSC', '', '1', @control_id),
('mucinous', 'Mucinous', '', '1', @control_id),
('endometrioid', 'Endometrioid', '', '1', @control_id),
('clear cell', 'Clear cell', '', '1', @control_id),
('transitional cell', 'Transitional cell', '', '1', @control_id),
('undifferentiated', 'Undifferentiated', '', '1', @control_id),
('mixed', 'Mixed', '', '1', @control_id),
('MMMT', 'MMMT', '', '1', @control_id),
('brenner', 'Brenner', '', '1', @control_id),
('other', 'Other', '', '1', @control_id);
INSERT INTO structures(`alias`) VALUES ('uhn_dxd_primary_endometriums');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'dx_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_endometrium_diagnosis_method') , '0', '', '', 'help_dx method', 'dx_method', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_primary_ovaries', 'location', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_endometrium_diagnosis_location') , '0', '', '', '', 'diagnosis location', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_primary_ovaries', 'histologic_type_1', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_endometrium_diagnosis_histologic_type_1') , '0', '', '', '', 'histologic type 1', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_primary_ovaries', 'histologic_type_2', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_endometrium_diagnosis_histologic_type_2') , '0', '', '', '', '', 'histologic type 2');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_endometrium_diagnosis_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx method' AND `language_label`='dx_method' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='location' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_endometrium_diagnosis_location')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='diagnosis location' AND `language_tag`=''), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='location_precision' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '7', '', '0', '0', '', '1', 'diagnosis location precision', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='histologic_type_1' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_endometrium_diagnosis_histologic_type_1')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic type 1' AND `language_tag`=''), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='histologic_type_2' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_endometrium_diagnosis_histologic_type_2')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='histologic type 2'), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='histologic_type_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='histologic type precision'), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_endometriums'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='figo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_figo')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='figo' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE  structure_permissible_values_custom_controls SET category = 'clinical - diagnosis' WHERE category = 'diagnosis';
UPDATE  structure_permissible_values_custom_controls SET category = 'clinical - annotation' WHERE category = 'annotation';


INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_other_diagnosis_method", "StructurePermissibleValuesCustom::getCustomDropdown(\'Other Diagnosis Method\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Other Diagnosis Method', 'clinical - diagnosis', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Other Diagnosis Method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('surgery', 'Surgery', '', '1', @control_id),
('clinical', 'Clinical', '', '1', @control_id),
('biopsy', 'Biopsy', '', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'dx_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_other_diagnosis_method') , '0', '', '', 'help_dx method', 'dx_method', '');
UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='uhn_other_diagnosis_method') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_dxd_primary_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_ovarian_diagnosis_method') AND `flag_confidential`='0');

ALTER TABLE uhn_dxd_others ADD COLUMN histologic_type varchar(100) DEFAULT NULL;
CREATE TABLE uhn_dxd_others_revs (
  diagnosis_master_id int(11) NOT NULL,
  laterality varchar(50) DEFAULT NULL,
  histologic_type varchar(50) DEFAULT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_other_diagnosis_histologic_type", "StructurePermissibleValuesCustom::getCustomDropdown(\'Other Diagnosis Histologic Type\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Other Diagnosis Histologic Type', 'clinical - diagnosis', 1, 100);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Other Diagnosis Histologic Type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`)
VALUES
('benign', 'Benign', '', '1', @control_id),
('carcinoma', 'Carcinoma', '', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_others', 'histologic_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_other_diagnosis_histologic_type') , '0', '', '', '', 'histologic type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_others'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_others' AND `field`='histologic_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_other_diagnosis_histologic_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='histologic type' AND `language_tag`=''), '1', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_dxd_primary_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-84' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `language_label`='dx nature' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `language_help`='help_dx nature' AND `validation_control`='open' AND `value_domain_control`='extend' AND `field_control`='locked' AND `flag_confidential`='0');
ALTER TABLE uhn_dxd_others MODIFY histologic_type varchar(100) DEFAULT NULL;
ALTER TABLE uhn_dxd_others_revs MODIFY histologic_type varchar(100) DEFAULT NULL;

INSERt INTO i18n (id,en) VALUES ('use either ovarian or endometrium diagnosis for this type of tumor','Use either ovarian or endometrium diagnosis for this type of tumor');

UPDATE structure_formats SET `structure_field_id`=(SELECT `id` FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `type`='select' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='uhn_other_diagnosis_method') ) WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_progression') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_ovarian_diagnosis_method') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_progression'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_progression') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `language_label`='dx_method' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='uhn_other_diagnosis_method') AND `language_help`='help_dx method' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_progression'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_other_diagnosis_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx method' AND `language_label`='dx_method' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE diagnosis_controls SET flag_active = 1 WHERE category = 'recurrence';
UPDATE diagnosis_controls SET flag_active = 0 WHERE category = 'remission';

INSERT INTO structures(`alias`) VALUES ('dx_recurrence');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='dx_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='dx_recurrence'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_other_diagnosis_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx method' AND `language_label`='dx_method' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

CREATE TABLE uhn_txd_surgeries_revs (
  residual_disease varchar(50) DEFAULT NULL,
  treatment_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/Protocol/%';
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolControl' AND `tablename`='protocol_controls' AND `field`='tumour_group' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol tumour group') AND `flag_confidential`='0');
UPDATE protocol_controls SET tumour_group = '';
INSERT INTO protocol_masters (`code`, `protocol_control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('Taxol + Carboplatinum', 1, NOW(), NOW(), 1, 1);
SET @protocol_master_id = (SELECT id FROM protocol_masters WHERE code = 'Taxol + Carboplatinum');
INSERT INTO pd_chemos (`protocol_master_id`) 
VALUES 
(@protocol_master_id);
INSERT INTO protocol_extend_masters (`protocol_master_id`, `protocol_extend_control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
(@protocol_master_id, 1, NOW(), NOW(), 1, 1);
SET @protocol_extend_master_id = LAST_INSERT_ID();
INSERT INTO pe_chemos (`drug_id`, `protocol_extend_master_id`) 
VALUES 
((SELECT id FROM drugs WHERE generic_name = 'Carboplatinum'), @protocol_extend_master_id);
INSERT INTO protocol_extend_masters (`protocol_master_id`, `protocol_extend_control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
(@protocol_master_id, 1, NOW(), NOW(), 1, 1);
SET @protocol_extend_master_id = LAST_INSERT_ID();
INSERT INTO pe_chemos (`drug_id`, `protocol_extend_master_id`) 
VALUES 
((SELECT id FROM drugs WHERE generic_name = 'Taxol'), @protocol_extend_master_id);
INSERT INTO protocol_masters (`code`, `protocol_control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('Taxol + CisPlatinum', 1, NOW(), NOW(), 1, 1);
SET @protocol_master_id = (SELECT id FROM protocol_masters WHERE code = 'Taxol + CisPlatinum');
INSERT INTO pd_chemos (`protocol_master_id`) 
VALUES 
(@protocol_master_id);
INSERT INTO protocol_extend_masters (`protocol_master_id`, `protocol_extend_control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
(@protocol_master_id, 1, NOW(), NOW(), 1, 1);
SET @protocol_extend_master_id = LAST_INSERT_ID();
INSERT INTO pe_chemos (`drug_id`, `protocol_extend_master_id`) 
VALUES 
((SELECT id FROM drugs WHERE generic_name = 'CisPlatinum'), @protocol_extend_master_id);
INSERT INTO protocol_extend_masters (`protocol_master_id`, `protocol_extend_control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
(@protocol_master_id, 1, NOW(), NOW(), 1, 1);
SET @protocol_extend_master_id = LAST_INSERT_ID();
INSERT INTO pe_chemos (`drug_id`, `protocol_extend_master_id`) 
VALUES 
((SELECT id FROM drugs WHERE generic_name = 'Taxol'), @protocol_extend_master_id);
INSERT INTO protocol_masters_revs (`protocol_control_id`, `code`, `name`, `modified_by`, `id`, `version_created`) (SELECT protocol_control_id, code, name, created_by, id, created FROM protocol_masters);
INSERT INTO pd_chemos_revs (`protocol_master_id`, `version_created`) (SELECT protocol_master_id, created FROM pd_chemos INNER JOIN protocol_masters ON id = protocol_master_id);
INSERT INTO protocol_extend_masters_revs (`protocol_master_id`, `protocol_extend_control_id`, `modified_by`, `id`, `version_created`) (SELECT protocol_master_id, protocol_extend_control_id, created_by, id, created FROM protocol_extend_masters);
INSERT INTO pe_chemos_revs (`protocol_extend_master_id`, `version_created`) (SELECT protocol_extend_master_id, created FROM pe_chemos INNER JOIN protocol_extend_masters ON id = protocol_extend_master_id);
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `flag_confidential`='0');





