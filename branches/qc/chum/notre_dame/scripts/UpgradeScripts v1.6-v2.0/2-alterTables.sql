#Alter existing tables to fit the newest schema. 
#Add foreign keys and data in control tables

##########################################################################
# INVENTORY
##########################################################################

# ALIQUOT ----------------------------------------------------------------

ALTER TABLE ad_tubes
    ADD cell_count decimal(10,2) NULL DEFAULT NULL COMMENT '' AFTER concentration_unit,
    ADD cell_count_unit varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER cell_count,
    ADD cell_passage_number varchar(10) NULL DEFAULT NULL AFTER cell_count_unit,
    ADD tmp_storage_method varchar(30) NULL DEFAULT NULL AFTER cell_passage_number,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '';
    
ALTER TABLE ad_tubes_revs
    ADD cell_passage_number varchar(10) NULL DEFAULT NULL AFTER cell_count_unit,
    ADD tmp_storage_method varchar(30) NULL DEFAULT NULL AFTER cell_passage_number,    
    ADD tmp_storage_solution varchar(30) NULL DEFAULT NULL AFTER tmp_storage_method;

#mode ad_cell_culture_tubes to ad_tubes
INSERT INTO ad_tubes (aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, tmp_storage_solution, cell_passage_number, created, created_by, modified, modified_by)
(SELECT aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, tmp_storage_solution, cell_passage_number, created, created_by, modified, modified_by FROM ad_cell_culture_tubes); 

DROP TABLE ad_cell_culture_tubes;    
UPDATE aliquot_controls SET detail_tablename = 'ad_tubes' WHERE detail_tablename = 'ad_cell_culture_tubes'; 

#move ad_cell_tubes to ad_tubes
INSERT INTO ad_tubes (aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, created, created_by, modified, modified_by) 
(SELECT aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, created, created_by, modified, modified_by FROM ad_cell_tubes);

DROP TABLE ad_cell_tubes;
UPDATE aliquot_controls SET detail_tablename = 'ad_tubes' WHERE detail_tablename = 'ad_cell_tubes'; 

#move ad_tissue_tubes to ad_tubes
INSERT INTO ad_tubes (aliquot_master_id, tmp_storage_solution, tmp_storage_method, created, created_by, modified, modified_by) 
(SELECT aliquot_master_id, tmp_storage_solution, tmp_storage_method, created, created_by, modified, modified_by FROM ad_tissue_tubes);

DROP TABLE ad_tissue_tubes;
UPDATE aliquot_controls SET detail_tablename = 'ad_tubes' WHERE detail_tablename = 'ad_tissue_tubes'; 

ALTER TABLE ad_blocks
    CHANGE type block_type varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER aliquot_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '';
    
ALTER TABLE ad_blocks_revs
    ADD sample_position_code varchar(10) NULL DEFAULT NULL AFTER block_type,	
    ADD tmp_gleason_primary_grade varchar(5) NULL DEFAULT NULL AFTER patho_dpt_block_code,	
    ADD tmp_gleason_secondary_grade varchar(5) NULL DEFAULT NULL AFTER tmp_gleason_primary_grade,	
    ADD tmp_tissue_primary_desc varchar(20) NULL DEFAULT NULL AFTER tmp_gleason_secondary_grade,	
    ADD tmp_tissue_secondary_desc varchar(20) NULL DEFAULT NULL AFTER tmp_tissue_primary_desc,	
    ADD path_report_code varchar(40) NULL DEFAULT NULL AFTER tmp_tissue_secondary_desc;	

ALTER TABLE ad_whatman_papers
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '';
    
