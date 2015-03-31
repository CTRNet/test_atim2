
SET @modified_by = (SELECT id FROM users WHERE username = 'Migration');
SET @modified = (SELECT NOW() FROM users WHERE username = 'Migration');

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Whatman paper initial storage date moved to note...
-- -----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE aliquot_masters AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.notes = CONCAT(AliquotMaster.notes,"\nLa date d'entreposage saisie était : ", SUBSTRING(AliquotMaster.storage_datetime, 1, 16))
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.storage_datetime IS NOT NULL AND AliquotMaster.notes IS NOT NULL AND AliquotMaster.notes NOT LIKE '';

UPDATE aliquot_masters AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.notes = CONCAT("La date d'entreposage saisie était : ", SUBSTRING(AliquotMaster.storage_datetime, 1, 16))
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.storage_datetime IS NOT NULL AND (AliquotMaster.notes IS NULL OR AliquotMaster.notes LIKE '');

UPDATE aliquot_masters AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.storage_datetime = null, AliquotMaster.storage_datetime_accuracy = null
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.storage_datetime IS NOT NULL;

UPDATE aliquot_masters_revs AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.notes = CONCAT(AliquotMaster.notes,"\nLa date d'entreposage saisie était : ", SUBSTRING(AliquotMaster.storage_datetime, 1, 16))
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.storage_datetime IS NOT NULL AND AliquotMaster.notes IS NOT NULL AND AliquotMaster.notes NOT LIKE '';

UPDATE aliquot_masters_revs AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.notes = CONCAT("La date d'entreposage saisie était : ", SUBSTRING(AliquotMaster.storage_datetime, 1, 16))
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.storage_datetime IS NOT NULL AND (AliquotMaster.notes IS NULL OR AliquotMaster.notes LIKE '');

UPDATE aliquot_masters_revs AliquotMaster, aliquot_controls AliquotControl, sample_controls SampleControl
SET AliquotMaster.storage_datetime = null, AliquotMaster.storage_datetime_accuracy = null
WHERE AliquotControl.id = AliquotMaster.aliquot_control_id AND SampleControl.id = AliquotControl.sample_control_id
AND sample_type = 'blood' AND aliquot_type = 'whatman paper' 
AND AliquotMaster.storage_datetime IS NOT NULL;

-- ----------------------------------------------------------------------------------------------------------------------------------------------
-- Participant form review (withdrawn and language preferred)
-- ----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE procure_cd_sigantures SET qc_nd_stop_followup_date = null WHERE qc_nd_stop_followup_date LIKE '0000-00%';
UPDATE procure_cd_sigantures_revs SET qc_nd_stop_followup_date = null WHERE qc_nd_stop_followup_date LIKE '0000-00%';

SELECT participant_id AS '### MESSAGE ### List of participant_id linked to a consent with a date of withdrawn but flag withdrawn is unselected. To check and correct after migration.' 
FROM consent_masters INNER JOIN procure_cd_sigantures ON id = consent_master_id WHERE deleted <> 1 AND qc_nd_stop_followup != 'y' AND qc_nd_stop_followup_date IS NOt NULL;

SELECT count(*) AS '### MESSAGE ### Nbr of participants flagged as withdrawn by script.' FROM (
	SELECT DISTINCT CM.participant_id FROM consent_masters CM, procure_cd_sigantures CD WHERE CM.deleted <> 1 AND CM.id = CD.consent_master_id AND CD.qc_nd_stop_followup = 'y'
) res;
UPDATE participants P, consent_masters CM, procure_cd_sigantures CD
SET P.procure_patient_withdrawn = '1', P.procure_patient_withdrawn_date = CD.qc_nd_stop_followup_date, P.procure_patient_withdrawn_date_accuracy = 'c', P.modified = @modified, P.modified_by = @modified_by
WHERE P.id = CM.participant_id AND CM.deleted <> 1 AND CM.id = CD.consent_master_id AND CD.qc_nd_stop_followup = 'y';
INSERT INTO participants_revs (id,title,first_name,middle_name,last_name,date_of_birth,date_of_birth_accuracy,marital_status,language_preferred,sex,race,vital_status,notes,date_of_death,date_of_death_accuracy,procure_cause_of_death,cod_icd10_code,secondary_cod_icd10_code,cod_confirmation_source,participant_identifier,last_chart_checked_date,last_chart_checked_date_accuracy,last_modification,last_modification_ds_id,qc_nd_last_contact,procure_patient_withdrawn,procure_patient_withdrawn_date,procure_patient_withdrawn_date_accuracy,procure_patient_withdrawn_reason,modified_by,version_created)
(SELECT id,title,first_name,middle_name,last_name,date_of_birth,date_of_birth_accuracy,marital_status,language_preferred,sex,race,vital_status,notes,date_of_death,date_of_death_accuracy,procure_cause_of_death,cod_icd10_code,secondary_cod_icd10_code,cod_confirmation_source,participant_identifier,last_chart_checked_date,last_chart_checked_date_accuracy,last_modification,last_modification_ds_id,qc_nd_last_contact,procure_patient_withdrawn,procure_patient_withdrawn_date,procure_patient_withdrawn_date_accuracy,procure_patient_withdrawn_reason,modified_by,modified FROM participants WHERE modified = @modified AND modified_by = @modified_by);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='language_preferred' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='language_preferred') AND `flag_confidential`='0');

