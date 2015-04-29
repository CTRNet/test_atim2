
-- ----------------------------------------------------------------------------------------------------
-- Removed custom value unclassifiable from the list of 'origin of slice' values (see tissue block)
-- ----------------------------------------------------------------------------------------------------

SELECT "Removed custom value unclassifiable from the list of 'origin of slice' values" AS '### MESSAGE ###';

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

SELECT "Created prostatectomy treatment based on tissue collection date" AS '### MESSAGE ###';

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

SELECT "Moved RNA bioanalyzer concentration and volume to nanodrop concentration and volume" AS '### MESSAGE ###';

SET @aliquot_contorl_id = (SELECT AliquotControl.id 
FROM aliquot_controls AliquotControl
INNER JOIN sample_controls SampleControl ON AliquotControl.sample_control_id = SampleControl.id
WHERE sample_type = 'rna' AND aliquot_type = 'tube');

SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn');

UPDATE ad_tubes, aliquot_masters
SET procure_concentration_nanodrop = concentration,
procure_concentration_unit_nanodrop = concentration_unit,
procure_total_quantity_ug_nanodrop = procure_total_quantity_ug,
modified = @modified, modified_by = @modified_by
WHERE id = aliquot_master_id AND aliquot_control_id = @aliquot_contorl_id;
UPDATE ad_tubes, aliquot_masters
SET concentration = null,
concentration_unit = null,
procure_total_quantity_ug = null,
modified = @modified, modified_by = @modified_by
WHERE id = aliquot_master_id AND aliquot_control_id = @aliquot_contorl_id;
UPDATE ad_tubes, aliquot_masters
SET procure_concentration_unit_nanodrop = null,
modified = @modified, modified_by = @modified_by
WHERE id = aliquot_master_id AND aliquot_control_id = @aliquot_contorl_id AND (procure_concentration_nanodrop IS NULL OR procure_concentration_nanodrop LIKE '');

INSERT INTO aliquot_masters_revs (id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
modified_by,version_created)
(SELECT id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
modified_by,modified FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE  modified = @modified AND modified_by = @modified_by AND aliquot_control_id = @aliquot_contorl_id);
INSERT INTO ad_tubes_revs (aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,procure_expiration_date,procure_tube_weight_gr,
procure_total_quantity_ug,procure_chus_micro_rna,procure_concentration_nanodrop,procure_concentration_unit_nanodrop,procure_total_quantity_ug_nanodrop,version_created)
(SELECT aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,procure_expiration_date,procure_tube_weight_gr,
procure_total_quantity_ug,procure_chus_micro_rna,procure_concentration_nanodrop,procure_concentration_unit_nanodrop,procure_total_quantity_ug_nanodrop,modified
FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE  modified = @modified AND modified_by = @modified_by AND aliquot_control_id = @aliquot_contorl_id);

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

SET @aliquot_contorl_id = (SELECT AliquotControl.id 
FROM aliquot_controls AliquotControl
INNER JOIN sample_controls SampleControl ON AliquotControl.sample_control_id = SampleControl.id
WHERE sample_type = 'blood' AND aliquot_type = 'tube');

SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn');

UPDATE sample_masters SampleMaster, sd_spe_bloods SampleDetail, aliquot_masters AliquotMaster
SET in_stock = 'no',
storage_master_id = null,
storage_coord_x = null,
storage_coord_y = null,
SampleMaster.modified = @modified, SampleMaster.modified_by = @modified_by
WHERE AliquotMaster.deleted <> 1 
AND AliquotMaster.aliquot_control_id = @aliquot_contorl_id
AND AliquotMaster.sample_master_id = SampleMaster.id
AND SampleMaster.id = SampleDetail.sample_master_id
AND blood_type != 'paxgene' AND in_stock != 'no';

