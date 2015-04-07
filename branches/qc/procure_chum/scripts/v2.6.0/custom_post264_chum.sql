
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

SET @cst_control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Consent Form Versions');
INSERT INTO `structure_permissible_values_customs` (`value`, `use_as_input`, `control_id`)
(SELECT DISTINCT form_version, 1, @cst_control_id  FROM consent_masters WHERE deleted <> 1 AND form_version NOT LIKE '');

SET @cst_control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Consent version date');
DELETE FROM structure_permissible_values_customs WHERE control_id = @cst_control_id;
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
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = CONCAT(TreatmentMaster.notes,' ',TreatmentDetail.type), TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.notes IS NOT NULL
AND TreatmentDetail.type IN ("implant d'iode 125", "implant d'iridium-192", 'iode 125','radiotherapie interstitielle de la prostate')
AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentMaster.notes IS NULL
AND TreatmentDetail.type IN ("implant d'iode 125", "implant d'iridium-192", 'iode 125','radiotherapie interstitielle de la prostate')
AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = NULL, treatment_type = 'brachytherapy'
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.type IN ("implant d'iode 125", "implant d'iridium-192", 'iode 125','radiotherapie interstitielle de la prostate')
AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.dosage = CONCAT(TreatmentDetail.dosage,' ',TreatmentDetail.type), TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.dosage IS NOT NULL
AND TreatmentDetail.type IN ("33 tx 6600 cGy", '33 Tx en 6600 Gy')
AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.dosage = TreatmentDetail.type, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.dosage IS NULL
AND TreatmentDetail.type IN ("33 tx 6600 cGy", '33 Tx en 6600 Gy')
AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = NULL
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.type IN ("33 tx 6600 cGy", '33 Tx en 6600 Gy')
AND treatment_type IN ('radiotherapy');

SET @rdx_sites_control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, en,fr, `use_as_input`, `control_id`)
VALUES
('head and neck','Head and Neck', 'Tête et cou', 1, @rdx_sites_control_id ),
('sinus','Sinus', 'Sinus', 1, @rdx_sites_control_id ),
('brain','Brain', 'Cerveau', 1, @rdx_sites_control_id ),
('thorax/lung','Thorax/Lung', 'Thorax/Poumon', 1, @rdx_sites_control_id ),
('true pelvis', 'True Pelvis', 'Petit bassin', 1, @rdx_sites_control_id ),
('bone','Bone', 'Os', 1, @rdx_sites_control_id ),
('mouth','Mouth','Bouche', 1, @rdx_sites_control_id );

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.treatment_site = "prostate bed", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type IN ('radiotherapie de la region pelvienne','radiotherapie pelvienne externe') AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.treatment_site = "head and neck", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie de la tete et du cou' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.treatment_site = "sinus", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie des sinus' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.treatment_site = "brain", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type ='radiotherapie du cerveau' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.treatment_site = "thorax/lung", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie du thorax/poumon' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.treatment_site = "true pelvis", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie externe du petit bassin (true pelvis)' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.treatment_site = "bone", TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie osseuse' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.treatment_site = "mouth",  TreatmentMaster.notes = CONCAT(TreatmentMaster.notes, ' ', TreatmentDetail.type), TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NOT NULL
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie endocavitaire de la bouche' AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.treatment_site = "mouth",  TreatmentMaster.notes = TreatmentDetail.type, TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NULL
AND (TreatmentDetail.treatment_site IS NULL OR TreatmentDetail.treatment_site LIKE '')
AND TreatmentDetail.type = 'radiotherapie endocavitaire de la bouche' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = CONCAT(TreatmentMaster.notes, ' ', TreatmentDetail.type), TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NOT NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type = 'etude radicals bras 2' AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type = 'etude radicals bras 2' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NOT NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type  LIKE '%Pelvienne externe IMRT' AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type LIKE '%Pelvienne externe IMRT' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NOT NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type  LIKE 'radiotherapie pelvienne externe' AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NULL
AND TreatmentDetail.treatment_site = "prostate bed"
AND TreatmentDetail.type LIKE 'radiotherapie pelvienne externe' AND treatment_type IN ('radiotherapy');

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = CONCAT(TreatmentMaster.notes, ' ', TreatmentDetail.type), TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NOT NULL
AND TreatmentDetail.type = 'radiotherapie (rt) sai' AND treatment_type IN ('radiotherapy');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
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

