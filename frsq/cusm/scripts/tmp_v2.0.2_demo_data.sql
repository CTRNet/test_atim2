-- phpMyAdmin SQL Dump
-- version 3.1.3
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Ven 28 Mai 2010 à 16:53
-- Version du serveur: 5.1.32
-- Version de PHP: 5.2.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET FOREIGN_KEY_CHECKS=0;

--
-- Base de données: `ctrnet_trunk`
--

--
-- Contenu de la table `ad_bags`
--


--
-- Contenu de la table `ad_bags_revs`
--


--
-- Contenu de la table `ad_blocks`
--


--
-- Contenu de la table `ad_blocks_revs`
--


--
-- Contenu de la table `ad_cell_cores`
--


--
-- Contenu de la table `ad_cell_cores_revs`
--


--
-- Contenu de la table `ad_cell_slides`
--


--
-- Contenu de la table `ad_cell_slides_revs`
--


--
-- Contenu de la table `ad_gel_matrices`
--


--
-- Contenu de la table `ad_gel_matrices_revs`
--


--
-- Contenu de la table `ad_tissue_cores`
--


--
-- Contenu de la table `ad_tissue_cores_revs`
--


--
-- Contenu de la table `ad_tissue_slides`
--


--
-- Contenu de la table `ad_tissue_slides_revs`
--


--
-- Contenu de la table `ad_tubes`
--

INSERT INTO `ad_tubes` (`id`, `aliquot_master_id`, `lot_number`, `concentration`, `concentration_unit`, `cell_count`, `cell_count_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:22', 1, '2010-05-28 16:19:43', 1, 0, NULL),
(2, 2, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:23', 1, '2010-05-28 16:10:06', 1, 0, NULL),
(3, 3, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:24', 1, '2010-05-28 16:05:02', 1, 0, NULL),
(4, 5, '#42343214', '54.00', 'million(s)/ml', '34.00', '10e7', '2010-05-28 16:23:59', 1, '2010-05-28 16:23:59', 1, 0, NULL),
(5, 6, '#42343214', '43.00', 'million(s)/ml', '23.00', '10e7', '2010-05-28 16:24:00', 1, '2010-05-28 16:24:00', 1, 0, NULL),
(6, 7, '', NULL, '', NULL, NULL, '2010-05-28 16:28:22', 1, '2010-05-28 16:28:22', 1, 0, NULL),
(7, 8, '', NULL, '', NULL, NULL, '2010-05-28 16:28:23', 1, '2010-05-28 16:28:23', 1, 0, NULL),
(8, 9, '', NULL, '', NULL, NULL, '2010-05-28 16:28:24', 1, '2010-05-28 16:28:24', 1, 0, NULL),
(9, 10, '', NULL, '', NULL, NULL, '2010-05-28 16:28:25', 1, '2010-05-28 16:33:46', 1, 0, NULL),
(10, 11, '', NULL, '', NULL, NULL, '2010-05-28 16:28:26', 1, '2010-05-28 16:32:08', 1, 0, NULL),
(11, 12, '', NULL, '', NULL, NULL, '2010-05-28 16:28:27', 1, '2010-05-28 16:28:27', 1, 0, NULL),
(12, 13, '', NULL, '', NULL, NULL, '2010-05-28 16:28:28', 1, '2010-05-28 16:28:28', 1, 0, NULL),
(13, 14, '', NULL, '', NULL, NULL, '2010-05-28 16:28:29', 1, '2010-05-28 16:28:29', 1, 0, NULL),
(14, 15, '', NULL, '', NULL, NULL, '2010-05-28 16:28:30', 1, '2010-05-28 16:28:30', 1, 0, NULL);

--
-- Contenu de la table `ad_tubes_revs`
--

INSERT INTO `ad_tubes_revs` (`id`, `aliquot_master_id`, `lot_number`, `concentration`, `concentration_unit`, `cell_count`, `cell_count_unit`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:22', 1, '2010-05-28 16:02:22', 1, 1, '2010-05-28 16:02:22', 0, NULL),
(2, 2, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:23', 1, '2010-05-28 16:02:23', 1, 2, '2010-05-28 16:02:23', 0, NULL),
(3, 3, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:24', 1, '2010-05-28 16:02:24', 1, 3, '2010-05-28 16:02:24', 0, NULL),
(3, 3, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:24', 1, '2010-05-28 16:04:31', 1, 4, '2010-05-28 16:04:32', 0, NULL),
(3, 3, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:24', 1, '2010-05-28 16:05:02', 1, 5, '2010-05-28 16:05:02', 0, NULL),
(2, 2, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:23', 1, '2010-05-28 16:10:04', 1, 6, '2010-05-28 16:10:05', 0, NULL),
(2, 2, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:23', 1, '2010-05-28 16:10:06', 1, 7, '2010-05-28 16:10:06', 0, NULL),
(1, 1, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:22', 1, '2010-05-28 16:19:41', 1, 8, '2010-05-28 16:19:41', 0, NULL),
(1, 1, '#97730-423', NULL, NULL, NULL, NULL, '2010-05-28 16:02:22', 1, '2010-05-28 16:19:43', 1, 9, '2010-05-28 16:19:43', 0, NULL),
(4, 5, '#42343214', '54.00', 'million(s)/ml', '34.00', '10e7', '2010-05-28 16:23:59', 1, '2010-05-28 16:23:59', 1, 10, '2010-05-28 16:24:00', 0, NULL),
(5, 6, '#42343214', '43.00', 'million(s)/ml', '23.00', '10e7', '2010-05-28 16:24:00', 1, '2010-05-28 16:24:00', 1, 11, '2010-05-28 16:24:00', 0, NULL),
(6, 7, '', NULL, '', NULL, NULL, '2010-05-28 16:28:22', 1, '2010-05-28 16:28:22', 1, 12, '2010-05-28 16:28:22', 0, NULL),
(7, 8, '', NULL, '', NULL, NULL, '2010-05-28 16:28:23', 1, '2010-05-28 16:28:23', 1, 13, '2010-05-28 16:28:23', 0, NULL),
(8, 9, '', NULL, '', NULL, NULL, '2010-05-28 16:28:24', 1, '2010-05-28 16:28:24', 1, 14, '2010-05-28 16:28:24', 0, NULL),
(9, 10, '', NULL, '', NULL, NULL, '2010-05-28 16:28:25', 1, '2010-05-28 16:28:25', 1, 15, '2010-05-28 16:28:25', 0, NULL),
(10, 11, '', NULL, '', NULL, NULL, '2010-05-28 16:28:26', 1, '2010-05-28 16:28:26', 1, 16, '2010-05-28 16:28:26', 0, NULL),
(11, 12, '', NULL, '', NULL, NULL, '2010-05-28 16:28:27', 1, '2010-05-28 16:28:27', 1, 17, '2010-05-28 16:28:27', 0, NULL),
(12, 13, '', NULL, '', NULL, NULL, '2010-05-28 16:28:28', 1, '2010-05-28 16:28:28', 1, 18, '2010-05-28 16:28:28', 0, NULL),
(13, 14, '', NULL, '', NULL, NULL, '2010-05-28 16:28:29', 1, '2010-05-28 16:28:29', 1, 19, '2010-05-28 16:28:29', 0, NULL),
(14, 15, '', NULL, '', NULL, NULL, '2010-05-28 16:28:30', 1, '2010-05-28 16:28:30', 1, 20, '2010-05-28 16:28:30', 0, NULL),
(9, 10, '', NULL, '', NULL, NULL, '2010-05-28 16:28:25', 1, '2010-05-28 16:31:12', 1, 21, '2010-05-28 16:31:12', 0, NULL),
(10, 11, '', NULL, '', NULL, NULL, '2010-05-28 16:28:26', 1, '2010-05-28 16:32:08', 1, 22, '2010-05-28 16:32:08', 0, NULL),
(9, 10, '', NULL, '', NULL, NULL, '2010-05-28 16:28:25', 1, '2010-05-28 16:33:46', 1, 23, '2010-05-28 16:33:47', 0, NULL);

--
-- Contenu de la table `ad_whatman_papers`
--

INSERT INTO `ad_whatman_papers` (`id`, `aliquot_master_id`, `used_blood_volume`, `used_blood_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 4, '1.50000', 'ml', '2010-05-28 16:03:25', 1, '2010-05-28 16:03:25', 1, 0, NULL);

--
-- Contenu de la table `ad_whatman_papers_revs`
--

