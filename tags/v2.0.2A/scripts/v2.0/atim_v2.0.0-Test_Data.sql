-- ------------------------------------------------------------------------------------------------------------
SET FOREIGN_KEY_CHECKS=0;
-- ------------------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------------------
--
-- TOOLS
--
-- ------------------------------------------------------------------------------------------------------------

-- Protocol Masters, Protocol Details, and Protocol Extends Test Data


-- Materials Test data


-- Drugs Test Data

-- Orders Test Data

INSERT INTO `orders` (`id`, `order_number`, `short_title`, `description`, `date_order_placed`, `date_order_completed`, `processing_status`, `comments`, `created`, `created_by`, `modified`, `modified_by`, `study_summary_id`, `deleted`, `deleted_date`) VALUES
(1, 'Ord_Test1', 'TO_001', '...', '2010-01-03', '2010-02-19', 'pending', '', '2010-01-21 10:14:38', '1', '2010-01-21 10:14:38', '1', 2, 0, NULL),
(2, 'Ord_test2', 'TO_002', '', '2010-01-06', NULL, 'pending', '', '2010-01-21 10:17:57', '1', '2010-01-21 10:18:29', '1', 1, 0, NULL);
INSERT INTO `orders_revs` (`id`, `order_number`, `short_title`, `description`, `date_order_placed`, `date_order_completed`, `processing_status`, `comments`, `created`, `created_by`, `modified`, `modified_by`, `study_summary_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 'Ord_Test1', 'TO_001', '...', '2010-01-03', '2010-02-19', 'pending', '', '2010-01-21 10:14:38', '1', '2010-01-21 10:14:38', '1', 2, 1, '2010-01-21 10:14:38', 0, NULL),
(2, 'Ord_test2', '', '', NULL, NULL, '', '', '2010-01-21 10:17:57', '1', '2010-01-21 10:17:57', '1', NULL, 2, '2010-01-21 10:17:57', 0, NULL),
(2, 'Ord_test2', 'TO_002', '', '2010-01-06', NULL, 'pending', '', '2010-01-21 10:17:57', '1', '2010-01-21 10:18:29', '1', 1, 3, '2010-01-21 10:18:29', 0, NULL);
INSERT INTO `order_lines` (`id`, `quantity_ordered`, `min_quantity_ordered`, `quantity_unit`, `date_required`, `status`, `created`, `created_by`, `modified`, `modified_by`, `product_code`, `sample_control_id`, `aliquot_control_id`, `sample_aliquot_precision`, `order_id`, `deleted`, `deleted_date`) VALUES
(1, '10', '', 'tubes', '2010-01-22', 'pending', '2010-01-21 10:15:27', '1', '2010-01-21 10:15:27', '1', '', 12, NULL, 'precision 1', 1, 0, NULL),
(2, '50', '', 'ml', '2010-01-22', 'pending', '2010-01-21 10:16:57', '1', '2010-01-21 10:16:57', '1', '', 8, 15, 'Frozen', 1, 0, NULL),
(3, '4', '', 'blcoks', NULL, 'pending', '2010-01-21 10:19:07', '1', '2010-01-21 10:19:07', '1', '', 3, 4, 'OCT', 2, 0, NULL);
INSERT INTO `order_lines_revs` (`id`, `quantity_ordered`, `min_quantity_ordered`, `quantity_unit`, `date_required`, `status`, `created`, `created_by`, `modified`, `modified_by`, `product_code`, `sample_control_id`, `aliquot_control_id`, `sample_aliquot_precision`, `order_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '10', '', 'tubes', '2010-01-22', 'pending', '2010-01-21 10:15:27', '1', '2010-01-21 10:15:27', '1', '', 12, NULL, 'precision 1', 1, 1, '2010-01-21 10:15:27', 0, NULL),
(2, '50', '', 'ml', '2010-01-22', 'pending', '2010-01-21 10:16:57', '1', '2010-01-21 10:16:57', '1', '', 8, 15, 'Frozen', 1, 2, '2010-01-21 10:16:57', 0, NULL),
(3, '4', '', 'blcoks', NULL, 'pending', '2010-01-21 10:19:07', '1', '2010-01-21 10:19:07', '1', '', 3, 4, 'OCT', 2, 3, '2010-01-21 10:19:07', 0, NULL);

-- Study Test Data

INSERT INTO `study_summaries` (`id`, `disease_site`, `study_type`, `study_science`, `study_use`, `title`, `start_date`, `end_date`, `summary`, `abstract`, `hypothesis`, `approach`, `analysis`, `significance`, `additional_clinical`, `created`, `created_by`, `modified`, `modified_by`, `path_to_file`, `deleted`, `deleted_date`) VALUES
(1, 'breast', 'prospective', 'basic', 'academic', 'Study_test_1', '2009-11-13', '2010-05-22', '...', '', '', '', '', '', '', '2010-01-20', '1', '2010-01-20', '1', '', 0, NULL),
(2, 'lung', 'prospective', 'basic', 'academic', 'Study_test_2', '2008-11-07', '2010-12-03', '...', '', '', '', '', '', '', '2010-01-20', '1', '2010-01-20', '1', '', 0, NULL);
INSERT INTO `study_summaries_revs` (`id`, `disease_site`, `study_type`, `study_science`, `study_use`, `title`, `start_date`, `end_date`, `summary`, `abstract`, `hypothesis`, `approach`, `analysis`, `significance`, `additional_clinical`, `created`, `created_by`, `modified`, `modified_by`, `path_to_file`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 'breast', 'prospective', 'basic', 'academic', 'Study_test_1', '2009-11-13', '2010-05-22', '...', '', '', '', '', '', '', '2010-01-20', '1', '2010-01-20', '1', '', 1, '2010-01-20 10:51:28', 0, NULL),
(2, 'lung', 'prospective', 'basic', 'academic', 'Study_test_2', '2008-11-07', '2010-12-03', '...', '', '', '', '', '', '', '2010-01-20', '1', '2010-01-20', '1', '', 2, '2010-01-20 10:51:56', 0, NULL);

-- SOP Masters, Sop Details, and Sop Extends Test Data

