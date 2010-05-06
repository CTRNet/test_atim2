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
    
# COLLECTION -------------------------------------------------------------  

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

ALTER TABLE event_masters DROP FOREIGN KEY event_masters_ibfk_2;
DROP TABLE diagnoses;

UPDATE diagnosis_masters SET dx_date_accuracy='' WHERE dx_date_accuracy='no' AND dx_date IS NULL;
UPDATE diagnosis_masters SET dx_date_accuracy='c' WHERE dx_date_accuracy='no';
UPDATE diagnosis_masters SET dx_date_accuracy='' WHERE dx_date_accuracy!='c';

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
   
SET @lifestyle_ctrl_id = (SELECT id FROM event_controls WHERE `disease_site` LIKE 'all' AND `event_group` LIKE 'lifestyle' AND `event_type` LIKE 'procure');  
DELETE FROM event_controls WHERE id NOT IN (@lifestyle_ctrl_id);

UPDATE event_masters SET event_control_id = @lifestyle_ctrl_id;


ALTER TABLE `ed_all_procure_lifestyle` DROP FOREIGN KEY ed_all_procure_lifestyle_ibfk_1; 
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
    
ALTER TABLE storage_controls
    ADD display_x_size tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
    ADD display_y_size tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
    ADD reverse_x_numbering tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
    ADD reverse_y_numbering  tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
    MODIFY form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci;

UPDATE storage_controls SET is_tma_block = 'FALSE' WHERE is_tma_block != 'TRUE' OR is_tma_block IS NULL;
UPDATE storage_controls SET set_temperature = 'FALSE' WHERE  storage_type LIKE 'rack20';
   
UPDATE storage_controls SET display_x_size = '9', display_y_size = '9' WHERE storage_type = 'box81';
UPDATE storage_controls SET display_x_size = '4', display_y_size = '6' WHERE storage_type = 'rack24';
UPDATE storage_controls SET display_x_size = '5', display_y_size = '5' WHERE storage_type = 'box25';	
UPDATE storage_controls SET display_x_size = '10', display_y_size = '10' WHERE storage_type = 'box100';	
UPDATE storage_controls SET display_x_size = '7', display_y_size = '7' WHERE storage_type = 'box49';	
UPDATE storage_controls SET display_x_size = '4', display_y_size = '5' WHERE storage_type = 'rack20';	

UPDATE storage_controls SET detail_tablename = 'std_boxs' WHERE storage_type LIKE 'box%';
INSERT std_boxs (id, storage_master_id, created, created_by, modified, modified_by)
(SELECT id, id, created, created_by, modified, modified_by FROM storage_masters WHERE storage_control_id IN (SELECT id FROM storage_controls WHERE storage_type LIKE 'box%'));

UPDATE storage_controls SET detail_tablename = 'std_racks' WHERE storage_type LIKE 'rack%';
INSERT std_racks (id, storage_master_id, created, created_by, modified, modified_by)
(SELECT id, id, created, created_by, modified, modified_by FROM storage_masters WHERE storage_control_id IN 
(SELECT id FROM storage_controls WHERE storage_type LIKE 'rack%'));

UPDATE storage_controls SET detail_tablename = 'std_cupboards' WHERE storage_type LIKE 'cupboard';
INSERT std_cupboards (id, storage_master_id, created, created_by, modified, modified_by)
(SELECT id, id, created, created_by, modified, modified_by FROM storage_masters WHERE storage_control_id IN 
(SELECT id FROM storage_controls WHERE storage_type LIKE 'cupboard'));

UPDATE storage_controls SET detail_tablename = 'std_freezers' WHERE storage_type LIKE 'freezer';
INSERT std_freezers (id, storage_master_id, created, created_by, modified, modified_by)
(SELECT id, id, created, created_by, modified, modified_by FROM storage_masters WHERE storage_control_id IN 
(SELECT id FROM storage_controls WHERE storage_type LIKE 'freezer'));

UPDATE storage_controls SET detail_tablename = 'std_fridges' WHERE storage_type LIKE 'fridge';
INSERT std_fridges (id, storage_master_id, created, created_by, modified, modified_by)
(SELECT id, id, created, created_by, modified, modified_by FROM storage_masters WHERE storage_control_id IN 
(SELECT id FROM storage_controls WHERE storage_type LIKE 'fridge'));

UPDATE storage_controls SET detail_tablename = 'std_nitro_locates' WHERE storage_type LIKE 'nitrogen locator';
INSERT std_nitro_locates (id, storage_master_id, created, created_by, modified, modified_by)
(SELECT id, id, created, created_by, modified, modified_by FROM storage_masters WHERE storage_control_id IN 
(SELECT id FROM storage_controls WHERE storage_type LIKE 'nitrogen locator'));

UPDATE storage_controls SET detail_tablename = 'std_shelfs' WHERE storage_type LIKE 'shelf';
INSERT std_shelfs (id, storage_master_id, created, created_by, modified, modified_by)
(SELECT id, id, created, created_by, modified, modified_by FROM storage_masters WHERE storage_control_id IN 
(SELECT id FROM storage_controls WHERE storage_type LIKE 'shelf'));
  
##########################################################################
# SYSTEM
##########################################################################

