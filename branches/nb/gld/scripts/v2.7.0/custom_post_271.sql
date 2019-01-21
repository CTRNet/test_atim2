-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Initial Customization
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

SET @modified = (SELECT NOW() FROM users WHERE id = '2');
SET @modified_by = (SELECT id FROM users WHERE id = '2');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Administration
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Set the ATiM installation name

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'GLD Moncton', 'GLD Moncton');

-- Users & Groups
-- ...................................................................................................................................

-- Manage users account that will be setup by default after the ATiM installation
-- (Could be done manually after the first installation using the ATiM functionalities of the "> Administration > Groups (Users & Permissions) " tool.)
--    . Activate first user
--    . Change second one to 'MigrationScript' with a complex password for any future data migration done by script
--    . Inactivate all the other one and assigned them a complex password

UPDATE groups SET flag_show_confidential = '1' WHERE id = 1;
UPDATE users SET flag_active = '1', password_modified = @modified, force_password_reset = '0' WHERE id = 1;

UPDATE users SET flag_active = 0, username = 'MigrationScript', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id = 2;
UPDATE groups SET name = 'System' WHERE id = 2;

UPDATE users SET flag_active = 0, password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id > 2;

UPDATE users SET first_name = username, email = '';

-- Banks
-- ...................................................................................................................................

-- Change name of the first bank from 'Default' to 'Lung' + create lymphoma bank
-- (Could be done manually after the first installation using the ATiM functionalities of the "> Administration > Banks " tool)

UPDATE banks SET name = 'Lung', description = '';

INSERT INTO banks (name, description, created_by, modified_by, created, modified) VALUES ('Lymphoma', '', @modified_by, @modified_by, @modified, @modified);

-- Custom Drop Down List

UPDATE structure_permissible_values_custom_controls
SET flag_active = 0
WHERE name IN ('SOP Versions ', 'Xenograft Species', 'Xenograft Implantation Sites', 'Xenograft Tissues Sources');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Clinical Annotation
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Profile
-- ...................................................................................................................................

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

-- Date of birth

ALTER TABLE participants ADD COLUMN gld_dob_unknown tinyint(1) DEFAULT '0';
ALTER TABLE participants_revs ADD COLUMN gld_dob_unknown tinyint(1) DEFAULT '0';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'gld_dob_unknown', 'checkbox',  NULL , '0', '', '', '', 'unknown', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='gld_dob_unknown' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='unknown' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET `language_label` = '', `language_tag` = 'unknown' WHERE field = 'gld_dob_unknown';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('unknown date of birth should not be completed', 'Unknown date of birth should not be completed', 'Une date de naissance inconnue ne doit pas être complétée');

-- Date of death

ALTER TABLE participants ADD COLUMN gld_dod_unknown tinyint(1) DEFAULT '0';
ALTER TABLE participants_revs ADD COLUMN gld_dod_unknown tinyint(1) DEFAULT '0';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'gld_dod_unknown', 'checkbox',  NULL , '0', '', '', '', 'unknown', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='gld_dod_unknown' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='unknown' AND `language_tag`=''), '3', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET `language_label` = '', `language_tag` = 'unknown' WHERE field = 'gld_dod_unknown';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('unknown date of death should not be completed', 'Unknown date of death should not be completed', 'Une date de décès inconnue ne doit pas être complétée');

-- Participant Status

ALTER TABLE participants 
  ADD COLUMN gld_contact_status varchar(50) DEFAULT NULL,
  ADD COLUMN gld_participant_status varchar(50) DEFAULT NULL;
ALTER TABLE participants_revs 
  ADD COLUMN gld_contact_status varchar(50) DEFAULT NULL,
  ADD COLUMN gld_participant_status varchar(50) DEFAULT NULL;  
INSERT INTO structure_value_domains (domain_name, source)
VALUES
("gld_participant_contact_status", "StructurePermissibleValuesCustom::getCustomDropdown('Participant Contact Status')"),
("gld_participant_status", "StructurePermissibleValuesCustom::getCustomDropdown('Participant Status')");
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('Participant Contact Status', 1, 50, 'clinical'),
('Participant Status', 1, 50, 'clinical');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Contact Status');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('contact allowed', 'Contact Allowed',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('no further contact', 'No Further Contact',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Status');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('active', 'Active',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by),
('withdrawn', 'Withdrawn',  '', '1', @control_id, @modified, @modified, @modified_by, @modified_by);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'gld_contact_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_participant_contact_status') , '0', '', '', '', 'contact status', ''), 
('ClinicalAnnotation', 'Participant', '', 'gld_participant_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_participant_status') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='gld_contact_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_participant_contact_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='contact status' AND `language_tag`=''), '3', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='' AND `field`='gld_participant_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_participant_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '3', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `tablename`='participants',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='gld_participant_status') ,  `language_label`='participant status' WHERE model='Participant' AND tablename='' AND field='gld_participant_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='gld_participant_status');

ALTER TABLE participants 
  ADD COLUMN gld_participant_withdrawn date DEFAULT NULL,
  ADD COLUMN gld_participant_withdrawn_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs 
  ADD COLUMN gld_participant_withdrawn date DEFAULT NULL,
  ADD COLUMN gld_participant_withdrawn_accuracy char(1) NOT NULL DEFAULT '';
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'gld_participant_withdrawn', 'date',  NULL , '0', '', '', '', '', 'withdrawn');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='gld_participant_withdrawn' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='withdrawn'), '3', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("contact status", "Contact Status", ""),
("participant status", "Participant Status", "");

