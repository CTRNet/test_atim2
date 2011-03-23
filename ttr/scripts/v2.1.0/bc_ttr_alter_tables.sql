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



  
DROP TABLE IF EXISTS `correspondences`;
CREATE TABLE IF NOT EXISTS `correspondences` (
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


ALTER TABLE  `sample_masters` ADD  `bc_ttr_buffy_coat_lab_tech` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  `sample_masters` ADD  `bc_ttr_ttrdb_acquisition_label` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  `sd_der_blood_cells` ADD  `bc_ttr_buffy_coat_lab_tech` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;

 
#------------------------
--   Plasma
#------------------------


ALTER TABLE  `sample_masters` ADD  `bc_ttr_plasma_lab_tech` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  `sample_masters` ADD  `bc_ttr_plasma_duration` INT(4) NULL AFTER  `deleted_date`;
ALTER TABLE  `sample_masters` ADD  `bc_ttr_plasma_Gval` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  `sample_masters` ADD  `bc_ttr_plasma_temperature` VARCHAR( 20 ) NULL AFTER  `deleted_date`;
ALTER TABLE  `sample_masters` ADD  `bc_ttr_plasma_transporter_time` time NULL AFTER  `deleted_date`;

ALTER TABLE  `sd_der_plasmas` ADD  `bc_ttr_plasma_lab_tech` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;
ALTER TABLE  `sd_der_plasmas` ADD  `bc_ttr_plasma_duration` INT(4) NULL AFTER  `sample_master_id`;
ALTER TABLE  `sd_der_plasmas` ADD  `bc_ttr_plasma_Gval` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;
ALTER TABLE  `sd_der_plasmas` ADD  `bc_ttr_plasma_temperature` VARCHAR( 20 ) NULL AFTER  `sample_master_id`;
ALTER TABLE  `sd_der_plasmas` ADD  `bc_ttr_plasma_transporter_time` time NULL AFTER  `sample_master_id`;






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
 


-- -------------------------------
--   Specimen and Aliquot Review 
-- -------------------------------


--
-- Table structure for table `spr_ovarian_cancer_types`
--


CREATE TABLE IF NOT EXISTS `spr_ovarian_cancer_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `specimen_review_master_id` int(11) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `other_type` varchar(250) DEFAULT NULL,
  `tumour_grade_score_nuclei` decimal(5,1) DEFAULT NULL,
  `tumour_grade_score_mitosis` decimal(5,1) DEFAULT NULL,
  `tumour_grade_score_architecture` decimal(5,1) DEFAULT NULL,
  `tumour_grade_score_total` decimal(5,1) DEFAULT NULL,
  `tumour_grade_category` varchar(100) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_spr_ovarian_cancer_types_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Constraints for table `spr_ovarian_cancer_types`
--
ALTER TABLE `spr_ovarian_cancer_types`
  ADD CONSTRAINT `FK_spr_ovarian_cancer_types_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);


-- --------------------------------------------------------

--
-- Table structure for table `spr_generic_cancer_types`
--


CREATE TABLE IF NOT EXISTS `spr_generic_cancer_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `specimen_review_master_id` int(11) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `other_type` varchar(250) DEFAULT NULL,
  `tumour_grade_category` varchar(100) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_spr_generic_cancer_types_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Constraints for table `spr_generic_cancer_types`
--
ALTER TABLE `spr_generic_cancer_types`
  ADD CONSTRAINT `FK_spr_generic_cancer_types_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);


  
-- --------------------------------------------------------

--
-- Table structure for table `spr_colon_cancer_types`
--

CREATE TABLE IF NOT EXISTS `spr_colon_cancer_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `specimen_review_master_id` int(11) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `other_type` varchar(250) DEFAULT NULL,
  `tumour_grade_category` varchar(100) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_spr_colon_cancer_types_specimen_review_masters` (`specimen_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Constraints for table `spr_colon_cancer_types`
--
ALTER TABLE `spr_colon_cancer_types`
  ADD CONSTRAINT `FK_spr_colon_cancer_types_specimen_review_masters` FOREIGN KEY (`specimen_review_master_id`) REFERENCES `specimen_review_masters` (`id`);
  
  

--  AR Aliquot Review Section --------------------------------------------------------

--
-- Table structure for table `ar_ovarian_tissue_slides`
--

CREATE TABLE IF NOT EXISTS `ar_ovarian_tissue_slides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_review_master_id` int(11) DEFAULT NULL,
  `type` varchar(100) NOT NULL,
  `invasive_percentage` decimal(5,1) DEFAULT NULL,
  `normal_percentage` decimal(5,1) DEFAULT NULL,
  `stroma_percentage` decimal(5,1) DEFAULT NULL,
  `necrosis_percentage` decimal(5,1) DEFAULT NULL,
  `inflammation` int(4) DEFAULT NULL,
  `quality_score` int(4) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ar_ovarian_tissue_slides_aliquot_review_masters` (`aliquot_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


ALTER TABLE `ar_ovarian_tissue_slides`
  ADD CONSTRAINT `FK_ar_ovarian_tissue_slides_aliquot_review_masters` FOREIGN KEY (`aliquot_review_master_id`) REFERENCES `aliquot_review_masters` (`id`);

  

--
-- Table structure for table `ar_generic_tissue_slides`
--

CREATE TABLE IF NOT EXISTS `ar_generic_tissue_slides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_review_master_id` int(11) DEFAULT NULL,
  `type` varchar(100) NOT NULL,
  `invasive_percentage` decimal(5,1) DEFAULT NULL,
  `in_situ_percentage` decimal(5,1) DEFAULT NULL,
  `normal_percentage` decimal(5,1) DEFAULT NULL,
  `stroma_percentage` decimal(5,1) DEFAULT NULL,
  `necrosis_percentage` decimal(5,1) DEFAULT NULL,
  `inflammation` int(4) DEFAULT NULL,
  `quality_score` int(4) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ar_generic_tissue_slides_aliquot_review_masters` (`aliquot_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


ALTER TABLE `ar_generic_tissue_slides`
  ADD CONSTRAINT `FK_ar_generic_tissue_slides_aliquot_review_masters` FOREIGN KEY (`aliquot_review_master_id`) REFERENCES `aliquot_review_masters` (`id`);  
  

--
-- Table structure for table `ar_colon_tissue_slides`
--

CREATE TABLE IF NOT EXISTS `ar_colon_tissue_slides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aliquot_review_master_id` int(11) DEFAULT NULL,
  `type` varchar(100) NOT NULL,
  `invasive_percentage` decimal(5,1) DEFAULT NULL,
  `in_situ_percentage` decimal(5,1) DEFAULT NULL,
  `normal_percentage` decimal(5,1) DEFAULT NULL,
  `stroma_percentage` decimal(5,1) DEFAULT NULL,
  `necrosis_percentage` decimal(5,1) DEFAULT NULL,
  `inflammation` int(4) DEFAULT NULL,
  `quality_score` int(4) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(10) unsigned NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(10) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ar_colon_tissue_slides_aliquot_review_masters` (`aliquot_review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


ALTER TABLE `ar_colon_tissue_slides`
  ADD CONSTRAINT `FK_ar_colon_tissue_slides_aliquot_review_masters` FOREIGN KEY (`aliquot_review_master_id`) REFERENCES `aliquot_review_masters` (`id`);   
  

  