INSERT INTO aliquot_masters_revs (id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
modified_by,version_created)
(SELECT id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,
modified_by,modified FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE  modified = @modified AND modified_by = @modified_by AND aliquot_control_id = @aliquot_contorl_id);
INSERT INTO ad_tubes_revs (aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,procure_expiration_date,procure_tube_weight_gr,
procure_total_quantity_ug,procure_chus_micro_rna,procure_concentration_nanodrop,procure_concentration_unit_nanodrop,procure_total_quantity_ug_nanodrop,version_created)
(SELECT aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,procure_expiration_date,procure_tube_weight_gr,
procure_total_quantity_ug,procure_chus_micro_rna,procure_concentration_nanodrop,procure_concentration_unit_nanodrop,procure_total_quantity_ug_nanodrop,modified
FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE  modified = @modified AND modified_by = @modified_by AND aliquot_control_id = @aliquot_contorl_id);

-- ----------------------------------------------------------------------------------------------------
-- Removed old treatment type field
-- ----------------------------------------------------------------------------------------------------

SELECT "Removed field 'old type' from treatment" AS '### MESSAGE ###';
SELECT count(*) AS 'Nbr of records', TreatmentDetail.treatment_type, TreatmentDetail.type AS 'old type', TreatmentDetail.dosage, Drug.type, Drug.generic_name 
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
LEFT JOIN drugs Drug ON Drug.id = TreatmentDetail.drug_id 
WHERE TreatmentMaster.deleted <> 1 
AND TreatmentDetail.type IS NOT NULL AND TreatmentDetail.type NOT LIKE ''
GROUP BY TreatmentDetail.treatment_type, TreatmentDetail.type, TreatmentDetail.dosage, Drug.type, Drug.generic_name 
ORDER by TreatmentDetail.treatment_type, TreatmentDetail.type;

SET @modified_by = (SELECT id FROM users WHERE username = 'NicoEn');
SET @modified = (SELECT NOW() FROM users WHERE username = 'NicoEn');

ALTER TABLE procure_txd_followup_worksheet_treatments ADD COLUMN old_type_copie varchar(500);
UPDATE procure_txd_followup_worksheet_treatments SET old_type_copie = type;

-- treatment_type = 'radiotherapy + hormonotherapy'

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET treatment_combination = 'y', modified = @modified, modified_by = @modified_by
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE 'radiotherapy + hormonotherapy';

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET notes = CONCAT(notes, ' Radiotherapy + Hormonotherapy'), modified = @modified, modified_by = @modified_by
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE 'radiotherapy + hormonotherapy'
AND notes IS NOT NULL;

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET notes = 'radiotherapy + hormonotherapy', modified = @modified, modified_by = @modified_by
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE 'radiotherapy + hormonotherapy'
AND notes IS NULL;

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET treatment_type = 'radiotherapy', modified = @modified, modified_by = @modified_by
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE 'radiotherapy + hormonotherapy' AND TreatmentDetail.type LIKE 'radiotherapy';

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET treatment_type = 'hormonotherapy', modified = @modified, modified_by = @modified_by
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE 'radiotherapy + hormonotherapy' AND TreatmentDetail.type LIKE 'hormonotherapy';

SELECT count(*) AS 'Nbr of radiotherapy + hormonotherapy not cleaned (should be 0)' 
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE 'radiotherapy + hormonotherapy';

-- treatment_type = type

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = ''
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE 'radiotherapy' AND TreatmentDetail.type LIKE 'radiotherapy';

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = ''
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE 'hormonotherapy' AND TreatmentDetail.type LIKE 'hormonotherapy';

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = ''
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE 'chemotherapy' AND TreatmentDetail.type LIKE 'chemotherapy';

-- Radiotherapy

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
(SELECT DISTINCT lower(TreatmentDetail.type), '1', @control_id, @modified, @modified, @modified_by, @modified_by
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE '%radiotherapy%'
AND TreatmentDetail.type NOT IN ('', 'loge prostatique', 'Loge prosrtatique'));

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.treatment_site = lower(TreatmentDetail.type), TreatmentDetail.type = '', modified = @modified, modified_by = @modified_by
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE '%radiotherapy%'
AND TreatmentDetail.type NOT IN ('', 'loge prostatique', 'Loge prosrtatique');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.treatment_site = 'prostate bed', TreatmentDetail.type = '', modified = @modified, modified_by = @modified_by
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type LIKE '%radiotherapy%'
AND TreatmentDetail.type IN ('loge prostatique', 'Loge prosrtatique');