SET @ev_note_control_id = (SELECT id FROM event_controls WHERE event_type = 'procure follow-up worksheet - clinical note');
INSERT INTO event_masters (participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, created, created_by, modified, modified_by)
(SELECT TreatmentMaster.participant_id, @ev_note_control_id, procure_form_identification, TreatmentMaster.start_date,  TreatmentMaster.start_date_accuracy, TreatmentDetail.type, created, created_by, @modified, @modified_by
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
INSERT INTO procure_ed_followup_worksheet_clinical_notes (event_master_id) (SELECT id FROM event_masters WHERE event_control_id = @ev_note_control_id AND id NOT IN (SELECT event_master_id FROM procure_ed_followup_worksheet_clinical_notes));
INSERT INTO event_masters_revs (id, participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, version_created, modified_by)
(SELECT id, participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, modified, modified_by FROM event_masters WHERE event_control_id = @ev_note_control_id AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_ed_followup_worksheet_clinical_notes_revs (event_master_id, version_created) (SELECT id, modified FROM event_masters WHERE event_control_id = @ev_note_control_id AND modified = @modified AND modified_by = @modified_by);
 
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

-- *** Other Treatment => Chemo *** 

SET @drug_id = (SELECT id FROM drugs WHERE type = 'chemotherapy' AND generic_name = 'Taxotère');
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentDetail.drug_id = @drug_id, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.drug_id IS NULL OR TreatmentDetail.drug_id LIKE '')
AND treatment_type IN ('other treatment') AND TreatmentDetail.type IN ("protocole taxotere","protocole taxotere q3sem");
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.type = NULL, TreatmentMaster.notes = CONCAT(TreatmentMaster.notes, ' ', TreatmentDetail.type), treatment_type = 'chemotherapy'
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.drug_id = @drug_id
AND treatment_type IN ('other treatment') AND TreatmentDetail.type IN ("protocole taxotere","protocole taxotere q3sem") AND TreatmentMaster.notes IS NOT NULL;
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.type = NULL, TreatmentMaster.notes = TreatmentDetail.type, treatment_type = 'chemotherapy'
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND TreatmentDetail.drug_id = @drug_id
AND treatment_type IN ('other treatment') AND TreatmentDetail.type IN ("protocole taxotere","protocole taxotere q3sem") AND TreatmentMaster.notes IS NULL;

-- *** Other Treatment => as is *** 

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = CONCAT(TreatmentMaster.notes, ' ', TreatmentDetail.type), TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NOT NULL
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("biopsie excisionnelle d'un ganglion",
"dissection des ganglions pelviens",
"dissection des ganglions regionaux de la prostate",
"orchiectomie",
"orchiectomie unilaterale",
"resection anterieure",
"resection transuretrale de la prostate (turp)",
"resection transuretrale de la vessie",
"resection transuretrale du col vesical",
"traitements palliatifs - niveau 3",
"traitements palliatifs - niveau 4",
"traitements palliatifs sai");
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentDetail.type = NULL, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id AND TreatmentMaster.notes IS NULL
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("biopsie excisionnelle d'un ganglion",
"dissection des ganglions pelviens",
"dissection des ganglions regionaux de la prostate",
"orchiectomie",
"orchiectomie unilaterale",
"resection anterieure",
"resection transuretrale de la prostate (turp)",
"resection transuretrale de la vessie",
"resection transuretrale du col vesical",
"traitements palliatifs - niveau 3",
"traitements palliatifs - niveau 4",
"traitements palliatifs sai");

-- *** Other Treatment => prostate drug *** 

UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.drug_id = Drug.id, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.drug_id IS NULL OR TreatmentDetail.drug_id LIKE '')
AND TreatmentDetail.type = Drug.generic_name
AND Drug.type = 'prostate'
AND Drug.deleted <> 1
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("acide zoledronique","denosumab","denosumab ou placebo","finasteride");
SELECT DISTINCT TreatmentDetail.type AS '### MESSAGE ### Created following prostate drugs. Please validate. Check also no treatment combination exists.'
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
WHERE TreatmentMaster.deleted <>1 AND treatment_type = 'other treatment' 
AND TreatmentDetail.type IN ("acide zoledronique","denosumab","denosumab ou placebo","finasteride") 
AND type NOT LIKE '' AND type IS NOT NULL AND type NOT IN (SELECT generic_name FROM drugs WHERE type = 'prostate');
INSERT INTO drugs (generic_name, type, procure_study, created, created_by, modified, modified_by)
(SELECT DISTINCT TreatmentDetail.type, 'prostate','0', @modified, @modified_by, @modified, @modified_by
FROM treatment_masters TreatmentMaster 
INNER JOIN procure_txd_followup_worksheet_treatments TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id 
WHERE TreatmentMaster.deleted <>1 AND treatment_type = 'other treatment' 
AND TreatmentDetail.type IN ("acide zoledronique","denosumab","denosumab ou placebo","finasteride") 
AND type NOT LIKE '' AND type IS NOT NULL AND type NOT IN (SELECT generic_name FROM drugs WHERE type = 'prostate'));
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail, drugs Drug 
SET TreatmentDetail.drug_id = Drug.id, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND (TreatmentDetail.drug_id IS NULL OR TreatmentDetail.drug_id LIKE '')
AND TreatmentDetail.type = Drug.generic_name
AND Drug.type = 'prostate'
AND Drug.deleted <> 1
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("acide zoledronique","denosumab","denosumab ou placebo","finasteride");
SET @ev_drug_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'procure medication worksheet - drug');
INSERT INTO treatment_masters (participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, created, created_by, modified, modified_by,facility,information_source)
(SELECT TreatmentMaster.participant_id, @ev_drug_control_id, procure_form_identification, TreatmentMaster.start_date,  TreatmentMaster.start_date_accuracy, TreatmentDetail.type, created, created_by, @modified, @modified_by, TreatmentDetail.drug_id, '#####DRUG PROSTATE TMP####'
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("acide zoledronique","denosumab","denosumab ou placebo","finasteride"));
INSERT INTO procure_txd_medication_drugs (treatment_master_id, drug_id) (SELECT id, facility FROM treatment_masters WHERE treatment_control_id = @ev_drug_control_id 
AND id NOT IN (SELECT treatment_master_id FROM procure_txd_medication_drugs) AND information_source = '#####DRUG PROSTATE TMP####' AND modified = @modified AND modified_by = @modified_by);
INSERT INTO treatment_masters_revs (id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, version_created, modified_by)
(SELECT id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, modified, modified_by FROM treatment_masters WHERE treatment_control_id = @ev_drug_control_id AND information_source = '#####DRUG PROSTATE TMP####' AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_medication_drugs_revs (treatment_master_id, drug_id, version_created) (SELECT id, facility, modified FROM treatment_masters WHERE treatment_control_id = @ev_drug_control_id AND information_source = '#####DRUG PROSTATE TMP####' AND modified = @modified AND modified_by = @modified_by);
UPDATE treatment_masters SET facility = '', information_source = '' WHERE information_source = '#####DRUG PROSTATE TMP####';
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentMaster.deleted = 1, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("acide zoledronique","denosumab","denosumab ou placebo","finasteride");

-- *** Other Treatment => other tumor treatment *** 

SET @other_tumor_tx_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'procure follow-up worksheet - other tumor tx');

