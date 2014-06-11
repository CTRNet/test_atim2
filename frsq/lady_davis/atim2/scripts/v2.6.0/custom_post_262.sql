
UPDATE datamart_structure_functions SET flag_active = 0 WHERE label = 'print barcodes';

ALTER TABLE participants ADD COLUMN `qc_lady_sardo_data_migration_date` date DEFAULT NULL;
ALTER TABLE participants_revs ADD COLUMN `qc_lady_sardo_data_migration_date` date DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'qc_lady_sardo_data_migration_date', 'date',  NULL , '0', '', '', '', 'sardo migration date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_lady_sardo_data_migration_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sardo migration date' AND `language_tag`=''), '3', '101', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('sardo migration date','SARDO Data Migration','Migration Données SARDO');

UPDATE versions SET branch_build_number = '5736' WHERE version_number = '2.6.2';

-- -------------------------------------------------------------------------------------------------------------------
-- SQL statements executed on 2014-05-20
-- -------------------------------------------------------------------------------------------------------------------

-- Participant Race

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Races');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
('other', 'Other', 'Autre', '1', @control_id, NOW(), NOW(), 1, 1);

-- Consent Status

INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("to be verified", "to be verified"),("not obtained", "not obtained"),("sent", "sent");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="consent_status"), (SELECT id FROM structure_permissible_values WHERE value="to be verified" AND language_alias="to be verified"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="consent_status"), (SELECT id FROM structure_permissible_values WHERE value="not obtained" AND language_alias="not obtained"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="consent_status"), (SELECT id FROM structure_permissible_values WHERE value="sent" AND language_alias="sent"), "", "1");
INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('to be verified','To be verified','À vérifier'),('not obtained','Not obtained','Non-obtenu'),('sent','Ssent','Envoyé');

-- Delete any EventSmoking

UPDATE event_masters SET deleted = 1 WHERE event_control_id IN (SELECT id FROM event_controls WHERE flag_active = 0);