ALTER TABLE ad_tissue_slides
    CHANGE ad_block_id block_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER immunochemistry,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP FOREIGN KEY ad_tissue_slides_ibfk_1,
    DROP FOREIGN KEY ad_tissue_slides_ibfk_2,
    ADD FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`),
    ADD FOREIGN KEY (`block_aliquot_master_id`) REFERENCES `aliquot_masters` (`id`);
    
ALTER TABLE aliquot_controls
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER comment,
    MODIFY form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci;

#Delete unused aliquot_controls that have not been defined into 2.0 (check #1)
DELETE FROM sample_aliquot_control_links WHERE aliquot_control_id IN ('3', '7', '9');
DELETE FROM aliquot_controls WHERE id IN ('3', '7', '9');

ALTER TABLE aliquot_masters
    CHANGE status in_stock varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER aliquot_volume_unit,
    CHANGE status_reason in_stock_detail varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER in_stock,
    ADD coord_x_order int(3) NULL DEFAULT NULL COMMENT '' AFTER storage_coord_x,
    ADD coord_y_order int(3) NULL DEFAULT NULL COMMENT '' AFTER storage_coord_y,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP received,
    DROP received_datetime,
    DROP received_from,
    DROP received_id,
    ADD UNIQUE unique_barcode (barcode),
    ADD INDEX barcode (barcode),
    ADD INDEX aliquot_type (aliquot_type);

UPDATE aliquot_masters set in_stock = 'no' WHERE in_stock = 'not available';
UPDATE aliquot_masters set in_stock = 'yes - available' WHERE in_stock = 'available' AND in_stock_detail IS NULL;
UPDATE aliquot_masters set in_stock = 'yes - available' WHERE in_stock = 'available' AND in_stock_detail LIKE '';
UPDATE aliquot_masters set in_stock = 'yes - not available' WHERE in_stock = 'available';
UPDATE aliquot_masters set in_stock_detail = 'used' WHERE in_stock_detail = 'used and/or sent';
 
UPDATE aliquot_masters set coord_x_order =  storage_coord_x;   
UPDATE aliquot_masters set coord_y_order = 1 where storage_coord_y = 'A'; 
UPDATE aliquot_masters set coord_y_order = 2 where storage_coord_y = 'B'; 
UPDATE aliquot_masters set coord_y_order = 3 where storage_coord_y = 'C'; 
UPDATE aliquot_masters set coord_y_order = 4 where storage_coord_y = 'D'; 
UPDATE aliquot_masters set coord_y_order = 5 where storage_coord_y = 'E'; 
UPDATE aliquot_masters set coord_y_order = 6 where storage_coord_y = 'F'; 
UPDATE aliquot_masters set coord_y_order = 7 where storage_coord_y = 'G'; 
UPDATE aliquot_masters set coord_y_order = 8 where storage_coord_y = 'H'; 
UPDATE aliquot_masters set coord_y_order = 9 where storage_coord_y = 'I'; 

ALTER TABLE aliquot_masters_revs
    ADD aliquot_label varchar(60) NOT NULL DEFAULT '' AFTER barcode,
    ADD stored_by varchar(50) NULL DEFAULT NULL AFTER coord_y_order;

ALTER TABLE aliquot_uses
    ADD use_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER use_definition,
    ADD used_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER use_datetime,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '';
 
UPDATE aliquot_uses set use_code = use_details WHERE use_definition = 'internal use';

UPDATE aliquot_uses alq_use, realiquotings rq
SET alq_use.use_datetime = rq.realiquoted_datetime,
alq_use.used_by = rq.realiquoted_by
WHERE rq.aliquot_use_id =  alq_use.id
AND alq_use.use_definition = 'realiquoted to';

ALTER TABLE realiquotings
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY parent_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY child_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '';
    
ALTER TABLE realiquotings
    DROP realiquoted_by,
    DROP realiquoted_datetime;

UPDATE aliquot_uses set use_code = use_details WHERE use_definition = 'realiquoted to';
UPDATE aliquot_uses set use_details = '' WHERE use_definition = 'realiquoted to';

RENAME TABLE quality_controls TO quality_ctrls;
ALTER TABLE quality_ctrls
    ADD qc_code varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER id,
    ADD run_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER run_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '';

ALTER TABLE quality_ctrls_revs
    ADD `chip_model` varchar(10) NULL DEFAULT NULL AFTER `type`,
    ADD `position_into_run` varchar(20) NULL DEFAULT NULL AFTER `run_by`;

UPDATE quality_ctrls SET qc_code = concat('QC - ', id); 

RENAME TABLE qc_tested_aliquots TO quality_ctrl_tested_aliquots;

ALTER TABLE quality_ctrl_tested_aliquots
	CHANGE COLUMN quality_control_id quality_ctrl_id int(11) DEFAULT NULL,
    ADD COLUMN deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    ADD COLUMN deleted_date datetime NULL DEFAULT NULL COMMENT '',
    DROP INDEX quality_control_id,
	DROP FOREIGN KEY quality_ctrl_tested_aliquots_ibfk_1,
	ADD INDEX quality_ctrl_id (`quality_ctrl_id`);

ALTER TABLE `quality_ctrl_tested_aliquots` 
  ADD CONSTRAINT `FK_quality_ctrl_tested_aliquots_quality_ctrls` 
  FOREIGN KEY (`quality_ctrl_id`) REFERENCES `quality_ctrls` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT;  
  
UPDATE `aliquot_uses` SET `use_recorded_into_table` = 'quality_ctrl_tested_aliquots' WHERE `use_recorded_into_table` LIKE 'qc_tested_aliquots';

UPDATE aliquot_uses alq_use, quality_ctrl_tested_aliquots tst_alq, quality_ctrls qc
SET alq_use.use_code = qc.qc_code
WHERE tst_alq.aliquot_use_id = alq_use.id
AND tst_alq.quality_ctrl_id = qc.id
AND alq_use.use_definition = 'quality control';

ALTER TABLE source_aliquots
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '';
    
UPDATE sample_masters samp, source_aliquots sour, aliquot_uses alq_use
SET alq_use.use_code = samp.sample_code
WHERE alq_use.id = sour.aliquot_use_id
AND sour.sample_master_id = samp.id
AND alq_use.use_definition = 'sample derivative creation';

ALTER TABLE orders
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    ADD INDEX order_number (order_number),
    ADD FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
    
ALTER TABLE orders_revs    
  ADD `type` varchar(30) DEFAULT NULL AFTER short_title,
  ADD `microarray_chip` varchar(30) DEFAULT NULL AFTER type;    

ALTER TABLE order_lines
    DROP cancer_type,
    DROP quantity_UM,
	CHANGE min_qty_ordered min_quantity_ordered varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER quantity_ordered,
    ADD quantity_unit varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER min_quantity_ordered,
    DROP min_qty_UM,
    DROP base_price,
    DROP quantity_shipped,
    DROP discount_id,
    DROP product_id,
    
    ADD product_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER modified_by,
    ADD aliquot_control_id int(11) NULL DEFAULT NULL COMMENT '' AFTER sample_control_id,
    ADD sample_aliquot_precision varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER aliquot_control_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER order_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
   
    MODIFY quantity_ordered varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD FOREIGN KEY (`sample_control_id`) REFERENCES `sample_controls` (`id`),
  	ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);
	
ALTER TABLE order_items
	CHANGE orderline_id order_line_id int(11) NULL DEFAULT NULL COMMENT '' AFTER modified_by,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER aliquot_use_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP barcode,
    DROP base_price,
    DROP datetime_scanned_out,
    MODIFY aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '';

ALTER TABLE order_items_revs
    ADD `shipping_name` varchar(80) DEFAULT NULL AFTER id;

ALTER TABLE shipments
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER order_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    ADD INDEX shipment_code (shipment_code),
    ADD INDEX recipient (recipient),
    ADD INDEX facility (facility),
    ADD INDEX FK_shipments_orders (order_id);

UPDATE order_lines SET status = 'shipped';
UPDATE order_lines SET status = 'pending' WHERE id NOT IN (SELECT order_line_id FROM order_items);
UPDATE order_lines SET status = 'pending' WHERE id IN (SELECT order_line_id FROM order_items WHERE status = 'pending');

UPDATE aliquot_masters alq, order_items items
SET alq.in_stock = 'yes - not available', alq.in_stock_detail = 'reserved for order'
WHERE alq.id = items.aliquot_master_id
AND items.status = 'pending';

UPDATE aliquot_masters alq, order_items items
SET alq.in_stock = 'no', alq.in_stock_detail = 'shipped'
WHERE alq.id = items.aliquot_master_id
AND items.status = 'shipped';

UPDATE order_items items, aliquot_uses alq_use, shipments ship
SET alq_use.use_code = ship.shipment_code,
alq_use.use_datetime = ship.datetime_shipped,
alq_use.used_by = ship.shipped_by
WHERE alq_use.id = items.aliquot_use_id
AND ship.id = items.shipment_id
AND items.status = 'shipped'
AND alq_use.use_definition = 'aliquot shipment';

# SAMPLE -----------------------------------------------------------------

ALTER TABLE sample_controls
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER detail_tablename,
    MODIFY form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci;

SET @sample_control_id = '5';
SET @sample_type = 'ascite cell';
UPDATE sample_controls SET detail_tablename = 'sd_der_ascite_cells' WHERE id = @sample_control_id AND sample_type = @sample_type;
INSERT INTO sd_der_ascite_cells (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters WHERE sample_control_id = @sample_control_id AND sample_type = @sample_type);
  
SET @sample_control_id = '6';
SET @sample_type = 'ascite supernatant';
UPDATE sample_controls SET detail_tablename = 'sd_der_ascite_sups' WHERE id = @sample_control_id AND sample_type = @sample_type;
INSERT INTO sd_der_ascite_sups (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters WHERE sample_control_id = @sample_control_id AND sample_type = @sample_type);
 
SET @sample_control_id = '14';
SET @sample_type = 'concentrated urine';
UPDATE sample_controls SET detail_tablename = 'sd_der_urine_cons' WHERE id = @sample_control_id AND sample_type = @sample_type;
INSERT INTO sd_der_urine_cons (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters WHERE sample_control_id = @sample_control_id AND sample_type = @sample_type);

SET @sample_control_id = '15';
SET @sample_type = 'centrifuged urine';
UPDATE sample_controls SET detail_tablename = 'sd_der_urine_cents' WHERE id = @sample_control_id AND sample_type = @sample_type;
INSERT INTO sd_der_urine_cents (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters WHERE sample_control_id = @sample_control_id AND sample_type = @sample_type);
  
SET @sample_control_id = '101';
SET @sample_type = 'tissue lysate';
UPDATE sample_controls SET detail_tablename = 'sd_der_tiss_lysates' WHERE id = @sample_control_id AND sample_type = @sample_type;
INSERT INTO sd_der_tiss_lysates (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters WHERE sample_control_id = @sample_control_id AND sample_type = @sample_type);
  
SET @sample_control_id = '102';
SET @sample_type = 'tissue suspension';
UPDATE sample_controls SET detail_tablename = 'sd_der_tiss_susps' WHERE id = @sample_control_id AND sample_type = @sample_type;
INSERT INTO sd_der_tiss_susps (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters WHERE sample_control_id = @sample_control_id AND sample_type = @sample_type);
  
SET @sample_control_id = '106';
SET @sample_type = 'peritoneal wash cell';
UPDATE sample_controls SET detail_tablename = 'sd_der_pw_cells' WHERE id = @sample_control_id AND sample_type = @sample_type;
INSERT INTO sd_der_pw_cells (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters WHERE sample_control_id = @sample_control_id AND sample_type = @sample_type);
     
SET @sample_control_id = '107';
SET @sample_type = 'peritoneal wash supernatant ';
UPDATE sample_controls SET detail_tablename = 'sd_der_pw_sups' WHERE id = @sample_control_id AND sample_type = @sample_type;
INSERT INTO sd_der_pw_sups (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters WHERE sample_control_id = @sample_control_id AND sample_type = @sample_type);
     
SET @sample_control_id = '108';
SET @sample_type = 'cystic fluid cell';
UPDATE sample_controls SET detail_tablename = 'sd_der_cystic_fl_cells' WHERE id = @sample_control_id AND sample_type = @sample_type;
INSERT INTO sd_der_cystic_fl_cells (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters WHERE sample_control_id = @sample_control_id AND sample_type = @sample_type);
     
SET @sample_control_id = '109';
SET @sample_type = 'cystic fluid supernatant';
UPDATE sample_controls SET detail_tablename = 'sd_der_cystic_fl_sups' WHERE id = @sample_control_id AND sample_type = @sample_type;
INSERT INTO sd_der_cystic_fl_sups (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters WHERE sample_control_id = @sample_control_id AND sample_type = @sample_type);

DELETE FROM `sample_aliquot_control_links` WHERE `sample_control_id` IN (SELECT id FROM `sample_controls` WHERE `sample_type` LIKE 'amplified dna');
DELETE FROM `sample_controls` WHERE `sample_type` LIKE 'amplified dna';
    
RENAME TABLE sd_der_amplified_rnas TO sd_der_amp_rnas;
UPDATE sample_controls SET detail_tablename = 'sd_der_amp_rnas' WHERE detail_tablename = 'sd_der_amplified_rnas';

UPDATE sample_controls SET form_alias = 'sd_undetailed_derivatives', detail_tablename = 'sd_der_b_cells' WHERE `sample_type` LIKE 'b cell';
UPDATE sample_controls SET status = 'inactive' WHERE `sample_type` LIKE 'b cell';

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_type_code`, `sample_category`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(112, 'pericardial fluid', 'PC-F', 'specimen', 'active', 'sd_spe_pericardial_fluids', 'sd_spe_pericardial_fluids', 0),
(113, 'pleural fluid', 'PL-F', 'specimen', 'active', 'sd_spe_pleural_fluids', 'sd_spe_pleural_fluids', 0),
(114, 'pericardial fluid cell', 'PC-C', 'derivative', 'active', 'sd_undetailed_derivatives', 'sd_der_pericardial_fl_cells', 0),
(115, 'pericardial fluid supernatant', 'PC-S', 'derivative', 'active', 'sd_undetailed_derivatives', 'sd_der_pericardial_fl_sups', 0),
(116, 'pleural fluid cell', 'PL-C', 'derivative', 'active', 'sd_undetailed_derivatives', 'sd_der_pleural_fl_cells', 0),
(117, 'pleural fluid supernatant', 'PL-S', 'derivative', 'active', 'sd_undetailed_derivatives', 'sd_der_pleural_fl_sups', 0);

UPDATE sample_controls SET detail_tablename = 'sd_der_of_cells ' WHERE `sample_type` LIKE 'other fluid cell';
UPDATE sample_controls SET detail_tablename = 'sd_der_of_sups' WHERE `sample_type` LIKE 'other fluid supernatant';

CREATE TABLE IF NOT EXISTS `sd_der_of_cells` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=29663 ;

CREATE TABLE IF NOT EXISTS `sd_der_of_cells_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `sd_der_of_sups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=29663 ;