INSERT INTO treatment_masters (participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, created, created_by, modified, modified_by,facility,information_source)
(SELECT TreatmentMaster.participant_id, @other_tumor_tx_control_id, procure_form_identification, TreatmentMaster.start_date,  TreatmentMaster.start_date_accuracy, TreatmentDetail.type, created, created_by, @modified, @modified_by, 'chemotherapy', '#####OTHER TUMOR TX TMP####'
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("protocole folfox","protocole mfolfox 6"));
INSERT INTO procure_txd_followup_worksheet_other_tumor_treatments (treatment_master_id, treatment_type) (SELECT id, facility FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id 
AND id NOT IN (SELECT treatment_master_id FROM procure_txd_followup_worksheet_other_tumor_treatments) AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
INSERT INTO treatment_masters_revs (id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, version_created, modified_by)
(SELECT id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, modified, modified_by FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_followup_worksheet_other_tumor_treatments_revs (treatment_master_id, treatment_type, version_created) (SELECT id, facility, modified FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
UPDATE treatment_masters SET facility = '', information_source = '' WHERE information_source = '#####OTHER TUMOR TX TMP####';
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentMaster.deleted = 1, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("protocole folfox","protocole mfolfox 6");

INSERT INTO treatment_masters (participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, created, created_by, modified, modified_by,facility,information_source)
(SELECT TreatmentMaster.participant_id, @other_tumor_tx_control_id, procure_form_identification, TreatmentMaster.start_date,  TreatmentMaster.start_date_accuracy, TreatmentDetail.type, created, created_by, @modified, @modified_by, 'other', '#####OTHER TUMOR TX TMP####'
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("bcg","everolimus","interferon alfa-2b","protocole 5-fu perfusion + rt pre-operatoire","protocole docetaxel + prednisone","protocole gemcitabine","protocole pemetrexed-cisplatin","protocole r + fc","protocole r-cop","protocole taxol + cisplatin + 5-fu","protocole taxol/carboplatin","rituximab"));
INSERT INTO procure_txd_followup_worksheet_other_tumor_treatments (treatment_master_id, treatment_type) (SELECT id, facility FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id 
AND id NOT IN (SELECT treatment_master_id FROM procure_txd_followup_worksheet_other_tumor_treatments) AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
INSERT INTO treatment_masters_revs (id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, version_created, modified_by)
(SELECT id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, modified, modified_by FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_followup_worksheet_other_tumor_treatments_revs (treatment_master_id, treatment_type, version_created) (SELECT id, facility, modified FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
UPDATE treatment_masters SET facility = '', information_source = '' WHERE information_source = '#####OTHER TUMOR TX TMP####';
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentMaster.deleted = 1, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("bcg","everolimus","interferon alfa-2b","protocole 5-fu perfusion + rt pre-operatoire","protocole docetaxel + prednisone","protocole gemcitabine","protocole pemetrexed-cisplatin","protocole r + fc","protocole r-cop","protocole taxol + cisplatin + 5-fu","protocole taxol/carboplatin","rituximab");

INSERT INTO treatment_masters (participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, created, created_by, modified, modified_by,facility,information_source)
(SELECT TreatmentMaster.participant_id, @other_tumor_tx_control_id, procure_form_identification, TreatmentMaster.start_date,  TreatmentMaster.start_date_accuracy, TreatmentDetail.type, created, created_by, @modified, @modified_by, 'radiotherapy', '#####OTHER TUMOR TX TMP####'
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("protocole cisplatin + radiotherapie"));
INSERT INTO procure_txd_followup_worksheet_other_tumor_treatments (treatment_master_id, treatment_type) (SELECT id, facility FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id 
AND id NOT IN (SELECT treatment_master_id FROM procure_txd_followup_worksheet_other_tumor_treatments) AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
INSERT INTO treatment_masters_revs (id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, version_created, modified_by)
(SELECT id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, modified, modified_by FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_followup_worksheet_other_tumor_treatments_revs (treatment_master_id, treatment_type, version_created) (SELECT id, facility, modified FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
UPDATE treatment_masters SET facility = '', information_source = '' WHERE information_source = '#####OTHER TUMOR TX TMP####';
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentMaster.deleted = 1, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("protocole cisplatin + radiotherapie");

INSERT INTO treatment_masters (participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, created, created_by, modified, modified_by,facility,information_source)
(SELECT TreatmentMaster.participant_id, @other_tumor_tx_control_id, procure_form_identification, TreatmentMaster.start_date,  TreatmentMaster.start_date_accuracy, TreatmentDetail.type, created, created_by, @modified, @modified_by, 'surgery', '#####OTHER TUMOR TX TMP####'
FROM treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("colostomie","cystectomie partielle","destruction de tumeur de la vessie","destruction de tumeur du foie","dissection des ganglions regionaux de la tete et du cou","excision de tumeur de la cornee","gastrectomie partielle/subtotale/hemi","hemicolectomie droite","hepatectomie partielle","ileostomie","installation d'une endoprothese des voies biliaires","laparotomie","mastectomie","nephrectomie","nephrectomie partielle/subtotale","nephrectomie radicale","nephro-ureterectomie","pancreatectomie corporeo-caudale","polypectomie du rectum","splenectomie"));
INSERT INTO procure_txd_followup_worksheet_other_tumor_treatments (treatment_master_id, treatment_type) (SELECT id, facility FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id 
AND id NOT IN (SELECT treatment_master_id FROM procure_txd_followup_worksheet_other_tumor_treatments) AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
INSERT INTO treatment_masters_revs (id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, version_created, modified_by)
(SELECT id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, notes, modified, modified_by FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_followup_worksheet_other_tumor_treatments_revs (treatment_master_id, treatment_type, version_created) (SELECT id, facility, modified FROM treatment_masters WHERE treatment_control_id = @other_tumor_tx_control_id AND information_source = '#####OTHER TUMOR TX TMP####' AND modified = @modified AND modified_by = @modified_by);
UPDATE treatment_masters SET facility = '', information_source = '' WHERE information_source = '#####OTHER TUMOR TX TMP####';
UPDATE treatment_masters TreatmentMaster, procure_txd_followup_worksheet_treatments TreatmentDetail
SET TreatmentMaster.notes = TreatmentDetail.type, TreatmentMaster.deleted = 1, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.id = TreatmentDetail.treatment_master_id
AND treatment_type IN ('other treatment')
AND TreatmentDetail.type IN ("colostomie","cystectomie partielle","destruction de tumeur de la vessie","destruction de tumeur du foie","dissection des ganglions regionaux de la tete et du cou","excision de tumeur de la cornee","gastrectomie partielle/subtotale/hemi","hemicolectomie droite","hepatectomie partielle","ileostomie","installation d'une endoprothese des voies biliaires","laparotomie","mastectomie","nephrectomie","nephrectomie partielle/subtotale","nephrectomie radicale","nephro-ureterectomie","pancreatectomie corporeo-caudale","polypectomie du rectum","splenectomie");

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

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE procure_txd_followup_worksheet_treatments DROP COLUMN type;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs DROP COLUMN type;

UPDATE drugs SET procure_study = '1' WHERE modified = @modified AND modified_by = @modified_by AND generic_name LIKE '%ou placebo%';
UPDATE drugs_revs SET procure_study = '1' WHERE version_created = @modified AND modified_by = @modified_by AND generic_name LIKE '%ou placebo%';
INSERT INTO drugs_revs (id, generic_name, type, procure_study, version_created, modified_by)
(SELECT id, generic_name, type, procure_study, modified, modified_by FROM drugs WHERE modified = @modified AND modified_by = @modified_by);

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Followup - Exam
-- -----------------------------------------------------------------------------------------------------------------------------------------------

SET @modified_by = (SELECT id FROM users WHERE username = 'Migration');
SET @modified = (SELECT NOW() FROM users WHERE username = 'Migration');

-- Set results

SET @clinical_ev_control_id = (SELECT id FROM event_controls WHERE event_type= 'procure follow-up worksheet - clinical event');
UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheet_clinical_events EventDetail
SET results = 'negative', modified = @modified, modified_by = @modified_by
WHERE id = event_master_id AND event_control_id = @clinical_ev_control_id AND deleted <> 1 AND (event_summary LIKE '% : negatif' OR event_summary LIKE '% : négatif');
UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheet_clinical_events EventDetail
SET results = 'positive', modified = @modified, modified_by = @modified_by
WHERE id = event_master_id AND event_control_id = @clinical_ev_control_id AND deleted <> 1 AND (event_summary LIKE '% : positif' OR event_summary LIKE '% : positif, en progression');
UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheet_clinical_events EventDetail
SET results = 'suspicious', modified = @modified, modified_by = @modified_by
WHERE id = event_master_id AND event_control_id = @clinical_ev_control_id AND deleted <> 1 AND (event_summary LIKE '% : suspect' OR event_summary LIKE '% : incertain');
UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheet_clinical_events EventDetail
SET results = 'negative', modified = @modified, modified_by = @modified_by
WHERE id = event_master_id AND event_control_id = @clinical_ev_control_id AND deleted <> 1 AND (event_summary LIKE 'negatif%' OR event_summary LIKE 'négatif%');
UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheet_clinical_events EventDetail
SET results = 'positive', modified = @modified, modified_by = @modified_by
WHERE id = event_master_id AND event_control_id = @clinical_ev_control_id AND deleted <> 1 AND (event_summary LIKE 'positif%');
UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheet_clinical_events EventDetail
SET results = 'suspicious', modified = @modified, modified_by = @modified_by
WHERE id = event_master_id AND event_control_id = @clinical_ev_control_id AND deleted <> 1 AND (event_summary LIKE 'suspect%');

-- Move some records to notes

SET @ev_note_control_id = (SELECT id FROM event_controls WHERE event_type = 'procure follow-up worksheet - clinical note');
INSERT INTO event_masters (participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, created, created_by, modified, modified_by)
(SELECT participant_id, @ev_note_control_id, procure_form_identification,  event_date, event_date_accuracy, event_summary, created, created_by, @modified, @modified_by
FROM event_masters EventMaster, procure_ed_clinical_followup_worksheet_clinical_events EventDetail
WHERE id = event_master_id AND event_control_id = @clinical_ev_control_id AND deleted <> 1 AND (event_summary LIKE 'premiere visite a la%' OR event_summary LIKE 'symptomes post-operatoires%' OR EventDetail.type IN ('other', 'other imaging')));
INSERT INTO procure_ed_followup_worksheet_clinical_notes (event_master_id) (SELECT id FROM event_masters WHERE event_control_id = @ev_note_control_id AND id NOT IN (SELECT event_master_id FROM procure_ed_followup_worksheet_clinical_notes));
INSERT INTO event_masters_revs (id, participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, version_created, modified_by)
(SELECT id, participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, modified, modified_by FROM event_masters WHERE event_control_id = @ev_note_control_id AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_ed_followup_worksheet_clinical_notes_revs (event_master_id, version_created) (SELECT id, modified FROM event_masters WHERE event_control_id = @ev_note_control_id AND modified = @modified AND modified_by = @modified_by);
UPDATE event_masters EventMaster, procure_ed_clinical_followup_worksheet_clinical_events EventDetail
SET deleted = '1', modified = @modified, modified_by = @modified_by
WHERE id = event_master_id AND event_control_id = @clinical_ev_control_id AND deleted <> 1 AND (event_summary LIKE 'premiere visite a la%' OR event_summary LIKE 'symptomes post-operatoires%' OR EventDetail.type IN ('other', 'other imaging'));
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="procure_followup_exam_types" AND spv.value="other" AND spv.language_alias="other";
DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="procure_followup_exam_types" AND spv.value="other imaging" AND spv.language_alias="other imaging";
DELETE FROM structure_permissible_values WHERE value="other imaging" AND language_alias="other imaging" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);

-- revs table

INSERT INTO event_masters_revs (id, event_control_id, event_summary, version_created,modified_by) (SELECT id, event_control_id, event_summary, modified,modified_by FROM event_masters WHERE event_control_id = @clinical_ev_control_id AND  modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_ed_clinical_followup_worksheet_clinical_events_revs (type,event_master_id,version_created,results) (SELECT type,id, modified,results FROM event_masters INNER JOIN procure_ed_clinical_followup_worksheet_clinical_events ON id = event_master_id WHERE event_control_id = @clinical_ev_control_id AND  modified = @modified AND modified_by = @modified_by);

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- SET Followup - Missing Date  & Fiche des médicaments - missing date
-- -----------------------------------------------------------------------------------------------------------------------------------------------

SET @modified_by = (SELECT id FROM users WHERE username = 'Migration');
SET @modified = (SELECT NOW() FROM users WHERE username = 'Migration');
SET @ev_control_id = (SELECT id FROM event_controls WHERE event_type= 'procure follow-up worksheet');

UPDATE event_masters EventMaster, collections Collection
SET EventMaster.event_date = Collection.collection_datetime, EventMaster.event_date_accuracy = Collection.collection_datetime_accuracy, EventMaster.modified = @modified, EventMaster.modified_by = @modified_by
WHERE EventMaster.deleted <> 1 AND EventMaster.event_control_id = @ev_control_id AND (EventMaster.event_date IS NULL OR EventMaster.event_date LIKE '')
AND Collection.participant_id = EventMaster.participant_id AND Collection.deleted <> 1 
AND EventMaster.procure_form_identification REGEXP CONCAT(Collection.procure_visit, ' -FSP')
AND (Collection.collection_datetime IS NOT NULL AND Collection.collection_datetime NOT LIKE '');
UPDATE event_masters EventMaster SET EventMaster.event_date_accuracy = 'c'
WHERE EventMaster.event_date_accuracy NOT IN ('y','m','d')
AND EventMaster.modified = @modified AND EventMaster.modified_by = @modified_by AND EventMaster.deleted <> 1 AND EventMaster.event_control_id = @ev_control_id AND (EventMaster.event_date IS NOT NULL AND EventMaster.event_date NOT LIKE '');

SET @tx_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'procure medication worksheet');
UPDATE treatment_masters TreatmentMaster, collections Collection
SET TreatmentMaster.start_date = Collection.collection_datetime, TreatmentMaster.start_date_accuracy = Collection.collection_datetime_accuracy, TreatmentMaster.modified = @modified, TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.treatment_control_id = @tx_control_id AND (TreatmentMaster.start_date IS NULL OR TreatmentMaster.start_date LIKE '')
AND Collection.participant_id = TreatmentMaster.participant_id AND Collection.deleted <> 1 
AND TreatmentMaster.procure_form_identification REGEXP CONCAT(Collection.procure_visit, ' -MED')
AND (Collection.collection_datetime IS NOT NULL AND Collection.collection_datetime NOT LIKE '');
UPDATE treatment_masters TreatmentMaster SET TreatmentMaster.start_date_accuracy = 'c'
WHERE TreatmentMaster.start_date_accuracy NOT IN ('y','m','d')
AND TreatmentMaster.modified = @modified AND TreatmentMaster.modified_by = @modified_by AND TreatmentMaster.deleted <> 1 AND TreatmentMaster.treatment_control_id = @tx_control_id AND (TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date NOT LIKE '');

INSERT INTO event_masters_revs (id, participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, version_created, modified_by)
(SELECT id, participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, modified, modified_by FROM event_masters WHERE event_control_id = @ev_control_id AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_ed_clinical_followup_worksheets_revs (patient_identity_verified,biochemical_recurrence,clinical_recurrence,clinical_recurrence_type,surgery_for_metastases,surgery_site,surgery_date,surgery_date_accuracy,event_master_id,clinical_recurrence_site_bones,clinical_recurrence_site_liver,clinical_recurrence_site_lungs,clinical_recurrence_site_others,refusing_treatments,method, version_created)
(SELECT patient_identity_verified,biochemical_recurrence,clinical_recurrence,clinical_recurrence_type,surgery_for_metastases,surgery_site,surgery_date,surgery_date_accuracy,event_master_id,clinical_recurrence_site_bones,clinical_recurrence_site_liver,clinical_recurrence_site_lungs,clinical_recurrence_site_others,refusing_treatments,method, modified
FROM event_masters  INNER JOIN procure_ed_clinical_followup_worksheets ON id = event_master_id WHERE event_control_id = @ev_control_id AND modified = @modified AND modified_by = @modified_by);
INSERT INTO treatment_masters_revs (id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, finish_date,finish_date_accuracy,notes, version_created, modified_by)
(SELECT id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, finish_date,finish_date_accuracy,notes, modified, modified_by FROM treatment_masters WHERE treatment_control_id = @tx_control_id AND modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_medications_revs (patient_identity_verified,medication_for_prostate_cancer,medication_for_benign_prostatic_hyperplasia,medication_for_prostatitis,benign_hyperplasia,benign_hyperplasia_place_and_date,benign_hyperplasia_notes,prescribed_drugs_for_other_diseases,list_of_drugs_for_other_diseases,photocopy_of_drugs_for_other_diseases,dosages_of_drugs_for_other_diseases,open_sale_drugs,treatment_master_id, version_created)
(SELECT patient_identity_verified,medication_for_prostate_cancer,medication_for_benign_prostatic_hyperplasia,medication_for_prostatitis,benign_hyperplasia,benign_hyperplasia_place_and_date,benign_hyperplasia_notes,prescribed_drugs_for_other_diseases,list_of_drugs_for_other_diseases,photocopy_of_drugs_for_other_diseases,dosages_of_drugs_for_other_diseases,open_sale_drugs,treatment_master_id, modified
FROM treatment_masters INNER JOIN procure_txd_medications ON id = treatment_master_id WHERE treatment_control_id = @tx_control_id AND modified = @modified AND modified_by = @modified_by);

UPDATE event_masters, procure_ed_clinical_followup_worksheets
SET event_summary = '***TO DELETE***'
WHERE id = event_master_id
AND event_control_id = @ev_control_id
AND (patient_identity_verified IS NULL OR patient_identity_verified LIKE '0')
AND (event_date IS NULL OR event_date LIKE '')
AND (method IS NULL OR method LIKE '')
AND (biochemical_recurrence IS NULL OR biochemical_recurrence LIKE '')
AND (clinical_recurrence IS NULL OR clinical_recurrence LIKE '')
AND (clinical_recurrence_type IS NULL OR clinical_recurrence_type LIKE '')
AND (clinical_recurrence_site_bones IS NULL OR clinical_recurrence_site_bones LIKE '0')
AND (clinical_recurrence_site_liver IS NULL OR clinical_recurrence_site_liver LIKE '0')
AND (clinical_recurrence_site_lungs IS NULL OR clinical_recurrence_site_lungs LIKE '0')
AND (clinical_recurrence_site_others IS NULL OR clinical_recurrence_site_others LIKE '0')
AND (surgery_for_metastases IS NULL OR surgery_for_metastases LIKE '')
AND (surgery_site IS NULL OR surgery_site LIKE '')
AND (surgery_date IS NULL OR surgery_date LIKE '')
AND (refusing_treatments IS NULL OR refusing_treatments LIKE '')
AND (event_summary IS NULL OR event_summary LIKE '');
DELETE FROM procure_ed_clinical_followup_worksheets WHERE event_master_id IN (SELECT id FROM event_masters WHERE event_summary = '***TO DELETE***' AND event_control_id = @ev_control_id);
DELETE FROM procure_ed_clinical_followup_worksheets_revs WHERE event_master_id IN (SELECT id FROM event_masters WHERE event_summary = '***TO DELETE***' AND event_control_id = @ev_control_id);
DELETE FROM event_masters_revs WHERE id IN (SELECT id FROM event_masters WHERE event_summary = '***TO DELETE***' AND event_control_id = @ev_control_id);
DELETE FROM event_masters WHERE event_summary = '***TO DELETE***' AND event_control_id = @ev_control_id;

SELECT procure_form_identification AS '### MESSAGE ### Follow-up Worksheet with no date (after clean up) to correct', participant_id, EventMaster.id AS event_master_id
FROM event_masters EventMaster INNER JOIN event_controls EventControl ON EventMaster.event_control_id = EventControl.id 
WHERE EventMaster.deleted <> 1 AND EventControl.event_type IN ('procure follow-up worksheet') AND (EventMaster.event_date IS NULL OR EventMaster.event_date LIKE '')
ORDER BY procure_form_identification;

SELECT procure_form_identification AS '### MESSAGE ### Medication Worksheet with no date (after clean up) to correct', participant_id, TreatmentMaster.id AS treatment_master_id
FROM treatment_masters TreatmentMaster INNER JOIN treatment_controls TreatmentControl ON TreatmentMaster.treatment_control_id = TreatmentControl.id 
WHERE TreatmentMaster.deleted <> 1 AND TreatmentControl.tx_method = 'procure medication worksheet' AND (TreatmentMaster.start_date IS NULL OR TreatmentMaster.start_date LIKE '')
ORDER BY procure_form_identification;

-- Clean diagnosis and treatment report

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Datamart' AND `model`='0' AND `tablename`='' AND `field`='qc_nd_aborted_prostatectomy' AND `language_label`='aborted prostatectomy' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_diagnosis_and_treatments_report_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Datamart' AND `model`='0' AND `tablename`='' AND `field`='qc_nd_curietherapy' AND `language_label`='curietherapy' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Datamart' AND `model`='0' AND `tablename`='' AND `field`='qc_nd_aborted_prostatectomy' AND `language_label`='aborted prostatectomy' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='Datamart' AND `model`='0' AND `tablename`='' AND `field`='qc_nd_curietherapy' AND `language_label`='curietherapy' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Datamart' AND `model`='0' AND `tablename`='' AND `field`='qc_nd_aborted_prostatectomy' AND `language_label`='aborted prostatectomy' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='Datamart' AND `model`='0' AND `tablename`='' AND `field`='qc_nd_curietherapy' AND `language_label`='curietherapy' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- Blood tube storage data clean up
-- -----------------------------------------------------------------------------------------------------------------------------------------------

SET @modified_by = (SELECT id FROM users WHERE username = 'Migration');
SET @modified = (SELECT NOW() FROM users WHERE username = 'Migration');

SET @blood_tube_control_id = (SELECT AliquotControl.id FROM aliquot_controls AliquotControl, sample_controls SampleControl WHERE AliquotControl.aliquot_type = 'tube' AND AliquotControl.sample_control_id = SampleControl.id AND SampleControl.sample_type = 'blood');

-- Record box and position

UPDATE aliquot_masters AliquotMaster, ad_tubes AliquotDetail, sd_spe_bloods SampleDetail, storage_masters StorageMaster
SET AliquotMaster.notes = CONCAT(AliquotMaster.notes, ' Storage was defined as [box: ', StorageMaster.selection_label,' - position: ', AliquotMaster.storage_coord_x,']')
WHERE AliquotMaster.aliquot_control_id = @blood_tube_control_id
AND AliquotMaster.deleted <> 1
AND AliquotMaster.id = AliquotDetail.aliquot_master_id
AND SampleDetail.sample_master_id = AliquotMaster.sample_master_id
AND SampleDetail.blood_type != 'paxgene'
AND AliquotMaster.in_stock != 'no'
AND AliquotMaster.storage_master_id = StorageMaster.id
AND AliquotMaster.storage_coord_x IS NOT NULL AND AliquotMaster.storage_coord_x NOT LIKE ''
AND AliquotMaster.notes NOT LIKE '' AND AliquotMaster.notes IS NOT NULL;

UPDATE aliquot_masters AliquotMaster, ad_tubes AliquotDetail, sd_spe_bloods SampleDetail, storage_masters StorageMaster
SET AliquotMaster.notes = CONCAT('Storage was defined as [box: ', StorageMaster.selection_label,' - position: ', AliquotMaster.storage_coord_x,']')
WHERE AliquotMaster.aliquot_control_id = @blood_tube_control_id
AND AliquotMaster.deleted <> 1
AND AliquotMaster.id = AliquotDetail.aliquot_master_id
AND SampleDetail.sample_master_id = AliquotMaster.sample_master_id
AND SampleDetail.blood_type != 'paxgene'
AND AliquotMaster.in_stock != 'no'
AND AliquotMaster.storage_master_id = StorageMaster.id
AND AliquotMaster.storage_coord_x IS NOT NULL AND AliquotMaster.storage_coord_x NOT LIKE ''
AND (AliquotMaster.notes LIKE '' OR AliquotMaster.notes IS NULL);

-- Record box and position

UPDATE aliquot_masters AliquotMaster, ad_tubes AliquotDetail, sd_spe_bloods SampleDetail, storage_masters StorageMaster
SET AliquotMaster.notes = CONCAT(AliquotMaster.notes, ' Storage was defined as [box: ', StorageMaster.selection_label,']')
WHERE AliquotMaster.aliquot_control_id = @blood_tube_control_id
AND AliquotMaster.deleted <> 1
AND AliquotMaster.id = AliquotDetail.aliquot_master_id
AND SampleDetail.sample_master_id = AliquotMaster.sample_master_id
AND SampleDetail.blood_type != 'paxgene'
AND AliquotMaster.in_stock != 'no'
AND AliquotMaster.storage_master_id = StorageMaster.id
AND (AliquotMaster.storage_coord_x IS NULL OR AliquotMaster.storage_coord_x LIKE '')
AND AliquotMaster.notes NOT LIKE '' AND AliquotMaster.notes IS NOT NULL;

UPDATE aliquot_masters AliquotMaster, ad_tubes AliquotDetail, sd_spe_bloods SampleDetail, storage_masters StorageMaster
SET AliquotMaster.notes = CONCAT('Storage was defined as [box: ', StorageMaster.selection_label,']')
WHERE AliquotMaster.aliquot_control_id = @blood_tube_control_id
AND AliquotMaster.deleted <> 1
AND AliquotMaster.id = AliquotDetail.aliquot_master_id
AND SampleDetail.sample_master_id = AliquotMaster.sample_master_id
AND SampleDetail.blood_type != 'paxgene'
AND AliquotMaster.in_stock != 'no'
AND AliquotMaster.storage_master_id = StorageMaster.id
AND (AliquotMaster.storage_coord_x IS NULL OR AliquotMaster.storage_coord_x LIKE '')
AND (AliquotMaster.notes LIKE '' OR AliquotMaster.notes IS NULL);

-- Remove storage data

UPDATE aliquot_masters AliquotMaster, ad_tubes AliquotDetail, sd_spe_bloods SampleDetail
SET AliquotMaster.in_stock = 'no', AliquotMaster.storage_master_id = null, AliquotMaster.storage_coord_x = null, AliquotMaster.storage_coord_y = null, modified = @modified, modified_by = @modified_by
WHERE AliquotMaster.aliquot_control_id = @blood_tube_control_id
AND AliquotMaster.deleted <> 1
AND AliquotMaster.id = AliquotDetail.aliquot_master_id
AND SampleDetail.sample_master_id = AliquotMaster.sample_master_id
AND SampleDetail.blood_type != 'paxgene'
AND AliquotMaster.in_stock != 'no';
INSERT INTO aliquot_masters_revs( id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id, initial_volume,current_volume,in_stock,in_stock_detail,use_counter,study_summary_id,storage_datetime,
storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,qc_nd_stored_by,version_created,modified_by)
(SELECT id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id, initial_volume,current_volume,in_stock,in_stock_detail,use_counter,study_summary_id,storage_datetime,
storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes,qc_nd_stored_by,modified,modified_by FROM aliquot_masters WHERE aliquot_control_id = @blood_tube_control_id AND modified = @modified AND modified_by = @modified_by);
INSERT INTO ad_tubes_revs (aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,procure_expiration_date,procure_tube_weight_gr,procure_total_quantity_ug,qc_nd_storage_solution,qc_nd_purification_method,procure_concentration_nanodrop,procure_concentration_unit_nanodrop,procure_total_quantity_ug_nanodrop,version_created)
(SELECT aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,procure_expiration_date,procure_tube_weight_gr,procure_total_quantity_ug,qc_nd_storage_solution,qc_nd_purification_method,procure_concentration_nanodrop,procure_concentration_unit_nanodrop,procure_total_quantity_ug_nanodrop,modified
FROM aliquot_masters INNER JOIN ad_tubes ON id = aliquot_master_id WHERE aliquot_control_id = @blood_tube_control_id AND modified = @modified AND modified_by = @modified_by);