-- chemotherapy, experimental treatment, hormonotherapy

SELECT count(*) AS '### MESSAGE ### Nbr of existing chemotherapy, experimental treatment, hormonotherapy drugs (should be equal to 0 else script has to be updated)'
FROM drugs WHERE type IN ('chemotherapy', 'experimental treatment', 'hormonotherapy');

SELECT count(*) AS '### MESSAGE ### Nbr treatment linked to drug (should be equal to 0 else script has to be updated)'
FROM procure_txd_followup_worksheet_treatments WHERE drug_id IS NOT NULL AND drug_id NOT LIKE '';

SELECT DISTINCT CONCAT (TreatmentDetail.treatment_type, ' - ', TreatmentDetail.type) AS '### MESSAGE ### New created drugs'
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type IN ('chemotherapy', 'experimental treatment', 'hormonotherapy')
AND TreatmentDetail.type IS NOT NULL AND TreatmentDetail.type NOT LIKE '' AND (TreatmentDetail.type NOT LIKE '% %' OR TreatmentDetail.type LIKE '%placebo%')
ORDER BY TreatmentDetail.treatment_type, TreatmentDetail.type;

INSERT INTO drugs (generic_name,type,created,created_by,modified,modified_by) 
(SELECT DISTINCT TreatmentDetail.type, TreatmentDetail.treatment_type, @modified, @modified_by, @modified, @modified_by
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type IN ('chemotherapy', 'experimental treatment', 'hormonotherapy')
AND TreatmentDetail.type IS NOT NULL AND TreatmentDetail.type NOT LIKE '' AND (TreatmentDetail.type NOT LIKE '% %' OR TreatmentDetail.type LIKE '%placebo%'));
UPDATE drugs SET procure_study = '1' WHERE modified = @modified AND modified_by = @modified_by AND generic_name LIKE '%placebo%';

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug
SET TreatmentDetail.drug_id = Drug.id, TreatmentDetail.type = '', TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type IN ('chemotherapy', 'experimental treatment', 'hormonotherapy')
AND Drug.type = TreatmentDetail.treatment_type
AND Drug.generic_name = TreatmentDetail.type;

SELECT 'List of treatment with old type that could not be migrated by process (old type will be moved to note)' AS '### MESSAEGE ###'
UNION ALL 
SELECT 'To manage manually' AS '### MESSAEGE ###'
UNION ALL
SELECT 'See below' AS '### MESSAEGE ###';
SELECT Participant.participant_identifier, TreatmentDetail.treatment_type, TreatmentDetail.type AS 'old type', TreatmentDetail.dosage, Drug.type, Drug.generic_name 
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
INNER JOIN participants Participant ON Participant.id  = TreatmentMaster.participant_id
LEFT JOIN drugs Drug ON Drug.id = TreatmentDetail.drug_id 
WHERE TreatmentMaster.deleted <> 1 
AND TreatmentDetail.type IS NOT NULL AND TreatmentDetail.type NOT LIKE ''
GROUP BY TreatmentDetail.treatment_type, TreatmentDetail.type, TreatmentDetail.dosage, Drug.type, Drug.generic_name 
ORDER by TreatmentDetail.treatment_type, TreatmentDetail.type;

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = CONCAT(notes, ' Old type field value :', TreatmentDetail.type), TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.type IS NOT NULL AND TreatmentDetail.type NOT LIKE '';

-- fields clean up

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE procure_txd_followup_worksheet_treatments DROP COLUMN type;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs DROP COLUMN type;

-- Set drug_id

SELECT DISTINCT dosage AS '### MESSAGE ### Parsed dosage to set treatment drug', TreatmentDetail.treatment_type
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type IN ('chemotherapy', 'experimental treatment', 'hormonotherapy')
AND TreatmentDetail.dosage IS NOT NULL AND TreatmentDetail.dosage NOT LIKE ''
ORDER BY TreatmentDetail.treatment_type, dosage;

