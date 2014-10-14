-- BCCH Customization Script
-- Version: v0.1
-- ATiM Version: v2.6.3

-- Update bank name for version tracking during customization
REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', "BCCH Biobank - BCCH v0.1", '');
	
--  --------------------------------------------------------------------------
--	v2.6.0 Upgrade changes
--	--------------------------------------------------------------------------

-- Deactivate Participant Identifiers demo report
UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');

-- Extended Treatment tables (txe_radiations)
SET @treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_radiations' AND detail_form_alias = 'txe_radiations');
ALTER TABLE treatment_extend_masters ADD COLUMN tmp_old_extend_id int(11) DEFAULT NULL;
INSERT INTO treatment_extend_masters (tmp_old_extend_id, treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted) (SELECT id, @treatment_extend_control_id, treatment_master_id, created, created_by, modified, modified_by, deleted FROM txe_radiations);

ALTER TABLE txe_radiations ADD treatment_extend_master_id int(11) NOT NULL, DROP FOREIGN KEY FK_txe_radiations_tx_masters, DROP COLUMN treatment_master_id, DROP COLUMN created, DROP COLUMN created_by, DROP COLUMN modified, DROP COLUMN modified_by, DROP COLUMN deleted;
UPDATE treatment_extend_masters extend_master, txe_radiations extend_detail SET extend_detail.treatment_extend_master_id = extend_master.id WHERE extend_master.tmp_old_extend_id = extend_detail.id;
ALTER TABLE txe_radiations_revs ADD COLUMN treatment_extend_master_id int(11) NOT NULL;
UPDATE txe_radiations_revs extend_detail_revs, txe_radiations extend_detail SET extend_detail_revs.treatment_extend_master_id = extend_detail.treatment_extend_master_id WHERE extend_detail.id = extend_detail_revs.id;
ALTER TABLE txe_radiations ADD CONSTRAINT FK_txe_radiations_treatment_extend_masters FOREIGN KEY (treatment_extend_master_id) REFERENCES treatment_extend_masters (id), DROP COLUMN id;
INSERT INTO treatment_extend_masters_revs (id, treatment_extend_control_id, treatment_master_id, modified_by, version_created) (SELECT treatment_extend_master_id, @treatment_extend_control_id, treatment_master_id, modified_by, version_created FROM txe_radiations_revs ORDER BY version_id ASC);
ALTER TABLE treatment_extend_masters DROP COLUMN tmp_old_extend_id;
ALTER TABLE txe_radiations_revs DROP COLUMN modified_by, DROP COLUMN id, DROP COLUMN treatment_master_id;
UPDATE treatment_extend_masters SET deleted = 1 WHERE treatment_master_id IN (SELECT id FROM treatment_masters WHERE deleted = 1);

-- Drop `txe_radiations`
DROP TABLE txe_radiations; 
DROP TABLE txe_radiations_revs;

-- Flag inactive relationsips if required (see queries below).
-- Don't forget Collection to Annotation, Treatment,Consent, etc if not requried.

/*
SELECT str1.model AS model_1, str2.model AS model_2, use_field FROM datamart_browsing_controls ctrl, datamart_structures str1, datamart_structures str2 WHERE str1.id = ctrl.id1 AND str2.id = ctrl.id2 AND (ctrl.flag_active_1_to_2 = 1 OR ctrl.flag_active_2_to_1 = 1);
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = 0 WHERE fct.datamart_structure_id = str.id AND/OR str.model IN ('Model1', 'Model2', 'Model...');
Please flag inactive datamart structure functions if required (see queries below).
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('Model1', 'Model2', 'Model...'));
Please change datamart_structures_relationships_en(and fr).png in appwebrootimgdataBrowser
*/

-- Review specimen review detail form `spr_breast_cancer_types`

/*
Should change trunk ViewSample to fix bug #2690: 
Changed [SampleMaster.parent_id AS parent_sample_id,] to [SampleMaster.parent_id AS parent_id].
Please review custom ViewSample $table_query.
*/

-- Category for custom lookup domains
UPDATE `structure_permissible_values_custom_controls` SET `category`='clinical - consent' WHERE `name`='ccbr person consenting';
UPDATE `structure_permissible_values_custom_controls` SET `category`='clinical - consent' WHERE `name`='ccbr treating physician';
UPDATE `structure_permissible_values_custom_controls` SET `category`='inventory' WHERE `name`='ccbr sample pickup by';
