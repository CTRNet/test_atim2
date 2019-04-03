-- -----------------------------------------------------------------------------------------------------------------------------------
-- 
-- Add data dictionnary
-- 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Set the ATiM installation name

REPLACE INTO i18n (id,en,fr) VALUES ('core_installname', 'Northern Biobank Initiative', 'Northern Biobank Initiative');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Protocol
-- -----------------------------------------------------------------------------------------------------------------------------------

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

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Activate new ClinicalAnnotation Components
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE menus SET flag_active = 1  WHERE use_link LIKE '/ClinicalAnnotation/ParticipantContacts%';
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/DiagnosisMasters/%';
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/TreatmentMasters/%';
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/Participants/chronology/%';
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers/search%';
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories/%';
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories/%';

SELECT 'ParticipantContacts' AS 'TODO: Change users access permission to let people to access following modules'
UNION ALL
SELECT 'TreatmentMaster' AS 'TODO: Change users access permission to let people to access following modules'
UNION ALL
SELECT 'TreatmentMasterExtends' AS 'TODO: Change users access permission to let people to access following modules'
UNION ALL
SELECT 'ReproductiveHistories' AS 'TODO: Change users access permission to let people to access following modules'
UNION ALL
SELECT 'FamilyHistories' AS 'TODO: Change users access permission to let people to access following modules';

UPDATE datamart_reports SET flag_active = '1' WHERE name = 'list all related diagnosis';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'ParticipantContact' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentExtendMaster' AND label = 'number of elements per participant';

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'FamilyHistory' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'ReproductiveHistory' AND label = 'number of elements per participant';

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 18 AND id2 =4) OR (id1 = 4 AND id2 =18);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 9 AND id2 =4) OR (id1 = 4 AND id2 =9);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 9 AND id2 =9) OR (id1 = 9 AND id2 =9);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 14 AND id2 =9) OR (id1 = 9 AND id2 =14);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 10 AND id2 =9) OR (id1 = 9 AND id2 =10);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 20 AND id2 =10) OR (id1 = 10 AND id2 =20);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 2 AND id2 =10) OR (id1 = 10 AND id2 =2);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 10 AND id2 =4) OR (id1 = 4 AND id2 =10);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 2 AND id2 =9) OR (id1 = 9 AND id2 =2);
UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 WHERE (id1 = 19 AND id2 =4) OR (id1 = 4 AND id2 =19);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Participant contacts
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Contact Type

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Participant Contact Types', 1, 50, 'clinical - contact');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Contact Types');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("participant", "Participant", "Participant", "0", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("family", "Family", "Famille", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("physician", "Physician", "Médecin", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("treatment centre", "Treatment Centre", "Centre de traitement", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("other", "Other", "Autre", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 5, values_counter = 5 WHERE name = 'Participant Contact Types';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Participant Contact Types\')' WHERE domain_name = 'contact_type';
SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'contact_type');
UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

-- other fields

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='other_contact_type' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET  `setting`='size=20' WHERE model='ParticipantContact' AND tablename='participant_contacts' AND field='contact_name' AND `type`='input' AND structure_value_domain  IS NULL ;

UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='contact_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='address' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='street' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='phone & fax' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='phone' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_label`='relationship (if applicable)', flag_override_label = '1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='relationship');

UPDATE structure_formats SET `language_heading`='notes' WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("phone & fax", "Phone & Fax", ""),
('relationship (if applicable)', 'Relationship (if applicable)', ''),
("details", "Details", "");

-- Realtion ship

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Participant Contacts Relationships', 1, 50, 'clinical - contact');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Participant Contacts Relationships');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("aunt", "Aunt", "Tante", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("cousin", "Cousin", "Cousin", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("mother", "Mother", "Mère", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("grandfather", "Grandfather", "Grand-père", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("other", "Other", "Autre", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("father", "Father", "Père", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("grandmother", "Grandmother", "Grand-mère", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("nephew", "Nephew", "Neveu", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("brother", "Brother", "Frère", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("son", "Son", "Fils", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("niece", "Niece", "Nièce", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("sister", "Sister", "Soeur", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("daughter", "Daughter", "Fille", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("uncle", "Uncle", "Oncle", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("friend", "Friend", "Ami(e)", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("husband", "Husband", "Mari", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("wife", "Wife", "Femme (mariée)", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("common-law partner", "Common-Law Partner", "Conjoint de fait", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("father-in-law", "Father-in-law", "Beau père", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("mother-in-law", "Mother-in-law", "Belle mère", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("brother-in-law", "Brother-in-law", "Beau frère", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("sister-in-law", "Sister-in-law", "Belle soeur", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("household", "Household", "Ménage", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("other family member", "Other family member", "Autre membre de la famille", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 24, values_counter = 24 WHERE name = 'Participant Contacts Relationships';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Participant Contacts Relationships\')' WHERE domain_name = 'participant_contact_relationship';
SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'participant_contact_relationship');
UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

-- Physician details

ALTER TABLE participant_contacts
  ADD COLUMN bc_nbi_msc_id integer(25) DEFAULT NULL,
  ADD COLUMN bc_nbi_physician_speciality varchar(10) DEFAULT NULL,
  ADD COLUMN bc_nbi_physician_speciality_detail varchar(250) DEFAULT NULL;
ALTER TABLE participant_contacts_revs
  ADD COLUMN bc_nbi_msc_id integer(25) DEFAULT NULL,
  ADD COLUMN bc_nbi_physician_speciality varchar(10) DEFAULT NULL,
  ADD COLUMN bc_nbi_physician_speciality_detail varchar(250) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'bc_nbi_msc_id', 'integer',  NULL , '0', 'size=11', '', '', 'MSC ID', ''), 
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'bc_nbi_physician_speciality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_phys_specialty') , '0', '', '', '', 'speciality', ''), 
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'bc_nbi_physician_speciality_detail', 'input', NULL , '0', 'size=30', '', '', 'details', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='bc_nbi_msc_id' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `default`='' AND `language_help`='' AND `language_label`='MSC ID' AND `language_tag`=''), '1', '20', 'physician details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='bc_nbi_physician_speciality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_phys_specialty')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='speciality' AND `language_tag`=''), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='bc_nbi_physician_speciality_detail' AND `type`='input' AND `structure_value_domain` IS NULL AND `flag_confidential`='0'), '1', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("MSC ID", "MSC ID", ""),
("speciality", "Speciality", ""),
("physician details", "Physician Precisions (if applicable)", "");

ALTER TABLE participant_contacts
  ADD COLUMN bc_nbi_physician_type varchar(250) DEFAULT NULL,
  ADD COLUMN bc_nbi_pre_2003_physician_name varchar(10) DEFAULT NULL;
ALTER TABLE participant_contacts_revs
  ADD COLUMN bc_nbi_physician_type varchar(250) DEFAULT NULL,
  ADD COLUMN bc_nbi_pre_2003_physician_name varchar(10) DEFAULT NULL;

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Physician Types', 1, 250, 'clinical - contact');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('bc_nbi_physician_types', "StructurePermissibleValuesCustom::getCustomDropdown('Physician Types')");
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Physician Types');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("follow-up", "Follow-up", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("most responsible 2003", "Most Responsible 2003", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("most responsible pre 2003", "Most Responsible pre 2003", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("family physician", "Family Physician", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'bc_nbi_physician_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_physician_types') , '0', '', '', '', 'type', ''), 
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'bc_nbi_pre_2003_physician_name', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_clinic_phys') , '0', '', '', '', 'pre 2003 physician', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='bc_nbi_physician_type'), 
'1', '20', '', '0', '0', '', '1', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='bc_nbi_pre_2003_physician_name'), 
'1', '5', '', '0', '1', '', '01', 'or pre 2003 physician', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("or pre 2003 physician", "or Pre 2003 Physician", ""),
("pre 2003 physician", "Pre 2003 Physician", "");

-- other fields

UPDATE structure_formats SET flag_search = '1', flag_index = '1' WHERE structure_id = (SELECT id FROM structures WHERE alias='participantcontacts')
AND flag_add = '1';

ALTER TABLE participant_contacts MODIFY contact_name varchar(100) NOT NULL DEFAULT '';
ALTER TABLE participant_contacts_revs MODIFY contact_name varchar(100) NOT NULL DEFAULT '';

UPDATE structure_formats SET `display_order`='10'
WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='effective_date');
UPDATE structure_formats SET `display_order`='11'
WHERE structure_id=(SELECT id FROM structures WHERE alias='participantcontacts') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='expiry_date');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Profile (Main Form)
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='middle_name' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='1');

ALTER TABLE participants MODIFY `last_name` varchar(50) DEFAULT NULL;
ALTER TABLE participants_revs MODIFY `last_name` varchar(50) DEFAULT NULL;

UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Current Status
 
ALTER TABLE participants
    ADD COLUMN bc_nbi_last_attended_appt date DEFAULT NULL,
    ADD COLUMN bc_nbi_last_attended_appt_accuracy char(1) NOT NULL DEFAULT '',
    ADD COLUMN bc_nbi_last_contact_date date DEFAULT NULL,
    ADD COLUMN bc_nbi_last_contact_date_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE participants_revs
    ADD COLUMN bc_nbi_last_attended_appt date DEFAULT NULL,
    ADD COLUMN bc_nbi_last_attended_appt_accuracy char(1) NOT NULL DEFAULT '',
    ADD COLUMN bc_nbi_last_contact_date date DEFAULT NULL,
    ADD COLUMN bc_nbi_last_contact_date_accuracy char(1) NOT NULL DEFAULT '';    
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_last_attended_appt', 'date',  NULL , '0', '', '', 'last_attended_appt', 'last attended appt', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_last_contact_date', 'date',  NULL , '0', '', '', 'bc_nbi_last_contact_date', 'last contact', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_last_attended_appt' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='last_attended_appt' AND `language_label`='last attended appt' AND `language_tag`=''), '3', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_last_contact_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_last_contact_date' AND `language_label`='last contact' AND `language_tag`=''), '3', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("last attended appt", "Last Attended Appt", ""),
("last contact", "Last Contact", ""),
("last_attended_appt", "Last known appointment that patient attended at BCCA", ""),
("bc_nbi_last_contact_date", "Last known date of contact with the patient", "");

ALTER TABLE participants
    ADD COLUMN bc_nbi_statmar18 varchar(8) DEFAULT NULL;
ALTER TABLE participants_revs
    ADD COLUMN bc_nbi_statmar18 varchar(8) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_statmar18', 'input',  NULL , '0', 'size=8', '', 'statmar18', 'vital status 2018-03-31', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_statmar18' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=8' AND `default`='' AND `language_help`='statmar18' AND `language_label`='vital status 2018-03-31' AND `language_tag`=''), '3', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("vital status 2018-03-31", "Vital Status 2018-03-31", ""),
("statmar18", "Event variable for OS - vital status at Mar 31, 2018", "")  ;
    
-- Cause of death   
    
UPDATE structure_fields SET  `language_help`='bc_nbi_help_bcca_cod',  `language_label`='bcca cause of death (icd10)' WHERE model='Participant' AND tablename='participants' AND field='cod_icd10_code' AND `type`='autocomplete' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='10', `language_heading`='cause of death', `flag_add`='1', `flag_edit`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_cod', 'BCOU variable (combines BCOU death table w bcca_COD) -  cause of death; if present and different from DVS cause of death, this variable overrides DVS', ''),
("bcca cause of death (icd10)", "BCCA (ICD-10)", "");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_bcca_cod_icd89', 'input',  NULL , '0', 'size=5', '', '', 'bcca cause of death (icd8/9)', 'code'), 
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_bcca_cod_icd89_desc', 'input',  NULL , '0', '', '', 'bc_nbi_help_bcca_cod', '', 'description');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_bcca_cod_icd89' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='bcca cause of death (icd8/9)' AND `language_tag`='code'), '3', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_bcca_cod_icd89_desc' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_help_bcca_cod' AND `language_label`='' AND `language_tag`='description'), '3', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("bcca cause of death (icd8/9)", "BCCA (ICD-8/9)", "");
ALTER TABLE participants
    ADD COLUMN bc_nbi_bcca_cod_icd89 varchar(5) DEFAULT NULL,
    ADD COLUMN bc_nbi_bcca_cod_icd89_desc varchar(100) DEFAULT NULL;
ALTER TABLE participants_revs
    ADD COLUMN bc_nbi_bcca_cod_icd89 varchar(5) DEFAULT NULL,
    ADD COLUMN bc_nbi_bcca_cod_icd89_desc varchar(100) DEFAULT NULL;

ALTER TABLE participants
    ADD COLUMN bc_nbi_death_cause_original_icd_10 varchar(50) DEFAULT NULL,
    ADD COLUMN bc_nbi_death_cause_original_icd_89 varchar(5) DEFAULT NULL,
    ADD COLUMN bc_nbi_death_cause_original_icd_89_desc varchar(100) DEFAULT NULL;
ALTER TABLE participants_revs
    ADD COLUMN bc_nbi_death_cause_original_icd_10 varchar(50) DEFAULT NULL,
    ADD COLUMN bc_nbi_death_cause_original_icd_89 varchar(5) DEFAULT NULL,
    ADD COLUMN bc_nbi_death_cause_original_icd_89_desc varchar(100) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_death_cause_original_icd_10', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who', '', 'bc_nbi_help_death_cause_original', 'underlying cause of death (icd10)', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_death_cause_original_icd_89', 'input',  NULL , '0', 'size=5', '', 'bc_nbi_help_death_cause_original', 'underlying cause of death (icd8/9)', 'code'), 
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_death_cause_original_icd_89_desc', 'input',  NULL , '0', '', '', '', '', 'description');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_death_cause_original_icd_10' AND `type`='autocomplete' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10,url=/CodingIcd/CodingIcd10s/autocomplete/who,tool=/CodingIcd/CodingIcd10s/tool/who' AND `default`='' AND `language_help`='bc_nbi_help_death_cause_original' AND `language_label`='underlying cause of death (icd10)' AND `language_tag`=''), '3', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_death_cause_original_icd_89' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='bc_nbi_help_death_cause_original' AND `language_label`='underlying cause of death (icd8/9)' AND `language_tag`='code'), '3', '14', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_death_cause_original_icd_89_desc' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='description'), '3', '15', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("bc_nbi_help_death_cause_original", "The patient’s primary or underlying cause of death as determined by the Division of Vital Statistics  or another province/country’s vital statistics department", ""),
("underlying cause of death (icd8/9)", "Underlying (ICD-8/9)", ""),
("underlying cause of death (icd10)", "Underlying (ICD-10)", "");
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant'  AND `field`='bc_nbi_death_cause_original_icd_10'), 'validateIcd10WhoCode', 'invalid cause of death code');

ALTER TABLE participants
    ADD COLUMN bc_nbi_death_sec_cause_89 varchar(5) DEFAULT NULL,
    ADD COLUMN bc_nbi_death_sec_cause_89_desc varchar(100) DEFAULT NULL;
ALTER TABLE participants_revs
    ADD COLUMN bc_nbi_death_sec_cause_89 varchar(5) DEFAULT NULL,
    ADD COLUMN bc_nbi_death_sec_cause_89_desc varchar(100) DEFAULT NULL;
UPDATE structure_fields SET  `language_help`='bc_nbi_help_death_sec_cause',  `language_label`='alternate cause of death (icd10)' WHERE model='Participant' AND tablename='participants' AND field='secondary_cod_icd10_code' AND `type`='autocomplete' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_order`='20', `flag_add`='1', `flag_edit`='1', `flag_search`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='secondary_cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_death_sec_cause_89', 'input',  NULL , '0', 'size=5', '', 'bc_nbi_help_death_sec_cause', 'alternate cause of death (icd8/9)', 'code'), 
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_death_sec_cause_89_desc', 'input',  NULL , '0', '', '', '', '', 'description');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_death_sec_cause_89' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='bc_nbi_help_death_sec_cause' AND `language_label`='alternate cause of death (icd8/9)' AND `language_tag`='code'), '3', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_death_sec_cause_89_desc' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='description'), '3', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("bc_nbi_help_death_sec_cause", "The secondary cause of the patient’s death as determined by the Division of Vital Statistics or another province /country’s vital statistics. The ICD code is entered without the decimal.", ""),
("alternate cause of death (icd8/9)", "Alternate (ICD-8/9)", ""),
("alternate cause of death (icd10)", "Alternate (ICD-10)", ""); 

UPDATE structure_fields SET  `language_help`='bc_nbi_help_bcca_cod' WHERE model='Participant' AND tablename='participants' AND field='bc_nbi_bcca_cod_icd89' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='bc_nbi_help_death_cause_original' WHERE model='Participant' AND tablename='participants' AND field='bc_nbi_death_cause_original_icd_89_desc' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `language_help`='bc_nbi_help_death_sec_cause' WHERE model='Participant' AND tablename='participants' AND field='bc_nbi_death_sec_cause_89_desc' AND `type`='input' AND structure_value_domain  IS NULL ;

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("death from breast cancer", "death from breast cancer");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="health_status"), (SELECT id FROM structure_permissible_values WHERE value="death from breast cancer" AND language_alias="death from breast cancer"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("death from other than breast cancer", "death from other than breast cancer");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="health_status"), (SELECT id FROM structure_permissible_values WHERE value="death from other than breast cancer" AND language_alias="death from other than breast cancer"), "2", "1");
INSERT IGNORE INTO i18n (id,en, fr) 
VALUES
("death from breast cancer", "Death from breast cancer", ''),
("death from other than breast cancer", "Death from other than breast cancer", '');

UPDATE structure_formats SET `display_column`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_modification' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Reproductive history
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hysterectomy_age_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='date_captured' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_addgrid`='1', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='menopause_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_addgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hysterectomy_age' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hysterectomy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='indicator') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='ovary_removed_type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ovary_removed_type') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='menopause_onset_reason' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_reason') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='lnmp_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hrt_use' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='indicator') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hrt_years_used' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menarche_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_last_parturition_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='gravida' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='para' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_first_parturition' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_last_parturition' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_addgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menarche' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='years_on_hormonal_contraceptives' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_first_parturition_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='age_accuracy') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='hormonal_contraceptive_use' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='indicator') AND `flag_confidential`='0');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='menopause_status') ,  `language_help`='bc_nbi_help_menopause status' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='menopause_status' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_status');
UPDATE structure_fields SET  `language_help`='bc_nbi_help_age at menopause' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='age_at_menopause' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_column`='3', `language_heading`='menopause' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='menopause_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='menopause_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menopause' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='menarche' WHERE structure_id=(SELECT id FROM structures WHERE alias='reproductivehistories') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='age_at_menarche' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ReproductiveHistory', 'reproductive_histories', 'bc_nbi_meno_status_desc', 'input',  NULL , '0', '', '', 'bc_nbi_help_meno_status_desc', 'menopausal status description', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='bc_nbi_meno_status_desc' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_help_meno_status_desc' AND `language_label`='menopausal status description' AND `language_tag`=''), '3', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("menarche", "Menarche", ""),
("menopause", "Menopause", ""),
("menopausal status description", "Status Description", ""),
("bc_nbi_help_menopause status", "The patient's menstrual status at referral to BCCA.<br>-Premenopausal:  menstruation has occurred within the previous year or patient has had a hysterectomy (ovaries not removed)  and no menopausal symptoms are present<br>-Postmenopausal: last menstruation more than 1 year ago<br>-Pregnant: patient was pregnant and/or lactating at referral", ""),
("bc_nbi_help_meno_status_desc", "The narrative description of the patient's menstrual status at referral to BCCA.", ""),
("bc_nbi_help_age at menopause", "The age at which the patient completely stopped menstruation or date of hysterectomy if both ovaries were removed.", "");

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Menopausal status', 1, 50, 'clinical - reproductive history');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Menopausal status');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "Not Known", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1", "Pre-Menopause", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3", "Post-Menopause", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4", "Pregnant", "", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 3, values_counter = 3 WHERE name = 'Menopausal status';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Menopausal status\')' WHERE domain_name = 'menopause_status';
SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'menopause_status');
UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Menopausal status');
UPDATE structure_permissible_values_customs SET value = LOWER(en) WHERE control_id = @control_id;
ALTER TABLE reproductive_histories ADD COLUMN bc_nbi_meno_status_desc varchar(100) DEFAULT NULL;
ALTER TABLE reproductive_histories_revs ADD COLUMN bc_nbi_meno_status_desc varchar(100) DEFAULT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Participant Identifier
-- -----------------------------------------------------------------------------------------------------------------------------------

-- INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, 
-- `flag_once_per_participant`, `flag_confidential`, `flag_unique`, `pad_to_length`, `reg_exp_validation`, `user_readable_format`, `flag_link_to_study`) VALUES
-- (null, 'bcca id', 1, 0, '', '', 
-- 1, 1, 1, 0, '', '', 0);
-- INSERT INTO i18n (id,en,fr)
-- VALUES
-- ('bcca id', 'BC Cancer Agency Id', ''); 

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Participant Treatment - Radiotherapy
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE treatment_controls SET flag_active = 0;
UPDATE treatment_extend_controls SET flag_active = 0;

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'radiotherapy', 'at diagnosis', 1, 'bc_nbi_txd_radiations_at_dx', 'bc_nbi_txd_radiations_at_dx', 0, NULL, NULL, 'radiotherapy|at diagnosis', 0, NULL, 1, 1),
(null, 'radiotherapy', '', 1, 'bc_nbi_txd_radiations', 'bc_nbi_txd_radiations', 0, NULL, NULL, 'radiotherapy', 0, NULL, 1, 1);

CREATE TABLE `bc_nbi_txd_radiations_at_dx` (
  `init_rt_boost` char(1) DEFAULT '',
  `init_rt_brachy` char(1) DEFAULT '',
  `init_rt_brchw` char(1) DEFAULT '',
  `init_rt_nodal`char(1) DEFAULT '',
  `rtoutofprov` tinyint(1) DEFAULT '0',
  init_finrt varchar(10) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `bc_nbi_txd_radiations_at_dx_revs` (
  `init_rt_boost` char(1) DEFAULT '',
  `init_rt_brachy` char(1) DEFAULT '',
  `init_rt_brchw` char(1) DEFAULT '',
  `init_rt_nodal`char(1) DEFAULT '',
  `rtoutofprov` tinyint(1) DEFAULT '0',
  init_finrt varchar(10) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `bc_nbi_txd_radiations_at_dx`
  ADD KEY `tx_master_id` (`treatment_master_id`),
  ADD CONSTRAINT `bc_nbi_txd_radiations_at_dx_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
ALTER TABLE `bc_nbi_txd_radiations_at_dx_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
INSERT INTO structures(`alias`) VALUES ('bc_nbi_txd_radiations_at_dx');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'init_rt_boost', 'yes_no',  NULL , '0', '', '', 'bc_help_nbi_init_rt_boost', 'rt boost at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'init_rt_brachy', 'yes_no',  NULL , '0', '', '', 'bc_help_nbi_init_rt_brachy', 'rt brachy at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'init_rt_brchw', 'yes_no',  NULL , '0', '', '', 'bc_help_nbi_init_rt_brchw', 'rt brchw at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'init_rt_nodal', 'yes_no',  NULL , '0', '', '', 'bc_help_nbi_init_rt_nodal', 'rt node at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'rtoutofprov', 'checkbox',  NULL , '0', '', '', 'bc_help_nbi_rtoutofprov', 'rt out of province', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'init_finrt', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_init_finrt') , '0', '', '', 'bc_help_nbi_init_finrt', 'rt at init dx', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations_at_dx' AND `field`='init_rt_boost'), '2', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations_at_dx' AND `field`='init_rt_brachy'), '2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations_at_dx' AND `field`='init_rt_brchw'), '2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations_at_dx' AND `field`='init_rt_nodal'), '2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations_at_dx' AND `field`='rtoutofprov'), '2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations_at_dx' AND `field`='init_finrt'), '2', '19', 'details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '1', '1');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("radiotherapy", "Radiotherapy", ""),
("at diagnosis", "At Diagnosis", ""),
("rt at init dx", "RT Plan at Initial Dx", ""),
("rt boost at init dx", "RT Boost", ""),
("rt brachy at init dx", "Brachytherapy", ""),
("rt brchw at init dx", "Breast/Chest Wall RT", ""),
("rt node at init dx", "Regional Nodal RT", ""),
("rt out of province", "Out of Province", ""),
("bc_help_nbi_init_rt_boost", "Indicates if there was an RT boost at initial dx - Calculated variable", ""),
("bc_help_nbi_init_rt_brachy", "Indicates if brachytherapy was given at initial dx - Calculated variable", ""),
("bc_help_nbi_init_rt_brchw", "Indicates if there was RT to the breast/chest wall at initial dx - Calculated variable", ""),
("bc_help_nbi_init_rt_nodal", "Indicates if there was RT to the regional nodes at initial dx - Calculated variable", ""),
("bc_help_nbi_rtoutofprov", "RT OOP flag captured from BCOU table:  RT out of province; located in H BOUTCOME drive", ""),
("bc_help_nbi_init_finrt", "Locoregional RT planned as part of the initial treatment plan at diagnosis. Calculated variable using RT Boost, Brachy, BRChw, Node at Init Dx variables.", "");

CREATE TABLE `bc_nbi_txd_radiations` (
   rt_treat_region varchar(10) DEFAULT NULL,
   rt_technique varchar(10) DEFAULT NULL,
   rt_technique_desc varchar(250) DEFAULT NULL,
   rt_treat_intent varchar(250) DEFAULT NULL,
   rt_treat_plan varchar(250) DEFAULT NULL,
   rt_dose_cgy int(5) DEFAULT NULL,
   rt_dose_xd varchar(250) DEFAULT NULL,
   rt_fractions int(5) DEFAULT NULL,
   rt_course int(5) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `bc_nbi_txd_radiations_revs` (
   rt_treat_region varchar(10) DEFAULT NULL,
   rt_technique varchar(10) DEFAULT NULL,
   rt_technique_desc varchar(250) DEFAULT NULL,
   rt_treat_intent varchar(250) DEFAULT NULL,
   rt_treat_plan varchar(250) DEFAULT NULL,
   rt_dose_cgy int(5) DEFAULT NULL,
   rt_dose_xd varchar(250) DEFAULT NULL,
   rt_fractions int(5) DEFAULT NULL,
   rt_course int(5) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `bc_nbi_txd_radiations`
  ADD KEY `tx_master_id` (`treatment_master_id`),
  ADD CONSTRAINT `bc_nbi_txd_radiations_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
ALTER TABLE `bc_nbi_txd_radiations_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;

INSERT INTO structures(`alias`) VALUES ('bc_nbi_txd_radiations');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_finish_date' AND `language_label`='finish date' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1', `flag_addgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='finish_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('Radiotherapy Treatment Intent', 1, 250, 'clinical - treatment');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('bc_nbi_rt_treat_intent', "StructurePermissibleValuesCustom::getCustomDropdown('Radiotherapy Treatment Intent')");
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Treatment Intent');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("r", "Radical", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("p", "Palliative", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("a", "Adjuvant (1984 - 2014)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("u", "Unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("o", "Other (1984 - 06/1995)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('Radiotherapy Dose D', 1, 250, 'clinical - treatment');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('bc_nbi_rt_dose_xd', "StructurePermissibleValuesCustom::getCustomDropdown('Radiotherapy Dose D')");
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Dose D');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("t", "TD (tumour dose)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("s", "SD (skin/surface dose)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('Radiotherapy Treatment Plan', 1, 250, 'clinical - treatment');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('bc_nbi_rt_treat_plan', "StructurePermissibleValuesCustom::getCustomDropdown('Radiotherapy Treatment Plan')");
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Treatment Plan');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("i", "Initial", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("u", "Subsequent", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_treat_region', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_trt_region') , '0', '', '', 'bc_nbi_help_rt_treat_region', 'region', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_technique', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_tech') , '0', '', '', 'bc_nbi_help_rt_technique', 'technique', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_technique_desc', 'input',  NULL , '0', '', '', 'bc_nbi_help_rt_technique_desc', '', 'description'), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_treat_intent', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_treat_intent') , '0', '', '', 'bc_nbi_help_rt_treat_intent', 'intent', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_treat_plan', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_treat_plan') , '0', '', '', 'bc_nbi_help_rt_treat_plan', 'plan', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_dose_cgy', 'integer_positive',  NULL , '0', 'size=4', '', 'bc_nbi_help_rt_dose_cgy', 'dose (cgy)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_dose_xd', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_dose_xd') , '0', '', '', 'bc_nbi_help_rt_dose_xd', 'dose (xd)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_fractions', 'integer_positive',  NULL , '0', 'size=4', '', 'bc_nbi_help_rt_fractions', 'fractions', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_course', 'integer_positive',  NULL , '0', 'size=4', '', 'bc_nbi_help_rt_course', 'course', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations' AND `field`='rt_treat_region' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_trt_region')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_help_rt_treat_region' AND `language_label`='region' AND `language_tag`=''), '3', '31', 'details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations' AND `field`='rt_technique' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_tech')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_help_rt_technique' AND `language_label`='technique' AND `language_tag`=''), '3', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations' AND `field`='rt_technique_desc' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_help_rt_technique_desc' AND `language_label`='' AND `language_tag`='description'), '3', '33', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations' AND `field`='rt_treat_intent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_treat_intent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_help_rt_treat_intent' AND `language_label`='intent' AND `language_tag`=''), '3', '34', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations' AND `field`='rt_treat_plan' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_treat_plan')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_help_rt_treat_plan' AND `language_label`='plan' AND `language_tag`=''), '3', '35', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations' AND `field`='rt_dose_cgy' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='bc_nbi_help_rt_dose_cgy' AND `language_label`='dose (cgy)' AND `language_tag`=''), '3', '36', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations' AND `field`='rt_dose_xd' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_dose_xd')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_help_rt_dose_xd' AND `language_label`='dose (xd)' AND `language_tag`=''), '3', '37', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations' AND `field`='rt_fractions' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='bc_nbi_help_rt_fractions' AND `language_label`='fractions' AND `language_tag`=''), '3', '38', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations' AND `field`='rt_course' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='bc_nbi_help_rt_course' AND `language_label`='course' AND `language_tag`=''), '3', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('technique', 'Technique', ''),
('plan', 'Plan', ''),
('dose (cgy)', 'Dose (CGy)', ''),
('dose (xd)', 'Dose (xd)', ''),
('fractions', 'Fractions', ''),
('course', 'Course', ''),
("bc_nbi_help_rt_treat_region", "The anatomic site where the patient received radiotherapy treatment: RT#1", ""),
("bc_nbi_help_rt_technique", "The method used to administer the radiotherapy: RT#1. The third-digit modifier must be A-N, R, S, U. Discontinued effective RT End Date April 1, 2011 (Exception: 'K'-continue to collect)", ""),
("bc_nbi_help_rt_technique_desc", "RT technique narrative description - CAIS data dictionary: RT#1", ""),
("bc_nbi_help_rt_treat_intent", "The expected result of the treatment course: RT#1", ""),
("bc_nbi_help_rt_treat_plan", "Describes how the radiotherapy fits into the treatment protocol: RT#1", ""),
("bc_nbi_help_rt_dose_cgy", "The amount of radiation received by the patient: RT#1", ""),
("bc_nbi_help_rt_dose_xd", "The type of radiation dose received by the patient: RT#1.  Discontinued effective RT end date: 4/1/2011.", ""),
("bc_nbi_help_rt_fractions", "The total number of individual exposures to radiation that the patient received for each treatment line: RT#1", ""),
("bc_nbi_help_rt_course", "The number assigned in sequence to each RT tx plan (including both radiotherapy & brachytherapy): RT#1", "");
       	    	
