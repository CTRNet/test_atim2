INSERT INTO i18n (id, en, fr) 
VALUES
("contact if need more information", "Contact if need more information", "Contacter si besoin d'informations supplémentaires"),
("contact if scientific discovery", "Contact if scientific discovery", "Contacter si découverte scientifique"),
("study on other disease", "Study on other disease", "Étude sur d'autre maladie"),
("contact if discovered on other diseases", "Contact if discovered on other diseases", "Contacter si découvertes sur d'autres maladies"),
("other contacts in case of death", "Other contacts in case of death", "Autres contacts en cas de décès");
ALTER TABLE procure_cd_sigantures
  ADD COLUMN procure_chus_contact_for_more_info char(1) DEFAULT '',
  ADD COLUMN procure_chus_contact_if_scientific_discovery char(1) DEFAULT '',
  ADD COLUMN procure_chus_study_on_other_diseases char(1) DEFAULT '',
  ADD COLUMN procure_chus_contact_if_discovery_on_other_diseases char(1) DEFAULT '',
  ADD COLUMN procure_chus_other_contacts_in_case_of_death char(1) DEFAULT '';
ALTER TABLE procure_cd_sigantures_revs
  ADD COLUMN procure_chus_contact_for_more_info char(1) DEFAULT '',
  ADD COLUMN procure_chus_contact_if_scientific_discovery char(1) DEFAULT '',
  ADD COLUMN procure_chus_study_on_other_diseases char(1) DEFAULT '',
  ADD COLUMN procure_chus_contact_if_discovery_on_other_diseases char(1) DEFAULT '',
  ADD COLUMN procure_chus_other_contacts_in_case_of_death char(1) DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chus_contact_for_more_info', 'yes_no',  NULL , '0', '', '', '', 'contact if need more information', ''),
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chus_contact_if_scientific_discovery', 'yes_no',  NULL , '0', '', '', '', 'contact if scientific discovery', ''),
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chus_study_on_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'study on other disease', ''),
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chus_contact_if_discovery_on_other_diseases', 'yes_no',  NULL , '0', '', '', '', 'contact if discovered on other diseases', ''),
('ClinicalAnnotation', 'ConsentDetail', 'procure_cd_sigantures', 'procure_chus_other_contacts_in_case_of_death', 'yes_no',  NULL , '0', '', '', '', 'other contacts in case of death', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `tablename`='procure_cd_sigantures' AND `field`='procure_chus_contact_for_more_info'), '2', '30', 'details', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `tablename`='procure_cd_sigantures' AND `field`='procure_chus_contact_if_scientific_discovery'), '2', '31', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `tablename`='procure_cd_sigantures' AND `field`='procure_chus_study_on_other_diseases'), '2', '32', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `tablename`='procure_cd_sigantures' AND `field`='procure_chus_contact_if_discovery_on_other_diseases'), '2', '33', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='procure_consent_form_siganture'), (SELECT id FROM structure_fields WHERE `tablename`='procure_cd_sigantures' AND `field`='procure_chus_other_contacts_in_case_of_death'), '2', '34', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE storage_controls SET flag_active = 0 WHERE storage_type NOT IN ('room', 'freezer', 'rack16', 'shelf');
ALTER TABLE storage_masters CHANGE COLUMN short_label short_label varchar(60) DEFAULT NULL,  CHANGE COLUMN selection_label selection_label varchar(150) DEFAULT '';
ALTER TABLE storage_masters_revs CHANGE COLUMN short_label short_label varchar(60) DEFAULT NULL,  CHANGE COLUMN selection_label selection_label varchar(150) DEFAULT '';
INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, 
`display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) 
VALUES
(null, 'box40', 'position', 'integer', 40, NULL, NULL, NULL, 10, 4, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'box40', 1),
(null, 'box100 10x10', 'row', 'integer', 10, 'column', 'integer', 10, 10, 10, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'box100 10x10', 1)
(null, 'box30 3x10', 'row', 'integer', 3, 'column', 'integer', 10, 3, 10, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'box30 3x10', 1);
INSERT INTO i18n (id,en,fr)
 VALUES 
('box40','Box40 1-40', 'Boîte40 1-40'),
('box100 10x10','Box100 10x10', 'Boîte100 10x10'),
('box30 3x10','Box30 3x10', 'Boîte30 3x10');


















