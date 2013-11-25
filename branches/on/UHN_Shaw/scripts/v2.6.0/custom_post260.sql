INSERT INTO i18n (id,en) VALUES ('core_installname', 'UHN');
UPDATE groups SET flag_show_confidential = '1' WHERE id = 1;
UPDATE versions SET permissions_regenerated = 0;
UPDATE structure_permissible_values_custom_controls SET flag_active = 0;

-- -----------------------------------------------------------------------------------------------------------------------
-- Profile
-- ----------------------------------------------------------------------------------------------------------------------- 

INSERT INTO `key_increments` VALUES ('main_participant_id',1);

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field` IN ('cod_icd10_code','cod_confirmation_source','middle_name','marital_status','language_preferred','title','race','secondary_cod_icd10_code'));

UPDATE structure_formats SET `display_column`='3', `display_order`='98', `language_heading`='system data', `flag_add`='0', `flag_edit_readonly`='1', `flag_addgrid`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE participants 
  ADD COLUMN uhn_date_of_death_requested_from_cco char(1) DEFAULT '',
  ADD COLUMN uhn_cco_comment text;
ALTER TABLE participants_revs 
  ADD COLUMN uhn_date_of_death_requested_from_cco char(1) DEFAULT '',
  ADD COLUMN uhn_cco_comment text;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'uhn_date_of_death_requested_from_cco', 'yes_no',  NULL , '0', '', '', '', 'requested from cco', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'uhn_cco_comment', 'input',  NULL , '0', 'rows=3,cols=30', '', '', 'cco comment', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='uhn_date_of_death_requested_from_cco' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='requested from cco' AND `language_tag`=''), '3', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='uhn_cco_comment' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='cco comment' AND `language_tag`=''), '3', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('requested from cco','Requested from CCO'),('cco comment','CCO Comment');

UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `flag_confidential`='1' WHERE model='Participant' AND tablename='participants' AND field IN ('date_of_birth', 'first_name', 'last_name');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE participants 
  ADD COLUMN uhn_brca_1_positif char(1) DEFAULT '',
  ADD COLUMN uhn_brca_2_positif char(1) DEFAULT '';
ALTER TABLE participants_revs 
  ADD COLUMN uhn_brca_1_positif char(1) DEFAULT '',
  ADD COLUMN uhn_brca_2_positif char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'uhn_brca_1_positif', 'yes_no',  NULL , '0', '', '', '', 'brca1 positif', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'uhn_brca_2_positif', 'yes_no',  NULL , '0', '', '', '', 'brca2 positif', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='uhn_brca_1_positif' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='brca1 positif' AND `language_tag`=''), '3', '20', 'brca status', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='uhn_brca_2_positif' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='brca2 positif' AND `language_tag`=''), '3', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('brca status', 'BRCA Status'),('brca1 positif', 'BRCA1+'),('brca2 positif', 'BRCA2+');

ALTER TABLE participants ADD COLUMN uhn_most_recent_contact date DEFAULT NULL, ADD COLUMN uhn_most_recent_contact_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs ADD COLUMN uhn_most_recent_contact date DEFAULT NULL, ADD COLUMN uhn_most_recent_contact_accuracy char(1) NOT NULL DEFAULT '';  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'uhn_most_recent_contact', 'date',  NULL , '0', '', '', '', 'most recent contact', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='uhn_most_recent_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='most recent contact' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('most recent contact', 'Most Recent Contact');

-- Misc Identifier

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `reg_exp_validation`) 
VALUES 
(NULL, 'hospital file number', '1', '', NULL, 
'1', '1', '1', ''),
(NULL, 'uhn biobank nbr', '1', '', NULL, 
'1', '0', '1', '');
INSERT IGNORE INTO i18n (id,en) VALUES ('hospital file number', 'Hospital File #'),('uhn biobank nbr','UHN Biobank #');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field` IN ('effective_date', 'expiry_date', 'notes'));

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, 
`flag_once_per_participant`, `flag_confidential`, `flag_unique`, `reg_exp_validation`) 
VALUES 
(NULL, 'tgh number', '1', '', NULL, 
'1', '1', '1', '');

INSERT IGNORE INTO i18n (id,en) VALUES ('tgh number','TGH #');

UPDATE misc_identifier_controls SET flag_once_per_participant = '0' WHERE misc_identifier_name = 'tgh number';

-- -----------------------------------------------------------------------------------------------------------------------
-- Consent
-- ----------------------------------------------------------------------------------------------------------------------- 

UPDATE consent_controls SET flag_active = 0;
INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'uhn', 1, 'uhn_cd_generics', 'cd_nationals', 0, 'uhn');
INSERT INTO i18n (id,en) VALUES ('uhn', 'UHN');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='form_version' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_consent_from_verisons') AND `flag_confidential`='0');
INSERT INTO structures(`alias`) VALUES ('uhn_cd_generics');
UPDATE structure_fields SET  `setting`='rows=3,cols=30' WHERE model='ConsentMaster' AND tablename='consent_masters' AND field='reason_denied' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------
-- Diagnosis
-- ----------------------------------------------------------------------------------------------------------------------- 

UPDATE diagnosis_controls SET flag_active = 0 WHERE controls_type IN ('blood','tissue');
UPDATE diagnosis_controls SET flag_active = 0 WHERE controls_type IN ('undetailed') AND category = 'secondary';

