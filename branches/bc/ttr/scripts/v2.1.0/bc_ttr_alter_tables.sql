ALTER TABLE `participants`
  ADD COLUMN `bc_ttr_phn` varchar(20) DEFAULT NULL;
ALTER TABLE `participants_revs`
  ADD COLUMN `bc_ttr_phn` varchar(20) DEFAULT NULL;
  


ALTER TABLE `consent_masters`
  ADD COLUMN `bc_ttr_consent_closed` varchar(100) DEFAULT NULL,
  ADD COLUMN `bc_ttr_protocol` varchar(100) DEFAULT NULL,
  ADD COLUMN `bc_ttr_diagnosis` varchar(50) DEFAULT NULL,
  ADD COLUMN `bc_ttr_cancer_type` varchar(50) DEFAULT NULL,
  ADD COLUMN `bc_ttr_referral_source` varchar(50) DEFAULT NULL,
  ADD COLUMN `bc_ttr_home_phone` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_cell_phone` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_work_phone` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_fax_number` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_email` varchar(30) DEFAULT NULL,
  ADD COLUMN `bc_ttr_iroc_number` varchar(10) DEFAULT NULL,
  ADD COLUMN `bc_ttr_iroc_flag` varchar(10) DEFAULT NULL,
  ADD COLUMN `bc_ttr_pathologist` varchar(50) DEFAULT NULL,
  ADD COLUMN `bc_ttr_consent_id` varchar(10) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_acquisition_id` varchar(10) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_ttr_appt_datetime` datetime DEFAULT NULL, 
  ADD COLUMN `bc_ttr_blood_collected` varchar(10) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_tissue_collected` varchar(10) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_contact_for_genetic_research` varchar(10) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_surgery` varchar(20) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_smoking_history` varchar(20) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_pack_years` varchar(20) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_years_since_quit` varchar(20) DEFAULT NULL,   
  ADD COLUMN `bc_ttr_medical_record_no` varchar(20) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_pathology_specification` varchar(20) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_date_consent_denied` date DEFAULT NULL, 
  ADD COLUMN `bc_ttr_date_consent_withdrawn` date DEFAULT NULL, 
  ADD COLUMN `bc_ttr_date_referral_withdrawn` date DEFAULT NULL,
  ADD COLUMN `bc_ttr_decline_use_of_blood_samples` varchar(10) DEFAULT NULL,
  ADD COLUMN `bc_ttr_brt_flag` varchar(10) DEFAULT NULL;
  
ALTER TABLE `consent_masters_revs`
  ADD COLUMN `bc_ttr_consent_closed` varchar(100) DEFAULT NULL,
  ADD COLUMN `bc_ttr_protocol` varchar(100) DEFAULT NULL,
  ADD COLUMN `bc_ttr_diagnosis` varchar(50) DEFAULT NULL,
  ADD COLUMN `bc_ttr_cancer_type` varchar(50) DEFAULT NULL,
  ADD COLUMN `bc_ttr_referral_source` varchar(50) DEFAULT NULL,
  ADD COLUMN `bc_ttr_home_phone` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_cell_phone` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_work_phone` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_fax_number` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_email` varchar(30) DEFAULT NULL,
  ADD COLUMN `bc_ttr_iroc_number` varchar(10) DEFAULT NULL,
  ADD COLUMN `bc_ttr_iroc_flag` varchar(10) DEFAULT NULL,
  ADD COLUMN `bc_ttr_pathologist` varchar(50) DEFAULT NULL,
  ADD COLUMN `bc_ttr_consent_id` varchar(10) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_acquisition_id` varchar(10) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_ttr_appt_datetime` datetime DEFAULT NULL, 
  ADD COLUMN `bc_ttr_blood_collected` varchar(10) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_tissue_collected` varchar(10) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_contact_for_genetic_research` varchar(10) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_surgery` varchar(20) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_smoking_history` varchar(20) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_pack_years` varchar(20) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_years_since_quit` varchar(20) DEFAULT NULL,   
  ADD COLUMN `bc_ttr_medical_record_no` varchar(20) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_pathology_specification` varchar(20) DEFAULT NULL, 
  ADD COLUMN `bc_ttr_date_consent_denied` date DEFAULT NULL, 
  ADD COLUMN `bc_ttr_date_consent_withdrawn` date DEFAULT NULL, 
  ADD COLUMN `bc_ttr_date_referral_withdrawn` date DEFAULT NULL,
  ADD COLUMN `bc_ttr_decline_use_of_blood_samples` varchar(10) DEFAULT NULL,
  ADD COLUMN `bc_ttr_brt_flag` varchar(10) DEFAULT NULL;
   
  
  
  
DROP TABLE IF EXISTS `bc_ttr_correspondences`;
CREATE TABLE IF NOT EXISTS `bc_ttr_correspondences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `participant_id` int(11) NOT NULL DEFAULT '0',
  `bc_ttr_correspondence_datetime` datetime DEFAULT NULL,
  `bc_ttr_correspondence_nurse` varchar(50) DEFAULT NULL,
  `bc_ttr_correspondence_type` varchar(50) DEFAULT NULL,
  `bc_ttr_purpose` varchar(50) DEFAULT NULL,
  `bc_ttr_location` varchar(50) DEFAULT NULL,
  `bc_ttr_correspondence_notes` text,
  `created` datetime DEFAULT NULL,
  `created_by` varchar(50)  DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50)  DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `participant_id` (`participant_id`)
) ENGINE=InnoDb  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;  

