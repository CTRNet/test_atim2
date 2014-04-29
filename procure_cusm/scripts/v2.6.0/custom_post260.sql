-- CUSTOM TREATMENT EXTEND TABLES TO UPGRADE
-- --------------------------------------------------------------------------------------------------------
SET @treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'procure_txe_medications' AND detail_form_alias = 'procure_txe_medications');
ALTER TABLE treatment_extend_masters ADD COLUMN tmp_old_extend_id int(11) DEFAULT NULL;
INSERT INTO treatment_extend_masters (tmp_old_extend_id, treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted) (SELECT id, @treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted FROM procure_txe_medications);
ALTER TABLE procure_txe_medications ADD treatment_extend_master_id int(11) NOT NULL, DROP FOREIGN KEY procure_txe_medications_ibfk_1, DROP COLUMN treatment_master_id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted;
UPDATE treatment_extend_masters extend_master, procure_txe_medications extend_detail SET extend_detail.treatment_extend_master_id = extend_master.id WHERE extend_master.tmp_old_extend_id = extend_detail.id;
ALTER TABLE procure_txe_medications_revs ADD COLUMN treatment_extend_master_id int(11) NOT NULL;
UPDATE procure_txe_medications_revs extend_detail_revs, procure_txe_medications extend_detail SET extend_detail_revs.treatment_extend_master_id = extend_detail.treatment_extend_master_id WHERE extend_detail.id = extend_detail_revs.id;
ALTER TABLE procure_txe_medications ADD CONSTRAINT FK_procure_txe_medications_treatment_extend_masters FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id), DROP COLUMN id;
INSERT INTO treatment_extend_masters_revs (id, treatment_extend_control_id, treatment_master_id, modified_by, version_created) (SELECT treatment_extend_master_id, @treatment_extend_control_id, treatment_master_id, modified_by, version_created FROM procure_txe_medications_revs ORDER BY version_id ASC);
ALTER TABLE treatment_extend_masters DROP COLUMN tmp_old_extend_id;
ALTER TABLE procure_txe_medications_revs DROP COLUMN modified_by, DROP COLUMN id, DROP COLUMN treatment_master_id;
UPDATE treatment_extend_masters SET deleted = 1 WHERE treatment_master_id IN (SELECT id FROM treatment_masters WHERE deleted = 1);

-- txe_radiations TABLE DELETION
-- --------------------------------------------------------------------------------------------------------
DROP TABLE txe_radiations; DROP TABLE txe_radiations_revs;


-- structure_permissible_values_custom_controls category
----------------------------------------------------------------------------------------------------------
UPDATE structure_permissible_values_custom_controls SET name = 'Method to complete questionnaire', category = 'clinical - annotation' WHERE name = 'method to complete questionnaire';
UPDATE structure_permissible_values_custom_controls SET name = 'Questionnaire recovery method', category = 'clinical - annotation' WHERE name = 'questionnaire recovery method';
UPDATE structure_permissible_values_custom_controls SET name = 'Questionnaire verification result', category = 'clinical - annotation' WHERE name = 'questionnaire verification result';
UPDATE structure_permissible_values_custom_controls SET name = 'Questionnaire revision method', category = 'clinical - annotation' WHERE name = 'questionnaire revision method';
UPDATE structure_permissible_values_custom_controls SET name = 'Questionnaire version', category = 'clinical - annotation' WHERE name = 'questionnaire version';
UPDATE structure_permissible_values_custom_controls SET name = 'Questionnaire version date', category = 'clinical - annotation' WHERE name = 'questionnaire version date';
UPDATE structure_permissible_values_custom_controls SET name = 'Blood collection sites', category = 'inventory' WHERE name = 'blood collection sites';
UPDATE structure_permissible_values_custom_controls SET name = 'Procure prostatectomy types', category = 'inventory' WHERE name = 'procure prostatectomy types';
UPDATE structure_permissible_values_custom_controls SET name = 'Procure slice origins', category = 'inventory' WHERE name = 'procure _slice origins';
UPDATE structure_permissible_values_custom_controls SET name = 'Collection visit', category = 'inventory' WHERE name = 'collection visit';
UPDATE structure_permissible_values_custom_controls SET name = 'Procure block classifications', category = 'inventory' WHERE name = 'procure block classifications';
UPDATE structure_permissible_values_custom_controls SET name = 'Procure followup medical treatment types', category = 'clinical - annotation' WHERE name = 'procure followup medical treatment types';
UPDATE structure_permissible_values_custom_controls SET name = 'Procure followup exam types ', category = 'clinical - annotation' WHERE name = 'procure followup exam types ';
UPDATE structure_permissible_values_custom_controls SET name = 'Procure followup clinical recurrence sites', category = 'clinical - annotation' WHERE name = 'procure followup clinical recurrence sites';
UPDATE structure_permissible_values_custom_controls SET name = 'Procure followup clinical recurrence types', category = 'clinical - annotation' WHERE name = 'procure followup clinical recurrence types';
UPDATE structure_permissible_values_custom_controls SET name = 'Questionnaire delivery site and method', category = 'clinical - annotation' WHERE name = 'questionnaire delivery site and method';
