-- -----------------------------------------------------------------------------------------------------------------------------------
-- Version
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET branch_build_number = '7339' WHERE version_number = '2.7.1';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Anonymize local database fields 
-- -----------------------------------------------------------------------------------------------------------------------------------

-- study_summaries
-- ---------------

--  ALTER TABLE `study_summaries`
--  CHANGE COLUMN `procure_site_ethics_committee_convenience_chum` `procure_site_ethics_committee_convenience_ps1` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_site_ethics_committee_convenience_chus` `procure_site_ethics_committee_convenience_ps4` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_site_ethics_committee_convenience_chuq` `procure_site_ethics_committee_convenience_ps2` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_site_ethics_committee_convenience_cusm` `procure_site_ethics_committee_convenience_ps3` char(1) DEFAULT '';
UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps1' WHERE field = 'procure_site_ethics_committee_convenience_chum';
UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps4' WHERE field = 'procure_site_ethics_committee_convenience_chus';
UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps2' WHERE field = 'procure_site_ethics_committee_convenience_chuq';
UPDATE structure_fields SET field = 'procure_site_ethics_committee_convenience_ps3' WHERE field = 'procure_site_ethics_committee_convenience_cusm';
UPDATE structure_fields SET language_label = '' WHERE field = '';
UPDATE structure_fields SET language_label = 'committee_convenience_ps1' WHERE field = 'procure_site_ethics_committee_convenience_ps1';
UPDATE structure_fields SET language_label = 'committee_convenience_ps4' WHERE field = 'procure_site_ethics_committee_convenience_ps4';
UPDATE structure_fields SET language_label = 'committee_convenience_ps2' WHERE field = 'procure_site_ethics_committee_convenience_ps2';
UPDATE structure_fields SET language_label = 'committee_convenience_ps3' WHERE field = 'procure_site_ethics_committee_convenience_ps3';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('committee_convenience_ps1', 'CHUM', 'CHUM'),
('committee_convenience_ps2', 'CHUQ', 'CHUQ'),
('committee_convenience_ps3', 'CUSM', 'MUHC'),
('committee_convenience_ps4', 'CHUS', 'CHUS');

-- procure_cd_sigantures & consent_controls
-- ----------------------------------------
-- Uncomment line that could not be applied on local installation

-- Linked to PS1 fields

UPDATE consent_controls SET detail_form_alias = REPLACE(detail_form_alias, 'qc_nd_cd_data', 'ps1_cd_data') WHERE detail_form_alias LIKE '%qc_nd_cd_data%';
UPDATE structures SET alias = 'ps1_cd_data' WHERE  alias = 'qc_nd_cd_data';
UPDATE structure_value_domains SET domain_name = 'ps1_stop_followup' WHERE domain_name = 'qc_nd_stop_followup';

-- ALTER TABLE procure_cd_sigantures
--  CHANGE COLUMN `qc_nd_biological_material_use` `ps1_biological_material_use` varchar(50) DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_use_of_urine` `ps1_use_of_urine` varchar(50) DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_use_of_blood` `ps1_use_of_blood` varchar(50) DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_research_other_disease` `ps1_research_other_disease` varchar(50) DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_urine_blood_use_for_followup` `ps1_urine_blood_use_for_followup` varchar(10) DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_stop_followup` `ps1_stop_followup` varchar(10) DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_stop_followup_date` `ps1_stop_followup_date` date DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_allow_questionnaire` `ps1_allow_questionnaire` varchar(10) DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_stop_questionnaire` `ps1_stop_questionnaire` varchar(10) DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_stop_questionnaire_date` `ps1_stop_questionnaire_date` date DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_contact_for_additional_data` `ps1_contact_for_additional_data` varchar(10) DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_inform_significant_discovery` `ps1_inform_significant_discovery` varchar(50) DEFAULT NULL,
--  CHANGE COLUMN `qc_nd_inform_discovery_on_other_disease` `ps1_inform_discovery_on_other_disease` varchar(10) DEFAULT NULL;
-- ALTER TABLE procure_cd_sigantures
--    ADD COLUMN `ps1_biological_material_use` varchar(50) DEFAULT NULL,
--    ADD COLUMN `ps1_use_of_urine` varchar(50) DEFAULT NULL,
--    ADD COLUMN `ps1_use_of_blood` varchar(50) DEFAULT NULL,
--    ADD COLUMN `ps1_research_other_disease` varchar(50) DEFAULT NULL,
--    ADD COLUMN `ps1_urine_blood_use_for_followup` varchar(10) DEFAULT NULL,
--    ADD COLUMN `ps1_stop_followup` varchar(10) DEFAULT NULL,
--    ADD COLUMN `ps1_stop_followup_date` date DEFAULT NULL,
--    ADD COLUMN `ps1_allow_questionnaire` varchar(10) DEFAULT NULL,
--    ADD COLUMN `ps1_stop_questionnaire` varchar(10) DEFAULT NULL,
--    ADD COLUMN `ps1_stop_questionnaire_date` date DEFAULT NULL,
--    ADD COLUMN `ps1_contact_for_additional_data` varchar(10) DEFAULT NULL,
--    ADD COLUMN `ps1_inform_significant_discovery` varchar(50) DEFAULT NULL,
--    ADD COLUMN `ps1_inform_discovery_on_other_disease` varchar(10) DEFAULT NULL; 
UPDATE structure_fields SET field = 'ps1_biological_material_use' WHERE field = 'qc_nd_biological_material_use';
UPDATE structure_fields SET field = 'ps1_use_of_urine' WHERE field = 'qc_nd_use_of_urine';
UPDATE structure_fields SET field = 'ps1_use_of_blood' WHERE field = 'qc_nd_use_of_blood';
UPDATE structure_fields SET field = 'ps1_research_other_disease' WHERE field = 'qc_nd_research_other_disease';
UPDATE structure_fields SET field = 'ps1_urine_blood_use_for_followup' WHERE field = 'qc_nd_urine_blood_use_for_followup';
UPDATE structure_fields SET field = 'ps1_stop_followup' WHERE field = 'qc_nd_stop_followup';
UPDATE structure_fields SET field = 'ps1_stop_followup_date' WHERE field = 'qc_nd_stop_followup_date';
UPDATE structure_fields SET field = 'ps1_allow_questionnaire' WHERE field = 'qc_nd_allow_questionnaire';
UPDATE structure_fields SET field = 'ps1_stop_questionnaire' WHERE field = 'qc_nd_stop_questionnaire';
UPDATE structure_fields SET field = 'ps1_stop_questionnaire_date' WHERE field = 'qc_nd_stop_questionnaire_date';
UPDATE structure_fields SET field = 'ps1_contact_for_additional_data' WHERE field = 'qc_nd_contact_for_additional_data';
UPDATE structure_fields SET field = 'ps1_inform_significant_discovery' WHERE field = 'qc_nd_inform_significant_discovery';
UPDATE structure_fields SET field = 'ps1_inform_discovery_on_other_disease' WHERE field = 'qc_nd_inform_discovery_on_other_disease';