-- HIV ...

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("yes_no_unknown", "locked", "indicator", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yes_no_unknown"), (SELECT id FROM structure_permissible_values WHERE value="yes" AND language_alias="yes"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yes_no_unknown"), (SELECT id FROM structure_permissible_values WHERE value="no" AND language_alias="no"), "0", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="yes_no_unknown"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "2", "1");
ALTER TABLE participants 
  ADD COLUMN gld_hiv varchar(20) DEFAULT NULL,
  ADD COLUMN gld_hep_abc varchar(20) DEFAULT NULL;
ALTER TABLE participants_revs
  ADD COLUMN gld_hiv varchar(20) DEFAULT NULL,
  ADD COLUMN gld_hep_abc varchar(20) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'gld_hiv', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '1', '', '', '', 'hiv', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'gld_hep_abc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown') , '1', '', '', '', 'hepatitis a, b or c', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='gld_hiv' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hiv' AND `language_tag`=''), '3', '20', 'viral infections', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='gld_hep_abc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yes_no_unknown')  AND `flag_confidential`='1' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hepatitis a, b or c' AND `language_tag`=''), '3', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('viral infections', 'Viral Infections', "Infections virales"),
("hiv", "HIV", "VIH"),
("hepatitis a, b or c", "Hepatitis A, B or C", "Hépatite A, B ou C");

ALTER TABLE participants 
  ADD COLUMN gld_hiv_details text DEFAULT NULL,
  ADD COLUMN gld_hep_abc_details text DEFAULT NULL;
ALTER TABLE participants_revs
  ADD COLUMN gld_hiv_details text DEFAULT NULL,
  ADD COLUMN gld_hep_abc_details text DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Participant', 'participants', 'gld_hiv_details', 'textarea',  NULL , '1', 'rows=1,cols=30', '', '', '', 'details'), 
('InventoryManagement', 'Participant', 'participants', 'gld_hep_abc_details', 'textarea',  NULL , '1', 'rows=1,cols=30', '', '', '', 'details');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='gld_hiv_details' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='rows=1,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='details'), '3', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='gld_hep_abc_details' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1' AND `setting`='rows=1,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='details'), '3', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Participant Identifier

REPLACE INTO i18n (id,en,fr) VALUES ('participant identifier', 'Biobank ID', 'Biobanque ID');

-- Sex

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('gender at birth', 'Gender at birth', 'Sexe à la naissance');
UPDATE structure_fields SET  `language_label`='gender at birth' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');

-- Other

REPLACE INTO i18n (id,en,fr)
VALUES
('last chart checked date', "Date of Medical Record Review", "Date révision du dossier médical");
ALTER TABLE participants 
  ADD COLUMN gld_medical_record_review_sources text DEFAULT NULL;
ALTER TABLE participants_revs
  ADD COLUMN gld_medical_record_review_sources text DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'gld_medical_record_review_sources', 'textarea',  NULL , '0', 'rows=2,cols=30', '', '', 'medical record sources', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='gld_medical_record_review_sources' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=2,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='medical record sources' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("medical record sources", "Medical Record Review Sources", "");
 
-- Misc-Identifier (Participant Identifiers)
-- ...................................................................................................................................

-- Hide dates and note fields

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='effective_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='expiry_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Add study identifier

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, flag_link_to_study) 
VALUES
('patient study id', 1, '', '', 0, 0, 0, 0, '', '', '1');
INSERT INTO i18n (id,en,fr) 
VALUES 
('patient study id', 'Patient Study ID', 'ID Patient - Étude');

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers_for_participant_search') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='miscidentifiers') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Other identifiers

INSERT INTO `misc_identifier_controls` (`misc_identifier_name`, `flag_active`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, flag_link_to_study) 
VALUES
('medicare card', 1, '', '', 1, 1, 1, 0, '', '', '0'),
('gld card', 1, '', '', 1, 1, 1, 0, '', '', '0');
INSERT INTO i18n (id,en,fr) 
VALUES 
('gld card', 'GLD Card', ''),
('medicare card', 'Medicare card', '');

-- Consent
-- ...................................................................................................................................

UPDATE consent_controls SET flag_active = 0;

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='reason_denied' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `field`='consent_status'), 'notBlank', '');

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) 
VALUES
(null, 'informed consent', 1, 'gld_informed_consents', 'gld_informed_consents', 0, 'informed consent');
ALTER TABLE consent_masters
   ADD COLUMN gld_language varchar(10) DEFAULT NULL;
ALTER TABLE consent_masters_revs
   ADD COLUMN gld_language varchar(10) DEFAULT NULL;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentMaster', 'consent_masters', 'gld_language', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='lang') , '0', '', '', '', 'language', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='gld_language' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='lang')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='language' AND `language_tag`=''), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

