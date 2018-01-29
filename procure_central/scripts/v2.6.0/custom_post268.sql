
-- 2017-11-07
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Last Contact

SELECT "Added a new field 'Last Contact' to the participant form. Review each installation and check this field is not duplicated like at the CHUM." AS '### WARNING ###';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_last_contact', 'date',  NULL , '0', '', '', 'procure_help_last_contact', 'last contact', ''), 
('ClinicalAnnotation', 'Participant', 'participants', 'procure_last_contact_details', 'textarea',  NULL , '0', 'rows=1,cols=30', '', '', '', 'details');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_last_contact' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='procure_help_last_contact' AND `language_label`='last contact' AND `language_tag`=''), '1', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_last_contact_details' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=1,cols=30' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='details'), '1', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
ALTER TABLE participants 
  ADD COLUMN procure_last_contact date DEFAULT NULL,
  ADD COLUMN procure_last_contact_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN procure_last_contact_details text;
ALTER TABLE participants_revs 
  ADD COLUMN procure_last_contact date DEFAULT NULL,
  ADD COLUMN procure_last_contact_accuracy char(1) NOT NULL DEFAULT '',
  ADD COLUMN procure_last_contact_details text;
UPDATE structure_formats SET `flag_search`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_last_contact_details' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_fields SET `language_label`='last contact details',  `language_tag`='' WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_last_contact_details' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('last contact', 'Last Contact', 'Dernier Contact'),
('last contact details', 'Details (Last Contact)', 'Détails (Dernier Contact)'),
('procure_help_last_contact', 
"Date when the patient was seen by a person from the hospital or bank, contacted or defined as 'alive' by a trusted source",
"Date à laquelle le patient à été vu par une personne de l'hôpital ou de la banque, a été contacté ou a été défini comme 'En vie' par une source 'de confiance'.");

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Clinical Note Types');
UPDATE `structure_permissible_values_customs`
SET use_as_input = '0' 
WHERE value = 'survival date' AND control_id = @control_id;
 
SELECT CONCAT(count(*), " clinical note(s) was/were flagged as 'survival date'. Please update participant last contact if required.") AS '###WARNING###'
FROM event_masters INNER JOIN procure_ed_clinical_notes ON id = event_master_id 
WHERE deleted <> 1 AND type = 'survival date';

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("the 'last contact date' is currently set to '%s'", "The 'last contact date' is currently '%s'.", "La date de dernier contacte est actuellement '%s'."),
('set last contact date to the date of the visit of the form you compelted today', "Set by default the 'Last contact' date to the date of the visit of the form you compelted today.", 
 "La date du dernier contact a été mise par défaut à la date du formulaire de visite que vous avez complété aujourd'hui.");

-- Remove Study Menu

UPDATE menus SET flag_active = 0 WHERE use_link LIKE '%/EventMasters/listall/Study%';
SELECT 'At least one event_controls group is equal to study' as '###WARNING###' from event_controls where flag_active = 1 AND event_group = 'study';

-- Labo

REPLACE INTO i18n (id,en,fr)
VALUES
('procure_ed_followup_worksheet_aps_help',
"Set the PSA value as a biochemical recurrence only when this recurrence is identified by the project physician/clinician or by a project 'competent' person and this recurrence has not been previously defined (unless the physiscian defined it as a new recurrence). Add a note to calrify the annotation if required.",
"Ne définissez la valeur de PSA comme une récurrence biochimique que si cette récurrence est identifiée par le médecin/clinicien ou par une personne 'compétente' du projet et si cette récurrence n'a pas été définie précédemment (sauf si le médecin l'a définie comme une nouvelle récurrence). Ajouter une note au besoin pour clarifier l'annotation.");

ALTER TABLE procure_ed_laboratories ADD COLUMN bcr_definition_precision text;
ALTER TABLE procure_ed_laboratories_revs ADD COLUMN bcr_definition_precision text;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventDetail', 'procure_ed_laboratories', 'bcr_definition_precision', 'textarea',  NULL , '0', 'rows=1,cols=30', '', 'procure_help_bcr_definition_precision', 'bcr_definition_precision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_ed_laboratories'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='procure_ed_laboratories' AND `field`='bcr_definition_precision' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=1,cols=30' AND `default`='' AND `language_help`='procure_help_bcr_definition_precision' AND `language_label`='bcr_definition_precision' AND `language_tag`=''), '1', '13', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '1', '0', '1', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en,fr) 
VALUES
("bcr_definition_precision", "Biochemical Relapse Precision", "Récidive biochimique - Précision"),
("procure_help_bcr_definition_precision", 
"Any information (if required) on the person who identified the biochemical relapse and the criteria that led to this diagnosis.", 
"Toute information (si nécessaire) sur la personne qui a identifié la rechute biochimique et les critères qui ont conduit à ce diagnostic.");

-- Traitement

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_txd_treatments') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='treatment_line' AND `language_label`='line' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_line') AND `language_help`='procure_help_treatment_line' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='treatment_line' AND `language_label`='line' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_line') AND `language_help`='procure_help_treatment_line' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='TreatmentDetail' AND `tablename`='procure_txd_treatments' AND `field`='treatment_line' AND `language_label`='line' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='procure_treatment_line') AND `language_help`='procure_help_treatment_line' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
ALTER TABLE procure_txd_treatments CHANGE treatment_line procure_deprecated_field_treatment_line varchar(3) default null;
ALTER TABLE procure_txd_treatments_revs CHANGE treatment_line procure_deprecated_field_treatment_line varchar(3) default null;
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("procure_dose_frequence_change_warning",
"Please create a new treatment record if the dose and/or the frequency changed over the time with the start and the finish dates completed.",
"Veuillez créer un nouveau traitement si la dose et/ou la fréquence ont changé au cours du temps en saissant les dates de début et de fin.");