CREATE TABLE IF NOT EXISTS `sd_der_of_sups_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ; 

RENAME TABLE sample_aliquot_control_links TO sample_to_aliquot_controls;

INSERT INTO parent_to_derivative_sample_controls (id, parent_sample_control_id, derivative_sample_control_id, status)
(SELECT id, source_sample_control_id, derived_sample_control_id, status FROM derived_sample_links);

DROP TABLE derived_sample_links;

INSERT INTO `parent_to_derivative_sample_controls` (`id`, `parent_sample_control_id`, `derivative_sample_control_id`, `status`) VALUES
(120, 112, 114, 'active'),
(121, 112, 115, 'active'),
(122, 113, 116, 'active'),
(123, 113, 117, 'active'),
(124, 114, 11, 'active'),
(125, 114, 12, 'active'),
(126, 114, 13, 'active'),
(127, 116, 11, 'active'),
(128, 116, 12, 'active'),
(129, 116, 13, 'active');

ALTER TABLE sample_to_aliquot_controls
    MODIFY sample_control_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_control_id int(11) NULL DEFAULT NULL COMMENT '';

INSERT INTO `sample_to_aliquot_controls` (`id`, `sample_control_id`, `aliquot_control_id`, `status`) VALUES
(45, 114, 8, 'active'),
(46, 115, 8, 'active'),
(47, 116, 8, 'active'),
(48, 117, 8, 'active'),
(49, 113, 2, 'active'),
(50, 112, 2, 'active'),
(51, 3, 1, 'inactive'),
(52, 11, 15, 'inactive');

ALTER TABLE sd_der_amp_rnas
    ADD COLUMN deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    ADD COLUMN deleted_date datetime NULL DEFAULT NULL COMMENT '';

ALTER TABLE sd_der_amp_rnas_revs
    ADD `tmp_amplification_method` varchar(30) DEFAULT NULL AFTER sample_master_id,
    ADD `tmp_amplification_number` varchar(30) DEFAULT NULL AFTER tmp_amplification_method;
    
ALTER TABLE sd_der_blood_cells
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';   
    
ALTER TABLE sd_der_blood_cells_revs
    ADD `tmp_solution` varchar(30) DEFAULT NULL AFTER sample_master_id;
    
ALTER TABLE sd_der_pbmcs
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT ''; 
  
ALTER TABLE sd_der_pbmcs_revs    
    ADD `tmp_solution` varchar(30) DEFAULT NULL AFTER sample_master_id;

ALTER TABLE sd_der_dnas
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
    
ALTER TABLE sd_der_dnas_revs    
    ADD `source_cell_passage_number` varchar(10) DEFAULT NULL AFTER sample_master_id,
    ADD `source_temperature` decimal(5,2) DEFAULT NULL AFTER source_cell_passage_number,
    ADD `source_temp_unit` varchar(20) DEFAULT NULL AFTER source_temperature,
    ADD `tmp_extraction_method` varchar(30) DEFAULT NULL AFTER source_temp_unit,
    ADD `tmp_source_milieu` varchar(30) DEFAULT NULL AFTER tmp_extraction_method,
    ADD `tmp_source_storage_method` varchar(30) DEFAULT NULL AFTER tmp_source_milieu;
  
ALTER TABLE sd_der_rnas
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';

ALTER TABLE sd_der_rnas_revs
    ADD `source_cell_passage_number` varchar(10) DEFAULT NULL,
    ADD `source_temperature` decimal(5,2) DEFAULT NULL,
    ADD `source_temp_unit` varchar(20) DEFAULT NULL,
    ADD `tmp_extraction_method` varchar(30) DEFAULT NULL,
    ADD `tmp_source_milieu` varchar(30) DEFAULT NULL,
    ADD `tmp_source_storage_method` varchar(30) DEFAULT NULL;

ALTER TABLE sd_spe_other_fluids
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';

CREATE TABLE IF NOT EXISTS `sd_spe_other_fluids_revs` (
  `id` int(11) NOT NULL,
  `sample_master_id` int(11) DEFAULT NULL,
  `collected_volume` decimal(10,5) DEFAULT NULL,
  `collected_volume_unit` varchar(20) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- Move other fluid to pericardial fluid
UPDATE sample_masters 
SET sample_control_id = '112', sample_type = 'pericardial fluid', initial_specimen_sample_type = 'pericardial fluid'
WHERE id = 3323;

INSERT INTO sd_spe_pericardial_fluids (id, sample_master_id, collected_volume, collected_volume_unit, created, created_by, modified, modified_by) 
(SELECT id, id, collected_volume, collected_volume_unit, created, created_by, modified, modified_by FROM sd_spe_other_fluids 
WHERE sample_master_id = 3323);

DELETE FROM sd_spe_other_fluids WHERE sample_master_id = 3323;

UPDATE sample_masters 
SET initial_specimen_sample_type = 'pericardial fluid'
WHERE initial_specimen_sample_id = 3323;

UPDATE sample_masters 
SET sample_control_id = '114', sample_type = 'pericardial fluid cell'
WHERE initial_specimen_sample_id = 3323
AND sample_type = 'other fluid cell';

INSERT INTO sd_der_pericardial_fl_cells (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters 
WHERE sample_type = 'pericardial fluid cell');

UPDATE sample_masters 
SET sample_control_id = '115', sample_type = 'pericardial fluid supernatant'
WHERE initial_specimen_sample_id = 3323
AND sample_type = 'other fluid supernatant';

INSERT INTO sd_der_pericardial_fl_sups (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters 
WHERE sample_type = 'pericardial fluid supernatant');

-- Move other fluid to pleural fluid
UPDATE sample_masters 
SET sample_control_id = '113', sample_type = 'pleural fluid', initial_specimen_sample_type = 'pleural fluid'
WHERE id IN (3327, 4677, 14328);

INSERT INTO sd_spe_pleural_fluids (id, sample_master_id, collected_volume, collected_volume_unit, created, created_by, modified, modified_by) 
(SELECT id, id, collected_volume, collected_volume_unit, created, created_by, modified, modified_by FROM sd_spe_other_fluids 
WHERE sample_master_id IN (3327, 4677, 14328));

DELETE FROM sd_spe_other_fluids WHERE sample_master_id IN (3327, 4677, 14328);

UPDATE sample_masters 
SET initial_specimen_sample_type = 'pleural fluid'
WHERE initial_specimen_sample_id IN (3327, 4677, 14328);

UPDATE sample_masters 
SET sample_control_id = '116', sample_type = 'pleural fluid cell'
WHERE initial_specimen_sample_id IN (3327, 4677, 14328)
AND sample_type = 'other fluid cell';

INSERT INTO sd_der_pleural_fl_cells (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters 
WHERE sample_type = 'pleural fluid cell');

UPDATE sample_masters 
SET sample_control_id = '117', sample_type = 'pleural fluid supernatant'
WHERE initial_specimen_sample_id IN (3327, 4677, 14328)
AND sample_type = 'other fluid supernatant';

INSERT INTO sd_der_pleural_fl_sups (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters 
WHERE sample_type = 'pleural fluid supernatant');

-- other fluid clean up
INSERT INTO sd_der_of_cells (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters 
WHERE sample_type = 'other fluid cell');

INSERT INTO sd_der_of_sups (id, sample_master_id, created, created_by, modified, modified_by) 
(SELECT id, id, created, created_by, modified, modified_by FROM sample_masters 
WHERE sample_type = 'other fluid supernatant');

ALTER TABLE sd_der_cell_cultures
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY cell_passage_number int(6) NULL DEFAULT NULL COMMENT '';
    
ALTER TABLE sd_der_cell_cultures_revs
	ADD `tmp_collection_method` varchar(30) DEFAULT NULL AFTER `cell_passage_number`,
	ADD `tmp_hormon` varchar(40) DEFAULT NULL AFTER `tmp_collection_method`,
	ADD `tmp_solution` varchar(30) DEFAULT NULL AFTER `tmp_hormon`,
	ADD `tmp_percentage_of_oxygen` varchar(30) DEFAULT NULL AFTER `tmp_solution`,
	ADD `tmp_percentage_of_serum` varchar(30) DEFAULT NULL AFTER `tmp_percentage_of_oxygen`; 

ALTER TABLE sd_der_plasmas
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT ''; 
    
ALTER TABLE sd_der_serums
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';

ALTER TABLE sd_spe_ascites
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
    
ALTER TABLE sd_spe_bloods
    CHANGE type blood_type varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER sample_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
  
ALTER TABLE sd_spe_cystic_fluids
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';

ALTER TABLE sd_spe_peritoneal_washes
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';

ALTER TABLE sd_spe_tissues
    CHANGE nature tissue_nature varchar(15) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER tissue_source,
    CHANGE laterality tissue_laterality varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER tissue_nature,
    CHANGE size tissue_size varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER pathology_reception_datetime,
    ADD tissue_size_unit varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER tissue_size,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY tissue_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci;

ALTER TABLE sd_spe_tissues_revs
    ADD `labo_laterality` varchar(10) DEFAULT NULL AFTER tissue_laterality,
    ADD `tmp_buffer_use` varchar(10) DEFAULT NULL AFTER tissue_size_unit,
    ADD `tmp_on_ice` varchar(10) DEFAULT NULL AFTER tmp_buffer_use;

ALTER TABLE sd_spe_urines
    CHANGE aspect urine_aspect varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER sample_master_id,
    CHANGE pellet pellet_signs varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER collected_volume_unit,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
      
ALTER TABLE sd_spe_urines    
	DROP received_volume,
	DROP received_volume_unit;
    
ALTER TABLE specimen_details
    ADD reception_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER supplier_dept,
    ADD reception_datetime datetime NULL DEFAULT NULL COMMENT '' AFTER reception_by,
    ADD reception_datetime_accuracy varchar(4) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER reception_datetime,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';

ALTER TABLE specimen_details_revs
    ADD `type_code` varchar(10) DEFAULT NULL AFTER reception_datetime_accuracy,
    ADD `sequence_number` varchar(10) DEFAULT NULL AFTER type_code;
	 
UPDATE specimen_details spec, sample_masters samp, collections col
SET spec.reception_by = col.reception_by,
spec.reception_datetime = col.reception_datetime
WHERE spec.sample_master_id = samp.id
AND samp.collection_id = col.id;

ALTER TABLE derivative_details
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';

ALTER TABLE sample_masters
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD UNIQUE unique_sample_code (sample_code),
    ADD INDEX sample_code (sample_code);
    
ALTER TABLE sample_masters_revs
    ADD `sample_label` varchar(60) NOT NULL DEFAULT '' AFTER parent_id;    
    
# COLLECTION & BANK ------------------------------------------------------  
    
ALTER TABLE banks
    ADD created_by int(11) NOT NULL DEFAULT 0 COMMENT '' AFTER description,
    ADD modified_by int(11) NOT NULL DEFAULT 0 COMMENT '' AFTER created,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;

ALTER TABLE collections
    ADD bank_id int(11) NULL DEFAULT NULL COMMENT '' AFTER acquisition_label,
    ADD collection_datetime_accuracy varchar(4) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER collection_datetime,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY collection_property varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD INDEX acquisition_label (acquisition_label);
    
ALTER TABLE collections   
    DROP bank_participant_identifier,
    DROP reception_by,
    DROP reception_datetime;
 
ALTER TABLE collections_revs
    ADD `visit_label` varchar(20) DEFAULT NULL AFTER bank_id;

DELETE FROM banks;

INSERT INTO banks (id, name) VALUES
(1, 'Breast / Sein'),
(2, 'Ovary / Ovaire'),
(3, 'Prostate / Prostate'),
(4, 'Kidney / Rein'),
(5, 'Head and Neck / Tête et cou');

UPDATE collections SET bank_id = '1' WHERE bank = 'breast';     
UPDATE collections SET bank_id = '2' WHERE bank = 'ovary';   
UPDATE collections SET bank_id = '3' WHERE bank = 'prostate'; 
UPDATE collections SET bank_id = '4' WHERE bank = 'kidney'; 
UPDATE collections SET bank_id = '5' WHERE bank = 'head and neck'; 

ALTER TABLE collections
	DROP bank;

ALTER TABLE clinical_collection_links
    CHANGE diagnosis_id diagnosis_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER collection_id,
    CHANGE consent_id consent_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER diagnosis_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '';
    
UPDATE clinical_collection_links SET participant_id=NULL WHERE participant_id=0;
UPDATE clinical_collection_links SET consent_master_id=NULL WHERE consent_master_id=0;
UPDATE clinical_collection_links SET diagnosis_master_id=NULL WHERE diagnosis_master_id=0;
    
##########################################################################
# CLINICAL ANNOTATION
##########################################################################

ALTER TABLE participants
    CHANGE memo notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER vital_status,
    CHANGE icd10_id cod_icd10_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER dod_date_accuracy,
    ADD secondary_cod_icd10_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER cod_icd10_code,
    MODIFY title varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
	MODIFY first_name varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY last_name varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY race varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
	ADD cod_confirmation_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER secondary_cod_icd10_code,
	CHANGE tb_number participant_identifier varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER cod_confirmation_source,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
	MODIFY sex varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
	CHANGE approximative_date_of_birth dob_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE approximative_date_of_death dod_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE approximative_last_visit_date lvd_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci;
       
ALTER TABLE participants    
	DROP ethnicity,
    DROP confirmation_source,
	DROP status,
	DROP date_status,
	DROP death_certificate_ident;
		    
UPDATE participants SET cod_icd10_code=NULL WHERE cod_icd10_code=''; 
UPDATE participants SET dob_date_accuracy='' WHERE dob_date_accuracy='no' AND date_of_birth IS NULL;
UPDATE participants SET dod_date_accuracy='' WHERE dod_date_accuracy='no' AND date_of_death IS NULL; 
UPDATE participants SET dob_date_accuracy='c' WHERE dob_date_accuracy='no';
UPDATE participants SET dod_date_accuracy='c' WHERE dod_date_accuracy='no'; 
UPDATE participants SET dob_date_accuracy='' WHERE dob_date_accuracy!='c';
UPDATE participants SET dod_date_accuracy='' WHERE dod_date_accuracy!='c'; 
UPDATE participants SET lvd_date_accuracy='' WHERE lvd_date_accuracy='no' AND last_visit_date IS NULL; 
UPDATE participants SET lvd_date_accuracy='c' WHERE lvd_date_accuracy='no';
UPDATE participants SET lvd_date_accuracy='' WHERE lvd_date_accuracy!='c';

UPDATE participants SET sex='f' WHERE sex='F';
UPDATE participants SET sex='m' WHERE sex='M';
UPDATE participants SET sex='u' WHERE sex='U';

ALTER TABLE participants_revs
    ADD `last_visit_date` date DEFAULT NULL,
    ADD `lvd_date_accuracy` varchar(50) DEFAULT NULL,
    ADD `sardo_participant_id` varchar(20) DEFAULT NULL,
    ADD `sardo_numero_dossier` varchar(20) DEFAULT NULL,
    ADD `last_sardo_import_date` date DEFAULT NULL;

UPDATE participant_contacts 
SET other_contact_type = type_precision
WHERE other_contact_type LIKE 'other contact:%';
    
UPDATE participant_contacts 
SET other_contact_type = facility
WHERE facility NOT LIKE '' AND facility IS NOT NULL;

ALTER TABLE participant_contacts
	CHANGE city locality varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER street,
	DROP street_nbr,
    CHANGE memo notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER expiry_date,
    CHANGE name contact_name varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER id,
    DROP type_precision,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER participant_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP facility,
    MODIFY phone_secondary varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '';

ALTER TABLE participant_messages
    CHANGE type message_type varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER author,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP sardo_note_id,
    DROP last_sardo_import_date;

ALTER TABLE participant_messages_revs
    ADD `status` varchar(20) DEFAULT NULL AFTER expiry_date;

ALTER TABLE misc_identifiers
    CHANGE name identifier_name varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER identifier_value,
    CHANGE memo notes varchar(100) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER expiry_date,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;

UPDATE misc_identifiers SET identifier_name = 'other center id nbr' WHERE identifier_name = 'other center patient number';

DELETE FROM misc_identifier_controls;
INSERT INTO misc_identifier_controls  
(`misc_identifier_name`, `misc_identifier_name_abbrev`, `status`, `display_order`, `autoincrement_name`, `misc_identifier_value`)
VALUE
('ovary bank no lab', 'OV NoLabo', 'active', '1', 'ovary bank no lab', '%%key_increment%%'),
('breast bank no lab', 'BR NoLabo', 'active', '2', 'breast bank no lab', '%%key_increment%%'),
('kidney bank no lab', 'KD NoLabo', 'active', '3', 'kidney bank no lab', '%%key_increment%%'),
('head and neck bank no lab', 'HN NoLabo', 'active', '4', 'head and neck bank no lab', '%%key_increment%%'),
('prostate bank no lab', 'PR NoLabo', 'active', '5', 'prostate bank no lab', '%%key_increment%%'),
('old bank no lab', 'OLD NoLabo', 'active', '6', null, null),

('ramq nbr', 'RAMQ', 'active', '10', null, null),

('hotel-dieu id nbr', 'HD H#', 'active', '21', null, null),
('notre-dame id nbr', 'ND H#', 'active', '22', null, null),
('saint-luc id nbr', 'SL H#', 'active', '23', null, null),

('code-barre', 'BC', 'active', '30', 'code-barre', '%%key_increment%%'),
('other center id nbr', 'EXT ID#', 'active', '31', null, null);

UPDATE misc_identifiers id,  misc_identifier_controls ctr
SET id.identifier_abrv = ctr.misc_identifier_name_abbrev
WHERE id.identifier_name = ctr.misc_identifier_name;

RENAME TABLE part_bank_nbr_counters TO key_increments;

ALTER TABLE key_increments
	DROP id,
	CHANGE bank_ident_title key_name varchar(50) NOT NULL UNIQUE,
	CHANGE last_nbr key_value int(11) NOT NULL;

UPDATE key_increments SET key_value=key_value + 1; #the old system had the previous value rather than the next one

UPDATE consents 
SET consent_type = 'FRSQ', consent_version_date = '2008-03-26', consent_language = 'fr'
WHERE form_version = 'FRSQ_fr_2008-03-26';

UPDATE consents SET form_version = NULL;

ALTER TABLE consent_masters
	ADD `invitation_date` date DEFAULT NULL AFTER reason_denied,
	ADD `consent_type` varchar(20) NOT NULL DEFAULT '' AFTER id,
	ADD `consent_version_date` varchar(10) DEFAULT NULL AFTER consent_type,
	ADD `consent_language` varchar(10) DEFAULT NULL AFTER consent_version_date;
  
ALTER TABLE consent_masters_revs
	ADD `invitation_date` date DEFAULT NULL AFTER reason_denied,
	ADD `consent_type` varchar(20) NOT NULL DEFAULT '' AFTER id,
	ADD `consent_version_date` varchar(10) DEFAULT NULL AFTER consent_type,
	ADD `consent_language` varchar(10) DEFAULT NULL AFTER consent_version_date;
	
INSERT INTO consent_masters	(id, invitation_date,
consent_type, consent_version_date , consent_language ,
reason_denied , consent_status , status_date ,
notes,
created , created_by , modified , modified_by ,
participant_id )
(SELECT id, date, 
consent_type, consent_version_date, consent_language ,
reason_denied , consent_status , status_date ,
memo ,
created , created_by , modified , modified_by ,
participant_id 
FROM consents);

CREATE TABLE IF NOT EXISTS `cd_icm_generics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consent_master_id` int(11) NOT NULL,
  `biological_material_use` varchar(50) DEFAULT NULL,
  `use_of_blood` varchar(50) DEFAULT NULL,
  `use_of_urine` varchar(50) DEFAULT NULL,
  `urine_blood_use_for_followup` varchar(10) DEFAULT NULL,
  `stop_followup` varchar(10) DEFAULT NULL,
  `stop_followup_date` date DEFAULT NULL,
  `contact_for_additional_data` varchar(10) DEFAULT NULL,
  `allow_questionnaire` varchar(10) DEFAULT NULL,
  `stop_questionnaire` varchar(10) DEFAULT NULL,
  `stop_questionnaire_date` date DEFAULT NULL,
  `research_other_disease` varchar(50) DEFAULT NULL,
  `inform_discovery_on_other_disease` varchar(10) DEFAULT NULL,
  `inform_significant_discovery` varchar(50) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `consent_master_id` (`consent_master_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
	