-- Unknown 

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_unknown_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Primary Other

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'other', 1, 'uhn_dxd_primary_others', 'uhn_dxd_others', 0, 'primary|other', 1);
ALTER TABLE diagnosis_masters ADD COLUMN uhn_site varchar(100) DEFAULT NULL;
ALTER TABLE diagnosis_masters_revs ADD COLUMN uhn_site varchar(100) DEFAULT NULL;
CREATE TABLE IF NOT EXISTS `uhn_dxd_others` (
  `diagnosis_master_id` int(11) NOT NULL,
  laterality varchar(50) DEFAULT NULL,
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `uhn_dxd_others` (
  `diagnosis_master_id` int(11) NOT NULL,
  laterality varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `uhn_dxd_others`
  ADD CONSTRAINT `FK_uhn_dxd_others_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_diagnosis_site", "StructurePermissibleValuesCustom::getCustomDropdown(\'Tumor Sites\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Tumor Sites', 1, 50);
UPDATE structure_permissible_values_custom_controls SET flag_active = 1, category = 'diagnosis' WHERE name = 'Tumor Sites'; 
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tumor Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('breast-breast', 'Breast-Breast', '', '1', @control_id),
('central nervous system-brain', 'Central Nervous System-Brain', '', '1', @control_id),
('central nervous system-other central nervous system', 'Central Nervous System-Other Central Nervous System', '', '1', @control_id),
('central nervous system-spinal cord', 'Central Nervous System-Spinal Cord', '', '1', @control_id),
('digestive-anal', 'Digestive-Anal', '', '1', @control_id),
('digestive-appendix', 'Digestive-Appendix', '', '1', @control_id),
('digestive-bile ducts', 'Digestive-Bile Ducts', '', '1', @control_id),
('digestive-colonic', 'Digestive-Colonic', '', '1', @control_id),
('digestive-esophageal', 'Digestive-Esophageal', '', '1', @control_id),
('digestive-gallbladder', 'Digestive-Gallbladder', '', '1', @control_id),
('digestive-liver', 'Digestive-Liver', '', '1', @control_id),
('digestive-other digestive', 'Digestive-Other Digestive', '', '1', @control_id),
('digestive-pancreas', 'Digestive-Pancreas', '', '1', @control_id),
('digestive-rectal', 'Digestive-Rectal', '', '1', @control_id),
('digestive-small intestine', 'Digestive-Small Intestine', '', '1', @control_id),
('digestive-stomach', 'Digestive-Stomach', '', '1', @control_id),
('female genital-cervical', 'Female Genital-Cervical', '', '1', @control_id),
('female genital-endometrium', 'Female Genital-Endometrium', '', '1', @control_id),
('female genital-fallopian tube', 'Female Genital-Fallopian Tube', '', '1', @control_id),
('female genital-gestational trophoblastic neoplasia', 'Female Genital-Gestational Trophoblastic Neoplasia', '', '1', @control_id),
('female genital-other female genital', 'Female Genital-Other Female Genital', '', '1', @control_id),
('female genital-ovary', 'Female Genital-Ovary', '', '1', @control_id),
('female genital-peritoneal pelvis abdomen', 'Female Genital-Peritoneal Pelvis Abdomen', '', '1', @control_id),
('female genital-uterine', 'Female Genital-Uterine', '', '1', @control_id),
('female genital-vagina', 'Female Genital-Vagina', '', '1', @control_id),
('female genital-vulva', 'Female Genital-Vulva', '', '1', @control_id),
('haematological-hodgkin''s disease', 'Haematological-Hodgkin''s Disease', '', '1', @control_id),
('haematological-leukemia', 'Haematological-Leukemia', '', '1', @control_id),
('haematological-lymphoma', 'Haematological-Lymphoma', '', '1', @control_id),
('haematological-non-hodgkin''s lymphomas', 'Haematological-Non-Hodgkin''s Lymphomas', '', '1', @control_id),
('haematological-other haematological', 'Haematological-Other Haematological', '', '1', @control_id),
('head & neck-larynx', 'Head & Neck-Larynx', '', '1', @control_id),
('head & neck-lip and oral cavity', 'Head & Neck-Lip and Oral Cavity', '', '1', @control_id),
('head & neck-nasal cavity and sinuses', 'Head & Neck-Nasal Cavity and Sinuses', '', '1', @control_id),
('head & neck-other head & neck', 'Head & Neck-Other Head & Neck', '', '1', @control_id),
('head & neck-pharynx', 'Head & Neck-Pharynx', '', '1', @control_id),
('head & neck-salivary glands', 'Head & Neck-Salivary Glands', '', '1', @control_id),
('head & neck-thyroid', 'Head & Neck-Thyroid', '', '1', @control_id),
('musculoskeletal sites-bone', 'Musculoskeletal Sites-Bone', '', '1', @control_id),
('musculoskeletal sites-other bone', 'Musculoskeletal Sites-Other Bone', '', '1', @control_id),
('musculoskeletal sites-soft tissue sarcoma', 'Musculoskeletal Sites-Soft Tissue Sarcoma', '', '1', @control_id),
('ophthalmic-eye', 'Ophthalmic-Eye', '', '1', @control_id),
('ophthalmic-other eye', 'Ophthalmic-Other Eye', '', '1', @control_id),
('other-gross metastatic disease', 'Other-Gross Metastatic Disease', '', '1', @control_id),
('other-primary unknown', 'Other-Primary Unknown', '', '1', @control_id),
('skin-melanoma', 'Skin-Melanoma', '', '1', @control_id),
('skin-non melanomas', 'Skin-Non Melanomas', '', '1', @control_id),
('skin-other skin', 'Skin-Other Skin', '', '1', @control_id),
('thoracic-lung', 'Thoracic-Lung', '', '1', @control_id),
('thoracic-mesothelioma', 'Thoracic-Mesothelioma', '', '1', @control_id),
('thoracic-other thoracic', 'Thoracic-Other Thoracic', '', '1', @control_id),
('urinary tract-bladder', 'Urinary Tract-Bladder', '', '1', @control_id),
('urinary tract-kidney', 'Urinary Tract-Kidney', '', '1', @control_id),
('urinary tract-other urinary tract', 'Urinary Tract-Other Urinary Tract', '', '1', @control_id),
('urinary tract-renal pelvis and ureter', 'Urinary Tract-Renal Pelvis and Ureter', '', '1', @control_id),
('urinary tract-urethra', 'Urinary Tract-Urethra', '', '1', @control_id),
('unknown', 'Unknown', '', '1', @control_id);
INSERT INTO structures(`alias`) VALUES ('uhn_dxd_primary_others');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_others', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', 'dx_laterality', 'laterality', ''), 
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'uhn_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site') , '0', '', '', '', 'site', '');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='uhn_site' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site')), 'notEmpty');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_others'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_others' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_others'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx nature' AND `language_label`='dx nature' AND `language_tag`=''), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_others'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_permissible_values (value, language_alias) VALUES("bilateral", "bilateral");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="laterality"), (SELECT id FROM structure_permissible_values WHERE value="bilateral" AND language_alias="bilateral"), "2", "1");
INSERT INTO i18n (id,en) VALUES ('site','Site');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_dxd_primary_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site') AND `flag_confidential`='0');

-- Secondary Other

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'secondary', 'other', 1, 'uhn_dxd_secondary_others', 'uhn_dxd_others', 0, 'secondary|other', 1);
INSERT INTO structures(`alias`) VALUES ('uhn_dxd_secondary_others');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_dxd_secondary_others'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_others' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_secondary_others'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_dxd_secondary_others') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site') AND `flag_confidential`='0');

-- Secondary - Ovary

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'secondary', 'ovary', 1, 'uhn_dxd_secondary_ovaries', 'uhn_dxd_secondary_ovaries', 0, 'secondary|ovary', 1);
CREATE TABLE IF NOT EXISTS `uhn_dxd_secondary_ovaries` (
  `diagnosis_master_id` int(11) NOT NULL,
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `uhn_dxd_secondary_ovaries` (
  `diagnosis_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `uhn_dxd_secondary_ovaries`
  ADD CONSTRAINT `FK_uhn_dxd_secondary_ovaries_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('uhn_dxd_secondary_ovaries');
INSERT INTO i18n (id,en) VALUES ('ovary','Ovary');

-- view_diagnosis

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0');

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field` IN ('topography','icd10_code'));

UPDATE structure_formats SET `display_order`='4' WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site') AND `flag_confidential`='0');

-- Primary - Ovary

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'ovary', 1, 'uhn_dxd_primary_ovaries', 'uhn_dxd_primary_ovaries', 0, 'primary|ovary', 1);
CREATE TABLE IF NOT EXISTS `uhn_dxd_primary_ovaries` (
  `diagnosis_master_id` int(11) NOT NULL,
  diagnosis_method varchar(50) DEFAULT NULL,
  laterality varchar(50) DEFAULT NULL,
  location varchar(50) DEFAULT NULL,
  location_precision varchar(250) DEFAULT NULL,
  histologic_type_1 varchar(100) DEFAULT NULL,
  histologic_type_2 varchar(100) DEFAULT NULL,
  histologic_type_precision varchar(250) DEFAULT NULL,
  figo varchar(10) DEFAULT NULL,

  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `uhn_dxd_primary_ovaries` (
  `diagnosis_master_id` int(11) NOT NULL,
  diagnosis_method varchar(50) DEFAULT NULL,
  laterality varchar(50) DEFAULT NULL,
  location varchar(50) DEFAULT NULL,
  location_precision varchar(250) DEFAULT NULL,
  histologic_type_1 varchar(100) DEFAULT NULL,
  histologic_type_2 varchar(100) DEFAULT NULL,
  histologic_type_precision varchar(250) DEFAULT NULL,
  figo varchar(10) DEFAULT NULL,
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `uhn_dxd_primary_ovaries`
  ADD CONSTRAINT `FK_uhn_dxd_primary_ovaries_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);
-- Ovarian Diagnosis Method
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_ovarian_diagnosis_method", "StructurePermissibleValuesCustom::getCustomDropdown(\'Ovarian Diagnosis Method\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Ovarian Diagnosis Method', 'diagnosis', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Ovarian Diagnosis Method');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('surgery', 'Surgery', '', '1', @control_id),
('clinical + ca125', 'Clinical + Ca125', '', '1', @control_id),
('clinical + cytology', 'Clinical + Cytology', '', '1', @control_id),
('clinical + radiological', 'Clinical + Radiological', '', '1', @control_id),
('endometrial biopsy', 'Endometrial Biopsy', '', '1', @control_id);
-- Ovarian Diagnosis Location
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_ovarian_diagnosis_location", "StructurePermissibleValuesCustom::getCustomDropdown(\'Ovarian Diagnosis Location\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Ovarian Diagnosis Location', 'diagnosis', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Ovarian Diagnosis Location');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('germ cell', 'Germ Cell', '', '1', @control_id),
('epithelial', 'Epithelial', '', '1', @control_id),
('sexcord stromal', 'Sexcord Stromal', '', '1', @control_id),
('other', 'Other', '', '1', @control_id);
-- histologic_type_1
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_ovarian_diagnosis_histologic_type_1", "StructurePermissibleValuesCustom::getCustomDropdown(\'Histologic Type\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Histologic Type', 'diagnosis', 1, 100);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Histologic Type');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('benign', 'Benign', '', '1', @control_id),
('borderline', 'Borderline', '', '1', @control_id),
('carcinoma', 'Carcinoma', '', '1', @control_id),
('borderline micropapillary', 'Borderline Micropapillary', '', '1', @control_id);
-- histologic_type_2
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_ovarian_diagnosis_histologic_type_2", "StructurePermissibleValuesCustom::getCustomDropdown(\'Histologic Type Precision\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Histologic Type Precision', 'diagnosis', 1, 100);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Histologic Type Precision');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('serous', 'Serous', '', '1', @control_id),
('mucinous', 'Mucinous', '', '1', @control_id),
('endometrioid', 'Endometrioid', '', '1', @control_id),
('clear cell', 'Clear cell', '', '1', @control_id),
('transitional cell', 'Transitional cell', '', '1', @control_id),
('undifferentiated', 'Undifferentiated', '', '1', @control_id),
('mixed', 'Mixed', '', '1', @control_id),
('MMMT', 'MMMT', '', '1', @control_id),
('brenner', 'Brenner', '', '1', @control_id),
('other', 'Other', '', '1', @control_id);
-- Figo
INSERT INTO structure_value_domains (domain_name) VALUES ("uhn_figo");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("Ia", "Ia"),
("Ib", "Ib"),
("Ic", "Ic"),
("IIa", "IIa"),
("IIb", "IIb"),
("IIc", "IIc"),
("IIIa", "IIIa"),
("IIIb", "IIIb"),
("IIIc", "IIIc"),
("IV", "IV"),
("unknown", "unknown");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="uhn_figo"), (SELECT id FROM structure_permissible_values WHERE value="Ia" AND language_alias="Ia"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="uhn_figo"), (SELECT id FROM structure_permissible_values WHERE value="Ib" AND language_alias="Ib"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="uhn_figo"), (SELECT id FROM structure_permissible_values WHERE value="Ic" AND language_alias="Ic"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="uhn_figo"), (SELECT id FROM structure_permissible_values WHERE value="IIa" AND language_alias="IIa"), "4", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="uhn_figo"), (SELECT id FROM structure_permissible_values WHERE value="IIb" AND language_alias="IIb"), "5", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="uhn_figo"), (SELECT id FROM structure_permissible_values WHERE value="IIc" AND language_alias="IIc"), "6", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="uhn_figo"), (SELECT id FROM structure_permissible_values WHERE value="IIIa" AND language_alias="IIIa"), "7", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="uhn_figo"), (SELECT id FROM structure_permissible_values WHERE value="IIIb" AND language_alias="IIIb"), "8", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="uhn_figo"), (SELECT id FROM structure_permissible_values WHERE value="IIIc" AND language_alias="IIIc"), "9", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="uhn_figo"), (SELECT id FROM structure_permissible_values WHERE value="IV" AND language_alias="IV"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="uhn_figo"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "11", "1");
INSERT INTO structures(`alias`) VALUES ('uhn_dxd_primary_ovaries');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_primary_ovaries', 'diagnosis_method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_ovarian_diagnosis_method') , '0', '', '', '', 'diagnosis method', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_primary_ovaries', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='laterality') , '0', '', '', 'dx_laterality', 'laterality', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_primary_ovaries', 'location', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_ovarian_diagnosis_location') , '0', '', '', '', 'ovarian diagnosis location', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_primary_ovaries', 'location_precision', 'input', NULL , '0', '', '', '', '', 'ovarian diagnosis location precision'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_primary_ovaries', 'histologic_type_1', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_ovarian_diagnosis_histologic_type_1') , '0', '', '', '', 'ovarian diagnosis histologic type 1', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_primary_ovaries', 'histologic_type_2', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_ovarian_diagnosis_histologic_type_2') , '0', '', '', '', '', 'ovarian diagnosis histologic type 2'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_primary_ovaries', 'histologic_type_precision', 'input', NULL , '0', '', '', '', '', 'ovarian diagnosis histologic type precision'), 
('ClinicalAnnotation', 'DiagnosisDetail', 'uhn_dxd_primary_ovaries', 'figo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_figo') , '0', '', '', '', 'figo', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='diagnosis_method'), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='laterality'), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='location'), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='location_precision'), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='histologic_type_1'), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='histologic_type_2'), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='histologic_type_precision'), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_dxd_primary_ovaries'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='uhn_dxd_primary_ovaries' AND `field`='figo'), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en) VALUES 
('diagnosis method','Diagnosis Method'),
('ovarian diagnosis location','Location'),
('ovarian diagnosis location precision','Precision'),
('ovarian diagnosis histologic type 1','Histologic Type'),('ovarian diagnosis histologic type 2', '-'),
('ovarian diagnosis histologic type precision','Precision'),
('figo', 'Figo'),
("Ia", "Ia"),
("Ib", "Ib"),
("Ic", "Ic"),
("IIa", "IIa"),
("IIb", "IIb"),
("IIc", "IIc"),
("IIIa", "IIIa"),
("IIIb", "IIIb"),
("IIIc", "IIIc"),
("IV", "IV");

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id!=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='uhn_site');
INSERT INTO i18n (id,en) VALUES ('use ovarian diagnosis for any either ovarian tumor or ovarian metastasis','Use ovarian diagnosis for any either ovarian tumor or ovarian metastasis');
UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('dx_primary', 'dx_secondary'));

-- -----------------------------------------------------------------------------------------------------------------------
-- Reproductive History
-- ----------------------------------------------------------------------------------------------------------------------- 

UPDATE structure_formats SET `display_column`='4', display_order = '99'
WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') ;
UPDATE structure_formats SET `display_column`='1', `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='date_captured' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='5', `language_heading`='menarche' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menarche' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menarche_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='lnmp_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0', `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `field` IN ('age_at_first_parturition_precision', 'age_at_first_parturition', 'age_at_last_parturition', 'age_at_last_parturition_precision'));
ALTER TABLE reproductive_histories MODIFY hormonal_contraceptive_use char(1) DEFAULT '';
ALTER TABLE reproductive_histories_revs MODIFY hormonal_contraceptive_use char(1) DEFAULT '';
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='hormonal_contraceptive_use' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='indicator');
UPDATE structure_formats SET `display_column`='1', `display_order`='20', `language_heading`='birth control' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hormonal_contraceptive_use');
UPDATE structure_formats SET `display_column`='1', `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='years_on_hormonal_contraceptives');
ALTER TABLE reproductive_histories ADD COLUMN uhn_iud_use char(1) DEFAULT '', ADD COLUMN uhn_tubal_ligation char(1) DEFAULT '';
ALTER TABLE reproductive_histories_revs ADD COLUMN uhn_iud_use char(1) DEFAULT '', ADD COLUMN uhn_tubal_ligation char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'uhn_iud_use', 'yes_no',  NULL , '0', '', '', '', 'iud use', ''), 
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'uhn_tubal_ligation', 'yes_no',  NULL , '0', '', '', '', 'tubal ligation', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='uhn_iud_use' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='iud use' AND `language_tag`=''), '1', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='uhn_tubal_ligation' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tubal ligation' AND `language_tag`=''), '1', '23', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_column`='1', `display_order`='30', `language_heading`='pregnancies' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='gravida' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='31' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='para' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE reproductive_histories ADD COLUMN uhn_abortus int(11) DEFAULT NULL;
ALTER TABLE reproductive_histories_revs ADD COLUMN uhn_abortus int(11) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'uhn_abortus', 'integer_positive',  NULL , '0', '', '', '', 'abortus', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='uhn_abortus' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='abortus' AND `language_tag`=''), '1', '32', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE reproductive_histories ADD COLUMN uhn_breast_feed char(1) DEFAULT '', ADD COLUMN uhn_fertility_drugs char(1) DEFAULT '';
ALTER TABLE reproductive_histories_revs ADD COLUMN uhn_breast_feed char(1) DEFAULT '', ADD COLUMN uhn_fertility_drugs char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'uhn_breast_feed', 'yes_no',  NULL , '0', '', '', '', 'breast feed', ''), 
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'uhn_fertility_drugs', 'yes_no',  NULL , '0', '', '', '', 'fertility drugs', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='uhn_breast_feed' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='breast feed' AND `language_tag`=''), '1', '33', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='uhn_fertility_drugs' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fertility drugs' AND `language_tag`=''), '1', '34', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_column`='2', `display_order`='52' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='50', `language_heading`='menopause' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='menopause_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='51' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='54' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='ovary_removed_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovary_removed_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='53' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='menopause_onset_reason' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_reason') AND `flag_confidential`='0');
ALTER TABLE reproductive_histories ADD COLUMN uhn_ovary_removed_reason varchar(250) DEFAULT NULL;
ALTER TABLE reproductive_histories_revs ADD COLUMN uhn_ovary_removed_reason varchar(250) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'uhn_ovary_removed_reason', 'input',  NULL , '0', 'size=20', '', '', '', 'reason');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='uhn_ovary_removed_reason' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='reason'), '1', '35', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE reproductive_histories MODIFY hrt_use char(1) DEFAULT '';
ALTER TABLE reproductive_histories_revs MODIFY hrt_use char(1) DEFAULT '';
UPDATE structure_fields SET  `type`='yes_no',  `structure_value_domain`= NULL  WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='hrt_use' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='indicator');
UPDATE structure_formats SET `display_column`='2', `display_order`='60', `language_heading`='other' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hrt_use' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='indicator') AND `flag_confidential`='0');
ALTER TABLE reproductive_histories ADD COLUMN uhn_estrogen char(1) DEFAULT '', ADD COLUMN uhn_estrogen_nbr_of_year int(4) DEFAULT NULL, ADD COLUMN uhn_progesteron char(1) DEFAULT '', ADD COLUMN uhn_progesteron_nbr_of_year int(4) DEFAULT NULL;
ALTER TABLE reproductive_histories_revs ADD COLUMN uhn_estrogen char(1) DEFAULT '', ADD COLUMN uhn_estrogen_nbr_of_year int(4) DEFAULT NULL, ADD COLUMN uhn_progesteron char(1) DEFAULT '', ADD COLUMN uhn_progesteron_nbr_of_year int(4) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'uhn_estrogen_nbr_of_year', 'integer_positive',  NULL , '0', '', '', '', '', 'estrogen nbr of years'), 
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'uhn_estrogen', 'yes_no',  NULL , '0', '', '', '', 'estrogen', ''), 
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'uhn_progesteron', 'yes_no',  NULL , '0', '', '', '', 'progesteron', ''), 
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'uhn_progesteron_nbr_of_year', 'integer_positive',  NULL , '0', '', '', '', '', 'progesteron nbr of years');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='uhn_estrogen_nbr_of_year' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='estrogen nbr of years'), '2', '63', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='uhn_estrogen' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='estrogen' AND `language_tag`=''), '2', '62', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='uhn_progesteron' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='progesteron' AND `language_tag`=''), '2', '63', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='uhn_progesteron_nbr_of_year' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='progesteron nbr of years'), '2', '64', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND display_order = '99';
UPDATE structure_formats SET `display_column`='2', `display_order`='55' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='uhn_ovary_removed_reason' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES
('abortus', 'Abortus'),
('birth control', 'Birth Control'),
('breast feed', 'Breast Feed'),
('estrogen', 'Estrogen'),
('estrogen nbr of years', 'Years Used'),
('fertility drugs', 'Fertility Drugs'),
('iud use', 'IUD Use'),
('menarche', 'Menarche'),
('menopause', 'Menopause'),
('pregnancies', 'Pregnancies'),
('progesteron', 'Progesteron'),
('progesteron nbr of years', 'Years Used'),
('reason', 'Reason'),
('tubal ligation', 'Tubal Ligation');
UPDATE structure_formats SET `language_heading`='other', `display_column`='2', `display_order`='60', `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hrt_use' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='61', `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hrt_years_used' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND `flag_add`='1';

