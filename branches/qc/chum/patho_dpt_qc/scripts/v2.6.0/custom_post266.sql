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
  ADD COLUMN chum_patho_ramq VARCHAR(50),
  ADD COLUMN chum_patho_hd_hospital_number VARCHAR(50),
  ADD COLUMN chum_patho_nd_hospital_number VARCHAR(50),
  ADD COLUMN chum_patho_sl_hospital_number VARCHAR(50);
ALTER TABLE participants_revs 
  ADD COLUMN chum_patho_ramq VARCHAR(50),
  ADD COLUMN chum_patho_hd_hospital_number VARCHAR(50),
  ADD COLUMN chum_patho_nd_hospital_number VARCHAR(50),
  ADD COLUMN chum_patho_sl_hospital_number VARCHAR(50);
  
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'chum_patho_ramq', 'input',  NULL , '1', 'size=30', '', '', 'ramq', ''),
('ClinicalAnnotation', 'Participant', 'participants', 'chum_patho_hd_hospital_number', 'input',  NULL , '1', 'size=30', '', '', 'hd hospital number', ''),
('ClinicalAnnotation', 'Participant', 'participants', 'chum_patho_nd_hospital_number', 'input',  NULL , '1', 'size=30', '', '', 'nd hospital number', ''),
('ClinicalAnnotation', 'Participant', 'participants', 'chum_patho_sl_hospital_number', 'input',  NULL , '1', 'size=30', '', '', 'sl hospital number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'),
 (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_patho_ramq'), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='participants'),
 (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_patho_hd_hospital_number'), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='participants'),
 (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_patho_nd_hospital_number'), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='participants'),
 (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_patho_sl_hospital_number'), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
INSERT INTO structure_validations (structure_field_id,rule )
VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_patho_ramq'), 'isUnique'),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_patho_hd_hospital_number'), 'isUnique'),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_patho_nd_hospital_number'), 'isUnique'),
((SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='chum_patho_sl_hospital_number'), 'isUnique');
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

-- Consent 

UPDATE consent_controls SET flag_active = 0;
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ConsentMasters/%';

-- Diagnosis ???


UPDATE diagnosis_controls SET flag_active = 0;
INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'diagnosis', 1, 'chum_patho_diagnosis', 'dxd_tissues', 0, 'diagnosis', 1);
INSERT INTO structures(`alias`) VALUES ('chum_patho_diagnosis');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_patho_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='help_primary code' AND `language_label`='disease code' AND `language_tag`=''), '2', '1', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/topo,tool=/CodingIcd/CodingIcdo3s/tool/topo' AND `default`='' AND `language_help`='help_topography' AND `language_label`='topography' AND `language_tag`=''), '2', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='morphology' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/morpho,tool=/CodingIcd/CodingIcdo3s/tool/morpho' AND `default`='' AND `language_help`='help_morphology' AND `language_label`='morphology' AND `language_tag`=''), '2', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

-- Event 

UPDATE event_controls SET flag_active = 0;
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/%';

-- Treatment 

UPDATE treatment_controls SET flag_active = 0;
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters/%';

-- Other

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts/%';

-- Clinical Collection Link

UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='consent_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='consent_signed_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='tx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_method_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentControl' AND `tablename`='treatment_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tx_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='event_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_tag`='0', `language_tag`='', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventControl' AND `tablename`='event_controls' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='event_disease_site_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Identifiers

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers/search%';

-- ParticipantMessages

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/ParticipantMessages%';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Inventory
-- ----------------------------------------------------------------------------------------------------------------------------------------

-- Collection

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_add_readonly`='0', `flag_edit`='0', `flag_edit_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='linked_collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');
REPLACE i18n (id,en,fr) VALUEs ('acquisition_label','Patho. #', 'Patho. #');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_collection_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='collections') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

-- Inventory Configuration

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(1, 12, 19, 131, 133, 135, 134, 23, 136, 20, 21, 193, 196, 197, 198, 199, 200, 13, 14, 2, 25, 3, 119, 15, 16, 24, 4, 132, 17, 18, 5, 118, 6, 190, 189, 105, 112, 113, 114, 106, 120, 124, 125, 126, 121, 103, 109, 110, 111, 104, 122, 127, 128, 129, 123, 191, 7, 130, 8, 9, 101, 102, 194, 11, 10);
UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(137, 138, 203, 188, 142, 143, 141, 144, 192, 140);
UPDATE aliquot_controls SET flag_active=false WHERE id IN(10, 1);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(11, 46, 1);

-- Tissue

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='supplier_dept' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_specimen_supplier_dept') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='specimen_details' AND `field`='time_at_room_temp_mn' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='pathology_reception_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_size_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_size_unit') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_addgrid`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='tissue_weight_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_weight_unit') AND `flag_confidential`='0');

UPDATE structure_value_domains SET source = "StructurePermissibleValuesCustom::getCustomDropdown('Tissue Sources')" WHERE domain_name = 'tissue_source_list';
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Tissue Sources', 1, 50, 'inventory');

UPDATE structure_fields SET  `setting`='size=20,class=file' WHERE model='ViewCollection' AND tablename='' AND field='acquisition_label' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewSample', '', 'tissue_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') , '0', '', '', '', 'tissue source', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_sample_joined_to_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='tissue_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue source' AND `language_tag`=''), '0', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');