CREATE TABLE IF NOT EXISTS `cd_icm_generics_revs` (
  `id` int(11) NOT NULL,
  `consent_master_id` int(11) NOT NULL,
  `biological_material_use` varchar(50) DEFAULT NULL,
  `use_of_blood` varchar(50) DEFAULT NULL,
  `use_of_urine` varchar(50) DEFAULT NULL,
  `urine_blood_use_for_followup` varchar(10) DEFAULT NULL,
  `stop_followup` varchar(10) DEFAULT NULL,
  `stop_followup_date` date DEFAULT NULL,
  `contact_for_additional_data` varchar(10) DEFAULT NULL,
  `allow_questionnaire` varchar(10) DEFAULT NULL,
  `stop_questionnaire` varchar(10) DEFAULT NULL,
  `stop_questionnaire_date` date DEFAULT NULL,
  `research_other_disease` varchar(50) DEFAULT NULL,
  `inform_discovery_on_other_disease` varchar(10) DEFAULT NULL,
  `inform_significant_discovery` varchar(50) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime DEFAULT NULL,
  `modified_by` varchar(50) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO cd_icm_generics (id, consent_master_id,
biological_material_use, use_of_blood, use_of_urine, 
urine_blood_use_for_followup, stop_followup, stop_followup_date,
contact_for_additional_data,
allow_questionnaire, stop_questionnaire, stop_questionnaire_date,
research_other_disease, inform_discovery_on_other_disease, inform_significant_discovery,
created , created_by , modified , modified_by)
(SELECT id, id,
biological_material_use, use_of_blood, use_of_urine, 
urine_blood_use_for_followup, stop_followup, stop_followup_date,
contact_for_additional_data,
allow_questionnaire, stop_questionnaire, stop_questionnaire_date,
research_other_disease, inform_discovery_on_other_disease, inform_significant_discovery,
created , created_by , modified , modified_by FROM consents);
  
DROP TABLE consents;

UPDATE consent_masters SET consent_signed_date = status_date WHERE consent_status = 'obtained';

DELETE FROM consent_controls;
INSERT INTO consent_controls (controls_type, form_alias, detail_tablename)
VALUE
('FRSQ - Network', 'cd_icm_generics', 'cd_icm_generics'),
('chum - kidney', 'cd_icm_generics', 'cd_icm_generics'),
('CHUM - Prostate', 'cd_icm_generics', 'cd_icm_generics'),
('FRSQ', 'cd_icm_generics', 'cd_icm_generics'),
('PROCURE', 'cd_icm_generics', 'cd_icm_generics'),
('unknown', 'cd_icm_generics', 'cd_icm_generics');

UPDATE consent_masters SET consent_type = 'unknown' WHERE consent_type = 'unknwon';
 
UPDATE consent_masters mast, consent_controls ctrl
SET mast.consent_control_id = ctrl.id
WHERE mast.consent_type = ctrl.controls_type;

CREATE TABLE IF NOT EXISTS `dxd_sardos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  `sardo_morpho_desc` varchar(200) DEFAULT NULL,
  `icd_o_grade` varchar(10) DEFAULT NULL,
  `grade` varchar(10) DEFAULT NULL,
  `stade_figo` varchar(100) DEFAULT NULL,
  `laterality` varchar(50) DEFAULT NULL,
  `sardo_diagnosis_id` varchar(20) DEFAULT NULL,
  `last_sardo_import_date` date DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL DEFAULT '',
  `deleted` int(11) NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `diagnosis_master_id` (`diagnosis_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `dxd_sardos_revs` (
  `id` int(11) NOT NULL,
  `diagnosis_master_id` int(11) NOT NULL DEFAULT '0',
  `sardo_morpho_desc` varchar(200) DEFAULT NULL,
  `icd_o_grade` varchar(10) DEFAULT NULL,
  `grade` varchar(10) DEFAULT NULL,
  `stade_figo` varchar(100) DEFAULT NULL,
  `laterality` varchar(50) DEFAULT NULL,
  `sardo_diagnosis_id` varchar(20) DEFAULT NULL,
  `last_sardo_import_date` date DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(255) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(255) NOT NULL DEFAULT '',
  `deleted` int(11) NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO diagnosis_masters (id,  
dx_identifier,dx_origin,dx_date,dx_date_accuracy,age_at_dx, 
primary_icd10_code,morphology,primary_number, 
clinical_tstage,clinical_nstage,clinical_mstage,clinical_stage_summary, 
path_tstage,path_nstage,path_mstage,path_stage_summary, 
survival_time_months, 
created,created_by,modified,modified_by, 
participant_id )
(SELECT id, 
dx_number, dx_origin, dx_date, approximative_dx_date, age_at_dx, 
icd10_id ,morphology, case_number,
clinical_tstage,clinical_nstage,clinical_mstage,clinical_stage_grouping, 
path_tstage,path_nstage,path_mstage,path_stage_grouping, 
survival, 
created,created_by,modified,modified_by,
participant_id FROM diagnoses);

INSERT INTO dxd_sardos (id, diagnosis_master_id,
sardo_morpho_desc,icd_o_grade,grade,stade_figo,laterality,sardo_diagnosis_id,last_sardo_import_date)
(SELECT id, id, 
sardo_morpho_desc,icd_o_grade,grade,stade_figo,laterality,sardo_diagnosis_id,last_sardo_import_date FROM diagnoses);

DROP TABLE diagnoses;

UPDATE participants SET dx_date_accuracy='' WHERE dx_date_accuracy='no' AND dx_date IS NULL;
UPDATE participants SET dx_date_accuracy='c' WHERE dx_date_accuracy='no';
UPDATE participants SET dx_date_accuracy='' WHERE dx_date_accuracy!='c';

DELETE FROM diagnosis_controls;
INSERT INTO diagnosis_controls (controls_type, form_alias, detail_tablename)
VALUE
('sardo', 'dxd_sardos', 'dxd_sardos');

UPDATE diagnosis_masters SET diagnosis_control_id = (SELECT id FROM diagnosis_controls WHERE controls_type = 'sardo');

RENAME TABLE event_masters TO event_masters_old;

CREATE TABLE IF NOT EXISTS `event_masters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_control_id` int(11) NOT NULL DEFAULT '0',
  `disease_site` varchar(255) NOT NULL DEFAULT '',
  `event_group` varchar(50) NOT NULL DEFAULT '',
  `event_type` varchar(50) NOT NULL DEFAULT '',
  `event_status` varchar(50) DEFAULT NULL,
  `event_summary` text,
  `event_date` date DEFAULT NULL,
  `information_source` varchar(255) DEFAULT NULL,
  `urgency` varchar(50) DEFAULT NULL,
  `date_required` date DEFAULT NULL,
  `date_requested` date DEFAULT NULL,
  `reference_number` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL DEFAULT '',
  `participant_id` int(11) DEFAULT NULL,
  `diagnosis_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `participant_id` (`participant_id`),
  INDEX `diagnosis_id` (`diagnosis_master_id`),
  INDEX `event_control_id` (`event_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT event_masters (id, 
disease_site,event_group,event_type, 
event_status,event_summary,event_date, 
information_source,urgency,date_required,date_requested,reference_number, 
created,created_by,modified,modified_by,
participant_id,diagnosis_master_id)
(SELECT id, 
disease_site,event_group,event_type, 
event_status,event_summary,event_date, 
information_source,urgency,date_required,date_requested,reference_number, 
created,created_by,modified,modified_by,
participant_id,diagnosis_id FROM event_masters_old
WHERE `disease_site` LIKE 'all'
AND `event_group` LIKE 'lifestyle'
AND `event_type` LIKE 'procure');

ALTER TABLE event_controls
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER detail_tablename;
   
SET @lifestyle_ctrl_id = SELECT id FROM event_controls WHERE `disease_site` LIKE 'all' AND `event_group` LIKE 'lifestyle' ;AND `event_type` LIKE 'procure';  
DELETE FROM event_controls WHERE id NOT IN (@lifestyle_ctrl_id);

UPDATE event_masters SET event_control_id = @lifestyle_ctrl_id;

DROP TABLE event_masters_old;

CREATE TABLE IF NOT EXISTS `ed_all_procure_lifestyle_revs` (
  `id` int(11) NOT NULL,
  `procure_lifestyle_status` varchar(50) DEFAULT NULL,
  `completed` varchar(10) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` varchar(50) NOT NULL DEFAULT '',
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime DEFAULT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE family_histories
    CHANGE domain family_domain varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE icd10_id primary_icd10_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER family_domain,
    ADD previous_primary_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER primary_icd10_code,
    ADD previous_primary_code_system varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER previous_primary_code,
    ADD age_at_dx_accuracy varchar(100) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER age_at_dx,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY relation varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    DROP dx_date,
    DROP approximative_dx_date,
    DROP dx_date_status,
    DROP age_at_dx_status,
    ADD FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`) ON DELETE CASCADE;

ALTER TABLE family_histories_revs
    ADD `sardo_diagnosis_id` varchar(20) DEFAULT NULL AFTER age_at_dx_accuracy,
    ADD `last_sardo_import_date` date DEFAULT NULL AFTER sardo_diagnosis_id;  

RENAME TABLE reproductive_histories TO reproductive_histories_old;

CREATE TABLE IF NOT EXISTS `reproductive_histories` (
  `id` int(11) NOT NULL auto_increment,
  `date_captured` date default NULL,
  `menopause_status` varchar(50) default NULL,
  `menopause_onset_reason` varchar(50) default NULL,
  `age_at_menopause` int(11) default NULL,
  `menopause_age_accuracy` varchar(50) default NULL,
  `age_at_menarche` int(11) default NULL,
  `age_at_menarche_accuracy` varchar(50) default NULL,
  `hrt_years_used` int(11) default NULL,
  `hrt_use` varchar(50) default NULL,
  `hysterectomy_age` int(11) default NULL,
  `hysterectomy_age_accuracy` varchar(50) default NULL,
  `hysterectomy` varchar(50) default NULL,
  `ovary_removed_type` varchar(50) default NULL,
  `gravida` int(11) default NULL,
  `para` int(11) default NULL,
  `age_at_first_parturition` int(11) default NULL,
  `first_parturition_accuracy` varchar(50) default NULL,
  `age_at_last_parturition` int(11) default NULL,
  `last_parturition_accuracy` varchar(50) default NULL,
  `hormonal_contraceptive_use` varchar(50) default NULL,
  `years_on_hormonal_contraceptives` int(11) default NULL,
  `lnmp_date` date default NULL,
  `lnmp_accuracy` varchar(50) default NULL,
  `participant_id` int(11) default NULL,
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(50) NOT NULL default '',
  `modified` datetime default NULL,
  `modified_by` varchar(50) NOT NULL default '',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted_date` datetime default NULL,
  PRIMARY KEY  (`id`),
  INDEX `participant_id` (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO reproductive_histories (id, menopause_status, lnmp_date, lnmp_accuracy, participant_id, created, created_by, modified, modified_by)
(SELECT id, menopause_status, lnmp_date, lnmp_certainty, participant_id, created, created_by, modified, modified_by FROM reproductive_histories_old);

DROP TABLE reproductive_histories_old;

##########################################################################
# TOOLS # OTHER
##########################################################################

ALTER TABLE users
    CHANGE passwd password varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER last_name,
 	ALTER help_visible DROP DEFAULT;
 	
ALTER TABLE study_summaries
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER path_to_file,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '';   

DELETE FROM `sop_masters`;

ALTER TABLE sop_masters
    ADD sop_control_id int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER form_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP detail_tablename,
    DROP detail_form_alias,
    DROP extend_tablename,
    DROP extend_form_alias;

ALTER TABLE std_rooms
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY storage_master_id int(11) NULL DEFAULT NULL COMMENT '';    

ALTER TABLE storage_masters
    ADD lft int(10) NULL DEFAULT NULL COMMENT '' AFTER parent_id,
    ADD rght int(10) NULL DEFAULT NULL COMMENT '' AFTER lft,
    ADD coord_x_order int(3) NULL DEFAULT NULL COMMENT '' AFTER parent_storage_coord_x,
    ADD coord_y_order int(3) NULL DEFAULT NULL COMMENT '' AFTER parent_storage_coord_y,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY barcode varchar(60) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY selection_label varchar(60) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY parent_storage_coord_x varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY parent_storage_coord_y varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD UNIQUE unique_code (code),
    ADD INDEX barcode (barcode),
    ADD INDEX short_label (short_label),
    ADD INDEX selection_label (selection_label);

UPDATE storage_masters set coord_x_order =  parent_storage_coord_x;   
UPDATE storage_masters set coord_x_order = 1 where parent_storage_coord_x = 'A'; 
UPDATE storage_masters set coord_x_order = 2 where parent_storage_coord_x = 'B'; 
UPDATE storage_masters set coord_x_order = 3 where parent_storage_coord_x = 'C'; 
UPDATE storage_masters set coord_x_order = 4 where parent_storage_coord_x = 'D'; 
UPDATE storage_masters set coord_x_order = 5 where parent_storage_coord_x = 'E'; 
UPDATE storage_masters set coord_x_order = 6 where parent_storage_coord_x = 'F'; 
UPDATE storage_masters set coord_x_order = 7 where parent_storage_coord_x = 'G'; 
UPDATE storage_masters set coord_x_order = 8 where parent_storage_coord_x = 'H'; 
UPDATE storage_masters set coord_x_order = 9 where parent_storage_coord_x = 'I';    
    
UPDATE storage_masters set coord_y_order =  parent_storage_coord_y;   
UPDATE storage_masters set coord_y_order = 1 where parent_storage_coord_y = 'A'; 
UPDATE storage_masters set coord_y_order = 2 where parent_storage_coord_y = 'B'; 
UPDATE storage_masters set coord_y_order = 3 where parent_storage_coord_y = 'C'; 
UPDATE storage_masters set coord_y_order = 4 where parent_storage_coord_y = 'D'; 
UPDATE storage_masters set coord_y_order = 5 where parent_storage_coord_y = 'E'; 
UPDATE storage_masters set coord_y_order = 6 where parent_storage_coord_y = 'F'; 
UPDATE storage_masters set coord_y_order = 7 where parent_storage_coord_y = 'G'; 
UPDATE storage_masters set coord_y_order = 8 where parent_storage_coord_y = 'H'; 
UPDATE storage_masters set coord_y_order = 9 where parent_storage_coord_y = 'I';       
    
    
-- ici
    
ALTER TABLE storage_controls
    ADD display_x_size tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
    ADD display_y_size tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
    ADD reverse_x_numbering tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
    ADD reverse_y_numbering  tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
    MODIFY form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci;

UPDATE storage_controls SET detail_tablename = 'std_boxs' WHERE id IN(101, 102, 103);
UPDATE storage_controls SET detail_tablename = 'std_racks' WHERE id IN(100, 104);

SET FOREIGN_KEY_CHECKS=0;
DELETE FROM storage_controls WHERE id < 100;
INSERT INTO `storage_controls` (`id`, `storage_type`, `storage_type_code`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `set_temperature`, `is_tma_block`, `status`, `form_alias`, `form_alias_for_children_pos`, `detail_tablename`) VALUES
(1, 'room', 'R', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'TRUE', 'FALSE', 'active', 'std_rooms', NULL, 'std_rooms'),
(2, 'cupboard', 'CP', 'shelf', 'list', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_cupboards'),
(3, 'nitrogen locator', 'NL', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'TRUE', 'FALSE', 'active', 'std_undetail_stg_with_tmp', NULL, 'std_nitro_locates'),
(4, 'incubator', 'INC', 'shelf', 'list', NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'TRUE', 'FALSE', 'active', 'std_incubators', 'std_1_dim_position_selection', 'std_incubators'),
(5, 'fridge', 'FRI', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'TRUE', 'FALSE', 'active', 'std_undetail_stg_with_tmp', NULL, 'std_fridges'),
(6, 'freezer', 'FRE', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'TRUE', 'FALSE', 'active', 'std_undetail_stg_with_tmp', NULL, 'std_freezers'),
(8, 'box', 'B', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', NULL, 'std_boxs'),
(9, 'box81 1A-9I', 'B2D81', 'column', 'integer', 9, 'row', 'alphabetical', 9, 0, 0, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_2_dim_position_selection', 'std_boxs'),
(10, 'box81', 'B81', 'position', 'integer', 81, NULL, NULL, NULL, 9, 9, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_boxs'),
(11, 'rack16', 'R2D16', 'column', 'alphabetical', 4, 'row', 'integer', 4, 0, 0, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_2_dim_position_selection', 'std_racks'),
(12, 'rack10', 'R10', 'position', 'integer', 10, NULL, NULL, NULL, 0, 0, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_racks'),
(13, 'rack24', 'R24', 'position', 'integer', 24, NULL, NULL, NULL, 0, 0, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_racks'),
(14, 'shelf', 'SH', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', NULL, 'std_shelfs'),
(15, 'rack11', 'R11', 'position', 'integer', 11, NULL, NULL, NULL, 0, 0, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_racks'),
(16, 'rack9', 'R9', 'position', 'integer', 9, NULL, NULL, NULL, 0, 0, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_racks'),
(17, 'box25', 'B25', 'position', 'integer', 25, NULL, NULL, NULL, 5, 5, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_1_dim_position_selection', 'std_boxs'),
(18, 'box100 1A-20E', 'B2D100', 'column', 'integer', 20, 'row', 'alphabetical', 5, 0, 0, 0, 0, 'FALSE', 'FALSE', 'active', 'std_undetail_stg_with_surr_tmp', 'std_2_dim_position_selection', 'std_boxs'),
(19, 'TMA-blc 23X15', 'TMA345', 'column', 'integer', 23, 'row', 'integer', 15, 0, 0, 0, 0, 'FALSE', 'TRUE', 'active', 'std_tma_blocks', 'std_2_dim_position_selection', 'std_tma_blocks'),
(20, 'TMA-blc 29X21', 'TMA609', 'column', 'integer', 29, 'row', 'integer', 21, 0, 0, 0, 0, 'FALSE', 'TRUE', 'active', 'std_tma_blocks', 'std_2_dim_position_selection', 'std_tma_blocks');
SET FOREIGN_KEY_CHECKS=1;

-- ----- to delete -----------------------------------------------------------
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------


   



ALTER TABLE clinical_collection_links
    ADD FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`),
  	ADD FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`),
  	ADD FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`),
  	ADD FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`);

#TODO: This query fixes the unmatched foreign key. Investigate the cause
UPDATE order_items SET aliquot_use_id=NULL WHERE aliquot_use_id=0;
ALTER TABLE order_items
    ADD FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`),
  	ADD FOREIGN KEY (`aliquot_use_id`) REFERENCES `aliquot_uses` (`id`),
  	ADD FOREIGN KEY (`order_line_id`) REFERENCES `order_lines` (`id`),
  	ADD FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`);

  	
  	
  	
  	
-- Create INDEX for access control object (acos) table.
#TODO - validate that an index does not exists before creating it my brave
CREATE INDEX acos_idx1 ON acos (lft, rght);
CREATE INDEX acos_idx2 ON acos (alias);
CREATE INDEX acos_idx3 ON acos (model, foreign_key);

CREATE INDEX aros_idx1 ON aros (lft, rght);
CREATE INDEX aros_idx2 ON aros (alias);
CREATE INDEX aros_idx3 ON aros (model, foreign_key);


-- Clinical Annotation Foreign Keys --

ALTER TABLE `clinical_collection_links`
  ADD CONSTRAINT `FK_clinical_collection_links_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `clinical_collection_links`
  ADD CONSTRAINT `FK_clinical_collection_links_diagnosis_masters`
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `clinical_collection_links`
  ADD CONSTRAINT `FK_clinical_collection_links_consent_masters`
  FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `clinical_collection_links`
  ADD CONSTRAINT `FK_clinical_collection_links_collections`
  FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `participants` 
  ADD CONSTRAINT `FK_participants_icd10_code`
  FOREIGN KEY (cod_icd10_code) REFERENCES coding_icd10 (id)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