-- -----------------------------------------------------------------------------------------------------------------------
-- Treatment
-- ----------------------------------------------------------------------------------------------------------------------- 

UPDATE treatment_controls SET flag_active = 0;
UPDATE treatment_extend_controls SET flag_active = 0;

-- Surgery

INSERT INTO `treatment_extend_controls` (`id`, `detail_tablename`, `detail_form_alias`, `flag_active`, `type`, `databrowser_label`) VALUES
(null, 'uhn_txe_surgeries', 'uhn_txe_surgeries', 1, 'surgery/biopsy procedure', 'surgery/biopsy procedure');
INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`) VALUES
(null, 'surgery/biopsy', 'general', 1, 'uhn_txd_surgeries', 'uhn_txd_surgeries', 0, null, '', 'surgery/biopsy', 1, (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'uhn_txe_surgeries'));
INSERT INTO i18n (id,en) VALUES ('surgery/biopsy', 'Surgery/Biopsy'),('surgery/biopsy procedure','Surgery/Biopsy Procedure');
-- Surgery Intent
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_surgery_intent", "StructurePermissibleValuesCustom::getCustomDropdown(\'Surgery Intent\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Surgery Intent', 'treatment', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Surgery Intent');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('diagnosis', 'Diagnosis', '', '1', @control_id),
('stage', 'Stage', '', '1', @control_id),
('debulk', 'Debulk', '', '1', @control_id),
('interval debulk', 'Interval Debulk', '', '1', @control_id),
('palliation', 'Palliation', '', '1', @control_id),
('second look laparotomy', 'Second Look Laparotomy', '', '1', @control_id),
('second look laparoscopy', 'Second Look Laparoscopy', '', '1', @control_id),
('other', 'Other', '', '1', @control_id);
-- Treamtent Institution
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_treatment_institution", "StructurePermissibleValuesCustom::getCustomDropdown(\'Treatment Institution\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Treatment Institution', 'treatment', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Institution');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('SHSC', 'SHSC', '', '1', @control_id),
('TGH', 'TGH', '', '1', @control_id);
-- uhn_residual_disease
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("uhn_residual_disease", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="uhn_residual_disease"), (SELECT id FROM structure_permissible_values WHERE value="none" AND language_alias="none"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("micro", "micro");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="uhn_residual_disease"), (SELECT id FROM structure_permissible_values WHERE value="micro" AND language_alias="micro"), "2", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("optimal", "optimal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="uhn_residual_disease"), (SELECT id FROM structure_permissible_values WHERE value="optimal" AND language_alias="optimal"), "3", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("suboptimal", "suboptimal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="uhn_residual_disease"), (SELECT id FROM structure_permissible_values WHERE value="suboptimal" AND language_alias="suboptimal"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="uhn_residual_disease"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "5", "1");
--
INSERT INTO structures(`alias`) VALUES ('uhn_txd_surgeries');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'tx_intent', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_surgery_intent') , '0', '', '', 'help_tx_intent', 'intent', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_surgery_intent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_intent' AND `language_label`='intent' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='uhn_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
ALTER TABLE treatment_masters ADD COLUMN uhn_tx_intent_precision VARCHAR(100) DEFAULT NULL;
ALTER TABLE treatment_masters_revs ADD COLUMN uhn_tx_intent_precision VARCHAR(100) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'uhn_tx_intent_precision', 'input',  NULL , '0', 'size=20', '', '', 'intent precisions', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='uhn_tx_intent_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='intent precisions' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `language_label`='',  `language_tag`='intent precisions' WHERE model='TreatmentMaster' AND tablename='treatment_masters' AND field='uhn_tx_intent_precision' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_surgery_intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='uhn_tx_intent_precision' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE treatment_masters ADD COLUMN uhn_institution VARCHAR(100) DEFAULT NULL;
ALTER TABLE treatment_masters_revs ADD COLUMN uhn_institution VARCHAR(100) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'uhn_institution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_treatment_institution') , '0', '', '', '', 'institution', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='uhn_institution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_treatment_institution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='institution' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
CREATE TABLE IF NOT EXISTS `uhn_txd_surgeries` (
  `treatment_master_id` int(11) NOT NULL,
	residual_disease varchar(50) DEFAULT NULL, 
  KEY `treatment_master_id` (`treatment_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `uhn_txd_surgeries` (
  `treatment_master_id` int(11) NOT NULL,
	residual_disease varchar(50) DEFAULT NULL,   
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `uhn_txd_surgeries`
  ADD CONSTRAINT `FK_uhn_txd_surgeries_treatment_masters` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'uhn_txd_surgeries', 'residual_disease', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_residual_disease') , '0', '', '', '', 'residual disease', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='uhn_txd_surgeries' AND `field`='residual_disease' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_residual_disease')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='residual disease' AND `language_tag`=''), '1', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('residual disease', 'Residual Disease'),('intent precisions','Precisions');
