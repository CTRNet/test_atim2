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
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers/%';
UPDATE menus SET flag_active = 1 WHERE use_link LIKE '/ClinicalAnnotation/ReproductiveHistories/%';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/FamilyHistories/%';

SELECT 'ParticipantContacts' AS 'TODO: Change users access permission to let people to access following modules'
UNION ALL
SELECT 'TreatmentMasterExtends' AS 'TODO: Change users access permission to let people to access following modules'
UNION ALL
SELECT 'ReproductiveHistories' AS 'TODO: Change users access permission to let people to access following modules';

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
  
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Physician Specialities', 1, 250, 'clinical - contact');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Physician Specialities');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("00", "00 - General Practice", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("01","01 - Dermatology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("02","02 - Neurology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("03","03 - Psychiatry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("04","04 - Neuropsychiatry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("05","05 - Obstetrics & Gyne", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("06","06 - Ophthalmology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("07","07 - Otolaryngology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("08","08 - General Surgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("09","09 - Neurosurgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("10","10 - Orthopaedics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("11","11 - Plastic Surgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("12","12 - Thor & Card Surgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("13","13 - Urology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("14","14 - Paed ( Neo-Nata l)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("15","15 - Internal Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("16","16 - Rad ( Onc Rad-16 )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("17","17 - Pathology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("18","18 - Anesthesiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("19","19 - Paed Card-Col 123180", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("20","20 - Phys Med & Rehab", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("21","21 - Pub Hlth & Comm Med", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("22","22 - Gen Surg 50% GP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("23","23 - MSC After 3 1/3 Fis Yr", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("24","24 - Medical Biochemistry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("25","25 - Gynecologic Oncology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("26","26 - Procedural Cardiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("27","27 - Paed 50% GP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("28","28 - F-T Co ( Top 280 )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("29","29 - Medical Microbiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("30","30 - Chiropractics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("31","31 - Naturopathy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("32","32 - Physiotherapy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("33","33 - Nuclear Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("34","34 - Osteopathy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("35", "35 - Orthoptic Technician", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("36","36 - Hospitals", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("37","37 - Oral Surgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("38","38 - Podiatry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("39","39 - Optometry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("40","40 - Dent Surg ( Reg Dent )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("41","41 - Dental Mechanics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("42","42 - Orthodontics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("43","43 - Periodontics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("44","44 - Rheumatology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("45","45 - Haematology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("46","46 - Gastroenterology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("47","47 - Nursing Home", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("48","48 - Respiratory Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("49","49 - Medical Genetics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("50","50 - Hosp ( Type Prac Code )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("51","51 - Haematopathology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("52","52 - Gen Med ( Prim Nonref )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("53","53 - Radiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("54","54 - Nurse Practitioner", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("55","55 - Psychology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("56","56 - Occupational Therapist", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("57","57 - Registered Nurse", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("58","58 - Audiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("59","59 - Genetic Counsellor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("60","60 - Registered Clinical Counsellor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("61","61 - Registered Dietitian", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("62","62 - Social Work", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("63","63 - Emergency Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("64","64 - Endocrinology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("70","70 - General Surgical Oncology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("71","71 - Prof Corp", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("80","80 - Clinics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("81","81 - Mr & Mrs ( Non Prof. )", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("82","82 - Radiation Oncology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("83","83 - Medical Oncology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("84","84 - Chemistry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("85","85 - Scientific", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("86","86 - Non Patient GP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("87","87 - Non Patient Spec", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("88","88 - Neuropsychology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("89","89 - Occupational Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("90","90 - Midwifery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("91","91 - Geriatric Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("92","92 - Acupuncture", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("93","93 - Vascular Surgery", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("94","94 - Cardiology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("95","95 - Nephrology", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("96","96 - Paediatrics", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("97","97 - Traditional Chinese Medicine", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("98","98 - Homeopathy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("99","99 - Allergy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_customs SET value = LOWER(en) WHERE control_id = @control_id;
UPDATE structure_permissible_values_custom_controls 
SET values_max_length = 250, values_used_as_input_counter = 1, values_counter = 1 WHERE name = 'Physician Specialities';
INSERT INTO structure_value_domains (domain_name, override, category, source) values
('bc_nbi_physician_specialities', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'Physician Specialities\')');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'bc_nbi_msc_id', 'integer',  NULL , '0', 'size=11', '', '', 'MSC ID', ''), 
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'bc_nbi_physician_speciality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_physician_specialities') , '0', '', '', '', 'speciality', ''), 
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'bc_nbi_physician_speciality_detail', 'input', NULL , '0', 'size=30', '', '', 'details', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='bc_nbi_msc_id' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `default`='' AND `language_help`='' AND `language_label`='MSC ID' AND `language_tag`=''), '1', '20', 'physician details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participantcontacts'), (SELECT id FROM structure_fields WHERE `model`='ParticipantContact' AND `tablename`='participant_contacts' AND `field`='bc_nbi_physician_speciality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_physician_specialities')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='speciality' AND `language_tag`=''), '1', '21', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
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
("Follow-up", "Follow-up", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("Most Responsible 2003", "Most Responsible 2003", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("Most Responsible pre 2003", "Most Responsible pre 2003", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("Family Physician", "Family Physician", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) VALUES
('Pre 2003 Physicians', 1, 250, 'clinical - contact');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('bc_nbi_pre_2003_physicians', "StructurePermissibleValuesCustom::getCustomDropdown('Pre 2003 Physicians')");
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Pre 2003 Physicians');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("aa", "AA - A. Avanessian", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("aat", "AAT - A. Al-Tourah", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ab", "AB - A. Barry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ach", "ACH - A.C. Hui", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("acl", "ACL - A.C. Lo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("adf", "ADF - A.D. Flores", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ah", "AH - A. Hovan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("aj", "AJ - A. Jones", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("aja", "AJA - A.J. Attwell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ajg", "AJG - A.J. Goldrick", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ak", "AK - A. Karvat", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("akc", "AKC - A.K. Cheung", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("akd", "AKD - A.K. David", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("al", "AL - A. Lin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ala", "ALA - A.L. Agranovich", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ams", "AMS - A.M. Shah", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("an", "AN - A. Nichol", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("arf", "ARF - A.R. Fowler", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("asa", "ASA - A.S. Alexander", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("asy", "ASY - A.S. Yee", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("at", "AT - A. Tinker", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("avk", "AVK - A.V. Krauze", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("aw", "AW - A. Weiss", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ay", "AY - A. Ye", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bac", "BAC - B.A. Czerkawski", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bam", "BAM - B. A. Masri", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bc", "BC - B. Campbell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bda", "BDA - B.D. Acker", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bgm", "BGM - B.G. McMillan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bh", "BH - B. Haylock", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bl", "BL - B. Lester", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ble", "BLE - B. Lee", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("blm", "BLM - B.L. Madsen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bm", "BM - B. Melosky", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bma", "BMA - B.M. Allan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bmo", "BMO - B. Mou", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bms", "BMS - B. Maas", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bn", "BN - B. Norris", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bne", "BNE - B. Nelems", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bp", "BP - B. Proctor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bs", "BS - B. Sheehan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bt", "BT - B. Thiessen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bv", "BV - B. Valev", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("bw", "BW - B. Weinerman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("caf", "CAF - C.A. Fitzgerald", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cag", "CAG - C.A. Grafton", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cal", "CAL - C.A. Lohrisch", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cas", "CAS - C.A. Smith", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cb", "CB - C. Blanke", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cc", "CC - C. Campbell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cch", "CCH - C.C. Ho", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cd", "CD - C. Demetz", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cdb", "CDB - C.D. Britten", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cdl", "CDL - C.D. Little", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cgm", "CGM - C.G. Martens", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cjb", "CJB - C.J. Bryce", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cjf", "CJF - C.J.H. Fryer", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cjn", "CJN - C.J. North", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ck", "CK - C. Kollmannsberger", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cks", "CKS - C. Kim-Sing", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ckw", "CKW - C.K. Williams", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cl", "CL - C. Leong", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("clh", "CLH - C.L. Holloway", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("clt", "CLT - C.L. Toze", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cm", "CM - C. Most", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cmc", "CMC - C.M. Coppin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cml", "CML - C.M. Ludgate", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("co", "CO - C. Oja", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cop", "COP - Comm. Onc.", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cp", "CP - C. Parsons", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cpd", "CPD - C.P. Duncan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("crl", "CRL - C.R. Lund", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cs", "CS - C. Sigal", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("cwl", "CWL - C.W. Lee", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dab", "DAB - D.A. Boyes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("db", "DB - D. Bowman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dbb", "DBB - D.B. Barwich", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dcw", "DCW - D.C. Wilson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ddp", "DDP - D.D. Panjwani", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dds", "DDS - D.D. Schellenberg", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("deh", "DEH - D.E. Hogge", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("der", "DER - D.E. Rheaume", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("df", "DF - D. Finch", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dfl", "DFL - D.F. Lee", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dg", "DG - D. Glick", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dh", "DH - D. Hoegler", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dim", "DIM - D.I. McLean", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("djk", "DJK - D.J. Klaassen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("djt", "DJT - D.J. Thorpe", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dk", "DK - D. Kim", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dls", "DLS - D.L. Saltman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dlu", "DLU - D.L. Uhlman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dm", "DM - D. Mirchandani", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dmm", "DMM - D. Miller", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("do", "DO - D. Osoba", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dp", "DP - D. Petrik", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dr", "DR - D. Reece", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ds", "DS - D. Sauciuc", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dss", "DSS - D.S. Stuart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dv", "DV - D. Voduc", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("dwf", "DWF - D.W. Fenton", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("eb", "EB - E. Berthelet", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ec", "EC - E. Conneally", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("eck", "ECK - E.C. Kostashuk", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("eh", "EH - E. Hadzic", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ejm", "EJM - E.J. McMurtrie", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ekb", "EKB - E.K. Beardsley", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ekc", "EKC - E. Chan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ekw", "EKW - E.K. Wong", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("el", "EL - E. Laukkanen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("elh", "ELH - E.L.G. Hardy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("emb", "EMB - E.M. Brown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("es", "ES - E. Sham", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("esb", "ESB - E.S. Bouttell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("esw", "ESW - E.S. Wai", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("et", "ET - E. Tran", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ewt", "EWT - E.W. Taylor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("fa", "FA - F. Alfaraj", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("fb", "FB - F. Bachand", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("fg", "FG - F. Germain", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("fhh", "FHH - F.H. Hsu", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("fjv", "FJV - F.J. Vernimmen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("flw", "FLW - F.L. Wong", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gb", "GB - G. Bahl", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gbg", "GBG - G.B. Goodman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gc", "GC - G. Campbell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gdm", "GDM - G.D. MacLean", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gg", "GG - G. McGregor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ggd", "GGD - G.G. Duncan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gkp", "GKP - G.K. Pansegrau", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("glp", "GLP - G.L. Phillips", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gmc", "GMC - G.M. Crawford", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gmf", "GMF - G.M. Fyles", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gn", "GN - G. Newman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gpb", "GPB - G.P. Browman", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gr", "GR - G. Richardson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("gwd", "GWD - G.W.K. Donaldson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("haj", "HAJ - H.A. Joe", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hak", "HAK - H. Kennecke", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hb", "HB - H. Berry", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hc", "HC - H. Carolan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hf", "HF - H. Fung", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hgk", "HGK - H.G. Klingemann", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hhp", "HHP - H.H. Pai", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hjl", "HJL - H.J. Lim", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hjs", "HJS - H.J. Sutherland", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hk", "HK - H. Kader", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hks", "HKS - H.K. Silver", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hl", "HL - H. Lui", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hla", "HLA - H.L. Anderson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hlr", "HLR - H.L. Rayner", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hm", "HM - H. Martins", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hmg", "HMG - H.M. Gough", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hvd", "HVD - H.V. Docherty", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hw", "HW - H. Wass", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("hyl", "HYL - H.Y. Lau", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("iao", "IAO - I.A. Olivotto", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("igm", "IGM - I.G. Mohamed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ihp", "IHP - I.H. Plenderleith", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ilt", "ILT - I.L. Thompson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ina", "INA - Inactive", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("is", "IS - I. Syndikus", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("iv", "IV - I. Vallieres", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ja", "JA - J. Archer", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jab", "JAB - J.A. Broomfield", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jac", "JAC - J. Crook", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jas", "JAS - J.A. Sutherland", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jay", "JAY - J. Younus", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jb", "JB - J. Bowen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jc", "JC - J. Cox", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jca", "JCA - J. Caon", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jcf", "JCF - J.C. Fetterly", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jcl", "JCL - J.C. Lavoie", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jds", "JDS - J.D. Shepherd", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jfc", "JFC - J.F. Canavan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jg", "JG - J. Goulart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jh", "JH - J. Hart", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jhc", "JHC - J.H. Chritchley", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jhg", "JHG - J.H. Goldie", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jhh", "JHH - J.H. Hay", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jj", "JJ - J. Jensen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jja", "JJA - J. Jaswal", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jjl", "JJL - J.J. Laskin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jjt", "JJT - J.J. Travaglini", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jk", "JK - J. Kamra", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jkr", "JKR - J.K. Rivers", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jl", "JL - J.T.W. Lim", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jlb", "JLB - J.L. Benedet", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jm", "JM - J. Michels", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jmb", "JMB - J.M. Bourque", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jmc", "JMC - J.M. Connors", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jmf", "JMF - J.M. Freund", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jmw", "JMW - J.M. Wilde", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jnm", "JNM - J.N. Moore", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jnr", "JNR - J.N. Rose", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jpl", "JPL - J.P. Livergant", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jqc", "JQC - J.Q. Cao", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jr", "JR - J. Ragaz", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jrb", "JRB - J.R. Brown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("js", "JS - J. D. Shustik", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jsk", "JSK - J.S. Kwon", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jsw", "JSW - J.S. Wu", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jv", "JV - J. Vergidis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jw", "JW - J. Wilson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jwr", "JWR - J.W. Rieke", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("jy", "JY - J. Yun", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("kag", "KAG - K.A. Gelmon", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("kc", "KC - K. Chu", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("kcm", "KCM - K.C. Murphy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("kds", "KDS - K.D. Swenerton", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("kek", "KEK - K.E. Khoo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("kj", "KJ - K. Jasas", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("kjg", "KJG - K.J. Goddard", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("kjs", "KJS - K.J. Savage", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("klb", "KLB - K.L. Brown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("knc", "KNC - K.N. Chi", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("krm", "KRM - K.R. Mills", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ksw", "KSW - K.S. Wilson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("lf", "LF - L. Fung", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("lhl", "LHL - L.H. Le", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("lhs", "LHS - L.H. Sehn", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("lm", "LM - L. Martin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("lw", "LW - L. Weir", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("lxw", "LXW - L. Warshawski", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ma", "MA - M. Abd-el-Malek", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("maa", "MAA - M. Almahmudi", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mad", "MAD - M.A. Delorme", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("maf", "MAF - M.A. Fortin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mah", "MAH - M.A. Hussain", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mak", "MAK - M.A. Knowling", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mam", "MAM - M.A. Mildenberger", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mat", "MAT - M.A. Taylor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mb", "MB - M. Bertrand", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mcl", "MCL - M.C.C. Liu", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mcp", "MCP - M.C. Po", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mdh", "MDH - M.D. Hafermann", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mdp", "MDP - M.D. Peacock", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mfm", "MFM - M.F. MANJI", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mh", "MH - M. Heywood", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mj", "MJ - M. Jovanovic", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mjb", "MJB - M.J. Barnett", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mjf", "MJF - M.J. Follwell", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mjm", "MJM - M.J. McLaughlin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mjt", "MJT - M.J. Taylor", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mk", "MK - M. Keyes", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mkk", "MKK - M.K. Khan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mlb", "MLB - M.L. Brigden", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mld", "MLD - M.L. Davis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mmm", "MMM - M.M. Manji", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mn", "MN - M. Nazerali", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mp", "MP - M. Pomeroy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mr", "MR - M. Reed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mrm", "MRM - M.R. McKenzie", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ms", "MS - M. Sia", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mt", "MT - M.T. Turko", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mv", "MV - M. Vlachaki", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mvm", "MVM - M.V. MacNeil", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("mwa", "MWA - M.W. Ashford", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("nam", "NAM - N.A. Macpherson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("nb", "NB - N. Bruchovsky", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("njv", "NJV - N.J.S. Voss", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("nl", "NL - N. Leong", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("nld", "NLD - N.L. Davis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("nn", "NN - N. Nicolaou", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ns", "NS - N. Shahid", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("nw", "NW - N. Wilson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pab", "PAB - P.A. Blood", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pag", "PAG - P.A. Gfeller-Ingledew", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pal", "PAL - P.A. Leco", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pb", "PB - P. Burgi", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pc", "PC - P. Coy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pd", "PD - P. Dixon", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pg", "PG - P. Graham", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pgk", "PGK - P.G. Kenny", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ph", "PH - P. Hoskins", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pjf", "PJF - P. J. Froud", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pk", "PK - P. Klimo", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pl", "PL - P. Lim", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pmc", "PMC - P.M. Czaykowski", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("prb", "PRB - P.R. Band", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("pt", "PT - P. Tallos", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ptt", "PTT - P.T. Truong", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rdo", "RDO - R.D. Ostlund", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rdw", "RDW - R.D. Winston", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("reb", "REB - R.E. Beck", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rec", "REC - R.E. Cheifetz", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rhc", "RHC - R.H. Chowdhury", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rjk", "RJK - R.J. Klasa", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rm", "RM - R. Ma", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rmh", "RMH - R.M. Halperin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rnf", "RNF - R.N. Fairey", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rnm", "RNM - R.N. Murray", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ro", "RO - R. Olson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rps", "RPS - R.P.S. Sawhney", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rrl", "RRL - R.R. Love", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("rs", "RS - R. Samant", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sa", "SA - S. Alexander", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("saa", "SAA - S. Arif", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sat", "SAT - S. Tyldesley", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sbs", "SBS - S.B. Sutcliffe", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("scr", "SCR - S.C. Rao", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sdl", "SDL - S.D. Lucas", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("seo", "SEO - S.E. O'Reilly", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sep", "SEP - S.E. Parameswaran", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sfs", "SFS - S.F. Souliere", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sg", "SG - S. Gill", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("shn", "SHN - S.H. Nantel", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sia", "SIA - S. Atrchian", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sja", "SJA - S.J. Allan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("skc", "SKC - S.K. Chia", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("skl", "SKL - S.K. Loewen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sl", "SL - S. Larsson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("slb", "SLB - S.L. Balkwill", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sle", "SLE - S.L. Ellard", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("slg", "SLG - S.L. Goldenberg", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sm", "SM - S. Miller", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("smj", "SMJ - S.M. Jackson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sna", "SNA - S.N. Ahmed", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("snh", "SNH - S.N. Hamilton", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ss", "SS - S. Smith", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("st", "ST - S. Thomson", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sty", "STY - S. Tyler", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sv", "SV - S. Vermeulen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("svl", "SVL - S. Lefresne", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("sxl", "SXL - S. Lam", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("tak", "TAK - T.A. Koulis", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("tap", "TAP - T.A. Pickles", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("tb", "TB - T. Berrang", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("td", "TD - T. Do", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("te", "TE - T. Ehlen", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("tht", "THT - T. Trotter", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("tk", "TK - T. Keane", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("tn", "TN - T. Nevill", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ts", "TS - T. Shenkier", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("tt", "TT - T. Tolcher", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("tw", "TW - T. Walia", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("twc", "TWC - T.W. Chan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("ul", "UL - U. Lee", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("vb", "VB - V. Bernstein", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("veb", "VEB - V.E. Basco", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("vg", "VG - V. Goutsouliak", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("vh", "VH - V. Ho", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("vk", "VK - V. Krause", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("vt", "VT - V. Tsang", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("vy", "VY - V. Yau", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("wbk", "WBK - W.B. Kwan", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("wcm", "WCM - W.C. MacDonald", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("wjm", "WJM - W.J. Morris", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("wmw", "WMW - W.M. Wisbeck", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("wyl", "WYL - W.Y. Lam", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("yz", "YZ - Y. Zhou", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("zzz", "ZZZ -  UNKNOWN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'bc_nbi_physician_type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_physician_types') , '0', '', '', '', 'type', ''), 
('ClinicalAnnotation', 'ParticipantContact', 'participant_contacts', 'bc_nbi_pre_2003_physician_name', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_pre_2003_physicians') , '0', '', '', '', 'pre 2003 physician', '');
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
("0", "0 - Not Known", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("1", "1 - Pre-Menopause", "", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("3", "3 - Post-Menopause", "", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("4", "4 - Pregnant", "", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
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
INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('Initial Radiotherapy Plan', 1, 250, 'clinical - treatment');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('bc_nbi_init_finrt', "StructurePermissibleValuesCustom::getCustomDropdown('Initial Radiotherapy Plan')");
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Initial Radiotherapy Plan');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("0 - no initial breast/chest wall or nodal rt", "0 - no initial breast/chest wall or nodal RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),			
("1 - initial breast/chest wall rt alone", "1 - initial breast/chest wall RT alone", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),			
("2 - initial breast/chest wall rt + regional nodal rt", "2 - initial breast/chest wall RT + regional nodal RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),			
("3 - regional nodal rt alone", "3 - regional nodal RT alone", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),			
("4 - brachy", "4 - brachy", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
INSERT INTO structures(`alias`) VALUES ('bc_nbi_txd_radiations_at_dx');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'init_rt_boost', 'yes_no',  NULL , '0', '', '', 'bc_help_nbi_init_rt_boost', 'rt boost at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'init_rt_brachy', 'yes_no',  NULL , '0', '', '', 'bc_help_nbi_init_rt_brachy', 'rt brachy at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'init_rt_brchw', 'yes_no',  NULL , '0', '', '', 'bc_help_nbi_init_rt_brchw', 'rt brchw at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'init_rt_nodal', 'yes_no',  NULL , '0', '', '', 'bc_help_nbi_init_rt_nodal', 'rt node at init dx', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'rtoutofprov', 'checkbox',  NULL , '0', '', '', 'bc_help_nbi_rtoutofprov', 'rt out of province', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations_at_dx', 'init_finrt', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_init_finrt') , '0', '', '', 'bc_help_nbi_init_finrt', 'rt at init dx', '');
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
('Radiotherapy Treatment Region', 1, 250, 'clinical - treatment');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('bc_nbi_rt_treat_region', "StructurePermissibleValuesCustom::getCustomDropdown('Radiotherapy Treatment Region')");
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Treatment Region');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("abd - abdomen nos", "ABD - ABDOMEN NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("abl - abdomen-lower", "ABL - ABDOMEN-LOWER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("abll - abdomen-lower left", "ABLL - ABDOMEN-LOWER LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ablr - abdomen-lower right", "ABLR - ABDOMEN-LOWER RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("abu - abdomen-upper", "ABU - ABDOMEN-UPPER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("abul - abdomen-upper left", "ABUL - ABDOMEN-UPPER LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("abur - abdomen-upper right", "ABUR - ABDOMEN-UPPER RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("abw - abdomen-whole", "ABW - ABDOMEN-WHOLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("adr - adrenal", "ADR - ADRENAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("adrb - adrenal-bilateral", "ADRB - ADRENAL-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("adrl - adrenal-left", "ADRL - ADRENAL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("adrr - adrenal-right", "ADRR - ADRENAL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ais - axi+im+supraclav", "AIS - AXI+IM+SUPRACLAV", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("aisl - axi+im+supraclav-lt", "AISL - AXI+IM+SUPRACLAV-LT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("aisr - axi+im+supraclav-rt", "AISR - AXI+IM+SUPRACLAV-RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ank - ankle", "ANK - ANKLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ankb - ankle-bilateral", "ANKB - ANKLE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ankl - ankle-left", "ANKL - ANKLE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ankr - ankle-right", "ANKR - ANKLE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ant - antrum", "ANT - ANTRUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("antl - antrum-left", "ANTL - ANTRUM-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("antr - antrum-right", "ANTR - ANTRUM-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("anu - anus", "ANU - ANUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("arm - arm", "ARM - ARM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("armb - arm-bilateral", "ARMB - ARM-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("arml - arm-left", "ARML - ARM-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("armr - arm-right", "ARMR - ARM-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("axi - axilla", "AXI - AXILLA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("axib - axilla-bilateral", "AXIB - AXILLA-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("axil - axilla-left", "AXIL - AXILLA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("axir - axilla-right", "AXIR - AXILLA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("axs - axilla + supraclav node", "AXS - AXILLA + SUPRACLAV NODE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("axsl - axilla + supraclav n-lt", "AXSL - AXILLA + SUPRACLAV N-LT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("axsr - axilla + supraclav n-rt", "AXSR - AXILLA + SUPRACLAV N-RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bac - back", "BAC - BACK", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bacl - back-left", "BACL - BACK-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bacr - back-right", "BACR - BACK-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bax - breast + axilla", "BAX - BREAST + AXILLA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("baxl - breast + axilla-left", "BAXL - BREAST + AXILLA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("baxr - breast + axilla-right", "BAXR - BREAST + AXILLA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bil - bile duct", "BIL - BILE DUCT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bla - bladder", "BLA - BLADDER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("blal - bladder-left", "BLAL - BLADDER-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("blar - bladder-right", "BLAR - BLADDER-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("blh - lower half body", "BLH - LOWER HALF BODY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bli - both lip", "BLI - BOTH LIP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("blil - both lip-left", "BLIL - BOTH LIP-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("blir - both lip-right", "BLIR - BOTH LIP-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bon2 - bone-2", "BON2 - BONE-2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bon3 - bone-3", "BON3 - BONE-3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bon4 - bone-4", "BON4 - BONE-4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bon5 - bone-5", "BON5 - BONE-5", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bon6 - bone-6", "BON6 - BONE-6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bon7 - bone-7", "BON7 - BONE-7", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bon8 - bone-8", "BON8 - BONE-8", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bon9 - bone-9", "BON9 - BONE-9", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bonb - bone-bilateral", "BONB - BONE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bonl - bone-left", "BONL - BONE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bonm - bone-multiple", "BONM - BONE-MULTIPLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bonr - bone-right", "BONR - BONE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bpa - body-partial", "BPA - BODY-PARTIAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bpl - breast partial-left", "BPL - BREAST PARTIAL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bpr - breast partial-right", "BPR - BREAST PARTIAL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bra - brain", "BRA - BRAIN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bral - brain-left", "BRAL - BRAIN-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brar - brain-right", "BRAR - BRAIN-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brb - brain boost", "BRB - BRAIN BOOST", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brbl - brain-boost-left", "BRBL - BRAIN-BOOST-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brbr - brain-boost-right", "BRBR - BRAIN-BOOST-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brep - breast-partial", "BREP - BREAST-PARTIAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brf - breast-off", "BRF - BREAST-OFF", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brfb - breast-off-bilateral", "BRFB - BREAST-OFF-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brfl - breast-off-left", "BRFL - BREAST-OFF-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brfr - breast-off-right", "BRFR - BREAST-OFF-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brh - brain half", "BRH - BRAIN HALF", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brhl - brain-half-left", "BRHL - BRAIN-HALF-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brhr - brain-half-right", "BRHR - BRAIN-HALF-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bril - breast+imc-left", "BRIL - BREAST+IMC-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brir - breast+imc-right", "BRIR - BREAST+IMC-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bro - breast-on", "BRO - BREAST-ON", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brob - breast-on-bilateral", "BROB - BREAST-ON-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brol - breast-on-left", "BROL - BREAST-ON-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bron - bronchus", "BRON - BRONCHUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bror - breast-on-right", "BROR - BREAST-ON-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brp - brain-partial", "BRP - BRAIN-PARTIAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brpl - brain-partial-left", "BRPL - BRAIN-PARTIAL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brpr - brain-partial-right", "BRPR - BRAIN-PARTIAL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brq - brain quarter", "BRQ - BRAIN QUARTER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brql - brain-quarter-left", "BRQL - BRAIN-QUARTER-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brqr - brain-quarter-right", "BRQR - BRAIN-QUARTER-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("brw - brain whole", "BRW - BRAIN WHOLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("buc - buccal mucosa", "BUC - BUCCAL MUCOSA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bucl - buccal mucosa-left", "BUCL - BUCCAL MUCOSA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("bucr - buccal mucosa-right", "BUCR - BUCCAL MUCOSA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("buh - upper half body", "BUH - UPPER HALF BODY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("but - buttocks", "BUT - BUTTOCKS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("butb - buttocks-bilateral", "BUTB - BUTTOCKS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("butl - buttocks-left", "BUTL - BUTTOCKS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("butr - buttocks-right", "BUTR - BUTTOCKS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("cbs - cerebrospinal", "CBS - CEREBROSPINAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("cer - cervix", "CER - CERVIX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("che - chest", "CHE - CHEST", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("chel - chest-left", "CHEL - CHEST-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("cher - chest-right", "CHER - CHEST-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("chn - chest + neck", "CHN - CHEST + NECK", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("chnl - chest + neck - left", "CHNL - CHEST + NECK - LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("chnr - chest + neck - right", "CHNR - CHEST + NECK - RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("chs - chest + supraclav node", "CHS - CHEST + SUPRACLAV NODE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("chsl - chest & supraclav node-lt", "CHSL - CHEST & SUPRACLAV NODE-LT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("chsr - chest + supraclav node-rt", "CHSR - CHEST + SUPRACLAV NODE-RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("chw - chest wall", "CHW - CHEST WALL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("chwl - chest wall-left", "CHWL - CHEST WALL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("chwr - chest wall-right", "CHWR - CHEST WALL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("cla - clavicle", "CLA - CLAVICLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("clab - clavicle-bilateral", "CLAB - CLAVICLE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("clal - clavicle-left", "CLAL - CLAVICLE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("clar - clavicle-right", "CLAR - CLAVICLE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("coc - coccyx", "COC - COCCYX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("col - colon", "COL - COLON", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("coll - colon-left", "COLL - COLON-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("colr - colon-right", "COLR - COLON-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("csp - cervical spine", "CSP - CERVICAL SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("cts - cervical & thoracic spine", "CTS - CERVICAL & THORACIC SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("cwil - chest wall+imc-left", "CWIL - CHEST WALL+IMC-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("cwir - chest wall+imc-right", "CWIR - CHEST WALL+IMC-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ear - ear", "EAR - EAR", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("earb - ear-bilateral", "EARB - EAR-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("earl - ear-left", "EARL - EAR-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("earr - ear-right", "EARR - EAR-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("epi - epigastrium", "EPI - EPIGASTRIUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("esl - esophagus-lower", "ESL - ESOPHAGUS-LOWER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("esm - esophagus-middle", "ESM - ESOPHAGUS-MIDDLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("eso - esophagus-nos", "ESO - ESOPHAGUS-NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("esu - esophagus-upper", "ESU - ESOPHAGUS-UPPER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("eth - ethmoid sinus", "ETH - ETHMOID SINUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ext - extended field", "EXT - EXTENDED FIELD", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("eye - eye", "EYE - EYE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("eyeb - eye-bilateral", "EYEB - EYE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("eyel - eye-left", "EYEL - EYE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("eyer - eye-right", "EYER - EYE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fac - face", "FAC - FACE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("facl - face-left", "FACL - FACE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("facr - face-right", "FACR - FACE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fal - fallopian tubes", "FAL - FALLOPIAN TUBES", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("falb - fallopian tube-bilateral", "FALB - FALLOPIAN TUBE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fall - fallopian tube-left", "FALL - FALLOPIAN TUBE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("falr - fallopian tube-right", "FALR - FALLOPIAN TUBE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fem - femur", "FEM - FEMUR", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("femb - femur-bilateral", "FEMB - FEMUR-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("feml - femur-left", "FEML - FEMUR-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("femr - femur-right", "FEMR - FEMUR-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fib - fibula", "FIB - FIBULA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fibb - fibula-bilateral", "FIBB - FIBULA-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fibl - fibula-left", "FIBL - FIBULA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fibr - fibula-right", "FIBR - FIBULA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fin - finger (includes thumb)", "FIN - FINGER (INCLUDES THUMB)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("finb - finger(incl.thumb)-bil", "FINB - FINGER(INCL.THUMB)-BIL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("finl - finger(incl.thumb)-left", "FINL - FINGER(INCL.THUMB)-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("finr - finger(incl.thumb)-rt", "FINR - FINGER(INCL.THUMB)-RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fla - flank", "FLA - FLANK", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("flal - flank-left", "FLAL - FLANK-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("flar - flank-right", "FLAR - FLANK-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("flo - floor of mouth", "FLO - FLOOR OF MOUTH", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("flol - floor of mouth-left", "FLOL - FLOOR OF MOUTH-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("flor - floor of mouth-right", "FLOR - FLOOR OF MOUTH-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("foo - foot", "FOO - FOOT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("foob - foot-bilateral", "FOOB - FOOT-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fool - foot-left", "FOOL - FOOT-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("foor - foot-right", "FOOR - FOOT-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fos - posterior fossa", "FOS - POSTERIOR FOSSA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("fro - frontal sinus", "FRO - FRONTAL SINUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("gal - gall bladder", "GAL - GALL BLADDER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("gin - gingiva", "GIN - GINGIVA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ginl - gingiva-left", "GINL - GINGIVA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ginr - gingiva-right", "GINR - GINGIVA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("han - hand", "HAN - HAND", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hanb - hand-bilateral", "HANB - HAND-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hanl - hand-left", "HANL - HAND-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hanr - hand-right", "HANR - HAND-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hdn - head and neck", "HDN - HEAD AND NECK", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hdnl - head and neck-left", "HDNL - HEAD AND NECK-Left", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hdnr - head and neck-right", "HDNR - HEAD AND NECK-Right", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hea - head", "HEA - HEAD", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("heal - head-left", "HEAL - HEAD-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hear - head-right", "HEAR - HEAD-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hee - heel", "HEE - HEEL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("heeb - heel-bilateral", "HEEB - HEEL-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("heel - heel-left", "HEEL - HEEL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("heer - heel-right", "HEER - HEEL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("her - heart", "HER - HEART", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hip - hip", "HIP - HIP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hipb - hip-bilateral", "HIPB - HIP-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hipl - hip-left", "HIPL - HIP-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hipr - hip-right", "HIPR - HIP-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hum - humerus", "HUM - HUMERUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("humb - humerus-bilateral", "HUMB - HUMERUS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("huml - humerus-left", "HUML - HUMERUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("humr - humerus-right", "HUMR - HUMERUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("hyp - hypopharynx", "HYP - HYPOPHARYNX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ica - inner canthus", "ICA - INNER CANTHUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("icab - inner canthus-bilateral", "ICAB - INNER CANTHUS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ical - inner canthus-left", "ICAL - INNER CANTHUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("icar - inner canthus-right", "ICAR - INNER CANTHUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ili - ilium", "ILI - ILIUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ilil - ilium-left", "ILIL - ILIUM-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ilir - ilium-right", "ILIR - ILIUM-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ing - inguinal", "ING - INGUINAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ingb - inguinal-bilateral", "INGB - INGUINAL-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ingl - inguinal-left", "INGL - INGUINAL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ingr - inguinal-right", "INGR - INGUINAL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("inm - int.mammary", "INM - INT.MAMMARY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("inmb - int.mammary-bilateral", "INMB - INT.MAMMARY-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("inml - int.mammary-left", "INML - INT.MAMMARY-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("inmr - int.mammary-right", "INMR - INT.MAMMARY-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("isc - ischium", "ISC - ISCHIUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("jaw - mandible", "JAW - MANDIBLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("jawl - mandible-left", "JAWL - MANDIBLE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("jawr - mandible-right", "JAWR - MANDIBLE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("kid - kidney", "KID - KIDNEY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("kidb - kidney-bilateral", "KIDB - KIDNEY-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("kidl - kidney-left", "KIDL - KIDNEY-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("kidr - kidney-right", "KIDR - KIDNEY-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("kne - knee", "KNE - KNEE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("kneb - knee-bilateral", "KNEB - KNEE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("knel - knee-left", "KNEL - KNEE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("kner - knee-right", "KNER - KNEE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lac - lacrimal gland", "LAC - LACRIMAL GLAND", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lacb - lacrimal gland-bilateral", "LACB - LACRIMAL GLAND-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lacl - lacrimal gland-left", "LACL - LACRIMAL GLAND-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lacr - lacrimal gland-right", "LACR - LACRIMAL GLAND-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lar - larynx", "LAR - LARYNX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("leg - leg", "LEG - LEG", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("legb - leg-bilateral", "LEGB - LEG-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("legl - leg-left", "LEGL - LEG-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("legr - leg-right", "LEGR - LEG-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lid - eyelid", "LID - EYELID", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lidb - eyelid-bilateral", "LIDB - EYELID-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lidl - eyelid-left", "LIDL - EYELID-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lidr - eyelid-right", "LIDR - EYELID-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("liv - liver", "LIV - LIVER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("llb - limb-lower-bone", "LLB - LIMB-LOWER-BONE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("llbl - limb-lower-bone-left", "LLBL - LIMB-LOWER-BONE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("llbr - limb-lower-bone-right", "LLBR - LIMB-LOWER-BONE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lli - lower lip", "LLI - LOWER LIP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("llil - lower lip-left", "LLIL - LOWER LIP-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("llir - lower lip-right", "LLIR - LOWER LIP-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lsp - lumbar spine", "LSP - LUMBAR SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lss - lumbosacral spine", "LSS - LUMBOSACRAL SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lub - limb-upper-bone", "LUB - LIMB-UPPER-BONE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lubl - limb-upper-bone-left", "LUBL - LIMB-UPPER-BONE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lubr - limb-upper-bone-right", "LUBR - LIMB-UPPER-BONE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lun - lung", "LUN - LUNG", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lunb - lung-bilateral", "LUNB - LUNG-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lunl - lung-left", "LUNL - LUNG-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("lunr - lung-right", "LUNR - LUNG-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("man - mantle", "MAN - MANTLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("max - maxilla", "MAX - MAXILLA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("maxl - maxilla-left", "MAXL - MAXILLA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("maxr - maxilla-right", "MAXR - MAXILLA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("med - mediastinum", "MED - MEDIASTINUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("mul - multiple regions", "MUL - MULTIPLE REGIONS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nac - nasal cavity", "NAC - NASAL CAVITY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nacl - nasal cavity-left", "NACL - NASAL CAVITY-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nacr - nasal cavity-right", "NACR - NASAL CAVITY-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("naf - nasolabial fold", "NAF - NASOLABIAL FOLD", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nas - nasopharynx", "NAS - NASOPHARYNX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nec - neck (includes nodes)", "NEC - NECK (INCLUDES NODES)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("necb - neck(incl.nodes)-bil", "NECB - NECK(INCL.NODES)-BIL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("necl - neck(incl.nodes)-left", "NECL - NECK(INCL.NODES)-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("necr - neck(incl.nodes)-right", "NECR - NECK(INCL.NODES)-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nelb - neck lower-bilateral", "NELB - NECK LOWER-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nell - neck lower-left", "NELL - NECK LOWER-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nelr - neck lower-right", "NELR - NECK LOWER-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nod - nodal", "NOD - NODAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nos - nose", "NOS - NOSE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nosl - nose-left", "NOSL - NOSE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("nosr - nose-right", "NOSR - NOSE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("oca - outer canthus", "OCA - OUTER CANTHUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ocab - outer canthus-bilateral", "OCAB - OUTER CANTHUS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ocal - outer canthus-left", "OCAL - OUTER CANTHUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ocar - outer canthus-right", "OCAR - OUTER CANTHUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ora - oral cavity", "ORA - ORAL CAVITY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("oral - oral cavity-left", "ORAL - ORAL CAVITY-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("orar - oral cavity-right", "ORAR - ORAL CAVITY-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("orb - orbit", "ORB - ORBIT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("orbb - orbit-bilateral", "ORBB - ORBIT-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("orbl - orbit-left", "ORBL - ORBIT-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("orbr - orbit-right", "ORBR - ORBIT-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("oro - oropharynx", "ORO - OROPHARYNX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ova - ovary", "OVA - OVARY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ovab - ovary-bilateral", "OVAB - OVARY-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("oval - ovary-left", "OVAL - OVARY-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ovar - ovary-right", "OVAR - OVARY-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pah - palate hard", "PAH - PALATE HARD", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pahl - palate hard-left", "PAHL - PALATE HARD-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pahr - palate hard-right", "PAHR - PALATE HARD-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pal - palate", "PAL - PALATE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pan - pancreas", "PAN - PANCREAS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pao - para-aortic", "PAO - PARA-AORTIC", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("paol - para-aortic-left", "PAOL - PARA-AORTIC-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("paor - para-aortic-right", "PAOR - PARA-AORTIC-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pap - para-aort&pelvis", "PAP - PARA-AORT&PELVIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("par - parotid", "PAR - PAROTID", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("parb - parotid-bilateral", "PARB - PAROTID-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("parl - parotid-left", "PARL - PAROTID-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("parr - parotid-right", "PARR - PAROTID-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pas - palate soft", "PAS - PALATE SOFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pasl - palate soft-left", "PASL - PALATE SOFT-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pasr - palate soft-right", "PASR - PALATE SOFT-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pbo - pelvis bones, nos", "PBO - PELVIS BONES, NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pbob - pelvis bones-bilateral", "PBOB - PELVIS BONES-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pbol - pelvis bones-left", "PBOL - PELVIS BONES-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pbor - pelvis bones-right", "PBOR - PELVIS BONES-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pel - pelvis, nos", "PEL - PELVIS, NOS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pelb - pelvis-bilateral", "PELB - PELVIS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pell - pelvis-left", "PELL - PELVIS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pelr - pelvis-right", "PELR - PELVIS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pen - penis", "PEN - PENIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("per - perineum", "PER - PERINEUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pha - pharynx", "PHA - PHARYNX", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("phal - pharynx-left", "PHAL - PHARYNX-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("phar - pharynx-right", "PHAR - PHARYNX-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pit - pituitary", "PIT - PITUITARY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ple - pleura", "PLE - PLEURA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pleb - pleura - bilateral", "PLEB - PLEURA - BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("plel - pleura-left", "PLEL - PLEURA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pler - pleura-right", "PLER - PLEURA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pln - pelvic lymph nodes", "PLN - PELVIC LYMPH NODES", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pol - pelvic organ &lymph nodes", "POL - PELVIC ORGAN &LYMPH NODES", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pro - prostate", "PRO - PROSTATE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pub - pubis", "PUB - PUBIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pubb - pubis-bilateral", "PUBB - PUBIS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("publ - pubis-left", "PUBL - PUBIS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("pubr - pubis-right", "PUBR - PUBIS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("rad - radius", "RAD - RADIUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("radb - radius-bilateral", "RADB - RADIUS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("radl - radius-left", "RADL - RADIUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("radr - radius-right", "RADR - RADIUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("rec - rectum (includes sigmoid)", "REC - RECTUM (INCLUDES SIGMOID)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ret - retroperitoneum", "RET - RETROPERITONEUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("rib - rib(s)", "RIB - RIB(S)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ribb - rib(s)-bilateral", "RIBB - RIB(S)-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ribl - rib(s)-left", "RIBL - RIB(S)-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ribr - rib(s)-right", "RIBR - RIB(S)-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("sac - sacrum", "SAC - SACRUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("sacl - sacrum-left", "SACL - SACRUM-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("sacr - sacrum-right", "SACR - SACRUM-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("sca - scapula", "SCA - SCAPULA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scab - scapula-bilateral", "SCAB - SCAPULA-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scal - scapula-left", "SCAL - SCAPULA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scar - scapula-right", "SCAR - SCAPULA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scn - supraclavicular nodes", "SCN - SUPRACLAVICULAR NODES", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scnb - supraclavicular nodes-bil", "SCNB - SUPRACLAVICULAR NODES-BIL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scnl - supraclavicular nodes-lt", "SCNL - SUPRACLAVICULAR NODES-LT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scnr - supraclavicular nodes-rt", "SCNR - SUPRACLAVICULAR NODES-RT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scp - scalp", "SCP - SCALP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scpb - scalp-bilateral", "SCPB - SCALP-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scpl - scalp-left", "SCPL - SCALP-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scpr - scalp-right", "SCPR - SCALP-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scr - scrotum", "SCR - SCROTUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scrb - scrotum-bilateral", "SCRB - SCROTUM-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scrl - scrotum-left", "SCRL - SCROTUM-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("scrr - scrotum-right", "SCRR - SCROTUM-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("sho - shoulder", "SHO - SHOULDER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("shob - shoulder-bilateral", "SHOB - SHOULDER-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("shol - shoulder-left", "SHOL - SHOULDER-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("shor - shoulder-right", "SHOR - SHOULDER-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ski - skin", "SKI - SKIN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ski2 - skin-2", "SKI2 - SKIN-2", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ski3 - skin-3", "SKI3 - SKIN-3", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ski4 - skin-4", "SKI4 - SKIN-4", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ski5 - skin-5", "SKI5 - SKIN-5", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ski6 - skin-6", "SKI6 - SKIN-6", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ski7 - skin-7", "SKI7 - SKIN-7", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ski8 - skin-8", "SKI8 - SKIN-8", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ski9 - skin-9", "SKI9 - SKIN-9", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("skil - skin-left", "SKIL - SKIN-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("skim - skin-multiple", "SKIM - SKIN-MULTIPLE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("skir - skin-right", "SKIR - SKIN-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("sku - skull", "SKU - SKULL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("skul - skull-left", "SKUL - SKULL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("skur - skull-right", "SKUR - SKULL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("sph - sphenoid sinus", "SPH - SPHENOID SINUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("sphl - sphenoid sinus-left", "SPHL - SPHENOID SINUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("sphr - sphenoid sinus-right", "SPHR - SPHENOID SINUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("spl - spleen", "SPL - SPLEEN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("spn - spine", "SPN - SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("spt - thoracic & lumbar spine", "SPT - THORACIC & LUMBAR SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ste - sternum", "STE - STERNUM", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("sto - stomach", "STO - STOMACH", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("sub - submandibular glands", "SUB - SUBMANDIBULAR GLANDS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("subb - submandibular gland-bil", "SUBB - SUBMANDIBULAR GLAND-BIL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("subl - submandibular gland-left", "SUBL - SUBMANDIBULAR GLAND-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("subr - submandibular gland-right", "SUBR - SUBMANDIBULAR GLAND-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tes - testis", "TES - TESTIS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tesb - testis-bilateral", "TESB - TESTIS-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tesl - testis-left", "TESL - TESTIS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tesr - testis-right", "TESR - TESTIS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("thy - thyroid", "THY - THYROID", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tib - tibia", "TIB - TIBIA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tibb - tibia-bilateral", "TIBB - TIBIA-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tibl - tibia-left", "TIBL - TIBIA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tibr - tibia-right", "TIBR - TIBIA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tng - tongue", "TNG - TONGUE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tngl - tongue-left", "TNGL - TONGUE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tngr - tongue-right", "TNGR - TONGUE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("toe - toe(s)", "TOE - TOE(S)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("toeb - toe-bilateral", "TOEB - TOE-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("toel - toe-left", "TOEL - TOE-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("toer - toe-right", "TOER - TOE-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ton - tonsil", "TON - TONSIL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tonl - tonsil-left", "TONL - TONSIL-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tonr - tonsil-right", "TONR - TONSIL-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tra - trachea", "TRA - TRACHEA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("tsp - thoracic spine", "TSP - THORACIC SPINE", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ukn - unknown", "UKN - UNKNOWN", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("uli - upper lip", "ULI - UPPER LIP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ulil - upper lip-left", "ULIL - UPPER LIP-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ulir - upper lip-right", "ULIR - UPPER LIP-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("uln - ulna", "ULN - ULNA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ulnb - ulna-bilateral", "ULNB - ULNA-BILATERAL", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ulnl - ulna-left", "ULNL - ULNA-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ulnr - ulna-right", "ULNR - ULNA-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ure - ureter", "URE - URETER", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("urel - ureter-left", "UREL - URETER-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("urer - ureter-right", "URER - URETER-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("urt - urethra", "URT - URETHRA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("usl - unspecified lip", "USL - UNSPECIFIED LIP", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("ute - uterus", "UTE - UTERUS", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("utel - uterus-left", "UTEL - UTERUS-LEFT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("uter - uterus-right", "UTER - UTERUS-RIGHT", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("utva - uterus and vagina", "UTVA - UTERUS AND VAGINA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("uvu - uvula", "UVU - UVULA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("vag - vagina", "VAG - VAGINA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("vul - vulva", "VUL - VULVA", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("war - waldeyer's ring", "WAR - WALDEYER'S RING", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("whb - whole body", "WHB - WHOLE BODY", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_permissible_values_custom_controls 
(name, flag_active, values_max_length, category) 
VALUES
('Radiotherapy Treatment Technique', 1, 250, 'clinical - treatment');
INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('bc_nbi_rt_technique', "StructurePermissibleValuesCustom::getCustomDropdown('Radiotherapy Treatment Technique')");
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Treatment Technique');
SET @user_id = 2;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("01 - single field r", "01 - SINGLE FIELD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01a - single field-a r", "01A - SINGLE FIELD-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01b - single field-b r", "01B - SINGLE FIELD-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01c - single field-c r", "01C - SINGLE FIELD-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01d - single field-d r", "01D - SINGLE FIELD-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01e - single field-e r", "01E - SINGLE FIELD-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01f - single field-f r", "01F - SINGLE FIELD-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01g - single field-g r", "01G - SINGLE FIELD-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01h - single field-h r", "01H - SINGLE FIELD-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01i - single field-i r", "01I - SINGLE FIELD-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01j - single field-j r", "01J - SINGLE FIELD-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01k - single field-k r", "01K - SINGLE FIELD-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01l - single field-l r", "01L - SINGLE FIELD-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01m - single field-m r", "01M - SINGLE FIELD-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01n - single field-n r", "01N - SINGLE FIELD-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01r - single field-r r", "01R - SINGLE FIELD-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01s - single field-s r", "01S - SINGLE FIELD-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("01u - single field-u r", "01U - SINGLE FIELD-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02 - 2 fields para r", "02 - 2 FIELDS PARA R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02a - 2 fields para-a r", "02A - 2 FIELDS PARA-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02b - 2 fields para-b r", "02B - 2 FIELDS PARA-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02c - 2 fields para-c r", "02C - 2 FIELDS PARA-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02d - 2 fields para-d r", "02D - 2 FIELDS PARA-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02e - 2 fields para-e r", "02E - 2 FIELDS PARA-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02f - 2 fields para-f r", "02F - 2 FIELDS PARA-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02g - 2 fields para-g r", "02G - 2 FIELDS PARA-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02h - 2 fields para-h r", "02H - 2 FIELDS PARA-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02i - 2 fields para-i r", "02I - 2 FIELDS PARA-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02j - 2 fields para-j r", "02J - 2 FIELDS PARA-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02k - 2 fields para-k r", "02K - 2 FIELDS PARA-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02l - 2 fields para-l r", "02L - 2 FIELDS PARA-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02m - 2 fields para-m r", "02M - 2 FIELDS PARA-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02n - 2 fields para-n r", "02N - 2 FIELDS PARA-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02o - 2 fields para-o r", "02O - 2 FIELDS PARA-O R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02r - 2 fields para-r r", "02R - 2 FIELDS PARA-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02s - 2 fields para-s r", "02S - 2 FIELDS PARA-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("02u - 2 fields para-u r", "02U - 2 FIELDS PARA-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03 - 2 fields tang r", "03 - 2 FIELDS TANG R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03a - 2 fields tang-a r", "03A - 2 FIELDS TANG-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03b - 2 fields tang-b r", "03B - 2 FIELDS TANG-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03c - 2 fields tang-c r", "03C - 2 FIELDS TANG-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03d - 2 fields tang-d r", "03D - 2 FIELDS TANG-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03e - 2 fields tang-e r", "03E - 2 FIELDS TANG-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03f - 2 fields tang-f r", "03F - 2 FIELDS TANG-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03g - 2 fields tang-g r", "03G - 2 FIELDS TANG-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03h - 2 fields tang-h r", "03H - 2 FIELDS TANG-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03i - 2 fields tang-i r", "03I - 2 FIELDS TANG-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03j - 2 fields tang-j r", "03J - 2 FIELDS TANG-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03k - 2 fields tang-k r", "03K - 2 FIELDS TANG-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03l - 2 fields tang-l r", "03L - 2 FIELDS TANG-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03m - 2 fields tang-m r", "03M - 2 FIELDS TANG-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03n - 2 fields tang-n r", "03N - 2 FIELDS TANG-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03r - 2 fields tang-r r", "03R - 2 FIELDS TANG-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("03s - 2 fields tang-s r", "03S - 2 FIELDS TANG-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04 - 2 fields other r", "04 - 2 FIELDS OTHER R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04a - 2 fields-othe-a r", "04A - 2 FIELDS-OTHE-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04b - 2 fields-othe-b r", "04B - 2 FIELDS-OTHE-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04c - 2 fields-othe-c r", "04C - 2 FIELDS-OTHE-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04d - 2 fields-othe-d r", "04D - 2 FIELDS-OTHE-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04e - 2 fields-othe-e r", "04E - 2 FIELDS-OTHE-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04f - 2 fields-othe-f r", "04F - 2 FIELDS-OTHE-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04g - 2 fields-othe-g r", "04G - 2 FIELDS-OTHE-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04h - 2 fields-othe-h r", "04H - 2 FIELDS-OTHE-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04i - 2 fields-othe-i r", "04I - 2 FIELDS-OTHE-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04j - 2 fields-othe-j r", "04J - 2 FIELDS-OTHE-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04k - 2 fields-othe-k r", "04K - 2 FIELDS-OTHE-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04l - 2 fields-othe-l r", "04L - 2 FIELDS-OTHE-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04m - 2 fields-othe-m r", "04M - 2 FIELDS-OTHE-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04n - 2 fields othe-n r", "04N - 2 FIELDS OTHE-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04r - 2 fields-othe-r r", "04R - 2 FIELDS-OTHE-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04s - 2 fields othe-s r", "04S - 2 FIELDS OTHE-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("04u - 2 fields othe-u r", "04U - 2 FIELDS OTHE-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05 - 3 fields r", "05 - 3 FIELDS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05a - 3 fields-a r", "05A - 3 FIELDS-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05b - 3 fields-b r", "05B - 3 FIELDS-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05c - 3 fields-c r", "05C - 3 FIELDS-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05d - 3 fields-d r", "05D - 3 FIELDS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05e - 3 fields-e r", "05E - 3 FIELDS-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05f - 3 fields-f r", "05F - 3 FIELDS-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05g - 3 fields-g r", "05G - 3 FIELDS-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05h - 3 fields-h r", "05H - 3 FIELDS-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05i - 3 fields-i r", "05I - 3 FIELDS-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05j - 3 fields-j r", "05J - 3 FIELDS-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05k - 3 fields-k r", "05K - 3 FIELDS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05l - 3 fields-l r", "05L - 3 FIELDS-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05m - 3 fields-m r", "05M - 3 FIELDS-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05n - 3 fields-n r", "05N - 3 FIELDS-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05r - 3 fields-r r", "05R - 3 FIELDS-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05s - 3 fields-s r", "05S - 3 FIELDS-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("05u - 3 fields-u r", "05U - 3 FIELDS-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06 - 4 fields r", "06 - 4 FIELDS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06a - 4 fields-a r", "06A - 4 FIELDS-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06b - 4 fields-b r", "06B - 4 FIELDS-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06c - 4 fields-c r", "06C - 4 FIELDS-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06d - 4 fields-d r", "06D - 4 FIELDS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06e - 4 fields-e r", "06E - 4 FIELDS-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06f - 4 fields-f r", "06F - 4 FIELDS-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06g - 4 fields-g r", "06G - 4 FIELDS-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06h - 4 fields-h r", "06H - 4 FIELDS-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06i - 4 fields-i r", "06I - 4 FIELDS-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06j - 4 fields-j r", "06J - 4 FIELDS-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06k - 4 fields-k r", "06K - 4 FIELDS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06l - 4 fields-l r", "06L - 4 FIELDS-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06m - 4 fields-m r", "06M - 4 FIELDS-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06n - 4 fields-n r", "06N - 4 FIELDS-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06r - 4 fields-r r", "06R - 4 FIELDS-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("06s - 4 fields-s r", "06S - 4 FIELDS-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07 - 5 fields r", "07 - 5 FIELDS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07a - 5 fields-a r", "07A - 5 FIELDS-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07b - 5 fields-b r", "07B - 5 FIELDS-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07c - 5 fields-c r", "07C - 5 FIELDS-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07d - 5 fields-d r", "07D - 5 FIELDS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07e - 5 fields-e r", "07E - 5 FIELDS-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07f - 5 fields-f r", "07F - 5 FIELDS-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07g - 5 fields-g r", "07G - 5 FIELDS-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07h - 5 fields-h r", "07H - 5 FIELDS-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07i - 5 fields-i r", "07I - 5 FIELDS-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07j - 5 fields-j r", "07J - 5 FIELDS-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07k - 5 fields-k r", "07K - 5 FIELDS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07l - 5 fields-l r", "07L - 5 FIELDS-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07m - 5 fields-m r", "07M - 5 FIELDS-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07n - 5 fields-n r", "07N - 5 FIELDS-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07r - 5 fields-r r", "07R - 5 FIELDS-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("07s - 5 fields-s r", "07S - 5 FIELDS-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08 - breast r", "08 - BREAST R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08a - breast-a r", "08A - BREAST-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08b - breast-b r", "08B - BREAST-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08c - breast-c r", "08C - BREAST-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08d - breast-d r", "08D - BREAST-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08e - breast-e r", "08E - BREAST-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08f - breast-f r", "08F - BREAST-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08g - breast-g r", "08G - BREAST-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08h - breast-h r", "08H - BREAST-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08i - breast-i r", "08I - BREAST-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08j - breast-j r", "08J - BREAST-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08k - breast-k r", "08K - BREAST-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08l - breast-l r", "08L - BREAST-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08m - breast-m r", "08M - BREAST-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08n - breast-n r", "08N - BREAST-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08r - breast-r r", "08R - BREAST-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("08u - breast-u r", "08U - BREAST-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09 - breast-che wall r", "09 - BREAST-CHE WALL R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09a - breast-ch wal-a r", "09A - BREAST-CH WAL-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09b - breast-ch wal-b r", "09B - BREAST-CH WAL-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09c - breast-ch wal-c r", "09C - BREAST-CH WAL-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09d - breast-ch wal-d r", "09D - BREAST-CH WAL-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09e - breast-ch wal-e r", "09E - BREAST-CH WAL-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09f - breast-ch wal-f r", "09F - BREAST-CH WAL-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09g - breast-ch wal-g r", "09G - BREAST-CH WAL-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09h - breast-ch wal-h r", "09H - BREAST-CH WAL-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09i - breast-ch wal-i r", "09I - BREAST-CH WAL-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09j - breast-ch wal-j r", "09J - BREAST-CH WAL-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09k - breast-ch wal-k r", "09K - BREAST-CH WAL-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09l - breast-ch wal-l r", "09L - BREAST-CH WAL-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09m - breast-ch wal-m r", "09M - BREAST-CH WAL-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09n - breast ch wal-n r", "09N - BREAST CH WAL-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09r - breast-ch wal-r r", "09R - BREAST-CH WAL-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("09u - breast-ch wal-u r", "09U - BREAST-CH WAL-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10 - breast-nodal r", "10 - BREAST-NODAL R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10a - breast-nodal-a r", "10A - BREAST-NODAL-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10b - breast-nodal-b r", "10B - BREAST-NODAL-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10c - breast-nodal-c r", "10C - BREAST-NODAL-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10d - breast-nodal-d r", "10D - BREAST-NODAL-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10e - breast-nodal-e r", "10E - BREAST-NODAL-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10f - breast-nodal-f r", "10F - BREAST-NODAL-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10g - breast-nodal-g r", "10G - BREAST-NODAL-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10h - breast-nodal-h r", "10H - BREAST-NODAL-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10i - breast-nodal-i r", "10I - BREAST-NODAL-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10j - breast-nodal-j r", "10J - BREAST-NODAL-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10k - breast-nodal-k r", "10K - BREAST-NODAL-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10l - breast-nodal-l r", "10L - BREAST-NODAL-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10m - breast-nodal-m r", "10M - BREAST-NODAL-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("10n - breast nodal-n r", "10N - BREAST NODAL-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11 - breast-boost r", "11 - BREAST-BOOST R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11a - breast-boost-a r", "11A - BREAST-BOOST-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11b - breast-boost-b r", "11B - BREAST-BOOST-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11c - breast-boost-c r", "11C - BREAST-BOOST-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11d - breast-boost-d r", "11D - BREAST-BOOST-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11e - breast-boost-e r", "11E - BREAST-BOOST-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11f - breast-boost-f r", "11F - BREAST-BOOST-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11g - breast-boost-g r", "11G - BREAST-BOOST-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11h - breast-boost-h r", "11H - BREAST-BOOST-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11i - breast-boost-i r", "11I - BREAST-BOOST-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11j - breast-boost-j r", "11J - BREAST-BOOST-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11k - breast-boost-k r", "11K - BREAST-BOOST-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11l - breast-boost-l r", "11L - BREAST-BOOST-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11m - breast-boost-m r", "11M - BREAST-BOOST-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11n - breast-boost-n r", "11N - BREAST-BOOST-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("11r - breast-boost-r r", "11R - BREAST-BOOST-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12 - multiple field r", "12 - MULTIPLE FIELD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12a - mult field-a r", "12A - MULT FIELD-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12b - mult field-b r", "12B - MULT FIELD-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12c - mult field-c r", "12C - MULT FIELD-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12d - mult field-d r", "12D - MULT FIELD-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12e - mult field-e r", "12E - MULT FIELD-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12f - mult field-f r", "12F - MULT FIELD-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12g - mult field-g r", "12G - MULT FIELD-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12h - mult field-h r", "12H - MULT FIELD-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12i - mult field-i r", "12I - MULT FIELD-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12j - mult field-j r", "12J - MULT FIELD-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12k - mult field-k r", "12K - MULT FIELD-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12l - mult field-l r", "12L - MULT FIELD-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12m - mult field-m r", "12M - MULT FIELD-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12n - mult field-n r", "12N - MULT FIELD-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("12r - mult field-r r", "12R - MULT FIELD-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13 - cranial irradia r", "13 - CRANIAL IRRADIA R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13a - cranial irr-a r", "13A - CRANIAL IRR-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13b - cranial irr-b r", "13B - CRANIAL IRR-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13c - cranial irr-c r", "13C - CRANIAL IRR-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13d - cranial irr-d r", "13D - CRANIAL IRR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13e - cranial irr-e r", "13E - CRANIAL IRR-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13f - cranial irr-f r", "13F - CRANIAL IRR-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13g - cranial irr-g r", "13G - CRANIAL IRR-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13h - cranial irr-h r", "13H - CRANIAL IRR-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13i - cranial irr-i r", "13I - CRANIAL IRR-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13j - cranial irr-j r", "13J - CRANIAL IRR-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13k - cranial irr-k r", "13K - CRANIAL IRR-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13l - cranial irr-l r", "13L - CRANIAL IRR-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13m - cranial irr-m r", "13M - CRANIAL IRR-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13n - cranial irr-n r", "13N - CRANIAL IRR-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("13r - cranial irr-r r", "13R - CRANIAL IRR-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14 - cerebrosp irrad r", "14 - CEREBROSP IRRAD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14a - cerebrosp irr-a r", "14A - CEREBROSP IRR-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14b - cerebrosp irr-b r", "14B - CEREBROSP IRR-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14c - cerebrosp irr-c r", "14C - CEREBROSP IRR-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14d - cerebrosp irr-d r", "14D - CEREBROSP IRR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14e - cerebrosp irr-e r", "14E - CEREBROSP IRR-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14f - cerebrosp irr-f r", "14F - CEREBROSP IRR-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14g - cerebrosp irr-g r", "14G - CEREBROSP IRR-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14h - cerebrosp irr-h r", "14H - CEREBROSP IRR-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14i - cerebrosp irr-i r", "14I - CEREBROSP IRR-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14j - cerebrosp irr-j r", "14J - CEREBROSP IRR-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14k - cerebrosp irr-k r", "14K - CEREBROSP IRR-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14l - cerebrosp irr-l r", "14L - CEREBROSP IRR-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14m - cerebrosp irr-m r", "14M - CEREBROSP IRR-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14n - cerebrosp irr-n r", "14N - CEREBROSP IRR-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("14r - cerebrosp irr-r r", "14R - CEREBROSP IRR-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15 - mantle-long r", "15 - MANTLE-LONG R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15a - mantle-long-a r", "15A - MANTLE-LONG-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15b - mantle-long-b r", "15B - MANTLE-LONG-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15c - mantle-long-c r", "15C - MANTLE-LONG-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15d - mantle-long-d r", "15D - MANTLE-LONG-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15e - mantle-long-e r", "15E - MANTLE-LONG-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15f - mantle-long-f r", "15F - MANTLE-LONG-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15g - mantle-long-g r", "15G - MANTLE-LONG-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15h - mantle-long-h r", "15H - MANTLE-LONG-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15i - mantle-long-i r", "15I - MANTLE-LONG-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15j - mantle-long-j r", "15J - MANTLE-LONG-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15k - mantle-long-k r", "15K - MANTLE-LONG-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15l - mantle-long-l r", "15L - MANTLE-LONG-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15m - mantle-long-m r", "15M - MANTLE-LONG-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15n - mantle-long-n r", "15N - MANTLE-LONG-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("15r - mantle-long-r r", "15R - MANTLE-LONG-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16 - mantle-short r", "16 - MANTLE-SHORT R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16a - mantle-short-a r", "16A - MANTLE-SHORT-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16b - mantle-short-b r", "16B - MANTLE-SHORT-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16c - mantle-short-c r", "16C - MANTLE-SHORT-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16d - mantle-short-d r", "16D - MANTLE-SHORT-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16e - mantle-short-e r", "16E - MANTLE-SHORT-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16f - mantle-short-f r", "16F - MANTLE-SHORT-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16g - mantle-short-g r", "16G - MANTLE-SHORT-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16h - mantle-short-h r", "16H - MANTLE-SHORT-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16i - mantle-short-i r", "16I - MANTLE-SHORT-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16j - mantle-short-j r", "16J - MANTLE-SHORT-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16k - mantle-short-k r", "16K - MANTLE-SHORT-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16l - mantle-short-l r", "16L - MANTLE-SHORT-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16m - mantle-short-m r", "16M - MANTLE-SHORT-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16n - mantle-short-n r", "16N - MANTLE-SHORT-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("16r - mantle-short-r r", "16R - MANTLE-SHORT-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17 - mantle-modified r", "17 - MANTLE-MODIFIED R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17a - mantle-modif-a r", "17A - MANTLE-MODIF-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17b - mantle-modif-b r", "17B - MANTLE-MODIF-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17c - mantle-modif-c r", "17C - MANTLE-MODIF-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17d - mantle-modif-d r", "17D - MANTLE-MODIF-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17e - mantle-modif-e r", "17E - MANTLE-MODIF-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17f - mantle-modif-f r", "17F - MANTLE-MODIF-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17g - mantle-modif-g r", "17G - MANTLE-MODIF-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17h - mantle-modif-h r", "17H - MANTLE-MODIF-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17i - mantle-modif-i r", "17I - MANTLE-MODIF-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17j - mantle-modif-j r", "17J - MANTLE-MODIF-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17k - mantle-modif-k r", "17K - MANTLE-MODIF-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17l - mantle-modif-l r", "17L - MANTLE-MODIF-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17m - mantle-modif-m r", "17M - MANTLE-MODIF-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17n - mantle-modif-n r", "17N - MANTLE-MODIF-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("17r - mantle-modif-r r", "17R - MANTLE-MODIF-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18 - abdominal irrad r", "18 - ABDOMINAL IRRAD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18a - abdominal irr-a r", "18A - ABDOMINAL IRR-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18b - abdominal irr-b r", "18B - ABDOMINAL IRR-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18c - abdominal irr-c r", "18C - ABDOMINAL IRR-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18d - abdominal irr-d r", "18D - ABDOMINAL IRR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18e - abdominal irr-e r", "18E - ABDOMINAL IRR-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18f - abdominal irr-f r", "18F - ABDOMINAL IRR-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18g - abdominal irr-g r", "18G - ABDOMINAL IRR-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18h - abdominal irr-h r", "18H - ABDOMINAL IRR-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18i - abdominal irr-i r", "18I - ABDOMINAL IRR-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18j - abdominal irr-j r", "18J - ABDOMINAL IRR-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18k - abdominal irr-k r", "18K - ABDOMINAL IRR-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18l - abdominal irr-l r", "18L - ABDOMINAL IRR-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18m - abdominal irr-m r", "18M - ABDOMINAL IRR-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18n - abdominal irr-n r", "18N - ABDOMINAL IRR-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("18r - abdominal irr-r r", "18R - ABDOMINAL IRR-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("19 - 2 fields ext r", "19 - 2 FIELDS EXT R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("19c - 2 fields ext-c r", "19C - 2 FIELDS EXT-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("19d - 2 fields ext-d r", "19D - 2 FIELDS EXT-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("19i - 2 fields ext-i r", "19I - 2 FIELDS EXT-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("19k - 2 fields ext-k r", "19K - 2 FIELDS EXT-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("19m - 2 fields ext-m r", "19M - 2 FIELDS EXT-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("19n - 2 fields ext-n r", "19N - 2 FIELDS EXT-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21 - rotation >=3arcs r", "21 - ROTATION >=3ARCS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21a - rotation-full-a r", "21A - ROTATION-FULL-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21b - rotation-full-b r", "21B - ROTATION-FULL-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21c - rotation-full-c r", "21C - ROTATION-FULL-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21d - rotation-full-d r", "21D - ROTATION-FULL-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21e - rotation-full-e r", "21E - ROTATION-FULL-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21f - rotation-full-f r", "21F - ROTATION-FULL-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21g - rotation-full-g r", "21G - ROTATION-FULL-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21h - rotation-full-h r", "21H - ROTATION-FULL-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21i - rotation-full-i r", "21I - ROTATION-FULL-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21j - rotation-full-j r", "21J - ROTATION-FULL-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21k - rotation-full-k r", "21K - ROTATION-FULL-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21l - rotation-full-l r", "21L - ROTATION-FULL-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21m - rotation-full-m r", "21M - ROTATION-FULL-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21n - rotation-full-n r", "21N - ROTATION-FULL-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21r - rotation-full-r r", "21R - ROTATION-FULL-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("21s - rotation-full-s r", "21S - ROTATION-FULL-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22 - rotat-sin arc r", "22 - ROTAT-SIN ARC R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22a - rot-sin arc-a r", "22A - ROT-SIN ARC-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22b - rot-sin arc-b r", "22B - ROT-SIN ARC-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22c - rot-sin arc-c r", "22C - ROT-SIN ARC-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22d - rot-sin arc-d r", "22D - ROT-SIN ARC-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22e - rot-sin arc-e r", "22E - ROT-SIN ARC-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22f - rot-sin arc-f r", "22F - ROT-SIN ARC-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22g - rot-sin arc-g r", "22G - ROT-SIN ARC-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22h - rot-sin arc-h r", "22H - ROT-SIN ARC-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22i - rot-sin arc-i r", "22I - ROT-SIN ARC-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22j - rot-sin arc-j r", "22J - ROT-SIN ARC-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22k - rot-sin arc-k r", "22K - ROT-SIN ARC-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22l - rot-sin arc-l r", "22L - ROT-SIN ARC-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22m - rot-sin arc-m r", "22M - ROT-SIN ARC-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22n - rot-sin arc-n r", "22N - ROT-SIN ARC-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("22r - rot-sin arc-r r", "22R - ROT-SIN ARC-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23 - rotat-doub arc r", "23 - ROTAT-DOUB ARC R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23a - rot-doub arc-a r", "23A - ROT-DOUB ARC-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23b - rot-doub arc-b r", "23B - ROT-DOUB ARC-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23c - rot-doub arc-c r", "23C - ROT-DOUB ARC-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23d - rot-doub arc-d r", "23D - ROT-DOUB ARC-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23e - rot-doub arc-e r", "23E - ROT-DOUB ARC-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23f - rot-doub arc-f r", "23F - ROT-DOUB ARC-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23g - rot-doub arc-g     g", "23G - ROT-DOUB ARC-G     G", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23h - rot-doub arc-h r", "23H - ROT-DOUB ARC-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23i - rot-doub arc-i r", "23I - ROT-DOUB ARC-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23j - rot-doub arc-j r", "23J - ROT-DOUB ARC-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23k - rot-doub arc-k r", "23K - ROT-DOUB ARC-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23l - rot-doub arc-l r", "23L - ROT-DOUB ARC-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23m - rot-doub arc-m r", "23M - ROT-DOUB ARC-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23n - rot-doub arc-n r", "23N - ROT-DOUB ARC-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("23r - rot-doub arc-r r", "23R - ROT-DOUB ARC-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24 - rotat-comp arc r", "24 - ROTAT-COMP ARC R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24a - rot-comp arc-a r", "24A - ROT-COMP ARC-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24b - rot-comp arc-b r", "24B - ROT-COMP ARC-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24c - rot-comp arc-c r", "24C - ROT-COMP ARC-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24d - rot-comp arc-d r", "24D - ROT-COMP ARC-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24e - rot-comp arc-e r", "24E - ROT-COMP ARC-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24f - rot-comp arc-f r", "24F - ROT-COMP ARC-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24g - rot-comp arc-g r", "24G - ROT-COMP ARC-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24h - rot-comp arc-h r", "24H - ROT-COMP ARC-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24i - rot-comp arc-i r", "24I - ROT-COMP ARC-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24j - rot-comp arc-j r", "24J - ROT-COMP ARC-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24k - rot-comp arc-k r", "24K - ROT-COMP ARC-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24l - rot-comp arc-l r", "24L - ROT-COMP ARC-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24m - rot-comp arc-m r", "24M - ROT-COMP ARC-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24n - rot-comp arc-n r", "24N - ROT-COMP ARC-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("24r - rot-comp arc-r r", "24R - ROT-COMP ARC-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("25 - intracavity b", "25 - INTRACAVITY  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("25o - intracavity-o b", "25O - INTRACAVITY-O  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("25p - intracavity-p b", "25P - INTRACAVITY-P  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("25q - intracavity-q b", "25Q - INTRACAVITY-Q  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("25r - intracavity-r b", "25R - Intracavity-R B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("25t - intracavity-t b", "25T - INTRACAVITY-T  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("25v - intracavity-v b", "25V - INTRACAVITY-V  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("25w - intracavity-w b", "25W - INTRACAVITY-W  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("25x - intracavity-x b", "25X - INTRACAVITY-X  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("25y - intracavity-y b", "25Y - INTRACAVITY-Y  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("25z - intracavity-z b", "25Z - INTRACAVITY-Z  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("26 - interstit-singl b", "26 - INTERSTIT-SINGL  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("27 - interstit-2 pl b", "27 - INTERSTIT-2 PL B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("28 - interstit-vol b", "28 - INTERSTIT-VOL  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("29 - surface applic b", "29 - SURFACE APPLIC B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31 - whole body surf r", "31 - WHOLE BODY SURF R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31a - whole bod sur-a r", "31A - WHOLE BOD SUR-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31b - whole bod sur-b r", "31B - WHOLE BOD SUR-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31c - whole bod sur-c r", "31C - WHOLE BOD SUR-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31d - whole bod sur-d r", "31D - WHOLE BOD SUR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31e - whole bod sur-e r", "31E - WHOLE BOD SUR-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31f - whole bod sur-f r", "31F - WHOLE BOD SUR-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31g - whole bod sur-g r", "31G - WHOLE BOD SUR-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31h - whole bod sur-h r", "31H - WHOLE BOD SUR-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31i - whole bod sur-i r", "31I - WHOLE BOD SUR-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31j - whole bod sur-j r", "31J - WHOLE BOD SUR-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31k - whole bod sur-k r", "31K - WHOLE BOD SUR-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31l - whole bod sur-l r", "31L - WHOLE BOD SUR-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31m - whole bod sur-m r", "31M - WHOLE BOD SUR-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31n - whole bod sur-n r", "31N - WHOLE BOD SUR-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31r - whole bod sur-r r", "31R - WHOLE BOD SUR-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("31s - whole bod sur-s r", "31S - WHOLE BOD SUR-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32 - whole body r", "32 - WHOLE BODY R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32a - whole body-a r", "32A - WHOLE BODY-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32b - whole body-b r", "32B - WHOLE BODY-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32c - whole body-c r", "32C - WHOLE BODY-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32d - whole body-d r", "32D - WHOLE BODY-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32e - whole body-e r", "32E - WHOLE BODY-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32f - whole body-f r", "32F - WHOLE BODY-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32g - whole body-g r", "32G - WHOLE BODY-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32h - whole body-h r", "32H - WHOLE BODY-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32i - whole body-i r", "32I - WHOLE BODY-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32j - whole body-j r", "32J - WHOLE BODY-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32k - whole body-k r", "32K - WHOLE BODY-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32l - whole body-l r", "32L - WHOLE BODY-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32m - whole body-m r", "32M - WHOLE BODY-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32n - whole body-n r", "32N - WHOLE BODY-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32r - whole body-r r", "32R - WHOLE BODY-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("32s - whole body-s r", "32S - WHOLE BODY-S R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("33 - unsealed isotope b", "33 - UNSEALED ISOTOPE B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34 - breast-nodal-2 r", "34 - BREAST-NODAL-2 R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34a - breast-nodal-2-a r", "34A - BREAST-NODAL-2-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34b - breast-nodal-2-b r", "34B - BREAST-NODAL-2-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34c - breast-nodal-2-c r", "34C - BREAST-NODAL-2-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34d - breast-nodal-2-d r", "34D - BREAST-NODAL-2-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34e - breast-nodal-2-e r", "34E - BREAST-NODAL-2-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34f - breast-nodal-2-f r", "34F - BREAST-NODAL-2-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34g - breast-nodal-2-g r", "34G - BREAST-NODAL-2-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34h - breast-nodal-2-h r", "34H - BREAST-NODAL-2-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34i - breast-nodal-2-i r", "34I - BREAST-NODAL-2-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34j - breast-nodal-2-j r", "34J - BREAST-NODAL-2-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34k - breast-nodal-2-k r", "34K - BREAST-NODAL-2-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34l - breast-nodal-2-l r", "34L - BREAST-NODAL-2-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34m - breast-nodal-2-m r", "34M - BREAST-NODAL-2-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34n - breast-nodal-2-n r", "34N - BREAST-NODAL-2-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34r - breast-nodal-2-r r", "34R - BREAST-NODAL-2-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("34u - breast-nodal-2-u r", "34U - BREAST-NODAL-2-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35 - breast-nodal-3 r", "35 - BREAST-NODAL-3 R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35a - breast-nodal-3-a r", "35A - BREAST-NODAL-3-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35b - breast-nodal-3-b r", "35B - BREAST-NODAL-3-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35c - breast-nodal-3-c r", "35C - BREAST-NODAL-3-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35d - breast-nodal-3-d r", "35D - BREAST-NODAL-3-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35e - breast-nodal-3-e r", "35E - BREAST-NODAL-3-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35f - breast-nodal-3-f r", "35F - BREAST-NODAL-3-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35g - breast-nodal-3-g r", "35G - BREAST-NODAL-3-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35h - breast-nodal-3-h r", "35H - BREAST-NODAL-3-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35i - breast-nodal-3-i r", "35I - BREAST-NODAL-3-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35j - breast-nodal-3-j r", "35J - BREAST-NODAL-3-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35k - breast-nodal-3-k r", "35K - BREAST-NODAL-3-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35l - breast-nodal-3-l r", "35L - BREAST-NODAL-3-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35m - breast-nodal-3-m r", "35M - BREAST-NODAL-3-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("35n - breast-nodal-3-n r", "35N - BREAST-NODAL-3-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36 - breast no-1 1/2 r", "36 - BREAST NO-1 1/2 R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36a - br-noda-1 1/2-a r", "36A - BR-NODA-1 1/2-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36b - br-noda-1 1/2-b r", "36B - BR-NODA-1 1/2-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36c - br-noda-1 1/2-c r", "36C - BR-NODA-1 1/2-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36d - br-noda-1 1/2-d r", "36D - BR-NODA-1 1/2-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36e - br-noda-1 1/2-e r", "36E - BR-NODA-1 1/2-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36f - br-noda-1 1/2-f r", "36F - BR-NODA-1 1/2-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36g - br-noda-1 1/2-g r", "36G - BR-NODA-1 1/2-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36h - br-noda-1 1/2-h r", "36H - BR-NODA-1 1/2-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36i - br-noda-1 1/2-i r", "36I - BR-NODA-1 1/2-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36j - br-noda-1 1/2-j r", "36J - BR-NODA-1 1/2-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36k - br-noda-1 1/2-k r", "36K - BR-NODA-1 1/2-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36l - br-noda-1 1/2-l r", "36L - BR-NODA-1 1/2-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36m - br-noda-1 1/2-m r", "36M - BR-NODA-1 1/2-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36n - br-noda-1 1/2-n r", "36N - BR-NODA-1 1/2-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("36r - br-noda-1 1/2-r r", "36R - BR-NODA-1 1/2-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37 - breast no-2 1/2 r", "37 - BREAST NO-2 1/2 R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37a - br-noda-2 1/2-a r", "37A - BR-NODA-2 1/2-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37b - br-noda-2 1/2-b r", "37B - BR-NODA-2 1/2-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37c - br-noda-2 1/2-c r", "37C - BR-NODA-2 1/2-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37d - br-noda-2 1/2-d r", "37D - BR-NODA-2 1/2-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37e - br-noda-2 1/2-e r", "37E - BR-NODA-2 1/2-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37f - br-noda-2 1/2-f r", "37F - BR-NODA-2 1/2-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37g - br-noda-2 1/2-g r", "37G - BR-NODA-2 1/2-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37h - br-noda-2 1/2-h r", "37H - BR-NODA-2 1/2-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37i - br-noda-2 1/2-i r", "37I - BR-NODA-2 1/2-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37j - br-noda-2 1/2-j r", "37J - BR-NODA-2 1/2-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37k - br-noda-2 1/2-k r", "37K - BR-NODA-2 1/2-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37l - br-noda-2 1/2-l r", "37L - BR-NODA-2 1/2-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37m - br-noda-2 1/2-m r", "37M - BR-NODA-2 1/2-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37n - br-noda-2 1/2-n r", "37N - BR-NODA-2 1/2-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("37r - br-noda-2 1/2-r r", "37R - BR-NODA-2 1/2-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("38 - br-nodal-1 r", "38 - BR-NODAL-1 R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("38a - br-nodal-1-a r", "38A - BR-NODAL-1-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("38b - br-nodal-1-b r", "38B - BR-NODAL-1-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("38d - br-nodal-1-d r", "38D - BR-NODAL-1-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("38e - br-nodal-1-e r", "38E - BR-NODAL-1-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("38f - br-nodal-1-f r", "38F - BR-NODAL-1-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("38h - br-nodal-1-h r", "38H - BR-NODAL-1-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("38j - br-nodal-1-j r", "38J - BR-NODAL-1-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("38k - br-nodal-1-k r", "38K - BR-NODAL-1-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("38m - br-nodal-1-m r", "38M - BR-NODAL-1-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39 - br-wide tang r", "39 - BR-WIDE TANG R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39a - br-wide tang-a r", "39A - BR-WIDE TANG-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39b - br-wide tang-b r", "39B - BR-WIDE TANG-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39c - br-wide tang-c r", "39C - BR-WIDE TANG-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39d - br-wide tang-d r", "39D - BR-WIDE TANG-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39e - br-wide tang-e r", "39E - BR-WIDE TANG-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39f - br-wide tang-f r", "39F - BR-WIDE TANG-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39g - br-wide tang-g r", "39G - BR-WIDE TANG-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39h - br-wide tang-h r", "39H - BR-WIDE TANG-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39i - br-wide tang-i r", "39I - BR-WIDE TANG-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39j - br-wide tang-j r", "39J - BR-WIDE TANG-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39k - br-wide tang-k r", "39K - BR-WIDE TANG-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39l - br-wide tang-l r", "39L - BR-WIDE TANG-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39m - br-wide tang-m r", "39M - BR-WIDE TANG-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39n - br-wide tang-n r", "39N - BR-WIDE TANG-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39r - br-wide tang-r r", "39R - BR-WIDE TANG-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("39u - br-wide tang-u r", "39U - BR-WIDE TANG-U R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40 - 6 fields r", "40 - 6 FIELDS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40a - 6 fields-a r", "40A - 6 FIELDS-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40b - 6 fields-b r", "40B - 6 FIELDS-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40c - 6 fields-c r", "40C - 6 FIELDS-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40d - 6 fields-d r", "40D - 6 FIELDS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40e - 6 fields-e r", "40E - 6 FIELDS-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40f - 6 fields-f r", "40F - 6 FIELDS-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40g - 6 fields-g r", "40G - 6 FIELDS-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40h - 6 fields-h r", "40H - 6 FIELDS-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40i - 6 fields-i r", "40I - 6 FIELDS-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40j - 6 fields-j r", "40J - 6 FIELDS-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40k - 6 fields-k r", "40K - 6 FIELDS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40l - 6 fields-l r", "40L - 6 FIELDS-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40m - 6 fields-m r", "40M - 6 FIELDS-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40n - 6 fields-n r", "40N - 6 FIELDS-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("40r - 6 fields-r r", "40R - 6 FIELDS-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("41 - br-nodal-1-scn r", "41 - BR-NODAL-1-SCN R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("41k - br-nodal-1-scn-k r", "41K - BR-NODAL-1-SCN-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("42 - br-nodal-1-axi r", "42 - BR-NODAL-1-AXI R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("42k - br-nodal-1-axi-k r", "42K - BR-NODAL-1-AXI-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("43 - br-nodal-1-imc r", "43 - BR-NODAL-1-IMC R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("43k - br-nodal-1-imc-k r", "43K - BR-NODAL-1-IMC-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("44 - br-nodal-2-scna r", "44 - BR-NODAL-2-SCNA R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("44k - br-nodal-2-scna-k r", "44K - BR-NODAL-2-SCNA-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("45 - br-nodal-2-scni r", "45 - BR-NODAL-2-SCNI R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("45k - br-nodal-2-scni-k r", "45K - BR-NODAL-2-SCNI-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("46 - br-nodal-2-aim r", "46 - BR-NODAL-2-AIM R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("46k - br-nodal-2-aim-k r", "46K - BR-NODAL-2-AIM-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("47 - br-nodal-3-asi r", "47 - BR-NODAL-3-ASI R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("47k - br-nodal-3-asi-k r", "47K - BR-NODAL-3-ASI-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50 - hockey stick r", "50 - HOCKEY STICK R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50a - hockey stick-a r", "50A - HOCKEY STICK-A R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50b - hockey stick-b r", "50B - HOCKEY STICK-B R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50c - hockey stick-c r", "50C - HOCKEY STICK-C R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50d - hockey stick-d r", "50D - HOCKEY STICK-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50e - hockey stick-e r", "50E - HOCKEY STICK-E R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50f - hockey stick-f r", "50F - HOCKEY STICK-F R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50g - hockey stick-g r", "50G - HOCKEY STICK-G R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50h - hockey stick-h r", "50H - HOCKEY STICK-H R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50i - hockey stick-i r", "50I - HOCKEY STICK-I R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50j - hockey stick-j r", "50J - HOCKEY STICK-J R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50k - hockey stick-k r", "50K - HOCKEY STICK-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50l - hockey stick-l r", "50L - HOCKEY STICK-L R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50m - hockey stick-m r", "50M - HOCKEY STICK-M R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50n - hockey stick-n r", "50N - HOCKEY STICK-N R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("50r - hockey stick-r r", "50R - HOCKEY STICK-R R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("51 - imrt-5 fields r", "51 - IMRT-5 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("51k - imrt-5 fields-k r", "51K - IMRT-5 Fields-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("52 - imrt-1 field r", "52 - IMRT-1 Field R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("52k - imrt-1 field-k r", "52K - IMRT-1 Field-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("53 - imrt-3 fields r", "53 - IMRT-3 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("53k - imrt-3 fields-k r", "53K - IMRT-3 Fields-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("54 - vmat, 1 arc r", "54 - VMAT, 1 ARC R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("54k - vmat 1 arc-k r", "54K - VMAT 1 ARC-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("55 - vmat, 2 arcs r", "55 - VMAT, 2 ARCS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("55k - vmat, 2 arcs-k r", "55K - VMAT, 2 ARCS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("56 - vmat, >=3 arcs r", "56 - VMAT, >=3 ARCS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("56k - vmat,>=3 arcs-k r", "56K - VMAT,>=3 ARCS-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("57 - vmat,arcs&fixed f. r", "57 - VMAT,Arcs&Fixed F. R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("57k - vmat,arcs&fixed f-k r", "57K - VMAT,Arcs&Fixed F-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("58 - vmat,arcs & imrt r", "58 - VMAT,Arcs & IMRT R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("58k - vmat,arcs & imrt-k r", "58K - VMAT,Arcs & IMRT-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("59 - unknown r", "59 - UNKNOWN R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("60d - stereotactic-1ar-d r", "60D - STEREOTACTIC-1AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("61d - stereotactic-2ar-d r", "61D - STEREOTACTIC-2AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("62d - stereotactic-3ar-d r", "62D - STEREOTACTIC-3AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("63d - stereotactic-4ar-d r", "63D - STEREOTACTIC-4AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("64d - stereotactic-5ar-d r", "64D - STEREOTACTIC-5AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("65d - stereotactic-6ar-d r", "65D - STEREOTACTIC-6AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("66d - stereotactic-7ar-d r", "66D - STEREOTACTIC-7AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("67d - stereotactic-8ar-d r", "67D - STEREOTACTIC-8AR-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("68d - srt>=9 arcs-d r", "68D - SRT>=9 ARCS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("70d - srt-1 beam-d r", "70D - SRT-1 BEAM-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("71d - srt-2 beams-d r", "71D - SRT-2 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("72d - srt-3 beams-d r", "72D - SRT-3 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("73d - srt-4 beams-d r", "73D - SRT-4 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("74d - srt-5 beams-d r", "74D - SRT-5 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("75d - srt-6 beams-d r", "75D - SRT-6 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("76d - srt-7 beams-d r", "76D - SRT-7 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("77d - srt-8 beams-d r", "77D - SRT-8 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("78d - srt-9 beams-d r", "78D - SRT-9 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("79d - srt-10 beams-d r", "79D - SRT-10 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("80d - srt>=11 beams-d r", "80D - SRT>=11 BEAMS-D R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("89d - srt-comp r", "89D - SRT-COMP R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("90 - imrt-6 fields r", "90 - IMRT-6 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("91 - imrt-7 fields r", "91 - IMRT-7 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("91k - imrt-7 fields-k r", "91K - IMRT-7 Fields-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("92 - imrt-8 fields r", "92 - IMRT-8 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("93 - imrt=9 fields r", "93 - IMRT=9 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("94 - imrt-10 fields r", "94 - IMRT-10 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("95 - imrt-11 fields r", "95 - IMRT-11 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("96 - imrt-12 fields r", "96 - IMRT-12 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("97 - imrt>=13 fields r", "97 - IMRT>=13 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("98 - imrt-2 fields r", "98 - IMRT-2 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("98k - imrt-2 fields-k r", "98K - IMRT-2 Fields-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("99 - imrt-4 fields r", "99 - IMRT-4 Fields R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("99k - imrt-4 fields-k r", "99K - IMRT-4 Fields-K R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("a - wedges r", "A - WEDGES R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("b - bolus r", "B - BOLUS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("c - compensator r", "C - COMPENSATOR R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("d - shielding r", "D - SHIELDING R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("e - superflab r", "E - SUPERFLAB R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("f - wedges + shielding r", "F - WEDGES + SHIELDING R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("g - wedges+compensatr r", "G - WEDGES+COMPENSATR R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("h - wedges+superflab r", "H - WEDGES+SUPERFLAB R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("i - wedge+compstr+shld r", "I - WEDGE+COMPSTR+SHLD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("j - wedges+bolus+shld r", "J - WEDGES+BOLUS+SHLD R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("k - boost r", "K - BOOST R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("l - bolus + wedge r", "L - BOLUS + WEDGE R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("m - bolus + shielding r", "M - BOLUS + SHIELDING R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("n - shieldng+compenstr r", "N - SHIELDNG+COMPENSTR R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("o - insert-lsource b", "O - INSERT-LSOURCE B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("p - insertion-2ch b", "P - INSERTION-2CH  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("q - insert-ute+2ov b", "Q - INSERT-UTE+2OV B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("r - shieldng&superflab r", "R - SHIELDNG&SUPERFLAB R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("s - split pelvis r", "S - SPLIT PELVIS R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("t - insert-ute+1ov b", "T - INSERT-UTE+1OV B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("u - wedge+shld+superf r", "U - WEDGE+SHLD+SUPERF R", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("v - insert-1 ovoid b", "V - INSERT-1 OVOID B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("w - intraluminal b", "W - INTRALUMINAL B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("x - insert-2 ovoids b", "X - INSERT-2 OVOIDS  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("y - insert-obturator b", "Y - INSERT-OBTURATOR B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),	
("z - insert-cylinder b", "Z - INSERT-CYLINDER  B", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

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
("r = radical", "R = Radical", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("p = palliative", "P = Palliative", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("a = adjuvant (1984 - 2014)", "A = Adjuvant (1984 - 2014)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("u = unknown", "U = Unknown", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("o = other (1984 - 06/1995)", "O = Other (1984 - 06/1995)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

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
("i = initial", "I = Initial", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("u = subsequent", "U = Subsequent", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

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
("t = td (tumour dose)", "T = TD (tumour dose)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id),
("s = sd (skin/surface dose)", "S = SD (skin/surface dose)", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_treat_region', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_treat_region') , '0', '', '', 'bc_nbi_help_rt_treat_region', 'region', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_technique', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_technique') , '0', '', '', 'bc_nbi_help_rt_technique', 'technique', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_technique_desc', 'input',  NULL , '0', '', '', 'bc_nbi_help_rt_technique_desc', '', 'description'), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_treat_intent', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_treat_intent') , '0', '', '', 'bc_nbi_help_rt_treat_intent', 'intent', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_treat_plan', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_treat_plan') , '0', '', '', 'bc_nbi_help_rt_treat_plan', 'plan', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_dose_cgy', 'integer_positive',  NULL , '0', 'size=4', '', 'bc_nbi_help_rt_dose_cgy', 'dose (cgy)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_dose_xd', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_dose_xd') , '0', '', '', 'bc_nbi_help_rt_dose_xd', 'dose (xd)', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_fractions', 'integer_positive',  NULL , '0', 'size=4', '', 'bc_nbi_help_rt_fractions', 'fractions', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'bc_nbi_txd_radiations', 'rt_course', 'integer_positive',  NULL , '0', 'size=4', '', 'bc_nbi_help_rt_course', 'course', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations' AND `field`='rt_treat_region' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_treat_region')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_help_rt_treat_region' AND `language_label`='region' AND `language_tag`=''), '3', '31', 'details', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='bc_nbi_txd_radiations'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='bc_nbi_txd_radiations' AND `field`='rt_technique' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='bc_nbi_rt_technique')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='bc_nbi_help_rt_technique' AND `language_label`='technique' AND `language_tag`=''), '3', '32', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
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
("0 = no initial breast surg", "0 = no initial breast surg"),
("1 = initial bcs", "1 = initial bcs"),
("2 = initial complete mastect", "2 = initial complete mastect");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_finsurg"), (SELECT id FROM structure_permissible_values WHERE value="0 = no initial breast surg" AND language_alias="0 = no initial breast surg"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_finsurg"), (SELECT id FROM structure_permissible_values WHERE value="1 = initial bcs" AND language_alias="1 = initial bcs"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_finsurg"), (SELECT id FROM structure_permissible_values WHERE value="2 = initial complete mastect" AND language_alias="2 = initial complete mastect"), "1", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("bc_nbi_surg_init_alnd", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("0 = no alnd performed", "0 = no alnd performed"),
("1 = alnd performed", "1 = alnd performed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_alnd"), (SELECT id FROM structure_permissible_values WHERE value="0 = no alnd performed" AND language_alias="0 = no alnd performed"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_alnd"), (SELECT id FROM structure_permissible_values WHERE value="1 = alnd performed" AND language_alias="1 = alnd performed"), "1", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("bc_nbi_surg_init_nodal_proc", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("0 = no nodal procedure performed", "0 = no nodal procedure performed"),
("1 = nodal procedure performed", "1 = nodal procedure performed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_nodal_proc"), (SELECT id FROM structure_permissible_values WHERE value="0 = no nodal procedure performed" AND language_alias="0 = no nodal procedure performed"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_nodal_proc"), (SELECT id FROM structure_permissible_values WHERE value="1 = nodal procedure performed" AND language_alias="1 = nodal procedure performed"), "1", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("bc_nbi_surg_init_partial_mastec", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("0 = no partial mastectomy", "0 = no partial mastectomy"),
("1 = partial mastec performed", "1 = partial mastec performed");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_partial_mastec"), (SELECT id FROM structure_permissible_values WHERE value="0 = no partial mastectomy" AND language_alias="0 = no partial mastectomy"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_partial_mastec"), (SELECT id FROM structure_permissible_values WHERE value="1 = partial mastec performed" AND language_alias="1 = partial mastec performed"), "1", "1");
INSERT INTO structure_value_domains (domain_name, override, category, source) 
VALUES 
("bc_nbi_surg_init_compl_mastec", "open", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) 
VALUES
("0 = no total/ mastec", "0 = no total/ mastec"),
("1 = total/complete mastec", "1 = total/complete mastec");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_compl_mastec"), (SELECT id FROM structure_permissible_values WHERE value="0 = no total/ mastec" AND language_alias="0 = no total/ mastec"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="bc_nbi_surg_init_compl_mastec"), (SELECT id FROM structure_permissible_values WHERE value="1 = total/complete mastec" AND language_alias="1 = total/complete mastec"), "1", "1");
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
("0 = no initial breast surg", "0 = No initial breast surg", ''),
("1 = initial bcs", "1 = Initial BCS", ''),
("2 = initial complete mastect", "2 = Initial complete mastect", ''),
("0 = no alnd performed", "0 = No ALND performed", ''),
("1 = alnd performed", "1 = ALND performed", ''),
("0 = no nodal procedure performed", "0 = No nodal procedure performed", ''),
("1 = nodal procedure performed", "1 = Nodal procedure performed", ''),
("0 = no partial mastectomy", "0 = No partial mastectomy", ''),
("1 = partial mastec performed", "1 = Partial mastec performed", ''),
("0 = no total/ mastec", "0 = No total/ mastec", ''),
("1 = total/complete mastec", "1 = Total/complete mastec", '');









































Concerning "Clinical Annotation" part: can we add here some of the entries from the Main data dictionary?
1) Referred Case
2) NHA  case
3) Diagnosis date
4) Admission date
5) Status at referral
6) Cancer site (i.e. primary location of malignant tumor in the body)
7) Province of Residence.







-- Users & Groups
-- ...................................................................................................................................


SELECT 'Activate Reproductive History' AS TODO
UNION ALL
SELECT 'Activate Contact' AS TODO
UNION ALL
SELECT 'Activate Consent' AS TODO
UNION ALL
SELECT 'Activate TreatmentExtendMasters' AS TODO;





Add province of residence
 
 
 
UPDATE versions SET branch_build_number = '7112' WHERE version_number = '2.7.0';