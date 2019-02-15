-- -----------------------------------------------------------------------------------------------------------------------------------
-- shipping_name vs order_item_shipping_label
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE order_items SET order_item_shipping_label = shipping_name;
UPDATE order_items_revs SET order_item_shipping_label = shipping_name;
UPDATE order_items SET order_item_shipping_label = null WHERE order_item_shipping_label = 'NULL';
UPDATE order_items_revs SET order_item_shipping_label = null WHERE order_item_shipping_label = 'NULL';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='orderitems') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='shipping_name' AND `language_label`='shipping name' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='shipping_name' AND `language_label`='shipping name' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Order' AND `model`='OrderItem' AND `tablename`='order_items' AND `field`='shipping_name' AND `language_label`='shipping name' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
ALTER TABLE order_items DROP COLUMN shipping_name;
ALTER TABLE order_items_revs DROP COLUMN shipping_name;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Raman consent & +
-- https://3.basecamp.com/3786377/buckets/4911238/todos/1115912377
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE cd_icm_generics
  ADD COLUMN acces_to_medical_records CHAR(1) DEFAULT NULL;
ALTER TABLE cd_icm_generics_revs
  ADD COLUMN acces_to_medical_records CHAR(1) DEFAULT NULL;
INSERT INTO structures(`alias`) VALUES ('qc_nd_cd_raman');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'cd_icm_generics', 'contact_for_other_research', 'yes_no',  NULL , '0', '', '', '', 'communicate to participate in other research', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'cd_icm_generics', 'acces_to_medical_records', 'yes_no',  NULL , '0', '', '', '', 'access to clinical records', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_cd_raman'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='contact_for_other_research' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='communicate to participate in other research' AND `language_tag`=''), '2', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_raman'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='acces_to_medical_records' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='access to clinical records' AND `language_tag`=''), '2', '9', 'agreements', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'chum - raman', 1, 'qc_nd_cd_raman', 'cd_icm_generics', 0, 'chum - raman');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('access to clinical records', 'Access to clinical records', "Accès au dossier médical"),
('chum - raman', 'CHUM -  Raman', 'CHUM - Raman');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'qc consent version');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
("2017-10-10", "", "", '1', @control_id, NOW(), NOW(), 1, 1);
REPLACE INTO i18n (id,en,fr)
VALUES
('frsq - network', "FRQS - Network>", "FRQS - Réseau"),
('frsq', "FRQS>", "FRQS"),
('pre-frsq', "Pre-FRQS>", "Pré-FRQS"),
('frsq - gyneco', "FRQS - Gyneco/Ovary/Breast>", "FRQS - Gynéco/Ovaire/Sein"),
('ghadirian consent', "Dr Ghadirian's lab>", "Labo Dr Ghadirian");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Menopausal
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("not menopausal", "not menopausal");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="menopause_status"), (SELECT id FROM structure_permissible_values WHERE value="not menopausal" AND language_alias="not menopausal"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="menopause_status"), (SELECT id FROM structure_permissible_values WHERE value="N/S" AND language_alias="N/S"), "5", "1");
INSERT IGNORE INTO i18n (id, en,fr) VALUES("not menopausal", "Not Menopausal", "Non ménopausée");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- CA125
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET  `type`='float_positive' WHERE model='EventDetail' AND tablename='qc_nd_ed_ca125s' AND field='value' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
ALTER TABLE qc_nd_ed_ca125s MODIFY value decimal(12,2) DEFAULT NULL;
ALTER TABLE qc_nd_ed_ca125s_revs MODIFY value decimal(12,2) DEFAULT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- sardo_import_summary
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE sardo_import_summary
   MODIFY data_type varchar(100) DEFAULT NULL;
ALTER TABLE sardo_import_summary
   MODIFY details varchar(1000) DEFAULT NULL;
   		
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7374' WHERE version_number = '2.7.1';

