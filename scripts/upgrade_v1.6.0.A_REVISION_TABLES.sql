﻿
-- Create Revisions tables

CREATE TABLE `ad_blocks_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `type` varchar(30) default NULL,
  `patho_dpt_block_code` varchar(30) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ad_cell_cores_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `ad_gel_matrix_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `ad_gel_matrix_id` (`ad_gel_matrix_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ad_cell_tubes_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `lot_number` varchar(30) default NULL,
  `concentration` decimal(10,2) default NULL,
  `concentration_unit` varchar(20) default NULL,
  `cell_count` decimal(10,2) default NULL,
  `cell_count_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime NOT NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ad_cell_slides_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `immunochemistry` varchar(30) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ad_gel_matrices_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `cell_count` decimal(10,2) default NULL,
  `cell_count_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ad_tissue_cores_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `ad_block_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `ad_block_id` (`ad_block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ad_tissue_slides_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `immunochemistry` varchar(30) default NULL,
  `ad_block_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `ad_block_id` (`ad_block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ad_tubes_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `concentration` decimal(10,2) default NULL,
  `concentration_unit` varchar(20) default NULL,
  `lot_number` varchar(30) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ad_whatman_papers_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `used_blood_volume` decimal(10,5) default NULL,
  `used_blood_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `aliquot_masters_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL,
  `barcode` varchar(60) NOT NULL default '',
  `aliquot_type` varchar(30) NOT NULL default '',
  `aliquot_control_id` int(11) NOT NULL default '0',
  `collection_id` int(11) NOT NULL default '0',
  `sample_master_id` int(11) NOT NULL default '0',
  `sop_master_id` int(11) default NULL,
  `initial_volume` decimal(10,5) default NULL,
  `current_volume` decimal(10,5) default NULL,
  `aliquot_volume_unit` varchar(20) default NULL,
  `status` varchar(30) default NULL,
  `status_reason` varchar(30) default NULL,
  `study_summary_id` int(11) default NULL,
  `storage_datetime` datetime default NULL,
  `storage_master_id` int(11) default NULL,
  `storage_coord_x` varchar(11) default NULL,
  `storage_coord_y` varchar(11) default NULL,
  `product_code` varchar(20) default NULL,
  `notes` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_control_id` (`aliquot_control_id`),
  KEY `collection_id` (`collection_id`),
  KEY `sample_master_id` (`sample_master_id`),
  KEY `sop_master_id` (`sop_master_id`),
  KEY `study_summary_id` (`study_summary_id`),
  KEY `aliquot_masters_ibfk_6` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `aliquot_uses_revs` (
  `id` int(11) NOT NULL,
  `aliquot_master_id` int(11) NOT NULL default '0',
  `use_definition` varchar(30) default NULL,
  `use_details` varchar(250) default NULL,
  `use_recorded_into_table` varchar(40) default NULL,
  `used_volume` decimal(10,5) default NULL,
  `use_datetime` datetime default NULL,
  `study_summary_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `study_summary_id` (`study_summary_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `banks_revs` (
  `version_id` int(11) NOT NULL auto_increment,
  `version_created` datetime NOT NULL,
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `created_by` int(11) NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

CREATE TABLE `clinical_collection_links_revs` (
  `id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL default '0',
  `collection_id` int(11) NOT NULL default '0',
  `diagnosis_id` int(11) NOT NULL default '0',
  `consent_id` int(11) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

CREATE TABLE `coding_adverse_events_revs` (
  `id` int(11) NOT NULL,
  `category` varchar(50) NOT NULL default '',
  `supra-ordinate_term` varchar(255) NOT NULL default '',
  `select_ae` varchar(255) default NULL,
  `grade` int(11) NOT NULL default '0',
  `description` text NOT NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `coding_icd10_revs` (
  `id` varchar(10) NOT NULL default '',
  `category` varchar(50) NOT NULL default '',
  `group` varchar(50) NOT NULL default '',
  `site` varchar(50) NOT NULL default '',
  `subsite` varchar(50) NOT NULL default '',
  `description` varchar(250) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `collections_revs` (
  `id` int(11) NOT NULL,
  `acquisition_label` varchar(50) NOT NULL default '',
  `bank_id` int(11) default NULL,
  `collection_site` varchar(30) default NULL,
  `collection_datetime` datetime default NULL,
  `reception_by` varchar(50) default NULL,
  `reception_datetime` datetime default NULL,
  `sop_master_id` int(11) default NULL,
  `collection_property` varchar(50) default NULL,
  `collection_notes` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sop_master_id` (`sop_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

CREATE TABLE `consents_revs` (
  `id` int(11) NOT NULL,
  `date` date default NULL,
  `form_version` varchar(50) default NULL,
  `reason_denied` varchar(200) default NULL,
  `consent_status` varchar(50) default NULL,
  `status_date` date default NULL,
  `surgeon` varchar(50) default NULL,
  `contact_method` varchar(50) default NULL,
  `operation_date` datetime default NULL,
  `facility` varchar(50) default NULL,
  `memo` text,
  `biological_material_use` varchar(50) default NULL,
  `use_of_tissue` varchar(50) default NULL,
  `contact_future_research` varchar(50) default NULL,
  `access_medical_information` varchar(50) default NULL,
  `use_of_blood` varchar(50) default NULL,
  `use_of_urine` varchar(50) default NULL,
  `research_other_disease` varchar(50) default NULL,
  `inform_significant_discovery` varchar(50) default NULL,
  `facility_other` varchar(50) default NULL,
  `recruit_route` varchar(10) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `consent_id` varchar(10) NOT NULL default '',
  `acquisition_id` varchar(10) NOT NULL default '',
  `participant_id` int(11) default NULL,
  `diagnosis_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `diagnosis_id` (`diagnosis_id`),
  KEY `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `diagnoses_revs` (
  `id` int(11) NOT NULL,
  `dx_number` varchar(50) default NULL,
  `dx_method` varchar(20) default NULL,
  `dx_nature` varchar(20) default NULL,
  `dx_origin` varchar(50) default NULL,
  `dx_date` date default NULL,
  `icd10_id` varchar(10) default NULL,
  `morphology` varchar(50) default NULL,
  `laterality` varchar(50) default NULL,
  `information_source` varchar(30) default NULL,
  `age_at_dx` int(11) default NULL,
  `age_at_dx_status` varchar(100) default NULL,
  `case_number` int(11) default NULL,
  `clinical_stage` varchar(50) default NULL,
  `collaborative_stage` varchar(50) default NULL,
  `tstage` varchar(5) default NULL,
  `nstage` varchar(5) default NULL,
  `mstage` varchar(5) default NULL,
  `stage_grouping` varchar(5) default NULL,
  `clinical_tstage` varchar(5) default NULL,
  `clinical_nstage` varchar(5) default NULL,
  `clinical_mstage` varchar(5) default NULL,
  `clinical_stage_grouping` varchar(5) default NULL,
  `path_tstage` varchar(5) default NULL,
  `path_nstage` varchar(5) default NULL,
  `path_mstage` varchar(5) default NULL,
  `path_stage_grouping` varchar(5) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `participant_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `drugs_revs` (
  `id` int(11) NOT NULL,
  `generic_name` varchar(50) NOT NULL default '',
  `trade_name` varchar(50) NOT NULL default '',
  `type` varchar(50) default NULL,
  `description` varchar(255) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime NOT NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

CREATE TABLE `ed_allsolid_lab_pathology_revs` (
  `id` int(11) NOT NULL,
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
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_adverse_events_adverse_event_revs` (
  `id` int(11) NOT NULL,
  `supra_ordinate_term` varchar(50) default NULL,
  `select_ae` varchar(50) default NULL,
  `grade` varchar(50) default NULL,
  `description` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_clinical_followup_revs` (
  `id` int(11) NOT NULL,
  `weight` int(11) default NULL,
  `recurrence_status` varchar(50) default NULL,
  `disease_status` varchar(50) default NULL,
  `vital_status` varchar(50) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_clinical_presentation_revs` (
  `id` int(11) NOT NULL,
  `weight` int(11) default NULL,
  `height` int(11) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `event_master_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_lifestyle_base_revs` (
  `id` int(11) NOT NULL,
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
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_protocol_followup_revs` (
  `id` int(11) NOT NULL,
  `title` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_all_study_research_revs` (
  `id` int(11) NOT NULL,
  `field_one` varchar(50) default NULL,
  `field_two` varchar(50) default NULL,
  `field_three` varchar(50) default NULL,
  `event_master_id` int(11) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_breast_lab_pathology_revs` (
  `id` int(11) NOT NULL,
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
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `ed_breast_screening_mammogram_revs` (
  `id` int(11) NOT NULL,
  `result` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `event_master_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `event_masters_revs` (
  `id` int(11) NOT NULL,
  `event_control_id` int(11) NOT NULL default 0,
  `disease_site` varchar(255) NOT NULL default '',
  `event_group` varchar(50) NOT NULL default '',
  `event_type` varchar(50) NOT NULL default '',
  `event_status` varchar(50) default NULL,
  `event_summary` text,
  `event_date` date default NULL,
  `information_source` varchar(255) default NULL,
  `urgency` varchar(50) default NULL,
  `date_required` date default NULL,
  `date_requested` date default NULL,
  `reference_number` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `form_alias` varchar(255) NOT NULL default '',
  `detail_tablename` varchar(50) NOT NULL default '',
  `participant_id` int(11) NOT NULL default '0',
  `diagnosis_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `participant_id` (`participant_id`),
  KEY `diagnosis_id` (`diagnosis_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `family_histories_revs` (
  `id` int(11) NOT NULL,
  `relation` varchar(20) default NULL,
  `domain` varchar(20) default NULL,
  `icd10_id` varchar(5) default NULL,
  `dx_date` date default NULL,
  `dx_date_status` char(1) default NULL,
  `age_at_dx` smallint(6) default NULL,
  `age_at_dx_status` varchar(100) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `participant_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `materials_revs` (
  `id` int(11) NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `item_type` varchar(50) default NULL,
  `description` varchar(255) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=220 ;

CREATE TABLE `misc_identifiers_revs` (
  `id` int(11) NOT NULL,
  `identifier_value` varchar(40) default NULL,
  `name` varchar(50) default NULL,
  `identifier_abrv` varchar(20) default NULL,
  `effective_date` date default NULL,
  `expiry_date` date default NULL,
  `memo` varchar(100) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `participant_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted`  int(11) default NULL,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `orders_revs` (
  `id` int(11) NOT NULL,
  `order_number` varchar(255) NOT NULL,
  `short_title` varchar(45) default NULL,
  `description` varchar(255) default NULL,
  `date_order_placed` date default NULL,
  `date_order_completed` date default NULL,
  `processing_status` varchar(45) default NULL,
  `comments` varchar(255) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(45) default NULL,
  `study_summary_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `order_items_revs` (
  `id` int(11) NOT NULL,
  `barcode` varchar(255) default NULL,
  `base_price` varchar(255) default NULL,
  `date_added` date default NULL,
  `added_by` varchar(255) default NULL,
  `datetime_scanned_out` datetime default NULL,
  `status` varchar(255) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `orderline_id` int(11) default NULL,
  `shipment_id` int(11) default NULL,
  `aliquot_master_id` int(11) default NULL,
  `aliquot_use_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `order_lines_revs` (
  `id` int(11) NOT NULL,
  `cancer_type` varchar(255) default NULL,
  `quantity_ordered` int(255) default NULL,
  `quantity_UM` varchar(255) default NULL,
  `min_qty_ordered` int(11) default NULL,
  `min_qty_UM` varchar(50) default NULL,
  `base_price` varchar(255) default NULL,
  `date_required` date default NULL,
  `quantity_shipped` int(11) default NULL,
  `status` varchar(255) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `discount_id` int(11) default NULL,
  `product_id` int(11) default NULL,
  `sample_control_id` int(11) default NULL,
  `order_id` int(11) NOT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `participants_revs` (
  `id` int(11) NOT NULL,
  `title` varchar(10) NOT NULL default '',
  `first_name` varchar(20) default NULL,
  `last_name` varchar(20) default NULL,
  `middle_name` varchar(50) default NULL,
  `date_of_birth` date default NULL,
  `date_status` char(1) default NULL,
  `marital_status` varchar(50) default NULL,
  `language_preferred` varchar(30) default NULL,
  `sex` char(1) default NULL,
  `race` varchar(30) default NULL,
  `ethnicity` varchar(30) default NULL,
  `vital_status` varchar(50) default NULL,
  `memo` varchar(200) default NULL,
  `status` varchar(10) default NULL,
  `date_of_death` date default NULL,
  `death_certificate_ident` varchar(20) NOT NULL default '',
  `icd10_id` varchar(50) NOT NULL default '',
  `confirmation_source` varchar(50) NOT NULL default '',
  `tb_number` varchar(50) default NULL,
  `last_chart_checked_date` date default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

CREATE TABLE `participant_contacts_revs` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL default '',
  `facility` varchar(50) default NULL,
  `contact_type` varchar(50) NOT NULL default '',
  `other_contact_type` varchar(100) default NULL,
  `effective_date` date default NULL,
  `expiry_date` date default NULL,
  `memo` text,
  `street` varchar(50) default NULL,
  `city` varchar(50) NOT NULL default '',
  `region` varchar(50) NOT NULL default '',
  `country` varchar(50) NOT NULL default '',
  `mail_code` varchar(10) NOT NULL default '',
  `phone` varchar(15) NOT NULL default '',
  `phone_type` varchar(15) NOT NULL default '',
  `phone_secondary` varchar(15) NOT NULL default '',
  `phone_secondary_type` varchar(15) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `participant_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `participant_messages_revs` (
  `id` int(11) NOT NULL,
  `date_requested` date default NULL,
  `author` varchar(50) default NULL,
  `type` varchar(20) default NULL,
  `title` varchar(50) default NULL,
  `description` text,
  `due_date` datetime default NULL,
  `expiry_date` date default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `participant_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `path_collection_reviews_revs` (
  `id` int(11) NOT NULL,
  `path_coll_rev_code` varchar(20) NOT NULL default '0',
  `collection_id` int(11) NOT NULL default '0',
  `sample_master_id` int(11) NOT NULL default '0',
  `aliquot_master_id` int(11) NOT NULL default '0',
  `review_date` date NOT NULL default '0000-00-00',
  `review_status` varchar(20) default NULL,
  `pathologist` varchar(30) default '0',
  `tumour_type` varchar(50) default '0',
  `comments` text,
  `tumour_gradecategory` varchar(10) default NULL,
  `tumour_grade_based_on_sample_master_id` int(11) default '0',
  `tumour_grade_score_tubules` decimal(5,1) default NULL,
  `tumour_grade_score_nuclei` decimal(5,1) default NULL,
  `tumour_grade_score_nuclear` decimal(5,1) default NULL,
  `tumour_grade_score_mitosis` decimal(5,1) default NULL,
  `tumour_grade_score_architecture` decimal(5,1) default NULL,
  `tumour_grade_score_total` decimal(5,1) default '0.0',
  `created` datetime default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `collection_id` (`collection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `pd_chemos_revs` (
  `id` int(11) NOT NULL,
  `num_cycles` int(11) default NULL,
  `length_cycles` int(11) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `protocol_master_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `pe_chemos_revs` (
  `id` int(11) NOT NULL,
  `method` varchar(50) default NULL,
  `dose` varchar(50) default NULL,
  `frequency` varchar(50) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `protocol_master_id` int(11) default NULL,
  `drug_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `protocol_masters_revs` (
  `id` int(11) NOT NULL,
  `protocol_control_id` int(11) NOT NULL default 0,
  `name` varchar(255) default NULL,
  `notes` text,
  `code` varchar(50) default NULL,
  `arm` varchar(50) default NULL,
  `tumour_group` varchar(50) default NULL,
  `type` varchar(50) NOT NULL default '',
  `status` varchar(50) default NULL,
  `expiry` date default NULL,
  `activated` date default NULL,
  `detail_tablename` varchar(255) NOT NULL default '',
  `detail_form_alias` varchar(255) NOT NULL default '',
  `extend_tablename` varchar(255) NOT NULL default '',
  `extend_form_alias` varchar(255) NOT NULL default '',
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `form_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `qc_tested_aliquots_revs` (
  `id` int(11) NOT NULL,
  `quality_control_id` int(11) NOT NULL default '0',
  `aliquot_master_id` int(11) NOT NULL default '0',
  `aliquot_use_id` int(11) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `quality_control_id` (`quality_control_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `aliquot_use_id` (`aliquot_use_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `quality_controls_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `type` varchar(30) default NULL,
  `tool` varchar(30) default NULL,
  `run_id` varchar(30) default NULL,
  `date` date default NULL,
  `score` varchar(30) default NULL,
  `unit` varchar(30) default NULL,
  `conclusion` varchar(30) default NULL,
  `notes` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_bloodcellcounts_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) NOT NULL default '0',
  `count_start_time` time default NULL,
  `wbc_tl_square` int(5) default NULL,
  `wbc_tr_square` int(5) default NULL,
  `wbc_bl_square` int(5) default NULL,
  `wbc_br_square` int(5) default NULL,
  `rbc_tl_square` int(5) default NULL,
  `rbc_tr_square` int(5) default NULL,
  `rbc_bl_square` int(5) default NULL,
  `rbc_br_square` int(5) default NULL,
  `rbc_mid_square` int(5) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_blood_cells_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) NOT NULL default '0',
  `mmt` varchar(10) default '',
  `fish` decimal(6,2) default NULL,
  `zap70` decimal(6,2) default NULL,
  `nq01` varchar(10) default NULL,
  `cd38` decimal(6,2) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_breastcancertypes_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) NOT NULL default '0',
  `invasive_percentage` decimal(5,1) default NULL,
  `in_situ_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_inv_percentage` decimal(5,1) default NULL,
  `necrosis_is_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_breast_cancers_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) NOT NULL default '0',
  `tumour_type_id` int(11) NOT NULL default '0',
  `invasive_percentage` decimal(5,1) NOT NULL default '0.0',
  `in_situ_percentage` decimal(5,1) NOT NULL default '0.0',
  `normal_percentage` decimal(5,1) NOT NULL default '0.0',
  `stroma_percentage` decimal(5,1) NOT NULL default '0.0',
  `necrosis_inv_percentage` decimal(5,1) NOT NULL default '0.0',
  `necrosis_is_percentage` decimal(5,1) NOT NULL default '0.0',
  `fat_percentage` decimal(5,1) NOT NULL default '0.0',
  `inflammation` tinyint(4) NOT NULL default '0',
  `quality_score` tinyint(4) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_coloncancertypes_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) NOT NULL default '0',
  `invasive_percentage` decimal(5,1) default NULL,
  `in_situ_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_genericcancertypes_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) NOT NULL default '0',
  `invasive_percentage` decimal(5,1) default NULL,
  `in_situ_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rd_ovarianuteruscancertypes_revs` (
  `id` int(11) NOT NULL,
  `review_master_id` int(11) NOT NULL default '0',
  `invasive_percentage` decimal(5,1) default NULL,
  `normal_percentage` decimal(5,1) default NULL,
  `stroma_percentage` decimal(5,1) default NULL,
  `necrosis_percentage` decimal(5,1) default NULL,
  `inflammation` tinyint(4) default NULL,
  `quality_score` tinyint(4) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `review_master_id` (`review_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `realiquotings_revs` (
  `id` int(11) NOT NULL,
  `parent_aliquot_master_id` int(11) NOT NULL default '0',
  `child_aliquot_master_id` int(11) NOT NULL default '0',
  `aliquot_use_id` int(11) NOT NULL default '0',
  `realiquoted_by` varchar(20) default NULL,
  `realiquoted_datetime` datetime default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_date` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `parent_aliquot_master_id` (`parent_aliquot_master_id`),
  KEY `child_aliquot_master_id` (`child_aliquot_master_id`),
  KEY `aliquot_use_id` (`aliquot_use_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `reproductive_histories_revs` (
  `id` int(11) NOT NULL,
  `date_captured` date default NULL,
  `menopause_status` varchar(20) default NULL,
  `age_at_menopause` int(11) default NULL,
  `menopause_age_certainty` varchar(50) default NULL,
  `hrt_years_on` int(11) default NULL,
  `hrt_use` varchar(50) default NULL,
  `hysterectomy_age` int(11) default NULL,
  `hysterectomy_age_certainty` varchar(50) default NULL,
  `hysterectomy` varchar(50) default NULL,
  `first_ovary_out_age` int(11) default NULL,
  `first_ovary_certainty` varchar(50) default NULL,
  `second_ovary_out_age` int(11) default NULL,
  `second_ovary_certainty` varchar(50) default NULL,
  `first_ovary_out` varchar(50) default NULL,
  `second_ovary_out` varchar(50) default NULL,
  `gravida` int(11) default NULL,
  `para` int(11) default NULL,
  `age_at_first_parturition` int(11) default NULL,
  `first_parturition_certainty` varchar(50) default NULL,
  `age_at_last_parturition` int(11) default NULL,
  `last_parturition_certainty` varchar(50) default NULL,
  `age_at_menarche` int(11) default NULL,
  `age_at_menarche_certainty` varchar(50) default NULL,
  `oralcontraceptive_use` varchar(50) default NULL,
  `years_on_oralcontraceptives` int(11) default NULL,
  `lnmp_date` date default NULL,
  `lnmp_certainty` varchar(50) default NULL,
  `created` date NOT NULL default '0000-00-00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` date NOT NULL default '0000-00-00',
  `modified_by` varchar(50) NOT NULL default '',
  `participant_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `review_masters_revs` (
  `id` int(11) NOT NULL,
  `review_control_id` int(11) NOT NULL default '0',
  `collection_id` int(11) NOT NULL default '0',
  `sample_master_id` int(11) NOT NULL default '0',
  `review_type` varchar(30) NOT NULL default '',
  `review_sample_group` varchar(30) NOT NULL default '',
  `review_date` date NOT NULL default '0000-00-00',
  `review_status` varchar(20) NOT NULL default '',
  `pathologist` varchar(50) default '',
  `comments` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  UNIQUE KEY `version_id` (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `rtbforms_revs` (
  `id` smallint(5) unsigned NOT NULL,
  `frmTitle` varchar(200) default NULL,
  `frmVersion` float NOT NULL default '0',
  `frmCategory` varchar(30) default NULL,
  `frmFileLocation` blob,
  `frmFileType` varchar(40) default NULL,
  `frmFileViewer` blob,
  `frmStatus` varchar(30) default NULL,
  `frmCreated` date default NULL,
  `frmGroup` varchar(50) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sample_masters_revs` (
  `id` int(11) NOT NULL,
  `sample_code` varchar(30) NOT NULL default '',
  `sample_category` varchar(30) NOT NULL default '',
  `sample_control_id` int(11) NOT NULL default '0',
  `sample_type` varchar(30) NOT NULL default '',
  `initial_specimen_sample_id` int(11) default NULL,
  `initial_specimen_sample_type` varchar(30) NOT NULL default '',
  `collection_id` int(11) NOT NULL default '0',
  `parent_id` int(11) default NULL,
  `sop_master_id` int(11) default NULL,
  `product_code` varchar(20) default NULL,
  `is_problematic` varchar(6) default NULL,
  `notes` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_control_id` (`sample_control_id`),
  KEY `initial_specimen_sample_id` (`initial_specimen_sample_id`),
  KEY `parent_id` (`parent_id`),
  KEY `collection_id` (`collection_id`),
  KEY `sop_master_id` (`sop_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_der_cell_cultures_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `culture_status` varchar(30) default NULL,
  `culture_status_reason` varchar(30) default NULL,
  `cell_passage_number` int(6) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_der_plasmas_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `hemolyze_signs` varchar(10) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_date` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_der_serums_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `hemolyze_signs` varchar(10) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_ascites_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_bloods_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `type` varchar(30) default NULL,
  `collected_tube_nbr` int(4) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_cystic_fluids_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_other_fluids_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_peritoneal_washes_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_tissues_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `tissue_source` varchar(20) default NULL,
  `nature` varchar(15) default NULL,
  `laterality` varchar(10) default NULL,
  `pathology_reception_datetime` datetime default NULL,
  `size` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sd_spe_urines_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `aspect` varchar(30) default NULL,
  `collected_volume` decimal(10,5) default NULL,
  `collected_volume_unit` varchar(20) default NULL,
  `received_volume` decimal(10,5) default NULL,
  `received_volume_unit` varchar(20) default NULL,
  `pellet` varchar(10) default NULL,
  `pellet_volume` decimal(10,5) default NULL,
  `pellet_volume_unit` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `shelves_revs` (
  `id` int(11) NOT NULL,
  `storage_id` int(11) NOT NULL default '0',
  `description` varchar(50) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_id` (`storage_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `shipments_revs` (
  `id` int(11) NOT NULL,
  `shipment_code` varchar(255) NOT NULL default 'No Code',
  `recipient` varchar(60) default NULL,
  `facility` varchar(60) default NULL,
  `delivery_street_address` varchar(255) default NULL,
  `delivery_city` varchar(255) default NULL,
  `delivery_province` varchar(255) default NULL,
  `delivery_postal_code` varchar(255) default NULL,
  `delivery_country` varchar(255) default NULL,
  `shipping_company` varchar(255) default NULL,
  `shipping_account_nbr` varchar(255) default NULL,
  `datetime_shipped` datetime default NULL,
  `datetime_received` datetime default NULL,
  `shipped_by` varchar(255) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(45) default NULL,
  `order_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `sopd_general_all_revs` (
  `id` int(11) NOT NULL,
  `value` varchar(255) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `sop_master_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=37 ;

CREATE TABLE `sope_general_all_revs` (
  `id` int(11) NOT NULL,
  `site_specific` varchar(50) default NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `sop_master_id` int(11) default NULL,
  `material_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=220 ;

CREATE TABLE `sop_masters_revs` (
  `id` int(11) NOT NULL,
  `sop_control_id` int(11) NOT NULL default 0,
  `title` varchar(255) default NULL,
  `notes` text,
  `code` varchar(50) default NULL,
  `version` varchar(50) default NULL,
  `sop_group` varchar(50) default NULL,
  `type` varchar(50) NOT NULL,
  `status` varchar(50) default NULL,
  `expiry_date` date default NULL,
  `activated_date` date default NULL,
  `scope` text,
  `purpose` text,
  `detail_tablename` varchar(255) NOT NULL,
  `detail_form_alias` varchar(255) NOT NULL,
  `extend_tablename` varchar(255) NOT NULL,
  `extend_form_alias` varchar(255) NOT NULL,
  `created` datetime default NULL,
  `created_by` varchar(50) default NULL,
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `form_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=37 ;

CREATE TABLE `source_aliquots_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `aliquot_master_id` int(11) NOT NULL default '0',
  `aliquot_use_id` int(11) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `aliquot_master_id` (`aliquot_master_id`),
  KEY `aliquot_use_id` (`aliquot_use_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `specimen_details_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) NOT NULL default '0',
  `supplier_dept` varchar(40) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `sample_master_id` (`sample_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_incubators_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) NOT NULL default '0',
  `oxygen_perc` varchar(10) default NULL,
  `carbonic_gaz_perc` varchar(10) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_rooms_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) NOT NULL default '0',
  `laboratory` varchar(50) default NULL,
  `floor` varchar(20) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `std_tma_blocks_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) NOT NULL default '0',
  `sop_master_id` int(11) default NULL,
  `product_code` varchar(20) default NULL,
  `creation_datetime` datetime default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`),
  KEY `sop_master_id` (`sop_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `storage_coordinates_revs` (
  `id` int(11) NOT NULL,
  `storage_master_id` int(11) NOT NULL default '0',
  `dimension` varchar(4) default '',
  `coordinate_value` varchar(30) default '',
  `order` int(4) default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `storage_masters_revs` (
  `id` int(11) NOT NULL,     
  `code` varchar(30) NOT NULL default '',
  `storage_type` varchar(30) NOT NULL default '',
  `storage_control_id` int(11) NOT NULL default '0',
  `parent_id` int(11) default NULL,
  `barcode` varchar(30) default '',
  `short_label` varchar(10) default NULL,
  `selection_label` varchar(60) default '',
  `storage_status` varchar(20) default '',
  `parent_storage_coord_x` varchar(11) default NULL,
  `parent_storage_coord_y` varchar(11) default NULL,
  `set_temperature` varchar(7) default NULL,
  `temperature` decimal(5,2) default NULL,
  `temp_unit` varchar(20) default NULL,
  `notes` text,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_control_id` (`storage_control_id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

CREATE TABLE `study_contacts_revs` (
  `id` int(11) NOT NULL,
  `sort` int(11) default NULL,
  `prefix` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `accreditation` varchar(255) default NULL,
  `occupation` varchar(255) default NULL,
  `department` varchar(255) default NULL,
  `organization` varchar(255) default NULL,
  `organization_type` varchar(255) default NULL,
  `address_street` varchar(255) default NULL,
  `address_city` varchar(255) default NULL,
  `address_province` varchar(255) default NULL,
  `address_country` varchar(255) default NULL,
  `address_postal` varchar(255) default NULL,
  `phone_country` int(11) default NULL,
  `phone_area` int(11) default NULL,
  `phone_number` int(11) default NULL,
  `phone_extension` int(11) default NULL,
  `phone2_country` int(11) default NULL,
  `phone2_area` int(11) default NULL,
  `phone2_number` int(11) default NULL,
  `phone2_extension` int(11) default NULL,
  `fax_country` int(11) default NULL,
  `fax_area` int(11) default NULL,
  `fax_number` int(11) default NULL,
  `fax_extension` int(11) default NULL,
  `email` varchar(255) default NULL,
  `website` varchar(255) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_ethics_boards_revs` (
  `id` int(11) NOT NULL,
  `ethics_board` varchar(255) default NULL,
  `restrictions` text,
  `contact` varchar(255) default NULL,
  `date` date default NULL,
  `phone_country` varchar(255) default NULL,
  `phone_area` varchar(255) default NULL,
  `phone_number` varchar(255) default NULL,
  `phone_extension` varchar(255) default NULL,
  `fax_country` varchar(255) default NULL,
  `fax_area` varchar(255) default NULL,
  `fax_number` varchar(255) default NULL,
  `fax_extension` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `status` varchar(255) default NULL,
  `approval_number` varchar(255) default NULL,
  `accrediation` varchar(255) default NULL,
  `ohrp_registration_number` varchar(255) default NULL,
  `ohrp_fwa_number` varchar(255) default NULL,
  `path_to_file` varchar(255) default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_fundings_revs` (
  `id` int(11) NOT NULL,
  `study_sponsor` varchar(255) default NULL,
  `restrictions` text,
  `year_1` int(11) default NULL,
  `amount_year_1` decimal(10,2) default NULL,
  `year_2` int(11) default NULL,
  `amount_year_2` decimal(10,2) default NULL,
  `year_3` int(11) default NULL,
  `amount_year_3` decimal(10,2) default NULL,
  `year_4` int(11) default NULL,
  `amount_year_4` decimal(10,2) default NULL,
  `year_5` int(11) default NULL,
  `amount_year_5` decimal(10,2) default NULL,
  `contact` varchar(255) default NULL,
  `phone_country` varchar(255) default NULL,
  `phone_area` varchar(255) default NULL,
  `phone_number` varchar(255) default NULL,
  `phone_extension` varchar(255) default NULL,
  `fax_country` varchar(255) default NULL,
  `fax_area` varchar(255) default NULL,
  `fax_number` varchar(255) default NULL,
  `fax_extension` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `status` varchar(255) default NULL,
  `date` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `rtbform_id` int(11) default NULL,
  `study_summary_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_investigators_revs` (
  `id` int(11) NOT NULL,
  `first_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `accrediation` varchar(255) default NULL,
  `occupation` varchar(255) default NULL,
  `department` varchar(255) default NULL,
  `organization` varchar(255) default NULL,
  `address_street` varchar(255) default NULL,
  `address_city` varchar(255) default NULL,
  `address_province` varchar(255) default NULL,
  `address_country` varchar(255) default NULL,
  `email` varchar(45) default NULL,
  `sort` int(11) default NULL,
  `role` varchar(255) default NULL,
  `brief` text,
  `participation_start_date` date default NULL,
  `participation_end_date` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `path_to_file` text,
  `study_summary_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_related_revs` (
  `id` int(11) NOT NULL,
  `title` varchar(255) default NULL,
  `principal_investigator` varchar(255) default NULL,
  `journal` varchar(255) default NULL,
  `issue` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `abstract` text,
  `relevance` text,
  `date_posted` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) NOT NULL default '0',
  `path_to_file` varchar(255) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_results_revs` (
  `id` int(11) NOT NULL,
  `abstract` text,
  `hypothesis` text,
  `conclusion` text,
  `comparison` text,
  `future` text,
  `result_date` datetime default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `rtbform_id` int(11) default NULL,
  `study_summary_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_reviews_revs` (
  `id` int(11) NOT NULL,
  `prefix` int(11) default NULL,
  `first_name` varchar(255) default NULL,
  `middle_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `accreditation` varchar(255) default NULL,
  `committee` varchar(255) default NULL,
  `institution` varchar(255) default NULL,
  `phone_country` varchar(255) default NULL,
  `phone_area` varchar(255) default NULL,
  `phone_number` varchar(255) default NULL,
  `phone_extension` varchar(255) default NULL,
  `status` varchar(255) default NULL,
  `date` date default NULL,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `study_summary_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `study_summaries_revs` (
  `id` int(11) NOT NULL,
  `disease_site` varchar(50) default NULL,
  `study_type` varchar(50) default NULL,
  `study_science` varchar(50) default NULL,
  `study_use` varchar(50) default NULL,
  `title` varchar(45) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `summary` text,
  `abstract` text,
  `hypothesis` text,
  `approach` text,
  `analysis` text,
  `significance` text,
  `additional_clinical` text,
  `created` date default NULL,
  `created_by` varchar(50) default NULL,
  `modified` date default NULL,
  `modified_by` varchar(50) default NULL,
  `path_to_file` varchar(255) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

CREATE TABLE `tma_slides_revs` (
  `id` int(11) NOT NULL,
  `std_tma_block_id` int(11) default '0',
  `barcode` varchar(30) NOT NULL default '',
  `product_code` varchar(20) default NULL,
  `sop_master_id` int(11) default NULL,
  `immunochemistry` varchar(30) default NULL,
  `picture_path` varchar(200) default NULL,
  `storage_datetime` datetime default NULL,
  `storage_master_id` int(11) default NULL,
  `storage_coord_x` varchar(11) default NULL,
  `storage_coord_y` varchar(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `storage_master_id` (`storage_master_id`),
  KEY `sop_master_id` (`sop_master_id`),
  KEY `std_tma_block_id` (`std_tma_block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `towers_revs` (
  `id` int(11) NOT NULL,
  `storage_id` int(11) NOT NULL default '0',
  `shelf_id` int(11) NOT NULL default '0',
  `description` varchar(50) NOT NULL default '',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `shelf_id` (`shelf_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txd_chemos_revs` (
  `id` int(11) NOT NULL,
  `completed` varchar(50) default NULL,
  `response` varchar(50) default NULL,
  `num_cycles` int(11) default NULL,
  `length_cycles` int(11) default NULL,
  `completed_cycles` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `tx_master_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

CREATE TABLE `txd_combos_revs` (
  `id` int(11) NOT NULL,
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
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txd_radiations_revs` (
  `id` int(11) NOT NULL,
  `source` varchar(50) default NULL,
  `mould` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `tx_master_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txd_surgeries_revs` (
  `id` int(11) NOT NULL,
  `path_num` varchar(50) default NULL,
  `primary` varchar(50) default NULL,
  `surgeon` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `tx_master_id` int(11) NOT NULL default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txe_chemos_revs` (
  `id` int(11) NOT NULL,
  `source` varchar(50) default NULL,
  `frequency` varchar(50) default NULL,
  `dose` varchar(50) default NULL,
  `method` varchar(50) default NULL,
  `reduction` varchar(50) default NULL,
  `cycle_number` int(11) default NULL,
  `completed_cycles` int(11) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  `tx_master_id` int(11) default NULL,
  `drug_id` varchar(50) default '0',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txe_radiations_revs` (
  `id` int(11) NOT NULL,
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
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `txe_surgeries_revs` (
  `id` int(11) NOT NULL,
  `surgical_procedure` varchar(50) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  `tx_master_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `tx_master_id` (`tx_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `tx_masters_revs` (
  `id` int(11) NOT NULL,
  `tx_control_id` int(11) NOT NULL default 0,
  `group` varchar(50) default NULL,
  `disease_site` varchar(50) default NULL,
  `tx_intent` varchar(50) default NULL,
  `start_date` date default NULL,
  `finish_date` date default NULL,
  `source` varchar(50) default NULL,
  `facility` varchar(50) default NULL,
  `summary` text,
  `detail_tablename` varchar(255) default NULL,
  `detail_form_alias` varchar(255) default NULL,
  `extend_tablename` varchar(255) default NULL,
  `extend_form_alias` varchar(255) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL default '',
  `protocol_id` int(11) default NULL,
  `participant_id` int(11) NOT NULL default '0',
  `diagnosis_id` int(11) default NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`version_id`),
  KEY `participant_id` (`participant_id`),
  KEY `diagnosis_id` (`diagnosis_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- Delete Unessecary Tables

DROP TABLE `install_disease_sites`;
DROP TABLE `install_locations`;
DROP TABLE `install_studies`;

-- Add ATiM infromation table

CREATE TABLE `atim_information` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `tablename` VARCHAR(255),
  `field` VARCHAR(255),
  `data_element_identifier` VARCHAR(225),
  `structure_field_id` INT(11) NOT NULL,
  `datatype` VARCHAR(255),
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) default NULL,
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(50) default NULL,
  PRIMARY KEY( `id` )
) ENGINE=INNODB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

INSERT INTO `atim_information` (`tablename`, `field`, `datatype` )
SELECT c.`TABLE_NAME`, c.`COLUMN_NAME`, c.`DATA_TYPE` FROM `INFORMATION_SCHEMA`.`COLUMNS` c;

INSERT INTO `versions` ( `version_number`, `status` ) VALUES ( 'ATiM version 2.0', 'Installed' );

INSERT INTO `structures` (`alias`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns`) VALUES
('versions', 0, 0, 0, 1);
INSERT INTO `structure_formats` ( `structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_help`, `flag_index`, `flag_detail` ) VALUES
( 0, 0, 1, 1, 'version', 1, 1),
( 0, 0, 1, 2, 'date', 1, 1),
( 0, 0, 1, 3, 'status', 1, 1);
UPDATE `structure_formats` f, `structure_fields` d, `structures` s SET f.structure_id = s.id, f.structure_field_id = d.id
WHERE f.language_help = 'version' AND s.alias = 'versions' AND d.`field` = 'version_number';
UPDATE `structure_formats` f, `structure_fields` d, `structures` s SET f.structure_id = s.id, f.structure_field_id = d.id
WHERE f.language_help = 'date' AND s.alias = 'versions' AND d.`field` = 'date_installed';
UPDATE `structure_formats` f, `structure_fields` d, `structures` s SET f.structure_id = s.id, f.structure_field_id = d.id
WHERE f.language_help = 'status' AND s.alias = 'versions' AND d.`field` = 'status' AND d.model = 'Version';

-- Provider Module SQL

CREATE TABLE `providers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(55) character set latin1 NOT NULL,
  `type` varchar(55) character set latin1 NOT NULL,
  `date_effective` datetime default NULL,
  `date_expiry` datetime default NULL,
  `description` text default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL default '',
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY ( `id` )
)  ENGINE=InnoDb DEFAULT CHARSET=latin1;

CREATE TABLE `providers_revs` (
  `id` int(11) NOT NULL,
  `name` varchar(55) character set latin1 NOT NULL,
  `type` varchar(55) character set latin1 NOT NULL,
  `date_effective` datetime default NULL,
  `date_expiry` datetime default NULL,
  `description` text default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL default '',
  `modified` datetime NOT NULL default '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL default '',
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` int(11) default 0,
  `deleted_date` datetime default NULL,
  PRIMARY KEY ( `version_id` )
)  ENGINE=InnoDb DEFAULT CHARSET=latin1;


INSERT INTO `structures` (`alias`, `flag_detail_columns` ) VALUES
('providers', 1);

SET @structure_id = last_insert_id();

INSERT INTO `structure_fields` (`plugin`, `model`, `field`, `language_label`, `type`, `setting`, `structure_value_domain`) VALUES
('Provider', 'Provider', 'name', 'name', 'input', 'size=30', 0);

SET @field_1_id = last_insert_id();

INSERT INTO `structure_fields` (`plugin`, `model`, `field`, `language_label`, `type`, `setting`, `structure_value_domain`) VALUES
('Provider', 'Provider', 'type', 'type', 'select', '', 0);

SET @field_2_id = last_insert_id();

INSERT INTO `structure_fields` (`plugin`, `model`, `field`, `language_label`, `type`, `setting`, `structure_value_domain`) VALUES
('Provider', 'Provider', 'date_effective', 'date_effective', 'datetime', '', 0);

SET @field_3_id = last_insert_id();

INSERT INTO `structure_fields` (`plugin`, `model`, `field`, `language_label`, `type`, `setting`, `structure_value_domain`) VALUES
('Provider', 'Provider', 'date_expiry', 'date_expiry', 'datetime', '', 0);

SET @field_4_id = last_insert_id();

INSERT INTO `structure_fields` (`plugin`, `model`, `field`, `language_label`, `type`, `setting`, `structure_value_domain`) VALUES
('Provider', 'Provider', 'descrition', 'description', 'textarea', 'cols=40,rows=4', 0);

SET @field_5_id = last_insert_id();

INSERT INTO `structure_formats`  (`structure_id`, `structure_field_id`, `display_order`, `flag_add`, `flag_edit`, `flag_search`, `flag_index`, `flag_detail`) VALUES
( @structure_id, @field_1_id, 1, 1, 1, 1, 1, 1),
( @structure_id, @field_2_id, 1, 1, 1, 1, 1, 1),
( @structure_id, @field_3_id, 1, 1, 1, 0, 0, 1),
( @structure_id, @field_4_id, 1, 1, 1, 0, 0, 1),
( @structure_id, @field_5_id, 1, 1, 1, 0, 0, 1);

INSERT INTO `structure_value_domains` (`domain_name`) VALUES
('provider_type');

SET @value_domain = last_insert_id();

INSERT INTO `structure_permissible_values` ( `value`, `language_alias` ) VALUES
( 'doctor', 'doctor' );

SET @value_1_id = last_insert_id();

INSERT INTO `structure_permissible_values` ( `value`, `language_alias` ) VALUES
( 'facility', 'facility' );

SET @value_2_id = last_insert_id();

INSERT INTO `structure_value_domains_permissible_values` ( `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active` ) VALUES
( @value_domain, @value_1_id, 1, 'yes' ),
( @value_domain, @value_2_is, 2, 'yes' );