ALTER TABLE `participants` 
  ADD CONSTRAINT `FK_participants_icd10_code_2`
  FOREIGN KEY (secondary_cod_icd10_code) REFERENCES coding_icd10 (id)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `consent_masters`
  ADD CONSTRAINT `FK_consent_masters_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

-- ALTER TABLE `consent_masters`
--   ADD CONSTRAINT `FK_consent_masters_diagnosis_masters`
--   FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
--   ON DELETE RESTRICT
--   ON UPDATE RESTRICT;

ALTER TABLE `consent_masters`
  ADD CONSTRAINT `FK_consent_masters_consent_controls`
  FOREIGN KEY (`consent_control_id`) REFERENCES `consent_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `diagnosis_masters`
  ADD CONSTRAINT `FK_diagnosis_masters_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `diagnosis_masters`
  ADD CONSTRAINT `FK_diagnosis_masters_diagnosis_controls`
  FOREIGN KEY (`diagnosis_control_id`) REFERENCES `diagnosis_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

#TODO: Cannot add foreign key as some codes are missing in coding_icd10  
#ALTER TABLE `diagnosis_masters`
#  ADD CONSTRAINT `FK_diagnosis_masters_icd10_code`
#  FOREIGN KEY (primary_icd10_code) REFERENCES coding_icd10 (id)
#  ON DELETE RESTRICT
#  ON UPDATE RESTRICT;
  
