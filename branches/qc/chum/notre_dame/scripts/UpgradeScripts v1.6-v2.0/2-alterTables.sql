#Alter existing tables to fit the newest schema. 
#Add foreign keys and data in control tables

##########################################################################
# INVENTORY
##########################################################################

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
  
UPDATE `aliquot_uses` SET `use_recorded_into_table` = 'quality_ctrl_tested_aliquots' WHERE `use_recorded_into_table` LIKE 'qc_tested_aliquots'

UPDATE aliquot_uses alq_use, quality_ctrl_tested_aliquots tst_alq, quality_ctrls qc
SET alq_use.use_code = qc.qc_code
WHERE tst_alq.aliquot_use_id = alq_use.id
AND tst_alq.quality_ctrl_id = qc.id
AND alq_use.use_definition = 'quality control';






-- ici
finir les uses suivant:
aliquot shipment
quality control









   
    
SELECT * FROM  aliquot_uses where use_definition = internal use
  	aliquot shipment
  	sample derivative creation
  	   
    

#
#  Fieldformat of
#    aliquot_uses.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE announcements
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY user_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY group_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY bank_id int(11) NULL DEFAULT '0' COMMENT '';
#
#  Fieldformats of
#    announcements.user_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    announcements.group_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    announcements.bank_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT '0' COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE banks
    ADD created_by int(11) NOT NULL DEFAULT 0 COMMENT '' AFTER description,
    ADD modified_by int(11) NOT NULL DEFAULT 0 COMMENT '' AFTER created,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;

ALTER TABLE clinical_collection_links
    CHANGE diagnosis_id diagnosis_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER collection_id,
    CHANGE consent_id consent_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER diagnosis_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '';
    
#
#  Fieldformats of
#    clinical_collection_links.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    clinical_collection_links.collection_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE coding_adverse_events
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;


ALTER TABLE coding_icd10
    CHANGE `group` icd_group varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER category,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;

#validate dropped fields
ALTER TABLE collections
    ADD bank_id int(11) NULL DEFAULT NULL COMMENT '' AFTER acquisition_label,
    ADD collection_datetime_accuracy varchar(4) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER collection_datetime,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP bank_participant_identifier,
    #DROP visit_label,
    #DROP reception_by,
    #DROP reception_datetime,
    MODIFY collection_property varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    DROP INDEX sop_master_id,
    ADD INDEX acquisition_label (acquisition_label),
    ADD FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`),
    ADD FOREIGN KEY (`sop_master_id`) REFERENCES `sop_masters` (`id`);
UPDATE collections AS c INNER JOIN banks AS b ON c.bank like b.name SET c.bank_id=b.id, collection_datetime_accuracy='u';
ALTER TABLE collections
	DROP bank;
	
#
#  Fieldformat of
#    collections.collection_property changed from varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

#TODO validate drops
RENAME TABLE consents TO consent_masters;
ALTER TABLE consent_masters
	CHANGE date date_of_referral date NULL DEFAULT NULL COMMENT '',
    ADD COLUMN route_of_referral varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN date_first_contact date NULL DEFAULT NULL COMMENT '',
    ADD COLUMN consent_signed_date date NULL DEFAULT NULL COMMENT '',
    ADD COLUMN process_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE memo notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN consent_method varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN translator_indicator varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN translator_signature varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN consent_person varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN consent_master_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD COLUMN consent_control_id int(11) NOT NULL DEFAULT 0 COMMENT '',
    CHANGE consent_type type varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    ADD COLUMN deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    ADD COLUMN deleted_date datetime NULL DEFAULT NULL COMMENT ''
    #,DROP use_of_blood,
    #DROP use_of_urine,
    #DROP urine_blood_use_for_followup,
    #DROP stop_followup,
    #DROP stop_followup_date,
    #DROP contact_for_additional_data,
    #DROP allow_questionaire,
    #DROP stop_questionnaire,
    #DROP stop_questionaire_date,
    #DROP research_other_disease,
    #DROP inform_discovery_on_other_disease,
    #DROP inform_significant_discovery
    ;
INSERT INTO `consent_controls` (`id`, `controls_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(1, 'Consent National', 'active', 'cd_nationals', 'cd_nationals', 0);
UPDATE consent_masters SET consent_control_id=1;

ALTER TABLE datamart_adhoc
    ADD plugin varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER description;


ALTER TABLE datamart_adhoc_favourites
    ADD id int(11) NOT NULL COMMENT '' auto_increment FIRST,
    MODIFY adhoc_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY user_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD PRIMARY KEY (id);
#
#  Fieldformats of
#    datamart_adhoc_favourites.adhoc_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    datamart_adhoc_favourites.user_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE datamart_adhoc_saved
    MODIFY adhoc_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY user_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    datamart_adhoc_saved.adhoc_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    datamart_adhoc_saved.user_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE datamart_batch_ids
    MODIFY set_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY lookup_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    datamart_batch_ids.set_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    datamart_batch_ids.lookup_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE datamart_batch_processes
    ADD plugin varchar(100) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER name;


