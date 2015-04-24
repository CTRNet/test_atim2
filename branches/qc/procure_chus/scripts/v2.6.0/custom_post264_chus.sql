
-- ----------------------------------------------------------------------------------------------------
-- Removed custom value unclassifiable from the list of 'origin of slice' values (see tissue block)
-- ----------------------------------------------------------------------------------------------------

DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="procure_slice_origins" AND spv.value="unclassifiable" AND spv.language_alias="unclassifiable";
DELETE FROM structure_permissible_values WHERE value="unclassifiable" AND language_alias="unclassifiable" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);

SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn');

UPDATE aliquot_masters ALiquotMaster, ad_blocks AliquotDetail
SET AliquotMaster.modified = @modified, AliquotMaster.modified_by = @modified_by, AliquotMaster.notes = CONCAT(AliquotMaster.notes," Origine of slice unclassifiable")
WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.id = AliquotDetail.aliquot_master_id 
AND AliquotDetail.procure_origin_of_slice = 'unclassifiable'
AND AliquotMaster.notes IS NOT NULL AND AliquotMaster.notes NOT LIKE '';

UPDATE aliquot_masters ALiquotMaster, ad_blocks AliquotDetail
SET AliquotMaster.modified = @modified, AliquotMaster.modified_by = @modified_by, AliquotMaster.notes = "Origine of slice unclassifiable"
WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.id = AliquotDetail.aliquot_master_id 
AND AliquotDetail.procure_origin_of_slice = 'unclassifiable'
AND (AliquotMaster.notes IS NULL OR AliquotMaster.notes LIKE '');

UPDATE aliquot_masters ALiquotMaster, ad_blocks AliquotDetail
SET AliquotMaster.modified = @modified, AliquotMaster.modified_by = @modified_by, AliquotDetail.procure_origin_of_slice = ''
WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.id = AliquotDetail.aliquot_master_id 
AND AliquotDetail.procure_origin_of_slice = 'unclassifiable';

INSERT INTO aliquot_masters_revs (id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
modified_by,version_created)
(SELECT id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
modified_by,modified FROM aliquot_masters INNER JOIN ad_blocks ON id = aliquot_master_id WHERE  modified = @modified AND modified_by = @modified_by);

INSERT INTO ad_blocks_revs (aliquot_master_id,block_type,procure_freezing_type,patho_dpt_block_code,procure_freezing_ending_time,procure_origin_of_slice,
procure_dimensions,time_spent_collection_to_freezing_end_mn,procure_classification,procure_chus_classification_precision,procure_chus_origin_of_slice_precision,version_created)
(SELECT aliquot_master_id,block_type,procure_freezing_type,patho_dpt_block_code,procure_freezing_ending_time,procure_origin_of_slice,
procure_dimensions,time_spent_collection_to_freezing_end_mn,procure_classification,procure_chus_classification_precision,procure_chus_origin_of_slice_precision,modified
FROM aliquot_masters INNER JOIN ad_blocks ON id = aliquot_master_id WHERE  modified = @modified AND modified_by = @modified_by);

-- ----------------------------------------------------------------------------------------------------
-- Create Prostatectomy
-- ----------------------------------------------------------------------------------------------------

SELECT participant_id AS '### MESSAGE ### ParticipantId with more than one tissue collection date. Will be an issue for prostatectomy' FROM (
	SELECT count(*) as nbr, participant_id FROM (
		SELECT DISTINCT participant_id, collection_datetime
		FROM collections Collection
		INNER JOIN sample_masters SampleMaster ON Collection.id = SampleMaster.collection_id
		INNER JOIN sample_controls SampleControl ON SampleMaster.sample_control_id = SampleControl.id
		WHERE SampleControl.sample_type = 'tissue' AND Collection.deleted <> 1 AND SampleMaster.deleted <> 1
		AND Collection.participant_id IS NOT NULL AND collection_datetime IS NOT NULL
	) AS res GROUP BY participant_id
) AS res2 WHERE res2.nbr > 1;

SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn');
SET @tx_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'procure follow-up worksheet - treatment');

