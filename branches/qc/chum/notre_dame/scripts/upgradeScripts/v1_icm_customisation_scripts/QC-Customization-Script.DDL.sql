-- ------------------------------------------------------------------------------------------------
--
-- VERSION: BEFORE PROD
--
-- ------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- clinical annotation 
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `participants`
-- ---------------------------------------------------------------------

ALTER TABLE `participants` 
ADD `last_visit_date` DATE NULL AFTER `tb_number` ,
ADD `approximative_last_visit_date` VARCHAR( 5 ) NULL AFTER `last_visit_date` ,
ADD `sardo_participant_id` VARCHAR( 20 ) NULL AFTER `approximative_last_visit_date` ,
ADD `sardo_numero_dossier` VARCHAR( 20 ) AFTER `sardo_participant_id` ,
ADD `last_sardo_import_date` DATE NULL AFTER `sardo_numero_dossier` ,
ADD `approximative_date_of_birth` VARCHAR( 5 ) NULL AFTER `date_of_birth` ,
ADD `approximative_date_of_death` VARCHAR( 5 ) NULL AFTER `date_of_death` ;

ALTER TABLE `participants` 
CHANGE `first_name` `first_name` VARCHAR( 20 ) NOT NULL default '',
CHANGE `last_name` `last_name` VARCHAR( 20 ) NOT NULL default '',
CHANGE `tb_number` `tb_number` VARCHAR( 50 ) NOT NULL default '';

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `consents`
-- ---------------------------------------------------------------------
 
ALTER TABLE `consents` 
ADD `consent_type` VARCHAR( 20 ) NULL AFTER `form_version`,
ADD `consent_language` VARCHAR( 10 ) NULL AFTER `consent_type`,
ADD `consent_version_date` VARCHAR( 10 ) AFTER `consent_type`,
ADD `urine_blood_use_for_followup` VARCHAR( 10 ) NULL AFTER `use_of_urine`,
ADD `stop_followup` VARCHAR( 10 ) NULL AFTER `urine_blood_use_for_followup`,
ADD `stop_followup_date` DATE NULL AFTER `stop_followup`,
ADD `contact_for_additional_data` VARCHAR( 10 ) NULL AFTER `stop_followup_date`,
ADD `allow_questionnaire` VARCHAR( 10 ) NULL AFTER `contact_for_additional_data`,
ADD `stop_questionnaire` VARCHAR( 10 ) AFTER `allow_questionnaire`,
ADD `stop_questionnaire_date` DATE NULL AFTER `stop_questionnaire`,
ADD `inform_discovery_on_other_disease` VARCHAR( 10 ) NULL AFTER `research_other_disease`;

ALTER TABLE `consents` 
CHANGE `consent_type` `consent_type` VARCHAR( 20 ) NOT NULL default '',
CHANGE `consent_status` `consent_status` VARCHAR( 50 ) NOT NULL default '';

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `family_histories`
-- ---------------------------------------------------------------------

ALTER TABLE `family_histories`
ADD `sardo_diagnosis_id` VARCHAR( 20 ) NULL AFTER `age_at_dx_status` ,
ADD `last_sardo_import_date` DATE NULL AFTER `sardo_diagnosis_id` ,
ADD `approximative_dx_date` VARCHAR( 5 ) NULL AFTER `dx_date` ;

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `participant_messages`
-- ---------------------------------------------------------------------

ALTER TABLE `participant_messages`
ADD `sardo_note_id` VARCHAR( 20 ) NULL AFTER `participant_id` ,
ADD `last_sardo_import_date` DATE NULL AFTER `sardo_note_id` ;

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `reproductive_histories`
-- ---------------------------------------------------------------------

ALTER TABLE `reproductive_histories`
ADD `aborta` INT( 11 ) NULL AFTER `gravida` ;

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `diagnoses`
-- ---------------------------------------------------------------------

ALTER TABLE `diagnoses`
ADD `icd_o_grade` VARCHAR( 10 ) NULL AFTER `morphology` ,
ADD `grade` VARCHAR( 10 ) NULL AFTER `icd_o_grade` ,
ADD `stade_figo` VARCHAR( 100 ) NULL AFTER `grade` ,
ADD `sequence_nbr` VARCHAR( 10 ) NULL AFTER `stade_figo` ,
ADD `sardo_diagnosis_id` VARCHAR( 20 ) NULL AFTER `path_stage_grouping` ,
ADD `last_sardo_import_date` DATE NULL AFTER `sardo_diagnosis_id` ,
ADD `approximative_dx_date` VARCHAR( 5 ) NULL AFTER `dx_date` ,
ADD `survival` INT( 5 ) NULL AFTER `path_stage_grouping` ,
ADD `survival_unit` VARCHAR( 5 ) NULL AFTER `survival` ,
ADD `is_cause_of_death` VARCHAR( 5 ) NULL AFTER `survival_unit` ;

ALTER TABLE `diagnoses` 
CHANGE `dx_number` `dx_number` VARCHAR( 50 ) NOT NULL default '',
CHANGE `case_number` `case_number` INT( 11 ) NOT NULL default '0'; 

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `participant_contacts`
-- ---------------------------------------------------------------------

