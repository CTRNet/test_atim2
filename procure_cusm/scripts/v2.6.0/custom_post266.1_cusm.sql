-- Whatman paper storage date correction (see custom_post263 script)

SELECT "Validate date and time for fields 'Card completed at' and 'Sealed on' and erase value of field 'Initial Storage Date' (nothing to do if section below is empty)" AS '### TODO ###';
SELECT barcode as 'Whatman Papaer Barcode', storage_datetime, procure_card_completed_datetime, procure_card_sealed_date
FROM aliquot_masters 
INNER JOIN ad_whatman_papers ON id = aliquot_master_id
WHERE deleted <> 1 AND aliquot_control_id = (select id from aliquot_controls WHERE aliquot_type = 'whatman paper') AND storage_datetime IS NOT NULL;

-- Create prostatectomy

SELECT 'Created prostatectomy based on tissue collection date' AS '### TO VALIDATE ###';
SET @tissue_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'tissue');
SET @user_id = (SELECT id FROM users WHERE username LIKE 'NicoEn');
SET @date = (SELECT NOW() FROM users WHERE username LIKE 'NicoEn');
SET @treatment_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'procure follow-up worksheet - treatment');
INSERT INTO treatment_masters (participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, procure_created_by_bank, modified, created, created_by, modified_by)
(SELECT DISTINCT participant_id, @treatment_control_id, CONCAT(participant_identifier, ' Vx -FSPx'), collection_datetime, collection_datetime_accuracy, '3', @date, @date, @user_id, @user_id
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id
INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
WHERE SampleMaster.sample_control_id = @tissue_control_id AND SampleMaster.deleted <> 1);
UPDATE treatment_masters SET start_date_accuracy = 'c' WHERE start_date_accuracy IN ('h','i') AND treatment_control_id = @treatment_control_id AND created = @date AND created_by = @user_id;
INSERT INTO procure_txd_followup_worksheet_treatments (treatment_type, treatment_master_id)
(SELECT 'prostatectomy', id FROM treatment_masters WHERE treatment_control_id = @treatment_control_id AND created = @date AND created_by = @user_id);
INSERT INTO treatment_masters_revs (id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, procure_created_by_bank, version_created, modified_by)
(SELECT id, participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, procure_created_by_bank, created, created_by FROM treatment_masters WHERE treatment_control_id = @treatment_control_id AND created = @date AND created_by = @user_id);
INSERT INTO procure_txd_followup_worksheet_treatments_revs (treatment_type, treatment_master_id, version_created)
(SELECT 'prostatectomy', id, created FROM treatment_masters WHERE treatment_control_id = @treatment_control_id AND created = @date AND created_by = @user_id);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- procure_txd_followup_worksheet_treatments.type field deletion
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE procure_txd_followup_worksheet_treatments SET type = 'LH-RH + Casodex' WHERE type = 'LH-RH-Casodex';
UPDATE procure_txd_followup_worksheet_treatments SET type = 'LH-RH + Casodex' WHERE type = 'LR-RH+Casodex';
UPDATE procure_txd_followup_worksheet_treatments SET type = 'LH-RH + Casodex' WHERE type = 'casodex+ LhRh';

SET @user_id = (SELECT id FROM users WHERE username LIKE 'NicoEn');
SET @date = (SELECT NOW() FROM users WHERE username LIKE 'NicoEn');

-- other treatment : Casodex

UPDATE treatment_masters, procure_txd_followup_worksheet_treatments
SET notes = CONCAT("Was flagged as 'other treatment - Casodex'. ",notes), type = CONCAT(type, ' *** Migrated ***')
WHERE id = treatment_master_id AND notes IS NOT NULL AND  treatment_type = 'other treatment' AND type = 'Casodex';
UPDATE treatment_masters, procure_txd_followup_worksheet_treatments
SET notes = "Was flagged as 'other treatment - Casodex'", type = CONCAT(type, ' *** Migrated ***')
WHERE id = treatment_master_id AND notes IS NULL AND  treatment_type = 'other treatment' AND type = 'Casodex';

-- chemotherapy and hormonotherapy

INSERT INTO drugs (type, generic_name, created, created_by, modified, modified_by)
(select distinct treatment_type, type, @date, @user_id, @date, @user_id FROM procure_txd_followup_worksheet_treatments WHERE treatment_type IN ('chemotherapy', 'hormonotherapy') AND type IS NOT NULL AND type NOT LIKE '' ORDER BY treatment_type);
INSERT INTO drugs_revs (id, type, generic_name, version_created, modified_by)
(SELECT id, type, generic_name, created, created_by FROM drugs WHERE created = @date AND created_by = @user_id);
UPDATE procure_txd_followup_worksheet_treatments Tx, drugs Dg 
SET Tx.drug_id = Dg.id, Tx.type = CONCAT(Tx.type, ' *** Migrated ***')
WHERE Tx.treatment_type IN ('chemotherapy', 'hormonotherapy')
AND Tx.treatment_type = Dg.type AND Dg.generic_name = Tx.type AND Tx.drug_id IS NULL;

