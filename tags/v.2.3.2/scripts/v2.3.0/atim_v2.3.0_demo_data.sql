-- phpMyAdmin SQL Dump
-- version 3.4.3
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 08, 2011 at 01:53 PM
-- Server version: 5.5.9
-- PHP Version: 5.2.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET FOREIGN_KEY_CHECKS=0;

--
-- Database: `atim_new`
--

--
-- Dumping data for table `ad_blocks`
--

INSERT INTO `ad_blocks` (`id`, `aliquot_master_id`, `block_type`, `patho_dpt_block_code`, `deleted`) VALUES
(1, 40, 'OCT', '', 0),
(2, 41, 'OCT', '', 0),
(3, 44, 'OCT', '', 0);

--
-- Dumping data for table `ad_blocks_revs`
--

INSERT INTO `ad_blocks_revs` (`id`, `aliquot_master_id`, `block_type`, `patho_dpt_block_code`, `version_id`, `version_created`) VALUES
(1, 40, 'OCT', '', 1, '2011-03-18 15:34:33'),
(2, 41, 'OCT', '', 2, '2011-03-18 15:34:34'),
(2, 41, 'OCT', '', 3, '2011-03-18 15:39:54'),
(2, 41, 'OCT', '', 4, '2011-03-18 15:39:55'),
(3, 44, 'OCT', '', 5, '2011-03-18 15:45:48'),
(3, 44, 'OCT', '', 6, '2011-03-18 15:49:53'),
(3, 44, 'OCT', '', 7, '2011-03-18 15:49:55'),
(2, 41, 'OCT', '', 8, '2011-03-18 17:11:14'),
(2, 41, 'OCT', '', 9, '2011-03-18 17:11:15'),
(2, 41, 'OCT', '', 10, '2011-03-18 17:21:20'),
(2, 41, 'OCT', '', 11, '2011-03-18 17:22:35'),
(3, 44, 'OCT', '', 12, '2011-03-18 17:53:09'),
(3, 44, 'OCT', '', 13, '2011-03-18 17:53:10'),
(2, 41, 'OCT', '', 14, '2011-03-18 17:53:59'),
(2, 41, 'OCT', '', 15, '2011-03-18 17:54:01');

--
-- Dumping data for table `ad_tissue_cores`
--

INSERT INTO `ad_tissue_cores` (`id`, `aliquot_master_id`, `deleted`) VALUES
(1, 52, 0),
(2, 53, 0);

--
-- Dumping data for table `ad_tissue_cores_revs`
--

INSERT INTO `ad_tissue_cores_revs` (`id`, `aliquot_master_id`, `version_id`, `version_created`) VALUES
(1, 52, 1, '2011-03-18 17:53:09'),
(2, 53, 2, '2011-03-18 17:54:00');

--
-- Dumping data for table `ad_tissue_slides`
--

INSERT INTO `ad_tissue_slides` (`id`, `aliquot_master_id`, `immunochemistry`, `deleted`) VALUES
(1, 37, 'AC9031', 0),
(2, 38, 'AC9e13', 0),
(3, 39, 'AC457', 0),
(4, 42, 'ac 9830', 0),
(5, 43, 'ac 739', 0),
(6, 45, 'ac 739', 0),
(7, 46, 'ac 9830', 0);

--
-- Dumping data for table `ad_tissue_slides_revs`
--

INSERT INTO `ad_tissue_slides_revs` (`id`, `aliquot_master_id`, `immunochemistry`, `version_id`, `version_created`) VALUES
(1, 37, 'AC9031', 1, '2011-02-10 21:28:24'),
(2, 38, 'AC9e13', 2, '2011-02-10 21:28:24'),
(3, 39, 'AC457', 3, '2011-02-10 21:28:25'),
(1, 37, 'AC9031', 4, '2011-02-10 21:31:56'),
(3, 39, 'AC457', 5, '2011-02-10 21:32:48'),
(2, 38, 'AC9e13', 6, '2011-02-10 21:33:26'),
(4, 42, 'ac 9830', 7, '2011-03-18 15:39:54'),
(5, 43, 'ac 739', 8, '2011-03-18 15:39:55'),
(6, 45, 'ac 739', 9, '2011-03-18 15:49:54'),
(7, 46, 'ac 9830', 10, '2011-03-18 15:49:55'),
(5, 43, 'ac 739', 11, '2011-03-18 17:49:30');

--
-- Dumping data for table `ad_tubes`
--

INSERT INTO `ad_tubes` (`id`, `aliquot_master_id`, `lot_number`, `concentration`, `concentration_unit`, `cell_count`, `cell_count_unit`, `cell_viability`, `hemolysis_signs`, `deleted`) VALUES
(1, 1, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 0),
(2, 2, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 0),
(3, 3, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 0),
(4, 5, '#42343214', 54.00, 'million(s)/ml', 34.00, '10e7', NULL, '', 0),
(5, 6, '#42343214', 43.00, 'million(s)/ml', 23.00, '10e7', NULL, '', 0),
(6, 7, '', NULL, '', NULL, NULL, NULL, '', 0),
(7, 8, '', NULL, '', NULL, NULL, NULL, '', 0),
(8, 9, '', NULL, '', NULL, NULL, NULL, '', 0),
(9, 10, '', NULL, '', NULL, NULL, NULL, '', 0),
(10, 11, '', NULL, '', NULL, NULL, NULL, '', 0),
(11, 12, '', NULL, '', NULL, NULL, NULL, '', 0),
(12, 13, '', NULL, '', NULL, NULL, NULL, '', 0),
(13, 14, '', NULL, '', NULL, NULL, NULL, '', 0),
(14, 15, '', NULL, '', NULL, NULL, NULL, '', 0),
(15, 16, '#423124', NULL, NULL, NULL, NULL, NULL, '', 0),
(16, 17, '#423124', NULL, NULL, NULL, NULL, NULL, '', 0),
(17, 18, '#423124', NULL, NULL, NULL, NULL, NULL, '', 0),
(18, 19, '#423124', NULL, NULL, NULL, NULL, NULL, '', 0),
(19, 20, '#423124', NULL, NULL, NULL, NULL, NULL, '', 0),
(20, 22, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 0),
(21, 23, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 0),
(22, 24, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 0),
(23, 25, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 0),
(24, 26, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 0),
(25, 27, '', 12.00, '', NULL, NULL, NULL, '', 0),
(26, 28, '', 12.00, '', NULL, NULL, NULL, '', 0),
(27, 29, '', 3.00, '', NULL, NULL, NULL, '', 0),
(28, 30, '', 3.00, '', NULL, NULL, NULL, '', 0),
(29, 31, '', 3.00, '', NULL, NULL, NULL, '', 0),
(30, 32, '', 3.00, '', NULL, NULL, NULL, '', 0),
(31, 33, '', NULL, '', NULL, NULL, NULL, '', 0),
(32, 34, '', NULL, '', NULL, NULL, NULL, '', 0),
(33, 35, '', NULL, '', NULL, NULL, NULL, '', 0),
(34, 36, '', NULL, NULL, NULL, NULL, NULL, '', 0),
(35, 47, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 0),
(36, 48, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 0),
(37, 49, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 0),
(38, 50, '', 31.00, 'ug/ul', NULL, NULL, NULL, '', 0),
(39, 51, '', 31.00, 'ug/ul', NULL, NULL, NULL, '', 0);

--
-- Dumping data for table `ad_tubes_revs`
--

INSERT INTO `ad_tubes_revs` (`id`, `aliquot_master_id`, `lot_number`, `concentration`, `concentration_unit`, `cell_count`, `cell_count_unit`, `cell_viability`, `hemolysis_signs`, `version_id`, `version_created`) VALUES
(1, 1, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 1, '2010-05-28 16:02:22'),
(2, 2, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 2, '2010-05-28 16:02:23'),
(3, 3, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 3, '2010-05-28 16:02:24'),
(3, 3, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 4, '2010-05-28 16:04:31'),
(3, 3, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 5, '2010-05-28 16:05:02'),
(2, 2, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 6, '2010-05-28 16:10:04'),
(2, 2, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 7, '2010-05-28 16:10:06'),
(1, 1, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 8, '2010-05-28 16:19:41'),
(1, 1, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 9, '2010-05-28 16:19:43'),
(4, 5, '#42343214', 54.00, 'million(s)/ml', 34.00, '10e7', NULL, '', 10, '2010-05-28 16:23:59'),
(5, 6, '#42343214', 43.00, 'million(s)/ml', 23.00, '10e7', NULL, '', 11, '2010-05-28 16:24:00'),
(6, 7, '', NULL, '', NULL, NULL, NULL, '', 12, '2010-05-28 16:28:22'),
(7, 8, '', NULL, '', NULL, NULL, NULL, '', 13, '2010-05-28 16:28:23'),
(8, 9, '', NULL, '', NULL, NULL, NULL, '', 14, '2010-05-28 16:28:24'),
(9, 10, '', NULL, '', NULL, NULL, NULL, '', 15, '2010-05-28 16:28:25'),
(10, 11, '', NULL, '', NULL, NULL, NULL, '', 16, '2010-05-28 16:28:26'),
(11, 12, '', NULL, '', NULL, NULL, NULL, '', 17, '2010-05-28 16:28:27'),
(12, 13, '', NULL, '', NULL, NULL, NULL, '', 18, '2010-05-28 16:28:28'),
(13, 14, '', NULL, '', NULL, NULL, NULL, '', 19, '2010-05-28 16:28:29'),
(14, 15, '', NULL, '', NULL, NULL, NULL, '', 20, '2010-05-28 16:28:30'),
(9, 10, '', NULL, '', NULL, NULL, NULL, '', 21, '2010-05-28 16:31:12'),
(10, 11, '', NULL, '', NULL, NULL, NULL, '', 22, '2010-05-28 16:32:08'),
(9, 10, '', NULL, '', NULL, NULL, NULL, '', 23, '2010-05-28 16:33:46'),
(15, 16, '#423124', NULL, NULL, NULL, NULL, NULL, '', 24, '2010-09-24 19:21:33'),
(16, 17, '#423124', NULL, NULL, NULL, NULL, NULL, '', 25, '2010-09-24 19:21:33'),
(17, 18, '#423124', NULL, NULL, NULL, NULL, NULL, '', 26, '2010-09-24 19:21:34'),
(18, 19, '#423124', NULL, NULL, NULL, NULL, NULL, '', 27, '2010-09-24 19:21:34'),
(19, 20, '#423124', NULL, NULL, NULL, NULL, NULL, '', 28, '2010-09-24 19:21:34'),
(20, 22, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 29, '2010-09-24 19:23:52'),
(21, 23, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 30, '2010-09-24 19:23:52'),
(22, 24, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 31, '2010-09-24 19:23:53'),
(23, 25, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 32, '2010-09-24 19:23:53'),
(24, 26, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 33, '2010-09-24 19:23:53'),
(25, 27, '', 12.00, '', NULL, NULL, NULL, '', 34, '2010-09-24 19:24:56'),
(26, 28, '', 12.00, '', NULL, NULL, NULL, '', 35, '2010-09-24 19:24:56'),
(26, 28, '', 12.00, '', NULL, NULL, NULL, '', 36, '2010-09-24 19:26:16'),
(26, 28, '', 12.00, '', NULL, NULL, NULL, '', 37, '2010-09-24 19:26:17'),
(25, 27, '', 12.00, '', NULL, NULL, NULL, '', 38, '2010-09-24 19:26:48'),
(25, 27, '', 12.00, '', NULL, NULL, NULL, '', 39, '2010-09-24 19:26:49'),
(23, 25, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 40, '2010-09-24 19:27:45'),
(26, 28, '', 12.00, '', NULL, NULL, NULL, '', 41, '2010-09-24 19:28:54'),
(26, 28, '', 12.00, '', NULL, NULL, NULL, '', 42, '2010-09-24 19:28:55'),
(27, 29, '', 3.00, '', NULL, NULL, NULL, '', 43, '2010-09-24 19:38:09'),
(28, 30, '', 3.00, '', NULL, NULL, NULL, '', 44, '2010-09-24 19:38:09'),
(29, 31, '', 3.00, '', NULL, NULL, NULL, '', 45, '2010-09-24 19:38:09'),
(30, 32, '', 3.00, '', NULL, NULL, NULL, '', 46, '2010-09-24 19:38:10'),
(31, 33, '', NULL, '', NULL, NULL, NULL, '', 47, '2010-09-24 19:45:19'),
(32, 34, '', NULL, '', NULL, NULL, NULL, '', 48, '2010-09-24 19:45:20'),
(33, 35, '', NULL, '', NULL, NULL, NULL, '', 49, '2010-09-24 19:45:20'),
(30, 32, '', 3.00, '', NULL, NULL, NULL, '', 50, '2010-09-24 20:09:49'),
(29, 31, '', 3.00, '', NULL, NULL, NULL, '', 51, '2010-09-24 20:09:50'),
(24, 26, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 52, '2010-09-24 20:09:50'),
(23, 25, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 53, '2010-09-24 20:09:50'),
(22, 24, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 54, '2010-09-24 20:09:51'),
(21, 23, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 55, '2010-09-24 20:09:51'),
(20, 22, '', 3.00, 'ng/ul', NULL, NULL, NULL, '', 56, '2010-09-24 20:09:52'),
(5, 6, '#42343214', 43.00, 'million(s)/ml', 23.00, '10e7', NULL, '', 57, '2010-09-24 20:09:52'),
(4, 5, '#42343214', 54.00, 'million(s)/ml', 34.00, '10e7', NULL, '', 58, '2010-09-24 20:09:52'),
(31, 33, '', NULL, '', NULL, NULL, NULL, '', 59, '2010-09-24 20:10:39'),
(19, 20, '#423124', NULL, NULL, NULL, NULL, NULL, '', 60, '2010-09-24 20:10:39'),
(18, 19, '#423124', NULL, NULL, NULL, NULL, NULL, '', 61, '2010-09-24 20:10:40'),
(17, 18, '#423124', NULL, NULL, NULL, NULL, NULL, '', 62, '2010-09-24 20:10:40'),
(16, 17, '#423124', NULL, NULL, NULL, NULL, NULL, '', 63, '2010-09-24 20:10:40'),
(15, 16, '#423124', NULL, NULL, NULL, NULL, NULL, '', 64, '2010-09-24 20:10:41'),
(25, 27, '', 12.00, '', NULL, NULL, NULL, '', 65, '2010-09-24 20:11:24'),
(14, 15, '', NULL, '', NULL, NULL, NULL, '', 66, '2010-09-24 20:11:24'),
(13, 14, '', NULL, '', NULL, NULL, NULL, '', 67, '2010-09-24 20:11:25'),
(12, 13, '', NULL, '', NULL, NULL, NULL, '', 68, '2010-09-24 20:11:25'),
(11, 12, '', NULL, '', NULL, NULL, NULL, '', 69, '2010-09-24 20:11:26'),
(10, 11, '', NULL, '', NULL, NULL, NULL, '', 70, '2010-09-24 20:11:26'),
(8, 9, '', NULL, '', NULL, NULL, NULL, '', 71, '2010-09-24 20:11:26'),
(7, 8, '', NULL, '', NULL, NULL, NULL, '', 72, '2010-09-24 20:11:27'),
(6, 7, '', NULL, '', NULL, NULL, NULL, '', 73, '2010-09-24 20:11:27'),
(3, 3, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 74, '2010-09-24 20:11:27'),
(2, 2, '#97730-423', NULL, NULL, NULL, NULL, NULL, '', 75, '2010-09-24 20:11:28'),
(32, 34, '', NULL, '', NULL, NULL, NULL, '', 76, '2010-09-24 20:11:52'),
(28, 30, '', 3.00, '', NULL, NULL, NULL, '', 77, '2010-09-24 20:11:53'),
(27, 29, '', 3.00, '', NULL, NULL, NULL, '', 78, '2010-09-24 20:11:53'),
(32, 34, '', NULL, '', NULL, NULL, NULL, '', 79, '2010-09-24 20:12:23'),
(28, 30, '', 3.00, '', NULL, NULL, NULL, '', 80, '2010-09-24 20:12:23'),
(27, 29, '', 3.00, '', NULL, NULL, NULL, '', 81, '2010-09-24 20:12:24'),
(34, 36, '', NULL, NULL, NULL, NULL, NULL, '', 82, '2011-02-10 21:27:31'),
(34, 36, '', NULL, NULL, NULL, NULL, NULL, '', 83, '2011-02-10 21:29:09'),
(34, 36, '', NULL, NULL, NULL, NULL, NULL, '', 84, '2011-03-18 15:34:33'),
(34, 36, '', NULL, NULL, NULL, NULL, NULL, '', 85, '2011-03-18 15:34:34'),
(35, 47, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 86, '2011-03-18 17:27:02'),
(36, 48, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 87, '2011-03-18 17:27:02'),
(37, 49, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 88, '2011-03-18 17:27:03'),
(37, 49, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 89, '2011-03-18 17:28:16'),
(36, 48, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 90, '2011-03-18 17:28:17'),
(35, 47, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 91, '2011-03-18 17:28:17'),
(32, 34, '', NULL, '', NULL, NULL, NULL, '', 92, '2011-03-18 17:28:18'),
(28, 30, '', 3.00, '', NULL, NULL, NULL, '', 93, '2011-03-18 17:28:18'),
(27, 29, '', 3.00, '', NULL, NULL, NULL, '', 94, '2011-03-18 17:28:19'),
(36, 48, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 95, '2011-03-18 17:30:02'),
(36, 48, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 96, '2011-03-18 17:33:50'),
(38, 50, '', 31.00, 'ug/ul', NULL, NULL, NULL, '', 97, '2011-03-18 17:33:51'),
(39, 51, '', 31.00, 'ug/ul', NULL, NULL, NULL, '', 98, '2011-03-18 17:33:52'),
(36, 48, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 99, '2011-03-18 17:33:52'),
(36, 48, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 100, '2011-03-18 17:35:18'),
(36, 48, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 101, '2011-03-18 17:37:37'),
(36, 48, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 102, '2011-03-18 17:37:38'),
(36, 48, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 103, '2011-03-18 17:40:57'),
(36, 48, '', 142.00, 'ug/ul', NULL, NULL, NULL, '', 104, '2011-03-18 17:40:58'),
(38, 50, '', 31.00, 'ug/ul', NULL, NULL, NULL, '', 105, '2011-03-18 17:44:22'),
(38, 50, '', 31.00, 'ug/ul', NULL, NULL, NULL, '', 106, '2011-03-18 17:45:25'),
(38, 50, '', 31.00, 'ug/ul', NULL, NULL, NULL, '', 107, '2011-03-18 17:45:26');

--
-- Dumping data for table `ad_whatman_papers`
--

INSERT INTO `ad_whatman_papers` (`id`, `aliquot_master_id`, `used_blood_volume`, `used_blood_volume_unit`, `deleted`) VALUES
(1, 4, 1.50000, 'ml', 0),
(2, 21, 1.00000, 'n/a', 0);

--
-- Dumping data for table `ad_whatman_papers_revs`
--

INSERT INTO `ad_whatman_papers_revs` (`id`, `aliquot_master_id`, `used_blood_volume`, `used_blood_volume_unit`, `version_id`, `version_created`) VALUES
(1, 4, 1.50000, 'ml', 1, '2010-05-28 16:03:25'),
(2, 21, 1.00000, 'n/a', 2, '2010-09-24 19:22:07');


--
-- Dumping data for table `aliquot_internal_uses`
--

INSERT INTO `aliquot_internal_uses` (`id`, `aliquot_master_id`, `use_code`, `use_details`, `used_volume`, `use_datetime`, `use_datetime_accuracy`, `used_by`, `study_summary_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(11, 38, 'projject 111', '', NULL, '2011-02-02 00:00:00', '', 'laboratory staff 1', 1, '2011-02-10 21:34:35', 1, '2011-02-10 21:34:35', 1, 0),
(12, 41, 'Dr Loop Study', 'Used by lab of Dr Loop.', NULL, '2011-03-19 00:00:00', '', 'laboratory staff etc', NULL, '2011-03-18 17:21:20', 1, '2011-03-18 17:22:34', 1, 0),
(13, 48, 'Dr Loop Study', 'Loan for Dr Loop Study', 1.43000, '2011-04-09 00:00:00', '', '', NULL, '2011-03-18 17:30:02', 1, '2011-03-18 17:35:18', 1, 0);

--
-- Dumping data for table `aliquot_internal_uses_revs`
--

INSERT INTO `aliquot_internal_uses_revs` (`id`, `aliquot_master_id`, `use_code`, `use_details`, `used_volume`, `use_datetime`, `used_by`, `study_summary_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 3, 'b1_tb2', '', 2.00000, '2003-04-23 13:35:00', 'laboratory staff 1', NULL, 1, 1, '2010-05-28 16:04:30'),
(2, 3, 'b1_wp1', '', 3.40000, '2003-04-23 13:35:00', '', NULL, 1, 2, '2010-05-28 16:04:30'),
(1, 3, 'b1_tb2', '', 1.00000, '2003-04-23 13:35:00', 'laboratory staff 1', NULL, 1, 3, '2010-05-28 16:05:01'),
(3, 1, 'PBMC - 2', '', 5.00000, '2003-04-23 17:18:00', '', NULL, 1, 4, '2010-05-28 16:19:41'),
(4, 10, 'UPS98409', '', NULL, '2010-05-31 13:04:00', 'laboratory staff 2', NULL, 1, 5, '2010-05-28 16:33:47'),
(5, 25, '442332', '', 1.00000, '2009-08-04 00:00:00', 'laboratory staff 2', NULL, 1, 6, '2010-09-24 19:27:45'),
(6, 25, '442332e', '', 1.00000, '2009-08-04 00:00:00', 'laboratory staff 2', NULL, 1, 7, '2010-09-24 19:27:45'),
(7, 28, 'QC - 1', '#1245', 11.00000, '2009-11-04 00:00:00', 'laboratory staff etc', NULL, 1, 8, '2010-09-24 19:28:54'),
(8, 36, 's56892', NULL, NULL, '2011-02-10 21:28:00', '', NULL, 1, 9, '2011-02-10 21:29:08'),
(9, 36, 's56894', NULL, NULL, '2011-02-10 21:28:00', '', NULL, 1, 10, '2011-02-10 21:29:08'),
(10, 36, 's56893', NULL, NULL, '2011-02-10 21:28:00', '', NULL, 1, 11, '2011-02-10 21:29:09'),
(11, 38, 'projject 111', '', NULL, '2011-02-02 00:00:00', 'laboratory staff 1', 1, 1, 12, '2011-02-10 21:34:35'),
(12, 39, 'rv378', NULL, NULL, '1995-04-17 00:00:00', NULL, NULL, 1, 13, '2011-02-10 21:35:47'),
(13, 37, 'rv378', NULL, NULL, '1995-04-17 00:00:00', NULL, NULL, 1, 14, '2011-02-10 21:35:48'),
(12, 41, 'Dr Loop Study', 'Used by lab of Dr Loop', NULL, '2011-03-19 00:00:00', 'laboratory staff etc', NULL, 1, 15, '2011-03-18 17:21:20'),
(12, 41, 'Dr Loop Study', 'Used by lab of Dr Loop.', NULL, '2011-03-19 00:00:00', 'laboratory staff etc', NULL, 1, 16, '2011-03-18 17:22:34'),
(13, 48, 'Dr Loop Study', 'Loan for Dr Loop Study', 1.40000, '2011-04-09 00:00:00', '', NULL, 1, 17, '2011-03-18 17:30:02'),
(13, 48, 'Dr Loop Study', 'Loan for Dr Loop Study', 1.43000, '2011-04-09 00:00:00', '', NULL, 1, 18, '2011-03-18 17:35:18');

