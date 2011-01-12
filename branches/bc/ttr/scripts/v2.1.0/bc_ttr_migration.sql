

-- ATIM Participants
INSERT INTO atim.participants (id, title, first_name, middle_name, last_name, date_of_birth, sex, bc_ttr_phn, notes,  created, created_by, modified, modified_by)
SELECT id, salutation, first_name, usual_name, last_name, date_of_birth, sex, phn, memo,created, created_by, modified, modified_by
FROM participants;


-- Temporary Fix for all orphan consents to Jane Doe participant until we can sort this out with TTR Clinical staff (BRT)
UPDATE consents
SET participant_id = 1878
WHERE  participant_id IN ( 1649, 2099, 2100, 3021, 3154, 3198 )

-- ATIM Consents

INSERT INTO atim.consent_masters(id, date_of_referral , reason_denied ,  surgeon , bc_ttr_consent_closed , bc_ttr_protocol , bc_ttr_diagnosis , bc_ttr_cancer_type , bc_ttr_referral_source , bc_ttr_home_phone , bc_ttr_cell_phone , bc_ttr_work_phone , bc_ttr_fax_number , bc_ttr_email , bc_ttr_iroc_number , bc_ttr_iroc_flag , bc_ttr_pathologist , bc_ttr_consent_id, facility , consent_signed_date , bc_ttr_blood_collected , participant_id ,	 consent_control_id,  bc_ttr_date_consent_denied , bc_ttr_date_consent_withdrawn, created, 	 created_by, 	 modified ,	 modified_by ,  bc_ttr_smoking_history , bc_ttr_pack_years , bc_ttr_years_since_quit , bc_ttr_contact_for_genetic_research , bc_ttr_date_referral_withdrawn , consent_method , form_version , bc_ttr_surgery , bc_ttr_tissue_collected , bc_ttr_ttr_appt_datetime , bc_ttr_pathology_specification ,bc_ttr_acquisition_id,notes, bc_ttr_medical_record_no , process_status , operation_date ,	bc_ttr_decline_use_of_blood_samples , bc_ttr_brt_flag  )
SELECT id,  referral_datetime , reason_denied , surgeon , consent_closed ,   protocol , diagnosis       , cancer_type , referral_source , home_phone , cell_phone , work_phone , fax_number , email , IROC_number , IROC_flag , pathologist , consent_id , or_facility   , date_consent_signed , blood_collected , participant_id ,1, date_denied , date_withdrawn , created , created_by , modified , modified_by ,smoking_history ,	pack_years ,years_since_quit ,	contact_for_genetic_research ,	 date_referral_withdrawn, 	 consent_method ,	 consent_version 	, surgery 	, acq_tissue_collected, 	 ttr_appt_datetime ,	 path_spec, 	 acquisition_id ,	 referral_memo , mrn,	consent_status,	or_datetime	,	 decline_use_of_blood_samples ,	 BRT_flag  
FROM consents;

-- ATIM collections and specimens migration 

INSERT INTO atim.collections
(id, acquisition_label, bc_ttr_collected_by, collection_datetime, collection_site, collection_notes, bc_ttr_collection_type, created, created_by, modified, modified_by, bc_ttr_tissue_collection_status, bc_ttr_blood_collection_status )
SELECT id, acquisition_label, collected_by, collection_datetime, collection_site, collection_notes, 
collection_type,     created, created_by, modified, modified_by, tissue_collection_status, 
blood_collection_status
FROM collections


-- Drop Constraint in Unique Sample code in ATIM sample masters - we need to put this constraint back after the following transaction
ALTER TABLE  `sample_masters` DROP INDEX  `unique_sample_code`

-- ATIM sample_masters
INSERT INTO atim.sample_masters( id, collection_id , sample_control_id )
SELECT id , id,  IF ( collection_type = 'blood', 2, 3)
FROM collections


-- Update the sample code  ( B - Blood, T - Tissue)

UPDATE atim.sample_masters
SET sample_code = CONCAT( 'B - ' , id)  
WHERE sample_control_id = 2


UPDATE atim.sample_masters
SET sample_code = CONCAT( 'T - ' , id)  
WHERE sample_control_id = 3


-- Put Constraint back as Unique Sample code in ATIM sample masters - we need to put this constraint back after the following transaction
CREATE UNIQUE INDEX unique_sample_code ON atim.sample_masters ( sample_code );


-- ATIM specimen_details
INSERT INTO atim.specimen_details( id, sample_master_id, reception_by, reception_datetime )
SELECT sm.id, sm.id , col.tb_received_by, col.tb_received_datetime
FROM atim.sample_masters sm, collections col 
WHERE sm.collection_id = col.id 


-- ATIM sd_spe_bloods
INSERT INTO atim.sd_spe_bloods( id, sample_master_id, collected_tube_nbr, bc_ttr_blood_drawn_datetime, bc_ttr_room_temperature )
SELECT sm.id, sm.id, col.number_of_blood_tubes , col.blood_drawn_datetime, col.room_temperature
FROM atim.sample_masters sm, collections col 
WHERE sm.collection_id = col.id 
and col.collection_type = 'blood'


-- ATIM sd_spe_tissues
INSERT INTO atim.sd_spe_tissues( id, sample_master_id, bc_ttr_time_anaesthesia_ready, bc_ttr_time_incision, bc_ttr_collection_pathologist, bc_ttr_after_hour_collection )
SELECT sm.id, sm.id, col.time_anaesthesia_ready , col.time_incision, col.pathologist, col.after_hour_collection
FROM atim.sample_masters sm, collections col 
WHERE sm.collection_id = col.id 
and col.collection_type = 'tissue'