INSERT INTO i18n (id,en) VALUES ("micro", "Micro"),("suboptimal", "Suboptimal"),("optimal", "Optimal");
-- surgical_procedure
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_surgical_procedure", "StructurePermissibleValuesCustom::getCustomDropdown(\'Surgical Procedure\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Surgical Procedure', 'treatment', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Surgical Procedure');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('biopsy of ovary', 'Biopsy of Ovary', '', '1', @control_id),
('partial oopherectomy', 'Partial Oopherectomy', '', '1', @control_id),
('cystectomy', 'Cystectomy', '', '1', @control_id),
('uso', 'USO', '', '1', @control_id),
('bso', 'BSO', '', '1', @control_id),
('tah', 'TAH', '', '1', @control_id),
('subtotal hysterectomy', 'Subtotal Hysterectomy', '', '1', @control_id),
('tahbso', 'TAHBSO', '', '1', @control_id),
('omentectomy', 'Omentectomy', '', '1', @control_id),
('omental biopsy', 'Omental biopsy', '', '1', @control_id),
('peritoneal biopsy', 'Peritoneal Biopsy', '', '1', @control_id),
('right pelvic lymph nodes', 'Right Pelvic Lymph Nodes', '', '1', @control_id),
('left pelvic lymph nodes', 'Left Pelvic Lymph Nodes', '', '1', @control_id),
('right para aortic lymph nodes', 'Right Para Aortic Lymph Nodes', '', '1', @control_id),
('left para aortic lymph nodes', 'Left Para Aortic Lymph Nodes', '', '1', @control_id),
('colostomy', 'Colostomy', '', '1', @control_id),
('gastrectomy', 'Gastrectomy', '', '1', @control_id),
('splenectomy', 'Splenectomy', '', '1', @control_id),
('small bowel - large bowel resection', 'Small Bowel - Large Bowel Resection', '', '1', @control_id),
('paracentesis', 'Paracentesis', '', '1', @control_id),
('thoracentesis', 'Thoracentesis', '', '1', @control_id);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Surgical Procedure');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('pelvic mass biopsy', 'Pelvic Mass Biopsy', '', '1', @control_id),
('pelvic mass', 'Pelvic Mass', '', '1', @control_id);
CREATE TABLE IF NOT EXISTS `uhn_txe_surgeries` (
  `surgical_procedure` varchar(50) DEFAULT NULL,
  `notes` varchar(50) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  KEY `FK_uhn_txe_surgeries_treatment_extend_masters` (`treatment_extend_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `uhn_txe_surgeries_revs` (
  `surgical_procedure` varchar(50) DEFAULT NULL,
  `notes` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `uhn_txe_surgeries`
  ADD CONSTRAINT `FK_uhn_txe_surgeries_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('uhn_txe_surgeries');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'uhn_txe_surgeries', 'surgical_procedure', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_surgical_procedure') , '0', '', '', 'help_surgical_procedure', 'surgical procedure', ''), 
('ClinicalAnnotation', 'TreatmentExtendDetail', 'uhn_txe_surgeries', 'notes', 'input',  NULL , '0', 'size=30', '', '', 'notes', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_txe_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='uhn_txe_surgeries' AND `field`='surgical_procedure' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_surgical_procedure')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_surgical_procedure' AND `language_label`='surgical procedure' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_txe_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='uhn_txe_surgeries' AND `field`='notes' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- treatment master

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0', `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
INSERT INTO drugs (`generic_name`, `type`) 
VALUES 
('Cyclophosphamide', 'chemotherapy'),
('CisPlatinum', 'chemotherapy'),
('Carboplatinum', 'chemotherapy'),
('Taxol', 'chemotherapy'),
('Fluorouracil', 'chemotherapy'),
('Adriamycin', 'chemotherapy'),
('Etopiside', 'chemotherapy'),
('Toptecan', 'chemotherapy'),
('Hexamethylmelamine', 'chemotherapy'),
('Tamoxifen', 'chemotherapy'),
('Megace', 'chemotherapy');
INSERT INTO drugs_revs (`id`, `generic_name`, `type`) (SELECT `id`, `generic_name`, `type` FROM drugs);
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='protocolmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='arm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE protocol_controls SET flag_active = 0 WHERE type = 'surgery';
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='arm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='pe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='pe_chemos' AND `field`='frequency' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='facility' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='facility') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='length_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- chemo

UPDATE treatment_controls SET flag_active = 1 WHERE tx_method IN ('chemotherapy', 'radiation');
UPDATE treatment_controls SET databrowser_label = tx_method;
ALTER TABLE txd_chemos ADD COLUMN uhn_treatment_line int(3) DEFAULT NULL, ADD COLUMN uhn_reason_for_stopping varchar(50) DEFAULT NULL;
ALTER TABLE txd_chemos_revs ADD COLUMN uhn_treatment_line int(3) DEFAULT NULL, ADD COLUMN uhn_reason_for_stopping varchar(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) VALUES ("uhn_trt_uhn_reason_for_stopping", "StructurePermissibleValuesCustom::getCustomDropdown(\'Chemo - Reason for stopping\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) VALUES ('Chemo - Reason for stopping', 'treatment', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Chemo - Reason for stopping');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('Completed course of treatment', 'Completed course of treatment', '', '1', @control_id),
('Increasing disease on P.E.', 'Increasing disease on P.E.', '', '1', @control_id),
('Data Unavailable', 'Data Unavailable', '', '1', @control_id),
('Increasing disease on X-ray', 'Increasing disease on X-ray', '', '1', @control_id),
('Stable Ca 125', 'Stable Ca 125', '', '1', @control_id),
('Other', 'Other', '', '1', @control_id),
('Increasing Ca 125', 'Increasing Ca 125', '', '1', @control_id),
('Drug Intolerance', 'Drug Intolerance', '', '1', @control_id),
('Chemo Resistant (Not responding to drug)', 'Chemo Resistant (Not responding to drug)', '', '1', @control_id),
('Chemo Sensitive (Increased side effects)', 'Chemo Sensitive (Increased side effects)', '', '1', @control_id),
('No evidence of disease', 'No evidence of disease', '', '1', @control_id),
('Disease at surgery', 'Disease at surgery', '', '1', @control_id),
('Increasing disease by biopsy', 'Increasing disease by biopsy', '', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txd_chemos', 'uhn_treatment_line', 'integer_positive',  NULL , '0', 'size=5', '', '', 'line', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_chemos', 'uhn_reason_for_stopping', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_trt_uhn_reason_for_stopping') , '0', '', '', '', '', 'reason for stopping');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='uhn_treatment_line' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='line' AND `language_tag`=''), '2', '10', 'chemotherapy specific', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='uhn_reason_for_stopping' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_trt_uhn_reason_for_stopping')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='reason for stopping'), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='chemo_completed' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='uhn_treatment_line' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='uhn_reason_for_stopping' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_trt_uhn_reason_for_stopping') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='uhn_reason_for_stopping' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_trt_uhn_reason_for_stopping') AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ('reason for stopping', 'Reason for stopping');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='uhn_institution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_treatment_institution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='institution' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txe_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='txe_chemos' AND `field`='method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') AND `flag_confidential`='0');

-- radiation

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='facility' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='facility') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='uhn_institution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_treatment_institution')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='institution' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------
-- Annotation
-- ----------------------------------------------------------------------------------------------------------------------- 