UPDATE structure_formats SET `flag_float`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations_at_dx');

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2019-02-20 : New Customization
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Participants

UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='date_of_death' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='cod_icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='last_chart_checked_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE participants
   ADD COLUMN bc_nbi_phn_number VARCHAR(200) DEFAULT NULL,
   ADD COLUMN bc_nbi_bc_cancer_agency_id varchar(200) DEFAULT NULL,
   ADD COLUMN bc_nbi_retrospective_bank char(1) NOT NULL DEFAULT 'n';
ALTER TABLE participants_revs
   ADD COLUMN bc_nbi_phn_number VARCHAR(200) DEFAULT NULL,
   ADD COLUMN bc_nbi_bc_cancer_agency_id varchar(200) DEFAULT NULL,
   ADD COLUMN bc_nbi_retrospective_bank char(1) NOT NULL DEFAULT 'n';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_bc_cancer_agency_id', 'input',  NULL , '1', '', '', '', 'bc cancer agency id', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_retrospective_bank', 'yes_no',  NULL , '0', '', '', '', 'retrospective bank', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'bc_nbi_phn_number', 'input',  NULL , '1', '', '', '', 'phn number', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_bc_cancer_agency_id' ), '1', '0', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_retrospective_bank'), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_phn_number'), '1', '-1', 'clin_demographics', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET language_heading = '', `display_order`='-3',`flag_add`='0', `flag_edit`='1', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='-2' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='bc_nbi_retrospective_bank' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='Participant'  AND `field`='bc_nbi_retrospective_bank'), 'notBlank', '');

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('phn number', 'PHN#', 'PHN#'),
('bc cancer agency id', 'BCCA#', 'BCCA#'),
('retrospective bank', 'Retrospective Bank', '');
UPDATE i18n SET en = 'ATiM-Participant#', fr = 'ATiM-Participant#' WHERE id = 'participant identifier';

UPDATE participants SET bc_nbi_phn_number = participant_identifier;
UPDATE participants_revs SET bc_nbi_phn_number = participant_identifier;

UPDATE participants SET bc_nbi_retrospective_bank = 'y', participant_identifier = CONCAT('ATiM-P#', id);
UPDATE participants_revs SET bc_nbi_retrospective_bank = 'y', participant_identifier = CONCAT('ATiM-P#', id);

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('you are not allowed to edit participant of the retrospective bank', "You are not allowed to edit participant of the 'Retrospective Bank'.", ''),
('your search will be limited to participant of the prospective bank only', "Your search will be limited to participant of the 'Prospective Bank' only.", ''),
('more than one participants have the same phn number into atim', 'More than one participants have the same PHN number into atim.', ''),
('more than one participants have the same bcca number into atim', 'More than one participants have the same BCCA number into atim.', '');

-- Treatment Surgery