-- refusal / withdrawal

UPDATE structure_formats SET `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_patient_withdrawn' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_next_collections_refusal', 'checkbox',  NULL , '0', '', '', 'procure_help_next_collections_refusal', 'refusal to participate to next collections', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_next_collections_refusal' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='procure_help_next_collections_refusal' AND `language_label`='refusal to participate to next collections' AND `language_tag`=''), '3', '39', 'refusal / withdrawal', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('refusal / withdrawal', 'Refusal/Withdrawal', 'Refus/Désistement'),
('refusal to participate to next collections',
"Refusal Next Collections",
"Refus des prochaines collections"),
("procure_help_next_collections_refusal",
"Refusal to participate to next collections",
"Refus de participer aux prochaines collections");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_next_visits_refusal', 'checkbox',  NULL , '0', '', '', 'procure_help_next_visits_refusal', 'refusal to participate to next visits', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_next_visits_refusal' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='procure_help_next_visits_refusal' AND `language_label`='refusal to participate to next visits' AND `language_tag`=''), '3', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('refusal to participate to next visits',
"Refusal Next Visits",
"Refus des prochaines visits"),
("procure_help_next_visits_refusal",
"Refusal to participate to next visits",
"Refus de participer aux prochaines collections");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_refusal_to_be_contacted', 'checkbox',  NULL , '0', '', '', 'procure_help_refusal_to_be_contacted', 'refusal to be contacted', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_refusal_to_be_contacted' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='procure_help_refusal_to_be_contacted' AND `language_label`='refusal to be contacted' AND `language_tag`=''), '3', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('refusal to be contacted',
"Refusal To Be Contacted",
"Refus d'être contacté"),
("procure_help_refusal_to_be_contacted",
"Refusal to be contacted",
"Refus d'être contacté");

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_clinical_file_update_refusal', 'checkbox',  NULL , '0', '', '', 'procure_help_clinical_file_update_refusal', 'clinical file update refusal', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_clinical_file_update_refusal' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='procure_help_clinical_file_update_refusal' AND `language_label`='clinical file update refusal' AND `language_tag`=''), '3', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('clinical file update refusal',
"Clinical File Update Refusal",
"Refus de mise à jour du dossier clinique"),
("procure_help_clinical_file_update_refusal",
"Clinical File Update Refusal",
"Refus de mise à jour du dossier clinique");

ALTER TABLE participants
  ADD COLUMN procure_next_collections_refusal tinyint(1) DEFAULT '0',
  ADD COLUMN procure_next_visits_refusal tinyint(1) DEFAULT '0',
  ADD COLUMN procure_refusal_to_be_contacted tinyint(1) DEFAULT '0',
  ADD COLUMN procure_clinical_file_update_refusal tinyint(1) DEFAULT '0',
  CHANGE procure_patient_withdrawn_date procure_patient_refusal_withdrawal_date date DEFAULT NULL,
  CHANGE procure_patient_withdrawn_date_accuracy procure_patient_refusal_withdrawal_date_accuracy char(1) NOT NULL DEFAULT '',
  CHANGE procure_patient_withdrawn_reason procure_patient_refusal_withdrawal_reason text;
ALTER TABLE participants_revs
  ADD COLUMN procure_next_collections_refusal tinyint(1) DEFAULT '0',
  ADD COLUMN procure_next_visits_refusal tinyint(1) DEFAULT '0',
  ADD COLUMN procure_refusal_to_be_contacted tinyint(1) DEFAULT '0',
  ADD COLUMN procure_clinical_file_update_refusal tinyint(1) DEFAULT '0',
  CHANGE procure_patient_withdrawn_date procure_patient_refusal_withdrawal_date date DEFAULT NULL,
  CHANGE procure_patient_withdrawn_date_accuracy procure_patient_refusal_withdrawal_date_accuracy char(1) NOT NULL DEFAULT '',
  CHANGE procure_patient_withdrawn_reason procure_patient_refusal_withdrawal_reason text;
UPDATE structure_fields SET field = 'procure_patient_refusal_withdrawal_date' WHERE field = 'procure_patient_withdrawn_date';
UPDATE structure_fields SET field = 'procure_patient_refusal_withdrawal_reason' WHERE field = 'procure_patient_withdrawn_reason';

-- Drug Type (hide)

SELECT Drug.generic_name AS '###WARNING### Drug name defined more than once into Drug Tool. To clean up to have no duplciation', Drug.type, IF(Drug.procure_study = 1, 'Yes', 'No') AS 'Is study', count(*) AS 'Nbr Of Record(s)'
FROM drugs Drug,
(
  SELECT generic_name AS dup_generic_name, count(*) AS nbr_records
  FROM drugs
  WHERE deleted <> 1
  GROUP BY generic_name
) AS DrugDupTmp
WHERE DrugDupTmp.dup_generic_name = Drug.generic_name
AND DrugDupTmp.nbr_records > 1
AND Drug.deleted <> 1
GROUP BY Drug.generic_name, Drug.procure_study, Drug.type;

SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('system') ORDER by username desc LIMIT 0, 1);

UPDATE treatment_masters TreatmentMaster, drugs Drug,
(
  SELECT Drug.id, Drug.generic_name, Drug.procure_study
  FROM drugs Drug,
  (
    SELECT generic_name AS dup_generic_name, count(*) AS nbr_records
    FROM drugs
    WHERE deleted <> 1
    GROUP BY generic_name
  ) AS DrugDupTmp
  WHERE DrugDupTmp.dup_generic_name = Drug.generic_name
  AND DrugDupTmp.nbr_records > 1
  AND Drug.deleted <> 1
) DrugDup
SET TreatmentMaster.procure_drug_id = DrugDup.id,
TreatmentMaster.modified = @modified,
TreatmentMaster.modified_by = @modified_by
WHERE TreatmentMaster.deleted <> 1
AND TreatmentMaster.procure_drug_id = Drug.id
AND Drug.deleted <> 1
AND Drug.generic_name = DrugDup.generic_name
AND Drug.procure_study = DrugDup.procure_study;

INSERT INTO treatment_masters_revs (id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
version_created, modified_by)
(SELECT id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
modified, modified_by FROM treatment_masters WHERE modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_treatments_revs(treatment_type,dosage,treatment_master_id,procure_deprecated_field_drug_id,treatment_site,treatment_precision,treatment_combination,
procure_deprecated_field_treatment_line,duration,surgery_type,
version_created)
(SELECT treatment_type,dosage,treatment_master_id,procure_deprecated_field_drug_id,treatment_site,treatment_precision,treatment_combination,
procure_deprecated_field_treatment_line,duration,surgery_type,
modified
FROM treatment_masters INNER JOIN procure_txd_treatments ON id = treatment_master_id 
AND modified = @modified AND modified_by = @modified_by);

UPDATE drugs Drug,
(
  SELECT Drug.id
  FROM drugs Drug,
  (
    SELECT generic_name AS dup_generic_name, count(*) AS nbr_records
    FROM drugs
    WHERE deleted <> 1
    GROUP BY generic_name
  ) AS DrugDupTmp
  WHERE DrugDupTmp.dup_generic_name = Drug.generic_name
  AND DrugDupTmp.nbr_records > 1
  AND Drug.deleted <> 1
) DrugDup
SET Drug.deleted = 1,
Drug.modified = @modified,
Drug.modified_by = @modified_by
WHERE Drug.deleted <> 1
AND DrugDup.id = Drug.id
AND DrugDup.id NOT IN (SELECT TreatmentMaster.procure_drug_id FROM treatment_masters TreatmentMaster WHERE deleted <> 1 AND TreatmentMaster.procure_drug_id IS NOT NULL);

INSERT INTO drugs_revs (id, generic_name, trade_name, type, description, modified_by, version_created, procure_study)
(SELECT id, generic_name, trade_name, type, description, modified_by, modified, procure_study 
FROM drugs 
WHERE modified = @modified AND modified_by = @modified_by);

SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('system') ORDER by username desc LIMIT 0, 1);

UPDATE drugs SET type = '' WHERE deleted <> 1;
INSERT INTO drugs_revs (id, generic_name, trade_name, type, description, modified_by, version_created, procure_study)
(SELECT id, generic_name, trade_name, type, description, modified_by, modified, procure_study 
FROM drugs 
WHERE deleted <> 1);

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='drugs') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='type' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_drug_type') AND `flag_confidential`='0');

UPDATE drugs SET generic_name = REPLACE(REPLACE(generic_name, ' (Experimental Treatment)', ''), ' (Traitement expérimental', '');
UPDATE drugs_revs SET generic_name = REPLACE(REPLACE(generic_name, ' (Experimental Treatment)', ''), ' (Traitement expérimental', '');

INSERT INTO i18n (id,en,fr)
VALUES
('the drug [%s] has already been recorded',
"The drug [%s] has already been recorded.",
"Le médicament [%s] a déjà été enregistré."),
('you can not record drug [%s] twice',
"You can not record drug [%s] twice.",
"Vous ne pouvez pas enregistrer le médicament [%s] deux fois.");

DELETE FROM structure_validations WHERE structure_field_id = (SELECT id FROM structure_fields WHERE `model`='Drug' AND `tablename`='drugs' AND `field`='type');

-- Next Followup Report

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_next_followup_data_notes', 'textarea',  NULL , '0', '', '', '', 'notes', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_next_followup_report_result'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_next_followup_data_notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '0', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
UPDATE structure_fields SET sortable = '0' WHERE field = 'procure_next_followup_data_notes';
INSERT INTO i18n (id,en,fr)
VALUES
('participants with refusal or withdrawal', 'At least one participant is a participant with refusal or withdrawal', "Au moins un participant est un participant avec refus ou retrait");
INSERT INTO i18n (id,en,fr) VALUES ('aborted', 'Aborted', 'Abandonné(e)');

UPDATE versions SET branch_build_number = '6918', site_branch_build_number = '????' WHERE version_number = '2.6.8';

-- Participant Lost Contact

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'procure_contact_lost', 'checkbox',  NULL , '0', '', '', '', 'lost contact', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_contact_lost' AND `type`='checkbox' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lost contact' AND `language_tag`=''), '3', '39', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `language_heading`='refusal / withdrawal / lost contact' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_next_collections_refusal' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE participants
  ADD COLUMN procure_contact_lost tinyint(1) DEFAULT '0';
ALTER TABLE participants_revs
  ADD COLUMN procure_contact_lost tinyint(1) DEFAULT '0';
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('lost contact', 'Lost Contact', 'Contact perdu'),
('refusal / withdrawal / lost contact', 'Refusal / Withdrawal / Lost Contact', 'Refus / Désistement / Contact perdu');
UPDATE structure_formats SET `display_order`='40' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='procure_contact_lost' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Medication Type Fusion
  
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Types (PROCURE values only)');
UPDATE structure_permissible_values_customs SET deleted = 1 WHERE control_id = @control_id AND value IN ('open sale medication', 'other diseases medication', 'prostate medication');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `use_as_input`, `control_id`, created, created_by, modified, modified_by) 
VALUES 
('medication' ,'Medication', 'Médicament ', '1', @control_id, NOW(), '1', NOW(), '1');

SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('NicoEn', 'administrator') ORDER by username desc LIMIT 0, 1);
UPDATE treatment_masters SET modified = @modified, modified_by = @modified_by
WHERE deleted <> 1 AND id IN (
  SELECT treatment_master_id FROM procure_txd_treatments WHERE treatment_type IN ('open sale medication', 'other diseases medication', 'prostate medication')
);
UPDATE procure_txd_treatments 
SET treatment_type = 'medication'
WHERE treatment_master_id IN (SELECT id FROM treatment_masters WHERE deleted <> 1)
AND treatment_type IN ('open sale medication', 'other diseases medication', 'prostate medication');
INSERT INTO treatment_masters_revs (id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
version_created, modified_by)
(SELECT id, treatment_control_id, tx_intent, target_site_icdo, start_date, start_date_accuracy, finish_date, finish_date_accuracy, information_source, facility, notes,
protocol_master_id, participant_id, diagnosis_master_id, procure_deprecated_field_procure_form_identification, procure_created_by_bank, procure_drug_id,
modified, modified_by FROM treatment_masters WHERE modified = @modified AND modified_by = @modified_by);
INSERT INTO procure_txd_treatments_revs(treatment_type,dosage,treatment_master_id,procure_deprecated_field_drug_id,treatment_site,treatment_precision,treatment_combination,
procure_deprecated_field_treatment_line,duration,surgery_type,
version_created)
(SELECT treatment_type,dosage,treatment_master_id,procure_deprecated_field_drug_id,treatment_site,treatment_precision,treatment_combination,
procure_deprecated_field_treatment_line,duration,surgery_type,
modified
FROM treatment_masters INNER JOIN procure_txd_treatments ON id = treatment_master_id 
AND modified = @modified AND modified_by = @modified_by);

-- Cause of death : Unknown

INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_cause_of_death"), (SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown"), "3", "1");

-- Added collection of controls

SET @modified = (SELECT NOW() FROM users limit 0, 1);
SET @modified_by = (SELECT id FROM users WHERE username IN ('NicoEn', 'administrator') ORDER by username desc LIMIT 0, 1);
SET @procure_collected_by_bank = (SELECT procure_collected_by_bank FROM collections ORDER by id LIMIT 0,1);
INSERT INTO `collections` (`id`, `acquisition_label`, `bank_id`, `collection_site`, `collection_datetime`, `collection_datetime_accuracy`, `sop_master_id`, `collection_property`, 
`collection_notes`, `participant_id`, `diagnosis_master_id`, `consent_master_id`, `treatment_master_id`, `event_master_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`, 
`procure_deprecated_field_procure_patient_identity_verified`, `procure_visit`, `procure_collected_by_bank`) VALUES
(null, '', NULL, NULL, NULL, '', NULL, 'independent collection', 
'Collection created to track all controls used by the PROCURE banks.', NULL, NULL, NULL, NULL, NULL, @modified, @modified_by, @modified, @modified_by, 0,
 0, 'Controls', @procure_collected_by_bank);
UPDATE versions set permissions_regenerated = 0;
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('control collection - no data can be updated', 'Collection of controls! No data can be updated!', "Collection de contrôles! Aucune donnée ne peut être mise à jour!"),
('control collection - collection can not be deleted', 'Collection of controls! Collection can not be deleted!', "Collection de contrôles! La collection ne peut pas être supprimée!");
-- Should be displayed to not include the control collection when participant is adding a new collection
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_property' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_property') AND `flag_confidential`='0');

-- Remove processing site from the list procure_banks list

DELETE FROM structure_value_domains_permissible_values
WHERE structure_value_domain_id = (SELECT id FROM structure_value_domains WHERE domain_name="procure_banks");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="1" AND language_alias="PS1"), "1", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="2" AND language_alias="PS2"), "1", "2"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="3" AND language_alias="PS3"), "1", "3"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="4" AND language_alias="PS4"), "1", "4"),
((SELECT id FROM structure_value_domains WHERE domain_name="procure_banks"), (SELECT id FROM structure_permissible_values WHERE value="s" AND language_alias="system option"), "1", "100");

-- Statements linked to transferred participant

REPLACE INTO i18n (id,en,fr) 
VALUES 
('the identification format is wrong',
"The identification format is wrong! Either the participant identifier does not start with the code of your bank (1,2,3,4) or the participant is initially a participant of another bank but this one has not been defined as a 'Transferred Participant'. To update the profile, the participant should be a participant of your bank or a 'Transferred Participant'.",
"Le format de l'identification n'est pas supporté! Soit l'identifiant du participant ne commence pas avec le code de votre banque (1,2,3,4), soit le participant est un participant initialement d'une autre banque mais celui-ci n'a pas été définie comme 'participant transféré'. Pour mettre à jour le profil, le participant doit être un participant de votre banque ou un 'participant transféré'.");
INSERT INTO i18n (id,en,fr) 
VALUES 
('participant of another bank but not transferred - no data entry',
"The participant is a participant of another bank and is not flagged as a 'Transferred Participant'. This participant has been initialy created by a script to migrate sample from the 'ATiM-Processing Site'. No profile data, no identifier, no clinical information, etc is supposed to be recorded into your ATiM for this particpant excepted if you flag this one as a 'Transferred Participant'.",
"Le participant est un participant d'une autre banque et n'est pas marqué comme un 'Participant transféré'. Ce participant a été créé par un script pour migrer les échantillons du 'ATiM-Processing Site'. Aucune donnée de profil, aucun identifiant, aucune information clinique, etc. n'est supposé être enregistré pour ce participant sauf si vous définissez le participant comme 'participant transféré'."),
('system does not allow you to define a participant of another bank from transferred to not transferred',
"The system does not allow you to change the profile of a participant of another bank from 'Transferred Participant' to 'Not Transferred Participant'. Please contact your system administrator.",
"Le système ne vous permet pas de modifier le profil d'un participant d'une autre banque de 'Participant transféré' à 'Participant non transféré'. Veuillez contacter votre administrateur système.");
UPDATE structure_fields SET  `language_help`='procure_transferred_participant_help' WHERE model='Participant' AND tablename='participants' AND field='procure_transferred_participant' AND `type`='yes_no' AND structure_value_domain  IS NULL ;
INSERT INTO i18n (id,en,fr)
VALUES
('procure_transferred_participant_help',
"Defined a participant initially followed by another bank then by your bank or participant who was initially followed by your bank then followed by another one.",
"Défini un participant initialement suivi par une autre banque puis par votre banque ou participant suivi initialement par votre banque puis suivi par un autre.");

-- Collection Property Clean Up (to let people copy collection)

UPDATE collections SET collection_property = 'participant collection' WHERE participant_id IS NOt NULL AND collection_property IS NULL;
UPDATE collections_revs SET collection_property = 'participant collection' WHERE participant_id IS NOt NULL AND collection_property IS NULL;
SELECT count(*) AS '### WARNING ### : Number of collections with collection property set to null' FROM collections WHERE deleted <> 1 AND collection_property IS NULL;

-- Clinical Collection Link Deletion will delete collection

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('the link cannot be deleted - collection contains at least one sample', 
'The collection cannot be deleted. Collection contains at least one sample.', 
'La collection ne peut pas être supprimée. Des échantillons existent dans la collection.');
REPLACE INTO i18n (id,en,fr)
VALUES
('use inventory management module to delete the entire collection', 'Please note that the collection has been automatically deleted.', "Veuillez noter que la collection a été supprimée automatiquement.");
SELECT count(*) AS '### WARNING ### : Number of collections not linked to a participant that should be deleted' FROM collections WHERE deleted <> 1 AND participant_id IS NULL AND collection_property = 'participant collection';
REPLACE INTO i18n (id,en,fr)
VALUES
('a created collection should be linked to a participant', 
'A created collection should be linked to a participant. Please create collection from participant.', 
'La création d''une collection doit être liée à un patient. Veuillez créer la collection d''un participant.');

-- Manage sample created by system to migrate data from processing site

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('a sample created by system/script to migrate data from the processing site can not be edited', 
"A sample created by system to migrate data from the 'ATiM-Processing Site' can not been modified.",
"Un échantillon créé par le système pour migrer des données depuis la version 'ATiM-Processing Site' ne peut être modifié."),
('no derivative can be created from sample created by system/script to migrate data from the processing site with no aliquot',
"No derivative can be created from sample created by system to migrate data from the 'ATiM-Processing Site' when no aliquot flagged as created by another bank is linked to the sample.",
"Aucune dérivée ne peut être créé à partir d'un échantillon créé par le système pour migrer des données depuis la version 'ATiM-Processing Site' si aucun aliquot défini comme créé par une autre banque n'est lié à l'échantillon."),
('no specimen review can be created from sample created by system/script to migrate data from the processing site with no aliquot',
"No specimen review can be created from sample created by system to migrate data from the 'ATiM-Processing Site' when no aliquot flagged as created by another bank is linked to the sample.",
"Aucune rapport d'histologie ne peut être créé à partir d'un échantillon créé par le système pour migrer des données depuis la version 'ATiM-Processing Site' si aucun aliquot défini comme créé par une autre banque n'est lié à l'échantillon."),
('no quality control can be created from sample created by system/script to migrate data from the processing site with no aliquot',
"No quality control can be created from sample created by system to migrate data from the 'ATiM-Processing Site' when no aliquot flagged as created by another bank is linked to the sample.",
"Aucun contrôle de qualité ne peut être créé à partir d'un échantillon créé par le système pour migrer des données depuis la version 'ATiM-Processing Site' si aucun aliquot défini comme créé par une autre banque n'est lié à l'échantillon."),
('at least one data (aliquot, quality control, derivative) is linked to the sample created by the sysem for the migration of aliquots from the processing site - delete all records first',
"An aliquot initialy transferred from a bank to the 'ATiM-Processing Site' then merged into your ATiM could only be deleted when no other data (derivative, aliquot, quality control) is linked to the sample of this aliquot. Please delete all other record first.", 
"Un aliquot initialement transférée d'une banque vers la version 'ATiM-Processing Site' et intégrée par la suitedans votre ATiM ne peut être supprimé que si aucune autre donnée (dérivée, aliquote, contrôle qualité) n'est liée à l'échantillon de cet aliquot. Veuillez avant tout supprimer tout autre enregistrement."),
('no aliquot can be created from sample created by system/script to migrate data from the processing site with no aliquot',
"No aliquot can be created from sample created by system to migrate data from the 'ATiM-Processing Site' when no aliquot flagged as created by another bank is linked to the sample.",
"Aucun aliquot ne peut être créé à partir d'un échantillon créé par le système pour migrer des données depuis la version 'ATiM-Processing Site' si aucun aliquot défini comme créé par une autre banque n'est lié à l'échantillon.");

-- Manage barcode validation Error Vs Warning

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('aliquot barcode format errror - error', 
'Identification (alq.) format errror. This one should start with the participant identification and the visit (PS0P0000 V00 -AAA)', 
'Erreur de format de l''identification (alq.). Cette donnée doit commencer avec l''identifiant du patient puis le numéro de visit (PS0P0000 V00 -AAA)'),
('aliquot barcode format errror - warning', 
'At least one label of an aliquot [Identification (alq.)] does not match a PROCURE format (PS0P0000 V00 -AAA). Please correct data if required.', 
'Au moins un identification d''aliquot ne correspond pas au format PROCURE (PS0P0000 V00 -AAA). Veuillez corriger la donnée au besoin.');
SET @datamart_report_id = (SELECT id FROM datamart_reports WHERE function LIKE 'procureGetListOfBarcodeErrors');
UPDATE datamart_reports SET flag_active = 0 WHERE id = @datamart_report_id;
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = CONCAT('/Datamart/Reports/manageReport/',CONVERT(@datamart_report_id USING utf8));

-- Remove chum, chuq, chus, etc from aliquot internal use list

SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'aliquot use and event types');
-- delete [sent to chuq|chum...]
SELECT DISTINCT type AS '### ERROR ### : Aliquot internal use type not supported (value will be deleted)' 
FROM aliquot_internal_uses
WHERE type LIKE 'sent to chum' OR type LIKE 'sent to chuq' OR type LIKE 'sent to chus' OR type LIKE 'sent to muhc';
DELETE FROM structure_permissible_values_customs 
WHERE control_id = @control_id AND (value LIKE 'sent to chum' OR value LIKE 'sent to chuq' OR value LIKE 'sent to chus' OR value LIKE 'sent to muhc');
-- [received from chum|chuq...] to [received from bank]
UPDATE aliquot_internal_uses
SET type = 'received from bank' 
WHERE (type LIKE 'received from chum' OR type LIKE 'received from chuq' OR type LIKE 'received from chus' OR type LIKE 'received from muhc');
UPDATE aliquot_internal_uses_revs
SET type = 'received from bank' 
WHERE (type LIKE 'received from chum' OR type LIKE 'received from chuq' OR type LIKE 'received from chus' OR type LIKE 'received from muhc');
DELETE FROM structure_permissible_values_customs 
WHERE control_id = @control_id 
AND (value LIKE 'received from chum' OR value LIKE 'received from chuq' OR value LIKE 'received from chus' OR value LIKE 'received from muhc');
-- [received from processing site] to [received from processing site ps3]
UPDATE aliquot_internal_uses
SET type = 'received from processing site ps3'
WHERE type LIKE 'received from processing site';
UPDATE aliquot_internal_uses_revs
SET type = 'received from processing site ps3'
WHERE type LIKE 'received from processing site';
-- [sent to processing site] to [sent to processing site ps3]
UPDATE aliquot_internal_uses
SET type = 'sent to processing site ps3'
WHERE type LIKE 'sent to processing site';
UPDATE aliquot_internal_uses_revs
SET type = 'sent to processing site ps3'
WHERE type LIKE 'sent to processing site';
UPDATE structure_permissible_values_customs 
SET value = 'sent to processing site ps3',
en = 'Sent To Processing Site (PS3)',
fr = 'Envoyé au site de traitment (PS3)'
WHERE control_id = @control_id AND value LIKE 'sent to processing site';
UPDATE structure_permissible_values_customs 
SET value = 'received from processing site ps3',
en = 'Received From Processing Site (PS3)',
fr = 'Recu du site de traitment (PS3)'
WHERE control_id = @control_id AND value LIKE 'received from processing site';

-- Add laste modification to profile, event and treatment

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'Participant', 'participants', 'modified', 'date',  NULL , '0', '', '', '', '', 'profile');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='participants'), (SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='modified' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='profile'), '3', '100', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_fields SET  `language_tag`='clinical annotation' WHERE model='Participant' AND tablename='participants' AND field='last_modification' AND `type`='datetime' AND structure_value_domain  IS NULL ;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'EventMaster', 'event_masters', 'modified', 'date',  NULL , '0', '', '', '', 'last modification', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='eventmasters'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='modified' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last modification' AND `language_tag`=''), '2', '1000', 'system data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentMaster', 'treatment_masters', 'modified', 'date',  NULL , '0', '', '', '', 'last modification', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='treatmentmasters'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='modified' AND `type`='date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='last modification' AND `language_tag`=''), '1', '1000', 'system data', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

-- Bank activity report

REPLACE INTO i18n (id,en,fr) 
VALUES
('encountered patients with collection post bcr', "Encountered 'R' patients with collection", "Patients 'R' recontrés avec collection"),
('encountered patients with collection pre bcr', "Encountered 'NR' patients with collection", "Patients 'NR' recontrés avec collection");
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_report_criteria_and_result') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_participant_identifier_prefix' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='procure_banks') AND `flag_confidential`='0');
UPDATE structure_fields SET language_help = CONCAT(field, '_help') WHERE id IN (SELECT structure_field_id FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_bank_activity_report'));
INSERT INTO i18n (id,en,fr)
VALUES
('procure_nbr_of_participants_with_collection_and_visit_help',
"Number of participants having at least one collection and/or a visite defined into the 'Visit / Contact' form.",
"Nombre de participants ayant au moins une collection et/ou une visite définie dans le formulaire 'Visite / Contact'."),
('procure_nbr_of_participants_with_collection_help',
"Number of participants having at least one collection.",
"Nombre de participants ayant au moins une collection."),
('procure_nbr_of_participants_with_visit_only_help',
"'Encountered patients' minus 'Encountered patients with collection'.", 
"'Patients rencontrés' moins 'Patients rencontrés avec collection'."),
('procure_nbr_of_participants_with_collection_post_bcr_help',
"Number of participants having at least one collection done after a biochemical relapse.",
"Nombre de participants ayant au moins une collection faite après une récidive biochimique."),
('procure_nbr_of_participants_with_collection_pre_bcr_help',
"'Encountered patients' minus 'Encountered 'R' patients with collection'.", 
"'Patients rencontrés' moins 'Patients 'R' recontrés avec collection'."),
('procure_nbr_of_participants_with_pbmc_extraction_help',
"Number of participants having at least one PBMC extraction done during the month.",
"Nombre de participants ayant au moins une extraction de PBMC faite durant le mois."),
('procure_nbr_of_participants_with_rna_extraction_help',
"Number of participants having at least one RNA extraction done during the month.",
"Nombre de participants ayant au moins une extraction d'ARN faite durant le mois."),
('procure_nbr_of_participants_with_clinical_data_update_help',
"Number of participants having either a date of death or a treatment start/finish date or a clinical annotation date (exam date, laboratory date, clinical note date, etc) defined during this month.",
"Nombre de participants ayant une date de décès ou une date de début / fin de traitement ou une date d'annotation clinique (date de l'examen, date du laboratoire, date de la note clinique, etc.) définie au cours de ce mois.");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Datamart', '0', '', 'procure_nbr_of_psa_created_modified', 'input',  NULL , '0', 'size=10', '', '', 'number of psas created / modified', ''), 
('Datamart', '0', '', 'procure_nbr_of_treatment_created_modified', 'input',  NULL , '0', 'size=10', '', '', 'number of treatments created / modified', ''), 
('Datamart', '0', '', 'procure_nbr_of_clinical_exams_created_modified', 'input',  NULL , '0', 'size=10', '', '', 'number of clinical exams created / modified', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_bank_activity_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_nbr_of_psa_created_modified' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='number of psas created / modified' AND `language_tag`=''), '0', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_bank_activity_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_nbr_of_treatment_created_modified' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='number of treatments created / modified' AND `language_tag`=''), '0', '11', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_bank_activity_report'), (SELECT id FROM structure_fields WHERE `model`='0' AND `tablename`='' AND `field`='procure_nbr_of_clinical_exams_created_modified' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=10' AND `default`='' AND `language_help`='' AND `language_label`='number of clinical exams created / modified' AND `language_tag`=''), '0', '12', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO i18n (id,en,fr)
VALUES
('number of psas created / modified',
"Number of PSA(s) created +modified",
"Nombre d'APS(s) créés + modifiés"),
('number of treatments created / modified',
"Number of treatment(s) created + modified",
"Nombre de traitment(s) créés + modifiés"),
('number of clinical exams created / modified',
"Number of clinical exam(s) created + modified",
"Nombre d'examen(s) clinique9s) créés + modifiés");

-- procure_banks_data_merge_tries & procure_banks_data_merge_messages

DROP TABLE IF EXISTS `procure_banks_data_merge_tries`;
CREATE TABLE `procure_banks_data_merge_tries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime DEFAULT NULL,
  `result` varchar(100) DEFAULT NULL,
  `ps1_dump_date` datetime DEFAULT NULL,
  `ps2_dump_date` datetime DEFAULT NULL,
  `ps3_dump_date` datetime DEFAULT NULL,
  `ps4_dump_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
DROP TABLE IF EXISTS procure_banks_data_merge_messages;
CREATE TABLE IF NOT EXISTS `procure_banks_data_merge_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  type varchar(20) default null,
  title varchar(1000) default null,
  details varchar(1000) default null,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
