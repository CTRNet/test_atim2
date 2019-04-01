SET time_zone = "+00:00";
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET FOREIGN_KEY_CHECKS=0;

--
-- Dumping data for table `ad_bags`
--


--
-- Dumping data for table `ad_bags_revs`
--


--
-- Dumping data for table `ad_blocks`
--

INSERT INTO `ad_blocks` (`id`, `aliquot_master_id`, `block_type`, `patho_dpt_block_code`, `deleted`) VALUES
(1, 19, 'OCT', '', 0),
(2, 20, 'OCT', '', 0),
(3, 21, 'paraffin', '', 0),
(4, 38, 'OCT', '', 0),
(5, 39, 'OCT', '#41123123', 0),
(6, 40, 'OCT', '', 0),
(7, 52, 'OCT', '', 0);

--
-- Dumping data for table `ad_blocks_revs`
--

INSERT INTO `ad_blocks_revs` (`id`, `aliquot_master_id`, `block_type`, `patho_dpt_block_code`, `version_id`, `version_created`) VALUES
(1, 19, 'OCT', '', 1, '2011-10-19 14:02:52'),
(2, 20, 'OCT', '', 2, '2011-10-19 14:02:53'),
(3, 21, 'paraffin', '', 3, '2011-10-19 14:02:54'),
(4, 38, 'OCT', '', 4, '2011-10-19 14:52:30'),
(5, 39, 'OCT', '#41123123', 5, '2011-10-19 14:52:31'),
(6, 40, 'OCT', '', 6, '2011-10-19 14:52:31'),
(7, 52, 'OCT', '', 7, '2011-10-19 15:17:38');

--
-- Dumping data for table `ad_cell_cores`
--


--
-- Dumping data for table `ad_cell_cores_revs`
--


--
-- Dumping data for table `ad_cell_slides`
--


--
-- Dumping data for table `ad_cell_slides_revs`
--


--
-- Dumping data for table `ad_gel_matrices`
--


--
-- Dumping data for table `ad_gel_matrices_revs`
--


--
-- Dumping data for table `ad_tissue_cores`
--


--
-- Dumping data for table `ad_tissue_cores_revs`
--


--
-- Dumping data for table `ad_tissue_slides`
--

INSERT INTO `ad_tissue_slides` (`id`, `aliquot_master_id`, `immunochemistry`, `deleted`) VALUES
(1, 24, 'AC78', 0),
(2, 42, 'AC67984', 0);

--
-- Dumping data for table `ad_tissue_slides_revs`
--

INSERT INTO `ad_tissue_slides_revs` (`id`, `aliquot_master_id`, `immunochemistry`, `version_id`, `version_created`) VALUES
(1, 24, 'AC78', 1, '2011-10-19 14:04:10'),
(2, 42, 'AC67984', 2, '2011-10-19 14:53:16');

--
-- Dumping data for table `ad_tubes`
--