-- Block

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_edit_readonly`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view'), (SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='sd_spe_tissues' AND `field`='tissue_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue source' AND `language_tag`=''), '0', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleDetail' AND `tablename`='' AND `field`='blood_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='blood_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='sample_masters_for_collection_tree_view') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='derivative_details' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1', `display_order`='1200', `language_heading`='system data', `flag_add`='0', `flag_addgrid`='0', `flag_editgrid_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='0', `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `setting`='size=10' WHERE model='AliquotDetail' AND tablename='' AND field='patho_dpt_block_code' AND `type`='input' AND structure_value_domain  IS NULL ;
REPLACE INTO i18n (id,en,fr) 
VALUES 
('pathology department block code','Block #','# Bloc');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `field`='patho_dpt_block_code'), 'notEmpty', '');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='block_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='block_type') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='1200', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='parent_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='parent_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='temperature' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='temp_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code') AND `flag_confidential`='0');

UPDATE structure_fields SET language_label = 'aliquot system barcode' WHERE language_label = 'barcode' AND model LIKE '%Aliquot%';

INSERT INTO i18n (id,en,fr) VALUES ('aliquot system barcode','Aliquot Code (Syst.)','Code Aliquot (Syst.)');

UPDATE structure_formats SET `display_order`='-1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='rec_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='view_aliquots' AND `field`='coll_to_stor_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='parent_sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='parent_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='parent_sample_type_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='initial_specimen_sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type_from_id') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_edit`='0', `flag_edit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_category' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_sample_joined_to_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='' AND `field`='sample_control_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type_from_id') AND `flag_confidential`='0');

ALTER TABLE ad_blocks 
  ADD COLUMN chum_patho_sould_out_date date DEFAULT NULL,
  ADD COLUMN chum_patho_sould_out_date_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN chum_patho_picture_path varchar(500) DEFAULT NULL;  
ALTER TABLE ad_blocks_revs 
  ADD COLUMN chum_patho_sould_out_date date DEFAULT NULL,
  ADD COLUMN chum_patho_sould_out_date_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN chum_patho_picture_path varchar(500) DEFAULT NULL;
ALTER TABLE ad_blocks 
  ADD COLUMN chum_patho_default_category varchar(250) DEFAULT NULL;  
ALTER TABLE ad_blocks_revs 
  ADD COLUMN chum_patho_default_category varchar(250) DEFAULT NULL;
    
INSERT INTO structure_value_domains (domain_name, source) VALUES ('chum_patho_tissue_category', "StructurePermissibleValuesCustom::getCustomDropdown('Tissue Categories')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Tissue Categories', 1, 250, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Tissue Categories');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('normal', 'Normal',  'Normal', '1', @control_id, NOW(), NOW(), 1, 1),
('Ctrl+', '',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('Ctrl-', '',  '', '1', @control_id, NOW(), NOW(), 1, 1),
('reserve', 'Reserve',  'Réserve', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', '', 'chum_patho_default_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_tissue_category') , '0', '', '', '', 'main category', ''), 
('InventoryManagement', 'AliquotDetail', '', 'chum_patho_sould_out_date', 'date',  NULL , '0', '', '', '', 'sould out', ''), 
('InventoryManagement', 'AliquotDetail', '', 'chum_patho_picture_path', 'input',  NULL , '0', '', '', '', 'picture', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='chum_patho_default_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_tissue_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='main category' AND `language_tag`=''), '1', '70', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='chum_patho_sould_out_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sould out' AND `language_tag`=''), '1', '71', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='chum_patho_picture_path' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='picture' AND `language_tag`=''), '1', '72', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) 
VALUES
('main category', 'Main Category', 'Principale catégorie'),
('sould out', 'Sould Out', 'Épuisé');
  
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='8' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1', `display_order`='59' WHERE structure_id=(SELECT id FROM structures WHERE alias='ad_spec_tiss_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='patho_dpt_block_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_edit`='1', `flag_edit_readonly`='1', `flag_search`='1', `flag_editgrid`='1', `flag_editgrid_readonly`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `tablename`='ad_blocks' WHERE model='AliquotDetail' AND tablename='' AND field='chum_patho_sould_out_date' AND `type`='date' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `flag_addgrid`='0', `flag_editgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquot_without_vol') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoted_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `tablename`='aliquot_controls' AND `field`='aliquot_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_batchedit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='used_aliq_in_stock_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock_detail' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_detail') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_edit`='0', `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='realiquoted_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='sample_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `flag_confidential`='0');

UPDATE structure_fields SET  `setting`='size=70' WHERE model='AliquotDetail' AND tablename='' AND field='chum_patho_picture_path' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE structure_fields SET  `setting`='size=20,class=file' WHERE model='ViewAliquot' AND tablename='' AND field='acquisition_label' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_setting`='1', `setting`='class=file' WHERE structure_id=(SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='aliquot_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Core

ALTER TABLE ad_tissue_cores 
  ADD COLUMN chum_patho_category varchar(250) DEFAULT NULL;  
ALTER TABLE ad_tissue_cores_revs 
  ADD COLUMN chum_patho_category varchar(250) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', '', 'chum_patho_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_tissue_category') , '0', '', '', '', 'category', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='ad_spec_tiss_cores'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='' AND `field`='chum_patho_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_tissue_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='category' AND `language_tag`=''), '1', '70', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '1', '0');

