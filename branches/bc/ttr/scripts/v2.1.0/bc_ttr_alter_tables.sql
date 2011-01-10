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
  ADD COLUMN `bc_ttr_date_referral_withdrawn` date DEFAULT NULL;
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
  ADD COLUMN `bc_ttr_date_referral_withdrawn` date DEFAULT NULL;  
  
  
  
DROP TABLE IF EXISTS `bc_ttr_correspondences`;
CREATE TABLE IF NOT EXISTS `bc_ttr_correspondences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `participant_id` int(11) NOT NULL DEFAULT '0',
  `bc_ttr_correspondence_datetime` datetime DEFAULT NULL,
  `bc_ttr_nurse` varchar(50) DEFAULT NULL,
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
DROP TABLE IF EXISTS `bc_ttr_correspondences`;
CREATE TABLE IF NOT EXISTS `bc_ttr_correspondences_revs` (
  `id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL DEFAULT '0',
  `bc_ttr_correspondence_datetime` datetime DEFAULT NULL,
  `bc_ttr_nurse` varchar(50) DEFAULT NULL,
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


/*ALTER TABLE `collections`
  ADD COLUMN `bc_ttr_collected_by` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_collected_datetime` datetime DEFAULT NULL, 
  ADD COLUMN `bc_ttr_collection_type` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_tb_received_by` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_tb_received_datetime` datetime DEFAULT NULL,
  ADD COLUMN `bc_ttr_tissue_collection_status` varchar(20) DEFAULT NULL;
ALTER TABLE `collections_revs`
  ADD COLUMN `bc_ttr_collected_by` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_collected_datetime` datetime DEFAULT NULL, 
  ADD COLUMN `bc_ttr_collection_type` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_tb_received_by` varchar(20) DEFAULT NULL,
  ADD COLUMN `bc_ttr_tb_received_datetime` datetime DEFAULT NULL,
  ADD COLUMN `bc_ttr_tissue_collection_status` varchar(20) DEFAULT NULL;
*/  