UPDATE event_controls SET flag_active = 0;
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`) VALUES
(null, 'uhn', 'lab', 'pathology', 1, 'uhn_ed_ovary_lab_pathology', 'uhn_ed_ovary_lab_pathologies', 0, 'pathology', 1, 0),
(null, 'uhn', 'lab', 'ca125', 1, 'uhn_ed_ovary_lab_ca125', 'uhn_ed_ovary_lab_ca125s', 0, 'ca125', 0, 1);

UPDATE menus SET flag_active = 0 WHERE use_link like '/ClinicalAnnotation/EventMasters%' AND language_title NOT IN ('lab', 'annotation');
SET @link = (SELECT use_link FROM menus WHERE use_link like '/ClinicalAnnotation/EventMasters%' AND language_title = 'lab') ;
UPDATE menus SET use_link = @link WHERE use_link like '/ClinicalAnnotation/EventMasters%' AND language_title = 'annotation';

-- ca125

CREATE TABLE IF NOT EXISTS `uhn_ed_ovary_lab_ca125s` (
  value decimal(10,2) DEFAULT NULL,
  level varchar(10) DEFAULT NULL,  
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `uhn_ed_ovary_lab_ca125s_revs` (
  value decimal(10,2) DEFAULT NULL,
  level varchar(10) DEFAULT NULL,  
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `uhn_ed_ovary_lab_ca125s`
  ADD CONSTRAINT `uhn_ed_ovary_lab_ca125s_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('uhn_ed_ovary_lab_ca125');
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("uhn_ca125_level", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="uhn_ca125_level"), (SELECT id FROM structure_permissible_values WHERE value="high" AND language_alias="high"), "1", "1");
INSERT INTO structure_permissible_values (value, language_alias) VALUES("medium", "medium");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="uhn_ca125_level"), (SELECT id FROM structure_permissible_values WHERE value="medium" AND language_alias="medium"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="uhn_ca125_level"), (SELECT id FROM structure_permissible_values WHERE value="low" AND language_alias="low"), "3", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_ca125s', 'value', 'float_positive',  NULL , '0', 'size=5', '', '', 'value', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_ca125s', 'level', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_ca125_level') , '0', '', '', '', 'level', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_ca125'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_ca125s' AND `field`='value' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='value' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_ca125'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_ca125s' AND `field`='level' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_ca125_level')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='level' AND `language_tag`=''), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_ca125s' AND `field`='value'), 'notEmpty');
INSERT INTO i18n (id,en) VALUES ('medium', 'Medium');

