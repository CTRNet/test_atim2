-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Clean up identifier + aliquot label
-- To run after atim_v2.6.5.sql & before custom_post265.sql
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Clean up clincial form identification to be consistent with the participant identifier

-- Consent

SELECT Participant.participant_identifier AS 'Update consent form of patient', 
ConsentMaster.procure_form_identification AS 'From', 
CONCAT(Participant.participant_identifier, SUBSTRING(ConsentMaster.procure_form_identification, LOCATE(' V', ConsentMaster.procure_form_identification))) AS 'To', 
ConsentMaster.id AS 'Record Id'
FROM participants Participant
INNER JOIN consent_masters ConsentMaster ON Participant.id = ConsentMaster.participant_id AND ConsentMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND ConsentMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier);

UPDATE participants Participant, consent_masters ConsentMaster
SET ConsentMaster.procure_form_identification = CONCAT(Participant.participant_identifier, SUBSTRING(ConsentMaster.procure_form_identification, LOCATE(' V', ConsentMaster.procure_form_identification)))
WHERE Participant.deleted <> 1 AND ConsentMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier) AND Participant.id = ConsentMaster.participant_id AND ConsentMaster.deleted <> 1;

UPDATE consent_masters ConsentMaster, consent_masters_revs ConsentMasterRevs
SET ConsentMasterRevs.procure_form_identification = ConsentMaster.procure_form_identification
WHERE ConsentMasterRevs.id = ConsentMaster.id 
AND ConsentMasterRevs.version_created = ConsentMaster.modified
AND ConsentMasterRevs.procure_form_identification != ConsentMaster.procure_form_identification;

-- Treatment

SELECT Participant.participant_identifier AS 'Update treatment form of patient', 
TreatmentMaster.procure_form_identification AS 'From', 
CONCAT(Participant.participant_identifier, SUBSTRING(TreatmentMaster.procure_form_identification, LOCATE(' V', TreatmentMaster.procure_form_identification))) AS 'To', 
TreatmentMaster.id AS 'Record Id'
FROM participants Participant
INNER JOIN treatment_masters TreatmentMaster ON Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND TreatmentMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier);

UPDATE participants Participant, treatment_masters TreatmentMaster
SET TreatmentMaster.procure_form_identification = CONCAT(Participant.participant_identifier, SUBSTRING(TreatmentMaster.procure_form_identification, LOCATE(' V', TreatmentMaster.procure_form_identification)))
WHERE Participant.deleted <> 1 AND TreatmentMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier) AND Participant.id = TreatmentMaster.participant_id AND TreatmentMaster.deleted <> 1;

UPDATE treatment_masters TreatmentMaster, treatment_masters_revs TreatmentMasterRevs
SET TreatmentMasterRevs.procure_form_identification = TreatmentMaster.procure_form_identification
WHERE TreatmentMasterRevs.id = TreatmentMaster.id 
AND TreatmentMasterRevs.version_created = TreatmentMaster.modified
AND TreatmentMasterRevs.procure_form_identification != TreatmentMaster.procure_form_identification;

-- Event

SELECT Participant.participant_identifier AS 'Update event form of patient', 
EventMaster.procure_form_identification AS 'From', 
CONCAT(Participant.participant_identifier, SUBSTRING(EventMaster.procure_form_identification, LOCATE(' V', EventMaster.procure_form_identification))) AS 'To', 
EventMaster.id AS 'Record Id'
FROM participants Participant
INNER JOIN event_masters EventMaster ON Participant.id = EventMaster.participant_id AND EventMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND EventMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier);

UPDATE participants Participant, event_masters EventMaster
SET EventMaster.procure_form_identification = CONCAT(Participant.participant_identifier, SUBSTRING(EventMaster.procure_form_identification, LOCATE(' V', EventMaster.procure_form_identification)))
WHERE Participant.deleted <> 1 AND EventMaster.procure_form_identification NOT REGEXP CONCAT('^', Participant.participant_identifier) AND Participant.id = EventMaster.participant_id AND EventMaster.deleted <> 1;

UPDATE event_masters EventMaster, event_masters_revs EventMasterRevs
SET EventMasterRevs.procure_form_identification = EventMaster.procure_form_identification
WHERE EventMasterRevs.id = EventMaster.id 
AND EventMasterRevs.version_created = EventMaster.modified
AND EventMasterRevs.procure_form_identification != EventMaster.procure_form_identification;

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Clean up aliquot barcodes to match participant_identifier + visit