ALTER TABLE `event_masters`
  ADD CONSTRAINT `FK_event_masters_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `event_masters`
  ADD CONSTRAINT `FK_event_masters_diagnosis_masters`
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `event_masters`
  ADD CONSTRAINT `FK_event_masters_event_controls`
  FOREIGN KEY (`event_control_id`) REFERENCES `event_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `family_histories`
  ADD CONSTRAINT `FK_family_histories_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `family_histories` 
  ADD CONSTRAINT `FK_family_histories_icd10_code`
  FOREIGN KEY (primary_icd10_code) REFERENCES coding_icd10 (id)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `misc_identifiers`
  ADD CONSTRAINT `FK_misc_identifiers_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `participant_contacts`
  ADD CONSTRAINT `FK_participant_contacts_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `participant_messages`
  ADD CONSTRAINT `FK_participant_messages_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `reproductive_histories`
  ADD CONSTRAINT `FK_reproductive_histories_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `tx_masters`
  ADD CONSTRAINT `FK_tx_masters_participant`
  FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `tx_masters`
  ADD CONSTRAINT `FK_tx_masters_diagnosis_masters`
  FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `tx_masters`
  ADD CONSTRAINT `FK_tx_masters_tx_controls`
  FOREIGN KEY (`treatment_control_id`) REFERENCES `tx_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