-- Aliquot View

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'ViewAliquot', '', 'tissue_source', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list') , '0', '', '', '', 'tissue source', ''), 
('InventoryManagement', 'ViewAliquot', '', 'chum_patho_category', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_tissue_category') , '0', '', '', '', 'category', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='tissue_source' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tissue_source_list')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tissue source' AND `language_tag`=''), '0', '10', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0'), 
((SELECT id FROM structures WHERE alias='view_aliquot_joined_to_sample_and_collection'), (SELECT id FROM structure_fields WHERE `model`='ViewAliquot' AND `tablename`='' AND `field`='chum_patho_category' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_tissue_category')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='category' AND `language_tag`=''), '0', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '1', '0');

-- Path Review

UPDATE aliquot_review_controls SET flag_active = 0;
UPDATE specimen_review_controls SET flag_active = 0;
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/SpecimenReviews%';

-- Qualit Controls

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/QualityCtrls%';

-- Derivatives

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/InventoryManagement/SampleMasters/listAllDerivatives%';

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- TMA & SLIDE
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE storage_controls SET flag_active = 0 WHERE storage_type NOT IN ('room','nitrogen locator','fridge','freezer','box','shelf','TMA-blc 23X15','TMA-blc 29X21');

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, 
`display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) 
VALUES
(null, 'cassettes box', 'position', 'integer', 8, NULL, NULL, NULL, 
4, 2, 0, 0, 1, 0, 0, 1, '', 'std_boxs', 'custom#storage types#cassettes box', 1),
(null, 'cassettes drawer', 'position', 'integer', 2, NULL, NULL, NULL, 
2, 1, 0, 0, 1, 0, 0, 1, '', 'std_boxs', 'custom#storage types#cassettes drawer', 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('cassettes box', 'Cassettes Box',  'Boîtes de cassettes', '1', @control_id, NOW(), NOW(), 1, 1),
('cassettes drawer', 'Cassettes Drawer',  'Tiroir de cassettes', '1', @control_id, NOW(), NOW(), 1, 1);

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, 
`display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'MTB-blc 23X15', 'column', 'integer', 23, 'row', 'integer', 15, 
0, 0, 0, 0, 0, 0, 1, 1, 'std_tma_blocks', 'std_tma_blocks', 'custom#storage types#MTB-blc 23X15', 1),
(null, 'MTB-blc 11X7', 'column', 'integer', 11, 'row', 'integer', 7, 
0, 0, 0, 0, 0, 0, 1, 1, 'std_tma_blocks', 'std_tma_blocks', 'custom#storage types#MTB-blc 11X7', 1);
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('MTB-blc 11X7', 'MTB-block 11X7',  'MTB-bloc 11X7', '1', @control_id, NOW(), NOW(), 1, 1),
('MTB-blc 23X15', 'MTB-block 23X15',  'MTB-bloc 23X15', '1', @control_id, NOW(), NOW(), 1, 1);

ALTER TABLE std_tma_blocks
  ADD COLUMN chum_patho_creation_date date DEFAULT NULL,
  ADD COLUMN chum_patho_creation_date_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN chum_patho_sould_out_date date DEFAULT NULL,
  ADD COLUMN chum_patho_sould_out_date_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN chum_patho_picture_path varchar(500) DEFAULT NULL,
  ADD COLUMN chum_patho_creation_to_sould_out_months INT(5) DEFAULT NULL;
ALTER TABLE std_tma_blocks_revs
  ADD COLUMN chum_patho_creation_date date DEFAULT NULL,
  ADD COLUMN chum_patho_creation_date_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN chum_patho_sould_out_date date DEFAULT NULL,
  ADD COLUMN chum_patho_sould_out_date_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN chum_patho_picture_path varchar(500) DEFAULT NULL,
  ADD COLUMN chum_patho_creation_to_sould_out_months INT(5) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'StorageDetail', 'std_tma_blocks', 'chum_patho_creation_date', 'date',  NULL , '0', '', '', '', 'creation date', ''), 
('StorageLayout', 'StorageDetail', 'std_tma_blocks', 'chum_patho_sould_out_date', 'date',  NULL , '0', '', '', '', 'sould out', ''), 
('StorageLayout', 'StorageDetail', 'std_tma_blocks', 'chum_patho_creation_to_sould_out_months', 'date',  NULL , '0', '', '', '', 'use (in months)', ''), 
('StorageLayout', 'StorageDetail', 'std_tma_blocks', 'chum_patho_picture_path', 'input',  NULL , '0', 'size=70', '', '', 'picture', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='std_tma_blocks'), (SELECT id FROM structure_fields WHERE `model`='StorageDetail' AND `tablename`='std_tma_blocks' AND `field`='chum_patho_creation_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='creation date' AND `language_tag`=''), '1', '28', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='std_tma_blocks'), (SELECT id FROM structure_fields WHERE `model`='StorageDetail' AND `tablename`='std_tma_blocks' AND `field`='chum_patho_sould_out_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sould out' AND `language_tag`=''), '1', '29', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='std_tma_blocks'), (SELECT id FROM structure_fields WHERE `model`='StorageDetail' AND `tablename`='std_tma_blocks' AND `field`='chum_patho_creation_to_sould_out_months' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='use (in months)' AND `language_tag`=''), '1', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='std_tma_blocks'), (SELECT id FROM structure_fields WHERE `model`='StorageDetail' AND `tablename`='std_tma_blocks' AND `field`='chum_patho_picture_path' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=70' AND `default`='' AND `language_help`='' AND `language_label`='picture' AND `language_tag`=''), '1', '31', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageDetail' AND `tablename`='std_tma_blocks' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageDetail' AND `tablename`='tma_slides' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `type`='integer',  `setting`='size=3' WHERE model='StorageDetail' AND tablename='std_tma_blocks' AND field='chum_patho_creation_to_sould_out_months' AND `type`='date' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='std_tma_blocks') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageDetail' AND `tablename`='std_tma_blocks' AND `field`='chum_patho_creation_to_sould_out_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en,fr) VALUES ('use (in months)','Use (Months)','Utilisation (mois)');