SELECT 'chemotherapy - R-Chop' AS '### MESSAGE ### New created drugs'
UNION ALL
SELECT 'hormonotherapy - Bicalutamide' AS '### MESSAGE ### New created drugs'
UNION ALL
SELECT 'hormonotherapy - Lupron' AS '### MESSAGE ### New created drugs'
UNION ALL
SELECT 'hormonotherapy - Firmagon' AS '### MESSAGE ### New created drugs'
UNION ALL
SELECT 'hormonotherapy - Tamoxifène' AS '### MESSAGE ### New created drugs'
UNION ALL
SELECT 'hormonotherapy - Trelstar' AS '### MESSAGE ### New created drugs';

INSERT INTO drugs (type,generic_name,created,created_by,modified,modified_by) 
VALUES
('chemotherapy','R-Chop', @modified, @modified_by, @modified, @modified_by),
('hormonotherapy','Bicalutamide', @modified, @modified_by, @modified, @modified_by),
('hormonotherapy','Lupron', @modified, @modified_by, @modified, @modified_by),
('hormonotherapy','Firmagon', @modified, @modified_by, @modified, @modified_by),
('hormonotherapy','Tamoxifène', @modified, @modified_by, @modified, @modified_by),
('hormonotherapy','Trelstar', @modified, @modified_by, @modified, @modified_by);

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug
SET TreatmentDetail.drug_id = Drug.id, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id 
AND TreatmentMaster.deleted <> 1
AND TreatmentDetail.treatment_type IN ('chemotherapy', 'hormonotherapy')
AND (TreatmentDetail.drug_id IS NULL OR TreatmentDetail.drug_id LIKE '')
AND Drug.type = TreatmentDetail.treatment_type
AND TreatmentDetail.dosage LIKE CONCAT('%',Drug.generic_name,'%');

-- Controls

SELECT 'Data for revision' AS '### MESSAGE ###';
SELECT count(*) AS 'Nbr of records', TreatmentDetail.treatment_type, old_type_copie AS 'Old Treatment Type', TreatmentDetail.dosage, Drug.generic_name, treatment_site, treatment_combination, notes
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
LEFT JOIN drugs Drug ON Drug.id = TreatmentDetail.drug_id 
WHERE TreatmentMaster.deleted <> 1 
GROUP BY TreatmentDetail.treatment_type, old_type_copie, TreatmentDetail.dosage, Drug.type, Drug.generic_name, treatment_site, treatment_precision, notes
ORDER by TreatmentDetail.treatment_type, old_type_copie;

ALTER TABLE procure_txd_followup_worksheet_treatments DROP COLUMN old_type_copie;

-- Revs Update

INSERT INTO treatment_masters_revs (id,participant_id, treatment_control_id, start_date, start_date_accuracy, finish_date, finish_date_accuracy, notes, procure_form_identification, version_created,modified_by)
(SELECT id,participant_id, treatment_control_id, start_date, start_date_accuracy, finish_date, finish_date_accuracy, notes, procure_form_identification, modified,modified_by 
FROM treatment_masters INNER JOIN procure_txd_followup_worksheet_treatments ON id = treatment_master_id 
WHERE modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_followup_worksheet_treatments_revs (treatment_type,dosage,treatment_master_id,drug_id,treatment_site,treatment_precision,treatment_combination,treatment_line,version_created)
(SELECT treatment_type,dosage,treatment_master_id,drug_id,treatment_site,treatment_precision,treatment_combination,treatment_line,modified FROM treatment_masters 
INNER JOIN procure_txd_followup_worksheet_treatments ON id = treatment_master_id 
WHERE modified = @modified AND modified_by = @modified_by);

INSERT INTO drugs_revs (id,generic_name,trade_name,type,description,procure_study,modified_by,version_created)
(SELECT id,generic_name,trade_name,type,description,procure_study,modified_by,modified FROM drugs WHERE modified = @modified AND modified_by = @modified_by);


-- ----------------------------------------------------------------------------------------------------
-- MESSAGE
-- ----------------------------------------------------------------------------------------------------

SELECT "Don't forget to run flag_bcr.php script after migration" AS "### MESSAGE ###";