DROP TABLE IF EXISTS procure_banks_data_merge_messages_revs;

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_banks_data_merge_messages') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Administrate' AND `model`='ProcureBanksDataMergeMessage' AND `tablename`='procure_banks_data_merge_messages' AND `field`='details' AND `language_label`='detail' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Administrate' AND `model`='ProcureBanksDataMergeMessage' AND `tablename`='procure_banks_data_merge_messages' AND `field`='details' AND `language_label`='detail' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='Administrate' AND `model`='ProcureBanksDataMergeMessage' AND `tablename`='procure_banks_data_merge_messages' AND `field`='details' AND `language_label`='detail' AND `language_tag`='' AND `type`='input' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'ProcureBanksDataMergeMessage', 'procure_banks_data_merge_messages', 'type', 'input',  NULL , '0', '', '', '', 'type', ''), 
('Administrate', 'ProcureBanksDataMergeMessage', 'procure_banks_data_merge_messages', 'title', 'input',  NULL , '0', '', '', '', 'message', ''), 
('Administrate', 'ProcureBanksDataMergeMessage', 'procure_banks_data_merge_messages', 'details', 'input',  NULL , '0', '', '', '', 'details', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_banks_data_merge_messages'), (SELECT id FROM structure_fields WHERE `model`='ProcureBanksDataMergeMessage' AND `tablename`='procure_banks_data_merge_messages' AND `field`='type' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_banks_data_merge_messages'), (SELECT id FROM structure_fields WHERE `model`='ProcureBanksDataMergeMessage' AND `tablename`='procure_banks_data_merge_messages' AND `field`='title' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='message' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_banks_data_merge_messages'), (SELECT id FROM structure_fields WHERE `model`='ProcureBanksDataMergeMessage' AND `tablename`='procure_banks_data_merge_messages' AND `field`='details' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='details' AND `language_tag`=''), '1', '3', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');
UPDATE structure_formats SET `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_banks_data_merge_messages');

INSERT INTO structures(`alias`) VALUES ('procure_banks_data_merge_tries');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Administrate', 'ProcureBanksDataMergeTrie', 'procure_banks_data_merge_tries', 'datetime', 'datetime',  NULL , '0', '', '', '', 'date', ''), 
('Administrate', 'ProcureBanksDataMergeTrie', 'procure_banks_data_merge_tries', 'result', 'input',  NULL , '0', '', '', '', 'status', ''), 
('Administrate', 'ProcureBanksDataMergeTrie', 'procure_banks_data_merge_tries', 'ps1_dump_date', 'datetime',  NULL , '0', '', '', '', 'PS1', ''), 
('Administrate', 'ProcureBanksDataMergeTrie', 'procure_banks_data_merge_tries', 'ps2_dump_date', 'datetime',  NULL , '0', '', '', '', 'PS2', ''), 
('Administrate', 'ProcureBanksDataMergeTrie', 'procure_banks_data_merge_tries', 'ps3_dump_date', 'datetime',  NULL , '0', '', '', '', 'PS4', ''), 
('Administrate', 'ProcureBanksDataMergeTrie', 'procure_banks_data_merge_tries', 'ps4_dump_date', 'datetime',  NULL , '0', '', '', '', 'PS4', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='procure_banks_data_merge_tries'), (SELECT id FROM structure_fields WHERE `model`='ProcureBanksDataMergeTrie' AND `tablename`='procure_banks_data_merge_tries' AND `field`='datetime' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='date' AND `language_tag`=''), '1', '1', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_banks_data_merge_tries'), (SELECT id FROM structure_fields WHERE `model`='ProcureBanksDataMergeTrie' AND `tablename`='procure_banks_data_merge_tries' AND `field`='result' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='status' AND `language_tag`=''), '1', '2', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_banks_data_merge_tries'), (SELECT id FROM structure_fields WHERE `model`='ProcureBanksDataMergeTrie' AND `tablename`='procure_banks_data_merge_tries' AND `field`='ps1_dump_date' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='PS1' AND `language_tag`=''), '1', '3', 'procure data dump date', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_banks_data_merge_tries'), (SELECT id FROM structure_fields WHERE `model`='ProcureBanksDataMergeTrie' AND `tablename`='procure_banks_data_merge_tries' AND `field`='ps2_dump_date' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='PS2' AND `language_tag`=''), '1', '4', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_banks_data_merge_tries'), (SELECT id FROM structure_fields WHERE `model`='ProcureBanksDataMergeTrie' AND `tablename`='procure_banks_data_merge_tries' AND `field`='ps3_dump_date' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='PS4' AND `language_tag`=''), '1', '5', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='procure_banks_data_merge_tries'), (SELECT id FROM structure_fields WHERE `model`='ProcureBanksDataMergeTrie' AND `tablename`='procure_banks_data_merge_tries' AND `field`='ps4_dump_date' AND `type`='datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='PS4' AND `language_tag`=''), '1', '6', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='procure_banks_data_merge_summary');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field` LIKE 'procure_banks_data_merge%');
DELETE FROM structure_fields WHERE `plugin`='Administrate' AND `model`='Generated' AND `tablename`='' AND `field` LIKE 'procure_banks_data_merge%';
DELETE FROM structures WHERE alias='procure_banks_data_merge_summary';

INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('tries', 'Tries', 'Essais'),
('procure data dump date', "Dates of Banks Data Copies", "Dates des copies des données des banques");
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
("procure_bank_merge_summary_help_transferred_participant",
"Transferred participant: Participant followed by one bank then by another one. In 'ATiM Central', all data will be merged and linked to one participant except the profile. Only the last modified participant profile will be kept.",
"Participant transféré: Participant suivi dans une banque puis par une autre. Dans 'ATiM Central', toutes les données seront fusionnées et associées à un participant à l'exception du profil. Seul le profil du dernier participant modifié sera conservé."),
("procure_bank_merge_summary_help_processing_site_participant",
"'Processing Site' Participant: ATiM participant created initialy by the system into the deprecated 'ATiM-Processing Site' to link aliquots received from bank to a 'system' participant. These participants are now recorded into 'ATiM-PS3', ATiM that gathers aliquots previoulsy recorded into the depreacted 'ATiM-Procure Processing Site'.",
"Participant 'Processing Site': Participant ATiM créé initialement par le système dans l'ancien 'ATiM-Processing Site' pour relier les aliquots reçus de la banque à un participant créé par le système. Ces participants sont maintenant enregistrés dans le 'ATiM-PS3', ATiM contenant les aliquots précédemment enregistrés dans le 'ATiM-Procure Processing Site' obsoltète."),
("procure_bank_merge_summary_help_transferred_aliquot",
"Transferred Aliquot : Aliquot created into one of the banks (PS1, PS2 or PS4) then transferred to PS3 and recorded into 'ATiM-PS3', ATiM that gathers aliquots previoulsy recorded into the depreacted 'ATiM-Procure Processing Site'.",
"Aliquot transféré : Aliquot créé dans une des banques (PS1, PS2 ou PS4) puis transféré à PS3 et enregistré dans le 'ATiM-PS3', ATiM contenant les aliquots précédemment enregistrés dans le 'ATiM-Procure Processing Site' obsoltète.");

UPDATE versions SET branch_build_number = '6982' WHERE version_number = '2.6.8';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
-- -1- Path review batch entry
--
--   From an excel file, create a path review entry for many samples and many collections.
--
-- -2- Merge data of processing site and cusm
--   
--   Keep sample as processing site samples.
--
-- -3- Use ICD03 topo code for any value of tissue site
--   
--   See email sent to Valerie on 2017-02-24 with the list of values (ICD-O-3 Topo (International classification) && Clinical Exam - Sites (PROCURE Defintion)
--     &&  Treatment Sites (PROCURE Defintion) && Other Tumor Site (PROCURE Defintion based on ICD-O-/ Topo))
-- 
-- -4- Mettre champ du site dans le label (ex: Protocol (Ch. CUSM)
-- 
-- -5- Central 
--
-- Importer le site de lucie sur central. Voire pourquoi si on cherche bcr sur central.... on a un site sans sans le flag du site 'PS...' comme PS1, PS2, etc.
-- 
-- -5- Clinical Data Clean Up
--
-- Voir si on peut nettoyer les données des sites. Ex: Clinical Exam les champs positif, clinical replase peuvent etre compltetes a partir des notes;
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