INSERT INTO `ad_whatman_papers_revs` (`id`, `aliquot_master_id`, `used_blood_volume`, `used_blood_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, 4, '1.50000', 'ml', '2010-05-28 16:03:25', 1, '2010-05-28 16:03:25', 1, 0, NULL, 1, '2010-05-28 16:03:26');

--
-- Contenu de la table `aliquot_masters`
--

INSERT INTO `aliquot_masters` (`id`, `barcode`, `aliquot_type`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `sop_master_id`, `initial_volume`, `current_volume`, `aliquot_volume_unit`, `in_stock`, `in_stock_detail`, `study_summary_id`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `coord_x_order`, `storage_coord_y`, `coord_y_order`, `product_code`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'b1_tb1', 'tube', 2, 1, 1, NULL, '5.00000', '0.00000', 'ml', 'no', 'empty', 1, '2003-04-23 13:35:00', NULL, NULL, 0, NULL, NULL, NULL, NULL, '2010-05-28 16:02:21', 1, '2010-05-28 16:19:42', 1, 0, NULL),
(2, 'b1_tb2', 'tube', 2, 1, 1, NULL, '5.00000', '5.00000', 'ml', 'yes - available', '', 1, '2003-04-23 13:35:00', 7, '6', 5, '', NULL, NULL, '', '2010-05-28 16:02:23', 1, '2010-05-28 16:10:05', 1, 0, NULL),
(3, 'b1_tb3', 'tube', 2, 1, 1, NULL, '5.00000', '0.60000', 'ml', 'yes - available', '', 1, '2003-04-23 13:35:00', 7, '3', 2, '', NULL, NULL, NULL, '2010-05-28 16:02:24', 1, '2010-05-28 16:05:02', 1, 0, NULL),
(4, 'b1_wp1', 'whatman paper', 6, 1, 1, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, '2003-04-23 13:02:00', NULL, '', NULL, '', NULL, NULL, NULL, '2010-05-28 16:03:25', 1, '2010-05-28 16:03:25', 1, 0, NULL),
(5, 'pbmc2_tb1', 'tube', 15, 1, 2, NULL, '4.00000', '4.00000', 'ml', 'yes - available', '', NULL, '2003-04-23 18:31:00', 10, '4', 3, '', NULL, NULL, NULL, '2010-05-28 16:23:59', 1, '2010-05-28 16:23:59', 1, 0, NULL),
(6, 'pbmc2_tb2', 'tube', 15, 1, 2, NULL, '5.00000', '5.00000', 'ml', 'yes - available', '', NULL, '2003-04-23 18:31:00', 10, '5', 4, '', NULL, NULL, NULL, '2010-05-28 16:24:00', 1, '2010-05-28 16:24:00', 1, 0, NULL),
(7, 'dna1_tb1', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '12', 11, '', NULL, NULL, NULL, '2010-05-28 16:28:21', 1, '2010-05-28 16:28:21', 1, 0, NULL),
(8, 'dna1_tb2', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '13', 12, '', NULL, NULL, NULL, '2010-05-28 16:28:22', 1, '2010-05-28 16:28:22', 1, 0, NULL),
(9, 'dna1_tb3', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '14', 13, '', NULL, NULL, NULL, '2010-05-28 16:28:23', 1, '2010-05-28 16:28:23', 1, 0, NULL),
(10, 'dna1_tb4', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'no', 'shipped', NULL, '2010-05-04 02:03:00', NULL, NULL, 14, NULL, NULL, NULL, NULL, '2010-05-28 16:28:25', 1, '2010-05-28 16:33:45', 1, 0, NULL),
(11, 'dna1_tb5', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - not available', 'reserved for order', NULL, '2010-05-04 02:03:00', 7, '16', 15, '', NULL, NULL, NULL, '2010-05-28 16:28:26', 1, '2010-05-28 16:32:07', 1, 0, NULL),
(12, 'dna1_tb6', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '17', 16, '', NULL, NULL, NULL, '2010-05-28 16:28:27', 1, '2010-05-28 16:28:27', 1, 0, NULL),
(13, 'dna1_tb7', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '18', 17, '', NULL, NULL, NULL, '2010-05-28 16:28:28', 1, '2010-05-28 16:28:28', 1, 0, NULL),
(14, 'dna1_tb8', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '19', 18, '', NULL, NULL, NULL, '2010-05-28 16:28:29', 1, '2010-05-28 16:28:29', 1, 0, NULL),
(15, 'dna1_tb9', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '20', 19, '', NULL, NULL, NULL, '2010-05-28 16:28:30', 1, '2010-05-28 16:28:30', 1, 0, NULL);

--
-- Contenu de la table `aliquot_masters_revs`
--

INSERT INTO `aliquot_masters_revs` (`id`, `barcode`, `aliquot_type`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `sop_master_id`, `initial_volume`, `current_volume`, `aliquot_volume_unit`, `in_stock`, `in_stock_detail`, `study_summary_id`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `coord_x_order`, `storage_coord_y`, `coord_y_order`, `product_code`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 'b1_tb1', 'tube', 2, 1, 1, NULL, '5.00000', '5.00000', 'ml', 'yes - available', '', 1, '2003-04-23 13:35:00', 7, '1', 0, '', NULL, NULL, NULL, '2010-05-28 16:02:21', 1, '2010-05-28 16:02:21', 1, 1, '2010-05-28 16:02:22', 0, NULL),
(2, 'b1_tb2', 'tube', 2, 1, 1, NULL, '5.00000', '5.00000', 'ml', 'yes - available', '', 1, '2003-04-23 13:35:00', 7, '2', 1, '', NULL, NULL, NULL, '2010-05-28 16:02:23', 1, '2010-05-28 16:02:23', 1, 2, '2010-05-28 16:02:23', 0, NULL),
(3, 'b1_tb3', 'tube', 2, 1, 1, NULL, '5.00000', '5.00000', 'ml', 'yes - available', '', 1, '2003-04-23 13:35:00', 7, '3', 2, '', NULL, NULL, NULL, '2010-05-28 16:02:24', 1, '2010-05-28 16:02:24', 1, 3, '2010-05-28 16:02:24', 0, NULL),
(4, 'b1_wp1', 'whatman paper', 6, 1, 1, NULL, NULL, NULL, NULL, 'yes - available', '', NULL, '2003-04-23 13:02:00', NULL, '', NULL, '', NULL, NULL, NULL, '2010-05-28 16:03:25', 1, '2010-05-28 16:03:25', 1, 4, '2010-05-28 16:03:26', 0, NULL),
(3, 'b1_tb3', 'tube', 2, 1, 1, NULL, '5.00000', '0.00000', 'ml', 'yes - available', '', 1, '2003-04-23 13:35:00', 7, '3', 2, '', NULL, NULL, NULL, '2010-05-28 16:02:24', 1, '2010-05-28 16:04:31', 1, 5, '2010-05-28 16:04:32', 0, NULL),
(3, 'b1_tb3', 'tube', 2, 1, 1, NULL, '5.00000', '0.60000', 'ml', 'yes - available', '', 1, '2003-04-23 13:35:00', 7, '3', 2, '', NULL, NULL, NULL, '2010-05-28 16:02:24', 1, '2010-05-28 16:05:02', 1, 6, '2010-05-28 16:05:03', 0, NULL),
(2, 'b1_tb2', 'tube', 2, 1, 1, NULL, '5.00000', '5.00000', 'ml', 'yes - available', '', 1, '2003-04-23 13:35:00', 7, '6', 5, '', NULL, NULL, '', '2010-05-28 16:02:23', 1, '2010-05-28 16:10:04', 1, 7, '2010-05-28 16:10:05', 0, NULL),
(2, 'b1_tb2', 'tube', 2, 1, 1, NULL, '5.00000', '5.00000', 'ml', 'yes - available', '', 1, '2003-04-23 13:35:00', 7, '6', 5, '', NULL, NULL, '', '2010-05-28 16:02:23', 1, '2010-05-28 16:10:05', 1, 8, '2010-05-28 16:10:06', 0, NULL),
(1, 'b1_tb1', 'tube', 2, 1, 1, NULL, '5.00000', '5.00000', 'ml', 'no', 'empty', 1, '2003-04-23 13:35:00', NULL, NULL, 0, NULL, NULL, NULL, NULL, '2010-05-28 16:02:21', 1, '2010-05-28 16:19:40', 1, 9, '2010-05-28 16:19:41', 0, NULL),
(1, 'b1_tb1', 'tube', 2, 1, 1, NULL, '5.00000', '0.00000', 'ml', 'no', 'empty', 1, '2003-04-23 13:35:00', NULL, NULL, 0, NULL, NULL, NULL, NULL, '2010-05-28 16:02:21', 1, '2010-05-28 16:19:42', 1, 10, '2010-05-28 16:19:43', 0, NULL),
(5, 'pbmc2_tb1', 'tube', 15, 1, 2, NULL, '4.00000', '4.00000', 'ml', 'yes - available', '', NULL, '2003-04-23 18:31:00', 10, '4', 3, '', NULL, NULL, NULL, '2010-05-28 16:23:59', 1, '2010-05-28 16:23:59', 1, 11, '2010-05-28 16:24:00', 0, NULL),
(6, 'pbmc2_tb2', 'tube', 15, 1, 2, NULL, '5.00000', '5.00000', 'ml', 'yes - available', '', NULL, '2003-04-23 18:31:00', 10, '5', 4, '', NULL, NULL, NULL, '2010-05-28 16:24:00', 1, '2010-05-28 16:24:00', 1, 12, '2010-05-28 16:24:01', 0, NULL),
(7, 'dna1_tb1', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '12', 11, '', NULL, NULL, NULL, '2010-05-28 16:28:21', 1, '2010-05-28 16:28:21', 1, 13, '2010-05-28 16:28:22', 0, NULL),
(8, 'dna1_tb2', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '13', 12, '', NULL, NULL, NULL, '2010-05-28 16:28:22', 1, '2010-05-28 16:28:22', 1, 14, '2010-05-28 16:28:23', 0, NULL),
(9, 'dna1_tb3', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '14', 13, '', NULL, NULL, NULL, '2010-05-28 16:28:23', 1, '2010-05-28 16:28:23', 1, 15, '2010-05-28 16:28:24', 0, NULL),
(10, 'dna1_tb4', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '15', 14, '', NULL, NULL, NULL, '2010-05-28 16:28:25', 1, '2010-05-28 16:28:25', 1, 16, '2010-05-28 16:28:26', 0, NULL),
(11, 'dna1_tb5', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '16', 15, '', NULL, NULL, NULL, '2010-05-28 16:28:26', 1, '2010-05-28 16:28:26', 1, 17, '2010-05-28 16:28:27', 0, NULL),
(12, 'dna1_tb6', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '17', 16, '', NULL, NULL, NULL, '2010-05-28 16:28:27', 1, '2010-05-28 16:28:27', 1, 18, '2010-05-28 16:28:28', 0, NULL),
(13, 'dna1_tb7', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '18', 17, '', NULL, NULL, NULL, '2010-05-28 16:28:28', 1, '2010-05-28 16:28:28', 1, 19, '2010-05-28 16:28:28', 0, NULL),
(14, 'dna1_tb8', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '19', 18, '', NULL, NULL, NULL, '2010-05-28 16:28:29', 1, '2010-05-28 16:28:29', 1, 20, '2010-05-28 16:28:29', 0, NULL),
(15, 'dna1_tb9', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', NULL, '2010-05-04 02:03:00', 7, '20', 19, '', NULL, NULL, NULL, '2010-05-28 16:28:30', 1, '2010-05-28 16:28:30', 1, 21, '2010-05-28 16:28:30', 0, NULL),
(10, 'dna1_tb4', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - not available', 'reserved for order', NULL, '2010-05-04 02:03:00', 7, '15', 14, '', NULL, NULL, NULL, '2010-05-28 16:28:25', 1, '2010-05-28 16:31:11', 1, 22, '2010-05-28 16:31:12', 0, NULL),
(11, 'dna1_tb5', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'yes - not available', 'reserved for order', NULL, '2010-05-04 02:03:00', 7, '16', 15, '', NULL, NULL, NULL, '2010-05-28 16:28:26', 1, '2010-05-28 16:32:07', 1, 23, '2010-05-28 16:32:08', 0, NULL),
(10, 'dna1_tb4', 'tube', 11, 1, 3, NULL, '12.00000', '12.00000', 'ul', 'no', 'shipped', NULL, '2010-05-04 02:03:00', NULL, NULL, 14, NULL, NULL, NULL, NULL, '2010-05-28 16:28:25', 1, '2010-05-28 16:33:45', 1, 24, '2010-05-28 16:33:47', 0, NULL);

--
-- Contenu de la table `aliquot_uses`
--

INSERT INTO `aliquot_uses` (`id`, `aliquot_master_id`, `use_definition`, `use_code`, `use_details`, `use_recorded_into_table`, `used_volume`, `use_datetime`, `used_by`, `study_summary_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 3, 'realiquoted to', 'b1_tb2', '', 'realiquotings', '1.00000', '2003-04-23 13:35:00', 'custom_laboratory_staff_1', NULL, '2010-05-28 16:04:30', 1, '2010-05-28 16:05:01', 1, 0, NULL),
(2, 3, 'realiquoted to', 'b1_wp1', '', 'realiquotings', '3.40000', '2003-04-23 13:35:00', '', NULL, '2010-05-28 16:04:30', 1, '2010-05-28 16:04:30', 1, 0, NULL),
(3, 1, 'sample derivative creation', 'PBMC - 2', '', 'source_aliquots', '5.00000', '2003-04-23 17:18:00', '', NULL, '2010-05-28 16:19:41', 1, '2010-05-28 16:19:41', 1, 0, NULL),
(4, 10, 'aliquot shipment', 'UPS98409', '', 'order_items', NULL, '2010-05-31 13:04:00', 'custom_laboratory_staff_2', NULL, '2010-05-28 16:33:47', 1, '2010-05-28 16:33:47', 1, 0, NULL);

--
-- Contenu de la table `aliquot_uses_revs`
--

INSERT INTO `aliquot_uses_revs` (`id`, `aliquot_master_id`, `use_definition`, `use_code`, `use_details`, `use_recorded_into_table`, `used_volume`, `use_datetime`, `used_by`, `study_summary_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 3, 'realiquoted to', 'b1_tb2', '', 'realiquotings', '2.00000', '2003-04-23 13:35:00', 'custom_laboratory_staff_1', NULL, '2010-05-28 16:04:30', 1, '2010-05-28 16:04:30', 1, 1, '2010-05-28 16:04:30', 0, NULL),
(2, 3, 'realiquoted to', 'b1_wp1', '', 'realiquotings', '3.40000', '2003-04-23 13:35:00', '', NULL, '2010-05-28 16:04:30', 1, '2010-05-28 16:04:30', 1, 2, '2010-05-28 16:04:30', 0, NULL),
(1, 3, 'realiquoted to', 'b1_tb2', '', 'realiquotings', '1.00000', '2003-04-23 13:35:00', 'custom_laboratory_staff_1', NULL, '2010-05-28 16:04:30', 1, '2010-05-28 16:05:01', 1, 3, '2010-05-28 16:05:01', 0, NULL),
(3, 1, 'sample derivative creation', 'PBMC - 2', '', 'source_aliquots', '5.00000', '2003-04-23 17:18:00', '', NULL, '2010-05-28 16:19:41', 1, '2010-05-28 16:19:41', 1, 4, '2010-05-28 16:19:42', 0, NULL),
(4, 10, 'aliquot shipment', 'UPS98409', '', 'order_items', NULL, '2010-05-31 13:04:00', 'custom_laboratory_staff_2', NULL, '2010-05-28 16:33:47', 1, '2010-05-28 16:33:47', 1, 5, '2010-05-28 16:33:47', 0, NULL);

--
-- Contenu de la table `atim_information`
--


--
-- Contenu de la table `banks`
--

INSERT INTO `banks` (`id`, `name`, `description`, `created_by`, `created`, `modified_by`, `modified`, `deleted`, `deleted_date`) VALUES
(2, 'Ovary Bk', '', 1, '2010-05-28 10:47:46', 1, '2010-05-28 10:47:46', 0, NULL),
(3, 'Prostate Bk', '', 1, '2010-05-28 10:49:46', 1, '2010-05-28 10:49:46', 0, NULL);

--
-- Contenu de la table `banks_revs`
--

INSERT INTO `banks_revs` (`id`, `name`, `description`, `created_by`, `created`, `modified_by`, `modified`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(2, 'Ovary Bk', '', 1, '2010-05-28 10:47:46', 1, '2010-05-28 10:47:46', 0, NULL, 1, '2010-05-28 10:47:47'),
(3, 'Prostate Bk', '', 1, '2010-05-28 10:49:46', 1, '2010-05-28 10:49:46', 0, NULL, 2, '2010-05-28 10:49:46');

--
-- Contenu de la table `cd_nationals`
--

INSERT INTO `cd_nationals` (`id`, `consent_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, '2010-05-28 14:07:25', 1, '2010-05-28 14:07:25', 1, 0, NULL);

--
-- Contenu de la table `cd_nationals_revs`
--

INSERT INTO `cd_nationals_revs` (`id`, `consent_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, 1, '2010-05-28 14:07:25', 1, '2010-05-28 14:07:25', 1, 0, NULL, 1, '2010-05-28 14:07:25');

--
-- Contenu de la table `clinical_collection_links`
--

INSERT INTO `clinical_collection_links` (`id`, `participant_id`, `collection_id`, `diagnosis_master_id`, `consent_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 1, 2, 1, '2010-05-28 14:34:39', 1, '2010-05-28 14:34:39', 1, 0, NULL);

--
-- Contenu de la table `clinical_collection_links_revs`
--

INSERT INTO `clinical_collection_links_revs` (`id`, `participant_id`, `collection_id`, `diagnosis_master_id`, `consent_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, NULL, 2, 1, '2010-05-28 14:34:39', 1, '2010-05-28 14:34:39', 1, 1, '2010-05-28 14:34:40', 1, NULL),
(1, 1, 1, 2, 1, '2010-05-28 14:34:39', 1, '2010-05-28 14:34:39', 1, 2, '2010-05-28 14:35:51', 0, NULL);

--
-- Contenu de la table `coding_adverse_events`
--


--
-- Contenu de la table `coding_adverse_events_revs`
--


--
-- Contenu de la table `collections`
--

INSERT INTO `collections` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'OV_9874_20030423', 2, 'collection_site_1', '2003-04-23 09:08:00', '', 1, 'participant collection', '', '2010-05-28 14:35:51', 1, '2010-05-28 14:35:51', 1, 0, NULL);

--
-- Contenu de la table `collections_revs`
--

INSERT INTO `collections_revs` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 'OV_9874_20030423', 2, 'collection_site_1', '2003-04-23 09:08:00', '', 1, 'participant collection', '', '2010-05-28 14:35:51', 1, '2010-05-28 14:35:51', 1, 1, '2010-05-28 14:35:51', 0, NULL);

--
-- Contenu de la table `consent_masters`
--

INSERT INTO `consent_masters` (`id`, `date_of_referral`, `route_of_referral`, `date_first_contact`, `consent_signed_date`, `form_version`, `reason_denied`, `consent_status`, `process_status`, `status_date`, `surgeon`, `operation_date`, `facility`, `notes`, `consent_method`, `translator_indicator`, `translator_signature`, `consent_person`, `facility_other`, `consent_master_id`, `acquisition_id`, `participant_id`, `consent_control_id`, `type`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, NULL, 'doctor', '2003-05-06', '2003-08-06', '2.90', '', 'obtained', '', '2003-08-06', '', NULL, '', '', 'in person', 'no', '', '', '', NULL, NULL, 1, 1, '', '2010-05-28 14:07:24', 1, '2010-05-28 14:07:24', 1, 0, NULL);

--
-- Contenu de la table `consent_masters_revs`
--

INSERT INTO `consent_masters_revs` (`id`, `date_of_referral`, `route_of_referral`, `date_first_contact`, `consent_signed_date`, `form_version`, `reason_denied`, `consent_status`, `process_status`, `status_date`, `surgeon`, `operation_date`, `facility`, `notes`, `consent_method`, `translator_indicator`, `translator_signature`, `consent_person`, `facility_other`, `consent_master_id`, `acquisition_id`, `participant_id`, `consent_control_id`, `type`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, NULL, 'doctor', '2003-05-06', '2003-08-06', '2.90', '', 'obtained', '', '2003-08-06', '', NULL, '', '', 'in person', 'no', '', '', '', NULL, NULL, 1, 1, '', '2010-05-28 14:07:24', 1, '2010-05-28 14:07:24', 1, 0, NULL, 1, '2010-05-28 14:07:25');

--
-- Contenu de la table `datamart_adhoc`
--


--
-- Contenu de la table `datamart_adhoc_favourites`
--


--
-- Contenu de la table `datamart_adhoc_saved`
--


--
-- Contenu de la table `datamart_batch_ids`
--


--
-- Contenu de la table `datamart_batch_processes`
--


--
-- Contenu de la table `datamart_batch_sets`
--


--
-- Contenu de la table `derivative_details`
--

INSERT INTO `derivative_details` (`id`, `sample_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 2, '', '', '2003-04-23 17:18:00', '2010-05-28 16:18:14', 1, '2010-05-28 16:18:56', 1, 0, NULL),
(2, 3, '', '', '2010-05-04 02:03:00', '2010-05-28 16:24:54', 1, '2010-05-28 16:24:54', 1, 0, NULL);

