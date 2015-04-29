-- ----------------------------------------------------------------------------------------------------
-- Procure Form Identification update
-- ----------------------------------------------------------------------------------------------------

select count(*) '### MESSAGE ### Nbr of drugs already created. Migration script should be reviewed if different than 0' from procure_txe_medications;

-- ----------------------------------------------------------------------------------------------------
-- Procure Form Identification update
-- ----------------------------------------------------------------------------------------------------

SELECT 'Updated treatment/clincial event follow-up form label to ...Vx -FSPx' AS '### MESSAGE ###';

-- Procure Form Identification update : treatment

UPDATE treatment_masters TreatmentMaster, participants Participant, treatment_controls TreatmentControl
SET TreatmentMaster.procure_form_identification = CONCAT (Participant.participant_identifier, ' Vx -FSPx')
WHERE Participant.id = TreatmentMaster.participant_id 
AND TreatmentMaster.treatment_control_id = TreatmentControl.id
AND TreatmentControl.tx_method = 'procure follow-up worksheet - treatment';

UPDATE treatment_masters_revs TreatmentMaster, participants Participant, treatment_controls TreatmentControl
SET TreatmentMaster.procure_form_identification = CONCAT (Participant.participant_identifier, ' Vx -FSPx')
WHERE Participant.id = TreatmentMaster.participant_id 
AND TreatmentMaster.treatment_control_id = TreatmentControl.id
AND TreatmentControl.tx_method = 'procure follow-up worksheet - treatment';

-- Procure Form Identification update : event

UPDATE event_masters EventMaster, event_controls EventControl, participants Participant
SET EventMaster.procure_form_identification = CONCAT (Participant.participant_identifier, ' Vx -FSPx')
WHERE Participant.id = EventMaster.participant_id 
AND EventMaster.event_control_id = EventControl.id
AND EventControl.event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event');

UPDATE event_masters_revs EventMaster, event_controls EventControl, participants Participant
SET EventMaster.procure_form_identification = CONCAT (Participant.participant_identifier, ' Vx -FSPx')
WHERE Participant.id = EventMaster.participant_id 
AND EventMaster.event_control_id = EventControl.id
AND EventControl.event_type IN ('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event');

-- ----------------------------------------------------------------------------------------------------
-- Copy Follow-up Id Confirmation Date to note
-- ----------------------------------------------------------------------------------------------------

SELECT 'Copied the Follow-up Id Confirmation Date to note and removed it' AS '### MESSAGE ###';

SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn');

SELECT count(*) AS '### MESSAGE ### Nbr of deleted followup worksheets with no information' 
FROM event_masters EventMaster, procure_ed_clinical_followup_worksheets EventDetail 
WHERE EventMaster.deleted <> 1 
AND EventDetail.event_master_id = EventMaster.id
AND (EventMaster.event_date IS NULL OR EventMaster.event_date LIKE '') 
AND (EventDetail.id_confirmation_date IS NULL OR EventDetail.id_confirmation_date LIKE '') 
AND (EventDetail.biochemical_recurrence IS NULL OR EventDetail.biochemical_recurrence IN ('','n')) 
AND (EventDetail.clinical_recurrence IS NULL OR EventDetail.clinical_recurrence IN ('','n')) 
AND (EventDetail.surgery_for_metastases IS NULL OR EventDetail.surgery_for_metastases IN ('','n')) 
AND (EventDetail.clinical_recurrence_type IS NULL OR EventDetail.clinical_recurrence_type LIKE '') 
AND (EventDetail.clinical_recurrence_site IS NULL OR EventDetail.clinical_recurrence_site LIKE '') 
AND (EventDetail.surgery_site IS NULL OR EventDetail.surgery_site LIKE '') 
AND (EventMaster.event_summary IS NULL OR EventMaster.event_summary LIKE '') 
AND (EventDetail.surgery_date IS NULL OR EventDetail.surgery_date LIKE '')
AND EventMaster.deleted <> 1;

UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheets EventDetail 
SET deleted = 1, modified = @modified, modified_by = @modified_by
WHERE EventMaster.deleted <> 1 
AND EventDetail.event_master_id = EventMaster.id
AND (EventMaster.event_date IS NULL OR EventMaster.event_date LIKE '') 
AND (EventDetail.id_confirmation_date IS NULL OR EventDetail.id_confirmation_date LIKE '') 
AND (EventDetail.biochemical_recurrence IS NULL OR EventDetail.biochemical_recurrence IN ('','n')) 
AND (EventDetail.clinical_recurrence IS NULL OR EventDetail.clinical_recurrence IN ('','n')) 
AND (EventDetail.surgery_for_metastases IS NULL OR EventDetail.surgery_for_metastases IN ('','n')) 
AND (EventDetail.clinical_recurrence_type IS NULL OR EventDetail.clinical_recurrence_type LIKE '') 
AND (EventDetail.clinical_recurrence_site IS NULL OR EventDetail.clinical_recurrence_site LIKE '') 
AND (EventDetail.surgery_site IS NULL OR EventDetail.surgery_site LIKE '') 
AND (EventMaster.event_summary IS NULL OR EventMaster.event_summary LIKE '') 
AND (EventDetail.surgery_date IS NULL OR EventDetail.surgery_date LIKE '')
AND EventMaster.deleted <> 1;