ALTER TABLE datamart_batch_sets
    ADD plugin varchar(100) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER description,
    MODIFY user_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY group_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    datamart_batch_sets.user_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    datamart_batch_sets.group_id changed from int(11) NOT NULL DEFAULT 0 COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE derivative_details
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    derivative_details.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate drop
#DROP TABLE derived_sample_links;

#TODO validate big table
RENAME TABLE diagnoses TO diagnosis_masters;
ALTER TABLE diagnosis_masters
    ADD dx_identifier varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD primary_number int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY dx_method varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY dx_nature varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY dx_origin varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD dx_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE icd10_id primary_icd10_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD previous_primary_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD previous_primary_code_system varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD topography varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD tumour_grade varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD age_at_dx_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD ajcc_edition varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE collaborative_stage collaborative_staged varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE clinical_stage_grouping clinical_stage_summary varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE path_stage_grouping path_stage_summary varchar(5) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD survival_time_months int(11) NULL DEFAULT NULL COMMENT '',
    ADD notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD diagnosis_control_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    MODIFY participant_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY created_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '';
    
UPDATE diagnosis_masters SET approximative_dx_date='c' WHERE approximative_dx_date='no';
UPDATE diagnosis_masters SET approximative_dx_date='M' WHERE dx_date like '%-06-01' AND approximative_dx_date='yes';
UPDATE diagnosis_masters SET approximative_dx_date='D' WHERE dx_date like '%-01' AND approximative_dx_date='yes';

INSERT INTO `diagnosis_controls` (`id`, `controls_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(1, 'Blood', 'active', 'dx_bloods', 'dxd_bloods', 0),
(2, 'Tissue', 'active', 'dx_tissues', 'dxd_tissues', 0),
(3, 'Unknown', 'active', 'dx_unknown', 'dxd_unknown', 0);
#TODO: build structure for dx_unknown if we keep it

#TODO determine diagnosis_control_id
UPDATE diagnosis_masters SET diagnosis_control_id=3;

ALTER TABLE drugs
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY description text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY created_by int(11) NOT NULL DEFAULT '0' COMMENT '',
    MODIFY modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY modified_by int(11) NOT NULL DEFAULT '0' COMMENT '';
#
#  Fieldformats of
#    drugs.description changed from varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    drugs.created changed from date NOT NULL DEFAULT '0000-00-00' COMMENT '' to datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT ''.
#    drugs.created_by changed from varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to int(11) NOT NULL DEFAULT '0' COMMENT ''.
#    drugs.modified changed from date NOT NULL DEFAULT '0000-00-00' COMMENT '' to datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT ''.
#    drugs.modified_by changed from varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to int(11) NOT NULL DEFAULT '0' COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_all_adverse_events_adverse_event
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_all_adverse_events_adverse_event.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_all_clinical_followup
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_all_clinical_followup.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_all_clinical_presentation
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY weight int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    ed_all_clinical_presentation.weight changed from decimal(10,2) NULL DEFAULT NULL COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    ed_all_clinical_presentation.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_all_lifestyle_base
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_all_lifestyle_base.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO this table is in use
#DROP TABLE ed_all_procure_lifestyle;

ALTER TABLE ed_all_protocol_followup
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_all_protocol_followup.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_all_study_research
    ADD file_path varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER event_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_all_study_research.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_allsolid_lab_pathology
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_allsolid_lab_pathology.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO this table is in use
#DROP TABLE ed_biopsy_clin_event;

ALTER TABLE ed_breast_lab_pathology
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX event_master_id (event_master_id);
#
#  Fieldformat of
#    ed_breast_lab_pathology.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE ed_breast_screening_mammogram
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER event_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY event_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    ed_breast_screening_mammogram.event_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO this table is in use
#DROP TABLE ed_coll_for_cyto_clin_event;

#TODO this table is in use
#DROP TABLE ed_examination_clin_event;

#TODO this table is in use
#DROP TABLE ed_lab_blood_report;

#TODO this table is in use
#DROP TABLE ed_lab_path_report;

#TODO this table is in use
#DROP TABLE ed_lab_revision_report;

#TODO this table is in use
#DROP TABLE ed_medical_imaging_clin_event;

ALTER TABLE event_controls
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER detail_tablename;
    
INSERT INTO `event_controls` (`id`, `disease_site`, `event_group`, `event_type`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(18, 'breast', 'lab', 'pathology', 'active', 'ed_breast_lab_pathology', 'ed_breast_lab_pathology', 0),
(19, 'all solid tumours', 'lab', 'pathology', 'active', 'ed_allsolid_lab_pathology', 'ed_allsolid_lab_pathology', 0),
(20, 'all', 'clinical', 'follow up', 'active', 'ed_all_clinical_followup', 'ed_all_clinical_followup', 0),
(22, 'all', 'clinical', 'presentation', 'active', 'ed_all_clinical_presentation', 'ed_all_clinical_presentation', 0),
(30, 'all', 'lifestyle', 'base', 'active', 'ed_all_lifestyle_base', 'ed_all_lifestyle_base', 0),
(31, 'all', 'adverse_events', 'adverse_event', 'active', 'ed_all_adverse_events_adverse_event', 'ed_all_adverse_events_adverse_event', 0),
(32, 'breast', 'screening', 'mammogram', 'active', 'ed_breast_screening_mammogram', 'ed_breast_screening_mammogram', 0),
(33, 'all', 'protocol', 'followup', 'yes', 'ed_all_protocol_followup', 'ed_all_protocol_followup', 0),
(34, 'all', 'study', 'research', 'active', 'ed_all_study_research', 'ed_all_study_research', 0);

ALTER TABLE event_masters
    ADD event_control_id int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER id,
    CHANGE diagnosis_id diagnosis_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER participant_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER diagnosis_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP FOREIGN KEY event_masters_ibfk_1,
    DROP FOREIGN KEY event_masters_ibfk_2,
    DROP FOREIGN KEY event_masters_ibfk_3;
    
UPDATE event_masters INNER JOIN event_controls ON event_masters.form_alias=event_controls.form_alias SET event_masters.event_control_id=event_controls.id;
    
#TODO validate/move dropped fields
ALTER TABLE event_masters
    #DROP approximative_event_date,
    #DROP result,
    #DROP therapeutic_goal,
    #DROP linked_path_report_id,
    #DROP sardo_record_id,
    #DROP sardo_record_source,
    #DROP last_sardo_import_date,    
    DROP form_alias,
    DROP detail_tablename,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`),
  	ADD FOREIGN KEY (`event_control_id`) REFERENCES `event_controls` (`id`),
  	ADD FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`);
#
#  Fieldformat of
#    event_masters.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO convert approximative yes/no to range or move to dx table??
ALTER TABLE family_histories
    CHANGE domain family_domain varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE icd10_id primary_icd10_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER family_domain,
    ADD previous_primary_code varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER primary_icd10_code,
    ADD previous_primary_code_system varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER previous_primary_code,
    ADD age_at_dx_accuracy varchar(100) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER age_at_dx,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY relation varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    #DROP dx_date, #does not exist anymore
    #DROP approximative_dx_date,
    DROP dx_date_status,#always null
    DROP age_at_dx_status,#always null
    #--do not drop custom column DROP sardo_diagnosis_id,
    #--do not drop custom column DROP last_sardo_import_date,
    ADD FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`) ON DELETE CASCADE;