--
-- Contenu de la table `derivative_details_revs`
--

INSERT INTO `derivative_details_revs` (`id`, `sample_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 2, '', '', '2003-05-23 17:18:00', '2010-05-28 16:18:14', 1, '2010-05-28 16:18:14', 1, 1, '2010-05-28 16:18:14', 0, NULL),
(1, 2, '', '', '2003-04-23 17:18:00', '2010-05-28 16:18:14', 1, '2010-05-28 16:18:56', 1, 2, '2010-05-28 16:18:56', 0, NULL),
(2, 3, '', '', '2010-05-04 02:03:00', '2010-05-28 16:24:54', 1, '2010-05-28 16:24:54', 1, 3, '2010-05-28 16:24:54', 0, NULL);

--
-- Contenu de la table `diagnosis_masters`
--

INSERT INTO `diagnosis_masters` (`id`, `dx_identifier`, `primary_number`, `dx_method`, `dx_nature`, `dx_origin`, `dx_date`, `dx_date_accuracy`, `primary_icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `morphology`, `topography`, `tumour_grade`, `age_at_dx`, `age_at_dx_accuracy`, `ajcc_edition`, `collaborative_staged`, `clinical_tstage`, `clinical_nstage`, `clinical_mstage`, `clinical_stage_summary`, `path_tstage`, `path_nstage`, `path_mstage`, `path_stage_summary`, `survival_time_months`, `information_source`, `notes`, `diagnosis_control_id`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, NULL, 1, 'radiology', 'malignant', 'primary', '2001-03-05', 'm', 'C50.1', '', '', '', '', 'well differentiated', NULL, '', '5th', 'yes', 'IV', '', '', 'IV', 'IA', '', '', '', NULL, '', '', 2, 1, '2010-05-28 14:09:11', 1, '2010-05-28 14:12:54', 1, 0, NULL),
(2, NULL, 1, 'cytology', 'malignant', 'secondary', '2003-02-01', '', 'C50.9', '', '', '', '', 'well differentiated', NULL, '', '', '', '', '', '', '', '', '', '', '', NULL, '', '', 2, 1, '2010-05-28 14:11:42', 1, '2010-05-28 14:11:42', 1, 0, NULL),
(3, NULL, 2, '', 'malignant', 'primary', '2002-06-13', '', 'C53.0', '', '', '', '', '', NULL, '', '', '', '', '', '', '', '', '', '', '', NULL, '', '', 2, 1, '2010-05-28 14:14:39', 1, '2010-05-28 14:14:39', 1, 0, NULL);

--
-- Contenu de la table `diagnosis_masters_revs`
--

INSERT INTO `diagnosis_masters_revs` (`id`, `dx_identifier`, `primary_number`, `dx_method`, `dx_nature`, `dx_origin`, `dx_date`, `dx_date_accuracy`, `primary_icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `morphology`, `topography`, `tumour_grade`, `age_at_dx`, `age_at_dx_accuracy`, `ajcc_edition`, `collaborative_staged`, `clinical_tstage`, `clinical_nstage`, `clinical_mstage`, `clinical_stage_summary`, `path_tstage`, `path_nstage`, `path_mstage`, `path_stage_summary`, `survival_time_months`, `information_source`, `notes`, `diagnosis_control_id`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, NULL, NULL, 'radiology', 'malignant', 'primary', '2001-03-05', 'm', 'C16.6', '', '', '', '', 'well differentiated', NULL, '', '5th', 'yes', 'IV', '', '', 'IV', 'IA', '', '', '', NULL, '', '', 2, 1, '2010-05-28 14:09:11', 1, '2010-05-28 14:09:11', 1, 0, NULL, 1, '2010-05-28 14:09:12'),
(1, NULL, NULL, 'radiology', 'malignant', 'primary', '2001-03-05', 'm', 'C50.1', '', '', '', '', 'well differentiated', NULL, '', '5th', 'yes', 'IV', '', '', 'IV', 'IA', '', '', '', NULL, '', '', 2, 1, '2010-05-28 14:09:11', 1, '2010-05-28 14:10:26', 1, 0, NULL, 2, '2010-05-28 14:10:27'),
(2, NULL, 1, 'cytology', 'malignant', 'secondary', '2003-02-01', '', 'C50.9', '', '', '', '', 'well differentiated', NULL, '', '', '', '', '', '', '', '', '', '', '', NULL, '', '', 2, 1, '2010-05-28 14:11:42', 1, '2010-05-28 14:11:42', 1, 0, NULL, 3, '2010-05-28 14:11:43'),
(1, NULL, 1, 'radiology', 'malignant', 'primary', '2001-03-05', 'm', 'C50.1', '', '', '', '', 'well differentiated', NULL, '', '5th', 'yes', 'IV', '', '', 'IV', 'IA', '', '', '', NULL, '', '', 2, 1, '2010-05-28 14:09:11', 1, '2010-05-28 14:12:54', 1, 0, NULL, 4, '2010-05-28 14:12:55'),
(3, NULL, 2, '', 'malignant', 'primary', '2002-06-13', '', 'C53.0', '', '', '', '', '', NULL, '', '', '', '', '', '', '', '', '', '', '', NULL, '', '', 2, 1, '2010-05-28 14:14:39', 1, '2010-05-28 14:14:39', 1, 0, NULL, 5, '2010-05-28 14:14:40');

--
-- Contenu de la table `drugs`
--

INSERT INTO `drugs` (`id`, `generic_name`, `trade_name`, `type`, `description`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, '5FU', '', 'chemotherapy', '', '2010-05-28 11:18:39', 1, '2010-05-28 11:18:39', 1, 0, NULL),
(2, 'Doxorubicine', '', 'chemotherapy', '', '2010-05-28 11:21:42', 1, '2010-05-28 11:21:42', 1, 0, NULL),
(3, 'Tamoxifene', '', 'hormonal', '', '2010-05-28 11:23:41', 1, '2010-05-28 11:23:41', 1, 0, NULL);

--
-- Contenu de la table `drugs_revs`
--

INSERT INTO `drugs_revs` (`id`, `generic_name`, `trade_name`, `type`, `description`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '5FU', '', 'chemotherapy', '', '2010-05-28 11:18:39', 1, '2010-05-28 11:18:39', 1, 1, '2010-05-28 11:18:39', 0, NULL),
(2, 'Doxorubicine', '', 'chemotherapy', '', '2010-05-28 11:21:42', 1, '2010-05-28 11:21:42', 1, 2, '2010-05-28 11:21:43', 0, NULL),
(3, 'Tamoxifene', '', 'hormonal', '', '2010-05-28 11:23:41', 1, '2010-05-28 11:23:41', 1, 3, '2010-05-28 11:23:41', 0, NULL);

--
-- Contenu de la table `dxd_bloods`
--


--
-- Contenu de la table `dxd_bloods_revs`
--


--
-- Contenu de la table `dxd_tissues`
--

INSERT INTO `dxd_tissues` (`id`, `diagnosis_master_id`, `laterality`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 'left', '2010-05-28 14:09:12', 1, '2010-05-28 14:12:55', 1, 0, NULL),
(2, 2, 'left', '2010-05-28 14:11:43', 1, '2010-05-28 14:11:43', 1, 0, NULL),
(3, 3, '', '2010-05-28 14:14:40', 1, '2010-05-28 14:14:40', 1, 0, NULL);

--
-- Contenu de la table `dxd_tissues_revs`
--

INSERT INTO `dxd_tissues_revs` (`id`, `diagnosis_master_id`, `laterality`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, 1, 'left', '2010-05-28 14:09:12', 1, '2010-05-28 14:09:12', 1, 0, NULL, 1, '2010-05-28 14:09:12'),
(1, 1, 'left', '2010-05-28 14:09:12', 1, '2010-05-28 14:10:27', 1, 0, NULL, 2, '2010-05-28 14:10:27'),
(2, 2, 'left', '2010-05-28 14:11:43', 1, '2010-05-28 14:11:43', 1, 0, NULL, 3, '2010-05-28 14:11:43'),
(1, 1, 'left', '2010-05-28 14:09:12', 1, '2010-05-28 14:12:55', 1, 0, NULL, 4, '2010-05-28 14:12:55'),
(3, 3, '', '2010-05-28 14:14:40', 1, '2010-05-28 14:14:40', 1, 0, NULL, 5, '2010-05-28 14:14:40');

--
-- Contenu de la table `ed_all_adverse_events_adverse_event`
--


--
-- Contenu de la table `ed_all_adverse_events_adverse_event_revs`
--


--
-- Contenu de la table `ed_all_clinical_followup`
--


--
-- Contenu de la table `ed_all_clinical_followup_revs`
--


--
-- Contenu de la table `ed_all_clinical_presentation`
--

INSERT INTO `ed_all_clinical_presentation` (`id`, `weight`, `height`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`, `deleted`, `deleted_date`) VALUES
(1, '63.00', '1.00', '2010-05-28 14:16:50', 1, '2010-05-28 14:16:50', 1, 1, 0, NULL);

--
-- Contenu de la table `ed_all_clinical_presentation_revs`
--

INSERT INTO `ed_all_clinical_presentation_revs` (`id`, `weight`, `height`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '63.00', '1.00', '2010-05-28 14:16:50', 1, '2010-05-28 14:16:50', 1, 1, 1, '2010-05-28 14:16:50', 0, NULL);

--
-- Contenu de la table `ed_all_lifestyle_smoking`
--

INSERT INTO `ed_all_lifestyle_smoking` (`id`, `smoking_history`, `smoking_status`, `pack_years`, `product_used`, `years_quit_smoking`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`, `deleted`, `deleted_date`) VALUES
(1, 'yes', 'ex-smoker', 36, 'cigarettes', 4, '2010-05-28 14:20:24', 1, '2010-05-28 14:20:24', 1, 2, 0, NULL);

--
-- Contenu de la table `ed_all_lifestyle_smoking_revs`
--

INSERT INTO `ed_all_lifestyle_smoking_revs` (`id`, `smoking_history`, `smoking_status`, `pack_years`, `product_used`, `years_quit_smoking`, `created`, `created_by`, `modified`, `modified_by`, `event_master_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 'yes', 'ex-smoker', 36, 'cigarettes', 4, '2010-05-28 14:20:24', 1, '2010-05-28 14:20:24', 1, 2, 1, '2010-05-28 14:20:25', 0, NULL);

--
-- Contenu de la table `ed_all_protocol_followup`
--


--
-- Contenu de la table `ed_all_protocol_followup_revs`
--


--
-- Contenu de la table `ed_all_study_research`
--


--
-- Contenu de la table `ed_all_study_research_revs`
--


--
-- Contenu de la table `ed_breast_lab_pathology`
--


--
-- Contenu de la table `ed_breast_lab_pathology_revs`
--


--
-- Contenu de la table `ed_breast_screening_mammogram`
--


--
-- Contenu de la table `ed_breast_screening_mammogram_revs`
--


--
-- Contenu de la table `event_masters`
--

INSERT INTO `event_masters` (`id`, `event_control_id`, `disease_site`, `event_group`, `event_type`, `event_status`, `event_summary`, `event_date`, `information_source`, `urgency`, `date_required`, `date_requested`, `reference_number`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`, `diagnosis_master_id`, `deleted`, `deleted_date`) VALUES
(1, 22, 'all', 'clinical', 'presentation', NULL, '', '2003-02-10', NULL, NULL, NULL, NULL, NULL, '2010-05-28 14:16:49', 1, '2010-05-28 14:16:49', 1, 1, 2, 0, NULL),
(2, 30, 'all', 'lifestyle', 'smoking', NULL, '', '2003-03-08', NULL, NULL, NULL, NULL, NULL, '2010-05-28 14:20:24', 1, '2010-05-28 14:20:24', 1, 1, 2, 0, NULL);

--
-- Contenu de la table `event_masters_revs`
--

INSERT INTO `event_masters_revs` (`id`, `event_control_id`, `disease_site`, `event_group`, `event_type`, `event_status`, `event_summary`, `event_date`, `information_source`, `urgency`, `date_required`, `date_requested`, `reference_number`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`, `diagnosis_master_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 22, 'all', 'clinical', 'presentation', NULL, '', '2003-02-10', NULL, NULL, NULL, NULL, NULL, '2010-05-28 14:16:49', 1, '2010-05-28 14:16:49', 1, 1, 2, 1, '2010-05-28 14:16:50', 0, NULL),
(2, 30, 'all', 'lifestyle', 'smoking', NULL, '', '2003-03-08', NULL, NULL, NULL, NULL, NULL, '2010-05-28 14:20:24', 1, '2010-05-28 14:20:24', 1, 1, 2, 2, '2010-05-28 14:20:25', 0, NULL);

--
-- Contenu de la table `family_histories`
--

INSERT INTO `family_histories` (`id`, `relation`, `family_domain`, `primary_icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `age_at_dx`, `age_at_dx_accuracy`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'mother', 'maternal', 'C50.4', '', '', NULL, '', 1, '2010-05-28 14:28:12', 1, '2010-05-28 14:28:12', 1, 0, NULL);