INSERT INTO treatment_extend_controls (detail_tablename, detail_form_alias, flag_active, type, databrowser_label)
VALUES
('bc_nbi_txe_surgeries', 'bc_nbi_txe_surgeries', '1', 'surgical procedure', 'surgical procedure');
DROP TABLE IF EXISTS `bc_nbi_txe_surgeries`;
CREATE TABLE `bc_nbi_txe_surgeries` (
  `surgery_code` varchar(5) DEFAULT NULL,
  `surgery_code_description` varchar(100) DEFAULT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  KEY `FK_bc_nbi_txe_surgeries_treatment_extend_masters` (`treatment_extend_master_id`),
  CONSTRAINT `FK_bc_nbi_txe_surgeries_treatment_extend_masters` FOREIGN KEY (`treatment_extend_master_id`) REFERENCES `treatment_extend_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `bc_nbi_txe_surgeries_revs`;
CREATE TABLE `bc_nbi_txe_surgeries_revs` (
  `surgery_code` varchar(5) DEFAULT NULL,
  `surgery_code_description` varchar(100) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `treatment_extend_master_id` int(11) NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO structures(`alias`) VALUES ('bc_nbi_txe_surgeries');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentExtendDetail', 'bc_nbi_txe_surgeries', 'surgery_code', 'input',  NULL , '0', 'size=5', '', 'bc_nbi_help_txe_surgery_code', 'surgery code', ''), 
('ClinicalAnnotation', 'TreatmentExtendDetail', 'bc_nbi_txe_surgeries', 'surgery_code_description', 'input',  NULL , '0', '', '', '', 'surgery code description', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_txe_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='bc_nbi_txe_surgeries' AND `field`='surgery_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='bc_nbi_help_txe_surgery_code' AND `language_label`='surgery code' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txe_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail' AND `tablename`='bc_nbi_txe_surgeries' AND `field`='surgery_code_description' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='surgery code description' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_validations(structure_field_id, rule, language_message) 
VALUES
((SELECT id FROM structure_fields WHERE `model`='TreatmentExtendDetail'  AND `field`='surgery_code'), 'notBlank', '');
INSERT IGNORE i18n (id,en,fr)
VALUES
('bc_nbi_help_txe_surgery_code', "Statistics Canada Canadian Classification of Diagnostic, Therapeutic, and Surgical Procedures", "Statistics Canada Canadian Classification of Diagnostic, Therapeutic, and Surgical Procedures"),
('surgery code', "Code", "Code"),
('surgery code description', "Description", "Description");

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) 
VALUES
(null, 'surgery', '', 1, 'bc_nbi_txd_surgeries', 'bc_nbi_txd_surgeries', 0, NULL, NULL, 'surgery', 1, (SELECT id FROM treatment_extend_controls WHERE detail_tablename  = 'bc_nbi_txe_surgeries'), 0, 1);
DROP TABLE IF EXISTS `bc_nbi_txd_surgeries`;
CREATE TABLE `bc_nbi_txd_surgeries` (
  `surg_treat_intent_desc` varchar(100) DEFAULT NULL,
  `surg_treat_plan_code` varchar(100) DEFAULT NULL,
  `surg_treat_plan_desc` varchar(100) DEFAULT NULL,
  `surgeon_msc_id` integer(25) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `bc_nbi_txd_surgeries_revs`;
CREATE TABLE `bc_nbi_txd_surgeries_revs` (
  `surg_treat_intent_desc` varchar(100) DEFAULT NULL,
  `surg_treat_plan_code` varchar(100) DEFAULT NULL,
  `surg_treat_plan_desc` varchar(100) DEFAULT NULL,
  `surgeon_msc_id` integer(25) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `bc_nbi_txd_surgeries`
  ADD KEY `tx_master_id` (`treatment_master_id`),
  ADD CONSTRAINT `bc_nbi_txd_surgeries_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
ALTER TABLE `bc_nbi_txd_surgeries_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="5" WHERE svd.domain_name='intent' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="palliative" AND language_alias="palliative");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("diagnostic", "diagnostic");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent"), (SELECT id FROM structure_permissible_values WHERE value="diagnostic" AND language_alias="diagnostic"), "3", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent"), (SELECT id FROM structure_permissible_values WHERE value="other" AND language_alias="other"), "4", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="intent"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "9", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("bc_nbi_surg_treat_plan", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("initial", "initial");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_treat_plan"), (SELECT id FROM structure_permissible_values WHERE value="initial" AND language_alias="initial"), "5", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("subsequent", "subsequent");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_treat_plan"), (SELECT id FROM structure_permissible_values WHERE value="subsequent" AND language_alias="subsequent"), "5", "1");
INSERT INTO structures(`alias`) VALUES ('bc_nbi_txd_surgeries');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_tx_intent' AND `language_label`='intent' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_column`='2', `display_order`='10' WHERE structure_id=(SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_surgeries', 'surg_treat_intent_desc', 'input',  NULL , '0', '', '', '', 'intent description', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_surgeries', 'surg_treat_plan_code', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_treat_plan') , '0', '', '', '', 'plan', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_surgeries', 'surg_treat_plan_desc', 'input',  NULL , '0', '', '', '', 'plan description', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_surgeries', 'surgeon_msc_id', 'integer',  NULL , '0', 'size=11', '', '', 'MSC ID', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_surgeries' AND `field`='surg_treat_intent_desc' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='intent description' AND `language_tag`=''), '2', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_surgeries' AND `field`='surg_treat_plan_code' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_treat_plan')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='plan' AND `language_tag`=''), '2', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_surgeries' AND `field`='surg_treat_plan_desc' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='plan description' AND `language_tag`=''), '2', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_surgeries' AND `field`='surgeon_msc_id' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=11' AND `default`='' AND `language_help`='' AND `language_label`='MSC ID' AND `language_tag`=''), '1', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1', '0');
UPDATE structure_formats SET `display_column`='3' WHERE structure_id=(SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT IGNORE INTO i18n (id, en,fr)
VALUES
('initial', 'Initial', ''),
('subsequent', 'Subsequent', ''),
('diagnostic', 'Diagnostic', 'Diagnostique'),
('diagnostic', 'Diagnostic', 'Diagnostique'),
('diagnostic', 'Diagnostic', 'Diagnostique'),
('diagnostic', 'Diagnostic', 'Diagnostique'),
('intent description', 'Intent Description', ''),
('plan description', 'Plan Description', '');

-- Treatment Surgery At Dx

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'surgery', 'at diagnosis', 1, 'bc_nbi_txd_surgeries_at_dx', 'bc_nbi_txd_surgeries_at_dx', 0, NULL, NULL, 'surgery|at diagnosis', 1, NULL, 0, 1);
DROP TABLE IF EXISTS `bc_nbi_txd_surgeries_at_dx`;
CREATE TABLE `bc_nbi_txd_surgeries_at_dx` (
  `finsurg` varchar(50) DEFAULT NULL,
  `init_alnd` varchar(50) DEFAULT NULL,
  `init_nodal_proc` varchar(50) DEFAULT NULL,
  `init_partial_mastec` varchar(50) DEFAULT NULL,
  `init_compl_mastec` varchar(50) DEFAULT NULL,
  `init_corebx` char(1) DEFAULT '',
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `bc_nbi_txd_surgeries_at_dx_revs`;
CREATE TABLE `bc_nbi_txd_surgeries_at_dx_revs` (
  `finsurg` varchar(50) DEFAULT NULL,
  `init_alnd` varchar(50) DEFAULT NULL,
  `init_nodal_proc` varchar(50) DEFAULT NULL,
  `init_partial_mastec` varchar(50) DEFAULT NULL,
  `init_compl_mastec` varchar(50) DEFAULT NULL,
  `init_corebx` char(1) DEFAULT '',
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `bc_nbi_txd_surgeries_at_dx`
  ADD KEY `tx_master_id` (`treatment_master_id`),
  ADD CONSTRAINT `bc_nbi_txd_surgeries_at_dx_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
ALTER TABLE `bc_nbi_txd_surgeries_at_dx_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("bc_nbi_surg_finsurg", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("0 - no initial breast surg", "0 - no initial breast surg"),
("1 - initial bcs", "1 - initial bcs"),
("2 - initial complete mastect", "2 - initial complete mastect");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_finsurg"), (SELECT id FROM structure_permissible_values WHERE value="0 - no initial breast surg" AND language_alias="0 - no initial breast surg"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_finsurg"), (SELECT id FROM structure_permissible_values WHERE value="1 - initial bcs" AND language_alias="1 - initial bcs"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_finsurg"), (SELECT id FROM structure_permissible_values WHERE value="2 - initial complete mastect" AND language_alias="2 - initial complete mastect"), "1", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("bc_nbi_surg_init_alnd", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("0 - no alnd performed", "0 - no alnd performed"),
("1 - alnd performed", "1 - alnd performed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_alnd"), (SELECT id FROM structure_permissible_values WHERE value="0 - no alnd performed" AND language_alias="0 - no alnd performed"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_alnd"), (SELECT id FROM structure_permissible_values WHERE value="1 - alnd performed" AND language_alias="1 - alnd performed"), "1", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("bc_nbi_surg_init_nodal_proc", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("0 - no nodal procedure performed", "0 - no nodal procedure performed"),
("1 - nodal procedure performed", "1 - nodal procedure performed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_nodal_proc"), (SELECT id FROM structure_permissible_values WHERE value="0 - no nodal procedure performed" AND language_alias="0 - no nodal procedure performed"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_nodal_proc"), (SELECT id FROM structure_permissible_values WHERE value="1 - nodal procedure performed" AND language_alias="1 - nodal procedure performed"), "1", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("bc_nbi_surg_init_partial_mastec", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("0 - no partial mastectomy", "0 - no partial mastectomy"),
("1 - partial mastec performed", "1 - partial mastec performed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_partial_mastec"), (SELECT id FROM structure_permissible_values WHERE value="0 - no partial mastectomy" AND language_alias="0 - no partial mastectomy"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_partial_mastec"), (SELECT id FROM structure_permissible_values WHERE value="1 - partial mastec performed" AND language_alias="1 - partial mastec performed"), "1", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("bc_nbi_surg_init_compl_mastec", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("0 - no total/complet mastec", "0 - no total/complet mastec"),
("1 - total/complete mastec", "1 - total/complete mastec");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_compl_mastec"), (SELECT id FROM structure_permissible_values WHERE value="0 - no total/complet mastec" AND language_alias="0 - no total/complet mastec"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_compl_mastec"), (SELECT id FROM structure_permissible_values WHERE value="1 - total/complete mastec" AND language_alias="1 - total/complete mastec"), "1", "1");
INSERT INTO structures(`alias`) VALUES ('bc_nbi_txd_surgeries_at_dx');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_surgeries_at_dx', 'finsurg', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_finsurg') , '0', '', '', '', 'definitive surg at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_surgeries_at_dx', 'init_alnd', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_init_alnd') , '0', '', '', '', 'alnd at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_surgeries_at_dx', 'init_nodal_proc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_init_nodal_proc') , '0', '', '', '', 'nodal proc at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_surgeries_at_dx', 'init_partial_mastec', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_init_partial_mastec') , '0', '', '', '', 'partial mastec at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_surgeries_at_dx', 'init_compl_mastec', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_init_compl_mastec') , '0', '', '', '', 'complete mastec at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_surgeries_at_dx', 'init_corebx', 'yes_no',  NULL , '0', '', '', '', 'core bx at init dx', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '3', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_surgeries_at_dx' AND `field`='finsurg' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_finsurg')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='definitive surg at init dx' AND `language_tag`=''), '2', '20', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_surgeries_at_dx' AND `field`='init_alnd' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_init_alnd')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='alnd at init dx' AND `language_tag`=''), '2', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_surgeries_at_dx' AND `field`='init_nodal_proc' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_init_nodal_proc')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='nodal proc at init dx' AND `language_tag`=''), '2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_surgeries_at_dx' AND `field`='init_partial_mastec' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_init_partial_mastec')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='partial mastec at init dx' AND `language_tag`=''), '2', '23', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_surgeries_at_dx' AND `field`='init_compl_mastec' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_init_compl_mastec')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='complete mastec at init dx' AND `language_tag`=''), '2', '24', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries_at_dx'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_surgeries_at_dx' AND `field`='init_corebx' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='core bx at init dx' AND `language_tag`=''), '2', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('definitive surg at init dx', 'Definitive Surg', ''),
('alnd at init dx', 'ALND', ''),
('nodal proc at init dx', 'Nodal Proc', ''),
('partial mastec at init dx', 'Partial Mastec', ''),
('complete mastec at init dx', 'Complete Mastec', ''),
('core bx at init dx', 'Core Bx', ''),
("0 - no initial breast surg", "0 - No initial breast surg", ''),
("1 - initial bcs", "1 - Initial BCS", ''),
("2 - initial complete mastect", "2 - Initial complete mastect", ''),
("0 - no alnd performed", "0 - No ALND performed", ''),
("1 - alnd performed", "1 - ALND performed", ''),
("0 - no nodal procedure performed", "0 - No nodal procedure performed", ''),
("1 - nodal procedure performed", "1 - Nodal procedure performed", ''),
("0 - no partial mastectomy", "0 - No partial mastectomy", ''),
("1 - partial mastec performed", "1 - Partial mastec performed", ''),
("0 - no total/complet mastec", "0 - No total/complete mastec", ''),
("1 - total/complete mastec", "1 - Total/complete mastec", '');

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='health_status' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="deceased" AND language_alias="deceased");

UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `flag_active`="0" WHERE svd.domain_name='intent' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="neoadjuvant" AND language_alias="neoadjuvant");

UPDATE treatment_controls SET tx_method = CONCAT(tx_method, ' ', disease_site) WHERE disease_site NOt LIKE '' AND flag_Active = 1;
UPDATE treatment_controls SET disease_site = '' WHERE disease_site NOt LIKE '' AND flag_Active = 1;
UPDATE treatment_controls SET databrowser_label = tx_method WHERE  flag_Active = 1;
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('radiotherapy at diagnosis', 'Radiotherapy at Diagnosis', ''),  ('surgery at diagnosis', 'Surgery at Diagnosis', '');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Pre 2003 Physicians');
UPDATE structure_permissible_values_customs SET value = LOWER(en) WHERE control_id = @control_id;
UPDATE structure_permissible_values_customs SET en = SUBSTRING(en,(POSITION(' - ' IN en) + 3),1000) WHERE control_id = @control_id;

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Physician Types');
UPDATE structure_permissible_values_customs SET value = LOWER(en) WHERE control_id = @control_id;

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Treatment Intent', 1, 50, 'clinical - treatment');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Intent');

SET @user_id = 2;

INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("palliative", "Palliative", "Palliatif", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("adjuvant", "Adjuvant", "Adjuvant", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("curative", "Curative", "Curatif", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("diagnostic", "Diagnostic", "Diagnostique", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("other", "Other", "Autre", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("unknown", "Unknown", "Inconnu", "9", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 6, values_counter = 6 WHERE name = 'Treatment Intent';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Treatment Intent\')' WHERE domain_name = 'intent';

SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'intent');

UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Surgery Treatment Plan', 1, 100, 'clinical - treatment');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Surgery Treatment Plan');

SET @user_id = 2;

INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("initial", "Initial", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("subsequent", "Subsequent", "", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 2, values_counter = 2 WHERE name = 'Surgery Treatment Plan';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Surgery Treatment Plan\')' WHERE domain_name = 'bc_nbi_surg_treat_plan';

SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'bc_nbi_surg_treat_plan');

UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

UPDATE structure_formats SET `language_heading`='details' WHERE structure_id=(SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='tx_intent' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='intent') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries_at_dx') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='details' WHERE structure_id=(SELECT id FROM structures WHERE alias='bc_nbi_txd_surgeries_at_dx') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_surgeries_at_dx' AND `field`='finsurg' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_surg_finsurg') AND `flag_confidential`='0');

start transaction;
UPDATE structure_permissible_values_custom_controls 
SET flag_active = 1, values_max_length = '50', category = 'clinical - treatment'
WHERE name = 'Surgery Treatment Plan';

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Definitive Surgery', 1, 50, 'clinical - treatment');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Definitive Surgery');

SET @user_id = 2;

INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No initial breast surg", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1", "Initial BCS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("2", "Initial complete mastect", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 3, values_counter = 3 WHERE name = 'Definitive Surgery';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Definitive Surgery\')' WHERE domain_name = 'bc_nbi_surg_finsurg';

SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'bc_nbi_surg_finsurg');

UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('ALND', 1, 50, 'clinical - treatment');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'ALND');

SET @user_id = 2;

INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No ALND performed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1", "ALND performed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 2, values_counter = 2 WHERE name = 'ALND';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'ALND\')' WHERE domain_name = 'bc_nbi_surg_init_alnd';

SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'bc_nbi_surg_init_alnd');

UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Nodal Proc', 1, 50, 'clinical - treatment');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Nodal Proc');

SET @user_id = 2;

INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No nodal procedure performed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1", "Nodal procedure performed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 2, values_counter = 2 WHERE name = 'Nodal Proc';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Nodal Proc\')' WHERE domain_name = 'bc_nbi_surg_init_nodal_proc';

SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'bc_nbi_surg_init_nodal_proc');

UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Partial Mastectomy', 1, 50, 'clinical - treatment');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Partial Mastectomy');

SET @user_id = 2;

INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No partial mastectomy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1", "Partial mastec performed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 2, values_counter = 2 WHERE name = 'Partial Mastectomy';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Partial Mastectomy\')' WHERE domain_name = 'bc_nbi_surg_init_partial_mastec';

SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'bc_nbi_surg_init_partial_mastec');

UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Complete Mastectomy', 1, 50, 'clinical - treatment');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Complete Mastectomy');

SET @user_id = 2;

INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("0", "No total/complete mastec", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1", "Total/complete mastec", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

UPDATE structure_permissible_values_custom_controls 
 SET values_used_as_input_counter = 2, values_counter = 2 WHERE name = 'Complete Mastectomy';

UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Complete Mastectomy\')' WHERE domain_name = 'bc_nbi_surg_init_compl_mastec';

SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'bc_nbi_surg_init_compl_mastec');

UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

-- Biopsy