-- ----------------------------------------------------------------------------------------------------------------------------------------------
-- Consent
-- ----------------------------------------------------------------------------------------------------------------------------------------------

UPDATE consent_masters SET form_version = qc_nd_consent_version_date;
UPDATE consent_masters_revs SET form_version = qc_nd_consent_version_date;

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Consent Form Versions');
INSERT INTO `structure_permissible_values_customs` (`value`, `use_as_input`, `control_id`)
(SELECT DISTINCT form_version, 1, @control_id  FROM consent_masters WHERE deleted <> 1 AND form_version NOT LIKE '');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Consent version date');
DELETE FROM structure_permissible_values_customs WHERE control_id = @control_id;
DELETE FROM structure_permissible_values_custom_controls WHERE name = 'Consent version date';
ALTER TABLE consent_masters DROP COLUMN qc_nd_consent_version_date;
ALTER TABLE consent_masters_revs DROP COLUMN qc_nd_consent_version_date;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_nd_consent_version_date' AND `language_label`='' AND `language_tag`='-' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_consent_version_date') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_nd_consent_version_date' AND `language_label`='' AND `language_tag`='-' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_consent_version_date') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='qc_nd_consent_version_date' AND `language_label`='' AND `language_tag`='-' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_nd_consent_version_date') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_value_domains WHERE domain_name='qc_nd_consent_version_date';

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Clean up procure_txd_followup_worksheet_treatments
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- *** Copy type to notes for deleted treatment ***

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET notes = CONCAT(notes,' ', type)
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.deleted = 1 AND notes is NOT NULL;
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET notes = type
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.deleted = 1 AND notes is NULL;
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET type = NULL
WHERE TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.deleted = 1;

-- *** Curietherapy ***

UPDATE procure_txd_followup_worksheet_treatments SET treatment_type = 'brachytherapy' WHERE treatment_type = 'curietherapy';
UPDATE procure_txd_followup_worksheet_treatments_revs SET treatment_type = 'brachytherapy' WHERE treatment_type = 'curietherapy';

-- *** Prostatectomy ***

UPDATE procure_txd_followup_worksheet_treatments SET type = NULL WHERE treatment_type = 'prostatectomy' AND type IN ('prostatectomie', 'prostatectomie radicale');
UPDATE procure_txd_followup_worksheet_treatments_revs SET type = NULL WHERE treatment_type = 'prostatectomy' AND type IN ('prostatectomie', 'prostatectomie radicale');

-- *** Aborted Prostatectomy ***

-- Nothing to do

-- *** Experimental Treatment *** 