ALTER TABLE `ed_allsolid_lab_pathology`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_adverse_events_adverse_event`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_clinical_followup`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_clinical_presentation`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_lifestyle_base`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_protocol_followup`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_study_research`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_breast_lab_pathology`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_breast_screening_mammogram`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
ALTER TABLE `cd_nationals`
  ADD FOREIGN KEY (`consent_master_id`) REFERENCES `consent_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;  

-- Inventory Management Foreign Keys --

ALTER TABLE `collections`
  ADD CONSTRAINT `FK_collections_banks`
  FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
ALTER TABLE `collections`
  ADD CONSTRAINT `FK_collections_sops`
  FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `sample_masters`
  ADD CONSTRAINT `FK_sample_masters_collections`
  FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `sample_masters`
  ADD CONSTRAINT `FK_sample_masters_sample_controls`
  FOREIGN KEY (`sample_control_id`) REFERENCES `sample_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;  

ALTER TABLE `sample_masters`
  ADD CONSTRAINT `FK_sample_masters_sample_specimens`
  FOREIGN KEY (`initial_specimen_sample_id`) REFERENCES `sample_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `sample_masters`
  ADD CONSTRAINT `FK_sample_masters_parent`
  FOREIGN KEY (`parent_id`) REFERENCES `sample_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `sample_masters`
  ADD CONSTRAINT `FK_sample_masters_sops`
  FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;  

ALTER TABLE `specimen_details`
  ADD CONSTRAINT `FK_specimen_details_sample_masters`
  FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `derivative_details`
  ADD CONSTRAINT `FK_detivative_details_sample_masters`
  FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `sd_der_amp_rnas` ADD CONSTRAINT `FK_sd_der_amp_rnas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_ascite_cells` ADD CONSTRAINT `FK_sd_der_ascite_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_ascite_sups` ADD CONSTRAINT `FK_sd_der_ascite_sups_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_blood_cells` ADD CONSTRAINT `FK_sd_der_blood_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_b_cells` ADD CONSTRAINT `FK_sd_der_b_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `sd_der_cell_cultures` ADD CONSTRAINT `FK_sd_der_cell_cultures_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_dnas` ADD CONSTRAINT `FK_sd_der_dnas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_cystic_fl_cells` ADD CONSTRAINT `FK_sd_der_cystic_fl_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_spe_pericardial_fluids` ADD CONSTRAINT `FK_sd_spe_pericardial_fluids_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_pericardial_fl_cells` ADD CONSTRAINT `FK_sd_der_pericardial_fl_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_pericardial_fl_sups` ADD CONSTRAINT `FK_sd_der_pericardial_fl_sups_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_spe_pleural_fluids` ADD CONSTRAINT `FK_sd_spe_pleural_fluids_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_pleural_fl_cells` ADD CONSTRAINT `FK_sd_der_pleural_fl_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_pleural_fl_sups` ADD CONSTRAINT `FK_sd_der_pleural_fl_sups_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_cystic_fl_sups` ADD CONSTRAINT `FK_sd_der_cystic_fl_sups_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_pbmcs` ADD CONSTRAINT `FK_sd_der_pbmcs_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_plasmas` ADD CONSTRAINT `FK_sd_der_plasmas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_pw_cells` ADD CONSTRAINT `FK_sd_der_pw_cells_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_pw_sups` ADD CONSTRAINT `FK_sd_der_pw_sups_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_rnas` ADD CONSTRAINT `FK_sd_der_rnas_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_serums` ADD CONSTRAINT `FK_sd_der_serums_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_tiss_lysates` ADD CONSTRAINT `FK_sd_der_tiss_lysates_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_tiss_susps` ADD CONSTRAINT `FK_sd_der_tiss_susps_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_urine_cents` ADD CONSTRAINT `FK_sd_der_urine_cents_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_der_urine_cons` ADD CONSTRAINT `FK_sd_der_urine_cons_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_spe_ascites` ADD CONSTRAINT `FK_sd_spe_ascites_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_spe_bloods` ADD CONSTRAINT `FK_sd_spe_bloods_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_spe_cystic_fluids` ADD CONSTRAINT `FK_sd_spe_cystic_fluids_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_spe_peritoneal_washes` ADD CONSTRAINT `FK_sd_spe_peritoneal_washes_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_spe_tissues` ADD CONSTRAINT `FK_sd_spe_tissues_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `sd_spe_urines` ADD CONSTRAINT `FK_sd_spe_urines_sample_masters` FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 