--
-- Dumping data for table `aliquot_masters`
--

INSERT INTO `aliquot_masters` (`id`, `barcode`, `aliquot_label`, `aliquot_type`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `sop_master_id`, `initial_volume`, `current_volume`, `aliquot_volume_unit`, `in_stock`, `in_stock_detail`, `use_counter`, `study_summary_id`, `storage_datetime`, `storage_datetime_accuracy`, `storage_master_id`, `storage_coord_x`, `storage_coord_y`, `product_code`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'b1_tb1', '', 'tube', 3, 1, 1, NULL, 5.00000, 0.00000, 'ml', 'no', 'empty', 1, 1, '2003-04-23 13:35:00', '', NULL, '', '', NULL, NULL, '2010-05-28 16:02:21', 1, '2010-05-28 16:19:42', 1, 0),
(2, 'b1_tb2', '', 'tube', 3, 1, 1, NULL, 5.00000, 5.00000, 'ml', 'yes - available', '', NULL, 1, '2003-04-23 13:35:00', '', 7, '12', '', NULL, '', '2010-05-28 16:02:23', 1, '2010-05-28 16:10:05', 1, 0),
(3, 'b1_tb3', '', 'tube', 3, 1, 1, NULL, 5.00000, 0.60000, 'ml', 'yes - available', '', 2, 1, '2003-04-23 13:35:00', '', 7, '9', '', NULL, NULL, '2010-05-28 16:02:24', 1, '2010-05-28 16:05:02', 1, 0),
(4, 'b1_wp1', '', 'whatman paper', 11, 1, 1, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2003-04-23 13:02:00', '', NULL, '', '', NULL, NULL, '2010-05-28 16:03:25', 1, '2010-05-28 16:03:25', 1, 0),
(5, 'pbmc2_tb1', '', 'tube', 37, 1, 2, NULL, 4.00000, 4.00000, 'ml', 'yes - available', '', NULL, NULL, '2003-04-23 18:31:00', '', 10, '2', 'B', NULL, NULL, '2010-05-28 16:23:59', 1, '2010-05-28 16:23:59', 1, 0),
(6, 'pbmc2_tb2', '', 'tube', 37, 1, 2, NULL, 5.00000, 5.00000, 'ml', 'yes - available', '', NULL, NULL, '2003-04-23 18:31:00', '', 10, '2', 'A', NULL, NULL, '2010-05-28 16:24:00', 1, '2010-05-28 16:24:00', 1, 0),
(7, 'dna1_tb1', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', '', 7, '2', '', NULL, NULL, '2010-05-28 16:28:21', 1, '2010-05-28 16:28:21', 1, 0),
(8, 'dna1_tb2', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', '', 7, '17', '', NULL, NULL, '2010-05-28 16:28:22', 1, '2010-05-28 16:28:22', 1, 0),
(9, 'dna1_tb3', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', '', 7, '24', '', NULL, NULL, '2010-05-28 16:28:23', 1, '2010-05-28 16:28:23', 1, 0),
(10, 'dna1_tb4', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'no', 'shipped', 1, NULL, '2010-05-04 02:03:00', '', NULL, '', '', NULL, NULL, '2010-05-28 16:28:25', 1, '2010-05-28 16:33:45', 1, 0),
(11, 'dna1_tb5', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - not available', 'reserved for order', NULL, NULL, '2010-05-04 02:03:00', '', 7, '1', '', NULL, NULL, '2010-05-28 16:28:26', 1, '2010-05-28 16:32:07', 1, 0),
(12, 'dna1_tb6', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', '', 7, '7', '', NULL, NULL, '2010-05-28 16:28:27', 1, '2010-05-28 16:28:27', 1, 0),
(13, 'dna1_tb7', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', '', 7, '22', '', NULL, NULL, '2010-05-28 16:28:28', 1, '2010-05-28 16:28:28', 1, 0),
(14, 'dna1_tb8', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', '', 7, '19', '', NULL, NULL, '2010-05-28 16:28:29', 1, '2010-05-28 16:28:29', 1, 0),
(15, 'dna1_tb9', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', '', 7, '14', '', NULL, NULL, '2010-05-28 16:28:30', 1, '2010-05-28 16:28:30', 1, 0),
(16, '8090023', '', 'tube', 3, 2, 4, NULL, 3.00000, 3.00000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', '', 5, '5', '', NULL, NULL, '2010-09-24 19:21:33', 1, '2010-09-24 19:21:33', 1, 0),
(17, '8090024', '', 'tube', 3, 2, 4, NULL, 3.40000, 3.40000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', '', 5, '6', '', NULL, NULL, '2010-09-24 19:21:33', 1, '2010-09-24 19:21:33', 1, 0),
(18, '8090025', '', 'tube', 3, 2, 4, NULL, 2.40000, 2.40000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', '', 5, '2', '', NULL, NULL, '2010-09-24 19:21:33', 1, '2010-09-24 19:21:33', 1, 0),
(19, '8090026', '', 'tube', 3, 2, 4, NULL, 3.00000, 3.00000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', '', 5, '3', '', NULL, NULL, '2010-09-24 19:21:34', 1, '2010-09-24 19:21:34', 1, 0),
(20, '8090027', '', 'tube', 3, 2, 4, NULL, 3.00000, 3.00000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', '', 5, '4', '', NULL, NULL, '2010-09-24 19:21:34', 1, '2010-09-24 19:21:34', 1, 0),
(21, 'w53344', '', 'whatman paper', 11, 2, 4, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1999-09-03 15:13:00', '', NULL, '', '', NULL, NULL, '2010-09-24 19:22:07', 1, '2010-09-24 19:22:07', 1, 0),
(22, '62424231', '', 'tube', 29, 2, 5, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', '', 10, '1', 'A', NULL, NULL, '2010-09-24 19:23:52', 1, '2010-09-24 19:23:52', 1, 0),
(23, '624242342', '', 'tube', 29, 2, 5, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', '', 10, '1', 'B', NULL, NULL, '2010-09-24 19:23:52', 1, '2010-09-24 19:23:52', 1, 0),
(24, '624242343', '', 'tube', 29, 2, 5, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', '', 10, '3', 'C', NULL, NULL, '2010-09-24 19:23:52', 1, '2010-09-24 19:23:52', 1, 0),
(25, '624242344', '', 'tube', 29, 2, 5, NULL, 12.00000, 10.00000, 'ul', 'yes - available', '', 2, NULL, '2008-02-12 00:00:00', '', 10, '3', 'A', NULL, NULL, '2010-09-24 19:23:53', 1, '2010-09-24 19:27:45', 1, 0),
(26, '624242345', '', 'tube', 29, 2, 5, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', '', 10, '2', 'C', NULL, NULL, '2010-09-24 19:23:53', 1, '2010-09-24 19:23:53', 1, 0),
(27, '442332', '', 'tube', 29, 2, 5, NULL, 33.00000, 33.00000, 'ul', 'yes - available', '', NULL, NULL, '2009-08-04 00:00:00', '', 7, '4', '', NULL, '', '2010-09-24 19:24:56', 1, '2010-09-24 19:26:49', 1, 0),
(28, '442332e', '', 'tube', 29, 2, 5, NULL, 33.00000, 22.00000, 'ul', 'no', '', 1, NULL, '2009-08-04 00:00:00', '', NULL, '', '', NULL, '', '2010-09-24 19:24:56', 1, '2010-09-24 19:28:54', 1, 0),
(29, 'r2323r2', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', '', 4, '1', 'C', NULL, NULL, '2010-09-24 19:38:08', 1, '2010-09-24 19:38:08', 1, 0),
(30, 'r2323r23', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', '', 4, '1', 'A', NULL, NULL, '2010-09-24 19:38:09', 1, '2010-09-24 19:38:09', 1, 0),
(31, 'r2323r24', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - not available', 'reserved for study', NULL, 1, '2010-09-01 00:00:00', '', 10, '3', 'B', NULL, NULL, '2010-09-24 19:38:09', 1, '2010-09-24 19:38:09', 1, 0),
(32, 'r2323r25', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', '', 10, '1', 'C', NULL, NULL, '2010-09-24 19:38:09', 1, '2010-09-24 19:38:09', 1, 0),
(33, '6436435345345r', '', 'tube', 29, 4, 10, NULL, 4.00000, 4.00000, 'ul', 'yes - available', '', NULL, NULL, '1992-09-29 00:00:00', '', 5, '1', '', NULL, NULL, '2010-09-24 19:45:19', 1, '2010-09-24 19:45:19', 1, 0),
(34, '6436435345345rd', '', 'tube', 29, 4, 10, NULL, 4.00000, 4.00000, 'ul', 'yes - available', '', NULL, NULL, '1992-09-29 00:00:00', '', 4, '2', 'A', NULL, NULL, '2010-09-24 19:45:20', 1, '2010-09-24 19:45:20', 1, 0),
(35, 'ggererre', '', 'tube', 29, 4, 10, NULL, NULL, NULL, 'ul', 'no', '', NULL, NULL, NULL, '', NULL, '', '', NULL, NULL, '2010-09-24 19:45:20', 1, '2010-09-24 19:45:20', 1, 0),
(36, 't6u9937', '', 'tube', 1, 3, 6, NULL, NULL, NULL, NULL, 'no', 'empty', 5, NULL, '1995-04-13 00:00:00', '', NULL, '', '', NULL, NULL, '2011-02-10 21:27:31', 1, '2011-03-18 15:34:34', 1, 0),
(37, 's56892', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1995-04-17 08:02:00', '', NULL, '', '', NULL, '', '2011-02-10 21:28:24', 1, '2011-02-10 21:31:56', 1, 0),
(38, 's56894', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', 1, NULL, '1995-04-17 08:02:00', '', NULL, '', '', NULL, '', '2011-02-10 21:28:24', 1, '2011-02-10 21:33:26', 1, 0),
(39, 's56893', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1995-04-17 08:02:00', '', NULL, '', '', NULL, '', '2011-02-10 21:28:25', 1, '2011-02-10 21:32:48', 1, 0),
(40, 'bl6703.1', '', 'block', 9, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-03-18 13:00:00', '', 2, '', '', NULL, NULL, '2011-03-18 15:34:33', 1, '2011-03-18 15:34:33', 1, 0),
(41, 'bl6703.2', '', 'block', 9, 3, 6, NULL, NULL, NULL, '', 'no', '', 5, NULL, '2011-03-18 13:00:00', '', NULL, '', '', NULL, NULL, '2011-03-18 15:34:34', 1, '2011-03-18 17:54:01', 1, 0),
(42, 's89430.1', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, 1, '2011-03-18 17:00:00', '', NULL, '', '', NULL, NULL, '2011-03-18 15:39:54', 1, '2011-03-18 15:39:54', 1, 0),
(43, 's89430.2', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', 1, 1, '2011-03-18 17:00:00', '', NULL, '', '', NULL, NULL, '2011-03-18 15:39:55', 1, '2011-03-18 17:49:30', 1, 0),
(44, 'bl9457687', '', 'block', 9, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', 3, NULL, '1999-09-03 16:32:00', '', NULL, '', '', NULL, NULL, '2011-03-18 15:45:47', 1, '2011-03-18 17:53:10', 1, 0),
(45, 's89430.3', '', 'slide', 10, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-03-18 17:35:00', '', NULL, '', '', NULL, NULL, '2011-03-18 15:49:54', 1, '2011-03-18 15:49:54', 1, 0),
(46, 's89430.4', '', 'slide', 10, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-03-18 17:47:00', '', NULL, '', '', NULL, NULL, '2011-03-18 15:49:55', 1, '2011-03-18 15:49:55', 1, 0),
(47, 'rS561', '', 'tube', 30, 3, 13, NULL, 13.23000, 13.23000, 'ul', 'yes - available', '', NULL, 1, '2011-04-01 11:08:00', '', 4, '1', 'B', NULL, NULL, '2011-03-18 17:27:02', 1, '2011-03-18 17:27:02', 1, 0),
(48, 'rS562', '', 'tube', 30, 3, 13, NULL, 13.23000, 0.80000, 'ul', 'no', '', 5, 1, '2011-04-01 11:08:00', '', NULL, '', '', NULL, NULL, '2011-03-18 17:27:02', 1, '2011-03-18 17:40:58', 1, 0),
(49, 'rS563', '', 'tube', 30, 3, 13, NULL, 13.23000, 13.23000, 'ul', 'yes - available', '', NULL, 1, '2011-04-01 11:08:00', '', 4, '2', 'C', NULL, NULL, '2011-03-18 17:27:02', 1, '2011-03-18 17:27:02', 1, 0),
(50, 'rS562.1', '', 'tube', 30, 3, 13, NULL, 11.00000, 11.00000, 'ul', 'no', 'shipped', 1, NULL, NULL, '', NULL, '', '', NULL, NULL, '2011-03-18 17:33:51', 1, '2011-03-18 17:45:26', 1, 0),
(51, 'rS562.2', '', 'tube', 30, 3, 13, NULL, 11.00000, 11.00000, 'ul', 'yes - available', '', NULL, NULL, NULL, '', NULL, '', '', NULL, NULL, '2011-03-18 17:33:51', 1, '2011-03-18 17:33:51', 1, 0),
(52, 'c1', '', 'core', 33, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-06-18 17:52:00', '', 11, '1', '1', NULL, NULL, '2011-03-18 17:53:09', 1, '2011-03-18 17:53:09', 1, 0),
(53, 'c2', '', 'core', 33, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-05-18 17:53:00', '', 11, '1', '2', NULL, NULL, '2011-03-18 17:54:00', 1, '2011-03-18 17:54:00', 1, 0);

--
-- Dumping data for table `aliquot_masters_revs`
--

INSERT INTO `aliquot_masters_revs` (`id`, `barcode`, `aliquot_label`, `aliquot_type`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `sop_master_id`, `initial_volume`, `current_volume`, `aliquot_volume_unit`, `in_stock`, `in_stock_detail`, `use_counter`, `study_summary_id`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `storage_coord_y`, `product_code`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'b1_tb1', '', 'tube', 3, 1, 1, NULL, 5.00000, 5.00000, 'ml', 'yes - available', '', NULL, 1, '2003-04-23 13:35:00', 7, '1', '', NULL, NULL, 1, 1, '2010-05-28 16:02:21'),
(2, 'b1_tb2', '', 'tube', 3, 1, 1, NULL, 5.00000, 5.00000, 'ml', 'yes - available', '', NULL, 1, '2003-04-23 13:35:00', 7, '2', '', NULL, NULL, 1, 2, '2010-05-28 16:02:23'),
(3, 'b1_tb3', '', 'tube', 3, 1, 1, NULL, 5.00000, 5.00000, 'ml', 'yes - available', '', NULL, 1, '2003-04-23 13:35:00', 7, '3', '', NULL, NULL, 1, 3, '2010-05-28 16:02:24'),
(4, 'b1_wp1', '', 'whatman paper', 11, 1, 1, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2003-04-23 13:02:00', NULL, '', '', NULL, NULL, 1, 4, '2010-05-28 16:03:25'),
(3, 'b1_tb3', '', 'tube', 3, 1, 1, NULL, 5.00000, 0.00000, 'ml', 'yes - available', '', NULL, 1, '2003-04-23 13:35:00', 7, '3', '', NULL, NULL, 1, 5, '2010-05-28 16:04:31'),
(3, 'b1_tb3', '', 'tube', 3, 1, 1, NULL, 5.00000, 0.60000, 'ml', 'yes - available', '', NULL, 1, '2003-04-23 13:35:00', 7, '3', '', NULL, NULL, 1, 6, '2010-05-28 16:05:02'),
(2, 'b1_tb2', '', 'tube', 3, 1, 1, NULL, 5.00000, 5.00000, 'ml', 'yes - available', '', NULL, 1, '2003-04-23 13:35:00', 7, '6', '', NULL, '', 1, 7, '2010-05-28 16:10:04'),
(2, 'b1_tb2', '', 'tube', 3, 1, 1, NULL, 5.00000, 5.00000, 'ml', 'yes - available', '', NULL, 1, '2003-04-23 13:35:00', 7, '6', '', NULL, '', 1, 8, '2010-05-28 16:10:05'),
(1, 'b1_tb1', '', 'tube', 3, 1, 1, NULL, 5.00000, 5.00000, 'ml', 'no', 'empty', NULL, 1, '2003-04-23 13:35:00', NULL, '', '', NULL, NULL, 1, 9, '2010-05-28 16:19:40'),
(1, 'b1_tb1', '', 'tube', 3, 1, 1, NULL, 5.00000, 0.00000, 'ml', 'no', 'empty', NULL, 1, '2003-04-23 13:35:00', NULL, '', '', NULL, NULL, 1, 10, '2010-05-28 16:19:42'),
(5, 'pbmc2_tb1', '', 'tube', 37, 1, 2, NULL, 4.00000, 4.00000, 'ml', 'yes - available', '', NULL, NULL, '2003-04-23 18:31:00', 10, '4', '', NULL, NULL, 1, 11, '2010-05-28 16:23:59'),
(6, 'pbmc2_tb2', '', 'tube', 37, 1, 2, NULL, 5.00000, 5.00000, 'ml', 'yes - available', '', NULL, NULL, '2003-04-23 18:31:00', 10, '5', '', NULL, NULL, 1, 12, '2010-05-28 16:24:00'),
(7, 'dna1_tb1', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '12', '', NULL, NULL, 1, 13, '2010-05-28 16:28:21'),
(8, 'dna1_tb2', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '13', '', NULL, NULL, 1, 14, '2010-05-28 16:28:22'),
(9, 'dna1_tb3', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '14', '', NULL, NULL, 1, 15, '2010-05-28 16:28:23'),
(10, 'dna1_tb4', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '15', '', NULL, NULL, 1, 16, '2010-05-28 16:28:25'),
(11, 'dna1_tb5', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '16', '', NULL, NULL, 1, 17, '2010-05-28 16:28:26'),
(12, 'dna1_tb6', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '17', '', NULL, NULL, 1, 18, '2010-05-28 16:28:27'),
(13, 'dna1_tb7', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '18', '', NULL, NULL, 1, 19, '2010-05-28 16:28:28'),
(14, 'dna1_tb8', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '19', '', NULL, NULL, 1, 20, '2010-05-28 16:28:29'),
(15, 'dna1_tb9', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '20', '', NULL, NULL, 1, 21, '2010-05-28 16:28:30'),
(10, 'dna1_tb4', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - not available', 'reserved for order', NULL, NULL, '2010-05-04 02:03:00', 7, '15', '', NULL, NULL, 1, 22, '2010-05-28 16:31:11'),
(11, 'dna1_tb5', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - not available', 'reserved for order', NULL, NULL, '2010-05-04 02:03:00', 7, '16', '', NULL, NULL, 1, 23, '2010-05-28 16:32:07'),
(10, 'dna1_tb4', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'no', 'shipped', NULL, NULL, '2010-05-04 02:03:00', NULL, '', '', NULL, NULL, 1, 24, '2010-05-28 16:33:45'),
(16, '8090023', '', 'tube', 3, 2, 4, NULL, 3.00000, 3.00000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', 5, '5', '', NULL, NULL, 1, 25, '2010-09-24 19:21:33'),
(17, '8090024', '', 'tube', 3, 2, 4, NULL, 3.40000, 3.40000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', 5, '1', '', NULL, NULL, 1, 26, '2010-09-24 19:21:33'),
(18, '8090025', '', 'tube', 3, 2, 4, NULL, 2.40000, 2.40000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', 5, '7', '', NULL, NULL, 1, 27, '2010-09-24 19:21:33'),
(19, '8090026', '', 'tube', 3, 2, 4, NULL, 3.00000, 3.00000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', 5, '8', '', NULL, NULL, 1, 28, '2010-09-24 19:21:34'),
(20, '8090027', '', 'tube', 3, 2, 4, NULL, 3.00000, 3.00000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', 5, '9', '', NULL, NULL, 1, 29, '2010-09-24 19:21:34'),
(21, 'w53344', '', 'whatman paper', 11, 2, 4, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1999-09-03 15:13:00', NULL, '', '', NULL, NULL, 1, 30, '2010-09-24 19:22:07'),
(22, '62424231', '', 'tube', 29, 2, 5, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', 10, '1', 'A', NULL, NULL, 1, 31, '2010-09-24 19:23:52'),
(23, '624242342', '', 'tube', 29, 2, 5, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', 10, '1', 'B', NULL, NULL, 1, 32, '2010-09-24 19:23:52'),
(24, '624242343', '', 'tube', 29, 2, 5, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', 10, '1', 'C', NULL, NULL, 1, 33, '2010-09-24 19:23:52'),
(25, '624242344', '', 'tube', 29, 2, 5, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', 10, '1', 'D', NULL, NULL, 1, 34, '2010-09-24 19:23:53'),
(26, '624242345', '', 'tube', 29, 2, 5, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', 10, '1', 'E', NULL, NULL, 1, 35, '2010-09-24 19:23:53'),
(27, '442332', '', 'tube', 29, 2, 5, NULL, 33.00000, 33.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', 7, '4', '', NULL, NULL, 1, 36, '2010-09-24 19:24:56'),
(28, '442332e', '', 'tube', 29, 2, 5, NULL, 33.00000, 33.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', 7, '5', '', NULL, NULL, 1, 37, '2010-09-24 19:24:56'),
(28, '442332e', '', 'tube', 29, 2, 5, NULL, 33.00000, 33.00000, 'ul', 'yes - available', '', NULL, NULL, '2009-08-04 00:00:00', 7, '5', '', NULL, '', 1, 38, '2010-09-24 19:26:16'),
(28, '442332e', '', 'tube', 29, 2, 5, NULL, 33.00000, 33.00000, 'ul', 'yes - available', '', NULL, NULL, '2009-08-04 00:00:00', 7, '5', '', NULL, '', 1, 39, '2010-09-24 19:26:17'),
(27, '442332', '', 'tube', 29, 2, 5, NULL, 33.00000, 33.00000, 'ul', 'yes - available', '', NULL, NULL, '2009-08-04 00:00:00', 7, '4', '', NULL, '', 1, 40, '2010-09-24 19:26:48'),
(27, '442332', '', 'tube', 29, 2, 5, NULL, 33.00000, 33.00000, 'ul', 'yes - available', '', NULL, NULL, '2009-08-04 00:00:00', 7, '4', '', NULL, '', 1, 41, '2010-09-24 19:26:49'),
(25, '624242344', '', 'tube', 29, 2, 5, NULL, 12.00000, 10.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', 10, '1', 'D', NULL, NULL, 1, 42, '2010-09-24 19:27:45'),
(28, '442332e', '', 'tube', 29, 2, 5, NULL, 33.00000, 33.00000, 'ul', 'no', '', NULL, NULL, '2009-08-04 00:00:00', NULL, '', '', NULL, '', 1, 43, '2010-09-24 19:28:54'),
(28, '442332e', '', 'tube', 29, 2, 5, NULL, 33.00000, 22.00000, 'ul', 'no', '', NULL, NULL, '2009-08-04 00:00:00', NULL, '', '', NULL, '', 1, 44, '2010-09-24 19:28:54'),
(29, 'r2323r2', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', 4, '8', 'C', NULL, NULL, 1, 45, '2010-09-24 19:38:08'),
(30, 'r2323r23', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', 4, '9', 'A', NULL, NULL, 1, 46, '2010-09-24 19:38:09'),
(31, 'r2323r24', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - not available', 'reserved for study', NULL, 1, '2010-09-01 00:00:00', 10, '7', 'B', NULL, NULL, 1, 47, '2010-09-24 19:38:09'),
(32, 'r2323r25', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', 10, '7', 'C', NULL, NULL, 1, 48, '2010-09-24 19:38:09'),
(33, '6436435345345r', '', 'tube', 29, 4, 10, NULL, 4.00000, 4.00000, 'ul', 'yes - available', '', NULL, NULL, '1992-09-29 00:00:00', 5, '6', '', NULL, NULL, 1, 49, '2010-09-24 19:45:19'),
(34, '6436435345345rd', '', 'tube', 29, 4, 10, NULL, 4.00000, 4.00000, 'ul', 'yes - available', '', NULL, NULL, '1992-09-29 00:00:00', 4, '7', 'A', NULL, NULL, 1, 50, '2010-09-24 19:45:20'),
(35, 'ggererre', '', 'tube', 29, 4, 10, NULL, NULL, NULL, 'ul', 'no', '', NULL, NULL, NULL, NULL, '', '', NULL, NULL, 1, 51, '2010-09-24 19:45:20'),
(32, 'r2323r25', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', 10, '1', 'C', NULL, NULL, 1, 52, '2010-09-24 19:38:09'),
(31, 'r2323r24', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - not available', 'reserved for study', NULL, 1, '2010-09-01 00:00:00', 10, '3', 'B', NULL, NULL, 1, 53, '2010-09-24 19:38:09'),
(26, '624242345', '', 'tube', 29, 2, 5, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', 10, '2', 'C', NULL, NULL, 1, 54, '2010-09-24 19:23:53'),
(25, '624242344', '', 'tube', 29, 2, 5, NULL, 12.00000, 10.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', 10, '3', 'A', NULL, NULL, 1, 55, '2010-09-24 19:27:45'),
(24, '624242343', '', 'tube', 29, 2, 5, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2008-02-12 00:00:00', 10, '3', 'C', NULL, NULL, 1, 56, '2010-09-24 19:23:52'),
(6, 'pbmc2_tb2', '', 'tube', 37, 1, 2, NULL, 5.00000, 5.00000, 'ml', 'yes - available', '', NULL, NULL, '2003-04-23 18:31:00', 10, '2', 'A', NULL, NULL, 1, 57, '2010-05-28 16:24:00'),
(5, 'pbmc2_tb1', '', 'tube', 37, 1, 2, NULL, 4.00000, 4.00000, 'ml', 'yes - available', '', NULL, NULL, '2003-04-23 18:31:00', 10, '2', 'B', NULL, NULL, 1, 58, '2010-05-28 16:23:59'),
(33, '6436435345345r', '', 'tube', 29, 4, 10, NULL, 4.00000, 4.00000, 'ul', 'yes - available', '', NULL, NULL, '1992-09-29 00:00:00', 5, '1', '', NULL, NULL, 1, 59, '2010-09-24 19:45:19'),
(20, '8090027', '', 'tube', 3, 2, 4, NULL, 3.00000, 3.00000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', 5, '4', '', NULL, NULL, 1, 60, '2010-09-24 19:21:34'),
(19, '8090026', '', 'tube', 3, 2, 4, NULL, 3.00000, 3.00000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', 5, '3', '', NULL, NULL, 1, 61, '2010-09-24 19:21:34'),
(18, '8090025', '', 'tube', 3, 2, 4, NULL, 2.40000, 2.40000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', 5, '2', '', NULL, NULL, 1, 62, '2010-09-24 19:21:33'),
(17, '8090024', '', 'tube', 3, 2, 4, NULL, 3.40000, 3.40000, 'ml', 'yes - available', '', NULL, 1, '1999-09-03 18:13:00', 5, '6', '', NULL, NULL, 1, 63, '2010-09-24 19:21:33'),
(15, 'dna1_tb9', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '14', '', NULL, NULL, 1, 64, '2010-05-28 16:28:30'),
(13, 'dna1_tb7', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '22', '', NULL, NULL, 1, 65, '2010-05-28 16:28:28'),
(12, 'dna1_tb6', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '7', '', NULL, NULL, 1, 66, '2010-05-28 16:28:27'),
(11, 'dna1_tb5', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - not available', 'reserved for order', NULL, NULL, '2010-05-04 02:03:00', 7, '1', '', NULL, NULL, 1, 67, '2010-05-28 16:32:07'),
(9, 'dna1_tb3', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '24', '', NULL, NULL, 1, 68, '2010-05-28 16:28:23'),
(8, 'dna1_tb2', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '17', '', NULL, NULL, 1, 69, '2010-05-28 16:28:22'),
(7, 'dna1_tb1', '', 'tube', 29, 1, 3, NULL, 12.00000, 12.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-05-04 02:03:00', 7, '2', '', NULL, NULL, 1, 70, '2010-05-28 16:28:21'),
(3, 'b1_tb3', '', 'tube', 3, 1, 1, NULL, 5.00000, 0.60000, 'ml', 'yes - available', '', NULL, 1, '2003-04-23 13:35:00', 7, '9', '', NULL, NULL, 1, 71, '2010-05-28 16:05:02'),
(2, 'b1_tb2', '', 'tube', 3, 1, 1, NULL, 5.00000, 5.00000, 'ml', 'yes - available', '', NULL, 1, '2003-04-23 13:35:00', 7, '12', '', NULL, '', 1, 72, '2010-05-28 16:10:05'),
(34, '6436435345345rd', '', 'tube', 29, 4, 10, NULL, 4.00000, 4.00000, 'ul', 'yes - available', '', NULL, NULL, '1992-09-29 00:00:00', 4, '2', 'A', NULL, NULL, 1, 73, '2010-09-24 19:45:20'),
(30, 'r2323r23', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', 4, '1', 'B', NULL, NULL, 1, 74, '2010-09-24 19:38:09'),
(29, 'r2323r2', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', 4, '1', 'A', NULL, NULL, 1, 75, '2010-09-24 19:38:08'),
(30, 'r2323r23', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', 4, '1', 'A', NULL, NULL, 1, 76, '2010-09-24 19:38:09'),
(29, 'r2323r2', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', 4, '3', 'A', NULL, NULL, 1, 77, '2010-09-24 19:38:08'),
(36, 't6u9937', '', 'tube', 1, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1995-04-13 00:00:00', NULL, '', '', NULL, NULL, 1, 78, '2011-02-10 21:27:31'),
(37, 's56892', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1995-04-13 00:00:00', NULL, '', '', NULL, NULL, 1, 79, '2011-02-10 21:28:24'),
(38, 's56894', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1995-04-13 00:00:00', NULL, '', '', NULL, NULL, 1, 80, '2011-02-10 21:28:24'),
(39, 's56893', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1995-04-13 00:00:00', NULL, '', '', NULL, NULL, 1, 81, '2011-02-10 21:28:25'),
(36, 't6u9937', '', 'tube', 1, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1995-04-13 00:00:00', NULL, '', '', NULL, NULL, 1, 82, '2011-02-10 21:29:09'),
(37, 's56892', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1995-04-17 08:02:00', NULL, '', '', NULL, '', 1, 83, '2011-02-10 21:31:56'),
(39, 's56893', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1995-04-17 08:02:00', NULL, '', '', NULL, '', 1, 84, '2011-02-10 21:32:48'),
(38, 's56894', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1995-04-17 08:02:00', NULL, '', '', NULL, '', 1, 85, '2011-02-10 21:33:26'),
(36, 't6u9937', '', 'tube', 1, 3, 6, NULL, NULL, NULL, NULL, 'no', 'empty', 3, NULL, '1995-04-13 00:00:00', NULL, '', '', NULL, NULL, 1, 86, '2011-03-18 15:34:33'),
(40, 'bl6703.1', '', 'block', 9, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-03-18 13:00:00', 2, '', '', NULL, NULL, 1, 87, '2011-03-18 15:34:33'),
(41, 'bl6703.2', '', 'block', 9, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-03-18 13:00:00', 2, '', '', NULL, NULL, 1, 88, '2011-03-18 15:34:34'),
(36, 't6u9937', '', 'tube', 1, 3, 6, NULL, NULL, NULL, NULL, 'no', 'empty', 3, NULL, '1995-04-13 00:00:00', NULL, '', '', NULL, NULL, 1, 89, '2011-03-18 15:34:34'),
(41, 'bl6703.2', '', 'block', 9, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-03-18 13:00:00', 2, '', '', NULL, NULL, 1, 90, '2011-03-18 15:39:54'),
(42, 's89430.1', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, 1, '2011-03-18 17:00:00', NULL, '', '', NULL, NULL, 1, 91, '2011-03-18 15:39:54'),
(43, 's89430.2', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, 1, '2011-03-18 17:00:00', NULL, '', '', NULL, NULL, 1, 92, '2011-03-18 15:39:55'),
(41, 'bl6703.2', '', 'block', 9, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-03-18 13:00:00', 2, '', '', NULL, NULL, 1, 93, '2011-03-18 15:39:55'),
(44, 'bl9457687', '', 'block', 9, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1999-09-03 16:32:00', NULL, '', '', NULL, NULL, 1, 94, '2011-03-18 15:45:47'),
(44, 'bl9457687', '', 'block', 9, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1999-09-03 16:32:00', NULL, '', '', NULL, NULL, 1, 95, '2011-03-18 15:49:53'),
(45, 's89430.3', '', 'slide', 10, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-03-18 17:35:00', NULL, '', '', NULL, NULL, 1, 96, '2011-03-18 15:49:54'),
(46, 's89430.4', '', 'slide', 10, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-03-18 17:47:00', NULL, '', '', NULL, NULL, 1, 97, '2011-03-18 15:49:55'),
(44, 'bl9457687', '', 'block', 9, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1999-09-03 16:32:00', NULL, '', '', NULL, NULL, 1, 98, '2011-03-18 15:49:55'),
(41, 'bl6703.2', '', 'block', 9, 3, 6, NULL, NULL, NULL, '', 'no', '', NULL, NULL, '2011-03-18 13:00:00', NULL, '', '', NULL, NULL, 1, 99, '2011-03-18 17:11:13'),
(41, 'bl6703.2', '', 'block', 9, 3, 6, NULL, NULL, NULL, '', 'no', '', 3, NULL, '2011-03-18 13:00:00', NULL, '', '', NULL, NULL, 1, 100, '2011-03-18 17:11:15'),
(41, 'bl6703.2', '', 'block', 9, 3, 6, NULL, NULL, NULL, '', 'no', '', 4, NULL, '2011-03-18 13:00:00', NULL, '', '', NULL, NULL, 1, 101, '2011-03-18 17:21:20'),
(41, 'bl6703.2', '', 'block', 9, 3, 6, NULL, NULL, NULL, '', 'no', '', 4, NULL, '2011-03-18 13:00:00', NULL, '', '', NULL, NULL, 1, 102, '2011-03-18 17:22:34'),
(47, 'rS561', '', 'tube', 30, 3, 13, NULL, 13.23000, 13.23000, 'ul', 'yes - available', '', NULL, 1, '2011-04-01 11:08:00', 4, '5', 'A', NULL, NULL, 1, 103, '2011-03-18 17:27:02'),
(48, 'rS562', '', 'tube', 30, 3, 13, NULL, 13.23000, 13.23000, 'ul', 'yes - available', '', NULL, 1, '2011-04-01 11:08:00', 4, '5', 'B', NULL, NULL, 1, 104, '2011-03-18 17:27:02'),
(49, 'rS563', '', 'tube', 30, 3, 13, NULL, 13.23000, 13.23000, 'ul', 'yes - available', '', NULL, 1, '2011-04-01 11:08:00', 4, '5', 'C', NULL, NULL, 1, 105, '2011-03-18 17:27:02'),
(49, 'rS563', '', 'tube', 30, 3, 13, NULL, 13.23000, 13.23000, 'ul', 'yes - available', '', NULL, 1, '2011-04-01 11:08:00', 4, '2', 'C', NULL, NULL, 1, 106, '2011-03-18 17:27:02'),
(48, 'rS562', '', 'tube', 30, 3, 13, NULL, 13.23000, 13.23000, 'ul', 'yes - available', '', NULL, 1, '2011-04-01 11:08:00', 4, '2', 'B', NULL, NULL, 1, 107, '2011-03-18 17:27:02'),
(47, 'rS561', '', 'tube', 30, 3, 13, NULL, 13.23000, 13.23000, 'ul', 'yes - available', '', NULL, 1, '2011-04-01 11:08:00', 4, '1', 'B', NULL, NULL, 1, 108, '2011-03-18 17:27:02'),
(29, 'r2323r2', '', 'tube', 29, 3, 7, NULL, 23.00000, 23.00000, 'ul', 'yes - available', '', NULL, NULL, '2010-09-01 00:00:00', 4, '1', 'C', NULL, NULL, 1, 109, '2010-09-24 19:38:08'),
(48, 'rS562', '', 'tube', 30, 3, 13, NULL, 13.23000, 11.83000, 'ul', 'yes - available', '', 1, 1, '2011-04-01 11:08:00', 4, '2', 'B', NULL, NULL, 1, 110, '2011-03-18 17:30:02'),
(48, 'rS562', '', 'tube', 30, 3, 13, NULL, 13.23000, 11.83000, 'ul', 'yes - available', '', 1, 1, '2011-04-01 11:08:00', 4, '2', 'B', NULL, NULL, 1, 111, '2011-03-18 17:33:50'),
(50, 'rS562.1', '', 'tube', 30, 3, 13, NULL, 11.00000, 11.00000, 'ul', 'yes - available', '', NULL, NULL, NULL, NULL, '', '', NULL, NULL, 1, 112, '2011-03-18 17:33:51'),
(51, 'rS562.2', '', 'tube', 30, 3, 13, NULL, 11.00000, 11.00000, 'ul', 'yes - available', '', NULL, NULL, NULL, NULL, '', '', NULL, NULL, 1, 113, '2011-03-18 17:33:51'),
(48, 'rS562', '', 'tube', 30, 3, 13, NULL, 13.23000, 4.83000, 'ul', 'yes - available', '', 3, 1, '2011-04-01 11:08:00', 4, '2', 'B', NULL, NULL, 1, 114, '2011-03-18 17:33:52'),
(48, 'rS562', '', 'tube', 30, 3, 13, NULL, 13.23000, 4.80000, 'ul', 'yes - available', '', 3, 1, '2011-04-01 11:08:00', 4, '2', 'B', NULL, NULL, 1, 115, '2011-03-18 17:35:18'),
(48, 'rS562', '', 'tube', 30, 3, 13, NULL, 13.23000, 4.80000, 'ul', 'no', '', 3, 1, '2011-04-01 11:08:00', NULL, '', '', NULL, NULL, 1, 116, '2011-03-18 17:37:37'),
(48, 'rS562', '', 'tube', 30, 3, 13, NULL, 13.23000, 2.10000, 'ul', 'no', '', 4, 1, '2011-04-01 11:08:00', NULL, '', '', NULL, NULL, 1, 117, '2011-03-18 17:37:38'),
(48, 'rS562', '', 'tube', 30, 3, 13, NULL, 13.23000, 2.10000, 'ul', 'no', '', 4, 1, '2011-04-01 11:08:00', NULL, '', '', NULL, NULL, 1, 118, '2011-03-18 17:40:57'),
(48, 'rS562', '', 'tube', 30, 3, 13, NULL, 13.23000, 0.80000, 'ul', 'no', '', 5, 1, '2011-04-01 11:08:00', NULL, '', '', NULL, NULL, 1, 119, '2011-03-18 17:40:58'),
(50, 'rS562.1', '', 'tube', 30, 3, 13, NULL, 11.00000, 11.00000, 'ul', 'yes - not available', 'reserved for order', NULL, NULL, NULL, NULL, '', '', NULL, NULL, 1, 120, '2011-03-18 17:44:22'),
(50, 'rS562.1', '', 'tube', 30, 3, 13, NULL, 11.00000, 11.00000, 'ul', 'no', 'shipped', NULL, NULL, NULL, NULL, '', '', NULL, NULL, 1, 121, '2011-03-18 17:45:25'),
(50, 'rS562.1', '', 'tube', 30, 3, 13, NULL, 11.00000, 11.00000, 'ul', 'no', 'shipped', 1, NULL, NULL, NULL, '', '', NULL, NULL, 1, 122, '2011-03-18 17:45:26'),
(43, 's89430.2', '', 'slide', 10, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', 1, 1, '2011-03-18 17:00:00', NULL, '', '', NULL, NULL, 1, 123, '2011-03-18 17:49:30'),
(44, 'bl9457687', '', 'block', 9, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1999-09-03 16:32:00', NULL, '', '', NULL, NULL, 1, 124, '2011-03-18 17:53:08'),
(52, 'c1', '', 'core', 33, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-06-18 17:52:00', 11, '1', '1', NULL, NULL, 1, 125, '2011-03-18 17:53:09'),
(44, 'bl9457687', '', 'block', 9, 2, 11, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '1999-09-03 16:32:00', NULL, '', '', NULL, NULL, 1, 126, '2011-03-18 17:53:10'),
(41, 'bl6703.2', '', 'block', 9, 3, 6, NULL, NULL, NULL, '', 'no', '', 4, NULL, '2011-03-18 13:00:00', NULL, '', '', NULL, NULL, 1, 127, '2011-03-18 17:53:59'),
(53, 'c2', '', 'core', 33, 3, 6, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, NULL, '2011-05-18 17:53:00', 11, '1', '2', NULL, NULL, 1, 128, '2011-03-18 17:54:00'),
(41, 'bl6703.2', '', 'block', 9, 3, 6, NULL, NULL, NULL, '', 'no', '', 4, NULL, '2011-03-18 13:00:00', NULL, '', '', NULL, NULL, 1, 129, '2011-03-18 17:54:01');

--
-- Dumping data for table `aliquot_review_masters`
--

INSERT INTO `aliquot_review_masters` (`id`, `aliquot_review_control_id`, `specimen_review_master_id`, `aliquot_master_id`, `review_code`, `basis_of_specimen_review`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 1, NULL, 'rv378', 'y', '2011-02-10 21:35:47', 1, '2011-02-10 21:35:47', 1, 0),
(2, 1, 1, NULL, 'rv378', '', '2011-02-10 21:35:48', 1, '2011-02-10 21:35:48', 1, 0),
(3, 1, 2, 43, 'TR-95.1', '', '2011-03-18 17:49:29', 1, '2011-03-18 17:49:29', 1, 0);

--
-- Dumping data for table `aliquot_review_masters_revs`
--

INSERT INTO `aliquot_review_masters_revs` (`id`, `aliquot_review_control_id`, `specimen_review_master_id`, `aliquot_master_id`, `review_code`, `basis_of_specimen_review`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, 1, 39, 'rv378', 'y', 1, 1, '2011-02-10 21:35:47'),
(2, 1, 1, 37, 'rv378', '', 1, 2, '2011-02-10 21:35:48'),
(3, 1, 2, 43, 'TR-95.1', '', 1, 3, '2011-03-18 17:49:29');

--
-- Dumping data for table `ar_breast_tissue_slides`
--

INSERT INTO `ar_breast_tissue_slides` (`id`, `aliquot_review_master_id`, `type`, `length`, `width`, `invasive_percentage`, `in_situ_percentage`, `normal_percentage`, `stroma_percentage`, `necrosis_inv_percentage`, `necrosis_is_percentage`, `inflammation`, `quality_score`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2011-02-10 21:35:48', 1, '2011-02-10 21:35:48', 1, 0),
(2, 2, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2011-02-10 21:35:48', 1, '2011-02-10 21:35:48', 1, 0),
(3, 3, 'tumor', NULL, NULL, 54.0, NULL, 34.0, NULL, NULL, NULL, NULL, NULL, '2011-03-18 17:49:29', 1, '2011-03-18 17:49:29', 1, 0);

--
-- Dumping data for table `ar_breast_tissue_slides_revs`
--

INSERT INTO `ar_breast_tissue_slides_revs` (`id`, `aliquot_review_master_id`, `type`, `length`, `width`, `invasive_percentage`, `in_situ_percentage`, `normal_percentage`, `stroma_percentage`, `necrosis_inv_percentage`, `necrosis_is_percentage`, `inflammation`, `quality_score`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, '2011-02-10 21:35:48'),
(2, 2, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 2, '2011-02-10 21:35:48'),
(3, 3, 'tumor', NULL, NULL, 54.0, NULL, 34.0, NULL, NULL, NULL, NULL, NULL, 1, 3, '2011-03-18 17:49:29');

--
-- Dumping data for table `banks`
--

INSERT INTO `banks` (`id`, `name`, `description`, `misc_identifier_control_id`, `created_by`, `created`, `modified_by`, `modified`, `deleted`) VALUES
(2, 'Ovary Bk', '', NULL, 1, '2010-05-28 10:47:46', 1, '2010-05-28 10:47:46', 0),
(3, 'Prostate Bk', '', NULL, 1, '2010-05-28 10:49:46', 1, '2010-05-28 10:49:46', 0);

--
-- Dumping data for table `banks_revs`
--

INSERT INTO `banks_revs` (`id`, `name`, `description`, `misc_identifier_control_id`, `modified_by`, `version_id`, `version_created`) VALUES
(2, 'Ovary Bk', '', NULL, 1, 1, '2010-05-28 10:47:46'),
(3, 'Prostate Bk', '', NULL, 1, 2, '2010-05-28 10:49:46');

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
(1, 1, 1, '2010-05-28 14:07:25'),
(2, 2, 2, '2010-09-24 19:32:53'),
(3, 3, 3, '2010-09-24 19:41:54');

--
-- Dumping data for table `clinical_collection_links`
--

INSERT INTO `clinical_collection_links` (`id`, `participant_id`, `collection_id`, `diagnosis_master_id`, `consent_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 1, 2, 1, '2010-05-28 14:34:39', 1, '2010-05-28 14:34:39', 1, 0),
(2, 1, 2, 2, 1, '2010-09-24 19:18:31', 1, '2010-09-24 19:18:31', 1, 0),
(3, 2, 3, NULL, NULL, '2010-09-24 19:33:08', 1, '2010-09-24 19:33:08', 1, 0),
(4, 3, 4, 5, 3, '2010-09-24 19:42:35', 1, '2010-09-24 19:42:35', 1, 0);

--
-- Dumping data for table `clinical_collection_links_revs`
--

INSERT INTO `clinical_collection_links_revs` (`id`, `participant_id`, `collection_id`, `diagnosis_master_id`, `consent_master_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, NULL, 2, 1, 1, 1, '2010-05-28 14:34:39'),
(1, 1, 1, 2, 1, 1, 2, '2010-05-28 14:34:39'),
(2, 1, NULL, 2, 1, 1, 3, '2010-09-24 19:18:31'),
(2, 1, 2, 2, 1, 1, 4, '2010-09-24 19:18:31'),
(3, 2, NULL, NULL, NULL, 1, 5, '2010-09-24 19:33:08'),
(3, 2, 3, NULL, NULL, 1, 6, '2010-09-24 19:33:08'),
(4, 3, NULL, 5, 3, 1, 7, '2010-09-24 19:42:35'),
(4, 3, 4, 5, 3, 1, 8, '2010-09-24 19:42:35');

--
-- Dumping data for table `collections`
--

INSERT INTO `collections` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'OV_9874_20030423', 2, 'collection site 1', '2003-04-23 09:08:00', '', 1, 'participant collection', '', '2010-05-28 14:35:51', 1, '2010-05-28 14:35:51', 1, 0),
(2, 'Coll6798', 2, 'collection site 2', '1999-09-03 07:12:00', '', NULL, 'participant collection', '', '2010-09-24 19:18:58', 1, '2010-09-24 19:18:58', 1, 0),
(3, '80kd', 2, 'collection site 2', '1995-04-13 00:00:00', '', NULL, 'participant collection', '', '2010-09-24 19:33:26', 1, '2010-09-24 19:33:26', 1, 0),
(4, '8894', NULL, '', NULL, '', NULL, 'participant collection', '', '2010-09-24 19:42:43', 1, '2010-09-24 19:42:43', 1, 0);

--
-- Dumping data for table `collections_revs`
--

INSERT INTO `collections_revs` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'OV_9874_20030423', 2, 'collection site 1', '2003-04-23 09:08:00', '', 1, 'participant collection', '', 1, 1, '2010-05-28 14:35:51'),
(2, 'Coll6798', 2, 'collection site 2', '1999-09-03 07:12:00', '', NULL, 'participant collection', '', 1, 2, '2010-09-24 19:18:58'),
(3, '80kd', 2, 'collection site 2', '1995-04-13 00:00:00', '', NULL, 'participant collection', '', 1, 3, '2010-09-24 19:33:26'),
(4, '8894', NULL, '', NULL, '', NULL, 'participant collection', '', 1, 4, '2010-09-24 19:42:43');

--
-- Dumping data for table `consent_masters`
--

INSERT INTO `consent_masters` (`id`, `date_of_referral`, `date_of_referral_accuracy`, `route_of_referral`, `date_first_contact`, `date_first_contact_accuracy`, `consent_signed_date`, `consent_signed_date_accuracy`, `form_version`, `reason_denied`, `consent_status`, `process_status`, `status_date`, `status_date_accuracy`, `surgeon`, `operation_date`, `operation_date_accuracy`, `facility`, `notes`, `consent_method`, `translator_indicator`, `translator_signature`, `consent_person`, `facility_other`, `acquisition_id`, `participant_id`, `consent_control_id`, `type`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, NULL, '', 'doctor', '2003-05-06', '', '2003-08-06', '', '2.90', '', 'obtained', '', '2003-08-06', '', '', NULL, '', '', '', 'in person', 'n', '', '', '', NULL, 1, 1, '', '2010-05-28 14:07:24', 1, '2010-05-28 14:07:24', 1, 0),
(2, NULL, '', '', NULL, '', NULL, '', '', '', 'obtained', '', '2010-09-01', '', '', NULL, '', '', '', '', '', '', '', '', NULL, 2, 1, '', '2010-09-24 19:32:53', 1, '2010-09-24 19:32:53', 1, 0),
(3, NULL, '', '', NULL, '', NULL, '', '', '', 'withdrawn', '', NULL, '', '', NULL, '', '', '', 'fax', '', '', '', '', NULL, 3, 1, '', '2010-09-24 19:41:54', 1, '2010-09-24 19:41:54', 1, 0);

--
-- Dumping data for table `consent_masters_revs`
--

INSERT INTO `consent_masters_revs` (`id`, `date_of_referral`, `route_of_referral`, `date_first_contact`, `consent_signed_date`, `form_version`, `reason_denied`, `consent_status`, `process_status`, `status_date`, `surgeon`, `operation_date`, `facility`, `notes`, `consent_method`, `translator_indicator`, `translator_signature`, `consent_person`, `facility_other`, `acquisition_id`, `participant_id`, `consent_control_id`, `type`, `modified_by`, `version_id`, `version_created`) VALUES
(1, NULL, 'doctor', '2003-05-06', '2003-08-06', '2.90', '', 'obtained', '', '2003-08-06', '', NULL, '', '', 'in person', 'no', '', '', '', NULL, 1, 1, '', 1, 1, '2010-05-28 14:07:24'),
(2, NULL, '', NULL, NULL, '', '', 'obtained', '', '2010-09-01', '', NULL, '', '', '', '', '', '', '', NULL, 2, 1, '', 1, 2, '2010-09-24 19:32:53'),
(3, NULL, '', NULL, NULL, '', '', 'withdrawn', '', NULL, '', NULL, '', '', 'fax', '', '', '', '', NULL, 3, 1, '', 1, 3, '2010-09-24 19:41:54');

--
-- Dumping data for table `datamart_adhoc`
--

INSERT INTO `datamart_adhoc` (`id`, `title`, `description`, `plugin`, `model`, `form_alias_for_search`, `form_alias_for_results`, `form_links_for_results`, `sql_query_for_results`, `flag_use_query_results`, `created`, `created_by`, `modified`, `modified_by`) VALUES
(1, 'QR_AQ_1_Demo', 'Search based on Participant + Aliquots criteria & Display Participant + Aliquots data<br>\n(<b>model</b> = ''AliquotMaster'', <b>form_alias_for_search</b> = ''QR_AQ_complexe'', <b>form_alias_for_results</b> = ''QR_AQ_complexe'', <b>flag_use_query_results</b> = 1)', 'Inventorymanagement', 'AliquotMaster', 'QR_AQ_complexe', 'QR_AQ_complexe', 'participant detail=>/clinicalannotation/participants/profile/%%Participant.id%%/|aliquot detail=>/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/', 'SELECT \nAliquotMaster.id,\nAliquotMaster.sample_master_id,\nAliquotMaster.collection_id,\nParticipant.id,\nParticipant.participant_identifier,\nParticipant.sex,\nAliquotMaster.barcode,\nSampleMaster.sample_type,\nAliquotMaster.aliquot_type,\nAliquotMaster.in_stock\nFROM participants AS Participant\nINNER JOIN clinical_collection_links AS link ON link.participant_id = Participant.id\nINNER JOIN collections AS Collection ON Collection.id = link.collection_id\nINNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id \nINNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id \nLEFT JOIN storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id \nWHERE TRUE\nAND Participant.participant_identifier = "@@Participant.participant_identifier@@" \nAND Participant.sex = "@@Participant.sex@@" \nAND SampleMaster.sample_type = "@@SampleMaster.sample_type@@" \nAND AliquotMaster.aliquot_type = "@@AliquotMaster.aliquot_type@@"  \nAND AliquotMaster.in_stock = "@@AliquotMaster.in_stock@@"\nORDER BY Participant.participant_identifier;', 1, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(2, 'QR_AQ_2_Demo', 'Search based on Participant + Aliquots criteria & Display Aliquots data<br>\n(<b>model</b> = ''AliquotMaster'', <b>form_alias_for_search</b> = ''QR_AQ_complexe'', <b>form_alias_for_results</b> = ''aliquot_masters_for_collection_tree_view'', <b>flag_use_query_results</b> = 0)', 'Inventorymanagement', 'AliquotMaster', 'QR_AQ_complexe', 'aliquot_masters_for_collection_tree_view', 'aliquot detail=>/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/', 'SELECT \nAliquotMaster.id,\nAliquotMaster.sample_master_id,\nAliquotMaster.collection_id,\nParticipant.id,\nParticipant.participant_identifier,\nParticipant.sex,\nAliquotMaster.barcode,\nSampleMaster.sample_type,\nAliquotMaster.aliquot_type,\nAliquotDetail.block_type,\nAliquotMaster.in_stock\nFROM participants AS Participant\nINNER JOIN clinical_collection_links AS link ON link.participant_id = Participant.id\nINNER JOIN collections AS Collection ON Collection.id = link.collection_id\nINNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id \nINNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id \nLEFT JOIN storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id \nLEFT JOIN ad_blocks AS AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id \nWHERE TRUE\nAND Participant.participant_identifier = "@@Participant.participant_identifier@@" \nAND Participant.sex = "@@Participant.sex@@" \nAND SampleMaster.sample_type = "@@SampleMaster.sample_type@@" \nAND AliquotMaster.aliquot_type = "@@AliquotMaster.aliquot_type@@"  \nAND AliquotMaster.in_stock = "@@AliquotMaster.in_stock@@"\nORDER BY Participant.participant_identifier;', 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(3, 'QR_AQ_3_Demo', 'Search Stored Sample Tube (using many fields having different type)<br>\n(<b>model</b> = ''AliquotMaster'', <b>form_alias_for_search</b> = ''QR_AQ_complexe_3'', <b>form_alias_for_results</b> = ''QR_AQ_complexe_3'', <b>flag_use_query_results</b> = 1)', 'Inventorymanagement', 'AliquotMaster', 'QR_AQ_complexe_3', 'QR_AQ_complexe_3', 'storage detail=>/storagelayout/storage_masters/detail/%%StorageMaster.id%%/|aliquot detail=>/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%/', 'SELECT \nCollection.id,\nSampleMaster.id,\nAliquotMaster.id,\nStorageMaster.id, \n \nCollection.acquisition_label,\nAliquotMaster.barcode, \nCollection.bank_id, \nSampleMaster.sample_type, \nAliquotMaster.aliquot_type, \nAliquotMaster.in_stock,\nAliquotMaster.storage_datetime, \nStorageMaster.short_label, \nStorageMaster.selection_label, \nAliquotMaster.storage_coord_x, \nAliquotMaster.storage_coord_y, \nStorageMaster.temperature, \nStorageMaster.temp_unit \nFROM collections AS Collection \nINNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id \nINNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id \nINNER JOIN storage_masters AS StorageMaster ON AliquotMaster.storage_master_id = StorageMaster.id \nWHERE TRUE\nAND Collection.acquisition_label = "@@Collection.acquisition_label@@"\nAND AliquotMaster.barcode = "@@AliquotMaster.barcode@@" \nAND Collection.bank_id = "@@Collection.bank_id@@"\nAND SampleMaster.sample_type = "@@SampleMaster.sample_type@@" \nAND AliquotMaster.aliquot_control_id IN (SELECT id FROM aliquot_controls WHERE aliquot_type = "tube")\nAND AliquotMaster.in_stock = "@@AliquotMaster.in_stock@@" \nAND AliquotMaster.storage_datetime >= "@@AliquotMaster.storage_datetime_start@@" \nAND AliquotMaster.storage_datetime <= "@@AliquotMaster.storage_datetime_end@@" \nAND (StorageMaster.short_label = "@@StorageMaster.short_label@@"\nAND (StorageMaster.short_label >= "@@StorageMaster.short_label_start@@" \nAND StorageMaster.short_label <= "@@StorageMaster.short_label_end@@"))\nAND StorageMaster.temperature >= "@@StorageMaster.temperature_start@@" \nAND StorageMaster.temperature <= "@@StorageMaster.temperature_end@@" \nAND StorageMaster.temp_unit = "@@StorageMaster.temp_unit@@" \nORDER BY AliquotMaster.barcode;', 1, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0),
(4, 'QR_SM_4_Demo', 'Search based on Participant + Samples criteria & Display Participant + Samples data<br>\n(<b>model</b> = ''SampleMaster'', <b>form_alias_for_search</b> = ''QR_SM_complexe'', <b>form_alias_for_results</b> = ''QR_SM_complexe'', <b>flag_use_query_results</b> = 1)', 'Inventorymanagement', 'SampleMaster', 'QR_SM_complexe', 'QR_SM_complexe', 'participant detail=>/clinicalannotation/participants/profile/%%Participant.id%%/|sample detail=>/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/', 'SELECT \nSampleMaster.id,\nSampleMaster.collection_id,\nParticipant.id,\nParticipant.participant_identifier,\nParticipant.sex,\nSampleMaster.sample_type,\nSampleMaster.sample_code\nFROM participants AS Participant\nINNER JOIN clinical_collection_links AS link ON link.participant_id = Participant.id\nINNER JOIN collections AS Collection ON Collection.id = link.collection_id\nINNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id\nWHERE TRUE\nAND Participant.participant_identifier = "@@Participant.participant_identifier@@" \nAND Participant.sex = "@@Participant.sex@@" \nAND SampleMaster.sample_type = "@@SampleMaster.sample_type@@"\nORDER BY Participant.participant_identifier;', 1, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', 0);

--
-- Dumping data for table `derivative_details`
--

INSERT INTO `derivative_details` (`id`, `sample_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `lab_book_master_id`, `sync_with_lab_book`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `creation_datetime_accuracy`) VALUES
(1, 2, '', '', '2003-04-23 17:18:00', NULL, 0, '2010-05-28 16:18:14', 1, '2010-05-28 16:18:56', 1, 0, ''),
(2, 3, '', '', '2010-05-04 02:03:00', NULL, 0, '2010-05-28 16:24:54', 1, '2010-05-28 16:24:54', 1, 0, ''),
(3, 5, 'laboratory site 2', 'laboratory staff 2', '2008-02-12 00:00:00', NULL, 0, '2010-09-24 19:22:49', 1, '2010-09-24 19:22:49', 1, 0, ''),
(4, 7, 'laboratory site 1', 'laboratory staff 2', '2010-09-01 00:00:00', NULL, 0, '2010-09-24 19:35:15', 1, '2010-09-24 19:35:15', 1, 0, ''),
(5, 9, '', '', NULL, NULL, 0, '2010-09-24 19:43:34', 1, '2010-09-24 19:43:34', 1, 0, ''),
(6, 10, '', '', NULL, NULL, 0, '2010-09-24 19:43:47', 1, '2010-09-24 19:43:47', 1, 0, ''),
(7, 12, 'laboratory site 2', 'laboratory staff 2', '2011-03-19 07:11:00', 2, 1, '2011-03-18 17:07:59', 1, '2011-03-18 17:09:53', 1, 0, ''),
(8, 13, '', 'laboratory staff etc', '2011-04-01 00:00:00', NULL, 0, '2011-03-18 17:24:37', 1, '2011-03-18 17:24:37', 1, 0, ''),
(9, 14, 'laboratory site 2', 'laboratory staff etc', '2011-06-01 00:00:00', NULL, 0, '2011-03-18 17:40:02', 1, '2011-03-18 17:40:02', 1, 0, '');

--
-- Dumping data for table `derivative_details_revs`
--

INSERT INTO `derivative_details_revs` (`id`, `sample_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `lab_book_master_id`, `sync_with_lab_book`, `modified_by`, `version_id`, `version_created`, `creation_datetime_accuracy`) VALUES
(1, 2, '', '', '2003-05-23 17:18:00', NULL, 0, 1, 1, '2010-05-28 16:18:14', ''),
(1, 2, '', '', '2003-04-23 17:18:00', NULL, 0, 1, 2, '2010-05-28 16:18:56', ''),
(2, 3, '', '', '2010-05-04 02:03:00', NULL, 0, 1, 3, '2010-05-28 16:24:54', ''),
(3, 5, 'laboratory site 2', 'laboratory staff 2', '2008-02-12 00:00:00', NULL, 0, 1, 4, '2010-09-24 19:22:49', ''),
(4, 7, 'laboratory site 1', 'laboratory staff 2', '2010-09-01 00:00:00', NULL, 0, 1, 5, '2010-09-24 19:35:15', ''),
(5, 9, '', '', NULL, NULL, 0, 1, 6, '2010-09-24 19:43:34', ''),
(6, 10, '', '', NULL, NULL, 0, 1, 7, '2010-09-24 19:43:47', ''),
(7, 12, 'laboratory site 2', 'laboratory staff 2', '2011-02-02 07:11:00', 2, 1, 1, 8, '2011-03-18 17:07:59', ''),
(7, 12, 'laboratory site 2', 'laboratory staff 2', '2011-03-19 07:11:00', 2, 1, 1, 9, '2011-03-18 17:08:37', ''),
(7, 12, 'laboratory site 2', 'laboratory staff 2', '2011-03-19 07:11:00', 2, 1, 1, 10, '2011-03-18 17:09:53', ''),
(8, 13, '', 'laboratory staff etc', '2011-04-01 00:00:00', NULL, 0, 1, 11, '2011-03-18 17:24:37', ''),
(9, 14, 'laboratory site 2', 'laboratory staff etc', '2011-06-01 00:00:00', NULL, 0, 1, 12, '2011-03-18 17:40:02', '');

--
-- Dumping data for table `diagnosis_masters`
--

INSERT INTO `diagnosis_masters` (`id`, `dx_identifier`, `primary_number`, `dx_method`, `dx_nature`, `dx_origin`, `dx_date`, `dx_date_accuracy`, `tumor_size_greatest_dimension`, `additional_dimension_a`, `additional_dimension_b`, `tumor_size_cannot_be_determined`, `primary_icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `morphology`, `topography`, `tumour_grade`, `tumour_grade_specify`, `age_at_dx`, `age_at_dx_accuracy`, `ajcc_edition`, `collaborative_staged`, `clinical_tstage`, `clinical_nstage`, `clinical_mstage`, `clinical_stage_summary`, `path_tnm_descriptor_m`, `path_tnm_descriptor_r`, `path_tnm_descriptor_y`, `path_tstage`, `path_nstage`, `path_nstage_nbr_node_examined`, `path_nstage_nbr_node_involved`, `path_mstage`, `path_mstage_metastasis_site_specify`, `path_stage_summary`, `survival_time_months`, `information_source`, `notes`, `diagnosis_control_id`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, NULL, 1, 'radiology', 'malignant', 'primary', '2001-03-05', 'm', NULL, NULL, NULL, 0, 'C501', '', '', '', '', 'well differentiated', NULL, NULL, '', '5th', 'yes', 'IV', '', '', 'IV', '', '', '', 'IA', '', 0, 0, '', NULL, '', NULL, '', '', 2, 1, '2010-05-28 14:09:11', 1, '2010-05-28 14:12:54', 1, 0),
(2, NULL, 1, 'cytology', 'malignant', 'secondary', '2003-02-01', '', NULL, NULL, NULL, 0, 'C509', '', '', '', '', 'well differentiated', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 1, '2010-05-28 14:11:42', 1, '2010-05-28 14:11:42', 1, 0),
(3, NULL, 2, '', 'malignant', 'primary', '2002-06-13', '', NULL, NULL, NULL, 0, 'C530', '', '', '', '', '', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 1, '2010-05-28 14:14:39', 1, '2010-05-28 14:14:39', 1, 0),
(4, NULL, NULL, 'radiology', 'malignant', 'primary', '1997-01-14', '', NULL, NULL, NULL, 0, 'D461', '', '', '80023', '', 'poorly differentiated', NULL, NULL, '', '', '', 'pT4', 'pN2', 'pMx', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 2, '2010-09-24 19:32:26', 1, '2010-09-24 19:32:26', 1, 0),
(5, NULL, NULL, 'autopsy', 'malignant', 'primary', '1992-09-09', '', NULL, NULL, NULL, 0, NULL, '', '', '80010', '', 'well differentiated', NULL, NULL, '', '', '', 'pT1', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 3, '2010-09-24 19:40:52', 1, '2010-09-24 19:40:52', 1, 0);

--
-- Dumping data for table `diagnosis_masters_revs`
--

INSERT INTO `diagnosis_masters_revs` (`id`, `dx_identifier`, `primary_number`, `dx_method`, `dx_nature`, `dx_origin`, `dx_date`, `dx_date_accuracy`, `tumor_size_greatest_dimension`, `additional_dimension_a`, `additional_dimension_b`, `tumor_size_cannot_be_determined`, `primary_icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `morphology`, `topography`, `tumour_grade`, `tumour_grade_specify`, `age_at_dx`, `age_at_dx_accuracy`, `ajcc_edition`, `collaborative_staged`, `clinical_tstage`, `clinical_nstage`, `clinical_mstage`, `clinical_stage_summary`, `path_tnm_descriptor_m`, `path_tnm_descriptor_r`, `path_tnm_descriptor_y`, `path_tstage`, `path_nstage`, `path_nstage_nbr_node_examined`, `path_nstage_nbr_node_involved`, `path_mstage`, `path_mstage_metastasis_site_specify`, `path_stage_summary`, `survival_time_months`, `information_source`, `notes`, `diagnosis_control_id`, `participant_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, NULL, NULL, 'radiology', 'malignant', 'primary', '2001-03-05', 'm', NULL, NULL, NULL, 0, 'C166', '', '', '', '', 'well differentiated', NULL, NULL, '', '5th', 'yes', 'IV', '', '', 'IV', '', '', '', 'IA', '', 0, 0, '', NULL, '', NULL, '', '', 2, 1, 1, 1, '2010-05-28 14:09:11'),
(1, NULL, NULL, 'radiology', 'malignant', 'primary', '2001-03-05', 'm', NULL, NULL, NULL, 0, 'C501', '', '', '', '', 'well differentiated', NULL, NULL, '', '5th', 'yes', 'IV', '', '', 'IV', '', '', '', 'IA', '', 0, 0, '', NULL, '', NULL, '', '', 2, 1, 1, 2, '2010-05-28 14:10:26'),
(2, NULL, 1, 'cytology', 'malignant', 'secondary', '2003-02-01', '', NULL, NULL, NULL, 0, 'C509', '', '', '', '', 'well differentiated', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 1, 1, 3, '2010-05-28 14:11:42'),
(1, NULL, 1, 'radiology', 'malignant', 'primary', '2001-03-05', 'm', NULL, NULL, NULL, 0, 'C501', '', '', '', '', 'well differentiated', NULL, NULL, '', '5th', 'yes', 'IV', '', '', 'IV', '', '', '', 'IA', '', 0, 0, '', NULL, '', NULL, '', '', 2, 1, 1, 4, '2010-05-28 14:12:54'),
(3, NULL, 2, '', 'malignant', 'primary', '2002-06-13', '', NULL, NULL, NULL, 0, 'C530', '', '', '', '', '', NULL, NULL, '', '', '', '', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 1, 1, 5, '2010-05-28 14:14:39'),
(4, NULL, NULL, 'radiology', 'malignant', 'primary', '1997-01-14', '', NULL, NULL, NULL, 0, 'D461', '', '', '80023', '', 'poorly differentiated', NULL, NULL, '', '', '', 'pT4', 'pN2', 'pMx', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 2, 1, 6, '2010-09-24 19:32:26'),
(5, NULL, NULL, 'autopsy', 'malignant', 'primary', '1992-09-09', '', NULL, NULL, NULL, 0, NULL, '', '', '80010', '', 'well differentiated', NULL, NULL, '', '', '', 'pT1', '', '', '', '', '', '', '', '', 0, 0, '', NULL, '', NULL, '', '', 2, 3, 1, 7, '2010-09-24 19:40:52');

--
-- Dumping data for table `drugs`
--

INSERT INTO `drugs` (`id`, `generic_name`, `trade_name`, `type`, `description`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, '5FU', '', 'chemotherapy', '', '2010-05-28 11:18:39', 1, '2010-05-28 11:18:39', 1, 0),
(2, 'Doxorubicine', '', 'chemotherapy', '', '2010-05-28 11:21:42', 1, '2010-05-28 11:21:42', 1, 0),
(3, 'Tamoxifene', '', 'hormonal', '', '2010-05-28 11:23:41', 1, '2010-05-28 11:23:41', 1, 0);

--
-- Dumping data for table `drugs_revs`
--

INSERT INTO `drugs_revs` (`id`, `generic_name`, `trade_name`, `type`, `description`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '5FU', '', 'chemotherapy', '', 1, 1, '2010-05-28 11:18:39'),
(2, 'Doxorubicine', '', 'chemotherapy', '', 1, 2, '2010-05-28 11:21:42'),
(3, 'Tamoxifene', '', 'hormonal', '', 1, 3, '2010-05-28 11:23:41');

--
-- Dumping data for table `dxd_tissues`
--

INSERT INTO `dxd_tissues` (`id`, `diagnosis_master_id`, `laterality`, `deleted`) VALUES
(1, 1, 'left', 0),
(2, 2, 'left', 0),
(3, 3, '', 0),
(4, 4, '', 0),
(5, 5, '', 0);

--
-- Dumping data for table `dxd_tissues_revs`
--

INSERT INTO `dxd_tissues_revs` (`id`, `diagnosis_master_id`, `laterality`, `version_id`, `version_created`) VALUES
(1, 1, 'left', 1, '2010-05-28 14:09:12'),
(1, 1, 'left', 2, '2010-05-28 14:10:27'),
(2, 2, 'left', 3, '2010-05-28 14:11:43'),
(1, 1, 'left', 4, '2010-05-28 14:12:55'),
(3, 3, '', 5, '2010-05-28 14:14:40'),
(4, 4, '', 6, '2010-09-24 19:32:26'),
(5, 5, '', 7, '2010-09-24 19:40:52');

--
-- Dumping data for table `ed_all_clinical_presentations`
--

INSERT INTO `ed_all_clinical_presentations` (`id`, `weight`, `height`, `event_master_id`, `deleted`) VALUES
(1, 63.00, 1.00, 1, 0);

--
-- Dumping data for table `ed_all_clinical_presentations_revs`
--

INSERT INTO `ed_all_clinical_presentations_revs` (`id`, `weight`, `height`, `event_master_id`, `version_id`, `version_created`) VALUES
(1, 63.00, 1.00, 1, 1, '2010-05-28 14:16:50');

--
-- Dumping data for table `ed_all_lifestyle_smokings`
--

INSERT INTO `ed_all_lifestyle_smokings` (`id`, `smoking_history`, `smoking_status`, `pack_years`, `product_used`, `years_quit_smoking`, `event_master_id`, `deleted`) VALUES
(1, 'yes', 'ex-smoker', 36, 'cigarettes', 4, 2, 0);

--
-- Dumping data for table `ed_all_lifestyle_smokings_revs`
--

INSERT INTO `ed_all_lifestyle_smokings_revs` (`id`, `smoking_history`, `smoking_status`, `pack_years`, `product_used`, `years_quit_smoking`, `event_master_id`, `version_id`, `version_created`) VALUES
(1, 'yes', 'ex-smoker', 36, 'cigarettes', 4, 2, 1, '2010-05-28 14:20:24');

--
-- Dumping data for table `event_masters`
--

INSERT INTO `event_masters` (`id`, `event_control_id`, `event_status`, `event_summary`, `event_date`, `event_date_accuracy`, `information_source`, `urgency`, `date_required`, `date_required_accuracy`, `date_requested`, `date_requested_accuracy`, `reference_number`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`, `diagnosis_master_id`, `deleted`) VALUES
(1, 22, NULL, '', '2003-02-10', '', NULL, NULL, NULL, '', NULL, '', NULL, '2010-05-28 14:16:49', 1, '2010-05-28 14:16:49', 1, 1, 2, 0),
(2, 30, NULL, '', '2003-03-08', '', NULL, NULL, NULL, '', NULL, '', NULL, '2010-05-28 14:20:24', 1, '2010-05-28 14:20:24', 1, 1, 2, 0);

--
-- Dumping data for table `event_masters_revs`
--

INSERT INTO `event_masters_revs` (`id`, `event_control_id`, `event_status`, `event_summary`, `event_date`, `information_source`, `urgency`, `date_required`, `date_requested`, `reference_number`, `modified_by`, `participant_id`, `diagnosis_master_id`, `version_id`, `version_created`) VALUES
(1, 22, NULL, '', '2003-02-10', NULL, NULL, NULL, NULL, NULL, 1, 1, 2, 1, '2010-05-28 14:16:49'),
(2, 30, NULL, '', '2003-03-08', NULL, NULL, NULL, NULL, NULL, 1, 1, 2, 2, '2010-05-28 14:20:24');

--
-- Dumping data for table `family_histories`
--

INSERT INTO `family_histories` (`id`, `relation`, `family_domain`, `primary_icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `age_at_dx`, `age_at_dx_accuracy`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'mother', 'maternal', 'C504', '', '', NULL, '', 1, '2010-05-28 14:28:12', 1, '2010-05-28 14:28:12', 1, 0);

--
-- Dumping data for table `family_histories_revs`
--

INSERT INTO `family_histories_revs` (`id`, `relation`, `family_domain`, `primary_icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `age_at_dx`, `age_at_dx_accuracy`, `participant_id`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'mother', 'maternal', 'C504', '', '', NULL, '', 1, 1, 1, '2010-05-28 14:28:12');

--
-- Dumping data for table `key_increments`
--

INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('NoLaboCounter', 1347);

--
-- Dumping data for table `lab_book_masters`
--

INSERT INTO `lab_book_masters` (`id`, `lab_book_control_id`, `code`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 2, 'S-1345', '', '2011-03-18 15:31:37', 1, '2011-03-18 15:50:57', 1, 0),
(2, 1, 'd79', '', '2011-03-18 17:05:53', 1, '2011-03-18 17:08:35', 1, 0);

--
-- Dumping data for table `lab_book_masters_revs`
--

INSERT INTO `lab_book_masters_revs` (`id`, `lab_book_control_id`, `code`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 2, 'S-1345', '', 1, 1, '2011-03-18 15:31:37'),
(1, 2, 'S-1345', '', 1, 2, '2011-03-18 15:37:37'),
(1, 2, 'S-1345', '', 1, 3, '2011-03-18 15:50:57'),
(2, 1, 'd79', '', 1, 4, '2011-03-18 17:05:53'),
(2, 1, 'd79', '', 1, 5, '2011-03-18 17:08:35');

--
-- Dumping data for table `lbd_dna_extractions`
--

INSERT INTO `lbd_dna_extractions` (`id`, `lab_book_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `creation_datetime_accuracy`, `sop_master_id`, `deleted`) VALUES
(35, 2, 'laboratory site 2', 'laboratory staff 2', '2011-03-19 07:11:00', '', NULL, 0);

--
-- Dumping data for table `lbd_dna_extractions_revs`
--

INSERT INTO `lbd_dna_extractions_revs` (`id`, `lab_book_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `sop_master_id`, `version_id`, `version_created`) VALUES
(35, 2, 'laboratory site 2', 'laboratory staff 2', '2011-02-02 07:11:00', NULL, 84, '2011-03-18 17:05:53'),
(35, 2, 'laboratory site 2', 'laboratory staff 2', '2011-03-19 07:11:00', NULL, 85, '2011-03-18 17:08:36');

--
-- Dumping data for table `lbd_slide_creations`
--

INSERT INTO `lbd_slide_creations` (`id`, `lab_book_master_id`, `realiquoting_datetime`, `realiquoting_datetime_accuracy`, `realiquoted_by`, `blade_temperature`, `duration_mn`, `sections_nbr`, `deleted`) VALUES
(35, 1, '2011-03-18 16:16:00', '', 'laboratory staff 1', -17.00000, 30, 4, 0);

--
-- Dumping data for table `lbd_slide_creations_revs`
--

INSERT INTO `lbd_slide_creations_revs` (`id`, `lab_book_master_id`, `realiquoting_datetime`, `realiquoted_by`, `blade_temperature`, `duration_mn`, `sections_nbr`, `version_id`, `version_created`) VALUES
(35, 1, '2011-03-18 10:09:00', 'laboratory staff 1', -17.00000, 30, 4, 84, '2011-03-18 15:31:37'),
(35, 1, '2011-03-18 16:09:00', 'laboratory staff 1', -17.00000, 30, 4, 85, '2011-03-18 15:37:37'),
(35, 1, '2011-03-18 16:16:00', 'laboratory staff 1', -17.00000, 30, 4, 86, '2011-03-18 15:50:57');


--
-- Dumping data for table `misc_identifiers`
--

INSERT INTO `misc_identifiers` (`id`, `identifier_value`, `misc_identifier_control_id`, `effective_date`, `effective_date_accuracy`, `expiry_date`, `expiry_date_accuracy`, `notes`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(5, 'xxxxxxx', 1, '0000-00-00', '', '0000-00-00', '', '', 2, '2010-12-02 18:17:55', 1, '2010-12-02 18:17:55', 1, 0),
(6, 'No-Labo-1345', 3, NULL, '', NULL, '', NULL, 2, '2010-12-02 18:18:02', 1, '2010-12-02 18:18:02', 1, 0),
(7, 'xxxxxxxx', 2, '0000-00-00', '', '0000-00-00', '', '', 2, '2010-12-02 18:18:28', 1, '2010-12-02 18:18:28', 1, 0),
(8, 'No-Labo-1346', 3, NULL, '', NULL, '', NULL, 1, '2010-12-02 18:18:52', 1, '2010-12-02 18:18:52', 1, 0);

--
-- Dumping data for table `misc_identifiers_revs`
--

INSERT INTO `misc_identifiers_revs` (`id`, `identifier_value`, `misc_identifier_control_id`, `effective_date`, `expiry_date`, `notes`, `participant_id`, `modified_by`, `version_id`, `version_created`) VALUES
(5, 'xxxxxxx', 1, '0000-00-00', '0000-00-00', '', 2, 1, 6, '2010-12-02 18:17:55'),
(6, 'No-Labo-1345', 3, NULL, NULL, NULL, 2, 1, 7, '2010-12-02 18:18:02'),
(7, 'xxxxxxxx', 2, '0000-00-00', '0000-00-00', '', 2, 1, 8, '2010-12-02 18:18:28'),
(8, 'No-Labo-1346', 3, NULL, NULL, NULL, 1, 1, 9, '2010-12-02 18:18:52');

--
-- Dumping data for table `misc_identifier_controls`
--

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`, `flag_confidential`) VALUES
(1, 'health insurance card', '#HIC', 1, 0, '', '', 1, 1),
(2, 'hospital nbr', '#HN', 1, 1, '', '', 0, 1),
(3, 'ovary bank no lab', '#Labo', 1, 3, 'NoLaboCounter', 'No-Labo-%%key_increment%%', 1, 1);

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `short_title`, `description`, `date_order_placed`, `date_order_placed_accuracy`, `date_order_completed`, `date_order_completed_accuracy`, `processing_status`, `comments`, `created`, `created_by`, `modified`, `modified_by`, `default_study_summary_id`, `deleted`) VALUES
(1, 'CD09848', '', '', '2010-06-01', '', NULL, '', 'pending', '', '2010-05-28 16:29:37', 1, '2010-05-28 16:29:37', 1, 1, 0),
(2, '67 LP 008', '', '', NULL, '', NULL, '', 'pending', '', '2011-03-18 17:42:52', 1, '2011-03-18 17:44:09', 1, NULL, 0);

--
-- Dumping data for table `orders_revs`
--

INSERT INTO `orders_revs` (`id`, `order_number`, `short_title`, `description`, `date_order_placed`, `date_order_completed`, `processing_status`, `comments`, `modified_by`, `default_study_summary_id`, `version_id`, `version_created`) VALUES
(1, 'CD09848', '', '', '2010-06-01', NULL, 'pending', '', 1, 1, 1, '2010-05-28 16:29:37'),
(2, '67 LP 008', '', '', NULL, NULL, 'completed', '', 1, NULL, 2, '2011-03-18 17:42:52'),
(2, '67 LP 008', '', '', NULL, NULL, 'pending', '', 1, NULL, 3, '2011-03-18 17:44:09');

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `date_added`, `date_added_accuracy`, `added_by`, `status`, `created`, `created_by`, `modified`, `modified_by`, `order_line_id`, `shipment_id`, `aliquot_master_id`, `deleted`) VALUES
(1, '2010-05-29', '', 'laboratory staff 2', 'shipped', '2010-05-28 16:31:11', 1, '2010-05-28 16:33:47', 1, 1, 1, 10, 0),
(2, '2010-05-29', '', 'laboratory staff 2', 'pending', '2010-05-28 16:32:06', 1, '2010-05-28 16:32:28', 1, 1, NULL, 11, 0),
(3, '2011-05-04', '', 'laboratory staff 1', 'shipped', '2011-03-18 17:44:21', 1, '2011-03-18 17:45:26', 1, 3, 2, 50, 0);

--
-- Dumping data for table `order_items_revs`
--

INSERT INTO `order_items_revs` (`id`, `date_added`, `added_by`, `status`, `modified_by`, `order_line_id`, `shipment_id`, `aliquot_master_id`, `version_id`, `version_created`) VALUES
(1, '2010-05-29', 'laboratory staff 2', 'pending', 1, 1, NULL, 10, 1, '2010-05-28 16:31:11'),
(2, NULL, '', 'pending', 1, 1, NULL, 11, 2, '2010-05-28 16:32:06'),
(1, '2010-05-29', 'laboratory staff 2', 'pending', 1, 1, NULL, 10, 3, '2010-05-28 16:32:28'),
(2, '2010-05-29', 'laboratory staff 2', 'pending', 1, 1, NULL, 11, 4, '2010-05-28 16:32:28'),
(1, '2010-05-29', 'laboratory staff 2', 'shipped', 1, 1, 1, 10, 5, '2010-05-28 16:33:47'),
(3, '2011-05-04', 'laboratory staff 1', 'pending', 1, 3, NULL, 50, 6, '2011-03-18 17:44:21'),
(3, '2011-05-04', 'laboratory staff 1', 'shipped', 1, 3, 2, 50, 7, '2011-03-18 17:45:26');

--
-- Dumping data for table `order_lines`
--

INSERT INTO `order_lines` (`id`, `quantity_ordered`, `min_quantity_ordered`, `quantity_unit`, `date_required`, `date_required_accuracy`, `status`, `created`, `created_by`, `modified`, `modified_by`, `product_code`, `sample_control_id`, `aliquot_control_id`, `sample_aliquot_precision`, `order_id`, `study_summary_id`, `deleted`) VALUES
(1, '23', '', 'ml', NULL, '', 'pending', '2010-05-28 16:30:23', 1, '2010-05-28 16:32:06', 1, '', 12, 29, 'PBMC', 1, 1, 0),
(2, '3', '', 'ml', NULL, '', 'pending', '2010-05-28 16:30:42', 1, '2010-05-28 16:30:42', 1, '', 119, 27, '', 1, 1, 0),
(3, '', '', '', NULL, '', 'shipped', '2011-03-18 17:43:14', 1, '2011-03-18 17:45:26', 1, '', 13, NULL, '', 2, NULL, 0);

--
-- Dumping data for table `order_lines_revs`
--

INSERT INTO `order_lines_revs` (`id`, `quantity_ordered`, `min_quantity_ordered`, `quantity_unit`, `date_required`, `status`, `modified_by`, `product_code`, `sample_control_id`, `aliquot_control_id`, `sample_aliquot_precision`, `order_id`, `study_summary_id`, `version_id`, `version_created`) VALUES
(1, '23', '', 'ml', NULL, 'pending', 1, '', 12, 29, 'PBMC', 1, NULL, 1, '2010-05-28 16:30:23'),
(2, '3', '', 'ml', NULL, 'pending', 1, '', 119, 27, '', 1, 1, 2, '2010-05-28 16:30:42'),
(1, '23', '', 'ml', NULL, 'pending', 1, '', 12, 29, 'PBMC', 1, NULL, 3, '2010-05-28 16:31:13'),
(1, '23', '', 'ml', NULL, 'pending', 1, '', 12, 29, 'PBMC', 1, 1, 4, '2010-05-28 16:32:06'),
(3, '', '', '', NULL, 'pending', 1, '', 13, NULL, '', 2, NULL, 5, '2011-03-18 17:43:14'),
(3, '', '', '', NULL, 'pending', 1, '', 13, NULL, '', 2, NULL, 6, '2011-03-18 17:44:22'),
(3, '', '', '', NULL, 'shipped', 1, '', 13, NULL, '', 2, NULL, 7, '2011-03-18 17:45:26');


--
-- Dumping data for table `participants`
--

INSERT INTO `participants` (`id`, `title`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `date_of_birth_accuracy`, `marital_status`, `language_preferred`, `sex`, `race`, `vital_status`, `notes`, `date_of_death`, `date_of_death_accuracy`, `cod_icd10_code`, `secondary_cod_icd10_code`, `cod_confirmation_source`, `participant_identifier`, `last_chart_checked_date`, `last_chart_checked_date_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'Ms.', 'Wonder', '', 'Woman', '1947-11-03', 'm', '', '', 'f', '', 'deceased', '', '2008-03-06', 'd', 'C002', NULL, '', 'wwi80', '2010-05-05', '', '2010-05-28 13:59:42', 1, '2010-05-28 14:31:50', 1, 0),
(2, 'Ms.', 'Ryana', 'Blue', '', '1926-06-10', '', '', '', 'f', '', 'alive', '', NULL, '', NULL, NULL, '', 'RRd784', NULL, '', '2010-09-24 19:30:37', 1, '2010-09-24 19:30:37', 1, 0),
(3, 'Ms.', 'Lady', '', 'Green', '1920-12-15', '', '', '', 'f', '', 'deceased', '', NULL, '', NULL, NULL, '', 'qq4213', NULL, '', '2010-09-24 19:40:11', 1, '2010-09-24 19:40:11', 1, 0);

--
-- Dumping data for table `participants_revs`
--

INSERT INTO `participants_revs` (`id`, `title`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `date_of_birth_accuracy`, `marital_status`, `language_preferred`, `sex`, `race`, `vital_status`, `notes`, `date_of_death`, `date_of_death_accuracy`, `cod_icd10_code`, `secondary_cod_icd10_code`, `cod_confirmation_source`, `participant_identifier`, `last_chart_checked_date`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 'Ms.', 'Wonder', 'Woman', '', '1947-11-03', 'm', '', '', 'f', '', 'deceased', '', '2008-03-06', 'd', 'C002', NULL, '', 'wwi80', '2010-05-05', 1, 1, '2010-05-28 13:59:42'),
(1, 'Ms.', 'Wonder', '', 'Woman', '1947-11-03', 'm', '', '', 'f', '', 'deceased', '', '2008-03-06', 'd', 'C002', NULL, '', 'wwi80', '2010-05-05', 1, 2, '2010-05-28 14:31:50'),
(2, 'Ms.', 'Ryana', 'Blue', '', '1926-06-10', '', '', '', 'f', '', 'alive', '', NULL, '', NULL, NULL, '', 'RRd784', NULL, 1, 3, '2010-09-24 19:30:37'),
(3, 'Ms.', 'Lady', '', 'Green', '1920-12-15', '', '', '', 'f', '', 'deceased', '', NULL, '', NULL, NULL, '', 'qq4213', NULL, 1, 4, '2010-09-24 19:40:11');

--
-- Dumping data for table `participant_contacts`
--

INSERT INTO `participant_contacts` (`id`, `contact_name`, `contact_type`, `other_contact_type`, `effective_date`, `effective_date_accuracy`, `expiry_date`, `expiry_date_accuracy`, `notes`, `street`, `locality`, `region`, `country`, `mail_code`, `phone`, `phone_type`, `phone_secondary`, `phone_secondary_type`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`, `deleted`) VALUES
(1, '', 'home', '', NULL, '', NULL, '', '', 'wall street', 'NY', '', '', '', '200 099 0879', 'residential', '', '', '2010-05-28 14:30:23', 1, '2010-05-28 14:30:23', 1, 1, 0);

--
-- Dumping data for table `participant_contacts_revs`
--

INSERT INTO `participant_contacts_revs` (`id`, `contact_name`, `contact_type`, `other_contact_type`, `effective_date`, `expiry_date`, `notes`, `street`, `locality`, `region`, `country`, `mail_code`, `phone`, `phone_type`, `phone_secondary`, `phone_secondary_type`, `modified_by`, `participant_id`, `version_id`, `version_created`) VALUES
(1, '', 'home', '', NULL, NULL, '', 'wall street', 'NY', '', '', '', '200 099 0879', 'residential', '', '', 1, 1, 1, '2010-05-28 14:30:23');

--
-- Dumping data for table `pd_chemos`
--

INSERT INTO `pd_chemos` (`id`, `protocol_master_id`, `deleted`) VALUES
(1, 1, 0);

--
-- Dumping data for table `pd_chemos_revs`
--

INSERT INTO `pd_chemos_revs` (`id`, `protocol_master_id`, `version_id`, `version_created`) VALUES
(1, 1, 1, '2010-05-28 11:25:19');

--
-- Dumping data for table `pe_chemos`
--

INSERT INTO `pe_chemos` (`id`, `method`, `dose`, `frequency`, `created`, `created_by`, `modified`, `modified_by`, `protocol_master_id`, `drug_id`, `deleted`) VALUES
(1, 'IV: Intravenous', '34', '2', '2010-05-28 11:27:45', 1, '2010-05-28 11:27:45', 1, 1, 1, 0),
(2, 'IV: Intravenous', '', '', '2010-05-28 11:28:04', 1, '2010-05-28 11:28:04', 1, 1, 3, 0);

--
-- Dumping data for table `protocol_masters`
--

INSERT INTO `protocol_masters` (`id`, `protocol_control_id`, `name`, `notes`, `code`, `arm`, `tumour_group`, `type`, `status`, `expiry`, `expiry_accuracy`, `activated`, `activated_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `deleted`) VALUES
(1, 1, 'Watson th', '', 'Prot-4577', '1', 'all', 'chemotherapy', NULL, NULL, '', NULL, '', '2010-05-28 11:25:19', 1, '2010-05-28 11:25:19', 1, NULL, 0);

--
-- Dumping data for table `protocol_masters_revs`
--

INSERT INTO `protocol_masters_revs` (`id`, `protocol_control_id`, `name`, `notes`, `code`, `arm`, `tumour_group`, `type`, `status`, `expiry`, `activated`, `modified_by`, `form_id`, `version_id`, `version_created`) VALUES
(1, 1, 'Watson th', '', 'Prot-4577', '1', 'all', 'chemotherapy', NULL, NULL, NULL, 1, NULL, 1, '2010-05-28 11:25:19');

--
-- Dumping data for table `quality_ctrls`
--

INSERT INTO `quality_ctrls` (`id`, `qc_code`, `sample_master_id`, `type`, `qc_type_precision`, `tool`, `run_id`, `run_by`, `date`, `date_accuracy`, `score`, `unit`, `conclusion`, `notes`, `aliquot_master_id`, `used_volume`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'QC - 1', 5, 'bioanalyzer', NULL, '', '#1245', 'laboratory staff etc', '2009-11-04', '', '13', 'RIN', 'acceptable', '', 28, 11.00000, '2010-09-24 19:28:34', 1, '2011-07-08 13:49:06', 1, 0),
(2, 'QC - 2', 6, 'bioanalyzer', NULL, '', '6885', 'laboratory staff 2', '2006-09-14', '', '', '', 'very good', '', NULL, NULL, '2010-09-24 19:38:53', 1, '2010-09-24 19:38:53', 1, 0),
(3, 'QC - 3', 10, 'spectrophotometer', NULL, '', '332e', 'laboratory staff 2', NULL, '', '', '', 'very good', '', NULL, NULL, '2010-09-24 19:45:49', 1, '2010-09-24 19:45:49', 1, 0),
(4, 'QC - 4', 13, 'bioanalyzer', '', '', 'qc52', 'laboratory staff 1', '2011-05-04', '', '32', 'RIN', 'good', '', 48, 2.70000, '2011-03-18 17:36:59', 1, '2011-07-08 13:49:06', 1, 0);

--
-- Dumping data for table `quality_ctrls_revs`
--

INSERT INTO `quality_ctrls_revs` (`id`, `qc_code`, `sample_master_id`, `type`, `qc_type_precision`, `tool`, `run_id`, `run_by`, `date`, `score`, `unit`, `conclusion`, `notes`, `aliquot_master_id`, `used_volume`, `modified_by`, `version_id`, `version_created`) VALUES
(1, NULL, 5, 'bioanalyzer', NULL, '', '#1245', 'laboratory staff etc', '2009-11-04', '13', 'RIN', 'acceptable', '', NULL, NULL, 1, 1, '2010-09-24 19:28:34'),
(1, 'QC - 1', 5, 'bioanalyzer', NULL, '', '#1245', 'laboratory staff etc', '2009-11-04', '13', 'RIN', 'acceptable', '', NULL, NULL, 1, 2, '2010-09-24 19:28:34'),
(2, NULL, 6, 'bioanalyzer', NULL, '', '6885', 'laboratory staff 2', '2006-09-14', '', '', 'very good', '', NULL, NULL, 1, 3, '2010-09-24 19:38:53'),
(2, 'QC - 2', 6, 'bioanalyzer', NULL, '', '6885', 'laboratory staff 2', '2006-09-14', '', '', 'very good', '', NULL, NULL, 1, 4, '2010-09-24 19:38:53'),
(3, NULL, 10, 'spectrophotometer', NULL, '', '332e', 'laboratory staff 2', NULL, '', '', 'very good', '', NULL, NULL, 1, 5, '2010-09-24 19:45:49'),
(3, 'QC - 3', 10, 'spectrophotometer', NULL, '', '332e', 'laboratory staff 2', NULL, '', '', 'very good', '', NULL, NULL, 1, 6, '2010-09-24 19:45:49'),
(4, NULL, 13, 'bioanalyzer', '', '', 'qc52', 'laboratory staff 1', '2011-05-04', '32', 'RIN', 'good', '', NULL, NULL, 1, 7, '2011-03-18 17:36:59'),
(4, 'QC - 4', 13, 'bioanalyzer', '', '', 'qc52', 'laboratory staff 1', '2011-05-04', '32', 'RIN', 'good', '', NULL, NULL, 1, 8, '2011-03-18 17:36:59'),
(1, 'QC - 1', 5, 'bioanalyzer', NULL, '', '#1245', 'laboratory staff etc', '2009-11-04', '13', 'RIN', 'acceptable', '', 28, 11.00000, 1, 9, '2011-07-08 13:49:06'),
(4, 'QC - 4', 13, 'bioanalyzer', '', '', 'qc52', 'laboratory staff 1', '2011-05-04', '32', 'RIN', 'good', '', 48, 2.70000, 1, 10, '2011-07-08 13:49:06'),
(1, NULL, 5, 'bioanalyzer', NULL, '', '#1245', 'laboratory staff etc', '2009-11-04', '13', 'RIN', 'acceptable', '', 28, NULL, 1, 12, '2010-09-24 19:28:54'),
(1, 'QC - 1', 5, 'bioanalyzer', NULL, '', '#1245', 'laboratory staff etc', '2009-11-04', '13', 'RIN', 'acceptable', '', 28, NULL, 1, 13, '2010-09-24 19:28:54'),
(4, NULL, 13, 'bioanalyzer', '', '', 'qc52', 'laboratory staff 1', '2011-05-04', '32', 'RIN', 'good', '', 48, 2.70000, 1, 14, '2011-03-18 17:37:38'),
(4, 'QC - 4', 13, 'bioanalyzer', '', '', 'qc52', 'laboratory staff 1', '2011-05-04', '32', 'RIN', 'good', '', 48, 2.70000, 1, 15, '2011-03-18 17:37:38');

--
-- Dumping data for table `realiquotings`
--

INSERT INTO `realiquotings` (`id`, `parent_aliquot_master_id`, `child_aliquot_master_id`, `parent_used_volume`, `realiquoting_datetime`, `realiquoting_datetime_accuracy`, `realiquoted_by`, `lab_book_master_id`, `sync_with_lab_book`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 3, 2, 1.00000, '2003-04-23 13:35:00', '', 'laboratory staff 1', NULL, 0, '2010-05-28 16:04:30', 1, '2010-05-28 16:04:30', 1, 0),
(2, 3, 4, 3.40000, '2003-04-23 13:35:00', '', '', NULL, 0, '2010-05-28 16:04:30', 1, '2010-05-28 16:04:30', 1, 0),
(3, 25, 27, 1.00000, '2009-08-04 00:00:00', '', 'laboratory staff 2', NULL, 0, '2010-09-24 19:27:45', 1, '2010-09-24 19:27:45', 1, 0),
(4, 25, 28, 1.00000, '2009-08-04 00:00:00', '', 'laboratory staff 2', NULL, 0, '2010-09-24 19:27:45', 1, '2010-09-24 19:27:45', 1, 0),
(5, 36, 37, NULL, '2011-02-10 21:28:00', '', '', NULL, 0, '2011-02-10 21:29:08', 1, '2011-02-10 21:29:08', 1, 0),
(6, 36, 38, NULL, '2011-02-10 21:28:00', '', '', NULL, 0, '2011-02-10 21:29:09', 1, '2011-02-10 21:29:09', 1, 0),
(7, 36, 39, NULL, '2011-02-10 21:28:00', '', '', NULL, 0, '2011-02-10 21:29:09', 1, '2011-02-10 21:29:09', 1, 0),
(8, 36, 40, NULL, '2011-03-18 13:00:00', '', 'laboratory staff 1', NULL, NULL, '2011-03-18 15:34:34', 1, '2011-03-18 15:34:34', 1, 0),
(9, 36, 41, NULL, '2011-03-18 13:00:00', '', 'laboratory staff 1', NULL, NULL, '2011-03-18 15:34:34', 1, '2011-03-18 15:34:34', 1, 0),
(10, 41, 42, NULL, '2011-03-18 16:16:00', '', 'laboratory staff 1', 1, 1, '2011-03-18 15:39:55', 1, '2011-03-18 15:50:57', 1, 0),
(11, 41, 43, NULL, '2011-03-18 16:16:00', '', 'laboratory staff 1', 1, 1, '2011-03-18 15:39:55', 1, '2011-03-18 15:50:58', 1, 0),
(12, 44, 45, NULL, '2011-03-18 16:16:00', '', 'laboratory staff 1', 1, 1, '2011-03-18 15:49:54', 1, '2011-03-18 15:50:58', 1, 0),
(13, 44, 46, NULL, '2011-03-18 16:16:00', '', 'laboratory staff 1', 1, 1, '2011-03-18 15:49:55', 1, '2011-03-18 15:50:58', 1, 0),
(14, 48, 50, 3.40000, '2011-05-03 17:31:00', '', 'laboratory staff 1', NULL, NULL, '2011-03-18 17:33:51', 1, '2011-03-18 17:33:51', 1, 0),
(15, 48, 51, 3.60000, '2011-05-03 17:31:00', '', 'laboratory staff 1', NULL, NULL, '2011-03-18 17:33:52', 1, '2011-03-18 17:33:52', 1, 0),
(16, 44, 52, NULL, '2011-06-18 17:52:00', '', '', NULL, NULL, '2011-03-18 17:53:10', 1, '2011-03-18 17:53:10', 1, 0),
(17, 41, 53, NULL, '2011-05-18 17:53:00', '', '', NULL, NULL, '2011-03-18 17:54:00', 1, '2011-03-18 17:54:00', 1, 0);

--
-- Dumping data for table `realiquotings_revs`
--

INSERT INTO `realiquotings_revs` (`id`, `parent_aliquot_master_id`, `child_aliquot_master_id`, `parent_used_volume`, `realiquoting_datetime`, `realiquoted_by`, `lab_book_master_id`, `sync_with_lab_book`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 3, 2, NULL, NULL, NULL, NULL, 0, 1, 1, '2010-05-28 16:04:30'),
(2, 3, 4, NULL, NULL, NULL, NULL, 0, 1, 2, '2010-05-28 16:04:30'),
(3, 25, 27, NULL, NULL, NULL, NULL, 0, 1, 3, '2010-09-24 19:27:45'),
(4, 25, 28, NULL, NULL, NULL, NULL, 0, 1, 4, '2010-09-24 19:27:45'),
(5, 36, 37, NULL, NULL, NULL, NULL, 0, 1, 5, '2011-02-10 21:29:08'),
(6, 36, 38, NULL, NULL, NULL, NULL, 0, 1, 6, '2011-02-10 21:29:09'),
(7, 36, 39, NULL, NULL, NULL, NULL, 0, 1, 7, '2011-02-10 21:29:09'),
(8, 36, 40, NULL, '2011-03-18 13:00:00', 'laboratory staff 1', NULL, NULL, 1, 8, '2011-03-18 15:34:34'),
(9, 36, 41, NULL, '2011-03-18 13:00:00', 'laboratory staff 1', NULL, NULL, 1, 9, '2011-03-18 15:34:34'),
(10, 41, 42, NULL, '2011-03-18 16:09:00', 'laboratory staff 1', 1, 1, 1, 10, '2011-03-18 15:39:55'),
(11, 41, 43, NULL, '2011-03-18 16:09:00', 'laboratory staff 1', 1, 1, 1, 11, '2011-03-18 15:39:55'),
(12, 44, 45, NULL, '2011-03-18 16:09:00', 'laboratory staff 1', 1, 1, 1, 12, '2011-03-18 15:49:54'),
(13, 44, 46, NULL, '2011-03-18 16:09:00', 'laboratory staff 1', 1, 1, 1, 13, '2011-03-18 15:49:55'),
(10, 41, 42, NULL, '2011-03-18 16:16:00', 'laboratory staff 1', 1, 1, 1, 14, '2011-03-18 15:50:57'),
(11, 41, 43, NULL, '2011-03-18 16:16:00', 'laboratory staff 1', 1, 1, 1, 15, '2011-03-18 15:50:58'),
(12, 44, 45, NULL, '2011-03-18 16:16:00', 'laboratory staff 1', 1, 1, 1, 16, '2011-03-18 15:50:58'),
(13, 44, 46, NULL, '2011-03-18 16:16:00', 'laboratory staff 1', 1, 1, 1, 17, '2011-03-18 15:50:58'),
(14, 48, 50, 3.40000, '2011-05-03 17:31:00', 'laboratory staff 1', NULL, NULL, 1, 18, '2011-03-18 17:33:51'),
(15, 48, 51, 3.60000, '2011-05-03 17:31:00', 'laboratory staff 1', NULL, NULL, 1, 19, '2011-03-18 17:33:52'),
(16, 44, 52, NULL, '2011-06-18 17:52:00', '', NULL, NULL, 1, 20, '2011-03-18 17:53:10'),
(17, 41, 53, NULL, '2011-05-18 17:53:00', '', NULL, NULL, 1, 21, '2011-03-18 17:54:00');

--
-- Dumping data for table `sample_masters`
--

INSERT INTO `sample_masters` (`id`, `sample_code`, `sample_category`, `sample_control_id`, `sample_type`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `parent_sample_type`, `sop_master_id`, `product_code`, `is_problematic`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'B - 1', 'specimen', 2, 'blood', 1, 'blood', 1, NULL, NULL, NULL, NULL, '', '', '2010-05-28 15:58:56', 1, '2010-05-28 15:59:43', 1, 0),
(2, 'PBMC - 2', 'derivative', 8, 'pbmc', 1, 'blood', 1, 1, 'blood', NULL, NULL, '', '', '2010-05-28 16:18:12', 1, '2010-05-28 16:18:55', 1, 0),
(3, 'DNA - 3', 'derivative', 12, 'dna', 1, 'blood', 1, 2, 'pbmc', NULL, NULL, '', '', '2010-05-28 16:24:52', 1, '2010-05-28 16:24:53', 1, 0),
(4, 'B - 4', 'specimen', 2, 'blood', 4, 'blood', 2, NULL, NULL, NULL, NULL, '', '', '2010-09-24 19:19:32', 1, '2010-09-24 19:19:33', 1, 0),
(5, 'DNA - 5', 'derivative', 12, 'dna', 4, 'blood', 2, 4, 'blood', NULL, NULL, '', '', '2010-09-24 19:22:49', 1, '2010-09-24 19:22:49', 1, 0),
(6, 'T - 6', 'specimen', 3, 'tissue', 6, 'tissue', 3, NULL, NULL, NULL, NULL, '', '', '2010-09-24 19:33:55', 1, '2010-09-24 19:33:56', 1, 0),
(7, 'DNA - 7', 'derivative', 12, 'dna', 6, 'tissue', 3, 6, 'tissue', 1, NULL, '', '', '2010-09-24 19:35:15', 1, '2010-09-24 19:35:15', 1, 0),
(8, 'B - 8', 'specimen', 2, 'blood', 8, 'blood', 4, NULL, NULL, NULL, NULL, '', '', '2010-09-24 19:42:55', 1, '2010-09-24 19:43:11', 1, 0),
(9, 'PBMC - 9', 'derivative', 8, 'pbmc', 8, 'blood', 4, 8, 'blood', NULL, NULL, '', '', '2010-09-24 19:43:34', 1, '2010-09-24 19:43:34', 1, 0),
(10, 'DNA - 10', 'derivative', 12, 'dna', 8, 'blood', 4, 9, 'pbmc', NULL, NULL, '', '', '2010-09-24 19:43:46', 1, '2010-09-24 19:43:47', 1, 0),
(11, 'T - 11', 'specimen', 3, 'tissue', 11, 'tissue', 2, NULL, NULL, NULL, NULL, 'y', '', '2011-03-18 15:45:06', 1, '2011-03-18 15:45:06', 1, 0),
(12, 'DNA - 12', 'derivative', 12, 'dna', 6, 'tissue', 3, 6, 'tissue', NULL, NULL, 'y', '', '2011-03-18 17:07:58', 1, '2011-03-18 17:09:53', 1, 0),
(13, 'RNA - 13', 'derivative', 13, 'rna', 6, 'tissue', 3, 6, 'tissue', NULL, NULL, 'y', '', '2011-03-18 17:24:36', 1, '2011-03-18 17:24:37', 1, 0),
(14, 'cDNA - 14', 'derivative', 19, 'cdna', 6, 'tissue', 3, 13, 'rna', NULL, NULL, 'y', '', '2011-03-18 17:40:01', 1, '2011-03-18 17:40:02', 1, 0);

--
-- Dumping data for table `sample_masters_revs`
--

INSERT INTO `sample_masters_revs` (`id`, `sample_code`, `sample_category`, `sample_control_id`, `sample_type`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `parent_sample_type`, `sop_master_id`, `product_code`, `is_problematic`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '', 'specimen', 2, 'blood', NULL, 'blood', 1, NULL, NULL, NULL, NULL, 'n', '', 1, 1, '2010-05-28 15:58:56'),
(1, 'B - 1', 'specimen', 2, 'blood', 1, 'blood', 1, NULL, NULL, NULL, NULL, 'n', '', 1, 2, '2010-05-28 15:58:57'),
(1, 'B - 1', 'specimen', 2, 'blood', 1, 'blood', 1, NULL, NULL, NULL, NULL, 'n', '', 1, 3, '2010-05-28 15:59:43'),
(2, '', 'derivative', 8, 'pbmc', 1, 'blood', 1, 1, NULL, NULL, NULL, 'n', '', 1, 4, '2010-05-28 16:18:12'),
(2, 'PBMC - 2', 'derivative', 8, 'pbmc', 1, 'blood', 1, 1, NULL, NULL, NULL, 'n', '', 1, 5, '2010-05-28 16:18:13'),
(2, 'PBMC - 2', 'derivative', 8, 'pbmc', 1, 'blood', 1, 1, NULL, NULL, NULL, 'n', '', 1, 6, '2010-05-28 16:18:55'),
(3, '', 'derivative', 12, 'dna', 1, 'blood', 1, 2, NULL, NULL, NULL, 'n', '', 1, 7, '2010-05-28 16:24:52'),
(3, 'DNA - 3', 'derivative', 12, 'dna', 1, 'blood', 1, 2, NULL, NULL, NULL, 'n', '', 1, 8, '2010-05-28 16:24:53'),
(4, '', 'specimen', 2, 'blood', NULL, 'blood', 2, NULL, NULL, NULL, NULL, 'n', '', 1, 9, '2010-09-24 19:19:32'),
(4, 'B - 4', 'specimen', 2, 'blood', 4, 'blood', 2, NULL, NULL, NULL, NULL, 'n', '', 1, 10, '2010-09-24 19:19:33'),
(5, '', 'derivative', 12, 'dna', 4, 'blood', 2, 4, NULL, NULL, NULL, 'n', '', 1, 11, '2010-09-24 19:22:49'),
(5, 'DNA - 5', 'derivative', 12, 'dna', 4, 'blood', 2, 4, NULL, NULL, NULL, 'n', '', 1, 12, '2010-09-24 19:22:49'),
(6, '', 'specimen', 3, 'tissue', NULL, 'tissue', 3, NULL, NULL, NULL, NULL, 'n', '', 1, 13, '2010-09-24 19:33:55'),
(6, 'T - 6', 'specimen', 3, 'tissue', 6, 'tissue', 3, NULL, NULL, NULL, NULL, 'n', '', 1, 14, '2010-09-24 19:33:56'),
(7, '', 'derivative', 12, 'dna', 6, 'tissue', 3, 6, NULL, 1, NULL, 'n', '', 1, 15, '2010-09-24 19:35:15'),
(7, 'DNA - 7', 'derivative', 12, 'dna', 6, 'tissue', 3, 6, NULL, 1, NULL, 'n', '', 1, 16, '2010-09-24 19:35:15'),
(8, '', 'specimen', 2, 'blood', NULL, 'blood', 4, NULL, NULL, NULL, NULL, 'n', '', 1, 17, '2010-09-24 19:42:55'),
(8, 'B - 8', 'specimen', 2, 'blood', 8, 'blood', 4, NULL, NULL, NULL, NULL, 'n', '', 1, 18, '2010-09-24 19:42:55'),
(8, 'B - 8', 'specimen', 2, 'blood', 8, 'blood', 4, NULL, NULL, NULL, NULL, 'n', '', 1, 19, '2010-09-24 19:43:11'),
(9, '', 'derivative', 8, 'pbmc', 8, 'blood', 4, 8, NULL, NULL, NULL, 'n', '', 1, 20, '2010-09-24 19:43:34'),
(9, 'PBMC - 9', 'derivative', 8, 'pbmc', 8, 'blood', 4, 8, NULL, NULL, NULL, 'n', '', 1, 21, '2010-09-24 19:43:34'),
(10, '', 'derivative', 12, 'dna', 8, 'blood', 4, 9, NULL, NULL, NULL, 'n', '', 1, 22, '2010-09-24 19:43:46'),
(10, 'DNA - 10', 'derivative', 12, 'dna', 8, 'blood', 4, 9, NULL, NULL, NULL, 'n', '', 1, 23, '2010-09-24 19:43:47'),
(11, '', 'specimen', 3, 'tissue', NULL, 'tissue', 2, NULL, NULL, NULL, NULL, 'y', '', 1, 24, '2011-03-18 15:45:06'),
(11, 'T - 11', 'specimen', 3, 'tissue', 11, 'tissue', 2, NULL, NULL, NULL, NULL, 'y', '', 1, 25, '2011-03-18 15:45:06'),
(12, '', 'derivative', 12, 'dna', 6, 'tissue', 3, 6, NULL, NULL, NULL, 'y', '', 1, 26, '2011-03-18 17:07:58'),
(12, 'DNA - 12', 'derivative', 12, 'dna', 6, 'tissue', 3, 6, NULL, NULL, NULL, 'y', '', 1, 27, '2011-03-18 17:07:59'),
(12, 'DNA - 12', 'derivative', 12, 'dna', 6, 'tissue', 3, 6, NULL, NULL, NULL, 'y', '', 1, 28, '2011-03-18 17:08:36'),
(12, 'DNA - 12', 'derivative', 12, 'dna', 6, 'tissue', 3, 6, NULL, NULL, NULL, 'y', '', 1, 29, '2011-03-18 17:09:53'),
(13, '', 'derivative', 13, 'rna', 6, 'tissue', 3, 6, NULL, NULL, NULL, 'y', '', 1, 30, '2011-03-18 17:24:36'),
(13, 'RNA - 13', 'derivative', 13, 'rna', 6, 'tissue', 3, 6, NULL, NULL, NULL, 'y', '', 1, 31, '2011-03-18 17:24:37'),
(14, '', 'derivative', 19, 'cdna', 6, 'tissue', 3, 13, NULL, NULL, NULL, 'y', '', 1, 32, '2011-03-18 17:40:01'),
(14, 'cDNA - 14', 'derivative', 19, 'cdna', 6, 'tissue', 3, 13, NULL, NULL, NULL, 'y', '', 1, 33, '2011-03-18 17:40:02');

--
-- Dumping data for table `sd_der_cdnas`
--

INSERT INTO `sd_der_cdnas` (`id`, `sample_master_id`, `deleted`) VALUES
(1, 14, 0);

--
-- Dumping data for table `sd_der_cdnas_revs`
--

INSERT INTO `sd_der_cdnas_revs` (`id`, `sample_master_id`, `version_id`, `version_created`) VALUES
(1, 14, 1, '2011-03-18 17:40:02');

--
-- Dumping data for table `sd_der_dnas`
--

INSERT INTO `sd_der_dnas` (`id`, `sample_master_id`, `deleted`) VALUES
(1, 3, 0),
(2, 5, 0),
(3, 7, 0),
(4, 10, 0),
(5, 12, 0);

--
-- Dumping data for table `sd_der_dnas_revs`
--

INSERT INTO `sd_der_dnas_revs` (`id`, `sample_master_id`, `version_id`, `version_created`) VALUES
(1, 3, 1, '2010-05-28 16:24:52'),
(1, 3, 2, '2010-05-28 16:24:54'),
(2, 5, 3, '2010-09-24 19:22:49'),
(3, 7, 4, '2010-09-24 19:35:15'),
(4, 10, 5, '2010-09-24 19:43:47'),
(5, 12, 6, '2011-03-18 17:07:58'),
(5, 12, 7, '2011-03-18 17:07:59'),
(5, 12, 8, '2011-03-18 17:08:36'),
(5, 12, 9, '2011-03-18 17:09:53');

--
-- Dumping data for table `sd_der_pbmcs`
--

INSERT INTO `sd_der_pbmcs` (`id`, `sample_master_id`, `deleted`) VALUES
(1, 2, 0),
(2, 9, 0);

--
-- Dumping data for table `sd_der_pbmcs_revs`
--

INSERT INTO `sd_der_pbmcs_revs` (`id`, `sample_master_id`, `version_id`, `version_created`) VALUES
(1, 2, 1, '2010-05-28 16:18:13'),
(1, 2, 2, '2010-05-28 16:18:14'),
(1, 2, 3, '2010-05-28 16:18:55'),
(2, 9, 4, '2010-09-24 19:43:34');

--
-- Dumping data for table `sd_der_rnas`
--

INSERT INTO `sd_der_rnas` (`id`, `sample_master_id`, `deleted`) VALUES
(1, 13, 0);

--
-- Dumping data for table `sd_der_rnas_revs`
--

INSERT INTO `sd_der_rnas_revs` (`id`, `sample_master_id`, `version_id`, `version_created`) VALUES
(1, 13, 1, '2011-03-18 17:24:37');

--
-- Dumping data for table `sd_spe_bloods`
--

INSERT INTO `sd_spe_bloods` (`id`, `sample_master_id`, `blood_type`, `collected_tube_nbr`, `collected_volume`, `collected_volume_unit`, `deleted`) VALUES
(1, 1, 'EDTA', 3, 12.43000, 'ml', 0),
(2, 4, 'EDTA', 3, 4.50000, 'ml', 0),
(3, 8, 'heparin', NULL, NULL, '', 0);

--
-- Dumping data for table `sd_spe_bloods_revs`
--

INSERT INTO `sd_spe_bloods_revs` (`id`, `sample_master_id`, `blood_type`, `collected_tube_nbr`, `collected_volume`, `collected_volume_unit`, `version_id`, `version_created`) VALUES
(1, 1, 'EDTA', 3, 12.43000, 'ml', 1, '2010-05-28 15:58:56'),
(1, 1, 'EDTA', 3, 12.43000, 'ml', 2, '2010-05-28 15:58:57'),
(1, 1, 'EDTA', 3, 12.43000, 'ml', 3, '2010-05-28 15:59:43'),
(2, 4, 'EDTA', 3, 4.50000, 'ml', 4, '2010-09-24 19:19:32'),
(2, 4, 'EDTA', 3, 4.50000, 'ml', 5, '2010-09-24 19:19:33'),
(3, 8, '', NULL, NULL, '', 6, '2010-09-24 19:42:55'),
(3, 8, '', NULL, NULL, '', 7, '2010-09-24 19:42:56'),
(3, 8, 'heparin', NULL, NULL, '', 8, '2010-09-24 19:43:11');

--
-- Dumping data for table `sd_spe_tissues`
--

INSERT INTO `sd_spe_tissues` (`id`, `sample_master_id`, `tissue_source`, `tissue_nature`, `tissue_laterality`, `pathology_reception_datetime`, `pathology_reception_datetime_accuracy`, `tissue_size`, `tissue_size_unit`, `tissue_weight`, `tissue_weight_unit`, `deleted`) VALUES
(1, 6, '', NULL, 'right', NULL, '', '', '', '', '', 0),
(2, 11, '', NULL, 'right', NULL, '', '1.5x1x1', 'cm', '', '', 0);

--
-- Dumping data for table `sd_spe_tissues_revs`
--

INSERT INTO `sd_spe_tissues_revs` (`id`, `sample_master_id`, `tissue_source`, `tissue_nature`, `tissue_laterality`, `pathology_reception_datetime`, `tissue_size`, `tissue_size_unit`, `tissue_weight`, `tissue_weight_unit`, `version_id`, `version_created`) VALUES
(1, 6, '', NULL, 'right', NULL, '', '', '', '', 1, '2010-09-24 19:33:56'),
(2, 11, '', NULL, 'right', NULL, '1.5x1x1', 'cm', '', '', 2, '2011-03-18 15:45:06');

--
-- Dumping data for table `shipments`
--

INSERT INTO `shipments` (`id`, `shipment_code`, `recipient`, `facility`, `delivery_street_address`, `delivery_city`, `delivery_province`, `delivery_postal_code`, `delivery_country`, `shipping_company`, `shipping_account_nbr`, `datetime_shipped`, `datetime_shipped_accuracy`, `datetime_received`, `datetime_received_accuracy`, `shipped_by`, `created`, `created_by`, `modified`, `modified_by`, `order_id`, `deleted`) VALUES
(1, 'UPS98409', 'qwerty', '', '', '', '', '', '', '', '', '2010-05-31 13:04:00', '', NULL, '', 'laboratory staff 2', '2010-05-28 16:33:18', 1, '2010-05-28 16:33:18', 1, 1, 0),
(2, 'rr1', '', '', '', '', '', '', '', '', '', '2011-05-06 00:00:00', '', NULL, '', 'laboratory staff 1', '2011-03-18 17:45:08', 1, '2011-03-18 17:45:08', 1, 2, 0);

--
-- Dumping data for table `shipments_revs`
--

INSERT INTO `shipments_revs` (`id`, `shipment_code`, `recipient`, `facility`, `delivery_street_address`, `delivery_city`, `delivery_province`, `delivery_postal_code`, `delivery_country`, `shipping_company`, `shipping_account_nbr`, `datetime_shipped`, `datetime_received`, `shipped_by`, `modified_by`, `order_id`, `version_id`, `version_created`) VALUES
(1, 'UPS98409', 'qwerty', '', '', '', '', '', '', '', '', '2010-05-31 13:04:00', NULL, 'laboratory staff 2', 1, 1, 1, '2010-05-28 16:33:18'),
(2, 'rr1', '', '', '', '', '', '', '', '', '', '2011-05-06 00:00:00', NULL, 'laboratory staff 1', 1, 2, 2, '2011-03-18 17:45:08');

--
-- Dumping data for table `sopd_general_alls`
--

INSERT INTO `sopd_general_alls` (`id`, `value`, `sop_master_id`, `deleted`) VALUES
(1, NULL, 1, 0);

--
-- Dumping data for table `sopd_general_alls_revs`
--

INSERT INTO `sopd_general_alls_revs` (`id`, `value`, `sop_master_id`, `version_id`, `version_created`) VALUES
(1, NULL, 1, 1, '2010-05-28 13:50:54');

--
-- Dumping data for table `sop_masters`
--

INSERT INTO `sop_masters` (`id`, `sop_control_id`, `title`, `notes`, `code`, `version`, `sop_group`, `type`, `status`, `expiry_date`, `expiry_date_accuracy`, `activated_date`, `activated_date_accuracy`, `scope`, `purpose`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `deleted`) VALUES
(1, 1, 'SOP4323', '', '', '', 'General', 'All', '', NULL, '', NULL, '', '', '', '2010-05-28 13:50:54', 1, '2010-05-28 13:50:54', 1, NULL, 0);

--
-- Dumping data for table `sop_masters_revs`
--

INSERT INTO `sop_masters_revs` (`id`, `sop_control_id`, `title`, `notes`, `code`, `version`, `sop_group`, `type`, `status`, `expiry_date`, `activated_date`, `scope`, `purpose`, `modified_by`, `form_id`, `version_id`, `version_created`) VALUES
(1, 1, 'SOP4323', '', '', '', 'General', 'All', '', NULL, NULL, '', '', 1, NULL, 1, '2010-05-28 13:50:54');

--
-- Dumping data for table `source_aliquots`
--

INSERT INTO `source_aliquots` (`id`, `sample_master_id`, `aliquot_master_id`, `used_volume`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 2, 1, 5.00000, '2010-05-28 16:19:42', 1, '2010-05-28 16:19:42', 1, 0),
(2, 12, 41, NULL, '2011-03-18 17:11:14', 1, '2011-03-18 17:11:14', 1, 0),
(3, 14, 48, 1.30000, '2011-03-18 17:40:58', 1, '2011-03-18 17:40:58', 1, 0);

--
-- Dumping data for table `source_aliquots_revs`
--

INSERT INTO `source_aliquots_revs` (`id`, `sample_master_id`, `aliquot_master_id`, `used_volume`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 2, 1, NULL, 1, 1, '2010-05-28 16:19:42'),
(2, 12, 41, NULL, 1, 2, '2011-03-18 17:11:14'),
(3, 14, 48, 1.30000, 1, 3, '2011-03-18 17:40:58');

--
-- Dumping data for table `specimen_details`
--

INSERT INTO `specimen_details` (`id`, `sample_master_id`, `supplier_dept`, `reception_by`, `reception_datetime`, `reception_datetime_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 'supplier dept 1', 'laboratory staff 2', '2003-04-23 13:02:00', '', '2010-05-28 15:58:57', 1, '2010-05-28 15:59:44', 1, 0),
(2, 4, 'supplier dept 2', 'laboratory staff 1', '1999-09-03 15:13:00', '', '2010-09-24 19:19:33', 1, '2010-09-24 19:19:33', 1, 0),
(3, 6, 'supplier dept 2', 'laboratory staff 1', '1995-04-13 00:00:00', '', '2010-09-24 19:33:56', 1, '2010-09-24 19:33:56', 1, 0),
(4, 8, '', '', NULL, '', '2010-09-24 19:42:56', 1, '2010-09-24 19:43:12', 1, 0),
(5, 11, 'supplier dept 2', 'laboratory staff 1', '1999-09-03 15:13:00', '', '2011-03-18 15:45:07', 1, '2011-03-18 15:45:07', 1, 0);

--
-- Dumping data for table `specimen_details_revs`
--

INSERT INTO `specimen_details_revs` (`id`, `sample_master_id`, `supplier_dept`, `reception_by`, `reception_datetime`, `reception_datetime_accuracy`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, 'supplier dept 1', 'laboratory staff 2', '2003-04-23 13:08:00', '', 1, 1, '2010-05-28 15:58:57'),
(1, 1, 'supplier dept 1', 'laboratory staff 2', '2003-04-23 13:02:00', '', 1, 2, '2010-05-28 15:59:44'),
(2, 4, 'supplier dept 2', 'laboratory staff 1', '1999-09-03 15:13:00', '', 1, 3, '2010-09-24 19:19:33'),
(3, 6, 'supplier dept 2', 'laboratory staff 1', '1995-04-13 00:00:00', '', 1, 4, '2010-09-24 19:33:56'),
(4, 8, '', '', NULL, '', 1, 5, '2010-09-24 19:42:56'),
(4, 8, '', '', NULL, '', 1, 6, '2010-09-24 19:43:12'),
(5, 11, 'supplier dept 2', 'laboratory staff 1', '1999-09-03 15:13:00', '', 1, 7, '2011-03-18 15:45:07');

--
-- Dumping data for table `specimen_review_masters`
--

INSERT INTO `specimen_review_masters` (`id`, `specimen_review_control_id`, `specimen_sample_type`, `review_type`, `collection_id`, `sample_master_id`, `review_code`, `review_date`, `review_date_accuracy`, `review_status`, `pathologist`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 'tissue', 'breast review', 3, 6, 'rv378', '1995-04-17', '', 'done', 'Dr Gold', '', '2011-02-10 21:35:47', 1, '2011-02-10 21:35:47', 1, 0),
(2, 1, 'tissue', 'breast review', 3, 6, 'TR-95', '2011-03-19', '', 'done', 'DR Qwerty', '', '2011-03-18 17:49:29', 1, '2011-03-18 17:49:29', 1, 0);

--
-- Dumping data for table `specimen_review_masters_revs`
--

INSERT INTO `specimen_review_masters_revs` (`id`, `specimen_review_control_id`, `specimen_sample_type`, `review_type`, `collection_id`, `sample_master_id`, `review_code`, `review_date`, `review_status`, `pathologist`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, 'tissue', 'breast review', 3, 6, 'rv378', '1995-04-17', 'done', 'Dr Gold', '', 1, 1, '2011-02-10 21:35:47'),
(2, 1, 'tissue', 'breast review', 3, 6, 'TR-95', '2011-03-19', 'done', 'DR Qwerty', '', 1, 2, '2011-03-18 17:49:29');

--
-- Dumping data for table `spr_breast_cancer_types`
--

INSERT INTO `spr_breast_cancer_types` (`id`, `specimen_review_master_id`, `type`, `other_type`, `tumour_grade_score_tubules`, `tumour_grade_score_nuclear`, `tumour_grade_score_mitosis`, `tumour_grade_score_total`, `tumour_grade_category`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 'ductal', NULL, 1.0, 3.0, 4.0, NULL, 'well diff', '2011-02-10 21:35:47', 1, '2011-02-10 21:35:47', 1, 0),
(2, 2, 'mucinous', NULL, NULL, NULL, NULL, NULL, 'well diff', '2011-03-18 17:49:29', 1, '2011-03-18 17:49:29', 1, 0);

--
-- Dumping data for table `spr_breast_cancer_types_revs`
--

INSERT INTO `spr_breast_cancer_types_revs` (`id`, `specimen_review_master_id`, `type`, `other_type`, `tumour_grade_score_tubules`, `tumour_grade_score_nuclear`, `tumour_grade_score_mitosis`, `tumour_grade_score_total`, `tumour_grade_category`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, 'ductal', NULL, 1.0, 3.0, 4.0, NULL, 'well diff', 1, 1, '2011-02-10 21:35:47'),
(2, 2, 'mucinous', NULL, NULL, NULL, NULL, NULL, 'well diff', 1, 2, '2011-03-18 17:49:29');

--
-- Dumping data for table `std_boxs`
--

INSERT INTO `std_boxs` (`id`, `storage_master_id`, `deleted`) VALUES
(1, 4, 0),
(2, 5, 0),
(3, 7, 0),
(4, 10, 0);

--
-- Dumping data for table `std_boxs_revs`
--

INSERT INTO `std_boxs_revs` (`id`, `storage_master_id`, `version_id`, `version_created`) VALUES
(1, 4, 1, '2010-05-28 13:24:31'),
(1, 4, 2, '2010-05-28 13:24:32'),
(1, 4, 3, '2010-05-28 13:24:45'),
(2, 5, 4, '2010-05-28 13:25:47'),
(2, 5, 5, '2010-05-28 13:25:48'),
(2, 5, 6, '2010-05-28 13:26:09'),
(3, 7, 7, '2010-05-28 13:38:48'),
(3, 7, 8, '2010-05-28 13:38:49'),
(3, 7, 9, '2010-05-28 13:39:03'),
(4, 10, 10, '2010-05-28 13:44:03'),
(4, 10, 11, '2010-05-28 13:44:05'),
(4, 10, 12, '2010-05-28 13:44:24'),
(4, 10, 13, '2010-05-28 13:46:45'),
(4, 10, 14, '2010-05-28 13:46:46'),
(4, 10, 15, '2010-05-28 13:47:50'),
(4, 10, 16, '2010-05-28 13:48:32'),
(4, 10, 17, '2010-05-28 13:49:11'),
(1, 4, 18, '2010-05-28 16:08:53'),
(2, 5, 19, '2010-05-28 16:08:54'),
(3, 7, 20, '2010-05-28 16:08:54'),
(1, 4, 21, '2010-09-24 20:13:03'),
(2, 5, 22, '2010-09-24 20:13:04'),
(3, 7, 23, '2010-09-24 20:13:04'),
(1, 4, 24, '2010-09-24 20:13:29'),
(2, 5, 25, '2010-09-24 20:13:30'),
(3, 7, 26, '2010-09-24 20:13:30');

--
-- Dumping data for table `std_fridges`
--

INSERT INTO `std_fridges` (`id`, `storage_master_id`, `deleted`) VALUES
(1, 1, 0);

--
-- Dumping data for table `std_fridges_revs`
--

INSERT INTO `std_fridges_revs` (`id`, `storage_master_id`, `version_id`, `version_created`) VALUES
(1, 1, 1, '2010-05-28 13:22:03'),
(1, 1, 2, '2010-05-28 13:22:04'),
(1, 1, 3, '2010-05-28 16:08:50'),
(1, 1, 4, '2010-09-24 20:13:01'),
(1, 1, 5, '2010-09-24 20:13:24');

--
-- Dumping data for table `std_incubators`
--

INSERT INTO `std_incubators` (`id`, `storage_master_id`, `oxygen_perc`, `carbonic_gaz_perc`, `deleted`) VALUES
(1, 8, '12', '32', 0);

--
-- Dumping data for table `std_incubators_revs`
--

INSERT INTO `std_incubators_revs` (`id`, `storage_master_id`, `oxygen_perc`, `carbonic_gaz_perc`, `version_id`, `version_created`) VALUES
(1, 8, '12', '32', 1, '2010-05-28 13:40:09'),
(1, 8, '12', '32', 2, '2010-05-28 13:40:10'),
(1, 8, '12', '32', 3, '2010-05-28 13:49:10');

--
-- Dumping data for table `std_racks`
--

INSERT INTO `std_racks` (`id`, `storage_master_id`, `deleted`) VALUES
(1, 3, 0),
(2, 6, 0),
(3, 9, 0);

--
-- Dumping data for table `std_racks_revs`
--

INSERT INTO `std_racks_revs` (`id`, `storage_master_id`, `version_id`, `version_created`) VALUES
(1, 3, 1, '2010-05-28 13:23:48'),
(1, 3, 2, '2010-05-28 13:23:49'),
(2, 6, 3, '2010-05-28 13:29:20'),
(2, 6, 4, '2010-05-28 13:29:21'),
(3, 9, 5, '2010-05-28 13:43:19'),
(3, 9, 6, '2010-05-28 13:43:20'),
(3, 9, 7, '2010-05-28 13:46:44'),
(3, 9, 8, '2010-05-28 13:47:02'),
(3, 9, 9, '2010-05-28 13:47:49'),
(3, 9, 10, '2010-05-28 13:48:31'),
(3, 9, 11, '2010-05-28 13:49:10'),
(1, 3, 12, '2010-05-28 16:08:52'),
(2, 6, 13, '2010-05-28 16:08:52'),
(1, 3, 14, '2010-09-24 20:13:02'),
(2, 6, 15, '2010-09-24 20:13:03'),
(1, 3, 16, '2010-09-24 20:13:28'),
(2, 6, 17, '2010-09-24 20:13:29');

--
-- Dumping data for table `std_shelfs`
--

INSERT INTO `std_shelfs` (`id`, `storage_master_id`, `deleted`) VALUES
(1, 2, 0);

--
-- Dumping data for table `std_shelfs_revs`
--

INSERT INTO `std_shelfs_revs` (`id`, `storage_master_id`, `version_id`, `version_created`) VALUES
(1, 2, 1, '2010-05-28 13:22:54'),
(1, 2, 2, '2010-05-28 13:22:55'),
(1, 2, 3, '2010-05-28 16:08:51'),
(1, 2, 4, '2010-09-24 20:13:02'),
(1, 2, 5, '2010-09-24 20:13:28');

--
-- Dumping data for table `std_tma_blocks`
--

INSERT INTO `std_tma_blocks` (`id`, `storage_master_id`, `sop_master_id`, `product_code`, `creation_datetime`, `creation_datetime_accuracy`, `deleted`) VALUES
(1, 11, NULL, NULL, '2011-05-18 00:00:00', '', 0);

--
-- Dumping data for table `std_tma_blocks_revs`
--

INSERT INTO `std_tma_blocks_revs` (`id`, `storage_master_id`, `sop_master_id`, `product_code`, `creation_datetime`, `version_id`, `version_created`) VALUES
(1, 11, NULL, NULL, NULL, 1, '2010-05-28 13:52:22'),
(1, 11, NULL, NULL, '2011-05-18 00:00:00', 2, '2011-03-18 17:54:37');

--
-- Dumping data for table `storage_coordinates`
--

INSERT INTO `storage_coordinates` (`id`, `storage_master_id`, `dimension`, `coordinate_value`, `order`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 8, 'x', '1', 1, '2010-05-28 13:41:21', 1, '2010-05-28 13:41:57', 1, 1),
(2, 8, 'x', 's2', 2, '2010-05-28 13:41:40', 1, '2010-05-28 13:41:40', 1, 0),
(3, 8, 'x', 's1', 1, '2010-05-28 13:42:18', 1, '2010-05-28 13:42:18', 1, 0);

--
-- Dumping data for table `storage_coordinates_revs`
--

INSERT INTO `storage_coordinates_revs` (`id`, `storage_master_id`, `dimension`, `coordinate_value`, `order`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 8, 'x', '1', 1, 1, 1, '2010-05-28 13:41:21'),
(2, 8, 'x', 's2', 2, 1, 2, '2010-05-28 13:41:40'),
(1, 8, 'x', '1', 1, 1, 3, '2010-05-28 13:41:57'),
(3, 8, 'x', 's1', 1, 1, 4, '2010-05-28 13:42:18');

--
-- Dumping data for table `storage_masters`
--

INSERT INTO `storage_masters` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `parent_storage_coord_y`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 'FRI - 1', 'fridge', 5, NULL, 1, 14, 'bc67893', 'fr1New', 'fr1New', '', '', '', 'TRUE', 4.70, 'celsius', '', '2010-05-28 13:22:03', 1, '2010-09-24 20:13:24', 1, 0),
(2, 'SH - 2', 'shelf', 14, 1, 2, 13, '-', '1', 'fr1New-1', '', '', '', 'FALSE', 4.70, 'celsius', '', '2010-05-28 13:22:54', 1, '2010-09-24 20:13:28', 1, 0),
(3, 'R10 - 3', 'rack10', 12, 2, 3, 8, 'bc78904', 'r1', 'fr1New-1-r1', '', '', '', 'FALSE', 4.70, 'celsius', '', '2010-05-28 13:23:47', 1, '2010-09-24 20:13:28', 1, 0),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1New-1-r1-001', '', '1', '', 'FALSE', 4.70, 'celsius', '', '2010-05-28 13:24:30', 1, '2010-09-24 20:13:29', 1, 0),
(5, 'B25 - 5', 'box25', 17, 3, 6, 7, 'bc8978732', '002', 'fr1New-1-r1-002', '', '2', '', 'FALSE', 4.70, 'celsius', '', '2010-05-28 13:25:46', 1, '2010-09-24 20:13:30', 1, 0),
(6, 'R10 - 6', 'rack10', 12, 2, 9, 12, 'bc988900', 'r2', 'fr1New-1-r2', '', '', '', 'FALSE', 4.70, 'celsius', '', '2010-05-28 13:29:19', 1, '2010-09-24 20:13:29', 1, 0),
(7, 'B25 - 7', 'box25', 17, 6, 10, 11, 'bc87987876', '003', 'fr1New-1-r2-003', '', '3', '', 'FALSE', 4.70, 'celsius', '', '2010-05-28 13:38:47', 1, '2010-09-24 20:13:30', 1, 0),
(8, 'INC - 8', 'incubator', 4, NULL, 15, 20, 'bc9032098', 'ic1', 'ic1', '', '', '', 'TRUE', 36.00, 'celsius', '', '2010-05-28 13:40:08', 1, '2010-05-28 13:49:10', 1, 0),
(9, 'R2D16 - 9', 'rack16', 11, 8, 16, 19, 'bc987237', 'r1', 'ic1-r1', '', 's2', '', 'FALSE', 36.00, 'celsius', '', '2010-05-28 13:43:19', 1, '2010-05-28 13:49:10', 1, 0),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'ic1-r1-004', '', 'B', '1', 'FALSE', 36.00, 'celsius', '', '2010-05-28 13:44:03', 1, '2010-05-28 13:49:11', 1, 0),
(11, 'TMA345 - 11', 'TMA-blc 23X15', 19, NULL, 21, 22, 'bc79879832', 'tm1', 'tm1', '', '', '', 'FALSE', NULL, NULL, '', '2010-05-28 13:52:21', 1, '2011-03-18 17:54:37', 1, 0);

--
-- Dumping data for table `storage_masters_revs`
--

INSERT INTO `storage_masters_revs` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `parent_storage_coord_y`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `modified_by`, `version_id`, `version_created`) VALUES
(1, '', 'fridge', 5, NULL, 1, 2, 'bc67893', 'fr1', 'fr1', '', '', '', 'TRUE', 6.00, 'celsius', '', 1, 1, '2010-05-28 13:22:03'),
(1, 'FRI - 1', 'fridge', 5, NULL, 1, 2, 'bc67893', 'fr1', 'fr1', '', '', '', 'TRUE', 6.00, 'celsius', '', 1, 2, '2010-05-28 13:22:04'),
(2, '', 'shelf', 14, 1, 0, 0, '-', '1', 'fr1-1', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 3, '2010-05-28 13:22:54'),
(2, 'SH - 2', 'shelf', 14, 1, 2, 3, '-', '1', 'fr1-1', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 4, '2010-05-28 13:22:55'),
(3, '', 'rack10', 12, 2, 0, 0, 'bc78904', 'r1', 'fr1-1-r1', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 5, '2010-05-28 13:23:47'),
(3, 'R10 - 3', 'rack10', 12, 2, 3, 4, 'bc78904', 'r1', 'fr1-1-r1', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 6, '2010-05-28 13:23:48'),
(4, '', 'box81 1A-9I', 9, 3, 0, 0, 'bc9973900', '001', 'fr1-1-r1-001', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 7, '2010-05-28 13:24:30'),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1-1-r1-001', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 8, '2010-05-28 13:24:31'),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1-1-r1-001', '', '6', '', 'FALSE', 6.00, 'celsius', '', 1, 9, '2010-05-28 13:24:45'),
(5, '', 'box25', 17, 3, 0, 0, 'bc8978732', '002', 'fr1-1-r1-002', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 10, '2010-05-28 13:25:46'),
(5, 'B25 - 5', 'box25', 17, 3, 6, 7, 'bc8978732', '002', 'fr1-1-r1-002', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 11, '2010-05-28 13:25:47'),
(5, 'B25 - 5', 'box25', 17, 3, 6, 7, 'bc8978732', '002', 'fr1-1-r1-002', '', '2', '', 'FALSE', 6.00, 'celsius', '', 1, 12, '2010-05-28 13:26:09'),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1-1-r1-001', '', '1', '', 'FALSE', 6.00, 'celsius', '', 1, 13, '2010-05-28 13:24:45'),
(6, '', 'rack10', 12, 2, 0, 0, 'bc988900', 'r2', 'fr1-1-r2', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 14, '2010-05-28 13:29:19'),
(6, 'R10 - 6', 'rack10', 12, 2, 9, 10, 'bc988900', 'r2', 'fr1-1-r2', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 15, '2010-05-28 13:29:20'),
(7, '', 'box25', 17, 6, 0, 0, 'bc87987876', '003', 'fr1-1-r2-003', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 16, '2010-05-28 13:38:47'),
(7, 'B25 - 7', 'box25', 17, 6, 10, 11, 'bc87987876', '003', 'fr1-1-r2-003', '', '', '', 'FALSE', 6.00, 'celsius', '', 1, 17, '2010-05-28 13:38:48'),
(7, 'B25 - 7', 'box25', 17, 6, 10, 11, 'bc87987876', '003', 'fr1-1-r2-003', '', '3', '', 'FALSE', 6.00, 'celsius', '', 1, 18, '2010-05-28 13:39:03'),
(8, '', 'incubator', 4, NULL, 15, 16, 'bc9032098', 'ic1', 'ic1', '', '', '', 'TRUE', 37.00, 'celsius', '', 1, 19, '2010-05-28 13:40:08'),
(8, 'INC - 8', 'incubator', 4, NULL, 15, 16, 'bc9032098', 'ic1', 'ic1', '', '', '', 'TRUE', 37.00, 'celsius', '', 1, 20, '2010-05-28 13:40:09'),
(9, '', 'rack16', 11, NULL, 17, 18, 'bc987237', 'r1', 'r1', '', '', '', 'FALSE', NULL, NULL, '', 1, 21, '2010-05-28 13:43:19'),
(9, 'R2D16 - 9', 'rack16', 11, NULL, 17, 18, 'bc987237', 'r1', 'r1', '', '', '', 'FALSE', NULL, NULL, '', 1, 22, '2010-05-28 13:43:20'),
(10, '', 'box100 1A-20E', 18, 9, 0, 0, 'bc987040', '004', 'r1-004', '', '', '', 'FALSE', NULL, NULL, '', 1, 23, '2010-05-28 13:44:03'),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 18, 19, 'bc987040', '004', 'r1-004', '', '', '', 'FALSE', NULL, NULL, '', 1, 24, '2010-05-28 13:44:04'),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 18, 19, 'bc987040', '004', 'r1-004', '', 'B', '1', 'FALSE', NULL, NULL, '', 1, 25, '2010-05-28 13:44:23'),
(9, 'R2D16 - 9', 'rack16', 11, 8, 17, 20, 'bc987237', 'r1', 'ic1-r1', '', '', '', 'FALSE', 37.00, 'celsius', '', 1, 26, '2010-05-28 13:46:43'),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'r1-004', '', 'B', '1', 'FALSE', 37.00, 'celsius', '', 1, 27, '2010-05-28 13:46:45'),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'ic1-r1-004', '', 'B', '1', 'FALSE', 37.00, 'celsius', '', 1, 28, '2010-05-28 13:46:45'),
(9, 'R2D16 - 9', 'rack16', 11, 8, 16, 19, 'bc987237', 'r1', 'ic1-r1', '', 's2', '', 'FALSE', 37.00, 'celsius', '', 1, 29, '2010-05-28 13:47:01'),
(9, 'R2D16 - 9', 'rack16', 11, 8, 16, 19, 'bc987237', 'ic_r1', 'ic1-ic_r1', '', 's2', '', 'FALSE', 37.00, 'celsius', '', 1, 30, '2010-05-28 13:47:49'),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'ic1-ic_r1-004', '', 'B', '1', 'FALSE', 37.00, 'celsius', '', 1, 31, '2010-05-28 13:47:49'),
(9, 'R2D16 - 9', 'rack16', 11, 8, 16, 19, 'bc987237', 'r1', 'ic1-r1', '', 's2', '', 'FALSE', 37.00, 'celsius', '', 1, 32, '2010-05-28 13:48:30'),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'ic1-r1-004', '', 'B', '1', 'FALSE', 37.00, 'celsius', '', 1, 33, '2010-05-28 13:48:31'),
(8, 'INC - 8', 'incubator', 4, NULL, 15, 20, 'bc9032098', 'ic1', 'ic1', '', '', '', 'TRUE', 36.00, 'celsius', '', 1, 34, '2010-05-28 13:49:10'),
(9, 'R2D16 - 9', 'rack16', 11, 8, 16, 19, 'bc987237', 'r1', 'ic1-r1', '', 's2', '', 'FALSE', 36.00, 'celsius', '', 1, 35, '2010-05-28 13:49:10'),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'ic1-r1-004', '', 'B', '1', 'FALSE', 36.00, 'celsius', '', 1, 36, '2010-05-28 13:49:11'),
(11, '', 'TMA-blc 23X15', 19, NULL, 21, 22, 'bc79879832', 'tm1', 'tm1', '', '', '', 'FALSE', NULL, NULL, '', 1, 37, '2010-05-28 13:52:21'),
(11, 'TMA345 - 11', 'TMA-blc 23X15', 19, NULL, 21, 22, 'bc79879832', 'tm1', 'tm1', '', '', '', 'FALSE', NULL, NULL, '', 1, 38, '2010-05-28 13:52:22'),
(1, 'FRI - 1', 'fridge', 5, NULL, 1, 14, 'bc67893', 'fr1', 'fr1', '', '', '', 'TRUE', 8.00, 'celsius', '', 1, 39, '2010-05-28 16:08:50'),
(2, 'SH - 2', 'shelf', 14, 1, 2, 13, '-', '1', 'fr1-1', '', '', '', 'FALSE', 8.00, 'celsius', '', 1, 40, '2010-05-28 16:08:51'),
(3, 'R10 - 3', 'rack10', 12, 2, 3, 8, 'bc78904', 'r1', 'fr1-1-r1', '', '', '', 'FALSE', 8.00, 'celsius', '', 1, 41, '2010-05-28 16:08:51'),
(6, 'R10 - 6', 'rack10', 12, 2, 9, 12, 'bc988900', 'r2', 'fr1-1-r2', '', '', '', 'FALSE', 8.00, 'celsius', '', 1, 42, '2010-05-28 16:08:52'),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1-1-r1-001', '', '1', '', 'FALSE', 8.00, 'celsius', '', 1, 43, '2010-05-28 16:08:53'),
(5, 'B25 - 5', 'box25', 17, 3, 6, 7, 'bc8978732', '002', 'fr1-1-r1-002', '', '2', '', 'FALSE', 8.00, 'celsius', '', 1, 44, '2010-05-28 16:08:53'),
(7, 'B25 - 7', 'box25', 17, 6, 10, 11, 'bc87987876', '003', 'fr1-1-r2-003', '', '3', '', 'FALSE', 8.00, 'celsius', '', 1, 45, '2010-05-28 16:08:54'),
(1, 'FRI - 1', 'fridge', 5, NULL, 1, 14, 'bc67893', 'fr1', 'fr1', '', '', '', 'TRUE', 4.70, 'celsius', '', 1, 46, '2010-09-24 20:13:01'),
(2, 'SH - 2', 'shelf', 14, 1, 2, 13, '-', '1', 'fr1-1', '', '', '', 'FALSE', 4.70, 'celsius', '', 1, 47, '2010-09-24 20:13:02'),
(3, 'R10 - 3', 'rack10', 12, 2, 3, 8, 'bc78904', 'r1', 'fr1-1-r1', '', '', '', 'FALSE', 4.70, 'celsius', '', 1, 48, '2010-09-24 20:13:02'),
(6, 'R10 - 6', 'rack10', 12, 2, 9, 12, 'bc988900', 'r2', 'fr1-1-r2', '', '', '', 'FALSE', 4.70, 'celsius', '', 1, 49, '2010-09-24 20:13:03'),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1-1-r1-001', '', '1', '', 'FALSE', 4.70, 'celsius', '', 1, 50, '2010-09-24 20:13:03'),
(5, 'B25 - 5', 'box25', 17, 3, 6, 7, 'bc8978732', '002', 'fr1-1-r1-002', '', '2', '', 'FALSE', 4.70, 'celsius', '', 1, 51, '2010-09-24 20:13:03'),
(7, 'B25 - 7', 'box25', 17, 6, 10, 11, 'bc87987876', '003', 'fr1-1-r2-003', '', '3', '', 'FALSE', 4.70, 'celsius', '', 1, 52, '2010-09-24 20:13:04'),
(1, 'FRI - 1', 'fridge', 5, NULL, 1, 14, 'bc67893', 'fr1New', 'fr1New', '', '', '', 'TRUE', 4.70, 'celsius', '', 1, 53, '2010-09-24 20:13:24'),
(2, 'SH - 2', 'shelf', 14, 1, 2, 13, '-', '1', 'fr1New-1', '', '', '', 'FALSE', 4.70, 'celsius', '', 1, 54, '2010-09-24 20:13:28'),
(3, 'R10 - 3', 'rack10', 12, 2, 3, 8, 'bc78904', 'r1', 'fr1New-1-r1', '', '', '', 'FALSE', 4.70, 'celsius', '', 1, 55, '2010-09-24 20:13:28'),
(6, 'R10 - 6', 'rack10', 12, 2, 9, 12, 'bc988900', 'r2', 'fr1New-1-r2', '', '', '', 'FALSE', 4.70, 'celsius', '', 1, 56, '2010-09-24 20:13:29'),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1New-1-r1-001', '', '1', '', 'FALSE', 4.70, 'celsius', '', 1, 57, '2010-09-24 20:13:29'),
(5, 'B25 - 5', 'box25', 17, 3, 6, 7, 'bc8978732', '002', 'fr1New-1-r1-002', '', '2', '', 'FALSE', 4.70, 'celsius', '', 1, 58, '2010-09-24 20:13:30'),
(7, 'B25 - 7', 'box25', 17, 6, 10, 11, 'bc87987876', '003', 'fr1New-1-r2-003', '', '3', '', 'FALSE', 4.70, 'celsius', '', 1, 59, '2010-09-24 20:13:30'),
(11, 'TMA345 - 11', 'TMA-blc 23X15', 19, NULL, 21, 22, 'bc79879832', 'tm1', 'tm1', '', '', '', 'FALSE', NULL, NULL, '', 1, 60, '2011-03-18 17:54:37');

--
-- Dumping data for table `study_summaries`
--

INSERT INTO `study_summaries` (`id`, `disease_site`, `study_type`, `study_science`, `study_use`, `title`, `start_date`, `start_date_accuracy`, `end_date`, `end_date_accuracy`, `summary`, `abstract`, `hypothesis`, `approach`, `analysis`, `significance`, `additional_clinical`, `created`, `created_by`, `modified`, `modified_by`, `path_to_file`, `deleted`) VALUES
(1, 'gynaecologic', 'prospective', 'basic', '', 'OP 987 Std1', '2010-05-04', '', '2010-10-05', '', '', '', '', '', '', '', '', '2010-05-28 11:29:52', 1, '2010-05-28 11:29:52', 1, '', 0);

--
-- Dumping data for table `study_summaries_revs`
--

INSERT INTO `study_summaries_revs` (`id`, `disease_site`, `study_type`, `study_science`, `study_use`, `title`, `start_date`, `end_date`, `summary`, `abstract`, `hypothesis`, `approach`, `analysis`, `significance`, `additional_clinical`, `modified_by`, `path_to_file`, `version_id`, `version_created`) VALUES
(1, 'gynaecologic', 'prospective', 'basic', '', 'OP 987 Std1', '2010-05-04', '2010-10-05', '', '', '', '', '', '', '', 1, '', 1, '2010-05-28 11:29:52');

--
-- Dumping data for table `tma_slides`
--

INSERT INTO `tma_slides` (`id`, `tma_block_storage_master_id`, `barcode`, `product_code`, `sop_master_id`, `immunochemistry`, `picture_path`, `storage_datetime`, `storage_datetime_accuracy`, `storage_master_id`, `storage_coord_x`, `storage_coord_y`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 11, 'sl9898', NULL, 1, 'ac412', '/tmp/899', '2010-05-03 00:00:00', '', 2, '', '', '2010-05-28 13:54:05', 1, '2010-05-28 13:56:20', 1, 0);

--
-- Dumping data for table `tma_slides_revs`
--

INSERT INTO `tma_slides_revs` (`id`, `tma_block_storage_master_id`, `barcode`, `product_code`, `sop_master_id`, `immunochemistry`, `picture_path`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `storage_coord_y`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 11, 'sl9898', NULL, 1, 'ac412', '/tmp/899', '2010-05-03 00:00:00', 3, '8', '', 1, 1, '2010-05-28 13:54:05'),
(1, 11, 'sl9898', NULL, 1, 'ac412', '/tmp/899', '2010-05-03 00:00:00', 2, '', '', 1, 2, '2010-05-28 13:56:20');

--
-- Dumping data for table `txd_chemos`
--

INSERT INTO `txd_chemos` (`id`, `chemo_completed`, `response`, `num_cycles`, `length_cycles`, `completed_cycles`, `tx_master_id`, `deleted`) VALUES
(1, 'yes', 'complete', 2, 3, NULL, 1, 0),
(2, 'no', '', NULL, NULL, NULL, 2, 0);

--
-- Dumping data for table `txd_chemos_revs`
--

INSERT INTO `txd_chemos_revs` (`id`, `chemo_completed`, `response`, `num_cycles`, `length_cycles`, `completed_cycles`, `tx_master_id`, `version_id`, `version_created`) VALUES
(1, 'yes', 'complete', 2, 3, NULL, 1, 1, '2010-05-28 14:23:14'),
(2, 'no', '', NULL, NULL, NULL, 2, 2, '2010-05-28 14:26:17');

--
-- Dumping data for table `txd_surgeries`
--

INSERT INTO `txd_surgeries` (`id`, `path_num`, `primary`, `tx_master_id`, `deleted`) VALUES
(1, '67yf45', NULL, 3, 0);

--
-- Dumping data for table `txd_surgeries_revs`
--

INSERT INTO `txd_surgeries_revs` (`id`, `path_num`, `primary`, `tx_master_id`, `version_id`, `version_created`) VALUES
(1, '67yf45', NULL, 3, 1, '2010-05-28 14:27:24');

--
-- Dumping data for table `txe_chemos`
--

INSERT INTO `txe_chemos` (`id`, `dose`, `method`, `drug_id`, `tx_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, '34', 'IV: Intravenous', 1, 1, '2010-05-28 14:23:55', 1, '2010-05-28 14:23:55', 1, 0),
(2, '', 'IV: Intravenous', 3, 1, '2010-05-28 14:23:55', 1, '2010-05-28 14:23:55', 1, 0),
(3, '', 'IV: Intravenous', 2, 1, '2010-05-28 14:24:15', 1, '2010-05-28 14:24:15', 1, 0);

--
-- Dumping data for table `tx_masters`
--

INSERT INTO `tx_masters` (`id`, `tx_control_id`, `tx_method`, `disease_site`, `tx_intent`, `target_site_icdo`, `start_date`, `start_date_accuracy`, `finish_date`, `finish_date_accuracy`, `information_source`, `facility`, `notes`, `protocol_master_id`, `participant_id`, `diagnosis_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 'chemotherapy', 'all', 'curative', '', '2003-03-14', '', '2003-03-15', '', '', 'Building A', '', 1, 1, 2, '2010-05-28 14:23:14', 1, '2010-05-28 14:23:14', 1, 0),
(2, 1, 'chemotherapy', 'all', 'curative', '', '2003-05-01', '', NULL, '', '', 'Building A', '', NULL, 1, 2, '2010-05-28 14:26:16', 1, '2010-05-28 14:26:16', 1, 0),
(3, 3, 'surgery', 'all', '', '', '2003-04-23', '', NULL, '', '', '', '', NULL, 1, 2, '2010-05-28 14:27:24', 1, '2010-05-28 14:27:24', 1, 0);

--
-- Dumping data for table `tx_masters_revs`
--

INSERT INTO `tx_masters_revs` (`id`, `tx_control_id`, `tx_method`, `disease_site`, `tx_intent`, `target_site_icdo`, `start_date`, `start_date_accuracy`, `finish_date`, `finish_date_accuracy`, `information_source`, `facility`, `notes`, `modified_by`, `protocol_master_id`, `participant_id`, `diagnosis_master_id`, `version_id`, `version_created`) VALUES
(1, 1, 'chemotherapy', 'all', 'curative', '', '2003-03-14', '', '2003-03-15', '', '', 'Building A', '', 1, 1, 1, 2, 1, '2010-05-28 14:23:14'),
(2, 1, 'chemotherapy', 'all', 'curative', '', '2003-05-01', '', NULL, '', '', 'Building A', '', 1, NULL, 1, 2, 2, '2010-05-28 14:26:16'),
(3, 3, 'surgery', 'all', '', '', '2003-04-23', '', NULL, '', '', '', '', 1, NULL, 1, 2, 3, '2010-05-28 14:27:24');

--
-- Dumping data for table `structure_permissible_values_customs`
--

INSERT INTO `structure_permissible_values_customs` (`id`, `control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) VALUES
(1, 1, 'laboratory staff 1', 'Lab Staff 1', 'Lab Staff 1', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0),
(2, 1, 'laboratory staff 2', 'Lab Staff 2', 'Lab Staff 2', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0),
(3, 1, 'laboratory staff etc', 'Lab Staff ...', 'Lab Staff ...', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0),
(4, 2, 'laboratory site 1', 'Lab Site 1', 'Lab Site 1', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0),
(5, 2, 'laboratory site 2', 'Lab Site 2', 'Lab Site 2', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0),
(6, 2, 'laboratory site etc', 'Lab Site ...', 'Lab Site ...', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0),
(7, 3, 'collection site 1', 'Col Site 1', 'Col Site 1', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0),
(8, 3, 'collection site 2', 'Col Site 2', 'Col Site 2', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0),
(9, 3, 'collection site etc', 'Col Site ...', 'Col Site ...', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0),
(10, 4, 'supplier dept 1', 'Sup Dept 1', 'Sup Dept 1', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0),
(11, 4, 'supplier dept 2', 'Sup Dept 2', 'Sup Dept 2', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0),
(12, 4, 'supplier dept etc', 'Sup Dept ...', 'Sup Dept ...', 0, 1, '0000-00-00 00:00:00', 0, NULL, 0, 0);

--
-- Dumping data for table `structure_permissible_values_customs_revs`
--

INSERT INTO `structure_permissible_values_customs_revs` (`id`, `control_id`, `value`, `en`, `fr`, `display_order`, `use_as_input`, `modified_by`, `version_id`, `version_created`) VALUES
(1, 1, 'laboratory staff 1', 'Lab Staff 1', 'Lab Staff 1', 0, 1, 0, 1, '0000-00-00 00:00:00'),
(2, 1, 'laboratory staff 2', 'Lab Staff 2', 'Lab Staff 2', 0, 1, 0, 2, '0000-00-00 00:00:00'),
(3, 1, 'laboratory staff etc', 'Lab Staff ...', 'Lab Staff ...', 0, 1, 0, 3, '0000-00-00 00:00:00'),
(4, 2, 'laboratory site 1', 'Lab Site 1', 'Lab Site 1', 0, 1, 0, 4, '0000-00-00 00:00:00'),
(5, 2, 'laboratory site 2', 'Lab Site 2', 'Lab Site 2', 0, 1, 0, 5, '0000-00-00 00:00:00'),
(6, 2, 'laboratory site etc', 'Lab Site ...', 'Lab Site ...', 0, 1, 0, 6, '0000-00-00 00:00:00'),
(7, 3, 'collection site 1', 'Col Site 1', 'Col Site 1', 0, 1, 0, 7, '0000-00-00 00:00:00'),
(8, 3, 'collection site 2', 'Col Site 2', 'Col Site 2', 0, 1, 0, 8, '0000-00-00 00:00:00'),
(9, 3, 'collection site etc', 'Col Site ...', 'Col Site ...', 0, 1, 0, 9, '0000-00-00 00:00:00'),
(10, 4, 'supplier dept 1', 'Sup Dept 1', 'Sup Dept 1', 0, 1, 0, 10, '0000-00-00 00:00:00'),
(11, 4, 'supplier dept 2', 'Sup Dept 2', 'Sup Dept 2', 0, 1, 0, 11, '0000-00-00 00:00:00'),
(12, 4, 'supplier dept etc', 'Sup Dept ...', 'Sup Dept ...', 0, 1, 0, 12, '0000-00-00 00:00:00');


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

INSERT INTO structures(`alias`) VALUES ('QR_AQ_complexe');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='help_participant identifier' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_sex' AND `language_label`='sex' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=30' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot type' AND `language_tag`=''), '0', '4', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='in_stock' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_in_stock_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='yes - available' AND `language_help`='aliquot_in_stock_help' AND `language_label`='aliquot in stock' AND `language_tag`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_label' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot label' AND `language_tag`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

INSERT INTO structures(`alias`) VALUES ('QR_AQ_complexe_3');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'barcode', 'input',  NULL , '0', 'tool=csv', '', '', 'barcode', ''), 
('Inventorymanagement', 'AliquotMaster', 'aliquot_masters', 'aliquot_label', 'input',  NULL , '0', 'tool=csv', '', '', 'aliquot label', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='tool=csv' AND `default`='' AND `language_help`='' AND `language_label`='barcode' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_AQ_complexe_3'), (SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='aliquot_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='aliquot_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='aliquot type' AND `language_tag`=''), '0', '2', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
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

INSERT INTO structures(`alias`) VALUES ('QR_SM_complexe');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='QR_SM_complexe'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=20' AND `default`='' AND `language_help`='help_participant identifier' AND `language_label`='participant identifier' AND `language_tag`=''), '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_SM_complexe'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_sex' AND `language_label`='sex' AND `language_tag`=''), '0', '1', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_SM_complexe'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sample_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='sample type' AND `language_tag`=''), '0', '3', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='QR_SM_complexe'), (SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='code' AND `language_tag`=''), '0', '5', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');

