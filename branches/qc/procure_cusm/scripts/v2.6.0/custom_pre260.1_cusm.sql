DELETE FROM structure_value_domains_permissible_values WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name='procure_pellet_aspect_after_centrifugation') AND structure_permissible_value_id IN (SELECT id FROM structure_permissible_values WHERE value IN ('turbidity', 'clear'));

SELECT count(*) AS '### TO VALIDATE ### Nbr of order record (should be equalt to 0)' FROM orders WHERE deleted <> 1;

SELECT count(*) AS '### TO VALIDATE ### Nbr of quality control record (should be equalt to 0)' FROM quality_ctrls WHERE deleted <> 1;

SELECT count(*) AS '### TO VALIDATE ### Nbr of study record (should be equalt to 0)' FROM study_summaries WHERE deleted <> 1;

UPDATE structure_permissible_values_custom_controls 
SET flag_active = 0
WHERE name IN ('Orders Institutions', 'Orders Contacts', 'Quality Control Tools', 'Laboratory Sites', 'Specimen Collection Sites', 'Specimen Supplier Departments');

UPDATE aliquot_masters SET barcode = REPLACE(barcode, 'V01-', 'V01 -') WHERE barcode IN  ('PS3P0506 V01-WHT1','PS3P0508 V01-PLA1','PS3P0508 V01-PLA2','PS3P0508 V01-PLA3');
UPDATE aliquot_masters_revs SET barcode = REPLACE(barcode, 'V01-', 'V01 -') WHERE barcode IN  ('PS3P0506 V01-WHT1','PS3P0508 V01-PLA1','PS3P0508 V01-PLA2','PS3P0508 V01-PLA3');

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Clean Up PROCURE Form identification
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Consent

SELECT CONCAT('Consent: ',ConsentMaster.procure_form_identification) AS '### TO VALIDATE ### Updated consent identification to V01 -CSF1'
FROM consent_masters ConsentMaster
INNER JOIN participants Participant ON Participant.id = ConsentMaster.participant_id
WHERE ConsentMaster.deleted <> 1 AND ConsentMaster.procure_form_identification != CONCAT(Participant.participant_identifier, ' V01 -CSF1');

UPDATE consent_masters ConsentMaster, participants Participant
SET ConsentMaster.procure_form_identification = CONCAT(Participant.participant_identifier, ' V01 -CSF1')
WHERE Participant.id = ConsentMaster.participant_id AND ConsentMaster.deleted <> 1 AND ConsentMaster.procure_form_identification != CONCAT(Participant.participant_identifier, ' V01 -CSF1');
UPDATE consent_masters ConsentMaster, consent_masters_revs ConsentMasterRevs
SET ConsentMasterRevs.procure_form_identification = ConsentMaster.procure_form_identification
WHERE ConsentMasterRevs.procure_form_identification != ConsentMaster.procure_form_identification AND ConsentMasterRevs.id = ConsentMaster.id;

-- Event 'procure follow-up worksheet - clinical event', 'procure follow-up worksheet - aps', 'procure follow-up worksheet - other tumor dx', 'procure follow-up worksheet - clinical note'

SELECT CONCAT(EventControl.event_type, ' : ', count(*)) AS  '### TO VALIDATE ### Updated event identification to Vx -FSPx'
FROM event_masters EventMaster, event_controls EventControl, participants Participant
WHERE EventMaster.event_control_id = EventControl.id
AND Participant.id = EventMaster.participant_id
AND procure_form_identification != CONCAT(Participant.participant_identifier, ' Vx -FSPx')
AND EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure follow-up worksheet - clinical event', 'procure follow-up worksheet - aps', 'procure follow-up worksheet - other tumor dx', 'procure follow-up worksheet - clinical note')
GROUP BY EventControl.event_type;

UPDATE event_masters EventMaster, event_controls EventControl, participants Participant
SET procure_form_identification = CONCAT(Participant.participant_identifier, ' Vx -FSPx')
WHERE EventMaster.event_control_id = EventControl.id
AND Participant.id = EventMaster.participant_id
AND procure_form_identification != CONCAT(Participant.participant_identifier, ' Vx -FSPx')
AND EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure follow-up worksheet - clinical event', 'procure follow-up worksheet - aps', 'procure follow-up worksheet - other tumor dx', 'procure follow-up worksheet - clinical note');

-- Event : procure pathology report

SELECT CONCAT(EventControl.event_type, ' : ', count(*)) AS  '### TO VALIDATE ### Updated event identification to V01 -PST1'
FROM event_masters EventMaster, event_controls EventControl, participants Participant
WHERE EventMaster.event_control_id = EventControl.id
AND Participant.id = EventMaster.participant_id
AND procure_form_identification != CONCAT(Participant.participant_identifier, ' V01 -PST1')
AND EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure pathology report')
GROUP BY EventControl.event_type;