-- Imaging types

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Imaging Types');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
INSERT INTO `structure_permissible_values_customs` (`value`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("mammographie","Mammographie", '1', @control_id, NOW(), NOW(), 1, 1),
("echographie des seins","Echographie des seins", '1', @control_id, NOW(), NOW(), 1, 1),
("scintigraphie osseuse","Scintigraphie osseuse", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie abdominale, thoracique et pelvienne","Tomodensitométrie abdominale, thoracique et pelvienne", '1', @control_id, NOW(), NOW(), 1, 1),
("irm du sein","IRM du sein", '1', @control_id, NOW(), NOW(), 1, 1),
("radiographie osseuse","Radiographie osseuse", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie crânienne","Tomodensitométrie crânienne", '1', @control_id, NOW(), NOW(), 1, 1),
("tomographie d'émission par positron du corps entier","Tomographie d'émission par positron du corps entier", '1', @control_id, NOW(), NOW(), 1, 1),
("irm de la colonne vertébrale","IRM de la colonne vertébrale", '1', @control_id, NOW(), NOW(), 1, 1),
("irm osseuse","IRM osseuse", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie abdominale et thoracique","Tomodensitométrie abdominale et thoracique", '1', @control_id, NOW(), NOW(), 1, 1),
("echographie de l'aisselle","Echographie de l'aisselle", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie de la colonne vertébrale","Tomodensitométrie de la colonne vertébrale", '1', @control_id, NOW(), NOW(), 1, 1),
("echographie abdominale","Echographie abdominale", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie abdominale et pelvienne","Tomodensitométrie abdominale et pelvienne", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie du rachis cervival","Tomodensitométrie du rachis cervival", '1', @control_id, NOW(), NOW(), 1, 1),
("radiographie thoracique","Radiographie thoracique", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie thoracique","Tomodensitométrie thoracique", '1', @control_id, NOW(), NOW(), 1, 1),
("echographie abdominale et pelvienne","Echographie abdominale et pelvienne", '1', @control_id, NOW(), NOW(), 1, 1),
("irm du foie","IRM du foie", '1', @control_id, NOW(), NOW(), 1, 1),
("irm abdominale","IRM abdominale", '1', @control_id, NOW(), NOW(), 1, 1),
("irm de la tête","IRM de la tête", '1', @control_id, NOW(), NOW(), 1, 1),
("tomographie d'émission par positron de la région cervicale et du tronc","Tomographie d'émission par positron de la région cervicale et du tronc", '1', @control_id, NOW(), NOW(), 1, 1),
("coloscopie","Coloscopie", '1', @control_id, NOW(), NOW(), 1, 1),
("angioscan","Angioscan", '1', @control_id, NOW(), NOW(), 1, 1),
("irm du cerveau","IRM du cerveau", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie du cerveau","Tomodensitométrie du cerveau", '1', @control_id, NOW(), NOW(), 1, 1),
("echographie ganglionnaire","Echographie ganglionnaire", '1', @control_id, NOW(), NOW(), 1, 1),
("tomodensitométrie du rachis lombaire","Tomodensitométrie du rachis lombaire", '1', @control_id, NOW(), NOW(), 1, 1),
("irm du rachis lombaire","IRM du rachis lombaire", '1', @control_id, NOW(), NOW(), 1, 1),
("irm pelvienne","IRM pelvienne", '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE qc_lady_imagings SET type = lower(type);

-- 20140611 Already executed....

ALTER TABLE family_histories 
  ADD COLUMN qc_lady_other_cancer char(1) default '',
  ADD COLUMN qc_lady_other_cancer_notes varchar(250);
ALTER TABLE family_histories_revs 
  ADD COLUMN qc_lady_other_cancer char(1) default '',
  ADD COLUMN qc_lady_other_cancer_notes varchar(250);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'FamilyHistory', 'family_histories', 'qc_lady_other_cancer', 'yes_no',  NULL , '0', '', '', '', 'other cancer', ''), 
('ClinicalAnnotation', 'FamilyHistory', 'family_histories', 'qc_lady_other_cancer_notes', 'input',  NULL , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_lady_other_cancer' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other cancer' AND `language_tag`=''), '1', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='qc_lady_other_cancer_notes' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '1', '16', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields set language_tag = 'details', setting = 'size=30' WHERE tablename = 'family_histories' AND field = 'qc_lady_other_cancer_notes';
INSERT INTO i18n (id,en,fr) VALUES ('other cancer', 'Other Cancer', 'Autre cancer'); 

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='num_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='txd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='length_cycles' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE txd_chemos ADD COLUMN qc_lady_length_cycles_unit varchar(10) DEFAULT NULL;
ALTER TABLE txd_chemos_revs ADD COLUMN qc_lady_length_cycles_unit varchar(10) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_lady_length_cycles_unit", "", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_length_cycles_unit"), (SELECT id FROM structure_permissible_values WHERE value="d" AND language_alias="day_unit"), "3", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("w", "week_unit");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_lady_length_cycles_unit"), (SELECT id FROM structure_permissible_values WHERE value="w" AND language_alias="week_unit"), "4", "1");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txd_chemos', 'qc_lady_length_cycles_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_length_cycles_unit') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='txd_chemos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_chemos' AND `field`='qc_lady_length_cycles_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_length_cycles_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES ('week_unit', 'Week(s)', 'Semaine(s)'); 
REPLACE INTO i18n (id,en,fr) VALUES ('day_unit', 'Day(s)', 'Jour(s)'); 

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='fish_ratio' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='' WHERE model='TreatmentDetail' AND tablename='qc_lady_txd_biopsy_surgeries' AND field='fish_ccl' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_positive_negative_equivocal_result');
ALTER TABLE qc_lady_txd_biopsy_surgeries ADD COLUMN pcr char(1) default'';  
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs ADD COLUMN pcr char(1) default'';  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'pcr', 'yes_no',  NULL , '0', '', '', '', 'pcr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_patho_evaluations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='pcr' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pcr' AND `language_tag`=''), '2', '124', 'pcr', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `display_order`='140', `language_heading`='lesions' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='tumor_size_mm_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='141' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='tumor_size_mm_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='161', `language_heading`='lymph nodes' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='lymph_node_size_mm_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='162' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='lymph_node_size_mm_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='tumor #1 size (mm x mm)' WHERE model='EventDetail' AND tablename='qc_lady_clinical_evaluations' AND field='tumor_size_mm_x' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='lymph node #1 size (mm x mm)' WHERE model='EventDetail' AND tablename='qc_lady_clinical_evaluations' AND field='lymph_node_size_mm_x' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
ALTER TABLE  qc_lady_clinical_evaluations
 ADD COLUMN tumor_size_2_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_2_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_3_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_3_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_2_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_2_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_3_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_3_mm_y float(8,2) DEFAULT NULL;
ALTER TABLE  qc_lady_clinical_evaluations_revs
 ADD COLUMN tumor_size_2_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_2_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_3_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_3_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_2_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_2_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_3_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_3_mm_y float(8,2) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'tumor_size_2_mm_x', 'float_positive',  NULL , '0', '', '', '', 'tumor #2 size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'tumor_size_2_mm_y', 'float_positive',  NULL , '0', '', '', '', '', 'X'), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'tumor_size_3_mm_x', 'float_positive',  NULL , '0', '', '', '', 'tumor #3 size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'tumor_size_3_mm_y', 'float_positive',  NULL , '0', '', '', '', '', 'X'), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'lymph_node_size_2_mm_x', 'float_positive',  NULL , '0', '', '', '', 'lymph node #2 size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'lymph_node_size_2_mm_y', 'float_positive',  NULL , '0', '', '', '', '', 'X'), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'lymph_node_size_3_mm_x', 'float_positive',  NULL , '0', '', '', '', 'lymph node #3 size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_clinical_evaluations', 'lymph_node_size_3_mm_y', 'float_positive',  NULL , '0', '', '', '', '', 'X');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='tumor_size_2_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor #2 size (mm x mm)' AND `language_tag`=''), '2', '142', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='tumor_size_2_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='X'), '2', '143', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='tumor_size_3_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor #3 size (mm x mm)' AND `language_tag`=''), '2', '144', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='tumor_size_3_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='X'), '2', '145', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='lymph_node_size_2_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node #2 size (mm x mm)' AND `language_tag`=''), '2', '163', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='lymph_node_size_2_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='X'), '2', '164', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='lymph_node_size_3_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node #3 size (mm x mm)' AND `language_tag`=''), '2', '165', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_clinical_evaluations'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_clinical_evaluations' AND `field`='lymph_node_size_3_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='X'), '2', '166', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) VALUES 
('lesions', 'Lesions', 'Lésions'),
('tumor #1 size (mm x mm)', 'Tumor #1 Size (mm*mm)', 'Taille tumeur #1 (mm*mm) '),
('lymph node #1 size (mm x mm)', 'Lymph Node #1 Size (mm*mm)', 'Taille ganglions lymphatique #1 (mm*mm)'),
('tumor #2 size (mm x mm)', 'Tumor #2 Size (mm*mm)', 'Taille tumeur #2 (mm*mm) '),
('lymph node #2 size (mm x mm)', 'Lymph Node #2 Size (mm*mm)', 'Taille ganglions lymphatique #2 (mm*mm)'),
('tumor #3 size (mm x mm)', 'Tumor #3 Size (mm*mm)', 'Taille tumeur #3 (mm*mm) '),
('lymph node #3 size (mm x mm)', 'Lymph Node #3 Size (mm*mm)', 'Taille ganglions lymphatique #3 (mm*mm)');

UPDATE structure_formats SET `display_order`='140', `language_heading`='lesions' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='tumor_size_mm_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='141' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='tumor_size_mm_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='161', `language_heading`='lymph nodes' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='lymph_node_size_mm_x' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='162' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_lady_imagings') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='lymph_node_size_mm_y' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `language_label`='tumor #1 size (mm x mm)' WHERE model='EventDetail' AND tablename='qc_lady_imagings' AND field='tumor_size_mm_x' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_label`='lymph node #1 size (mm x mm)' WHERE model='EventDetail' AND tablename='qc_lady_imagings' AND field='lymph_node_size_mm_x' AND `type`='float_positive' AND structure_value_domain  IS NULL ;
ALTER TABLE  qc_lady_imagings
 ADD COLUMN tumor_size_2_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_2_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_3_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_3_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_2_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_2_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_3_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_3_mm_y float(8,2) DEFAULT NULL;
ALTER TABLE  qc_lady_imagings_revs
 ADD COLUMN tumor_size_2_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_2_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_3_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN tumor_size_3_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_2_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_2_mm_y float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_3_mm_x float(8,2) DEFAULT NULL,
 ADD COLUMN lymph_node_size_3_mm_y float(8,2) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'tumor_size_2_mm_x', 'float_positive',  NULL , '0', '', '', '', 'tumor #2 size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'tumor_size_2_mm_y', 'float_positive',  NULL , '0', '', '', '', '', 'X'), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'tumor_size_3_mm_x', 'float_positive',  NULL , '0', '', '', '', 'tumor #3 size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'tumor_size_3_mm_y', 'float_positive',  NULL , '0', '', '', '', '', 'X'), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'lymph_node_size_2_mm_x', 'float_positive',  NULL , '0', '', '', '', 'lymph node #2 size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'lymph_node_size_2_mm_y', 'float_positive',  NULL , '0', '', '', '', '', 'X'), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'lymph_node_size_3_mm_x', 'float_positive',  NULL , '0', '', '', '', 'lymph node #3 size (mm x mm)', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_imagings', 'lymph_node_size_3_mm_y', 'float_positive',  NULL , '0', '', '', '', '', 'X');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='tumor_size_2_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor #2 size (mm x mm)' AND `language_tag`=''), '2', '142', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='tumor_size_2_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='X'), '2', '143', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='tumor_size_3_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor #3 size (mm x mm)' AND `language_tag`=''), '2', '144', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='tumor_size_3_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='X'), '2', '145', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='lymph_node_size_2_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node #2 size (mm x mm)' AND `language_tag`=''), '2', '163', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='lymph_node_size_2_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='X'), '2', '164', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='lymph_node_size_3_mm_x' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node #3 size (mm x mm)' AND `language_tag`=''), '2', '165', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_imagings'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_imagings' AND `field`='lymph_node_size_3_mm_y' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='X'), '2', '166', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

ALTER TABLE qc_lady_txd_biopsy_surgeries 
  ADD COLUMN other_staining char(1) default '',
  ADD COLUMN other_staining_notes varchar(250);
ALTER TABLE qc_lady_txd_biopsy_surgeries_revs 
  ADD COLUMN other_staining char(1) default '',
  ADD COLUMN other_staining_notes varchar(250);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'other_staining', 'yes_no',  NULL , '0', '', '', '', 'other staining', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_lady_txd_biopsy_surgeries', 'other_staining_notes', 'yes_no',  NULL , '0', '', '', '', '', 'details');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='other_staining' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='other staining' AND `language_tag`=''), '2', '148', 'other staining', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_txd_biopsy_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_lady_txd_biopsy_surgeries' AND `field`='other_staining_notes' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='details'), '2', '149', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET type = 'input', setting = 'size=30' WHERE field = 'other_staining_notes';
INSERT INTO i18n (id,en,fr) VALUES ('other staining', 'Other Staining', 'Autre coloration');




INSERT INTO event_controls (id, disease_site, event_group, event_type, flag_active, detail_form_alias, detail_tablename, display_order, databrowser_label, flag_use_for_ccl, use_addgrid, use_detail_form_for_index) VALUES
(null, '', 'clinical', 'blood marker', 1, 'qc_lady_blood_markers', 'qc_lady_blood_markers', 0, 'blood marker', 0, 1, 1);
CREATE TABLE IF NOT EXISTS qc_lady_blood_markers (
  event_master_id int(11) NOT NULL,
  type varchar(100) DEFAULT NULL,
  value float(8,2) DEFAULT NULL,
  test_unit varchar(10) DEFAULT NULL,
  KEY event_master_id (event_master_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS qc_lady_blood_markers_revs (
  event_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL AUTO_INCREMENT,
  version_created datetime NOT NULL,
  type varchar(100) DEFAULT NULL,
  value float(8,2) DEFAULT NULL,
  test_unit varchar(10) DEFAULT NULL,
  PRIMARY KEY (version_id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ; 
ALTER TABLE `qc_lady_blood_markers`
  ADD CONSTRAINT qc_lady_blood_markers_ibfk_1 FOREIGN KEY (event_master_id) REFERENCES event_masters (id);

INSERT INTO structures(`alias`) VALUES ('qc_lady_blood_markers');
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("qc_lady_blood_markers", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Blood markers\')"),
("qc_lady_blood_markers_unit", "", "", "StructurePermissibleValuesCustom::getCustomDropdown(\'Blood markers Units\')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Blood markers', 1, 100, 'clinical - annotation'),
('Blood markers Units', 1, 10, 'clinical - annotation');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Blood markers');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('CEA','','', '1', @control_id, NOW(), NOW(), 1, 1),
('CA125','','', '1', @control_id, NOW(), NOW(), 1, 1),
('CA19.9','','', '1', @control_id, NOW(), NOW(), 1, 1),
('CA15.3','','', '1', @control_id, NOW(), NOW(), 1, 1),
('CA27.29','','', '1', @control_id, NOW(), NOW(), 1, 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Blood markers Units');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES 
('ug/l','','', '1', @control_id, NOW(), NOW(), 1, 1),
('u/mL','','', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'qc_lady_blood_markers', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_blood_markers') , '0', '', '', '', 'test', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_blood_markers', 'value', 'float_positive',  NULL , '0', '', '', '', 'result', ''), 
('ClinicalAnnotation', 'EventDetail', 'qc_lady_blood_markers', 'test_unit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_blood_markers_unit') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_lady_blood_markers'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_blood_markers'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_blood_markers' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_blood_markers')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='test' AND `language_tag`=''), '2', '140', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_blood_markers'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_blood_markers' AND `field`='value' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='result' AND `language_tag`=''), '2', '141', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='qc_lady_blood_markers'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_lady_blood_markers' AND `field`='test_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_lady_blood_markers_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '2', '142', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '0'); 
INSERT INTO i18n (id,en,fr) VALUES ('blood marker','Blood Marker','Marqueur sanguin'),('test','Test','Test');

UPDATE participants SET date_of_birth = null, date_of_birth_accuracy = '', marital_status = '', language_preferred = '', sex = '', race = '', vital_status = '', first_name = 'to create', last_name = 'to create' where participant_identifier IN (1642,1648) AND deleted = 1;

UPDATE reproductive_histories rh, participants p, diagnosis_masters dx
SET rh.date_captured = dx.dx_date, rh.date_captured_accuracy = dx.dx_date_accuracy
WHERE rh.date_captured = '2014-05-14' AND rh.participant_id = p.id AND p.id = dx.participant_id
AND rh.deleted <> 1 AND dx.deleted <> 1 AND dx.dx_date IS NOT NULL AND dx.dx_date NOT LIKE '';

UPDATE versions SET branch_build_number = '5779' WHERE version_number = '2.6.2';