-- Slide

REPLACE INTO i18n (id,en,fr) 
VALUES
('tma block', 'TMA/MTB Block', 'Bloc TMA/MTB'),
('tma slide', 'TMA/MTB Slide', 'Lame TMA/MTB'),
('tma slides', 'TMA/MTB Slides', 'Lames TMA/MTB'),
('tma slides creation','TMA/MTB Slide Creation','Création de lames de TMA/MTB');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='sop_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='tma_slide_sop_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='immunochemistry' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='study_summary_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='study_list') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='storage' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='recorded_storage_selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='storage' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET `language_label`='antibody' WHERE model='TmaSlide' AND tablename='tma_slides' AND field='study_summary_id' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='study_list');
ALTER TABLE tma_slides
  ADD COLUMN chum_patho_utilisations varchar(250) DEFAULT NULL;
ALTER TABLE tma_slides_revs
  ADD COLUMN chum_patho_utilisations varchar(250) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) VALUES ('chum_hepato_tma_slide_utilisation', "StructurePermissibleValuesCustom::getCustomDropdown('TMA/MTB Slide Utilisations')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('TMA/MTB Slide Utilisations', 1, 250, 'storages');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'TMA/MTB Slide Utilisations');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('validation-optimization', 'Validation-Optimization',  'Validation-Optimisation', '1', @control_id, NOW(), NOW(), 1, 1),
('validation-sensitivity', 'Validation-Sensitivity',  'Validation-Sensibilité', '1', @control_id, NOW(), NOW(), 1, 1),
('quality assurance', 'Quality Assurance',  'Assurance qualité', '1', @control_id, NOW(), NOW(), 1, 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('StorageLayout', 'TmaSlide', 'tma_slides', 'chum_patho_utilisations', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_hepato_tma_slide_utilisation') , '0', '', '', '', '', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='tma_slides'), (SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='chum_patho_utilisations' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_hepato_tma_slide_utilisation')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='chum_hepato_tma_slide_utilisation') ,  `language_label`='use' WHERE model='TmaSlide' AND tablename='tma_slides' AND field='chum_patho_utilisations' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='chum_hepato_tma_slide_utilisation');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE tablename='tma_slides' AND field='study_summary_id'), 'notEmpty', ''),
((SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='chum_patho_utilisations'), 'notEmpty', '');
REPLACE INTO i18n (id,en,fr)
VALUES
('edit tma slides','Edit TMA/MTB Slides','Modified lames TMA/MTB'),
('study/project is assigned to a  tma slide', 
'Your data cannot be deleted! This study/project is linked to a TMA/MTB slide. ',
"Vos données ne peuvent être supprimées! Ce(tte) étude/projet est attaché(e) à un lame de TMA/MTB. "),
('you must create at least one slide for each tma','You must create at least one slide per TMA/MTB block','Vous devez créer au moins une lame par bloc de TMA/MTB'),
('at least one selected item is not a tma block', 'At least one selected item is not a tma block.', 'Au moins un item sélectionné n''est pas un bloc de TMA/MTB'),
('tma slides creation','TMA/MTB Slides Creation','Création de lames de TMA/MTB'),
('create tma slide', 'Create TMA/MTB Slide', 'Créer lame de TMA/MTB'),
('links between storage and tma slides are limited to tma blocks and slides created from these blocks - different than slide storage',
'Links between storage and TMA/MTB slides are limited to TMA/MTB blocks and slides created from these blocks. The databrowser won''t link TMA/MTB slide to the storage containing these slides.',
"Les liens entre les entreposages et les lames de TMA/MTB sont limitès aux blocs de TMA/MTB et aux lames créées à partir de ces blocs. Le 'Navigateur de Données' ne fait pas le lien entre les lames de TMA/MTB et les entreposages contenant les lames.");

UPDATE structure_formats SET `display_column`='1', `flag_override_label`='1', `language_label`='slide #', `display_order`='50', `language_heading`='system data', `flag_add`='0', `flag_addgrid`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='tma_slides') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TmaSlide' AND `tablename`='tma_slides' AND `field`='barcode' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('slide #','Slide #','# Lame');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Study
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_fields SET  `language_label`='antibody' WHERE model='StudySummary' AND tablename='study_summaries' AND field='title' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Identification

ALTER TABLE study_summaries
  ADD COLUMN chum_patho_company varchar(250) DEFAULT NULL,
  ADD COLUMN chum_patho_clone_mono varchar(250) DEFAULT NULL,
  ADD COLUMN chum_patho_clone_poly varchar(250) DEFAULT NULL,
  ADD COLUMN chum_patho_stored_at varchar(250) DEFAULT NULL,
  ADD COLUMN chum_patho_listing varchar(500) DEFAULT NULL;
ALTER TABLE study_summaries_revs
  ADD COLUMN chum_patho_company varchar(250) DEFAULT NULL,
  ADD COLUMN chum_patho_clone_mono varchar(250) DEFAULT NULL,
  ADD COLUMN chum_patho_clone_poly varchar(250) DEFAULT NULL,
  ADD COLUMN chum_patho_stored_at varchar(250) DEFAULT NULL,
  ADD COLUMN chum_patho_listing varchar(500) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('chum_patho_antibody_company', "StructurePermissibleValuesCustom::getCustomDropdown('Antibody : Company Provider')"),