DELETE FROM `acos`;
INSERT INTO `acos` (`id`, `parent_id`, `model`, `foreign_key`, `alias`, `lft`, `rght`) VALUES
(1, NULL, NULL, NULL, 'controllers', 1, 930),
(2, 1, NULL, NULL, 'Administrate', 2, 111),
(3, 2, NULL, NULL, 'Announcements', 3, 14),
(4, 3, NULL, NULL, 'add', 4, 5),
(5, 3, NULL, NULL, 'index', 6, 7),
(6, 3, NULL, NULL, 'detail', 8, 9),
(7, 3, NULL, NULL, 'edit', 10, 11),
(8, 3, NULL, NULL, 'delete', 12, 13),
(9, 2, NULL, NULL, 'Banks', 15, 26),
(10, 9, NULL, NULL, 'add', 16, 17),
(11, 9, NULL, NULL, 'index', 18, 19),
(12, 9, NULL, NULL, 'detail', 20, 21),
(13, 9, NULL, NULL, 'edit', 22, 23),
(14, 9, NULL, NULL, 'delete', 24, 25),
(15, 2, NULL, NULL, 'Groups', 27, 38),
(16, 15, NULL, NULL, 'index', 28, 29),
(17, 15, NULL, NULL, 'detail', 30, 31),
(18, 15, NULL, NULL, 'add', 32, 33),
(19, 15, NULL, NULL, 'edit', 34, 35),
(20, 15, NULL, NULL, 'delete', 36, 37),
(21, 2, NULL, NULL, 'Menus', 39, 48),
(22, 21, NULL, NULL, 'index', 40, 41),
(23, 21, NULL, NULL, 'detail', 42, 43),
(24, 21, NULL, NULL, 'edit', 44, 45),
(25, 21, NULL, NULL, 'add', 46, 47),
(26, 2, NULL, NULL, 'Passwords', 49, 52),
(27, 26, NULL, NULL, 'index', 50, 51),
(28, 2, NULL, NULL, 'Permissions', 53, 66),
(29, 28, NULL, NULL, 'index', 54, 55),
(30, 28, NULL, NULL, 'regenerate', 56, 57),
(31, 28, NULL, NULL, 'update', 58, 59),
(32, 28, NULL, NULL, 'updatePermission', 60, 61),
(33, 28, NULL, NULL, 'tree', 62, 63),
(34, 28, NULL, NULL, 'addPermissionStateToThreadedData', 64, 65),
(35, 2, NULL, NULL, 'Preferences', 67, 72),
(36, 35, NULL, NULL, 'index', 68, 69),
(37, 35, NULL, NULL, 'edit', 70, 71),
(38, 2, NULL, NULL, 'StructureFormats', 73, 82),
(39, 38, NULL, NULL, 'listall', 74, 75),
(40, 38, NULL, NULL, 'detail', 76, 77),
(41, 38, NULL, NULL, 'edit', 78, 79),
(42, 38, NULL, NULL, 'add', 80, 81),
(43, 2, NULL, NULL, 'Structures', 83, 92),
(44, 43, NULL, NULL, 'index', 84, 85),
(45, 43, NULL, NULL, 'detail', 86, 87),
(46, 43, NULL, NULL, 'edit', 88, 89),
(47, 43, NULL, NULL, 'add', 90, 91),
(48, 2, NULL, NULL, 'UserLogs', 93, 96),
(49, 48, NULL, NULL, 'index', 94, 95),
(50, 2, NULL, NULL, 'Users', 97, 106),
(51, 50, NULL, NULL, 'listall', 98, 99),
(52, 50, NULL, NULL, 'detail', 100, 101),
(53, 50, NULL, NULL, 'add', 102, 103),
(54, 50, NULL, NULL, 'edit', 104, 105),
(55, 2, NULL, NULL, 'Versions', 107, 110),
(56, 55, NULL, NULL, 'detail', 108, 109),
(57, 1, NULL, NULL, 'App', 112, 153),
(58, 57, NULL, NULL, 'Groups', 113, 124),
(59, 58, NULL, NULL, 'index', 114, 115),
(60, 58, NULL, NULL, 'view', 116, 117),
(61, 58, NULL, NULL, 'add', 118, 119),
(62, 58, NULL, NULL, 'edit', 120, 121),
(63, 58, NULL, NULL, 'delete', 122, 123),
(64, 57, NULL, NULL, 'Menus', 125, 130),
(65, 64, NULL, NULL, 'index', 126, 127),
(66, 64, NULL, NULL, 'update', 128, 129),
(67, 57, NULL, NULL, 'Pages', 131, 134),
(68, 67, NULL, NULL, 'display', 132, 133),
(69, 57, NULL, NULL, 'Posts', 135, 146),
(70, 69, NULL, NULL, 'index', 136, 137),
(71, 69, NULL, NULL, 'view', 138, 139),
(72, 69, NULL, NULL, 'add', 140, 141),
(73, 69, NULL, NULL, 'edit', 142, 143),
(74, 69, NULL, NULL, 'delete', 144, 145),
(75, 57, NULL, NULL, 'Users', 147, 152),
(76, 75, NULL, NULL, 'login', 148, 149),
(77, 75, NULL, NULL, 'logout', 150, 151),
(78, 1, NULL, NULL, 'Clinicalannotation', 154, 333),
(79, 78, NULL, NULL, 'ClinicalCollectionLinks', 155, 168),
(80, 79, NULL, NULL, 'listall', 156, 157),
(81, 79, NULL, NULL, 'detail', 158, 159),
(82, 79, NULL, NULL, 'add', 160, 161),
(83, 79, NULL, NULL, 'edit', 162, 163),
(84, 79, NULL, NULL, 'delete', 164, 165),
(85, 79, NULL, NULL, 'allowClinicalCollectionLinkDeletion', 166, 167),
(86, 78, NULL, NULL, 'ConsentMasters', 169, 182),
(87, 86, NULL, NULL, 'listall', 170, 171),
(88, 86, NULL, NULL, 'detail', 172, 173),
(89, 86, NULL, NULL, 'add', 174, 175),
(90, 86, NULL, NULL, 'edit', 176, 177),
(91, 86, NULL, NULL, 'delete', 178, 179),
(92, 86, NULL, NULL, 'allowConsentDeletion', 180, 181),
(93, 78, NULL, NULL, 'DiagnosisMasters', 183, 198),
(94, 93, NULL, NULL, 'listall', 184, 185),
(95, 93, NULL, NULL, 'detail', 186, 187),
(96, 93, NULL, NULL, 'add', 188, 189),
(97, 93, NULL, NULL, 'edit', 190, 191),
(98, 93, NULL, NULL, 'delete', 192, 193),
(99, 93, NULL, NULL, 'allowDiagnosisDeletion', 194, 195),
(100, 93, NULL, NULL, 'buildAndSetExistingDx', 196, 197),
(101, 78, NULL, NULL, 'EventMasters', 199, 212),
(102, 101, NULL, NULL, 'listall', 200, 201),
(103, 101, NULL, NULL, 'detail', 202, 203),
(104, 101, NULL, NULL, 'add', 204, 205),
(105, 101, NULL, NULL, 'edit', 206, 207),
(106, 101, NULL, NULL, 'delete', 208, 209),
(107, 101, NULL, NULL, 'allowEventDeletion', 210, 211),
(108, 78, NULL, NULL, 'FamilyHistories', 213, 226),
(109, 108, NULL, NULL, 'listall', 214, 215),
(110, 108, NULL, NULL, 'detail', 216, 217),
(111, 108, NULL, NULL, 'add', 218, 219),
(112, 108, NULL, NULL, 'edit', 220, 221),
(113, 108, NULL, NULL, 'delete', 222, 223),
(114, 108, NULL, NULL, 'allowFamilyHistoryDeletion', 224, 225),
(115, 78, NULL, NULL, 'MiscIdentifiers', 227, 244),
(116, 115, NULL, NULL, 'index', 228, 229),
(117, 115, NULL, NULL, 'search', 230, 231),
(118, 115, NULL, NULL, 'listall', 232, 233),
(119, 115, NULL, NULL, 'detail', 234, 235),
(120, 115, NULL, NULL, 'add', 236, 237),
(121, 115, NULL, NULL, 'edit', 238, 239),
(122, 115, NULL, NULL, 'delete', 240, 241),
(123, 115, NULL, NULL, 'allowMiscIdentifierDeletion', 242, 243),
(124, 78, NULL, NULL, 'ParticipantContacts', 245, 258),
(125, 124, NULL, NULL, 'listall', 246, 247),
(126, 124, NULL, NULL, 'detail', 248, 249),
(127, 124, NULL, NULL, 'add', 250, 251),
(128, 124, NULL, NULL, 'edit', 252, 253),
(129, 124, NULL, NULL, 'delete', 254, 255),
(130, 124, NULL, NULL, 'allowParticipantContactDeletion', 256, 257),
(131, 78, NULL, NULL, 'ParticipantMessages', 259, 272),
(132, 131, NULL, NULL, 'listall', 260, 261),
(133, 131, NULL, NULL, 'detail', 262, 263),
(134, 131, NULL, NULL, 'add', 264, 265),
(135, 131, NULL, NULL, 'edit', 266, 267),
(136, 131, NULL, NULL, 'delete', 268, 269),
(137, 131, NULL, NULL, 'allowParticipantMessageDeletion', 270, 271),
(138, 78, NULL, NULL, 'Participants', 273, 290),
(139, 138, NULL, NULL, 'index', 274, 275),
(140, 138, NULL, NULL, 'search', 276, 277),
(141, 138, NULL, NULL, 'profile', 278, 279),
(142, 138, NULL, NULL, 'add', 280, 281),
(143, 138, NULL, NULL, 'edit', 282, 283),
(144, 138, NULL, NULL, 'delete', 284, 285),
(145, 138, NULL, NULL, 'allowParticipantDeletion', 286, 287),
(146, 138, NULL, NULL, 'chronology', 288, 289),
(147, 78, NULL, NULL, 'ProductMasters', 291, 294),
(148, 147, NULL, NULL, 'productsTreeView', 292, 293),
(149, 78, NULL, NULL, 'ReproductiveHistories', 295, 308),
(150, 149, NULL, NULL, 'listall', 296, 297),
(151, 149, NULL, NULL, 'detail', 298, 299),
(152, 149, NULL, NULL, 'add', 300, 301),
(153, 149, NULL, NULL, 'edit', 302, 303),
(154, 149, NULL, NULL, 'delete', 304, 305),
(155, 149, NULL, NULL, 'allowReproductiveHistoryDeletion', 306, 307),
(156, 78, NULL, NULL, 'TreatmentExtends', 309, 320),
(157, 156, NULL, NULL, 'listall', 310, 311),
(158, 156, NULL, NULL, 'detail', 312, 313),
(159, 156, NULL, NULL, 'add', 314, 315),
(160, 156, NULL, NULL, 'edit', 316, 317),
(161, 156, NULL, NULL, 'delete', 318, 319),
(162, 78, NULL, NULL, 'TreatmentMasters', 321, 332),
(163, 162, NULL, NULL, 'listall', 322, 323),
(164, 162, NULL, NULL, 'detail', 324, 325),
(165, 162, NULL, NULL, 'edit', 326, 327),
(166, 162, NULL, NULL, 'add', 328, 329),
(167, 162, NULL, NULL, 'delete', 330, 331),
(168, 1, NULL, NULL, 'Codingicd10', 334, 341),
(169, 168, NULL, NULL, 'CodingIcd10s', 335, 340),
(170, 169, NULL, NULL, 'tool', 336, 337),
(171, 169, NULL, NULL, 'autoComplete', 338, 339),
(172, 1, NULL, NULL, 'Customize', 342, 365),
(173, 172, NULL, NULL, 'Announcements', 343, 348),
(174, 173, NULL, NULL, 'index', 344, 345),
(175, 173, NULL, NULL, 'detail', 346, 347),
(176, 172, NULL, NULL, 'Passwords', 349, 352),
(177, 176, NULL, NULL, 'index', 350, 351),
(178, 172, NULL, NULL, 'Preferences', 353, 358),
(179, 178, NULL, NULL, 'index', 354, 355),
(180, 178, NULL, NULL, 'edit', 356, 357),
(181, 172, NULL, NULL, 'Profiles', 359, 364),
(182, 181, NULL, NULL, 'index', 360, 361),
(183, 181, NULL, NULL, 'edit', 362, 363),
(184, 1, NULL, NULL, 'Datamart', 366, 415),
(185, 184, NULL, NULL, 'AdhocSaved', 367, 380),
(186, 185, NULL, NULL, 'index', 368, 369),
(187, 185, NULL, NULL, 'add', 370, 371),
(188, 185, NULL, NULL, 'search', 372, 373),
(189, 185, NULL, NULL, 'results', 374, 375),
(190, 185, NULL, NULL, 'edit', 376, 377),
(191, 185, NULL, NULL, 'delete', 378, 379),
(192, 184, NULL, NULL, 'Adhocs', 381, 396),
(193, 192, NULL, NULL, 'index', 382, 383),
(194, 192, NULL, NULL, 'favourite', 384, 385),
(195, 192, NULL, NULL, 'unfavourite', 386, 387),
(196, 192, NULL, NULL, 'search', 388, 389),
(197, 192, NULL, NULL, 'results', 390, 391),
(198, 192, NULL, NULL, 'process', 392, 393),
(199, 192, NULL, NULL, 'csv', 394, 395),
(200, 184, NULL, NULL, 'BatchSets', 397, 414),
(201, 200, NULL, NULL, 'index', 398, 399),
(202, 200, NULL, NULL, 'listall', 400, 401),
(203, 200, NULL, NULL, 'add', 402, 403),
(204, 200, NULL, NULL, 'edit', 404, 405),
(205, 200, NULL, NULL, 'delete', 406, 407),
(206, 200, NULL, NULL, 'process', 408, 409),
(207, 200, NULL, NULL, 'remove', 410, 411),
(208, 200, NULL, NULL, 'csv', 412, 413),
(209, 1, NULL, NULL, 'Drug', 416, 433),
(210, 209, NULL, NULL, 'Drugs', 417, 432),
(211, 210, NULL, NULL, 'index', 418, 419),
(212, 210, NULL, NULL, 'search', 420, 421),
(213, 210, NULL, NULL, 'listall', 422, 423),
(214, 210, NULL, NULL, 'add', 424, 425),
(215, 210, NULL, NULL, 'edit', 426, 427),
(216, 210, NULL, NULL, 'detail', 428, 429),
(217, 210, NULL, NULL, 'delete', 430, 431),
(218, 1, NULL, NULL, 'Inventorymanagement', 434, 559),
(219, 218, NULL, NULL, 'AliquotMasters', 435, 490),
(220, 219, NULL, NULL, 'index', 436, 437),
(221, 219, NULL, NULL, 'search', 438, 439),
(222, 219, NULL, NULL, 'listAll', 440, 441),
(223, 219, NULL, NULL, 'add', 442, 443),
(224, 219, NULL, NULL, 'detail', 444, 445),
(225, 219, NULL, NULL, 'edit', 446, 447),
(226, 219, NULL, NULL, 'removeAliquotFromStorage', 448, 449),
(227, 219, NULL, NULL, 'delete', 450, 451),
(228, 219, NULL, NULL, 'addAliquotUse', 452, 453),
(229, 219, NULL, NULL, 'editAliquotUse', 454, 455),
(230, 219, NULL, NULL, 'deleteAliquotUse', 456, 457),
(231, 219, NULL, NULL, 'addSourceAliquots', 458, 459),
(232, 219, NULL, NULL, 'listAllSourceAliquots', 460, 461),
(233, 219, NULL, NULL, 'defineRealiquotedChildren', 462, 463),
(234, 219, NULL, NULL, 'listAllRealiquotedParents', 464, 465),
(235, 219, NULL, NULL, 'getStudiesList', 466, 467),
(236, 219, NULL, NULL, 'getSampleBlocksList', 468, 469),
(237, 219, NULL, NULL, 'getSampleGelMatricesList', 470, 471),
(238, 219, NULL, NULL, 'getDefaultAliquotStorageDate', 472, 473),
(239, 219, NULL, NULL, 'isDuplicatedAliquotBarcode', 474, 475),
(240, 219, NULL, NULL, 'formatAliquotFieldDecimalData', 476, 477),
(241, 219, NULL, NULL, 'validateAliquotStorageData', 478, 479),
(242, 219, NULL, NULL, 'allowAliquotDeletion', 480, 481),
(243, 219, NULL, NULL, 'getDefaultRealiquotingDate', 482, 483),
(244, 219, NULL, NULL, 'formatPreselectedStoragesForDisplay', 484, 485),
(245, 219, NULL, NULL, 'formatBlocksForDisplay', 486, 487),
(246, 219, NULL, NULL, 'formatGelMatricesForDisplay', 488, 489),
(247, 218, NULL, NULL, 'Collections', 491, 506),
(248, 247, NULL, NULL, 'index', 492, 493),
(249, 247, NULL, NULL, 'search', 494, 495),
(250, 247, NULL, NULL, 'detail', 496, 497),
(251, 247, NULL, NULL, 'add', 498, 499),
(252, 247, NULL, NULL, 'edit', 500, 501),
(253, 247, NULL, NULL, 'delete', 502, 503),
(254, 247, NULL, NULL, 'allowCollectionDeletion', 504, 505),
(255, 218, NULL, NULL, 'PathCollectionReviews', 507, 508),
(256, 218, NULL, NULL, 'QualityCtrls', 509, 528),
(257, 256, NULL, NULL, 'listAll', 510, 511),
(258, 256, NULL, NULL, 'add', 512, 513),
(259, 256, NULL, NULL, 'detail', 514, 515),
(260, 256, NULL, NULL, 'edit', 516, 517),
(261, 256, NULL, NULL, 'if', 518, 519),
(262, 256, NULL, NULL, 'delete', 520, 521),
(263, 256, NULL, NULL, 'addTestedAliquots', 522, 523),
(264, 256, NULL, NULL, 'allowQcDeletion', 524, 525),
(265, 256, NULL, NULL, 'createQcCode', 526, 527),
(266, 218, NULL, NULL, 'ReviewMasters', 529, 530),
(267, 218, NULL, NULL, 'SampleMasters', 531, 558),
(268, 267, NULL, NULL, 'index', 532, 533),
(269, 267, NULL, NULL, 'search', 534, 535),
(270, 267, NULL, NULL, 'contentTreeView', 536, 537),
(271, 267, NULL, NULL, 'listAll', 538, 539),
(272, 267, NULL, NULL, 'detail', 540, 541),
(273, 267, NULL, NULL, 'add', 542, 543),
(274, 267, NULL, NULL, 'edit', 544, 545),
(275, 267, NULL, NULL, 'delete', 546, 547),
(276, 267, NULL, NULL, 'createSampleCode', 548, 549),
(277, 267, NULL, NULL, 'allowSampleDeletion', 550, 551),
(278, 267, NULL, NULL, 'getTissueSourceList', 552, 553),
(279, 267, NULL, NULL, 'formatSampleFieldDecimalData', 554, 555),
(280, 267, NULL, NULL, 'formatParentSampleDataForDisplay', 556, 557),
(281, 1, NULL, NULL, 'Material', 560, 577),
(282, 281, NULL, NULL, 'Materials', 561, 576),
(283, 282, NULL, NULL, 'index', 562, 563),
(284, 282, NULL, NULL, 'search', 564, 565),
(285, 282, NULL, NULL, 'listall', 566, 567),
(286, 282, NULL, NULL, 'add', 568, 569),
(287, 282, NULL, NULL, 'edit', 570, 571),
(288, 282, NULL, NULL, 'detail', 572, 573),
(289, 282, NULL, NULL, 'delete', 574, 575),
(290, 1, NULL, NULL, 'Order', 578, 649),
(291, 290, NULL, NULL, 'OrderItems', 579, 592),
(292, 291, NULL, NULL, 'listall', 580, 581),
(293, 291, NULL, NULL, 'add', 582, 583),
(294, 291, NULL, NULL, 'addAliquotsInBatch', 584, 585),
(295, 291, NULL, NULL, 'edit', 586, 587),
(296, 291, NULL, NULL, 'delete', 588, 589),
(297, 291, NULL, NULL, 'allowOrderItemDeletion', 590, 591),
(298, 290, NULL, NULL, 'OrderLines', 593, 608),
(299, 298, NULL, NULL, 'listall', 594, 595),
(300, 298, NULL, NULL, 'add', 596, 597),
(301, 298, NULL, NULL, 'edit', 598, 599),
(302, 298, NULL, NULL, 'detail', 600, 601),
(303, 298, NULL, NULL, 'delete', 602, 603),
(304, 298, NULL, NULL, 'generateSampleAliquotControlList', 604, 605),
(305, 298, NULL, NULL, 'allowOrderLineDeletion', 606, 607),
(306, 290, NULL, NULL, 'Orders', 609, 626),
(307, 306, NULL, NULL, 'index', 610, 611),
(308, 306, NULL, NULL, 'search', 612, 613),
(309, 306, NULL, NULL, 'add', 614, 615),
(310, 306, NULL, NULL, 'detail', 616, 617),
(311, 306, NULL, NULL, 'edit', 618, 619),
(312, 306, NULL, NULL, 'delete', 620, 621),
(313, 306, NULL, NULL, 'getStudiesList', 622, 623),
(314, 306, NULL, NULL, 'allowOrderDeletion', 624, 625),
(315, 290, NULL, NULL, 'Shipments', 627, 648),
(316, 315, NULL, NULL, 'listall', 628, 629),
(317, 315, NULL, NULL, 'add', 630, 631),
(318, 315, NULL, NULL, 'edit', 632, 633),
(319, 315, NULL, NULL, 'if', 634, 635),
(320, 315, NULL, NULL, 'detail', 636, 637),
(321, 315, NULL, NULL, 'delete', 638, 639),
(322, 315, NULL, NULL, 'addToShipment', 640, 641),
(323, 315, NULL, NULL, 'deleteFromShipment', 642, 643),
(324, 315, NULL, NULL, 'allowShipmentDeletion', 644, 645),
(325, 315, NULL, NULL, 'allowItemRemoveFromShipment', 646, 647),
(326, 1, NULL, NULL, 'Protocol', 650, 679),
(327, 326, NULL, NULL, 'ProtocolExtends', 651, 662),
(328, 327, NULL, NULL, 'listall', 652, 653),
(329, 327, NULL, NULL, 'detail', 654, 655),
(330, 327, NULL, NULL, 'add', 656, 657),
(331, 327, NULL, NULL, 'edit', 658, 659),
(332, 327, NULL, NULL, 'delete', 660, 661),
(333, 326, NULL, NULL, 'ProtocolMasters', 663, 678),
(334, 333, NULL, NULL, 'index', 664, 665),
(335, 333, NULL, NULL, 'search', 666, 667),
(336, 333, NULL, NULL, 'listall', 668, 669),
(337, 333, NULL, NULL, 'add', 670, 671),
(338, 333, NULL, NULL, 'detail', 672, 673),
(339, 333, NULL, NULL, 'edit', 674, 675),
(340, 333, NULL, NULL, 'delete', 676, 677),
(341, 1, NULL, NULL, 'Provider', 680, 697),
(342, 341, NULL, NULL, 'Providers', 681, 696),
(343, 342, NULL, NULL, 'index', 682, 683),
(344, 342, NULL, NULL, 'search', 684, 685),
(345, 342, NULL, NULL, 'listall', 686, 687),
(346, 342, NULL, NULL, 'add', 688, 689),
(347, 342, NULL, NULL, 'detail', 690, 691),
(348, 342, NULL, NULL, 'edit', 692, 693),
(349, 342, NULL, NULL, 'delete', 694, 695),
(350, 1, NULL, NULL, 'Rtbform', 698, 713),
(351, 350, NULL, NULL, 'Rtbforms', 699, 712),
(352, 351, NULL, NULL, 'index', 700, 701),
(353, 351, NULL, NULL, 'search', 702, 703),
(354, 351, NULL, NULL, 'profile', 704, 705),
(355, 351, NULL, NULL, 'add', 706, 707),
(356, 351, NULL, NULL, 'edit', 708, 709),
(357, 351, NULL, NULL, 'delete', 710, 711),
(358, 1, NULL, NULL, 'Sop', 714, 739),
(359, 358, NULL, NULL, 'SopExtends', 715, 726),
(360, 359, NULL, NULL, 'listall', 716, 717),
(361, 359, NULL, NULL, 'detail', 718, 719),
(362, 359, NULL, NULL, 'add', 720, 721),
(363, 359, NULL, NULL, 'edit', 722, 723),
(364, 359, NULL, NULL, 'delete', 724, 725),
(365, 358, NULL, NULL, 'SopMasters', 727, 738),
(366, 365, NULL, NULL, 'listall', 728, 729),
(367, 365, NULL, NULL, 'add', 730, 731),
(368, 365, NULL, NULL, 'detail', 732, 733),
(369, 365, NULL, NULL, 'edit', 734, 735),
(370, 365, NULL, NULL, 'delete', 736, 737),
(371, 1, NULL, NULL, 'Storagelayout', 740, 815),
(372, 371, NULL, NULL, 'StorageCoordinates', 741, 754),
(373, 372, NULL, NULL, 'listAll', 742, 743),
(374, 372, NULL, NULL, 'add', 744, 745),
(375, 372, NULL, NULL, 'delete', 746, 747),
(376, 372, NULL, NULL, 'allowStorageCoordinateDeletion', 748, 749),
(377, 372, NULL, NULL, 'isDuplicatedValue', 750, 751),
(378, 372, NULL, NULL, 'isDuplicatedOrder', 752, 753),
(379, 371, NULL, NULL, 'StorageMasters', 755, 796),
(380, 379, NULL, NULL, 'index', 756, 757),
(381, 379, NULL, NULL, 'search', 758, 759),
(382, 379, NULL, NULL, 'detail', 760, 761),
(383, 379, NULL, NULL, 'add', 762, 763),
(384, 379, NULL, NULL, 'edit', 764, 765),
(385, 379, NULL, NULL, 'editStoragePosition', 766, 767),
(386, 379, NULL, NULL, 'delete', 768, 769),
(387, 379, NULL, NULL, 'contentTreeView', 770, 771),
(388, 379, NULL, NULL, 'completeStorageContent', 772, 773),
(389, 379, NULL, NULL, 'storageLayout', 774, 775),
(390, 379, NULL, NULL, 'setStorageCoordinateValues', 776, 777),
(391, 379, NULL, NULL, 'allowStorageDeletion', 778, 779),
(392, 379, NULL, NULL, 'getStorageSelectionLabel', 780, 781),
(393, 379, NULL, NULL, 'updateChildrenStorageSelectionLabel', 782, 783),
(394, 379, NULL, NULL, 'createSelectionLabel', 784, 785),
(395, 379, NULL, NULL, 'IsDuplicatedStorageBarCode', 786, 787),
(396, 379, NULL, NULL, 'createStorageCode', 788, 789),
(397, 379, NULL, NULL, 'updateChildrenSurroundingTemperature', 790, 791),
(398, 379, NULL, NULL, 'updateAndSaveDataArray', 792, 793),
(399, 379, NULL, NULL, 'buildChildrenArray', 794, 795),
(400, 371, NULL, NULL, 'TmaSlides', 797, 814),
(401, 400, NULL, NULL, 'listAll', 798, 799),
(402, 400, NULL, NULL, 'add', 800, 801),
(403, 400, NULL, NULL, 'detail', 802, 803),
(404, 400, NULL, NULL, 'edit', 804, 805),
(405, 400, NULL, NULL, 'delete', 806, 807),
(406, 400, NULL, NULL, 'isDuplicatedTmaSlideBarcode', 808, 809),
(407, 400, NULL, NULL, 'allowTMASlideDeletion', 810, 811),
(408, 400, NULL, NULL, 'formatPreselectedStoragesForDisplay', 812, 813),
(409, 1, NULL, NULL, 'Study', 816, 929),
(410, 409, NULL, NULL, 'StudyContacts', 817, 830),
(411, 410, NULL, NULL, 'listall', 818, 819),
(412, 410, NULL, NULL, 'detail', 820, 821),
(413, 410, NULL, NULL, 'add', 822, 823),
(414, 410, NULL, NULL, 'edit', 824, 825),
(415, 410, NULL, NULL, 'delete', 826, 827),
(416, 410, NULL, NULL, 'allowStudyContactDeletion', 828, 829),
(417, 409, NULL, NULL, 'StudyEthicsBoards', 831, 844),
(418, 417, NULL, NULL, 'listall', 832, 833),
(419, 417, NULL, NULL, 'detail', 834, 835),
(420, 417, NULL, NULL, 'add', 836, 837),
(421, 417, NULL, NULL, 'edit', 838, 839),
(422, 417, NULL, NULL, 'delete', 840, 841),
(423, 417, NULL, NULL, 'allowStudyEthicsBoardDeletion', 842, 843),
(424, 409, NULL, NULL, 'StudyFundings', 845, 858),
(425, 424, NULL, NULL, 'listall', 846, 847),
(426, 424, NULL, NULL, 'detail', 848, 849),
(427, 424, NULL, NULL, 'add', 850, 851),
(428, 424, NULL, NULL, 'edit', 852, 853),
(429, 424, NULL, NULL, 'delete', 854, 855),
(430, 424, NULL, NULL, 'allowStudyFundingDeletion', 856, 857),
(431, 409, NULL, NULL, 'StudyInvestigators', 859, 872),
(432, 431, NULL, NULL, 'listall', 860, 861),
(433, 431, NULL, NULL, 'detail', 862, 863),
(434, 431, NULL, NULL, 'add', 864, 865),
(435, 431, NULL, NULL, 'edit', 866, 867),
(436, 431, NULL, NULL, 'delete', 868, 869),
(437, 431, NULL, NULL, 'allowStudyInvestigatorDeletion', 870, 871),
(438, 409, NULL, NULL, 'StudyRelated', 873, 886),
(439, 438, NULL, NULL, 'listall', 874, 875),
(440, 438, NULL, NULL, 'detail', 876, 877),
(441, 438, NULL, NULL, 'add', 878, 879),
(442, 438, NULL, NULL, 'edit', 880, 881),
(443, 438, NULL, NULL, 'delete', 882, 883),
(444, 438, NULL, NULL, 'allowStudyRelatedDeletion', 884, 885),
(445, 409, NULL, NULL, 'StudyResults', 887, 900),
(446, 445, NULL, NULL, 'listall', 888, 889),
(447, 445, NULL, NULL, 'detail', 890, 891),
(448, 445, NULL, NULL, 'add', 892, 893),
(449, 445, NULL, NULL, 'edit', 894, 895),
(450, 445, NULL, NULL, 'delete', 896, 897),
(451, 445, NULL, NULL, 'allowStudyResultDeletion', 898, 899),
(452, 409, NULL, NULL, 'StudyReviews', 901, 914),
(453, 452, NULL, NULL, 'listall', 902, 903),
(454, 452, NULL, NULL, 'detail', 904, 905),
(455, 452, NULL, NULL, 'add', 906, 907),
(456, 452, NULL, NULL, 'edit', 908, 909),
(457, 452, NULL, NULL, 'delete', 910, 911),
(458, 452, NULL, NULL, 'allowStudyReviewDeletion', 912, 913),
(459, 409, NULL, NULL, 'StudySummaries', 915, 928),
(460, 459, NULL, NULL, 'listall', 916, 917),
(461, 459, NULL, NULL, 'detail', 918, 919),
(462, 459, NULL, NULL, 'add', 920, 921),
(463, 459, NULL, NULL, 'edit', 922, 923),
(464, 459, NULL, NULL, 'delete', 924, 925),
(465, 459, NULL, NULL, 'allowStudySummaryDeletion', 926, 927);