SELECT DISTINCT TreatmentDetail.type AS '### MESSAGE ### Created following hormonotherapy drugs. Please validate. Check also no treatment combination exists.'
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
WHERE TreatmentMaster.deleted <>1 AND treatment_type = 'experimental treatment' AND type LIKE 'etude%' AND type NOT LIKE '' AND type IS NOT NULL AND type NOT IN (SELECT generic_name FROM drugs WHERE type = 'experimental treatment');
INSERT INTO drugs (generic_name, type, procure_study, created, created_by, modified, modified_by)
(SELECT DISTINCT TreatmentDetail.type, 'experimental treatment','1', @modified, @modified_by, @modified, @modified_by
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
WHERE TreatmentMaster.deleted <>1 AND treatment_type = 'experimental treatment' AND type LIKE 'etude%' AND type NOT LIKE '' AND type IS NOT NULL AND type NOT IN (SELECT generic_name FROM drugs WHERE type = 'experimental treatment'));
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.drug_id = Drug.id, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.drug_id IS NULL OR TreatmentDetail.drug_id LIKE '')
AND TreatmentDetail.type = Drug.generic_name
AND TreatmentDetail.treatment_type = Drug.type
AND Drug.deleted <> 1
AND treatment_type IN ('experimental treatment');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.type = NULL
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.drug_id = Drug.id
AND TreatmentDetail.type = Drug.generic_name
AND TreatmentDetail.treatment_type = Drug.type
AND Drug.deleted <> 1
AND treatment_type IN ('experimental treatment');