-- radiotherapy

ALTER TABLE procure_txd_followup_worksheet_treatments
  ADD COLUMN procure_cusm_protocol varchar(50);
ALTER TABLE procure_txd_followup_worksheet_treatments_revs
  ADD COLUMN procure_cusm_protocol varchar(50);

INSERT INTO structure_value_domains (domain_name, source) 
VALUES 
('procure_chuq_treatment_protocols', "StructurePermissibleValuesCustom::getCustomDropdown(\'Treatment Protocols\')");
INSERT INTO structure_permissible_values_custom_controls (name, category, values_max_length) 
VALUES 
('Treatment Protocols', 'clinical - treatment', '50');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'procure_txd_followup_worksheet_treatments', 'procure_cusm_protocol', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_protocols') , '0', '', '', '', 'protocol', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='procure_cusm_protocol' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_chuq_treatment_protocols')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='protocol' AND `language_tag`=''), '1', '30', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE procure_txd_followup_worksheet_treatments SET treatment_precision = type, type = CONCAT(type, ' *** Migrated ***') WHERE treatment_type IN ('radiotherapy') AND type IN ('adjuvant', 'palliative', 'salvage');

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Protocols');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('RTOG-0534','','',  '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE procure_txd_followup_worksheet_treatments SET procure_cusm_protocol = 'RTOG-0534', type = CONCAT(type, ' *** Migrated ***') WHERE treatment_type IN ('radiotherapy') AND type IN ('RTOG-0534');

-- radiotherapy + hormonotherapy

UPDATE procure_txd_followup_worksheet_treatments Tx, drugs Dg 
SET Tx.drug_id = Dg.id, Tx.type = CONCAT(Tx.type, ' *** Migrated ***')
WHERE Tx.treatment_type IN ('radiotherapy + hormonotherapy')
AND 'hormonotherapy' = Dg.type AND Dg.generic_name = Tx.type AND Tx.drug_id IS NULL;