UPDATE event_masters EventMaster, event_controls EventControl, participants Participant
SET procure_form_identification = CONCAT(Participant.participant_identifier, ' V01 -PST1')
WHERE EventMaster.event_control_id = EventControl.id
AND Participant.id = EventMaster.participant_id
AND procure_form_identification != CONCAT(Participant.participant_identifier, ' V01 -PST1')
AND EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure pathology report');

-- Event : procure diagnostic information worksheet

SELECT CONCAT(EventControl.event_type, ' : ', count(*)) AS  '### TO VALIDATE ### Updated event identification to V01 -FBP1'
FROM event_masters EventMaster, event_controls EventControl, participants Participant
WHERE EventMaster.event_control_id = EventControl.id
AND Participant.id = EventMaster.participant_id
AND procure_form_identification != CONCAT(Participant.participant_identifier, ' V01 -FBP1')
AND EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure diagnostic information worksheet')
GROUP BY EventControl.event_type;

UPDATE event_masters EventMaster, event_controls EventControl, participants Participant
SET procure_form_identification = CONCAT(Participant.participant_identifier, ' V01 -FBP1')
WHERE EventMaster.event_control_id = EventControl.id
AND Participant.id = EventMaster.participant_id
AND procure_form_identification != CONCAT(Participant.participant_identifier, ' V01 -FBP1')
AND EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure diagnostic information worksheet');

-- Event : procure questionnaire administration worksheet

SELECT CONCAT(EventControl.event_type, ' : ', procure_form_identification) AS  '### TO VALIDATE ### Updated event identification to V01 -QUE1'
FROM event_masters EventMaster, event_controls EventControl, participants Participant
WHERE EventMaster.event_control_id = EventControl.id
AND Participant.id = EventMaster.participant_id
AND procure_form_identification != CONCAT(Participant.participant_identifier, ' V01 -QUE1')
AND EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure questionnaire administration worksheet');

UPDATE event_masters EventMaster, event_controls EventControl, participants Participant
SET procure_form_identification = CONCAT(Participant.participant_identifier, ' V01 -QUE1')
WHERE EventMaster.event_control_id = EventControl.id
AND Participant.id = EventMaster.participant_id
AND procure_form_identification != CONCAT(Participant.participant_identifier, ' V01 -QUE1')
AND EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure questionnaire administration worksheet');

-- Event : procure questionnaire administration worksheet

-- Has to be done manually by Lucie
-- SELECT CONCAT(EventControl.event_type, ' : ', procure_form_identification) AS  '### TO VALIDATE ### Wrong event identification'
-- FROM event_masters EventMaster, event_controls EventControl, participants Participant
-- WHERE EventMaster.event_control_id = EventControl.id
-- AND Participant.id = EventMaster.participant_id
-- AND procure_form_identification NOT REGEXP CONCAT('^',Participant.participant_identifier, '\ V((0[1-9])|(1[0-9]))\ -FSP1$')
-- AND EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure follow-up worksheet');

-- Event Revs

UPDATE event_masters EventMaster, event_masters_revs EventMasterRevs
SET EventMasterRevs.procure_form_identification = EventMaster.procure_form_identification
WHERE EventMasterRevs.procure_form_identification != EventMaster.procure_form_identification AND EventMasterRevs.id = EventMaster.id;

-- Treatment

SELECT CONCAT(TreatmentControl.tx_method, ' : ', count(*)) AS  '### TO VALIDATE ### Updated treatment follow-up to Vx -FSPx'
FROM treatment_masters TreatmentMaster,  treatment_controls TreatmentControl, participants Participant
WHERE TreatmentControl.id = TreatmentMaster.treatment_control_id
AND Participant.id = TreatmentMaster.participant_id
AND procure_form_identification != CONCAT(Participant.participant_identifier, ' Vx -FSPx')
AND TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure follow-up worksheet - treatment'
GROUP BY TreatmentControl.tx_method;

UPDATE treatment_masters TreatmentMaster,  treatment_controls TreatmentControl, participants Participant
SET procure_form_identification = CONCAT(Participant.participant_identifier, ' Vx -FSPx')
WHERE TreatmentControl.id = TreatmentMaster.treatment_control_id
AND Participant.id = TreatmentMaster.participant_id
AND procure_form_identification != CONCAT(Participant.participant_identifier, ' Vx -FSPx')
AND TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure follow-up worksheet - treatment';

-- Treatment Revs

UPDATE treatment_masters TreatmentMaster, treatment_masters_revs TreatmentMasterRevs
SET TreatmentMasterRevs.procure_form_identification = TreatmentMaster.procure_form_identification
WHERE TreatmentMasterRevs.procure_form_identification != TreatmentMaster.procure_form_identification AND TreatmentMasterRevs.id = TreatmentMaster.id;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 'run custom_pre260.2_cusm.php' AS 'TODO';