--
-- Contenu de la table `family_histories_revs`
--

INSERT INTO `family_histories_revs` (`id`, `relation`, `family_domain`, `primary_icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `age_at_dx`, `age_at_dx_accuracy`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, 'mother', 'maternal', 'C50.4', '', '', NULL, '', 1, '2010-05-28 14:28:12', 1, '2010-05-28 14:28:12', 1, 0, NULL, 1, '2010-05-28 14:28:13');

--
-- Contenu de la table `key_increments`
--

INSERT INTO `key_increments` (`key_name`, `key_value`) VALUES
('ovary bank no lab', 4564),
('prostate bank no lab', 501020);

--
-- Contenu de la table `langs`
--


--
-- Contenu de la table `materials`
--


--
-- Contenu de la table `materials_revs`
--


--
-- Contenu de la table `misc_identifiers`
--

INSERT INTO `misc_identifiers` (`id`, `identifier_value`, `misc_identifier_control_id`, `identifier_name`, `identifier_abrv`, `effective_date`, `expiry_date`, `notes`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'OV_4563', 1, 'ovary bank no lab', 'OV#', '2003-03-26', NULL, '', 1, '2010-05-28 14:55:04', 1, '2010-05-28 14:55:58', 1, 0, NULL),
(2, 'xccz', 13, 'other center no labr', 'OTHER#', NULL, NULL, '', 1, '2010-05-28 14:56:44', 1, '2010-05-28 14:56:44', 1, 0, NULL);

--
-- Contenu de la table `misc_identifiers_revs`
--

INSERT INTO `misc_identifiers_revs` (`id`, `identifier_value`, `misc_identifier_control_id`, `identifier_name`, `identifier_abrv`, `effective_date`, `expiry_date`, `notes`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, 'OV_4563', 1, 'ovary bank no lab', 'OV#', NULL, NULL, '', 1, '2010-05-28 14:55:04', 1, '2010-05-28 14:55:04', 1, 0, NULL, 1, '2010-05-28 14:55:04'),
(1, 'OV_4563', 1, 'ovary bank no lab', 'OV#', '2003-03-26', NULL, '', 1, '2010-05-28 14:55:04', 1, '2010-05-28 14:55:58', 1, 0, NULL, 2, '2010-05-28 14:55:58'),
(2, 'xccz', 13, 'other center no labr', 'OTHER#', NULL, NULL, '', 1, '2010-05-28 14:56:44', 1, '2010-05-28 14:56:44', 1, 0, NULL, 3, '2010-05-28 14:56:44');

--
-- Contenu de la table `misc_identifier_controls`
--

INSERT INTO `misc_identifier_controls` (`id`, `misc_identifier_name`, `misc_identifier_name_abbrev`, `flag_active`, `display_order`, `autoincrement_name`, `misc_identifier_format`, `flag_once_per_participant`) VALUES
(1, 'ovary bank no lab', 'OV#', 1, 1, 'ovary bank no lab', 'OV_%%key_increment%%', 1),
(5, 'prostate bank no lab', 'PR#', 1, 5, 'prostate bank no lab', 'P%%key_increment%%_BR_03', 1),
(7, 'health card nbr', 'HC', 1, 10, '', '', 1),
(8, 'hospital nbr', 'HOSP', 1, 21, '', '', 0),
(13, 'other center no labr', 'OTHER#', 1, 31, '', '', 0);

--
-- Contenu de la table `missing_translations`
--

--
-- Contenu de la table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `short_title`, `description`, `date_order_placed`, `date_order_completed`, `processing_status`, `comments`, `created`, `created_by`, `modified`, `modified_by`, `study_summary_id`, `deleted`, `deleted_date`) VALUES
(1, 'CD09848', '', '', '2010-06-01', NULL, 'pending', '', '2010-05-28 16:29:37', 1, '2010-05-28 16:29:37', 1, 1, 0, NULL);

--
-- Contenu de la table `orders_revs`
--

INSERT INTO `orders_revs` (`id`, `order_number`, `short_title`, `description`, `date_order_placed`, `date_order_completed`, `processing_status`, `comments`, `created`, `created_by`, `modified`, `modified_by`, `study_summary_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 'CD09848', '', '', '2010-06-01', NULL, 'pending', '', '2010-05-28 16:29:37', 1, '2010-05-28 16:29:37', 1, 1, 1, '2010-05-28 16:29:38', 0, NULL);

--
-- Contenu de la table `order_items`
--

INSERT INTO `order_items` (`id`, `date_added`, `added_by`, `status`, `created`, `created_by`, `modified`, `modified_by`, `order_line_id`, `shipment_id`, `aliquot_master_id`, `aliquot_use_id`, `deleted`, `deleted_date`) VALUES
(1, '2010-05-29', 'custom_laboratory_staff_2', 'shipped', '2010-05-28 16:31:11', 1, '2010-05-28 16:33:47', 1, 1, 1, 10, 4, 0, NULL),
(2, '2010-05-29', 'custom_laboratory_staff_2', 'pending', '2010-05-28 16:32:06', 1, '2010-05-28 16:32:28', 1, 1, NULL, 11, NULL, 0, NULL);

--
-- Contenu de la table `order_items_revs`
--

INSERT INTO `order_items_revs` (`id`, `date_added`, `added_by`, `status`, `created`, `created_by`, `modified`, `modified_by`, `order_line_id`, `shipment_id`, `aliquot_master_id`, `aliquot_use_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '2010-05-29', 'custom_laboratory_staff_2', 'pending', '2010-05-28 16:31:11', 1, '2010-05-28 16:31:11', 1, 1, NULL, 10, NULL, 1, '2010-05-28 16:31:11', 0, NULL),
(2, NULL, '', 'pending', '2010-05-28 16:32:06', 1, '2010-05-28 16:32:06', 1, 1, NULL, 11, NULL, 2, '2010-05-28 16:32:06', 0, NULL),
(1, '2010-05-29', 'custom_laboratory_staff_2', 'pending', '2010-05-28 16:31:11', 1, '2010-05-28 16:32:28', 1, 1, NULL, 10, NULL, 3, '2010-05-28 16:32:28', 0, NULL),
(2, '2010-05-29', 'custom_laboratory_staff_2', 'pending', '2010-05-28 16:32:06', 1, '2010-05-28 16:32:28', 1, 1, NULL, 11, NULL, 4, '2010-05-28 16:32:28', 0, NULL),
(1, '2010-05-29', 'custom_laboratory_staff_2', 'shipped', '2010-05-28 16:31:11', 1, '2010-05-28 16:33:47', 1, 1, 1, 10, 4, 5, '2010-05-28 16:33:47', 0, NULL);

--
-- Contenu de la table `order_lines`
--

INSERT INTO `order_lines` (`id`, `quantity_ordered`, `min_quantity_ordered`, `quantity_unit`, `date_required`, `status`, `created`, `created_by`, `modified`, `modified_by`, `product_code`, `sample_control_id`, `aliquot_control_id`, `sample_aliquot_precision`, `order_id`, `deleted`, `deleted_date`) VALUES
(1, '23', '', 'ml', NULL, 'pending', '2010-05-28 16:30:23', 1, '2010-05-28 16:32:06', 1, '', 12, 11, 'PBMC', 1, 0, NULL),
(2, '3', '', 'ml', NULL, 'pending', '2010-05-28 16:30:42', 1, '2010-05-28 16:30:42', 1, '', 119, 8, '', 1, 0, NULL);

--
-- Contenu de la table `order_lines_revs`
--

INSERT INTO `order_lines_revs` (`id`, `quantity_ordered`, `min_quantity_ordered`, `quantity_unit`, `date_required`, `status`, `created`, `created_by`, `modified`, `modified_by`, `product_code`, `sample_control_id`, `aliquot_control_id`, `sample_aliquot_precision`, `order_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '23', '', 'ml', NULL, 'pending', '2010-05-28 16:30:23', 1, '2010-05-28 16:30:23', 1, '', 12, 11, 'PBMC', 1, 1, '2010-05-28 16:30:23', 0, NULL),
(2, '3', '', 'ml', NULL, 'pending', '2010-05-28 16:30:42', 1, '2010-05-28 16:30:42', 1, '', 119, 8, '', 1, 2, '2010-05-28 16:30:42', 0, NULL),
(1, '23', '', 'ml', NULL, 'pending', '2010-05-28 16:30:23', 1, '2010-05-28 16:31:13', 1, '', 12, 11, 'PBMC', 1, 3, '2010-05-28 16:31:13', 0, NULL),
(1, '23', '', 'ml', NULL, 'pending', '2010-05-28 16:30:23', 1, '2010-05-28 16:32:06', 1, '', 12, 11, 'PBMC', 1, 4, '2010-05-28 16:32:07', 0, NULL);

--
-- Contenu de la table `participants`
--

INSERT INTO `participants` (`id`, `title`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `dob_date_accuracy`, `marital_status`, `language_preferred`, `sex`, `race`, `vital_status`, `notes`, `date_of_death`, `dod_date_accuracy`, `cod_icd10_code`, `secondary_cod_icd10_code`, `cod_confirmation_source`, `participant_identifier`, `last_chart_checked_date`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'Ms.', 'Wonder', '', 'Woman', '1947-11-03', 'm', '', '', 'f', '', 'dead', '', '2008-03-06', 'd', 'C00.2', NULL, '', 'wwi80', '2010-05-05', '2010-05-28 13:59:42', 1, '2010-05-28 14:31:50', 1, 0, NULL);

--
-- Contenu de la table `participants_revs`
--

INSERT INTO `participants_revs` (`id`, `title`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `dob_date_accuracy`, `marital_status`, `language_preferred`, `sex`, `race`, `vital_status`, `notes`, `date_of_death`, `dod_date_accuracy`, `cod_icd10_code`, `secondary_cod_icd10_code`, `cod_confirmation_source`, `participant_identifier`, `last_chart_checked_date`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, 'Ms.', 'Wonder', 'Woman', '', '1947-11-03', 'm', '', '', 'f', '', 'dead', '', '2008-03-06', 'd', 'C00.2', NULL, '', 'wwi80', '2010-05-05', '2010-05-28 13:59:42', 1, '2010-05-28 13:59:42', 1, 0, NULL, 1, '2010-05-28 13:59:42'),
(1, 'Ms.', 'Wonder', '', 'Woman', '1947-11-03', 'm', '', '', 'f', '', 'dead', '', '2008-03-06', 'd', 'C00.2', NULL, '', 'wwi80', '2010-05-05', '2010-05-28 13:59:42', 1, '2010-05-28 14:31:50', 1, 0, NULL, 2, '2010-05-28 14:31:51');

--
-- Contenu de la table `participant_contacts`
--

INSERT INTO `participant_contacts` (`id`, `contact_name`, `contact_type`, `other_contact_type`, `effective_date`, `expiry_date`, `notes`, `street`, `locality`, `region`, `country`, `mail_code`, `phone`, `phone_type`, `phone_secondary`, `phone_secondary_type`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`, `deleted`, `deleted_date`) VALUES
(1, '', 'home', '', NULL, NULL, '', 'wall street', 'NY', '', '', '', '200 099 0879', 'residential', '', '', '2010-05-28 14:30:23', 1, '2010-05-28 14:30:23', 1, 1, 0, NULL);

--
-- Contenu de la table `participant_contacts_revs`
--

INSERT INTO `participant_contacts_revs` (`id`, `contact_name`, `contact_type`, `other_contact_type`, `effective_date`, `expiry_date`, `notes`, `street`, `locality`, `region`, `country`, `mail_code`, `phone`, `phone_type`, `phone_secondary`, `phone_secondary_type`, `created`, `created_by`, `modified`, `modified_by`, `participant_id`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, '', 'home', '', NULL, NULL, '', 'wall street', 'NY', '', '', '', '200 099 0879', 'residential', '', '', '2010-05-28 14:30:23', 1, '2010-05-28 14:30:23', 1, 1, 0, NULL, 1, '2010-05-28 14:30:23');

--
-- Contenu de la table `participant_messages`
--


--
-- Contenu de la table `participant_messages_revs`
--


--
-- Contenu de la table `path_collection_reviews`
--


--
-- Contenu de la table `path_collection_reviews_revs`
--


--
-- Contenu de la table `pd_chemos`
--

INSERT INTO `pd_chemos` (`id`, `created`, `created_by`, `modified`, `modified_by`, `protocol_master_id`, `deleted`, `deleted_date`) VALUES
(1, '2010-05-28 11:25:19', 1, '2010-05-28 11:25:19', 1, 1, 0, NULL);

--
-- Contenu de la table `pd_chemos_revs`
--

INSERT INTO `pd_chemos_revs` (`id`, `created`, `created_by`, `modified`, `modified_by`, `protocol_master_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '2010-05-28 11:25:19', 1, '2010-05-28 11:25:19', 1, 1, 1, '2010-05-28 11:25:19', 0, NULL);

--
-- Contenu de la table `pe_chemos`
--

INSERT INTO `pe_chemos` (`id`, `method`, `dose`, `frequency`, `created`, `created_by`, `modified`, `modified_by`, `protocol_master_id`, `drug_id`, `deleted`, `deleted_date`) VALUES
(1, 'IV: Intravenous', '34', '2', '2010-05-28 11:27:45', 1, '2010-05-28 11:27:45', 1, 1, 1, 0, NULL),
(2, 'IV: Intravenous', '', '', '2010-05-28 11:28:04', 1, '2010-05-28 11:28:04', 1, 1, 3, 0, NULL);