#
#  Fieldformat of
#    family_histories.relation changed from varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

#TODO: Import custom stuff or rebuild it with the form builder
#DROP TABLE form_fields;
#DROP TABLE form_fields_global_lookups;
#DROP TABLE form_formats;
#DROP TABLE form_validations;
#DROP TABLE forms;
#DROP TABLE global_lookups;

#TODO validate head n neck
ALTER TABLE groups
    MODIFY bank_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY name varchar(100) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    DROP level,
    DROP redirect,
    DROP perm_type,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    DROP created_by,
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    DROP modified_by;
#
#  Fieldformats of
#    groups.bank_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    groups.name changed from varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(100) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    groups.created changed from datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    groups.modified changed from datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate
#DROP TABLE groups_permissions;

ALTER TABLE i18n
    MODIFY page_id varchar(100) NOT NULL DEFAULT '';
    
#TODO - what are those tables?
#DROP TABLE install_disease_sites;
#DROP TABLE install_locations;
#DROP TABLE install_studies;
#DROP TABLE lab_type_laterality_match;

ALTER TABLE materials
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;

ALTER TABLE misc_identifiers
    CHANGE name identifier_name varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER identifier_value,
    CHANGE memo notes varchar(100) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER expiry_date,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;

#TODO: adjust the autoincrements    
INSERT INTO misc_identifier_controls(`misc_identifier_name`, `misc_identifier_name_abbrev`, `status`, `display_order`, `autoincrement_name`, `misc_identifier_format`)
(SELECT identifier_name, '', 'active', '0', NULL, NULL FROM misc_identifiers group by identifier_name);

ALTER TABLE `misc_identifiers` ADD `misc_identifier_control_id`  INT( 11 ) NOT NULL DEFAULT '0' AFTER `identifier_value` ; 
ALTER TABLE `misc_identifiers_revs` ADD `misc_identifier_control_id`  INT( 11 ) NOT NULL DEFAULT '0' AFTER `identifier_value` ;
UPDATE `misc_identifiers` AS mi INNER JOIN misc_identifier_controls AS mic ON mi.identifier_name=mic.misc_identifier_name
SET mi.misc_identifier_control_id=mic.id;


#TODO order_items clean up
ALTER TABLE order_items
    ADD order_line_id int(11) NULL DEFAULT NULL COMMENT '' AFTER modified_by,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER aliquot_use_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP barcode,
    #DROP shipping_name,
    #DROP base_price,
    #DROP datetime_scanned_out,
    #DROP orderline_id,
    MODIFY aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    order_items.aliquot_use_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO clean