UPDATE versions SET branch_build_number = '7381' WHERE version_number = '2.7.1';
UPDATE versions SET branch_build_number = '7396' WHERE version_number = '2.7.1';
UPDATE versions SET branch_build_number = '7427' WHERE version_number = '2.7.1';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- pulmonary bank
-- -----------------------------------------------------------------------------------------------------------------------------------

REPLACE INTO i18n (id,en,fr)
VALUES
("frsq - network", "FRQS - Network", "FRQS - Réseau"),
("frsq", "FRQS", "FRQS"),
("pre-frsq", "Pre-FRQS", "Pré-FRQS"),
("frsq - gyneco", "FRQS - Gyneco/Ovary/Breast", "FRQS - Gynéco/Ovaire/Sein"),
("ghadirian consent", "Dr Ghadirian's lab", "Labo Dr Ghadirian");

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'chum - pulmonary by script', 1, 'qc_nd_cd_chum_pulmonary_by_scripts', 'qc_nd_cd_chum_pulmonarys', 0, 'chum - pulmonary by script');

ALTER TABLE qc_nd_cd_chum_pulmonarys
   ADD COLUMN person_who_consented_by_script varchar (250) DEFAULT NULL,
   ADD COLUMN person_who_consented_by_script_relationship varchar (250) DEFAULT NULL;
ALTER TABLE qc_nd_cd_chum_pulmonarys_revs
   ADD COLUMN person_who_consented_by_script varchar (250) DEFAULT NULL,
   ADD COLUMN person_who_consented_by_script_relationship varchar (250) DEFAULT NULL;
INSERT INTO structures(`alias`) VALUES ('qc_nd_cd_chum_pulmonary_by_scripts');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'qc_nd_cd_chum_pulmonarys', 'person_who_consented_by_script', 'input',  NULL , '1', 'size=40', '', '', 'person who consented', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'qc_nd_cd_chum_pulmonarys', 'person_who_consented_by_script_relationship', 'input',  NULL , '1', 'size=40', '', '', 'relationship with the patient', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_pulmonary_by_scripts'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_pulmonarys' AND `field`='person_who_consented_by_script' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='person who consented' AND `language_tag`=''), '2', '20', 'script details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_chum_pulmonary_by_scripts'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='qc_nd_cd_chum_pulmonarys' AND `field`='person_who_consented_by_script_relationship' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='size=40' AND `default`='' AND `language_help`='' AND `language_label`='relationship with the patient' AND `language_tag`=''), '2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('chum - pulmonary by script', 'CHUM -  Pulmonary (by script)', 'CHUM - Pulmonaire (par script)'),
('script details', 'Script Details', 'Détails du script'),
("person who consented", "Person who Consented", "Personne qui a consenti"),
("relationship with the patient", "Relationship with the Patient", "Relation avec le patient");

INSERT INTO `lab_type_laterality_match` (`selected_type_code`, `selected_labo_laterality`, `sample_type_matching`, `tissue_source_matching`, `nature_matching`, `laterality_matching`) VALUES
('PO', '', 'tissue', 'lung', 'unknown', ''),
('PON', '', 'tissue', 'lung', 'normal', ''),
('POT', '', 'tissue', 'lung', 'malignant', '');

UPDATE versions SET branch_build_number = '7476' WHERE version_number = '2.7.1';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Change clinical stage data size
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE diagnosis_masters 
  MODIFY `clinical_stage_summary` varchar(25) DEFAULT NULL,
  MODIFY `path_stage_summary` varchar(25) DEFAULT NULL;
ALTER TABLE diagnosis_masters_revs
  MODIFY `clinical_stage_summary` varchar(25) DEFAULT NULL,
  MODIFY `path_stage_summary` varchar(25) DEFAULT NULL;
 