CREATE TABLE `gld_informed_consents` (
  `consent_master_id` int(11) NOT NULL,
  participant_require_assistance char(1) DEFAULT '',
  assistance_reason varchar(100) DEFAULT NULL  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `gld_informed_consents_revs` (
  `consent_master_id` int(11) NOT NULL,
  participant_require_assistance char(1) DEFAULT '',
  assistance_reason varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `gld_informed_consents`
  ADD KEY `consent_master_id` (`consent_master_id`),
  ADD CONSTRAINT `gld_informed_consents_ibfk_1` FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`);
ALTER TABLE `gld_informed_consents_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('Consent Assistance Reasons', 1, 100, 'clinical - consent');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Consent Assistance Reasons');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("the participant is unable to read", "The participant is unable to read", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by), 
("an interpreter/ translator assisted during the consent process", "An interpreter/ translator assisted during the consent process", "", "2", "1", @control_id, @modified, @modified, @modified_by, @modified_by);
INSERT INTO structure_value_domains (domain_name, override, category, source) values
('gld_consent_assistance_reasons', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Consent Assistance Reasons\')');
INSERT INTO structures(`alias`) VALUES ('gld_informed_consents');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ConsentDetail', 'gld_informed_consents', 'participant_require_assistance', 'yes_no',  NULL , '0', '', '', '', 'participant required assistance', ''), 
('ClinicalAnnotation', 'ConsentDetail', 'gld_informed_consents', 'assistance_reason', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_consent_assistance_reasons') , '0', '', '', '', 'reason', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='gld_informed_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='gld_informed_consents' AND `field`='participant_require_assistance' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='participant required assistance' AND `language_tag`=''), '2', '20', 'details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_informed_consents'), (SELECT id FROM structure_fields WHERE `model`='ConsentDetail' AND `tablename`='gld_informed_consents' AND `field`='assistance_reason' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_consent_assistance_reasons')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='reason' AND `language_tag`=''), '2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr)
VALUES
('informed consent', 'Informed Consent', 'Consentement éclairé'),
("participant required assistance", 'Participant Required Assistance', '');

-- Create study consent

INSERT INTO `consent_controls` (`id`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
(null, 'study consent', 1, 'consent_masters_study', 'cd_nationals', 0, 'study consent');
INSERT INTO i18n (id,en,fr) VALUES ('study consent', 'Sudy Consent', 'Consentement d''étude');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `field`='autocomplete_consent_study_summary_id'), 'notBlank', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='consent_masters'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '2', '', '0', '1', '', '1', '-', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters_study') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ConsentMaster') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary');

-- Event Master				
-- ...................................................................................................................................

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/%/lifestyle%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/%/Study%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/%/screening%';

-- Biomarker

UPDATE event_controls SET flag_active = 0 WHERE event_group = 'lab';
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_use_for_ccl`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, '', 'lab', 'biomarker', 1, 'gld_ed_biomarkers', 'gld_ed_biomarkers', 0, 'biomarker', 0, 1, 1);
CREATE TABLE `gld_ed_biomarkers` (
  `biomarker` varchar(50) DEFAULT NULL,
  `biomarkers_panel` varchar(250) DEFAULT NULL,
  `qualitative_result` varchar(50) DEFAULT NULL,
  `mutation_status` varchar(50) DEFAULT NULL,
  `test_added_to_file` char(1) DEFAULT '',
  `event_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `gld_ed_biomarkers_revs` (
  `biomarker` varchar(50) DEFAULT NULL,
  `biomarkers_panel` varchar(250) DEFAULT NULL,
  `qualitative_result` varchar(50) DEFAULT NULL,
  `mutation_status` varchar(50) DEFAULT NULL,
  `test_added_to_file` char(1) DEFAULT '',
  `event_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `gld_ed_biomarkers`
  ADD KEY `event_master_id` (`event_master_id`),
  ADD CONSTRAINT `gld_ed_biomarkers_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);
ALTER TABLE `gld_ed_biomarkers_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;

INSERT INTO structure_value_domains (domain_name, override, category, source) values
('gld_biomarkers', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Biomarkers\')'),
('gld_biomarkers_panels', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Biomarkers Panels\')'),
('gld_mutation_status', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Mutation Status\')');
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('Biomarkers', 1, 50, 'clinical - annotation'),
('Biomarkers Panels', 1, 250, 'clinical - annotation'),
('Mutation Status', 1, 50, 'clinical - annotation'); 
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Biomarkers');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("PSA", "PSA", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("CEA", "CEA", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("Ca 19-9", "Ca 19-9", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by);
UPDATE structure_permissible_values_customs SET value = LOWER(en) WHERE control_id = @control_id;
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Biomarkers Panels');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("le lung and colon cancer mutation", "le lung and colon cancer mutation", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("Lung, colon cancer, Melanoma Mutation", "Lung, colon cancer, Melanoma Mutation", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("Hotspot", "Hotspot", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by);
UPDATE structure_permissible_values_customs SET value = LOWER(en) WHERE control_id = @control_id;
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Mutation Status');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("mutated", "Mutated", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by),
("wild-type", "Wild-Type", "", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by);
 
INSERT INTO structures(`alias`) VALUES ('gld_ed_biomarkers'); 
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'gld_ed_biomarkers', 'biomarker', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_biomarkers') , '0', '', '', '', 'biomarker', ''), 
('ClinicalAnnotation', 'EventDetail', 'gld_ed_biomarkers', 'biomarkers_panel', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_biomarkers_panels') , '0', '', '', '', 'panel', ''), 
('ClinicalAnnotation', 'EventDetail', 'gld_ed_biomarkers', 'qualitative_result', 'input',  NULL , '0', 'size=20', '', '', 'qualitative result if applicable', ''), 
('ClinicalAnnotation', 'EventDetail', 'gld_ed_biomarkers', 'mutation_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_mutation_status') , '0', '', '', '', 'mutation status if applicable', ''), 
('ClinicalAnnotation', 'EventDetail', 'gld_ed_biomarkers', 'test_added_to_file', 'yes_no',  NULL , '0', '', '', '', 'test added to file', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='gld_ed_biomarkers'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='gld_ed_biomarkers' AND `field`='biomarker' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_biomarkers')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='biomarker' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_ed_biomarkers'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='gld_ed_biomarkers' AND `field`='biomarkers_panel' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_biomarkers_panels')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='panel' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_ed_biomarkers'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='gld_ed_biomarkers' AND `field`='qualitative_result' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='qualitative result if applicable' AND `language_tag`=''), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_ed_biomarkers'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='gld_ed_biomarkers' AND `field`='mutation_status' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_mutation_status')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='mutation status if applicable' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_ed_biomarkers'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='gld_ed_biomarkers' AND `field`='test_added_to_file' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='test added to file' AND `language_tag`=''), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='gld_ed_biomarkers' AND `field`='biomarker'), 'notBlank', '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('biomarker', 'Biomarker', 'Biomarqueur'),
('panel', 'Panel', 'Panel'),
('qualitative result if applicable', 'Qualitative Result (if applicable)', "Résultat qualitatif (si applicable)"),
('mutation status if applicable', 'Mutation Status (if applicable)', "Statut de mutation (si applicable)"),
('test added to file', 'Test Added to File', "Test ajouté au dossier");
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='gld_ed_biomarkers'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '1', 'cols=40,rows=1', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Follow-up

UPDATE event_controls SET flag_active = 0 WHERE event_group != 'lab' && event_type != 'follow up';
UPDATE event_controls SET disease_site = '', databrowser_label = CONCAT(event_group,'|',event_type) WHERE flag_active = 1;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='recurrence_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='disease_status' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='2', `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='weight' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE ed_all_clinical_followups
  ADD COLUMN gld_medical_history text DEFAULT NULL,
  ADD COLUMN gld_smoker char(1) DEFAULT '',
  ADD COLUMN gld_smoker_quantity varchar(50) DEFAULT NULL,
  ADD COLUMN gld_smoker_details text DEFAULT NULL,
  ADD COLUMN gld_exposure_to_chemical_compounds char(1) DEFAULT '',
  ADD COLUMN gld_exposure_to_chemical_compounds_details text DEFAULT NULL,
  ADD COLUMN gld_chronical_disease char(1) DEFAULT '',
  ADD COLUMN gld_chronical_disease_details text DEFAULT NULL;
