INSERT INTO `participants` (`id`, `title`, `first_name`, `last_name`, `middle_name`, `date_of_birth`, `date_status`, `marital_status`, `language_preferred`, `sex`, `race`, `ethnicity`, `vital_status`, `memo`, `status`, `date_of_death`, `death_certificate_ident`, `icd10_id`, `confirmation_source`, `tb_number`, `last_chart_checked_date`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES 
(1, '', 'Joe', 'Test', '', '2029-01-01', NULL, 'married', '', 'male', '', NULL, '', '', NULL, '2029-01-01', '', '', '', '', '2029-01-01', '2009-05-14 16:07:13', '1', '2009-05-14 16:07:13', '1', 0, '0000-00-00 00:00:00'),
(2, '', 'Jane', 'Doe', '', '1987-05-01', NULL, 'single', '', 'female', '', NULL, '', '', NULL, '2029-01-01', '', '', '', '', '2009-03-01', '2009-05-14 16:07:13', '1', '2009-05-14 16:07:13', '1', 0, '0000-00-00 00:00:00');

INSERT INTO `event_masters` (`id`, `disease_site`, `event_group`, `event_type`, `event_status`, `event_summary`, `event_date`, `information_source`, `urgency`, `date_required`, `date_requested`, `reference_number`, `created`, `created_by`, `modified`, `modified_by`, `form_alias`, `detail_tablename`, `participant_id`, `diagnosis_id`, `deleted`, `deleted_date`) VALUES
(1, 'breast', 'screening', 'mammogram', 'active', NULL, '2008-05-05', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '2009-06-01 16:59:27', '', 'ed_breast_screening_mammogram', 'ed_breast_screening_mammogram', 1, NULL, 0, '2009-06-01 16:59:27'),
(3, 'breast', 'lab', 'pathology', 'active', '', '1990-10-10', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '2009-06-03 14:15:28', '1', 'ed_breast_lab_pathology', 'ed_breast_lab_pathology', 1, NULL, 0, '0000-00-00 00:00:00'),
(4, 'all', 'clinical', 'presentation', 'active', NULL, '2002-01-02', NULL, NULL, NULL, NULL, NULL, '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 'ed_all_clinical_presentation', 'ed_all_clinical_presentation', 1, NULL, 0, '0000-00-00 00:00:00');

INSERT INTO `ed_breast_lab_pathology` (`id`, `path_number`, `report_type`, `facility`, `vascular_lymph_invasion`, `extra_nodal_invasion`, `blood_lymph`, `tumour_type`, `grade`, `multifocal`, `preneoplastic_changes`, `spread_skin_nipple`, `level_nodal_involvement`, `frozen_section`, `er_assay_ligand`, `pr_assay_ligand`, `progesterone`, `estrogen`, `number_resected`, `number_positive`, `nodal_status`, `resection_margins`, `tumour_size`, `tumour_total_size`, `sentinel_only`, `in_situ_type`, `her2_grade`, `her2_method`, `mb_collectionid`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`, `deleted`, `deleted_date`) VALUES
(3, '1', '', 'manitoba', '', '', NULL, '', '', '', '', '', '', '', 'bbbb', 'cccc', 'aaaa', '', '', '', NULL, 'h', NULL, NULL, '', '', '', '', NULL, '0000-00-00', '', '2009-06-03', '', 0, 0, '0000-00-00 00:00:00');

INSERT INTO `ed_breast_screening_mammogram` (`id`, `result`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`, `deleted`, `deleted_date`) VALUES
(1, 'asdadsads', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00', '', 0, 0, '0000-00-00 00:00:00');

INSERT INTO `tx_masters` ( `id`, `tx_group`, `detail_tablename`, `detail_form_alias`, `extend_tablename`, `extend_form_alias`, `participant_id` ) VALUES
(101, 'chemotherapy', 'txd_chemos', 'txd_chemos', 'txe_chemos', 'txe_chemos', 1),
(102, 'radiation', 'txd_radiations', 'txd_radiations', 'txe_radiations', 'txe_radiations', 1),
(103, 'surgery', 'txd_surgeries', 'txd_surgeries', 'txe_surgeries', 'txe_surgeries', 1);

INSERT INTO `txd_chemos` ( `id`, `completed`, `response`, `tx_master_id` ) VALUES
(101, 'yes', 'completed', 101);

INSERT INTO `txd_radiations` ( `id`, `source`, `mould`, `tx_master_id` ) VALUES
(102, 'plutonium', 'asdf', 102);

INSERT INTO `txd_surgeries` ( `id`, `path_num`, `primary`, `surgeon`, `tx_master_id` ) VALUES
(103, 2456, 'block', 'dr. death', 103);