--
-- Contenu de la table `pe_chemos_revs`
--


--
-- Contenu de la table `protocol_masters`
--

INSERT INTO `protocol_masters` (`id`, `protocol_control_id`, `name`, `notes`, `code`, `arm`, `tumour_group`, `type`, `status`, `expiry`, `activated`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `deleted`, `deleted_date`) VALUES
(1, 1, 'Watson th', '', 'Prot-4577', '1', 'all', 'chemotherapy', NULL, NULL, NULL, '2010-05-28 11:25:19', 1, '2010-05-28 11:25:19', 1, NULL, 0, NULL);

--
-- Contenu de la table `protocol_masters_revs`
--

INSERT INTO `protocol_masters_revs` (`id`, `protocol_control_id`, `name`, `notes`, `code`, `arm`, `tumour_group`, `type`, `status`, `expiry`, `activated`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, 'Watson th', '', 'Prot-4577', '1', 'all', 'chemotherapy', NULL, NULL, NULL, '2010-05-28 11:25:19', 1, '2010-05-28 11:25:19', 1, NULL, 1, '2010-05-28 11:25:19', 0, NULL);

--
-- Contenu de la table `providers`
--


--
-- Contenu de la table `providers_revs`
--


--
-- Contenu de la table `quality_ctrls`
--


--
-- Contenu de la table `quality_ctrls_revs`
--


--
-- Contenu de la table `quality_ctrl_tested_aliquots`
--


--
-- Contenu de la table `quality_ctrl_tested_aliquots_revs`
--


--
-- Contenu de la table `rd_bloodcellcounts`
--


--
-- Contenu de la table `rd_bloodcellcounts_revs`
--


--
-- Contenu de la table `rd_blood_cells`
--


--
-- Contenu de la table `rd_blood_cells_revs`
--


--
-- Contenu de la table `rd_breastcancertypes`
--


--
-- Contenu de la table `rd_breastcancertypes_revs`
--


--
-- Contenu de la table `rd_breast_cancers`
--


--
-- Contenu de la table `rd_breast_cancers_revs`
--


--
-- Contenu de la table `rd_coloncancertypes`
--


--
-- Contenu de la table `rd_coloncancertypes_revs`
--


--
-- Contenu de la table `rd_genericcancertypes`
--


--
-- Contenu de la table `rd_genericcancertypes_revs`
--


--
-- Contenu de la table `rd_ovarianuteruscancertypes`
--


--
-- Contenu de la table `rd_ovarianuteruscancertypes_revs`
--


--
-- Contenu de la table `realiquotings`
--

INSERT INTO `realiquotings` (`id`, `parent_aliquot_master_id`, `child_aliquot_master_id`, `aliquot_use_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 3, 2, 1, '2010-05-28 16:04:30', 1, '2010-05-28 16:04:30', 1, 0, NULL),
(2, 3, 4, 2, '2010-05-28 16:04:30', 1, '2010-05-28 16:04:30', 1, 0, NULL);

--
-- Contenu de la table `realiquotings_revs`
--

INSERT INTO `realiquotings_revs` (`id`, `parent_aliquot_master_id`, `child_aliquot_master_id`, `aliquot_use_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 3, 2, 1, '2010-05-28 16:04:30', 1, '2010-05-28 16:04:30', 1, 1, '2010-05-28 16:04:30', 0, NULL),
(2, 3, 4, 2, '2010-05-28 16:04:30', 1, '2010-05-28 16:04:30', 1, 2, '2010-05-28 16:04:31', 0, NULL);

--
-- Contenu de la table `reproductive_histories`
--


--
-- Contenu de la table `reproductive_histories_revs`
--


--
-- Contenu de la table `review_masters`
--


--
-- Contenu de la table `review_masters_revs`
--


--
-- Contenu de la table `rtbforms`
--


--
-- Contenu de la table `rtbforms_revs`
--


--
-- Contenu de la table `sample_masters`
--

INSERT INTO `sample_masters` (`id`, `sample_code`, `sample_category`, `sample_control_id`, `sample_type`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `sop_master_id`, `product_code`, `is_problematic`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'B - 1', 'specimen', 2, 'blood', 1, 'blood', 1, NULL, NULL, NULL, 'no', '', '2010-05-28 15:58:56', 1, '2010-05-28 15:59:43', 1, 0, NULL),
(2, 'PBMC - 2', 'derivative', 8, 'pbmc', 1, 'blood', 1, 1, NULL, NULL, 'no', '', '2010-05-28 16:18:12', 1, '2010-05-28 16:18:55', 1, 0, NULL),
(3, 'DNA - 3', 'derivative', 12, 'dna', 1, 'blood', 1, 2, NULL, NULL, 'no', '', '2010-05-28 16:24:52', 1, '2010-05-28 16:24:53', 1, 0, NULL);

--
-- Contenu de la table `sample_masters_revs`
--

INSERT INTO `sample_masters_revs` (`id`, `sample_code`, `sample_category`, `sample_control_id`, `sample_type`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `sop_master_id`, `product_code`, `is_problematic`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '', 'specimen', 2, 'blood', NULL, 'blood', 1, NULL, NULL, NULL, 'no', '', '2010-05-28 15:58:56', 1, '2010-05-28 15:58:56', 1, 1, '2010-05-28 15:58:56', 0, NULL),
(1, 'B - 1', 'specimen', 2, 'blood', 1, 'blood', 1, NULL, NULL, NULL, 'no', '', '2010-05-28 15:58:56', 1, '2010-05-28 15:58:57', 1, 2, '2010-05-28 15:58:57', 0, NULL),
(1, 'B - 1', 'specimen', 2, 'blood', 1, 'blood', 1, NULL, NULL, NULL, 'no', '', '2010-05-28 15:58:56', 1, '2010-05-28 15:59:43', 1, 3, '2010-05-28 15:59:44', 0, NULL),
(2, '', 'derivative', 8, 'pbmc', 1, 'blood', 1, 1, NULL, NULL, 'no', '', '2010-05-28 16:18:12', 1, '2010-05-28 16:18:12', 1, 4, '2010-05-28 16:18:13', 0, NULL),
(2, 'PBMC - 2', 'derivative', 8, 'pbmc', 1, 'blood', 1, 1, NULL, NULL, 'no', '', '2010-05-28 16:18:12', 1, '2010-05-28 16:18:13', 1, 5, '2010-05-28 16:18:14', 0, NULL),
(2, 'PBMC - 2', 'derivative', 8, 'pbmc', 1, 'blood', 1, 1, NULL, NULL, 'no', '', '2010-05-28 16:18:12', 1, '2010-05-28 16:18:55', 1, 6, '2010-05-28 16:18:56', 0, NULL),
(3, '', 'derivative', 12, 'dna', 1, 'blood', 1, 2, NULL, NULL, 'no', '', '2010-05-28 16:24:52', 1, '2010-05-28 16:24:52', 1, 7, '2010-05-28 16:24:53', 0, NULL),
(3, 'DNA - 3', 'derivative', 12, 'dna', 1, 'blood', 1, 2, NULL, NULL, 'no', '', '2010-05-28 16:24:52', 1, '2010-05-28 16:24:53', 1, 8, '2010-05-28 16:24:54', 0, NULL);

--
-- Contenu de la table `sd_der_amp_rnas`
--


--
-- Contenu de la table `sd_der_amp_rnas_revs`
--


--
-- Contenu de la table `sd_der_ascite_cells`
--


--
-- Contenu de la table `sd_der_ascite_cells_revs`
--


--
-- Contenu de la table `sd_der_ascite_sups`
--


--
-- Contenu de la table `sd_der_ascite_sups_revs`
--


--
-- Contenu de la table `sd_der_blood_cells`
--


--
-- Contenu de la table `sd_der_blood_cells_revs`
--


--
-- Contenu de la table `sd_der_b_cells`
--


--
-- Contenu de la table `sd_der_b_cells_revs`
--


--
-- Contenu de la table `sd_der_cell_cultures`
--


--
-- Contenu de la table `sd_der_cell_cultures_revs`
--


--
-- Contenu de la table `sd_der_cell_lysates`
--


--
-- Contenu de la table `sd_der_cell_lysates_revs`
--


--
-- Contenu de la table `sd_der_cystic_fl_cells`
--


--
-- Contenu de la table `sd_der_cystic_fl_cells_revs`
--


--
-- Contenu de la table `sd_der_cystic_fl_sups`
--


--
-- Contenu de la table `sd_der_cystic_fl_sups_revs`
--


--
-- Contenu de la table `sd_der_dnas`
--

INSERT INTO `sd_der_dnas` (`id`, `sample_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 3, '2010-05-28 16:24:52', 1, '2010-05-28 16:24:54', 1, 0, NULL);

--
-- Contenu de la table `sd_der_dnas_revs`
--

INSERT INTO `sd_der_dnas_revs` (`id`, `sample_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 3, '2010-05-28 16:24:52', 1, '2010-05-28 16:24:52', 1, 1, '2010-05-28 16:24:53', 0, NULL),
(1, 3, '2010-05-28 16:24:52', 1, '2010-05-28 16:24:54', 1, 2, '2010-05-28 16:24:54', 0, NULL);

--
-- Contenu de la table `sd_der_pbmcs`
--

INSERT INTO `sd_der_pbmcs` (`id`, `sample_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 2, '2010-05-28 16:18:13', 1, '2010-05-28 16:18:55', 1, 0, NULL);

--
-- Contenu de la table `sd_der_pbmcs_revs`
--

INSERT INTO `sd_der_pbmcs_revs` (`id`, `sample_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 2, '2010-05-28 16:18:13', 1, '2010-05-28 16:18:13', 1, 1, '2010-05-28 16:18:13', 0, NULL),
(1, 2, '2010-05-28 16:18:13', 1, '2010-05-28 16:18:14', 1, 2, '2010-05-28 16:18:14', 0, NULL),
(1, 2, '2010-05-28 16:18:13', 1, '2010-05-28 16:18:55', 1, 3, '2010-05-28 16:18:55', 0, NULL);

--
-- Contenu de la table `sd_der_pericardial_fl_cells`
--


--
-- Contenu de la table `sd_der_pericardial_fl_cells_revs`
--


--
-- Contenu de la table `sd_der_pericardial_fl_sups`
--


--
-- Contenu de la table `sd_der_pericardial_fl_sups_revs`
--


--
-- Contenu de la table `sd_der_plasmas`
--


--
-- Contenu de la table `sd_der_plasmas_revs`
--


--
-- Contenu de la table `sd_der_pleural_fl_cells`
--


--
-- Contenu de la table `sd_der_pleural_fl_cells_revs`
--


--
-- Contenu de la table `sd_der_pleural_fl_sups`
--


--
-- Contenu de la table `sd_der_pleural_fl_sups_revs`
--


--
-- Contenu de la table `sd_der_proteins`
--


--
-- Contenu de la table `sd_der_proteins_revs`
--


--
-- Contenu de la table `sd_der_pw_cells`
--


--
-- Contenu de la table `sd_der_pw_cells_revs`
--


--
-- Contenu de la table `sd_der_pw_sups`
--


--
-- Contenu de la table `sd_der_pw_sups_revs`
--


--
-- Contenu de la table `sd_der_rnas`
--


--
-- Contenu de la table `sd_der_rnas_revs`
--


--
-- Contenu de la table `sd_der_serums`
--


--
-- Contenu de la table `sd_der_serums_revs`
--


--
-- Contenu de la table `sd_der_tiss_lysates`
--


--
-- Contenu de la table `sd_der_tiss_lysates_revs`
--


--
-- Contenu de la table `sd_der_tiss_susps`
--


--
-- Contenu de la table `sd_der_tiss_susps_revs`
--


--
-- Contenu de la table `sd_der_urine_cents`
--


--
-- Contenu de la table `sd_der_urine_cents_revs`
--


--
-- Contenu de la table `sd_der_urine_cons`
--


--
-- Contenu de la table `sd_der_urine_cons_revs`
--


--
-- Contenu de la table `sd_spe_ascites`
--


--
-- Contenu de la table `sd_spe_ascites_revs`
--


--
-- Contenu de la table `sd_spe_bloods`
--

INSERT INTO `sd_spe_bloods` (`id`, `sample_master_id`, `blood_type`, `collected_tube_nbr`, `collected_volume`, `collected_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 'EDTA', 3, '12.43000', 'ml', '2010-05-28 15:58:56', 1, '2010-05-28 15:59:43', 1, 0, NULL);

--
-- Contenu de la table `sd_spe_bloods_revs`
--

INSERT INTO `sd_spe_bloods_revs` (`id`, `sample_master_id`, `blood_type`, `collected_tube_nbr`, `collected_volume`, `collected_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, 'EDTA', 3, '12.43000', 'ml', '2010-05-28 15:58:56', 1, '2010-05-28 15:58:56', 1, 1, '2010-05-28 15:58:56', 0, NULL),
(1, 1, 'EDTA', 3, '12.43000', 'ml', '2010-05-28 15:58:56', 1, '2010-05-28 15:58:57', 1, 2, '2010-05-28 15:58:57', 0, NULL),
(1, 1, 'EDTA', 3, '12.43000', 'ml', '2010-05-28 15:58:56', 1, '2010-05-28 15:59:43', 1, 3, '2010-05-28 15:59:43', 0, NULL);

--
-- Contenu de la table `sd_spe_cystic_fluids`
--


--
-- Contenu de la table `sd_spe_cystic_fluids_revs`
--


--
-- Contenu de la table `sd_spe_pericardial_fluids`
--


--
-- Contenu de la table `sd_spe_pericardial_fluids_revs`
--


--
-- Contenu de la table `sd_spe_peritoneal_washes`
--


--
-- Contenu de la table `sd_spe_peritoneal_washes_revs`
--


--
-- Contenu de la table `sd_spe_pleural_fluids`
--


--
-- Contenu de la table `sd_spe_pleural_fluids_revs`
--


--
-- Contenu de la table `sd_spe_tissues`
--


--
-- Contenu de la table `sd_spe_tissues_revs`
--


--
-- Contenu de la table `sd_spe_urines`
--


--
-- Contenu de la table `sd_spe_urines_revs`
--