ALTER TABLE `participant_contacts`
ADD `type_precision` VARCHAR( 60 ) NULL AFTER `contact_type` ,
ADD `street_nbr` VARCHAR( 10 ) NULL AFTER `memo` ;

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `misc_identifiers`
-- ---------------------------------------------------------------------

ALTER TABLE `misc_identifiers` 
CHANGE `name` `name` VARCHAR( 50 ) NOT NULL default '0'; 

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `part_bank_nbr_counters`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `part_bank_nbr_counters`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `part_bank_nbr_counters` (
  `id` int(11) NOT NULL auto_increment,
  `bank_ident_title` varchar(50) default NULL,
  `last_nbr` varchar(30) default NULL,
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ; 

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `tx_masters`
-- ---------------------------------------------------------------------

ALTER TABLE `tx_masters`
ADD `result` VARCHAR( 20 ) NULL AFTER `summary` ,
ADD `therapeutic_goal` VARCHAR( 200 ) NULL AFTER `result` ,
ADD `sardo_treatment_id` VARCHAR( 20 ) NULL AFTER `therapeutic_goal` ,
ADD `last_sardo_import_date` DATE NULL AFTER `sardo_treatment_id`, 
ADD `approximative_tx_date` VARCHAR( 5 ) NULL AFTER `finish_date` ;

ALTER TABLE `tx_masters` 
CHANGE `group` `group` VARCHAR( 50 ) NOT NULL default '',
CHANGE `disease_site` `disease_site` VARCHAR( 50 ) NOT NULL default ''; 

-- ---------------------------------------------------------------------
-- DROP TABLE:
--    - `Treatment...`
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `txd_brachytherapies`;
DROP TABLE IF EXISTS `txd_combos`;
DROP TABLE IF EXISTS `txe_brachytherapies`;
DROP TABLE IF EXISTS `txe_radiations`;
DROP TABLE IF EXISTS `txe_surgeries`;

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `txd_radiations`
-- ---------------------------------------------------------------------

ALTER TABLE `txd_radiations`
ADD `radiation_type` VARCHAR( 100 ) NULL AFTER `id` ;

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `txd_surgeries`
-- ---------------------------------------------------------------------

ALTER TABLE `txd_surgeries`
ADD `surgery_type` VARCHAR( 100 ) NULL AFTER `id` ,
ADD `ed_lab_path_report_id` int(11) default NULL AFTER `surgery_type` ;

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `txd_drugs`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `txd_drugs`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `txd_drugs` (
  `id` int(11) NOT NULL auto_increment,
  `tx_master_id` int(11) NOT NULL default '0',
  `drug_id` int(11) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) collate utf8_bin NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) collate utf8_bin NOT NULL default '',
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `txd_drugs` ADD INDEX ( `tx_master_id` );

ALTER TABLE `txd_drugs`
ADD FOREIGN KEY (tx_master_id)
REFERENCES tx_masters (id);

ALTER TABLE `txd_drugs` ADD INDEX ( `drug_id` );

ALTER TABLE `txd_drugs`
ADD FOREIGN KEY (drug_id)
REFERENCES drugs (id);

-- ---------------------------------------------------------------------
-- ALTER TABLE:
--    - `event_masters`
-- ---------------------------------------------------------------------

ALTER TABLE `event_masters`
ADD `sardo_record_id` VARCHAR( 20 ) NULL AFTER `reference_number` ,
ADD `sardo_record_source` VARCHAR( 20 ) NULL AFTER `sardo_record_id` ,
ADD `last_sardo_import_date` DATE NULL AFTER `sardo_record_source` , 
ADD `approximative_event_date` VARCHAR( 5 ) NULL AFTER `event_date` ,
ADD `result` VARCHAR( 20 ) NULL AFTER `approximative_event_date` ,
ADD `therapeutic_goal` VARCHAR( 200 ) NULL AFTER `result` ;