DELETE FROM `aros`;
INSERT INTO `aros` (`id`, `parent_id`, `model`, `foreign_key`, `alias`, `lft`, `rght`) VALUES
(1, NULL, 'Group', 1, 'Group::1', 1, 6),
(2, NULL, 'Group', 2, 'Group::2', 7, 10),
(3, NULL, 'Group', 3, 'Group::3', 11, 14),
(4, 1, 'User', 1, 'User::1', 2, 3),
(5, 2, 'User', 2, 'User::2', 8, 9),
(6, 3, 'User', 3, 'User::3', 12, 13),
(7, NULL, 'Group', 4, 'Group::4', 15, 18),
(8, 7, 'User', 4, NULL, 16, 17),
(9, NULL, 'Group', 5, 'Group::5', 19, 32),
(10, 9, 'User', 5, NULL, 20, 21),
(11, 9, 'User', 6, NULL, 22, 23),
(12, NULL, 'Group', 6, 'Group::6', 33, 40),
(13, 12, 'User', 7, NULL, 34, 35),
(14, 12, 'User', 8, NULL, 36, 37),
(15, NULL, 'Group', 7, 'Group::7', 41, 46),
(16, 15, 'User', 9, NULL, 42, 43),
(17, 9, 'User', 10, NULL, 24, 25),
(18, 9, 'User', 11, NULL, 26, 27),
(19, 15, 'User', 12, NULL, 44, 45),
(20, 9, 'User', 13, NULL, 28, 29),
(21, 12, 'User', 14, NULL, 38, 39),
(22, 9, 'User', 15, NULL, 30, 31),
(23, 1, 'User', 16, NULL, 4, 5),
(24, NULL, 'Group', 8, 'Group::8', 47, 50),
(25, 24, 'User', 17, NULL, 48, 49),
(26, NULL, 'Group', 9, 'Group::9', 51, 56),
(27, 26, 'User', 18, NULL, 52, 53),
(28, 26, 'User', 19, NULL, 54, 55);