--
-- Contenu de la table `shelves`
--


--
-- Contenu de la table `shelves_revs`
--


--
-- Contenu de la table `shipments`
--

INSERT INTO `shipments` (`id`, `shipment_code`, `recipient`, `facility`, `delivery_street_address`, `delivery_city`, `delivery_province`, `delivery_postal_code`, `delivery_country`, `shipping_company`, `shipping_account_nbr`, `datetime_shipped`, `datetime_received`, `shipped_by`, `created`, `created_by`, `modified`, `modified_by`, `order_id`, `deleted`, `deleted_date`) VALUES
(1, 'UPS98409', 'qwerty', '', '', '', '', '', '', '', '', '2010-05-31 13:04:00', NULL, 'custom_laboratory_staff_2', '2010-05-28 16:33:18', 1, '2010-05-28 16:33:18', 1, 1, 0, NULL);

--
-- Contenu de la table `shipments_revs`
--

INSERT INTO `shipments_revs` (`id`, `shipment_code`, `recipient`, `facility`, `delivery_street_address`, `delivery_city`, `delivery_province`, `delivery_postal_code`, `delivery_country`, `shipping_company`, `shipping_account_nbr`, `datetime_shipped`, `datetime_received`, `shipped_by`, `created`, `created_by`, `modified`, `modified_by`, `order_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 'UPS98409', 'qwerty', '', '', '', '', '', '', '', '', '2010-05-31 13:04:00', NULL, 'custom_laboratory_staff_2', '2010-05-28 16:33:18', 1, '2010-05-28 16:33:18', 1, 1, 1, '2010-05-28 16:33:18', 0, NULL);

--
-- Contenu de la table `sidebars`
--


--
-- Contenu de la table `sopd_general_all`
--

INSERT INTO `sopd_general_all` (`id`, `value`, `created`, `created_by`, `modified`, `modified_by`, `sop_master_id`, `deleted`, `deleted_date`) VALUES
(1, NULL, '2010-05-28 13:50:54', 1, '2010-05-28 13:50:54', 1, 1, 0, NULL);

--
-- Contenu de la table `sopd_general_all_revs`
--

INSERT INTO `sopd_general_all_revs` (`id`, `value`, `created`, `created_by`, `modified`, `modified_by`, `sop_master_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, NULL, '2010-05-28 13:50:54', 1, '2010-05-28 13:50:54', 1, 1, 1, '2010-05-28 13:50:54', 0, NULL);

--
-- Contenu de la table `sopd_inventory_all`
--


--
-- Contenu de la table `sopd_inventory_all_revs`
--


--
-- Contenu de la table `sope_general_all`
--


--
-- Contenu de la table `sope_general_all_revs`
--


--
-- Contenu de la table `sope_inventory_all`
--


--
-- Contenu de la table `sope_inventory_all_revs`
--


--
-- Contenu de la table `sop_masters`
--

INSERT INTO `sop_masters` (`id`, `sop_control_id`, `title`, `notes`, `code`, `version`, `sop_group`, `type`, `status`, `expiry_date`, `activated_date`, `scope`, `purpose`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `deleted`, `deleted_date`) VALUES
(1, 1, 'SOP4323', '', '', '', 'General', 'All', '', NULL, NULL, '', '', '2010-05-28 13:50:54', 1, '2010-05-28 13:50:54', 1, NULL, 0, NULL);

--
-- Contenu de la table `sop_masters_revs`
--

INSERT INTO `sop_masters_revs` (`id`, `sop_control_id`, `title`, `notes`, `code`, `version`, `sop_group`, `type`, `status`, `expiry_date`, `activated_date`, `scope`, `purpose`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, 'SOP4323', '', '', '', 'General', 'All', '', NULL, NULL, '', '', '2010-05-28 13:50:54', 1, '2010-05-28 13:50:54', 1, NULL, 1, '2010-05-28 13:50:54', 0, NULL);

--
-- Contenu de la table `source_aliquots`
--

INSERT INTO `source_aliquots` (`id`, `sample_master_id`, `aliquot_master_id`, `aliquot_use_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 2, 1, 3, '2010-05-28 16:19:42', 1, '2010-05-28 16:19:42', 1, 0, NULL);

--
-- Contenu de la table `source_aliquots_revs`
--

INSERT INTO `source_aliquots_revs` (`id`, `sample_master_id`, `aliquot_master_id`, `aliquot_use_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 2, 1, 3, '2010-05-28 16:19:42', 1, '2010-05-28 16:19:42', 1, 1, '2010-05-28 16:19:42', 0, NULL);

--
-- Contenu de la table `specimen_details`
--

INSERT INTO `specimen_details` (`id`, `sample_master_id`, `supplier_dept`, `reception_by`, `reception_datetime`, `reception_datetime_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 'custom_supplier_dept_1', 'custom_laboratory_staff_2', '2003-04-23 13:02:00', '', '2010-05-28 15:58:57', 1, '2010-05-28 15:59:44', 1, 0, NULL);

--
-- Contenu de la table `specimen_details_revs`
--

INSERT INTO `specimen_details_revs` (`id`, `sample_master_id`, `supplier_dept`, `reception_by`, `reception_datetime`, `reception_datetime_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, 'custom_supplier_dept_1', 'custom_laboratory_staff_2', '2003-04-23 13:08:00', '', '2010-05-28 15:58:57', 1, '2010-05-28 15:58:57', 1, 1, '2010-05-28 15:58:58', 0, NULL),
(1, 1, 'custom_supplier_dept_1', 'custom_laboratory_staff_2', '2003-04-23 13:02:00', '', '2010-05-28 15:58:57', 1, '2010-05-28 15:59:44', 1, 2, '2010-05-28 15:59:44', 0, NULL);

--
-- Contenu de la table `std_boxs`
--

INSERT INTO `std_boxs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 4, '2010-05-28 13:24:31', 1, '2010-05-28 16:08:53', 1, 0, NULL),
(2, 5, '2010-05-28 13:25:47', 1, '2010-05-28 16:08:54', 1, 0, NULL),
(3, 7, '2010-05-28 13:38:48', 1, '2010-05-28 16:08:54', 1, 0, NULL),
(4, 10, '2010-05-28 13:44:03', 1, '2010-05-28 13:49:11', 1, 0, NULL);

--
-- Contenu de la table `std_boxs_revs`
--

INSERT INTO `std_boxs_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 4, '2010-05-28 13:24:31', 1, '2010-05-28 13:24:31', 1, 1, '2010-05-28 13:24:31', 0, NULL),
(1, 4, '2010-05-28 13:24:31', 1, '2010-05-28 13:24:32', 1, 2, '2010-05-28 13:24:32', 0, NULL),
(1, 4, '2010-05-28 13:24:31', 1, '2010-05-28 13:24:45', 1, 3, '2010-05-28 13:24:45', 0, NULL),
(2, 5, '2010-05-28 13:25:47', 1, '2010-05-28 13:25:47', 1, 4, '2010-05-28 13:25:47', 0, NULL),
(2, 5, '2010-05-28 13:25:47', 1, '2010-05-28 13:25:48', 1, 5, '2010-05-28 13:25:48', 0, NULL),
(2, 5, '2010-05-28 13:25:47', 1, '2010-05-28 13:26:09', 1, 6, '2010-05-28 13:26:09', 0, NULL),
(3, 7, '2010-05-28 13:38:48', 1, '2010-05-28 13:38:48', 1, 7, '2010-05-28 13:38:48', 0, NULL),
(3, 7, '2010-05-28 13:38:48', 1, '2010-05-28 13:38:49', 1, 8, '2010-05-28 13:38:49', 0, NULL),
(3, 7, '2010-05-28 13:38:48', 1, '2010-05-28 13:39:03', 1, 9, '2010-05-28 13:39:03', 0, NULL),
(4, 10, '2010-05-28 13:44:03', 1, '2010-05-28 13:44:03', 1, 10, '2010-05-28 13:44:04', 0, NULL),
(4, 10, '2010-05-28 13:44:03', 1, '2010-05-28 13:44:05', 1, 11, '2010-05-28 13:44:05', 0, NULL),
(4, 10, '2010-05-28 13:44:03', 1, '2010-05-28 13:44:24', 1, 12, '2010-05-28 13:44:24', 0, NULL),
(4, 10, '2010-05-28 13:44:03', 1, '2010-05-28 13:46:45', 1, 13, '2010-05-28 13:46:45', 0, NULL),
(4, 10, '2010-05-28 13:44:03', 1, '2010-05-28 13:46:46', 1, 14, '2010-05-28 13:46:46', 0, NULL),
(4, 10, '2010-05-28 13:44:03', 1, '2010-05-28 13:47:50', 1, 15, '2010-05-28 13:47:50', 0, NULL),
(4, 10, '2010-05-28 13:44:03', 1, '2010-05-28 13:48:32', 1, 16, '2010-05-28 13:48:32', 0, NULL),
(4, 10, '2010-05-28 13:44:03', 1, '2010-05-28 13:49:11', 1, 17, '2010-05-28 13:49:11', 0, NULL),
(1, 4, '2010-05-28 13:24:31', 1, '2010-05-28 16:08:53', 1, 18, '2010-05-28 16:08:53', 0, NULL),
(2, 5, '2010-05-28 13:25:47', 1, '2010-05-28 16:08:54', 1, 19, '2010-05-28 16:08:54', 0, NULL),
(3, 7, '2010-05-28 13:38:48', 1, '2010-05-28 16:08:54', 1, 20, '2010-05-28 16:08:54', 0, NULL);

--
-- Contenu de la table `std_cupboards`
--


--
-- Contenu de la table `std_cupboards_revs`
--


--
-- Contenu de la table `std_freezers`
--


--
-- Contenu de la table `std_freezers_revs`
--


--
-- Contenu de la table `std_fridges`
--

INSERT INTO `std_fridges` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, '2010-05-28 13:22:03', 1, '2010-05-28 16:08:50', 1, 0, NULL);

--
-- Contenu de la table `std_fridges_revs`
--

INSERT INTO `std_fridges_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, '2010-05-28 13:22:03', 1, '2010-05-28 13:22:03', 1, 1, '2010-05-28 13:22:04', 0, NULL),
(1, 1, '2010-05-28 13:22:03', 1, '2010-05-28 13:22:04', 1, 2, '2010-05-28 13:22:05', 0, NULL),
(1, 1, '2010-05-28 13:22:03', 1, '2010-05-28 16:08:50', 1, 3, '2010-05-28 16:08:50', 0, NULL);

--
-- Contenu de la table `std_incubators`
--

INSERT INTO `std_incubators` (`id`, `storage_master_id`, `oxygen_perc`, `carbonic_gaz_perc`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 8, '12', '32', '2010-05-28 13:40:09', 1, '2010-05-28 13:49:10', 1, 0, NULL);

--
-- Contenu de la table `std_incubators_revs`
--

INSERT INTO `std_incubators_revs` (`id`, `storage_master_id`, `oxygen_perc`, `carbonic_gaz_perc`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 8, '12', '32', '2010-05-28 13:40:09', 1, '2010-05-28 13:40:09', 1, 1, '2010-05-28 13:40:09', 0, NULL),
(1, 8, '12', '32', '2010-05-28 13:40:09', 1, '2010-05-28 13:40:10', 1, 2, '2010-05-28 13:40:10', 0, NULL),
(1, 8, '12', '32', '2010-05-28 13:40:09', 1, '2010-05-28 13:49:10', 1, 3, '2010-05-28 13:49:10', 0, NULL);

--
-- Contenu de la table `std_nitro_locates`
--


--
-- Contenu de la table `std_nitro_locates_revs`
--


--
-- Contenu de la table `std_racks`
--

INSERT INTO `std_racks` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 3, '2010-05-28 13:23:48', 1, '2010-05-28 16:08:52', 1, 0, NULL),
(2, 6, '2010-05-28 13:29:20', 1, '2010-05-28 16:08:52', 1, 0, NULL),
(3, 9, '2010-05-28 13:43:19', 1, '2010-05-28 13:49:10', 1, 0, NULL);

--
-- Contenu de la table `std_racks_revs`
--

INSERT INTO `std_racks_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 3, '2010-05-28 13:23:48', 1, '2010-05-28 13:23:48', 1, 1, '2010-05-28 13:23:48', 0, NULL),
(1, 3, '2010-05-28 13:23:48', 1, '2010-05-28 13:23:49', 1, 2, '2010-05-28 13:23:49', 0, NULL),
(2, 6, '2010-05-28 13:29:20', 1, '2010-05-28 13:29:20', 1, 3, '2010-05-28 13:29:20', 0, NULL),
(2, 6, '2010-05-28 13:29:20', 1, '2010-05-28 13:29:21', 1, 4, '2010-05-28 13:29:21', 0, NULL),
(3, 9, '2010-05-28 13:43:19', 1, '2010-05-28 13:43:19', 1, 5, '2010-05-28 13:43:20', 0, NULL),
(3, 9, '2010-05-28 13:43:19', 1, '2010-05-28 13:43:20', 1, 6, '2010-05-28 13:43:20', 0, NULL),
(3, 9, '2010-05-28 13:43:19', 1, '2010-05-28 13:46:44', 1, 7, '2010-05-28 13:46:44', 0, NULL),
(3, 9, '2010-05-28 13:43:19', 1, '2010-05-28 13:47:02', 1, 8, '2010-05-28 13:47:02', 0, NULL),
(3, 9, '2010-05-28 13:43:19', 1, '2010-05-28 13:47:49', 1, 9, '2010-05-28 13:47:49', 0, NULL),
(3, 9, '2010-05-28 13:43:19', 1, '2010-05-28 13:48:31', 1, 10, '2010-05-28 13:48:31', 0, NULL),
(3, 9, '2010-05-28 13:43:19', 1, '2010-05-28 13:49:10', 1, 11, '2010-05-28 13:49:11', 0, NULL),
(1, 3, '2010-05-28 13:23:48', 1, '2010-05-28 16:08:52', 1, 12, '2010-05-28 16:08:52', 0, NULL),
(2, 6, '2010-05-28 13:29:20', 1, '2010-05-28 16:08:52', 1, 13, '2010-05-28 16:08:52', 0, NULL);