ALTER TABLE ed_all_clinical_followups_revs
  ADD COLUMN gld_medical_history text DEFAULT NULL,
  ADD COLUMN gld_smoker char(1) DEFAULT '',
  ADD COLUMN gld_smoker_quantity varchar(50) DEFAULT NULL,
  ADD COLUMN gld_smoker_details text DEFAULT NULL,
  ADD COLUMN gld_exposure_to_chemical_compounds char(1) DEFAULT '',
  ADD COLUMN gld_exposure_to_chemical_compounds_details text DEFAULT NULL,
  ADD COLUMN gld_chronical_disease char(1) DEFAULT '',
  ADD COLUMN gld_chronical_disease_details text DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'ed_all_clinical_followups', 'gld_medical_history', 'textarea',  NULL , '0', 'rows=1,cols=30', '', '', 'medical history', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_all_clinical_followups', 'gld_smoker', 'yes_no',  NULL , '0', '', '', '', 'smoker', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_all_clinical_followups', 'gld_smoker_quantity', 'input',  NULL , '0', 'size=10', '', '', 'quantity', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_all_clinical_followups', 'gld_smoker_details', 'textarea',  NULL , '0', 'rows=1,cols=30', '', '', 'details', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_all_clinical_followups', 'gld_exposure_to_chemical_compounds', 'yes_no',  NULL , '0', '', '', '', 'exposure', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_all_clinical_followups', 'gld_exposure_to_chemical_compounds_details', 'textarea',  NULL , '0', 'rows=1,cols=30', '', '', 'details', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_all_clinical_followups', 'gld_chronical_disease', 'yes_no',  NULL , '0', '', '', '', 'chronical diseases', ''), 
('ClinicalAnnotation', 'EventDetail', 'ed_all_clinical_followups', 'gld_chronical_disease_details', 'textarea',  NULL , '0', 'rows=1,cols=30', '', '', 'details', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ed_all_clinical_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='gld_medical_history' ), '1', '45', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_clinical_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='gld_smoker' AND `type`='yes_no'), '1', '46', 'smoker', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_clinical_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='gld_smoker_quantity' AND `type`='input'), '1', '47', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_clinical_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='gld_smoker_details' AND `type`='textarea'), '1', '48', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_clinical_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='gld_exposure_to_chemical_compounds' AND `type`='yes_no'), '1', '49', 'chemical compounds', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_clinical_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='gld_exposure_to_chemical_compounds_details' AND `type`='textarea'), '1', '50', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_clinical_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='gld_chronical_disease' AND `type`='yes_no'), '1', '51', 'chronical disease', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='ed_all_clinical_followup'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='ed_all_clinical_followups' AND `field`='gld_chronical_disease_details'), '1', '52', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats 
SET `display_column`='2' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='ed_all_clinical_followup') 
AND display_order > 45;


INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('medical history', 'Medical History', 'Historique Médicale'),
('quantity', 'Quantity', 'Quantité'),
('chemical compounds', 'Chemical Compounds', 'Composants chimiques'),
('chronical diseases', 'Chronical Diseases', 'Maladies chroniques'),
('chronical disease', 'Chronical Disease', 'Maladie chronique'),
('exposure', 'Exposure', 'Exposition');

UPDATE event_controls SET use_detail_form_for_index = 1 WHERE flag_active = 1;

