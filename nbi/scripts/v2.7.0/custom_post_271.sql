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
  ADD COLUMN bc_nbi_physician_speciality varchar(250) DEFAULT NULL,
  ADD COLUMN bc_nbi_physician_speciality_detail varchar(250) DEFAULT NULL;
ALTER TABLE participant_contacts_revs
  ADD COLUMN bc_nbi_msc_id integer(25) DEFAULT NULL,
  ADD COLUMN bc_nbi_physician_speciality varchar(250) DEFAULT NULL,
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
  ADD COLUMN bc_nbi_pre_2003_physician_name varchar(250) DEFAULT NULL;
ALTER TABLE participant_contacts_revs
  ADD COLUMN bc_nbi_physician_type varchar(250) DEFAULT NULL,
  ADD COLUMN bc_nbi_pre_2003_physician_name varchar(250) DEFAULT NULL;

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
  init_finrt varchar(250) DEFAULT NULL,
  `treatment_master_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `bc_nbi_txd_radiations_at_dx_revs` (
  `init_rt_boost` char(1) DEFAULT '',
  `init_rt_brachy` char(1) DEFAULT '',
  `init_rt_brchw` char(1) DEFAULT '',
  `init_rt_nodal`char(1) DEFAULT '',
  `rtoutofprov` tinyint(1) DEFAULT '0',
  init_finrt varchar(250) DEFAULT NULL,
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
   rt_treat_region varchar(250) DEFAULT NULL,
   rt_technique varchar(250) DEFAULT NULL,
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
   rt_treat_region varchar(250) DEFAULT NULL,
   rt_technique varchar(250) DEFAULT NULL,
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