ALTER TABLE `aliquot_masters`
  ADD CONSTRAINT `FK_aliquot_masters_aliquot_controls`
  FOREIGN KEY (`aliquot_control_id`) REFERENCES `aliquot_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `aliquot_masters`
  ADD CONSTRAINT `FK_aliquot_masters_collections`
  FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `aliquot_masters`
  ADD CONSTRAINT `FK_aliquot_masters_sample_masters`
  FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `aliquot_masters`
  ADD CONSTRAINT `FK_aliquot_masters_sops`
  FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `aliquot_masters`
  ADD CONSTRAINT `FK_aliquot_masters_study_summaries`
  FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `aliquot_masters`
  ADD CONSTRAINT `FK_aliquot_masters_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `ad_bags` ADD CONSTRAINT `FK_ad_bags_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `ad_blocks` ADD CONSTRAINT `FK_ad_blocks_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `ad_cell_cores` ADD CONSTRAINT `FK_ad_cell_cores_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `ad_cell_slides` ADD CONSTRAINT `FK_ad_cell_slides_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `ad_gel_matrices` ADD CONSTRAINT `FK_ad_gel_matrices_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `ad_tissue_cores` ADD CONSTRAINT `FK_ad_tissue_cores_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `ad_tissue_slides` ADD CONSTRAINT `FK_ad_tissue_slides_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `ad_tubes` ADD CONSTRAINT `FK_ad_tubes_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `ad_whatman_papers` ADD CONSTRAINT `FK_ad_whatman_papers_aliquot_masters` FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 

ALTER TABLE `ad_cell_cores` ADD CONSTRAINT `FK_ad_cell_cores_gel_matrices` FOREIGN KEY (`gel_matrix_aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 

ALTER TABLE `ad_tissue_cores` ADD CONSTRAINT `FK_ad_tissue_cores_blocks` FOREIGN KEY (`block_aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 
ALTER TABLE `ad_tissue_slides` ADD CONSTRAINT `FK_ad_tissue_slides_aliquot_ad_cell_coress` FOREIGN KEY (`block_aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT; 

ALTER TABLE `aliquot_uses`
  ADD CONSTRAINT `FK_aliquot_uses_study_summaries`
  FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `aliquot_uses` 
  ADD CONSTRAINT `FK_aliquot_uses_aliquot_masters` 
  FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT; 
  
ALTER TABLE `source_aliquots` 
  ADD CONSTRAINT `FK_source_aliquots_aliquot_masters` 
  FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT; 
  
ALTER TABLE `source_aliquots` 
  ADD CONSTRAINT `FK_source_aliquots_aliquot_uses` 
  FOREIGN KEY (`aliquot_use_id`) REFERENCES `aliquot_uses` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT;   
  
ALTER TABLE `source_aliquots` 
  ADD CONSTRAINT `FK_source_aliquots_sample_masters` 
  FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT;   
  
ALTER TABLE `realiquotings` 
  ADD CONSTRAINT `FK_realiquotings_parent_aliquot_masters` 
  FOREIGN KEY (`parent_aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT; 

ALTER TABLE `realiquotings` 
  ADD CONSTRAINT `FK_realiquotings_child_aliquot_masters` 
  FOREIGN KEY (`child_aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT; 
  
ALTER TABLE `realiquotings` 
  ADD CONSTRAINT `FK_realiquotings_aliquot_uses` 
  FOREIGN KEY (`aliquot_use_id`) REFERENCES `aliquot_uses` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT;   
    
ALTER TABLE `quality_ctrls` 
  ADD CONSTRAINT `FK_quality_ctrls_sample_masters` 
  FOREIGN KEY (`sample_master_id`) REFERENCES `sample_masters` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT;  

ALTER TABLE `quality_ctrl_tested_aliquots` 
  ADD CONSTRAINT `FK_quality_ctrl_tested_aliquots_aliquot_masters` 
  FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT; 
  
ALTER TABLE `quality_ctrl_tested_aliquots` 
  ADD CONSTRAINT `FK_quality_ctrl_tested_aliquots_aliquot_uses` 
  FOREIGN KEY (`aliquot_use_id`) REFERENCES `aliquot_uses` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT;  

ALTER TABLE `quality_ctrl_tested_aliquots` 
  ADD CONSTRAINT `FK_quality_ctrl_tested_aliquots_quality_ctrls` 
  FOREIGN KEY (`quality_ctrl_id`) REFERENCES `quality_ctrls` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT;  

ALTER TABLE `sample_to_aliquot_controls` 
  ADD CONSTRAINT `FK_sample_to_aliquot_controls_sample_controls` 
  FOREIGN KEY (`sample_control_id`) REFERENCES `sample_controls` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT;  
  
ALTER TABLE `sample_to_aliquot_controls` 
  ADD CONSTRAINT `FK_sample_to_aliquot_controls_aliquot_controls` 
  FOREIGN KEY (`aliquot_control_id`) REFERENCES `aliquot_controls` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT; 

ALTER TABLE `parent_to_derivative_sample_controls` 
  ADD CONSTRAINT `FK_parent_to_derivative_sample_controls_parent` 
  FOREIGN KEY (`parent_sample_control_id`) REFERENCES `sample_controls` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT;  
  
ALTER TABLE `parent_to_derivative_sample_controls` 
  ADD CONSTRAINT `FK_parent_to_derivative_sample_controls_derivative` 
  FOREIGN KEY (`derivative_sample_control_id`) REFERENCES `sample_controls` (`id`) 
  ON DELETE RESTRICT 
  ON UPDATE RESTRICT;  
  
-- StorageLayout Foreign Keys --

ALTER TABLE `std_cupboards`
  ADD CONSTRAINT `FK_std_cupboards_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `std_nitro_locates`
  ADD CONSTRAINT `FK_std_nitro_locates_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `std_fridges`
  ADD CONSTRAINT `FK_std_fridges_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `std_freezers`
  ADD CONSTRAINT `FK_std_freezers_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `std_boxs`
  ADD CONSTRAINT `FK_std_boxs_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `std_racks`
  ADD CONSTRAINT `FK_std_racks_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `std_shelfs`
  ADD CONSTRAINT `FK_std_shelfs_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `std_incubators`
  ADD CONSTRAINT `FK_std_incubators_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `std_rooms`
  ADD CONSTRAINT `FK_std_rooms_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `storage_coordinates`
  ADD CONSTRAINT `FK_storage_coordinates_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `std_tma_blocks`
  ADD CONSTRAINT `FK_std_tma_blocks_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `std_tma_blocks`
  ADD CONSTRAINT `FK_std_tma_blocks_sop_masters`
  FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 

ALTER TABLE `tma_slides`
  ADD CONSTRAINT `FK_tma_slides_storage_masters`
  FOREIGN KEY (`storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `tma_slides`
  ADD CONSTRAINT `FK_tma_slides_sop_masters`
  FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `tma_slides`
  ADD CONSTRAINT `FK_tma_slides_tma_blocks`
  FOREIGN KEY (`tma_block_storage_master_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
  
ALTER TABLE `storage_masters`
  ADD CONSTRAINT `FK_storage_masters_storage_controls`
  FOREIGN KEY (`storage_control_id`) REFERENCES `storage_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
ALTER TABLE `storage_masters`
  ADD CONSTRAINT `FK_storage_masters_parent`
  FOREIGN KEY (`parent_id`) REFERENCES `storage_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 


-- Order Management Foreign Keys --

ALTER TABLE `orders`
  ADD CONSTRAINT `FK_orders_study_summaries`
  FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `order_lines`
  ADD CONSTRAINT `FK_order_lines_orders`
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
 ALTER TABLE `order_lines`
  ADD CONSTRAINT `FK_order_lines_sample_controls`
  FOREIGN KEY (`sample_control_id`) REFERENCES `sample_controls` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT; 
  
ALTER TABLE `order_items`
  ADD CONSTRAINT `FK_order_items_order_lines`
  FOREIGN KEY (`order_line_id`) REFERENCES `order_lines` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `order_items`
  ADD CONSTRAINT `FK_order_items_shipments`
  FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `order_items`
  ADD CONSTRAINT `FK_order_items_aliquot_masters`
  FOREIGN KEY (`aliquot_master_id`) REFERENCES `aliquot_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `order_items`
  ADD CONSTRAINT `FK_order_items_aliquot_uses`
  FOREIGN KEY (`aliquot_use_id`) REFERENCES `aliquot_uses` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `shipments`
  ADD CONSTRAINT `FK_shipments_orders`
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  

-- Studies Foreign Keys --

ALTER TABLE `study_contacts`
  ADD CONSTRAINT `FK_study_contacts_study_summaries`
  FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `study_ethics_boards`
  ADD CONSTRAINT `FK_study_ethics_boards_study_summaries`
  FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `study_fundings`
  ADD CONSTRAINT `FK_study_fundings_study_summaries`
  FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `study_investigators`
  ADD CONSTRAINT `FK_study_investigators_study_summaries`
  FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `study_related`
  ADD CONSTRAINT `FK_study_related_study_summaries`
  FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `study_results`
  ADD CONSTRAINT `FK_study_results_study_summaries`
  FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `study_reviews`
  ADD CONSTRAINT `FK_study_reviews_study_summaries`
  FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

#TODO: Once done run the db_validation script
#TODO: run left right script on storage_masters