-- Treatment Master				
-- ...................................................................................................................................

UPDATE treatment_controls SET flag_active = 0 WHERE id = 4;
UPDATE treatment_controls SET disease_site = '';
UPDATE treatment_controls SET databrowser_label = tx_method, use_detail_form_for_index = 1;

-- All treatment

UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='facility' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='facility') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');

-- Surgery

INSERT INTO structure_value_domains (domain_name, override, category, source) values
('gld_surgical_procedures', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Surgical Procedures\')');
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('Surgical Procedures', 1, 50, 'clinical - treatment');
UPDATE structure_fields SET  `type`='select',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='gld_surgical_procedures') ,  `setting`='' WHERE model='TreatmentExtendDetail' AND tablename='txe_surgeries' AND field='surgical_procedure';
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='txe_surgeries' AND `field`='surgical_procedure'), 'notBlank', '');

-- Chemo

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='pd_chemos') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ProtocolMaster' AND `tablename`='protocol_masters' AND `field`='arm' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Hormonotherapy / Immunotherpay

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("immunotherapy", "immunotherapy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="type"), (SELECT id FROM structure_permissible_values WHERE value="immunotherapy" AND language_alias="immunotherapy"), "1", "1");
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('immunotherapy', 'Immunotherapy', 'Immuno-thérapie');

INSERT INTO `protocol_extend_controls` (`id`, `detail_tablename`, `detail_form_alias`, `flag_active`) 
VALUES
(null, 'gld_pe_hormonos', 'gld_pe_hormonos', 1),
(null, 'gld_pe_immunos', 'gld_pe_immunos', 1);
CREATE TABLE `gld_pe_immunos` (
  `method` varchar(50) DEFAULT NULL,
  `dose` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `protocol_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `gld_pe_immunos_revs` (
  `method` varchar(50) DEFAULT NULL,
  `dose` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL,
  `protocol_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `gld_pe_immunos`
  ADD KEY `FK_gld_pe_immunos_protocol_extend_masters` (`protocol_extend_master_id`),
  ADD CONSTRAINT `FK_gld_pe_immunos_protocol_extend_masters` FOREIGN KEY (`protocol_extend_master_id`) REFERENCES `protocol_extend_masters` (`id`);
ALTER TABLE `gld_pe_immunos_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
CREATE TABLE `gld_pe_hormonos` (
  `method` varchar(50) DEFAULT NULL,
  `dose` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `protocol_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `gld_pe_hormonos_revs` (
  `method` varchar(50) DEFAULT NULL,
  `dose` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL,
  `protocol_extend_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `gld_pe_hormonos`
  ADD KEY `FK_gld_pe_hormonos_protocol_extend_masters` (`protocol_extend_master_id`),
  ADD CONSTRAINT `FK_gld_pe_hormonos_protocol_extend_masters` FOREIGN KEY (`protocol_extend_master_id`) REFERENCES `protocol_extend_masters` (`id`);
ALTER TABLE `gld_pe_hormonos_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
INSERT INTO structures(`alias`) VALUES ('gld_pe_hormonos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Protocol', 'ProtocolExtendDetail', 'gld_pe_hormonos', 'method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') , '0', '', '', '', 'method', ''), 
('Protocol', 'ProtocolExtendDetail', 'gld_pe_hormonos', 'dose', 'input',  NULL , '0', 'size=10', '', '', 'dose', ''), 
('Protocol', 'ProtocolExtendDetail', 'gld_pe_hormonos', 'frequency', 'input',  NULL , '0', 'size=10', '', '', 'frequency', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='gld_pe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='gld_pe_hormonos' AND `field`='method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_pe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='gld_pe_hormonos' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_pe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='gld_pe_hormonos' AND `field`='frequency' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='frequency' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_pe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_protocol_drug_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Drug/Drugs/autocompleteDrug' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_pe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='generic_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '0', '1', 'drug', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structures(`alias`) VALUES ('gld_pe_immunos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Protocol', 'ProtocolExtendDetail', 'gld_pe_immunos', 'method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') , '0', '', '', '', 'method', ''), 
('Protocol', 'ProtocolExtendDetail', 'gld_pe_immunos', 'dose', 'input',  NULL , '0', 'size=10', '', '', 'dose', ''), 
('Protocol', 'ProtocolExtendDetail', 'gld_pe_immunos', 'frequency', 'input',  NULL , '0', 'size=10', '', '', 'frequency', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='gld_pe_immunos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='gld_pe_immunos' AND `field`='method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='method' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_pe_immunos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='gld_pe_immunos' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_pe_immunos'), (SELECT id FROM structure_fields WHERE `model`='ProtocolExtendDetail' AND `tablename`='gld_pe_immunos' AND `field`='frequency' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='frequency' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_pe_immunos'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_protocol_drug_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Drug/Drugs/autocompleteDrug' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_pe_immunos'), (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='generic_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', '', '0', '1', 'drug', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT INTO `protocol_controls` (`id`, `tumour_group`, `type`, `detail_tablename`, `detail_form_alias`, `flag_active`, `protocol_extend_control_id`) 
VALUES
(null, 'all', 'hormonotherapy', 'gld_pd_hormonos', 'gld_pd_hormonos', 1, (SELECT id FROM protocol_extend_controls WHERE detail_tablename = 'gld_pe_hormonos')),
(null, 'all', 'immunotherapy', 'gld_pd_immunos', 'gld_pd_immunos', 1, (SELECT id FROM protocol_extend_controls WHERE detail_tablename = 'gld_pe_immunos'));
CREATE TABLE `gld_pd_immunos` (
  `protocol_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `gld_pd_immunos_revs` (
  `protocol_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `gld_pd_immunos`
  ADD KEY `FK_gld_pd_immunos_protocol_masters` (`protocol_master_id`),
  ADD CONSTRAINT `FK_gld_pd_immunos_protocol_masters` FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);
ALTER TABLE `gld_pd_immunos_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
CREATE TABLE `gld_pd_hormonos` (
  `protocol_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `gld_pd_hormonos_revs` (
  `protocol_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `gld_pd_hormonos`
  ADD KEY `FK_gld_pd_hormonos_protocol_masters` (`protocol_master_id`),
  ADD CONSTRAINT `FK_gld_pd_hormonos_protocol_masters` FOREIGN KEY (`protocol_master_id`) REFERENCES `protocol_masters` (`id`);
ALTER TABLE `gld_pd_hormonos_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
INSERT INTO structures(`alias`) VALUES ('gld_pd_hormonos');
INSERT INTO structures(`alias`) VALUES ('gld_pd_immunos');

INSERT INTO `treatment_extend_controls` (`id`, `detail_tablename`, `detail_form_alias`, `flag_active`, `type`, `databrowser_label`) VALUES
(null, 'gld_txe_hormonos', 'gld_txe_hormonos', 1, 'hormonotherapy drug', 'hormonotherapy drug'),
(null, 'gld_txe_immunos', 'gld_txe_immunos', 1, 'immunotherapy drug', 'immunotherapy drug');
CREATE TABLE gld_txe_hormonos (
  dose varchar(50) DEFAULT NULL,
  method varchar(50) DEFAULT NULL,
  treatment_extend_master_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE gld_txe_hormonos
  ADD KEY FK_gld_txe_hormonos_treatment_extend_masters (treatment_extend_master_id),
  ADD CONSTRAINT FK_gld_txe_hormonos_treatment_extend_masters FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id);
CREATE TABLE gld_txe_hormonos_revs (
  dose varchar(50) DEFAULT NULL,
  method varchar(50) DEFAULT NULL,
  version_id int(11) NOT NULL,
  version_created datetime NOT NULL,
  treatment_extend_master_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE gld_txe_hormonos_revs
  ADD PRIMARY KEY (version_id),
  MODIFY version_id int(11) NOT NULL AUTO_INCREMENT;
CREATE TABLE gld_txe_immunos (
  dose varchar(50) DEFAULT NULL,
  method varchar(50) DEFAULT NULL,
  treatment_extend_master_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE gld_txe_immunos
  ADD KEY FK_gld_txe_immunos_treatment_extend_masters (treatment_extend_master_id),
  ADD CONSTRAINT FK_gld_txe_immunos_treatment_extend_masters FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id);
CREATE TABLE gld_txe_immunos_revs (
  dose varchar(50) DEFAULT NULL,
  method varchar(50) DEFAULT NULL,
  version_id int(11) NOT NULL,
  version_created datetime NOT NULL,
  treatment_extend_master_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE gld_txe_immunos_revs
  ADD PRIMARY KEY (version_id),
  MODIFY version_id int(11) NOT NULL AUTO_INCREMENT;
INSERT INTO structures(`alias`) VALUES ('gld_txe_hormonos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'gld_txe_hormonos', 'dose', 'input',  NULL , '0', 'size=10', '', 'help_dose', 'dose', ''), 
('ClinicalAnnotation', 'TreatmentExtendDetail', 'gld_txe_hormonos', 'method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') , '0', '', '', 'help_method', 'method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='gld_txe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_treatment_drug_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Drug/Drugs/autocompleteDrug' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_txe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='generic_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', 'drugs', '0', '1', 'drug', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_txe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='gld_txe_hormonos' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_dose' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_txe_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='gld_txe_hormonos' AND `field`='method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_method' AND `language_label`='method' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');
INSERT INTO structures(`alias`) VALUES ('gld_txe_immunos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'gld_txe_immunos', 'dose', 'input',  NULL , '0', 'size=10', '', 'help_dose', 'dose', ''), 
('ClinicalAnnotation', 'TreatmentExtendDetail', 'gld_txe_immunos', 'method', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method') , '0', '', '', 'help_method', 'method', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='gld_txe_immunos'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_treatment_drug_id' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='url=/Drug/Drugs/autocompleteDrug' AND `default`='' AND `language_help`='' AND `language_label`='drug' AND `language_tag`=''), '1', '1', 'drugs', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_txe_immunos'), (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='generic_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '1', 'drugs', '0', '1', 'drug', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_txe_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='gld_txe_immunos' AND `field`='dose' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='help_dose' AND `language_label`='dose' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_txe_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='gld_txe_immunos' AND `field`='method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chemotherapy_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_method' AND `language_label`='method' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '0', '1', '0');

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'hormonotherapy', '', 1, 'gld_txd_hormonos', 'gld_txd_hormonos', 0, (SELECT id FROM protocol_controls WHERE type = 'hormonotherapy'), 'importDrugFromChemoProtocol', 'hormonotherapy', 0, (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'gld_txe_hormonos'), 0, 1),
(null, 'immunotherapy', '', 1, 'gld_txd_immunos', 'gld_txd_immunos', 0, (SELECT id FROM protocol_controls WHERE type = 'immunotherapy'), 'importDrugFromChemoProtocol', 'immunotherapy', 0, (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'gld_txe_immunos'), 0, 1);
CREATE TABLE gld_txd_hormonos (
  completed varchar(50) DEFAULT NULL,
  response varchar(50) DEFAULT NULL,
  num_cycles int(11) DEFAULT NULL,
  length_cycles int(11) DEFAULT NULL,
  completed_cycles int(11) DEFAULT NULL,
  treatment_master_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE gld_txd_hormonos
  ADD KEY tx_master_id (treatment_master_id),
  ADD CONSTRAINT gld_txd_hormonos_ibfk_1 FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters (id);
CREATE TABLE gld_txd_hormonos_revs (
  completed varchar(50) DEFAULT NULL,
  response varchar(50) DEFAULT NULL,
  num_cycles int(11) DEFAULT NULL,
  length_cycles int(11) DEFAULT NULL,
  completed_cycles int(11) DEFAULT NULL,
  treatment_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL,
  version_created datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE gld_txd_hormonos_revs
  ADD PRIMARY KEY (version_id),
  MODIFY version_id int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
CREATE TABLE gld_txd_immunos (
  completed varchar(50) DEFAULT NULL,
  response varchar(50) DEFAULT NULL,
  num_cycles int(11) DEFAULT NULL,
  length_cycles int(11) DEFAULT NULL,
  completed_cycles int(11) DEFAULT NULL,
  treatment_master_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE gld_txd_immunos
  ADD KEY tx_master_id (treatment_master_id),
  ADD CONSTRAINT gld_txd_immunos_ibfk_1 FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters (id);
CREATE TABLE gld_txd_immunos_revs (
  completed varchar(50) DEFAULT NULL,
  response varchar(50) DEFAULT NULL,
  num_cycles int(11) DEFAULT NULL,
  length_cycles int(11) DEFAULT NULL,
  completed_cycles int(11) DEFAULT NULL,
  treatment_master_id int(11) NOT NULL,
  version_id int(11) NOT NULL,
  version_created datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE gld_txd_immunos_revs
  ADD PRIMARY KEY (version_id),
  MODIFY version_id int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
INSERT INTO structures(`alias`) VALUES ('gld_txd_hormonos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'gld_txd_hormonos', 'completed', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'completed', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'gld_txd_hormonos', 'response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='response') , '0', '', '', '', 'response', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='gld_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_intent' AND `language_label`='intent' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='facility' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='facility')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_facility' AND `language_label`='treatment facility' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_protocol_name' AND `language_label`='protocol' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='gld_txd_hormonos' AND `field`='completed' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='completed' AND `language_tag`=''), '2', '11', 'chemotherapy specific', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_hormonos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='gld_txd_hormonos' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='response' AND `language_tag`=''), '2', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structures(`alias`) VALUES ('gld_txd_immunos');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'gld_txd_immunos', 'completed', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='yesno') , '0', '', '', '', 'completed', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'gld_txd_immunos', 'response', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='response') , '0', '', '', '', 'response', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='gld_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_intent' AND `language_label`='intent' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='facility' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='facility')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_facility' AND `language_label`='treatment facility' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='protocol_master_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='protocol_site_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_protocol_name' AND `language_label`='protocol' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='gld_txd_immunos' AND `field`='completed' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='yesno')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='completed' AND `language_tag`=''), '2', '11', 'chemotherapy specific', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='gld_txd_immunos'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='gld_txd_immunos' AND `field`='response' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='response')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='response' AND `language_tag`=''), '2', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('immunotherapy drug', 'Immunotherapy - Drug', 'Immunothérapie - Médicament'),
('hormonotherapy drug', 'Hormonotherapy - Drug', 'Hormonothérapie - Médicament'),
('hormonotherapy', 'Hormonotherapy', 'Hormonothérapie');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Inventory Management
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN('141', '102', '194', '193', '131', '130', '101', '144', '137', '142', '10', '3', '132', '25', '143', '203');
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN('152', '187', '221', '222', '235', '224', '225', '216', '228', '218', '227', '217', '166', '165');
UPDATE realiquoting_controls SET flag_active=true WHERE id IN('48');
UPDATE parent_to_derivative_sample_controls SET flag_active=true WHERE id IN('193');
UPDATE aliquot_controls SET flag_active=false WHERE id IN('11');
UPDATE realiquoting_controls SET flag_active=false WHERE id IN('12');