ALTER TABLE order_lines
    CHANGE min_qty_ordered min_quantity_ordered varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER quantity_ordered,
    ADD quantity_unit varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER min_quantity_ordered,
    ADD product_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER modified_by,
    ADD aliquot_control_id int(11) NULL DEFAULT NULL COMMENT '' AFTER sample_control_id,
    ADD sample_aliquot_precision varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER aliquot_control_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER order_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP cancer_type,#always null
    MODIFY quantity_ordered varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    #DROP quantity_UM,
    #DROP min_qty_UM,
    #DROP base_price,
    #DROP quantity_shipped,
    #DROP discount_id,
    #DROP product_id,
    ADD FOREIGN KEY (`sample_control_id`) REFERENCES `sample_controls` (`id`),
  	ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);
#
#  Fieldformat of
#    order_lines.quantity_ordered changed from int(255) NULL DEFAULT NULL COMMENT '' to varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

#TODO clean
ALTER TABLE orders
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP type,
    #DROP microarray_chip,
    ADD INDEX order_number (order_number),
    ADD FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);


ALTER TABLE part_bank_nbr_counters
	CHANGE bank_ident_title keyname varchar(50) NOT NULL,
	CHANGE last_nbr key_value int(11) NOT NULL;

RENAME TABLE part_bank_nbr_counters TO key_increments;
UPDATE key_increments SET key_value=key_value + 1; #the old system had the previous value rather than the next one
ALTER TABLE key_increments
	CHANGE keyname key_name varchar(50) NOT NULL UNIQUE;

#TODO validate
ALTER TABLE participant_contacts
    CHANGE name contact_name varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER id,
    CHANGE memo notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER expiry_date,
    ADD locality varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER street,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER participant_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP facility,
    #DROP type_precision,
    #DROP street_nbr,
    #DROP city,
    MODIFY phone_secondary varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    participant_contacts.phone changed from varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    participant_contacts.phone_secondary changed from varchar(30) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(15) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    participant_contacts.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate
ALTER TABLE participant_messages
    CHANGE type message_type varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER author,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP status,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '';
    #--do not drop custom field DROP sardo_note_id,
    #--do not drop custom field DROP last_sardo_import_date;
#
#  Fieldformat of
#    participant_messages.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate
ALTER TABLE participants
    CHANGE memo notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER vital_status,
    CHANGE icd10_id cod_icd10_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER dod_date_accuracy,
    ADD secondary_cod_icd10_code varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER cod_icd10_code,
    ADD cod_confirmation_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER secondary_cod_icd10_code,
    ADD participant_identifier varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER cod_confirmation_source,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY title varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY first_name varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY last_name varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE approximative_date_of_birth dob_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    #DROP date_status,
    MODIFY sex varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY race varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    #DROP ethnicity,
    #DROP status,
    CHANGE approximative_date_of_death dod_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    #DROP death_certificate_ident,
    #DROP confirmation_source,
    #DROP tb_number,
    #DROP last_visit_date,
    #DROP approximative_last_visit_date,
    #--do not drop custom column DROP sardo_participant_id,
    #--do not drop custom column DROP sardo_numero_dossier,
    #--do not drop custom column DROP last_sardo_import_date,
    MODIFY created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY created_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY modified datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY modified_by varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    ADD UNIQUE unique_participant_identifier (participant_identifier);    
UPDATE participants SET cod_icd10_code=NULL WHERE cod_icd10_code=''; 
UPDATE participants SET dob_date_accuracy='' WHERE dob_date_accuracy='yes' AND date_of_birth IS NULL;
UPDATE participants SET dod_date_accuracy='' WHERE dod_date_accuracy='yes' AND date_of_death IS NULL; 

ALTER TABLE participants
    ADD FOREIGN KEY (`secondary_cod_icd10_code`) REFERENCES `coding_icd10` (`id`),
  	ADD FOREIGN KEY (`cod_icd10_code`) REFERENCES `coding_icd10` (`id`);
#
#  Fieldformats of
#    participants.title changed from varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    participants.first_name changed from varchar(20) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    participants.last_name changed from varchar(20) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    participants.sex changed from char(1) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    participants.race changed from varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    participants.created changed from datetime NULL DEFAULT NULL COMMENT '' to datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT ''.
#    participants.created_by changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    participants.modified changed from datetime NULL DEFAULT NULL COMMENT '' to datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT ''.
#    participants.modified_by changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

ALTER TABLE path_collection_reviews
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    path_collection_reviews.collection_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    path_collection_reviews.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    path_collection_reviews.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate
ALTER TABLE pd_chemos
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER protocol_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP num_cycles,
    #DROP length_cycles,
    MODIFY protocol_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    pd_chemos.protocol_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#this table is in use. where do the data go?
#DROP TABLE pd_undetailled_protocols;

ALTER TABLE pe_chemos
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER drug_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;

#ok, empty table
DROP TABLE pe_undetailled_protocols;

#TODO validate, looks useless
DROP TABLE permissions;

#TODO extend_form_alias might need update to pe_chemos
ALTER TABLE protocol_controls
    CHANGE detail_form_alias form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER detail_tablename;