DELETE FROM `aros_acos`;
INSERT INTO `aros_acos` (`id`, `aro_id`, `aco_id`, `_create`, `_read`, `_update`, `_delete`) VALUES
(1, 1, 1, '1', '1', '1', '1'),
(2, 2, 1, '1', '1', '1', '1'),
(3, 3, 1, '1', '1', '1', '1'),
(4, 7, 2, '-1', '-1', '-1', '-1'),
(5, 7, 281, '-1', '-1', '-1', '-1'),
(6, 7, 341, '-1', '-1', '-1', '-1'),
(7, 7, 350, '-1', '-1', '-1', '-1'),
(8, 7, 358, '-1', '-1', '-1', '-1'),
(9, 9, 2, '-1', '-1', '-1', '-1'),
(10, 9, 281, '-1', '-1', '-1', '-1'),
(11, 9, 341, '-1', '-1', '-1', '-1'),
(12, 9, 350, '-1', '-1', '-1', '-1'),
(13, 9, 358, '-1', '-1', '-1', '-1'),
(14, 12, 2, '-1', '-1', '-1', '-1'),
(15, 12, 281, '-1', '-1', '-1', '-1'),
(16, 12, 341, '-1', '-1', '-1', '-1'),
(17, 12, 350, '-1', '-1', '-1', '-1'),
(18, 12, 358, '-1', '-1', '-1', '-1'),
(19, 15, 1, '-1', '-1', '-1', '-1'),
(20, 24, 2, '-1', '-1', '-1', '-1'),
(21, 24, 281, '-1', '-1', '-1', '-1'),
(22, 24, 341, '-1', '-1', '-1', '-1'),
(23, 24, 350, '-1', '-1', '-1', '-1'),
(24, 24, 358, '-1', '-1', '-1', '-1'),
(25, 26, 2, '-1', '-1', '-1', '-1'),
(26, 26, 281, '-1', '-1', '-1', '-1'),
(27, 26, 341, '-1', '-1', '-1', '-1'),
(28, 26, 350, '-1', '-1', '-1', '-1'),
(29, 26, 358, '-1', '-1', '-1', '-1');