-- Collection
-- ...................................................................................................................................

-- Protocol

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='collection' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');
 
-- Pre/post & Acquisition label

ALTER TABLE collections
  ADD COLUMN gld_pre_post_surgery varchar(4) DEFAULT NULL,
  ADD COLUMN gld_pre_post_chemo varchar(4) DEFAULT NULL,
  ADD COLUMN gld_pre_post_radio varchar(4) DEFAULT NULL,
  ADD COLUMN gld_pre_post_immuno varchar(4) DEFAULT NULL;
ALTER TABLE collections_revs
  ADD COLUMN gld_pre_post_surgery varchar(4) DEFAULT NULL,
  ADD COLUMN gld_pre_post_chemo varchar(4) DEFAULT NULL,
  ADD COLUMN gld_pre_post_radio varchar(4) DEFAULT NULL,
  ADD COLUMN gld_pre_post_immuno varchar(4) DEFAULT NULL;

INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("gld_pre_post_tx", "open", "", NULL);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="gld_pre_post_tx"), (SELECT id FROM structure_permissible_values WHERE value="pre" AND language_alias="pre"), "1", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="gld_pre_post_tx"), (SELECT id FROM structure_permissible_values WHERE value="post" AND language_alias="post"), "2", "1");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'Collection', 'collections', 'gld_pre_post_surgery', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx') , '0', '', '', '', 'surgery', ''), 
('InventoryManagement', 'Collection', 'collections', 'gld_pre_post_chemo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx') , '0', '', '', '', 'chemotherapy', ''), 
('InventoryManagement', 'Collection', 'collections', 'gld_pre_post_radio', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx') , '0', '', '', '', 'radiotherapy', ''), 
('InventoryManagement', 'Collection', 'collections', 'gld_pre_post_immuno', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx') , '0', '', '', '', 'immunotherapy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='gld_pre_post_surgery' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surgery' AND `language_tag`=''), '1', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='gld_pre_post_chemo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='chemotherapy' AND `language_tag`=''), '1', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='gld_pre_post_radio' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiotherapy' AND `language_tag`=''), '1', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='linked_collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='gld_pre_post_immuno' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='immunotherapy' AND `language_tag`=''), '1', '43', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='treatment history' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='gld_pre_post_surgery' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx') AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('treatment history', 'Treatment History', 'Historique des traitements'),
('immunotherapy', 'Immunotherapy', 'Immunothérapie'),
('radiotherapy', 'Radiotherapy', 'Radiothérapie');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewCollection', '', 'gld_pre_post_surgery', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx') , '0', '', '', '', 'surgery', ''), 
('InventoryManagement', 'ViewCollection', '', 'gld_pre_post_chemo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx') , '0', '', '', '', 'chemotherapy', ''), 
('InventoryManagement', 'ViewCollection', '', 'gld_pre_post_radio', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx') , '0', '', '', '', 'radiotherapy', ''), 
('InventoryManagement', 'ViewCollection', '', 'gld_pre_post_immuno', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx') , '0', '', '', '', 'immunotherapy', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `field`='gld_pre_post_surgery' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surgery' AND `language_tag`=''), '2', '40', 'treatment history', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `field`='gld_pre_post_chemo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='chemotherapy' AND `language_tag`=''), '2', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `field`='gld_pre_post_radio' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiotherapy' AND `language_tag`=''), '2', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='view_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `field`='gld_pre_post_immuno' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='immunotherapy' AND `language_tag`=''), '2', '43', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_column`='2', `display_order`='60' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_detail`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2', `display_order`='60' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='view_collections' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='gld_pre_post_surgery' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surgery' AND `language_tag`=''), '1', '40', 'treatment history', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='gld_pre_post_chemo' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='chemotherapy' AND `language_tag`=''), '1', '41', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='gld_pre_post_radio' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='radiotherapy' AND `language_tag`=''), '1', '42', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='collections'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='gld_pre_post_immuno' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='gld_pre_post_tx')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='immunotherapy' AND `language_tag`=''), '1', '43', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='collection' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- collection bank