UPDATE protocol_controls SET detail_tablename='pd_chemos', form_alias='pd_chemos', extend_tablename='pd_chemos' WHERE id=1;


ALTER TABLE protocol_masters
    ADD protocol_control_id int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER form_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP detail_tablename,
    DROP detail_form_alias,
    DROP extend_tablename,
    DROP extend_form_alias;

UPDATE protocol_masters SET protocol_control_id=1;


ALTER TABLE rd_blood_cells
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_blood_cells.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_bloodcellcounts
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_bloodcellcounts.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_breast_cancers
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY tumour_type_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    rd_breast_cancers.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    rd_breast_cancers.tumour_type_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_breastcancertypes
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_breastcancertypes.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_coloncancertypes
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_coloncancertypes.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_genericcancertypes
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_genericcancertypes.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rd_ovarianuteruscancertypes
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY review_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    rd_ovarianuteruscancertypes.review_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate dropped columns
ALTER TABLE realiquotings
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY parent_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY child_aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '';
    #DROP realiquoted_by,
    #DROP realiquoted_datetime,
    #DROP INDEX parent_aliquot_master_id,
    #DROP INDEX child_aliquot_master_id,
    #DROP INDEX aliquot_use_id;
#
#  Fieldformats of
#    realiquotings.parent_aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    realiquotings.child_aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    realiquotings.aliquot_use_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO looks like a major refactoring
ALTER TABLE reproductive_histories
    ADD menopause_onset_reason varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER menopause_status,
    ADD menopause_age_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER age_at_menopause,
    ADD age_at_menarche_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER age_at_menarche,
    ADD hrt_years_used int(11) NULL DEFAULT NULL COMMENT '' AFTER age_at_menarche_accuracy,
    ADD hysterectomy_age_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER hysterectomy_age,
    ADD ovary_removed_type varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER hysterectomy,
    ADD first_parturition_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER age_at_first_parturition,
    ADD last_parturition_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER age_at_last_parturition,
    ADD hormonal_contraceptive_use varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER last_parturition_accuracy,
    ADD years_on_hormonal_contraceptives int(11) NULL DEFAULT NULL COMMENT '' AFTER hormonal_contraceptive_use,
    ADD lnmp_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER lnmp_date,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY menopause_status varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    #DROP menopause_age_certainty,
    #DROP hrt_years_on,
    #DROP hysterectomy_age_certainty,
    #DROP first_ovary_out_age,
    #DROP first_ovary_certainty,
    #DROP second_ovary_out_age,
    #DROP second_ovary_certainty,
    #DROP first_ovary_out,
    #DROP second_ovary_out,
    #DROP aborta,
    #DROP first_parturition_certainty,
    #DROP last_parturition_certainty,
    #DROP age_at_menarche_certainty,
    #DROP oralcontraceptive_use,
    #DROP years_on_oralcontraceptives,
    #DROP lnmp_certainty,
    MODIFY created datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD INDEX participant_id (participant_id);
#
#  Fieldformats of
#    reproductive_histories.menopause_status changed from varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    reproductive_histories.created changed from date NOT NULL DEFAULT '0000-00-00' COMMENT '' to datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT ''.
#    reproductive_histories.modified changed from date NOT NULL DEFAULT '0000-00-00' COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    reproductive_histories.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE review_controls
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER detail_tablename,
    MODIFY form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci;
#
#  Fieldformats of
#    review_controls.form_alias changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    review_controls.detail_tablename changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

ALTER TABLE review_masters
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    review_masters.collection_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    review_masters.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE rtbforms
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY created_by int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY modified_by int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    rtbforms.created_by changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to int(11) NULL DEFAULT NULL COMMENT ''.
#    rtbforms.modified_by changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO: this table might need an update to the new version
RENAME TABLE sample_aliquot_control_links TO sample_to_aliquot_controls;

-- there is no more specific structure for tissue tubes
UPDATE sample_to_aliquot_controls SET aliquot_control_id=1 WHERE aliquot_control_id=1001;
UPDATE aliquot_masters SET aliquot_control_id=1 WHERE aliquot_control_id=1001;
DELETE FROM aliquot_controls WHERE id=1001;

-- there is no more specific table for cell tubes
UPDATE aliquot_controls SET detail_tablename='ad_tubes' WHERE id=15;
#TODO create a structure for aliquot bag (1002)

ALTER TABLE sample_controls
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER detail_tablename,
    MODIFY form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY detail_tablename varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci;
    
UPDATE sample_controls SET form_alias='sd_undetailed_derivatives' WHERE id IN('5', '7', '8', '12', '13', '14', '15', '17', '18', '101', '102', '106', '107', '108', '109');
#TODO: amp_rnas had a form called  sd_der_amplified_rnas -> need to reproduce it
#TODO tablename for amplified dna(16), other fluid cell(110), other fluid supernatant(111) UPDATE sample_controls SET detail_tablename='???' WHERE id='???';