('chum_patho_clone_poly', "StructurePermissibleValuesCustom::getCustomDropdown('Antibody : Clone Poly')"),
('chum_patho_antibody_storage_condition', "StructurePermissibleValuesCustom::getCustomDropdown('Antibody : Storage Condition')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Antibody : Company Provider', 1, 250, 'study / project'),
('Antibody : Clone Poly', 1, 250, 'study / project'),
('Antibody : Storage Condition', 1, 250, 'study / project');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'chum_patho_company', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_antibody_company') , '0', '', '', '', 'company', ''), 
('Study', 'StudySummary', 'study_summaries', 'chum_patho_clone_mono', 'input',  NULL , '0', 'size=20', '', '', 'clone', 'mono'), 
('Study', 'StudySummary', 'study_summaries', 'chum_patho_clone_poly', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_clone_poly') , '0', '', '', '', '', 'poly'), 
('Study', 'StudySummary', 'study_summaries', 'chum_patho_stored_at', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_antibody_storage_condition') , '0', '', '', '', 'stored at', ''), 
('Study', 'StudySummary', 'study_summaries', 'chum_patho_listing', 'input',  NULL , '0', 'size=70', '', '', 'listing', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_company' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_antibody_company')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='company' AND `language_tag`=''), '1', '5', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_clone_mono' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='' AND `language_label`='clone' AND `language_tag`='mono'), '1', '6', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_clone_poly' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_clone_poly')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='poly'), '1', '7', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_stored_at' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_antibody_storage_condition')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='stored at' AND `language_tag`=''), '1', '8', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='studysummaries'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_listing' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=70' AND `default`='' AND `language_help`='' AND `language_label`='listing' AND `language_tag`=''), '1', '9', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES 
('antibody', 'Antibody', 'Anticorps'),
('company', 'Company', 'Compagnie'),
('clone', 'Clone', 'Clone'),
('mono', 'Mono', 'Mono'),
('poly', 'Poly', 'Poly'),
('stored at', 'Stored At', 'Conservé à'),
('listing', 'Listing', 'Fiche signalétique');

-- Quality Control

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`) VALUES
('chum_path_std_1', 'tool_CAN_100', 0, 2, 'quality control', '', '/Study/StudySummaries/stdQcCriteriaDetail/%%StudySummary.id%%/', 'Study.StudySummary::summary', 1, 1);
ALTER TABLE study_summaries
  ADD COLUMN `chum_patho_signal` varchar(50) DEFAULT NULL,
  ADD COLUMN `chum_patho_ctrl_pos` varchar(50) DEFAULT NULL,
  ADD COLUMN `chum_patho_ctrl_neg` varchar(50) DEFAULT NULL,
  ADD COLUMN `chum_patho_pictures` varchar(500) DEFAULT NULL,
  ADD COLUMN `chum_patho_performance_criteria` text,
  ADD COLUMN `chum_patho_non_compliance_indicators` text,
  ADD COLUMN `chum_patho_pathologist` varchar(50) DEFAULT NULL;
ALTER TABLE study_summaries_revs
  ADD COLUMN `chum_patho_signal` varchar(50) DEFAULT NULL,
  ADD COLUMN `chum_patho_ctrl_pos` varchar(50) DEFAULT NULL,
  ADD COLUMN `chum_patho_ctrl_neg` varchar(50) DEFAULT NULL,
  ADD COLUMN `chum_patho_pictures` varchar(500) DEFAULT NULL,
  ADD COLUMN `chum_patho_performance_criteria` text,
  ADD COLUMN `chum_patho_non_compliance_indicators` text,
  ADD COLUMN `chum_patho_pathologist` varchar(50) DEFAULT NULL;
INSERT INTO structures(`alias`) VALUES ('chum_patho_study_quality_controls');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('chum_patho_study_quality_controls_signal', "StructurePermissibleValuesCustom::getCustomDropdown('Antibody : Quality Control Signal')"),
('chum_hepato_pathologist', "StructurePermissibleValuesCustom::getCustomDropdown('Antibody : Pathologist')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Antibody : Quality Control Signal', 1, 50, 'study / project'),
('Antibody : Pathologist', 1, 50, 'study / project');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudySummary', 'study_summaries', 'chum_patho_signal', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_quality_controls_signal') , '0', '', '', '', 'signal', ''), 
('Study', 'StudySummary', 'study_summaries', 'chum_patho_ctrl_pos', 'input',  NULL , '0', 'size=30', '', '', 'ctrl pos', ''), 
('Study', 'StudySummary', 'study_summaries', 'chum_patho_ctrl_neg', 'input',  NULL , '0', 'size=30', '', '', 'ctrl neg', ''), 
('Study', 'StudySummary', 'study_summaries', 'chum_patho_pictures', 'input',  NULL , '0', 'size=70', '', '', 'picture', ''), 
('Study', 'StudySummary', 'study_summaries', 'chum_patho_performance_criteria', 'textarea',  NULL , '0', '', '', '', 'performance criteria', ''), 
('Study', 'StudySummary', 'study_summaries', 'chum_patho_non_compliance_indicators', 'textarea',  NULL , '0', '', '', '', 'non compliance indicators', ''), 
('Study', 'StudySummary', 'study_summaries', 'chum_patho_pathologist', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_hepato_pathologist') , '0', '', '', '', 'pathologist', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_controls'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_signal' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_quality_controls_signal')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='signal' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_controls'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_ctrl_pos' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='ctrl pos' AND `language_tag`=''), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_controls'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_ctrl_neg' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='ctrl neg' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_controls'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_pictures' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=70' AND `default`='' AND `language_help`='' AND `language_label`='picture' AND `language_tag`=''), '1', '13', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_controls'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_performance_criteria' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='performance criteria' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_controls'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_non_compliance_indicators' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='non compliance indicators' AND `language_tag`=''), '2', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_controls'), (SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_pathologist' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_hepato_pathologist')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='pathologist' AND `language_tag`=''), '1', '15', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('quality control criteria','Criteria','Critère'),
('signal','Signal','Signal'),
('ctrl pos','Ctrl+','Ctrl+'),
('ctrl neg','Ctrl-','Ctrl-'),
('performance criteria','Performance Criteria ','Critères de Performance'),
('non compliance indicators','Non Compliance Indicators','Indicateurs de non-conformité');
UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias = 'chum_patho_study_quality_controls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_signal' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_quality_controls_signal') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='chum_patho_study_quality_controls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_performance_criteria' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='chum_patho_study_quality_controls') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='chum_patho_non_compliance_indicators' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Report

CREATE TABLE IF NOT EXISTS `chum_patho_study_quality_control_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `study_summary_id` int(11) DEFAULT NULL,
  `chum_patho_lot` varchar(250) DEFAULT NULL,
  `chum_patho_date_received` date DEFAULT NULL,
  `chum_patho_date_received_accuracy` char(1) NOT NULL DEFAULT '',
  `chum_patho_expiration_date` date DEFAULT NULL,
  `chum_patho_expiration_date_accuracy` char(1) NOT NULL DEFAULT '',
  `chum_patho_validated` char(1) DEFAULT '',
  `chum_patho_validated_date` date DEFAULT NULL,
  `chum_patho_validated_date_accuracy` char(1) NOT NULL DEFAULT '',
  `chum_patho_validated_protocol_number` varchar(250) DEFAULT NULL,
  `chum_patho_test` date DEFAULT NULL,
  `chum_patho_test_accuracy` char(1) NOT NULL DEFAULT '',
  `chum_patho_intensity` varchar(100) DEFAULT NULL,
  `chum_patho_uniformity` varchar(100) DEFAULT NULL,
  `chum_patho_specificity` varchar(100) DEFAULT NULL,
  `chum_patho_background_noise` varchar(100) DEFAULT NULL,
  `chum_patho_counterstain` varchar(100) DEFAULT NULL,
  `chum_patho_conclusion` varchar(50) DEFAULT NULL,
  `chum_patho_techn_resp_comment` text,
  `chum_patho_pathologist_comment` text,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE IF NOT EXISTS `chum_patho_study_quality_control_reports_revs` (
  `id` int(11) NOT NULL,
  `study_summary_id` int(11) DEFAULT NULL,
  `chum_patho_lot` varchar(250) DEFAULT NULL,
  `chum_patho_date_received` date DEFAULT NULL,
  `chum_patho_date_received_accuracy` char(1) NOT NULL DEFAULT '',
  `chum_patho_expiration_date` date DEFAULT NULL,
  `chum_patho_expiration_date_accuracy` char(1) NOT NULL DEFAULT '',
  `chum_patho_validated` char(1) DEFAULT '',
  `chum_patho_validated_date` date DEFAULT NULL,
  `chum_patho_validated_date_accuracy` char(1) NOT NULL DEFAULT '',
  `chum_patho_validated_protocol_number` varchar(250) DEFAULT NULL,
  `chum_patho_test` date DEFAULT NULL,
  `chum_patho_test_accuracy` char(1) NOT NULL DEFAULT '',
  `chum_patho_intensity` varchar(100) DEFAULT NULL,
  `chum_patho_uniformity` varchar(100) DEFAULT NULL,
  `chum_patho_specificity` varchar(100) DEFAULT NULL,
  `chum_patho_background_noise` varchar(100) DEFAULT NULL,
  `chum_patho_counterstain` varchar(100) DEFAULT NULL,
  `chum_patho_conclusion` varchar(50) DEFAULT NULL,
  `chum_patho_techn_resp_comment` text,
  `chum_patho_pathologist_comment` text,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;
ALTER TABLE `chum_patho_study_quality_control_reports`
  ADD CONSTRAINT `FK_chum_patho_study_quality_control_reports_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);

INSERT INTO structures(`alias`) VALUES ('chum_patho_study_quality_control_reports');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('chum_patho_study_qc_ctrl_intensity', "StructurePermissibleValuesCustom::getCustomDropdown('Antibody QC Report: Intensity')"),
('chum_patho_study_qc_ctrl_uniformity', "StructurePermissibleValuesCustom::getCustomDropdown('Antibody QC Report: Uniformity')"),
('chum_patho_study_qc_ctrl_specificity', "StructurePermissibleValuesCustom::getCustomDropdown('Antibody QC Report: Specificity')"),
('chum_patho_study_qc_ctrl_background_noise', "StructurePermissibleValuesCustom::getCustomDropdown('Antibody QC Report: Background Noise')"),
('chum_patho_study_qc_ctrl_counterstain', "StructurePermissibleValuesCustom::getCustomDropdown('Antibody QC Report: Counterstain')"),
('chum_patho_study_qc_ctrl_conclusion', "StructurePermissibleValuesCustom::getCustomDropdown('Antibody QC Report: Conclusion')");
INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES 
('Antibody QC Report: Intensity', 1, 100, 'study / project'),
('Antibody QC Report: Uniformity', 1, 100, 'study / project'),
('Antibody QC Report: Specificity', 1, 100, 'study / project'),
('Antibody QC Report: Background Noise', 1, 100, 'study / project'),
('Antibody QC Report: Counterstain', 1, 100, 'study / project'),
('Antibody QC Report: Conclusion', 1, 50, 'study / project');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_lot', 'input',  NULL , '0', 'size=15', '', '', 'lot', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_date_received', 'date',  NULL , '0', '', '', '', 'date received', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_expiration_date', 'date',  NULL , '0', '', '', '', 'expiration date', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_validated', 'yes_no',  NULL , '0', '', '', '', 'validated', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_validated_date', 'date',  NULL , '0', '', '', '', '', 'date'), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_validated_protocol_number', 'input',  NULL , '0', 'size=15', '', '', '', 'protocol number'), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_test', 'date',  NULL , '0', '', '', '', 'test', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_intensity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_intensity') , '0', '', '', '', 'intensity', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_uniformity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_uniformity') , '0', '', '', '', 'uniformity', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_specificity', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_specificity') , '0', '', '', '', 'specificity', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_background_noise', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_background_noise') , '0', '', '', '', 'background noise', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_counterstain', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_counterstain') , '0', '', '', '', 'counterstain', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_conclusion', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_conclusion') , '0', '', '', '', 'conclusion', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_techn_resp_comment', 'textarea',  NULL , '0', 'cols=30,rows=2', '', '', 'techn. resp. comment', ''), 
('Study', 'StudyQualityControlReport', 'chum_patho_study_quality_control_reports', 'chum_patho_pathologist_comment', 'textarea',  NULL , '0', 'cols=30,rows=2', '', '', 'pathologist comment', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_lot' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='lot' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_date_received' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date received' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_expiration_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='expiration date' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_validated' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='validated' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_validated_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='date'), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_validated_protocol_number' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=15' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='protocol number'), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_test' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='test' AND `language_tag`=''), '1', '7', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_intensity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_intensity')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='intensity' AND `language_tag`=''), '1', '8', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_uniformity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_uniformity')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='uniformity' AND `language_tag`=''), '1', '9', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_specificity' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_specificity')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='specificity' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_background_noise' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_background_noise')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='background noise' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_counterstain' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_counterstain')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='counterstain' AND `language_tag`=''), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_conclusion' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chum_patho_study_qc_ctrl_conclusion')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='conclusion' AND `language_tag`=''), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_techn_resp_comment' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=2' AND `default`='' AND `language_help`='' AND `language_label`='techn. resp. comment' AND `language_tag`=''), '1', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_quality_control_reports'), (SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `tablename`='chum_patho_study_quality_control_reports' AND `field`='chum_patho_pathologist_comment' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=2' AND `default`='' AND `language_help`='' AND `language_label`='pathologist comment' AND `language_tag`=''), '1', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('techn. resp. comment','Techn. Resp. Comment','Commentaire Techn. Resp.'),
('lot', 'Lot', 'Lot'),
('date received', 'Date received', 'Date reçu'),
('expiration date', 'Expiration Date', 'Date exp'),
('validated', 'Validated', 'Validé'),
('protocol number', 'Protocol #', 'Protocole #'),
('test', 'Test', 'Essai'),
('intensity', 'Intensity', 'Intensité'),
('uniformity', 'Uniformity', 'Uniformité'),
('specificity', 'Specificity', 'Spécficité'),
('background noise', 'Background Noise', 'Bruit de fond'),
('against coloring', 'Against Coloring', 'Contre coloration'),
('conclusion', 'Conclusion', 'Conclusion'),
('counterstain','Counterstain','Contre coloration'),
('counterstain','Counterstain','Contre coloration'),
('add report', 'Add Report', 'Céer un rapport'),
('pathologist comment', 'Pathologist Comment', 'Commentaire Pathologiste');
INSERT INTO structure_validations(structure_field_id, rule, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='StudyQualityControlReport' AND `field`='chum_patho_lot'), 'notEmpty', '');

-- External Evaluation

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`) VALUES
('chum_path_std_2', 'tool_CAN_100', 0, 2, 'external evaluation', '', '/Study/StudySummaries/stdExtEvalListall/%%StudySummary.id%%/', 'Study.StudySummary::summary', 1, 1);

CREATE TABLE IF NOT EXISTS `chum_patho_study_external_evaluations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `study_summary_id` int(11) DEFAULT NULL,
  `chum_patho_ciqc` date DEFAULT NULL,
  `chum_patho_ciqc_accuracy` char(1) NOT NULL DEFAULT '',
  `chum_patho_cap` date DEFAULT NULL,
  `chum_patho_cap_accuracy` char(1) NOT NULL DEFAULT '',
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE IF NOT EXISTS `chum_patho_study_external_evaluations_revs` (
  `id` int(11) NOT NULL,
  `study_summary_id` int(11) DEFAULT NULL,
  `chum_patho_ciqc` date DEFAULT NULL,
  `chum_patho_ciqc_accuracy` char(1) NOT NULL DEFAULT '',
  `chum_patho_cap` date DEFAULT NULL,
  `chum_patho_cap_accuracy` char(1) NOT NULL DEFAULT '',
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;
ALTER TABLE `chum_patho_study_external_evaluations`
  ADD CONSTRAINT `FK_chum_patho_study_external_evaluations_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
  
INSERT INTO structures(`alias`) VALUES ('chum_patho_study_external_evaluations');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudyExternalEvaluation', 'chum_patho_study_external_evaluations', 'chum_patho_ciqc', 'date',  NULL , '0', '', '', '', 'ciqc', ''), 
('Study', 'StudyExternalEvaluation', 'chum_patho_study_external_evaluations', 'chum_patho_cap', 'date',  NULL , '0', '', '', '', 'cap', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_patho_study_external_evaluations'), (SELECT id FROM structure_fields WHERE `model`='StudyExternalEvaluation' AND `tablename`='chum_patho_study_external_evaluations' AND `field`='chum_patho_ciqc' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ciqc' AND `language_tag`=''), '1', '1', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_external_evaluations'), (SELECT id FROM structure_fields WHERE `model`='StudyExternalEvaluation' AND `tablename`='chum_patho_study_external_evaluations' AND `field`='chum_patho_cap' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='cap' AND `language_tag`=''), '1', '2', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='chum_patho_study_external_evaluations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudyExternalEvaluation' AND `tablename`='chum_patho_study_external_evaluations' AND `field`='chum_patho_cap' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('ciqc','CiQC','CiQC'),
('cap','CAP','CAP'),
('external evaluation', 'External Evaluation', 'Evaluation Externe');

-- Reference

INSERT INTO `menus` (`id`, `parent_id`, `is_root`, `display_order`, `language_title`, `language_description`, `use_link`, `use_summary`, `flag_active`, `flag_submenu`) VALUES
('chum_path_std_3', 'tool_CAN_100', 0, 2, 'reference', '', '/Study/StudySummaries/stdRefListall/%%StudySummary.id%%/', 'Study.StudySummary::summary', 1, 1);

CREATE TABLE IF NOT EXISTS `chum_patho_study_references` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `study_summary_id` int(11) DEFAULT NULL,
  `path` varchar(250) DEFAULT NULL,
  `description` text,
  `created` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
CREATE TABLE IF NOT EXISTS `chum_patho_study_references_revs` (
  `id` int(11) NOT NULL,
  `study_summary_id` int(11) DEFAULT NULL,
  `path` varchar(250) DEFAULT NULL,
  `description` text,
  `modified_by` int(10) unsigned NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;
ALTER TABLE `chum_patho_study_references`
  ADD CONSTRAINT `FK_chum_patho_study_references_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
  
INSERT INTO structures(`alias`) VALUES ('chum_patho_study_references');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Study', 'StudyReference', 'chum_patho_study_references', 'description', 'textarea',  NULL , '0', 'cols=30,rows=2', '', '', 'description', ''), 
('Study', 'StudyReference', 'chum_patho_study_references', 'path', 'input',  NULL , '0', 'size=70', '', '', 'path', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='chum_patho_study_references'), (SELECT id FROM structure_fields WHERE `model`='StudyReference' AND `tablename`='chum_patho_study_references' AND `field`='description' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=30,rows=2' AND `default`='' AND `language_help`='' AND `language_label`='description' AND `language_tag`=''), '1', '3', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='chum_patho_study_references'), (SELECT id FROM structure_fields WHERE `model`='StudyReference' AND `tablename`='chum_patho_study_references' AND `field`='path' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=70' AND `default`='' AND `language_help`='' AND `language_label`='path' AND `language_tag`=''), '1', '4', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('reference','Reference','Référence'),('path','Path','Accès');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Administration
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls SET flag_active = 0 WHERE name IN ('Laboratory Staff','Laboratory Sites','Specimen Collection Sites','Specimen Supplier Departments','Quality Control Tools',
'SOP Versions','Consent Form Versions','Orders Institutions','Orders Contacts','Xenograft Species','Xenograft Implantation Sites','Xenograft Tissues Sources');

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Datamart
-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_structure_functions SET flag_active = 0 WHERE label IN ('create derivative','add to order','create derivative','create quality control','print barcodes','participant identifiers report','all derivatives display','list all related diagnosis','initial specimens display');
UPDATE datamart_structure_functions SET flag_active = 0 WHERE datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN ('MiscIdentifier', 'ConsentMaster', 'TreatmentMaster', 'FamilyHistory', 'ParticipantMessage', 'QualityCtrl', 'EventMaster', 'SpecimenReviewMaster', 'ParticipantContact', 'ReproductiveHistory', 'TreatmentExtendMaster', 'AliquotReviewMaster'));
UPDATE datamart_reports SET flag_active = 0 WHERE name NOT IN ('number of elements per participant','list all children storages');

UPDATE datamart_structure_functions SET flag_active = 0
WHERE datamart_structure_id IN (
	SELECT id FROM datamart_structures 
	WHERE model IN ('MiscIdentifier',
	'ConsentMaster',
	'TreatmentMaster',
	'FamilyHistory',
	'ParticipantMessage',
	'QualityCtrl',
	'EventMaster',
	'SpecimenReviewMaster',
	'OrderItem',
	'Shipment',
	'ParticipantContact',
	'ReproductiveHistory',
	'TreatmentExtendMaster',
	'AliquotReviewMaster',
	'Order'));

UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = '0', flag_active_2_to_1 = '0'
WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN (
	'MiscIdentifier',
	'ConsentMaster',
	'TreatmentMaster',
	'FamilyHistory',
	'ParticipantMessage',
	'QualityCtrl',
	'EventMaster',
	'SpecimenReviewMaster',
	'OrderItem',
	'Shipment',
	'ParticipantContact',
	'ReproductiveHistory',
	'TreatmentExtendMaster',
	'AliquotReviewMaster',
	'Order'))
OR id2 IN (SELECT id FROM datamart_structures WHERE model IN (
	'MiscIdentifier',
	'ConsentMaster',
	'TreatmentMaster',
	'FamilyHistory',
	'ParticipantMessage',
	'QualityCtrl',
	'EventMaster',
	'SpecimenReviewMaster',
	'OrderItem',
	'Shipment',
	'ParticipantContact',
	'ReproductiveHistory',
	'TreatmentExtendMaster',
	'AliquotReviewMaster',
	'Order'));

-- ----------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '63xx' WHERE version_number = '2.6.6';