UPDATE structure_formats SET `flag_override_default`='1', `default`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_default`='1', `default`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

-- Specimen Collection Sites

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Specimen Collection Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('chu gld', 'CHU - GLD',  'CHU - GLD', '1', @control_id, @modified, @modified, @modified_by, @modified_by);

UPDATE structure_formats SET `flag_override_default`='1', `default`='chu gld' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site');
UPDATE structure_formats SET `flag_override_default`='1', `default`='chu gld' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site');

-- Sample
-- ...................................................................................................................................

-- Acquisition label

UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Blood

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Blood Tube Types', 1, 30, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Blood Tube Types');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("EDTA", "EDTA", "EDTA", "2", "1", @control_id, @modified, @modified, @modified_by, @modified_by), 
("heparin", "Heparin", "Héparine", "2", "1", @control_id, @modified, @modified, @modified_by, @modified_by), 
("paxgene", "Paxgene", "Paxgene", "2", "1", @control_id, @modified, @modified, @modified_by, @modified_by), 
("unknown", "Unknown", "Inconnu", "1", "1", @control_id, @modified, @modified, @modified_by, @modified_by);
UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 4, values_counter = 4 WHERE name = 'Blood Tube Types';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Blood Tube Types\')' WHERE domain_name = 'blood_type';
SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'blood_type');
UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type'), 'notBlank', '');

-- Tissue

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Tissues Sources', 1, 50, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissues Sources');
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("lung", "Lung", "Poumon", "2", "1", @control_id, @modified, @modified, @modified_by, @modified_by);
UPDATE structure_permissible_values_custom_controls 
SET values_max_length = 50, values_used_as_input_counter = 1, values_counter = 1 WHERE name = 'Tissues Sources';
UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown(\'Tissues Sources\')" WHERE domain_name = 'tissue_source_list';

-- Aliquot
-- ...................................................................................................................................

-- Acquisition label

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Study

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='autocomplete_aliquot_master_study_summary_id' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='study_summary_title' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE (id1 = 1 AND id2 =25) OR (id1 = 25 AND id2 =1);

-- Lot Number

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_detail`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `field`='lot_number');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Tools
-- -----------------------------------------------------------------------------------------------------------------------------------

-- SOP
-- ...................................................................................................................................

UPDATE menus 
SET flag_active = 0 
WHERE use_link LIKE '/Sop/%';

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='sop_master_id');

-- Storage
-- ...................................................................................................................................

UPDATE storage_controls
SET flag_active = 0
WHERE storage_type NOt IN ('room', 'nitrogen locator', 'fridge', 'freezer', 'box', 'box81 1A-9I', 'box81', 'rack16', 'rack10 ', 'rack24', 'shelf', 'rack11', 'rack9');