INSERT INTO treatment_masters (participant_id, treatment_control_id, start_date, start_date_accuracy, finish_date, finish_date_accuracy, notes, created, created_by, modified, modified_by, procure_form_identification)
(SELECT DISTINCT participant_id, @tx_control_id, collection_datetime, collection_datetime_accuracy, collection_datetime, collection_datetime_accuracy, 'Record created by script based on tissue collection date.', @modified, @modified_by, @modified, @modified_by, CONCAT(Participant.participant_identifier, ' Vx -FSPx') 
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id
INNER JOIN sample_masters SampleMaster ON Collection.id = SampleMaster.collection_id
INNER JOIN sample_controls SampleControl ON SampleMaster.sample_control_id = SampleControl.id
WHERE SampleControl.sample_type = 'tissue' AND Collection.deleted <> 1 AND SampleMaster.deleted <> 1
AND Collection.participant_id IS NOT NULL AND collection_datetime IS NOT NULL);
UPDATE treatment_masters SET start_date_accuracy = 'c', finish_date_accuracy = 'c' WHERE start_date_accuracy IN ('h', 'i') AND treatment_control_id = @tx_control_id AND modified = @modified AND modified_by = @modified_by;
INSERT INTO procure_txd_followup_worksheet_treatments (treatment_master_id, treatment_type)
(SELECT id, 'prostatectomy' FROM treatment_masters WHERE treatment_control_id = @tx_control_id AND modified = @modified AND modified_by = @modified_by);
INSERT INTO treatment_masters_revs (id,participant_id, treatment_control_id, start_date, start_date_accuracy, finish_date, finish_date_accuracy, notes, procure_form_identification, version_created,modified_by)
(SELECT id,participant_id, treatment_control_id, start_date, start_date_accuracy, finish_date, finish_date_accuracy, notes, procure_form_identification, modified,modified_by FROM treatment_masters WHERE treatment_control_id = @tx_control_id AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_followup_worksheet_treatments_revs (treatment_master_id, treatment_type, version_created)
(SELECT id, 'prostatectomy',modified FROM treatment_masters WHERE treatment_control_id = @tx_control_id AND modified = @modified AND modified_by = @modified_by);

-- ----------------------------------------------------------------------------------------------------
-- Move RNA conc and vol from bioanalyzer to nanodrop
-- ----------------------------------------------------------------------------------------------------

UPDATE ad_tubes
SET procure_concentration_nanodrop = concentration,
procure_concentration_unit_nanodrop = concentration_unit,
procure_total_quantity_ug_nanodrop = procure_total_quantity_ug
WHERE aliquot_master_id IN (
	SELECT AliquotMaster.id 
	FROM aliquot_masters AliquotMaster
	INNER JOIN aliquot_controls AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
	INNER JOIN sample_controls SampleControl ON AliquotControl.sample_control_id = SampleControl.id
	WHERE sample_type = 'rna' AND aliquot_type = 'tube'
);
UPDATE ad_tubes
SET concentration = null,
concentration_unit = null,
procure_total_quantity_ug = null
WHERE aliquot_master_id IN (
	SELECT AliquotMaster.id 
	FROM aliquot_masters AliquotMaster
	INNER JOIN aliquot_controls AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
	INNER JOIN sample_controls SampleControl ON AliquotControl.sample_control_id = SampleControl.id
	WHERE sample_type = 'rna' AND aliquot_type = 'tube'
);
UPDATE ad_tubes
SET procure_concentration_unit_nanodrop = null
WHERE aliquot_master_id IN (
	SELECT AliquotMaster.id 
	FROM aliquot_masters AliquotMaster
	INNER JOIN aliquot_controls AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
	INNER JOIN sample_controls SampleControl ON AliquotControl.sample_control_id = SampleControl.id
	WHERE sample_type = 'rna' AND aliquot_type = 'tube'
) AND (procure_concentration_nanodrop IS NULL OR procure_concentration_nanodrop LIKE '');

UPDATE ad_tubes_revs
SET procure_concentration_nanodrop = concentration,
procure_concentration_unit_nanodrop = concentration_unit,
procure_total_quantity_ug_nanodrop = procure_total_quantity_ug
WHERE aliquot_master_id IN (
	SELECT AliquotMaster.id 
	FROM aliquot_masters AliquotMaster
	INNER JOIN aliquot_controls AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
	INNER JOIN sample_controls SampleControl ON AliquotControl.sample_control_id = SampleControl.id
	WHERE sample_type = 'rna' AND aliquot_type = 'tube'
);
UPDATE ad_tubes_revs
SET concentration = null,
concentration_unit = null,
procure_total_quantity_ug = null
WHERE aliquot_master_id IN (
	SELECT AliquotMaster.id 
	FROM aliquot_masters AliquotMaster
	INNER JOIN aliquot_controls AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
	INNER JOIN sample_controls SampleControl ON AliquotControl.sample_control_id = SampleControl.id
	WHERE sample_type = 'rna' AND aliquot_type = 'tube'
);
UPDATE ad_tubes_revs
SET procure_concentration_unit_nanodrop = null
WHERE aliquot_master_id IN (
	SELECT AliquotMaster.id 
	FROM aliquot_masters AliquotMaster
	INNER JOIN aliquot_controls AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
	INNER JOIN sample_controls SampleControl ON AliquotControl.sample_control_id = SampleControl.id
	WHERE sample_type = 'rna' AND aliquot_type = 'tube'
) AND (procure_concentration_nanodrop IS NULL OR procure_concentration_nanodrop LIKE '');

-- ----------------------------------------------------------------------------------------------------
-- Defined blood tube as not in stock
-- ----------------------------------------------------------------------------------------------------

SELECT  'Set following tubes as not in stock' AS '### MESSAGE ###';
SELECT AliquotMaster.id, AliquotMaster.barcode, CONCAT(SampleControl.sample_type, ' ', AliquotControl.aliquot_type, ' ', blood_type) AS 'aliquot type', in_stock, StorageMaster.selection_label, CONCAT(storage_coord_x,' ',storage_coord_y) AS positions
FROM sample_masters SampleMaster
INNER JOIN sample_controls SampleControl ON SampleMaster.sample_control_id = SampleControl.id
INNER JOIN sd_spe_bloods SampleDetail ON SampleMaster.id = SampleDetail.sample_master_id
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id
INNER JOIN aliquot_controls AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
LEFT JOIN storage_masters StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id
WHERE AliquotMaster.deleted <> 1 AND SampleControl.sample_type = 'blood' AND AliquotControl.aliquot_type = 'tube'
AND blood_type != 'paxgene' AND in_stock != 'no';

UPDATE aliquot_masters_revs 
SET in_stock = 'no',
storage_master_id = null,
storage_coord_x = null,
storage_coord_y = null
WHERE id IN (
	SELECT AliquotMaster.id
	FROM sample_masters SampleMaster
	INNER JOIN sample_controls SampleControl ON SampleMaster.sample_control_id = SampleControl.id
	INNER JOIN sd_spe_bloods SampleDetail ON SampleMaster.id = SampleDetail.sample_master_id
	INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id
	INNER JOIN aliquot_controls AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
	WHERE AliquotMaster.deleted <> 1 AND SampleControl.sample_type = 'blood' AND AliquotControl.aliquot_type = 'tube'
	AND blood_type != 'paxgene' AND in_stock != 'no'
);

UPDATE sample_masters SampleMaster, sample_controls SampleControl, sd_spe_bloods SampleDetail, aliquot_masters AliquotMaster, aliquot_controls AliquotControl
SET in_stock = 'no',
storage_master_id = null,
storage_coord_x = null,
storage_coord_y = null
WHERE AliquotMaster.deleted <> 1 
AND SampleMaster.sample_control_id = SampleControl.id
AND SampleMaster.id = SampleDetail.sample_master_id
AND AliquotMaster.sample_master_id = SampleMaster.id
AND AliquotMaster.aliquot_control_id = AliquotControl.id
AND SampleControl.sample_type = 'blood' AND AliquotControl.aliquot_type = 'tube'
AND blood_type != 'paxgene' AND in_stock != 'no';



























TODO remove field treatment type
created drug from this field or not
remove combination

-- ----------------------------------------------------------------------------------------------------
-- Removed old treatment type field
-- ----------------------------------------------------------------------------------------------------









faire requete suivante sur une ligne
select 'ici2' as msg;

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = ''
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.treatment_type = 'chemotherapy' AND TreatmentDetail.type IN ('Chemothérapy', 'Chemotherapy', 'chemothérapy', 'chemotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments_revs TreatmentDetail
SET TreatmentDetail.type = ''
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.treatment_type = 'chemotherapy' AND TreatmentDetail.type IN ('Chemothérapy', 'Chemotherapy', 'chemothérapy', 'chemotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = ''
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.treatment_type = 'radiotherapy' AND TreatmentDetail.type IN ('Radiotherapy', 'radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments_revs TreatmentDetail
SET TreatmentDetail.type = ''
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.treatment_type = 'radiotherapy' AND TreatmentDetail.type IN ('Radiotherapy', 'radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = ''
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.treatment_type = 'hormonotherapy' AND TreatmentDetail.type IN ('Hormonotherapy', 'hormonotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments_revs TreatmentDetail
SET TreatmentDetail.type = ''
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.treatment_type = 'hormonotherapy' AND TreatmentDetail.type IN ('Hormonotherapy', 'hormonotherapy');




UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = CONCAT(TreatmentMaster.notes, ' Treatment type previously defined as : radiotherapy + hormonotherapy')
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.type IN ('radiotherapy', 'Radiotherapy', 'hormonotherapy', 'Hormonotherapy')
AND TreatmentMaster.notes IS NOT NULL AND TreatmentMaster.notes NOT LIKE '';

si radio + chimio mettre dnas note + check combiné
si type radio mettre treatment type radio...
si chimio mettre treatment type chimo








si radiotherapy + 














UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = CONCAT(TreatmentMaster.notes, ' Treatment type previously defined as :', TreatmentDetail.type)
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.type IS NOT NULL AND TreatmentDetail.type NOT LIKE ''
AND TreatmentMaster.notes IS NOT NULL AND TreatmentMaster.notes NOT LIKE '';
UPDATE treatment_masters_revs TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = CONCAT(TreatmentMaster.notes, ' Treatment type previously defined as :', TreatmentDetail.type)
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.type IS NOT NULL AND TreatmentDetail.type NOT LIKE ''
AND TreatmentMaster.notes IS NOT NULL AND TreatmentMaster.notes NOT LIKE '';

SELECT 'Treatment to review after migration', Participant.participant_identifier, TreatmentMaster.start_date, TreatmentDetail.treatment_type, TreatmentDetail.type, TreatmentDetail.dosage, CONCAT(Drug.type, ' : ', Drug.generic_name) AS drug 
FROM participants Participant
INNER JOIN treatment_masters TreatmentMaster ON TreatmentMaster.participant_id = Participant.id
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
LEFT JOIN drugs Drug ON Drug.id = TreatmentDetail.drug_id 
WHERE TreatmentMaster.deleted <> 1 
AND TreatmentDetail.type IS NOT NULL AND TreatmentDetail.type NOT LIKE ''
ORDER by Participant.participant_identifier, TreatmentMaster.start_date, TreatmentDetail.treatment_type;



















SELECT count(*), TreatmentDetail.treatment_type, TreatmentDetail.type, TreatmentDetail.dosage, Drug.type, Drug.generic_name 
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
LEFT JOIN drugs Drug ON Drug.id = TreatmentDetail.drug_id 
WHERE TreatmentMaster.deleted <> 1 
AND TreatmentDetail.type IS NOT NULL AND TreatmentDetail.type NOT LIKE ''
GROUP BY TreatmentDetail.treatment_type, TreatmentDetail.type, TreatmentDetail.dosage, Drug.type, Drug.generic_name 
ORDER by TreatmentDetail.treatment_type, TreatmentDetail.type;






TODO 1: Check data have been correctly migrated to [type] field and add clean up if required (use following query to list data).
SELECT DISTINCT TreatmentDetail.treatment_type, TreatmentDetail.type, Drug.type, Drug.generic_name FROM treatment_masters TreatmentMaster INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id LEFT JOIN drugs Drug ON Drug.id = TreatmentDetail.drug_id WHERE TreatmentMaster.deleted <> 1 ORDER by TreatmentDetail.treatment_type, TreatmentDetail.type;
TODO 2: Then remove old field renamed to [type (to remove)] running follwing queries (already included into custom_post263.2.sql).
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE procure_txd_followup_worksheet_treatments DROP COLUMN type;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs DROP COLUMN type;


















