INSERT INTO `ad_tubes` (`id`, `aliquot_master_id`, `lot_number`, `concentration`, `concentration_unit`, `cell_count`, `cell_count_unit`, `cell_viability`, `hemolysis_signs`, `deleted`) VALUES
(1, 1, '', NULL, '', '12.00', '10e6', '56.00', '', 0),
(2, 2, '', NULL, '', '3.00', '10e6', '78.00', '', 0),
(3, 3, '', NULL, '', '12.00', '10e6', '54.00', '', 0),
(4, 4, '', '23.80', 'ng/ul', NULL, NULL, NULL, '', 0),
(5, 5, '', '23.80', 'ng/ul', NULL, NULL, NULL, '', 0),
(6, 6, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(7, 7, '', NULL, NULL, NULL, NULL, NULL, 'y', 0),
(8, 8, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(9, 9, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(10, 10, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(11, 11, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(12, 12, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(13, 13, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(14, 14, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(15, 16, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(16, 17, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(17, 18, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(18, 22, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(19, 23, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(20, 25, '', NULL, '', NULL, NULL, NULL, '', 0),
(21, 26, '', NULL, '', NULL, NULL, NULL, '', 0),
(22, 27, '', NULL, '', NULL, NULL, NULL, '', 0),
(23, 28, '#41414', '12.00', 'ug/ul', NULL, NULL, NULL, '', 0),
(24, 29, '#41414', '12.00', 'ug/ul', NULL, NULL, NULL, '', 0),
(25, 30, '#41414', '12.00', 'ug/ul', NULL, NULL, NULL, '', 0),
(26, 31, '', NULL, '', NULL, NULL, NULL, '', 0),
(27, 32, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(28, 33, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(29, 34, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(30, 35, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(31, 36, '1311', NULL, NULL, NULL, NULL, NULL, '', 0),
(32, 37, '4133', NULL, NULL, NULL, NULL, NULL, '', 0),
(33, 41, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(34, 43, '', '2.00', 'ug/ul', NULL, NULL, NULL, '', 0),
(35, 44, '', '2.00', 'ug/ul', NULL, NULL, NULL, '', 0),
(36, 45, '', '2.00', 'ug/ul', NULL, NULL, NULL, '', 0),
(37, 46, '', NULL, '', NULL, NULL, NULL, '', 0),
(38, 47, '', NULL, '', NULL, NULL, NULL, '', 0),
(39, 48, '', NULL, '', NULL, NULL, NULL, '', 0),
(40, 49, '', NULL, '', NULL, NULL, NULL, '', 0),
(41, 50, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(42, 51, '', '12.00', 'ug/ul', NULL, NULL, NULL, '', 0),
(43, 53, '', NULL, '', NULL, NULL, NULL, '', 0),
(44, 54, '', NULL, '', NULL, NULL, NULL, '', 0),
(45, 55, '', NULL, '', NULL, NULL, NULL, '', 0);

--
-- Dumping data for table `ad_tubes_revs`
--

INSERT INTO `ad_tubes_revs` (`id`, `aliquot_master_id`, `lot_number`, `concentration`, `concentration_unit`, `cell_count`, `cell_count_unit`, `cell_viability`, `hemolysis_signs`, `version_id`, `version_created`) VALUES
(1, 1, '', NULL, '', '12.00', '10e6', '56.00', '', 1, '2011-10-19 13:32:52'),
(2, 2, '', NULL, '', '3.00', '10e6', '78.00', '', 2, '2011-10-19 13:32:53'),
(3, 3, '', NULL, '', '12.00', '10e6', '54.00', '', 3, '2011-10-19 13:32:53'),
(4, 4, '', '23.80', 'ng/ul', NULL, NULL, NULL, '', 4, '2011-10-19 13:34:09'),
(5, 5, '', '23.80', 'ng/ul', NULL, NULL, NULL, '', 5, '2011-10-19 13:34:10'),
(6, 6, '', NULL, NULL, NULL, NULL, NULL, '', 6, '2011-10-19 13:35:57'),
(7, 7, '', NULL, NULL, NULL, NULL, NULL, 'y', 7, '2011-10-19 13:35:57'),
(8, 8, '', NULL, NULL, NULL, NULL, NULL, '', 8, '2011-10-19 13:35:58'),
(9, 9, '', NULL, NULL, NULL, NULL, NULL, '', 9, '2011-10-19 13:37:04'),
(10, 10, '', NULL, NULL, NULL, NULL, NULL, '', 10, '2011-10-19 13:37:05'),
(11, 11, '', NULL, NULL, NULL, NULL, NULL, '', 11, '2011-10-19 13:37:05'),
(12, 12, '', NULL, NULL, NULL, NULL, NULL, '', 12, '2011-10-19 13:38:18'),
(13, 13, '', NULL, NULL, NULL, NULL, NULL, '', 13, '2011-10-19 13:38:18'),
(14, 14, '', NULL, NULL, NULL, NULL, NULL, '', 14, '2011-10-19 13:38:19'),
(15, 16, '', NULL, NULL, NULL, NULL, NULL, '', 15, '2011-10-19 13:42:05'),
(16, 17, '', NULL, NULL, NULL, NULL, NULL, '', 16, '2011-10-19 13:42:05'),
(17, 18, '', NULL, NULL, NULL, NULL, NULL, '', 17, '2011-10-19 14:00:23'),
(18, 22, '', NULL, NULL, NULL, NULL, NULL, '', 18, '2011-10-19 14:03:50'),
(19, 23, '', NULL, NULL, NULL, NULL, NULL, '', 19, '2011-10-19 14:03:51'),
(20, 25, '', NULL, '', NULL, NULL, NULL, '', 20, '2011-10-19 14:06:04'),
(21, 26, '', NULL, '', NULL, NULL, NULL, '', 21, '2011-10-19 14:06:05'),
(22, 27, '', NULL, '', NULL, NULL, NULL, '', 22, '2011-10-19 14:06:05'),
(23, 28, '#41414', '12.00', 'ug/ul', NULL, NULL, NULL, '', 23, '2011-10-19 14:07:16'),
(24, 29, '#41414', '12.00', 'ug/ul', NULL, NULL, NULL, '', 24, '2011-10-19 14:07:17'),
(25, 30, '#41414', '12.00', 'ug/ul', NULL, NULL, NULL, '', 25, '2011-10-19 14:07:18'),
(26, 31, '', NULL, '', NULL, NULL, NULL, '', 26, '2011-10-19 14:09:03'),
(27, 32, '', NULL, NULL, NULL, NULL, NULL, '', 27, '2011-10-19 14:49:35'),
(28, 33, '', NULL, NULL, NULL, NULL, NULL, '', 28, '2011-10-19 14:49:36'),
(29, 34, '', NULL, NULL, NULL, NULL, NULL, '', 29, '2011-10-19 14:51:09'),
(30, 35, '', NULL, NULL, NULL, NULL, NULL, '', 30, '2011-10-19 14:51:09'),
(31, 36, '1311', NULL, NULL, NULL, NULL, NULL, '', 31, '2011-10-19 14:51:10'),
(32, 37, '4133', NULL, NULL, NULL, NULL, NULL, '', 32, '2011-10-19 14:51:10'),
(33, 41, '', NULL, NULL, NULL, NULL, NULL, '', 33, '2011-10-19 14:53:02'),
(34, 43, '', '2.00', 'ug/ul', NULL, NULL, NULL, '', 34, '2011-10-19 14:54:33'),
(35, 44, '', '2.00', 'ug/ul', NULL, NULL, NULL, '', 35, '2011-10-19 14:54:36'),
(36, 45, '', '2.00', 'ug/ul', NULL, NULL, NULL, '', 36, '2011-10-19 14:54:36'),
(37, 46, '', NULL, '', NULL, NULL, NULL, '', 37, '2011-10-19 14:55:51'),
(38, 47, '', NULL, '', NULL, NULL, NULL, '', 38, '2011-10-19 14:55:52'),
(39, 48, '', NULL, '', NULL, NULL, NULL, '', 39, '2011-10-19 14:55:52'),
(40, 49, '', NULL, '', NULL, NULL, NULL, '', 40, '2011-10-19 14:56:52'),
(41, 50, '', NULL, NULL, NULL, NULL, NULL, '', 41, '2011-10-19 14:58:27'),
(42, 51, '', '12.00', 'ug/ul', NULL, NULL, NULL, '', 42, '2011-10-19 15:13:38'),
(43, 53, '', NULL, '', NULL, NULL, NULL, '', 43, '2011-10-19 18:24:22'),
(44, 54, '', NULL, '', NULL, NULL, NULL, '', 44, '2011-10-19 18:24:22'),
(45, 55, '', NULL, '', NULL, NULL, NULL, '', 45, '2011-10-19 18:24:24');

--
-- Dumping data for table `ad_whatman_papers`
--

INSERT INTO `ad_whatman_papers` (`id`, `aliquot_master_id`, `used_blood_volume`, `used_blood_volume_unit`, `deleted`) VALUES
(1, 15, NULL, '', 0);

--
-- Dumping data for table `ad_whatman_papers_revs`
--

INSERT INTO `ad_whatman_papers_revs` (`id`, `aliquot_master_id`, `used_blood_volume`, `used_blood_volume_unit`, `version_id`, `version_created`) VALUES
(1, 15, NULL, '', 1, '2011-10-19 13:38:40');

--
-- Dumping data for table `aliquot_internal_uses`
--

INSERT INTO `aliquot_internal_uses` (`id`, `aliquot_master_id`, `use_code`, `use_details`, `used_volume`, `use_datetime`, `use_datetime_accuracy`, `used_by`, `study_summary_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 24, 'Reviewed By Dr Watson', '', NULL, '2011-12-09 02:06:00', '', '', NULL, '2011-10-20 13:26:01', 1, '2011-10-20 13:26:01', 1, 0),
(2, 38, 'Used By Lab Santer', '', NULL, '2012-03-08 16:15:00', '', '', 2, '2011-10-20 13:28:35', 1, '2011-10-20 13:29:17', 1, 1),
(3, 38, 'Used By Lab Santer', '', NULL, '2012-03-08 16:15:00', '', '', 2, '2011-10-20 13:28:35', 1, '2011-10-20 13:28:35', 1, 0),
(4, 40, 'Used By Lab Santer', '', NULL, '2012-03-08 16:15:00', '', '', 2, '2011-10-20 13:28:35', 1, '2011-10-20 13:28:35', 1, 0),
(5, 25, 'Projet Dr Qwerty', '', '2.30000', '2012-04-17 06:12:00', '', '', 2, '2011-10-20 13:32:52', 1, '2011-10-20 13:32:52', 1, 0),
(6, 44, 'Projet Dr Qwerty', '', '1.70000', '2012-04-17 06:12:00', '', '', 2, '2011-10-20 13:32:52', 1, '2011-10-20 13:32:52', 1, 0),
(7, 45, 'Dr Shapuis', '', NULL, NULL, '', '', NULL, '2011-10-20 13:43:36', 1, '2011-10-20 13:43:36', 1, 0),
(8, 27, 'Test Proto 9948', '', NULL, NULL, '', '', NULL, '2011-10-20 13:45:21', 1, '2011-10-20 13:45:21', 1, 0);

--
-- Dumping data for table `aliquot_internal_uses_revs`
--

INSERT INTO `aliquot_internal_uses_revs` (`id`, `aliquot_master_id`, `use_code`, `use_details`, `used_volume`, `use_datetime`, `use_datetime_accuracy`, `used_by`, `study_summary_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 24, 'Reviewed By Dr Watson', '', NULL, '2011-12-09 02:06:00', '', '', NULL, 1, 1, '2011-10-20 13:26:01'),
(2, 38, 'Used By Lab Santer', '', NULL, '2012-03-08 16:15:00', '', '', 2, 1, 2, '2011-10-20 13:28:35'),
(3, 38, 'Used By Lab Santer', '', NULL, '2012-03-08 16:15:00', '', '', 2, 1, 3, '2011-10-20 13:28:35'),
(4, 40, 'Used By Lab Santer', '', NULL, '2012-03-08 16:15:00', '', '', 2, 1, 4, '2011-10-20 13:28:35'),
(2, 38, 'Used By Lab Santer', '', NULL, '2012-03-08 16:15:00', '', '', 2, 1, 5, '2011-10-20 13:29:17'),
(5, 25, 'Projet Dr Qwerty', '', '2.30000', '2012-04-17 06:12:00', '', '', 2, 1, 6, '2011-10-20 13:32:52'),
(6, 44, 'Projet Dr Qwerty', '', '1.70000', '2012-04-17 06:12:00', '', '', 2, 1, 7, '2011-10-20 13:32:52'),
(7, 45, 'Dr Shapuis', '', NULL, NULL, '', '', NULL, 1, 8, '2011-10-20 13:43:36'),
(8, 27, 'Test Proto 9948', '', NULL, NULL, '', '', NULL, 1, 9, '2011-10-20 13:45:21');

--
-- Dumping data for table `aliquot_masters`
--

INSERT INTO `aliquot_masters` (`id`, `barcode`, `aliquot_label`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `sop_master_id`, `initial_volume`, `current_volume`, `in_stock`, `in_stock_detail`, `use_counter`, `study_summary_id`, `storage_datetime`, `storage_datetime_accuracy`, `storage_master_id`, `storage_coord_x`, `storage_coord_y`, `product_code`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, '89932', 'bc1', 36, 1, 2, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, 1, '2011-05-28 13:18:00', 'c', 11, '1', 'A', NULL, NULL, '2011-10-19 13:32:52', 1, '2011-10-19 13:32:52', 1, 0),
(2, '73991', 'bc2', 36, 1, 2, NULL, '7.30000', '7.30000', 'yes - available', '', NULL, 1, '2011-05-28 13:18:00', 'c', 11, '3', 'A', NULL, NULL, '2011-10-19 13:32:52', 1, '2011-10-19 13:32:52', 1, 0),
(3, '739171', 'bc3', 36, 1, 2, NULL, '7.90000', '7.90000', 'yes - available', '', NULL, 1, '2011-05-28 13:19:00', 'c', 11, '2', 'A', NULL, NULL, '2011-10-19 13:32:53', 1, '2011-10-19 13:32:53', 1, 0),
(4, '7454567', 'bc.dna 1', 29, 1, 3, NULL, '5.00000', '5.00000', 'yes - available', '', NULL, 1, '2011-10-05 11:07:00', 'c', 9, '1', '', NULL, NULL, '2011-10-19 13:34:09', 1, '2011-10-19 13:34:09', 1, 0),
(5, '7454564', 'bc.dna 2', 29, 1, 3, NULL, '5.00000', '3.70000', 'yes - available', '', 1, 1, '2011-10-05 11:07:00', 'c', 9, '2', '', NULL, NULL, '2011-10-19 13:34:09', 1, '2011-10-20 15:00:23', 1, 0),
(6, '6345345435', 'pl 1', 16, 1, 4, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:13:00', 'c', 12, '4', 'A', NULL, NULL, '2011-10-19 13:35:54', 1, '2011-10-19 13:35:54', 1, 0),
(7, '634534531', 'pl 2', 16, 1, 4, NULL, '3.70000', '3.70000', 'yes - available', '', NULL, NULL, '2011-05-28 13:13:00', 'c', 12, '5', 'A', NULL, NULL, '2011-10-19 13:35:57', 1, '2011-10-19 13:35:57', 1, 0),
(8, '63453454335', 'pl 3', 16, 1, 4, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:13:00', 'c', 12, '6', 'A', NULL, NULL, '2011-10-19 13:35:57', 1, '2011-10-19 13:35:57', 1, 0),
(9, '733455', 'ser  1', 17, 1, 5, NULL, '4.10000', '4.10000', 'yes - available', '', NULL, NULL, '2011-05-28 12:13:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 13:37:04', 1, '2011-10-19 13:37:04', 1, 0),
(10, '734255', 'ser 2', 17, 1, 5, NULL, '4.10000', '4.10000', 'yes - available', '', NULL, NULL, '2011-05-28 12:13:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 13:37:05', 1, '2011-10-19 13:37:05', 1, 0),
(11, '734535', 'ser 3', 17, 1, 5, NULL, '4.10000', '4.10000', 'yes - available', '', NULL, NULL, '2011-05-28 12:13:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 13:37:05', 1, '2011-10-19 13:37:05', 1, 0),
(12, 'e12123124', 'Pax 1', 3, 1, 6, NULL, '4.00000', '4.00000', 'yes - available', '', NULL, NULL, '2011-05-28 12:57:00', 'c', 12, '3', 'A', NULL, NULL, '2011-10-19 13:38:17', 1, '2011-10-19 13:38:17', 1, 0),
(13, 'e121233124', 'Pax 2', 3, 1, 6, NULL, '4.00000', '4.00000', 'yes - available', '', NULL, NULL, '2011-05-28 12:57:00', 'c', 12, '2', 'A', NULL, NULL, '2011-10-19 13:38:18', 1, '2011-10-19 13:38:18', 1, 0),
(14, 'e121232124', 'Pax 3', 3, 1, 6, NULL, '5.60000', '5.60000', 'yes - available', '', NULL, NULL, '2011-05-28 12:57:00', 'c', 12, '1', 'A', NULL, NULL, '2011-10-19 13:38:19', 1, '2011-10-19 13:38:19', 1, 0),
(15, '41241241', 'wp1', 11, 1, 6, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-05-28 16:38:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 13:38:40', 1, '2011-10-19 13:38:40', 1, 0),
(16, '76745645', 'asc 1', 2, 2, 7, NULL, '31.00000', '31.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:11:00', 'c', 21, '2', 'A', NULL, NULL, '2011-10-19 13:42:04', 1, '2011-10-19 13:42:04', 1, 0),
(17, '74456456456', 'asc 2', 2, 2, 7, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:11:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 13:42:05', 1, '2011-10-19 13:42:05', 1, 0),
(18, '8902134', 'asc c1', 12, 2, 8, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-05 16:06:00', 'c', 21, '1', 'A', NULL, NULL, '2011-10-19 14:00:22', 1, '2011-10-19 14:00:22', 1, 0),
(19, '52342525', 'ov oct 1', 9, 2, 9, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:02:52', 1, '2011-10-19 16:58:05', 1, 0),
(20, '53234324', 'ov oct 2', 9, 2, 9, NULL, NULL, NULL, 'yes - available', '', 1, 1, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:02:53', 1, '2011-10-19 17:10:37', 1, 0),
(21, '5234234324', 'ov parf 1', 9, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, 1, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:02:53', 1, '2011-10-19 14:02:53', 1, 0),
(22, '432324234', 'ov t1', 1, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-05-28 16:07:00', 'c', 21, '3', 'A', NULL, NULL, '2011-10-19 14:03:50', 1, '2011-10-19 14:03:50', 1, 0),
(23, '234234234', 'ov t2', 1, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-05-28 16:07:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:03:50', 1, '2011-10-19 14:03:50', 1, 0),
(24, '235324324432', 'sl9846', 10, 2, 9, NULL, NULL, NULL, 'yes - available', 'on loan', 1, NULL, '2011-10-01 00:00:00', 'd', NULL, '', '', NULL, '', '2011-10-19 14:04:10', 1, '2011-10-20 13:26:01', 1, 0),
(25, '338819221', 'DNA ov t1', 29, 2, 11, NULL, '12.00000', '9.70000', 'yes - available', '', 2, 2, '2011-05-31 00:00:00', 'c', 10, '3', '1', NULL, NULL, '2011-10-19 14:06:04', 1, '2011-10-20 15:04:17', 1, 0),
(26, '338819231', 'DNA ov t2', 29, 2, 11, NULL, '12.00000', '7.20000', 'no', '', 2, 2, '2011-05-31 00:00:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:06:04', 1, '2011-10-20 14:28:37', 1, 0),
(27, '338811921', 'DNA ov t3', 29, 2, 11, NULL, '12.00000', '12.00000', 'yes - not available', 'on loan', 1, 2, '2011-05-31 00:00:00', 'c', 10, '1', '1', NULL, NULL, '2011-10-19 14:06:05', 1, '2011-10-20 13:45:21', 1, 0),
(28, '41122121', 'RNA ov1', 30, 2, 12, NULL, '1.00000', '0.17000', 'yes - available', '', 3, 1, '2011-10-05 04:10:00', 'c', 19, '1', 'A', NULL, '', '2011-10-19 14:07:16', 1, '2011-10-19 18:42:39', 1, 0),
(29, '4124111', 'RNA ov2', 30, 2, 12, NULL, '1.00000', '1.00000', 'no', 'shipped', 1, NULL, '2011-10-05 04:10:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:07:17', 1, '2011-10-19 17:43:47', 1, 0),
(30, '41312', 'RNA ov3', 30, 2, 12, NULL, '1.00000', '0.00000', 'no', 'empty', 1, NULL, '2011-10-05 04:10:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:07:17', 1, '2011-10-19 17:24:32', 1, 0),
(31, '89030', 'ARNA1', 31, 2, 13, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-29 04:12:00', 'c', 18, '1', 'A', NULL, NULL, '2011-10-19 14:09:02', 1, '2011-10-19 14:09:02', 1, 0),
(32, '413212', 'asc 1.1', 2, 3, 14, NULL, '3.40000', '3.40000', 'yes - available', '', NULL, 2, '2011-10-02 09:09:00', 'c', 21, '3', 'A', NULL, NULL, '2011-10-19 14:49:35', 1, '2011-10-19 14:49:35', 1, 0),
(33, '413211', 'asc 1.2', 2, 3, 14, NULL, '3.40000', '3.40000', 'yes - available', '', NULL, 2, '2011-10-02 09:09:00', 'c', 21, '3', 'B', NULL, NULL, '2011-10-19 14:49:35', 1, '2011-10-19 14:49:35', 1, 0),
(34, '432213', 'asc c 1.1', 12, 3, 15, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 2, '2011-10-19 09:05:00', 'c', 21, '4', 'A', NULL, NULL, '2011-10-19 14:51:08', 1, '2011-10-19 14:51:08', 1, 0),
(35, '4322313', 'asc c 1.2', 12, 3, 15, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 2, '2011-10-19 09:05:00', 'c', 21, '4', 'A', NULL, NULL, '2011-10-19 14:51:09', 1, '2011-10-19 14:51:09', 1, 0),
(36, '4322331', 'asc c 1.3', 12, 3, 15, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 2, '2011-10-19 09:05:00', 'c', 21, '4', 'A', NULL, NULL, '2011-10-19 14:51:09', 1, '2011-10-19 14:51:09', 1, 0),
(37, '4322333', 'asc c 1.4', 12, 3, 15, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 2, '2011-10-19 09:05:00', 'c', 21, '4', 'A', NULL, NULL, '2011-10-19 14:51:10', 1, '2011-10-19 14:51:10', 1, 0),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', '', 2, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, '2011-10-19 14:52:30', 1, '2011-10-20 13:28:35', 1, 0),
(39, '4121321', 'bck oct 2', 9, 3, 16, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'B', NULL, NULL, '2011-10-19 14:52:31', 1, '2011-10-19 14:52:31', 1, 0),
(40, '4121121', 'bck oct 3', 9, 3, 16, NULL, NULL, NULL, 'yes - not available', 'reserved for order', 1, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'C', NULL, NULL, '2011-10-19 14:52:31', 1, '2011-10-20 15:13:43', 1, 0),
(41, '311212', 'tis tub 2', 1, 3, 16, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-02 10:09:00', 'c', 21, '5', 'E', NULL, NULL, '2011-10-19 14:53:01', 1, '2011-10-19 14:53:01', 1, 0),
(42, '89003', 'sl 9843', 10, 3, 16, NULL, NULL, NULL, 'yes - available', '', 1, NULL, '2011-10-02 10:09:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:53:16', 1, '2011-10-19 14:53:16', 1, 0),
(43, '42131223', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '0.30000', 'no', '', 1, NULL, '2011-10-01 00:00:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:54:33', 1, '2011-10-20 15:00:23', 1, 0),
(44, '42131123', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '1.30000', 'no', 'lost', 1, NULL, '2011-10-01 00:00:00', 'c', 9, '12', '', NULL, NULL, '2011-10-19 14:54:36', 1, '2011-10-20 13:32:53', 1, 0),
(45, '42133123', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '3.00000', 'no', '', 1, NULL, '2011-10-01 00:00:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:54:36', 1, '2011-10-20 13:43:36', 1, 0),
(46, '4112213', 't RNA 2', 30, 3, 19, NULL, '3.00000', '0.40000', 'yes - available', '', 2, NULL, '2011-10-12 00:00:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:55:51', 1, '2011-10-19 18:42:40', 1, 0),
(47, '41122213', 't RNA 22', 30, 3, 19, NULL, '2.00000', '2.00000', 'yes - available', '', NULL, NULL, '2011-10-12 00:00:00', 'c', 18, '6', 'C', NULL, NULL, '2011-10-19 14:55:51', 1, '2011-10-19 14:55:51', 1, 0),
(48, '41123411', 't RNA 23', 30, 3, 19, NULL, '3.00000', '1.70000', 'yes - available', 'on loan', 1, NULL, '2011-10-12 00:00:00', 'c', 18, '6', 'A', NULL, NULL, '2011-10-19 14:55:52', 1, '2011-10-19 17:24:33', 1, 0),
(49, '5674467', 'A RNA 2', 31, 3, 20, NULL, NULL, NULL, 'yes - available', 'empty', NULL, NULL, '2011-10-27 00:00:00', 'c', 19, '', '', NULL, NULL, '2011-10-19 14:56:52', 1, '2011-10-19 14:56:52', 1, 0),
(50, '5234234', 'U189', 4, 4, 21, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-02 08:09:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 14:58:27', 1, '2011-10-19 14:58:27', 1, 0),
(51, '32234324324', 'RNA TCC 9843', 30, 5, 25, NULL, '3.40000', '3.40000', 'no', 'shipped', 1, NULL, '2011-10-29 00:00:00', 'c', NULL, '', '', NULL, NULL, '2011-10-19 15:13:38', 1, '2011-10-19 17:43:45', 1, 0),
(52, '778920', 'TT OCT1', 9, 5, 23, NULL, NULL, NULL, 'yes - not available', 'reserved for order', NULL, NULL, '2011-10-05 09:07:00', 'c', 21, '9', 'A', NULL, NULL, '2011-10-19 15:17:38', 1, '2011-10-20 15:13:44', 1, 0),
(53, '41231231414.1', 'RNA ov1.1', 30, 2, 12, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 1, '2011-12-01 08:09:00', 'c', 19, '4', 'A', NULL, NULL, '2011-10-19 18:24:21', 1, '2011-10-19 18:24:21', 1, 0),
(54, '41231231414.2', 'RNA ov1.2', 30, 2, 12, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 1, '2011-12-01 08:09:00', 'c', 19, '4', 'B', NULL, NULL, '2011-10-19 18:24:22', 1, '2011-10-19 18:24:22', 1, 0),
(55, '4112213.1', 't RNA 2.1', 30, 3, 19, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 1, '2011-12-01 08:09:00', 'c', 19, '4', 'C', NULL, NULL, '2011-10-19 18:24:23', 1, '2011-10-19 18:24:23', 1, 0);

--
-- Dumping data for table `aliquot_masters_revs`
--

INSERT INTO `aliquot_masters_revs` (`id`, `barcode`, `aliquot_label`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `sop_master_id`, `initial_volume`, `current_volume`, `in_stock`, `in_stock_detail`, `use_counter`, `study_summary_id`, `storage_datetime`, `storage_datetime_accuracy`, `storage_master_id`, `storage_coord_x`, `storage_coord_y`, `product_code`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '89932', 'bc1', 36, 1, 2, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, 1, '2011-05-28 13:18:00', 'c', 11, '1', 'A', NULL, NULL, 1, 1, '2011-10-19 13:32:52'),
(2, '73991', 'bc2', 36, 1, 2, NULL, '7.30000', '7.30000', 'yes - available', '', NULL, 1, '2011-05-28 13:18:00', 'c', 11, '2', 'A', NULL, NULL, 1, 2, '2011-10-19 13:32:53'),
(3, '739171', 'bc3', 36, 1, 2, NULL, '7.90000', '7.90000', 'yes - available', '', NULL, 1, '2011-05-28 13:19:00', 'c', 11, '2', 'A', NULL, NULL, 1, 3, '2011-10-19 13:32:53'),
(4, '7454567', 'bc.dna 1', 29, 1, 3, NULL, '5.00000', '5.00000', 'yes - available', '', NULL, 1, '2011-10-05 11:07:00', 'c', 9, '1', '', NULL, NULL, 1, 4, '2011-10-19 13:34:09'),
(5, '7454564', 'bc.dna 2', 29, 1, 3, NULL, '5.00000', '5.00000', 'yes - available', '', NULL, 1, '2011-10-05 11:07:00', 'c', 9, '2', '', NULL, NULL, 1, 5, '2011-10-19 13:34:10'),
(6, '6345345435', 'pl 1', 16, 1, 4, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:13:00', 'c', 19, '1', 'A', NULL, NULL, 1, 6, '2011-10-19 13:35:57'),
(7, '634534531', 'pl 2', 16, 1, 4, NULL, '3.70000', '3.70000', 'yes - available', '', NULL, NULL, '2011-05-28 13:13:00', 'c', 19, '2', 'A', NULL, NULL, 1, 7, '2011-10-19 13:35:57'),
(8, '63453454335', 'pl 3', 16, 1, 4, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:13:00', 'c', 19, '3', 'A', NULL, NULL, 1, 8, '2011-10-19 13:35:58'),
(9, '733455', 'ser  1', 17, 1, 5, NULL, '4.10000', '4.10000', 'yes - available', '', NULL, NULL, '2011-05-28 12:13:00', 'c', NULL, '', '', NULL, NULL, 1, 9, '2011-10-19 13:37:05'),
(10, '734255', 'ser 2', 17, 1, 5, NULL, '4.10000', '4.10000', 'yes - available', '', NULL, NULL, '2011-05-28 12:13:00', 'c', NULL, '', '', NULL, NULL, 1, 10, '2011-10-19 13:37:05'),
(11, '734535', 'ser 3', 17, 1, 5, NULL, '4.10000', '4.10000', 'yes - available', '', NULL, NULL, '2011-05-28 12:13:00', 'c', NULL, '', '', NULL, NULL, 1, 11, '2011-10-19 13:37:05'),
(12, 'e12123124', 'Pax 1', 3, 1, 6, NULL, '4.00000', '4.00000', 'yes - available', '', NULL, NULL, '2011-05-28 12:57:00', 'c', 12, '1', 'A', NULL, NULL, 1, 12, '2011-10-19 13:38:18'),
(13, 'e121233124', 'Pax 2', 3, 1, 6, NULL, '4.00000', '4.00000', 'yes - available', '', NULL, NULL, '2011-05-28 12:57:00', 'c', 12, '1', 'A', NULL, NULL, 1, 13, '2011-10-19 13:38:19'),
(14, 'e121232124', 'Pax 3', 3, 1, 6, NULL, '5.60000', '5.60000', 'yes - available', '', NULL, NULL, '2011-05-28 12:57:00', 'c', 12, '1', 'A', NULL, NULL, 1, 14, '2011-10-19 13:38:20'),
(15, '41241241', 'wp1', 11, 1, 6, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-05-28 16:38:00', 'c', NULL, '', '', NULL, NULL, 1, 15, '2011-10-19 13:38:41'),
(16, '76745645', 'asc 1', 2, 2, 7, NULL, '31.00000', '31.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:11:00', 'c', 9, '1', '', NULL, NULL, 1, 16, '2011-10-19 13:42:05'),
(17, '74456456456', 'asc 2', 2, 2, 7, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:11:00', 'c', NULL, '', '', NULL, NULL, 1, 17, '2011-10-19 13:42:05'),
(18, '8902134', 'asc c1', 12, 2, 8, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-05 16:06:00', 'c', 11, '1', 'A', NULL, NULL, 1, 18, '2011-10-19 14:00:23'),
(19, '52342525', 'ov oct 1', 9, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, 1, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, 1, 19, '2011-10-19 14:02:53'),
(20, '53234324', 'ov oct 2', 9, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, 1, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, 1, 20, '2011-10-19 14:02:53'),
(21, '5234234324', 'ov parf 1', 9, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, 1, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, 1, 21, '2011-10-19 14:02:54'),
(22, '432324234', 'ov t1', 1, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-05-28 16:07:00', 'c', 11, '1', 'A', NULL, NULL, 1, 22, '2011-10-19 14:03:50'),
(23, '234234234', 'ov t2', 1, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-05-28 16:07:00', 'c', NULL, '', '', NULL, NULL, 1, 23, '2011-10-19 14:03:51'),
(24, '235324324432', 'sl9846', 10, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, 1, 24, '2011-10-19 14:04:10'),
(25, '338819221', 'DNA ov t1', 29, 2, 11, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, 2, '2011-05-31 00:00:00', 'c', 19, '1', 'A', NULL, NULL, 1, 25, '2011-10-19 14:06:04'),
(26, '338819231', 'DNA ov t2', 29, 2, 11, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, 2, '2011-05-31 00:00:00', 'c', 19, '1', 'B', NULL, NULL, 1, 26, '2011-10-19 14:06:05'),
(27, '338811921', 'DNA ov t3', 29, 2, 11, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, 2, '2011-05-31 00:00:00', 'c', 19, '1', 'C', NULL, NULL, 1, 27, '2011-10-19 14:06:05'),
(28, '41122121', 'RNA ov1', 30, 2, 12, NULL, '1.00000', '1.00000', 'yes - available', '', NULL, NULL, '2011-10-05 04:10:00', 'c', 19, '4', 'A', NULL, NULL, 1, 28, '2011-10-19 14:07:16'),
(29, '4124111', 'RNA ov2', 30, 2, 12, NULL, '1.00000', '1.00000', 'yes - available', '', NULL, NULL, '2011-10-05 04:10:00', 'c', 19, '4', 'A', NULL, NULL, 1, 29, '2011-10-19 14:07:17'),
(30, '41312', 'RNA ov3', 30, 2, 12, NULL, '1.00000', '1.00000', 'yes - available', '', NULL, NULL, '2011-10-05 04:10:00', 'c', 19, '4', 'A', NULL, NULL, 1, 30, '2011-10-19 14:07:18'),
(31, '89030', 'ARNA1', 31, 2, 13, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-29 04:12:00', 'c', 18, '1', 'A', NULL, NULL, 1, 31, '2011-10-19 14:09:03'),
(6, '6345345435', 'pl 1', 16, 1, 4, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:13:00', 'c', 19, '7', 'A', NULL, NULL, 1, 32, '2011-10-19 14:33:44'),
(27, '338811921', 'DNA ov t3', 29, 2, 11, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, 2, '2011-05-31 00:00:00', 'c', 19, '2', 'B', NULL, NULL, 1, 33, '2011-10-19 14:33:44'),
(28, '41122121', 'RNA ov1', 30, 2, 12, NULL, '1.00000', '1.00000', 'yes - available', '', NULL, NULL, '2011-10-05 04:10:00', 'c', 19, '6', 'A', NULL, NULL, 1, 34, '2011-10-19 14:33:45'),
(29, '4124111', 'RNA ov2', 30, 2, 12, NULL, '1.00000', '1.00000', 'yes - available', '', NULL, NULL, '2011-10-05 04:10:00', 'c', 19, '5', 'A', NULL, NULL, 1, 35, '2011-10-19 14:33:45'),
(6, '6345345435', 'pl 1', 16, 1, 4, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:13:00', 'c', 19, '1', 'A', NULL, NULL, 1, 36, '2011-10-19 14:35:31'),
(25, '338819221', 'DNA ov t1', 29, 2, 11, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, 2, '2011-05-31 00:00:00', 'c', 10, '3', '1', NULL, NULL, 1, 37, '2011-10-19 14:35:32'),
(26, '338819231', 'DNA ov t2', 29, 2, 11, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, 2, '2011-05-31 00:00:00', 'c', 10, '2', '1', NULL, NULL, 1, 38, '2011-10-19 14:35:32'),
(27, '338811921', 'DNA ov t3', 29, 2, 11, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, 2, '2011-05-31 00:00:00', 'c', 10, '1', '1', NULL, NULL, 1, 39, '2011-10-19 14:35:32'),
(6, '6345345435', 'pl 1', 16, 1, 4, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:13:00', 'c', 12, '4', 'A', NULL, NULL, 1, 40, '2011-10-19 14:36:34'),
(7, '634534531', 'pl 2', 16, 1, 4, NULL, '3.70000', '3.70000', 'yes - available', '', NULL, NULL, '2011-05-28 13:13:00', 'c', 12, '5', 'A', NULL, NULL, 1, 41, '2011-10-19 14:36:34'),
(8, '63453454335', 'pl 3', 16, 1, 4, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:13:00', 'c', 12, '6', 'A', NULL, NULL, 1, 42, '2011-10-19 14:36:34'),
(12, 'e12123124', 'Pax 1', 3, 1, 6, NULL, '4.00000', '4.00000', 'yes - available', '', NULL, NULL, '2011-05-28 12:57:00', 'c', 12, '3', 'A', NULL, NULL, 1, 43, '2011-10-19 14:36:35'),
(13, 'e121233124', 'Pax 2', 3, 1, 6, NULL, '4.00000', '4.00000', 'yes - available', '', NULL, NULL, '2011-05-28 12:57:00', 'c', 12, '2', 'A', NULL, NULL, 1, 44, '2011-10-19 14:36:35'),
(28, '41122121', 'RNA ov1', 30, 2, 12, NULL, '1.00000', '1.00000', 'yes - available', '', NULL, NULL, '2011-10-05 04:10:00', 'c', 19, '1', 'A', NULL, NULL, 1, 45, '2011-10-19 14:36:36'),
(29, '4124111', 'RNA ov2', 30, 2, 12, NULL, '1.00000', '1.00000', 'yes - available', '', NULL, NULL, '2011-10-05 04:10:00', 'c', 19, '2', 'A', NULL, NULL, 1, 46, '2011-10-19 14:36:36'),
(30, '41312', 'RNA ov3', 30, 2, 12, NULL, '1.00000', '1.00000', 'yes - available', '', NULL, NULL, '2011-10-05 04:10:00', 'c', 19, '3', 'A', NULL, NULL, 1, 47, '2011-10-19 14:36:36'),
(16, '76745645', 'asc 1', 2, 2, 7, NULL, '31.00000', '31.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:11:00', 'c', 21, '1', '', NULL, NULL, 1, 48, '2011-10-19 14:39:11'),
(2, '73991', 'bc2', 36, 1, 2, NULL, '7.30000', '7.30000', 'yes - available', '', NULL, 1, '2011-05-28 13:18:00', 'c', 11, '3', 'A', NULL, NULL, 1, 49, '2011-10-19 14:42:22'),
(16, '76745645', 'asc 1', 2, 2, 7, NULL, '31.00000', '31.00000', 'yes - available', '', NULL, NULL, '2011-05-28 13:11:00', 'c', 21, '2', 'A', NULL, NULL, 1, 50, '2011-10-19 14:42:22'),
(18, '8902134', 'asc c1', 12, 2, 8, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-05 16:06:00', 'c', 21, '1', 'A', NULL, NULL, 1, 51, '2011-10-19 14:42:23'),
(22, '432324234', 'ov t1', 1, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-05-28 16:07:00', 'c', 21, '3', 'A', NULL, NULL, 1, 52, '2011-10-19 14:42:23'),
(32, '413212', 'asc 1.1', 2, 3, 14, NULL, '3.40000', '3.40000', 'yes - available', '', NULL, 2, '2011-10-02 09:09:00', 'c', 21, '3', 'A', NULL, NULL, 1, 53, '2011-10-19 14:49:35'),
(33, '413211', 'asc 1.2', 2, 3, 14, NULL, '3.40000', '3.40000', 'yes - available', '', NULL, 2, '2011-10-02 09:09:00', 'c', 21, '3', 'B', NULL, NULL, 1, 54, '2011-10-19 14:49:36'),
(34, '432213', 'asc c 1.1', 12, 3, 15, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 2, '2011-10-19 09:05:00', 'c', 21, '4', 'A', NULL, NULL, 1, 55, '2011-10-19 14:51:09'),
(35, '4322313', 'asc c 1.2', 12, 3, 15, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 2, '2011-10-19 09:05:00', 'c', 21, '4', 'A', NULL, NULL, 1, 56, '2011-10-19 14:51:09'),
(36, '4322331', 'asc c 1.3', 12, 3, 15, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 2, '2011-10-19 09:05:00', 'c', 21, '4', 'A', NULL, NULL, 1, 57, '2011-10-19 14:51:10'),
(37, '4322333', 'asc c 1.4', 12, 3, 15, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 2, '2011-10-19 09:05:00', 'c', 21, '4', 'A', NULL, NULL, 1, 58, '2011-10-19 14:51:10'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 59, '2011-10-19 14:52:30'),
(39, '4121321', 'bck oct 2', 9, 3, 16, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'B', NULL, NULL, 1, 60, '2011-10-19 14:52:31'),
(40, '4121121', 'bck oct 3', 9, 3, 16, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'C', NULL, NULL, 1, 61, '2011-10-19 14:52:31'),
(41, '311212', 'tis tub 2', 1, 3, 16, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-02 10:09:00', 'c', 21, '5', 'E', NULL, NULL, 1, 62, '2011-10-19 14:53:02'),
(42, '89003', 'sl 9843', 10, 3, 16, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-02 10:09:00', 'c', NULL, '', '', NULL, NULL, 1, 63, '2011-10-19 14:53:16'),
(43, '42131223', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-10-01 00:00:00', 'c', 9, '11', '', NULL, NULL, 1, 64, '2011-10-19 14:54:36'),
(44, '42131123', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-10-01 00:00:00', 'c', 9, '12', '', NULL, NULL, 1, 65, '2011-10-19 14:54:36'),
(45, '42133123', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-10-01 00:00:00', 'c', 9, '13', '', NULL, NULL, 1, 66, '2011-10-19 14:54:37'),
(46, '4112213', 't RNA 2', 30, 3, 19, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-10-12 00:00:00', 'c', 18, '6', 'E', NULL, NULL, 1, 67, '2011-10-19 14:55:51'),
(47, '41122213', 't RNA 22', 30, 3, 19, NULL, '2.00000', '2.00000', 'yes - available', '', NULL, NULL, '2011-10-12 00:00:00', 'c', 18, '6', 'C', NULL, NULL, 1, 68, '2011-10-19 14:55:52'),
(48, '41123411', 't RNA 23', 30, 3, 19, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-10-12 00:00:00', 'c', 18, '6', 'A', NULL, NULL, 1, 69, '2011-10-19 14:55:52'),
(49, '5674467', 'A RNA 2', 31, 3, 20, NULL, NULL, NULL, 'yes - available', 'empty', NULL, NULL, '2011-10-27 00:00:00', 'c', 19, '', '', NULL, NULL, 1, 70, '2011-10-19 14:56:52'),
(50, '5234234', 'U189', 4, 4, 21, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-02 08:09:00', 'c', NULL, '', '', NULL, NULL, 1, 71, '2011-10-19 14:58:28'),
(51, '32234324324', 'RNA TCC 9843', 30, 5, 25, NULL, '3.40000', '3.40000', 'yes - available', '', NULL, NULL, '2011-10-29 00:00:00', 'c', 19, '7', 'A', NULL, NULL, 1, 72, '2011-10-19 15:13:38'),
(52, '778920', 'TT OCT1', 9, 5, 23, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-05 09:07:00', 'c', 21, '9', 'A', NULL, NULL, 1, 73, '2011-10-19 15:17:39'),
(19, '52342525', 'ov oct 1', 9, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, 1, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, 1, 74, '2011-10-19 16:58:05'),
(19, '52342525', 'ov oct 1', 9, 2, 9, NULL, NULL, NULL, 'yes - available', '', 1, 1, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, 1, 75, '2011-10-19 16:58:06'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', 'on loan', NULL, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 76, '2011-10-19 16:58:06'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', 'on loan', 1, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 77, '2011-10-19 16:58:07'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', 'on loan', 0, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 78, '2011-10-19 16:59:40'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', '', 0, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 79, '2011-10-19 17:00:39'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', '', 1, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 80, '2011-10-19 17:00:39'),
(19, '52342525', 'ov oct 1', 9, 2, 9, NULL, NULL, NULL, 'yes - available', '', 0, 1, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, 1, 81, '2011-10-19 17:07:47'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', '', 0, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 82, '2011-10-19 17:08:02'),
(20, '53234324', 'ov oct 2', 9, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, 1, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, 1, 83, '2011-10-19 17:10:37'),
(20, '53234324', 'ov oct 2', 9, 2, 9, NULL, NULL, NULL, 'yes - available', '', 1, 1, '2011-05-28 13:07:00', 'c', NULL, '', '', NULL, NULL, 1, 84, '2011-10-19 17:10:38'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', '', 0, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 85, '2011-10-19 17:10:38'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', '', 1, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 86, '2011-10-19 17:10:39'),
(24, '235324324432', 'sl9846', 10, 2, 9, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-01 00:00:00', 'd', NULL, '', '', NULL, '', 1, 87, '2011-10-19 17:12:02'),
(30, '41312', 'RNA ov3', 30, 2, 12, NULL, '1.00000', '1.00000', 'no', 'empty', NULL, NULL, '2011-10-05 04:10:00', 'c', NULL, '', '', NULL, NULL, 1, 88, '2011-10-19 17:24:32'),
(30, '41312', 'RNA ov3', 30, 2, 12, NULL, '1.00000', '0.00000', 'no', 'empty', 1, NULL, '2011-10-05 04:10:00', 'c', NULL, '', '', NULL, NULL, 1, 89, '2011-10-19 17:24:33'),
(48, '41123411', 't RNA 23', 30, 3, 19, NULL, '3.00000', '3.00000', 'yes - available', 'on loan', NULL, NULL, '2011-10-12 00:00:00', 'c', 18, '6', 'A', NULL, NULL, 1, 90, '2011-10-19 17:24:33'),
(48, '41123411', 't RNA 23', 30, 3, 19, NULL, '3.00000', '1.70000', 'yes - available', 'on loan', 1, NULL, '2011-10-12 00:00:00', 'c', 18, '6', 'A', NULL, NULL, 1, 91, '2011-10-19 17:24:34'),
(51, '32234324324', 'RNA TCC 9843', 30, 5, 25, NULL, '3.40000', '3.40000', 'yes - not available', 'reserved for order', NULL, NULL, '2011-10-29 00:00:00', 'c', 19, '7', 'A', NULL, NULL, 1, 92, '2011-10-19 17:41:16'),
(46, '4112213', 't RNA 2', 30, 3, 19, NULL, '3.00000', '3.00000', 'yes - not available', 'reserved for order', NULL, NULL, '2011-10-12 00:00:00', 'c', 18, '6', 'E', NULL, NULL, 1, 93, '2011-10-19 17:41:16'),
(29, '4124111', 'RNA ov2', 30, 2, 12, NULL, '1.00000', '1.00000', 'yes - not available', 'reserved for order', NULL, NULL, '2011-10-05 04:10:00', 'c', 19, '2', 'A', NULL, NULL, 1, 94, '2011-10-19 17:41:17'),
(51, '32234324324', 'RNA TCC 9843', 30, 5, 25, NULL, '3.40000', '3.40000', 'no', 'shipped', NULL, NULL, '2011-10-29 00:00:00', 'c', NULL, '', '', NULL, NULL, 1, 95, '2011-10-19 17:43:46'),
(51, '32234324324', 'RNA TCC 9843', 30, 5, 25, NULL, '3.40000', '3.40000', 'no', 'shipped', 1, NULL, '2011-10-29 00:00:00', 'c', NULL, '', '', NULL, NULL, 1, 96, '2011-10-19 17:43:47'),
(29, '4124111', 'RNA ov2', 30, 2, 12, NULL, '1.00000', '1.00000', 'no', 'shipped', NULL, NULL, '2011-10-05 04:10:00', 'c', NULL, '', '', NULL, NULL, 1, 97, '2011-10-19 17:43:48'),
(29, '4124111', 'RNA ov2', 30, 2, 12, NULL, '1.00000', '1.00000', 'no', 'shipped', 1, NULL, '2011-10-05 04:10:00', 'c', NULL, '', '', NULL, NULL, 1, 98, '2011-10-19 17:43:48'),
(46, '4112213', 't RNA 2', 30, 3, 19, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-10-12 00:00:00', 'c', 18, '6', 'E', NULL, NULL, 1, 99, '2011-10-19 17:44:32'),
(28, '41122121', 'RNA ov1', 30, 2, 12, NULL, '1.00000', '1.00000', 'yes - available', 'reserved for study', NULL, NULL, '2011-10-05 04:10:00', 'c', 19, '1', 'A', NULL, NULL, 1, 100, '2011-10-19 18:24:21'),
(53, '41231231414.1', 'RNA ov1.1', 30, 2, 12, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 1, '2011-12-01 08:09:00', 'c', 19, '4', 'A', NULL, NULL, 1, 101, '2011-10-19 18:24:22'),
(54, '41231231414.2', 'RNA ov1.2', 30, 2, 12, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 1, '2011-12-01 08:09:00', 'c', 19, '4', 'B', NULL, NULL, 1, 102, '2011-10-19 18:24:22'),
(28, '41122121', 'RNA ov1', 30, 2, 12, NULL, '1.00000', '0.40000', 'yes - available', 'reserved for study', 2, NULL, '2011-10-05 04:10:00', 'c', 19, '1', 'A', NULL, NULL, 1, 103, '2011-10-19 18:24:23'),
(46, '4112213', 't RNA 2', 30, 3, 19, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, NULL, '2011-10-12 00:00:00', 'c', 18, '6', 'E', NULL, NULL, 1, 104, '2011-10-19 18:24:23'),
(55, '4112213.1', 't RNA 2.1', 30, 3, 19, NULL, '3.00000', '3.00000', 'yes - available', '', NULL, 1, '2011-12-01 08:09:00', 'c', 19, '4', 'C', NULL, NULL, 1, 105, '2011-10-19 18:24:24'),
(46, '4112213', 't RNA 2', 30, 3, 19, NULL, '3.00000', '2.70000', 'yes - available', '', 1, NULL, '2011-10-12 00:00:00', 'c', 18, '6', 'E', NULL, NULL, 1, 106, '2011-10-19 18:24:24'),
(28, '41122121', 'RNA ov1', 30, 2, 12, NULL, '1.00000', '0.40000', 'yes - available', 'reserved for study', 2, 1, '2011-10-05 04:10:00', 'c', 19, '1', 'A', NULL, '', 1, 107, '2011-10-19 18:25:41'),
(28, '41122121', 'RNA ov1', 30, 2, 12, NULL, '1.00000', '0.40000', 'yes - available', '', 2, 1, '2011-10-05 04:10:00', 'c', 19, '1', 'A', NULL, '', 1, 108, '2011-10-19 18:42:40'),
(28, '41122121', 'RNA ov1', 30, 2, 12, NULL, '1.00000', '0.17000', 'yes - available', '', 3, 1, '2011-10-05 04:10:00', 'c', 19, '1', 'A', NULL, '', 1, 109, '2011-10-19 18:42:40'),
(46, '4112213', 't RNA 2', 30, 3, 19, NULL, '3.00000', '2.70000', 'yes - available', '', 1, NULL, '2011-10-12 00:00:00', 'c', NULL, '', '', NULL, NULL, 1, 110, '2011-10-19 18:42:40'),
(46, '4112213', 't RNA 2', 30, 3, 19, NULL, '3.00000', '0.17000', 'yes - available', '', 3, NULL, '2011-10-12 00:00:00', 'c', NULL, '', '', NULL, NULL, 1, 111, '2011-10-19 18:42:41'),
(46, '4112213', 't RNA 2', 30, 3, 19, NULL, '3.00000', '0.40000', 'yes - available', '', 2, NULL, '2011-10-12 00:00:00', 'c', NULL, '', '', NULL, NULL, 1, 112, '2011-10-19 18:45:42'),
(24, '235324324432', 'sl9846', 10, 2, 9, NULL, NULL, NULL, 'yes - available', 'on loan', NULL, NULL, '2011-10-01 00:00:00', 'd', NULL, '', '', NULL, '', 1, 113, '2011-10-20 13:26:01'),
(24, '235324324432', 'sl9846', 10, 2, 9, NULL, NULL, NULL, 'yes - available', 'on loan', 1, NULL, '2011-10-01 00:00:00', 'd', NULL, '', '', NULL, '', 1, 114, '2011-10-20 13:26:01'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', '', 1, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 115, '2011-10-20 13:28:35'),
(40, '4121121', 'bck oct 3', 9, 3, 16, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'C', NULL, NULL, 1, 116, '2011-10-20 13:28:35'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', '', 3, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 117, '2011-10-20 13:28:36'),
(40, '4121121', 'bck oct 3', 9, 3, 16, NULL, NULL, NULL, 'yes - available', '', 1, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'C', NULL, NULL, 1, 118, '2011-10-20 13:28:36'),
(38, '41222', 'bck oct 1', 9, 3, 16, 1, NULL, NULL, 'yes - available', '', 2, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'A', NULL, NULL, 1, 119, '2011-10-20 13:29:17'),
(25, '338819221', 'DNA ov t1', 29, 2, 11, NULL, '12.00000', '12.00000', 'yes - available', '', NULL, 2, '2011-05-31 00:00:00', 'c', 10, '3', '1', NULL, NULL, 1, 120, '2011-10-20 13:32:53'),
(44, '42131123', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '3.00000', 'no', 'lost', NULL, NULL, '2011-10-01 00:00:00', 'c', 9, '12', '', NULL, NULL, 1, 121, '2011-10-20 13:32:53'),
(25, '338819221', 'DNA ov t1', 29, 2, 11, NULL, '12.00000', '9.70000', 'yes - available', '', 1, 2, '2011-05-31 00:00:00', 'c', 10, '3', '1', NULL, NULL, 1, 122, '2011-10-20 13:32:53'),
(44, '42131123', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '1.30000', 'no', 'lost', 1, NULL, '2011-10-01 00:00:00', 'c', 9, '12', '', NULL, NULL, 1, 123, '2011-10-20 13:32:53'),
(45, '42133123', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '3.00000', 'no', '', NULL, NULL, '2011-10-01 00:00:00', 'c', NULL, '', '', NULL, NULL, 1, 124, '2011-10-20 13:43:36'),
(45, '42133123', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '3.00000', 'no', '', 1, NULL, '2011-10-01 00:00:00', 'c', NULL, '', '', NULL, NULL, 1, 125, '2011-10-20 13:43:37'),
(27, '338811921', 'DNA ov t3', 29, 2, 11, NULL, '12.00000', '12.00000', 'yes - not available', 'on loan', NULL, 2, '2011-05-31 00:00:00', 'c', 10, '1', '1', NULL, NULL, 1, 126, '2011-10-20 13:45:21'),
(27, '338811921', 'DNA ov t3', 29, 2, 11, NULL, '12.00000', '12.00000', 'yes - not available', 'on loan', 1, 2, '2011-05-31 00:00:00', 'c', 10, '1', '1', NULL, NULL, 1, 127, '2011-10-20 13:45:22'),
(26, '338819231', 'DNA ov t2', 29, 2, 11, NULL, '12.00000', '10.80000', 'yes - available', '', 1, 2, '2011-05-31 00:00:00', 'c', 10, '2', '1', NULL, NULL, 1, 128, '2011-10-20 14:26:29'),
(26, '338819231', 'DNA ov t2', 29, 2, 11, NULL, '12.00000', '10.80000', 'no', '', 1, 2, '2011-05-31 00:00:00', 'c', NULL, '', '', NULL, NULL, 1, 129, '2011-10-20 14:28:37'),
(26, '338819231', 'DNA ov t2', 29, 2, 11, NULL, '12.00000', '7.20000', 'no', '', 2, 2, '2011-05-31 00:00:00', 'c', NULL, '', '', NULL, NULL, 1, 130, '2011-10-20 14:28:38'),
(5, '7454564', 'bc.dna 2', 29, 1, 3, NULL, '5.00000', '5.00000', 'yes - available', '', NULL, 1, '2011-10-05 11:07:00', 'c', 9, '2', '', NULL, NULL, 1, 131, '2011-10-20 15:00:23'),
(43, '42131223', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '3.00000', 'no', '', NULL, NULL, '2011-10-01 00:00:00', 'c', NULL, '', '', NULL, NULL, 1, 132, '2011-10-20 15:00:23'),
(5, '7454564', 'bc.dna 2', 29, 1, 3, NULL, '5.00000', '3.70000', 'yes - available', '', 1, 1, '2011-10-05 11:07:00', 'c', 9, '2', '', NULL, NULL, 1, 133, '2011-10-20 15:00:24'),
(43, '42131223', 'Tis DNA 8.3', 29, 3, 18, NULL, '3.00000', '0.30000', 'no', '', 1, NULL, '2011-10-01 00:00:00', 'c', NULL, '', '', NULL, NULL, 1, 134, '2011-10-20 15:00:24'),
(25, '338819221', 'DNA ov t1', 29, 2, 11, NULL, '12.00000', '9.70000', 'yes - available', '', 1, 2, '2011-05-31 00:00:00', 'c', 10, '3', '1', NULL, NULL, 1, 135, '2011-10-20 15:04:17'),
(25, '338819221', 'DNA ov t1', 29, 2, 11, NULL, '12.00000', '9.70000', 'yes - available', '', 2, 2, '2011-05-31 00:00:00', 'c', 10, '3', '1', NULL, NULL, 1, 136, '2011-10-20 15:04:18'),
(40, '4121121', 'bck oct 3', 9, 3, 16, NULL, NULL, NULL, 'yes - not available', 'reserved for order', 1, NULL, '2011-10-02 10:09:00', 'c', 21, '4', 'C', NULL, NULL, 1, 137, '2011-10-20 15:13:43'),
(52, '778920', 'TT OCT1', 9, 5, 23, NULL, NULL, NULL, 'yes - not available', 'reserved for order', NULL, NULL, '2011-10-05 09:07:00', 'c', 21, '9', 'A', NULL, NULL, 1, 138, '2011-10-20 15:13:44'),
(42, '89003', 'sl 9843', 10, 3, 16, NULL, NULL, NULL, 'yes - available', '', 1, NULL, '2011-10-02 10:09:00', 'c', NULL, '', '', NULL, NULL, 1, 139, '2011-10-20 15:17:28'),
(42, '89003', 'sl 9843', 10, 3, 16, NULL, NULL, NULL, 'yes - available', '', 2, NULL, '2011-10-02 10:09:00', 'c', NULL, '', '', NULL, NULL, 1, 140, '2011-10-20 15:28:29'),
(42, '89003', 'sl 9843', 10, 3, 16, NULL, NULL, NULL, 'yes - available', '', 1, NULL, '2011-10-02 10:09:00', 'c', NULL, '', '', NULL, NULL, 1, 141, '2011-10-20 15:28:42'),
(42, '89003', 'sl 9843', 10, 3, 16, NULL, NULL, NULL, 'yes - available', '', 2, NULL, '2011-10-02 10:09:00', 'c', NULL, '', '', NULL, NULL, 1, 142, '2011-10-20 15:29:09'),
(42, '89003', 'sl 9843', 10, 3, 16, NULL, NULL, NULL, 'yes - available', '', 1, NULL, '2011-10-02 10:09:00', 'c', NULL, '', '', NULL, NULL, 1, 143, '2011-10-20 15:29:25');

--
-- Dumping data for table `aliquot_review_masters`
--

INSERT INTO `aliquot_review_masters` (`id`, `aliquot_review_control_id`, `specimen_review_master_id`, `aliquot_master_id`, `review_code`, `basis_of_specimen_review`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 1, 42, '78994.1', 'y', '2011-10-20 15:17:24', 1, '2011-10-20 15:17:24', 1, 0),
(2, 1, 4, 42, 'to del ar', '', '2011-10-20 15:28:27', 1, '2011-10-20 15:28:41', 1, 1),
(3, 1, 4, 42, 'to del ar2', '', '2011-10-20 15:29:08', 1, '2011-10-20 15:29:24', 1, 1);

--
-- Dumping data for table `aliquot_review_masters_revs`
--

INSERT INTO `aliquot_review_masters_revs` (`id`, `aliquot_review_control_id`, `specimen_review_master_id`, `aliquot_master_id`, `review_code`, `basis_of_specimen_review`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, 1, 42, '78994.1', 'y', 1, 1, '2011-10-20 15:17:24'),
(2, 1, 4, 42, 'to del ar', '', 1, 2, '2011-10-20 15:28:28'),
(2, 1, 4, 42, 'to del ar', '', 1, 3, '2011-10-20 15:28:41'),
(3, 1, 4, 42, 'to del ar2', '', 1, 4, '2011-10-20 15:29:08'),
(3, 1, 4, 42, 'to del ar2', '', 1, 5, '2011-10-20 15:29:24');

--
-- Dumping data for table `ar_breast_tissue_slides`
--

INSERT INTO `ar_breast_tissue_slides` (`id`, `aliquot_review_master_id`, `type`, `length`, `width`, `invasive_percentage`, `in_situ_percentage`, `normal_percentage`, `stroma_percentage`, `necrosis_inv_percentage`, `necrosis_is_percentage`, `inflammation`, `quality_score`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 'tumor', '4.0', NULL, '45.0', '23.0', '24.0', NULL, NULL, NULL, 2, 2, '2011-10-20 15:17:24', 1, '2011-10-20 15:17:24', 1, 0),
(2, 2, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2011-10-20 15:28:28', 1, '2011-10-20 15:28:41', 1, 1),
(3, 3, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2011-10-20 15:29:08', 1, '2011-10-20 15:29:23', 1, 1);

--
-- Dumping data for table `ar_breast_tissue_slides_revs`
--

INSERT INTO `ar_breast_tissue_slides_revs` (`id`, `aliquot_review_master_id`, `type`, `length`, `width`, `invasive_percentage`, `in_situ_percentage`, `normal_percentage`, `stroma_percentage`, `necrosis_inv_percentage`, `necrosis_is_percentage`, `inflammation`, `quality_score`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, 'tumor', '4.0', NULL, '45.0', '23.0', '24.0', NULL, NULL, NULL, 2, 2, 1, 1, '2011-10-20 15:17:24'),
(2, 2, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 2, '2011-10-20 15:28:28'),
(2, 2, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 3, '2011-10-20 15:28:41'),
(3, 3, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 4, '2011-10-20 15:29:08'),
(3, 3, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 5, '2011-10-20 15:29:24');

--
-- Dumping data for table `atim_information`
--


--
-- Dumping data for table `banks`
--

TRUNCATE `banks`;
INSERT INTO `banks` (`id`, `name`, `description`, `misc_identifier_control_id`, `created_by`, `created`, `modified_by`, `modified`, `deleted`) VALUES
(1, 'Breast Bank', '', NULL, 0, '2001-01-01 00:00:00', 1, '2011-10-19 02:02:13', 0),
(2, 'Ovary Bank', '', NULL, 1, '2011-10-19 02:02:32', 1, '2011-10-19 02:02:32', 0);

--
-- Dumping data for table `banks_revs`
--

INSERT INTO `banks_revs` (`id`, `name`, `description`, `misc_identifier_control_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'Breast Bank', '', NULL, 1, 1, '2011-10-19 02:02:13'),
(2, 'Ovary Bank', '', NULL, 1, 2, '2011-10-19 02:02:32');

--
-- Dumping data for table `cake_sessions`
--


--
-- Dumping data for table `cd_nationals`
--

INSERT INTO `cd_nationals` (`id`, `consent_master_id`, `deleted`) VALUES
(1, 1, 0),
(2, 2, 0),
(3, 3, 0);

--
-- Dumping data for table `cd_nationals_revs`
--

INSERT INTO `cd_nationals_revs` (`id`, `consent_master_id`, `version_id`, `version_created`) VALUES
(1, 1, 1, '2011-10-19 02:14:33'),
(2, 2, 2, '2011-10-19 02:46:05'),
(3, 3, 3, '2011-10-19 02:50:07');

--
-- Dumping data for table `clinical_collection_links`
--

INSERT INTO `clinical_collection_links` (`id`, `participant_id`, `collection_id`, `diagnosis_master_id`, `consent_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 3, 1, 11, 3, '2011-10-19 13:27:12', 1, '2011-10-19 13:27:12', 1, 0),
(2, 3, 2, 11, 3, '2011-10-19 13:40:45', 1, '2011-10-19 13:40:45', 1, 0),
(3, 2, 3, 9, 2, '2011-10-19 14:47:26', 1, '2011-10-19 14:47:26', 1, 0),
(4, 2, 4, 9, 2, '2011-10-19 14:57:33', 1, '2011-10-19 14:57:33', 1, 0),
(5, 1, 5, NULL, 1, '2011-10-19 15:00:50', 1, '2011-10-19 15:00:50', 1, 0);

--
-- Dumping data for table `clinical_collection_links_revs`
--

INSERT INTO `clinical_collection_links_revs` (`id`, `participant_id`, `collection_id`, `diagnosis_master_id`, `consent_master_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 3, NULL, 11, 3, 1, 1, '2011-10-19 13:27:12'),
(1, 3, 1, 11, 3, 1, 2, '2011-10-19 13:27:44'),
(2, 3, 2, 11, 3, 1, 3, '2011-10-19 13:40:45'),
(3, 2, NULL, 9, 2, 1, 4, '2011-10-19 14:47:26'),
(3, 2, 3, 9, 2, 1, 5, '2011-10-19 14:48:01'),
(4, 2, 4, 9, 2, 1, 6, '2011-10-19 14:57:33'),
(5, 1, NULL, NULL, 1, 1, 7, '2011-10-19 15:00:50'),
(5, 1, 5, NULL, 1, 1, 8, '2011-10-19 15:01:12');

--
-- Dumping data for table `coding_adverse_events`
--


--
-- Dumping data for table `coding_adverse_events_revs`
--


--
-- Dumping data for table `collections`
--

INSERT INTO `collections` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'OV-1', 2, 'surgery room', '2011-05-28 10:07:00', 'c', 1, 'participant collection', '', '2011-10-19 13:27:44', 1, '2011-10-19 13:27:44', 1, 0),
(2, 'OV-1', 2, 'surgery room', '2011-05-28 10:07:00', 'c', 1, 'participant collection', '', '2011-10-19 13:40:45', 1, '2011-10-19 13:40:45', 1, 0),
(3, 'OV-2', 2, 'surgery room', '2011-10-02 07:09:00', 'c', 1, 'participant collection', '', '2011-10-19 14:48:01', 1, '2011-10-19 14:48:01', 1, 0),
(4, 'OV-2', 2, 'surgery room', '2011-10-02 08:09:00', 'c', 1, 'participant collection', '', '2011-10-19 14:57:33', 1, '2011-10-19 14:57:33', 1, 0),
(5, 'TT.894', 1, 'surgery room', '2011-10-05 09:00:00', 'c', NULL, 'participant collection', '', '2011-10-19 15:01:12', 1, '2011-10-19 15:01:12', 1, 0);

--
-- Dumping data for table `collections_revs`
--

INSERT INTO `collections_revs` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'OV-1', 2, 'surgery room', '2011-05-28 10:07:00', 'c', 1, 'participant collection', '', 1, 1, '2011-10-19 13:27:44'),
(2, 'OV-1', 2, 'surgery room', '2011-05-28 10:07:00', 'c', 1, 'participant collection', '', 1, 2, '2011-10-19 13:40:45'),
(3, 'OV-2', 2, 'surgery room', '2011-10-02 07:09:00', 'c', 1, 'participant collection', '', 1, 3, '2011-10-19 14:48:01'),
(4, 'OV-2', 2, 'surgery room', '2011-10-02 08:09:00', 'c', 1, 'participant collection', '', 1, 4, '2011-10-19 14:57:33'),
(5, 'TT.894', 1, 'surgery room', '2011-10-05 09:00:00', 'c', NULL, 'participant collection', '', 1, 5, '2011-10-19 15:01:12');

--
-- Dumping data for table `consent_masters`
--

INSERT INTO `consent_masters` (`id`, `date_of_referral`, `date_of_referral_accuracy`, `route_of_referral`, `date_first_contact`, `date_first_contact_accuracy`, `consent_signed_date`, `consent_signed_date_accuracy`, `form_version`, `reason_denied`, `consent_status`, `process_status`, `status_date`, `status_date_accuracy`, `surgeon`, `operation_date`, `operation_date_accuracy`, `facility`, `notes`, `consent_method`, `translator_indicator`, `translator_signature`, `consent_person`, `facility_other`, `acquisition_id`, `participant_id`, `consent_control_id`, `type`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, '2009-03-01', 'c', 'doctor', NULL, '', '2009-03-27', 'c', 'v3', '', 'obtained', '', '2009-03-27', 'c', 'Dr Alban', '2009-03-01 00:00:00', 'h', '', '', 'in person', 'n', '', '', '', NULL, 1, 1, '', '2011-10-19 02:14:33', 1, '2011-10-19 02:14:33', 1, 0),
(2, NULL, '', '', NULL, '', NULL, '', '', '', 'obtained', '', NULL, '', '', NULL, '', '', '', '', '', '', '', '', NULL, 2, 1, '', '2011-10-19 02:46:05', 1, '2011-10-19 02:46:05', 1, 0),
(3, NULL, '', '', NULL, '', NULL, '', '', '', 'pending', '', '2011-06-09', 'c', '', NULL, '', '', '', '', '', '', '', '', NULL, 3, 1, '', '2011-10-19 02:50:06', 1, '2011-10-19 02:50:06', 1, 0);

--
-- Dumping data for table `consent_masters_revs`
--

INSERT INTO `consent_masters_revs` (`id`, `date_of_referral`, `date_of_referral_accuracy`, `route_of_referral`, `date_first_contact`, `date_first_contact_accuracy`, `consent_signed_date`, `consent_signed_date_accuracy`, `form_version`, `reason_denied`, `consent_status`, `process_status`, `status_date`, `status_date_accuracy`, `surgeon`, `operation_date`, `operation_date_accuracy`, `facility`, `notes`, `consent_method`, `translator_indicator`, `translator_signature`, `consent_person`, `facility_other`, `acquisition_id`, `participant_id`, `consent_control_id`, `type`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '2009-03-01', 'c', 'doctor', NULL, '', '2009-03-27', 'c', 'v3', '', 'obtained', '', '2009-03-27', 'c', 'Dr Alban', '2009-03-01 00:00:00', 'h', '', '', 'in person', 'n', '', '', '', NULL, 1, 1, '', 1, 1, '2011-10-19 02:14:33'),
(2, NULL, '', '', NULL, '', NULL, '', '', '', 'obtained', '', NULL, '', '', NULL, '', '', '', '', '', '', '', '', NULL, 2, 1, '', 1, 2, '2011-10-19 02:46:05'),
(3, NULL, '', '', NULL, '', NULL, '', '', '', 'pending', '', '2011-06-09', 'c', '', NULL, '', '', '', '', '', '', '', '', NULL, 3, 1, '', 1, 3, '2011-10-19 02:50:07');

--
-- Dumping data for table `datamart_adhoc`
--


--
-- Dumping data for table `datamart_adhoc_favourites`
--


--
-- Dumping data for table `datamart_adhoc_permissions`
--


--
-- Dumping data for table `datamart_adhoc_saved`
--


--
-- Dumping data for table `datamart_batch_ids`
--

INSERT INTO `datamart_batch_ids` (`id`, `set_id`, `lookup_id`) VALUES
(1, 1, 10),
(2, 1, 8),
(3, 2, 28),
(4, 2, 46);

--
-- Dumping data for table `datamart_batch_sets`
--

INSERT INTO `datamart_batch_sets` (`id`, `user_id`, `group_id`, `sharing_status`, `title`, `description`, `datamart_structure_id`, `datamart_adhoc_id`, `locked`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(1, 1, 1, 'user', '2011-10-19 15:30', NULL, 9, NULL, 0, '2011-10-19 15:30:47', 1, '2011-10-19 15:30:47', 1),
(2, 1, 1, 'user', '2011-10-19 17:55', NULL, 1, NULL, 0, '2011-10-19 17:55:20', 1, '2011-10-19 17:55:20', 1);

--
-- Dumping data for table `datamart_browsing_indexes`
--

INSERT INTO `datamart_browsing_indexes` (`id`, `root_node_id`, `notes`, `temporary`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, NULL, 0, '2011-10-19 15:27:01', 1, '2011-10-19 15:27:01', 1, 0),
(2, 4, NULL, 1, '2011-10-19 15:31:30', 1, '2011-10-20 15:46:51', 1, 1),
(3, 11, NULL, 1, '2011-10-19 17:18:24', 1, '2011-10-19 17:18:24', 1, 0),
(4, 13, NULL, 1, '2011-10-19 17:32:02', 1, '2011-10-19 17:32:02', 1, 0),
(5, 17, NULL, 0, '2011-10-19 18:19:21', 1, '2011-10-19 18:19:21', 1, 0),
(6, 18, NULL, 1, '2011-10-20 13:27:00', 1, '2011-10-20 13:27:00', 1, 0),
(7, 23, NULL, 1, '2011-10-20 14:37:23', 1, '2011-10-20 14:37:23', 1, 0),
(8, 31, NULL, 1, '2011-10-20 15:10:59', 1, '2011-10-20 15:10:59', 1, 0),
(9, 37, NULL, 1, '2011-10-20 15:47:25', 1, '2011-10-20 15:47:25', 1, 0);

--
-- Dumping data for table `datamart_browsing_indexes_revs`
--

INSERT INTO `datamart_browsing_indexes_revs` (`id`, `root_node_id`, `notes`, `temporary`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, NULL, 1, 1, 1, '2011-10-19 15:27:01'),
(2, 4, NULL, 1, 1, 2, '2011-10-19 15:31:30'),
(1, 1, NULL, 0, 1, 3, '2011-10-19 16:43:19'),
(3, 11, NULL, 1, 1, 4, '2011-10-19 17:18:24'),
(4, 13, NULL, 1, 1, 5, '2011-10-19 17:32:02'),
(5, 17, NULL, 1, 1, 6, '2011-10-19 18:19:21'),
(5, 17, NULL, 0, 1, 7, '2011-10-19 18:26:27'),
(6, 18, NULL, 1, 1, 8, '2011-10-20 13:27:00'),
(7, 23, NULL, 1, 1, 9, '2011-10-20 14:37:23'),
(8, 31, NULL, 1, 1, 10, '2011-10-20 15:10:59'),
(2, 4, NULL, 1, 1, 11, '2011-10-20 15:46:51'),
(9, 37, NULL, 1, 1, 12, '2011-10-20 15:47:25');

--
-- Dumping data for table `datamart_browsing_results`
--

INSERT INTO `datamart_browsing_results` (`id`, `user_id`, `parent_node_id`, `browsing_structures_id`, `browsing_structures_sub_id`, `raw`, `serialized_search_params`, `id_csv`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 0, 8, 1, 1, 'a:2:{s:17:"search_conditions";a:1:{s:32:"ConsentMaster.consent_control_id";s:1:"1";}s:12:"exact_search";b:0;}', '1,2,3', '2011-10-19 15:27:01', 1, '2011-10-19 15:27:01', 1, 0),
(2, 1, 1, 4, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '1,2,3', '2011-10-19 15:27:58', 1, '2011-10-19 15:27:58', 1, 0),
(3, 1, 2, 9, 0, 1, 'a:2:{s:17:"search_conditions";a:2:{s:25:"DiagnosisControl.category";a:1:{i:0;s:7:"primary";}s:30:"DiagnosisControl.controls_type";a:1:{i:0;s:6:"tissue";}}s:12:"exact_search";b:0;}', '5,8,10', '2011-10-19 15:28:13', 1, '2011-10-19 15:28:13', 1, 0),
(4, 1, 0, 9, 0, 1, NULL, '8,10', '2011-10-19 15:31:30', 1, '2011-10-19 15:31:30', 1, 0),
(5, 1, 4, 4, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '2,3', '2011-10-19 15:36:18', 1, '2011-10-19 15:36:18', 1, 0),
(6, 1, 5, 2, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '1,2,3,4', '2011-10-19 15:36:18', 1, '2011-10-19 15:36:18', 1, 0),
(7, 1, 6, 5, 3, 1, 'a:2:{s:17:"search_conditions";a:1:{s:30:"SampleMaster.sample_control_id";s:1:"3";}s:12:"exact_search";b:0;}', '9,10,16,17', '2011-10-19 15:36:34', 1, '2011-10-19 15:36:34', 1, 0),
(8, 1, 7, 1, 9, 1, 'a:2:{s:17:"search_conditions";a:3:{s:22:"AliquotMaster.in_stock";a:1:{i:0;s:15:"yes - available";}s:24:"AliquotDetail.block_type";a:1:{i:0;s:3:"OCT";}s:32:"AliquotMaster.aliquot_control_id";s:1:"9";}s:12:"exact_search";b:0;}', '19,20,38,39,40', '2011-10-19 15:36:58', 1, '2011-10-19 15:36:58', 1, 0),
(9, 1, 7, 5, 3, 0, NULL, '10,17', '2011-10-19 15:37:47', 1, '2011-10-19 15:37:47', 1, 0),
(10, 1, 6, 5, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21', '2011-10-19 17:05:50', 1, '2011-10-19 17:05:50', 1, 0),
(11, 1, 0, 5, 0, 1, 'a:2:{s:17:"search_conditions";a:1:{s:28:"ViewSample.sample_control_id";a:2:{i:0;s:2:"12";i:1;s:2:"13";}}s:12:"exact_search";b:0;}', '3,11,12,18,19,25', '2011-10-19 17:18:24', 1, '2011-10-19 17:18:24', 1, 0),
(12, 1, 11, 1, 0, 1, 'a:2:{s:17:"search_conditions";a:1:{s:24:"ViewAliquot.aliquot_type";a:1:{i:0;s:4:"tube";}}s:12:"exact_search";b:0;}', '4,5,25,26,27,28,29,30,43,44,45,46,47,48,51', '2011-10-19 17:18:48', 1, '2011-10-19 17:18:48', 1, 0),
(13, 1, 0, 5, 13, 1, 'a:2:{s:17:"search_conditions";a:1:{s:30:"SampleMaster.sample_control_id";s:2:"13";}s:12:"exact_search";b:0;}', '12,19,25', '2011-10-19 17:32:02', 1, '2011-10-19 17:32:02', 1, 0),
(14, 1, 13, 1, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '28,29,30,46,47,48,51', '2011-10-19 17:32:22', 1, '2011-10-19 17:32:22', 1, 0),
(15, 1, 14, 5, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '12,19,25', '2011-10-19 17:33:31', 1, '2011-10-19 17:33:31', 1, 0),
(16, 1, 15, 2, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '2,3,5', '2011-10-19 17:33:31', 1, '2011-10-19 17:33:31', 1, 0),
(17, 1, 0, 1, 0, 1, 'a:2:{s:17:"search_conditions";a:1:{i:0;s:79:"(ViewAliquot.barcode LIKE ''%41122121%'' OR ViewAliquot.barcode LIKE ''%4112213%'')";}s:12:"exact_search";b:0;}', '28,46', '2011-10-19 18:19:21', 1, '2011-10-19 18:19:21', 1, 0),
(18, 1, 0, 1, 0, 1, 'a:2:{s:17:"search_conditions";a:2:{s:29:"ViewAliquot.sample_control_id";a:1:{i:0;s:1:"3";}s:24:"ViewAliquot.aliquot_type";a:1:{i:0;s:5:"block";}}s:12:"exact_search";b:0;}', '19,20,21,38,39,40,52', '2011-10-20 13:27:00', 1, '2011-10-20 13:27:00', 1, 0),
(19, 1, 18, 5, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '9,16,23', '2011-10-20 13:29:41', 1, '2011-10-20 13:29:41', 1, 0),
(20, 1, 19, 2, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '2,3,5', '2011-10-20 13:29:42', 1, '2011-10-20 13:29:42', 1, 0),
(21, 1, 20, 5, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '7,8,9,10,11,12,13,14,15,16,17,18,19,20,23,24,25,26,27,28', '2011-10-20 13:29:55', 1, '2011-10-20 13:29:55', 1, 0),
(22, 1, 21, 1, 0, 1, 'a:2:{s:17:"search_conditions";a:1:{s:29:"ViewAliquot.sample_control_id";a:1:{i:0;s:2:"12";}}s:12:"exact_search";b:0;}', '25,26,27,43,44,45', '2011-10-20 13:30:05', 1, '2011-10-20 13:30:05', 1, 0),
(23, 1, 0, 5, 12, 1, 'a:2:{s:17:"search_conditions";a:1:{s:30:"SampleMaster.sample_control_id";s:2:"12";}s:12:"exact_search";b:0;}', '3,11,18', '2011-10-20 14:37:23', 1, '2011-10-20 14:37:23', 1, 0),
(24, 1, 23, 5, 12, 0, NULL, '18', '2011-10-20 14:37:45', 1, '2011-10-20 14:37:45', 1, 0),
(25, 1, 24, 1, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '43,44,45', '2011-10-20 14:37:45', 1, '2011-10-20 14:37:45', 1, 0),
(26, 1, 25, 5, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '18', '2011-10-20 14:38:00', 1, '2011-10-20 14:38:00', 1, 0),
(27, 1, 26, 2, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '3', '2011-10-20 14:38:14', 1, '2011-10-20 14:38:14', 1, 0),
(28, 1, 23, 1, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '4,5,25,26,27,43,44,45', '2011-10-20 14:39:49', 1, '2011-10-20 14:39:49', 1, 0),
(29, 1, 28, 5, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '3,11,18', '2011-10-20 14:40:10', 1, '2011-10-20 14:40:10', 1, 0),
(30, 1, 29, 2, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '1,2,3', '2011-10-20 14:40:11', 1, '2011-10-20 14:40:11', 1, 0),
(31, 1, 0, 8, 1, 1, 'a:2:{s:17:"search_conditions";a:2:{s:28:"ConsentMaster.consent_status";a:1:{i:0;s:8:"obtained";}s:32:"ConsentMaster.consent_control_id";s:1:"1";}s:12:"exact_search";b:0;}', '1,2', '2011-10-20 15:10:59', 1, '2011-10-20 15:10:59', 1, 0),
(32, 1, 31, 4, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '1,2', '2011-10-20 15:11:12', 1, '2011-10-20 15:11:12', 1, 0),
(33, 1, 32, 2, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '3,4,5', '2011-10-20 15:11:12', 1, '2011-10-20 15:11:12', 1, 0),
(34, 1, 33, 5, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '14,15,16,17,18,19,20,21,23,24,25,27,28', '2011-10-20 15:11:12', 1, '2011-10-20 15:11:12', 1, 0),
(35, 1, 33, 5, 3, 1, 'a:2:{s:17:"search_conditions";a:1:{s:30:"SampleMaster.sample_control_id";s:1:"3";}s:12:"exact_search";b:0;}', '16,17,23', '2011-10-20 15:11:47', 1, '2011-10-20 15:11:47', 1, 0),
(36, 1, 35, 1, 9, 1, 'a:2:{s:17:"search_conditions";a:2:{s:22:"AliquotMaster.in_stock";a:1:{i:0;s:15:"yes - available";}s:32:"AliquotMaster.aliquot_control_id";s:1:"9";}s:12:"exact_search";b:0;}', '38,39,40,52', '2011-10-20 15:12:10', 1, '2011-10-20 15:12:10', 1, 0),
(37, 1, 0, 9, 2, 1, 'a:2:{s:17:"search_conditions";a:2:{s:25:"DiagnosisMaster.dx_nature";a:1:{i:0;s:9:"malignant";}s:36:"DiagnosisMaster.diagnosis_control_id";s:1:"2";}s:12:"exact_search";b:0;}', '5,8,10', '2011-10-20 15:47:25', 1, '2011-10-20 15:47:25', 1, 0),
(38, 1, 37, 4, 0, 1, 'a:2:{s:17:"search_conditions";a:0:{}s:12:"exact_search";b:0;}', '1,2,3', '2011-10-20 15:47:43', 1, '2011-10-20 15:47:43', 1, 0),
(39, 1, 38, 8, 1, 1, 'a:2:{s:17:"search_conditions";a:2:{s:28:"ConsentMaster.consent_status";a:1:{i:0;s:8:"obtained";}s:32:"ConsentMaster.consent_control_id";s:1:"1";}s:12:"exact_search";b:0;}', '1,2', '2011-10-20 15:47:52', 1, '2011-10-20 15:47:52', 1, 0);

--
-- Dumping data for table `derivative_details`
--

INSERT INTO `derivative_details` (`id`, `sample_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `lab_book_master_id`, `sync_with_lab_book`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `creation_datetime_accuracy`) VALUES
(1, 2, 'floor4-lab', 'buzz lightyear', '2011-05-28 13:13:00', NULL, 0, '2011-10-19 13:30:56', 1, '2011-10-19 13:30:56', 1, 0, 'c'),
(2, 3, 'floor4-lab', 'shrek', '2011-10-05 04:09:00', NULL, 0, '2011-10-19 13:33:11', 1, '2011-10-19 13:33:11', 1, 0, 'c'),
(3, 4, 'floor4-lab', 'buzz lightyear', '2011-05-28 13:13:00', NULL, 0, '2011-10-19 13:34:39', 1, '2011-10-19 13:34:39', 1, 0, 'c'),
(4, 5, 'floor4-lab', 'buzz lightyear', '2011-05-28 12:13:00', NULL, 0, '2011-10-19 13:36:23', 1, '2011-10-19 13:36:23', 1, 0, 'c'),
(5, 8, 'ctrnet', 'buzz lightyear', '2011-10-05 16:06:00', NULL, 0, '2011-10-19 13:42:41', 1, '2011-10-19 13:42:41', 1, 0, 'c'),
(6, 11, 'ctrnet', 'buzz lightyear', '2011-05-31 00:00:00', NULL, 0, '2011-10-19 14:05:08', 1, '2011-10-19 14:05:08', 1, 0, 'h'),
(7, 12, 'ctrnet', 'shrek', '2011-10-05 04:10:00', NULL, 0, '2011-10-19 14:06:20', 1, '2011-10-19 14:06:20', 1, 0, 'c'),
(8, 13, '', 'shrek', '2011-10-29 04:12:00', NULL, 0, '2011-10-19 14:07:45', 1, '2011-10-19 14:07:45', 1, 0, 'c'),
(9, 15, '', 'shrek', '2011-10-19 08:05:00', NULL, 0, '2011-10-19 14:49:52', 1, '2011-10-19 14:49:52', 1, 0, 'c'),
(10, 18, '', 'buzz lightyear', '2011-10-01 00:00:00', NULL, 0, '2011-10-19 14:53:41', 1, '2011-10-19 14:53:41', 1, 0, 'd'),
(11, 19, '', '', '2011-10-12 00:00:00', NULL, 0, '2011-10-19 14:54:44', 1, '2011-10-19 14:54:44', 1, 0, 'h'),
(12, 20, 'ctrnet', 'buzz lightyear', '2011-10-27 00:00:00', NULL, 0, '2011-10-19 14:56:18', 1, '2011-10-19 14:56:18', 1, 0, 'h'),
(13, 24, '', 'buzz lightyear', '2011-10-27 00:00:00', NULL, 0, '2011-10-19 15:10:30', 1, '2011-10-19 15:10:30', 1, 0, 'h'),
(14, 25, '', 'buzz lightyear', '2011-10-29 00:00:00', NULL, 0, '2011-10-19 15:10:39', 1, '2011-10-19 15:10:39', 1, 0, 'h'),
(15, 26, 'ctrnet', 'buzz lightyear', '2012-01-02 18:29:00', NULL, NULL, '2011-10-19 18:42:36', 1, '2011-10-19 18:42:36', 1, 0, 'c'),
(16, 27, 'ctrnet', 'buzz lightyear', '2012-01-02 18:29:00', NULL, NULL, '2011-10-19 18:42:38', 1, '2011-10-19 18:42:38', 1, 0, 'c'),
(17, 28, 'ctrnet', 'buzz lightyear', '2012-01-02 18:29:00', NULL, NULL, '2011-10-19 18:42:39', 1, '2011-10-19 18:42:39', 1, 0, 'c');

--
-- Dumping data for table `derivative_details_revs`
--

INSERT INTO `derivative_details_revs` (`id`, `sample_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `lab_book_master_id`, `sync_with_lab_book`, `modified_by`, `version_id`, `version_created`, `creation_datetime_accuracy`) VALUES
(1, 2, 'floor4-lab', 'buzz lightyear', '2011-05-28 13:13:00', NULL, 0, 1, 1, '2011-10-19 13:30:56', 'c'),
(2, 3, 'floor4-lab', 'shrek', '2011-10-05 04:09:00', NULL, 0, 1, 2, '2011-10-19 13:33:11', 'c'),
(3, 4, 'floor4-lab', 'buzz lightyear', '2011-05-28 13:13:00', NULL, 0, 1, 3, '2011-10-19 13:34:39', 'c'),
(4, 5, 'floor4-lab', 'buzz lightyear', '2011-05-28 12:13:00', NULL, 0, 1, 4, '2011-10-19 13:36:23', 'c'),
(5, 8, 'ctrnet', 'buzz lightyear', '2011-10-05 16:06:00', NULL, 0, 1, 5, '2011-10-19 13:42:41', 'c'),
(6, 11, 'ctrnet', 'buzz lightyear', '2011-05-31 00:00:00', NULL, 0, 1, 6, '2011-10-19 14:05:08', 'h'),
(7, 12, 'ctrnet', 'shrek', '2011-10-05 04:10:00', NULL, 0, 1, 7, '2011-10-19 14:06:20', 'c'),
(8, 13, '', 'shrek', '2011-10-29 04:12:00', NULL, 0, 1, 8, '2011-10-19 14:07:45', 'c'),
(9, 15, '', 'shrek', '2011-10-19 08:05:00', NULL, 0, 1, 9, '2011-10-19 14:49:52', 'c'),
(10, 18, '', 'buzz lightyear', '2011-10-01 00:00:00', NULL, 0, 1, 10, '2011-10-19 14:53:41', 'd'),
(11, 19, '', '', '2011-10-12 00:00:00', NULL, 0, 1, 11, '2011-10-19 14:54:44', 'h'),
(12, 20, 'ctrnet', 'buzz lightyear', '2011-10-27 00:00:00', NULL, 0, 1, 12, '2011-10-19 14:56:18', 'h'),
(13, 24, '', 'buzz lightyear', '2011-10-27 00:00:00', NULL, 0, 1, 13, '2011-10-19 15:10:30', 'h'),
(14, 25, '', 'buzz lightyear', '2011-10-29 00:00:00', NULL, 0, 1, 14, '2011-10-19 15:10:39', 'h'),
(15, 26, 'ctrnet', 'buzz lightyear', '2012-01-02 18:29:00', NULL, NULL, 1, 15, '2011-10-19 18:42:37', 'c'),
(16, 27, 'ctrnet', 'buzz lightyear', '2012-01-02 18:29:00', NULL, NULL, 1, 16, '2011-10-19 18:42:38', 'c'),
(17, 28, 'ctrnet', 'buzz lightyear', '2012-01-02 18:29:00', NULL, NULL, 1, 17, '2011-10-19 18:42:39', 'c');

--
-- Dumping data for table `diagnosis_masters`
--

INSERT INTO `diagnosis_masters` (`id`, `primary_id`, `parent_id`, `dx_method`, `dx_nature`, `dx_date`, `dx_date_accuracy`, `tumor_size_greatest_dimension`, `additional_dimension_a`, `additional_dimension_b`, `tumor_size_cannot_be_determined`, `icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `morphology`, `topography`, `tumour_grade`, `tumour_grade_specify`, `age_at_dx`, `age_at_dx_precision`, `ajcc_edition`, `collaborative_staged`, `clinical_tstage`, `clinical_nstage`, `clinical_mstage`, `clinical_stage_summary`, `path_tnm_descriptor_m`, `path_tnm_descriptor_r`, `path_tnm_descriptor_y`, `path_tstage`, `path_nstage`, `path_nstage_nbr_node_examined`, `path_nstage_nbr_node_involved`, `path_mstage`, `path_mstage_metastasis_site_specify`, `path_stage_summary`, `survival_time_months`, `information_source`, `notes`, `diagnosis_control_id`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, 0, 'C80', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 15, 1, '2011-10-19 02:14:54', 1, '2011-10-19 02:14:54', 1, 0),
(2, 1, 1, 'radiology', NULL, '2010-02-18', 'c', NULL, NULL, NULL, 0, 'D057', NULL, NULL, '85413', 'C504', NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 'path report', '', 16, 1, '2011-10-19 02:16:30', 1, '2011-10-19 02:16:30', 1, 0),
(3, 1, 2, NULL, NULL, '2010-08-01', 'd', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 18, 1, '2011-10-19 02:17:03', 1, '2011-10-19 02:17:03', 1, 0),
(4, 1, 2, NULL, NULL, '2011-01-01', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 1, '2011-10-19 02:17:32', 1, '2011-10-19 02:17:32', 1, 0),
(5, 5, NULL, 'surgical', 'malignant', '1997-01-01', 'y', NULL, NULL, NULL, 0, 'N833', NULL, NULL, '86700', 'C569', '', NULL, NULL, '', '5th', '', '', '', '', '', '', '', '', '1a', '0', 0, 0, '1', NULL, 'IV', NULL, 'path report', '', 2, 1, '2011-10-19 02:23:11', 1, '2011-10-19 02:23:11', 1, 0),
(6, 5, 5, NULL, NULL, '1998-01-01', 'y', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 1, '2011-10-19 02:23:48', 1, '2011-10-19 02:23:48', 1, 0),
(7, 5, 5, NULL, NULL, '2001-10-02', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 19, 1, '2011-10-19 02:24:09', 1, '2011-10-19 02:24:09', 1, 0),
(8, 8, NULL, 'cytology', 'malignant', '2006-10-01', 'd', NULL, NULL, NULL, 0, 'C508', NULL, NULL, '', '', '', NULL, NULL, '', '', '', '', '', '', '2', '', '', '', '', '', 0, 0, '', NULL, '1a', NULL, '', '', 2, 2, '2011-10-19 02:44:54', 1, '2011-10-19 02:44:54', 1, 0),
(9, 8, 8, NULL, NULL, '2011-02-10', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 18, 2, '2011-10-19 02:45:40', 1, '2011-10-19 02:45:40', 1, 0),
(10, 10, NULL, '', 'malignant', '2011-03-05', 'c', NULL, NULL, NULL, 0, 'C502', NULL, NULL, '', 'C506', '', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 3, '2011-10-19 02:50:49', 1, '2011-10-19 02:50:50', 1, 0),
(11, 10, 10, NULL, NULL, '2011-05-23', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 18, 3, '2011-10-19 02:51:12', 1, '2011-10-19 02:51:12', 1, 0),
(12, 10, 10, NULL, NULL, '2011-07-23', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 18, 3, '2011-10-19 02:51:17', 1, '2011-10-19 02:51:17', 1, 0);

--
-- Dumping data for table `diagnosis_masters_revs`
--

INSERT INTO `diagnosis_masters_revs` (`id`, `primary_id`, `parent_id`, `dx_method`, `dx_nature`, `dx_date`, `dx_date_accuracy`, `tumor_size_greatest_dimension`, `additional_dimension_a`, `additional_dimension_b`, `tumor_size_cannot_be_determined`, `icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `morphology`, `topography`, `tumour_grade`, `tumour_grade_specify`, `age_at_dx`, `age_at_dx_precision`, `ajcc_edition`, `collaborative_staged`, `clinical_tstage`, `clinical_nstage`, `clinical_mstage`, `clinical_stage_summary`, `path_tnm_descriptor_m`, `path_tnm_descriptor_r`, `path_tnm_descriptor_y`, `path_tstage`, `path_nstage`, `path_nstage_nbr_node_examined`, `path_nstage_nbr_node_involved`, `path_mstage`, `path_mstage_metastasis_site_specify`, `path_stage_summary`, `survival_time_months`, `information_source`, `notes`, `diagnosis_control_id`, `participant_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, 0, 'C80', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 15, 1, 1, 1, '2011-10-19 02:14:54'),
(1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, 0, 'C80', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 15, 1, 1, 2, '2011-10-19 02:14:54'),
(2, 1, 1, 'radiology', NULL, '2010-02-18', 'c', NULL, NULL, NULL, 0, 'D057', NULL, NULL, '85413', 'C504', NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, 'path report', '', 16, 1, 1, 3, '2011-10-19 02:16:31'),
(3, 1, 2, NULL, NULL, '2010-08-01', 'd', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 18, 1, 1, 4, '2011-10-19 02:17:03'),
(4, 1, 2, NULL, NULL, '2011-01-01', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 1, 1, 5, '2011-10-19 02:17:32'),
(5, NULL, NULL, 'surgical', 'malignant', '1997-01-01', 'y', NULL, NULL, NULL, 0, 'N833', NULL, NULL, '86700', 'C569', '', NULL, NULL, '', '5th', '', '', '', '', '', '', '', '', '1a', '0', 0, 0, '1', NULL, 'IV', NULL, 'path report', '', 2, 1, 1, 6, '2011-10-19 02:23:11'),
(5, 5, NULL, 'surgical', 'malignant', '1997-01-01', 'y', NULL, NULL, NULL, 0, 'N833', NULL, NULL, '86700', 'C569', '', NULL, NULL, '', '5th', '', '', '', '', '', '', '', '', '1a', '0', 0, 0, '1', NULL, 'IV', NULL, 'path report', '', 2, 1, 1, 7, '2011-10-19 02:23:12'),
(6, 5, 5, NULL, NULL, '1998-01-01', 'y', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 17, 1, 1, 8, '2011-10-19 02:23:48'),
(7, 5, 5, NULL, NULL, '2001-10-02', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 19, 1, 1, 9, '2011-10-19 02:24:09'),
(8, NULL, NULL, 'cytology', 'malignant', '2006-10-01', 'd', NULL, NULL, NULL, 0, 'C508', NULL, NULL, '', '', '', NULL, NULL, '', '', '', '', '', '', '2', '', '', '', '', '', 0, 0, '', NULL, '1a', NULL, '', '', 2, 2, 1, 10, '2011-10-19 02:44:54'),
(8, 8, NULL, 'cytology', 'malignant', '2006-10-01', 'd', NULL, NULL, NULL, 0, 'C508', NULL, NULL, '', '', '', NULL, NULL, '', '', '', '', '', '', '2', '', '', '', '', '', 0, 0, '', NULL, '1a', NULL, '', '', 2, 2, 1, 11, '2011-10-19 02:44:54'),
(9, 8, 8, NULL, NULL, '2011-02-10', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 18, 2, 1, 12, '2011-10-19 02:45:40'),
(10, NULL, NULL, '', 'malignant', '2011-03-05', 'c', NULL, NULL, NULL, 0, 'C502', NULL, NULL, '', 'C506', '', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 3, 1, 13, '2011-10-19 02:50:50'),
(10, 10, NULL, '', 'malignant', '2011-03-05', 'c', NULL, NULL, NULL, 0, 'C502', NULL, NULL, '', 'C506', '', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 3, 1, 14, '2011-10-19 02:50:50'),
(11, 10, 10, NULL, NULL, '2011-05-23', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 18, 3, 1, 15, '2011-10-19 02:51:12'),
(12, 10, 10, NULL, NULL, '2011-07-23', 'c', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, '', 18, 3, 1, 16, '2011-10-19 02:51:17');

--
-- Dumping data for table `drugs`
--

INSERT INTO `drugs` (`id`, `generic_name`, `trade_name`, `type`, `description`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'Taxol', '', 'chemotherapy', '', '2011-10-19 02:25:41', 1, '2011-10-19 02:25:41', 1, 0),
(2, 'Taxotere', '', 'chemotherapy', '', '2011-10-19 02:25:47', 1, '2011-10-19 02:25:47', 1, 0),
(3, 'Morphine', '', 'other', '', '2011-10-19 02:26:10', 1, '2011-10-19 02:26:10', 1, 0);

--
-- Dumping data for table `drugs_revs`
--

INSERT INTO `drugs_revs` (`id`, `generic_name`, `trade_name`, `type`, `description`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'Taxol', '', 'chemotherapy', '', 1, 1, '2011-10-19 02:25:41'),
(2, 'Taxotere', '', 'chemotherapy', '', 1, 2, '2011-10-19 02:25:48'),
(3, 'Morphine', '', 'other', '', 1, 3, '2011-10-19 02:26:10');

--
-- Dumping data for table `dxd_bloods`
--


--
-- Dumping data for table `dxd_bloods_revs`
--


--
-- Dumping data for table `dxd_primaries`
--

INSERT INTO `dxd_primaries` (`id`, `diagnosis_master_id`, `deleted`) VALUES
(1, 1, 0);

--
-- Dumping data for table `dxd_primaries_revs`
--

INSERT INTO `dxd_primaries_revs` (`id`, `diagnosis_master_id`, `deleted`, `version_id`, `version_created`) VALUES
(1, 1, 0, 1, '2011-10-19 02:14:54');

--
-- Dumping data for table `dxd_progressions`
--

INSERT INTO `dxd_progressions` (`id`, `diagnosis_master_id`, `deleted`) VALUES
(1, 3, 0),
(2, 9, 0),
(3, 11, 0),
(4, 12, 0);

--
-- Dumping data for table `dxd_progressions_revs`
--

INSERT INTO `dxd_progressions_revs` (`id`, `diagnosis_master_id`, `deleted`, `version_id`, `version_created`) VALUES
(1, 3, 0, 1, '2011-10-19 02:17:03'),
(2, 9, 0, 2, '2011-10-19 02:45:40'),
(3, 11, 0, 3, '2011-10-19 02:51:12'),
(4, 12, 0, 4, '2011-10-19 02:51:17');

--
-- Dumping data for table `dxd_recurrences`
--

INSERT INTO `dxd_recurrences` (`id`, `diagnosis_master_id`, `deleted`) VALUES
(1, 7, 0);

--
-- Dumping data for table `dxd_recurrences_revs`
--

INSERT INTO `dxd_recurrences_revs` (`id`, `diagnosis_master_id`, `deleted`, `version_id`, `version_created`) VALUES
(1, 7, 0, 1, '2011-10-19 02:24:09');

--
-- Dumping data for table `dxd_remissions`
--

INSERT INTO `dxd_remissions` (`id`, `diagnosis_master_id`, `deleted`) VALUES
(1, 4, 0),
(2, 6, 0);

--
-- Dumping data for table `dxd_remissions_revs`
--

INSERT INTO `dxd_remissions_revs` (`id`, `diagnosis_master_id`, `deleted`, `version_id`, `version_created`) VALUES
(1, 4, 0, 1, '2011-10-19 02:17:32'),
(2, 6, 0, 2, '2011-10-19 02:23:48');

--
-- Dumping data for table `dxd_secondaries`
--

INSERT INTO `dxd_secondaries` (`id`, `diagnosis_master_id`, `deleted`) VALUES
(1, 2, 0);

--
-- Dumping data for table `dxd_secondaries_revs`
--

INSERT INTO `dxd_secondaries_revs` (`id`, `diagnosis_master_id`, `deleted`, `version_id`, `version_created`) VALUES
(1, 2, 0, 1, '2011-10-19 02:16:31');

--
-- Dumping data for table `dxd_tissues`
--

INSERT INTO `dxd_tissues` (`id`, `diagnosis_master_id`, `laterality`, `deleted`) VALUES
(1, 5, 'right', 0),
(2, 8, 'unknown', 0),
(3, 10, '', 0);

--
-- Dumping data for table `dxd_tissues_revs`
--

INSERT INTO `dxd_tissues_revs` (`id`, `diagnosis_master_id`, `laterality`, `version_id`, `version_created`) VALUES
(1, 5, 'right', 1, '2011-10-19 02:23:11'),
(2, 8, 'unknown', 2, '2011-10-19 02:44:54'),
(3, 10, '', 3, '2011-10-19 02:50:50');

--
-- Dumping data for table `ed_all_adverse_events_adverse_events`
--


--
-- Dumping data for table `ed_all_adverse_events_adverse_events_revs`
--


--
-- Dumping data for table `ed_all_clinical_followups`
--

INSERT INTO `ed_all_clinical_followups` (`id`, `weight`, `recurrence_status`, `disease_status`, `vital_status`, `event_master_id`, `deleted`) VALUES
(1, NULL, '', '', 'alive and well with disease', 1, 0),
(2, NULL, '', '', 'alive', 3, 0);

--
-- Dumping data for table `ed_all_clinical_followups_revs`
--

INSERT INTO `ed_all_clinical_followups_revs` (`id`, `weight`, `recurrence_status`, `disease_status`, `vital_status`, `event_master_id`, `version_id`, `version_created`) VALUES
(1, NULL, '', '', 'alive and well with disease', 1, 1, '2011-10-19 02:39:29'),
(2, NULL, '', '', 'alive', 3, 2, '2011-10-19 02:52:04');

--
-- Dumping data for table `ed_all_clinical_presentations`
--


--
-- Dumping data for table `ed_all_clinical_presentations_revs`
--


--
-- Dumping data for table `ed_all_lifestyle_smokings`
--


--
-- Dumping data for table `ed_all_lifestyle_smokings_revs`
--


--
-- Dumping data for table `ed_all_protocol_followups`
--


--
-- Dumping data for table `ed_all_protocol_followups_revs`
--


--
-- Dumping data for table `ed_all_study_researches`
--


--
-- Dumping data for table `ed_all_study_researches_revs`
--


--
-- Dumping data for table `ed_breast_lab_pathologies`
--

INSERT INTO `ed_breast_lab_pathologies` (`id`, `path_number`, `report_type`, `facility`, `vascular_lymph_invasion`, `extra_nodal_invasion`, `blood_lymph`, `tumour_type`, `grade`, `multifocal`, `preneoplastic_changes`, `spread_skin_nipple`, `level_nodal_involvement`, `frozen_section`, `er_assay_ligand`, `pr_assay_ligand`, `progesterone`, `estrogen`, `number_resected`, `number_positive`, `nodal_status`, `resection_margins`, `tumour_size`, `tumour_total_size`, `sentinel_only`, `in_situ_type`, `her2_grade`, `her2_method`, `mb_collectionid`, `event_master_id`, `deleted`, `breast_tumour_size`) VALUES
(1, '#997123', '', '', 'positive', '', NULL, '', '3', 'yes', '', '', '', '', '', '', '', '', '', '', NULL, '', NULL, NULL, 'yes', '', '+2', 'ihc', NULL, 2, 0, '');

--
-- Dumping data for table `ed_breast_lab_pathologies_revs`
--

INSERT INTO `ed_breast_lab_pathologies_revs` (`id`, `path_number`, `report_type`, `facility`, `vascular_lymph_invasion`, `extra_nodal_invasion`, `blood_lymph`, `tumour_type`, `grade`, `multifocal`, `preneoplastic_changes`, `spread_skin_nipple`, `level_nodal_involvement`, `frozen_section`, `er_assay_ligand`, `pr_assay_ligand`, `progesterone`, `estrogen`, `number_resected`, `number_positive`, `nodal_status`, `resection_margins`, `tumour_size`, `tumour_total_size`, `sentinel_only`, `in_situ_type`, `her2_grade`, `her2_method`, `mb_collectionid`, `event_master_id`, `version_id`, `version_created`, `breast_tumour_size`) VALUES
(1, '#997123', '', '', 'positive', '', NULL, '', '3', 'yes', '', '', '', '', '', '', '', '', '', '', NULL, '', NULL, NULL, 'yes', '', '+2', 'ihc', NULL, 2, 1, '2011-10-19 02:40:57', '');

--
-- Dumping data for table `ed_breast_screening_mammograms`
--


--
-- Dumping data for table `ed_breast_screening_mammograms_revs`
--


--
-- Dumping data for table `ed_cap_report_ampullas`
--


--
-- Dumping data for table `ed_cap_report_ampullas_revs`
--


--
-- Dumping data for table `ed_cap_report_colon_biopsies`
--


--
-- Dumping data for table `ed_cap_report_colon_biopsies_revs`
--


--
-- Dumping data for table `ed_cap_report_colon_rectum_resections`
--


--
-- Dumping data for table `ed_cap_report_colon_rectum_resections_revs`
--


--
-- Dumping data for table `ed_cap_report_distalexbileducts`
--


--
-- Dumping data for table `ed_cap_report_distalexbileducts_revs`
--


--
-- Dumping data for table `ed_cap_report_gallbladders`
--


--
-- Dumping data for table `ed_cap_report_gallbladders_revs`
--


--
-- Dumping data for table `ed_cap_report_hepatocellular_carcinomas`
--


--
-- Dumping data for table `ed_cap_report_hepatocellular_carcinomas_revs`
--


--
-- Dumping data for table `ed_cap_report_intrahepbileducts`
--


--
-- Dumping data for table `ed_cap_report_intrahepbileducts_revs`
--


--
-- Dumping data for table `ed_cap_report_pancreasendos`
--


--
-- Dumping data for table `ed_cap_report_pancreasendos_revs`
--


--
-- Dumping data for table `ed_cap_report_pancreasexos`
--


--
-- Dumping data for table `ed_cap_report_pancreasexos_revs`
--


--
-- Dumping data for table `ed_cap_report_perihilarbileducts`
--


--
-- Dumping data for table `ed_cap_report_perihilarbileducts_revs`
--


--
-- Dumping data for table `ed_cap_report_smintestines`
--


--
-- Dumping data for table `ed_cap_report_smintestines_revs`
--


--
-- Dumping data for table `event_masters`
--

INSERT INTO `event_masters` (`id`, `event_control_id`, `event_status`, `event_summary`, `event_date`, `event_date_accuracy`, `information_source`, `urgency`, `date_required`, `date_required_accuracy`, `date_requested`, `date_requested_accuracy`, `reference_number`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`, `diagnosis_master_id`, `deleted`) VALUES
(1, 20, NULL, '', '2010-08-01', 'd', NULL, NULL, NULL, '', NULL, '', NULL, '2011-10-19 02:39:29', 1, '2011-10-19 02:39:29', 1, 1, NULL, 0),
(2, 18, NULL, '', '2010-02-18', 'c', NULL, NULL, NULL, '', NULL, '', NULL, '2011-10-19 02:40:56', 1, '2011-10-19 02:40:56', 1, 1, 2, 0),
(3, 20, NULL, '', '2011-05-03', 'c', NULL, NULL, NULL, '', NULL, '', NULL, '2011-10-19 02:52:04', 1, '2011-10-19 02:52:04', 1, 3, 11, 0);

--
-- Dumping data for table `event_masters_revs`
--

INSERT INTO `event_masters_revs` (`id`, `event_control_id`, `event_status`, `event_summary`, `event_date`, `event_date_accuracy`, `information_source`, `urgency`, `date_required`, `date_required_accuracy`, `date_requested`, `date_requested_accuracy`, `reference_number`, `modified_by`, `participant_id`, `diagnosis_master_id`, `version_id`, `version_created`) VALUES
(1, 20, NULL, '', '2010-08-01', 'd', NULL, NULL, NULL, '', NULL, '', NULL, 1, 1, NULL, 1, '2011-10-19 02:39:29'),
(2, 18, NULL, '', '2010-02-18', 'c', NULL, NULL, NULL, '', NULL, '', NULL, 1, 1, 2, 2, '2011-10-19 02:40:57'),
(3, 20, NULL, '', '2011-05-03', 'c', NULL, NULL, NULL, '', NULL, '', NULL, 1, 3, 11, 3, '2011-10-19 02:52:04');

--
-- Dumping data for table `family_histories`
--


--
-- Dumping data for table `family_histories_revs`
--


--
-- Dumping data for table `key_increments`
--

TRUNCATE `key_increments`;
INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('NoLaboCounter', 1350),
('part_ident_hospital_num', 1),
('part_ident_insurance_num', 1);

--
-- Dumping data for table `lab_book_masters`
--


--
-- Dumping data for table `lab_book_masters_revs`
--


--
-- Dumping data for table `langs`
--


--
-- Dumping data for table `lbd_dna_extractions`
--


--
-- Dumping data for table `lbd_dna_extractions_revs`
--


--
-- Dumping data for table `lbd_slide_creations`
--


--
-- Dumping data for table `lbd_slide_creations_revs`
--


--
-- Dumping data for table `materials`
--


--
-- Dumping data for table `materials_revs`
--


--
-- Dumping data for table `misc_identifiers`
--

INSERT INTO `misc_identifiers` (`id`, `identifier_value`, `misc_identifier_control_id`, `effective_date`, `effective_date_accuracy`, `expiry_date`, `expiry_date_accuracy`, `notes`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `tmp_deleted`) VALUES
(1, 'No-Labo-1347', 3, NULL, '', NULL, '', NULL, 1, '2011-10-19 02:41:13', 1, '2011-10-19 02:41:13', 1, 0, 0),
(2, '#5123', 2, NULL, '', NULL, '', '', 1, '2011-10-19 02:41:28', 1, '2011-10-19 02:41:28', 1, 0, 0),
(3, 'No-Labo-1348', 3, NULL, '', NULL, '', NULL, 3, '2011-10-19 02:55:25', 1, '2011-10-19 02:55:25', 1, 0, 0),
(4, 'AAA98293', 1, NULL, '', NULL, '', '', 3, '2011-10-19 12:53:43', 1, '2011-10-19 12:53:43', 1, 0, 0),
(5, '#878839', 2, NULL, '', NULL, '', '', 2, '2011-10-19 12:57:26', 1, '2011-10-19 12:57:26', 1, 0, 0),
(6, 'QTR478902', 1, NULL, '', NULL, '', '', 2, '2011-10-19 12:57:57', 1, '2011-10-19 12:57:57', 1, 0, 0),
(7, 'No-Labo-1349', 3, NULL, '', NULL, '', NULL, 2, '2011-10-19 12:58:14', 1, '2011-10-19 12:58:14', 1, 0, 0);

--
-- Dumping data for table `misc_identifiers_revs`
--

INSERT INTO `misc_identifiers_revs` (`id`, `identifier_value`, `misc_identifier_control_id`, `effective_date`, `effective_date_accuracy`, `expiry_date`, `expiry_date_accuracy`, `notes`, `participant_id`, `modified_by`, `version_id`, `version_created`, `tmp_deleted`) VALUES
(1, 'No-Labo-1347', 3, NULL, '', NULL, '', NULL, 1, 1, 1, '2011-10-19 02:41:13', 0),
(2, '#5123', 2, NULL, '', NULL, '', '', 1, 1, 2, '2011-10-19 02:41:28', 0),
(3, 'No-Labo-1348', 3, NULL, '', NULL, '', NULL, 3, 1, 3, '2011-10-19 02:55:26', 0),
(4, 'AAA98293', 1, NULL, '', NULL, '', '', 3, 1, 4, '2011-10-19 12:53:43', 0),
(5, '#878839', 2, NULL, '', NULL, '', '', 2, 1, 5, '2011-10-19 12:57:26', 0),
(6, 'QTR478902', 1, NULL, '', NULL, '', '', 2, 1, 6, '2011-10-19 12:57:57', 0),
(7, 'No-Labo-1349', 3, NULL, '', NULL, '', NULL, 2, 1, 7, '2011-10-19 12:58:14', 0);

--
-- Dumping data for table `misc_identifier_controls`
--

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`) VALUES
(1, 'health insurance card', 1, 0, '', '', 1, 1),
(2, 'hospital nbr', 1, 1, '', '', 0, 1),
(3, 'ovary bank no lab', 1, 3, 'NoLaboCounter', 'No-Labo-%%key_increment%%', 1, 1);

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `short_title`, `description`, `date_order_placed`, `date_order_placed_accuracy`, `date_order_completed`, `date_order_completed_accuracy`, `processing_status`, `comments`, `created`, `created_by`, `modified`, `modified_by`, `default_study_summary_id`, `deleted`) VALUES
(1, 'BC OVc', '', 'bla bla bla...', '2011-05-24', 'c', NULL, '', 'pending', '', '2011-10-19 13:01:45', 1, '2011-10-19 13:01:45', 1, 1, 0),
(2, 'Poiuy-Qwerty', '', '', NULL, '', NULL, '', 'planned', '', '2011-10-19 13:03:08', 1, '2011-10-19 13:03:33', 1, 1, 0);

--
-- Dumping data for table `orders_revs`
--

INSERT INTO `orders_revs` (`id`, `order_number`, `short_title`, `description`, `date_order_placed`, `date_order_placed_accuracy`, `date_order_completed`, `date_order_completed_accuracy`, `processing_status`, `comments`, `modified_by`, `default_study_summary_id`, `version_id`, `version_created`) VALUES
(1, 'BC OVc', '', 'bla bla bla...', '2011-05-24', 'c', NULL, '', 'pending', '', 1, 1, 1, '2011-10-19 13:01:46'),
(2, 'po', '', '', NULL, '', NULL, '', '', '', 1, NULL, 2, '2011-10-19 13:03:08'),
(2, 'Poiuy-Qwerty', '', '', NULL, '', NULL, '', 'planned', '', 1, 1, 3, '2011-10-19 13:03:33');

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `date_added`, `date_added_accuracy`, `added_by`, `status`, `created`, `created_by`, `modified`, `modified_by`, `order_line_id`, `shipment_id`, `aliquot_master_id`, `deleted`) VALUES
(1, '2011-11-01', 'd', 'shrek', 'shipped', '2011-10-19 17:41:15', 1, '2011-10-19 17:43:46', 1, 5, 1, 51, 0),
(2, '2011-11-01', 'd', 'shrek', 'pending', '2011-10-19 17:41:16', 1, '2011-10-19 17:44:31', 1, 5, NULL, 46, 1),
(3, '2011-11-01', 'd', 'shrek', 'shipped', '2011-10-19 17:41:16', 1, '2011-10-19 17:43:48', 1, 5, 1, 29, 0),
(4, '2011-10-31', 'c', 'shrek', 'pending', '2011-10-20 15:13:43', 1, '2011-10-20 15:13:43', 1, 4, NULL, 40, 0),
(5, '2011-10-31', 'c', 'shrek', 'pending', '2011-10-20 15:13:43', 1, '2011-10-20 15:13:43', 1, 4, NULL, 52, 0);

--
-- Dumping data for table `order_items_revs`
--

INSERT INTO `order_items_revs` (`id`, `date_added`, `date_added_accuracy`, `added_by`, `status`, `modified_by`, `order_line_id`, `shipment_id`, `aliquot_master_id`, `version_id`, `version_created`) VALUES
(1, '2011-11-01', 'd', 'shrek', 'pending', 1, 5, NULL, 51, 1, '2011-10-19 17:41:16'),
(2, '2011-11-01', 'd', 'shrek', 'pending', 1, 5, NULL, 46, 2, '2011-10-19 17:41:16'),
(3, '2011-11-01', 'd', 'shrek', 'pending', 1, 5, NULL, 29, 3, '2011-10-19 17:41:17'),
(1, '2011-11-01', 'd', 'shrek', 'shipped', 1, 5, 1, 51, 4, '2011-10-19 17:43:46'),
(3, '2011-11-01', 'd', 'shrek', 'shipped', 1, 5, 1, 29, 5, '2011-10-19 17:43:48'),
(2, '2011-11-01', 'd', 'shrek', 'pending', 1, 5, NULL, 46, 6, '2011-10-19 17:44:31'),
(4, '2011-10-31', 'c', 'shrek', 'pending', 1, 4, NULL, 40, 7, '2011-10-20 15:13:43'),
(5, '2011-10-31', 'c', 'shrek', 'pending', 1, 4, NULL, 52, 8, '2011-10-20 15:13:44');

--
-- Dumping data for table `order_lines`
--

INSERT INTO `order_lines` (`id`, `quantity_ordered`, `min_quantity_ordered`, `quantity_unit`, `date_required`, `date_required_accuracy`, `status`, `created`, `created_by`, `modified`, `modified_by`, `product_code`, `sample_control_id`, `aliquot_control_id`, `sample_aliquot_precision`, `order_id`, `study_summary_id`, `deleted`) VALUES
(1, '25', '25', 'ml', '2011-10-29', 'c', 'pending', '2011-10-19 13:02:31', 1, '2011-10-19 13:02:31', 1, '', 12, 29, '', 1, 1, 0),
(2, '3', '2', '', '2011-10-29', 'c', 'pending', '2011-10-19 13:02:49', 1, '2011-10-19 13:02:49', 1, '', 3, 9, 'OCT', 1, 1, 0),
(3, '4', '', '', NULL, '', 'pending', '2011-10-19 13:03:57', 1, '2011-10-19 13:03:57', 1, '', 3, 9, 'Paraf.', 2, 1, 0),
(4, '4', '', '', NULL, '', 'pending', '2011-10-19 13:04:05', 1, '2011-10-20 15:13:44', 1, '', 3, 9, 'Oct.', 2, 1, 0),
(5, '', '', '', NULL, '', 'shipped', '2011-10-19 17:40:12', 1, '2011-10-19 17:44:32', 1, '', 13, NULL, '', 1, 1, 0);

--
-- Dumping data for table `order_lines_revs`
--

INSERT INTO `order_lines_revs` (`id`, `quantity_ordered`, `min_quantity_ordered`, `quantity_unit`, `date_required`, `date_required_accuracy`, `status`, `modified_by`, `product_code`, `sample_control_id`, `aliquot_control_id`, `sample_aliquot_precision`, `order_id`, `study_summary_id`, `version_id`, `version_created`) VALUES
(1, '25', '25', 'ml', '2011-10-29', 'c', 'pending', 1, '', 12, 29, '', 1, 1, 1, '2011-10-19 13:02:31'),
(2, '3', '2', '', '2011-10-29', 'c', 'pending', 1, '', 3, 9, 'OCT', 1, 1, 2, '2011-10-19 13:02:49'),
(3, '4', '', '', NULL, '', 'pending', 1, '', 3, 9, 'Paraf.', 2, 1, 3, '2011-10-19 13:03:57'),
(4, '4', '', '', NULL, '', 'pending', 1, '', 3, 9, 'Oct.', 2, 1, 4, '2011-10-19 13:04:05'),
(5, '', '', '', NULL, '', 'pending', 1, '', 13, NULL, '', 1, 1, 5, '2011-10-19 17:40:12'),
(5, '', '', '', NULL, '', 'pending', 1, '', 13, NULL, '', 1, 1, 6, '2011-10-19 17:41:17'),
(5, '', '', '', NULL, '', 'shipped', 1, '', 13, NULL, '', 1, 1, 7, '2011-10-19 17:44:32'),
(4, '4', '', '', NULL, '', 'pending', 1, '', 3, 9, 'Oct.', 2, 1, 8, '2011-10-20 15:13:44');

--
-- Dumping data for table `participants`
--

INSERT INTO `participants` (`id`, `title`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `date_of_birth_accuracy`, `marital_status`, `language_preferred`, `sex`, `race`, `vital_status`, `notes`, `date_of_death`, `date_of_death_accuracy`, `cod_icd10_code`, `secondary_cod_icd10_code`, `cod_confirmation_source`, `participant_identifier`, `last_chart_checked_date`, `last_chart_checked_date_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'Mrs.', 'Olivia', '', 'Esperensa', '1935-01-01', 'y', 'married', 'french', 'f', '', 'deceased', '', '2011-02-19', 'c', 'V029', NULL, '', '001', '2011-03-04', 'c', '2011-10-19 02:13:11', 1, '2011-10-19 02:13:11', 1, 0),
(2, '', 'Jeanne', '', 'Dubet', '1945-10-01', 'c', '', '', 'f', '', 'deceased', '', NULL, '', 'C508', NULL, '', '008', '2010-12-16', 'c', '2011-10-19 02:43:44', 1, '2011-10-19 02:43:44', 1, 0),
(3, '', 'Lisa', '', 'Qwerty', '1978-01-01', 'm', '', '', '', '', 'deceased', '', '2011-10-01', 'c', NULL, NULL, '', '0098', NULL, '', '2011-10-19 02:49:41', 1, '2011-10-19 02:49:41', 1, 0);

--
-- Dumping data for table `participants_revs`
--

INSERT INTO `participants_revs` (`id`, `title`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `date_of_birth_accuracy`, `marital_status`, `language_preferred`, `sex`, `race`, `vital_status`, `notes`, `date_of_death`, `date_of_death_accuracy`, `cod_icd10_code`, `secondary_cod_icd10_code`, `cod_confirmation_source`, `participant_identifier`, `last_chart_checked_date`, `last_chart_checked_date_accuracy`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'Mrs.', 'Olivia', '', 'Esperensa', '1935-01-01', 'y', 'married', 'french', 'f', '', 'deceased', '', '2011-02-19', 'c', 'V029', NULL, '', '001', '2011-03-04', 'c', 1, 1, '2011-10-19 02:13:11'),
(2, '', 'Jeanne', '', 'Dubet', '1945-10-01', 'c', '', '', 'f', '', 'deceased', '', NULL, '', 'C508', NULL, '', '008', '2010-12-16', 'c', 1, 2, '2011-10-19 02:43:45'),
(3, '', 'Lisa', '', 'Qwerty', '1978-01-01', 'm', '', '', '', '', 'deceased', '', '2011-10-01', 'c', NULL, NULL, '', '0098', NULL, '', 1, 3, '2011-10-19 02:49:41');

--
-- Dumping data for table `participant_contacts`
--


--
-- Dumping data for table `participant_contacts_revs`
--


--
-- Dumping data for table `participant_messages`
--


--
-- Dumping data for table `participant_messages_revs`
--


--
-- Dumping data for table `pd_chemos`
--

INSERT INTO `pd_chemos` (`id`, `protocol_master_id`, `deleted`) VALUES
(1, 1, 0);

--
-- Dumping data for table `pd_chemos_revs`
--

INSERT INTO `pd_chemos_revs` (`id`, `protocol_master_id`, `version_id`, `version_created`) VALUES
(1, 1, 1, '2011-10-19 02:26:46');

--
-- Dumping data for table `pd_surgeries`
--


--
-- Dumping data for table `pd_surgeries_revs`
--


--
-- Dumping data for table `permissions_presets`
--


--
-- Dumping data for table `permissions_presets_revs`
--


--
-- Dumping data for table `pe_chemos`
--

INSERT INTO `pe_chemos` (`id`, `method`, `dose`, `frequency`, `created`, `created_by`, `modified`, `modified_by`, `protocol_master_id`, `drug_id`, `deleted`) VALUES
(1, 'IV: Intravenous', '', '', '2011-10-19 02:27:07', 1, '2011-10-19 02:27:07', 1, 1, 3, 0),
(2, 'IV: Intravenous', '', '', '2011-10-19 02:27:13', 1, '2011-10-19 02:27:13', 1, 1, 1, 0),
(3, 'IV: Intravenous', '', '', '2011-10-19 02:27:17', 1, '2011-10-19 02:27:17', 1, 1, 2, 0);

--
-- Dumping data for table `pe_chemos_revs`
--

INSERT INTO `pe_chemos_revs` (`id`, `method`, `dose`, `frequency`, `modified_by`, `protocol_master_id`, `drug_id`, `version_id`, `version_created`) VALUES
(1, 'IV: Intravenous', '', '', 1, 1, 3, 1, '2011-10-19 02:27:07'),
(2, 'IV: Intravenous', '', '', 1, 1, 1, 2, '2011-10-19 02:27:13'),
(3, 'IV: Intravenous', '', '', 1, 1, 2, 3, '2011-10-19 02:27:17');

--
-- Dumping data for table `protocol_masters`
--

INSERT INTO `protocol_masters` (`id`, `protocol_control_id`, `name`, `notes`, `code`, `arm`, `type`, `status`, `expiry`, `expiry_accuracy`, `activated`, `activated_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `deleted`) VALUES
(1, 1, '', '', 'Proto-0193', '', 'chemotherapy', NULL, NULL, '', NULL, '', '2011-10-19 02:26:45', 1, '2011-10-19 02:26:45', 1, NULL, 0);

--
-- Dumping data for table `protocol_masters_revs`
--

INSERT INTO `protocol_masters_revs` (`id`, `protocol_control_id`, `name`, `notes`, `code`, `arm`, `type`, `status`, `expiry`, `expiry_accuracy`, `activated`, `activated_accuracy`, `modified_by`, `form_id`, `version_id`, `version_created`) VALUES
(1, 1, '', '', 'Proto-0193', '', 'chemotherapy', NULL, NULL, '', NULL, '', 1, NULL, 1, '2011-10-19 02:26:46');

--
-- Dumping data for table `quality_ctrls`
--

INSERT INTO `quality_ctrls` (`id`, `qc_code`, `sample_master_id`, `type`, `qc_type_precision`, `tool`, `run_id`, `run_by`, `date`, `date_accuracy`, `score`, `unit`, `conclusion`, `notes`, `aliquot_master_id`, `used_volume`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'QC - 1', 11, 'bioanalyzer', '', 'BioAnlayzer1000', '8993', 'shrek', '2011-06-05', 'c', '6', 'RIN', 'acceptable', '', 26, '1.20000', '2011-10-20 14:25:47', 1, '2011-10-20 14:26:28', 1, 0),
(2, 'QC - 2', 11, 'bioanalyzer', '', 'BioAnlayzer1044', '97676', '', '2011-09-01', 'd', '6.8', 'RIN', 'good', '', 26, '3.60000', '2011-10-20 14:28:37', 1, '2011-10-20 14:28:37', 1, 0),
(3, 'QC - 3', 3, 'bioanalyzer', '', 'BioAnlayzer1000', 'DNA3-8392', '', NULL, '', '2', 'RIN', 'poor', '', NULL, NULL, '2011-10-20 14:48:42', 1, '2011-10-20 14:48:42', 1, 0),
(4, 'QC - 4', 18, 'bioanalyzer', '', '', 'DNA18-8392', '', NULL, '', '3', '', 'poor', '', NULL, NULL, '2011-10-20 14:48:42', 1, '2011-10-20 14:48:42', 1, 0),
(5, 'QC - 5', 3, 'bioanalyzer', '', 'BioAnlayzer1044', 'DupTest', '', NULL, '', '3.4', '', 'poor', '', NULL, NULL, '2011-10-20 14:52:53', 1, '2011-10-20 14:53:48', 1, 1),
(6, 'QC - 6', 3, 'bioanalyzer', '', 'BioAnlayzer1044', 'DupTest2', '', NULL, '', '3.4', '', 'poor', '', NULL, NULL, '2011-10-20 14:53:36', 1, '2011-10-20 14:53:36', 1, 0),
(7, 'QC - 7', 3, 'spectrophotometer', '', 'Spectro500', 'Ru89043', '', NULL, '', '', '', 'very good', '', 5, '1.30000', '2011-10-20 15:00:23', 1, '2011-10-20 15:00:23', 1, 0),
(8, 'QC - 8', 18, 'spectrophotometer', '', 'Spectro500', 'Ru89043', '', NULL, '', '', '', 'very good', '', 43, '2.70000', '2011-10-20 15:00:23', 1, '2011-10-20 15:00:23', 1, 0),
(9, 'QC - 9', 11, 'spectrophotometer', '', '', 'Run564', '', NULL, '', '', '', 'acceptable', '', 25, NULL, '2011-10-20 15:04:17', 1, '2011-10-20 15:04:17', 1, 0),
(10, 'QC - 10', 18, 'spectrophotometer', '', 'Spectro500', '6783', '', NULL, '', '', '', 'good', '', NULL, NULL, '2011-10-20 15:04:56', 1, '2011-10-20 15:04:56', 1, 0);

--
-- Dumping data for table `quality_ctrls_revs`
--

INSERT INTO `quality_ctrls_revs` (`id`, `qc_code`, `sample_master_id`, `type`, `qc_type_precision`, `tool`, `run_id`, `run_by`, `date`, `date_accuracy`, `score`, `unit`, `conclusion`, `notes`, `aliquot_master_id`, `used_volume`, `modified_by`, `version_id`, `version_created`) VALUES
(1, NULL, 11, 'bioanalyzer', '', 'BioAnlayzer1000', '8993', 'shrek', '2011-06-01', 'd', '6', 'RIN', 'acceptable', '', NULL, NULL, 1, 1, '2011-10-20 14:25:47'),
(1, 'QC - 1', 11, 'bioanalyzer', '', 'BioAnlayzer1000', '8993', 'shrek', '2011-06-05', 'c', '6', 'RIN', 'acceptable', '', NULL, NULL, 1, 2, '2011-10-20 14:26:05'),
(1, 'QC - 1', 11, 'bioanalyzer', '', 'BioAnlayzer1000', '8993', 'shrek', '2011-06-05', 'c', '6', 'RIN', 'acceptable', '', 26, '1.20000', 1, 3, '2011-10-20 14:26:28'),
(2, NULL, 11, 'bioanalyzer', '', 'BioAnlayzer1044', '97676', '', '2011-09-01', 'd', '6.8', 'RIN', 'good', '', 26, '3.60000', 1, 4, '2011-10-20 14:28:37'),
(3, NULL, 3, 'bioanalyzer', '', 'BioAnlayzer1000', 'DNA3-8392', '', NULL, '', '2', 'RIN', 'poor', '', NULL, NULL, 1, 5, '2011-10-20 14:48:42'),
(4, NULL, 18, 'bioanalyzer', '', '', 'DNA18-8392', '', NULL, '', '3', '', 'poor', '', NULL, NULL, 1, 6, '2011-10-20 14:48:42'),
(5, NULL, 3, 'bioanalyzer', '', 'BioAnlayzer1044', 'DupTest', '', NULL, '', '3.4', '', 'poor', '', NULL, NULL, 1, 7, '2011-10-20 14:52:53'),
(6, NULL, 3, 'bioanalyzer', '', 'BioAnlayzer1044', 'DupTest2', '', NULL, '', '3.4', '', 'poor', '', NULL, NULL, 1, 8, '2011-10-20 14:53:36'),
(5, 'QC - 5', 3, 'bioanalyzer', '', 'BioAnlayzer1044', 'DupTest', '', NULL, '', '3.4', '', 'poor', '', NULL, NULL, 1, 9, '2011-10-20 14:53:49'),
(7, NULL, 3, 'spectrophotometer', '', 'Spectro500', 'Ru89043', '', NULL, '', '', '', 'very good', '', 5, '1.30000', 1, 10, '2011-10-20 15:00:23'),
(8, NULL, 18, 'spectrophotometer', '', 'Spectro500', 'Ru89043', '', NULL, '', '', '', 'very good', '', 43, '2.70000', 1, 11, '2011-10-20 15:00:23'),
(9, NULL, 11, 'spectrophotometer', '', '', 'Run564', '', NULL, '', '', '', 'acceptable', '', 25, NULL, 1, 12, '2011-10-20 15:04:17'),
(10, NULL, 18, 'spectrophotometer', '', 'Spectro500', '6783', '', NULL, '', '', '', 'good', '', NULL, NULL, 1, 13, '2011-10-20 15:04:56');

--
-- Dumping data for table `realiquotings`
--

INSERT INTO `realiquotings` (`id`, `parent_aliquot_master_id`, `child_aliquot_master_id`, `parent_used_volume`, `realiquoting_datetime`, `realiquoting_datetime_accuracy`, `realiquoted_by`, `lab_book_master_id`, `sync_with_lab_book`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 19, 24, NULL, '2011-10-16 01:52:00', 'c', 'buzz lightyear', NULL, NULL, '2011-10-19 16:58:05', 1, '2011-10-19 17:07:46', 1, 1),
(2, 38, 42, NULL, '2011-10-16 01:52:00', 'c', 'buzz lightyear', NULL, NULL, '2011-10-19 16:58:06', 1, '2011-10-19 16:59:39', 1, 1),
(3, 38, 42, NULL, '2011-10-02 17:00:00', 'c', '', NULL, NULL, '2011-10-19 17:00:39', 1, '2011-10-19 17:08:00', 1, 1),
(4, 20, 24, NULL, '2011-10-01 00:00:00', 'c', 'buzz lightyear', NULL, NULL, '2011-10-19 17:10:37', 1, '2011-10-19 17:10:37', 1, 0),
(5, 38, 42, NULL, '2011-10-01 00:00:00', 'c', 'buzz lightyear', NULL, NULL, '2011-10-19 17:10:38', 1, '2011-10-19 17:10:38', 1, 0),
(6, 30, 28, '1.00000', '2011-10-05 17:21:00', 'c', 'buzz lightyear', NULL, NULL, '2011-10-19 17:24:32', 1, '2011-10-19 17:24:32', 1, 0),
(7, 48, 47, '1.30000', '2011-10-12 00:00:00', 'c', 'buzz lightyear', NULL, NULL, '2011-10-19 17:24:33', 1, '2011-10-19 17:24:33', 1, 0),
(8, 28, 53, '0.30000', '2011-12-01 07:20:00', 'c', 'shrek', NULL, NULL, '2011-10-19 18:24:22', 1, '2011-10-19 18:24:22', 1, 0),
(9, 28, 54, '0.30000', '2011-12-01 07:20:00', 'c', 'shrek', NULL, NULL, '2011-10-19 18:24:23', 1, '2011-10-19 18:24:23', 1, 0),
(10, 46, 55, '0.30000', '2011-12-01 07:20:00', 'c', 'shrek', NULL, NULL, '2011-10-19 18:24:24', 1, '2011-10-19 18:24:24', 1, 0);

--
-- Dumping data for table `realiquotings_revs`
--

INSERT INTO `realiquotings_revs` (`id`, `parent_aliquot_master_id`, `child_aliquot_master_id`, `parent_used_volume`, `realiquoting_datetime`, `realiquoting_datetime_accuracy`, `realiquoted_by`, `lab_book_master_id`, `sync_with_lab_book`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 19, 24, NULL, '2011-10-16 01:52:00', 'c', 'buzz lightyear', NULL, NULL, 1, 1, '2011-10-19 16:58:05'),
(2, 38, 42, NULL, '2011-10-16 01:52:00', 'c', 'buzz lightyear', NULL, NULL, 1, 2, '2011-10-19 16:58:06'),
(2, 38, 42, NULL, '2011-10-16 01:52:00', 'c', 'buzz lightyear', NULL, NULL, 1, 3, '2011-10-19 16:59:39'),
(3, 38, 42, NULL, '2011-10-02 17:00:00', 'c', '', NULL, NULL, 1, 4, '2011-10-19 17:00:39'),
(1, 19, 24, NULL, '2011-10-16 01:52:00', 'c', 'buzz lightyear', NULL, NULL, 1, 5, '2011-10-19 17:07:46'),
(3, 38, 42, NULL, '2011-10-02 17:00:00', 'c', '', NULL, NULL, 1, 6, '2011-10-19 17:08:00'),
(4, 20, 24, NULL, '2011-10-01 00:00:00', 'c', 'buzz lightyear', NULL, NULL, 1, 7, '2011-10-19 17:10:37'),
(5, 38, 42, NULL, '2011-10-01 00:00:00', 'c', 'buzz lightyear', NULL, NULL, 1, 8, '2011-10-19 17:10:38'),
(6, 30, 28, '1.00000', '2011-10-05 17:21:00', 'c', 'buzz lightyear', NULL, NULL, 1, 9, '2011-10-19 17:24:32'),
(7, 48, 47, '1.30000', '2011-10-12 00:00:00', 'c', 'buzz lightyear', NULL, NULL, 1, 10, '2011-10-19 17:24:34'),
(8, 28, 53, '0.30000', '2011-12-01 07:20:00', 'c', 'shrek', NULL, NULL, 1, 11, '2011-10-19 18:24:22'),
(9, 28, 54, '0.30000', '2011-12-01 07:20:00', 'c', 'shrek', NULL, NULL, 1, 12, '2011-10-19 18:24:23'),
(10, 46, 55, '0.30000', '2011-12-01 07:20:00', 'c', 'shrek', NULL, NULL, 1, 13, '2011-10-19 18:24:24');

--
-- Dumping data for table `reproductive_histories`
--

INSERT INTO `reproductive_histories` (`id`, `date_captured`, `date_captured_accuracy`, `menopause_status`, `menopause_onset_reason`, `age_at_menopause`, `age_at_menopause_precision`, `age_at_menarche`, `age_at_menarche_precision`, `hrt_years_used`, `hrt_use`, `hysterectomy_age`, `hysterectomy_age_precision`, `hysterectomy`, `ovary_removed_type`, `gravida`, `para`, `age_at_first_parturition`, `age_at_first_parturition_precision`, `age_at_last_parturition`, `age_at_last_parturition_precision`, `hormonal_contraceptive_use`, `years_on_hormonal_contraceptives`, `lnmp_date`, `lnmp_date_accuracy`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, '2010-10-06', 'c', 'post', '', NULL, '', NULL, '', NULL, '', NULL, '', '', '', NULL, NULL, NULL, '', NULL, '', '', NULL, NULL, '', 1, '2011-10-19 02:41:58', 1, '2011-10-19 02:41:58', 1, 0);

--
-- Dumping data for table `reproductive_histories_revs`
--

INSERT INTO `reproductive_histories_revs` (`id`, `date_captured`, `date_captured_accuracy`, `menopause_status`, `menopause_onset_reason`, `age_at_menopause`, `age_at_menopause_precision`, `age_at_menarche`, `age_at_menarche_precision`, `hrt_years_used`, `hrt_use`, `hysterectomy_age`, `hysterectomy_age_precision`, `hysterectomy`, `ovary_removed_type`, `gravida`, `para`, `age_at_first_parturition`, `age_at_first_parturition_precision`, `age_at_last_parturition`, `age_at_last_parturition_precision`, `hormonal_contraceptive_use`, `years_on_hormonal_contraceptives`, `lnmp_date`, `lnmp_date_accuracy`, `participant_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '2010-10-06', 'c', 'post', '', NULL, '', NULL, '', NULL, '', NULL, '', '', '', NULL, NULL, NULL, '', NULL, '', '', NULL, NULL, '', 1, 1, 1, '2011-10-19 02:41:58');

--
-- Dumping data for table `rtbforms`
--


--
-- Dumping data for table `rtbforms_revs`
--


--
-- Dumping data for table `sample_masters`
--

INSERT INTO `sample_masters` (`id`, `sample_code`, `sample_control_id`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `parent_sample_type`, `sop_master_id`, `product_code`, `is_problematic`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'B - 1', 2, 1, 'blood', 1, NULL, NULL, NULL, NULL, '', '', '2011-10-19 13:30:15', 1, '2011-10-19 13:30:15', 1, 0),
(2, 'BLD-C - 2', 7, 1, 'blood', 1, 1, 'blood', NULL, NULL, '', '', '2011-10-19 13:30:55', 1, '2011-10-19 13:30:55', 1, 0),
(3, 'DNA - 3', 12, 1, 'blood', 1, 2, 'blood cell', NULL, NULL, '', '', '2011-10-19 13:33:10', 1, '2011-10-19 13:33:11', 1, 0),
(4, 'PLS - 4', 9, 1, 'blood', 1, 1, 'blood', NULL, NULL, '', '', '2011-10-19 13:34:38', 1, '2011-10-19 13:34:39', 1, 0),
(5, 'SER - 5', 10, 1, 'blood', 1, 1, 'blood', NULL, NULL, '', '', '2011-10-19 13:36:22', 1, '2011-10-19 13:36:23', 1, 0),
(6, 'B - 6', 2, 6, 'blood', 1, NULL, NULL, NULL, NULL, '', '', '2011-10-19 13:37:22', 1, '2011-10-19 13:37:23', 1, 0),
(7, 'A - 7', 1, 7, 'ascite', 2, NULL, NULL, NULL, NULL, '', '', '2011-10-19 13:41:23', 1, '2011-10-19 13:41:23', 1, 0),
(8, 'ASC-C - 8', 5, 7, 'ascite', 2, 7, 'ascite', NULL, NULL, '', '', '2011-10-19 13:42:40', 1, '2011-10-19 13:42:40', 1, 0),
(9, 'T - 9', 3, 9, 'tissue', 2, NULL, NULL, NULL, NULL, '', '', '2011-10-19 14:02:00', 1, '2011-10-19 14:02:01', 1, 0),
(10, 'T - 10', 3, 10, 'tissue', 2, NULL, NULL, NULL, NULL, '', '', '2011-10-19 14:04:31', 1, '2011-10-19 14:04:32', 1, 0),
(11, 'DNA - 11', 12, 10, 'tissue', 2, 10, 'tissue', NULL, NULL, '', '', '2011-10-19 14:05:07', 1, '2011-10-19 14:05:08', 1, 0),
(12, 'RNA - 12', 13, 10, 'tissue', 2, 10, 'tissue', NULL, NULL, '', '', '2011-10-19 14:06:18', 1, '2011-10-19 14:06:19', 1, 0),
(13, 'AMP-RNA - 13', 17, 10, 'tissue', 2, 12, 'rna', NULL, NULL, '', '', '2011-10-19 14:07:43', 1, '2011-10-19 14:07:44', 1, 0),
(14, 'A - 14', 1, 14, 'ascite', 3, NULL, NULL, NULL, NULL, '', '', '2011-10-19 14:48:33', 1, '2011-10-19 14:48:33', 1, 0),
(15, 'ASC-C - 15', 5, 14, 'ascite', 3, 14, 'ascite', NULL, NULL, '', '', '2011-10-19 14:49:51', 1, '2011-10-19 14:49:52', 1, 0),
(16, 'T - 16', 3, 16, 'tissue', 3, NULL, NULL, NULL, NULL, '', '', '2011-10-19 14:51:28', 1, '2011-10-19 14:51:28', 1, 0),
(17, 'T - 17', 3, 17, 'tissue', 3, NULL, NULL, NULL, NULL, '', '', '2011-10-19 14:53:26', 1, '2011-10-19 14:53:26', 1, 0),
(18, 'DNA - 18', 12, 17, 'tissue', 3, 17, 'tissue', NULL, NULL, '', '', '2011-10-19 14:53:40', 1, '2011-10-19 14:53:40', 1, 0),
(19, 'RNA - 19', 13, 17, 'tissue', 3, 17, 'tissue', NULL, NULL, '', '', '2011-10-19 14:54:43', 1, '2011-10-19 14:54:44', 1, 0),
(20, 'AMP-RNA - 20', 17, 17, 'tissue', 3, 19, 'rna', NULL, NULL, '', '', '2011-10-19 14:56:17', 1, '2011-10-19 14:56:18', 1, 0),
(21, 'U - 21', 4, 21, 'urine', 4, NULL, NULL, NULL, NULL, '', '', '2011-10-19 14:58:01', 1, '2011-10-19 14:58:01', 1, 0),
(22, 'T - 22', 3, 22, 'tissue', 5, NULL, NULL, NULL, NULL, '', '', '2011-10-19 15:02:08', 1, '2011-10-19 15:16:50', 1, 1),
(23, 'T - 23', 3, 23, 'tissue', 5, NULL, NULL, NULL, NULL, '', '', '2011-10-19 15:07:13', 1, '2011-10-19 15:07:14', 1, 0),
(24, 'C-CULT - 24', 11, 23, 'tissue', 5, 23, 'tissue', NULL, NULL, '', '', '2011-10-19 15:10:29', 1, '2011-10-19 15:10:30', 1, 0),
(25, 'RNA - 25', 13, 23, 'tissue', 5, 24, 'cell culture', NULL, NULL, '', '', '2011-10-19 15:10:38', 1, '2011-10-19 15:10:39', 1, 0),
(26, 'AMP-RNA - 26', 17, 10, 'tissue', 2, 12, 'rna', 1, NULL, '', '', '2011-10-19 18:42:36', 1, '2011-10-19 18:42:36', 1, 0),
(27, 'AMP-RNA - 27', 17, 17, 'tissue', 3, 19, 'rna', 1, NULL, '', '', '2011-10-19 18:42:37', 1, '2011-10-19 18:42:38', 1, 0),
(28, 'AMP-RNA - 28', 17, 17, 'tissue', 3, 19, 'rna', 1, NULL, '', '', '2011-10-19 18:42:38', 1, '2011-10-19 18:42:39', 1, 0);

UPDATE sample_masters SET sample_code = id;

--
-- Dumping data for table `sample_masters_revs`
--

INSERT INTO `sample_masters_revs` (`id`, `sample_code`, `sample_control_id`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `parent_sample_type`, `sop_master_id`, `product_code`, `is_problematic`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '', 2, NULL, 'blood', 1, NULL, NULL, NULL, NULL, '', '', 1, 1, '2011-10-19 13:30:15'),
(1, 'B - 1', 2, 1, 'blood', 1, NULL, NULL, NULL, NULL, '', '', 1, 2, '2011-10-19 13:30:15'),
(2, '', 7, 1, 'blood', 1, 1, 'blood', NULL, NULL, '', '', 1, 3, '2011-10-19 13:30:55'),
(2, 'BLD-C - 2', 7, 1, 'blood', 1, 1, 'blood', NULL, NULL, '', '', 1, 4, '2011-10-19 13:30:56'),
(3, '', 12, 1, 'blood', 1, 2, 'blood cell', NULL, NULL, '', '', 1, 5, '2011-10-19 13:33:11'),
(3, 'DNA - 3', 12, 1, 'blood', 1, 2, 'blood cell', NULL, NULL, '', '', 1, 6, '2011-10-19 13:33:11'),
(4, '', 9, 1, 'blood', 1, 1, 'blood', NULL, NULL, '', '', 1, 7, '2011-10-19 13:34:39'),
(4, 'PLS - 4', 9, 1, 'blood', 1, 1, 'blood', NULL, NULL, '', '', 1, 8, '2011-10-19 13:34:39'),
(5, '', 10, 1, 'blood', 1, 1, 'blood', NULL, NULL, '', '', 1, 9, '2011-10-19 13:36:23'),
(5, 'SER - 5', 10, 1, 'blood', 1, 1, 'blood', NULL, NULL, '', '', 1, 10, '2011-10-19 13:36:23'),
(6, '', 2, NULL, 'blood', 1, NULL, NULL, NULL, NULL, '', '', 1, 11, '2011-10-19 13:37:23'),
(6, 'B - 6', 2, 6, 'blood', 1, NULL, NULL, NULL, NULL, '', '', 1, 12, '2011-10-19 13:37:24'),
(7, '', 1, NULL, 'ascite', 2, NULL, NULL, NULL, NULL, '', '', 1, 13, '2011-10-19 13:41:23'),
(7, 'A - 7', 1, 7, 'ascite', 2, NULL, NULL, NULL, NULL, '', '', 1, 14, '2011-10-19 13:41:24'),
(8, '', 5, 7, 'ascite', 2, 7, 'ascite', NULL, NULL, '', '', 1, 15, '2011-10-19 13:42:40'),
(8, 'ASC-C - 8', 5, 7, 'ascite', 2, 7, 'ascite', NULL, NULL, '', '', 1, 16, '2011-10-19 13:42:41'),
(9, '', 3, NULL, 'tissue', 2, NULL, NULL, NULL, NULL, '', '', 1, 17, '2011-10-19 14:02:01'),
(9, 'T - 9', 3, 9, 'tissue', 2, NULL, NULL, NULL, NULL, '', '', 1, 18, '2011-10-19 14:02:02'),
(10, '', 3, NULL, 'tissue', 2, NULL, NULL, NULL, NULL, '', '', 1, 19, '2011-10-19 14:04:32'),
(10, 'T - 10', 3, 10, 'tissue', 2, NULL, NULL, NULL, NULL, '', '', 1, 20, '2011-10-19 14:04:32'),
(11, '', 12, 10, 'tissue', 2, 10, 'tissue', NULL, NULL, '', '', 1, 21, '2011-10-19 14:05:07'),
(11, 'DNA - 11', 12, 10, 'tissue', 2, 10, 'tissue', NULL, NULL, '', '', 1, 22, '2011-10-19 14:05:08'),
(12, '', 13, 10, 'tissue', 2, 10, 'tissue', NULL, NULL, '', '', 1, 23, '2011-10-19 14:06:19'),
(12, 'RNA - 12', 13, 10, 'tissue', 2, 10, 'tissue', NULL, NULL, '', '', 1, 24, '2011-10-19 14:06:20'),
(13, '', 17, 10, 'tissue', 2, 12, 'rna', NULL, NULL, '', '', 1, 25, '2011-10-19 14:07:44'),
(13, 'AMP-RNA - 13', 17, 10, 'tissue', 2, 12, 'rna', NULL, NULL, '', '', 1, 26, '2011-10-19 14:07:44'),
(14, '', 1, NULL, 'ascite', 3, NULL, NULL, NULL, NULL, '', '', 1, 27, '2011-10-19 14:48:33'),
(14, 'A - 14', 1, 14, 'ascite', 3, NULL, NULL, NULL, NULL, '', '', 1, 28, '2011-10-19 14:48:33'),
(15, '', 5, 14, 'ascite', 3, 14, 'ascite', NULL, NULL, '', '', 1, 29, '2011-10-19 14:49:52'),
(15, 'ASC-C - 15', 5, 14, 'ascite', 3, 14, 'ascite', NULL, NULL, '', '', 1, 30, '2011-10-19 14:49:52'),
(16, '', 3, NULL, 'tissue', 3, NULL, NULL, NULL, NULL, '', '', 1, 31, '2011-10-19 14:51:28'),
(16, 'T - 16', 3, 16, 'tissue', 3, NULL, NULL, NULL, NULL, '', '', 1, 32, '2011-10-19 14:51:29'),
(17, '', 3, NULL, 'tissue', 3, NULL, NULL, NULL, NULL, '', '', 1, 33, '2011-10-19 14:53:26'),
(17, 'T - 17', 3, 17, 'tissue', 3, NULL, NULL, NULL, NULL, '', '', 1, 34, '2011-10-19 14:53:26'),
(18, '', 12, 17, 'tissue', 3, 17, 'tissue', NULL, NULL, '', '', 1, 35, '2011-10-19 14:53:40'),
(18, 'DNA - 18', 12, 17, 'tissue', 3, 17, 'tissue', NULL, NULL, '', '', 1, 36, '2011-10-19 14:53:41'),
(19, '', 13, 17, 'tissue', 3, 17, 'tissue', NULL, NULL, '', '', 1, 37, '2011-10-19 14:54:44'),
(19, 'RNA - 19', 13, 17, 'tissue', 3, 17, 'tissue', NULL, NULL, '', '', 1, 38, '2011-10-19 14:54:44'),
(20, '', 17, 17, 'tissue', 3, 19, 'rna', NULL, NULL, '', '', 1, 39, '2011-10-19 14:56:18'),
(20, 'AMP-RNA - 20', 17, 17, 'tissue', 3, 19, 'rna', NULL, NULL, '', '', 1, 40, '2011-10-19 14:56:18'),
(21, '', 4, NULL, 'urine', 4, NULL, NULL, NULL, NULL, '', '', 1, 41, '2011-10-19 14:58:01'),
(21, 'U - 21', 4, 21, 'urine', 4, NULL, NULL, NULL, NULL, '', '', 1, 42, '2011-10-19 14:58:01'),
(22, '', 3, NULL, 'tissue', 5, NULL, NULL, NULL, NULL, '', '', 1, 43, '2011-10-19 15:02:08'),
(22, 'T - 22', 3, 22, 'tissue', 5, NULL, NULL, NULL, NULL, '', '', 1, 44, '2011-10-19 15:02:09'),
(23, '', 3, NULL, 'tissue', 5, NULL, NULL, NULL, NULL, '', '', 1, 45, '2011-10-19 15:07:14'),
(23, 'T - 23', 3, 23, 'tissue', 5, NULL, NULL, NULL, NULL, '', '', 1, 46, '2011-10-19 15:07:14'),
(24, '', 11, 23, 'tissue', 5, 23, 'tissue', NULL, NULL, '', '', 1, 47, '2011-10-19 15:10:30'),
(24, 'C-CULT - 24', 11, 23, 'tissue', 5, 23, 'tissue', NULL, NULL, '', '', 1, 48, '2011-10-19 15:10:30'),
(25, '', 13, 23, 'tissue', 5, 24, 'cell culture', NULL, NULL, '', '', 1, 49, '2011-10-19 15:10:39'),
(25, 'RNA - 25', 13, 23, 'tissue', 5, 24, 'cell culture', NULL, NULL, '', '', 1, 50, '2011-10-19 15:10:39'),
(22, 'T - 22', 3, 22, 'tissue', 5, NULL, NULL, NULL, NULL, '', '', 1, 51, '2011-10-19 15:16:50'),
(26, '', 17, 10, 'tissue', 2, 12, 'rna', 1, NULL, '', '', 1, 52, '2011-10-19 18:42:36'),
(26, 'AMP-RNA - 26', 17, 10, 'tissue', 2, 12, 'rna', 1, NULL, '', '', 1, 53, '2011-10-19 18:42:36'),
(27, '', 17, 17, 'tissue', 3, 19, 'rna', 1, NULL, '', '', 1, 54, '2011-10-19 18:42:38'),
(27, 'AMP-RNA - 27', 17, 17, 'tissue', 3, 19, 'rna', 1, NULL, '', '', 1, 55, '2011-10-19 18:42:38'),
(28, '', 17, 17, 'tissue', 3, 19, 'rna', 1, NULL, '', '', 1, 56, '2011-10-19 18:42:39'),
(28, 'AMP-RNA - 28', 17, 17, 'tissue', 3, 19, 'rna', 1, NULL, '', '', 1, 57, '2011-10-19 18:42:39');

UPDATE sample_masters_revs SET sample_code = id;

--
-- Dumping data for table `sd_der_amp_rnas`
--

INSERT INTO `sd_der_amp_rnas` (`id`, `sample_master_id`, `deleted`) VALUES
(1, 13, 0),
(2, 20, 0),
(3, 26, 0),
(4, 27, 0),
(5, 28, 0);

--
-- Dumping data for table `sd_der_amp_rnas_revs`
--

INSERT INTO `sd_der_amp_rnas_revs` (`id`, `sample_master_id`, `version_id`, `version_created`) VALUES
(1, 13, 1, '2011-10-19 14:07:44'),
(2, 20, 2, '2011-10-19 14:56:18'),
(3, 26, 3, '2011-10-19 18:42:36'),
(4, 27, 4, '2011-10-19 18:42:38'),
(5, 28, 5, '2011-10-19 18:42:39');

--
-- Dumping data for table `sd_der_ascite_cells`
--

INSERT INTO `sd_der_ascite_cells` (`id`, `sample_master_id`, `deleted`) VALUES
(1, 8, 0),
(2, 15, 0);

--
-- Dumping data for table `sd_der_ascite_cells_revs`
--

INSERT INTO `sd_der_ascite_cells_revs` (`id`, `sample_master_id`, `version_id`, `version_created`) VALUES
(1, 8, 1, '2011-10-19 13:42:40'),
(2, 15, 2, '2011-10-19 14:49:51');

--
-- Dumping data for table `sd_der_ascite_sups`
--


--
-- Dumping data for table `sd_der_ascite_sups_revs`
--


--
-- Dumping data for table `sd_der_blood_cells`
--

INSERT INTO `sd_der_blood_cells` (`id`, `sample_master_id`, `deleted`) VALUES
(1, 2, 0);

--
-- Dumping data for table `sd_der_blood_cells_revs`
--

INSERT INTO `sd_der_blood_cells_revs` (`id`, `sample_master_id`, `version_id`, `version_created`) VALUES
(1, 2, 1, '2011-10-19 13:30:55');

--
-- Dumping data for table `sd_der_bone_marrow_susps`
--


--
-- Dumping data for table `sd_der_bone_marrow_susps_revs`
--


--
-- Dumping data for table `sd_der_b_cells`
--


--
-- Dumping data for table `sd_der_b_cells_revs`
--


--
-- Dumping data for table `sd_der_cdnas`
--


--
-- Dumping data for table `sd_der_cdnas_revs`
--


--
-- Dumping data for table `sd_der_cell_cultures`
--

INSERT INTO `sd_der_cell_cultures` (`id`, `sample_master_id`, `culture_status`, `culture_status_reason`, `cell_passage_number`, `deleted`) VALUES
(1, 24, 'active', '', 3, 0);

--
-- Dumping data for table `sd_der_cell_cultures_revs`
--

INSERT INTO `sd_der_cell_cultures_revs` (`id`, `sample_master_id`, `culture_status`, `culture_status_reason`, `cell_passage_number`, `version_id`, `version_created`) VALUES
(1, 24, 'active', '', 3, 1, '2011-10-19 15:10:30');

--
-- Dumping data for table `sd_der_cell_lysates`
--


--
-- Dumping data for table `sd_der_cell_lysates_revs`
--


--
-- Dumping data for table `sd_der_cystic_fl_cells`
--


--
-- Dumping data for table `sd_der_cystic_fl_cells_revs`
--


--
-- Dumping data for table `sd_der_cystic_fl_sups`
--


--
-- Dumping data for table `sd_der_cystic_fl_sups_revs`
--


--
-- Dumping data for table `sd_der_dnas`
--

INSERT INTO `sd_der_dnas` (`id`, `sample_master_id`, `deleted`) VALUES
(1, 3, 0),
(2, 11, 0),
(3, 18, 0);

--
-- Dumping data for table `sd_der_dnas_revs`
--

INSERT INTO `sd_der_dnas_revs` (`id`, `sample_master_id`, `version_id`, `version_created`) VALUES
(1, 3, 1, '2011-10-19 13:33:11'),
(2, 11, 2, '2011-10-19 14:05:07'),
(3, 18, 3, '2011-10-19 14:53:40');

--
-- Dumping data for table `sd_der_no_b_cells`
--


--
-- Dumping data for table `sd_der_no_b_cells_revs`
--


--
-- Dumping data for table `sd_der_pbmcs`
--


--
-- Dumping data for table `sd_der_pbmcs_revs`
--


--
-- Dumping data for table `sd_der_pericardial_fl_cells`
--


--
-- Dumping data for table `sd_der_pericardial_fl_cells_revs`
--


--
-- Dumping data for table `sd_der_pericardial_fl_sups`
--


--
-- Dumping data for table `sd_der_pericardial_fl_sups_revs`
--


--
-- Dumping data for table `sd_der_plasmas`
--

INSERT INTO `sd_der_plasmas` (`id`, `sample_master_id`, `deleted`) VALUES
(1, 4, 0);

--
-- Dumping data for table `sd_der_plasmas_revs`
--

INSERT INTO `sd_der_plasmas_revs` (`id`, `sample_master_id`, `version_id`, `version_created`) VALUES
(1, 4, 1, '2011-10-19 13:34:38');

--
-- Dumping data for table `sd_der_pleural_fl_cells`
--


--
-- Dumping data for table `sd_der_pleural_fl_cells_revs`
--


--
-- Dumping data for table `sd_der_pleural_fl_sups`
--


--
-- Dumping data for table `sd_der_pleural_fl_sups_revs`
--


--
-- Dumping data for table `sd_der_proteins`
--


--
-- Dumping data for table `sd_der_proteins_revs`
--


--
-- Dumping data for table `sd_der_pw_cells`
--


--
-- Dumping data for table `sd_der_pw_cells_revs`
--


--
-- Dumping data for table `sd_der_pw_sups`
--


--
-- Dumping data for table `sd_der_pw_sups_revs`
--


--
-- Dumping data for table `sd_der_rnas`
--

INSERT INTO `sd_der_rnas` (`id`, `sample_master_id`, `deleted`) VALUES
(1, 12, 0),
(2, 19, 0),
(3, 25, 0);

--
-- Dumping data for table `sd_der_rnas_revs`
--

INSERT INTO `sd_der_rnas_revs` (`id`, `sample_master_id`, `version_id`, `version_created`) VALUES
(1, 12, 1, '2011-10-19 14:06:19'),
(2, 19, 2, '2011-10-19 14:54:43'),
(3, 25, 3, '2011-10-19 15:10:39');

--
-- Dumping data for table `sd_der_serums`
--

INSERT INTO `sd_der_serums` (`id`, `sample_master_id`, `deleted`) VALUES
(1, 5, 0);

--
-- Dumping data for table `sd_der_serums_revs`
--

INSERT INTO `sd_der_serums_revs` (`id`, `sample_master_id`, `version_id`, `version_created`) VALUES
(1, 5, 1, '2011-10-19 13:36:22');

--
-- Dumping data for table `sd_der_tiss_lysates`
--


--
-- Dumping data for table `sd_der_tiss_lysates_revs`
--


--
-- Dumping data for table `sd_der_tiss_susps`
--


--
-- Dumping data for table `sd_der_tiss_susps_revs`
--


--
-- Dumping data for table `sd_der_urine_cents`
--


--
-- Dumping data for table `sd_der_urine_cents_revs`
--


--
-- Dumping data for table `sd_der_urine_cons`
--


--
-- Dumping data for table `sd_der_urine_cons_revs`
--


--
-- Dumping data for table `sd_spe_ascites`
--

INSERT INTO `sd_spe_ascites` (`id`, `sample_master_id`, `collected_volume`, `collected_volume_unit`, `deleted`) VALUES
(1, 7, NULL, '', 0),
(2, 14, NULL, '', 0);

--
-- Dumping data for table `sd_spe_ascites_revs`
--

INSERT INTO `sd_spe_ascites_revs` (`id`, `sample_master_id`, `collected_volume`, `collected_volume_unit`, `version_id`, `version_created`) VALUES
(1, 7, NULL, '', 1, '2011-10-19 13:41:23'),
(2, 14, NULL, '', 2, '2011-10-19 14:48:33');

--
-- Dumping data for table `sd_spe_bloods`
--

INSERT INTO `sd_spe_bloods` (`id`, `sample_master_id`, `blood_type`, `collected_tube_nbr`, `collected_volume`, `collected_volume_unit`, `deleted`) VALUES
(1, 1, 'EDTA', 2, '30.00000', 'ml', 0),
(2, 6, 'paxgene', NULL, NULL, '', 0);

--
-- Dumping data for table `sd_spe_bloods_revs`
--

INSERT INTO `sd_spe_bloods_revs` (`id`, `sample_master_id`, `blood_type`, `collected_tube_nbr`, `collected_volume`, `collected_volume_unit`, `version_id`, `version_created`) VALUES
(1, 1, 'EDTA', 2, '30.00000', 'ml', 1, '2011-10-19 13:30:15'),
(2, 6, 'paxgene', NULL, NULL, '', 2, '2011-10-19 13:37:23');

--
-- Dumping data for table `sd_spe_bone_marrows`
--


--
-- Dumping data for table `sd_spe_bone_marrows_revs`
--


--
-- Dumping data for table `sd_spe_cystic_fluids`
--


--
-- Dumping data for table `sd_spe_cystic_fluids_revs`
--


--
-- Dumping data for table `sd_spe_pericardial_fluids`
--


--
-- Dumping data for table `sd_spe_pericardial_fluids_revs`
--


--
-- Dumping data for table `sd_spe_peritoneal_washes`
--


--
-- Dumping data for table `sd_spe_peritoneal_washes_revs`
--


--
-- Dumping data for table `sd_spe_pleural_fluids`
--


--
-- Dumping data for table `sd_spe_pleural_fluids_revs`
--


--
-- Dumping data for table `sd_spe_tissues`
--

INSERT INTO `sd_spe_tissues` (`id`, `sample_master_id`, `tissue_source`, `tissue_nature`, `tissue_laterality`, `pathology_reception_datetime`, `pathology_reception_datetime_accuracy`, `tissue_size`, `tissue_size_unit`, `tissue_weight`, `tissue_weight_unit`, `deleted`) VALUES
(1, 9, '', NULL, 'right', '2011-05-28 12:08:00', 'c', '1x3x3', 'cm', '2', 'gr', 0),
(2, 10, '', NULL, 'left', NULL, '', '', '', '', '', 0),
(3, 16, '', NULL, 'left', NULL, '', '1x3x2', 'cm', '', '', 0),
(4, 17, '', NULL, 'right', NULL, '', '', '', '', '', 0),
(5, 22, '', NULL, 'right', NULL, '', '', '', '', '', 1),
(6, 23, '', NULL, '', NULL, '', '', '', '', '', 0);

--
-- Dumping data for table `sd_spe_tissues_revs`
--

INSERT INTO `sd_spe_tissues_revs` (`id`, `sample_master_id`, `tissue_source`, `tissue_nature`, `tissue_laterality`, `pathology_reception_datetime`, `pathology_reception_datetime_accuracy`, `tissue_size`, `tissue_size_unit`, `tissue_weight`, `tissue_weight_unit`, `version_id`, `version_created`) VALUES
(1, 9, '', NULL, 'right', '2011-05-28 12:08:00', 'c', '1x3x3', 'cm', '2', 'gr', 1, '2011-10-19 14:02:01'),
(2, 10, '', NULL, 'left', NULL, '', '', '', '', '', 2, '2011-10-19 14:04:31'),
(3, 16, '', NULL, 'left', NULL, '', '1x3x2', 'cm', '', '', 3, '2011-10-19 14:51:28'),
(4, 17, '', NULL, 'right', NULL, '', '', '', '', '', 4, '2011-10-19 14:53:26'),
(5, 22, '', NULL, 'right', NULL, '', '', '', '', '', 5, '2011-10-19 15:02:08'),
(6, 23, '', NULL, '', NULL, '', '', '', '', '', 6, '2011-10-19 15:07:14'),
(5, 22, '', NULL, 'right', NULL, '', '', '', '', '', 7, '2011-10-19 15:16:50');

--
-- Dumping data for table `sd_spe_urines`
--

INSERT INTO `sd_spe_urines` (`id`, `sample_master_id`, `urine_aspect`, `collected_volume`, `collected_volume_unit`, `pellet_signs`, `pellet_volume`, `pellet_volume_unit`, `deleted`) VALUES
(1, 21, 'turbidity', NULL, '', '', NULL, '', 0);

--
-- Dumping data for table `sd_spe_urines_revs`
--

INSERT INTO `sd_spe_urines_revs` (`id`, `sample_master_id`, `urine_aspect`, `collected_volume`, `collected_volume_unit`, `pellet_signs`, `pellet_volume`, `pellet_volume_unit`, `version_id`, `version_created`) VALUES
(1, 21, 'turbidity', NULL, '', '', NULL, '', 1, '2011-10-19 14:58:01');

--
-- Dumping data for table `shelves`
--


--
-- Dumping data for table `shelves_revs`
--


--
-- Dumping data for table `shipments`
--

INSERT INTO `shipments` (`id`, `shipment_code`, `recipient`, `facility`, `delivery_street_address`, `delivery_city`, `delivery_province`, `delivery_postal_code`, `delivery_country`, `shipping_company`, `shipping_account_nbr`, `datetime_shipped`, `datetime_shipped_accuracy`, `datetime_received`, `datetime_received_accuracy`, `shipped_by`, `created`, `created_by`, `modified`, `modified_by`, `order_id`, `deleted`) VALUES
(1, 'cd-873', '', '', '', '', '', '', '', 'UPP', '31241', '2011-11-29 00:00:00', 'h', NULL, '', 'shrek', '2011-10-19 17:43:21', 1, '2011-10-19 17:43:21', 1, 1, 0),
(2, '778', 'CTRNet Dr TRY', '', '3324 Street View', 'Winnipeg', '', '', '', 'SHIP-FAST', '', '2011-10-31 07:13:00', '', NULL, '', 'shrek', '2011-10-20 15:15:07', 1, '2011-10-20 15:15:07', 1, 2, 0);

--
-- Dumping data for table `shipments_revs`
--

INSERT INTO `shipments_revs` (`id`, `shipment_code`, `recipient`, `facility`, `delivery_street_address`, `delivery_city`, `delivery_province`, `delivery_postal_code`, `delivery_country`, `shipping_company`, `shipping_account_nbr`, `datetime_shipped`, `datetime_shipped_accuracy`, `datetime_received`, `datetime_received_accuracy`, `shipped_by`, `modified_by`, `order_id`, `version_id`, `version_created`) VALUES
(1, 'cd-873', '', '', '', '', '', '', '', 'UPP', '31241', '2011-11-29 00:00:00', 'h', NULL, '', 'shrek', 1, 1, 1, '2011-10-19 17:43:21'),
(2, '778', 'CTRNet Dr TRY', '', '3324 Street View', 'Winnipeg', '', '', '', 'SHIP-FAST', '', '2011-10-31 07:13:00', '', NULL, '', 'shrek', 1, 2, 2, '2011-10-20 15:15:07');

--
-- Dumping data for table `shipment_contacts`
--


--
-- Dumping data for table `shipment_contacts_revs`
--


--
-- Dumping data for table `sopd_general_alls`
--


--
-- Dumping data for table `sopd_general_alls_revs`
--


--
-- Dumping data for table `sopd_inventory_alls`
--

INSERT INTO `sopd_inventory_alls` (`id`, `sop_master_id`, `deleted`) VALUES
(1, 1, 0);

--
-- Dumping data for table `sopd_inventory_alls_revs`
--

INSERT INTO `sopd_inventory_alls_revs` (`id`, `sop_master_id`, `version_id`, `version_created`) VALUES
(1, 1, 1, '2011-10-19 13:00:47');

--
-- Dumping data for table `sope_general_all`
--


--
-- Dumping data for table `sope_general_all_revs`
--


--
-- Dumping data for table `sope_inventory_all`
--


--
-- Dumping data for table `sope_inventory_all_revs`
--


--
-- Dumping data for table `sop_masters`
--

INSERT INTO `sop_masters` (`id`, `sop_control_id`, `title`, `notes`, `code`, `version`, `status`, `expiry_date`, `expiry_date_accuracy`, `activated_date`, `activated_date_accuracy`, `scope`, `purpose`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `deleted`) VALUES
(1, 2, 'OV-Collection', '', 'OV-98437.sop', 'v1.13', 'activated', NULL, '', '2008-06-07', 'c', NULL, NULL, '2011-10-19 13:00:47', 1, '2011-10-19 13:00:47', 1, NULL, 0);

--
-- Dumping data for table `sop_masters_revs`
--

INSERT INTO `sop_masters_revs` (`id`, `sop_control_id`, `title`, `notes`, `code`, `version`, `status`, `expiry_date`, `expiry_date_accuracy`, `activated_date`, `activated_date_accuracy`, `scope`, `purpose`, `modified_by`, `form_id`, `version_id`, `version_created`) VALUES
(1, 2, 'OV-Collection', '', 'OV-98437.sop', 'v1.13', 'activated', NULL, '', '2008-06-07', 'c', NULL, NULL, 1, NULL, 1, '2011-10-19 13:00:47');

--
-- Dumping data for table `source_aliquots`
--

INSERT INTO `source_aliquots` (`id`, `sample_master_id`, `aliquot_master_id`, `used_volume`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 26, 28, '0.23000', '2011-10-19 18:42:37', 1, '2011-10-19 18:42:37', 1, 0),
(2, 27, 46, '0.23000', '2011-10-19 18:42:38', 1, '2011-10-19 18:45:41', 1, 1),
(3, 28, 46, '2.30000', '2011-10-19 18:42:39', 1, '2011-10-19 18:42:39', 1, 0);

--
-- Dumping data for table `source_aliquots_revs`
--

INSERT INTO `source_aliquots_revs` (`id`, `sample_master_id`, `aliquot_master_id`, `used_volume`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 26, 28, '0.23000', 1, 1, '2011-10-19 18:42:37'),
(2, 27, 46, '0.23000', 1, 2, '2011-10-19 18:42:38'),
(3, 28, 46, '2.30000', 1, 3, '2011-10-19 18:42:39'),
(2, 27, 46, '0.23000', 1, 4, '2011-10-19 18:45:41');

--
-- Dumping data for table `specimen_details`
--

INSERT INTO `specimen_details` (`id`, `sample_master_id`, `supplier_dept`, `reception_by`, `reception_datetime`, `reception_datetime_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 'suregry room', 'buzz lightyear', '2011-05-28 12:24:00', 'c', '2011-10-19 13:30:15', 1, '2011-10-19 13:30:15', 1, 0),
(2, 6, 'suregry room', 'buzz lightyear', '2011-05-28 12:38:00', 'c', '2011-10-19 13:37:24', 1, '2011-10-19 13:37:24', 1, 0),
(3, 7, 'patho dpt', 'buzz lightyear', '2011-05-28 13:07:00', 'c', '2011-10-19 13:41:24', 1, '2011-10-19 13:41:24', 1, 0),
(4, 9, 'suregry room', 'buzz lightyear', '2011-05-28 13:07:00', 'c', '2011-10-19 14:02:02', 1, '2011-10-19 14:02:02', 1, 0),
(5, 10, 'patho dpt', 'buzz lightyear', '2011-05-30 09:07:00', 'c', '2011-10-19 14:04:32', 1, '2011-10-19 14:04:32', 1, 0),
(6, 14, 'patho dpt', 'buzz lightyear', '2011-10-02 09:09:00', 'c', '2011-10-19 14:48:33', 1, '2011-10-19 14:48:33', 1, 0),
(7, 16, '', '', '2011-10-02 10:09:00', 'c', '2011-10-19 14:51:29', 1, '2011-10-19 14:51:29', 1, 0),
(8, 17, 'patho dpt', 'buzz lightyear', '2011-10-02 09:09:00', 'c', '2011-10-19 14:53:26', 1, '2011-10-19 14:53:26', 1, 0),
(9, 21, 'Clinic', 'buzz lightyear', '2011-10-02 08:09:00', 'c', '2011-10-19 14:58:01', 1, '2011-10-19 14:58:01', 1, 0),
(10, 22, 'Clinic', 'buzz lightyear', '2011-10-05 09:07:00', 'c', '2011-10-19 15:02:09', 1, '2011-10-19 15:16:50', 1, 1),
(11, 23, 'Clinic', 'buzz lightyear', '2011-10-05 09:07:00', 'c', '2011-10-19 15:07:14', 1, '2011-10-19 15:07:14', 1, 0);

--
-- Dumping data for table `specimen_details_revs`
--

INSERT INTO `specimen_details_revs` (`id`, `sample_master_id`, `supplier_dept`, `reception_by`, `reception_datetime`, `reception_datetime_accuracy`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, 'suregry room', 'buzz lightyear', '2011-05-28 12:24:00', 'c', 1, 1, '2011-10-19 13:30:16'),
(2, 6, 'suregry room', 'buzz lightyear', '2011-05-28 12:38:00', 'c', 1, 2, '2011-10-19 13:37:24'),
(3, 7, 'patho dpt', 'buzz lightyear', '2011-05-28 13:07:00', 'c', 1, 3, '2011-10-19 13:41:24'),
(4, 9, 'suregry room', 'buzz lightyear', '2011-05-28 13:07:00', 'c', 1, 4, '2011-10-19 14:02:02'),
(5, 10, 'patho dpt', 'buzz lightyear', '2011-05-30 09:07:00', 'c', 1, 5, '2011-10-19 14:04:32'),
(6, 14, 'patho dpt', 'buzz lightyear', '2011-10-02 09:09:00', 'c', 1, 6, '2011-10-19 14:48:34'),
(7, 16, '', '', '2011-10-02 10:09:00', 'c', 1, 7, '2011-10-19 14:51:29'),
(8, 17, 'patho dpt', 'buzz lightyear', '2011-10-02 09:09:00', 'c', 1, 8, '2011-10-19 14:53:26'),
(9, 21, 'Clinic', 'buzz lightyear', '2011-10-02 08:09:00', 'c', 1, 9, '2011-10-19 14:58:02'),
(10, 22, 'Clinic', 'buzz lightyear', '2011-10-05 09:07:00', 'c', 1, 10, '2011-10-19 15:02:09'),
(11, 23, 'Clinic', 'buzz lightyear', '2011-10-05 09:07:00', 'c', 1, 11, '2011-10-19 15:07:14'),
(10, 22, 'Clinic', 'buzz lightyear', '2011-10-05 09:07:00', 'c', 1, 12, '2011-10-19 15:16:50'),
(10, 22, 'Clinic', 'buzz lightyear', '2011-10-05 09:07:00', 'c', 1, 13, '2011-10-19 15:16:50');

--
-- Dumping data for table `specimen_review_masters`
--

INSERT INTO `specimen_review_masters` (`id`, `specimen_review_control_id`, `collection_id`, `sample_master_id`, `review_code`, `review_date`, `review_date_accuracy`, `review_status`, `pathologist`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 3, 16, '78994', '2011-10-30', 'c', 'done', 'Dr Minot', '', '2011-10-20 15:17:24', 1, '2011-10-20 15:17:24', 1, 0),
(2, 2, 3, 16, 'To del', NULL, '', '', '', '', '2011-10-20 15:18:44', 1, '2011-10-20 15:19:09', 1, 1),
(3, 2, 3, 16, 'test', NULL, '', '', '', '', '2011-10-20 15:25:19', 1, '2011-10-20 15:27:56', 1, 1),
(4, 1, 3, 16, 'to del', NULL, '', '', '', '', '2011-10-20 15:28:27', 1, '2011-10-20 15:29:25', 1, 1);

--
-- Dumping data for table `specimen_review_masters_revs`
--

INSERT INTO `specimen_review_masters_revs` (`id`, `specimen_review_control_id`, `collection_id`, `sample_master_id`, `review_code`, `review_date`, `review_date_accuracy`, `review_status`, `pathologist`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, 3, 16, '78994', '2011-10-30', 'c', 'done', 'Dr Minot', '', 1, 1, '2011-10-20 15:17:24'),
(2, 2, 3, 16, 'To del', NULL, '', '', '', '', 1, 2, '2011-10-20 15:18:44'),
(2, 2, 3, 16, 'To del', NULL, '', '', '', '', 1, 3, '2011-10-20 15:18:57'),
(2, 2, 3, 16, 'To del', NULL, '', '', '', '', 1, 4, '2011-10-20 15:19:09'),
(3, 2, 3, 16, 'test', NULL, '', '', '', '', 1, 5, '2011-10-20 15:25:19'),
(3, 2, 3, 16, 'test', NULL, '', '', '', '', 1, 6, '2011-10-20 15:27:56'),
(4, 1, 3, 16, 'to del', NULL, '', '', '', '', 1, 7, '2011-10-20 15:28:27'),
(4, 1, 3, 16, 'to del', NULL, '', '', '', '', 1, 8, '2011-10-20 15:28:40'),
(4, 1, 3, 16, 'to del', NULL, '', '', '', '', 1, 9, '2011-10-20 15:29:08'),
(4, 1, 3, 16, 'to del', NULL, '', '', '', '', 1, 10, '2011-10-20 15:29:25');

--
-- Dumping data for table `spr_breast_cancer_types`
--

INSERT INTO `spr_breast_cancer_types` (`id`, `specimen_review_master_id`, `type`, `other_type`, `tumour_grade_score_tubules`, `tumour_grade_score_nuclear`, `tumour_grade_score_mitosis`, `tumour_grade_score_total`, `tumour_grade_category`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 'lobular', NULL, '3.0', NULL, NULL, NULL, 'well diff', '2011-10-20 15:17:24', 1, '2011-10-20 15:17:24', 1, 0),
(2, 2, '', NULL, '1.1', NULL, NULL, NULL, '', '2011-10-20 15:18:44', 1, '2011-10-20 15:19:09', 1, 1),
(3, 3, '', NULL, NULL, NULL, NULL, NULL, '', '2011-10-20 15:25:19', 1, '2011-10-20 15:27:55', 1, 1),
(4, 4, '', NULL, NULL, NULL, NULL, NULL, '', '2011-10-20 15:28:27', 1, '2011-10-20 15:29:25', 1, 1);

--
-- Dumping data for table `spr_breast_cancer_types_revs`
--

INSERT INTO `spr_breast_cancer_types_revs` (`id`, `specimen_review_master_id`, `type`, `other_type`, `tumour_grade_score_tubules`, `tumour_grade_score_nuclear`, `tumour_grade_score_mitosis`, `tumour_grade_score_total`, `tumour_grade_category`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, 'lobular', NULL, '3.0', NULL, NULL, NULL, 'well diff', 1, 1, '2011-10-20 15:17:24'),
(2, 2, '', NULL, '1.0', NULL, NULL, NULL, '', 1, 2, '2011-10-20 15:18:44'),
(2, 2, '', NULL, '1.1', NULL, NULL, NULL, '', 1, 3, '2011-10-20 15:18:57'),
(2, 2, '', NULL, '1.1', NULL, NULL, NULL, '', 1, 4, '2011-10-20 15:19:09'),
(3, 3, '', NULL, NULL, NULL, NULL, NULL, '', 1, 5, '2011-10-20 15:25:19'),
(3, 3, '', NULL, NULL, NULL, NULL, NULL, '', 1, 6, '2011-10-20 15:27:55'),
(4, 4, '', NULL, NULL, NULL, NULL, NULL, '', 1, 7, '2011-10-20 15:28:27'),
(4, 4, '', NULL, NULL, NULL, NULL, NULL, '', 1, 8, '2011-10-20 15:28:40'),
(4, 4, '', NULL, NULL, NULL, NULL, NULL, '', 1, 9, '2011-10-20 15:29:08'),
(4, 4, '', NULL, NULL, NULL, NULL, NULL, '', 1, 10, '2011-10-20 15:29:25');

--
-- Dumping data for table `std_boxs`
--

INSERT INTO `std_boxs` (`id`, `storage_master_id`, `deleted`) VALUES
(1, 9, 0),
(2, 10, 0),
(3, 11, 0),
(4, 12, 0),
(5, 13, 0),
(6, 14, 0),
(7, 18, 0),
(8, 19, 0),
(9, 21, 0);

--
-- Dumping data for table `std_boxs_revs`
--

INSERT INTO `std_boxs_revs` (`id`, `storage_master_id`, `version_id`, `version_created`) VALUES
(1, 9, 1, '2011-10-19 13:13:14'),
(2, 10, 2, '2011-10-19 13:13:28'),
(3, 11, 3, '2011-10-19 13:14:14'),
(4, 12, 4, '2011-10-19 13:14:25'),
(5, 13, 5, '2011-10-19 13:14:58'),
(6, 14, 6, '2011-10-19 13:16:03'),
(7, 18, 7, '2011-10-19 13:17:41'),
(8, 19, 8, '2011-10-19 13:17:50'),
(9, 21, 9, '2011-10-19 14:28:51');

--
-- Dumping data for table `std_cupboards`
--


--
-- Dumping data for table `std_cupboards_revs`
--


--
-- Dumping data for table `std_freezers`
--

INSERT INTO `std_freezers` (`id`, `storage_master_id`, `deleted`) VALUES
(1, 1, 0);

--
-- Dumping data for table `std_freezers_revs`
--

INSERT INTO `std_freezers_revs` (`id`, `storage_master_id`, `version_id`, `version_created`) VALUES
(1, 1, 1, '2011-10-19 13:10:23');

--
-- Dumping data for table `std_fridges`
--


--
-- Dumping data for table `std_fridges_revs`
--


--
-- Dumping data for table `std_incubators`
--


--
-- Dumping data for table `std_incubators_revs`
--


--
-- Dumping data for table `std_nitro_locates`
--

INSERT INTO `std_nitro_locates` (`id`, `storage_master_id`, `deleted`) VALUES
(1, 15, 0);

--
-- Dumping data for table `std_nitro_locates_revs`
--

INSERT INTO `std_nitro_locates_revs` (`id`, `storage_master_id`, `version_id`, `version_created`) VALUES
(1, 15, 1, '2011-10-19 13:16:49');

--
-- Dumping data for table `std_racks`
--

INSERT INTO `std_racks` (`id`, `storage_master_id`, `deleted`) VALUES
(1, 5, 0),
(2, 6, 0),
(3, 7, 0),
(4, 8, 0),
(5, 16, 0),
(6, 17, 0);

--
-- Dumping data for table `std_racks_revs`
--

INSERT INTO `std_racks_revs` (`id`, `storage_master_id`, `version_id`, `version_created`) VALUES
(1, 5, 1, '2011-10-19 13:11:48'),
(2, 6, 2, '2011-10-19 13:11:59'),
(3, 7, 3, '2011-10-19 13:12:44'),
(4, 8, 4, '2011-10-19 13:12:52'),
(5, 16, 5, '2011-10-19 13:17:05'),
(6, 17, 6, '2011-10-19 13:17:12');

--
-- Dumping data for table `std_rooms`
--


--
-- Dumping data for table `std_rooms_revs`
--


--
-- Dumping data for table `std_shelfs`
--

INSERT INTO `std_shelfs` (`id`, `storage_master_id`, `deleted`) VALUES
(1, 2, 0),
(2, 3, 0),
(3, 4, 0);

--
-- Dumping data for table `std_shelfs_revs`
--

INSERT INTO `std_shelfs_revs` (`id`, `storage_master_id`, `version_id`, `version_created`) VALUES
(1, 2, 1, '2011-10-19 13:11:08'),
(2, 3, 2, '2011-10-19 13:11:19'),
(3, 4, 3, '2011-10-19 13:11:27');

--
-- Dumping data for table `std_tma_blocks`
--

INSERT INTO `std_tma_blocks` (`id`, `storage_master_id`, `sop_master_id`, `product_code`, `creation_datetime`, `creation_datetime_accuracy`, `deleted`) VALUES
(1, 20, 1, NULL, '2011-10-11 00:00:00', 'h', 0);

--
-- Dumping data for table `std_tma_blocks_revs`
--

INSERT INTO `std_tma_blocks_revs` (`id`, `storage_master_id`, `sop_master_id`, `product_code`, `creation_datetime`, `creation_datetime_accuracy`, `version_id`, `version_created`) VALUES
(1, 20, 1, NULL, '2011-10-11 00:00:00', 'h', 1, '2011-10-19 13:20:47');

--
-- Dumping data for table `storage_coordinates`
--


--
-- Dumping data for table `storage_coordinates_revs`
--


--
-- Dumping data for table `storage_masters`
--

INSERT INTO `storage_masters` (`id`, `code`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `parent_storage_coord_y`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'FRE - 1', 6, NULL, 1, 32, '98327898', 'fr1', 'fr1', '', '', '', '-82.00', 'celsius', '', '2011-10-19 13:10:22', 1, '2011-10-19 13:18:23', 1, 0),
(2, 'SH - 2', 14, 1, 2, 3, '78893', '1', 'fr1-1', '', '', '', '-82.00', 'celsius', '', '2011-10-19 13:11:08', 1, '2011-10-19 13:18:24', 1, 0),
(3, 'SH - 3', 14, 1, 4, 15, '788933', '2', 'fr1-2', '', '', '', '-82.00', 'celsius', '', '2011-10-19 13:11:19', 1, '2011-10-19 13:18:24', 1, 0),
(4, 'SH - 4', 14, 1, 16, 31, '2213', '3', 'fr1-3', '', '', '', '-82.00', 'celsius', '', '2011-10-19 13:11:27', 1, '2011-10-19 13:18:24', 1, 0),
(5, 'R10 - 5', 12, 4, 17, 24, '313313131', 'r1', 'fr1-3-r1', '', '', '', '-82.00', 'celsius', '', '2011-10-19 13:11:48', 1, '2011-10-19 13:18:25', 1, 0),
(6, 'R10 - 6', 12, 4, 25, 30, '3133133131', 'r2', 'fr1-3-r2', '', '', '', '-82.00', 'celsius', '', '2011-10-19 13:11:59', 1, '2011-10-19 13:18:25', 1, 0),
(7, 'R11 - 7', 15, 3, 5, 8, '41q123123', 'r43', 'fr1-2-r43', '', '', '', '-82.00', 'celsius', '', '2011-10-19 13:12:44', 1, '2011-10-19 13:18:26', 1, 0),
(8, 'R11 - 8', 15, 3, 9, 14, '41q1233123', 'r41', 'fr1-2-r41', '', '', '', '-82.00', 'celsius', '', '2011-10-19 13:12:52', 1, '2011-10-19 13:18:26', 1, 0),
(9, 'B25 - 9', 17, 8, 10, 11, '233232233', 'DNA', 'fr1-2-r41-DNA', '', '1', '', '-82.00', 'celsius', '', '2011-10-19 13:13:14', 1, '2011-10-19 13:18:26', 1, 0),
(10, 'B25 - 10', 17, 8, 12, 13, '2332322333', 'DNA2', 'fr1-2-r41-DNA2', '', '2', '', '-82.00', 'celsius', '', '2011-10-19 13:13:28', 1, '2011-10-19 13:18:26', 1, 0),
(11, 'B2D81 - 11', 9, 5, 18, 19, '124124124', 'BLOOD1', 'fr1-3-r1-BLOOD1', '', '1', '', '-82.00', 'celsius', '', '2011-10-19 13:14:14', 1, '2011-10-19 13:18:27', 1, 0),
(12, 'B2D81 - 12', 9, 5, 20, 21, '1241241224', 'BLOOD2', 'fr1-3-r1-BLOOD2', '', '2', '', '-82.00', 'celsius', '', '2011-10-19 13:14:25', 1, '2011-10-19 13:18:27', 1, 0),
(13, 'B2D81 - 13', 9, 5, 22, 23, '442121', 'RNA1', 'fr1-3-r1-RNA1', '', '3', '', '-82.00', 'celsius', '', '2011-10-19 13:14:58', 1, '2011-10-19 13:18:27', 1, 0),
(14, 'B - 14', 8, 6, 26, 29, '5234', 'TMA', 'fr1-3-r2-TMA', '', '5', '', '-82.00', 'celsius', '', '2011-10-19 13:16:03', 1, '2011-10-19 13:18:27', 1, 0),
(15, 'NL - 15', 3, NULL, 33, 42, '44232', 'Loc', 'Loc', '', '', '', '-179.00', 'celsius', '', '2011-10-19 13:16:48', 1, '2011-10-19 13:19:23', 1, 0),
(16, 'R10 - 16', 12, 15, 34, 35, '422424', '1', 'Loc-1', '', '', '', '-179.00', 'celsius', '', '2011-10-19 13:17:05', 1, '2011-10-19 13:19:24', 1, 0),
(17, 'R10 - 17', 12, 15, 36, 41, '4322424', '2', 'Loc-2', '', '', '', '-179.00', 'celsius', '', '2011-10-19 13:17:11', 1, '2011-10-19 13:19:25', 1, 0),
(18, 'B2D81 - 18', 9, 17, 37, 38, '413131', 'RNA.9', 'Loc-2-RNA.9', '', '2', '', '-179.00', 'celsius', '', '2011-10-19 13:17:41', 1, '2011-10-19 13:19:25', 1, 0),
(19, 'B2D81 - 19', 9, 17, 39, 40, '41222131', 'RNA.2', 'Loc-2-RNA.2', '', '3', '', '-179.00', 'celsius', '', '2011-10-19 13:17:50', 1, '2011-10-19 13:19:25', 1, 0),
(20, 'TMA609 - 20', 20, 14, 27, 28, '938912', 'TMA-007', 'fr1-3-r2-TMA-TMA-007', '', '', '', '-82.00', 'celsius', '', '2011-10-19 13:20:47', 1, '2011-10-19 13:20:48', 1, 0),
(21, 'B2D100 - 21', 18, 7, 6, 7, '41221123123', 'TISS1', 'fr1-2-r43-TISS1', '', '', '', '-82.00', 'celsius', '', '2011-10-19 14:28:50', 1, '2011-10-19 14:28:51', 1, 0);

UPDATE storage_masters SET code = id;
--
-- Dumping data for table `storage_masters_revs`
--

INSERT INTO `storage_masters_revs` (`id`, `code`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `parent_storage_coord_y`, `temperature`, `temp_unit`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '', 6, NULL, 1, 2, '98327898', 'fr1', 'fr1', '', '', '', '-80.00', 'celsius', '', 1, 1, '2011-10-19 13:10:23'),
(1, 'FRE - 1', 6, NULL, 1, 2, '98327898', 'fr1', 'fr1', '', '', '', '-80.00', 'celsius', '', 1, 2, '2011-10-19 13:10:23'),
(2, '', 14, 1, 0, 0, '78893', '1', 'fr1-1', '', '', '', '-80.00', 'celsius', '', 1, 3, '2011-10-19 13:11:08'),
(2, 'SH - 2', 14, 1, 2, 3, '78893', '1', 'fr1-1', '', '', '', '-80.00', 'celsius', '', 1, 4, '2011-10-19 13:11:09'),
(3, '', 14, 1, 0, 0, '788933', '2', 'fr1-2', '', '', '', '-80.00', 'celsius', '', 1, 5, '2011-10-19 13:11:19'),
(3, 'SH - 3', 14, 1, 4, 5, '788933', '2', 'fr1-2', '', '', '', '-80.00', 'celsius', '', 1, 6, '2011-10-19 13:11:20'),
(4, '', 14, 1, 0, 0, '2213', '3', 'fr1-3', '', '', '', '-80.00', 'celsius', '', 1, 7, '2011-10-19 13:11:27'),
(4, 'SH - 4', 14, 1, 6, 7, '2213', '3', 'fr1-3', '', '', '', '-80.00', 'celsius', '', 1, 8, '2011-10-19 13:11:28'),
(5, '', 12, 4, 0, 0, '313313131', 'r1', 'fr1-3-r1', '', '', '', '-80.00', 'celsius', '', 1, 9, '2011-10-19 13:11:48'),
(5, 'R10 - 5', 12, 4, 7, 8, '313313131', 'r1', 'fr1-3-r1', '', '', '', '-80.00', 'celsius', '', 1, 10, '2011-10-19 13:11:49'),
(6, '', 12, 4, 0, 0, '3133133131', 'r2', 'fr1-3-r2', '', '', '', '-80.00', 'celsius', '', 1, 11, '2011-10-19 13:11:59'),
(6, 'R10 - 6', 12, 4, 9, 10, '3133133131', 'r2', 'fr1-3-r2', '', '', '', '-80.00', 'celsius', '', 1, 12, '2011-10-19 13:12:00'),
(7, '', 15, 3, 0, 0, '41q123123', 'r43', 'fr1-2-r43', '', '', '', '-80.00', 'celsius', '', 1, 13, '2011-10-19 13:12:44'),
(7, 'R11 - 7', 15, 3, 5, 6, '41q123123', 'r43', 'fr1-2-r43', '', '', '', '-80.00', 'celsius', '', 1, 14, '2011-10-19 13:12:44'),
(8, '', 15, 3, 0, 0, '41q1233123', 'r41', 'fr1-2-r41', '', '', '', '-80.00', 'celsius', '', 1, 15, '2011-10-19 13:12:52'),
(8, 'R11 - 8', 15, 3, 7, 8, '41q1233123', 'r41', 'fr1-2-r41', '', '', '', '-80.00', 'celsius', '', 1, 16, '2011-10-19 13:12:53'),
(9, '', 17, 8, 0, 0, '233232233', 'DNA', 'fr1-2-r41-DNA', '', '1', '', '-80.00', 'celsius', '', 1, 17, '2011-10-19 13:13:15'),
(9, 'B25 - 9', 17, 8, 8, 9, '233232233', 'DNA', 'fr1-2-r41-DNA', '', '1', '', '-80.00', 'celsius', '', 1, 18, '2011-10-19 13:13:15'),
(10, '', 17, 8, 0, 0, '2332322333', 'DNA2', 'fr1-2-r41-DNA2', '', '2', '', '-80.00', 'celsius', '', 1, 19, '2011-10-19 13:13:28'),
(10, 'B25 - 10', 17, 8, 10, 11, '2332322333', 'DNA2', 'fr1-2-r41-DNA2', '', '2', '', '-80.00', 'celsius', '', 1, 20, '2011-10-19 13:13:29'),
(11, '', 9, 5, 0, 0, '124124124', 'BLOOD1', 'fr1-3-r1-BLOOD1', '', '1', '', '-80.00', 'celsius', '', 1, 21, '2011-10-19 13:14:14'),
(11, 'B2D81 - 11', 9, 5, 16, 17, '124124124', 'BLOOD1', 'fr1-3-r1-BLOOD1', '', '1', '', '-80.00', 'celsius', '', 1, 22, '2011-10-19 13:14:15'),
(12, '', 9, 5, 0, 0, '1241241224', 'BLOOD2', 'fr1-3-r1-BLOOD2', '', '2', '', '-80.00', 'celsius', '', 1, 23, '2011-10-19 13:14:25'),
(12, 'B2D81 - 12', 9, 5, 18, 19, '1241241224', 'BLOOD2', 'fr1-3-r1-BLOOD2', '', '2', '', '-80.00', 'celsius', '', 1, 24, '2011-10-19 13:14:26'),
(13, '', 9, 5, 0, 0, '442121', 'RNA1', 'fr1-3-r1-RNA1', '', '3', '', '-80.00', 'celsius', '', 1, 25, '2011-10-19 13:14:58'),
(13, 'B2D81 - 13', 9, 5, 20, 21, '442121', 'RNA1', 'fr1-3-r1-RNA1', '', '3', '', '-80.00', 'celsius', '', 1, 26, '2011-10-19 13:14:59'),
(14, '', 8, 6, 0, 0, '5234', 'TMA', 'fr1-3-r2-TMA', '', '5', '', '-80.00', 'celsius', '', 1, 27, '2011-10-19 13:16:03'),
(14, 'B - 14', 8, 6, 24, 25, '5234', 'TMA', 'fr1-3-r2-TMA', '', '5', '', '-80.00', 'celsius', '', 1, 28, '2011-10-19 13:16:04'),
(15, '', 3, 3, 0, 0, '44232', 'Loc', 'fr1-2-Loc', '', '', '', '-179.00', 'celsius', '', 1, 29, '2011-10-19 13:16:49'),
(15, 'NL - 15', 3, 3, 13, 14, '44232', 'Loc', 'fr1-2-Loc', '', '', '', '-179.00', 'celsius', '', 1, 30, '2011-10-19 13:16:49'),
(16, '', 12, 15, 0, 0, '422424', '1', 'fr1-2-Loc-1', '', '', '', '-179.00', 'celsius', '', 1, 31, '2011-10-19 13:17:05'),
(16, 'R10 - 16', 12, 15, 14, 15, '422424', '1', 'fr1-2-Loc-1', '', '', '', '-179.00', 'celsius', '', 1, 32, '2011-10-19 13:17:06'),
(17, '', 12, 15, 0, 0, '4322424', '2', 'fr1-2-Loc-2', '', '', '', '-179.00', 'celsius', '', 1, 33, '2011-10-19 13:17:12'),
(17, 'R10 - 17', 12, 15, 16, 17, '4322424', '2', 'fr1-2-Loc-2', '', '', '', '-179.00', 'celsius', '', 1, 34, '2011-10-19 13:17:12'),
(18, '', 9, 17, 0, 0, '413131', 'RNA.9', 'fr1-2-Loc-2-RNA.9', '', '2', '', '-179.00', 'celsius', '', 1, 35, '2011-10-19 13:17:41'),
(18, 'B2D81 - 18', 9, 17, 17, 18, '413131', 'RNA.9', 'fr1-2-Loc-2-RNA.9', '', '2', '', '-179.00', 'celsius', '', 1, 36, '2011-10-19 13:17:42'),
(19, '', 9, 17, 0, 0, '41222131', 'RNA.2', 'fr1-2-Loc-2-RNA.2', '', '3', '', '-179.00', 'celsius', '', 1, 37, '2011-10-19 13:17:50'),
(19, 'B2D81 - 19', 9, 17, 19, 20, '41222131', 'RNA.2', 'fr1-2-Loc-2-RNA.2', '', '3', '', '-179.00', 'celsius', '', 1, 38, '2011-10-19 13:17:50'),
(1, 'FRE - 1', 6, NULL, 1, 38, '98327898', 'fr1', 'fr1', '', '', '', '-82.00', 'celsius', '', 1, 39, '2011-10-19 13:18:23'),
(2, 'SH - 2', 14, 1, 2, 3, '78893', '1', 'fr1-1', '', '', '', '-82.00', 'celsius', '', 1, 40, '2011-10-19 13:18:24'),
(3, 'SH - 3', 14, 1, 4, 23, '788933', '2', 'fr1-2', '', '', '', '-82.00', 'celsius', '', 1, 41, '2011-10-19 13:18:24'),
(4, 'SH - 4', 14, 1, 24, 37, '2213', '3', 'fr1-3', '', '', '', '-82.00', 'celsius', '', 1, 42, '2011-10-19 13:18:25'),
(5, 'R10 - 5', 12, 4, 25, 32, '313313131', 'r1', 'fr1-3-r1', '', '', '', '-82.00', 'celsius', '', 1, 43, '2011-10-19 13:18:25'),
(6, 'R10 - 6', 12, 4, 33, 36, '3133133131', 'r2', 'fr1-3-r2', '', '', '', '-82.00', 'celsius', '', 1, 44, '2011-10-19 13:18:25'),
(7, 'R11 - 7', 15, 3, 5, 6, '41q123123', 'r43', 'fr1-2-r43', '', '', '', '-82.00', 'celsius', '', 1, 45, '2011-10-19 13:18:26'),
(8, 'R11 - 8', 15, 3, 7, 12, '41q1233123', 'r41', 'fr1-2-r41', '', '', '', '-82.00', 'celsius', '', 1, 46, '2011-10-19 13:18:26'),
(9, 'B25 - 9', 17, 8, 8, 9, '233232233', 'DNA', 'fr1-2-r41-DNA', '', '1', '', '-82.00', 'celsius', '', 1, 47, '2011-10-19 13:18:26'),
(10, 'B25 - 10', 17, 8, 10, 11, '2332322333', 'DNA2', 'fr1-2-r41-DNA2', '', '2', '', '-82.00', 'celsius', '', 1, 48, '2011-10-19 13:18:27'),
(11, 'B2D81 - 11', 9, 5, 26, 27, '124124124', 'BLOOD1', 'fr1-3-r1-BLOOD1', '', '1', '', '-82.00', 'celsius', '', 1, 49, '2011-10-19 13:18:27'),
(12, 'B2D81 - 12', 9, 5, 28, 29, '1241241224', 'BLOOD2', 'fr1-3-r1-BLOOD2', '', '2', '', '-82.00', 'celsius', '', 1, 50, '2011-10-19 13:18:27'),
(13, 'B2D81 - 13', 9, 5, 30, 31, '442121', 'RNA1', 'fr1-3-r1-RNA1', '', '3', '', '-82.00', 'celsius', '', 1, 51, '2011-10-19 13:18:27'),
(14, 'B - 14', 8, 6, 34, 35, '5234', 'TMA', 'fr1-3-r2-TMA', '', '5', '', '-82.00', 'celsius', '', 1, 52, '2011-10-19 13:18:28'),
(15, 'NL - 15', 3, NULL, 13, 22, '44232', 'Loc', 'Loc', '', '', '', '-179.00', 'celsius', '', 1, 53, '2011-10-19 13:19:24'),
(16, 'R10 - 16', 12, 15, 30, 31, '422424', '1', 'Loc-1', '', '', '', '-179.00', 'celsius', '', 1, 54, '2011-10-19 13:19:25'),
(17, 'R10 - 17', 12, 15, 32, 37, '4322424', '2', 'Loc-2', '', '', '', '-179.00', 'celsius', '', 1, 55, '2011-10-19 13:19:25'),
(18, 'B2D81 - 18', 9, 17, 33, 34, '413131', 'RNA.9', 'Loc-2-RNA.9', '', '2', '', '-179.00', 'celsius', '', 1, 56, '2011-10-19 13:19:25'),
(19, 'B2D81 - 19', 9, 17, 35, 36, '41222131', 'RNA.2', 'Loc-2-RNA.2', '', '3', '', '-179.00', 'celsius', '', 1, 57, '2011-10-19 13:19:25'),
(20, '', 20, 14, 0, 0, '938912', 'TMA-007', 'fr1-3-r2-TMA-TMA-007', '', '', '', '-82.00', 'celsius', '', 1, 58, '2011-10-19 13:20:47'),
(20, 'TMA609 - 20', 20, 14, 25, 26, '938912', 'TMA-007', 'fr1-3-r2-TMA-TMA-007', '', '', '', '-82.00', 'celsius', '', 1, 59, '2011-10-19 13:20:48'),
(21, '', 18, 7, 0, 0, '41221123123', 'TISS1', 'fr1-2-r43-TISS1', '', '', '', '-82.00', 'celsius', '', 1, 60, '2011-10-19 14:28:51'),
(21, 'B2D100 - 21', 18, 7, 6, 7, '41221123123', 'TISS1', 'fr1-2-r43-TISS1', '', '', '', '-82.00', 'celsius', '', 1, 61, '2011-10-19 14:28:52');

UPDATE storage_masters_revs SET code = id;	

--
-- Dumping data for table `structure_permissible_values_customs`
--

INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(13, 7, 'v3', 'v3.0', 'v3.0', 0, 1, '2011-10-19 02:03:24', 1, '2011-10-19 02:03:35', 1, 0),
(14, 7, 'v2', 'v2.0', 'v2.0', 0, 0, '2011-10-19 02:03:24', 1, '2011-10-19 02:03:24', 1, 0),
(15, 7, 'v1', 'v1.0', 'v1.0', 0, 1, '2011-10-19 02:03:24', 1, '2011-10-19 02:03:24', 1, 0),
(16, 2, 'ctrnet', 'CTRNet', 'CTRNet', 0, 1, '2011-10-19 02:04:17', 1, '2011-10-19 02:04:17', 1, 0),
(17, 2, 'floor4-lab', 'Lab floor 4', 'Lab Étage 4', 0, 1, '2011-10-19 02:04:17', 1, '2011-10-19 02:04:17', 1, 0),
(18, 1, 'shrek', 'Shrek', 'Shrek', 0, 1, '2011-10-19 02:05:56', 1, '2011-10-19 02:05:56', 1, 0),
(19, 1, 'buzz lightyear', 'Buzz Lightyear', 'Buzz Lightyear', 0, 1, '2011-10-19 02:05:57', 1, '2011-10-19 02:05:57', 1, 0),
(20, 5, 'Spectro500', 'Spectro500', 'Spectro500', 0, 1, '2011-10-19 02:06:42', 1, '2011-10-19 02:06:42', 1, 0),
(21, 5, 'BioAnlayzer1044', 'BioAnlayzer1044', 'BioAnlayzer1044', 0, 1, '2011-10-19 02:06:42', 1, '2011-10-19 02:06:42', 1, 0),
(22, 5, 'BioAnlayzer1000', 'BioAnlayzer1000', 'BioAnlayzer1000', 0, 1, '2011-10-19 02:06:43', 1, '2011-10-19 02:06:43', 1, 0),
(23, 6, 'v1.13', 'v1.13', 'v1.13', 0, 1, '2011-10-19 02:07:16', 1, '2011-10-19 02:07:16', 1, 0),
(24, 3, 'external clinic', 'External Clinic', 'Clinique externe', 0, 1, '2011-10-19 02:08:25', 1, '2011-10-19 02:08:25', 1, 0),
(25, 3, 'surgery room', 'Surgery Room', 'Chambre Opératoire', 0, 1, '2011-10-19 02:08:25', 1, '2011-10-19 02:08:25', 1, 0),
(26, 3, 'clinic', 'Clinic', 'Clinique', 0, 1, '2011-10-19 02:08:25', 1, '2011-10-19 02:08:25', 1, 0),
(27, 4, 'Clinic', 'Clinic', 'Clinique', 0, 1, '2011-10-19 02:09:33', 1, '2011-10-19 02:09:33', 1, 0),
(28, 4, 'patho dpt', 'Pahto. Dpet.', 'Dept. Patho.', 0, 1, '2011-10-19 02:09:33', 1, '2011-10-19 02:09:33', 1, 0),
(29, 4, 'suregry room', 'Suregry Room', 'Chambre Opératoire', 0, 1, '2011-10-19 02:09:33', 1, '2011-10-19 02:09:33', 1, 0);

--
-- Dumping data for table `structure_permissible_values_customs_revs`
--

INSERT INTO `structure_permissible_values_customs_revs` (`id`, `control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `modified_by`, `version_id`, `version_created`) VALUES
(13, 7, 'v3', 'v3.0', 'v3.0', 0, 0, 1, 16, '2011-10-19 02:03:24'),
(14, 7, 'v2', 'v2.0', 'v2.0', 0, 0, 1, 17, '2011-10-19 02:03:24'),
(15, 7, 'v1', 'v1.0', 'v1.0', 0, 1, 1, 18, '2011-10-19 02:03:24'),
(13, 7, 'v3', 'v3.0', 'v3.0', 0, 1, 1, 19, '2011-10-19 02:03:35'),
(16, 2, 'ctrnet', 'CTRNet', 'CTRNet', 0, 1, 1, 20, '2011-10-19 02:04:17'),
(17, 2, 'floor4-lab', 'Lab floor 4', 'Lab Étage 4', 0, 1, 1, 21, '2011-10-19 02:04:17'),
(18, 1, 'shrek', 'Shrek', 'Shrek', 0, 1, 1, 22, '2011-10-19 02:05:56'),
(19, 1, 'buzz lightyear', 'Buzz Lightyear', 'Buzz Lightyear', 0, 1, 1, 23, '2011-10-19 02:05:57'),
(20, 5, 'Spectro500', 'Spectro500', 'Spectro500', 0, 1, 1, 24, '2011-10-19 02:06:42'),
(21, 5, 'BioAnlayzer1044', 'BioAnlayzer1044', 'BioAnlayzer1044', 0, 1, 1, 25, '2011-10-19 02:06:43'),
(22, 5, 'BioAnlayzer1000', 'BioAnlayzer1000', 'BioAnlayzer1000', 0, 1, 1, 26, '2011-10-19 02:06:43'),
(23, 6, 'v1.13', 'v1.13', 'v1.13', 0, 1, 1, 27, '2011-10-19 02:07:16'),
(24, 3, 'external clinic', 'External Clinic', 'Clinique externe', 0, 1, 1, 28, '2011-10-19 02:08:25'),
(25, 3, 'surgery room', 'Surgery Room', 'Chambre Opératoire', 0, 1, 1, 29, '2011-10-19 02:08:25'),
(26, 3, 'clinic', 'Clinic', 'Clinique', 0, 1, 1, 30, '2011-10-19 02:08:25'),
(27, 4, 'Clinic', 'Clinic', 'Clinique', 0, 1, 1, 31, '2011-10-19 02:09:33'),
(28, 4, 'patho dpt', 'Pahto. Dpet.', 'Dept. Patho.', 0, 1, 1, 32, '2011-10-19 02:09:33'),
(29, 4, 'suregry room', 'Suregry Room', 'Chambre Opératoire', 0, 1, 1, 33, '2011-10-19 02:09:34');

--
-- Dumping data for table `study_contacts`
--


--
-- Dumping data for table `study_contacts_revs`
--


--
-- Dumping data for table `study_ethics_boards`
--


--
-- Dumping data for table `study_ethics_boards_revs`
--


--
-- Dumping data for table `study_fundings`
--


--
-- Dumping data for table `study_fundings_revs`
--


--
-- Dumping data for table `study_investigators`
--


--
-- Dumping data for table `study_investigators_revs`
--


--
-- Dumping data for table `study_related`
--


--
-- Dumping data for table `study_related_revs`
--


--
-- Dumping data for table `study_results`
--


--
-- Dumping data for table `study_results_revs`
--


--
-- Dumping data for table `study_reviews`
--


--
-- Dumping data for table `study_reviews_revs`
--


--
-- Dumping data for table `study_summaries`
--

INSERT INTO `study_summaries` (`id`, `disease_site`, `study_type`, `study_science`, `study_use`, `title`, `start_date`, `start_date_accuracy`, `end_date`, `end_date_accuracy`, `summary`, `abstract`, `hypothesis`, `approach`, `analysis`, `significance`, `additional_clinical`, `created`, `created_by`, `modified`, `modified_by`, `path_to_file`, `deleted`) VALUES
(1, 'female genital - ovary', NULL, NULL, NULL, 'TFRI COEUR', '2010-04-07', 'c', NULL, '', '', NULL, NULL, NULL, NULL, NULL, NULL, '2011-10-19 12:59:18', 1, '2011-10-19 12:59:18', 1, NULL, 0),
(2, 'male genital - prostate', NULL, NULL, NULL, 'PRO-stat', '2010-01-01', 'y', NULL, '', '', NULL, NULL, NULL, NULL, NULL, NULL, '2011-10-19 12:59:56', 1, '2011-10-19 12:59:56', 1, NULL, 0);

--
-- Dumping data for table `study_summaries_revs`
--

INSERT INTO `study_summaries_revs` (`id`, `disease_site`, `study_type`, `study_science`, `study_use`, `title`, `start_date`, `start_date_accuracy`, `end_date`, `end_date_accuracy`, `summary`, `abstract`, `hypothesis`, `approach`, `analysis`, `significance`, `additional_clinical`, `modified_by`, `path_to_file`, `version_id`, `version_created`) VALUES
(1, 'female genital - ovary', NULL, NULL, NULL, 'TFRI COEUR', '2010-04-07', 'c', NULL, '', '', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, '2011-10-19 12:59:18'),
(2, 'male genital - prostate', NULL, NULL, NULL, 'PRO-stat', '2010-01-01', 'y', NULL, '', '', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 2, '2011-10-19 12:59:56');

--
-- Dumping data for table `templates`
--

INSERT INTO `templates` (`id`, `flag_system`, `name`, `owner`, `visibility`, `flag_active`, `owning_entity_id`, `visible_entity_id`) VALUES
(1, 0, 'Ov. Tissue Coll', 'user', 'user', 1, 1, 1),
(2, 0, 'OV Blood', 'user', 'user', 1, 1, 1);

--
-- Dumping data for table `template_nodes`
--

INSERT INTO `template_nodes` (`id`, `parent_id`, `template_id`, `datamart_structure_id`, `control_id`, `quantity`) VALUES
(1, NULL, 1, 5, 1, 1),
(2, 1, 1, 1, 2, 2),
(3, 1, 1, 5, 5, 1),
(4, 3, 1, 1, 12, 4),
(5, NULL, 1, 5, 3, 1),
(6, 5, 1, 1, 9, 3),
(7, 5, 1, 1, 1, 2),
(8, 5, 1, 1, 10, 1),
(9, NULL, 1, 5, 3, 1),
(10, 9, 1, 5, 12, 1),
(11, 10, 1, 1, 29, 3),
(12, 9, 1, 5, 13, 1),
(13, 12, 1, 1, 30, 3),
(14, 12, 1, 5, 17, 1),
(15, 14, 1, 1, 31, 1),
(16, NULL, 2, 5, 2, 1),
(17, 16, 2, 5, 7, 1),
(18, 17, 2, 1, 36, 3),
(19, 17, 2, 5, 12, 1),
(20, 19, 2, 1, 29, 2),
(21, 16, 2, 5, 9, 1),
(22, 21, 2, 1, 16, 3),
(23, 16, 2, 5, 10, 1),
(24, 23, 2, 1, 17, 3),
(25, NULL, 2, 5, 2, 1),
(26, 25, 2, 1, 3, 3),
(27, 25, 2, 1, 11, 1);

--
-- Dumping data for table `tma_slides`
--


--
-- Dumping data for table `tma_slides_revs`
--


--
-- Dumping data for table `tmp_bogus_primary_dx`
--


--
-- Dumping data for table `txd_chemos`
--

INSERT INTO `txd_chemos` (`id`, `chemo_completed`, `response`, `num_cycles`, `length_cycles`, `completed_cycles`, `tx_master_id`, `deleted`) VALUES
(1, 'yes', 'complete', NULL, NULL, NULL, 3, 0),
(2, 'yes', 'partial', NULL, NULL, NULL, 8, 0),
(3, 'no', 'unknown', NULL, NULL, NULL, 11, 0);

--
-- Dumping data for table `txd_chemos_revs`
--

INSERT INTO `txd_chemos_revs` (`id`, `chemo_completed`, `response`, `num_cycles`, `length_cycles`, `completed_cycles`, `tx_master_id`, `version_id`, `version_created`) VALUES
(1, 'yes', 'complete', NULL, NULL, NULL, 3, 1, '2011-10-19 02:30:06'),
(2, 'yes', 'partial', NULL, NULL, NULL, 8, 2, '2011-10-19 02:48:50'),
(3, 'no', 'unknown', NULL, NULL, NULL, 11, 3, '2011-10-19 02:53:34');

--
-- Dumping data for table `txd_radiations`
--

INSERT INTO `txd_radiations` (`id`, `rad_completed`, `tx_master_id`, `deleted`) VALUES
(1, 'yes', 4, 0);

--
-- Dumping data for table `txd_radiations_revs`
--

INSERT INTO `txd_radiations_revs` (`id`, `rad_completed`, `tx_master_id`, `version_id`, `version_created`) VALUES
(1, 'yes', 4, 1, '2011-10-19 02:30:59');

--
-- Dumping data for table `txd_surgeries`
--

INSERT INTO `txd_surgeries` (`id`, `path_num`, `primary`, `tx_master_id`, `deleted`) VALUES
(1, '#873', NULL, 1, 0),
(2, '#8906', NULL, 2, 0),
(3, '', NULL, 5, 0),
(4, '#457832', NULL, 6, 0),
(5, '', NULL, 7, 0),
(6, '', NULL, 9, 0),
(7, '', NULL, 10, 0);

--
-- Dumping data for table `txd_surgeries_revs`
--

INSERT INTO `txd_surgeries_revs` (`id`, `path_num`, `primary`, `tx_master_id`, `version_id`, `version_created`) VALUES
(1, '#873', NULL, 1, 1, '2011-10-19 02:28:32'),
(2, '#8906', NULL, 2, 2, '2011-10-19 02:29:06'),
(3, '', NULL, 5, 3, '2011-10-19 02:46:47'),
(4, '#457832', NULL, 6, 4, '2011-10-19 02:47:03'),
(5, '', NULL, 7, 5, '2011-10-19 02:48:02'),
(6, '', NULL, 9, 6, '2011-10-19 02:52:38'),
(7, '', NULL, 10, 7, '2011-10-19 02:52:49');

--
-- Dumping data for table `txe_chemos`
--

INSERT INTO `txe_chemos` (`id`, `dose`, `method`, `drug_id`, `tx_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, '', 'IV: Intravenous', 3, 3, '2011-10-19 02:30:20', 1, '2011-10-19 02:30:20', 1, 0),
(2, '', 'IV: Intravenous', 1, 3, '2011-10-19 02:30:20', 1, '2011-10-19 02:30:20', 1, 0),
(3, '', 'IV: Intravenous', 2, 3, '2011-10-19 02:30:20', 1, '2011-10-19 02:30:20', 1, 0),
(4, '', 'IV: Intravenous', 3, 11, '2011-10-19 02:53:43', 1, '2011-10-19 02:53:43', 1, 0),
(5, '', 'IV: Intravenous', 1, 11, '2011-10-19 02:53:43', 1, '2011-10-19 02:53:52', 1, 1),
(6, '', 'IV: Intravenous', 2, 11, '2011-10-19 02:53:43', 1, '2011-10-19 02:53:43', 1, 0);

--
-- Dumping data for table `txe_chemos_revs`
--

INSERT INTO `txe_chemos_revs` (`id`, `dose`, `method`, `drug_id`, `tx_master_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '', 'IV: Intravenous', 3, 3, 1, 1, '2011-10-19 02:30:20'),
(2, '', 'IV: Intravenous', 1, 3, 1, 2, '2011-10-19 02:30:20'),
(3, '', 'IV: Intravenous', 2, 3, 1, 3, '2011-10-19 02:30:20'),
(4, '', 'IV: Intravenous', 3, 11, 1, 4, '2011-10-19 02:53:43'),
(5, '', 'IV: Intravenous', 1, 11, 1, 5, '2011-10-19 02:53:43'),
(6, '', 'IV: Intravenous', 2, 11, 1, 6, '2011-10-19 02:53:43'),
(5, '', 'IV: Intravenous', 1, 11, 1, 7, '2011-10-19 02:53:53');

--
-- Dumping data for table `txe_radiations`
--


--
-- Dumping data for table `txe_radiations_revs`
--


--
-- Dumping data for table `txe_surgeries`
--


--
-- Dumping data for table `txe_surgeries_revs`
--


--
-- Dumping data for table `tx_masters`
--

INSERT INTO `tx_masters` (`id`, `tx_control_id`, `tx_intent`, `target_site_icdo`, `start_date`, `start_date_accuracy`, `finish_date`, `finish_date_accuracy`, `information_source`, `facility`, `notes`, `protocol_master_id`, `participant_id`, `diagnosis_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 3, 'curative', NULL, '2010-09-09', 'c', NULL, '', 'path report', 'Building A', '', NULL, 1, 2, '2011-10-19 02:28:32', 1, '2011-10-19 02:28:32', 1, 0),
(2, 3, 'curative', NULL, '1997-01-01', 'y', NULL, '', '', '', '', NULL, 1, 5, '2011-10-19 02:29:06', 1, '2011-10-19 02:29:06', 1, 0),
(3, 1, 'curative', NULL, '2010-10-13', 'c', NULL, '', '', '', '', 1, 1, 3, '2011-10-19 02:30:06', 1, '2011-10-19 02:30:06', 1, 0),
(4, 2, 'curative', NULL, '1997-01-01', 'y', NULL, '', '', '', '', NULL, 1, 5, '2011-10-19 02:30:58', 1, '2011-10-19 02:30:58', 1, 0),
(5, 3, 'curative', NULL, '2006-01-01', 'm', NULL, '', '', '', '', NULL, 2, 8, '2011-10-19 02:46:47', 1, '2011-10-19 02:46:47', 1, 0),
(6, 3, 'curative', NULL, '2007-01-01', 'm', NULL, '', '', '', '', NULL, 2, 8, '2011-10-19 02:47:03', 1, '2011-10-19 02:47:03', 1, 0),
(7, 3, 'curative', NULL, '2011-01-01', 'c', NULL, '', '', '', '', NULL, 2, NULL, '2011-10-19 02:48:02', 1, '2011-10-19 02:48:02', 1, 0),
(8, 1, 'curative', NULL, '2011-01-01', 'm', NULL, '', '', 'Building A', '', 1, 2, 9, '2011-10-19 02:48:50', 1, '2011-10-19 02:48:50', 1, 0),
(9, 3, 'curative', NULL, '2011-04-08', 'c', NULL, '', '', 'Building A', '', NULL, 3, 10, '2011-10-19 02:52:37', 1, '2011-10-19 02:55:13', 1, 0),
(10, 3, 'curative', NULL, '2011-07-08', 'c', NULL, '', '', 'Building A', '', NULL, 3, 10, '2011-10-19 02:52:49', 1, '2011-10-19 02:54:42', 1, 0),
(11, 1, 'curative', NULL, '2011-07-13', 'c', NULL, '', '', '', '', 1, 3, 12, '2011-10-19 02:53:34', 1, '2011-10-19 02:53:34', 1, 0);

--
-- Dumping data for table `tx_masters_revs`
--

INSERT INTO `tx_masters_revs` (`id`, `tx_control_id`, `tx_intent`, `target_site_icdo`, `start_date`, `start_date_accuracy`, `finish_date`, `finish_date_accuracy`, `information_source`, `facility`, `notes`, `modified_by`, `protocol_master_id`, `participant_id`, `diagnosis_master_id`, `version_id`, `version_created`) VALUES
(1, 3, 'curative', NULL, '2010-09-09', 'c', NULL, '', 'path report', 'Building A', '', 1, NULL, 1, 2, 1, '2011-10-19 02:28:32'),
(2, 3, 'curative', NULL, '1997-01-01', 'y', NULL, '', '', '', '', 1, NULL, 1, 5, 2, '2011-10-19 02:29:06'),
(3, 1, 'curative', NULL, '2010-10-13', 'c', NULL, '', '', '', '', 1, 1, 1, 3, 3, '2011-10-19 02:30:06'),
(4, 2, 'curative', NULL, '1997-01-01', 'y', NULL, '', '', '', '', 1, NULL, 1, 5, 4, '2011-10-19 02:30:59'),
(5, 3, 'curative', NULL, '2006-01-01', 'm', NULL, '', '', '', '', 1, NULL, 2, 8, 5, '2011-10-19 02:46:47'),
(6, 3, 'curative', NULL, '2007-01-01', 'm', NULL, '', '', '', '', 1, NULL, 2, 8, 6, '2011-10-19 02:47:03'),
(7, 3, 'curative', NULL, '2011-01-01', 'c', NULL, '', '', '', '', 1, NULL, 2, NULL, 7, '2011-10-19 02:48:02'),
(8, 1, 'curative', NULL, '2011-01-01', 'm', NULL, '', '', 'Building A', '', 1, 1, 2, 9, 8, '2011-10-19 02:48:50'),
(9, 3, 'curative', NULL, '2011-04-08', 'c', NULL, '', '', 'Building A', '', 1, NULL, 3, NULL, 9, '2011-10-19 02:52:38'),
(10, 3, 'curative', NULL, '2011-07-08', 'c', NULL, '', '', 'Building A', '', 1, NULL, 3, NULL, 10, '2011-10-19 02:52:49'),
(11, 1, 'curative', NULL, '2011-07-13', 'c', NULL, '', '', '', '', 1, 1, 3, 12, 11, '2011-10-19 02:53:34'),
(10, 3, 'curative', NULL, '2011-07-08', 'c', NULL, '', '', 'Building A', '', 1, NULL, 3, 10, 12, '2011-10-19 02:54:42'),
(9, 3, 'curative', NULL, '2011-04-08', 'c', NULL, '', '', 'Building A', '', 1, NULL, 3, 10, 13, '2011-10-19 02:55:13');

SET FOREIGN_KEY_CHECKS=1;

-- -------------------------------------------------------------------
-- CUSTOM QUERY EXAMPLE
-- -------------------------------------------------------------------

INSERT INTO `datamart_adhoc` (`id`, `title`, `description`, `plugin`, `model`, `form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, `sql_query_for_results`, `function_for_results`) VALUES
(null, 'QR_AQ_1_Demo', 'QR_AQ_1_Demo_Description', 'Inventorymanagement', 'AliquotMaster', 'QR_AQ_complexe', 'QR_AQ_complexe', 'participant detail=>/clinicalannotation/participants/profile/%%Participant.id%%/|aliquot detail=>/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/', 
 'SELECT 
AliquotMaster.id,
AliquotMaster.sample_master_id,
AliquotMaster.collection_id,
Participant.id,
Participant.participant_identifier,
Participant.sex,
AliquotMaster.barcode,
AliquotMaster.aliquot_label,
SampleControl.sample_type,
AliquotControl.aliquot_type,
AliquotMaster.in_stock
FROM participants AS Participant
INNER JOIN clinical_collection_links AS link ON link.participant_id = Participant.id
INNER JOIN collections AS Collection ON Collection.id = link.collection_id
INNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id
INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id 
INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id 
INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
LEFT JOIN storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id 
WHERE TRUE
AND Participant.participant_identifier = "@@Participant.participant_identifier@@" 
AND Participant.sex = "@@Participant.sex@@" 
AND SampleControl.sample_type = "@@SampleControl.sample_type@@" 
AND AliquotControl.aliquot_type = "@@AliquotControl.aliquot_type@@"  
AND AliquotMaster.in_stock = "@@AliquotMaster.in_stock@@"
ORDER BY Participant.participant_identifier;', '');

INSERT INTO datamart_adhoc_permissions (group_id,datamart_adhoc_id) VALUES ('1', (SELECT id FROM datamart_adhoc WHERE title = 'QR_AQ_1_Demo'));

INSERT INTO structures(`alias`) VALUES ('QR_AQ_complexe');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier'), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), 
(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `type`='select'), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `type`='input'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), 
(SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `field`='sample_type' AND `type`='select'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `field`='aliquot_type' AND `type`='select'), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `field`='in_stock' AND `type`='select'), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), 
(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `type`='input'), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO i18n (id, en, fr) VALUES
('QR_AQ_1_Demo_Description',
 'Search based on Participant + Aliquots criteria & Display Participant + Aliquots data<br/> (<b>model</b> = ''AliquotMaster'', <b>form_alias_for_search</b> = ''QR_AQ_complexe'', <b>form_alias_for_results</b> = ''QR_AQ_complexe'', <b>flag_use_control_for_results</b> = 1)',
 'Search based on Participant + Aliquots criteria & Display Participant + Aliquots data<br/> (<b>model</b> = ''AliquotMaster'', <b>form_alias_for_search</b> = ''QR_AQ_complexe'', <b>form_alias_for_results</b> = ''QR_AQ_complexe'', <b>flag_use_control_for_results</b> = 1)');

-- Ex 2:
 
INSERT INTO `datamart_adhoc` (`id`, `title`, `description`, `plugin`, `model`, `form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, `sql_query_for_results`, `function_for_results`) VALUES
(null, 'QR_AQ_2_Demo', 'QR_AQ_2_Demo_Description', 'Inventorymanagement', 'AliquotMaster', 'QR_AQ_complexe', 'aliquot_masters_for_collection_tree_view', 'aliquot detail=>/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/', 
 'SELECT 
AliquotMaster.id,
AliquotMaster.sample_master_id,
AliquotMaster.collection_id,
Participant.id,
Participant.participant_identifier,
Participant.sex,
AliquotMaster.barcode,
AliquotMaster.aliquot_label,
SampleControl.sample_type,
AliquotControl.aliquot_type,
AliquotDetail.block_type,
AliquotMaster.in_stock,
AliquotMaster.storage_coord_x,
AliquotMaster.storage_coord_y,
StorageMaster.selection_label,
StorageMaster.temperature,
StorageMaster.temp_unit
FROM participants AS Participant
INNER JOIN clinical_collection_links AS link ON link.participant_id = Participant.id
INNER JOIN collections AS Collection ON Collection.id = link.collection_id
INNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id
INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id 
INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id
INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id 
LEFT JOIN storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id 
LEFT JOIN ad_blocks AS AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id 
WHERE TRUE
AND Participant.participant_identifier = "@@Participant.participant_identifier@@" 
AND Participant.sex = "@@Participant.sex@@" 
AND SampleCpontrol.sample_type = "@@SampleControl.sample_type@@" 
AND AliquotControl.aliquot_type = "@@AliquotControl.aliquot_type@@"  
AND AliquotMaster.in_stock = "@@AliquotMaster.in_stock@@"
ORDER BY Participant.participant_identifier;', '');

INSERT INTO datamart_adhoc_permissions (group_id,datamart_adhoc_id) VALUES ('1', (SELECT id FROM datamart_adhoc WHERE title = 'QR_AQ_2_Demo'));

-- Ex 3:
 
INSERT INTO `datamart_adhoc` (`id`, `title`, `description`, `plugin`, `model`, `form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, `sql_query_for_results`, `function_for_results`) VALUES
(null, 'QR_AQ_3_Demo', 'QR_AQ_3_Demo_Description', 'Inventorymanagement', 'AliquotMaster', 'QR_AQ_complexe_3', 'QR_AQ_complexe_3', 'storage detail=>/storagelayout/storage_masters/detail/%%StorageMaster.id%%/|aliquot detail=>/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%/', 
'SELECT 
Collection.id,
SampleMaster.id,
AliquotMaster.id,
StorageMaster.id, 
Collection.acquisition_label,
AliquotMaster.barcode, 
Collection.bank_id, 
SampleControl.sample_type, 
AliquotControl.aliquot_type, 
AliquotMaster.aliquot_label,
AliquotMaster.in_stock,
AliquotMaster.storage_datetime, 
StorageMaster.short_label, 
StorageMaster.selection_label, 
AliquotMaster.storage_coord_x, 
AliquotMaster.storage_coord_y, 
StorageMaster.temperature, 
StorageMaster.temp_unit 
FROM collections AS Collection 
INNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id
INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id  
INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id
INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id 
INNER JOIN storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id 
WHERE TRUE
AND Collection.acquisition_label = "@@Collection.acquisition_label@@"
AND AliquotMaster.barcode = "@@AliquotMaster.barcode@@" 
AND Collection.bank_id = "@@Collection.bank_id@@"
AND SampleControl.sample_type = "@@SampleControl.sample_type@@" 
AND AliquotMaster.aliquot_control_id IN (SELECT id FROM aliquot_controls WHERE aliquot_type = "tube")
AND AliquotMaster.in_stock = "@@AliquotMaster.in_stock@@" 
AND AliquotMaster.storage_datetime >= "@@AliquotMaster.storage_datetime_start@@" 
AND AliquotMaster.storage_datetime <= "@@AliquotMaster.storage_datetime_end@@" 
AND (StorageMaster.short_label = "@@StorageMaster.short_label@@"
AND (StorageMaster.short_label >= "@@StorageMaster.short_label_start@@" 
AND StorageMaster.short_label <= "@@StorageMaster.short_label_end@@"))
AND StorageMaster.temperature >= "@@StorageMaster.temperature_start@@" 
AND StorageMaster.temperature <= "@@StorageMaster.temperature_end@@" 
AND StorageMaster.temp_unit = "@@StorageMaster.temp_unit@@" 
ORDER BY AliquotMaster.barcode;', '');

INSERT INTO datamart_adhoc_permissions (group_id,datamart_adhoc_id) VALUES ('1', (SELECT id FROM datamart_adhoc WHERE title = 'QR_AQ_3_Demo'));

INSERT INTO structures(`alias`) VALUES ('QR_AQ_complexe_3');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'barcode', 'input',  NULL , '0', 'tool=csv', '', '', 'barcode', ''), 
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'aliquot_label', 'input',  NULL , '0', 'tool=csv', '', '', 'aliquot label', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='tool=csv' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `field`='sample_type' AND `type`='select'), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='AliquotControl' AND `field`='aliquot_type' AND `type`='select'), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='yes - available' AND `language_help`='aliquot_in_stock_help' AND `language_label`='aliquot in stock' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='initial storage date' AND `language_tag`=''), '0', '6', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='short_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '1', 'class=range', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='selection_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='stor_selection_label_defintion' AND `language_label`='storage' AND `language_tag`=''), '0', '7', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_x' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='position into storage' AND `language_tag`=''), '0', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='storage_coord_y' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=4' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temperature' AND `type`='float' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='storage temperature' AND `language_tag`=''), '0', '11', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='StorageMaster' AND `tablename`='storage_masters' AND `field`='temp_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='temperature_unit_code')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`=''), '0', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='bank_id' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='inv_collection_bank_defintion' AND `language_label`='collection bank' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='inv_acquisition_label_defintion' AND `language_label`='acquisition_label' AND `language_tag`=''), '0', '-1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='tool=csv' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
 
INSERT INTO i18n (id, en, fr) VALUES 
('QR_AQ_3_Demo_Description',
 'Search Stored Sample Tube (using many fields having different type)<br/> (<b>model</b> = ''AliquotMaster'', <b>form_alias_for_search</b> = ''QR_AQ_complexe_3'', <b>form_alias_for_results</b> = ''QR_AQ_complexe_3'', <b>flag_use_control_for_results</b> = 1)',
 'Search Stored Sample Tube (using many fields having different type)<br/> (<b>model</b> = ''AliquotMaster'', <b>form_alias_for_search</b> = ''QR_AQ_complexe_3'', <b>form_alias_for_results</b> = ''QR_AQ_complexe_3'', <b>flag_use_control_for_results</b> = 1)');
 
-- Ex 4:
 
DELETE FROM datamart_adhoc_permissions WHERE datamart_adhoc_id  = (SELECT id FROM datamart_adhoc WHERE title = 'QR_AQ_3_Demo');
DELETE FROM datamart_adhoc WHERE title = 'QR_AQ_3_Demo';

INSERT INTO `datamart_adhoc` (`id`, `title`, `description`, `plugin`, `model`, `form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, `sql_query_for_results`, `function_for_results`) VALUES
(null, 'QR_SM_4_Demo', 'QR_SM_4_Demo_Description', 'Inventorymanagement', 'SampleMaster', 'QR_SM_complexe', 'QR_SM_complexe', 'participant detail=>/clinicalannotation/participants/profile/%%Participant.id%%/|sample detail=>/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/', 
 'SELECT 
SampleMaster.id,
SampleMaster.collection_id,
Participant.id,
Participant.participant_identifier,
Participant.sex,
SampleControl.sample_type,
SampleMaster.sample_code
FROM participants AS Participant
INNER JOIN clinical_collection_links AS link ON link.participant_id = Participant.id
INNER JOIN collections AS Collection ON Collection.id = link.collection_id
INNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id
INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
WHERE TRUE
AND Participant.participant_identifier = "@@Participant.participant_identifier@@" 
AND Participant.sex = "@@Participant.sex@@" 
AND SampleControl.sample_type = "@@SampleControl.sample_type@@"
ORDER BY Participant.participant_identifier;', '');

INSERT INTO datamart_adhoc_permissions (group_id,datamart_adhoc_id) VALUES ('1', (SELECT id FROM datamart_adhoc WHERE title = 'QR_SM_4_Demo'));

INSERT INTO structures(`alias`) VALUES ('QR_SM_complexe');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='QR_SM_complexe'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='help_participant identifier' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_SM_complexe'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_sex' AND `language_label`='sex' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_SM_complexe'), (SELECT id FROM structure_fields WHERE `model`='SampleControl' AND `field`='sample_type' AND `type`='select'), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_SM_complexe'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `type`='input'), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO i18n (id, en, fr) VALUES  
 ('QR_SM_4_Demo_Description',
 'Search based on Participant + Samples criteria & Display Participant + Samples data<br/> (<b>model</b> = ''SampleMaster'', <b>form_alias_for_search</b> = ''QR_SM_complexe'', <b>form_alias_for_results</b> = ''QR_SM_complexe'', <b>flag_use_control_for_results</b> = 1)',
 'Search based on Participant + Samples criteria & Display Participant + Samples data<br/> (<b>model</b> = ''SampleMaster'', <b>form_alias_for_search</b> = ''QR_SM_complexe'', <b>form_alias_for_results</b> = ''QR_SM_complexe'', <b>flag_use_control_for_results</b> = 1)');
 
-- Ex 5:
 
INSERT INTO `datamart_adhoc` (`id`, `title`, `description`, `plugin`, `model`, `form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, `sql_query_for_results`, `function_for_results`) VALUES
(null, 'QR_PART_5_Demo', 'QR_PART_5_Demo_Description', 'Clinicalannotation', 'Participant', 'participants', 'participants', 'participant detail=>/clinicalannotation/participants/profile/%%Participant.id%%/', 
'', 'demoFuncParticipant');

INSERT INTO datamart_adhoc_permissions (group_id,datamart_adhoc_id) VALUES ('1', (SELECT id FROM datamart_adhoc WHERE title = 'QR_PART_5_Demo'));

INSERT INTO i18n (id, en, fr) VALUES  
('QR_PART_5_Demo_Description',
 'Straight participants search using a function instead of a query',
 'Straight participants search using a function instead of a query');
 
DELETE FROM datamart_adhoc_permissions WHERE datamart_adhoc_id = (SELECT id FROM datamart_adhoc WHERE title = 'QR_PART_5_Demo');

UPDATE sample_masters SET initial_specimen_sample_id=parent_id where id!=parent_id AND id=initial_specimen_sample_id;

UPDATE sample_masters SET initial_specimen_sample_id=10 WHERE id=13;
UPDATE sample_masters SET initial_specimen_sample_id=17 WHERE id=20;
UPDATE sample_masters SET initial_specimen_sample_id=10 WHERE id=26;
UPDATE sample_masters SET initial_specimen_sample_id=17 WHERE id=27;
UPDATE sample_masters SET initial_specimen_sample_id=17 WHERE id=28;
UPDATE sample_masters SET initial_specimen_sample_id=23 WHERE id=25;
UPDATE sample_masters SET initial_specimen_sample_id=1 WHERE id=3;