-- *** Chemotherapy *** 

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.drug_id = Drug.id, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.drug_id IS NULL OR TreatmentDetail.drug_id LIKE '')
AND TreatmentDetail.type = Drug.generic_name
AND TreatmentDetail.treatment_type = Drug.type
AND Drug.deleted <> 1
AND treatment_type IN ('chemotherapy');
SELECT DISTINCT TreatmentDetail.type AS '### MESSAGE ### Created following hormonotherapy drugs. Please validate. Check also no treatment combination exists.'
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
WHERE TreatmentMaster.deleted <>1 AND treatment_type = 'chemotherapy' AND type NOT LIKE '%+%' AND type NOT LIKE '' AND type IS NOT NULL AND type NOT IN (SELECT generic_name FROM drugs WHERE type = 'chemotherapy');
INSERT INTO drugs (generic_name, type, procure_study, created, created_by, modified, modified_by)
(SELECT DISTINCT TreatmentDetail.type, 'chemotherapy','0', @modified, @modified_by, @modified, @modified_by
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
WHERE TreatmentMaster.deleted <>1 AND treatment_type = 'chemotherapy' AND type NOT LIKE '%+%' AND type NOT LIKE '' AND type IS NOT NULL AND type NOT IN (SELECT generic_name FROM drugs WHERE type = 'chemotherapy'));
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.drug_id = Drug.id, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.drug_id IS NULL OR TreatmentDetail.drug_id LIKE '')
AND TreatmentDetail.type = Drug.generic_name
AND TreatmentDetail.treatment_type = Drug.type
AND Drug.deleted <> 1
AND treatment_type IN ('chemotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.type = NULL
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.drug_id = Drug.id
AND TreatmentDetail.type = Drug.generic_name
AND TreatmentDetail.treatment_type = Drug.type
AND Drug.deleted <> 1
AND treatment_type IN ('chemotherapy');

-- *** Hormonotherapy *** 

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.drug_id = Drug.id, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.drug_id IS NULL OR TreatmentDetail.drug_id LIKE '')
AND TreatmentDetail.type = Drug.generic_name
AND TreatmentDetail.treatment_type = Drug.type
AND Drug.deleted <> 1
AND treatment_type IN ('hormonotherapy');
SELECT DISTINCT TreatmentDetail.type AS '### MESSAGE ### Created following hormonotherapy drugs. Please validate. Check also no treatment combination exists.'
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
WHERE TreatmentMaster.deleted <>1 AND treatment_type = 'hormonotherapy' AND type NOT LIKE '%+%' AND type NOT LIKE '' AND type IS NOT NULL AND type NOT IN (SELECT generic_name FROM drugs WHERE type = 'hormonotherapy');
INSERT INTO drugs (generic_name, type, procure_study, created, created_by, modified, modified_by)
(SELECT DISTINCT TreatmentDetail.type, 'hormonotherapy','0', @modified, @modified_by, @modified, @modified_by
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
WHERE TreatmentMaster.deleted <>1 AND treatment_type = 'hormonotherapy' AND type NOT LIKE '%+%' AND type NOT LIKE '' AND type IS NOT NULL AND type NOT IN (SELECT generic_name FROM drugs WHERE type = 'hormonotherapy'));
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.drug_id = Drug.id, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.drug_id IS NULL OR TreatmentDetail.drug_id LIKE '')
AND TreatmentDetail.type = Drug.generic_name
AND TreatmentDetail.treatment_type = Drug.type
AND Drug.deleted <> 1
AND treatment_type IN ('hormonotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.type = NULL
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.drug_id = Drug.id
AND TreatmentDetail.type = Drug.generic_name
AND TreatmentDetail.treatment_type = Drug.type
AND Drug.deleted <> 1
AND treatment_type IN ('hormonotherapy');

-- *** Radiotherapy *** 

SELECT "Considered radiotherapy with type = 'implant d'iode 125', 'implant d'iridium-192', 'iode 125' and 'radiotherapie interstitielle de la prostate' as bradytherapy. Please confirm." AS "### MESSAGE ###"; 
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentMaster.notes = CONCAT(TreatmentMaster.notes,' ',TreatmentDetail.type), TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.notes IS NOT NULL
AND TreatmentDetail.type IN ("implant d'iode 125", "implant d'iridium-192", 'iode 125','radiotherapie interstitielle de la prostate')
AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.notes IS NULL
AND TreatmentDetail.type IN ("implant d'iode 125", "implant d'iridium-192", 'iode 125','radiotherapie interstitielle de la prostate')
AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.type = NULL, treatment_type = 'brachytherapy'
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.type IN ("implant d'iode 125", "implant d'iridium-192", 'iode 125','radiotherapie interstitielle de la prostate')
AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.dosage = CONCAT(TreatmentDetail.dosage,' ',TreatmentDetail.type), TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.dosage IS NOT NULL
AND TreatmentDetail.type IN ("33 tx 6600 cGy", '33 Tx en 6600 Gy')
AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.dosage = TreatmentDetail.type, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.dosage IS NULL
AND TreatmentDetail.type IN ("33 tx 6600 cGy", '33 Tx en 6600 Gy')
AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.type = NULL
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.type IN ("33 tx 6600 cGy", '33 Tx en 6600 Gy')
AND treatment_type IN ('radiotherapy');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, en,fr, `use_as_input`, `control_id`)
VALUES
('head and neck','Head and Neck', 'Tête et cou', 1, @control_id ),
('sinus','Sinus', 'Sinus', 1, @control_id ),
('brain','Brain', 'Cerveau', 1, @control_id ),
('thorax/lung','Thorax/Lung', 'Thorax/Poumon', 1, @control_id ),
('true pelvis', 'True Pelvis', 'Petit bassin', 1, @control_id ),
('bone','Bone', 'Os', 1, @control_id ),
('mouth','Mouth','Bouche', 1, @control_id );

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.treatment_site = "prostate bed", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type IN ('radiotherapie de la region pelvienne','radiotherapie pelvienne externe') AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.treatment_site = "head and neck", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie de la tete et du cou' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.treatment_site = "sinus", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie des sinus' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.treatment_site = "brain", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type ='radiotherapie du cerveau' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.treatment_site = "thorax/lung", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie du thorax/poumon' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.treatment_site = "true pelvis", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie externe du petit bassin (true pelvis)' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.treatment_site = "bone", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie osseuse' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.treatment_site = "mouth",  TreatmentMaster.notes = CONCAT(TreatmentMaster.notes, ' ', TreatmentDetail.type), TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NOT NULL
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie endocavitaire de la bouche' AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.treatment_site = "mouth",  TreatmentMaster.notes = TreatmentDetail.type, TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NULL
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie endocavitaire de la bouche' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentMaster.notes = CONCAT(TreatmentMaster.notes, ' ', TreatmentDetail.type), TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NOT NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type = 'etude radicals bras 2' AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type = 'etude radicals bras 2' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NOT NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type  LIKE '%Pelvienne externe IMRT' AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type LIKE '%Pelvienne externe IMRT' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NOT NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type  LIKE 'radiotherapie pelvienne externe' AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type LIKE 'radiotherapie pelvienne externe' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentMaster.notes = CONCAT(TreatmentMaster.notes, ' ', TreatmentDetail.type), TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NOT NULL
AND TreatmentDetail.type = 'radiotherapie (rt) sai' AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NULL
AND TreatmentDetail.type = 'radiotherapie (rt) sai' AND treatment_type IN ('radiotherapy');

-- *** Other Treatment => Notes *** 
 