-- Linked to PS2 fields

-- ALTER TABLE procure_cd_sigantures
--  CHANGE COLUMN `procure_chuq_tissue` `ps2_tissue` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chuq_blood` `ps2_blood` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chuq_urine` `ps2_urine` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chuq_followup` `ps2_followup` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chuq_questionnaire` `ps2_questionnaire` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chuq_contact_for_additional_data` `ps2_contact_for_additional_data` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chuq_inform_significant_discovery` `ps2_inform_significant_discovery` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chuq_contact_in_case_of_death` `ps2_contact_in_case_of_death` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chuq_witness` `ps2_witness` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chuq_complete` `ps2_complete` char(1) DEFAULT '';    
-- ALTER TABLE procure_cd_sigantures
--    ADD COLUMN `ps2_tissue` char(1) DEFAULT '',
--    ADD COLUMN `ps2_blood` char(1) DEFAULT '',
--    ADD COLUMN `ps2_urine` char(1) DEFAULT '',
--    ADD COLUMN `ps2_followup` char(1) DEFAULT '',
--    ADD COLUMN `ps2_questionnaire` char(1) DEFAULT '',
--    ADD COLUMN `ps2_contact_for_additional_data` char(1) DEFAULT '',
--    ADD COLUMN `ps2_inform_significant_discovery` char(1) DEFAULT '',
--    ADD COLUMN `ps2_contact_in_case_of_death` char(1) DEFAULT '',
--    ADD COLUMN `ps2_witness` char(1) DEFAULT '',
--    ADD COLUMN `ps2_complete` char(1) DEFAULT '';   
UPDATE structure_fields SET field = 'ps2_tissue' WHERE field = 'procure_chuq_tissue';
UPDATE structure_fields SET field = 'ps2_blood' WHERE field = 'procure_chuq_blood';
UPDATE structure_fields SET field = 'ps2_urine' WHERE field = 'procure_chuq_urine';
UPDATE structure_fields SET field = 'ps2_followup' WHERE field = 'procure_chuq_followup';
UPDATE structure_fields SET field = 'ps2_questionnaire' WHERE field = 'procure_chuq_questionnaire';
UPDATE structure_fields SET field = 'ps2_contact_for_additional_data' WHERE field = 'procure_chuq_contact_for_additional_data';
UPDATE structure_fields SET field = 'ps2_inform_significant_discovery' WHERE field = 'procure_chuq_inform_significant_discovery';
UPDATE structure_fields SET field = 'ps2_contact_in_case_of_death' WHERE field = 'procure_chuq_contact_in_case_of_death';
UPDATE structure_fields SET field = 'ps2_witness' WHERE field = 'procure_chuq_witness';
UPDATE structure_fields SET field = 'ps2_complete' WHERE field = 'procure_chuq_complete';
  
-- Linked to PS4 fields

-- ALTER TABLE procure_cd_sigantures
--  CHANGE COLUMN `procure_chus_contact_for_more_info` `ps4_contact_for_more_info` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chus_contact_if_scientific_discovery` `ps4_contact_if_scientific_discovery` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chus_study_on_other_diseases` `ps4_study_on_other_diseases` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chus_contact_if_discovery_on_other_diseases` `ps4_contact_if_discovery_on_other_diseases` char(1) DEFAULT '',
--  CHANGE COLUMN `procure_chus_other_contacts_in_case_of_death` `ps4_other_contacts_in_case_of_death` char(1) DEFAULT '';
-- ALTER TABLE procure_cd_sigantures
--    ADD COLUMN `ps4_contact_for_more_info` char(1) DEFAULT '',
--    ADD COLUMN `ps4_contact_if_scientific_discovery` char(1) DEFAULT '',
--    ADD COLUMN `ps4_study_on_other_diseases` char(1) DEFAULT '',
--    ADD COLUMN `ps4_contact_if_discovery_on_other_diseases` char(1) DEFAULT '',
--    ADD COLUMN `ps4_other_contacts_in_case_of_death` char(1) DEFAULT '';
UPDATE structure_fields SET field = 'ps4_contact_for_more_info' WHERE field = 'procure_chus_contact_for_more_info';
UPDATE structure_fields SET field = 'ps4_contact_if_scientific_discovery' WHERE field = 'procure_chus_contact_if_scientific_discovery';
UPDATE structure_fields SET field = 'ps4_study_on_other_diseases' WHERE field = 'procure_chus_study_on_other_diseases';
UPDATE structure_fields SET field = 'ps4_contact_if_discovery_on_other_diseases' WHERE field = 'procure_chus_contact_if_discovery_on_other_diseases';
UPDATE structure_fields SET field = 'ps4_other_contacts_in_case_of_death' WHERE field = 'procure_chus_other_contacts_in_case_of_death';

UPDATE versions SET branch_build_number = '7347' WHERE version_number = '2.7.1';







  
  
  
  
  