DELETE FROM `banks`;
INSERT INTO `banks` (`id`, `name`, `description`, `created_by`, `created`, `modified_by`, `modified`, `deleted`, `deleted_date`) VALUES
(1, 'Administratrion', '', 0, '0000-00-00 00:00:00', 1, '2010-05-06 11:28:48', 0, '0000-00-00 00:00:00'),
(2, 'Breast/Sein', '', 1, '2010-05-06 11:33:49', 1, '2010-05-06 11:33:49', 0, NULL),
(3, 'Ovarian/Ovaire', '', 1, '2010-05-06 12:21:35', 1, '2010-05-06 12:21:35', 0, NULL),
(4, 'Prostate', '', 1, '2010-05-06 12:24:36', 1, '2010-05-06 12:24:36', 0, NULL),
(5, 'Head&Neck/Tête&cou', '', 1, '2010-05-06 12:37:33', 1, '2010-05-06 12:37:33', 0, NULL),
(6, 'Kidney/Rein', '', 1, '2010-05-06 12:39:26', 1, '2010-05-06 12:39:26', 0, NULL);

DELETE FROM `groups`;
INSERT INTO `groups` (`id`, `bank_id`, `name`, `created`, `modified`) VALUES
(1, 1, 'Syst. Admin.', '2009-02-18 13:05:46', '2010-05-06 11:30:26'),
(2, 1, 'Developers', '2009-02-18 13:05:52', '2010-05-06 11:31:52'),
(3, 1, 'Users Admin.', '2009-02-18 13:05:59', '2010-05-06 11:33:13'),
(4, 2, 'Users', '2010-05-06 11:34:10', '2010-05-06 11:34:10'),
(5, 3, 'Users', '2010-05-06 12:22:12', '2010-05-06 12:22:12'),
(6, 4, 'Users', '2010-05-06 12:24:54', '2010-05-06 12:24:54'),
(7, 1, 'Migration', '2010-05-06 12:29:52', '2010-05-06 12:29:52'),
(8, 5, 'Users', '2010-05-06 12:37:54', '2010-05-06 12:37:54'),
(9, 6, 'Users', '2010-05-06 12:39:44', '2010-05-06 12:39:44');

