USE `atim2`;

DELETE FROM `participants`;
INSERT INTO `participants` (`id`, `title`, `first_name`, `last_name`, `middle_name`, `date_of_birth`, `date_status`, `marital_status`, `language_preferred`, `sex`, `race`, `ethnicity`, `vital_status`, `memo`, `status`, `date_of_death`, `death_certificate_ident`, `icd10_id`, `confirmation_source`, `tb_number`, `last_chart_checked_date`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, '', 'Joe', 'Test', '', '2029-01-01', NULL, 'married', '', 'male', '', NULL, '', '', NULL, '2029-01-01', '', '', '', '', '2029-01-01', '2009-05-14 16:07:13', '1', '2009-05-14 16:07:13', '1', 0, '0000-00-00 00:00:00'),
(2, '', 'Jane', 'Doe', '', '1987-05-01', NULL, 'single', '', 'female', '', NULL, '', '', NULL, '2029-01-01', '', '', '', '', '2009-03-01', '2009-05-14 16:07:13', '1', '2009-05-14 16:07:13', '1', 0, '0000-00-00 00:00:00');

DELETE FROM `event_masters`;
INSERT INTO `event_masters` (`id`, `disease_site`, `event_group`, `event_type`, `event_status`, `event_summary`, `event_date`, `information_source`, `urgency`, `date_required`, `date_requested`, `reference_number`, `created`, `created_by`, `modified`, `modified_by`, `form_alias`, `detail_tablename`, `participant_id`, `diagnosis_id`, `deleted`, `deleted_date`) VALUES
(1, 'breast', 'screening', 'mammogram', 'active', NULL, '2008-05-05', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '2009-06-01 16:59:27', '', 'ed_breast_screening_mammogram', 'ed_breast_screening_mammogram', 1, NULL, 0, '2009-06-01 16:59:27'),
(3, 'breast', 'lab', 'pathology', 'active', '', '1990-10-10', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '2009-06-03 14:15:28', '1', 'ed_breast_lab_pathology', 'ed_breast_lab_pathology', 1, NULL, 0, '0000-00-00 00:00:00'),
(4, 'all', 'clinical', 'presentation', 'active', NULL, '2002-01-02', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_all_clinical_presentation', 'ed_all_clinical_presentation', 1, NULL, 0, '0000-00-00 00:00:00'),
(5, 'breast', 'screening', 'mammogram', 'active', NULL, '2005-02-02', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_breast_screening_mammogram', 'ed_breast_screening_mammogram', 1, NULL, 0, NULL),
(6, 'breast', 'lab', 'pathology', 'active', NULL, '1962-01-01', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_breast_lab_pathology', 'ed_breast_lab_pathology', 1, NULL, 0, NULL),
(7, 'breast', 'lab', 'pathology', 'active', NULL, '1998-04-02', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_breast_lab_pathology', 'ed_breast_lab_pathology', 1, NULL, 0, NULL),
(8, 'allsolid', 'lab', 'pathology', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_allsolid_lab_pathology', 'ed_allsolid_lab_pathology', 1, NULL, 0, NULL),
(9, 'allsolid', 'lab', 'pathology', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_allsolid_lab_pathology', 'ed_allsolid_lab_pathology', 1, NULL, 0, NULL);

DELETE FROM `ed_breast_lab_pathology`;
INSERT INTO `ed_breast_lab_pathology` (`id`, `path_number`, `report_type`, `facility`, `vascular_lymph_invasion`, `extra_nodal_invasion`, `blood_lymph`, `tumour_type`, `grade`, `multifocal`, `preneoplastic_changes`, `spread_skin_nipple`, `level_nodal_involvement`, `frozen_section`, `er_assay_ligand`, `pr_assay_ligand`, `progesterone`, `estrogen`, `number_resected`, `number_positive`, `nodal_status`, `resection_margins`, `tumour_size`, `tumour_total_size`, `sentinel_only`, `in_situ_type`, `her2_grade`, `her2_method`, `mb_collectionid`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`, `deleted`, `deleted_date`) VALUES
(3, '1', '', 'manitoba', '', '', NULL, '', '', '', '', '', '', '', 'bbbb', 'cccc', 'aaaa', '', '', '', NULL, 'h', '12.4', NULL, '', '', '', '', NULL, '0000-00-00', '', '2009-06-03', '', 3, 0, '0000-00-00 00:00:00'),
(6, '123', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '23.4', NULL, NULL, NULL, NULL, NULL, NULL, '0000-00-00', '', '0000-00-00', '', 6, 0, NULL),
(7, '3453', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2.6', NULL, NULL, NULL, NULL, NULL, NULL, '0000-00-00', '', '0000-00-00', '', 7, 0, NULL);

DELETE FROM `ed_breast_screening_mammogram`;
INSERT INTO `ed_breast_screening_mammogram` (`id`, `result`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`, `deleted`, `deleted_date`) VALUES
(1, 'asdadsads', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 1, 0, '0000-00-00 00:00:00'),
(5, 'atypical', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 5, 0, NULL);

DELETE FROM `ed_all_clinical_presentation`;
INSERT INTO `ed_all_clinical_presentation` ( `id` , `weight` , `height` , `created` , `created_by` , `modified` , `modified_by` , `event_master_id` , `deleted` , `deleted_date` ) VALUES
('4', '105', '98', NULL , NULL , NULL , NULL , '4', '0', NULL);

DELETE FROM `ed_allsolid_lab_pathology`;
INSERT INTO `ed_allsolid_lab_pathology` ( `id` , `tumour_type` , `resection_margin` , `extra_nodal_invasion` , `lymphatic_vascular_invasion` , `in_situ_component` , `fine_needle_aspirate` , `trucut_core_biopsy` , `open_biopsy` , `frozen_section` , `breast_tumour_size` , `nodes_removed` , `nodes_positive` , `created` , `created_by` , `modified` , `modified_by` , `event_master_id` , `deleted` , `deleted_date` ) VALUES
('8', NULL , 'et', 'est', 'asdf', 'sadf', 'sdf', 'sdf', 'yest', NULL , NULL , '45', '21', '0000-00-00', '', '0000-00-00', '', '8', '0', NULL),
('9', 'mroe test', NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , NULL , '23423', '234', '0000-00-00', '', '0000-00-00', '', '9', '0', NULL);

DELETE FROM `tx_masters`;
INSERT INTO `tx_masters` ( `id`, `tx_group`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `participant_id` ) VALUES
(101, 'chemotherapy', 'txd_chemos', 'txd_chemos', 'txe_chemos', 'txe_chemos', 1),
(102, 'radiation', 'txd_radiations', 'txd_radiations', 'txe_radiations', 'txe_radiations', 1),
(103, 'surgery', 'txd_surgeries', 'txd_surgeries', 'txe_surgeries', 'txe_surgeries', 1);

DELETE FROM `txd_chemos`;
INSERT INTO `txd_chemos` ( `id`, `completed`, `response`, `tx_master_id` ) VALUES
(101, 'yes', 'completed', 101);

DELETE FROM `txd_radiations`;
INSERT INTO `txd_radiations` ( `id`, `source`, `mould`, `tx_master_id` ) VALUES
(102, 'plutonium', 'asdf', 102);

DELETE FROM `txd_surgeries`;
INSERT INTO `txd_surgeries` ( `id`, `path_num`, `primary`, `surgeon`, `tx_master_id` ) VALUES
(103, 2456, 'block', 'dr. death', 103);

DELETE FROM `protocol_masters`;
INSERT INTO `protocol_masters` ( `id`, `name`, `notes`, `code`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias` ) VALUES
(101, 'test', 'test', '34.5C', 'pd_chemos', 'pd_chemos', 'pe_chemos', 'pe_chemos');

DELETE FROM `pd_chemos`;
INSERT INTO `pd_chemos` ( `id`, `num_cycles`, `length_cycles`, `protocol_master_id` ) VALUES
(101, 45, 45, 101);

DELETE FROM `collections`;
INSERT INTO `collections` ( `id`, `acquisition_label`, `bank`, `collection_notes` ) VALUES
(1, 'test', 'the bank', 'This is a test fool');

DELETE FROM `sample_masters`;
INSERT INTO `sample_masters` ( `id`, `sample_code`, `sample_category`, `sample_control_id`, `sample_type`, `collection_id`, `notes` ) VALUES
(1, 'PW-1', 'specimen', 103, 'peritoneal wash', 1, 'This is a test fool'),
(2, 'A-7', 'specimen', 1, 'ascite', 1, 'This is... a test! Dun-Duh.');

DELETE FROM `sd_spe_ascites`;
INSERT INTO `sd_spe_ascites` ( `id`, `sample_master_id`, `collected_volume` ) VALUES
(1, 1, 144);

DELETE FROM `sd_spe_peritoneal_washes`;
INSERT INTO `sd_spe_peritoneal_washes` ( `id`, `sample_master_id`, `collected_volume` ) VALUES
(1, 1, 25.5);

DELETE FROM `storage_masters`;
INSERT INTO `storage_masters` ( `id`, `code`, `storage_control_id`, `parent_id`, `barcode`, `notes` ) VALUES
(1, 'B - 1', 1, NULL, '12332', 'Test');

DELETE FROM `std_rooms`;
INSERT INTO `std_rooms` ( `id`, `storage_master_id`, `laboratory`, `floor` ) VALUES
(1, 1, 'test', 'test');

DELETE FROM `aliquot_masters`;
INSERT INTO `aliquot_masters` ( `id`, `barcode`, `aliquot_type`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `status` ) VALUES
(1, 'D345430D212', 'slide', 10, 1, 1, 'active' ),
(2, 'E30002123C8', 'gel matrices', 13, 1, 1, 'active');

DELETE FROM `ad_cell_slides`;
INSERT INTO `ad_cell_slides` ( `id`, `aliquot_master_id`, `immunochemistry` ) VALUES
( 1, 1, 'test');

DELETE FROM `ad_gel_matrices`;
INSERT INTO `ad_gel_matrices` ( `id`, `aliquot_master_id`, `cell_count` ) VALUES
( 1, 2, 45 );

DELETE FROM `sop_masters`;
INSERT INTO `sop_masters` ( `id`, `title`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`) VALUES
(1, 'test', 'sopd_general_all', 'sopd_general_all', 'sope_general_all', 'sope_general_all');