INSERT INTO `sample_controls` (`id`, `sample_type`, `sample_type_code`, `sample_category`, `status`, `form_alias`, `detail_tablename`, `display_order`) VALUES
(112, 'pericardial fluid', 'PC-F', 'specimen', 'active', 'sd_spe_pericardial_fluids', 'sd_spe_pericardial_fluids', 0),
(113, 'pleural fluid', 'PL-F', 'specimen', 'active', 'sd_spe_pleural_fluids', 'sd_spe_pleural_fluids', 0),
(114, 'pericardial fluid cell', 'PC-C', 'derivative', 'active', 'sd_undetailed_derivatives', 'sd_der_pericardial_fl_cells', 0),
(115, 'pericardial fluid supernatant', 'PC-S', 'derivative', 'active', 'sd_undetailed_derivatives', 'sd_der_pericardial_fl_sups', 0),
(116, 'pleural fluid cell', 'PL-C', 'derivative', 'active', 'sd_undetailed_derivatives', 'sd_der_pleural_fl_cells', 0),
(117, 'pleural fluid supernatant', 'PL-S', 'derivative', 'active', 'sd_undetailed_derivatives', 'sd_der_pleural_fl_sups', 0);


#
#  Fieldformats of
#    sample_controls.form_alias changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    sample_controls.detail_tablename changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

#todo validate drop
ALTER TABLE sample_masters
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY collection_id int(11) NULL DEFAULT NULL COMMENT '',
    #DROP sample_label,
    ADD UNIQUE unique_sample_code (sample_code),
    ADD INDEX sample_code (sample_code),
  	ADD FOREIGN KEY (`initial_specimen_sample_id`) REFERENCES `sample_masters` (`id`);
#
#  Fieldformat of
#    sample_masters.collection_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

RENAME TABLE sd_der_amplified_rnas TO sd_der_amp_rnas;
ALTER TABLE sd_der_amp_rnas
    ADD COLUMN deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '',
    ADD COLUMN deleted_date datetime NULL DEFAULT NULL COMMENT '';

ALTER TABLE sd_der_blood_cells
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';    
#  Fieldformat of
#    sd_der_blood_cells.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#warning can be ignored
ALTER TABLE sd_der_cell_cultures
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY cell_passage_number int(6) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    sd_der_cell_cultures.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    sd_der_cell_cultures.cell_passage_number changed from varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to int(6) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate drops
ALTER TABLE sd_der_dnas
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT ''
    #,DROP source_cell_passage_number,
    #DROP source_temperature,
    #DROP source_temp_unit,
    ;
#
#  Fieldformat of
#    sd_der_dnas.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_der_pbmcs
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
    
#
#  Fieldformat of
#    sd_der_pbmcs.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_der_plasmas
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    sd_der_plasmas.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate dropped columns
ALTER TABLE sd_der_rnas
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT ''
    #,DROP source_cell_passage_number,
    #DROP source_temperature,
    #DROP source_temp_unit,
    ;
#
#  Fieldformat of
#    sd_der_rnas.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_der_serums
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';

#
#  Fieldformat of
#    sd_der_serums.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_spe_ascites
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';

#
#  Fieldformat of
#    sd_spe_ascites.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_spe_bloods
    CHANGE type blood_type varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER sample_master_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    sd_spe_bloods.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_spe_cystic_fluids
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    sd_spe_cystic_fluids.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO not droping non empty table
#DROP TABLE sd_spe_other_fluids;

ALTER TABLE sd_spe_peritoneal_washes
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    sd_spe_peritoneal_washes.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sd_spe_tissues
    CHANGE nature tissue_nature varchar(15) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER tissue_source,
    CHANGE laterality tissue_laterality varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER tissue_nature,
    CHANGE size tissue_size varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER pathology_reception_datetime,
    ADD tissue_size_unit varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER tissue_size,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY tissue_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci;
    #--do not drop custom field DROP labo_laterality,
#
#  Fieldformats of
#    sd_spe_tissues.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    sd_spe_tissues.tissue_source changed from varchar(20) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

#TODO validate dropped fields
ALTER TABLE sd_spe_urines
    CHANGE aspect urine_aspect varchar(30) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER sample_master_id,
    CHANGE pellet pellet_signs varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER collected_volume_unit,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT ''
    #,DROP received_volume,
    #DROP received_volume_unit,
    ;
#
#  Fieldformat of
#    sd_spe_urines.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE shelves
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY storage_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    shelves.storage_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE shipments
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER order_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    ADD INDEX shipment_code (shipment_code),
    ADD INDEX recipient (recipient),
    ADD INDEX facility (facility),
    ADD INDEX FK_shipments_orders (order_id);


ALTER TABLE sop_controls
    CHANGE detail_form_alias form_alias varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER detail_tablename,
    ADD display_order int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER extend_form_alias;


ALTER TABLE sop_masters
    ADD sop_control_id int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER form_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP detail_tablename,
    DROP detail_form_alias,
    DROP extend_tablename,
    DROP extend_form_alias;