--
-- Contenu de la table `std_rooms`
--


--
-- Contenu de la table `std_rooms_revs`
--


--
-- Contenu de la table `std_shelfs`
--

INSERT INTO `std_shelfs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 2, '2010-05-28 13:22:54', 1, '2010-05-28 16:08:51', 1, 0, NULL);

--
-- Contenu de la table `std_shelfs_revs`
--

INSERT INTO `std_shelfs_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 2, '2010-05-28 13:22:54', 1, '2010-05-28 13:22:54', 1, 1, '2010-05-28 13:22:55', 0, NULL),
(1, 2, '2010-05-28 13:22:54', 1, '2010-05-28 13:22:55', 1, 2, '2010-05-28 13:22:55', 0, NULL),
(1, 2, '2010-05-28 13:22:54', 1, '2010-05-28 16:08:51', 1, 3, '2010-05-28 16:08:51', 0, NULL);

--
-- Contenu de la table `std_tma_blocks`
--

INSERT INTO `std_tma_blocks` (`id`, `storage_master_id`, `sop_master_id`, `product_code`, `creation_datetime`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 11, NULL, NULL, NULL, '2010-05-28 13:52:22', 1, '2010-05-28 13:52:22', 1, 0, NULL);

--
-- Contenu de la table `std_tma_blocks_revs`
--

INSERT INTO `std_tma_blocks_revs` (`id`, `storage_master_id`, `sop_master_id`, `product_code`, `creation_datetime`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 11, NULL, NULL, NULL, '2010-05-28 13:52:22', 1, '2010-05-28 13:52:22', 1, 1, '2010-05-28 13:52:22', 0, NULL);

--
-- Contenu de la table `storage_coordinates`
--

INSERT INTO `storage_coordinates` (`id`, `storage_master_id`, `dimension`, `coordinate_value`, `order`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 8, 'x', '1', 1, '2010-05-28 13:41:21', 1, '2010-05-28 13:41:57', 1, 1, '2010-05-28 13:41:57'),
(2, 8, 'x', 's2', 2, '2010-05-28 13:41:40', 1, '2010-05-28 13:41:40', 1, 0, NULL),
(3, 8, 'x', 's1', 1, '2010-05-28 13:42:18', 1, '2010-05-28 13:42:18', 1, 0, NULL);

--
-- Contenu de la table `storage_coordinates_revs`
--

INSERT INTO `storage_coordinates_revs` (`id`, `storage_master_id`, `dimension`, `coordinate_value`, `order`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 8, 'x', '1', 1, '2010-05-28 13:41:21', 1, '2010-05-28 13:41:21', 1, 1, '2010-05-28 13:41:21', 0, NULL),
(2, 8, 'x', 's2', 2, '2010-05-28 13:41:40', 1, '2010-05-28 13:41:40', 1, 2, '2010-05-28 13:41:41', 0, NULL),
(1, 8, 'x', '1', 1, '2010-05-28 13:41:21', 1, '2010-05-28 13:41:57', 1, 3, '2010-05-28 13:41:58', 1, '2010-05-28 13:41:57'),
(3, 8, 'x', 's1', 1, '2010-05-28 13:42:18', 1, '2010-05-28 13:42:18', 1, 4, '2010-05-28 13:42:18', 0, NULL);

--
-- Contenu de la table `storage_masters`
--

