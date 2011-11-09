









INSERT INTO `diagnosis_controls` (`id`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph. progression', 1, 'ld_lymph_dx_progressions', 'ld_lymph_dx_progressions', 0, 'ld lymph. progression');


UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("progression","progression");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="origin"),  
(SELECT id FROM structure_permissible_values WHERE value="progression" AND language_alias="progression"), "1", "1");

UPDATE structure_value_domains_permissible_values SET flag_active = '0'
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="origin")
AND structure_permissible_value_id NOT IN (SELECT id FROM structure_permissible_values WHERE (value="progression" AND language_alias="progression") OR (value="primary" AND language_alias="primary"));

INSERT INTO i18n (id,en) VALUES 
("a progression should be linked to an existing diagnoses group", "A progression should be linked to an existing diagnoses group!"),
("the diagnoses group of a diagnosis can not be changed","The diagnoses group of a diagnosis can not be changed!"),
("a new diagnostic should be linked to a new diagnoses group","A new diagnostic should be linked to a new diagnoses group!"),
('all progression of the group should be deleted frist', 'All progression of the group should be deleted frist!');

CREATE TABLE IF NOT EXISTS `ld_lymph_dx_progressions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `site` varchar(100) DEFAULT '',  
  `trt_at_progression` varchar(50) DEFAULT '',  
  `stem_cell_transplant` char(1) DEFAULT '',  
  `stem_cell_transplant_date` date DEFAULT NULL,
  `stem_cell_transplant_date_accuracy` char(1) NOT NULL DEFAULT '',

  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_dx_progressions`
  ADD CONSTRAINT `FK_ld_lymph_dx_progressions_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_dx_progressions_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  
  `site` varchar(100) DEFAULT '',  
  `trt_at_progression` varchar(50) DEFAULT '',  
  `stem_cell_transplant` char(1) DEFAULT '',  
  `stem_cell_transplant_date` date DEFAULT NULL,
  `stem_cell_transplant_date_accuracy` char(1) NOT NULL DEFAULT '',
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_dx_progressions');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '4', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_primary number' AND `language_label`='primary_number' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx origin' AND `language_label`='origin' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '13', '', '0', '', '0', '', '1', 'help_memo', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('digestive-anal','digestive-anal'),
('digestive-appendix','digestive-appendix'),
('digestive-bile ducts','digestive-bile ducts'),
('digestive-colonic','digestive-colonic'),
('digestive-esophageal','digestive-esophageal'),
('digestive-gallbladder','digestive-gallbladder'),
('digestive-liver','digestive-liver'),
('digestive-pancreas','digestive-pancreas'),
('digestive-rectal','digestive-rectal'),
('digestive-small intestine','digestive-small intestine'),
('digestive-stomach','digestive-stomach'),
('digestive-other digestive','digestive-other digestive'),
('thoracic-lung','thoracic-lung'),
('thoracic-mesothelioma','thoracic-mesothelioma'),
('thoracic-other thoracic','thoracic-other thoracic'),
('ophthalmic-eye','ophthalmic-eye'),
('ophthalmic-other eye','ophthalmic-other eye'),
('breast-breast','breast-breast'),
('female genital-cervical','female genital-cervical'),
('female genital-endometrium','female genital-endometrium'),
('female genital-fallopian tube','female genital-fallopian tube'),
('female genital-gestational trophoblastic neoplasia','female genital-gestational trophoblastic neoplasia'),
('female genital-ovary','female genital-ovary'),
('female genital-peritoneal','female genital-peritoneal'),
('female genital-uterine','female genital-uterine'),
('female genital-vulva','female genital-vulva'),
('female genital-vagina','female genital-vagina'),
('female genital-other female genital','female genital-other female genital'),
('head & neck-larynx','head & neck-larynx'),
('head & neck-nasal cavity and sinuses','head & neck-nasal cavity and sinuses'),
('head & neck-lip and oral cavity','head & neck-lip and oral cavity'),
('head & neck-pharynx','head & neck-pharynx'),
('head & neck-thyroid','head & neck-thyroid'),
('head & neck-salivary glands','head & neck-salivary glands'),
('head & neck-other head & neck','head & neck-other head & neck'),
('haematological-leukemia','haematological-leukemia'),
('haematological-lymphoma','haematological-lymphoma'),
('haematological-hodgkin''s disease','haematological-hodgkin''s disease'),
('haematological-non-hodgkin''s lymphomas','haematological-non-hodgkin''s lymphomas'),
('haematological-other haematological','haematological-other haematological'),
('skin-melanoma','skin-melanoma'),
('skin-non melanomas','skin-non melanomas'),
('skin-other skin','skin-other skin'),
('urinary tract-bladder','urinary tract-bladder'),
('urinary tract-renal pelvis and ureter','urinary tract-renal pelvis and ureter'),
('urinary tract-kidney','urinary tract-kidney'),
('urinary tract-urethra','urinary tract-urethra'),
('urinary tract-other urinary tract','urinary tract-other urinary tract'),
('central nervous system-brain','central nervous system-brain'),
('central nervous system-spinal cord','central nervous system-spinal cord'),
('central nervous system-other central nervous system','central nervous system-other central nervous system'),
('musculoskeletal sites-soft tissue sarcoma','musculoskeletal sites-soft tissue sarcoma'),
('musculoskeletal sites-bone','musculoskeletal sites-bone'),
('musculoskeletal sites-other bone','musculoskeletal sites-other bone'),
('other-primary unknown','other-primary unknown'),
('other-gross metastatic disease','other-gross metastatic disease');

INSERT INTO structure_value_domains(`domain_name`, `override`, `category`, `source`) VALUES ('ld_lymph_tumour_site', '', '', NULL);
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="breast-breast" AND language_alias="breast-breast"), "1", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-brain" AND language_alias="central nervous system-brain"), "10", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-spinal cord" AND language_alias="central nervous system-spinal cord"), "11", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="central nervous system-other central nervous system" AND language_alias="central nervous system-other central nervous system"), "12", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-anal" AND language_alias="digestive-anal"), "21", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-appendix" AND language_alias="digestive-appendix"), "22", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-bile ducts" AND language_alias="digestive-bile ducts"), "23", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-colonic" AND language_alias="digestive-colonic"), "24", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-esophageal" AND language_alias="digestive-esophageal"), "25", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-gallbladder" AND language_alias="digestive-gallbladder"), "26", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-liver" AND language_alias="digestive-liver"), "27", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-pancreas" AND language_alias="digestive-pancreas"), "28", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-rectal" AND language_alias="digestive-rectal"), "29", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-small intestine" AND language_alias="digestive-small intestine"), "30", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-stomach" AND language_alias="digestive-stomach"), "31", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="digestive-other digestive" AND language_alias="digestive-other digestive"), "32", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-cervical" AND language_alias="female genital-cervical"), "40", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-endometrium" AND language_alias="female genital-endometrium"), "41", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-fallopian tube" AND language_alias="female genital-fallopian tube"), "42", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-gestational trophoblastic neoplasia" AND language_alias="female genital-gestational trophoblastic neoplasia"), "43", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-ovary" AND language_alias="female genital-ovary"), "44", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-peritoneal" AND language_alias="female genital-peritoneal"), "45", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-uterine" AND language_alias="female genital-uterine"), "46", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-vulva" AND language_alias="female genital-vulva"), "47", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-vagina" AND language_alias="female genital-vagina"), "48", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="female genital-other female genital" AND language_alias="female genital-other female genital"), "49", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-leukemia" AND language_alias="haematological-leukemia"), "60", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-lymphoma" AND language_alias="haematological-lymphoma"), "61", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-non-hodgkin's lymphomas" AND language_alias="haematological-non-hodgkin's lymphomas"), "62", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-hodgkin's disease" AND language_alias="haematological-hodgkin's disease"), "63", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="haematological-other haematological" AND language_alias="haematological-other haematological"), "64", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-larynx" AND language_alias="head & neck-larynx"), "70", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-lip and oral cavity" AND language_alias="head & neck-lip and oral cavity"), "71", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-nasal cavity and sinuses" AND language_alias="head & neck-nasal cavity and sinuses"), "72", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-pharynx" AND language_alias="head & neck-pharynx"), "73", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-salivary glands" AND language_alias="head & neck-salivary glands"), "74", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-thyroid" AND language_alias="head & neck-thyroid"), "75", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="head & neck-other head & neck" AND language_alias="head & neck-other head & neck"), "76", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-bone" AND language_alias="musculoskeletal sites-bone"), "80", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-soft tissue sarcoma" AND language_alias="musculoskeletal sites-soft tissue sarcoma"), "81", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="musculoskeletal sites-other bone" AND language_alias="musculoskeletal sites-other bone"), "82", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="ophthalmic-eye" AND language_alias="ophthalmic-eye"), "116", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="ophthalmic-other eye" AND language_alias="ophthalmic-other eye"), "117", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-melanoma" AND language_alias="skin-melanoma"), "121", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-non melanomas" AND language_alias="skin-non melanomas"), "122", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="skin-other skin" AND language_alias="skin-other skin"), "123", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-lung" AND language_alias="thoracic-lung"), "133", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-mesothelioma" AND language_alias="thoracic-mesothelioma"), "134", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="thoracic-other thoracic" AND language_alias="thoracic-other thoracic"), "135", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-bladder" AND language_alias="urinary tract-bladder"), "144", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-kidney" AND language_alias="urinary tract-kidney"), "145", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-renal pelvis and ureter" AND language_alias="urinary tract-renal pelvis and ureter"), "146", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-urethra" AND language_alias="urinary tract-urethra"), "147", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="urinary tract-other urinary tract" AND language_alias="urinary tract-other urinary tract"), "148", "1"),

((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="other-primary unknown" AND language_alias="other-primary unknown"), "255", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"), (SELECT id FROM structure_permissible_values WHERE value="other-gross metastatic disease" AND language_alias="other-gross metastatic disease"), "256", "1");

INSERT INTO i18n (id,en) VALUES 
('digestive-anal','Digestive - Anal'),
('digestive-appendix','Digestive - Appendix'),
('digestive-bile ducts','Digestive - Bile Ducts'),
('digestive-colonic','Digestive - Colonic'),
('digestive-esophageal','Digestive - Esophageal'),
('digestive-gallbladder','Digestive - Gallbladder'),
('digestive-liver','Digestive - Liver'),
('digestive-pancreas','Digestive - Pancreas'),
('digestive-rectal','Digestive - Rectal'),
('digestive-small intestine','Digestive - Small Intestine'),
('digestive-stomach','Digestive - Stomach'),
('digestive-other digestive','Digestive - Other Digestive'),
('thoracic-lung','Thoracic - Lung'),
('thoracic-mesothelioma','Thoracic - Mesothelioma'),
('thoracic-other thoracic','Thoracic - Other Thoracic'),
('ophthalmic-eye','Ophthalmic - Eye'),
('ophthalmic-other eye','Ophthalmic - Other Eye'),
('breast-breast','Breast - Breast'),
('female genital-cervical','Female Genital - Cervical'),
('female genital-endometrium','Female Genital - Endometrium'),
('female genital-fallopian tube','Female Genital - Fallopian Tube'),
('female genital-gestational trophoblastic neoplasia','Female Genital - Gestational Trophoblastic Neoplasia'),
('female genital-ovary','Female Genital - Ovary'),
('female genital-peritoneal','Female Genital - Peritoneal'),
('female genital-uterine','Female Genital - Uterine'),
('female genital-vulva','Female Genital - Vulva'),
('female genital-vagina','Female Genital - Vagina'),
('female genital-other female genital','Female Genital - Other Female Genital'),
('head & neck-larynx','Head & Neck - Larynx'),
('head & neck-nasal cavity and sinuses','Head & Neck - Nasal Cavity and Sinuses'),
('head & neck-lip and oral cavity','Head & Neck - Lip and Oral Cavity'),
('head & neck-pharynx','Head & Neck - Pharynx'),
('head & neck-thyroid','Head & Neck - Thyroid'),
('head & neck-salivary glands','Head & Neck - Salivary Glands'),
('head & neck-other head & neck','Head & Neck - Other Head & Neck'),
('haematological-leukemia','Haematological - Leukemia'),
('haematological-lymphoma','Haematological - Lymphoma'),
('haematological-hodgkin''s disease','Haematological - Hodgkin''s Disease'),
('haematological-non-hodgkin''s lymphomas','Haematological - Non-Hodgkin''s Lymphomas'),
('haematological-other haematological','Haematological-Other Haematological'),
('skin-melanoma','Skin - Melanoma'),
('skin-non melanomas','Skin - Non Melanomas'),
('skin-other skin','Skin - Other Skin'),
('urinary tract-bladder','Urinary Tract - Bladder'),
('urinary tract-renal pelvis and ureter','Urinary Tract - Renal Pelvis and Ureter'),
('urinary tract-kidney','Urinary Tract - Kidney'),
('urinary tract-urethra','Urinary Tract - Urethra'),
('urinary tract-other urinary tract','Urinary Tract - Other Urinary Tract'),
('central nervous system-brain','Central Nervous System - Brain'),
('central nervous system-spinal cord','Central Nervous System - Spinal Cord'),
('central nervous system-other central nervous system','Central Nervous System - Other Central Nervous System'),
('musculoskeletal sites-soft tissue sarcoma','Musculoskeletal Sites - Soft Tissue Sarcoma'),
('musculoskeletal sites-bone','Musculoskeletal Sites - Bone'),
('musculoskeletal sites-other bone','Musculoskeletal Sites - Other Bone'),
('other-primary unknown','Other - Primary Unknown'),
('other-gross metastatic disease','Other - Gross Metastatic Disease');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_trt_at_progression', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''treatment at progression'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length) VALUES ('treatment at progression', '1', '50');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_progressions', 'site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_tumour_site') , '0', '', '', '', 'site', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_progressions', 'trt_at_progression', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_trt_at_progression') , '0', '', '', '', 'trt at progression', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_progressions', 'stem_cell_transplant', 'yes_no',  NULL , '0', '', '', '', 'stem cell transplant', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_progressions', 'stem_cell_transplant_date', 'date',  NULL , '0', '', '', '', 'stem cell transplant date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_progressions' AND `field`='site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_tumour_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_progressions' AND `field`='trt_at_progression' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_trt_at_progression')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='trt at progression' AND `language_tag`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_progressions' AND `field`='stem_cell_transplant' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stem cell transplant' AND `language_tag`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_progressions' AND `field`='stem_cell_transplant_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stem cell transplant date' AND `language_tag`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES 
('site','Site'),
('trt at progression','Treatment at Progression'),
('stem cell transplant','Stem Cell Transplant'),
('stem cell transplant date','SCT Date'),
('sct','SCT');

UPDATE structure_fields SET  `language_label`='sct' WHERE model='DiagnosisDetail' AND tablename='ld_lymph_dx_progressions' AND field='stem_cell_transplant' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `language_heading`='stem cell transplant' WHERE structure_id=(SELECT id FROM structures WHERE alias='ld_lymph_dx_progressions') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_progressions' AND `field`='stem_cell_transplant' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_tumour_site"),  
(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "100", "1");

UPDATE event_controls SET flag_active = 0;

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph.', 'clinical', 'follow up', 1, 'ld_lymph_followup', 'ed_all_clinical_followups', 0, 'clinical|ld lymph.|follow up');

INSERT INTO structures(`alias`) VALUES ('ld_lymph_followup');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_followup'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_followup'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_followup'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='vital_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='vital_status_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='vital status' AND `language_tag`=''), '1', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_followup'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');


INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='event_summary'), (SELECT id FROM structure_fields WHERE `model`='EventControl' AND `field`='event_type'), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  WHERE model='EventControl' AND tablename='event_controls' AND field='disease_site' AND `type`='input' AND structure_value_domain  IS NULL ;




INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph.', 'study', 'research study', 1, 'ld_lymph_ed_research_studies', 'ld_lymph_ed_research_studies', 0, 'study|ld lymph.|research study');

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_research_studies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL DEFAULT '0',
	
  `name` varchar(50) DEFAULT '',
  `consent_date` date DEFAULT null,
  `germ_dna_available` char(1) DEFAULT '',
  
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_ed_research_studies`
  ADD CONSTRAINT `FK_ld_lymph_ed_research_studies_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_research_studies_revs` (
  `id` int(11) NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,
  
  `name` varchar(50) DEFAULT '',
  `consent_date` date DEFAULT null,
  `germ_dna_available` char(1) DEFAULT '',
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_ed_research_studies');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_research_studies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_research_studies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_research_studies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '1', 'start date', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_research_studies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT IGNORE into i18n (id,en) VALUES ('start date','Start Date');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_research_studies', 'name', 'input',  NULL , '0', 'size=20', '', '', 'name', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_research_studies', 'consent_date', 'date',  NULL , '0', '', '', '', 'consent date', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_research_studies', 'germ_dna_available', 'yes_no',  NULL , '0', '', '', '', 'germ dna available', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_research_studies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_research_studies' AND `field`='name' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='name' AND `language_tag`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_research_studies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_research_studies' AND `field`='consent_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='consent date' AND `language_tag`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_research_studies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_research_studies' AND `field`='germ_dna_available' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='germ dna available' AND `language_tag`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

INSERT IGNORE INTO i18n (id,en) VALUES 
('research study', 'Research Study'),
('consent date','Consent Date'),
('germ dna available','Germ. DNA Available');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph.', 'lab', 'immunohistochemistry', 1, 'ld_lymph_ed_immunohistochemistries', 'ld_lymph_ed_immunohistochemistries', 0, 'lab|ld lymph.|immunohistochemistry');

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_immunohistochemistries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL DEFAULT '0',
	
  `cd10` varchar(20) DEFAULT '',
  `bcl2_pr` varchar(20) DEFAULT '',
  `bcl6_pr` varchar(20) DEFAULT '',
  `mum1` varchar(20) DEFAULT '',
  `pheno_b_t` varchar(20) DEFAULT '',
  `ki67_percent` decimal(5,2) DEFAULT null,
  
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_ed_immunohistochemistries`
  ADD CONSTRAINT `FK_ld_lymph_ed_immunohistochemistries_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_immunohistochemistries_revs` (
  `id` int(11) NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,

  `cd10` varchar(20) DEFAULT '',
  `bcl2_pr` varchar(20) DEFAULT '',
  `bcl6_pr` varchar(20) DEFAULT '',
  `mum1` varchar(20) DEFAULT '',
  `pheno_b_t` varchar(20) DEFAULT '',
  `ki67_percent` decimal(5,2) DEFAULT null,
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_pheno_b_vs_t', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("B","pheno_b"),("T","pheno_t");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_pheno_b_vs_t"),  
(SELECT id FROM structure_permissible_values WHERE value="B" AND language_alias="pheno_b"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_pheno_b_vs_t"),  
(SELECT id FROM structure_permissible_values WHERE value="T" AND language_alias="pheno_t"), "2", "1");

INSERT IGNORE INTO i18n (id,en) VALUES ("pheno_b","B"), ("pheno_t","T");

INSERT INTO structures(`alias`) VALUES ('ld_lymph_ed_immunohistochemistries');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_immunohistochemistries'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_immunohistochemistries'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_immunohistochemistries'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_immunohistochemistries'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_immunohistochemistries', 'cd10', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values') , '0', '', '', '', 'cd10', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_immunohistochemistries', 'bcl2_pr', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values') , '0', '', '', '', 'bcl2 pr', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_immunohistochemistries', 'bcl6_pr', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values') , '0', '', '', '', 'bcl6 pr', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_immunohistochemistries', 'mum1', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values') , '0', '', '', '', 'mum1', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_immunohistochemistries', 'pheno_b_t', 'input', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_pheno_b_vs_t') , '0', '', '', '', 'pheno b t', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_immunohistochemistries', 'ki67_percent', 'float',  NULL , '0', 'size=5', '', '', 'ki67 percent', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_immunohistochemistries'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_immunohistochemistries' AND `field`='cd10' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cd10' AND `language_tag`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_immunohistochemistries'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_immunohistochemistries' AND `field`='bcl2_pr' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bcl2 pr' AND `language_tag`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_immunohistochemistries'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_immunohistochemistries' AND `field`='bcl6_pr' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bcl6 pr' AND `language_tag`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_immunohistochemistries'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_immunohistochemistries' AND `field`='mum1' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_labs_test_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mum1' AND `language_tag`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_immunohistochemistries'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_immunohistochemistries' AND `field`='pheno_b_t' AND `type`='input' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_pheno_b_vs_t')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pheno b t' AND `language_tag`=''), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_immunohistochemistries'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_immunohistochemistries' AND `field`='ki67_percent' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='ki67 percent' AND `language_tag`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

UPDATE structure_fields SET `type`='select'
WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_immunohistochemistries' AND `field`='pheno_b_t' AND `type`='input';

INSERT IGNORE INTO i18n (id,en) VALUES 
('bcl2 pr' ,'BCL2 pr'),
('bcl6 pr' ,'BCL6 pr'),
('cd10' ,'CD10'),
('ki67 percent' ,'KI67 (%)'),
('mum1' ,'MUM1'),
('pheno b t' ,'Pheno (B vs T)');

INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph.', 'clinical', 'initial biopsy', 1, 'ld_lymph_ed_initial_biopsies', 'ld_lymph_ed_biopsies', 0, 'clinical|ld lymph.|initial biopsy'),
(null, 'ld lymph.', 'clinical', 'subsequent biopsy', 1, 'ld_lymph_ed_subsequent_biopsies', 'ld_lymph_ed_biopsies', 0, 'clinical|ld lymph.|subsequent biopsy');

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_biopsies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_master_id` int(11) NOT NULL DEFAULT '0',
	
  `site` varchar(50) DEFAULT '',
  `surgery_nbr` varchar(50) DEFAULT '',
  `ref_center` varchar(50) DEFAULT '',
  `biopsy_reviewer` varchar(50) DEFAULT '',
  `patho_nbr` varchar(50) DEFAULT '',
  `who_class` varchar(50) DEFAULT '',
  `other_investigations` text,
  
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_ed_biopsies`
  ADD CONSTRAINT `FK_ld_lymph_ed_biopsies_event_masters` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_ed_biopsies_revs` (
  `id` int(11) NOT NULL,
  `event_master_id` int(11) DEFAULT NULL,

  `site` varchar(50) DEFAULT '',
  `surgery_nbr` varchar(50) DEFAULT '',
  `ref_center` varchar(50) DEFAULT '',
  `biopsy_reviewer` varchar(50) DEFAULT '',
  `patho_nbr` varchar(50) DEFAULT '',
  `who_class` varchar(50) DEFAULT '',
  `other_investigations` text,
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_ed_initial_biopsies');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_initial_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_initial_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_initial_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_initial_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structures(`alias`) VALUES ('ld_lymph_ed_subsequent_biopsies');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_subsequent_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='disease_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='event_form_type' AND `language_tag`=''), '1', '-10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_subsequent_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '1', '-9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_subsequent_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_subsequent_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES 
(NULL, 'custom_biopsy_sites_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''biopsy sites'')'),
(NULL, 'custom_biopsy_ref_centers_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''biopsy ref centers'')'),
(NULL, 'custom_biopsy_reviewers_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''biopsy reviewers'')');

INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('biopsy sites', '1', '50'), ('biopsy ref centers', '1', '50'), ('biopsy reviewers', '1', '50');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_biopsies', 'site', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_biopsy_sites_list') , '0', '', '', '', 'site', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_biopsies', 'surgery_nbr', 'input',  NULL , '0', 'size=20', '', '', 'surgery nbr', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_biopsies', 'ref_center', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_biopsy_ref_centers_list') , '0', '', '', '', 'ref center', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_biopsies', 'biopsy_reviewer', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_biopsy_reviewers_list') , '0', '', '', '', 'biopsy reviewer', ''), 
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_biopsies', 'patho_nbr', 'input',  NULL , '0', 'size=20', '', '', 'patho nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_initial_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_biopsy_sites_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_initial_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='surgery_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='surgery nbr' AND `language_tag`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_initial_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='ref_center' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_biopsy_ref_centers_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ref center' AND `language_tag`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_initial_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='biopsy_reviewer' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_biopsy_reviewers_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy reviewer' AND `language_tag`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_initial_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'ld_lymph_ed_biopsies', 'other_investigations', 'textarea',  NULL , '0', 'rows=2,cols=30', '', '', 'other investigations', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_subsequent_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_biopsy_sites_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='site' AND `language_tag`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_subsequent_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='surgery_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='surgery nbr' AND `language_tag`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_subsequent_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='ref_center' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_biopsy_ref_centers_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ref center' AND `language_tag`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_subsequent_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='biopsy_reviewer' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_biopsy_reviewers_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biopsy reviewer' AND `language_tag`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_subsequent_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='patho nbr' AND `language_tag`=''), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_subsequent_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='other_investigations' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='other investigations' AND `language_tag`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES 
('initial biopsy','Initial Biopsy'),
('subsequent biopsy','Subsequent Biopsy'),