ALTER TABLE sopd_general_all
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER sop_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sop_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    sopd_general_all.sop_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE sope_general_all
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER material_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;


ALTER TABLE source_aliquots
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY aliquot_use_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    source_aliquots.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    source_aliquots.aliquot_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    source_aliquots.aliquot_use_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate dropped columns
ALTER TABLE specimen_details
    ADD reception_by varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER supplier_dept,
    ADD reception_datetime datetime NULL DEFAULT NULL COMMENT '' AFTER reception_by,
    ADD reception_datetime_accuracy varchar(4) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER reception_datetime,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY sample_master_id int(11) NULL DEFAULT NULL COMMENT ''
    #,DROP type_code,
    #DROP sequence_number,
    ;
#
#  Fieldformat of
#    specimen_details.sample_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE std_incubators
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY storage_master_id int(11) NULL DEFAULT NULL COMMENT '';
    
#
#  Fieldformat of
#    std_incubators.storage_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE std_rooms
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY storage_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    std_rooms.storage_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE std_tma_blocks
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY storage_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    std_tma_blocks.storage_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

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
#
#  Fieldformats of
#    storage_controls.form_alias changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    storage_controls.detail_tablename changed from varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

ALTER TABLE storage_coordinates
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY storage_master_id int(11) NULL DEFAULT NULL COMMENT '',
    MODIFY coordinate_value varchar(50) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci;
#
#  Fieldformats of
#    storage_coordinates.storage_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#    storage_coordinates.coordinate_value changed from varchar(30) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

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
#
#  Fieldformats of
#    storage_masters.barcode changed from varchar(30) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(60) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    storage_masters.short_label changed from varchar(10) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(10) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    storage_masters.selection_label changed from varchar(60) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(60) NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#    storage_masters.parent_storage_coord_x changed from varchar(11) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    storage_masters.parent_storage_coord_y changed from varchar(11) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

ALTER TABLE study_contacts
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP phone_country,
    DROP phone_area,
    MODIFY phone_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    DROP phone2_country,
    DROP phone2_area,
    MODIFY phone2_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    DROP fax_country,
    DROP fax_area,
    MODIFY fax_number varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
#
#  Fieldformats of
#    study_contacts.phone_number changed from int(11) NULL DEFAULT NULL COMMENT '' to varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    study_contacts.phone2_number changed from int(11) NULL DEFAULT NULL COMMENT '' to varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    study_contacts.fax_number changed from int(11) NULL DEFAULT NULL COMMENT '' to varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    study_contacts.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_contacts.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_contacts.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#empty table
DROP TABLE study_ethicsboards;

ALTER TABLE study_fundings
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP phone_country,
    DROP phone_area,
    DROP fax_country,
    DROP fax_area,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
#
#  Fieldformats of
#    study_fundings.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_fundings.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_fundings.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE study_investigators
    ADD email varchar(45) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER sort,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
#
#  Fieldformats of
#    study_investigators.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_investigators.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_investigators.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE study_related
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER path_to_file,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
#
#  Fieldformats of
#    study_related.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_related.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_related.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE study_results
    ADD result_date datetime NULL DEFAULT NULL COMMENT '' AFTER future,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
#
#  Fieldformats of
#    study_results.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_results.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_results.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE study_reviews
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER study_summary_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP phone_country,
    DROP phone_area,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '',
    MODIFY study_summary_id int(11) NULL DEFAULT NULL COMMENT '',
    ADD FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
#
#  Fieldformats of
#    study_reviews.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_reviews.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_reviews.study_summary_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE study_summaries
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER path_to_file,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    MODIFY created datetime NULL DEFAULT NULL COMMENT '',
    MODIFY modified datetime NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    study_summaries.created changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#    study_summaries.modified changed from date NULL DEFAULT NULL COMMENT '' to datetime NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE tma_slides
    CHANGE std_tma_block_id tma_block_storage_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER id,
    ADD coord_x_order int(3) NULL DEFAULT NULL COMMENT '' AFTER storage_coord_x,
    ADD coord_y_order int(3) NULL DEFAULT NULL COMMENT '' AFTER storage_coord_y,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP FOREIGN KEY tma_slides_ibfk_3,
    ADD UNIQUE unique_barcode (barcode),
    ADD INDEX barcode (barcode),
    ADD INDEX product_code (product_code),
    ADD FOREIGN KEY (`tma_block_storage_master_id`) REFERENCES `storage_masters` (`id`);

#empty table
DROP TABLE towers;

ALTER TABLE tx_controls
	CHANGE detail_form_alias form_alias varchar(255) DEFAULT NULL,
	ADD display_order tinyint unsigned NOT NULL DEFAULT 0;
UPDATE tx_controls SET extend_tablename='txe_radiations', extend_form_alias='txe_radiations' WHERE id='2';
UPDATE tx_controls SET extend_tablename='txe_surgeries', extend_form_alias='txe_surgeries' WHERE id='3';
UPDATE tx_controls SET extend_tablename='txe_drugs', extend_form_alias='txe_drugs' WHERE id='4';
#
#  Fieldformat of
#    tx_controls.detail_tablename changed from varchar(255) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci to varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci.
#  Possibly data modifications needed!
#