SELECT 'ERR007' AS '### MESSAGE ###', TreatmentMaster.participant_id, TreatmentMaster.start_date,  TreatmentMaster.start_date_accuracy,
TreatmentDetail.type AS 'Old type removed (Can not match a selected drug, Can be a treatment combination, etc)', 
treatment_site,
treatment_combination,
drug_id,
dosage,
TreatmentMaster.notes
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND (TreatmentDetail.type LIKE '%chimiotherapie non administree (non prevue)%'
OR TreatmentDetail.type LIKE '%chirurgie contre-indiquee (facteurs de risque)%'
OR TreatmentDetail.type LIKE '%chirurgie recommandee, mais non effectuee%'
OR TreatmentDetail.type LIKE '%chirurgie non effectuee (non prevue)%' 
OR TreatmentDetail.type LIKE '%chirurgie recommandee, mais non confirmee%' 
OR TreatmentDetail.type LIKE '%hormonotherapie recommandee, mais non administree%' 	
OR TreatmentDetail.type LIKE '%hormonotherapie recommandee, mais non confirmee%' 
OR TreatmentDetail.type LIKE '%radiotherapie contre-indiquee (facteurs de risque)%' 
OR TreatmentDetail.type LIKE '%radiotherapie recommandee, mais non administree%' 
OR TreatmentDetail.type LIKE '%radiotherapie recommandee, mais non confirmee%' 
OR TreatmentDetail.type LIKE '%refus d%'
OR TreatmentDetail.type LIKE '%traitement systemique non administre (non prevu)%' 
OR TreatmentDetail.type LIKE '%transfert du patient a un autre etablissement%')
AND ((treatment_site IS NOT NULL AND treatment_site NOT LIKE '') OR  
(treatment_combination IS NOT NULL AND treatment_combination NOT LIKE '') OR  
(drug_id IS NOT NULL AND drug_id NOT LIKE '') OR  
(dosage IS NOT NULL AND dosage NOT LIKE '') OR  
(notes IS NOT NULL AND notes NOT LIKE ''));

