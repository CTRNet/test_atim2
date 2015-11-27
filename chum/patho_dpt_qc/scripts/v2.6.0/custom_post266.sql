REPLACE INTO i18n (id,en,fr) VALUES ('core_installname','CHUM - Patho','CHUM - Patho');

UPDATE users SET flag_active = 0;
UPDATE users SET flag_active = 1, username = 'NicoEn', first_name = 'Nico', password = 'ddeaa159a89375256a02d1cfbd9a1946ad01a979' WHERE id = 1;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Remove Any Unused Menus
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/Order/%';
UPDATE menus  SET flag_active = 0 WHERE use_link LIKE '/Drug/%';
UPDATE menus  SET flag_active = 0 WHERE use_link LIKE '/Sop/%';
UPDATE menus  SET flag_active = 0 WHERE use_link LIKE '/Protocol/%';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Clinical Annotation
-- ----------------------------------------------------------------------------------------------------------------------------------------

-- Participants

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='title' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='person title') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_birth' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_confirmation_source' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='marital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='marital_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_batchedit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');


ALTER TABLE participants 
  ADD COLUMN chum_hepato_ramq VARCHAR(50),
  ADD COLUMN chum_hepato_hd_hospital_number VARCHAR(50),
  ADD COLUMN chum_hepato_nd_hospital_number VARCHAR(50),
  ADD COLUMN chum_hepato_sl_hospital_number VARCHAR(50);
ALTER TABLE participants_revs 
  ADD COLUMN chum_hepato_ramq VARCHAR(50),
  ADD COLUMN chum_hepato_hd_hospital_number VARCHAR(50),
  ADD COLUMN chum_hepato_nd_hospital_number VARCHAR(50),
  ADD COLUMN chum_hepato_sl_hospital_number VARCHAR(50);
  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'chum_hepato_ramq', 'input',  NULL , '1', 'size=30', '', '', 'ramq', ''),
('ClinicalAnnotation', 'Participant', 'participants', 'chum_hepato_hd_hospital_number', 'input',  NULL , '1', 'size=30', '', '', 'hd hospital number', ''),
('ClinicalAnnotation', 'Participant', 'participants', 'chum_hepato_nd_hospital_number', 'input',  NULL , '1', 'size=30', '', '', 'nd hospital number', ''),
('ClinicalAnnotation', 'Participant', 'participants', 'chum_hepato_sl_hospital_number', 'input',  NULL , '1', 'size=30', '', '', 'sl hospital number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'),
 (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_hepato_ramq'), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='participants'),
 (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_hepato_hd_hospital_number'), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='participants'),
 (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_hepato_nd_hospital_number'), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='participants'),
 (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_hepato_sl_hospital_number'), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_validations (structure_field_id,rule )
VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_hepato_ramq'), 'isUnique'),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_hepato_hd_hospital_number'), 'isUnique'),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_hepato_nd_hospital_number'), 'isUnique'),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_hepato_sl_hospital_number'), 'isUnique');
INSERT INTO i18n (id,en,fr)
VALUES
('ramq', 'RAMQ', 'RAMQ'),
('hd hospital number', 'H.D.#', 'H.D.#'),
('nd hospital number', 'N.D.#', 'N.D.#'),
('sl hospital number', 'S.L.#', 'S.L.#');
REPLACE INTO i18n (id,en,fr)
VALUES
('participant identifier', 'Participant Code (Syst.)', 'Code Participant (syst.)');
UPDATE structure_formats SET `display_column`='3', `display_order`='99', `language_heading`='system data', `flag_add`='0', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
















http://localhost/bc_ovcare//Drugs/search/


























-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '63xx' WHERE version_number = '2.6.6';