#TODO validate drops
ALTER TABLE tx_masters
    ADD treatment_control_id int(11) NOT NULL DEFAULT '0' COMMENT '' AFTER id,
    ADD tx_method varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER treatment_control_id,
    ADD target_site_icdo varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER tx_intent,
    ADD finish_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER finish_date,
    CHANGE source information_source varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER finish_date_accuracy,
    CHANGE summary notes text NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER facility,
    CHANGE diagnosis_id diagnosis_master_id int(11) NULL DEFAULT NULL COMMENT '' AFTER participant_id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP `group`,
    MODIFY disease_site varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci,
    CHANGE approximative_tx_date start_date_accuracy varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER start_date,
    #DROP result,
    #DROP therapeutic_goal,
    #--do not drop custom column DROP sardo_treatment_id,
    #--do not drop custom column DROP last_sardo_import_date,
    MODIFY participant_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP INDEX diagnosis_id,
    DROP FOREIGN KEY `tx_masters_ibfk_2`, 
    ADD FOREIGN KEY (`diagnosis_master_id`) REFERENCES `diagnosis_masters` (`id`) ON DELETE SET NULL,
    ADD INDEX treatment_control_id (treatment_control_id);
UPDATE tx_masters SET start_date_accuracy='c' WHERE start_date_accuracy='no';
UPDATE tx_masters SET start_date_accuracy='M' WHERE start_date_accuracy='yes' AND start_date LIKE '%-06-01';
UPDATE tx_masters SET start_date_accuracy='D' WHERE start_date_accuracy='yes' AND start_date LIKE '%-01';
#
#  Fieldformats of
#    tx_masters.disease_site changed from varchar(50) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci to varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci.
#    tx_masters.participant_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

UPDATE tx_masters AS tm INNER JOIN tx_controls AS tc ON tm.detail_form_alias=tc.form_alias SET tm.treatment_control_id=tc.id;

ALTER TABLE tx_masters
	DROP detail_tablename,
	DROP detail_form_alias,
	DROP extend_tablename,
	DROP extend_form_alias;

ALTER TABLE txd_chemos
    ADD chemo_completed varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER tx_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP completed,#always null
    MODIFY tx_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    txd_chemos.tx_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#empty table
DROP TABLE txd_combos;

#TODO do not drop
#DROP TABLE txd_drugs;

#TODO validate drop radiation_type
ALTER TABLE txd_radiations
    ADD rad_completed varchar(50) NULL DEFAULT NULL COMMENT '' COLLATE latin1_swedish_ci AFTER id,
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP radiation_type,
    DROP source,#ok drop
    DROP mould,#ok drop
    MODIFY tx_master_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    txd_radiations.tx_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#TODO validate drops
ALTER TABLE txd_surgeries
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    #DROP surgery_type,
    #DROP linked_path_report_id,
    DROP surgeon,#ok drop
    MODIFY tx_master_id int(11) NULL DEFAULT NULL COMMENT '',
    DROP FOREIGN KEY txd_surgeries_ibfk_2;
#
#  Fieldformat of
#    txd_surgeries.tx_master_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

#empty table
ALTER TABLE txe_chemos
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted,
    DROP source,
    DROP frequency,
    DROP reduction,
    DROP cycle_number,
    DROP completed_cycles,
    DROP start_date,
    DROP end_date,
    MODIFY tx_master_id int(11) NOT NULL DEFAULT '0' COMMENT '',
    MODIFY drug_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformats of
#    txe_chemos.tx_master_id changed from int(11) NULL DEFAULT NULL COMMENT '' to int(11) NOT NULL DEFAULT '0' COMMENT ''.
#    txe_chemos.drug_id changed from varchar(50) NULL DEFAULT '0' COMMENT '' COLLATE latin1_swedish_ci to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE txe_radiations
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER tx_master_id,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;


ALTER TABLE txe_surgeries
    ADD deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '' AFTER modified_by,
    ADD deleted_date datetime NULL DEFAULT NULL COMMENT '' AFTER deleted;


ALTER TABLE user_logs
    MODIFY user_id int(11) NULL DEFAULT NULL COMMENT '';
#
#  Fieldformat of
#    user_logs.user_id changed from int(11) NOT NULL DEFAULT '0' COMMENT '' to int(11) NULL DEFAULT NULL COMMENT ''.
#  Possibly data modifications needed!
#

ALTER TABLE users
    CHANGE passwd password varchar(255) NOT NULL DEFAULT '' COMMENT '' COLLATE latin1_swedish_ci AFTER last_name,
 	ALTER help_visible DROP DEFAULT;

#TODO - the following update fixes the foreign key
UPDATE clinical_collection_links SET participant_id=NULL WHERE participant_id=0;
UPDATE clinical_collection_links SET consent_master_id=NULL WHERE consent_master_id=0;
UPDATE clinical_collection_links SET diagnosis_master_id=NULL WHERE diagnosis_master_id=0;
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