('surgery nbr' , 'Surg#'),
('ref center' , 'Ref Center'),
('biopsy reviewer' , 'Path reviewed by MD'),
('patho nbr' , 'Path'),
('other investigations' , 'Other Investigations');

INSERT INTO `structure_fields` (`id`, `public_identifier`, `plugin`, `model`, `tablename`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `structure_value_domain`, `language_help`, `validation_control`, `value_domain_control`, `field_control`, `flag_confidential`) VALUES
(null, '', 'Clinicalannotation', 'EventDetail', 'ld_lymph_ed_biopsies', 'who_class', 'who class', '', 'autocomplete', 'size=10,url=/codingicd/CodingIcdo3s/autocomplete/morpho,tool=/codingicd/CodingIcdo3s/tool/morpho', '', NULL, '', 'open', 'open', 'open', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_ed_initial_biopsies'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ld_lymph_ed_biopsies' AND `field`='who_class'), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES ('who class', 'WHO Class');

UPDATE structure_formats
SET `flag_override_label` = '1', `language_label` = 'notes'
WHERE structure_id IN (SELECT st.id FROM structures as st INNER JOIN event_controls as ev ON ev.form_alias = st.alias AND ev.flag_active = '1')
AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary');

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='eventmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='process_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='date_first_contact' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en) VALUES 
("an initial biopsy should be linked to a primary diagnosis","An initial biopsy should be linked to a primary diagnosis!"),
('2 initial biopsies are linked to the same diagnosis','Two initial biopsies are linked to the same diagnosis!');

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/clinicalannotation%' AND language_title IN ('family history','reproductive history');
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/drug%' ;
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/protocol%' ;
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/labbook%' ;

UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/study%' AND language_title NOT IN ('tool_study','tool_summary');
 
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='disease site 3') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_science' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_science') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='study_use' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_use') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='abstract' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='hypothesis' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='approach' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='analysis' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='significance' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='additional_clinical' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='path_to_file' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE tx_controls SET flag_active = '0';
INSERT INTO `tx_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `form_alias`, `extend_tablename`, `extend_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`) VALUES
(null, 'primary treatment', 'ld lymph.', 1, 'ld_lymph_txd_primary_treatments', 'ld_lymph_txd_primary_treatments', NULL, NULL, 0, NULL, NULL, 'ld lymph.|primary treatment');

CREATE TABLE IF NOT EXISTS `ld_lymph_txd_primary_treatments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,

  `primary_treatment_type` varchar(50) DEFAULT '',
  `chemo_regimen` varchar(100) DEFAULT '',
  `dose_modified` char(1) DEFAULT '',
  `dose_modified_precision` text,

  `response` varchar(50) DEFAULT '',
  `based_on` varchar(50) DEFAULT '',
  `based_on_other` varchar(50) DEFAULT '',
  `mid_cycle_pet_ct_date` date DEFAULT null,
  `suv_mid` decimal(7,2) DEFAULT null,
  `final_pet_ct_date` date DEFAULT null,
  `suv_final` decimal(7,2) DEFAULT null,

  `tx_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_txd_primary_treatments`
  ADD CONSTRAINT `FK_ld_lymph_txd_primary_treatments_tx_masters` FOREIGN KEY (`tx_master_id`) REFERENCES `tx_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_txd_primary_treatments_revs` (
  `id` int(11) NOT NULL,

  `primary_treatment_type` varchar(50) DEFAULT '',
  `chemo_regimen` varchar(100) DEFAULT '',
  `dose_modified` char(1) DEFAULT '',
  `dose_modified_precision` text,

  `response` varchar(50) DEFAULT '',
  `based_on` varchar(50) DEFAULT '',
  `based_on_other` varchar(50) DEFAULT '',
  `mid_cycle_pet_ct_date` date DEFAULT null,
  `suv_mid` decimal(7,2) DEFAULT null,
  `final_pet_ct_date` date DEFAULT null,
  `suv_final` decimal(7,2) DEFAULT null,

  `tx_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_txd_primary_treatments');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_method' AND `language_label`='' AND `language_tag`=''), '1', '1', 'clin_treatment', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='start_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_start_date' AND `language_label`='start date' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='protocol_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='treatmentmasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='tx_masters' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_primary_trt_types', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("observation","observation"),("frail","frail palliative"),("chemo","chemo");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_primary_trt_types"),  
(SELECT id FROM structure_permissible_values WHERE value="observation" AND language_alias="observation"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_primary_trt_types"),  
(SELECT id FROM structure_permissible_values WHERE value="frail" AND language_alias="frail palliative"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_primary_trt_types"),  
(SELECT id FROM structure_permissible_values WHERE value="chemo" AND language_alias="chemo"), "3", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) 
VALUES 
(NULL, 'custom_chemo_regimens_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''chemo regimens'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('chemo regimens', '1', '100');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_trt_responses', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) 
VALUES ("CR","CR trt responses"),("PR","PR trt responses"),("SD","SD trt responses"),("PD","PD trt responses");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_responses"),  
(SELECT id FROM structure_permissible_values WHERE value="CR" AND language_alias="CR trt responses"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_responses"),  
(SELECT id FROM structure_permissible_values WHERE value="PR" AND language_alias="PR trt responses"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_responses"),  
(SELECT id FROM structure_permissible_values WHERE value="SD" AND language_alias="SD trt responses"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_responses"),  
(SELECT id FROM structure_permissible_values WHERE value="PD" AND language_alias="PD trt responses"), "4", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_trt_response_based_on', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("CT","based on CT"),("PET","based on PET"),("PE","based on PE"),("other","other");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_response_based_on"),  
(SELECT id FROM structure_permissible_values WHERE value="CT" AND language_alias="based on CT"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_response_based_on"),  
(SELECT id FROM structure_permissible_values WHERE value="PET" AND language_alias="based on PET"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_response_based_on"),  
(SELECT id FROM structure_permissible_values WHERE value="PE" AND language_alias="based on PE"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_trt_response_based_on"),  
(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "4", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_primary_treatments', 'primary_treatment_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_primary_trt_types') , '0', '', '', '', 'primary treatment type', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_primary_treatments', 'chemo_regimen', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_chemo_regimens_list') , '0', '', '', '', 'chemo regimen', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_primary_treatments', 'dose_modified', 'yes_no',  NULL , '0', '', '', '', 'dose modified', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_primary_treatments', 'dose_modified_precision', 'input',  NULL , '0', 'size=30', '', '', 'dose modified precision', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_primary_treatments', 'response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_trt_responses') , '0', '', '', '', 'response', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_primary_treatments', 'based_on', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_trt_response_based_on') , '0', '', '', '', 'based on', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_primary_treatments', 'based_on_other', 'input',  NULL , '0', 'size=30', '', '', 'based on other', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_primary_treatments', 'mid_cycle_pet_ct_date', 'date',  NULL , '0', '', '', '', 'mid cycle pet ct date', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_primary_treatments', 'suv_mid', 'float',  NULL , '0', '', '', '', 'suv mid', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_primary_treatments', 'final_pet_ct_date', 'date',  NULL , '0', '', '', '', 'final pet ct date', ''), 
('Clinicalannotation', 'TreatmentDetail', 'ld_lymph_txd_primary_treatments', 'suv_final', 'float',  NULL , '0', '', '', '', 'suv final', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_primary_treatments' AND `field`='primary_treatment_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_primary_trt_types')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='primary treatment type' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_primary_treatments' AND `field`='chemo_regimen' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_chemo_regimens_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='chemo regimen' AND `language_tag`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_primary_treatments' AND `field`='dose_modified' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='dose modified' AND `language_tag`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_primary_treatments' AND `field`='dose_modified_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='dose modified precision' AND `language_tag`=''), '1', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_primary_treatments' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_trt_responses')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='response' AND `language_tag`=''), '2', '30', 'response', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_primary_treatments' AND `field`='based_on' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_trt_response_based_on')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='based on' AND `language_tag`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_primary_treatments' AND `field`='based_on_other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='based on other' AND `language_tag`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_primary_treatments' AND `field`='mid_cycle_pet_ct_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mid cycle pet ct date' AND `language_tag`=''), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_primary_treatments' AND `field`='suv_mid' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='suv mid' AND `language_tag`=''), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_primary_treatments' AND `field`='final_pet_ct_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='final pet ct date' AND `language_tag`=''), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_txd_primary_treatments'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='ld_lymph_txd_primary_treatments' AND `field`='suv_final' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='suv final' AND `language_tag`=''), '2', '37', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en) VALUES
('based on' ,'Based On'),
('based on CT' ,'CT'),
('based on other' ,'Other'),
('based on PE' ,'PE'),
('based on PET' ,'PET'),
('chemo' ,'Chemo'),
('chemo regimen' ,'Chemo Regimen'),
('CR trt responses' ,'CR'),
('dose modified' ,'Dose Modified'),
('dose modified precision' ,'Modification Precision'),
('final pet ct date' ,'Final PET/CT'),
('frail palliative' ,'Frail (palliative)'),
('mid cycle pet ct date' ,'Mid cycle PET/CT'),
('observation' ,'Observation'),
('PD trt responses' ,'PD'),
('PR trt responses' ,'PR'),
('primary treatment' ,'Primary Treatment'),
('primary treatment type' ,'Type'),
('SD trt responses' ,'SD'),
('suv final' ,'SUVfinal'),
('suv mid' ,'SUVmid');

INSERT INTO `diagnosis_controls` (`id`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'ld lymph. cns relapse', 1, 'ld_lymph_dx_cns_relapses', 'ld_lymph_dx_cns_relapses', 0, 'ld lymph. cns relapse'),
(null, 'ld lymph. histological transformation', 1, 'ld_lymph_dx_histo_transformations', 'ld_lymph_dx_histo_transformations', 0, 'ld lymph. histological transformation');

DROP TABLE IF EXISTS `ld_lymph_dx_cns_relapses`;
CREATE TABLE IF NOT EXISTS `ld_lymph_dx_cns_relapses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
    
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_dx_cns_relapses`
  ADD CONSTRAINT `FK_ld_lymph_dx_cns_relapses_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

DROP TABLE IF EXISTS `ld_lymph_dx_cns_relapses_revs`;
CREATE TABLE IF NOT EXISTS `ld_lymph_dx_cns_relapses_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `ld_lymph_dx_histo_transformations`;
CREATE TABLE IF NOT EXISTS `ld_lymph_dx_histo_transformations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  
  `type_of_transformation` varchar(20) DEFAULT '',

  `hyper_ca2plus` char(1) DEFAULT '',
  `hyper_ca2plus_value` decimal(7,2) DEFAULT NULL,  
  
  `unusual_site` char(1) DEFAULT '',
  `unusual_site_value` varchar(20) DEFAULT '',
  
  `ldh_increased_more_than_2xlimit` char(1) DEFAULT '',
  `ldh_value` decimal(7,2) DEFAULT NULL,  
  
  `discordant_nodal_growth` char(1) DEFAULT '',  
  `new_b_symptoms` char(1) DEFAULT '',  
 
  `path_date` date DEFAULT NULL,
   
  `deleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_dx_histo_transformations`
  ADD CONSTRAINT `FK_ld_lymph_dx_histo_transformations_diagnosis_masters` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

DROP TABLE IF EXISTS `ld_lymph_dx_histo_transformations_revs`;
CREATE TABLE IF NOT EXISTS `ld_lymph_dx_histo_transformations_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  
  `type_of_transformation` varchar(20) DEFAULT '',

  `hyper_ca2plus` char(1) DEFAULT '',
  `hyper_ca2plus_value` decimal(7,2) DEFAULT NULL,  
  
  `unusual_site` char(1) DEFAULT '',
  `unusual_site_value` varchar(20) DEFAULT '',
  
  `ldh_increased_more_than_2xlimit` char(1) DEFAULT '',
  `ldh_value` decimal(7,2) DEFAULT NULL,  
  
  `discordant_nodal_growth` char(1) DEFAULT '',  
  `new_b_symptoms` char(1) DEFAULT '',  
 
  `path_date` date DEFAULT NULL,
  
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structures(`alias`) VALUES ('ld_lymph_dx_cns_relapses');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_cns_relapses'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '4', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_cns_relapses'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_primary number' AND `language_label`='primary_number' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_cns_relapses'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx origin' AND `language_label`='origin' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_cns_relapses'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '13', '', '0', '', '0', '', '1', 'help_memo', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO structures(`alias`) VALUES ('ld_lymph_dx_histo_transformations');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '4', '', '0', '', '0', '', '1', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='primary_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_primary number' AND `language_label`='primary_number' AND `language_tag`=''), '1', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_origin' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='origin')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx origin' AND `language_label`='origin' AND `language_tag`=''), '1', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '13', '', '0', '', '0', '', '1', 'help_memo', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_dx_histo_transf_definition_source', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("clinical","clinical"),("patho","patho");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_definition_source"),  
(SELECT id FROM structure_permissible_values WHERE value="clinical" AND language_alias="clinical"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_definition_source"),  
(SELECT id FROM structure_permissible_values WHERE value="patho" AND language_alias="patho"), "2", "1");

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_dx_histo_transf_unusual_site', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("liver","liver"),("bone","bone"),("ms","unusual site ms"),("cns","unusual site cns");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_unusual_site"),  
(SELECT id FROM structure_permissible_values WHERE value="liver" AND language_alias="liver"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_unusual_site"),  
(SELECT id FROM structure_permissible_values WHERE value="bone" AND language_alias="bone"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_unusual_site"),  
(SELECT id FROM structure_permissible_values WHERE value="ms" AND language_alias="unusual site ms"), "3", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_dx_histo_transf_unusual_site"),  
(SELECT id FROM structure_permissible_values WHERE value="cns" AND language_alias="unusual site cns"), "5", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_histo_transformations', 'type_of_transformation', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_dx_histo_transf_definition_source') , '0', '', '', '', 'type of transformation', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_histo_transformations', 'hyper_ca2plus', 'yes_no',  NULL , '0', '', '', '', 'hyper ca2plus', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_histo_transformations', 'hyper_ca2plus_value', 'float',  NULL , '0', '', '', '', 'hyper ca2plus value', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_histo_transformations', 'unusual_site', 'yes_no',  NULL , '0', '', '', '', 'unusual site', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_histo_transformations', 'unusual_site_value', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_dx_histo_transf_unusual_site') , '0', '', '', '', 'unusual site value', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_histo_transformations', 'ldh_increased_more_than_2xlimit', 'yes_no',  NULL , '0', '', '', '', 'ldh increased more than 2xlimit', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_histo_transformations', 'ldh_value', 'float',  NULL , '0', '', '', '', 'ldh value', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_histo_transformations', 'discordant_nodal_growth', 'yes_no',  NULL , '0', '', '', '', 'discordant nodal growth', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_histo_transformations', 'new_b_symptoms', 'input',  NULL , '0', '', '', '', 'new b symptoms', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_histo_transformations', 'path_date', 'date',  NULL , '0', '', '', '', 'path date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_histo_transformations' AND `field`='type_of_transformation' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_dx_histo_transf_definition_source')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type of transformation' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_histo_transformations' AND `field`='hyper_ca2plus' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hyper ca2plus' AND `language_tag`=''), '2', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_histo_transformations' AND `field`='hyper_ca2plus_value' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hyper ca2plus value' AND `language_tag`=''), '2', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_histo_transformations' AND `field`='unusual_site' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='unusual site' AND `language_tag`=''), '2', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_histo_transformations' AND `field`='unusual_site_value' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_dx_histo_transf_unusual_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='unusual site value' AND `language_tag`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_histo_transformations' AND `field`='ldh_increased_more_than_2xlimit' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ldh increased more than 2xlimit' AND `language_tag`=''), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_histo_transformations' AND `field`='ldh_value' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ldh value' AND `language_tag`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_histo_transformations' AND `field`='discordant_nodal_growth' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='discordant nodal growth' AND `language_tag`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_histo_transformations' AND `field`='new_b_symptoms' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='new b symptoms' AND `language_tag`=''), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_histo_transformations'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_histo_transformations' AND `field`='path_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='path date' AND `language_tag`=''), '1', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO i18n (id,en) VALUES
('discordant nodal growth', 'Discordant Nodal Growth'),
('group', 'Group'),
('hyper ca2plus', 'Hyper Ca<sup>2+</sup>'),
('hyper ca2plus value', 'Ca<sup>2+</sup> Value'),
('ld lymph. cns relapse', 'LD Lymph. CNS Relapse'),
('ld lymph. histological transformation', 'LD Lymph. Histological Transformation'),
('ldh increased more than 2xlimit', 'Increased LDH > 2 x Limit'),
('ldh value', 'LDH Value'),
('new b symptoms', 'New B Symptoms'),
('path date', 'Path Date'),
('patho', 'Patho'),
('type of transformation', 'Transformation Defined'),
('unusual site', 'Unusual Site'),
('unusual site cns', 'CNS'),
('unusual site ms', 'MS'),
('unusual site value', 'Site Value');

UPDATE structure_fields SET  `type`='yes_no' WHERE model='DiagnosisDetail' AND tablename='ld_lymph_dx_histo_transformations' AND field='new_b_symptoms' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE `diagnosis_controls` SET display_order = id;

UPDATE `parent_to_derivative_sample_controls` SET lab_book_control_id = NULL;
UPDATE `realiquoting_controls` SET lab_book_control_id = NULL;

UPDATE specimen_review_controls SET flag_active = 0;

SET @sample_control_id = (select id from sample_controls where sample_type like 'tissue');
INSERT INTO `specimen_review_controls` (`id`, `sample_control_id`, `aliquot_review_control_id`, `specimen_sample_type`, `review_type`, `flag_active`, `form_alias`, `detail_tablename`, `databrowser_label`) VALUES
(null, @sample_control_id, NULL, 'tissue', 'molecular lab', 1, 'ld_lymph_spr_molecular_labs', 'ld_lymph_spr_molecular_labs', 'molecular lab'),
(null, @sample_control_id, NULL, 'tissue', 'flow cytometry lab', 1, 'ld_lymph_spr_flow_cytometry_labs', 'ld_lymph_spr_flow_cytometry_labs', 'flow cytometry lab'),
(null, @sample_control_id, NULL, 'tissue', 'cytogenetics lab', 1, 'ld_lymph_spr_cytogenetics_labs', 'ld_lymph_spr_cytogenetics_labs', 'cytogenetics lab');
SET @sample_control_id = (select id from sample_controls where sample_type like 'blood');
INSERT INTO `specimen_review_controls` (`id`, `sample_control_id`, `aliquot_review_control_id`, `specimen_sample_type`, `review_type`, `flag_active`, `form_alias`, `detail_tablename`, `databrowser_label`) VALUES
(null, @sample_control_id, NULL, 'blood', 'molecular lab', 1, 'ld_lymph_spr_molecular_labs', 'ld_lymph_spr_molecular_labs', 'molecular lab'),
(null, @sample_control_id, NULL, 'blood', 'flow cytometry lab', 1, 'ld_lymph_spr_flow_cytometry_labs', 'ld_lymph_spr_flow_cytometry_labs', 'flow cytometry lab'),
(null, @sample_control_id, NULL, 'blood', 'cytogenetics lab', 1, 'ld_lymph_spr_cytogenetics_labs', 'ld_lymph_spr_cytogenetics_labs', 'cytogenetics lab');
SET @sample_control_id = (select id from sample_controls where sample_type like 'bone marrow');
INSERT INTO `specimen_review_controls` (`id`, `sample_control_id`, `aliquot_review_control_id`, `specimen_sample_type`, `review_type`, `flag_active`, `form_alias`, `detail_tablename`, `databrowser_label`) VALUES
(null, @sample_control_id, NULL, 'bone marrow', 'molecular lab', 1, 'ld_lymph_spr_molecular_labs', 'ld_lymph_spr_molecular_labs', 'molecular lab'),
(null, @sample_control_id, NULL, 'bone marrow', 'flow cytometry lab', 1, 'ld_lymph_spr_flow_cytometry_labs', 'ld_lymph_spr_flow_cytometry_labs', 'flow cytometry lab'),
(null, @sample_control_id, NULL, 'bone marrow', 'cytogenetics lab', 1, 'ld_lymph_spr_cytogenetics_labs', 'ld_lymph_spr_cytogenetics_labs', 'cytogenetics lab');

INSERT INTO structures(`alias`) VALUES ('ld_lymph_spr_molecular_labs'),('ld_lymph_spr_flow_cytometry_labs'),('ld_lymph_spr_cytogenetics_labs');



DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('ld_lymph_spr_molecular_labs','ld_lymph_spr_cytogenetics_labs','ld_lymph_spr_flow_cytometry_labs'));


INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
-- ((SELECT id FROM structures WHERE alias='ld_lymph_spr_molecular_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='review code' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_molecular_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='specimen_sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_type_for_review')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen review type' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_molecular_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_molecular_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='review date' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
-- ((SELECT id FROM structures WHERE alias='ld_lymph_spr_molecular_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='review status' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_molecular_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
-- ((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='review code' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='specimen_sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_type_for_review')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen review type' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='review date' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
-- ((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='review status' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
-- ((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='review code' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='specimen_sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_type_for_review')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specimen review type' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='-'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='review date' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
-- ((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='review_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_review_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='review status' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

ALTER TABLE specimen_review_masters
  ADD ld_lymph_center varchar(100) DEFAULT '' AFTER pathologist;
ALTER TABLE specimen_review_masters_revs
  ADD ld_lymph_center varchar(100) DEFAULT '' AFTER pathologist;
  
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_path_review_centers_list', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''path review centers'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length) VALUES ('path review centers', '1', '100');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SpecimenReviewMaster', 'specimen_review_masters', 'ld_lymph_center', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='custom_path_review_centers_list') , '0', '', '', '', 'ld lymph center', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_molecular_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='ld_lymph_center' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_path_review_centers_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ld lymph center' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='ld_lymph_center' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_path_review_centers_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ld lymph center' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewMaster' AND `tablename`='specimen_review_masters' AND `field`='ld_lymph_center' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_path_review_centers_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ld lymph center' AND `language_tag`=''), '0', '8', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

CREATE TABLE IF NOT EXISTS `ld_lymph_spr_molecular_labs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `specimen_review_master_id` int(11) DEFAULT NULL,
  
  `mdl_number` decimal(7,5) DEFAULT NULL,	
  `mb_number` decimal(7,5) DEFAULT NULL,	
  `molecular_dx` varchar(250) DEFAULT '',	
    
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_ld_lymph_spr_molecular_labs_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_spr_molecular_labs`
  ADD CONSTRAINT `FK_ld_lymph_spr_molecular_labs_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_spr_molecular_labs_revs` (
  `id` int(11) NOT NULL,
  `specimen_review_master_id` int(11) DEFAULT NULL,
  
  `mdl_number` decimal(7,5) DEFAULT NULL,	
  `mb_number` decimal(7,5) DEFAULT NULL,	
  `molecular_dx` varchar(250) DEFAULT '',	
  
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ld_lymph_spr_flow_cytometry_labs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `specimen_review_master_id` int(11) DEFAULT NULL,
  
  `flow_number` varchar(100) DEFAULT '',	
  `cd20` decimal(7,5) DEFAULT NULL,		
  `cd19` decimal(7,5) DEFAULT NULL,	
  `cd10` decimal(7,5) DEFAULT NULL,	
  `cd5` decimal(7,5) DEFAULT NULL,	
  `cd23` decimal(7,5) DEFAULT NULL,	
  `cd2` decimal(7,5) DEFAULT NULL,	
  `cd3` decimal(7,5) DEFAULT NULL,	
  `cd4` decimal(7,5) DEFAULT NULL,	
  `cd8` decimal(7,5) DEFAULT NULL,	
  `lambda` decimal(7,5) DEFAULT NULL,	
  `kappa` decimal(7,5) DEFAULT NULL,	
  `other` varchar(100) DEFAULT '',		
  `other_value` decimal(7,5) DEFAULT NULL,		
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_ld_lymph_spr_flow_cytometry_labs_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_spr_flow_cytometry_labs`
  ADD CONSTRAINT `FK_ld_lymph_spr_flow_cytometry_labs_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_spr_flow_cytometry_labs_revs` (
  `id` int(11) NOT NULL,
  `specimen_review_master_id` int(11) DEFAULT NULL,
  
  `flow_number` varchar(100) DEFAULT '',	
  `cd20` decimal(7,5) DEFAULT NULL,		
  `cd19` decimal(7,5) DEFAULT NULL,	
  `cd10` decimal(7,5) DEFAULT NULL,	
  `cd5` decimal(7,5) DEFAULT NULL,	
  `cd23` decimal(7,5) DEFAULT NULL,	
  `cd2` decimal(7,5) DEFAULT NULL,	
  `cd3` decimal(7,5) DEFAULT NULL,	
  `cd4` decimal(7,5) DEFAULT NULL,	
  `cd8` decimal(7,5) DEFAULT NULL,	
  `lambda` decimal(7,5) DEFAULT NULL,	
  `kappa` decimal(7,5) DEFAULT NULL,	
  `other` varchar(100) DEFAULT '',		
  `other_value` decimal(7,5) DEFAULT NULL,	
  
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ld_lymph_spr_cytogenetics_labs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `specimen_review_master_id` int(11) DEFAULT NULL,
  
  `case_number` varchar(100) DEFAULT '',	
  `cyto_number` varchar(100) DEFAULT '',	
  `technique` varchar(100) DEFAULT '',	
  `technique_precision` varchar(100) DEFAULT '',
  `bcl2_tr` decimal(7,5) DEFAULT NULL,		
  `bcl6_tr` decimal(7,5) DEFAULT NULL,	
  `myc_tr` decimal(7,5) DEFAULT NULL,	
  `cyclin_d1_tr` decimal(7,5) DEFAULT NULL,	
  `karyotype` varchar(100) DEFAULT '',			
  
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_ld_lymph_spr_cytogenetics_labs_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `ld_lymph_spr_cytogenetics_labs`
  ADD CONSTRAINT `FK_ld_lymph_spr_cytogenetics_labs_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);

CREATE TABLE IF NOT EXISTS `ld_lymph_spr_cytogenetics_labs_revs` (
  `id` int(11) NOT NULL,
  `specimen_review_master_id` int(11) DEFAULT NULL,
  
  `case_number` varchar(100) DEFAULT '',	
  `cyto_number` varchar(100) DEFAULT '',	
  `technique` varchar(100) DEFAULT '',		
  `technique_precision` varchar(100) DEFAULT '',
  `bcl2_tr` decimal(7,5) DEFAULT NULL,		
  `bcl6_tr` decimal(7,5) DEFAULT NULL,	
  `myc_tr` decimal(7,5) DEFAULT NULL,	
  `cyclin_d1_tr` decimal(7,5) DEFAULT NULL,	
  `karyotype` varchar(100) DEFAULT '',	
  
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_molecular_labs', 'mdl_number', 'float',  NULL , '0', '', '', '', 'mdl number', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_molecular_labs', 'mb_number', 'float',  NULL , '0', '', '', '', 'mb number', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_molecular_labs', 'molecular_dx', 'input',  NULL , '0', '', '', '', 'molecular dx', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_molecular_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_molecular_labs' AND `field`='mdl_number' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mdl number' AND `language_tag`=''), '1', '20', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_molecular_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_molecular_labs' AND `field`='mb_number' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mb number' AND `language_tag`=''), '1', '21', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_molecular_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_molecular_labs' AND `field`='molecular_dx' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='molecular dx' AND `language_tag`=''), '1', '22', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'flow_number', 'input',  NULL , '0', 'size=30', '', '', 'flow number', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'cd20', 'NULL',  NULL , '0', 'size=5', '', '', 'cd20', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'cd5', 'float',  NULL , '0', 'size=5', '', '', 'cd5', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'cd23', 'float',  NULL , '0', 'size=5', '', '', 'cd23', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'cd2', 'float',  NULL , '0', 'size=5', '', '', 'cd2', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'cd3', 'float',  NULL , '0', 'size=5', '', '', 'cd3', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'cd4', 'float',  NULL , '0', 'size=5', '', '', 'cd4', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'cd8', 'float',  NULL , '0', 'size=5', '', '', 'cd8', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'lambda', 'float',  NULL , '0', 'size=5', '', '', 'lambda', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'kappa', 'float',  NULL , '0', 'size=5', '', '', 'kappa', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'other', 'input',  NULL , '0', 'size=30', '', '', 'other', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'other_value', 'input',  NULL , '0', 'size=30', '', '', '', ':'), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'cd10', 'float',  NULL , '0', 'size=5', '', '', 'cd10', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_flow_cytometry_labs', 'cd19', 'float',  NULL , '0', 'size=5', '', '', 'cd19', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='flow_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='flow number' AND `language_tag`=''), '2', '23', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='cd20' AND `type`='NULL' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cd20' AND `language_tag`=''), '2', '24', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='cd5' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cd5' AND `language_tag`=''), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='cd23' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cd23' AND `language_tag`=''), '2', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='cd2' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cd2' AND `language_tag`=''), '2', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='cd3' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cd3' AND `language_tag`=''), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='cd4' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cd4' AND `language_tag`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='cd8' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cd8' AND `language_tag`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='lambda' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='lambda' AND `language_tag`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='kappa' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='kappa' AND `language_tag`=''), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='other' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='other' AND `language_tag`=''), '2', '35', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='other_value' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=':'), '2', '36', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='cd10' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cd10' AND `language_tag`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_flow_cytometry_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_flow_cytometry_labs' AND `field`='cd19' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cd19' AND `language_tag`=''), '2', '25', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_cytogenetic_technique', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("FISH","FISH");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_cytogenetic_technique"),  
(SELECT id FROM structure_permissible_values WHERE value="FISH" AND language_alias="FISH"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_cytogenetic_technique"),  
(SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "4", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_cytogenetics_labs', 'case_number', 'input',  NULL , '0', 'size=30', '', '', 'case number', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_cytogenetics_labs', 'cyto_number', 'input',  NULL , '0', 'size=30', '', '', 'cyto number', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_cytogenetics_labs', 'technique', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_cytogenetic_technique') , '0', '', '', '', 'technique', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_cytogenetics_labs', 'technique_precision', 'input',  NULL , '0', 'size=30', '', '', 'precision', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_cytogenetics_labs', 'bcl2_tr', 'float',  NULL , '0', 'size=5', '', '', 'bcl2 tr', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_cytogenetics_labs', 'bcl6_tr', 'float',  NULL , '0', 'size=5', '', '', 'bcl6 tr', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_cytogenetics_labs', 'myc_tr', 'float',  NULL , '0', 'size=5', '', '', 'myc tr', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_cytogenetics_labs', 'cyclin_d1_tr', 'float',  NULL , '0', 'size=5', '', '', 'cyclin d1 tr', ''), 
('Inventorymanagement', 'SpecimenReviewDetail', 'ld_lymph_spr_cytogenetics_labs', 'karyotype', 'input',  NULL , '0', 'size=30', '', '', 'karyotype', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_cytogenetics_labs' AND `field`='case_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='case number' AND `language_tag`=''), '2', '26', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_cytogenetics_labs' AND `field`='cyto_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='cyto number' AND `language_tag`=''), '2', '27', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_cytogenetics_labs' AND `field`='technique' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_cytogenetic_technique')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='technique' AND `language_tag`=''), '2', '28', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_cytogenetics_labs' AND `field`='technique_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '2', '29', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_cytogenetics_labs' AND `field`='bcl2_tr' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='bcl2 tr' AND `language_tag`=''), '2', '30', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_cytogenetics_labs' AND `field`='bcl6_tr' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='bcl6 tr' AND `language_tag`=''), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_cytogenetics_labs' AND `field`='myc_tr' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='myc tr' AND `language_tag`=''), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_cytogenetics_labs' AND `field`='cyclin_d1_tr' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='cyclin d1 tr' AND `language_tag`=''), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_spr_cytogenetics_labs'), (SELECT id FROM structure_fields WHERE `model`='SpecimenReviewDetail' AND `tablename`='ld_lymph_spr_cytogenetics_labs' AND `field`='karyotype' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='karyotype' AND `language_tag`=''), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en) VALUES
('mdl number', 'MDL-number'),
('mb number', 'MB-number'),
('molecular dx', 'Molecular Dx'),
('flow number', 'Flow#'),
('cd20', 'CD20'),
('cd5', 'CD5'),
('cd23', 'CD23'),
('cd2', 'CD2'),
('cd3', 'CD3'),
('cd4', 'CD4'),
('cd8', 'CD8'),
('lambda', '&#955;'),
('kappa', '&#954;'),
('cd10', 'CD10'),
('cd19', 'CD19');

INSERT IGNORE INTO i18n (id,en) VALUES
('bcl2 tr','BCL2 Tr'),
('bcl6 tr','BCL6 Tr'),
('case number','Case Number'),
('cyclin d1 tr','Cyclin D1 Tr'),
('cyto number','Cyto#'),
('cytogenetics lab','Cytogenetics Lab'),
('flow cytometry lab','Flow Cytometry Lab'),
('karyotype','Karyotype'),
('molecular lab','Molecular Lab'),
('myc tr','MYC tr'),
('technique','Technique');

INSERT IGNORE INTO i18n (id,en) VALUES ('ld lymph center','Center');

UPDATE structure_fields SET  `type`='float' WHERE model='SpecimenReviewDetail' AND tablename='ld_lymph_spr_flow_cytometry_labs' AND field='cd20' AND `type`='NULL' AND structure_value_domain  IS NULL ;

ALTER TABLE ld_lymph_spr_cytogenetics_labs
	MODIFY `case_number` decimal(7,5) DEFAULT NULL;
ALTER TABLE ld_lymph_spr_cytogenetics_labs_revs
	MODIFY `case_number` decimal(7,5) DEFAULT NULL;

UPDATE structure_fields SET setting = 'size=5', type='float' WHERE field = 'case_number' AND tablename = 'ld_lymph_spr_cytogenetics_labs';

-- TODO delete --

SELECT 'DELETE INSERT INTO structure_permissible_values_customs example statement' AS 'TODO';
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `use_as_input`, `control_id`) 
(SELECT 'value 1', CONCAT('custom ', name, ' list to complete in admin tool'), '1', id FROM structure_permissible_values_custom_controls );

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
UPDATE structure_fields SET  `type`='yes_no' WHERE model='DiagnosisDetail' AND tablename='ld_lymph_dx_histo_transformations' AND field='new_b_symptoms' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'ld_lymph_bone_marrow_dx', 'open', '', NULL);
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES ("positive","positive"),("negative","negative"),("not diagnosed","not diagnosed");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_bone_marrow_dx"),  
(SELECT id FROM structure_permissible_values WHERE value="positive" AND language_alias="positive"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_bone_marrow_dx"),  
(SELECT id FROM structure_permissible_values WHERE value="negative" AND language_alias="negative"), "2", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="ld_lymph_bone_marrow_dx"),  
(SELECT id FROM structure_permissible_values WHERE value="not diagnosed" AND language_alias="not diagnosed"), "4", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'tiss_histo_dx', 'textarea',  NULL , '0', 'rows=2,cols=30', '', '', 'tiss histo dx', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'bm_dx', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_bone_marrow_dx') , '0', '', '', '', 'bm dx', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'bm_histo_dx', 'textarea', (SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_bone_marrow_dx') , '0', 'rows=2,cols=30', '', '', 'bm histo dx', ''), 
('Clinicalannotation', 'DiagnosisDetail', 'ld_lymph_dx_lymphomas', 'bm_histo_patho_nbr', 'input',  NULL , '0', 'size=15', '', '', 'bm histo patho nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='tiss_histo_dx' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='tiss histo dx' AND `language_tag`=''), '2', '60', 'histology', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='bm_dx' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_bone_marrow_dx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='bm dx' AND `language_tag`=''), '2', '61', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='bm_histo_dx' AND `type`='textarea' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ld_lymph_bone_marrow_dx')  AND `flag_confidential`='0' AND `setting`='rows=2,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='bm histo dx' AND `language_tag`=''), '2', '62', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ld_lymph_dx_lymphomas'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='ld_lymph_dx_lymphomas' AND `field`='bm_histo_patho_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='bm histo patho nbr' AND `language_tag`=''), '2', '63', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_fields SET  `type`='textarea',  `setting`='rows=2,cols=30' WHERE model='DiagnosisDetail' AND tablename='ld_lymph_dx_lymphomas' AND field='comorbidities_precision' AND `type`='input' AND structure_value_domain  IS NULL ;





('bm dx' , 'Bone Marrow'),
('bm histo dx' , 'B.M. Histological Dx'),
('bm histo patho nbr' , 'Pathology Number'),




('ld lymph. diagnostic' , 'LD Lymph. Diagnostic'),
('ld lymph. progression' , 'LD Lymph. Progression'),

('not diagnosed' , 'Not Diagnosed'),



('tiss histo dx' , 'Histological Dx');



  `tiss_histo_dx` text,  
  `bm_dx` varchar(20) DEFAULT '',  
  `bm_histo_dx` text,  
  `bm_histo_patho_nbr` varchar(20) DEFAULT '', 
  


- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