DROP TABLE IF EXISTS `bc_ttr_correspondences_revs`;
CREATE TABLE IF NOT EXISTS `bc_ttr_correspondences_revs` (
  `id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL DEFAULT '0',
  `bc_ttr_correspondence_datetime` datetime DEFAULT NULL,
  `bc_ttr_correspondence_nurse` varchar(50) DEFAULT NULL,
  `bc_ttr_correspondence_type` varchar(50) DEFAULT NULL,
  `bc_ttr_purpose` varchar(50) DEFAULT NULL,
  `bc_ttr_location` varchar(50) DEFAULT NULL,
  `bc_ttr_correspondence_notes` text,
  `created` datetime DEFAULT NULL,
  `created_by` varchar(50)  DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50)  DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `version_created` datetime NOT NULL               
) ENGINE=InnoDb  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;  


ALTER TABLE `collections`
  ADD COLUMN `bc_ttr_collected_by` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_collection_type` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_blood_collection_status` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_tissue_collection_status` varchar(30) DEFAULT NULL;
  
 
ALTER TABLE `collections_revs`
  ADD COLUMN `bc_ttr_collected_by` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_collection_type` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_blood_collection_status` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_tissue_collection_status` varchar(30) DEFAULT NULL;
  

ALTER TABLE `sd_spe_bloods`
  ADD COLUMN `bc_ttr_blood_drawn_datetime` datetime DEFAULT NULL,
  ADD COLUMN `bc_ttr_room_temperature` varchar(5) DEFAULT NULL;

ALTER TABLE `sd_spe_bloods_revs`
  ADD COLUMN `bc_ttr_blood_drawn_datetime` datetime DEFAULT NULL,
  ADD COLUMN `bc_ttr_room_temperature` varchar(5) DEFAULT NULL;


ALTER TABLE `sd_spe_tissues`
  ADD COLUMN `bc_ttr_time_anaesthesia_ready` time DEFAULT NULL,
  ADD COLUMN `bc_ttr_time_incision` time DEFAULT NULL,
  ADD COLUMN `bc_ttr_collection_pathologist` varchar(30) DEFAULT NULL,
  ADD COLUMN `bc_ttr_after_hour_collection` char(3) DEFAULT NULL;

ALTER TABLE `sd_spe_tissues_revs`
  ADD COLUMN `bc_ttr_time_anaesthesia_ready` time DEFAULT NULL,
  ADD COLUMN `bc_ttr_time_incision` time DEFAULT NULL,
  ADD COLUMN `bc_ttr_collection_pathologist` varchar(30) DEFAULT NULL,
  ADD COLUMN `bc_ttr_after_hour_collection` char(3) DEFAULT NULL;
  


#------------------------
--   Blood Cells
#------------------------


ALTER TABLE  atim.`sample_masters` ADD  `bc_ttr_buffy_coat_lab_tech` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sample_masters` ADD  `bc_ttr_ttrdb_acquisition_label` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sd_der_blood_cells` ADD  `bc_ttr_buffy_coat_lab_tech` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;

-- Drop Constraint in Unique Sample code in ATIM sample masters - we need to put this constraint back after the following transaction
ALTER TABLE  atim.`sample_masters` DROP INDEX  `unique_sample_code`;


-- Insert into temporary table  for Blood Cells (Buffy Coat) specimen
INSERT INTO atim.sample_masters
(sample_category, sample_control_id, sample_type, initial_specimen_sample_type, collection_id,     bc_ttr_ttrdb_acquisition_label, bc_ttr_buffy_coat_lab_tech )
SELECT 
'derivative','7', 'blood cell', 'blood', tcol.id,  
tcol.acquisition_label, tcol.buffy_coat_lab_tech
FROM  ttrdb.collections tcol  
WHERE  
( SELECT Count(*) FROM ttrdb.sample_masters tsm WHERE tsm.collection_id =  tcol.id AND tsm.sample_type = 'buffy_coat' ) > 0 ;


UPDATE atim.sample_masters
SET sample_code = CONCAT( 'BLD-C - ' , id)  
WHERE sample_control_id = 7;

-- Put Constraint back as Unique Sample code in ATIM sample masters - we need to put this constraint back after the following transaction
CREATE UNIQUE INDEX unique_sample_code ON atim.sample_masters ( sample_code );


-- Insert Blood Cell (Buffy Coat) Derivative into sample detail table
INSERT INTO atim.sd_der_blood_cells (sample_master_id, bc_ttr_buffy_coat_lab_tech )
SELECT smt.id, smt.bc_ttr_buffy_coat_lab_tech
FROM atim.sample_masters smt
WHERE smt.sample_code LIKE '%BLD-C%'
 
 
#------------------------
--   Plasma
#------------------------


ALTER TABLE  atim.`sample_masters` ADD  `bc_ttr_plasma_lab_tech` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sample_masters` ADD  `bc_ttr_plasma_duration` INT(4) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sample_masters` ADD  `bc_ttr_plasma_Gval` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sample_masters` ADD  `bc_ttr_plasma_temperature` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  atim.`sample_masters` ADD  `bc_ttr_plasma_transporter_time` time NULL AFTER  `deleted_date`;

-- ALTER TABLE  atim.`sample_masters` ADD  `bc_ttr_ttrdb_acquisition_label` VARCHAR( 20 ) NULL AFTER  `deleted_date`

ALTER TABLE  atim.`sd_der_plasmas` ADD  `bc_ttr_plasma_lab_tech` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;
ALTER TABLE  atim.`sd_der_plasmas` ADD  `bc_ttr_plasma_duration` INT(4) NULL AFTER  `sample_master_id`;
ALTER TABLE  atim.`sd_der_plasmas` ADD  `bc_ttr_plasma_Gval` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;
ALTER TABLE  atim.`sd_der_plasmas` ADD  `bc_ttr_plasma_temperature` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;
ALTER TABLE  atim.`sd_der_plasmas` ADD  `bc_ttr_plasma_transporter_time` time NULL AFTER  `sample_master_id`;





-- Drop Constraint in Unique Sample code in ATIM sample masters - we need to put this constraint back after the following transaction
ALTER TABLE  atim.`sample_masters` DROP INDEX  `unique_sample_code`;

-- Insert into temporary table  for Plasma Derivative Sample 
INSERT INTO atim.sample_masters
(sample_category, sample_control_id, sample_type, initial_specimen_sample_type, collection_id,     bc_ttr_ttrdb_acquisition_label, bc_ttr_plasma_lab_tech, bc_ttr_plasma_duration, bc_ttr_plasma_Gval, bc_ttr_plasma_temperature, bc_ttr_plasma_transporter_time )
SELECT 
'derivative','9', 'plasma', 'blood', tcol.id, 
tcol.acquisition_label, tcol.plasma_lab_tech, tcol.plasma_duration, tcol.plasma_Gval,
tcol.plasma_temperature, tcol.plasma_transporter_time
FROM  ttrdb.collections tcol  
WHERE  
( SELECT Count(*) FROM ttrdb.sample_masters tsm WHERE tsm.collection_id =  tcol.id AND tsm.sample_type = 'plasma' ) > 0 ;



UPDATE atim.sample_masters
SET sample_code = CONCAT( 'PLS - ' , id)  
WHERE sample_control_id = 9;


-- Put Constraint back as Unique Sample code in ATIM sample masters - we need to put this constraint back after the following transaction
CREATE UNIQUE INDEX unique_sample_code ON atim.sample_masters ( sample_code );


-- Insert Plasma Derivatives
INSERT INTO atim.sd_der_plasmas (sample_master_id, bc_ttr_plasma_lab_tech, bc_ttr_plasma_duration, 
 bc_ttr_plasma_Gval, bc_ttr_plasma_temperature, bc_ttr_plasma_transporter_time  )
SELECT smt.id, smt.bc_ttr_plasma_lab_tech, smt.bc_ttr_plasma_duration, smt.bc_ttr_plasma_Gval, smt.bc_ttr_plasma_temperature, smt.bc_ttr_plasma_transporter_time
FROM atim.sample_masters smt
WHERE smt.sample_code LIKE '%PLS%'
 


#------------------------
--   Tissue Blocks
#------------------------
  
 
ALTER TABLE ad_blocks
 ADD COLUMN bc_ttr_tissue_site VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_tissue_type VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_size_of_tumour VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_tissue_observation VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_time_of_removal TIME DEFAULT NULL,
 ADD COLUMN bc_ttr_page_time TIME DEFAULT NULL,
 ADD COLUMN bc_ttr_tissue_arrival_in_patho_lab TIME DEFAULT NULL,
 ADD COLUMN bc_ttr_pathologist_presence TIME DEFAULT NULL,
 ADD COLUMN bc_ttr_tissue_in_transporter TIME DEFAULT NULL,
 ADD COLUMN bc_ttr_transporter VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_path_reference VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_size1 FLOAT DEFAULT NULL,
 ADD COLUMN bc_ttr_size2 FLOAT DEFAULT NULL,
 ADD COLUMN bc_ttr_size3 FLOAT DEFAULT NULL,
 ADD COLUMN bc_ttr_tissue_subsite VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_block_observation VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE ad_blocks_revs
 ADD COLUMN bc_ttr_tissue_site VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_tissue_type VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_size_of_tumour VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_tissue_observation VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_time_of_removal TIME DEFAULT NULL,
 ADD COLUMN bc_ttr_page_time TIME DEFAULT NULL,
 ADD COLUMN bc_ttr_tissue_arrival_in_patho_lab TIME DEFAULT NULL,
 ADD COLUMN bc_ttr_pathologist_presence TIME DEFAULT NULL,
 ADD COLUMN bc_ttr_tissue_in_transporter TIME DEFAULT NULL,
 ADD COLUMN bc_ttr_transporter VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_path_reference VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_size1 FLOAT DEFAULT NULL,
 ADD COLUMN bc_ttr_size2 FLOAT DEFAULT NULL,
 ADD COLUMN bc_ttr_size3 FLOAT DEFAULT NULL,
 ADD COLUMN bc_ttr_tissue_subsite VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_block_observation VARCHAR(50) NOT NULL DEFAULT '';
 
 
 
#------------------------
--   Tissue Slides
#------------------------


ALTER TABLE ad_tissue_slides
 ADD COLUMN bc_ttr_date_created DATE DEFAULT NULL,
 ADD COLUMN bc_ttr_slide_stain VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_slide_location VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_lab_technician VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_time_removed_from_formalin TIME DEFAULT NULL;
ALTER TABLE ad_tissue_slides_revs
 ADD COLUMN bc_ttr_date_created DATE DEFAULT NULL,
 ADD COLUMN bc_ttr_slide_stain VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_slide_location VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_lab_technician VARCHAR(50) NOT NULL DEFAULT '',
 ADD COLUMN bc_ttr_time_removed_from_formalin TIME DEFAULT NULL;
 
  