UPDATE versions SET branch_build_number = '7495' WHERE version_number = '2.7.1';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Adrenal Bank
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO key_increments (key_name ,key_value) VALUES ('adrenal bank no lab', '360');
INSERT INTO misc_identifier_controls (misc_identifier_name , flag_active, display_order, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_confidential, flag_unique, pad_to_length, reg_exp_validation, user_readable_format, flag_link_to_study)
VALUES
('adrenal bank no lab','1','1','adrenal bank no lab','%%key_increment%%','1','0','1','0','','','0');
INSERT INTO i18n (id,en,fr)
VALUES 
('adrenal no lab', "'No Labo' of Adrenal Bank","'No Labo' de la banque Surrénal"),
('adrenal bank no lab', "'No Labo' of Adrenal Bank","'No Labo' de la banque Surrénal");

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'chum - adrenal', 1, 'qc_nd_cd_adrenal', 'cd_icm_generics', 0, 'chum - adrenal');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('chum - adrenal', 'CHUM - Adrenal', 'CHUM - Surrénal');
INSERT INTO structures(`alias`) VALUES ('qc_nd_cd_adrenal');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_nd_cd_adrenal'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='biological_material_use' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biological material use' AND `language_tag`=''), '2', '1', 'agreements', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_adrenal'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='use_of_blood' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='use of blood' AND `language_tag`=''), '2', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_nd_cd_adrenal'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='cd_icm_generics' AND `field`='contact_for_additional_data' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact for additional data' AND `language_tag`=''), '2', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE banks SET misc_identifier_control_id = (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = 'adrenal bank no lab') WHERE name = 'Adrenal/Surrénal';
UPDATE misc_identifier_controls SET misc_identifier_format = 'B-%%key_increment%%' WHERE misc_identifier_name = 'adrenal bank no lab';

UPDATE versions SET branch_build_number = '7501' WHERE version_number = '2.7.1';

INSERT INTO `lab_type_laterality_match` (`selected_type_code`, `selected_labo_laterality`, `sample_type_matching`, `tissue_source_matching`, `nature_matching`, `laterality_matching`) 
VALUES
('SU', '', 'tissue', 'adrenal', 'unknown', ''),
('SU', 'D', 'tissue', 'adrenal', 'unknown', 'right'),
('SU', 'G', 'tissue', 'adrenal', 'unknown', 'left'),
('SUN', '', 'tissue', 'adrenal', 'normal', ''),
('SUN', 'D', 'tissue', 'adrenal', 'normal', 'right'),
('SUN', 'G', 'tissue', 'adrenal', 'normal', 'left'),
('SUT', '', 'tissue', 'adrenal', 'malignant', ''),
('SUT', 'D', 'tissue', 'adrenal', 'malignant', 'right'),
('SUT', 'G', 'tissue', 'adrenal', 'malignant', 'left');
INSERT IGNORE INTO i18n (id, en,fr) VALUES ('adrenal', 'Adrenal', 'Surrenal');
UPDATE versions set permissions_regenerated = 0;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- 20190215 : Add new nolabo to identifiers report
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'provaq_bank_no_lab', 'input',  NULL , '0', 'size=20', '', '', 'provaq bank no lab', ''), 
('Datamart', '0', '', 'adrenal_bank_no_lab', 'input',  NULL , '0', 'size=20', '', '', 'adrenal bank no lab', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='provaq_bank_no_lab' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='provaq bank no lab' AND `language_tag`=''), '0', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='report_participant_identifiers_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='adrenal_bank_no_lab' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='adrenal bank no lab' AND `language_tag`=''), '0', '17', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `language_heading`='no labo' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ovary_gyneco_bank_no_lab' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='confidential identifiers' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='ramq_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `language_heading`='other' WHERE structure_id=(SELECT id FROM structures WHERE alias='report_participant_identifiers_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='other_center_id_nbr' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('confidential identifiers', 'Confidential Identifiers', 'Identifiants confidentiels');

UPDATE versions SET branch_build_number = '7575' WHERE version_number = '2.7.1';