UPDATE procure_txd_followup_worksheet_treatments Tx
SET Tx.treatment_site = 'prostate bed', Tx.type = CONCAT(Tx.type, ' *** Migrated ***')
WHERE Tx.treatment_type IN ('radiotherapy + hormonotherapy') AND 'radio, prostatic bed' = Tx.type AND Tx.treatment_site IS NULL;
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiotherapy Sites');
INSERT INTO `structure_permissible_values_customs` (`value`, en, fr, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`)
VALUES
('nodal','','',  '1', @control_id, NOW(), NOW(), 1, 1);
UPDATE procure_txd_followup_worksheet_treatments Tx
SET Tx.treatment_site = 'nodal', Tx.type = CONCAT(Tx.type, ' *** Migrated ***')
WHERE Tx.treatment_type IN ('radiotherapy + hormonotherapy') AND 'nodal' = Tx.type AND Tx.treatment_site IS NULL;

SET @user_id = (SELECT id FROM users WHERE username LIKE 'NicoEn');
SET @date = (SELECT NOW() FROM users WHERE username LIKE 'NicoEn');

UPDATE treatment_masters, procure_txd_followup_worksheet_treatments
SET notes = CONCAT('radiotherapy + hormonotherapy. ', notes), treatment_combination = 'y', modified = @date, modified_by = @user_id
WHERE id = treatment_master_id AND notes IS NOT NULL AND  treatment_type = 'radiotherapy + hormonotherapy';
UPDATE treatment_masters, procure_txd_followup_worksheet_treatments
SET notes = 'radiotherapy + hormonotherapy', treatment_combination = 'y', modified = @date, modified_by = @user_id
WHERE id = treatment_master_id AND notes IS NULL AND  treatment_type = 'radiotherapy + hormonotherapy';

ALTER TABLE treatment_masters ADD COLUMN source_id int(11);
INSERT INTO treatment_masters (source_id, treatment_control_id, start_date, start_date_accuracy, finish_date, finish_date_accuracy, notes, participant_id, created, created_by, modified, modified_by, procure_form_identification, procure_created_by_bank)
(SELECT id, treatment_control_id, start_date, start_date_accuracy, finish_date, finish_date_accuracy, notes, participant_id, @date, @user_id, @date, @user_id, procure_form_identification, procure_created_by_bank
FROM treatment_masters, procure_txd_followup_worksheet_treatments WHERE id = treatment_master_id AND  treatment_type = 'radiotherapy + hormonotherapy');
INSERT INTO procure_txd_followup_worksheet_treatments (treatment_type,type,treatment_master_id,drug_id,treatment_precision,treatment_combination,treatment_line)
(SELECT 'hormonotherapy',type,id,drug_id,treatment_precision,treatment_combination,treatment_line
FROM treatment_masters, procure_txd_followup_worksheet_treatments WHERE source_id = treatment_master_id);
UPDATE procure_txd_followup_worksheet_treatments SET treatment_type = 'radiotherapy', drug_id = null WHERE treatment_type = 'radiotherapy + hormonotherapy';

-- revs table update

SET @user_id = (SELECT id FROM users WHERE username LIKE 'NicoEn');
SET @date = (SELECT NOW() FROM users WHERE username LIKE 'NicoEn');

UPDATE treatment_masters, procure_txd_followup_worksheet_treatments SET modified = @date, modified_by = @user_id WHERE id = treatment_master_id AND type LIKE '% *** Migrated ***';
INSERT INTO treatment_masters_revs (id,treatment_control_id,start_date,start_date_accuracy,finish_date,finish_date_accuracy,notes,modified_by,participant_id,version_created,procure_form_identification,procure_created_by_bank)
(SELECT id,treatment_control_id,start_date,start_date_accuracy,finish_date,finish_date_accuracy,notes,modified_by,participant_id,modified,procure_form_identification,procure_created_by_bank FROM treatment_masters WHERE  modified = @date AND modified_by = @user_id);
INSERT INTO procure_txd_followup_worksheet_treatments_revs (treatment_type,type,dosage,treatment_master_id,drug_id,treatment_site,treatment_precision,treatment_combination,treatment_line,procure_cusm_protocol,version_created)
(SELECT treatment_type,type,dosage,treatment_master_id,drug_id,treatment_site,treatment_precision,treatment_combination,treatment_line,procure_cusm_protocol,modified
FROM treatment_masters, procure_txd_followup_worksheet_treatments WHERE id = treatment_master_id AND modified = @date AND modified_by = @user_id);

-- type deletion

SELECT count(*) 'Nbr of treatment type unmigrated (should be eqaul to 0)' FROM procure_txd_followup_worksheet_treatments WHERE type IS NOT NULL AND type NOT LIKE '% *** Migrated ***' AND type NOT LIKE '';
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_followup_worksheet_treatment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_followup_worksheet_treatments' AND `field`='type' AND `language_label`='type (to remove)' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
ALTER TABLE procure_txd_followup_worksheet_treatments DROP COLUMN type;
ALTER TABLE procure_txd_followup_worksheet_treatments_revs DROP COLUMN type;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_permissible_values_custom_controls 
SET flag_active = 0
WHERE name IN ('Orders Institutions', 'Orders Contacts', 'Quality Control Tools', 'Laboratory Sites', 'Specimen Collection Sites', 'Specimen Supplier Departments');

--

UPDATE participants SET procure_last_modification_by_bank = '3';
UPDATE participants_revs SET procure_last_modification_by_bank = '3';
UPDATE consent_masters SET procure_created_by_bank = '3';
UPDATE consent_masters_revs SET procure_created_by_bank = '3';
UPDATE event_masters SET procure_created_by_bank = '3';
UPDATE event_masters_revs SET procure_created_by_bank = '3';
UPDATE treatment_masters SET procure_created_by_bank = '3';
UPDATE treatment_masters_revs SET procure_created_by_bank = '3';
UPDATE collections SET procure_collected_by_bank = '3';
UPDATE collections_revs SET procure_collected_by_bank = '3';
UPDATE sample_masters SET procure_created_by_bank = '3';
UPDATE sample_masters_revs SET procure_created_by_bank = '3';
UPDATE aliquot_masters SET procure_created_by_bank = '3';
UPDATE aliquot_masters_revs SET procure_created_by_bank = '3';
UPDATE aliquot_internal_uses SET procure_created_by_bank = '3';
UPDATE aliquot_internal_uses_revs SET procure_created_by_bank = '3';
UPDATE quality_ctrls SET procure_created_by_bank = '3';
UPDATE quality_ctrls_revs SET procure_created_by_bank = '3';

--

SELECT count(*) AS 'Wrong Participant Identifier (should be equal to 0)' FROM participants WHERE participant_identifier NOT LIKE 'PS3P0%';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET site_branch_build_number = '6371' WHERE version_number = '2.6.6';