INSERT INTO `storage_masters` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `coord_x_order`, `parent_storage_coord_y`, `coord_y_order`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'FRI - 1', 'fridge', 5, NULL, 1, 14, 'bc67893', 'fr1', 'fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '8.00', 'celsius', '', '2010-05-28 13:22:03', 1, '2010-05-28 16:08:50', 1, 0, NULL),
(2, 'SH - 2', 'shelf', 14, 1, 2, 13, '-', '1', 'fr1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:22:54', 1, '2010-05-28 16:08:51', 1, 0, NULL),
(3, 'R10 - 3', 'rack10', 12, 2, 3, 8, 'bc78904', 'r1', 'fr1-1-r1', '', NULL, NULL, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:23:47', 1, '2010-05-28 16:08:51', 1, 0, NULL),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1-1-r1-001', '', '1', 5, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:24:30', 1, '2010-05-28 16:08:53', 1, 0, NULL),
(5, 'B25 - 5', 'box25', 17, 3, 6, 7, 'bc8978732', '002', 'fr1-1-r1-002', '', '2', 1, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:25:46', 1, '2010-05-28 16:08:53', 1, 0, NULL),
(6, 'R10 - 6', 'rack10', 12, 2, 9, 12, 'bc988900', 'r2', 'fr1-1-r2', '', NULL, NULL, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:29:19', 1, '2010-05-28 16:08:52', 1, 0, NULL),
(7, 'B25 - 7', 'box25', 17, 6, 10, 11, 'bc87987876', '003', 'fr1-1-r2-003', '', '3', 2, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:38:47', 1, '2010-05-28 16:08:54', 1, 0, NULL),
(8, 'INC - 8', 'incubator', 4, NULL, 15, 20, 'bc9032098', 'ic1', 'ic1', '', NULL, NULL, NULL, NULL, 'TRUE', '36.00', 'celsius', '', '2010-05-28 13:40:08', 1, '2010-05-28 13:49:10', 1, 0, NULL),
(9, 'R2D16 - 9', 'rack16', 11, 8, 16, 19, 'bc987237', 'r1', 'ic1-r1', '', 's2', 2, NULL, NULL, 'FALSE', '36.00', 'celsius', '', '2010-05-28 13:43:19', 1, '2010-05-28 13:49:10', 1, 0, NULL),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'ic1-r1-004', '', 'B', 1, '1', 0, 'FALSE', '36.00', 'celsius', '', '2010-05-28 13:44:03', 1, '2010-05-28 13:49:11', 1, 0, NULL),
(11, 'TMA345 - 11', 'TMA-blc 23X15', 19, NULL, 21, 22, 'bc79879832', 'tm1', 'tm1', '', NULL, NULL, NULL, NULL, 'FALSE', NULL, NULL, '', '2010-05-28 13:52:21', 1, '2010-05-28 13:52:22', 1, 0, NULL);

--
-- Contenu de la table `storage_masters_revs`
--

INSERT INTO `storage_masters_revs` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `coord_x_order`, `parent_storage_coord_y`, `coord_y_order`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '', 'fridge', 5, NULL, 1, 2, 'bc67893', 'fr1', 'fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '6.00', 'celsius', '', '2010-05-28 13:22:03', 1, '2010-05-28 13:22:03', 1, 1, '2010-05-28 13:22:04', 0, NULL),
(1, 'FRI - 1', 'fridge', 5, NULL, 1, 2, 'bc67893', 'fr1', 'fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '6.00', 'celsius', '', '2010-05-28 13:22:03', 1, '2010-05-28 13:22:04', 1, 2, '2010-05-28 13:22:05', 0, NULL),
(2, '', 'shelf', 14, 1, 0, 0, '-', '1', 'fr1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:22:54', 1, '2010-05-28 13:22:54', 1, 3, '2010-05-28 13:22:55', 0, NULL),
(2, 'SH - 2', 'shelf', 14, 1, 2, 3, '-', '1', 'fr1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:22:54', 1, '2010-05-28 13:22:55', 1, 4, '2010-05-28 13:22:56', 0, NULL),
(3, '', 'rack10', 12, 2, 0, 0, 'bc78904', 'r1', 'fr1-1-r1', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:23:47', 1, '2010-05-28 13:23:47', 1, 5, '2010-05-28 13:23:48', 0, NULL),
(3, 'R10 - 3', 'rack10', 12, 2, 3, 4, 'bc78904', 'r1', 'fr1-1-r1', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:23:47', 1, '2010-05-28 13:23:48', 1, 6, '2010-05-28 13:23:49', 0, NULL),
(4, '', 'box81 1A-9I', 9, 3, 0, 0, 'bc9973900', '001', 'fr1-1-r1-001', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:24:30', 1, '2010-05-28 13:24:30', 1, 7, '2010-05-28 13:24:31', 0, NULL),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1-1-r1-001', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:24:30', 1, '2010-05-28 13:24:31', 1, 8, '2010-05-28 13:24:32', 0, NULL),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1-1-r1-001', '', '6', 5, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:24:30', 1, '2010-05-28 13:24:45', 1, 9, '2010-05-28 13:24:45', 0, NULL),
(5, '', 'box25', 17, 3, 0, 0, 'bc8978732', '002', 'fr1-1-r1-002', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:25:46', 1, '2010-05-28 13:25:46', 1, 10, '2010-05-28 13:25:47', 0, NULL),
(5, 'B25 - 5', 'box25', 17, 3, 6, 7, 'bc8978732', '002', 'fr1-1-r1-002', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:25:46', 1, '2010-05-28 13:25:47', 1, 11, '2010-05-28 13:25:48', 0, NULL),
(5, 'B25 - 5', 'box25', 17, 3, 6, 7, 'bc8978732', '002', 'fr1-1-r1-002', '', '2', 1, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:25:46', 1, '2010-05-28 13:26:09', 1, 12, '2010-05-28 13:26:09', 0, NULL),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1-1-r1-001', '', '1', 5, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:24:30', 1, '2010-05-28 13:24:45', 1, 13, '2010-05-28 13:28:03', 0, NULL),
(6, '', 'rack10', 12, 2, 0, 0, 'bc988900', 'r2', 'fr1-1-r2', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:29:19', 1, '2010-05-28 13:29:19', 1, 14, '2010-05-28 13:29:20', 0, NULL),
(6, 'R10 - 6', 'rack10', 12, 2, 9, 10, 'bc988900', 'r2', 'fr1-1-r2', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:29:19', 1, '2010-05-28 13:29:20', 1, 15, '2010-05-28 13:29:21', 0, NULL),
(7, '', 'box25', 17, 6, 0, 0, 'bc87987876', '003', 'fr1-1-r2-003', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:38:47', 1, '2010-05-28 13:38:47', 1, 16, '2010-05-28 13:38:48', 0, NULL),
(7, 'B25 - 7', 'box25', 17, 6, 10, 11, 'bc87987876', '003', 'fr1-1-r2-003', '', NULL, NULL, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:38:47', 1, '2010-05-28 13:38:48', 1, 17, '2010-05-28 13:38:49', 0, NULL),
(7, 'B25 - 7', 'box25', 17, 6, 10, 11, 'bc87987876', '003', 'fr1-1-r2-003', '', '3', 2, NULL, NULL, 'FALSE', '6.00', 'celsius', '', '2010-05-28 13:38:47', 1, '2010-05-28 13:39:03', 1, 18, '2010-05-28 13:39:03', 0, NULL),
(8, '', 'incubator', 4, NULL, 15, 16, 'bc9032098', 'ic1', 'ic1', '', NULL, NULL, NULL, NULL, 'TRUE', '37.00', 'celsius', '', '2010-05-28 13:40:08', 1, '2010-05-28 13:40:08', 1, 19, '2010-05-28 13:40:09', 0, NULL),
(8, 'INC - 8', 'incubator', 4, NULL, 15, 16, 'bc9032098', 'ic1', 'ic1', '', NULL, NULL, NULL, NULL, 'TRUE', '37.00', 'celsius', '', '2010-05-28 13:40:08', 1, '2010-05-28 13:40:09', 1, 20, '2010-05-28 13:40:10', 0, NULL),
(9, '', 'rack16', 11, NULL, 17, 18, 'bc987237', 'r1', 'r1', '', NULL, NULL, NULL, NULL, 'FALSE', NULL, NULL, '', '2010-05-28 13:43:19', 1, '2010-05-28 13:43:19', 1, 21, '2010-05-28 13:43:20', 0, NULL),
(9, 'R2D16 - 9', 'rack16', 11, NULL, 17, 18, 'bc987237', 'r1', 'r1', '', NULL, NULL, NULL, NULL, 'FALSE', NULL, NULL, '', '2010-05-28 13:43:19', 1, '2010-05-28 13:43:20', 1, 22, '2010-05-28 13:43:20', 0, NULL),
(10, '', 'box100 1A-20E', 18, 9, 0, 0, 'bc987040', '004', 'r1-004', '', NULL, NULL, NULL, NULL, 'FALSE', NULL, NULL, '', '2010-05-28 13:44:03', 1, '2010-05-28 13:44:03', 1, 23, '2010-05-28 13:44:04', 0, NULL),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 18, 19, 'bc987040', '004', 'r1-004', '', NULL, NULL, NULL, NULL, 'FALSE', NULL, NULL, '', '2010-05-28 13:44:03', 1, '2010-05-28 13:44:04', 1, 24, '2010-05-28 13:44:05', 0, NULL),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 18, 19, 'bc987040', '004', 'r1-004', '', 'B', 1, '1', 0, 'FALSE', NULL, NULL, '', '2010-05-28 13:44:03', 1, '2010-05-28 13:44:23', 1, 25, '2010-05-28 13:44:24', 0, NULL),
(9, 'R2D16 - 9', 'rack16', 11, 8, 17, 20, 'bc987237', 'r1', 'ic1-r1', '', NULL, NULL, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2010-05-28 13:43:19', 1, '2010-05-28 13:46:43', 1, 26, '2010-05-28 13:46:44', 0, NULL),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'r1-004', '', 'B', 1, '1', 0, 'FALSE', '37.00', 'celsius', '', '2010-05-28 13:44:03', 1, '2010-05-28 13:46:45', 1, 27, '2010-05-28 13:46:45', 0, NULL),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'ic1-r1-004', '', 'B', 1, '1', 0, 'FALSE', '37.00', 'celsius', '', '2010-05-28 13:44:03', 1, '2010-05-28 13:46:45', 1, 28, '2010-05-28 13:46:46', 0, NULL),
(9, 'R2D16 - 9', 'rack16', 11, 8, 16, 19, 'bc987237', 'r1', 'ic1-r1', '', 's2', 2, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2010-05-28 13:43:19', 1, '2010-05-28 13:47:01', 1, 29, '2010-05-28 13:47:02', 0, NULL),
(9, 'R2D16 - 9', 'rack16', 11, 8, 16, 19, 'bc987237', 'ic_r1', 'ic1-ic_r1', '', 's2', 2, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2010-05-28 13:43:19', 1, '2010-05-28 13:47:49', 1, 30, '2010-05-28 13:47:49', 0, NULL),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'ic1-ic_r1-004', '', 'B', 1, '1', 0, 'FALSE', '37.00', 'celsius', '', '2010-05-28 13:44:03', 1, '2010-05-28 13:47:49', 1, 31, '2010-05-28 13:47:50', 0, NULL),
(9, 'R2D16 - 9', 'rack16', 11, 8, 16, 19, 'bc987237', 'r1', 'ic1-r1', '', 's2', 2, NULL, NULL, 'FALSE', '37.00', 'celsius', '', '2010-05-28 13:43:19', 1, '2010-05-28 13:48:30', 1, 32, '2010-05-28 13:48:31', 0, NULL),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'ic1-r1-004', '', 'B', 1, '1', 0, 'FALSE', '37.00', 'celsius', '', '2010-05-28 13:44:03', 1, '2010-05-28 13:48:31', 1, 33, '2010-05-28 13:48:32', 0, NULL),
(8, 'INC - 8', 'incubator', 4, NULL, 15, 20, 'bc9032098', 'ic1', 'ic1', '', NULL, NULL, NULL, NULL, 'TRUE', '36.00', 'celsius', '', '2010-05-28 13:40:08', 1, '2010-05-28 13:49:10', 1, 34, '2010-05-28 13:49:10', 0, NULL),
(9, 'R2D16 - 9', 'rack16', 11, 8, 16, 19, 'bc987237', 'r1', 'ic1-r1', '', 's2', 2, NULL, NULL, 'FALSE', '36.00', 'celsius', '', '2010-05-28 13:43:19', 1, '2010-05-28 13:49:10', 1, 35, '2010-05-28 13:49:11', 0, NULL),
(10, 'B2D100 - 10', 'box100 1A-20E', 18, 9, 17, 18, 'bc987040', '004', 'ic1-r1-004', '', 'B', 1, '1', 0, 'FALSE', '36.00', 'celsius', '', '2010-05-28 13:44:03', 1, '2010-05-28 13:49:11', 1, 36, '2010-05-28 13:49:11', 0, NULL),
(11, '', 'TMA-blc 23X15', 19, NULL, 21, 22, 'bc79879832', 'tm1', 'tm1', '', NULL, NULL, NULL, NULL, 'FALSE', NULL, NULL, '', '2010-05-28 13:52:21', 1, '2010-05-28 13:52:21', 1, 37, '2010-05-28 13:52:22', 0, NULL),
(11, 'TMA345 - 11', 'TMA-blc 23X15', 19, NULL, 21, 22, 'bc79879832', 'tm1', 'tm1', '', NULL, NULL, NULL, NULL, 'FALSE', NULL, NULL, '', '2010-05-28 13:52:21', 1, '2010-05-28 13:52:22', 1, 38, '2010-05-28 13:52:23', 0, NULL),
(1, 'FRI - 1', 'fridge', 5, NULL, 1, 14, 'bc67893', 'fr1', 'fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '8.00', 'celsius', '', '2010-05-28 13:22:03', 1, '2010-05-28 16:08:50', 1, 39, '2010-05-28 16:08:50', 0, NULL),
(2, 'SH - 2', 'shelf', 14, 1, 2, 13, '-', '1', 'fr1-1', '', NULL, NULL, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:22:54', 1, '2010-05-28 16:08:51', 1, 40, '2010-05-28 16:08:51', 0, NULL),
(3, 'R10 - 3', 'rack10', 12, 2, 3, 8, 'bc78904', 'r1', 'fr1-1-r1', '', NULL, NULL, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:23:47', 1, '2010-05-28 16:08:51', 1, 41, '2010-05-28 16:08:52', 0, NULL),
(6, 'R10 - 6', 'rack10', 12, 2, 9, 12, 'bc988900', 'r2', 'fr1-1-r2', '', NULL, NULL, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:29:19', 1, '2010-05-28 16:08:52', 1, 42, '2010-05-28 16:08:52', 0, NULL),
(4, 'B2D81 - 4', 'box81 1A-9I', 9, 3, 4, 5, 'bc9973900', '001', 'fr1-1-r1-001', '', '1', 5, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:24:30', 1, '2010-05-28 16:08:53', 1, 43, '2010-05-28 16:08:53', 0, NULL),
(5, 'B25 - 5', 'box25', 17, 3, 6, 7, 'bc8978732', '002', 'fr1-1-r1-002', '', '2', 1, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:25:46', 1, '2010-05-28 16:08:53', 1, 44, '2010-05-28 16:08:54', 0, NULL),
(7, 'B25 - 7', 'box25', 17, 6, 10, 11, 'bc87987876', '003', 'fr1-1-r2-003', '', '3', 2, NULL, NULL, 'FALSE', '8.00', 'celsius', '', '2010-05-28 13:38:47', 1, '2010-05-28 16:08:54', 1, 45, '2010-05-28 16:08:54', 0, NULL);

--
-- Contenu de la table `study_contacts`
--


--
-- Contenu de la table `study_contacts_revs`
--


--
-- Contenu de la table `study_ethics_boards`
--


--
-- Contenu de la table `study_ethics_boards_revs`
--


--
-- Contenu de la table `study_fundings`
--


--
-- Contenu de la table `study_fundings_revs`
--


--
-- Contenu de la table `study_investigators`
--


--
-- Contenu de la table `study_investigators_revs`
--


--
-- Contenu de la table `study_related`
--


--
-- Contenu de la table `study_related_revs`
--


--
-- Contenu de la table `study_results`
--


--
-- Contenu de la table `study_results_revs`
--


--
-- Contenu de la table `study_reviews`
--


--
-- Contenu de la table `study_reviews_revs`
--


--
-- Contenu de la table `study_summaries`
--

INSERT INTO `study_summaries` (`id`, `disease_site`, `study_type`, `study_science`, `study_use`, `title`, `start_date`, `end_date`, `summary`, `abstract`, `hypothesis`, `approach`, `analysis`, `significance`, `additional_clinical`, `created`, `created_by`, `modified`, `modified_by`, `path_to_file`, `deleted`, `deleted_date`) VALUES
(1, 'gynaecologic', 'prospective', 'basic', '', 'OP 987 Std1', '2010-05-04', '2010-10-05', '', '', '', '', '', '', '', '2010-05-28 11:29:52', 1, '2010-05-28 11:29:52', 1, '', 0, NULL);

--
-- Contenu de la table `study_summaries_revs`
--

INSERT INTO `study_summaries_revs` (`id`, `disease_site`, `study_type`, `study_science`, `study_use`, `title`, `start_date`, `end_date`, `summary`, `abstract`, `hypothesis`, `approach`, `analysis`, `significance`, `additional_clinical`, `created`, `created_by`, `modified`, `modified_by`, `path_to_file`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 'gynaecologic', 'prospective', 'basic', '', 'OP 987 Std1', '2010-05-04', '2010-10-05', '', '', '', '', '', '', '', '2010-05-28 11:29:52', 1, '2010-05-28 11:29:52', 1, '', 1, '2010-05-28 11:29:52', 0, NULL);

--
-- Contenu de la table `tma_slides`
--

INSERT INTO `tma_slides` (`id`, `tma_block_storage_master_id`, `barcode`, `product_code`, `sop_master_id`, `immunochemistry`, `picture_path`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `coord_x_order`, `storage_coord_y`, `coord_y_order`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 11, 'sl9898', NULL, 1, 'ac412', '/tmp/899', '2010-05-03 00:00:00', 2, '', NULL, '', NULL, '2010-05-28 13:54:05', 1, '2010-05-28 13:56:20', 1, 0, NULL);

--
-- Contenu de la table `tma_slides_revs`
--

INSERT INTO `tma_slides_revs` (`id`, `tma_block_storage_master_id`, `barcode`, `product_code`, `sop_master_id`, `immunochemistry`, `picture_path`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `coord_x_order`, `storage_coord_y`, `coord_y_order`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 11, 'sl9898', NULL, 1, 'ac412', '/tmp/899', '2010-05-03 00:00:00', 3, '8', 7, '', NULL, '2010-05-28 13:54:05', 1, '2010-05-28 13:54:05', 1, 1, '2010-05-28 13:54:05', 0, NULL),
(1, 11, 'sl9898', NULL, 1, 'ac412', '/tmp/899', '2010-05-03 00:00:00', 2, '', NULL, '', NULL, '2010-05-28 13:54:05', 1, '2010-05-28 13:56:20', 1, 2, '2010-05-28 13:56:20', 0, NULL);

--
-- Contenu de la table `txd_chemos`
--

INSERT INTO `txd_chemos` (`id`, `chemo_completed`, `response`, `num_cycles`, `length_cycles`, `completed_cycles`, `created`, `created_by`, `modified`, `modified_by`, `tx_master_id`, `deleted`, `deleted_date`) VALUES
(1, 'yes', 'complete', 2, 3, NULL, '2010-05-28 14:23:14', 1, '2010-05-28 14:23:14', 1, 1, 0, NULL),
(2, 'no', '', NULL, NULL, NULL, '2010-05-28 14:26:17', 1, '2010-05-28 14:26:17', 1, 2, 0, NULL);

--
-- Contenu de la table `txd_chemos_revs`
--

INSERT INTO `txd_chemos_revs` (`id`, `chemo_completed`, `response`, `num_cycles`, `length_cycles`, `completed_cycles`, `created`, `created_by`, `modified`, `modified_by`, `tx_master_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 'yes', 'complete', 2, 3, NULL, '2010-05-28 14:23:14', 1, '2010-05-28 14:23:14', 1, 1, 1, '2010-05-28 14:23:14', 0, NULL),
(2, 'no', '', NULL, NULL, NULL, '2010-05-28 14:26:17', 1, '2010-05-28 14:26:17', 1, 2, 2, '2010-05-28 14:26:17', 0, NULL);

--
-- Contenu de la table `txd_radiations`
--


--
-- Contenu de la table `txd_radiations_revs`
--


--
-- Contenu de la table `txd_surgeries`
--

INSERT INTO `txd_surgeries` (`id`, `path_num`, `primary`, `tx_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, '67yf45', NULL, 3, '2010-05-28 14:27:24', 1, '2010-05-28 14:27:24', 1, 0, NULL);

--
-- Contenu de la table `txd_surgeries_revs`
--

INSERT INTO `txd_surgeries_revs` (`id`, `path_num`, `primary`, `tx_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, '67yf45', NULL, 3, '2010-05-28 14:27:24', 1, '2010-05-28 14:27:24', 1, 0, NULL, 1, '2010-05-28 14:27:24');

--
-- Contenu de la table `txe_chemos`
--

INSERT INTO `txe_chemos` (`id`, `dose`, `method`, `drug_id`, `tx_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, '34', 'IV: Intravenous', 1, 1, '2010-05-28 14:23:55', 1, '2010-05-28 14:23:55', 1, 0, NULL),
(2, '', 'IV: Intravenous', 3, 1, '2010-05-28 14:23:55', 1, '2010-05-28 14:23:55', 1, 0, NULL),
(3, '', 'IV: Intravenous', 2, 1, '2010-05-28 14:24:15', 1, '2010-05-28 14:24:15', 1, 0, NULL);

--
-- Contenu de la table `txe_chemos_revs`
--


--
-- Contenu de la table `txe_radiations`
--


--
-- Contenu de la table `txe_radiations_revs`
--


--
-- Contenu de la table `txe_surgeries`
--


--
-- Contenu de la table `txe_surgeries_revs`
--


--
-- Contenu de la table `tx_masters`
--

INSERT INTO `tx_masters` (`id`, `treatment_control_id`, `tx_method`, `disease_site`, `tx_intent`, `target_site_icdo`, `start_date`, `start_date_accuracy`, `finish_date`, `finish_date_accuracy`, `information_source`, `facility`, `notes`, `protocol_master_id`, `participant_id`, `diagnosis_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 'chemotherapy', 'all', 'curative', '', '2003-03-14', '', '2003-03-15', '', '', 'Building A', '', 1, 1, 2, '2010-05-28 14:23:14', 1, '2010-05-28 14:23:14', 1, 0, NULL),
(2, 1, 'chemotherapy', 'all', 'curative', '', '2003-05-01', '', NULL, '', '', 'Building A', '', NULL, 1, 2, '2010-05-28 14:26:16', 1, '2010-05-28 14:26:16', 1, 0, NULL),
(3, 3, 'surgery', 'all', '', '', '2003-04-23', '', NULL, '', '', '', '', NULL, 1, 2, '2010-05-28 14:27:24', 1, '2010-05-28 14:27:24', 1, 0, NULL);

--
-- Contenu de la table `tx_masters_revs`
--

INSERT INTO `tx_masters_revs` (`id`, `treatment_control_id`, `tx_method`, `disease_site`, `tx_intent`, `target_site_icdo`, `start_date`, `start_date_accuracy`, `finish_date`, `finish_date_accuracy`, `information_source`, `facility`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `protocol_master_id`, `participant_id`, `diagnosis_master_id`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, 1, 'chemotherapy', 'all', 'curative', '', '2003-03-14', '', '2003-03-15', '', '', 'Building A', '', '2010-05-28 14:23:14', 1, '2010-05-28 14:23:14', 1, 1, 1, 2, 0, NULL, 1, '2010-05-28 14:23:15'),
(2, 1, 'chemotherapy', 'all', 'curative', '', '2003-05-01', '', NULL, '', '', 'Building A', '', '2010-05-28 14:26:16', 1, '2010-05-28 14:26:16', 1, NULL, 1, 2, 0, NULL, 2, '2010-05-28 14:26:17'),
(3, 3, 'surgery', 'all', '', '', '2003-04-23', '', NULL, '', '', '', '', '2010-05-28 14:27:24', 1, '2010-05-28 14:27:24', 1, NULL, 1, 2, 0, NULL, 3, '2010-05-28 14:27:25');

--
-- Contenu de la table `user_logs`
--

SET FOREIGN_KEY_CHECKS=1;