DELETE FROM `users`;
INSERT INTO `users` (`id`, `username`, `first_name`, `last_name`, `password`, `email`, `department`, `job_title`, `institution`, `laboratory`, `help_visible`, `street`, `city`, `region`, `country`, `mail_code`, `phone_work`, `phone_home`, `lang`, `pagination`, `last_visit`, `group_id`, `active`, `created`, `modified`) VALUES
(1, 'NicoFr', 'Nico', 'Fr', '0ad07cfe52905f3e71193d457c702193', 'administrator@atim2core.dev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'en', 5, '0000-00-00 00:00:00', 1, 0, '2009-02-18 13:06:38', '2009-02-18 13:06:38'),
(2, 'NicoEn', 'Nico', 'En', '0ad07cfe52905f3e71193d457c702193', 'manager@atim2core.dev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'en', 5, '0000-00-00 00:00:00', 2, 0, '2009-02-18 13:07:00', '2009-02-18 13:07:00'),
(3, 'AdminManon', 'Manon', 'Admin', '6f8872887ba08477d9301fb340212b81', 'user@atim2core.dev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'en', 5, '0000-00-00 00:00:00', 3, 0, '2009-02-18 13:07:07', '2009-02-18 13:07:07'),
(4, 'UrszulaK', 'Urszula', 'Krzemien', 'f344980578dbc368444ef46973503554', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 4, 0, '2010-05-06 11:37:44', '2010-05-06 11:37:44'),
(5, 'Manon', 'Manon', 'de Ladurantaye', '6f8872887ba08477d9301fb340212b81', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 5, 0, '2010-05-06 12:23:26', '2010-05-06 12:23:26'),
(6, 'LiseP', 'Lise', 'Portelance', 'bc3a34dd14b4c4ef6a3ffdd83108f6f2', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 5, 0, '2010-05-06 12:24:10', '2010-05-06 12:24:10'),
(7, 'AuroreP', 'Aurore', 'Pierrard', '60b411bcf9d0f3ae111f84748c49f71d', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 6, 0, '2010-05-06 12:26:16', '2010-05-06 12:26:16'),

(8, 'ChantaleA', 'Chantale', 'Auger', '54793ab3a37ce1d4f7dffa151dda27b3', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 6, 0, '2010-05-06 12:26:46', '2010-05-06 12:26:46'),
(9, 'Migration', 'Migration', 'Migration', '0ad07cfe52905f3e71193d457c702193', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 7, 0, '2010-05-06 12:30:39', '2010-05-06 12:30:39'),
(10, 'JennK', 'Jennifer', 'Kendall-Dupont', '3b5aed19be2bf4c6c4fd43cb5dc157b3', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 5, 0, '2010-05-06 12:31:46', '2010-05-06 12:31:46'),
(11, 'Liliane', 'Liliane', 'Meunier', '97a56ac028d6fd7451a527bb8f70b980', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 5, 0, '2010-05-06 12:32:14', '2010-05-06 12:32:14'),
(12, 'SardoMigration', 'SardoMigration', 'SardoMigration', '0ad07cfe52905f3e71193d457c702193', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 7, 0, '2010-05-06 12:33:57', '2010-05-06 12:33:57'),
(13, 'GuilC', 'Guillaume', 'Cardin', '66e333377d39f1eee8aefb26c08c79f2', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 5, 0, '2010-05-06 12:34:38', '2010-05-06 12:34:38'),
(14, 'TeodoraY', 'Teodora', 'Yaneva', '93b785bd590d54099853051e677d8368', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 6, 0, '2010-05-06 12:35:29', '2010-05-06 12:35:29'),
(15, 'karine', 'Karine', 'Normandin', '80c2960e8b84ecf58a930c75b94fbead', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 5, 0, '2010-05-06 12:35:48', '2010-05-06 12:35:48'),
(16, 'MichEn', 'F-M', 'H', '6a1d28d02c836e8c8a93c86f03ad88a1', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 1, 0, '2010-05-06 12:36:56', '2010-05-06 12:36:56'),
(17, 'achristopoulos', 'Apostolos', 'Christopoulos', 'f7148b6a59ce239d4ebdf2472628797d', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 8, 0, '2010-05-06 12:38:56', '2010-05-06 12:38:56'),
(18, 'cfduchat', 'Carl Frédéric', 'Duchatelier', 'cbf02a6d0825c92f7dbf7fa418d48d8c', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 9, 0, '2010-05-06 12:40:53', '2010-05-06 12:40:53'),
(19, 'Jean-Baptiste', 'Jean-Baptiste', 'Lattouf', '453a1e889b0a37dfa97e1d36191ab9db', '', '', '', '', '', NULL, '', '', '', '', '', '', '', 'en', 5, '0000-00-00 00:00:00', 9, 0, '2010-05-06 12:41:23', '2010-05-06 12:41:23');