-- pathology


CREATE TABLE IF NOT EXISTS `uhn_ed_ovary_lab_pathologies` (
	report_number varchar(50) DEFAULT NULL,

	left_ovary_tumour_present CHAR(1) DEFAULT '',
	left_ovary_weight_g decimal(10,2) DEFAULT NULL,
	left_ovary_diameter_cm decimal(10,2) DEFAULT NULL,
	left_ovary_surface varchar(50) DEFAULT NULL,
	left_ovary_capsule varchar(50) DEFAULT NULL,
	left_ovary_cut_surface_cysts varchar(50) DEFAULT NULL,
	left_ovary_cut_surface_necrosis varchar(50) DEFAULT NULL,
	
	right_ovary_tumour_present CHAR(1) DEFAULT '',
	right_ovary_weight_g decimal(10,2) DEFAULT NULL,
	right_ovary_diameter_cm decimal(10,2) DEFAULT NULL,
	right_ovary_surface varchar(50) DEFAULT NULL,
	right_ovary_capsule varchar(50) DEFAULT NULL,
	right_ovary_cut_surface_cysts varchar(50) DEFAULT NULL,
	right_ovary_cut_surface_necrosis varchar(50) DEFAULT NULL,
	
	nos_ovary_tumour_present CHAR(1) DEFAULT '',
	nos_ovary_weight_g decimal(10,2) DEFAULT NULL,
	nos_ovary_diameter_cm decimal(10,2) DEFAULT NULL,
	nos_ovary_surface varchar(50) DEFAULT NULL,
	nos_ovary_capsule varchar(50) DEFAULT NULL,
	nos_ovary_cut_surface_cysts varchar(50) DEFAULT NULL,
	nos_ovary_cut_surface_necrosis varchar(50) DEFAULT NULL,
	
	normal_ovary_cortical_inclusions CHAR(1) DEFAULT '',
	normal_ovary_stromal_hyperplasia CHAR(1) DEFAULT '',
	normal_ovary_epithelial_hyperplasia CHAR(1) DEFAULT '',
	normal_ovary_epithelial_dysplasia CHAR(1) DEFAULT '',
	normal_ovary_stromal_fibrosis CHAR(1) DEFAULT '',
	
  `event_master_id` int(11) NOT NULL,
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS `uhn_ed_ovary_lab_pathologies_revs` (
	report_number varchar(50) DEFAULT NULL,

	left_ovary_tumour_present CHAR(1) DEFAULT '',
	left_ovary_weight_g decimal(10,2) DEFAULT NULL,
	left_ovary_diameter_cm decimal(10,2) DEFAULT NULL,
	left_ovary_surface varchar(50) DEFAULT NULL,
	left_ovary_capsule varchar(50) DEFAULT NULL,
	left_ovary_cut_surface_cysts varchar(50) DEFAULT NULL,
	left_ovary_cut_surface_necrosis varchar(50) DEFAULT NULL,
	
	right_ovary_tumour_present CHAR(1) DEFAULT '',
	right_ovary_weight_g decimal(10,2) DEFAULT NULL,
	right_ovary_diameter_cm decimal(10,2) DEFAULT NULL,
	right_ovary_surface varchar(50) DEFAULT NULL,
	right_ovary_capsule varchar(50) DEFAULT NULL,
	right_ovary_cut_surface_cysts varchar(50) DEFAULT NULL,
	right_ovary_cut_surface_necrosis varchar(50) DEFAULT NULL,
	
	nos_ovary_tumour_present CHAR(1) DEFAULT '',
	nos_ovary_weight_g decimal(10,2) DEFAULT NULL,
	nos_ovary_diameter_cm decimal(10,2) DEFAULT NULL,
	nos_ovary_surface varchar(50) DEFAULT NULL,
	nos_ovary_capsule varchar(50) DEFAULT NULL,
	nos_ovary_cut_surface_cysts varchar(50) DEFAULT NULL,
	nos_ovary_cut_surface_necrosis varchar(50) DEFAULT NULL,
	
	normal_ovary_cortical_inclusions CHAR(1) DEFAULT '',
	normal_ovary_stromal_hyperplasia CHAR(1) DEFAULT '',
	normal_ovary_epithelial_hyperplasia CHAR(1) DEFAULT '',
	normal_ovary_epithelial_dysplasia CHAR(1) DEFAULT '',
	normal_ovary_stromal_fibrosis CHAR(1) DEFAULT '',
	
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
ALTER TABLE `uhn_ed_ovary_lab_pathologies`
  ADD CONSTRAINT `uhn_ed_ovary_lab_pathologies_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
INSERT INTO structures(`alias`) VALUES ('uhn_ed_ovary_lab_pathology');
INSERT INTO structure_value_domains (domain_name, source) VALUES 
("uhn_patho_surface", "StructurePermissibleValuesCustom::getCustomDropdown(\'Patho - Ovarian Surface\')"),
("uhn_patho_capsule", "StructurePermissibleValuesCustom::getCustomDropdown(\'Patho - Ovarian Capsule\')"),
("uhn_patho_cut_surface_cysts", "StructurePermissibleValuesCustom::getCustomDropdown(\'Patho - Ovarian Cut Surface Cysts\')"),
("uhn_patho_cut_surface_necrosis", "StructurePermissibleValuesCustom::getCustomDropdown(\'Patho - varian Cut Surface Necrosis\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) 
VALUES 
('Patho - Ovarian Surface', 'annotation', 1, 50),
('Patho - Ovarian Capsule', 'annotation', 1, 50),
('Patho - Ovarian Cut Surface Cysts', 'annotation', 1, 50),
('Patho - Ovarian Cut Surface Necrosis', 'annotation', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Patho - Ovarian Surface');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('smooth', 'Smooth', '', '1', @control_id),
('adhesions', 'Adhesions', '', '1', @control_id),
('tumour', 'Tumour', '', '1', @control_id),
('n/a', 'N/A', '', '1', @control_id);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Patho - Ovarian Capsule');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('intact', 'Intact', '', '1', @control_id),
('rupture', 'Rupture', '', '1', @control_id),
('open', 'Open', '', '1', @control_id),
('nos', 'NOS', '', '1', @control_id);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Patho - Ovarian Cut Surface Cysts');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('none', 'None', '', '1', @control_id),
('single', 'Single', '', '1', @control_id),
('few (<5)', 'Few (<5)', '', '1', @control_id),
('many', 'Many', '', '1', @control_id);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Patho - Ovarian Cut Surface Necrosis');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('no', 'No', '', '1', @control_id),
('yes', 'Yes', '', '1', @control_id),
('extensive', 'Extensive', '', '1', @control_id),
('all', 'All', '', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'report_number', 'input',  NULL , '0', 'size=30', '', '', 'report number', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'left_ovary_tumour_present', 'yes_no',  NULL , '0', '', '', '', 'tumour present', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'left_ovary_weight_g', 'float',  NULL , '0', 'size=5', '', '', 'weight g', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'left_ovary_diameter_cm', 'float',  NULL , '0', 'size=5', '', '', 'diameter cm', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'left_ovary_surface', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_surface') , '0', '', '', '', 'surface', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'left_ovary_capsule', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_capsule') , '0', '', '', '', 'capsule', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'left_ovary_cut_surface_cysts', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_cysts') , '0', '', '', '', 'cut surface cysts', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'left_ovary_cut_surface_necrosis', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_necrosis') , '0', '', '', '', 'cut surface necrosis', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'right_ovary_tumour_present', 'yes_no',  NULL , '0', '', '', '', 'tumour present', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'right_ovary_weight_g', 'float',  NULL , '0', 'size=5', '', '', 'weight g', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'right_ovary_diameter_cm', 'float',  NULL , '0', 'size=5', '', '', 'diameter cm', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'right_ovary_surface', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_surface') , '0', '', '', '', 'surface', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'right_ovary_capsule', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_capsule') , '0', '', '', '', 'capsule', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'right_ovary_cut_surface_cysts', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_cysts') , '0', '', '', '', 'cut surface cysts', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'right_ovary_cut_surface_necrosis', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_necrosis') , '0', '', '', '', 'cut surface necrosis', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'nos_ovary_tumour_present', 'yes_no',  NULL , '0', '', '', '', 'tumour present', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'nos_ovary_weight_g', 'float',  NULL , '0', 'size=5', '', '', 'weight g', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'nos_ovary_diameter_cm', 'float',  NULL , '0', 'size=5', '', '', 'diameter cm', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'nos_ovary_surface', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_surface') , '0', '', '', '', 'surface', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'nos_ovary_capsule', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_capsule') , '0', '', '', '', 'capsule', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'nos_ovary_cut_surface_cysts', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_cysts') , '0', '', '', '', 'cut surface cysts', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'nos_ovary_cut_surface_necrosis', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_necrosis') , '0', '', '', '', 'cut surface necrosis', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'normal_ovary_cortical_inclusions', 'yes_no',  NULL , '0', '', '', '', 'cortical inclusions', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'normal_ovary_stromal_hyperplasia', 'yes_no',  NULL , '0', '', '', '', 'stromal hyperplasia', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'normal_ovary_epithelial_hyperplasia', 'yes_no',  NULL , '0', '', '', '', 'epithelial hyperplasia', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'normal_ovary_epithelial_dysplasia', 'yes_no',  NULL , '0', '', '', '', 'epithelial dysplasia', ''), 
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'normal_ovary_stromal_fibrosis', 'yes_no',  NULL , '0', '', '', '', 'stromal fibrosis', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='report_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='report number' AND `language_tag`=''), '1', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='left_ovary_tumour_present' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumour present' AND `language_tag`=''), '2', '69', 'left ovary', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='left_ovary_weight_g' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='weight g' AND `language_tag`=''), '2', '70', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='left_ovary_diameter_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='diameter cm' AND `language_tag`=''), '2', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='left_ovary_surface' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_surface')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surface' AND `language_tag`=''), '2', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='left_ovary_capsule' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_capsule')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='capsule' AND `language_tag`=''), '2', '73', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='left_ovary_cut_surface_cysts' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_cysts')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cut surface cysts' AND `language_tag`=''), '2', '74', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='left_ovary_cut_surface_necrosis' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_necrosis')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cut surface necrosis' AND `language_tag`=''), '2', '75', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='right_ovary_tumour_present' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumour present' AND `language_tag`=''), '2', '76', 'right ovary', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='right_ovary_weight_g' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='weight g' AND `language_tag`=''), '2', '77', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='right_ovary_diameter_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='diameter cm' AND `language_tag`=''), '2', '78', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='right_ovary_surface' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_surface')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surface' AND `language_tag`=''), '2', '79', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='right_ovary_capsule' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_capsule')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='capsule' AND `language_tag`=''), '2', '80', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='right_ovary_cut_surface_cysts' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_cysts')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cut surface cysts' AND `language_tag`=''), '2', '81', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='right_ovary_cut_surface_necrosis' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_necrosis')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cut surface necrosis' AND `language_tag`=''), '3', '82', 'nos ovary', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='nos_ovary_tumour_present' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumour present' AND `language_tag`=''), '3', '83', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='nos_ovary_weight_g' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='weight g' AND `language_tag`=''), '3', '84', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='nos_ovary_diameter_cm' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='diameter cm' AND `language_tag`=''), '3', '85', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='nos_ovary_surface' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_surface')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surface' AND `language_tag`=''), '3', '86', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='nos_ovary_capsule' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_capsule')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='capsule' AND `language_tag`=''), '3', '87', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='nos_ovary_cut_surface_cysts' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_cysts')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cut surface cysts' AND `language_tag`=''), '3', '88', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='nos_ovary_cut_surface_necrosis' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_necrosis')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cut surface necrosis' AND `language_tag`=''), '3', '89', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='normal_ovary_cortical_inclusions' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cortical inclusions' AND `language_tag`=''), '3', '90', 'normal ovary', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='normal_ovary_stromal_hyperplasia' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stromal hyperplasia' AND `language_tag`=''), '3', '91', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='normal_ovary_epithelial_hyperplasia' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='epithelial hyperplasia' AND `language_tag`=''), '3', '92', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='normal_ovary_epithelial_dysplasia' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='epithelial dysplasia' AND `language_tag`=''), '3', '93', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='normal_ovary_stromal_fibrosis' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stromal fibrosis' AND `language_tag`=''), '3', '94', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en)
VALUES
('tumour present','Tumour Present'),
('report number','Report #'),
('left ovary', 'Left Ovary'),
('weight g', 'Weight (g)'),
('diameter cm', 'Diameter (cm)'),
('surface', 'Surface'),
('capsule', 'Capsule'),
('cut surface cysts', 'Cut Surface Cysts'),
('cut surface necrosis', 'Cut Surface Necrosis'),
('right ovary','Right Ovary'),
('normal ovary','Normal Ovary'),
('nos ovary','NOS Ovary');
INSERT IGNORE INTO i18n (id,en)
VALUES
('cortical inclusions','Cortical Inclusions'),
('stromal hyperplasia','Stromal Hyperplasia'),
('epithelial hyperplasia','Epithelial Hyperplasia'),
('epithelial dysplasia','Epithelial Dysplasia'),
('stromal fibrosis','Stromal Fibrosis');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='right_ovary_cut_surface_necrosis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_necrosis') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='nos ovary' WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='nos_ovary_tumour_present' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='right_ovary_cut_surface_necrosis' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_cut_surface_necrosis') AND `flag_confidential`='0');
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Patho - Ovarian Cut Surface Necrosis\')" WHERE domain_name = "uhn_patho_cut_surface_necrosis";
ALTER TABLE uhn_ed_ovary_lab_pathologies ADD COLUMN endometrium VARCHAR(50) DEFAULT NULL;
ALTER TABLE uhn_ed_ovary_lab_pathologies_revs ADD COLUMN endometrium VARCHAR(50) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) VALUES 
("uhn_patho_endometrium", "StructurePermissibleValuesCustom::getCustomDropdown(\'Patho - Endometrium\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, flag_active, values_max_length) 
VALUES 
('Patho - Endometrium', 'annotation', 1, 50);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Patho - Endometrium');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('inactive', 'Inactive', '', '1', @control_id),
('atrophic', 'Atrophic', '', '1', @control_id),
('proliferative', 'Proliferative', '', '1', @control_id),
('secretory', 'Secretory', '', '1', @control_id),
('hyperplasia', 'Hyperplasia', '', '1', @control_id),
('carcinoma', 'Carcinoma', '', '1', @control_id),
('other', 'Other', '', '1', @control_id),
('not documented', 'Not Documented', '', '1', @control_id),
('n/a', 'N/A', '', '1', @control_id);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'uhn_ed_ovary_lab_pathologies', 'endometrium', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_endometrium') , '0', '', '', '', 'endometrium', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='endometrium' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_endometrium')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='endometrium' AND `language_tag`=''), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) VALUES ('endometrium','Endometrium');
UPDATE structure_formats SET `display_column`='3', `display_order`='95', `language_heading`='endometrium' WHERE structure_id=(SELECT id FROM structures WHERE alias='uhn_ed_ovary_lab_pathology') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='uhn_ed_ovary_lab_pathologies' AND `field`='endometrium' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_patho_endometrium') AND `flag_confidential`='0');

-- event master

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ('ca125','Ca125');

UPDATE event_controls SET use_detail_form_for_index = 1 WHERE flag_active = 1 AND event_type = 'ca125';

-- follow-up

UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters%' AND language_title = 'clinical';
UPDATE event_controls SET flag_active = 1 WHERE event_type = 'follow up';
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='weight' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='recurrence_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='disease_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Vital Status\')" WHERE domain_name = "vital_status_code";
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='vital_status_code';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length) VALUES ('Vital Status', 1, 50);
UPDATE structure_permissible_values_custom_controls SET flag_active = 1, category = 'follow up' WHERE name = 'Vital Status'; 
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Vital Status');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`) 
VALUES
('alive-no known disease', 'Alive-No known disease', '', '1', @control_id),
('alive-with disease', 'Alive-With disease', '', '1', @control_id),
('alive-unknown disease status', 'Alive-Unknown disease status', '', '1', @control_id),
('dead of disease', 'Dead of disease', '', '1', @control_id),
('dead-no known disease', 'Dead-No known disease', '', '1', @control_id),
('dead with disease', 'Dead with disease', '', '1', @control_id),
('dead of complications with disease', 'Dead of complications with disease', '', '1', @control_id),
('dead of complications with out disease', 'Dead of complications with out disease', '', '1', @control_id),
('dead-unknown disease status', 'Dead-Unknown disease status', '', '1', @control_id),
('lost to follow up', 'Lost to follow up', '', '1', @control_id),
('unknown', 'Unknown', '', '1', @control_id);
UPDATE event_controls SET use_detail_form_for_index = 1, use_addgrid = 1 WHERE flag_active = 1 AND event_type = 'follow up';
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='vital_status_code') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------
-- Family Histories
-- ----------------------------------------------------------------------------------------------------------------------- 

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='previous_primary_code_system' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='familyhistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE family_histories ADD COLUMN uhn_site varchar(100) DEFAULT NULL;
ALTER TABLE family_histories_revs ADD COLUMN uhn_site varchar(100) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FamilyHistory', 'family_histories', 'uhn_site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site') , '0', '', '', '', 'site', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='uhn_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='uhn_diagnosis_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_validations(structure_field_id, rule) VALUES
((SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='uhn_site'), 'notEmpty');
