INSERT INTO `sopd_general_all` (`id`, `value`, `created`, `created_by`, `modified`, `modified_by`, `sop_master_id`, `deleted`, `deleted_date`) VALUES
(1, NULL, '2009-12-08 13:26:24', '1', '2009-12-08 13:26:24', '1', 1, 0, NULL),
(2, NULL, '2009-12-08 13:26:34', '1', '2009-12-08 13:26:34', '1', 2, 0, NULL);
INSERT INTO `sopd_general_all_revs` (`id`, `value`, `created`, `created_by`, `modified`, `modified_by`, `sop_master_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, NULL, '2009-12-08 13:26:24', '1', '2009-12-08 13:26:24', '1', 1, 1, '2009-12-08 13:26:24', 0, NULL),
(2, NULL, '2009-12-08 13:26:34', '1', '2009-12-08 13:26:34', '1', 2, 2, '2009-12-08 13:26:34', 0, NULL);
INSERT INTO `sop_masters` (`id`, `sop_control_id`, `title`, `notes`, `code`, `version`, `sop_group`, `type`, `status`, `expiry_date`, `activated_date`, `scope`, `purpose`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `deleted`, `deleted_date`) VALUES
(1, 1, 'SOP1', '', '809038SOP', '', 'General', 'All', '', NULL, NULL, '', '', '2009-12-08 13:26:23', '1', '2009-12-08 13:26:23', '1', NULL, 0, NULL),
(2, 1, 'SOP2', '', '7890083SOP', '', 'General', 'All', '', NULL, NULL, '', '', '2009-12-08 13:26:34', '1', '2009-12-08 13:26:34', '1', NULL, 0, NULL);
INSERT INTO `sop_masters_revs` (`id`, `sop_control_id`, `title`, `notes`, `code`, `version`, `sop_group`, `type`, `status`, `expiry_date`, `activated_date`, `scope`, `purpose`, `created`, `created_by`, `modified`, `modified_by`, `form_id`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, 'SOP1', '', '809038SOP', '', 'General', 'All', '', NULL, NULL, '', '', '2009-12-08 13:26:23', '1', '2009-12-08 13:26:23', '1', NULL, 1, '2009-12-08 13:26:24', 0, NULL),
(2, 1, 'SOP2', '', '7890083SOP', '', 'General', 'All', '', NULL, NULL, '', '', '2009-12-08 13:26:34', '1', '2009-12-08 13:26:34', '1', NULL, 2, '2009-12-08 13:26:34', 0, NULL);

-- Storages Test Data

INSERT INTO `std_boxs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 4, '2009-12-08 14:07:58', '1', '2009-12-08 14:08:10', '1', 0, NULL),
(2, 5, '2009-12-08 14:09:56', '1', '2009-12-08 14:13:09', '1', 0, NULL),
(3, 14, '2009-12-08 14:23:31', '1', '2009-12-08 14:23:43', '1', 0, NULL),
(4, 15, '2009-12-08 14:24:12', '1', '2009-12-08 14:24:13', '1', 0, NULL),
(5, 16, '2009-12-08 14:24:20', '1', '2009-12-08 14:24:20', '1', 0, NULL),
(6, 17, '2009-12-08 14:24:35', '1', '2009-12-08 14:24:35', '1', 0, NULL),
(7, 18, '2009-12-08 14:24:44', '1', '2009-12-08 14:24:45', '1', 0, NULL),
(8, 19, '2009-12-08 14:24:57', '1', '2009-12-08 14:24:57', '1', 0, NULL);
INSERT INTO `std_boxs_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 4, '2009-12-08 14:07:58', '1', '2009-12-08 14:07:58', '1', 1, '2009-12-08 14:07:58', 0, NULL),
(1, 4, '2009-12-08 14:07:58', '1', '2009-12-08 14:08:10', '1', 2, '2009-12-08 14:08:10', 0, NULL),
(2, 5, '2009-12-08 14:09:56', '1', '2009-12-08 14:09:56', '1', 3, '2009-12-08 14:09:56', 0, NULL),
(2, 5, '2009-12-08 14:09:56', '1', '2009-12-08 14:10:09', '1', 4, '2009-12-08 14:10:09', 0, NULL),
(2, 5, '2009-12-08 14:09:56', '1', '2009-12-08 14:13:09', '1', 5, '2009-12-08 14:13:09', 0, NULL),
(3, 14, '2009-12-08 14:23:31', '1', '2009-12-08 14:23:31', '1', 6, '2009-12-08 14:23:32', 0, NULL),
(3, 14, '2009-12-08 14:23:31', '1', '2009-12-08 14:23:32', '1', 7, '2009-12-08 14:23:32', 0, NULL),
(3, 14, '2009-12-08 14:23:31', '1', '2009-12-08 14:23:43', '1', 8, '2009-12-08 14:23:43', 0, NULL),
(4, 15, '2009-12-08 14:24:12', '1', '2009-12-08 14:24:12', '1', 9, '2009-12-08 14:24:12', 0, NULL),
(4, 15, '2009-12-08 14:24:12', '1', '2009-12-08 14:24:13', '1', 10, '2009-12-08 14:24:13', 0, NULL),
(5, 16, '2009-12-08 14:24:20', '1', '2009-12-08 14:24:20', '1', 11, '2009-12-08 14:24:20', 0, NULL),
(6, 17, '2009-12-08 14:24:35', '1', '2009-12-08 14:24:35', '1', 12, '2009-12-08 14:24:35', 0, NULL),
(7, 18, '2009-12-08 14:24:44', '1', '2009-12-08 14:24:44', '1', 13, '2009-12-08 14:24:44', 0, NULL),
(7, 18, '2009-12-08 14:24:44', '1', '2009-12-08 14:24:45', '1', 14, '2009-12-08 14:24:45', 0, NULL),
(8, 19, '2009-12-08 14:24:57', '1', '2009-12-08 14:24:57', '1', 15, '2009-12-08 14:24:57', 0, NULL);
INSERT INTO `std_cupboards` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 3, '2009-12-08 13:37:17', '1', '2009-12-08 13:37:17', '1', 0, NULL);
INSERT INTO `std_cupboards_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 3, '2009-12-08 13:37:17', '1', '2009-12-08 13:37:17', '1', 1, '2009-12-08 13:37:17', 0, NULL);
INSERT INTO `std_freezers` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 7, '2009-12-08 14:18:47', '1', '2009-12-08 14:20:32', '1', 0, NULL);
INSERT INTO `std_freezers_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 7, '2009-12-08 14:18:47', '1', '2009-12-08 14:18:47', '1', 1, '2009-12-08 14:18:47', 0, NULL),
(1, 7, '2009-12-08 14:18:47', '1', '2009-12-08 14:20:32', '1', 2, '2009-12-08 14:20:32', 0, NULL);
INSERT INTO `std_racks` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 12, '2009-12-08 14:22:15', '1', '2009-12-08 14:22:15', '1', 0, NULL),
(2, 13, '2009-12-08 14:22:26', '1', '2009-12-08 14:22:26', '1', 0, NULL);
INSERT INTO `std_racks_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 12, '2009-12-08 14:22:15', '1', '2009-12-08 14:22:15', '1', 1, '2009-12-08 14:22:15', 0, NULL),
(2, 13, '2009-12-08 14:22:26', '1', '2009-12-08 14:22:26', '1', 2, '2009-12-08 14:22:26', 0, NULL);
INSERT INTO `std_rooms` (`id`, `storage_master_id`, `laboratory`, `floor`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 2, 'CTRNet', '4', '2009-12-08 13:36:22', '1', '2009-12-08 13:36:46', '1', 0, NULL),
(2, 6, 'CTRNet', '2', '2009-12-08 14:14:32', '1', '2009-12-08 14:15:19', '1', 0, NULL);
INSERT INTO `std_rooms_revs` (`id`, `storage_master_id`, `laboratory`, `floor`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 2, 'CTRNet', '4', '2009-12-08 13:36:22', '1', '2009-12-08 13:36:22', '1', 1, '2009-12-08 13:36:22', 0, NULL),
(1, 2, 'CTRNet', '4', '2009-12-08 13:36:22', '1', '2009-12-08 13:36:23', '1', 2, '2009-12-08 13:36:23', 0, NULL),
(1, 2, 'CTRNet', '4', '2009-12-08 13:36:22', '1', '2009-12-08 13:36:46', '1', 3, '2009-12-08 13:36:46', 0, NULL),
(2, 6, '', '', '2009-12-08 14:14:32', '1', '2009-12-08 14:14:32', '1', 4, '2009-12-08 14:14:32', 0, NULL),
(2, 6, '', '', '2009-12-08 14:14:32', '1', '2009-12-08 14:14:33', '1', 5, '2009-12-08 14:14:33', 0, NULL),
(2, 6, 'CTRNet', '2', '2009-12-08 14:14:32', '1', '2009-12-08 14:15:19', '1', 6, '2009-12-08 14:15:19', 0, NULL);
INSERT INTO `std_shelfs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 8, '2009-12-08 14:20:58', '1', '2009-12-08 14:20:58', '1', 0, NULL),
(2, 9, '2009-12-08 14:21:06', '1', '2009-12-08 14:21:06', '1', 0, NULL),
(3, 10, '2009-12-08 14:21:20', '1', '2009-12-08 14:21:21', '1', 0, NULL),
(4, 11, '2009-12-08 14:21:29', '1', '2009-12-08 14:21:29', '1', 0, NULL);
INSERT INTO `std_shelfs_revs` (`id`, `storage_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 8, '2009-12-08 14:20:58', '1', '2009-12-08 14:20:58', '1', 1, '2009-12-08 14:20:58', 0, NULL),
(2, 9, '2009-12-08 14:21:06', '1', '2009-12-08 14:21:06', '1', 2, '2009-12-08 14:21:06', 0, NULL),
(3, 10, '2009-12-08 14:21:20', '1', '2009-12-08 14:21:20', '1', 3, '2009-12-08 14:21:20', 0, NULL),
(3, 10, '2009-12-08 14:21:20', '1', '2009-12-08 14:21:21', '1', 4, '2009-12-08 14:21:21', 0, NULL),
(4, 11, '2009-12-08 14:21:29', '1', '2009-12-08 14:21:29', '1', 5, '2009-12-08 14:21:29', 0, NULL);
INSERT INTO `std_tma_blocks` (`id`, `storage_master_id`, `sop_master_id`, `product_code`, `creation_datetime`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 2, NULL, '2009-12-10 00:00:00', '2009-12-08 13:30:24', '1', '2009-12-08 14:08:54', '1', 0, NULL);
INSERT INTO `std_tma_blocks_revs` (`id`, `storage_master_id`, `sop_master_id`, `product_code`, `creation_datetime`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, 1, NULL, '2009-12-10 00:00:00', '2009-12-08 13:30:24', '1', '2009-12-08 13:30:24', '1', 1, '2009-12-08 13:30:24', 0, NULL),
(1, 1, 2, NULL, '2009-12-10 00:00:00', '2009-12-08 13:30:24', '1', '2009-12-08 13:30:40', '1', 2, '2009-12-08 13:30:40', 0, NULL),
(1, 1, 2, NULL, '2009-12-10 00:00:00', '2009-12-08 13:30:24', '1', '2009-12-08 13:42:55', '1', 3, '2009-12-08 13:42:55', 0, NULL),
(1, 1, 2, NULL, '2009-12-10 00:00:00', '2009-12-08 13:30:24', '1', '2009-12-08 13:43:37', '1', 4, '2009-12-08 13:43:37', 0, NULL),
(1, 1, 2, NULL, '2009-12-10 00:00:00', '2009-12-08 13:30:24', '1', '2009-12-08 13:46:27', '1', 5, '2009-12-08 13:46:27', 0, NULL),
(1, 1, 2, NULL, '2009-12-10 00:00:00', '2009-12-08 13:30:24', '1', '2009-12-08 14:05:02', '1', 6, '2009-12-08 14:05:02', 0, NULL),
(1, 1, 2, NULL, '2009-12-10 00:00:00', '2009-12-08 13:30:24', '1', '2009-12-08 14:05:51', '1', 7, '2009-12-08 14:05:51', 0, NULL),
(1, 1, 2, NULL, '2009-12-10 00:00:00', '2009-12-08 13:30:24', '1', '2009-12-08 14:08:54', '1', 8, '2009-12-08 14:08:54', 0, NULL);
INSERT INTO `storage_coordinates` (`id`, `storage_master_id`, `dimension`, `coordinate_value`, `order`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 3, 'x', 'sh1_slide', 1, '2009-12-08 13:37:42', '1', '2009-12-08 13:37:42', '1', 0, NULL),
(2, 3, 'x', 'sh2_block', 3, '2009-12-08 13:38:02', '1', '2009-12-08 13:38:02', '1', 0, NULL),
(3, 3, 'x', 'sh_main', 2, '2009-12-08 13:38:09', '1', '2009-12-08 13:38:09', '1', 0, NULL);
INSERT INTO `storage_coordinates_revs` (`id`, `storage_master_id`, `dimension`, `coordinate_value`, `order`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 3, 'x', 'sh1_slide', 1, '2009-12-08 13:37:42', '1', '2009-12-08 13:37:42', '1', 1, '2009-12-08 13:37:42', 0, NULL),
(2, 3, 'x', 'sh2_block', 2, '2009-12-08 13:38:02', '1', '2009-12-08 13:38:02', '1', 2, '2009-12-08 13:38:02', 0, NULL),
(3, 3, 'x', 'sh_main', 2, '2009-12-08 13:38:09', '1', '2009-12-08 13:38:09', '1', 3, '2009-12-08 13:38:09', 0, NULL);
INSERT INTO `storage_masters` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `coord_x_order`, `parent_storage_coord_y`, `coord_y_order`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'TMA345 - 1', 'TMA-blc 23X15', 19, 4, 4, 5, 'TMA_blc899763', 'tm1', 'r1-cb1-bb1-tm1', '', NULL, NULL, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 13:30:24', '1', '2009-12-08 14:08:54', '1', 0, NULL),
(2, 'R - 2', 'room', 1, NULL, 1, 36, '9800237ROOM1', 'r1', 'r1', '', NULL, NULL, NULL, NULL, 'TRUE', '21.00', 'celsius', '', '2009-12-08 13:36:22', '1', '2009-12-08 13:36:46', '1', 0, NULL),
(3, 'CP - 3', 'cupboard', 2, 2, 2, 9, '89004812CB837', 'cb1', 'r1-cb1', '', NULL, NULL, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 13:37:17', '1', '2009-12-08 13:37:17', '1', 0, NULL),
(4, 'B - 4', 'box', 8, 3, 3, 6, '8998736B1', 'bb1', 'r1-cb1-bb1', '', 'sh2_block', 3, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 14:07:58', '1', '2009-12-08 14:08:09', '1', 0, NULL),
(5, 'B - 5', 'box', 8, 3, 7, 8, '43423442b4', 'bb2', 'r1-cb1-bb2', '', 'sh1_slide', 1, NULL, NULL, 'FALSE', '21.00', 'celsius', 'Box for tma slide', '2009-12-08 14:09:56', '1', '2009-12-08 14:13:09', '1', 0, NULL),
(6, 'R - 6', 'room', 1, NULL, 37, 38, '4247263472FR1', 'fr1', 'fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '22.00', 'celsius', '', '2009-12-08 14:14:32', '1', '2009-12-08 14:15:19', '1', 0, NULL),
(7, 'FRE - 7', 'freezer', 6, 2, 10, 35, '78840033FR2', 'fr2', 'r1-fr2', '', NULL, NULL, NULL, NULL, 'TRUE', '-82.00', 'celsius', '', '2009-12-08 14:18:47', '1', '2009-12-08 14:20:31', '1', 0, NULL),
(8, 'SH - 8', 'shelf', 14, 7, 11, 12, '000000001', 'sh1', 'r1-fr2-sh1', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:20:58', '1', '2009-12-08 14:20:58', '1', 0, NULL),
(9, 'SH - 9', 'shelf', 14, 7, 13, 30, '000000002', 'sh2', 'r1-fr2-sh2', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:21:06', '1', '2009-12-08 14:21:06', '1', 0, NULL),
(10, 'SH - 10', 'shelf', 14, 7, 31, 32, '000000003', 'sh3', 'r1-fr2-sh3', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:21:20', '1', '2009-12-08 14:21:20', '1', 0, NULL),
(11, 'SH - 11', 'shelf', 14, 7, 33, 34, '000000004', 'sh4', 'r1-fr2-sh4', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:21:29', '1', '2009-12-08 14:21:29', '1', 0, NULL),
(12, 'R2D16 - 12', 'rack16', 11, 9, 14, 27, '8890238', 'R1', 'r1-fr2-sh2-R1', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:22:14', '1', '2009-12-08 14:22:15', '1', 0, NULL),
(13, 'R2D16 - 13', 'rack16', 11, 9, 28, 29, '8890238S', 'R2', 'r1-fr2-sh2-R2', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:22:26', '1', '2009-12-08 14:22:26', '1', 0, NULL),
(14, 'B25 - 14', 'box25', 17, 12, 15, 16, '5234234234', 'B2.2', 'r1-fr2-sh2-R1-B2.2', '', 'A', 0, NULL, 0, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:23:31', '1', '2009-12-08 14:23:42', '1', 0, NULL),
(15, 'B2D81 - 15', 'box81 1A-9I', 9, 12, 17, 18, 'AS32112', 'B2.3', 'r1-fr2-sh2-R1-B2.3', '', 'C', NULL, '2', NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:12', '1', '2009-12-08 14:24:12', '1', 0, NULL),
(16, 'B2D81 - 16', 'box81 1A-9I', 9, 12, 19, 20, 'AS32112ASASD', 'B2.4', 'r1-fr2-sh2-R1-B2.4', '', 'C', NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:20', '1', '2009-12-08 14:24:20', '1', 0, NULL),
(17, 'B2D81 - 17', 'box81 1A-9I', 9, 12, 21, 22, '00984', 'B2.007', 'r1-fr2-sh2-R1-B2.007', '', 'B', NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:35', '1', '2009-12-08 14:24:35', '1', 0, NULL),
(18, 'B2D81 - 18', 'box81 1A-9I', 9, 12, 23, 24, '33211221', 'B2.12', 'r1-fr2-sh2-R1-B2.12', '', 'B', NULL, '2', NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:44', '1', '2009-12-08 14:24:44', '1', 0, NULL),
(19, 'B2D81 - 19', 'box81 1A-9I', 9, 12, 25, 26, '332323', 'B2.111', 'r1-fr2-sh2-R1-B2.111', '', 'A', NULL, '2', NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:57', '1', '2009-12-08 14:24:57', '1', 0, NULL);
INSERT INTO `storage_masters_revs` (`id`, `code`, `storage_type`, `storage_control_id`, `parent_id`, `lft`, `rght`, `barcode`, `short_label`, `selection_label`, `storage_status`, `parent_storage_coord_x`, `coord_x_order`, `parent_storage_coord_y`, `coord_y_order`, `set_temperature`, `temperature`, `temp_unit`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '', 'TMA-blc 23X15', 19, NULL, 1, 2, 'TMA_blc899763', 'tm1', 'tm1', '', NULL, NULL, NULL, NULL, 'FALSE', NULL, NULL, '', '2009-12-08 13:30:24', '1', '2009-12-08 13:30:24', '1', 1, '2009-12-08 13:30:24', 0, NULL),
(1, 'TMA345 - 1', 'TMA-blc 23X15', 19, NULL, 1, 2, 'TMA_blc899763', 'tm1', 'tm1', '', NULL, NULL, NULL, NULL, 'FALSE', NULL, NULL, '', '2009-12-08 13:30:24', '1', '2009-12-08 13:30:24', '1', 2, '2009-12-08 13:30:24', 0, NULL),
(1, 'TMA345 - 1', 'TMA-blc 23X15', 19, NULL, 1, 2, 'TMA_blc899763', 'tm1', 'tm1', '', NULL, NULL, NULL, NULL, 'FALSE', NULL, NULL, '', '2009-12-08 13:30:24', '1', '2009-12-08 13:30:40', '1', 3, '2009-12-08 13:30:40', 0, NULL),
(2, '', 'room', 1, NULL, 3, 4, '9800237ROOM1', 'r1', 'r1', '', NULL, NULL, NULL, NULL, 'TRUE', NULL, '', '', '2009-12-08 13:36:22', '1', '2009-12-08 13:36:22', '1', 4, '2009-12-08 13:36:22', 0, NULL),
(2, 'R - 2', 'room', 1, NULL, 3, 4, '9800237ROOM1', 'r1', 'r1', '', NULL, NULL, NULL, NULL, 'TRUE', NULL, '', '', '2009-12-08 13:36:22', '1', '2009-12-08 13:36:22', '1', 5, '2009-12-08 13:36:23', 0, NULL),
(2, 'R - 2', 'room', 1, NULL, 3, 4, '9800237ROOM1', 'r1', 'r1', '', NULL, NULL, NULL, NULL, 'TRUE', '21.00', 'celsius', '', '2009-12-08 13:36:22', '1', '2009-12-08 13:36:46', '1', 6, '2009-12-08 13:36:46', 0, NULL),
(3, '', 'cupboard', 2, 2, 0, 0, '89004812CB837', 'cb1', 'r1-cb1', '', NULL, NULL, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 13:37:17', '1', '2009-12-08 13:37:17', '1', 7, '2009-12-08 13:37:17', 0, NULL),
(3, 'CP - 3', 'cupboard', 2, 2, 4, 5, '89004812CB837', 'cb1', 'r1-cb1', '', NULL, NULL, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 13:37:17', '1', '2009-12-08 13:37:17', '1', 8, '2009-12-08 13:37:17', 0, NULL),
(1, 'TMA345 - 1', 'TMA-blc 23X15', 19, 3, 1, 2, 'TMA_blc899763', 'tm1', 'r1-cb1-tm1', '', NULL, NULL, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 13:30:24', '1', '2009-12-08 13:42:55', '1', 9, '2009-12-08 13:42:55', 0, NULL),
(1, 'TMA345 - 1', 'TMA-blc 23X15', 19, 3, 3, 4, 'TMA_blc899763', 'tm1', 'r1-cb1-tm1', '', 'sh1_slide', 1, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 13:30:24', '1', '2009-12-08 13:43:36', '1', 10, '2009-12-08 13:43:37', 0, NULL),
(1, 'TMA345 - 1', 'TMA-blc 23X15', 19, 3, 3, 4, 'TMA_blc899763', 'tm1', 'r1-cb1-tm1', '', 'sh2_block', 3, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 13:30:24', '1', '2009-12-08 13:46:27', '1', 11, '2009-12-08 13:46:27', 0, NULL),
(1, 'TMA345 - 1', 'TMA-blc 23X15', 19, 3, 3, 4, 'TMA_blc899763', 'tm1', 'r1-cb1-tm1', '', 'sh_main', 2, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 13:30:24', '1', '2009-12-08 14:05:02', '1', 12, '2009-12-08 14:05:02', 0, NULL),
(1, 'TMA345 - 1', 'TMA-blc 23X15', 19, 3, 3, 4, 'TMA_blc899763', 'tm1', 'r1-cb1-tm1', '', 'sh2_block', 3, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 13:30:24', '1', '2009-12-08 14:05:51', '1', 13, '2009-12-08 14:05:51', 0, NULL),
(4, '', 'box', 8, 3, 0, 0, '8998736B1', 'bb1', 'r1-cb1-bb1', '', NULL, NULL, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 14:07:58', '1', '2009-12-08 14:07:58', '1', 14, '2009-12-08 14:07:58', 0, NULL),
(4, 'B - 4', 'box', 8, 3, 5, 6, '8998736B1', 'bb1', 'r1-cb1-bb1', '', NULL, NULL, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 14:07:58', '1', '2009-12-08 14:07:58', '1', 15, '2009-12-08 14:07:58', 0, NULL),
(4, 'B - 4', 'box', 8, 3, 5, 6, '8998736B1', 'bb1', 'r1-cb1-bb1', '', 'sh2_block', 3, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 14:07:58', '1', '2009-12-08 14:08:09', '1', 16, '2009-12-08 14:08:10', 0, NULL),
(1, 'TMA345 - 1', 'TMA-blc 23X15', 19, 4, 3, 4, 'TMA_blc899763', 'tm1', 'r1-cb1-bb1-tm1', '', NULL, NULL, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 13:30:24', '1', '2009-12-08 14:08:54', '1', 17, '2009-12-08 14:08:54', 0, NULL),
(5, '', 'box', 8, 3, 0, 0, '43423442b4', 'bb2', 'r1-cb1-bb2', '', NULL, NULL, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 14:09:56', '1', '2009-12-08 14:09:56', '1', 18, '2009-12-08 14:09:56', 0, NULL),
(5, 'B - 5', 'box', 8, 3, 7, 8, '43423442b4', 'bb2', 'r1-cb1-bb2', '', NULL, NULL, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 14:09:56', '1', '2009-12-08 14:09:56', '1', 19, '2009-12-08 14:09:57', 0, NULL),
(5, 'B - 5', 'box', 8, 3, 7, 8, '43423442b4', 'bb2', 'r1-cb1-bb2', '', 'sh1_slide', 1, NULL, NULL, 'FALSE', '21.00', 'celsius', '', '2009-12-08 14:09:56', '1', '2009-12-08 14:10:09', '1', 20, '2009-12-08 14:10:09', 0, NULL),
(5, 'B - 5', 'box', 8, 3, 7, 8, '43423442b4', 'bb2', 'r1-cb1-bb2', '', 'sh1_slide', 1, NULL, NULL, 'FALSE', '21.00', 'celsius', 'Box for tma slide', '2009-12-08 14:09:56', '1', '2009-12-08 14:13:09', '1', 21, '2009-12-08 14:13:09', 0, NULL),
(6, '', 'room', 1, 2, 0, 0, '4247263472FR1', 'fr1', 'r1-fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '-80.00', 'celsius', '', '2009-12-08 14:14:32', '1', '2009-12-08 14:14:32', '1', 22, '2009-12-08 14:14:32', 0, NULL),
(6, 'R - 6', 'room', 1, 2, 10, 11, '4247263472FR1', 'fr1', 'r1-fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '-80.00', 'celsius', '', '2009-12-08 14:14:32', '1', '2009-12-08 14:14:32', '1', 23, '2009-12-08 14:14:33', 0, NULL),
(6, 'R - 6', 'room', 1, NULL, 10, 11, '4247263472FR1', 'fr1', 'fr1', '', NULL, NULL, NULL, NULL, 'TRUE', '22.00', 'celsius', '', '2009-12-08 14:14:32', '1', '2009-12-08 14:15:19', '1', 24, '2009-12-08 14:15:19', 0, NULL),
(7, '', 'freezer', 6, 2, 0, 0, '78840033FR2', 'fr2', 'r1-fr2', '', NULL, NULL, NULL, NULL, 'TRUE', '-80.00', 'celsius', '', '2009-12-08 14:18:47', '1', '2009-12-08 14:18:47', '1', 25, '2009-12-08 14:18:47', 0, NULL),
(7, 'FRE - 7', 'freezer', 6, 2, 10, 11, '78840033FR2', 'fr2', 'r1-fr2', '', NULL, NULL, NULL, NULL, 'TRUE', '-80.00', 'celsius', '', '2009-12-08 14:18:47', '1', '2009-12-08 14:18:47', '1', 26, '2009-12-08 14:18:47', 0, NULL),
(7, 'FRE - 7', 'freezer', 6, 2, 10, 11, '78840033FR2', 'fr2', 'r1-fr2', '', NULL, NULL, NULL, NULL, 'TRUE', '-82.00', 'celsius', '', '2009-12-08 14:18:47', '1', '2009-12-08 14:20:31', '1', 27, '2009-12-08 14:20:32', 0, NULL),
(8, '', 'shelf', 14, 7, 0, 0, '000000001', 'sh1', 'r1-fr2-sh1', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:20:58', '1', '2009-12-08 14:20:58', '1', 28, '2009-12-08 14:20:58', 0, NULL),
(8, 'SH - 8', 'shelf', 14, 7, 11, 12, '000000001', 'sh1', 'r1-fr2-sh1', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:20:58', '1', '2009-12-08 14:20:58', '1', 29, '2009-12-08 14:20:58', 0, NULL),
(9, '', 'shelf', 14, 7, 0, 0, '000000002', 'sh2', 'r1-fr2-sh2', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:21:06', '1', '2009-12-08 14:21:06', '1', 30, '2009-12-08 14:21:06', 0, NULL),
(9, 'SH - 9', 'shelf', 14, 7, 13, 14, '000000002', 'sh2', 'r1-fr2-sh2', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:21:06', '1', '2009-12-08 14:21:06', '1', 31, '2009-12-08 14:21:06', 0, NULL),
(10, '', 'shelf', 14, 7, 0, 0, '000000003', 'sh3', 'r1-fr2-sh3', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:21:20', '1', '2009-12-08 14:21:20', '1', 32, '2009-12-08 14:21:20', 0, NULL),
(10, 'SH - 10', 'shelf', 14, 7, 15, 16, '000000003', 'sh3', 'r1-fr2-sh3', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:21:20', '1', '2009-12-08 14:21:20', '1', 33, '2009-12-08 14:21:21', 0, NULL),
(11, '', 'shelf', 14, 7, 0, 0, '000000004', 'sh4', 'r1-fr2-sh4', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:21:29', '1', '2009-12-08 14:21:29', '1', 34, '2009-12-08 14:21:29', 0, NULL),
(11, 'SH - 11', 'shelf', 14, 7, 17, 18, '000000004', 'sh4', 'r1-fr2-sh4', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:21:29', '1', '2009-12-08 14:21:29', '1', 35, '2009-12-08 14:21:29', 0, NULL),
(12, '', 'rack16', 11, 9, 0, 0, '8890238', 'R1', 'r1-fr2-sh2-R1', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:22:14', '1', '2009-12-08 14:22:14', '1', 36, '2009-12-08 14:22:15', 0, NULL),
(12, 'R2D16 - 12', 'rack16', 11, 9, 14, 15, '8890238', 'R1', 'r1-fr2-sh2-R1', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:22:14', '1', '2009-12-08 14:22:15', '1', 37, '2009-12-08 14:22:15', 0, NULL),
(13, '', 'rack16', 11, 9, 0, 0, '8890238S', 'R2', 'r1-fr2-sh2-R2', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:22:26', '1', '2009-12-08 14:22:26', '1', 38, '2009-12-08 14:22:26', 0, NULL),
(13, 'R2D16 - 13', 'rack16', 11, 9, 16, 17, '8890238S', 'R2', 'r1-fr2-sh2-R2', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:22:26', '1', '2009-12-08 14:22:26', '1', 39, '2009-12-08 14:22:26', 0, NULL),
(14, '', 'box25', 17, 12, 0, 0, '5234234234', 'B2.2', 'r1-fr2-sh2-R1-B2.2', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:23:31', '1', '2009-12-08 14:23:31', '1', 40, '2009-12-08 14:23:32', 0, NULL),
(14, 'B25 - 14', 'box25', 17, 12, 15, 16, '5234234234', 'B2.2', 'r1-fr2-sh2-R1-B2.2', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:23:31', '1', '2009-12-08 14:23:32', '1', 41, '2009-12-08 14:23:32', 0, NULL),
(14, 'B25 - 14', 'box25', 17, 12, 15, 16, '5234234234', 'B2.2', 'r1-fr2-sh2-R1-B2.2', '', 'A', 0, '1', 0, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:23:31', '1', '2009-12-08 14:23:42', '1', 42, '2009-12-08 14:23:43', 0, NULL),
(15, '', 'box81 1A-9I', 9, 12, 0, 0, 'AS32112', 'B2.3', 'r1-fr2-sh2-R1-B2.3', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:12', '1', '2009-12-08 14:24:12', '1', 43, '2009-12-08 14:24:12', 0, NULL),
(15, 'B2D81 - 15', 'box81 1A-9I', 9, 12, 17, 18, 'AS32112', 'B2.3', 'r1-fr2-sh2-R1-B2.3', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:12', '1', '2009-12-08 14:24:12', '1', 44, '2009-12-08 14:24:13', 0, NULL),
(16, '', 'box81 1A-9I', 9, 12, 0, 0, 'AS32112ASASD', 'B2.4', 'r1-fr2-sh2-R1-B2.4', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:20', '1', '2009-12-08 14:24:20', '1', 45, '2009-12-08 14:24:20', 0, NULL),
(16, 'B2D81 - 16', 'box81 1A-9I', 9, 12, 19, 20, 'AS32112ASASD', 'B2.4', 'r1-fr2-sh2-R1-B2.4', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:20', '1', '2009-12-08 14:24:20', '1', 46, '2009-12-08 14:24:20', 0, NULL),
(17, '', 'box81 1A-9I', 9, 12, 0, 0, '00984', 'B2.007', 'r1-fr2-sh2-R1-B2.007', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:35', '1', '2009-12-08 14:24:35', '1', 47, '2009-12-08 14:24:35', 0, NULL),
(17, 'B2D81 - 17', 'box81 1A-9I', 9, 12, 21, 22, '00984', 'B2.007', 'r1-fr2-sh2-R1-B2.007', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:35', '1', '2009-12-08 14:24:35', '1', 48, '2009-12-08 14:24:35', 0, NULL),
(18, '', 'box81 1A-9I', 9, 12, 0, 0, '33211221', 'B2.12', 'r1-fr2-sh2-R1-B2.12', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:44', '1', '2009-12-08 14:24:44', '1', 49, '2009-12-08 14:24:44', 0, NULL),
(18, 'B2D81 - 18', 'box81 1A-9I', 9, 12, 23, 24, '33211221', 'B2.12', 'r1-fr2-sh2-R1-B2.12', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:44', '1', '2009-12-08 14:24:44', '1', 50, '2009-12-08 14:24:45', 0, NULL),
(19, '', 'box81 1A-9I', 9, 12, 0, 0, '332323', 'B2.111', 'r1-fr2-sh2-R1-B2.111', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:57', '1', '2009-12-08 14:24:57', '1', 51, '2009-12-08 14:24:57', 0, NULL),
(19, 'B2D81 - 19', 'box81 1A-9I', 9, 12, 25, 26, '332323', 'B2.111', 'r1-fr2-sh2-R1-B2.111', '', NULL, NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:57', '1', '2009-12-08 14:24:57', '1', 52, '2009-12-08 14:24:57', 0, NULL),
(19, 'B2D81 - 19', 'box81 1A-9I', 9, 12, 25, 26, '332323', 'B2.111', 'r1-fr2-sh2-R1-B2.111', '', 'A', NULL, '2', NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:57', '1', '2009-12-08 14:24:57', '1', 53, '2009-12-08 14:28:30', 0, NULL),
(18, 'B2D81 - 18', 'box81 1A-9I', 9, 12, 23, 24, '33211221', 'B2.12', 'r1-fr2-sh2-R1-B2.12', '', 'B', NULL, '2', NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:44', '1', '2009-12-08 14:24:44', '1', 54, '2009-12-08 14:28:30', 0, NULL),
(17, 'B2D81 - 17', 'box81 1A-9I', 9, 12, 21, 22, '00984', 'B2.007', 'r1-fr2-sh2-R1-B2.007', '', 'B', NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:35', '1', '2009-12-08 14:24:35', '1', 55, '2009-12-08 14:28:30', 0, NULL),
(16, 'B2D81 - 16', 'box81 1A-9I', 9, 12, 19, 20, 'AS32112ASASD', 'B2.4', 'r1-fr2-sh2-R1-B2.4', '', 'C', NULL, NULL, NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:20', '1', '2009-12-08 14:24:20', '1', 56, '2009-12-08 14:28:30', 0, NULL),
(15, 'B2D81 - 15', 'box81 1A-9I', 9, 12, 17, 18, 'AS32112', 'B2.3', 'r1-fr2-sh2-R1-B2.3', '', 'C', NULL, '2', NULL, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:24:12', '1', '2009-12-08 14:24:12', '1', 57, '2009-12-08 14:28:31', 0, NULL),
(14, 'B25 - 14', 'box25', 17, 12, 15, 16, '5234234234', 'B2.2', 'r1-fr2-sh2-R1-B2.2', '', 'A', 0, NULL, 0, 'FALSE', '-82.00', 'celsius', '', '2009-12-08 14:23:31', '1', '2009-12-08 14:23:42', '1', 58, '2009-12-08 14:28:31', 0, NULL);
INSERT INTO `tma_slides` (`id`, `tma_block_storage_master_id`, `barcode`, `product_code`, `sop_master_id`, `immunochemistry`, `picture_path`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `coord_x_order`, `storage_coord_y`, `coord_y_order`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 'SL1234', NULL, 1, 'AC788309', '/tmp/789.jpg', '2009-12-11 00:00:00', 5, '', NULL, '', NULL, '2009-12-08 13:33:53', '1', '2009-12-08 14:12:04', '1', 0, NULL),
(2, 1, 'TMASL90048', NULL, 1, 'AC78840', '', '2009-12-11 00:00:00', 5, '', NULL, '', NULL, '2009-12-08 13:35:31', '1', '2009-12-08 14:11:12', '1', 0, NULL);
INSERT INTO `tma_slides_revs` (`id`, `tma_block_storage_master_id`, `barcode`, `product_code`, `sop_master_id`, `immunochemistry`, `picture_path`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `coord_x_order`, `storage_coord_y`, `coord_y_order`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, 'SL1234', NULL, 2, 'AC788309', '/tmp/789.jpg', '2009-12-11 00:00:00', NULL, '', NULL, '', NULL, '2009-12-08 13:33:53', '1', '2009-12-08 13:33:53', '1', 1, '2009-12-08 13:33:53', 0, NULL),
(1, 1, 'SL1234', NULL, 1, 'AC788309', '/tmp/789.jpg', '2009-12-11 00:00:00', NULL, '', NULL, '', NULL, '2009-12-08 13:33:53', '1', '2009-12-08 13:34:37', '1', 2, '2009-12-08 13:34:37', 0, NULL),
(2, 1, 'TMASL90048', NULL, 1, '', '', NULL, NULL, '', NULL, '', NULL, '2009-12-08 13:35:31', '1', '2009-12-08 13:35:31', '1', 3, '2009-12-08 13:35:31', 0, NULL),
(2, 1, 'TMASL90048', NULL, 1, '', '', '2009-12-11 00:00:00', 3, '', NULL, '', NULL, '2009-12-08 13:35:31', '1', '2009-12-08 13:40:06', '1', 4, '2009-12-08 13:40:06', 0, NULL),
(2, 1, 'TMASL90048', NULL, 1, '', '', '2009-12-11 00:00:00', 3, 'sh2_block', NULL, NULL, NULL, '2009-12-08 13:35:31', '1', '2009-12-08 13:40:06', '1', 5, '2009-12-08 13:40:38', 0, NULL),
(2, 1, 'TMASL90048', NULL, 1, '', '', '2009-12-11 00:00:00', 3, 'sh2_block', 3, '', NULL, '2009-12-08 13:35:31', '1', '2009-12-08 13:46:54', '1', 6, '2009-12-08 13:46:54', 0, NULL),
(2, 1, 'TMASL90048', NULL, 1, 'AC78840', '', '2009-12-11 00:00:00', 5, '', NULL, '', NULL, '2009-12-08 13:35:31', '1', '2009-12-08 14:11:12', '1', 7, '2009-12-08 14:11:12', 0, NULL),
(1, 1, 'SL1234', NULL, 1, 'AC788309', '/tmp/789.jpg', '2009-12-11 00:00:00', 5, '', NULL, '', NULL, '2009-12-08 13:33:53', '1', '2009-12-08 14:12:04', '1', 8, '2009-12-08 14:12:04', 0, NULL);

-- ------------------------------------------------------------------------------------------------------------
--
-- CLINICAL ANNOTATION MODULE
--
-- ------------------------------------------------------------------------------------------------------------

INSERT INTO `participants` (`id`, `title`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `dob_date_accuracy`, `marital_status`, `language_preferred`, `sex`, `race`, `vital_status`, `notes`, `date_of_death`, `dod_date_accuracy`, `cod_icd10_code`, `secondary_cod_icd10_code`, `cod_confirmation_source`, `participant_identifier`, `last_chart_checked_date`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, '', 'Buzz', '', 'Lightyear', '1999-03-13', '', '', '', 'm', '', '', '', NULL, '', NULL, NULL, '', 'Part_1_Demo', NULL, '2010-01-20 10:55:40', '1', '2010-01-20 10:55:40', '1', 0, NULL),
(2, 'Dr.', 'Mr', '', 'Woody', '1993-05-06', '', '', '', 'm', '', '', '', NULL, '', NULL, NULL, '', 'Part_2_Demo', NULL, '2010-01-20 10:56:11', '1', '2010-01-20 10:56:11', '1', 0, NULL);
INSERT INTO `participants_revs` (`id`, `title`, `first_name`, `middle_name`, `last_name`, `date_of_birth`, `dob_date_accuracy`, `marital_status`, `language_preferred`, `sex`, `race`, `vital_status`, `notes`, `date_of_death`, `dod_date_accuracy`, `cod_icd10_code`, `secondary_cod_icd10_code`, `cod_confirmation_source`, `participant_identifier`, `last_chart_checked_date`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`, `version_id`, `version_created`) VALUES
(1, '', 'Buzz', '', 'Lightyear', '1999-03-13', '', '', '', 'm', '', '', '', NULL, '', NULL, NULL, '', 'Part_1_Demo', NULL, '2010-01-20 10:55:40', '1', '2010-01-20 10:55:40', '1', 0, NULL, 1, '2010-01-20 10:55:40'),
(2, '', 'Mr', '', 'Woody', '1993-05-06', '', '', '', 'm', '', '', '', NULL, '', NULL, NULL, '', 'Part_2_Demo', NULL, '2010-01-20 10:56:11', '1', '2010-01-20 10:56:11', '1', 0, NULL, 2, '2010-01-20 10:56:11');

INSERT INTO `clinical_collection_links` (`id`, `participant_id`, `collection_id`, `diagnosis_master_id`, `consent_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 1, NULL, NULL, '2010-01-20 10:57:08', '1', '2010-01-20 11:21:54', '1', 0, NULL),
(2, 1, 2, NULL, NULL, '2010-01-20 11:20:05', '1', '2010-01-20 11:22:48', '1', 0, NULL);
INSERT INTO `clinical_collection_links_revs` (`id`, `participant_id`, `collection_id`, `diagnosis_master_id`, `consent_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, NULL, 1, NULL, NULL, '2010-01-20 10:57:08', '1', '2010-01-20 10:57:08', '1', 1, '2010-01-20 10:57:08', 0, NULL),
(2, NULL, 2, NULL, NULL, '2010-01-20 11:20:05', '1', '2010-01-20 11:20:05', '1', 2, '2010-01-20 11:20:05', 0, NULL),
(1, 1, 1, NULL, NULL, '2010-01-20 10:57:08', '1', '2010-01-20 11:21:54', '1', 3, '2010-01-20 11:21:54', 0, NULL),
(2, 1, 2, NULL, NULL, '2010-01-20 11:20:05', '1', '2010-01-20 11:22:48', '1', 4, '2010-01-20 11:22:48', 0, NULL);

-- ------------------------------------------------------------------------------------------------------------
--
-- INVENTORY MODULE
--
-- ------------------------------------------------------------------------------------------------------------

INSERT INTO `ad_blocks` (`id`, `aliquot_master_id`, `block_type`, `patho_dpt_block_code`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 'OCT', '#893643231212', '2010-01-20 11:00:57', '1', '2010-01-20 11:14:10', '1', 0, NULL),
(2, 2, 'OCT', '#893311231232', '2010-01-20 11:00:57', '1', '2010-01-20 11:00:57', '1', 0, NULL),
(3, 3, 'OCT', '#8934443234', '2010-01-20 11:00:58', '1', '2010-01-20 11:00:58', '1', 0, NULL),
(4, 4, 'OCT', '#897643w9823', '2010-01-20 11:00:59', '1', '2010-01-20 11:00:59', '1', 0, NULL);
INSERT INTO `ad_blocks_revs` (`id`, `aliquot_master_id`, `block_type`, `patho_dpt_block_code`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, 'OCT', '#893643231212', '2010-01-20 11:00:57', '1', '2010-01-20 11:00:57', '1', 1, '2010-01-20 11:00:57', 0, NULL),
(2, 2, 'OCT', '#893311231232', '2010-01-20 11:00:57', '1', '2010-01-20 11:00:57', '1', 2, '2010-01-20 11:00:57', 0, NULL),
(3, 3, 'OCT', '#8934443234', '2010-01-20 11:00:58', '1', '2010-01-20 11:00:58', '1', 3, '2010-01-20 11:00:58', 0, NULL),
(4, 4, 'OCT', '#897643w9823', '2010-01-20 11:00:59', '1', '2010-01-20 11:00:59', '1', 4, '2010-01-20 11:00:59', 0, NULL),
(1, 1, 'OCT', '#893643231212', '2010-01-20 11:00:57', '1', '2010-01-20 11:14:10', '1', 5, '2010-01-20 11:14:10', 0, NULL);
INSERT INTO `ad_tissue_slides` (`id`, `aliquot_master_id`, `immunochemistry`, `block_aliquot_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 5, 'AC98', 1, '2010-01-20 11:02:27', '1', '2010-01-20 11:02:27', '1', 0, NULL),
(2, 6, 'AC98', 1, '2010-01-20 11:02:28', '1', '2010-01-20 11:02:28', '1', 0, NULL),
(3, 7, 'AC98', 1, '2010-01-20 11:02:28', '1', '2010-01-20 11:02:28', '1', 0, NULL);
INSERT INTO `ad_tissue_slides_revs` (`id`, `aliquot_master_id`, `immunochemistry`, `block_aliquot_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 5, 'AC98', 1, '2010-01-20 11:02:27', '1', '2010-01-20 11:02:27', '1', 1, '2010-01-20 11:02:27', 0, NULL),
(2, 6, 'AC98', 1, '2010-01-20 11:02:28', '1', '2010-01-20 11:02:28', '1', 2, '2010-01-20 11:02:28', 0, NULL),
(3, 7, 'AC98', 1, '2010-01-20 11:02:28', '1', '2010-01-20 11:02:28', '1', 3, '2010-01-20 11:02:28', 0, NULL);
INSERT INTO `ad_tubes` (`id`, `aliquot_master_id`, `lot_number`, `concentration`, `concentration_unit`, `cell_count`, `cell_count_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 8, '#98736', '647.00', 'ug/ul', NULL, NULL, '2010-01-20 11:06:51', '1', '2010-01-20 11:11:38', '1', 0, NULL),
(2, 9, '#98736', '647.00', 'ug/ul', NULL, NULL, '2010-01-20 11:06:52', '1', '2010-01-20 11:06:52', '1', 0, NULL),
(3, 10, '#98736', '647.00', 'ug/ul', NULL, NULL, '2010-01-20 11:06:53', '1', '2010-01-20 11:13:15', '1', 0, NULL),
(4, 11, '#98736', '647.00', 'ug/ul', NULL, NULL, '2010-01-20 11:06:53', '1', '2010-01-20 11:06:53', '1', 0, NULL),
(5, 12, '#412312', NULL, '', NULL, NULL, '2010-01-20 11:09:32', '1', '2010-01-20 11:09:32', '1', 0, NULL),
(6, 13, '#412312', NULL, '', NULL, NULL, '2010-01-20 11:09:33', '1', '2010-01-20 11:09:33', '1', 0, NULL),
(7, 14, '', NULL, NULL, NULL, NULL, '2010-01-20 11:16:50', '1', '2010-01-20 11:16:50', '1', 0, NULL),
(8, 15, '', NULL, NULL, NULL, NULL, '2010-01-20 11:16:50', '1', '2010-01-20 11:16:50', '1', 0, NULL),
(9, 16, '', NULL, '', '859.30', '10e7', '2010-01-20 11:19:12', '1', '2010-01-20 11:19:12', '1', 0, NULL),
(10, 17, '', NULL, '', '859.30', '10e7', '2010-01-20 11:19:13', '1', '2010-01-20 11:19:13', '1', 0, NULL),
(11, 18, '', NULL, '', '859.30', '10e7', '2010-01-20 11:19:13', '1', '2010-01-20 11:19:13', '1', 0, NULL),
(12, 19, '', NULL, NULL, NULL, NULL, '2010-01-20 11:21:09', '1', '2010-01-20 11:21:09', '1', 0, NULL);
INSERT INTO `ad_tubes_revs` (`id`, `aliquot_master_id`, `lot_number`, `concentration`, `concentration_unit`, `cell_count`, `cell_count_unit`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 8, '#98736', '647.00', 'ug/ul', NULL, NULL, '2010-01-20 11:06:51', '1', '2010-01-20 11:06:51', '1', 1, '2010-01-20 11:06:51', 0, NULL),
(2, 9, '#98736', '647.00', 'ug/ul', NULL, NULL, '2010-01-20 11:06:52', '1', '2010-01-20 11:06:52', '1', 2, '2010-01-20 11:06:52', 0, NULL),
(3, 10, '#98736', '647.00', 'ug/ul', NULL, NULL, '2010-01-20 11:06:53', '1', '2010-01-20 11:06:53', '1', 3, '2010-01-20 11:06:53', 0, NULL),
(4, 11, '#98736', '647.00', 'ug/ul', NULL, NULL, '2010-01-20 11:06:53', '1', '2010-01-20 11:06:53', '1', 4, '2010-01-20 11:06:53', 0, NULL),
(5, 12, '#412312', NULL, '', NULL, NULL, '2010-01-20 11:09:32', '1', '2010-01-20 11:09:32', '1', 5, '2010-01-20 11:09:32', 0, NULL),
(6, 13, '#412312', NULL, '', NULL, NULL, '2010-01-20 11:09:33', '1', '2010-01-20 11:09:33', '1', 6, '2010-01-20 11:09:33', 0, NULL),
(1, 8, '#98736', '647.00', 'ug/ul', NULL, NULL, '2010-01-20 11:06:51', '1', '2010-01-20 11:11:38', '1', 7, '2010-01-20 11:11:38', 0, NULL),
(3, 10, '#98736', '647.00', 'ug/ul', NULL, NULL, '2010-01-20 11:06:53', '1', '2010-01-20 11:12:53', '1', 8, '2010-01-20 11:12:53', 0, NULL),
(3, 10, '#98736', '647.00', 'ug/ul', NULL, NULL, '2010-01-20 11:06:53', '1', '2010-01-20 11:13:15', '1', 9, '2010-01-20 11:13:15', 0, NULL),
(7, 14, '', NULL, NULL, NULL, NULL, '2010-01-20 11:16:50', '1', '2010-01-20 11:16:50', '1', 10, '2010-01-20 11:16:50', 0, NULL),
(8, 15, '', NULL, NULL, NULL, NULL, '2010-01-20 11:16:50', '1', '2010-01-20 11:16:50', '1', 11, '2010-01-20 11:16:50', 0, NULL),
(9, 16, '', NULL, '', '859.30', '10e7', '2010-01-20 11:19:12', '1', '2010-01-20 11:19:12', '1', 12, '2010-01-20 11:19:12', 0, NULL),
(10, 17, '', NULL, '', '859.30', '10e7', '2010-01-20 11:19:13', '1', '2010-01-20 11:19:13', '1', 13, '2010-01-20 11:19:13', 0, NULL),
(11, 18, '', NULL, '', '859.30', '10e7', '2010-01-20 11:19:13', '1', '2010-01-20 11:19:13', '1', 14, '2010-01-20 11:19:13', 0, NULL),
(12, 19, '', NULL, NULL, NULL, NULL, '2010-01-20 11:21:09', '1', '2010-01-20 11:21:09', '1', 15, '2010-01-20 11:21:09', 0, NULL);
INSERT INTO `aliquot_masters` (`id`, `barcode`, `aliquot_type`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `sop_master_id`, `initial_volume`, `current_volume`, `aliquot_volume_unit`, `in_stock`, `in_stock_detail`, `study_summary_id`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `coord_x_order`, `storage_coord_y`, `coord_y_order`, `product_code`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'bc_blc904376531', 'block', 4, 1, 1, 2, NULL, NULL, '', 'yes - available', '', 1, '2010-01-01 10:28:00', 5, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:00:56', '1', '2010-01-20 11:14:10', '1', 0, NULL),
(2, 'bc_blc904376532', 'block', 4, 1, 1, 2, NULL, NULL, NULL, 'yes - available', '', 1, '2010-01-01 00:28:00', 5, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:00:57', '1', '2010-01-20 11:00:57', '1', 0, NULL),
(3, 'bc_blc904376533', 'block', 4, 1, 1, 2, NULL, NULL, NULL, 'yes - available', '', NULL, '2010-01-01 00:28:00', 5, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:00:57', '1', '2010-01-20 11:00:57', '1', 0, NULL),
(4, 'bc_blc904376534', 'block', 4, 1, 1, 2, NULL, NULL, NULL, 'yes - available', '', 2, '2010-01-01 00:28:00', 5, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:00:58', '1', '2010-01-20 11:00:58', '1', 0, NULL),
(5, 'bc8948721_007', 'slide', 5, 1, 1, NULL, NULL, NULL, NULL, 'yes - available', '', 1, '2010-01-01 00:46:00', 4, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:02:27', '1', '2010-01-20 11:02:27', '1', 0, NULL),
(6, 'bc8948721_0071', 'slide', 5, 1, 1, NULL, NULL, NULL, NULL, 'yes - available', '', 1, '2010-01-01 00:46:00', 4, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:02:27', '1', '2010-01-20 11:02:27', '1', 0, NULL),
(7, 'bc8948721_0072', 'slide', 5, 1, 1, NULL, NULL, NULL, NULL, 'yes - available', '', 1, '2010-01-01 00:46:00', 4, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:02:28', '1', '2010-01-20 11:02:28', '1', 0, NULL),
(8, 'bc_dna_9836', 'tube', 11, 1, 2, NULL, '12.00000', '5.00000', 'ul', 'yes - available', '', 1, '2010-01-30 10:02:00', 17, '1', 0, 'A', 0, NULL, NULL, '2010-01-20 11:06:51', '1', '2010-01-20 11:11:37', '1', 0, NULL),
(9, 'bc_dna_9837', 'tube', 11, 1, 2, NULL, '12.43000', '12.43000', 'ul', 'yes - available', '', 1, '2010-01-30 00:02:00', 17, '1', 0, 'B', 1, NULL, NULL, '2010-01-20 11:06:51', '1', '2010-01-20 11:06:51', '1', 0, NULL),
(10, 'bc_dna_9838', 'tube', 11, 1, 2, NULL, '10.98000', '6.55000', 'ul', 'yes - available', '', 1, '2010-01-30 00:02:00', 17, '1', 0, 'C', 2, NULL, NULL, '2010-01-20 11:06:52', '1', '2010-01-20 11:13:14', '1', 0, NULL),
(11, 'bc_dna_9839', 'tube', 11, 1, 2, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', 1, '2010-01-30 00:02:00', 17, '1', 0, 'D', 3, NULL, NULL, '2010-01-20 11:06:53', '1', '2010-01-20 11:06:53', '1', 0, NULL),
(12, 'bc_dna_9836.r1', 'tube', 11, 1, 2, NULL, '32.00000', '32.00000', 'ul', 'yes - available', '', NULL, '2010-02-15 00:00:00', 17, '2', 1, 'A', 0, NULL, NULL, '2010-01-20 11:09:32', '1', '2010-01-20 11:09:32', '1', 0, NULL),
(13, 'bc_dna_9836.r2', 'tube', 11, 1, 2, NULL, '32.00000', '32.00000', 'ul', 'yes - available', '', NULL, '2010-02-15 00:00:00', 17, '2', 1, 'B', 1, NULL, NULL, '2010-01-20 11:09:32', '1', '2010-01-20 11:09:32', '1', 0, NULL),
(14, 'PLS_9763', 'tube', 8, 1, 4, NULL, '3.00000', '3.00000', 'ml', 'yes - available', '', NULL, NULL, 15, '1', 0, 'A', 0, NULL, NULL, '2010-01-20 11:16:49', '1', '2010-01-20 11:16:49', '1', 0, NULL),
(15, 'PLS_9761', 'tube', 8, 1, 4, NULL, '3.00000', '3.00000', 'ml', 'yes - available', '', NULL, NULL, 15, '1', 0, 'B', 1, NULL, NULL, '2010-01-20 11:16:50', '1', '2010-01-20 11:16:50', '1', 0, NULL),
(16, 'PBMC_001', 'tube', 15, 1, 5, NULL, '43.00000', '43.00000', 'ml', 'yes - available', '', NULL, NULL, 15, '4', 3, 'A', 0, NULL, NULL, '2010-01-20 11:19:12', '1', '2010-01-20 11:19:12', '1', 0, NULL),
(17, 'PBMC_002', 'tube', 15, 1, 5, NULL, '43.00000', '43.00000', 'ml', 'yes - available', '', NULL, NULL, 15, '5', 4, 'C', 2, NULL, NULL, '2010-01-20 11:19:12', '1', '2010-01-20 11:19:12', '1', 0, NULL),
(18, 'PBMC_003', 'tube', 15, 1, 5, NULL, '43.00000', '43.00000', 'ml', 'yes - available', '', NULL, NULL, 15, '3', 2, 'C', 2, NULL, NULL, '2010-01-20 11:19:13', '1', '2010-01-20 11:19:13', '1', 0, NULL),
(19, 'U874', 'tube', 2, 2, 6, NULL, '12.00000', '12.00000', 'ml', 'yes - available', '', NULL, '2010-01-02 12:03:00', NULL, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:21:08', '1', '2010-01-20 11:21:08', '1', 0, NULL);
INSERT INTO `aliquot_masters_revs` (`id`, `barcode`, `aliquot_type`, `aliquot_control_id`, `collection_id`, `sample_master_id`, `sop_master_id`, `initial_volume`, `current_volume`, `aliquot_volume_unit`, `in_stock`, `in_stock_detail`, `study_summary_id`, `storage_datetime`, `storage_master_id`, `storage_coord_x`, `coord_x_order`, `storage_coord_y`, `coord_y_order`, `product_code`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 'bc_blc904376531', 'block', 4, 1, 1, 2, NULL, NULL, NULL, 'yes - available', '', 1, '2010-01-01 10:28:00', 5, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:00:56', '1', '2010-01-20 11:00:56', '1', 1, '2010-01-20 11:00:57', 0, NULL),
(2, 'bc_blc904376532', 'block', 4, 1, 1, 2, NULL, NULL, NULL, 'yes - available', '', 1, '2010-01-01 00:28:00', 5, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:00:57', '1', '2010-01-20 11:00:57', '1', 2, '2010-01-20 11:00:57', 0, NULL),
(3, 'bc_blc904376533', 'block', 4, 1, 1, 2, NULL, NULL, NULL, 'yes - available', '', NULL, '2010-01-01 00:28:00', 5, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:00:57', '1', '2010-01-20 11:00:57', '1', 3, '2010-01-20 11:00:58', 0, NULL),
(4, 'bc_blc904376534', 'block', 4, 1, 1, 2, NULL, NULL, NULL, 'yes - available', '', 2, '2010-01-01 00:28:00', 5, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:00:58', '1', '2010-01-20 11:00:58', '1', 4, '2010-01-20 11:00:59', 0, NULL),
(5, 'bc8948721_007', 'slide', 5, 1, 1, NULL, NULL, NULL, NULL, 'yes - available', '', 1, '2010-01-01 00:46:00', 4, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:02:27', '1', '2010-01-20 11:02:27', '1', 5, '2010-01-20 11:02:27', 0, NULL),
(6, 'bc8948721_0071', 'slide', 5, 1, 1, NULL, NULL, NULL, NULL, 'yes - available', '', 1, '2010-01-01 00:46:00', 4, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:02:27', '1', '2010-01-20 11:02:27', '1', 6, '2010-01-20 11:02:28', 0, NULL),
(7, 'bc8948721_0072', 'slide', 5, 1, 1, NULL, NULL, NULL, NULL, 'yes - available', '', 1, '2010-01-01 00:46:00', 4, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:02:28', '1', '2010-01-20 11:02:28', '1', 7, '2010-01-20 11:02:28', 0, NULL),
(8, 'bc_dna_9836', 'tube', 11, 1, 2, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', 1, '2010-01-30 10:02:00', 17, '1', 0, 'A', 0, NULL, NULL, '2010-01-20 11:06:51', '1', '2010-01-20 11:06:51', '1', 8, '2010-01-20 11:06:51', 0, NULL),
(9, 'bc_dna_9837', 'tube', 11, 1, 2, NULL, '12.43000', '12.43000', 'ul', 'yes - available', '', 1, '2010-01-30 00:02:00', 17, '1', 0, 'B', 1, NULL, NULL, '2010-01-20 11:06:51', '1', '2010-01-20 11:06:51', '1', 9, '2010-01-20 11:06:52', 0, NULL),
(10, 'bc_dna_9838', 'tube', 11, 1, 2, NULL, '10.98000', '10.98000', 'ul', 'yes - available', '', 1, '2010-01-30 00:02:00', 17, '1', 0, 'C', 2, NULL, NULL, '2010-01-20 11:06:52', '1', '2010-01-20 11:06:52', '1', 10, '2010-01-20 11:06:53', 0, NULL),
(11, 'bc_dna_9839', 'tube', 11, 1, 2, NULL, '12.00000', '12.00000', 'ul', 'yes - available', '', 1, '2010-01-30 00:02:00', 17, '1', 0, 'D', 3, NULL, NULL, '2010-01-20 11:06:53', '1', '2010-01-20 11:06:53', '1', 11, '2010-01-20 11:06:53', 0, NULL),
(12, 'bc_dna_9836.r1', 'tube', 11, 1, 2, NULL, '32.00000', '32.00000', 'ul', 'yes - available', '', NULL, '2010-02-15 00:00:00', 17, '2', 1, 'A', 0, NULL, NULL, '2010-01-20 11:09:32', '1', '2010-01-20 11:09:32', '1', 12, '2010-01-20 11:09:32', 0, NULL),
(13, 'bc_dna_9836.r2', 'tube', 11, 1, 2, NULL, '32.00000', '32.00000', 'ul', 'yes - available', '', NULL, '2010-02-15 00:00:00', 17, '2', 1, 'B', 1, NULL, NULL, '2010-01-20 11:09:32', '1', '2010-01-20 11:09:32', '1', 13, '2010-01-20 11:09:33', 0, NULL),
(8, 'bc_dna_9836', 'tube', 11, 1, 2, NULL, '12.00000', '5.00000', 'ul', 'yes - available', '', 1, '2010-01-30 10:02:00', 17, '1', 0, 'A', 0, NULL, NULL, '2010-01-20 11:06:51', '1', '2010-01-20 11:11:37', '1', 14, '2010-01-20 11:11:38', 0, NULL),
(10, 'bc_dna_9838', 'tube', 11, 1, 2, NULL, '10.98000', '7.98000', 'ul', 'yes - available', '', 1, '2010-01-30 00:02:00', 17, '1', 0, 'C', 2, NULL, NULL, '2010-01-20 11:06:52', '1', '2010-01-20 11:12:53', '1', 15, '2010-01-20 11:12:53', 0, NULL),
(10, 'bc_dna_9838', 'tube', 11, 1, 2, NULL, '10.98000', '6.55000', 'ul', 'yes - available', '', 1, '2010-01-30 00:02:00', 17, '1', 0, 'C', 2, NULL, NULL, '2010-01-20 11:06:52', '1', '2010-01-20 11:13:14', '1', 16, '2010-01-20 11:13:15', 0, NULL),
(1, 'bc_blc904376531', 'block', 4, 1, 1, 2, NULL, NULL, '', 'yes - available', '', 1, '2010-01-01 10:28:00', 5, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:00:56', '1', '2010-01-20 11:14:10', '1', 17, '2010-01-20 11:14:10', 0, NULL),
(14, 'PLS_9763', 'tube', 8, 1, 4, NULL, '3.00000', '3.00000', 'ml', 'yes - available', '', NULL, NULL, 15, '1', 0, 'A', 0, NULL, NULL, '2010-01-20 11:16:49', '1', '2010-01-20 11:16:49', '1', 18, '2010-01-20 11:16:50', 0, NULL),
(15, 'PLS_9761', 'tube', 8, 1, 4, NULL, '3.00000', '3.00000', 'ml', 'yes - available', '', NULL, NULL, 15, '1', 0, 'B', 1, NULL, NULL, '2010-01-20 11:16:50', '1', '2010-01-20 11:16:50', '1', 19, '2010-01-20 11:16:50', 0, NULL),
(16, 'PBMC_001', 'tube', 15, 1, 5, NULL, '43.00000', '43.00000', 'ml', 'yes - available', '', NULL, NULL, 15, '4', 3, 'A', 0, NULL, NULL, '2010-01-20 11:19:12', '1', '2010-01-20 11:19:12', '1', 20, '2010-01-20 11:19:12', 0, NULL),
(17, 'PBMC_002', 'tube', 15, 1, 5, NULL, '43.00000', '43.00000', 'ml', 'yes - available', '', NULL, NULL, 15, '5', 4, 'C', 2, NULL, NULL, '2010-01-20 11:19:12', '1', '2010-01-20 11:19:12', '1', 21, '2010-01-20 11:19:13', 0, NULL),
(18, 'PBMC_003', 'tube', 15, 1, 5, NULL, '43.00000', '43.00000', 'ml', 'yes - available', '', NULL, NULL, 15, '3', 2, 'C', 2, NULL, NULL, '2010-01-20 11:19:13', '1', '2010-01-20 11:19:13', '1', 22, '2010-01-20 11:19:13', 0, NULL),
(19, 'U874', 'tube', 2, 2, 6, NULL, '12.00000', '12.00000', 'ml', 'yes - available', '', NULL, '2010-01-02 12:03:00', NULL, '', NULL, '', NULL, NULL, NULL, '2010-01-20 11:21:08', '1', '2010-01-20 11:21:08', '1', 23, '2010-01-20 11:21:09', 0, NULL);
INSERT INTO `aliquot_uses` (`id`, `aliquot_master_id`, `use_definition`, `use_code`, `use_details`, `use_recorded_into_table`, `used_volume`, `use_datetime`, `used_by`, `study_summary_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 8, 'realiquoted to', 'bc_dna_9836.r1', '', 'realiquotings', '3.00000', '2010-01-30 00:02:00', '', NULL, '2010-01-20 11:11:37', '1', '2010-01-20 11:11:37', '1', 0, NULL),
(2, 8, 'realiquoted to', 'bc_dna_9836.r2', '', 'realiquotings', '4.00000', '2010-01-30 00:02:00', '', NULL, '2010-01-20 11:11:37', '1', '2010-01-20 11:11:37', '1', 0, NULL),
(3, 10, 'internal use', 'Proto_986', '', NULL, '3.00000', '2010-03-06 00:00:00', 'custom_laboratory_staff_1', 2, '2010-01-20 11:12:52', '1', '2010-01-20 11:12:52', '1', 0, NULL),
(4, 10, 'internal use', 'Proto_9765', '', NULL, '1.43000', '2010-03-19 00:00:00', 'custom_laboratory_staff_1', 2, '2010-01-20 11:13:14', '1', '2010-01-20 11:13:14', '1', 0, NULL),
(5, 1, 'sample derivative creation', 'DNA - 2', '', 'source_aliquots', NULL, '2010-01-30 00:00:00', 'custom_laboratory_staff_2', NULL, '2010-01-20 11:14:10', '1', '2010-01-20 11:14:10', '1', 0, NULL);
INSERT INTO `aliquot_uses_revs` (`id`, `aliquot_master_id`, `use_definition`, `use_code`, `use_details`, `use_recorded_into_table`, `used_volume`, `use_datetime`, `used_by`, `study_summary_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 8, 'realiquoted to', 'bc_dna_9836.r1', '', 'realiquotings', '3.00000', '2010-01-30 00:02:00', '', NULL, '2010-01-20 11:11:37', '1', '2010-01-20 11:11:37', '1', 1, '2010-01-20 11:11:37', 0, NULL),
(2, 8, 'realiquoted to', 'bc_dna_9836.r2', '', 'realiquotings', '4.00000', '2010-01-30 00:02:00', '', NULL, '2010-01-20 11:11:37', '1', '2010-01-20 11:11:37', '1', 2, '2010-01-20 11:11:37', 0, NULL),
(3, 10, 'internal use', 'Proto_986', '', NULL, '3.00000', '2010-03-06 00:00:00', 'custom_laboratory_staff_1', 2, '2010-01-20 11:12:52', '1', '2010-01-20 11:12:52', '1', 3, '2010-01-20 11:12:52', 0, NULL),
(4, 10, 'internal use', 'Proto_9765', '', NULL, '1.43000', '2010-03-19 00:00:00', 'custom_laboratory_staff_1', 2, '2010-01-20 11:13:14', '1', '2010-01-20 11:13:14', '1', 4, '2010-01-20 11:13:14', 0, NULL),
(5, 1, 'sample derivative creation', 'DNA - 2', '', 'source_aliquots', NULL, '2010-01-30 00:00:00', 'custom_laboratory_staff_2', NULL, '2010-01-20 11:14:10', '1', '2010-01-20 11:14:10', '1', 5, '2010-01-20 11:14:10', 0, NULL);
INSERT INTO `collections` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'Coll_1_demo', 1, 'collection_site_2', '2010-01-01 02:07:00', '', 2, 'participant collection', '', '2010-01-20 10:57:08', '1', '2010-01-20 10:57:08', '1', 0, NULL),
(2, 'Coll_2_demo', 1, 'collection_site_2', '2010-01-02 14:03:00', '', NULL, 'participant collection', '', '2010-01-20 11:20:05', '1', '2010-01-20 11:20:05', '1', 0, NULL);
INSERT INTO `collections_revs` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, `collection_notes`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 'Coll_1_demo', 1, 'collection_site_2', '2010-01-01 02:07:00', '', 2, 'participant collection', '', '2010-01-20 10:57:08', '1', '2010-01-20 10:57:08', '1', 1, '2010-01-20 10:57:08', 0, NULL),
(2, 'Coll_2_demo', 1, 'collection_site_2', '2010-01-02 14:03:00', '', NULL, 'participant collection', '', '2010-01-20 11:20:05', '1', '2010-01-20 11:20:05', '1', 2, '2010-01-20 11:20:05', 0, NULL);
INSERT INTO `derivative_details` (`id`, `sample_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 2, 'custom_laboratory_site_1', 'custom_laboratory_staff_2', '2010-01-30 00:00:00', '2010-01-20 11:03:53', '1', '2010-01-20 11:03:53', '1', 0, NULL),
(2, 4, 'custom_laboratory_site_1', 'custom_laboratory_staff_2', NULL, '2010-01-20 11:15:43', '1', '2010-01-20 11:15:43', '1', 0, NULL),
(3, 5, '', 'custom_laboratory_staff_1', NULL, '2010-01-20 11:17:55', '1', '2010-01-20 11:17:55', '1', 0, NULL);
INSERT INTO `derivative_details_revs` (`id`, `sample_master_id`, `creation_site`, `creation_by`, `creation_datetime`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 2, 'custom_laboratory_site_1', 'custom_laboratory_staff_2', '2010-01-30 00:00:00', '2010-01-20 11:03:53', '1', '2010-01-20 11:03:53', '1', 1, '2010-01-20 11:03:53', 0, NULL),
(2, 4, 'custom_laboratory_site_1', 'custom_laboratory_staff_2', NULL, '2010-01-20 11:15:43', '1', '2010-01-20 11:15:43', '1', 2, '2010-01-20 11:15:43', 0, NULL),
(3, 5, '', 'custom_laboratory_staff_1', NULL, '2010-01-20 11:17:55', '1', '2010-01-20 11:17:55', '1', 3, '2010-01-20 11:17:55', 0, NULL);
INSERT INTO `realiquotings` (`id`, `parent_aliquot_master_id`, `child_aliquot_master_id`, `aliquot_use_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 8, 12, 1, '2010-01-20 11:11:37', '1', '2010-01-20 11:11:37', '1', 0, NULL),
(2, 8, 13, 2, '2010-01-20 11:11:37', '1', '2010-01-20 11:11:37', '1', 0, NULL);
INSERT INTO `realiquotings_revs` (`id`, `parent_aliquot_master_id`, `child_aliquot_master_id`, `aliquot_use_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 8, 12, 1, '2010-01-20 11:11:37', '1', '2010-01-20 11:11:37', '1', 1, '2010-01-20 11:11:37', 0, NULL),
(2, 8, 13, 2, '2010-01-20 11:11:37', '1', '2010-01-20 11:11:37', '1', 2, '2010-01-20 11:11:37', 0, NULL);
INSERT INTO `sample_masters` (`id`, `sample_code`, `sample_category`, `sample_control_id`, `sample_type`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `sop_master_id`, `product_code`, `is_problematic`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 'T - 1', 'specimen', 3, 'tissue', 1, 'tissue', 1, NULL, NULL, NULL, 'no', '', '2010-01-20 10:58:42', '1', '2010-01-20 10:58:42', '1', 0, NULL),
(2, 'DNA - 2', 'derivative', 12, 'dna', 1, 'tissue', 1, 1, NULL, NULL, 'no', '', '2010-01-20 11:03:52', '1', '2010-01-20 11:03:52', '1', 0, NULL),
(3, 'B - 3', 'specimen', 2, 'blood', 3, 'blood', 1, NULL, NULL, NULL, 'no', '', '2010-01-20 11:15:11', '1', '2010-01-20 11:15:11', '1', 0, NULL),
(4, 'PLS - 4', 'derivative', 9, 'plasma', 3, 'blood', 1, 3, NULL, NULL, 'no', '', '2010-01-20 11:15:43', '1', '2010-01-20 11:15:43', '1', 0, NULL),
(5, 'PBMC - 5', 'derivative', 8, 'pbmc', 3, 'blood', 1, 3, NULL, NULL, 'no', '', '2010-01-20 11:17:54', '1', '2010-01-20 11:17:55', '1', 0, NULL),
(6, 'U - 6', 'specimen', 4, 'urine', 6, 'urine', 2, NULL, NULL, NULL, 'no', '', '2010-01-20 11:20:37', '1', '2010-01-20 11:20:37', '1', 0, NULL);
INSERT INTO `sample_masters_revs` (`id`, `sample_code`, `sample_category`, `sample_control_id`, `sample_type`, `initial_specimen_sample_id`, `initial_specimen_sample_type`, `collection_id`, `parent_id`, `sop_master_id`, `product_code`, `is_problematic`, `notes`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, '', 'specimen', 3, 'tissue', NULL, 'tissue', 1, NULL, NULL, NULL, 'no', '', '2010-01-20 10:58:42', '1', '2010-01-20 10:58:42', '1', 1, '2010-01-20 10:58:42', 0, NULL),
(1, 'T - 1', 'specimen', 3, 'tissue', 1, 'tissue', 1, NULL, NULL, NULL, 'no', '', '2010-01-20 10:58:42', '1', '2010-01-20 10:58:42', '1', 2, '2010-01-20 10:58:42', 0, NULL),
(2, '', 'derivative', 12, 'dna', 1, 'tissue', 1, 1, NULL, NULL, 'no', '', '2010-01-20 11:03:52', '1', '2010-01-20 11:03:52', '1', 3, '2010-01-20 11:03:52', 0, NULL),
(2, 'DNA - 2', 'derivative', 12, 'dna', 1, 'tissue', 1, 1, NULL, NULL, 'no', '', '2010-01-20 11:03:52', '1', '2010-01-20 11:03:52', '1', 4, '2010-01-20 11:03:53', 0, NULL),
(3, '', 'specimen', 2, 'blood', NULL, 'blood', 1, NULL, NULL, NULL, 'no', '', '2010-01-20 11:15:11', '1', '2010-01-20 11:15:11', '1', 5, '2010-01-20 11:15:11', 0, NULL),
(3, 'B - 3', 'specimen', 2, 'blood', 3, 'blood', 1, NULL, NULL, NULL, 'no', '', '2010-01-20 11:15:11', '1', '2010-01-20 11:15:11', '1', 6, '2010-01-20 11:15:12', 0, NULL),
(4, '', 'derivative', 9, 'plasma', 3, 'blood', 1, 3, NULL, NULL, 'no', '', '2010-01-20 11:15:43', '1', '2010-01-20 11:15:43', '1', 7, '2010-01-20 11:15:43', 0, NULL),
(4, 'PLS - 4', 'derivative', 9, 'plasma', 3, 'blood', 1, 3, NULL, NULL, 'no', '', '2010-01-20 11:15:43', '1', '2010-01-20 11:15:43', '1', 8, '2010-01-20 11:15:43', 0, NULL),
(5, '', 'derivative', 8, 'pbmc', 3, 'blood', 1, 3, NULL, NULL, 'no', '', '2010-01-20 11:17:54', '1', '2010-01-20 11:17:54', '1', 9, '2010-01-20 11:17:55', 0, NULL),
(5, 'PBMC - 5', 'derivative', 8, 'pbmc', 3, 'blood', 1, 3, NULL, NULL, 'no', '', '2010-01-20 11:17:54', '1', '2010-01-20 11:17:55', '1', 10, '2010-01-20 11:17:55', 0, NULL),
(6, '', 'specimen', 4, 'urine', NULL, 'urine', 2, NULL, NULL, NULL, 'no', '', '2010-01-20 11:20:37', '1', '2010-01-20 11:20:37', '1', 11, '2010-01-20 11:20:37', 0, NULL),
(6, 'U - 6', 'specimen', 4, 'urine', 6, 'urine', 2, NULL, NULL, NULL, 'no', '', '2010-01-20 11:20:37', '1', '2010-01-20 11:20:37', '1', 12, '2010-01-20 11:20:38', 0, NULL);
INSERT INTO `sd_der_dnas` (`id`, `sample_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 2, '2010-01-20 11:03:52', '1', '2010-01-20 11:03:53', '1', 0, NULL);
INSERT INTO `sd_der_dnas_revs` (`id`, `sample_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 2, '2010-01-20 11:03:52', '1', '2010-01-20 11:03:52', '1', 1, '2010-01-20 11:03:52', 0, NULL),
(1, 2, '2010-01-20 11:03:52', '1', '2010-01-20 11:03:53', '1', 2, '2010-01-20 11:03:53', 0, NULL);
INSERT INTO `sd_der_pbmcs` (`id`, `sample_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 5, '2010-01-20 11:17:55', '1', '2010-01-20 11:17:55', '1', 0, NULL);
INSERT INTO `sd_der_pbmcs_revs` (`id`, `sample_master_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 5, '2010-01-20 11:17:55', '1', '2010-01-20 11:17:55', '1', 1, '2010-01-20 11:17:55', 0, NULL);
INSERT INTO `sd_der_plasmas` (`id`, `sample_master_id`, `hemolyze_signs`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 4, 'yes', '2010-01-20 11:15:43', '1', '2010-01-20 11:15:43', '1', 0, NULL);
INSERT INTO `sd_der_plasmas_revs` (`id`, `sample_master_id`, `hemolyze_signs`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 4, 'yes', '2010-01-20 11:15:43', '1', '2010-01-20 11:15:43', '1', 1, '2010-01-20 11:15:43', 0, NULL);
INSERT INTO `sd_spe_bloods` (`id`, `sample_master_id`, `blood_type`, `collected_tube_nbr`, `collected_volume`, `collected_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 3, 'heparine', 3, '123.00000', 'ml', '2010-01-20 11:15:11', '1', '2010-01-20 11:15:12', '1', 0, NULL);
INSERT INTO `sd_spe_bloods_revs` (`id`, `sample_master_id`, `blood_type`, `collected_tube_nbr`, `collected_volume`, `collected_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 3, 'heparine', 3, '123.00000', 'ml', '2010-01-20 11:15:11', '1', '2010-01-20 11:15:11', '1', 1, '2010-01-20 11:15:11', 0, NULL),
(1, 3, 'heparine', 3, '123.00000', 'ml', '2010-01-20 11:15:11', '1', '2010-01-20 11:15:12', '1', 2, '2010-01-20 11:15:12', 0, NULL);
INSERT INTO `sd_spe_tissues` (`id`, `sample_master_id`, `tissue_source`, `tissue_nature`, `tissue_laterality`, `pathology_reception_datetime`, `tissue_size`, `tissue_size_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 'colon', NULL, '', '2010-01-01 02:37:00', '2x3x4', '', '2010-01-20 10:58:42', '1', '2010-01-20 10:58:42', '1', 0, NULL);
INSERT INTO `sd_spe_tissues_revs` (`id`, `sample_master_id`, `tissue_source`, `tissue_nature`, `tissue_laterality`, `pathology_reception_datetime`, `tissue_size`, `tissue_size_unit`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, 'colon', NULL, '', '2010-01-01 02:37:00', '2x3x4', '', '2010-01-20 10:58:42', '1', '2010-01-20 10:58:42', '1', 1, '2010-01-20 10:58:42', 0, NULL);
INSERT INTO `sd_spe_urines` (`id`, `sample_master_id`, `urine_aspect`, `collected_volume`, `collected_volume_unit`, `pellet_signs`, `pellet_volume`, `pellet_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 6, '', '23.00000', 'ml', '', NULL, '', '2010-01-20 11:20:37', '1', '2010-01-20 11:20:38', '1', 0, NULL);
INSERT INTO `sd_spe_urines_revs` (`id`, `sample_master_id`, `urine_aspect`, `collected_volume`, `collected_volume_unit`, `pellet_signs`, `pellet_volume`, `pellet_volume_unit`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 6, '', '23.00000', 'ml', '', NULL, '', '2010-01-20 11:20:37', '1', '2010-01-20 11:20:37', '1', 1, '2010-01-20 11:20:37', 0, NULL),
(1, 6, '', '23.00000', 'ml', '', NULL, '', '2010-01-20 11:20:37', '1', '2010-01-20 11:20:38', '1', 2, '2010-01-20 11:20:38', 0, NULL);
INSERT INTO `source_aliquots` (`id`, `sample_master_id`, `aliquot_master_id`, `aliquot_use_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 2, 1, 5, '2010-01-20 11:14:10', '1', '2010-01-20 11:14:10', '1', 0, NULL);
INSERT INTO `source_aliquots_revs` (`id`, `sample_master_id`, `aliquot_master_id`, `aliquot_use_id`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 2, 1, 5, '2010-01-20 11:14:10', '1', '2010-01-20 11:14:10', '1', 1, '2010-01-20 11:14:10', 0, NULL);
INSERT INTO `specimen_details` (`id`, `sample_master_id`, `supplier_dept`, `reception_by`, `reception_datetime`, `reception_datetime_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, `deleted_date`) VALUES
(1, 1, 'custom_supplier_dept_2', 'custom_laboratory_staff_etc', '2010-01-01 02:46:00', '', '2010-01-20 10:58:42', '1', '2010-01-20 10:58:42', '1', 0, NULL),
(2, 3, 'custom_supplier_dept_etc', 'custom_laboratory_staff_1', '2010-01-01 02:46:00', '', '2010-01-20 11:15:12', '1', '2010-01-20 11:15:12', '1', 0, NULL),
(3, 6, '', '', '2010-01-02 14:03:00', '', '2010-01-20 11:20:38', '1', '2010-01-20 11:20:38', '1', 0, NULL);
INSERT INTO `specimen_details_revs` (`id`, `sample_master_id`, `supplier_dept`, `reception_by`, `reception_datetime`, `reception_datetime_accuracy`, `created`, `created_by`, `modified`, `modified_by`, `version_id`, `version_created`, `deleted`, `deleted_date`) VALUES
(1, 1, 'custom_supplier_dept_2', 'custom_laboratory_staff_etc', '2010-01-01 02:46:00', '', '2010-01-20 10:58:42', '1', '2010-01-20 10:58:42', '1', 1, '2010-01-20 10:58:42', 0, NULL),
(2, 3, 'custom_supplier_dept_etc', 'custom_laboratory_staff_1', '2010-01-01 02:46:00', '', '2010-01-20 11:15:12', '1', '2010-01-20 11:15:12', '1', 2, '2010-01-20 11:15:12', 0, NULL),
(3, 6, '', '', '2010-01-02 14:03:00', '', '2010-01-20 11:20:38', '1', '2010-01-20 11:20:38', '1', 3, '2010-01-20 11:20:38', 0, NULL);

-- ------------------------------------------------------------------------------------------------------------
SET FOREIGN_KEY_CHECKS=1;
-- ------------------------------------------------------------------------------------------------------------