SET @control_id = (SELECT id FROM event_controls WHERE event_type = 'procure follow-up worksheet - clinical note');
INSERT INTO event_masters (participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, created, created_by, modified, modified_by)
(SELECT TreatmentMaster.participant_id, @control_id, procure_form_identification, TreatmentMaster.start_date,  TreatmentMaster.start_date_accuracy, TreatmentDetail.type, created, created_by, @modified, @modified_by
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND (TreatmentDetail.type LIKE '%chimiotherapie non administree (non prevue)%'
OR TreatmentDetail.type LIKE '%chirurgie contre-indiquee (facteurs de risque)%'
OR TreatmentDetail.type LIKE '%chirurgie recommandee, mais non effectuee%'
OR TreatmentDetail.type LIKE '%chirurgie non effectuee (non prevue)%' 
OR TreatmentDetail.type LIKE '%chirurgie recommandee, mais non confirmee%' 
OR TreatmentDetail.type LIKE '%hormonotherapie recommandee, mais non administree%' 	
OR TreatmentDetail.type LIKE '%hormonotherapie recommandee, mais non confirmee%' 
OR TreatmentDetail.type LIKE '%radiotherapie contre-indiquee (facteurs de risque)%' 
OR TreatmentDetail.type LIKE '%radiotherapie recommandee, mais non administree%' 
OR TreatmentDetail.type LIKE '%radiotherapie recommandee, mais non confirmee%' 
OR TreatmentDetail.type LIKE '%refus d%'
OR TreatmentDetail.type LIKE '%traitement systemique non administre (non prevu)%' 
OR TreatmentDetail.type LIKE '%transfert du patient a un autre etablissement%'));
INSERT INTO procure_ed_followup_worksheet_clinical_notes (event_master_id) (SELECT id FROM event_masters WHERE event_control_id = @control_id AND id NOT IN (SELECT event_master_id FROM procure_ed_followup_worksheet_clinical_notes));
INSERT INTO event_masters_revs (id, participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, version_created, modified_by)
(SELECT id, participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, modified, modified_by FROM event_masters WHERE event_control_id = @control_id AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_ed_followup_worksheet_clinical_notes_revs (event_master_id, version_created) (SELECT id, modified FROM event_masters WHERE event_control_id = @control_id AND modified = @modified AND modified_by = @modified_by);
 
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentMaster.deleted = 1, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND (TreatmentDetail.type LIKE '%chimiotherapie non administree (non prevue)%'
OR TreatmentDetail.type LIKE '%chirurgie contre-indiquee (facteurs de risque)%'
OR TreatmentDetail.type LIKE '%chirurgie recommandee, mais non effectuee%'
OR TreatmentDetail.type LIKE '%chirurgie non effectuee (non prevue)%' 
OR TreatmentDetail.type LIKE '%chirurgie recommandee, mais non confirmee%' 
OR TreatmentDetail.type LIKE '%hormonotherapie recommandee, mais non administree%' 	
OR TreatmentDetail.type LIKE '%hormonotherapie recommandee, mais non confirmee%' 
OR TreatmentDetail.type LIKE '%radiotherapie contre-indiquee (facteurs de risque)%' 
OR TreatmentDetail.type LIKE '%radiotherapie recommandee, mais non administree%' 
OR TreatmentDetail.type LIKE '%radiotherapie recommandee, mais non confirmee%' 
OR TreatmentDetail.type LIKE '%refus d%'
OR TreatmentDetail.type LIKE '%traitement systemique non administre (non prevu)%' 
OR TreatmentDetail.type LIKE '%transfert du patient a un autre etablissement%');
















-- *** FINAL TEST, REVS DATA INSERT AND DELETE COLUMN *** 

SELECT participant_identifier AS '### MESSAGE ### Patient with uncleaned treatment type (field to remove). To clean up after migration.', TreatmentMaster.participant_id, TreatmentDetail.treatment_master_id, 
TreatmentDetail.treatment_type, 
TreatmentDetail.type AS 'Old type removed (Can not match a selected drug, Can be a treatment combination, etc)', 
treatment_site,
treatment_combination,
Drug.type as drug_type, 
Drug.generic_name,
dosage,
TreatmentMaster.notes
FROM participants Participant
INNER JOIN treatment_masters TreatmentMaster ON TreatmentMaster.participant_id = Participant.id
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
LEFT JOIN drugs Drug ON Drug.id = TreatmentDetail.drug_id 
WHERE TreatmentMaster.deleted <>1 AND TreatmentDetail.type IS NOT NULL
ORDER BY treatment_type, TreatmentDetail.type ;

INSERT INTO treatment_masters_revs (id, treatment_control_id,start_date,start_date_accuracy,finish_date,finish_date_accuracy,notes,modified_by,participant_id,diagnosis_master_id,version_created,procure_form_identification)
(SELECT id, treatment_control_id,start_date,start_date_accuracy,finish_date,finish_date_accuracy,notes,modified_by,participant_id,diagnosis_master_id,modified,procure_form_identification
FROM treatment_masters INNER JOIN procure_txd_followup_worksheet_treatments ON id = treatment_master_id WHERE deleted <> 1 AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_followup_worksheet_treatments_revs (treatment_type,type,dosage,treatment_master_id,version_created,drug_id,treatment_site,treatment_precision,treatment_combination,chemotherapy_line)
(SELECT treatment_type,type,dosage,treatment_master_id,modified,drug_id,treatment_site,treatment_precision,treatment_combination,chemotherapy_line
FROM treatment_masters INNER JOIN procure_txd_followup_worksheet_treatments ON id = treatment_master_id WHERE deleted <> 1 AND modified = @modified AND modified_by = @modified_by);

--TODO DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
--TODO DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
--TODO DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
--TODO ALTER TABLE procure_txd_followup_worksheet_treatments DROP COLUMN type;
--TODO ALTER TABLE procure_txd_followup_worksheet_treatments_revs DROP COLUMN type;

UPDATE drugs SET procure_study = '1' WHERE modified = @modified AND modified_by = @modified_by AND generic_name LIKE '%ou placebo%';
UPDATE drugs_revs SET procure_study = '1' WHERE version_created = @modified AND modified_by = @modified_by AND generic_name LIKE '%ou placebo%';
INSERT INTO drugs_revs (id, generic_name, type, procure_study, version_created, modified_by)
(SELECT id, generic_name, type, procure_study, modified, modified_by FROM drugs WHERE modified = @modified AND modified_by = @modified_by);