SELECT count(*) AS '### MESSAGE ### Nbr of followup worksheets with id confirmation date (date will be moved to notes)' 
FROM event_masters EventMaster, procure_ed_clinical_followup_worksheets EventDetail 
WHERE EventMaster.deleted <> 1 
AND EventDetail.event_master_id = EventMaster.id
AND (EventDetail.id_confirmation_date IS NOT NULL AND EventDetail.id_confirmation_date NOT LIKE '');

UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheets EventDetail 
SET EventMaster.event_summary = CONCAT('ID Confirmation Date : ', EventDetail.id_confirmation_date, '. ', EventMaster.event_summary), 
modified = @modified, modified_by = @modified_by
WHERE EventMaster.deleted <> 1 
AND EventDetail.event_master_id = EventMaster.id
AND (EventDetail.id_confirmation_date IS NOT NULL AND EventDetail.id_confirmation_date NOT LIKE '')
AND EventMaster.event_summary IS NOT NULL;

UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheets EventDetail 
SET EventMaster.event_summary = CONCAT('ID Confirmation Date : ', EventDetail.id_confirmation_date, '. '), 
modified = @modified, modified_by = @modified_by
WHERE EventMaster.deleted <> 1 
AND EventDetail.event_master_id = EventMaster.id
AND (EventDetail.id_confirmation_date IS NOT NULL AND EventDetail.id_confirmation_date NOT LIKE '')
AND EventMaster.event_summary IS NULL;

UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheets EventDetail 
SET EventDetail.id_confirmation_date = NULL, EventDetail.id_confirmation_date_accuracy = ''
WHERE EventMaster.deleted <> 1 
AND EventDetail.event_master_id = EventMaster.id
AND (EventDetail.id_confirmation_date IS NOT NULL AND EventDetail.id_confirmation_date NOT LIKE '');

INSERT INTO event_masters_revs (id, participant_id, diagnosis_master_id, event_control_id, event_summary, event_date, event_date_accuracy, procure_form_identification, modified_by, version_created)
(SELECT id, participant_id, diagnosis_master_id, event_control_id, event_summary, event_date, event_date_accuracy, procure_form_identification, modified_by, modified 
FROM event_masters EventMaster, procure_ed_clinical_followup_worksheets EventDetail WHERE EventDetail.event_master_id = EventMaster.id AND modified = @modified AND modified_by = @modified_by);

INSERT INTO procure_ed_clinical_followup_worksheets_revs (id_confirmation_date,id_confirmation_date_accuracy,patient_identity_verified,biochemical_recurrence,clinical_recurrence,clinical_recurrence_type,clinical_recurrence_site,
surgery_for_metastases,surgery_site,surgery_date,surgery_date_accuracy,event_master_id,version_created)
(SELECT id_confirmation_date,id_confirmation_date_accuracy,patient_identity_verified,biochemical_recurrence,clinical_recurrence,clinical_recurrence_type,clinical_recurrence_site,
surgery_for_metastases,surgery_site,surgery_date,surgery_date_accuracy,event_master_id, modified 
FROM event_masters EventMaster, procure_ed_clinical_followup_worksheets EventDetail WHERE EventDetail.event_master_id = EventMaster.id AND modified = @modified AND modified_by = @modified_by);

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Whatman paper initial storage date moved to note...
-- -----------------------------------------------------------------------------------------------------------------------------------------------

SELECT 'Copied the Whatman paper initial storage date to note and removed it' AS '### MESSAGE ###';

SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn');

UPDATE aliquot_masters AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.notes = CONCAT(AliquotMaster.notes," La date d'entreposage saisie était : ", SUBSTRING(AliquotMaster.storage_datetime, 1, 16)),
modified = @modified, modified_by = @modified_by
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.storage_datetime IS NOT NULL AND AliquotMaster.notes IS NOT NULL AND AliquotMaster.notes NOT LIKE '';

UPDATE aliquot_masters AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.notes = CONCAT("La date d'entreposage saisie était : ", SUBSTRING(AliquotMaster.storage_datetime, 1, 16)),
modified = @modified, modified_by = @modified_by
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.storage_datetime IS NOT NULL AND (AliquotMaster.notes IS NULL OR AliquotMaster.notes LIKE '');

UPDATE aliquot_masters AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.storage_datetime = null, AliquotMaster.storage_datetime_accuracy = null,
modified = @modified, modified_by = @modified_by
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.storage_datetime IS NOT NULL;

INSERT INTO aliquot_masters_revs (id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
modified_by,version_created)
(SELECT id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
modified_by,modified FROM aliquot_masters INNER JOIN ad_whatman_papers ON id = aliquot_master_id WHERE  modified = @modified AND modified_by = @modified_by);

INSERT INTO ad_whatman_papers_revs (aliquot_master_id,used_blood_volume,used_blood_volume_unit,procure_card_sealed_date,procure_card_sealed_date_accuracy,
procure_card_completed_at,version_created)
(SELECT aliquot_master_id,used_blood_volume,used_blood_volume_unit,procure_card_sealed_date,procure_card_sealed_date_accuracy,
procure_card_completed_at,modified
FROM aliquot_masters INNER JOIN ad_whatman_papers ON id = aliquot_master_id WHERE  modified = @modified AND modified_by = @modified_by);