-- #1

SELECT CONCAT(Participant.participant_identifier, ' + ', Collection.procure_visit) AS 'Update aliquot label of patient and collection (case #1)', 
AliquotMaster.barcode AS 'From',
CONCAT(Participant.participant_identifier, SUBSTRING(AliquotMaster.barcode, LOCATE(' V', AliquotMaster.barcode))) AS 'To',
AliquotMaster.id AS 'Record Id'
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
WHERE Participant.deleted <> 1 
AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier, '\ V') 
AND  AliquotMaster.barcode REGEXP CONCAT('^PS1P0000[0-9\(\)]+\ V'); 

UPDATE participants Participant, collections Collection, aliquot_masters AliquotMaster
SET AliquotMaster.barcode = CONCAT(Participant.participant_identifier, SUBSTRING(AliquotMaster.barcode, LOCATE(' V', AliquotMaster.barcode)))
WHERE Participant.deleted <> 1 
AND Collection.participant_id = Participant.id AND Collection.deleted <> 1
AND AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier, '\ V') 
AND AliquotMaster.barcode REGEXP CONCAT('^PS1P0000[0-9\(\)]+\ V'); 

-- #2

SELECT CONCAT(Participant.participant_identifier, ' + ', Collection.procure_visit) AS 'Update aliquot label of patient and collection (case #2)', 
AliquotMaster.barcode AS 'From',
REPLACE(AliquotMaster.barcode, ' V0 ', CONCAT(' ', Collection.procure_visit, ' ')) AS 'To',
AliquotMaster.id AS 'Record Id'
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
WHERE Participant.deleted <> 1 
AND AliquotMaster.barcode REGEXP CONCAT('^', Participant.participant_identifier, '\ V0\ \-');

UPDATE participants Participant, collections Collection, aliquot_masters AliquotMaster
SET AliquotMaster.barcode = REPLACE(AliquotMaster.barcode, ' V0 ', CONCAT(' ', Collection.procure_visit, ' '))
WHERE Participant.deleted <> 1 
AND Collection.participant_id = Participant.id AND Collection.deleted <> 1
AND AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
AND AliquotMaster.barcode REGEXP CONCAT('^', Participant.participant_identifier, '\ V0\ \-');

-- #3

SELECT CONCAT(Participant.participant_identifier, ' + ', Collection.procure_visit) AS 'Update aliquot label of patient and collection (case #3)', 
AliquotMaster.barcode AS 'From',
REPLACE(AliquotMaster.barcode, '  -', CONCAT(' ', Collection.procure_visit, ' -')) AS 'To',
AliquotMaster.id AS 'Record Id'
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
WHERE Participant.deleted <> 1 
AND AliquotMaster.barcode REGEXP CONCAT('^', Participant.participant_identifier, '\ \ \-');

UPDATE participants Participant, collections Collection, aliquot_masters AliquotMaster
SET AliquotMaster.barcode = REPLACE(AliquotMaster.barcode, '  -', CONCAT(' ', Collection.procure_visit, ' -'))
WHERE Participant.deleted <> 1 
AND Collection.participant_id = Participant.id AND Collection.deleted <> 1
AND AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
AND AliquotMaster.barcode REGEXP CONCAT('^', Participant.participant_identifier, '\ \ \-');

-- #4

SELECT CONCAT(Participant.participant_identifier, ' + ', Collection.procure_visit) AS 'Update aliquot label of patient and collection (case #4)', 
AliquotMaster.barcode AS 'From',
REPLACE(AliquotMaster.barcode, CONCAT(Participant.participant_identifier, Collection.procure_visit, ' -'), CONCAT(Participant.participant_identifier, ' ', Collection.procure_visit, ' -')) AS 'To',
AliquotMaster.id AS 'Record Id'
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
WHERE Participant.deleted <> 1 
AND AliquotMaster.barcode REGEXP CONCAT('^', Participant.participant_identifier, Collection.procure_visit, '\ \-');

UPDATE participants Participant, collections Collection, aliquot_masters AliquotMaster
SET AliquotMaster.barcode = REPLACE(AliquotMaster.barcode, CONCAT(Participant.participant_identifier, Collection.procure_visit, ' -'), CONCAT(Participant.participant_identifier, ' ', Collection.procure_visit, ' -')) 
WHERE Participant.deleted <> 1 
AND Collection.participant_id = Participant.id AND Collection.deleted <> 1
AND AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
AND AliquotMaster.barcode REGEXP CONCAT('^', Participant.participant_identifier, Collection.procure_visit, '\ \-');