INSERT INTO `treatment_controls` (`id`, `tx_method`, `disease_site`, `flag_active`, `detail_tablename`, `detail_form_alias`, `display_order`, `applied_protocol_control_id`, `extended_data_import_process`, `databrowser_label`, `flag_use_for_ccl`, `treatment_extend_control_id`, `use_addgrid`, `use_detail_form_for_index`) VALUES
(null, 'biopsy', '', 1, 'bc_nbi_txd_biopsies', 'bc_nbi_txd_biopsies', 0, NULL, NULL, 'biopsy', 1, NULL, 0, 1);
DROP TABLE IF EXISTS `bc_nbi_txd_biopsies`;
CREATE TABLE `bc_nbi_txd_biopsies` (
   init_corebx_type varchar(50) DEFAULT NULL,
   init_fwlbx char(1) DEFAULT '',
   init_fwlbx_date date DEFAULT NULL,
   init_fwlbx_date_accuracy char(1) NOT NULL DEFAULT '',
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS `bc_nbi_txd_biopsies_revs`;
CREATE TABLE `bc_nbi_txd_biopsies_revs` (
   init_corebx_type varchar(50) DEFAULT NULL,
   init_fwlbx char(1) DEFAULT '',
   init_fwlbx_date date DEFAULT NULL,
   init_fwlbx_date_accuracy char(1) NOT NULL DEFAULT '',
  `treatment_master_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `bc_nbi_txd_biopsies`
  ADD KEY `tx_master_id` (`treatment_master_id`),
  ADD CONSTRAINT `bc_nbi_txd_biopsies_ibfk_1` FOREIGN KEY (`treatment_master_id`) REFERENCES `treatment_masters` (`id`);
ALTER TABLE `bc_nbi_txd_biopsies_revs`
  ADD PRIMARY KEY (`version_id`),
  MODIFY `version_id` int(11) NOT NULL AUTO_INCREMENT;
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Biopsy Types', 1, 50, 'clinical - treatment');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Biopsy Types');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("S", "Stereotactic", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("US", "Ultrasound", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("P", "Palpable", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("U", "Unknown", "", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls 
SET values_max_length = 50, values_used_as_input_counter = 4, values_counter = 4 WHERE name = 'Biopsy Types';
INSERT INTO structure_value_domains (domain_name, override, category, source) values
('bc_nbi_init_corebx_type', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Biopsy Types\')');
UPDATE structure_permissible_values_customs SET `value` = LOWER(`value`) WHERE control_id = @control_id;
INSERT INTO structures(`alias`) VALUES ('bc_nbi_txd_biopsies');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_biopsies', 'init_corebx_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_init_corebx_type') , '0', '', '', '', 'type', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_biopsies', 'init_fwlbx', 'yes_no',  NULL , '0', '', '', 'bc_nbi_help_init_fwlbx', 'fwl', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_biopsies', 'init_fwlbx_date', 'date',  NULL , '0', '', '', '', 'fwl date', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '99', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_biopsies' AND `field`='init_corebx_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_init_corebx_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '2', '10', 'details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_biopsies' AND `field`='init_fwlbx' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_help_init_fwlbx' AND `language_label`='fwl' AND `language_tag`=''), '2', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_biopsies' AND `field`='init_fwlbx_date' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='fwl date' AND `language_tag`=''), '2', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('fwl', 'FWL', ''),
('fwl date', 'FWL Date', ''),
('biopsy', 'Biopsy', 'Biospie'),
("bc_nbi_help_init_fwlbx", "In the case that the location of the breast mass cannot be felt, this indicates whether the radiologists used a very fine needle to target the breast abnormality in order for the surgeon to remove the right tissue for biopsy. Non-referred manually abstracted cases.", "");

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('you are not allowed to define a particpant as a participant of the retrospecitve bank', 'You are not allowed to define a particpant as a participant of the retrospecitve bank.', '');

UPDATE versions SET branch_build_number = '7578' WHERE version_number = '2.7.0';

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('you are not allowed to create a confidential contact for retrospective bank participant', "You are not allowed to create a confidential contact for retrospective bank participant.", "");

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Diagnosis
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `detail_form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'primary', 'bcca tumor registery', 1, 'dx_primary,bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_diagnosis', 0, 'primary|bcca tumor registery', 0);
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary');
UPDATE structure_fields SET  `language_help`='help_memo' WHERE model='DiagnosisMaster' AND tablename='diagnosis_masters' AND field='notes' AND `type`='textarea' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

DROP TABLE IF EXISTS bc_nbi_bcca_diagnosis;
CREATE TABLE `bc_nbi_bcca_diagnosis` (
  `diagnosis_master_id` int(11) NOT NULL,
  `bc_nbi_bcca_site_num` int(4)  DEFAULT NULL,
  `bc_nbi_bcca_ref` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_dataset` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_site_admit_date`  date DEFAULT NULL,
  `bc_nbi_bcca_status_at_referral` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_status_at_referral_desc` varchar(20)  DEFAULT NULL,
  `bc_nbi_bcca_registry_group` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_diag_type` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_diag_type_desc` varchar(50)  DEFAULT NULL,
  `bc_nbi_bcca_loc_at_admit` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_loc_at_admit_desc` varchar(30)  DEFAULT NULL,
  `bc_nbi_bcca_loc_at_diag` varchar(16)  DEFAULT NULL,
  `bc_nbi_bcca_loc_at_diag_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_dx_hlth_auth` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_dx_hlth_auth_desc` varchar(20)  DEFAULT NULL,
  `bc_nbi_bcca_dx_hsda` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_dx_hsda_desc` varchar(25)  DEFAULT NULL,
  `bc_nbi_bcca_dx_hsda_cc` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_dx_local_health_area` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_dx_lha_desc` varchar(25)  DEFAULT NULL,
  `bc_nbi_bcca_dx_lha_cc` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_dx_post_code` varchar(6)  DEFAULT NULL,
  `bc_nbi_bcca_number_fst_deg_relatives` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_performance_status` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_performance_status_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_laterality` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_laterality_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_site_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_behavior` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_behavior_desc` varchar(40)  DEFAULT NULL,
  `bc_nbi_bcca_hist1` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_hist1_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_hist2` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_hist2_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_hist3` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_hist3_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_grade_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_grade_type_p00005` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_br_grade_type_p00005_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_overall_stg` int(8)  DEFAULT NULL,
  `bc_nbi_bcca_overall_clin_stg` int(8)  DEFAULT NULL,
  `bc_nbi_bcca_cT` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_cN` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_pT` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_pN` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_overall_path_stg` int(8)  DEFAULT NULL,
  `bc_nbi_bcca_M_STG` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_neoadjuvant` tinyint(1) DEFAULT '0',
  `bc_nbi_bcca_tnm_clin_yr` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_t` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_t_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_n` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_n_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_m` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_m_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_yr` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_t` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_t_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_n` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_n_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_m` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_m_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_Edition` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_T_clin` varchar(15)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_N_clin` varchar(15)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_M_clin` varchar(15)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_T_path` varchar(16)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_N_path` varchar(16)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_M_path` varchar(16)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf3` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf4` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf5` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf6` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf7` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf8` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf9` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf10` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf11` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf12` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf13` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf14` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf16` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf19` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf22` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf23` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_overlap_lesion_onco` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_overlap_lesion_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_multicentbrstca_onco` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_multicentbrstca_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_multifocbrstca_onco` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_multifocbrstca_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tum_size` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_final_margins` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_nodestat` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_posnodes` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_totnodes` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_COL_nodes` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_COL_nodes_eval` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_ECE_final` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_radiologicconfirmFWL_onco` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_radiologicconfirmFWL_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_recon_final` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_surgspecimenoriented_onco` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_surgspecimenoriented_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_postr_deepmarg_onco` varchar(50)  DEFAULT NULL,
  `bc_nbi_bcca_br_postr_deepmarg_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_ant_tiss_onco` varchar(50)  DEFAULT NULL,
  `bc_nbi_bcca_br_ant_tiss_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_clipmarkingbxcavity_onco` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_clipmarkingbxcavity_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_closeposmargintype_onco` varchar(37)  DEFAULT NULL,
  `bc_nbi_bcca_br_closeposmargintype_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_totsentnodes` int(8)  DEFAULT NULL,
  `bc_nbi_bcca_possentnodes` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_negsentnodes` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_SLNB` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_SLNB_YesNo` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_sentinel_lymph_node_bx_date_p00005`  date DEFAULT NULL,
  `bc_nbi_bcca_lvn_final` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_erposneg` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_er` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_pgrposneg` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_her2_date`  date DEFAULT NULL,
  `bc_nbi_bcca_her2_final` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_her2tissuesite` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_her2lab_initdx` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_her2neulabatrecur_onco` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_her2neulabatrecur_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_fst_treat_date`  date DEFAULT NULL,
  `bc_nbi_bcca_not_treated` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_not_treated_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_localtx` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_systx` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_init_chemo` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_chemoreg` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_chemotype_p00005` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_chemotype_p00005_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_chemoreg_onco` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_chemoreg_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_init_horm` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_hormreg` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_horm_type_p00005` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_horm_type_p00005_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_hormreg_onco` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_hormreg_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_init_targ_therapy` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_targthx` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_immunotherapy_p00005` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_immunotherapy_p00005_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_targtherapy_onco` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_targtherapy_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_M1atDx` varchar(11)  DEFAULT NULL,
  `bc_nbi_bcca_M1DXDATE`  date DEFAULT NULL,
  `bc_nbi_bcca_M1SITEDX` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_M1sitedx_desc` varchar(40)  DEFAULT NULL,
  `bc_nbi_bcca_fst_relapse_date`  date DEFAULT NULL,
  `bc_nbi_bcca_locoreg_relapse_date`  date DEFAULT NULL,
  `bc_nbi_bcca_loc_ind` tinyint(1) DEFAULT '0',
  `bc_nbi_bcca_loc_type` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_loc_date`  date DEFAULT NULL,
  `bc_nbi_bcca_loc_site` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_loc_site_desc` text DEFAULT NULL,
  `bc_nbi_bcca_reg_ind` tinyint(1) DEFAULT '0',
  `bc_nbi_bcca_reg_date`  date DEFAULT NULL,
  `bc_nbi_bcca_reg_site` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_reg_site_desc` varchar(40)  DEFAULT NULL,
  `bc_nbi_bcca_dist_ind` tinyint(1) DEFAULT '0',
  `bc_nbi_bcca_dist_date`  date DEFAULT NULL,
  `bc_nbi_bcca_dist_site` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_dist_site_desc` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS bc_nbi_bcca_diagnosis_revs;
CREATE TABLE `bc_nbi_bcca_diagnosis_revs` (
  `diagnosis_master_id` int(11) NOT NULL,
  `bc_nbi_bcca_site_num` int(4)  DEFAULT NULL,
  `bc_nbi_bcca_ref` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_dataset` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_site_admit_date`  date DEFAULT NULL,
  `bc_nbi_bcca_status_at_referral` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_status_at_referral_desc` varchar(20)  DEFAULT NULL,
  `bc_nbi_bcca_registry_group` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_diag_type` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_diag_type_desc` varchar(50)  DEFAULT NULL,
  `bc_nbi_bcca_loc_at_admit` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_loc_at_admit_desc` varchar(30)  DEFAULT NULL,
  `bc_nbi_bcca_loc_at_diag` varchar(16)  DEFAULT NULL,
  `bc_nbi_bcca_loc_at_diag_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_dx_hlth_auth` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_dx_hlth_auth_desc` varchar(20)  DEFAULT NULL,
  `bc_nbi_bcca_dx_hsda` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_dx_hsda_desc` varchar(25)  DEFAULT NULL,
  `bc_nbi_bcca_dx_hsda_cc` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_dx_local_health_area` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_dx_lha_desc` varchar(25)  DEFAULT NULL,
  `bc_nbi_bcca_dx_lha_cc` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_dx_post_code` varchar(6)  DEFAULT NULL,
  `bc_nbi_bcca_number_fst_deg_relatives` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_performance_status` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_performance_status_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_laterality` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_laterality_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_site_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_behavior` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_behavior_desc` varchar(40)  DEFAULT NULL,
  `bc_nbi_bcca_hist1` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_hist1_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_hist2` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_hist2_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_hist3` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_hist3_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_grade_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_grade_type_p00005` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_br_grade_type_p00005_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_overall_stg` int(8)  DEFAULT NULL,
  `bc_nbi_bcca_overall_clin_stg` int(8)  DEFAULT NULL,
  `bc_nbi_bcca_cT` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_cN` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_pT` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_pN` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_overall_path_stg` int(8)  DEFAULT NULL,
  `bc_nbi_bcca_M_STG` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_neoadjuvant` tinyint(1) DEFAULT '0',
  `bc_nbi_bcca_tnm_clin_yr` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_t` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_t_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_n` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_n_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_m` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_clin_m_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_yr` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_t` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_t_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_n` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_n_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_m` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_tnm_surg_m_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_Edition` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_T_clin` varchar(15)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_N_clin` varchar(15)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_M_clin` varchar(15)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_T_path` varchar(16)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_N_path` varchar(16)  DEFAULT NULL,
  `bc_nbi_bcca_COL_AJCC_M_path` varchar(16)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf3` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf4` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf5` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf6` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf7` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf8` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf9` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf10` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf11` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf12` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf13` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf14` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf16` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf19` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf22` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_col_ssf23` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_overlap_lesion_onco` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_overlap_lesion_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_multicentbrstca_onco` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_multicentbrstca_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_multifocbrstca_onco` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_multifocbrstca_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_tum_size` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_final_margins` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_nodestat` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_posnodes` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_totnodes` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_COL_nodes` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_COL_nodes_eval` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_ECE_final` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_radiologicconfirmFWL_onco` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_radiologicconfirmFWL_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_recon_final` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_surgspecimenoriented_onco` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_surgspecimenoriented_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_postr_deepmarg_onco` varchar(50)  DEFAULT NULL,
  `bc_nbi_bcca_br_postr_deepmarg_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_ant_tiss_onco` varchar(50)  DEFAULT NULL,
  `bc_nbi_bcca_br_ant_tiss_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_clipmarkingbxcavity_onco` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_clipmarkingbxcavity_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_closeposmargintype_onco` varchar(37)  DEFAULT NULL,
  `bc_nbi_bcca_br_closeposmargintype_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_totsentnodes` int(8)  DEFAULT NULL,
  `bc_nbi_bcca_possentnodes` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_negsentnodes` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_SLNB` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_SLNB_YesNo` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_sentinel_lymph_node_bx_date_p00005`  date DEFAULT NULL,
  `bc_nbi_bcca_lvn_final` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_erposneg` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_er` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_pgrposneg` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_her2_date`  date DEFAULT NULL,
  `bc_nbi_bcca_her2_final` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_her2tissuesite` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_her2lab_initdx` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_her2neulabatrecur_onco` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_her2neulabatrecur_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_fst_treat_date`  date DEFAULT NULL,
  `bc_nbi_bcca_not_treated` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_not_treated_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_localtx` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_systx` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_init_chemo` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_chemoreg` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_chemotype_p00005` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_chemotype_p00005_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_chemoreg_onco` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_chemoreg_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_init_horm` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_hormreg` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_horm_type_p00005` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_horm_type_p00005_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_hormreg_onco` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_hormreg_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_init_targ_therapy` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_targthx` varchar(8)  DEFAULT NULL,
  `bc_nbi_bcca_br_immunotherapy_p00005` varchar(2)  DEFAULT NULL,
  `bc_nbi_bcca_br_immunotherapy_p00005_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_targtherapy_onco` varchar(3)  DEFAULT NULL,
  `bc_nbi_bcca_br_initl_targtherapy_onco_desc` varchar(100)  DEFAULT NULL,
  `bc_nbi_bcca_M1atDx` varchar(11)  DEFAULT NULL,
  `bc_nbi_bcca_M1DXDATE`  date DEFAULT NULL,
  `bc_nbi_bcca_M1SITEDX` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_M1sitedx_desc` varchar(40)  DEFAULT NULL,
  `bc_nbi_bcca_fst_relapse_date`  date DEFAULT NULL,
  `bc_nbi_bcca_locoreg_relapse_date`  date DEFAULT NULL,
  `bc_nbi_bcca_loc_ind` tinyint(1) DEFAULT '0',
  `bc_nbi_bcca_loc_type` varchar(1)  DEFAULT NULL,
  `bc_nbi_bcca_loc_date`  date DEFAULT NULL,
  `bc_nbi_bcca_loc_site` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_loc_site_desc` text DEFAULT NULL,
  `bc_nbi_bcca_reg_ind` tinyint(1) DEFAULT '0',
  `bc_nbi_bcca_reg_date`  date DEFAULT NULL,
  `bc_nbi_bcca_reg_site` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_reg_site_desc` varchar(40)  DEFAULT NULL,
  `bc_nbi_bcca_dist_ind` tinyint(1) DEFAULT '0',
  `bc_nbi_bcca_dist_date`  date DEFAULT NULL,
  `bc_nbi_bcca_dist_site` varchar(5)  DEFAULT NULL,
  `bc_nbi_bcca_dist_site_desc` text DEFAULT NULL,
  `version_id` int(11) NOT NULL,
  `version_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `bc_nbi_bcca_diagnosis`
  ADD CONSTRAINT `bc_nbi_bcca_diagnosis_ibfk_1` FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('bc_nbi_bcca_diagnosis');





















INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) 
VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_site_num', 'integer',  NULL , '0', 'size=4', '', 'bc_nbi_help_bcca_site_num', 'site #', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_ref', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_ref') , '0', '', '', 'bc_nbi_help_bcca_ref', 'referred case', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dataset', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_dataset') , '0', '', '', 'bc_nbi_help_bcca_dataset', 'nha case', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_site_admit_date', 'date',  NULL , '0', '', '', 'bc_nbi_help_bcca_site_admit_date', 'admit date', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_status_at_referral', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_status_at_referral') , '0', '', '', 'bc_nbi_help_bcca_status_at_referral', 'status at referral', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_status_at_referral_desc', 'input',  NULL , '0', 'size=20', '', 'bc_nbi_help_bcca_status_at_referral_desc', 'referral status desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_registry_group', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_registry_group') , '0', '', '', 'bc_nbi_help_bcca_registry_group', 'province of residence', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_diag_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_diag_type') , '0', '', '', 'bc_nbi_help_bcca_diag_type', 'coding status', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_diag_type_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_diag_type_desc', 'coding status desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_loc_at_admit', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_loc_at_admit & location') , '0', '', '', 'bc_nbi_help_bcca_loc_at_admit', 'location at admit', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_loc_at_admit_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_loc_at_admit_desc', 'location at admit desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_loc_at_diag', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_loc_at_diag') , '0', '', '', 'bc_nbi_help_bcca_loc_at_diag', 'postal code at diagnosis', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_loc_at_diag_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_loc_at_diag_desc', 'postal code at dx desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dx_hlth_auth', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_hlth_auth') , '0', '', '', 'bc_nbi_help_bcca_dx_hlth_auth', 'health authority at diagnosis', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dx_hlth_auth_desc', 'input',  NULL , '0', 'size=20', '', 'bc_nbi_help_bcca_dx_hlth_auth_desc', 'health authority at diagnosis desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dx_hsda', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_hsda') , '0', '', '', 'bc_nbi_help_bcca_dx_hsda', 'hsda at diagnosis', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dx_hsda_desc', 'input',  NULL , '0', 'size=25', '', 'bc_nbi_help_bcca_dx_hsda_desc', 'hsda at diagnosis desc', ''),
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dx_hsda_cc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_cancer_center') , '0', '', '', 'bc_nbi_help_bcca_dx_hsda_cc', 'cancer center for hsda at diagnosis', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dx_local_health_area', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_local_health_area') , '0', '', '', 'bc_nbi_help_bcca_dx_local_health_area', 'local health area at diagnosis', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dx_lha_desc', 'input',  NULL , '0', 'size=25', '', 'bc_nbi_help_bcca_dx_lha_desc', 'local health area at diagnosis desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dx_lha_cc', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_cancer_center') , '0', '', '', 'bc_nbi_help_bcca_dx_lha_cc', 'cancer center for local health area at diagnosis', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dx_post_code', 'input',  NULL , '0', 'size=6', '', 'bc_nbi_help_bcca_dx_post_code', 'postal code at diagnosis', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_number_fst_deg_relatives', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_num_fst_deg_relatives') , '0', '', '', 'bc_nbi_help_bcca_number_fst_deg_relatives', '# relatives br ca', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_performance_status', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_performance_status') , '0', '', '', 'bc_nbi_help_bcca_performance_status', 'performance status', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_performance_status_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_performance_status_desc', 'performance status desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_laterality') , '0', '', '', 'bc_nbi_help_bcca_laterality', 'laterality', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_laterality_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_laterality_desc', 'laterality desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_site_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_site_desc', 'tumour site desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_behavior', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_tumour_behavior') , '0', '', '', 'bc_nbi_help_bcca_behavior', 'tumour behaviour', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_behavior_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_behavior_desc', 'tumour behaviour desc', ''),
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_hist1', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/topo,tool=/CodingIcd/CodingIcdo3s/tool/topo', '', 'bc_nbi_help_bcca_hist1', 'histology code1', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_hist1_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_hist1_desc', 'histology code1 desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_hist2', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/topo,tool=/CodingIcd/CodingIcdo3s/tool/topo', '', 'bc_nbi_help_bcca_hist2', 'histology code2', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_hist2_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_hist2_desc', 'histology code2 desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_hist3', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/topo,tool=/CodingIcd/CodingIcdo3s/tool/topo', '', 'bc_nbi_help_bcca_hist3', 'histology code3', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_hist3_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_hist3_desc', 'histology code3 desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_grade_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_grade_desc', 'tumour grade desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_grade_type_p00005', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_grade_type') , '0', '', '', 'bc_nbi_help_bcca_br_grade_type_p00005', 'tumour grade type', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_grade_type_p00005_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_grade_type_p00005_desc', 'tumour grade type desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_overall_stg', 'integer',  NULL , '0', 'size=8', '', 'bc_nbi_help_bcca_overall_stg', 'overall stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_overall_clin_stg', 'integer',  NULL , '0', 'size=8', '', 'bc_nbi_help_bcca_overall_clin_stg', 'overall  clinical stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_cT', 'input',  NULL , '0', 'size=5', '', 'bc_nbi_help_bcca_cT', 'clinical t stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_cN', 'input',  NULL , '0', 'size=5', '', 'bc_nbi_help_bcca_cN', 'clinical n stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_pT', 'input',  NULL , '0', 'size=5', '', 'bc_nbi_help_bcca_pT', 'pathologic t stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_pN', 'input',  NULL , '0', 'size=8', '', 'bc_nbi_help_bcca_pN', 'pathologic n stage', ''),
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_overall_path_stg', 'integer',  NULL , '0', 'size=8', '', 'bc_nbi_help_bcca_overall_path_stg', 'overall pathologic stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_M_STG', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_M_STG') , '0', '', '', 'bc_nbi_help_bcca_M_STG', 'metastases', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_neoadjuvant', 'checkbox',  NULL , '0', '', '', 'bc_nbi_help_bcca_neoadjuvant', 'neoadjuvant treatment', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_clin_yr', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_UICC_TNM_staging_system') , '0', '', '', 'bc_nbi_help_bcca_tnm_clin_yr', 'tnm clinical year', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_clin_t', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_tnm_clin_t') , '0', '', '', 'bc_nbi_help_bcca_tnm_clin_t', 'tnm clinical t stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_clin_t_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_tnm_clin_t_desc', 'tnm clinical t stage desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_clin_n', 'input',  NULL , '0', 'size=3', '', 'bc_nbi_help_bcca_tnm_clin_n', 'tnm clinical n stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_clin_n_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_tnm_clin_n_desc', 'tnm clinical n stage desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_clin_m', 'input',  NULL , '0', 'size=3', '', 'bc_nbi_help_bcca_tnm_clin_m', 'tnm clinical m stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_clin_m_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_tnm_clin_m_desc', 'tnm clinical m stage desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_surg_yr', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_UICC_TNM_staging_system') , '0', '', '', 'bc_nbi_help_bcca_tnm_surg_yr', 'tnm pathologic year', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_surg_t', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_tnm_surg_t') , '0', '', '', 'bc_nbi_help_bcca_tnm_surg_t', 'tnm pathologic t stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_surg_t_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_tnm_surg_t_desc', 'tnm pathologic t stage desc', ''),
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_surg_n', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_tnm_surg_n') , '0', '', '', 'bc_nbi_help_bcca_tnm_surg_n', 'tnm pathologic n stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_surg_n_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_tnm_surg_n_desc', 'tnm pathologic n stage desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_surg_m', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_tnm_surg_m') , '0', '', '', 'bc_nbi_help_bcca_tnm_surg_m', 'tnm pathologic m stage', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tnm_surg_m_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_tnm_surg_m_desc', 'tnm pathologic m stage desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_COL_AJCC_Edition', 'input',  NULL , '0', 'size=1', '', 'bc_nbi_help_bcca_COL_AJCC_Edition', 'ajcc staging manual edition', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_COL_AJCC_T_clin', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_COL_AJCC_T_clin') , '0', '', '', 'bc_nbi_help_bcca_COL_AJCC_T_clin', 'cs clinical t', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_COL_AJCC_N_clin', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_COL_AJCC_N_clin') , '0', '', '', 'bc_nbi_help_bcca_COL_AJCC_N_clin', 'cs clinical n', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_COL_AJCC_M_clin', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_COL_AJCC_M_clin') , '0', '', '', 'bc_nbi_help_bcca_COL_AJCC_M_clin', 'cs clinical m', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_COL_AJCC_T_path', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_COL_AJCC_T_path') , '0', '', '', 'bc_nbi_help_bcca_COL_AJCC_T_path', 'cs pathologic t', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_COL_AJCC_N_path', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_COL_AJCC_N_path') , '0', '', '', 'bc_nbi_help_bcca_COL_AJCC_N_path', 'cs pathologic n', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_COL_AJCC_M_path', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_COL_AJCC_M_path') , '0', '', '', 'bc_nbi_help_bcca_COL_AJCC_M_path', 'cs pathologic m', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf3', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf3') , '0', '', '', 'bc_nbi_help_bcca_col_ssf3', 'cs ssf3 # positive ipsilateral aln', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf4', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf4') , '0', '', '', 'bc_nbi_help_bcca_col_ssf4', 'cs ssf4 ihc of regional ln', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf5', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf5') , '0', '', '', 'bc_nbi_help_bcca_col_ssf5', 'cs ssf5 mol studies of rln', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf6', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf6') , '0', '', '', 'bc_nbi_help_bcca_col_ssf6', 'cs ssf6 size of tumour - invasive component', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf7', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf7') , '0', '', '', 'bc_nbi_help_bcca_col_ssf7', 'cs ssf7 nottingham or br score/grade', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf8', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf8') , '0', '', '', 'bc_nbi_help_bcca_col_ssf8', 'cs ssf8 her2:  ihc lab value', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf9', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf9') , '0', '', '', 'bc_nbi_help_bcca_col_ssf9', 'cs ssf9 her2: ihc test interpretation', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf10', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf10') , '0', '', '', 'bc_nbi_help_bcca_col_ssf10', 'cs ssf10 her2: fish lab value', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf11', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf11') , '0', '', '', 'bc_nbi_help_bcca_col_ssf11', 'cs ssf11 her2: fish test interpretation', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf12', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf12') , '0', '', '', 'bc_nbi_help_bcca_col_ssf12', 'cs ssf12 her2: cish lab value', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf13', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf13') , '0', '', '', 'bc_nbi_help_bcca_col_ssf13', 'cs ssf13 her2: cish test interpretation', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf14', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf14') , '0', '', '', 'bc_nbi_help_bcca_col_ssf14', 'cs ssf14 her2 result of other or unknown test', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf16', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf16') , '0', '', '', 'bc_nbi_help_bcca_col_ssf16', 'cs ssf16 combinations of er, pr, and her2 results', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf19', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf19') , '0', '', '', 'bc_nbi_help_bcca_col_ssf19', 'cs ssf19 assesment of positive ipsilateral aln', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf22', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf22') , '0', '', '', 'bc_nbi_help_bcca_col_ssf22', 'cs ssf22 multigene signature method', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_col_ssf23', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_col_ssf23') , '0', '', '', 'bc_nbi_help_bcca_col_ssf23', 'cs ssf23 multigene signature results', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_overlap_lesion_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_overlap_lesion_onco') , '0', '', '', 'bc_nbi_help_bcca_br_overlap_lesion_onco', 'overlapping lesion', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_overlap_lesion_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_overlap_lesion_onco_desc', 'overlapping leion desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_multicentbrstca_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_multicentbrstca_onco') , '0', '', '', 'bc_nbi_help_bcca_br_multicentbrstca_onco', 'multicentric breast ca', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_multicentbrstca_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_multicentbrstca_onco_desc', 'multicentric breast ca desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_multifocbrstca_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_multifocbrstca_onco') , '0', '', '', 'bc_nbi_help_bcca_br_multifocbrstca_onco', 'multifocal breast ca', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_multifocbrstca_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_multifocbrstca_onco_desc', 'multifocal breast ca desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_tum_size', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_tum_size') , '0', '', '', 'bc_nbi_help_bcca_tum_size', 'tumour size', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_final_margins', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_neg_pos_close_unknown') , '0', '', '', 'bc_nbi_help_bcca_final_margins', 'margin status at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_nodestat', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_nodestat') , '0', '', '', 'bc_nbi_help_bcca_nodestat', 'nodal status at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_posnodes', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_posnodes') , '0', '', '', 'bc_nbi_help_bcca_posnodes', '# positive nodes at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_totnodes', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_totnodes') , '0', '', '', 'bc_nbi_help_bcca_totnodes', '# total nodes at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_COL_nodes', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_COL_nodes') , '0', '', '', 'bc_nbi_help_bcca_COL_nodes', 'cs regional ln involved at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_COL_nodes_eval', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_COL_nodes_eval') , '0', '', '', 'bc_nbi_help_bcca_COL_nodes_eval', 'cs n category staging basis', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_ECE_final', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_ECE_final') , '0', '', '', 'bc_nbi_help_bcca_ECE_final', 'ece', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_radiologicconfirmFWL_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_radiologicconfirmFWL_onco') , '0', '', '', 'bc_nbi_help_bcca_br_radiologicconfirmFWL_onco', 'radiologic confirm fwl', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_radiologicconfirmFWL_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_radiologicconfirmFWL_onco_desc', 'radiologic confirm fwl desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_recon_final', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_recon_final') , '0', '', '', 'bc_nbi_help_bcca_recon_final', 'reconstruction surgery', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_surgspecimenoriented_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_surgspecimenoriented_onco') , '0', '', '', 'bc_nbi_help_bcca_br_surgspecimenoriented_onco', 'surg specimen oriented', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_surgspecimenoriented_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_surgspecimenoriented_onco_desc', 'surg specimen oriented desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_postr_deepmarg_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_postr_deepmarg_onco') , '0', '', '', 'bc_nbi_help_bcca_br_postr_deepmarg_onco', 'posterior or deep  margin', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_postr_deepmarg_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_postr_deepmarg_onco_desc', 'posterior or deep margin desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_ant_tiss_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_ant_tiss_onco') , '0', '', '', 'bc_nbi_help_bcca_br_ant_tiss_onco', 'anterior tissue remaining', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_ant_tiss_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_ant_tiss_onco_desc', 'anterior tissue remaining desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_clipmarkingbxcavity_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_clipmarkingbxcavity_onco') , '0', '', '', 'bc_nbi_help_bcca_br_clipmarkingbxcavity_onco', 'clips used to mark cavity bcs', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_clipmarkingbxcavity_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_clipmarkingbxcavity_onco_desc', 'clips used to mark cavity bcs desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_closeposmargintype_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_closeposmargintype_onco') , '0', '', '', 'bc_nbi_help_bcca_br_closeposmargintype_onco', 'close or pos margin type', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_closeposmargintype_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_closeposmargintype_onco_desc', 'close or pos margin type desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_totsentnodes', 'integer',  NULL , '0', 'size=8', '', 'bc_nbi_help_bcca_totsentnodes', '# of sentinel ln', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_possentnodes', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_sentnodes') , '0', '', '', 'bc_nbi_help_bcca_possentnodes', '# of pos sentinel ln', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_negsentnodes', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_sentnodes') , '0', '', '', 'bc_nbi_help_bcca_negsentnodes', '# of neg sentinel ln', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_SLNB', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_SLNB') , '0', '', '', 'bc_nbi_help_bcca_SLNB', 'sentinel lymph node bx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_SLNB_YesNo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_SLNB_yes_no') , '0', '', '', 'bc_nbi_help_bcca_SLNB_YesNo', 'sln bx: y/n ', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_sentinel_lymph_node_bx_date_p00005', 'date',  NULL , '0', '', '', 'bc_nbi_help_bcca_br_sentinel_lymph_node_bx_date_p00005', 'sentinel ln bx date', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_lvn_final', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_neg_pos_unknown') , '0', '', '', 'bc_nbi_help_bcca_lvn_final', 'lvn', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_erposneg', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_neg_pos_unknown') , '0', '', '', 'bc_nbi_help_bcca_erposneg', 'er: pos/neg at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_er', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_er_status') , '0', '', '', 'bc_nbi_help_bcca_er', 'er status at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_pgrposneg', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_neg_pos_unknown') , '0', '', '', 'bc_nbi_help_bcca_pgrposneg', 'pr: pos/neg at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_her2_date', 'date',  NULL , '0', '', '', 'bc_nbi_help_bcca_her2_date', 'her2 date', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_her2_final', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_neg_pos_unknown') , '0', '', '', 'bc_nbi_help_bcca_her2_final', 'her2 at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_her2tissuesite', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_her2_tissuesite') , '0', '', '', 'bc_nbi_help_bcca_her2tissuesite', 'her2 tissue site', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_her2lab_initdx', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_her2neulab_initdx') , '0', '', '', 'bc_nbi_help_bcca_her2lab_initdx', 'her2 lab at dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_her2neulabatrecur_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_her2neulabatrecur_onco') , '0', '', '', 'bc_nbi_help_bcca_br_her2neulabatrecur_onco', 'her2 lab at recurrence', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_her2neulabatrecur_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_her2neulabatrecur_onco_desc', 'her2 lab at recurrence desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_fst_treat_date', 'date',  NULL , '0', '', '', 'bc_nbi_help_bcca_fst_treat_date', 'first treatment date', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_not_treated', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_not_treated') , '0', '', '', 'bc_nbi_help_bcca_not_treated', 'no initial treatment', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_not_treated_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_not_treated_desc', 'no initial treatment desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_localtx', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_localtx') , '0', '', '', 'bc_nbi_help_bcca_localtx', 'local treatment', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_systx', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_systx') , '0', '', '', 'bc_nbi_help_bcca_systx', 'systemic therapy', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_init_chemo', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_init_chemo') , '0', '', '', 'bc_nbi_help_bcca_init_chemo', 'chemo: y/n at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_chemoreg', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_initl_chemoreg') , '0', '', '', 'bc_nbi_help_bcca_br_initl_chemoreg', 'initial chemo regimen', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_chemotype_p00005', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_initl_chemo_type_p00005') , '0', '', '', 'bc_nbi_help_bcca_br_initl_chemotype_p00005', 'chemo at init dx pre 2010', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_chemotype_p00005_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_initl_chemotype_p00005_desc', 'chemo at init dx pre 2010 desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_chemoreg_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_initl_chemoreg') , '0', '', '', 'bc_nbi_help_bcca_br_initl_chemoreg_onco', 'init chemo regimen 2010', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_chemoreg_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_initl_chemoreg_onco_desc', 'init chemo regimen 2010 desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_init_horm', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_init_horm') , '0', '', '', 'bc_nbi_help_bcca_init_horm', 'hormone therapy: y/n at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_hormreg', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_initl_hormreg') , '0', '', '', 'bc_nbi_help_bcca_br_initl_hormreg', 'initial hormone regimen', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_horm_type_p00005', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_initl_horm_type_p00005') , '0', '', '', 'bc_nbi_help_bcca_br_initl_horm_type_p00005', 'horm at init dx pre 2010', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_horm_type_p00005_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_initl_horm_type_p00005_desc', 'horm at init dx pre 2010 desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_hormreg_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_initl_hormreg') , '0', '', '', 'bc_nbi_help_bcca_br_initl_hormreg_onco', 'init horm regimen 2010', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_hormreg_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_initl_hormreg_onco_desc', 'init horm regimen 2010 desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_init_targ_therapy', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_initl_targthx_yn') , '0', '', '', 'bc_nbi_help_bcca_init_targ_therapy', 'targeted therapy: y/n at init dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_targthx', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_initl_targthx') , '0', '', '', 'bc_nbi_help_bcca_br_initl_targthx', 'initial targeted therapy', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_immunotherapy_p00005', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_immunotherapy_p00005') , '0', '', '', 'bc_nbi_help_bcca_br_immunotherapy_p00005', 'targ thx at init dx pre 2010', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_immunotherapy_p00005_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_immunotherapy_p00005_desc', 'targ thx at init dx pre 2010 desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_targtherapy_onco', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_br_initl_targthx') , '0', '', '', 'bc_nbi_help_bcca_br_initl_targtherapy_onco', 'init targ thx 2010', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_br_initl_targtherapy_onco_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_br_initl_targtherapy_onco_desc', 'init targ thx 2010 desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_M1atDx', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_M1atDx') , '0', '', '', 'bc_nbi_help_bcca_M1atDx', 'm1 at dx', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_M1DXDATE', 'date',  NULL , '0', '', '', 'bc_nbi_help_bcca_M1DXDATE', 'm1 date', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_M1SITEDX', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/topo,tool=/CodingIcd/CodingIcdo3s/tool/topo', '', 'bc_nbi_help_bcca_M1SITEDX', 'm1 site', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_M1sitedx_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_M1sitedx_desc', 'm1 site desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_fst_relapse_date', 'date',  NULL , '0', '', '', 'bc_nbi_help_bcca_fst_relapse_date', 'first relapse date', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_locoreg_relapse_date', 'date',  NULL , '0', '', '', 'bc_nbi_help_bcca_locoreg_relapse_date', 'first locoregional relapse date', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_loc_ind', 'checkbox',  NULL , '0', '', '', 'bc_nbi_help_bcca_loc_ind', 'local recurrence', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_loc_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_loc_type') , '0', '', '', 'bc_nbi_help_bcca_loc_type', 'local rec type', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_loc_date', 'date',  NULL , '0', '', '', 'bc_nbi_help_bcca_loc_date', 'loc rec date', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_loc_site', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/topo,tool=/CodingIcd/CodingIcdo3s/tool/topo', '', 'bc_nbi_help_bcca_loc_site', 'loc rec site', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_loc_site_desc', 'textarea',  NULL , '0', 'cols=40,rows=2', '', 'bc_nbi_help_bcca_loc_site_desc', 'loc rec site desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_reg_ind', 'checkbox',  NULL , '0', '', '', 'bc_nbi_help_bcca_reg_ind', 'regional recurrence', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_reg_date', 'date',  NULL , '0', '', '', 'bc_nbi_help_bcca_reg_date', 'reg rec date', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_reg_site', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/topo,tool=/CodingIcd/CodingIcdo3s/tool/topo', '', 'bc_nbi_help_bcca_reg_site', 'reg rec site', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_reg_site_desc', 'input',  NULL , '0', 'size=30', '', 'bc_nbi_help_bcca_reg_site_desc', 'reg rec site desc', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dist_ind', 'checkbox',  NULL , '0', '', '', 'bc_nbi_help_bcca_dist_ind', 'distant recurrence', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dist_date', 'date',  NULL , '0', '', '', 'bc_nbi_help_bcca_dist_date', 'dist rec date', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dist_site', 'autocomplete',  NULL , '0', 'size=10,url=/CodingIcd/CodingIcdo3s/autocomplete/topo,tool=/CodingIcd/CodingIcdo3s/tool/topo', '', 'bc_nbi_help_bcca_dist_site', 'dist rec site', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'bc_nbi_bcca_diagnosis', 'bc_nbi_bcca_dist_site_desc', 'textarea',  NULL , '0', 'cols=40,rows=2', '', 'bc_nbi_help_bcca_dist_site_desc', 'dist rec site desc', '');

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_site_num'), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_ref'), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dataset'), '1', '16', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_site_admit_date'), '1', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_status_at_referral'), '1', '28', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_status_at_referral_desc'), '1', '31', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_diag_type'), '1', '34', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_diag_type_desc'), '1', '37', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_number_fst_deg_relatives'), '1', '40', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_performance_status'), '1', '43', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_performance_status_desc'), '1', '46', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_laterality'), '1', '49', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_laterality_desc'), '1', '52', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_site_desc'), '1', '58', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_behavior'), '1', '61', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_behavior_desc'), '1', '64', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_hist1'), '1', '67', 'coding', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_hist1_desc'), '1', '70', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_hist2'), '1', '73', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_hist2_desc'), '1', '76', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_hist3'), '1', '79', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_hist3_desc'), '1', '82', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_grade_desc'), '1', '88', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_grade_type_p00005'), '1', '91', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_grade_type_p00005_desc'), '1', '94', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_overall_stg'), '1', '97', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_overall_clin_stg'), '1', '100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_cT'), '1', '103', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_cN'), '1', '106', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_pT'), '1', '109', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_pN'), '1', '112', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_overall_path_stg'), '1', '115', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_M_STG'), '1', '118', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_neoadjuvant'), '1', '121', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_clin_yr'), '1', '124', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_clin_t'), '1', '127', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_clin_t_desc'), '1', '130', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_clin_n'), '1', '133', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_clin_n_desc'), '1', '136', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_clin_m'), '1', '139', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_clin_m_desc'), '1', '142', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_surg_yr'), '1', '145', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_surg_t'), '1', '148', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_surg_t_desc'), '1', '151', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_surg_n'), '1', '154', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_surg_n_desc'), '1', '157', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_surg_m'), '1', '160', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tnm_surg_m_desc'), '1', '163', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_COL_AJCC_Edition'), '2', '166', 'collaborative stage', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_COL_AJCC_T_clin'), '2', '169', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_COL_AJCC_N_clin'), '2', '172', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_COL_AJCC_M_clin'), '2', '175', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_COL_AJCC_T_path'), '2', '178', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_COL_AJCC_N_path'), '2', '181', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_COL_AJCC_M_path'), '2', '184', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf3'), '2', '187', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf4'), '2', '190', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf5'), '2', '193', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf6'), '2', '196', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf7'), '2', '199', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf8'), '2', '202', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf9'), '2', '205', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf10'), '2', '208', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf11'), '2', '211', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf12'), '2', '214', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf13'), '2', '217', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf14'), '2', '220', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf16'), '2', '223', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf19'), '2', '226', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf22'), '2', '229', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_col_ssf23'), '2', '232', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_overlap_lesion_onco'), '2', '235', 'surgery/pathology', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_overlap_lesion_onco_desc'), '2', '238', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_multicentbrstca_onco'), '2', '241', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_multicentbrstca_onco_desc'), '2', '244', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_multifocbrstca_onco'), '2', '247', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_multifocbrstca_onco_desc'), '2', '250', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_tum_size'), '2', '253', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_final_margins'), '2', '256', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_nodestat'), '2', '259', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_posnodes'), '2', '262', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_totnodes'), '2', '265', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_COL_nodes'), '2', '268', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_COL_nodes_eval'), '2', '271', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_ECE_final'), '2', '274', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_radiologicconfirmFWL_onco'), '2', '277', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_radiologicconfirmFWL_onco_desc'), '2', '280', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_recon_final'), '2', '283', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_surgspecimenoriented_onco'), '2', '286', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_surgspecimenoriented_onco_desc'), '2', '289', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_postr_deepmarg_onco'), '2', '292', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_postr_deepmarg_onco_desc'), '2', '295', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_ant_tiss_onco'), '2', '298', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_ant_tiss_onco_desc'), '2', '301', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_clipmarkingbxcavity_onco'), '2', '304', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_clipmarkingbxcavity_onco_desc'), '2', '307', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_closeposmargintype_onco'), '2', '310', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_closeposmargintype_onco_desc'), '2', '313', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_totsentnodes'), '2', '316', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_possentnodes'), '2', '319', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_negsentnodes'), '2', '322', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_SLNB'), '2', '325', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_SLNB_YesNo'), '2', '328', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_sentinel_lymph_node_bx_date_p00005'), '2', '331', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_lvn_final'), '2', '334', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_erposneg'), '2', '337', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_er'), '2', '340', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_pgrposneg'), '2', '343', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_her2_date'), '2', '346', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_her2_final'), '2', '349', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_her2tissuesite'), '2', '352', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_her2lab_initdx'), '2', '355', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_her2neulabatrecur_onco'), '2', '358', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_her2neulabatrecur_onco_desc'), '2', '361', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_fst_treat_date'), '3', '364', 'treatment at diagnosis', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_not_treated'), '3', '367', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_not_treated_desc'), '3', '370', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_localtx'), '3', '373', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_systx'), '3', '376', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_init_chemo'), '3', '379', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_chemoreg'), '3', '382', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_chemotype_p00005'), '3', '385', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_chemotype_p00005_desc'), '3', '388', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_chemoreg_onco'), '3', '391', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_chemoreg_onco_desc'), '3', '394', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_init_horm'), '3', '397', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_hormreg'), '3', '400', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_horm_type_p00005'), '3', '403', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_horm_type_p00005_desc'), '3', '406', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_hormreg_onco'), '3', '409', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_hormreg_onco_desc'), '3', '412', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_init_targ_therapy'), '3', '415', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_targthx'), '3', '418', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_immunotherapy_p00005'), '3', '421', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_immunotherapy_p00005_desc'), '3', '424', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_targtherapy_onco'), '3', '427', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_br_initl_targtherapy_onco_desc'), '3', '430', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_M1atDx'), '3', '433', 'progressions', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_M1DXDATE'), '3', '436', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_M1SITEDX'), '3', '439', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_M1sitedx_desc'), '3', '442', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_fst_relapse_date'), '3', '445', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_locoreg_relapse_date'), '3', '448', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_loc_ind'), '3', '451', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_loc_type'), '3', '454', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_loc_date'), '3', '457', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_loc_site'), '3', '460', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_loc_site_desc'), '3', '463', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_reg_ind'), '3', '466', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_reg_date'), '3', '469', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_reg_site'), '3', '472', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_reg_site_desc'), '3', '475', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dist_ind'), '3', '478', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dist_date'), '3', '481', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dist_site'), '3', '484', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dist_site_desc'), '3', '487', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),

((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_registry_group'), '4', '490', 'other', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_loc_at_admit'), '4', '493', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_loc_at_admit_desc'), '4', '496', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_loc_at_diag'), '4', '499', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_loc_at_diag_desc'), '4', '502', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dx_hlth_auth'), '4', '505', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dx_hlth_auth_desc'), '4', '508', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dx_hsda'), '4', '511', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dx_hsda_desc'), '4', '514', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dx_hsda_cc'), '4', '517', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dx_local_health_area'), '4', '520', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dx_lha_desc'), '4', '523', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dx_lha_cc'), '4', '526', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'),
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='bc_nbi_bcca_diagnosis' AND `field`='bc_nbi_bcca_dx_post_code'), '4', '529', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='topography' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '57', '', '0', '1', 'tumor site', '0', '', '1', 'bc_nbi_bcca_help_tumor_site', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_bcca_help_tumor_site', "An International Classification of Diseases for Oncology Third Edition (ICD-O) code which indicates the point of origin from which the primary cancer has arisen.  (Breast sites – C500- C509 with 4th digit BCCA modification).  Breast primary site is determined from the following sources, in the order indicated:  mammogram, staging diagram, surgeon’s consultation report/breast questionnaire operative report/chart notes.", '');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisMaster', 'diagnosis_masters', 'tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_tumour_grade') , '0', '', '', 'bc_nbi_bcca_help_tumour_grade', 'tumour grade', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='age_at_dx' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '1', '6', '', '0', '0', '', '0', '', '1', 'bc_nbi_bcca_help_age_at_dx', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_bcca_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_bcca_tumour_grade')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_bcca_help_tumour_grade' AND `language_label`='tumour grade' AND `language_tag`=''), '1', '87', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_bcca_help_age_at_dx', "The patient’s age at the time the breast cancer was diagnosed. A computer-generated calculated field.", ''),
('bc_nbi_bcca_help_tumour_grade', "The code that describes the system used to identify the Type of grade/differentiation/cell indicator. Invasive grade is recorded when there is a discrepancy between invasive & in-situ.  Where invasive grade is not commented on and only the in-situ component is graded, “9” (unknown) is recorded.", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('treatment at diagnosis', 'Treatment at Diagnosis', ''),
('collaborative stage', 'Collaborative Stage', ''),
('bcca tumor registry', 'BCCA Tumor Registry', ''),
('bcca', 'BCCA', ''),
('progressions', 'Progressions', ''),
('surgery/pathology', 'Surgery/Pathology', '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('site #', 'Site #', ''),
('referred case', 'Referred Case', ''),
('nha case', 'NHA Case', ''),
('admit date', 'Admit Date', ''),
('status at referral', 'Status at Referral', ''),
('referral status desc', 'Referral Status Desc', ''),
('province of residence', 'Province of Residence', ''),
('coding status', 'Coding Status', ''),
('coding status desc', 'Coding Status Desc', ''),
('location at admit', 'Location at Admit', ''),
('location at admit desc', 'Location at Admit Desc', ''),
('postal code at diagnosis', 'Postal Code at Diagnosis', ''),
('postal code at dx desc', 'Postal Code at Dx Desc', ''),
('health authority at diagnosis', 'Health Authority at Diagnosis', ''),
('health authority at diagnosis desc', 'Health Authority at Diagnosis Desc', ''),
('hsda at diagnosis', 'HSDA at Diagnosis', ''),
('hsda at diagnosis desc', 'HSDA at Diagnosis Desc', ''),
('cancer center for hsda at diagnosis', 'Cancer Center for HSDA at Diagnosis', ''),
('local health area at diagnosis', 'Local Health Area at Diagnosis', ''),
('local health area at diagnosis desc', 'Local Health Area at Diagnosis Desc', ''),
('cancer center for local health area at diagnosis', 'Cancer Center for Local Health Area at Diagnosis', ''),
('postal code at diagnosis', 'Postal Code at Diagnosis', ''),
('# relatives br ca', '# Relatives Br Ca', ''),
('performance status', 'Performance Status', ''),
('performance status desc', 'Performance Status Desc', ''),
('laterality', 'Laterality', ''),
('laterality desc', 'Laterality Desc', ''),
('tumour site desc', 'Tumour Site Desc', ''),
('tumour behaviour', 'Tumour Behaviour', ''),
('tumour behaviour desc', 'Tumour Behaviour Desc', ''),
('histology code1', 'Histology Code1', ''),
('histology code1 desc', 'HIstology Code1 Desc', ''),
('histology code2', 'Histology Code2', ''),
('histology code2 desc', 'Histology Code2 Desc', ''),
('histology code3', 'Histology Code3', ''),
('histology code3 desc', 'Histology Code3 Desc', ''),
('tumour grade desc', 'Tumour Grade Desc', ''),
('tumour grade type', 'Tumour Grade Type', ''),
('tumour grade type desc', 'Tumour Grade Type Desc', ''),
('overall stage', 'Overall Stage', ''),
('overall  clinical stage', 'Overall  Clinical Stage', ''),
('clinical t stage', 'Clinical T stage', ''),
('clinical n stage', 'Clinical N stage', ''),
('pathologic t stage', 'Pathologic T stage', ''),
('pathologic n stage', 'Pathologic N stage', ''),
('overall pathologic stage', 'Overall Pathologic Stage', ''),
('metastases', 'Metastases', ''),
('neoadjuvant treatment', 'Neoadjuvant Treatment', ''),
('tnm clinical year', 'TNM Clinical Year', ''),
('tnm clinical t stage', 'TNM Clinical T Stage', ''),
('tnm clinical t stage desc', 'TNM Clinical T Stage Desc', ''),
('tnm clinical n stage', 'TNM Clinical N Stage', ''),
('tnm clinical n stage desc', 'TNM Clinical N Stage Desc', ''),
('tnm clinical m stage', 'TNM Clinical M Stage', ''),
('tnm clinical m stage desc', 'TNM Clinical M Stage Desc', ''),
('tnm pathologic year', 'TNM Pathologic Year', ''),
('tnm pathologic t stage', 'TNM Pathologic T Stage', ''),
('tnm pathologic t stage desc', 'TNM Pathologic T Stage Desc', ''),
('tnm pathologic n stage', 'TNM Pathologic N Stage', ''),
('tnm pathologic n stage desc', 'TNM Pathologic N Stage Desc', ''),
('tnm pathologic m stage', 'TNM Pathologic M Stage', ''),
('tnm pathologic m stage desc', 'TNM Pathologic M Stage Desc', ''),
('ajcc staging manual edition', 'AJCC Staging Manual Edition', ''),
('cs clinical t', 'CS Clinical T', ''),
('cs clinical n', 'CS Clinical N', ''),
('cs clinical m', 'CS Clinical M', ''),
('cs pathologic t', 'CS Pathologic T', ''),
('cs pathologic n', 'CS Pathologic N', ''),
('cs pathologic m', 'CS Pathologic M', ''),
('cs ssf3 # positive ipsilateral aln', 'CS SSF3 # Positive Ipsilateral ALN', ''),
('cs ssf4 ihc of regional ln', 'CS SSF4 IHC of Regional LN', ''),
('cs ssf5 mol studies of rln', 'CS SSF5 MOL Studies of RLN', ''),
('cs ssf6 size of tumour - invasive component', 'CS SSF6 Size of Tumour - Invasive Component', ''),
('cs ssf7 nottingham or br score/grade', 'CS SSF7 Nottingham or BR Score/Grade', ''),
('cs ssf8 her2:  ihc lab value', 'CS SSF8 HER2:  IHC Lab Value', ''),
('cs ssf9 her2: ihc test interpretation', 'CS SSF9 HER2: IHC Test Interpretation', ''),
('cs ssf10 her2: fish lab value', 'CS SSF10 HER2: FISH Lab Value', ''),
('cs ssf11 her2: fish test interpretation', 'CS SSF11 HER2: FISH Test Interpretation', ''),
('cs ssf12 her2: cish lab value', 'CS SSF12 HER2: CISH Lab Value', ''),
('cs ssf13 her2: cish test interpretation', 'CS SSF13 HER2: CISH Test Interpretation', ''),
('cs ssf14 her2 result of other or unknown test', 'CS SSF14 HER2 Result of Other or Unknown Test', ''),
('cs ssf16 combinations of er, pr, and her2 results', 'CS SSF16 Combinations of ER, PR, and HER2 Results', ''),
('cs ssf19 assesment of positive ipsilateral aln', 'CS SSF19 Assesment of Positive Ipsilateral ALN', ''),
('cs ssf22 multigene signature method', 'CS SSF22 Multigene Signature Method', ''),
('cs ssf23 multigene signature results', 'CS SSF23 Multigene Signature Results', ''),
('overlapping lesion', 'Overlapping Lesion', ''),
('overlapping leion desc', 'Overlapping Leion Desc', ''),
('multicentric breast ca', 'Multicentric Breast Ca', ''),
('multicentric breast ca desc', 'Multicentric Breast Ca Desc', ''),
('multifocal breast ca', 'Multifocal Breast Ca', ''),
('multifocal breast ca desc', 'Multifocal Breast Ca Desc', ''),
('tumour size', 'Tumour Size', ''),
('margin status at init dx', 'Margin Status at Init Dx', ''),
('nodal status at init dx', 'Nodal Status at Init Dx', ''),
('# positive nodes at init dx', '# Positive Nodes at Init Dx', ''),
('# total nodes at init dx', '# Total Nodes at Init Dx', ''),
('cs regional ln involved at init dx', 'CS Regional LN Involved at Init Dx', ''),
('cs n category staging basis', 'CS N Category Staging Basis', ''),
('ece', 'ECE', ''),
('radiologic confirm fwl', 'Radiologic Confirm FWL', ''),
('radiologic confirm fwl desc', 'Radiologic Confirm FWL Desc', ''),
('reconstruction surgery', 'Reconstruction Surgery', ''),
('surg specimen oriented', 'Surg Specimen Oriented', ''),
('surg specimen oriented desc', 'Surg Specimen Oriented Desc', ''),
('posterior or deep  margin', 'Posterior or Deep  Margin', ''),
('posterior or deep margin desc', 'Posterior or Deep Margin Desc', ''),
('anterior tissue remaining', 'Anterior Tissue Remaining', ''),
('anterior tissue remaining desc', 'Anterior Tissue Remaining Desc', ''),
('clips used to mark cavity bcs', 'Clips Used to Mark Cavity BCS', ''),
('clips used to mark cavity bcs desc', 'Clips Used to Mark Cavity BCS Desc', ''),
('close or pos margin type', 'Close or Pos Margin Type', ''),
('close or pos margin type desc', 'Close or Pos Margin Type Desc', ''),
('# of sentinel ln', '# of Sentinel LN', ''),
('# of pos sentinel ln', '# of Pos Sentinel LN', ''),
('# of neg sentinel ln', '# of Neg Sentinel LN', ''),
('sentinel lymph node bx', 'Sentinel Lymph Node Bx', ''),
('sln bx: y/n ', 'SLN Bx: Y/N ', ''),
('sentinel ln bx date', 'Sentinel LN Bx Date', ''),
('lvn', 'LVN', ''),
('er: pos/neg at init dx', 'ER: Pos/Neg at Init Dx', ''),
('er status at init dx', 'ER Status at Init Dx', ''),
('pr: pos/neg at init dx', 'PR: Pos/Neg at Init Dx', ''),
('her2 date', 'Her2 Date', ''),
('her2 at init dx', 'HER2 at Init Dx', ''),
('her2 tissue site', 'HER2 Tissue Site', ''),
('her2 lab at dx', 'HER2 Lab at Dx', ''),
('her2 lab at recurrence', 'HER2 Lab at Recurrence', ''),
('her2 lab at recurrence desc', 'HER2 Lab at Recurrence Desc', ''),
('first treatment date', 'First Treatment Date', ''),
('no initial treatment', 'No Initial Treatment', ''),
('no initial treatment desc', 'No Initial Treatment Desc', ''),
('local treatment', 'Local Treatment', ''),
('systemic therapy', 'Systemic Therapy', ''),
('chemo: y/n at init dx', 'Chemo: Y/N at Init Dx', ''),
('initial chemo regimen', 'Initial Chemo Regimen', ''),
('chemo at init dx pre 2010', 'Chemo at Init Dx Pre 2010', ''),
('chemo at init dx pre 2010 desc', 'Chemo at Init Dx Pre 2010 Desc', ''),
('init chemo regimen 2010', 'Init Chemo Regimen 2010', ''),
('init chemo regimen 2010 desc', 'Init Chemo Regimen 2010 Desc', ''),
('hormone therapy: y/n at init dx', 'Hormone Therapy: Y/N at Init Dx', ''),
('initial hormone regimen', 'Initial Hormone Regimen', ''),
('horm at init dx pre 2010', 'Horm at Init Dx Pre 2010', ''),
('horm at init dx pre 2010 desc', 'Horm at Init Dx Pre 2010 Desc', ''),
('init horm regimen 2010', 'Init Horm Regimen 2010', ''),
('init horm regimen 2010 desc', 'Init Horm Regimen 2010 Desc', ''),
('targeted therapy: y/n at init dx', 'Targeted Therapy: Y/N at Init Dx', ''),
('initial targeted therapy', 'Initial Targeted Therapy', ''),
('targ thx at init dx pre 2010', 'Targ Thx at Init Dx Pre 2010', ''),
('targ thx at init dx pre 2010 desc', 'Targ Thx at Init Dx Pre 2010 Desc', ''),
('init targ thx 2010', 'Init Targ Thx 2010', ''),
('init targ thx 2010 desc', 'Init Targ Thx 2010 Desc', ''),
('m1 at dx', 'M1 at Dx', ''),
('m1 date', 'M1 Date', ''),
('m1 site', 'M1 Site', ''),
('m1 site desc', 'M1 Site Desc', ''),
('first relapse date', 'First Relapse Date', ''),
('first locoregional relapse date', 'First Locoregional Relapse Date', ''),
('local recurrence', 'Local Recurrence', ''),
('local rec type', 'Local Rec Type', ''),
('loc rec date', 'Loc Rec Date', ''),
('loc rec site', 'Loc Rec Site', ''),
('loc rec site desc', 'Loc Rec Site Desc', ''),
('regional recurrence', 'Regional Recurrence', ''),
('reg rec date', 'Reg Rec Date', ''),
('reg rec site', 'Reg Rec Site', ''),
('reg rec site desc', 'Reg Rec Site Desc', ''),
('distant recurrence', 'Distant Recurrence', ''),
('dist rec date', 'Dist Rec Date', ''),
('dist rec site', 'Dist Rec Site', ''),
('dist rec site desc', 'Dist Rec Site Desc', '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_site_num' , "A system generated number, assigned in sequence, to each primary cancer site record per patient.", ''),
('bc_nbi_help_bcca_ref' , "A number assigned to identify referred or non-referred case.
-Non-referred = Patient has never been referred to the BC Cancer Agency for assessment or treatment of the index breast cancer.
-Referred = Patient must be seen by a BCCA physician (oncologist or clinic associate) for assessment, follow-up or receive treatment at any one of the agency's clinics or centres.", ''),
('bc_nbi_help_bcca_dataset' , "A number assigned to identify NHA or VCC case", ''),
('bc_nbi_help_bcca_site_admit_date' , "The date the patient was fully admitted for a malignancy/condition (referred cases).", ''),
('bc_nbi_help_bcca_status_at_referral' , "Indicates the status of the patient’s malignancy/condition at time of referral to BCCA for initial management.", ''),
('bc_nbi_help_bcca_status_at_referral_desc' , "The narrative description of the patient status at referral.", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_registry_group' , "Indicates if the patient, at time of dx, was a BC resident, Yukon resident, or other resident", ''),
('bc_nbi_help_bcca_diag_type' , "Indicates whether or not the site has been finalized by coding staff.", ''),
('bc_nbi_help_bcca_diag_type_desc' , "Description of the whether or not the site has been finalized by coding staff", ''),
('bc_nbi_help_bcca_loc_at_admit' , "The BCCA Clinic where the patient was first seen by a BCCA Oncologist/clinic associate for a particular condition/malignancy", ''),
('bc_nbi_help_bcca_loc_at_admit_desc' , "The narrative description of the BCCA center/clinic where the patient was first admitted.", ''),
('bc_nbi_help_bcca_loc_at_diag' , "Indicates the postal, province, or country code of the patient's permanent address at the time the cancer was diagnosed", ''),
('bc_nbi_help_bcca_loc_at_diag_desc' , "The narrative description of the geographic location of the patient at the  time of diagnosis (based on the patient’s BC postal code)  ", ''),
('bc_nbi_help_bcca_dx_hlth_auth' , "The health authority in which the patient resided at the time of diagnosis (based on the patient’s BC postal code).", ''),
('bc_nbi_help_bcca_dx_hlth_auth_desc' , "The narrative description of the health authority in which the patient resided at the time of diagnosis (based on the patient’s BC postal code).", ''),
('bc_nbi_help_bcca_dx_hsda' , "The health service delivery area in which the patient resided at the time of diagnosis (based on the patient’s BC postal code).", ''),
('bc_nbi_help_bcca_dx_hsda_desc' , "The narrative description of the health service delivery area in which the patient resided at the time of diagnosis (based on the patient’s BC postal code).", ''),
('bc_nbi_help_bcca_dx_hsda_cc' , "The Cancer Center catchment area for the health service delivery area in which the patient resided at the time of diagnosis. ", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_dx_local_health_area' , "The local health area of the patient’s BC postal code at the time of diagnosis.", ''),
('bc_nbi_help_bcca_dx_lha_desc' , "The narrative description of the local health area of the patient at the time of diagnosis (based on the patient’s BC postal code)", ''),
('bc_nbi_help_bcca_dx_lha_cc' , "Indicates the catchment centre associated with the local health area in which the patient resided at time of diagnosis", ''),
('bc_nbi_help_bcca_dx_post_code' , "The patient’s home address postal code at time of diagnosis", ''),
('bc_nbi_help_bcca_number_fst_deg_relatives' , "Indicates the number of first degree relatives with a hx of breast cancer. Calculated variable from pre- and post 2010 variables.", ''),
('bc_nbi_help_bcca_performance_status' , "A code denoting the patient’s functional ability. This indicates the performance rating given to the patient within one month before or after admission to BCCA according to the ECOG (Eastern Cooperative Oncology Group) scale. ", ''),
('bc_nbi_help_bcca_performance_status_desc' , "The narrative description of the code denoting the patient’s functional ability. ", ''),
('bc_nbi_help_bcca_laterality' , "The involved side of the primary site.   There should only be 1 primary cancer per laterality. ", ''),
('bc_nbi_help_bcca_laterality_desc' , "The narrative description of the involved side of the primary site.", ''),
('bc_nbi_help_bcca_site_desc' , "Narrative description of ICD-O (3rd edition) site code.", ''),
('bc_nbi_help_bcca_behavior' , "Indicates whether the breast primary tumor is insitu or invasive.", ''),
('bc_nbi_help_bcca_behavior_desc' , "The narrative description of the nature of the breast primary tumor.", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_hist1' , "An International Classification of Diseases for Oncology Third Edition (ICD-O) code which describes the cell type of the breast cancer.  The first 4 digits describe the cell type and the fifth digit describes the behavior.  This field captures the primary histology of the tumour.", ''),
('bc_nbi_help_bcca_hist1_desc' , "Narrative description of the ICD-O primary histology code.", ''),
('bc_nbi_help_bcca_hist2' , "An International Classification of Diseases for Oncology Third Edition (ICD-O) code which describes the cell type of the breast cancer.  The first 4 digits describe the cell type and the fifth digit describes the behavior.  This field captures the secondary histology of the tumour, if applicable.", ''),
('bc_nbi_help_bcca_hist2_desc' , "Narrative description of the ICD-O secondary histology code.", ''),
('bc_nbi_help_bcca_hist3' , "An International Classification of Diseases for Oncology Third Edition (ICD-O) code which describes the cell type of the breast cancer.  The first 4 digits describe the cell type and the fifth digit describes the behavior.  This field captures the third histology of the tumour, if applicable.", ''),
('bc_nbi_help_bcca_hist3_desc' , "Narrative description of the ICD-O third histology code.", ''),
('bc_nbi_help_bcca_grade_desc' , "The narrative description of the code that describes the system used to identify the Type of grade/differentiation/cell indicator.", ''),
('bc_nbi_help_bcca_br_grade_type_p00005' , "The code for grade type.  When grade is mentioned on the pathology, but the type is not given record this as histologic. Source: Pathology reports or Pathology Review if available. Discontinued 12/31/2009.", ''),
('bc_nbi_help_bcca_br_grade_type_p00005_desc' , "The narrative description of br_grade_type_p00005", ''),
('bc_nbi_help_bcca_overall_stg' , "The pathological stage grouping or clinical stage grouping if path unknown or path staging is lower after neoadjuvant tx. Calculated variable for pre and post 2010 diagnoses.", ''),
('bc_nbi_help_bcca_overall_clin_stg' , "clincal stage grouping - 6th ed. Calculated variable for pre and post 2010 diagnoses.", ''),
('bc_nbi_help_bcca_cT' , "clinical T stage, collapsed from pre- and post-2010 clinical T variables", ''),
('bc_nbi_help_bcca_cN' , "clinical N stage, collapsed from pre- and post-2010 clinical T variables", ''),
('bc_nbi_help_bcca_pT' , "pathological N stage, collapsed from pre- and post-2010 pathological T variables", ''),
('bc_nbi_help_bcca_pN' , "pathological N stage, collapsed from pre- and post-2010 pathological T variables", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_overall_path_stg' , "pathological stage groupinig - 6th ed. Calculated variable for pre and post 2010 diagnoses.", ''),
('bc_nbi_help_bcca_M_STG' , "M stage, collapsed from pre- and post-2010 M stage variables", ''),
('bc_nbi_help_bcca_neoadjuvant' , "indicates that the patient had neoadjuvant treatment. Calculated variable for pre and post 2010 diagnoses.", ''),
('bc_nbi_help_bcca_tnm_clin_yr' , "The revision year of the clinical  UICC TNM staging system.", ''),
('bc_nbi_help_bcca_tnm_clin_t' , "Clinical T stage of tumour at diagnosis (anatomical extent of the primary tumour), as per the applicable version of the UICC TNM Classification of Malignant Tumours.", ''),
('bc_nbi_help_bcca_tnm_clin_t_desc' , "The narrative description of Clinical T stage of tumour at diagnosis", ''),
('bc_nbi_help_bcca_tnm_clin_n' , "Clinical N stage of tumour at diagnosis (absence, or presence and extent of regional lymph node metastases), as per the applicable version of the UICC TNM Classification of Malignant Tumours. ", ''),
('bc_nbi_help_bcca_tnm_clin_n_desc' , "The narrative description of Clinical N stage of tumour at diagnosis.", ''),
('bc_nbi_help_bcca_tnm_clin_m' , "Clinical M stage of tumour at diagnosis (presence or absence of distant metastases), as per the applicable version of the UICC TNM Classification of Malignant Tumours. ", ''),
('bc_nbi_help_bcca_tnm_clin_m_desc' , "The narrative description of Clinical M stage of tumour at diagnosis.", ''),
('bc_nbi_help_bcca_tnm_surg_yr' , "The revision year of the pathologic  UICC TNM staging system.", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_tnm_surg_t' , "Pathological T stage of tumour at diagnosis (anatomical extent of the primary tumour), as per the applicable version of the UICC TNM Classification of Malignant Tumours.  The pathological classification requires the examination of the primary carcinoma with no gross tumour at the margins of resection.  A case can be classified pT if there is only microscopic tumour in a margin.  When classifying pT, the tumour size is a measurement of the invasive component.", ''),
('bc_nbi_help_bcca_tnm_surg_t_desc' , "The narrative description of Pathological T stage of tumour at diagnosis.", ''),
('bc_nbi_help_bcca_tnm_surg_n' , "Pathological N stage of tumour at diagnosis (absence, or presence and extent of regional lymph node metastases), as per the applicable version of the UICC TNM Classification of Malignant Tumours.  Status of nodes recorded even if only incidentally removed.", ''),
('bc_nbi_help_bcca_tnm_surg_n_desc' , "The narrative description of Pathological N stage of tumour at diagnosis.", ''),
('bc_nbi_help_bcca_tnm_surg_m' , "Pathologic M stage of tumour at diagnosis (presence or absence of distant metastases), as per the applicable version of the UICC TNM Classification of Malignant Tumours. ", ''),
('bc_nbi_help_bcca_tnm_surg_m_desc' , "The narrative description of Pathologic M stage of tumour at diagnosis.", ''),
('bc_nbi_help_bcca_COL_AJCC_Edition' , "Identifies the edition of the Cancer Staging Manual used to stage the case. TNM codes have changed over time and conversion is not always possible. Therefore, a case-specific indicator is needed to allow grouping of cases for comparison", ''),
('bc_nbi_help_bcca_COL_AJCC_T_clin' , "Collaborative Stage clinical T stage.  The site specific code evaluating the primary tumour clinically (T) and reflects the tumour size and/or extension as recorded", ''),
('bc_nbi_help_bcca_COL_AJCC_N_clin' , "Collaborative Stage clinical N stage.  The site specific code identifying the absence or presence of clinical, regional lymph node (N) metastasis and describes the extent of regional lymph node metastasis as recorded", ''),
('bc_nbi_help_bcca_COL_AJCC_M_clin' , "Collaborative Stage clinical M stage.  The site-specific code identifying the presence or absence of clinical distant metastasis (M) as recorded", ''),
('bc_nbi_help_bcca_COL_AJCC_T_path' , "Collaborative Stage pathological T stage; y prefix indicates staging after neo-adjuvant tx.  The site specific code evaluating the primary tumour pathologically (T) and reflects the tumour size and/or extension as recorded", ''),
('bc_nbi_help_bcca_COL_AJCC_N_path' , "Collaborative Stage pathological N stage; y prefix indicates staging after neo-adjuvant tx.  The site specific code identifying the absence or presence of clinical, regional lymph node (N) metastasis and describes the extent of regional lymph node metastasis as recorded", ''),
('bc_nbi_help_bcca_COL_AJCC_M_path' , "Collaborative Stage pathological M stage; y prefix indicates staging after neo-adjuvant tx.  The site-specific code identifying the presence or absence of clinical distant metastasis (M) as recorded", ''),
('bc_nbi_help_bcca_col_ssf3' , "# of Positive Ipsilateral Level I-II Axillary Lymph Nodes - Collaborative Stage variable", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_col_ssf4' , "immunohistochemistry (IHC) of regional lymph nodes - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf5' , "molecular (MOL) studies of regional lymph nodes - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf6' , "size of tumor - invasive component - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf7' , "Nottingham or Bloom-Richardson (BR) Score/Grade - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf8' , "HER2: Immunohistochemistry (IHC) Lab Value - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf9' , "HER2: Immunohistochemistry (IHC) Test Interpretation - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf10' , "HER2: Fluorescence in Situ Hybridization (FISH) Lab Value;  ratio recorded without the decimal - eg. 5.64 recorded as 564 - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf11' , "HER2: Fluorescence in Situ Hybridization (FISH) Test Interpretation - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf12' , "HER2: Chromogenic in Situ Hybridization (CISH) Lab Value;  mean recorded without the decimal - eg. 5.64 recorded as 564 - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf13' , "HER2: Chromogenic in Situ Hybridization (CISH) Test Interpretation - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf14' , "HER2: Result of Other or Unknown Test - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf16' , "Combinations of ER, PR, and HER2 Results - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf19' , "Assessment of Positive Ipsilateral Axillary Lymph Nodes - Collaborative Stage variable", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_col_ssf22' , "Multigene Signature Method - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_col_ssf23' , "Multigene Signature Results; recorded as actual score with leading zeroes to nearest whole percentage - Collaborative Stage variable", ''),
('bc_nbi_help_bcca_br_overlap_lesion_onco' , "identifies a specific location within the breast re: site of origin for primary tumours coded as overlapping lesions (C50.8) - BREAST SPECIAL STUDIES FIELD. Effective 2010 diagnosis date.", ''),
('bc_nbi_help_bcca_br_overlap_lesion_onco_desc' , "The narrative description of ation within the breast re: site of origin for primary tumours coded as overlapping lesions (C50.8) - BREAST SPECIAL STUDIES FIELD", ''),
('bc_nbi_help_bcca_br_multicentbrstca_onco' , "indicates whether or not the primary breast tumour was multicentric -BREAST SPECIAL STUDIES FIELD. Effective 2010 diagnosis date.", ''),
('bc_nbi_help_bcca_br_multicentbrstca_onco_desc' , "The narrative description of hether or not the primary breast tumour was multicentric -BREAST SPECIAL STUDIES FIELD", ''),
('bc_nbi_help_bcca_br_multifocbrstca_onco' , "indicates whether or not the primary breast tumour was multifocal - BREAST SPECIAL STUDIES FIELD. Effective 2010 diagnosis date.", ''),
('bc_nbi_help_bcca_br_multifocbrstca_onco_desc' , "The narrative description of  whether or not the primary breast tumour was multifocal - BREAST SPECIAL STUDIES FIELD", ''),
('bc_nbi_help_bcca_tum_size' , "tumour size variable from pre- and post 2010 tumour size variables (recorded as per Collaborative Stage variable in mm)", ''),
('bc_nbi_help_bcca_final_margins' , "status of margins after final surgery performed at initial dx - Calculated variable using pre and post 2010 variables", ''),
('bc_nbi_help_bcca_nodestat' , "Patient's nodal status at initial diagnosis - Calculated variable using pre and psot 2010 variables", ''),
('bc_nbi_help_bcca_posnodes' , "# of positive nodes removed at initial dx -Calculated variable using pre and post 2010 variables", ''),
('bc_nbi_help_bcca_totnodes' , "total # of nodes removed at initial dx - Calculated variable using pre and post 2010 variables", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_COL_nodes' , "CS Lymph Nodes - Collaborative Stage variable - identifies regional lymph nodes involved w cancer at time of dx. Effective 2010 diagnosis date", ''),
('bc_nbi_help_bcca_COL_nodes_eval' , "Collaborative Stage variable: field used primarily to derive the staging basis for N category in the tnm system. Effective 2010 diagnosis date", ''),
('bc_nbi_help_bcca_ECE_final' , "Indicates whether or not there is extracapsular extension at the time of initial nodal surgery, and if so, the degree of extracapsular extension - Calculated variable using pre- and post 2010 variables", ''),
('bc_nbi_help_bcca_br_radiologicconfirmFWL_onco' , "Indicates whether or not the surgical specimen from a fine-wire localization (FWL), performed as part of the surgical treatment plan at initial diagnosis, was radiologically confirmed - BR SS Field. Effective 2010 diagnosis date", ''),
('bc_nbi_help_bcca_br_radiologicconfirmFWL_onco_desc' , "The narrative description of whether or not the surgical specimen from a fine-wire localization (FWL), performed as part of the surgical treatment plan at initial diagnosis, was radiologically confirmed - BR SS Field", ''),
('bc_nbi_help_bcca_recon_final' , "For patients who had a full mx as part of their surg tx plan at initial dx, this field indicates whether or not the pt had breast recon surg, and if so, the timing of the recon in relation to the first relapse - collapsed from pre & post 2010 variables", ''),
('bc_nbi_help_bcca_br_surgspecimenoriented_onco' , "Indicates whether or not the surgical specimen from the first open surgical procedure performed as part of the surgical treatment plan at initial diagnosis was oriented (placed in its proper clinical and anatomic context) - BR SS Field. Effective 2010 diagnosis date", ''),
('bc_nbi_help_bcca_br_surgspecimenoriented_onco_desc' , "The narrative description of whether or not the surgical specimen from the first open surgical procedure performed as part of the surgical treatment plan at initial diagnosis was oriented (placed in its proper clinical and anatomic context) - BR SS Field", ''),
('bc_nbi_help_bcca_br_postr_deepmarg_onco' , "Indicates whether or not the surgeon assessed the posterior (deep) resection margin in the most definitive operative procedure that addressed the deep margin - BR SS Field. Effective 2010 diagnosis date", ''),
('bc_nbi_help_bcca_br_postr_deepmarg_onco_desc' , "The narrative description of whether or not the surgeon assessed the posterior (deep) resection margin in the most definitive operative procedure that addressed the deep margin - BR SS Field", ''),
('bc_nbi_help_bcca_br_ant_tiss_onco' , "Indicates whether or not any more tissue could be removed anterior to the surgical cavity (i.e. whether there was any more anterior breast tissue remaining) for any open BCS procedure performed as part of the surgical tx plan at initial dx - BR SS Field. Effective 2010 diagnosis date", ''),
('bc_nbi_help_bcca_br_ant_tiss_onco_desc' , "The narrative description of whether or not any more tissue could be removed anterior to the surgical cavity", ''),
('bc_nbi_help_bcca_br_clipmarkingbxcavity_onco' , "For all patients who have undergone BCS as part of their surgical tx plan at initial dx, this field indicates whether or not the surgeon marked the biopsy cavity with clips to facilitate radiation planning - BR SS Field. Effective 2010 diagnosis date", ''),
('bc_nbi_help_bcca_br_clipmarkingbxcavity_onco_desc' , "The narrative description of whether or not the surgeon marked the biopsy cavity with clips to facilitate radiation planning - BR SS Field", ''),
('bc_nbi_help_bcca_br_closeposmargintype_onco' , "Indicates whether or not close and/or positive margins were found on the last open surgical procedure performed on the breast as part of the surgical tx plan at initial dx, and also specifies which margins were close and/or positive - BR SS Field. Effective 2010 diagnosis date", ''),
('bc_nbi_help_bcca_br_closeposmargintype_onco_desc' , "The narrative description of whether or not close and/or positive margins were found on the last open surgical procedure performed on the breast as part of the surgical tx plan at initial dx, and also specifies which margins were close and/or positive - BR SS Field", ''),
('bc_nbi_help_bcca_totsentnodes' , "total # of sentinel lymph nodes removed at initial dx - Calculated variable from pre- and post 2010 # of sentinel lymph node variables", ''),
('bc_nbi_help_bcca_possentnodes' , "# of positive sentinel lymph nodes removed at initial dx - Calculated variable from pre- and post 2010 positive sentinel lymph node variables", ''),
('bc_nbi_help_bcca_negsentnodes' , "# of negative sentinel lymph nodes removed at initial dx - Calculated variable from pre- and post 2010 negative sentinel lymph node variables", ''),
('bc_nbi_help_bcca_SLNB' , "indicates whether or not a SLNBx was performed at intial dx and if so, the outcome of the SLNBx - Calculated variable from pre- and post 2010 SLNB variables", ''),
('bc_nbi_help_bcca_SLNB_YesNo' , "SLNB further categorized as yes, no, abandoned, or unknown", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_br_sentinel_lymph_node_bx_date_p00005' , "Date of the sentinel lymph node biopsy performed as part of the initial treatment plan.  This field has been captured in cases referred since May 19, 1999.  Data in this field prior to May 1/99 site admit date has not been consistently captured on all cases Discontinued discharges effective 12/31/2009.", ''),
('bc_nbi_help_bcca_lvn_final' , "presence/absence of cells in lymphatic channels or blood vessels within the primary tumour - Calculated variable from pre- and post 2010 LV fields", ''),
('bc_nbi_help_bcca_erposneg' , "ER status at initial dx, collapsed as negative/positive/unknown - Calculated variable from pre- and post 2010 ER fields", ''),
('bc_nbi_help_bcca_er' , "ER status at initial dx - Calculated variable from pre- and post 2010 ER fields", ''),
('bc_nbi_help_bcca_pgrposneg' , "PR status at initial dx, collapsed as negative/positive/unknown - Calculated variable from PR fields", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_her2_date' , "The date of the operative report from which the specimen was taken for her2 testing.  If more than one her2 testing method was performed, FISH/CISH takes precedence over IHC and FISH takes precedence over CISH.  If testing was done at time of diagnosis and at relapse, the “most positive” result is captured.  If the results from initial diagnosis and relapse are identical, the site and date from the specimen from initial diagnosis are captured. Variable collected for cases diagnosed from 1/12003 - 12/31/2009.", ''),
('bc_nbi_help_bcca_her2_final' , "HER2 status at initial dx - Calculated variable from pre- and post 2010 HER2 fields", ''),
('bc_nbi_help_bcca_her2tissuesite' , "indicates the specimen site(s) from which the most definitive HER2 testing was performed. Calculated variable based on pre and post 2010 variables.", ''),
('bc_nbi_help_bcca_her2lab_initdx' , "Indicates the lab where the Her2 testing at initial dx was performed - collapsed from pre & post 2010 variables", ''),
('bc_nbi_help_bcca_br_her2neulabatrecur_onco' , "Indicates the lab where her2 testing at recurrence was performed. Effective 2010 diagnosis date.", ''),
('bc_nbi_help_bcca_br_her2neulabatrecur_onco_desc' , "The narrative description of the lab where her2 testing at recurrence was performed. ", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_fst_treat_date' , "The date the patient received first treatment (initial or subsequent if initial plan was no treatment). This may be surgery, radiotherapy, chemotherapy or hormone therapy", ''),
('bc_nbi_help_bcca_not_treated' , "Indicates why the patient has not received initial treatment for a malignancy/condition. Discontinued for Non-referred cases effective April 30, 2012", ''),
('bc_nbi_help_bcca_not_treated_desc' , "The narrative description why the patient has not received initial treatment for a malignancy/condition.", ''),
('bc_nbi_help_bcca_localtx' , "local treatment of the primary breast cancer at initial diagnosis. Calculated variable based on init complete, init partial, and init nodal proc variables (pre and post 2010)", ''),
('bc_nbi_help_bcca_systx' , "systemic therapy (chemo & hormonal) at initial diagnosis. Calculated variable based on pre and post 2010 variables.", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_init_chemo' , "initial chemo - calculated field using pre and post 2010 variables. Chemo data for Non-referred cases calculated from Pharmacy Database protocol codes.   If protocol code = blank, collected as Chemo, NOS.", ''),
('bc_nbi_help_bcca_br_initl_chemoreg' , "initial chemo regimen - Indicates the type of chemotherapy planned at initial diagnosis. Calculated variable combining pre and post 2010 variables. Chemo data for Non-referred cases calculated from Pharmacy Database protocol codes.   If protocol code = blank, collected as Chemo, NOS.", ''),
('bc_nbi_help_bcca_br_initl_chemotype_p00005' , "The type of adjuvant chemotherapy treatment received (if any) by the patient.  Only the initial chemotherapy regimen is recorded (i.e. if patient begins one regimen and it is subsequently stopped and another regimen began). Pre 2010 Dx", ''),
('bc_nbi_help_bcca_br_initl_chemotype_p00005_desc' , "The narrative description of the type of adjuvant chemotherapy treatment received (if any) by the patient.", ''),
('bc_nbi_help_bcca_br_initl_chemoreg_onco' , "initial chemo regimen - BREAST SPECIAL STUDIES FIELD. Indicates the type of chemotherapy planned at initial diagnosis. Effective 2010 diagnosis date.", ''),
('bc_nbi_help_bcca_br_initl_chemoreg_onco_desc' , "The descriptive narrative for initial chemo regimen - BREAST SPECIAL STUDIES FIELD", ''),
('bc_nbi_help_bcca_init_horm' , "initial hormonal therapy yes/no - calculated field using pre and post 2010 variables. Hormone data for Non-referred cases calculated from Pharmacy Database protocol codes.   If protocol code = blank, used  the first drug.  Note: for Tamoxifen, did not capture switches if they occurred. ", ''),
('bc_nbi_help_bcca_br_initl_hormreg' , "initial hormonal regimen - Indicates the type of hormonal therapy planned at initial diagnosis. Calculated variable combining pre and post 2010 variables. Hormone data for Non-referred cases calculated from Pharmacy Database protocol codes.   If protocol code = blank, used  the first drug.  Note: for Tamoxifen, did not capture switches if they occurred. ", ''),
('bc_nbi_help_bcca_br_initl_horm_type_p00005' , "The type of adjuvant hormonal treatment received (if any) by the patient.  Only the initial hormonal therapy is recorded. Pre 2010 Dx", ''),
('bc_nbi_help_bcca_br_initl_horm_type_p00005_desc' , "The narrative description of the type of adjuvant hormonal treatment received (if any) by the patient. Effective 2010 diagnosis date.", ''),
('bc_nbi_help_bcca_br_initl_hormreg_onco' , "initial hormonal therapy regimen - Breast Special Studies field. Indicates the type of hormonal therapy planned at initial diagnosis. Effective 2010 dx dates.", ''),
('bc_nbi_help_bcca_br_initl_hormreg_onco_desc' , "The narrative description of the initial hormonal therapy regimen - Breast Special Studies field", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_init_targ_therapy' , "initial targeted therapy yes/no - calculated field pre and post 2010 variables. Target therapy data for Non-referred cases calculated from Pharmacy Database protocol codes.", ''),
('bc_nbi_help_bcca_br_initl_targthx' , "initial targeted therapy regimen - Indicates the type of targeted therapy planned at initial diagnosis. calculated variable combining pre and post 2010 variables. Target therapy data for Non-referred cases calculated from Pharmacy Database protocol codes.", ''),
('bc_nbi_help_bcca_br_immunotherapy_p00005' , "Indicates whether Immunotherapy (ie Herceptin (Trastuzumab) was given as part of the initial treatment plan. Pre 2010 Dx.", ''),
('bc_nbi_help_bcca_br_immunotherapy_p00005_desc' , "The narrative description of whether immunotherapy was given as part of the initial treatment plan.", ''),
('bc_nbi_help_bcca_br_initl_targtherapy_onco' , "initial targeted therapy regimen - Breast Special Studies field. Indicates the type of targeted therapy planned at initial diagnosis. Effective 2010 diagnosis dates.", ''),
('bc_nbi_help_bcca_br_initl_targtherapy_onco_desc' , "The narrative description for initial targeted therapy regimen - Breast Special Studies field", ''),
('bc_nbi_help_bcca_M1atDx' , "Metastases at diagnosis. Calculated variable using pre and post 2010 staging variables. For non-referred, blanks = 9 unknown", ''),
('bc_nbi_help_bcca_M1DXDATE' , "Calculated variable combining M1 distant dates into 1 variable pre and post 2010.", ''),
('bc_nbi_help_bcca_M1SITEDX' , "Calculated variable M1 distant site into 1 variable pre and post 2010. An International Classification of Diseases for Oncology Third Edition (ICD-O) code which indicates the site of local recurrence.", ''),
('bc_nbi_help_bcca_M1sitedx_desc' , "The narrative description of calculated variable M1 distant site.", ''),
('bc_nbi_help_bcca_fst_relapse_date' , "Calculated variable - pre and post 2010 diagnose. First relapse date (of any type)", ''),
('bc_nbi_help_bcca_locoreg_relapse_date' , "Calculated variable - pre and post 2010 diagnoses. First relapse date that was either local or regional", '');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('bc_nbi_help_bcca_loc_ind' , "Indicates that the patient experienced a local recurrence a recurrence of tumour within the ipsilateral breast or chest wall, including skin from midline to midaxillary line). Local relapse information has only consistently been captured in referred breast cancer patients diagnosed since Jan. 1, 1989. Calculated variable using pre and post 2010 variables.", ''),
('bc_nbi_help_bcca_loc_type' , "Indicates whether the Local recurrence is invasive, insitu or unknown. Calculated variable using pre and post 2010 variables.", ''),
('bc_nbi_help_bcca_loc_date' , "The date of first positive confirmation of a local recurrence (a recurrence of tumour within the ipsilateral breast or chest wall, including skin from midline to midaxillary line). If there is no local relapse, field is left blank. Calculated variable using pre and post 2010 variables.", ''),
('bc_nbi_help_bcca_loc_site' , "An International Classification of Diseases for Oncology Third Edition (ICD-O) code which indicates the site of local recurrence. Calculated variable using pre and post 2010 variables.", ''),
('bc_nbi_help_bcca_loc_site_desc' , "Narrative description of ICD-0 (3rd edition) local recurrence code.", ''),
('bc_nbi_help_bcca_reg_ind' , "Indicates that the patient experienced a regional recurrence (a recurrence of tumour within the ipsilateral axillary, infraclavicular, *suprclavicular, or internal mammary nodes). Regional relapse information has only consistently been captured in referred breast cancer patients diagnosed since Jan 1, 1989. Calculated variable using pre and post 2010 variables.", ''),
('bc_nbi_help_bcca_reg_date' , "The date of first positive confirmation of a regional recurrence (a recurrence of tumour within the ipsilateral axillary, infraclavicular, *supraclavicular, or internal mammary nodes). Calculated variable using pre and post 2010 variables.", ''),
('bc_nbi_help_bcca_reg_site' , "An International Classification of Diseases for Oncology Third Edition (ICD-O) code which indicates the site of regional recurrence. Calculated variable using pre and post 2010 variables.", ''),
('bc_nbi_help_bcca_reg_site_desc' , "Narrative description of ICD-0 (3rd edition) regional recurrence code.", ''),
('bc_nbi_help_bcca_dist_ind' , "Indicates that the patient experienced a distant recurrence at any time after diagnosis. Distant relapse/disease information has only consistently been captured in referred breast cancer patients diagnosed since Jan. 1, 1989.. Calculated variable using pre and post 2010 variables.", ''),
('bc_nbi_help_bcca_dist_date' , "The date of first positive confirmation of a distant recurrence.  . If there is no distant relapse, field is left blank. Distant relapse information has only consistently been captured in referred breast cancer patients diagnosed since Jan. 1, 1989.. Calculated variable using pre and post 2010 variables.", ''),
('bc_nbi_help_bcca_dist_site' , "An International Classification of Diseases for Oncology Third Edition (ICD-O) code which indicates the site of distant recurrence (for patients staged as M0 or Mx at time of initial diagnosis).. Calculated variable using pre and post 2010 variables.", ''),
('bc_nbi_help_bcca_dist_site_desc' , "Narrative description of ICD-0 (3rd edition) distant recurrence/extent of distant disease code.", '');



































Retrospective Vs Prospective Participants Business Rules

No data into the database are encrypted. All rules are managed at the ATiM controller’s level.

A participant can be flagged as part of the 'Retropsective Bank' or 'Prospective Bank'. In the futur installation, we can validate that only the 'Prospective Bank' option can be selected.

1- Participant creation

No specific business rule. 

2- Participant profile information display

When a participant is flagged as 'Retrospective Bank' participant, only users of the 'Administrators' users group will have access/see to the following confidential information:
- PHN#
- BCCA#
- First Name
- Middle Name
- Last Name
- Date of Birth

For the users of the other users group, all profile confidential information (listed above) will be replaced by 'Confidential' for the participants flagged 
as participants of the 'Retrospective Bank'.

3- Participant profile search

When a participant is flagged as 'Retrospective Bank' participant, only users of the 'Administrators' users group can search on retrospective bank participants based on the following information:
- PHN#
- BCCA#
- First Name
- Middle Name
- Last Name
- Date of Birth

When the users of the other users groups are looking for participants based on criteria linked to the fields listed above, then the system will limit the results to the 
participants of the ‘Prospective Bank’ only.

4- Participant profile modification

When a participant is flagged as 'Retrospective Bank' participant, only users of the 'Administrators' users group can change profile information of the participant.

5- PHN and BCCA numbers are unique

No control is in place to block duplication of PHN or BCCA numbers but when user is displaying the profile of a participant a warning message is displayed when:
-	The user is part of the 'Administrators' users group and the number is duplaiceted.
-	The user is not part of the 'Administrators' users group, the displayed participant is not a participant of the ‘Retrospective Bank’ and at least two participants of the ‘Prospective Bank’ have the same number.

6- Participant Contact

Only users of the 'Administrators' users group can access confidential participant contacts for participants of the ‘Retrospective Bank’.





















PHN# is the key between file and ATiM...
Actually Viktor is enterring PHN# /
 First name last name and dob and sex




















Concerning "Clinical Annotation" part: can we add here some of the entries from the Main data dictionary?
1) Referred Case
2) NHA  case
3) Diagnosis date
4) Admission date
5) Status at referral
6) Cancer site (i.e. primary location of malignant tumor in the body)
7) Province of Residence.


Add province of residence
 
 
 
UPDATE versions SET branch_build_number = '7112' WHERE version_number = '2.7.0';