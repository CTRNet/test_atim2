-- Storages
UPDATE atim.storage_controls SET flag_active=false WHERE id!=6;
-- TODO: Complete with details
ALTER TABLE atim.storage_masters
 DROP INDEX unique_code,
 ADD COLUMN old_id int,
 ADD COLUMN tower_id int,
 ADD COLUMN box_id int;
-- freezer
INSERT INTO atim.storage_masters(code, storage_control_id, storage_type, set_temperature, temperature, temp_unit, old_id, created, created_by, modified, modified_by) 
(SELECT NULL, 6, 'freezer', true, storage_temp, 'celsius', id,created, created_by, modified, modified_by FROM storages);
UPDATE atim.storage_masters SET code=CONCAT('FRE - ', id);
INSERT INTO atim.std_freezers(storage_master_id, created_by, modified, modified_by) (SELECT id, created_by, modified, modified_by FROM atim.storage_masters);

-- Towers
-- TODO: you have towers without a proper freezer. Run SELECT id FROM towers WHERE storage_id NOT IN(SELECT id FROM storages);
INSERT INTO `atim`.`storage_controls` (`id`, `storage_type`, `storage_type_code`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `form_alias`, `detail_tablename`, `databrowser_label`) VALUES
(NULL, 'tower', 'T', NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', '0', '0', '1', NULL, NULL, '1', 'std_undetail_stg_with_surr_tmp', 'std_towers', 'tower');
CREATE TABLE atim.std_towers (SELECT * FROM atim.std_shelfs LIMIT 1);
ALTER TABLE atim.std_towers
 MODIFY id int NOT NULL AUTO_INCREMENT PRIMARY KEY;
INSERT INTO atim.storage_masters(code, storage_control_id, storage_type, set_temperature, temp_unit, parent_id, tower_id, created, created_by, modified, modified_by)
(SELECT NULL, 21, 'tower', false, 'celsius', (SELECT id FROM atim.storage_masters WHERE old_id=storage_id), id, created, created_by, modified, modified_by FROM towers);
UPDATE atim.storage_masters AS c 
 LEFT JOIN atim.storage_masters AS p ON c.parent_id=p.id
 SET c.code=CONCAT('T - ', c.id), c.temperature=p.temperature WHERE c.tower_id IS NOT NULL;
INSERT INTO atim.std_towers(storage_master_id, created_by, modified, modified_by) (SELECT id, created_by, modified, modified_by FROM atim.storage_masters WHERE tower_id IS NOT NULL);

-- Boxes
INSERT INTO `atim`.`storage_controls` (`id`, `storage_type`, `storage_type_code`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `form_alias`, `detail_tablename`, `databrowser_label`) VALUES 
(NULL, 'box 1,1-9,9', 'B1199', 'column', 'integer', '9', 'row', 'integer', '9', '0', '0', '0', '0', '1', NULL, NULL, '1', 'std_undetail_stg_with_surr_tmp', 'std_boxs', 'box 1,1-9,9');
INSERT INTO atim.storage_masters(code, storage_control_id, storage_type, set_temperature, temp_unit, parent_id, box_id, created, created_by, modified, modified_by, selection_label)
(SELECT NULL, 22, 'box', false, 'celsius', p.id, c.id, c.created, c.created_by, c.modified, c.modified_by, description 
FROM boxes AS c
LEFT JOIN atim.storage_masters AS p ON c.tower_id=p.tower_id);
UPDATE atim.storage_masters AS c 
 LEFT JOIN atim.storage_masters AS p ON c.parent_id=p.id
 SET c.code=CONCAT('B1199 - ', c.id), c.temperature=p.temperature WHERE c.box_id IS NOT NULL;
INSERT INTO atim.std_boxs(storage_master_id, created_by, modified, modified_by) (SELECT id, created_by, modified, modified_by FROM atim.storage_masters WHERE box_id IS NOT NULL);

-- ATIM Participants
INSERT INTO atim.participants (id, title, first_name, middle_name, last_name, date_of_birth, sex, bc_ttr_phn, notes,  created, created_by, modified, modified_by)
SELECT id, salutation, first_name, usual_name, last_name, date_of_birth, sex, phn, memo,created, created_by, modified, modified_by
FROM participants;


-- Temporary Fix for all orphan consents to Jane Doe participant until we can sort this out with TTR Clinical staff (BRT)
UPDATE consents
SET participant_id = 1878
WHERE  participant_id IN ( 1649, 2099, 2100, 3021, 3154, 3198 );

-- ATIM Consents

INSERT INTO atim.consent_masters(id, date_of_referral , reason_denied ,  surgeon , bc_ttr_consent_closed , bc_ttr_protocol , bc_ttr_diagnosis , bc_ttr_cancer_type , bc_ttr_referral_source , bc_ttr_home_phone , bc_ttr_cell_phone , bc_ttr_work_phone , bc_ttr_fax_number , bc_ttr_email , bc_ttr_iroc_number , bc_ttr_iroc_flag , bc_ttr_pathologist , bc_ttr_consent_id, facility , consent_signed_date , bc_ttr_blood_collected , participant_id ,	 consent_control_id,  bc_ttr_date_consent_denied , bc_ttr_date_consent_withdrawn, created, 	 created_by, 	 modified ,	 modified_by ,  bc_ttr_smoking_history , bc_ttr_pack_years , bc_ttr_years_since_quit , bc_ttr_contact_for_genetic_research , bc_ttr_date_referral_withdrawn , consent_method , form_version , bc_ttr_surgery , bc_ttr_tissue_collected , bc_ttr_ttr_appt_datetime , bc_ttr_pathology_specification ,bc_ttr_acquisition_id,notes, bc_ttr_medical_record_no , process_status , operation_date ,	bc_ttr_decline_use_of_blood_samples , bc_ttr_brt_flag  )
SELECT id,  referral_datetime , reason_denied , surgeon , consent_closed ,   protocol , diagnosis       , cancer_type , referral_source , home_phone , cell_phone , work_phone , fax_number , email , IROC_number , IROC_flag , pathologist , consent_id , or_facility   , date_consent_signed , blood_collected , participant_id ,1, date_denied , date_withdrawn , created , created_by , modified , modified_by ,smoking_history ,	pack_years ,years_since_quit ,	contact_for_genetic_research ,	 date_referral_withdrawn, 	 consent_method ,	 consent_version 	, surgery 	, acq_tissue_collected, 	 ttr_appt_datetime ,	 path_spec, 	 acquisition_id ,	 referral_memo , mrn,	consent_status,	or_datetime	,	 decline_use_of_blood_samples ,	 BRT_flag  
FROM consents;

#----------------------------------------------------------
-- COLLECTIONS and SAMPLES (Blood Tubes and Virtual Tissue) 
#------------------------------------------------------------

INSERT INTO atim.collections
(id, acquisition_label, bc_ttr_collected_by, collection_datetime, collection_site, collection_notes, bc_ttr_collection_type, created, created_by, modified, modified_by, bc_ttr_tissue_collection_status, bc_ttr_blood_collection_status )
SELECT id, acquisition_label, collected_by, collection_datetime, collection_site, collection_notes, 
collection_type,     created, created_by, modified, modified_by, tissue_collection_status, 
blood_collection_status
FROM collections;


-- Drop Constraint in Unique Sample code in ATIM sample masters - we need to put this constraint back after the following transaction
ALTER TABLE `atim`.`sample_masters`   
 DROP INDEX  `unique_sample_code`;

-- ATIM sample_masters
INSERT INTO atim.sample_masters( id, collection_id , sample_control_id, sample_category)
SELECT id , id,  IF ( collection_type = 'blood', 2, 3), 'specimen'
FROM collections;


-- Update the sample code  ( B - Blood, T - Tissue)

UPDATE atim.sample_masters
SET sample_code = CONCAT( 'B - ' , id)  
WHERE sample_control_id = 2;


UPDATE atim.sample_masters
SET sample_code = CONCAT( 'T - ' , id)  
WHERE sample_control_id = 3;


-- Put Constraint back as Unique Sample code in ATIM sample masters - we need to put this constraint back after the following transaction
CREATE UNIQUE INDEX unique_sample_code ON atim.sample_masters ( sample_code );


-- ATIM specimen_details
INSERT INTO atim.specimen_details( id, sample_master_id, reception_by, reception_datetime )
SELECT sm.id, sm.id , col.tb_received_by, col.tb_received_datetime
FROM atim.sample_masters sm, collections col 
WHERE sm.collection_id = col.id ;


-- ATIM sd_spe_bloods
INSERT INTO atim.sd_spe_bloods( id, sample_master_id, collected_tube_nbr, bc_ttr_blood_drawn_datetime, bc_ttr_room_temperature )
SELECT sm.id, sm.id, col.number_of_blood_tubes , col.blood_drawn_datetime, col.room_temperature
FROM atim.sample_masters sm, collections col 
WHERE sm.collection_id = col.id 
and col.collection_type = 'blood';


-- ATIM sd_spe_tissues
INSERT INTO atim.sd_spe_tissues( id, sample_master_id, bc_ttr_time_anaesthesia_ready, bc_ttr_time_incision, bc_ttr_collection_pathologist, bc_ttr_after_hour_collection )
SELECT sm.id, sm.id, col.time_anaesthesia_ready , col.time_incision, col.pathologist, col.after_hour_collection
FROM atim.sample_masters sm, collections col 
WHERE sm.collection_id = col.id 
and col.collection_type = 'tissue';



-- UPDATE sample_master sample_type for tissue and blood

update sample_masters
set sample_type = 'blood'
where sample_code LIKE '%B -%'
and sample_control_id = 2;

update sample_masters
set sample_type = 'tissue'
where sample_code LIKE '%T -%'
and sample_control_id = 3;


-- update parent id of blood cell
update sample_masters sm1 , sample_masters sm2
set sm2.parent_id = sm1.id
where sm2.collection_id = sm1.collection_id
and sm1.sample_control_id = 2
and sm2.sample_control_id = 7

-- update parent id of plasma
update sample_masters sm1 , sample_masters sm2
set sm2.parent_id = sm1.id
where sm2.collection_id = sm1.collection_id
and sm1.sample_control_id = 2
and sm2.sample_control_id = 9





#-------------
-- Blood Cells
#-------------

-- Drop Constraint in Unique Sample code in ATIM sample masters

ALTER TABLE  atim.`sample_masters` DROP INDEX  `unique_sample_code`;


-- Insert into table  for Blood Cells (Buffy Coat) specimen
INSERT INTO atim.sample_masters
(sample_category, sample_control_id, sample_type, initial_specimen_sample_type, collection_id, bc_ttr_ttrdb_acquisition_label, bc_ttr_buffy_coat_lab_tech )
SELECT 
'derivative','7', 'blood cell', 'blood', tcol.id,  
tcol.acquisition_label, tcol.buffy_coat_lab_tech
FROM  ttrdb.collections tcol  
WHERE  
( SELECT Count(*) FROM ttrdb.sample_masters tsm WHERE tsm.collection_id =  tcol.id AND tsm.sample_type = 'buffy_coat' ) > 0 ;


UPDATE atim.sample_masters
SET sample_code = CONCAT( 'BLD-C - ' , id)  
WHERE sample_control_id = 7;

-- Put Constraint back as Unique Sample code in ATIM sample masters
CREATE UNIQUE INDEX unique_sample_code ON atim.sample_masters ( sample_code );

-- Insert Blood Cell (Buffy Coat) Derivative into sample detail table
INSERT INTO atim.sd_der_blood_cells (sample_master_id, bc_ttr_buffy_coat_lab_tech )
SELECT smt.id, smt.bc_ttr_buffy_coat_lab_tech
FROM atim.sample_masters smt
WHERE smt.sample_code LIKE '%BLD-C%';
 
 
 
#------------------
-- PLASMA
#-----------------


-- Drop Constraint Unique Sample code in ATIM sample masters - we need to put this constraint back after the following transaction
ALTER TABLE  atim.`sample_masters` DROP INDEX  `unique_sample_code`;

-- Insert into  table  for Plasma Derivative Sample 
INSERT INTO atim.sample_masters
(sample_category, sample_control_id, sample_type, initial_specimen_sample_type, collection_id,  bc_ttr_ttrdb_acquisition_label, bc_ttr_plasma_lab_tech, bc_ttr_plasma_duration, bc_ttr_plasma_Gval, bc_ttr_plasma_temperature, bc_ttr_plasma_transporter_time )
SELECT 
'derivative','9', 'plasma', 'blood', tcol.id, 
tcol.acquisition_label, tcol.plasma_lab_tech, tcol.plasma_duration, tcol.plasma_Gval,
tcol.plasma_temperature, tcol.plasma_transporter_time
FROM  ttrdb.collections tcol  
WHERE  
( SELECT Count(*) FROM ttrdb.sample_masters tsm WHERE tsm.collection_id =  tcol.id AND tsm.sample_type = 'plasma' ) > 0 ;



UPDATE atim.sample_masters
SET sample_code = CONCAT( 'PLS - ' , id)  
WHERE sample_control_id = 9;


-- Put Constraint back as Unique Sample code in ATIM sample masters - we need to put this constraint back after the following transaction
CREATE UNIQUE INDEX unique_sample_code ON atim.sample_masters ( sample_code );


-- Insert Plasma Derivatives
INSERT INTO atim.sd_der_plasmas (sample_master_id, bc_ttr_plasma_lab_tech, bc_ttr_plasma_duration, 
 bc_ttr_plasma_Gval, bc_ttr_plasma_temperature, bc_ttr_plasma_transporter_time  )
SELECT smt.id, smt.bc_ttr_plasma_lab_tech, smt.bc_ttr_plasma_duration, smt.bc_ttr_plasma_Gval, smt.bc_ttr_plasma_temperature, smt.bc_ttr_plasma_transporter_time
FROM atim.sample_masters smt
WHERE smt.sample_code LIKE '%PLS%';
 


#---------------------
-- tissues blocks
-- TODO: invalid entries - the 2 following queries show that there are some invalid records
#select count(*) from sd_tissueblocks;
#select count(*) from sd_tissueblocks as st inner join sample_masters as sm on st.sample_master_id=sm.id;
-- WARNING: DELETING INVALID RECORDS, DECIDE IF ITS RIGHT OR WRONG
DELETE FROM sd_tissueblocks WHERE sample_master_id NOT IN(SELECT id FROM sample_masters);
ALTER TABLE atim.aliquot_masters
 ADD COLUMN tmp_id int DEFAULT NULL,
 ADD COLUMN tmp_slide_id int DEFAULT NULL,
 ADD COLUMN bc_ttr_prev_storage_id int DEFAULT NULL,
 ADD KEY (tmp_id),
 ADD KEY (tmp_slide_id);

CREATE TABLE atim.tmp_blocks (SELECT barcode, storage_master_id, bc_ttr_prev_storage_id, storage_coord_x, storage_coord_y, storage_datetime, 
sample_master_id , aliquot_type , aliquot_control_id ,collection_id, a.created, a.created_by    , a.modified , a.modified_by, 
 bc_ttr_tissue_site , bc_ttr_tissue_type , bc_ttr_tissue_subsite , bc_ttr_size_of_tumour , bc_ttr_tissue_observation , bc_ttr_time_of_removal , bc_ttr_page_time , bc_ttr_tissue_arrival_in_patho_lab , bc_ttr_pathologist_presence , bc_ttr_tissue_in_transporter , bc_ttr_transporter , bc_ttr_path_reference , bc_ttr_size1 , bc_ttr_size2 , bc_ttr_size3 ,bc_ttr_block_observation, block_type
 FROM atim.aliquot_masters AS a INNER JOIN atim.ad_blocks LIMIT 0);
ALTER TABLE atim.tmp_blocks ADD column tid int auto_increment primary key;
INSERT INTO atim.tmp_blocks (barcode, storage_master_id, bc_ttr_prev_storage_id, storage_coord_x, storage_coord_y, storage_datetime, aliquot_type , aliquot_control_id ,collection_id, created, created_by, modified , modified_by, bc_ttr_tissue_site , bc_ttr_tissue_type , bc_ttr_tissue_subsite , bc_ttr_size_of_tumour , bc_ttr_tissue_observation , bc_ttr_time_of_removal , bc_ttr_page_time , bc_ttr_tissue_arrival_in_patho_lab , bc_ttr_pathologist_presence , bc_ttr_tissue_in_transporter , bc_ttr_transporter , bc_ttr_path_reference , bc_ttr_size1 , bc_ttr_size2 , bc_ttr_size3 ,bc_ttr_block_observation, block_type, tid)  
(SELECT sample_barcode, box_id, previous_box_id, row_id, col_id, stored_datetime ,'block',4, collection_id, sm.created, sm.created_by    , sm.modified , sm.modified_by, tissue_type_id , tissue_site_id , tissue_subsite_id , size_of_tumour , tissue_observation , tissue_removal_time , page_time , tissue_arrival_pathlab_time , pathologist_presence_time , tissue_into_transporter_time , transporter , path_ref , size1 , size2 , size3 , block_observation, sample_type, sm.id FROM sd_tissueblocks INNER JOIN sample_masters AS sm ON sd_tissueblocks.sample_master_id=sm.id);

UPDATE atim.tmp_blocks AS c
LEFT JOIN atim.storage_masters AS p ON c.storage_master_id=p.box_id
SET c.storage_master_id=p.id;
UPDATE atim.tmp_blocks AS c
LEFT JOIN atim.sample_masters AS p ON p.collection_id=c.collection_id
SET c.sample_master_id=p.id;

INSERT INTO atim.aliquot_masters (barcode, storage_master_id, bc_ttr_prev_storage_id, storage_coord_x, storage_coord_y, storage_datetime, collection_id, sample_master_id , aliquot_type , aliquot_control_id ,created, created_by    , modified , modified_by, tmp_id)
(SELECT barcode, storage_master_id, bc_ttr_prev_storage_id, storage_coord_x, storage_coord_y, storage_datetime, collection_id, sample_master_id, aliquot_type , aliquot_control_id , created, created_by    , modified , modified_by, tid FROM atim.tmp_blocks);
INSERT INTO atim.ad_blocks (aliquot_master_id, created, created_by    , modified , modified_by, bc_ttr_tissue_site , bc_ttr_tissue_type , bc_ttr_tissue_subsite , bc_ttr_size_of_tumour , bc_ttr_tissue_observation , bc_ttr_time_of_removal , bc_ttr_page_time , bc_ttr_tissue_arrival_in_patho_lab , bc_ttr_pathologist_presence , bc_ttr_tissue_in_transporter , bc_ttr_transporter , bc_ttr_path_reference , bc_ttr_size1 , bc_ttr_size2 , bc_ttr_size3 ,bc_ttr_block_observation, block_type)
(SELECT p.id, c.created, c.created_by, c.modified , c.modified_by, bc_ttr_tissue_site , bc_ttr_tissue_type , bc_ttr_tissue_subsite , bc_ttr_size_of_tumour , bc_ttr_tissue_observation , bc_ttr_time_of_removal , bc_ttr_page_time , bc_ttr_tissue_arrival_in_patho_lab , bc_ttr_pathologist_presence , bc_ttr_tissue_in_transporter , bc_ttr_transporter , bc_ttr_path_reference , bc_ttr_size1 , bc_ttr_size2 , bc_ttr_size3 ,bc_ttr_block_observation, block_type FROM atim.tmp_blocks AS c INNER JOIN atim.aliquot_masters AS p ON c.tid=p.tmp_id);
DROP TABLE atim.tmp_blocks;




-- tissues slides
-- WARNING: DELETEING INVALID sample_master RECORD
DELETE FROM sample_masters WHERE id=43301;
DELETE FROM sd_tissueslides WHERE sample_master_id=43301;
-- WARNING: DELETING INVALID RECORDS, DECIDE IF ITS RIGHT OR WRONG (seen with SELECT count(*) FROM sd_tissueslides WHERE sample_master_id NOT IN(SELECT id FROM sample_masters);)
DELETE FROM sd_tissueslides WHERE sample_master_id NOT IN(SELECT id FROM sample_masters);
CREATE TABLE atim.tmp_slides(SELECT  barcode     , aliquot_type , aliquot_control_id , collection_id , sample_master_id, in_stock , storage_datetime    , storage_master_id , storage_coord_x , storage_coord_y , product_code , notes , bc_ttr_prev_storage_id , bc_ttr_date_created ,bc_ttr_slide_stain , bc_ttr_slide_location , bc_ttr_lab_technician , bc_ttr_time_removed_from_formalin, p.created   , p.created_by    , p.modified , p.modified_by FROM atim.aliquot_masters AS p LEFT JOIN atim.ad_tissue_slides ON NULL LIMIT 0);
ALTER TABLE atim.tmp_slides
 ADD COLUMN tid int DEFAULT NULL,
 ADD COLUMN old_sample_id int DEFAULT NULL;
 
INSERT INTO atim.tmp_slides (barcode     , aliquot_type , aliquot_control_id , collection_id , in_stock , storage_datetime    , storage_master_id , storage_coord_x , storage_coord_y , notes , bc_ttr_prev_storage_id , bc_ttr_date_created ,bc_ttr_slide_stain , bc_ttr_slide_location , bc_ttr_lab_technician , bc_ttr_time_removed_from_formalin, created   , created_by    , modified , modified_by, tid, old_sample_id)
(SELECT  sample_barcode ,'slide',5, collection_id, sample_status, stored_datetime     , box_id , row_id , col_id , slide_notes , previous_box_id , date_slide_created , slide_stain , current_slide_location , lab_tech, time_removed_from_formalin , p.created             , p.created_by    , p.modified , p.modified_by , p.id, parent_sample_id FROM sample_masters AS p INNER JOIN sd_tissueslides AS c ON c.sample_master_id=p.id); 
UPDATE atim.tmp_slides AS c
LEFT JOIN atim.storage_masters AS p ON c.storage_master_id=p.box_id
SET c.storage_master_id=p.id;
UPDATE atim.tmp_slides AS c
LEFT JOIN atim.aliquot_masters AS p ON p.tmp_id=c.old_sample_id
SET c.sample_master_id=p.sample_master_id;

INSERT INTO atim.aliquot_masters (barcode     , aliquot_type , aliquot_control_id , collection_id , in_stock , storage_datetime    , storage_master_id , storage_coord_x , storage_coord_y , notes , bc_ttr_prev_storage_id, created   , created_by    , modified , modified_by, sample_master_id, tmp_slide_id)
(SELECT barcode, aliquot_type , aliquot_control_id , collection_id , in_stock , storage_datetime    , storage_master_id , storage_coord_x , storage_coord_y , notes , bc_ttr_prev_storage_id, created   , created_by    , modified , modified_by, sample_master_id, tid FROM atim.tmp_slides); 
INSERT INTO atim.ad_tissue_slides(aliquot_master_id, bc_ttr_date_created ,bc_ttr_slide_stain , bc_ttr_slide_location , bc_ttr_lab_technician , bc_ttr_time_removed_from_formalin)
(SELECT p.id, bc_ttr_date_created ,bc_ttr_slide_stain , bc_ttr_slide_location , bc_ttr_lab_technician , bc_ttr_time_removed_from_formalin FROM atim.tmp_slides AS c INNER JOIN atim.aliquot_masters AS p on c.tid=p.tmp_slide_id);
ALTER TABLE atim.aliquot_uses 
 ADD COLUMN child_id int default null,
 ADD INDEX (child_id);
INSERT INTO atim.aliquot_uses(aliquot_master_id, use_definition, use_recorded_into_table, child_id, use_code)
(SELECT p.id, "realiquoted to", "realiquotings", c.tid, c.barcode FROM atim.tmp_slides AS c INNER JOIN atim.aliquot_masters AS p ON c.old_sample_id=p.tmp_id);
INSERT INTO atim.realiquotings(parent_aliquot_master_id, child_aliquot_master_id, aliquot_use_id)
(SELECT c.aliquot_master_id, p.id, c.id FROM atim.aliquot_uses AS c INNER JOIN atim.aliquot_masters AS p ON c.child_id=p.tmp_slide_id);
ALTER TABLE atim.aliquot_uses 
 DROP child_id;

-- TODO: create a rev for aliquots with an old box id

-- TODO: rebuild lft/rgt for storages. See scripts/utilities/rebuildLeftRight.php
-- TODO: populate revs tables











ALTER TABLE atim.storage_masters
 ADD UNIQUE KEY `unique_code` (`code`),
 DROP COLUMN old_id,
 DROP COLUMN tower_id,
 DROP COLUMN box_id;