-- #5

SELECT CONCAT(Participant.participant_identifier, ' + ', Collection.procure_visit) AS 'Update aliquot label of patient and collection (case #5)', 
AliquotMaster.barcode AS 'From',
REPLACE(AliquotMaster.barcode, CONCAT(Participant.participant_identifier, ' ', Collection.procure_visit, '-'), CONCAT(Participant.participant_identifier, ' ', Collection.procure_visit, ' -')) AS 'To',
AliquotMaster.id AS 'Record Id'
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
WHERE Participant.deleted <> 1 
AND AliquotMaster.barcode REGEXP CONCAT('^', Participant.participant_identifier, '\ ', Collection.procure_visit, '\-');

UPDATE participants Participant, collections Collection, aliquot_masters AliquotMaster
SET AliquotMaster.barcode = REPLACE(AliquotMaster.barcode, CONCAT(Participant.participant_identifier, ' ', Collection.procure_visit, '-'), CONCAT(Participant.participant_identifier, ' ', Collection.procure_visit, ' -'))
WHERE Participant.deleted <> 1 
AND Collection.participant_id = Participant.id AND Collection.deleted <> 1
AND AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
AND AliquotMaster.barcode REGEXP CONCAT('^', Participant.participant_identifier, '\ ', Collection.procure_visit, '\-');

-- #6

SELECT CONCAT(Participant.participant_identifier, ' + ', Collection.procure_visit) AS 'Update aliquot label of patient and collection (case #6)', 
AliquotMaster.barcode AS 'From',
CONCAT(Participant.participant_identifier, ' ', Collection.procure_visit, SUBSTRING(AliquotMaster.barcode, LOCATE(' -', AliquotMaster.barcode))) AS 'To',
AliquotMaster.id AS 'Record Id'
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
WHERE Participant.deleted <> 1 
AND AliquotMaster.barcode REGEXP CONCAT('^', Participant.participant_identifier, '\ V[0-9]{2}\ \-')
AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier, '\ ', Collection.procure_visit, ' \-');

UPDATE participants Participant, collections Collection, aliquot_masters AliquotMaster
SET AliquotMaster.barcode = CONCAT(Participant.participant_identifier, ' ', Collection.procure_visit, SUBSTRING(AliquotMaster.barcode, LOCATE(' -', AliquotMaster.barcode)))
WHERE Participant.deleted <> 1 
AND Collection.participant_id = Participant.id AND Collection.deleted <> 1
AND AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
AND AliquotMaster.barcode REGEXP CONCAT('^', Participant.participant_identifier, '\ V[0-9]{2}\ \-')
AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier, '\ ', Collection.procure_visit, ' \-');

-- #7

SELECT CONCAT(Participant.participant_identifier, ' + ', Collection.procure_visit) AS 'Update aliquot label of patient and collection (case #7)', 
AliquotMaster.barcode AS 'From',
CONCAT(Participant.participant_identifier, ' ', Collection.procure_visit, SUBSTRING(AliquotMaster.barcode, LOCATE(' -', AliquotMaster.barcode))) AS 'To',
AliquotMaster.id AS 'Record Id'
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
WHERE Participant.deleted <> 1 
AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier)
AND AliquotMaster.barcode REGEXP CONCAT('PS1P[0-9]{4}\ ', Collection.procure_visit, ' \-');

UPDATE participants Participant, collections Collection, aliquot_masters AliquotMaster
SET AliquotMaster.barcode = CONCAT(Participant.participant_identifier, ' ', Collection.procure_visit, SUBSTRING(AliquotMaster.barcode, LOCATE(' -', AliquotMaster.barcode)))
WHERE Participant.deleted <> 1 
AND Collection.participant_id = Participant.id AND Collection.deleted <> 1
AND AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier)
AND AliquotMaster.barcode REGEXP CONCAT('PS1P[0-9]{4}\ ', Collection.procure_visit, ' \-');

-- Revs

UPDATE aliquot_masters AliquotMaster, aliquot_masters_revs AliquotMasterRevs
SET AliquotMasterRevs.barcode = AliquotMaster.barcode
WHERE AliquotMasterRevs.id = AliquotMaster.id 
AND AliquotMasterRevs.version_created = AliquotMaster.modified
AND AliquotMasterRevs.barcode != AliquotMaster.barcode;