-- ---------------------------------------------------------------------
-- DROP TABLE:
--    - `Event...`
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `ed_allsolid_lab_pathology`;
DROP TABLE IF EXISTS `ed_all_adverse_events_adverse_event`;
DROP TABLE IF EXISTS `ed_all_clinical_followup`;
DROP TABLE IF EXISTS `ed_all_clinical_presentation`;
DROP TABLE IF EXISTS `ed_all_lifestyle_base`;
DROP TABLE IF EXISTS `ed_all_protocol_followup`;
DROP TABLE IF EXISTS `ed_all_study_research`;
DROP TABLE IF EXISTS `ed_breast_clinical_presentation`;
DROP TABLE IF EXISTS `ed_breast_screening_mammogram`;
DROP TABLE IF EXISTS `ed_breast_lab_pathology`;
DROP TABLE IF EXISTS `ed_biopsy_report`;
DROP TABLE IF EXISTS `ed_cytology_report`; 
DROP TABLE IF EXISTS `ed_surgery_report`; 

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `ed_lab_path_report`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `ed_lab_path_report`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `ed_lab_path_report` (
  `id` int(11) NOT NULL auto_increment, 
  `path_report_code` varchar(40) NOT NULL default '',
  `conclusion` varchar(20) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `ed_lab_path_report` ADD INDEX ( `event_master_id` );

ALTER TABLE `ed_lab_path_report`
ADD FOREIGN KEY (event_master_id)
REFERENCES event_masters (id);

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `ed_lab_revision_report`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `ed_lab_revision_report`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `ed_lab_revision_report` (
  `id` int(11) NOT NULL auto_increment,
  `path_report_code` varchar(40) NOT NULL default '',
  `revision_type` varchar(100) default NULL,
  `conclusion` varchar(20) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `ed_lab_revision_report` ADD INDEX ( `event_master_id` );

ALTER TABLE `ed_lab_revision_report`
ADD FOREIGN KEY (event_master_id)
REFERENCES event_masters (id);

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `ed_lab_blood_report`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `ed_lab_blood_report`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `ed_lab_blood_report` (
  `id` int(11) NOT NULL auto_increment,
  `path_report_code` varchar(40) NOT NULL default '',
  `aps` decimal(10,5) default NULL,
  `aps_sardo_record_id` VARCHAR( 20 ) default NULL,
  `aps_pre_op` decimal(10,5) default NULL,       
  `aps_pre_op_sardo_record_id` VARCHAR( 20 ) default NULL,
  `ca_125` decimal(10,5) default NULL,
  `ca125_sardo_record_id` VARCHAR( 20 ) default NULL,
  `red_blood_cells` decimal(10,5) default NULL,
  `rbc_sardo_record_id` VARCHAR( 20 ) default NULL,
  `hemoglobin` decimal(10,5) default NULL,
  `hmg_sardo_record_id` VARCHAR( 20 ) default NULL,
  `hematocrit` decimal(10,5) default NULL,
  `hmt_sardo_record_id` VARCHAR( 20 ) default NULL,
  `mean_corpusc_volume` decimal(10,5) default NULL,
  `mcv_sardo_record_id` VARCHAR( 20 ) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `ed_lab_blood_report` ADD INDEX ( `event_master_id` );

ALTER TABLE `ed_lab_blood_report`
ADD FOREIGN KEY (event_master_id)
REFERENCES event_masters (id);

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `ed_biopsy_clin_event`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `ed_biopsy_clin_event`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `ed_biopsy_clin_event` (
  `id` int(11) NOT NULL auto_increment,
  `biopsy_type` varchar(100) default NULL,
  `ed_lab_path_report_id` int(11) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `ed_biopsy_clin_event` ADD INDEX ( `event_master_id` );

ALTER TABLE `ed_biopsy_clin_event`
ADD FOREIGN KEY (event_master_id)
REFERENCES event_masters (id);

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `ed_coll_for_cyto_clin_event`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `ed_coll_for_cyto_clin_event`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `ed_coll_for_cyto_clin_event` (
  `id` int(11) NOT NULL auto_increment,
  `collection_type` varchar(100) default NULL,
  `ed_lab_path_report_id` int(11) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `ed_coll_for_cyto_clin_event` ADD INDEX ( `event_master_id` );

ALTER TABLE `ed_coll_for_cyto_clin_event`
ADD FOREIGN KEY (event_master_id)
REFERENCES event_masters (id);

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `ed_examination_clin_event`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `ed_examination_clin_event`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `ed_examination_clin_event` (
  `id` int(11) NOT NULL auto_increment,
  `examination_type` varchar(100) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `ed_examination_clin_event` ADD INDEX ( `event_master_id` );

ALTER TABLE `ed_examination_clin_event`
ADD FOREIGN KEY (event_master_id)
REFERENCES event_masters (id);

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `ed_medical_imaging_clin_event`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `ed_medical_imaging_clin_event`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `ed_medical_imaging_clin_event` (
  `id` int(11) NOT NULL auto_increment,
  `imaging_type` varchar(100) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `ed_medical_imaging_clin_event` ADD INDEX ( `event_master_id` );

ALTER TABLE `ed_medical_imaging_clin_event`
ADD FOREIGN KEY (event_master_id)
REFERENCES event_masters (id);

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `ed_all_procure_lifestyle`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `ed_all_procure_lifestyle`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `ed_all_procure_lifestyle` (
  `id` int(11) NOT NULL auto_increment,
  `procure_lifestyle_status` varchar(50) default NULL, 
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `ed_all_procure_lifestyle` ADD INDEX ( `event_master_id` );

ALTER TABLE `ed_all_procure_lifestyle`
ADD FOREIGN KEY (event_master_id)
REFERENCES event_masters (id);

-- ---------------------------------------------------------------------
-- inventory management - Quebec Customization
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `lab_type_laterality_match`; 
DROP TABLE IF EXISTS `ad_cell_culture_tubes`; 
DROP TABLE IF EXISTS `sd_der_rnas`; 
DROP TABLE IF EXISTS `sd_der_dnas`; 

-- 
-- Table - `collections`
-- 

-- Action: ALTER
-- Comments:

ALTER TABLE `collections` 
CHANGE `bank` `bank` VARCHAR( 50 ) NOT NULL default '';
ALTER TABLE `collections` 
CHANGE `collection_property` `collection_property` VARCHAR( 50 ) NOT NULL default '';
ALTER TABLE `collections` 
ADD `bank_participant_identifier` VARCHAR(60) default NULL AFTER `bank`; 
  
-- 
-- Table - `sample_masters`
-- 

-- Action: ALTER
-- Comments:

ALTER TABLE `sample_masters` 
ADD `sample_label` VARCHAR(60) NOT NULL default '' AFTER `parent_id`; 

-- 
-- Table - `specimen_details` 
-- 

-- Action: ALTER
-- Comments:

ALTER TABLE `specimen_details` 
ADD `type_code` VARCHAR(10) default NULL AFTER `supplier_dept`,
ADD `sequence_number` VARCHAR(10) default NULL AFTER `type_code`;

-- 
-- Table - `sd_spe_tissues`
-- 

ALTER TABLE `sd_spe_tissues` 
ADD `labo_laterality` VARCHAR(10) default NULL AFTER `laterality`;

-- 
-- Table - `sd_der_dnas`
-- 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `sd_der_dnas` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) NOT NULL default '0',
  `source_cell_passage_number` int(6) default NULL,
  `source_temperature` decimal(5,2) default NULL,
  `source_temp_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `sd_der_dnas` ADD INDEX ( `sample_master_id` );

ALTER TABLE `sd_der_dnas`
ADD FOREIGN KEY (sample_master_id)
REFERENCES sample_masters (id);

-- 
-- Table - `sd_der_rnas`
-- 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `sd_der_rnas` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) NOT NULL default '0',
  `source_cell_passage_number` int(6) default NULL,
  `source_temperature` decimal(5,2) default NULL,
  `source_temp_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `sd_der_rnas` ADD INDEX ( `sample_master_id` );

ALTER TABLE `sd_der_rnas`
ADD FOREIGN KEY (sample_master_id)
REFERENCES sample_masters (id);

-- 
-- Table - `aliquot_masters`
-- 

-- Action: ALTER
-- Comments:

ALTER TABLE `aliquot_masters` 
ADD `aliquot_label` VARCHAR(60) NOT NULL default '' AFTER `barcode`; 
ALTER TABLE `aliquot_masters` 
CHANGE `status` `status` VARCHAR( 30 ) NOT NULL DEFAULT '';

-- 
-- Table - `ad_blocks`
-- 

-- Action: ALTER
-- Comments:

ALTER TABLE `ad_blocks` 
ADD `sample_position_code` varchar(10) default NULL AFTER `type`, 
ADD `path_report_code` varchar(40) default NULL AFTER `patho_dpt_block_code`;

-- 
-- Table - `ad_cell_culture_tubes`
-- 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `ad_cell_culture_tubes` (
  `id` int(11) NOT NULL auto_increment,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `lot_number` varchar(30) default NULL,
  `cell_passage_number` int(6) default NULL,  
  `concentration` decimal(10,2) default NULL,
  `concentration_unit` varchar(20) default NULL,
  `cell_count` decimal(10,2) default NULL,
  `cell_count_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `ad_cell_culture_tubes` ADD INDEX ( `aliquot_master_id` );

ALTER TABLE `ad_cell_culture_tubes`
ADD FOREIGN KEY (aliquot_master_id)
REFERENCES aliquot_masters (id);

-- 
-- Table - `lab_type_laterality_match`
-- 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `lab_type_laterality_match` (
  `id` int(11) NOT NULL auto_increment,
  `selected_type_code` VARCHAR(10) default NULL,  
  `selected_labo_laterality` VARCHAR(10) default NULL, 
  `sample_type_matching` varchar(30) default NULL,
  `tissue_source_matching` varchar(20) default NULL,
  `nature_matching` varchar(15) default NULL,  
  `laterality_matching` varchar(10) default NULL, 
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

-- 
-- Table - `quality_controls`
-- 

-- Action: ALTER
-- Comments:

ALTER TABLE `quality_controls` 
ADD `chip_model` VARCHAR(10) default NULL AFTER `type`,
ADD `position_into_run` VARCHAR(20) default NULL AFTER `run_id`;

-- ---------------------------------------------------------------------
-- inventory management - Temporary Quebec Customization
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS `ad_tissue_bags`; 
DROP TABLE IF EXISTS `ad_tissue_tubes`; 
DROP TABLE IF EXISTS `sd_der_amplified_rnas`; 
DROP TABLE IF EXISTS `sd_der_blood_cells`; 
DROP TABLE IF EXISTS `sd_der_pbmcs`; 

-- 
-- Table - `sd_spe_tissues`
-- 

ALTER TABLE `sd_spe_tissues` 
ADD `tmp_buffer_use` VARCHAR(10) default NULL AFTER `size`,
ADD `tmp_on_ice` VARCHAR(10) default NULL AFTER `tmp_buffer_use`;

-- 
-- Table - `sd_der_pbmcs`
-- 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `sd_der_pbmcs` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) NOT NULL default '0',
  `tmp_solution` varchar(30) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `sd_der_pbmcs` ADD INDEX ( `sample_master_id` );

ALTER TABLE `sd_der_pbmcs`
ADD FOREIGN KEY (sample_master_id)
REFERENCES sample_masters (id);

-- 
-- Table - `sd_der_blood_cells`
-- 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `sd_der_blood_cells` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) NOT NULL default '0',
  `tmp_solution` varchar(30) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `sd_der_blood_cells` ADD INDEX ( `sample_master_id` );

ALTER TABLE `sd_der_blood_cells`
ADD FOREIGN KEY (sample_master_id)
REFERENCES sample_masters (id);

-- 
-- Table - `sd_der_cell_cultures`
-- 

ALTER TABLE `sd_der_cell_cultures` 
ADD `tmp_collection_method` VARCHAR(30) default NULL AFTER `cell_passage_number`,
ADD `tmp_hormon` varchar(40) default NULL AFTER `tmp_collection_method`,
ADD `tmp_solution` VARCHAR(30) default NULL AFTER `tmp_hormon`,
ADD `tmp_percentage_of_oxygen` VARCHAR(30) default NULL AFTER `tmp_solution`,
ADD `tmp_percentage_of_serum` VARCHAR(30) default NULL AFTER `tmp_percentage_of_oxygen`;

-- 
-- Table - `sd_der_dnas`
-- 

ALTER TABLE `sd_der_dnas` 
ADD `tmp_extraction_method` VARCHAR(30) default NULL AFTER `source_temp_unit`,
ADD `tmp_source_milieu` VARCHAR(30) default NULL AFTER `tmp_extraction_method`,
ADD `tmp_source_storage_method` VARCHAR(30) default NULL AFTER `tmp_source_milieu`;

-- 
-- Table - `sd_der_rnas`
-- 

ALTER TABLE `sd_der_rnas` 
ADD `tmp_extraction_method` VARCHAR(30) default NULL AFTER `source_temp_unit`,
ADD `tmp_source_milieu` VARCHAR(30) default NULL AFTER `tmp_extraction_method`,
ADD `tmp_source_storage_method` VARCHAR(30) default NULL AFTER `tmp_source_milieu`;

-- 
-- Table - `sd_der_amplified_rnas`
-- 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `sd_der_amplified_rnas` (
  `id` int(11) NOT NULL auto_increment,
  `sample_master_id` int(11) NOT NULL default '0',
  `tmp_amplification_method` varchar(30) default NULL,
  `tmp_amplification_number` varchar(30) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `sd_der_amplified_rnas` ADD INDEX ( `sample_master_id` );

ALTER TABLE `sd_der_amplified_rnas`
ADD FOREIGN KEY (sample_master_id)
REFERENCES sample_masters (id);

-- 
-- Table - `ad_blocks`
-- 

-- Action: ALTER
-- Comments:

ALTER TABLE `ad_blocks` 
ADD `tmp_gleason_primary_grade` varchar(5) default NULL AFTER `patho_dpt_block_code`,
ADD `tmp_gleason_secondary_grade` varchar(5) default NULL AFTER `tmp_gleason_primary_grade`,
ADD `tmp_tissue_primary_desc` varchar(20) default NULL AFTER `tmp_gleason_secondary_grade`,
ADD `tmp_tissue_secondary_desc` varchar(20) default NULL AFTER `tmp_tissue_primary_desc`; 

-- 
-- Table - `ad_tissue_tubes`
-- 

-- Action: CREATE
-- Comments: n/a


CREATE TABLE `ad_tissue_tubes`(
  `id` int(11) NOT NULL auto_increment,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `tmp_storage_solution` varchar(30) default NULL,
  `tmp_storage_method` varchar(30) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `ad_tissue_tubes` ADD INDEX ( `aliquot_master_id` );

ALTER TABLE `ad_tissue_tubes`
ADD FOREIGN KEY (aliquot_master_id)
REFERENCES aliquot_masters (id);

-- 
-- Table - `ad_tissue_bags`
-- 

-- Action: CREATE
-- Comments: n/a


CREATE TABLE `ad_tissue_bags`(
  `id` int(11) NOT NULL auto_increment,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `tmp_storage_solution` varchar(30) default NULL,
  `tmp_storage_method` varchar(30) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `ad_tissue_bags` ADD INDEX ( `aliquot_master_id` );

ALTER TABLE `ad_tissue_bags`
ADD FOREIGN KEY (aliquot_master_id)
REFERENCES aliquot_masters (id);

-- 
-- Table - `ad_cell_culture_tubes`
-- 

-- Action: ALTER
-- Comments:

ALTER TABLE `ad_cell_culture_tubes` 
ADD `tmp_storage_solution` varchar(30) default NULL AFTER `cell_passage_number`; 

-- 
-- Table - `ad_tubes`
-- 

-- Action: ALTER
-- Comments:

ALTER TABLE `ad_tubes` 
ADD `tmp_storage_solution` varchar(30) default NULL AFTER `concentration_unit`; 


-- ---------------------------------------------------------------------
-- CTRApp - order
-- ---------------------------------------------------------------------

ALTER TABLE `orders` ADD `type` VARCHAR( 30 ) default NULL AFTER `short_title` ;
ALTER TABLE `orders` ADD `microarray_chip` VARCHAR( 30 ) default NULL AFTER  `type` ;

ALTER TABLE `order_items` ADD `shipping_name` VARCHAR( 80 ) default NULL AFTER `barcode` ;
ALTER TABLE `orders` CHANGE `order_number` `order_number` VARCHAR( 255 ) NOT NULL ;

-- ---------------------------------------------------------------------
-- CTRApp - tool 
-- ---------------------------------------------------------------------

ALTER TABLE `protocol_masters` 
CHANGE `name` `name` VARCHAR( 100 );

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `pd_undetailled_protocols`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `pd_undetailled_protocols`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `pd_undetailled_protocols` (
  `id` int(11) NOT NULL auto_increment,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `protocol_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `pd_undetailled_protocols` ADD INDEX ( `protocol_master_id` );

ALTER TABLE `pd_undetailled_protocols`
ADD FOREIGN KEY (protocol_master_id)
REFERENCES protocol_masters (id);

-- ---------------------------------------------------------------------
-- CREATE TABLE:
--    - `pe_undetailled_protocols`
-- ---------------------------------------------------------------------

-- Action: DROP
-- Comments: n/a

DROP TABLE IF EXISTS `pe_undetailled_protocols`; 

-- Action: CREATE
-- Comments: n/a

CREATE TABLE `pe_undetailled_protocols` (
  `id` int(11) NOT NULL auto_increment,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `protocol_master_id` int(11) NOT NULL default '0',
  `drug_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) AUTO_INCREMENT=1 ;

ALTER TABLE `pe_undetailled_protocols` ADD INDEX ( `protocol_master_id` );

ALTER TABLE `pe_undetailled_protocols`
ADD FOREIGN KEY (protocol_master_id)
REFERENCES protocol_masters (id);

-- ---------------------------------------------------------------------
-- CTRApp - storage management 
-- ---------------------------------------------------------------------

ALTER TABLE `storage_masters` 
CHANGE `short_label` `short_label` VARCHAR( 10 ) NOT NULL default '';
ALTER TABLE `storage_masters` 
CHANGE `selection_label` `selection_label` VARCHAR( 60 ) NOT NULL default '';

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: AFTER PROD
--
-- ------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------

ALTER TABLE `derivative_details` 
CHANGE `creation_by` `creation_by` VARCHAR( 50 ) DEFAULT NULL;

ALTER TABLE `collections` 
CHANGE `reception_by` `reception_by` VARCHAR( 50 ) DEFAULT NULL;

ALTER TABLE `aliquot_masters` 
ADD `stored_by` VARCHAR(50) default NULL AFTER `storage_coord_y`; 

ALTER TABLE `specimen_details` 
CHANGE `supplier_dept` `supplier_dept` VARCHAR( 40 ) DEFAULT NULL;

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: 1.5
--
-- ------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: 1.5.1
--
-- ------------------------------------------------------------------------------------------------

-- 
-- Table structure for table `ed_all_adverse_events_adverse_event`
-- 

CREATE TABLE `ed_all_adverse_events_adverse_event` (
  `id` int(11) NOT NULL auto_increment,
  `supra_ordinate_term` varchar(50) default NULL,
  `select_ae` varchar(50) default NULL,
  `grade` varchar(50) default NULL,
  `description` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_all_clinical_followup`
-- 

CREATE TABLE `ed_all_clinical_followup` (
  `id` int(11) NOT NULL auto_increment,
  `weight` int(11) default NULL,
  `recurrence_status` varchar(50) default NULL,
  `disease_status` varchar(50) default NULL,
  `vital_status` varchar(50) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_all_clinical_presentation`
-- 

CREATE TABLE `ed_all_clinical_presentation` (
  `id` int(11) NOT NULL auto_increment,
  `weight` decimal(10,2) default NULL,
  `height` int(11) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_all_lifestyle_base`
-- 

CREATE TABLE `ed_all_lifestyle_base` (
  `id` int(11) NOT NULL auto_increment,
  `smoking_history` varchar(50) default NULL,
  `smoking_status` varchar(50) default NULL,
  `pack_years` date default NULL,
  `product_used` varchar(50) default NULL,
  `years_quit_smoking` int(11) default NULL,
  `alcohol_history` varchar(50) default NULL,
  `weight_loss` float default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_all_protocol_followup`
-- 

CREATE TABLE `ed_all_protocol_followup` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_all_study_research`
-- 

CREATE TABLE `ed_all_study_research` (
  `id` int(11) NOT NULL auto_increment,
  `field_one` varchar(50) default NULL,
  `field_two` varchar(50) default NULL,
  `field_three` varchar(50) default NULL,
  `event_master_id` int(11) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_allsolid_lab_pathology`
-- 

CREATE TABLE `ed_allsolid_lab_pathology` (
  `id` int(11) NOT NULL auto_increment,
  `tumour_type` varchar(50) default NULL,
  `resection_margin` varchar(50) default NULL,
  `extra_nodal_invasion` varchar(50) default NULL,
  `lymphatic_vascular_invasion` varchar(50) default NULL,
  `in_situ_component` varchar(50) default NULL,
  `fine_needle_aspirate` varchar(50) default NULL,
  `trucut_core_biopsy` varchar(50) default NULL,
  `open_biopsy` varchar(50) default NULL,
  `frozen_section` varchar(50) default NULL,
  `breast_tumour_size` varchar(50) default NULL,
  `nodes_removed` varchar(50) default NULL,
  `nodes_positive` varchar(50) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `ed_breast_lab_pathology`
-- 

CREATE TABLE `ed_breast_lab_pathology` (
  `id` int(11) NOT NULL auto_increment,
  `path_number` varchar(50) default NULL,
  `report_type` varchar(50) default NULL,
  `facility` varchar(50) default NULL,
  `vascular_lymph_invasion` varchar(50) default NULL,
  `extra_nodal_invasion` varchar(50) default NULL,
  `blood_lymph` varchar(50) default NULL,
  `tumour_type` varchar(50) default NULL,
  `grade` varchar(50) default NULL,
  `multifocal` varchar(50) default NULL,
  `preneoplastic_changes` varchar(50) default NULL,
  `spread_skin_nipple` varchar(50) default NULL,
  `level_nodal_involvement` varchar(50) default NULL,
  `frozen_section` varchar(50) default NULL,
  `er_assay_ligand` varchar(50) default NULL,
  `pr_assay_ligand` varchar(50) default NULL,
  `progesterone` varchar(50) default NULL,
  `estrogen` varchar(50) default NULL,
  `number_resected` varchar(50) default NULL,
  `number_positive` varchar(50) default NULL,
  `nodal_status` varchar(45) default NULL,
  `resection_margins` varchar(50) default NULL,
  `tumour_size` varchar(50) default NULL,
  `tumour_total_size` varchar(45) default NULL,
  `sentinel_only` varchar(50) default NULL,
  `in_situ_type` varchar(50) default NULL,
  `her2_grade` varchar(50) default NULL,
  `her2_method` varchar(50) default NULL,
  `mb_collectionid` varchar(45) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

-- 
-- Table structure for table `ed_breast_screening_mammogram`
-- 

CREATE TABLE `ed_breast_screening_mammogram` (
  `id` int(11) NOT NULL auto_increment,
  `result` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `txd_combos`
-- 

CREATE TABLE `txd_combos` (
  `id` int(11) NOT NULL auto_increment,
  `txd_combo_path_num` varchar(50) default NULL,
  `txd_combo_primary` varchar(50) default NULL,
  `txd_combo_provider` varchar(50) default NULL,
  `txd_combo_chemocompleted` varchar(50) default NULL,
  `txd_combo_response` varchar(50) default NULL,
  `txd_combo_num_cycles` int(11) default NULL,
  `txd_combo_length_cycles` int(11) default NULL,
  `txd_combo_completed_cycles` int(11) default NULL,
  `txd_combo_total_dose` varchar(50) default NULL,
  `txd_combo_total_fractions` varchar(50) default NULL,
  `txd_combo_radcompleted` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Table structure for table `txe_radiations`
-- 

CREATE TABLE `txe_radiations` (
  `id` int(11) NOT NULL auto_increment,
  `modaility` varchar(50) default NULL,
  `technique` varchar(50) default NULL,
  `fractions` varchar(50) default NULL,
  `frequency` varchar(50) default NULL,
  `total_time` varchar(50) default NULL,
  `distance_sxd` varchar(50) default NULL,
  `distance_cm` varchar(50) default NULL,
  `dose_xd` varchar(50) default NULL,
  `dose_cgy` varchar(50) default NULL,
  `completed` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  `tx_master_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


-- 
-- Table structure for table `txe_surgeries`
-- 

CREATE TABLE `txe_surgeries` (
  `id` int(11) NOT NULL auto_increment,
  `surgical_procedure` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  `tx_master_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


ALTER TABLE `collections` 
CHANGE `collection_property` `collection_property` VARCHAR( 50 ) NOT NULL default '';
ALTER TABLE `diagnoses` 
CHANGE `dx_number` `dx_number` VARCHAR( 50 ) NOT NULL default '';
ALTER TABLE `storage_masters` 
CHANGE `short_label` `short_label` VARCHAR( 10 ) NOT NULL default '';

ALTER TABLE `datamart_adhoc_favourites`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `datamart_adhoc_saved`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `ed_breast_lab_pathology`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `form_formats`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `orders`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `order_items`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `order_lines`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `participant_messages`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `reproductive_histories`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `shipments`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `txe_chemos`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `install_disease_sites`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `install_locations`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
ALTER TABLE `install_studies`  ENGINE = innodb DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;

ALTER TABLE `datamart_adhoc_saved` 
CHANGE `search_params` `search_params` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
CHANGE `description` `description` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;

ALTER TABLE `install_disease_sites` 
CHANGE `disease_site` `disease_site` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;

ALTER TABLE `install_locations` 
CHANGE `country` `country` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'canada',
CHANGE `region` `region` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'all',
CHANGE `biobank` `biobank` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'all';

ALTER TABLE `install_studies` 
CHANGE `study_name` `study_name` VARCHAR( 100 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;

ALTER TABLE `participant_messages` 
CHANGE `author` `author` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `type` `type` VARCHAR( 20 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `title` `title` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `description` `description` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `created_by` `created_by` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `modified_by` `modified_by` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `sardo_note_id` `sardo_note_id` VARCHAR( 20 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL;


ALTER TABLE `txe_chemos` 
CHANGE `source` `source` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `frequency` `frequency` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `dose` `dose` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `method` `method` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `reduction` `reduction` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `created_by` `created_by` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `modified_by` `modified_by` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL ,
CHANGE `drug_id` `drug_id` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT '0';

ALTER TABLE `coding_icd10` 
CHANGE `id` `id` VARCHAR( 10 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;

ALTER TABLE `groups` 
CHANGE `redirect` `redirect` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL; 

ALTER TABLE `i18n` 
CHANGE `id` `id` VARCHAR( 100 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
CHANGE `page_id` `page_id` VARCHAR( 100 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'global',
CHANGE `en` `en` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
CHANGE `fr` `fr` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;

ALTER TABLE `materials` 
CHANGE `modified_by` `modified_by` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;

ALTER TABLE `pages` 
CHANGE `id` `id` VARCHAR( 100 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;

ALTER TABLE `txd_drugs` 
CHANGE `created_by` `created_by` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
CHANGE `modified_by` `modified_by` VARCHAR( 50 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;

-- ------------------------------------------------------------------------------------------------
--
-- VERSION: 1.6.0
--
-- ------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------
-- add procure life style field: completed -------------------------------------------------------------------------

ALTER TABLE `ed_all_procure_lifestyle`
 ADD `completed` VARCHAR( 10 ) NULL AFTER `procure_lifestyle_status`; 
 
-- -----------------------------------------------------------------------------------------------------------------
-- add collection visit flag -------------------------------------------------------------------------

ALTER TABLE `collections`
 ADD `visit_label` VARCHAR( 20 ) NULL AFTER `bank_participant_identifier`; 
 
-- -----------------------------------------------------------------------------------------------------------------
-- move ed_lab_path_report_id to event_masters table -------------------------------------------------------------------------

ALTER TABLE `event_masters`
 ADD `linked_path_report_id` int(11) NULL DEFAULT NULL AFTER `reference_number`; 

ALTER TABLE `event_masters`
ADD FOREIGN KEY (linked_path_report_id)
REFERENCES event_masters (id);

ALTER TABLE `txd_surgeries` 
CHANGE `ed_lab_path_report_id` `linked_path_report_id` INT( 11 ) NULL DEFAULT NULL;

ALTER TABLE `txd_surgeries`
ADD FOREIGN KEY (linked_path_report_id)
REFERENCES event_masters (id);

-- SELECT linked_path_report_id from txd_surgeries
-- WHERE linked_path_report_id NOT IN (SELECT id FROM event_masters);

-- SELECT ed_lab_path_report_id from ed_coll_for_cyto_clin_event
-- WHERE ed_lab_path_report_id NOT IN (SELECT id FROM event_masters);

-- SELECT ed_lab_path_report_id from ed_biopsy_clin_event
-- WHERE ed_lab_path_report_id NOT IN (SELECT id FROM event_masters);
 
-- SELECT 'UPDATE event_masters SET linked_path_report_id = ' AS sql_1, 
-- ed_lab_path_report_id, 
-- ' WHERE id = ' AS sql_2, 
-- event_master_id,
-- ' ;' AS sql_3
-- FROM ed_coll_for_cyto_clin_event WHERE ed_lab_path_report_id IS NOT NULL;
 
-- SELECT master.id
-- FROM event_masters as master
-- INNER JOIN ed_coll_for_cyto_clin_event as detail on master.id = detail.event_master_id
-- WHERE master.linked_path_report_id != detail.ed_lab_path_report_id;
 
-- SELECT 'UPDATE event_masters SET linked_path_report_id = ' AS sql_1, 
-- ed_lab_path_report_id, 
-- ' WHERE id = ' AS sql_2, 
-- event_master_id,
-- ' ;' AS sql_3
-- FROM ed_biopsy_clin_event WHERE ed_lab_path_report_id IS NOT NULL;

-- SELECT master.id
-- FROM event_masters as master
-- INNER JOIN ed_biopsy_clin_event as detail on master.id = detail.event_master_id
-- WHERE master.linked_path_report_id != detail.ed_lab_path_report_id;
 
ALTER TABLE ed_biopsy_clin_event
DROP COLUMN ed_lab_path_report_id;
 
ALTER TABLE ed_coll_for_cyto_clin_event
DROP COLUMN ed_lab_path_report_id;
 
-- -----------------------------------------------------------------------------------------------------------------
-- Change phone field size -------------------------------------------------------------------------

ALTER TABLE `participant_contacts` 
CHANGE `phone` `phone` VARCHAR( 30 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL ,
CHANGE `phone_secondary` `phone_secondary` VARCHAR( 30 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;  

-- -----------------------------------------------------------------------------------------------------------------
-- Add Task Status -------------------------------------------------

ALTER TABLE `participant_messages` 
ADD `status` VARCHAR( 20 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL AFTER `expiry_date` ;

-- ------------------------------------------------------------------------------
-- Allow 5-7 for cell passage number ---------

ALTER TABLE `sd_der_cell_cultures` 
CHANGE `cell_passage_number` `cell_passage_number` VARCHAR( 10 ) NULL DEFAULT NULL;

ALTER TABLE `sd_der_dnas` 
CHANGE `source_cell_passage_number` `source_cell_passage_number` VARCHAR( 10 ) NULL DEFAULT NULL ;

ALTER TABLE `sd_der_rnas` 
CHANGE `source_cell_passage_number` `source_cell_passage_number` VARCHAR( 10 ) NULL DEFAULT NULL ;

ALTER TABLE `ad_cell_culture_tubes` 
CHANGE `cell_passage_number` `cell_passage_number` VARCHAR( 10 ) NULL DEFAULT NULL ;

-- -----------------------------------------------------------------------------------------------------------------
-- Add time to QC date -------------------------------------------------

ALTER TABLE `quality_controls` 
CHANGE `date` `date` DATETIME NULL DEFAULT NULL;


ALTER TABLE `storage_masters` 
CHANGE `short_label` `short_label` VARCHAR( 15 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL; 


-- -----------------------------------------------------------------------------------------------------------------
-- Add time to QC date -------------------------------------------------

ALTER TABLE `ad_tubes` 
ADD `tmp_storage_method` varchar(30) default NULL AFTER `tmp_storage_solution`; 