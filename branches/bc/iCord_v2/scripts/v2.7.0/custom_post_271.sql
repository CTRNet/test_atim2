-- -----------------------------------------------------------------------------------------------------------------------------------
-- iCord Customization Script                                                                                                       --
-- -----------------------------------------------------------------------------------------------------------------------------------
--                                                                                                                                  --
-- ATiM Version: v2.6.5                                                                                                             --
-- Notes: Custom script developped for the iCord project.                                                                           --
--        To be loaded after the the atim_v.2.6.5_upgrade.sql script.                                                              --
-- -----------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#869 : Add 'tube' as aliquot type
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : Consider that formalin is a storage solution for csf tube
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Alter ad_tubes table

ALTER TABLE ad_tubes ADD COLUMN icord_storage_solution VARCHAR(50) DEFAULT NULL;
ALTER TABLE ad_tubes_revs ADD COLUMN icord_storage_solution VARCHAR(50) DEFAULT NULL;

-- Add field to the forms used to manage csf tube data (step1)

UPDATE aliquot_controls
SET detail_form_alias = CONCAT(detail_form_alias, ',icord_ad_csf_tubes')
WHERE aliquot_type = 'tube'
AND sample_control_id = (select id from sample_controls WHERE sample_type = 'csf');

INSERT INTO structures(`alias`) VALUES ('icord_ad_csf_tubes');

-- Create csf storage solution list (custom)

INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('CSF Storage Solutions', 1, 50, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'CSF Storage Solutions');
SET @user_id = 1;
INSERT INTO structure_permissible_values_customs (`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) 
VALUES
("formalin", "Formalin", "", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls SET values_used_as_input_counter = 1, values_counter = 1 WHERE name = 'CSF Storage Solutions';
INSERT INTO structure_value_domains (domain_name, override, category, source) values
('icord_csf_storage_solutions', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(\'CSF Storage Solutions\')');

-- Add 'storage solution' field to the forms used to manage csf tube data (step2)

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('InventoryManagement', 'AliquotDetail', 'ad_tubes', 'icord_storage_solution', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='icord_csf_storage_solutions') , '0', '', '', '', 'storage solution', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='icord_ad_csf_tubes'), (SELECT id FROM structure_fields WHERE `model`='AliquotDetail' AND `tablename`='ad_tubes' AND `field`='icord_storage_solution' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='icord_csf_storage_solutions')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='storage solution' AND `language_tag`=''), '1', '65', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT IGNORE INTO i18n (id,en,fr)
VALUES
('storage solution', 'Storage Solution', "Solution d'entreposage");

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#788: Add 'Thawed' to the Tube Stock Detail dropdown list
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : Will change the aliquot in stock detail list from fix to custom
-- -----------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structure_permissible_values_custom_controls (name, flag_active, values_max_length, category) 
VALUES
('Aliquot In Stock Details List', 1, 30, 'inventory');
SET @control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Aliquot In Stock Details List');
SET @user_id = 1;
INSERT INTO structure_permissible_values_customs 
(`value`, `en`, `fr`, `display_order`, `use_as_input`, `control_id`, `modified`, `created`, `created_by`, `modified_by`) VALUES
("empty", "Empty", "Vide", "2", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("reserved for order", "Reserved For Order", "Réservé pour une commande", "6", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("lost", "Lost", "Perdu", "3", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("used", "Used", "Utilisé", "8", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("on loan", "On Loan", "Prêté", "4", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("other", "Other", "Autre", "9", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("shipped", "Shipped", "Envoyé", "7", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("contaminated", "Contaminated", "Contaminé", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("reserved for study", "Reserved For Study/Project", "Réservé pour une Étude/Projet", "5", "1", @control_id, NOW(), NOW(), @user_id, @user_id), 
("thawed", "Thawed", "Décongelé", "1", "1", @control_id, NOW(), NOW(), @user_id, @user_id);
UPDATE structure_permissible_values_custom_controls 
SET values_used_as_input_counter = 10, values_counter = 10 
WHERE name = 'Aliquot In Stock Details List';
UPDATE structure_value_domains SET source = 'StructurePermissibleValuesCustom::getCustomDropdown(\'Aliquot In Stock Details List\')' WHERE domain_name = 'aliquot_in_stock_detail';
SET @id = (SELECT id FROM structure_value_domains WHERE domain_name = 'aliquot_in_stock_detail');
UPDATE structure_value_domains_permissible_values SET flag_active = 0 WHERE structure_value_domain_id = @id;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Issue#854: Add additional specimen types to collections
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : -
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Urine

UPDATE parent_to_derivative_sample_controls 
SET flag_active=true 
WHERE parent_sample_control_id IS NULL
AND derivative_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'urine');
UPDATE parent_to_derivative_sample_controls 
SET flag_active=true 
WHERE parent_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'urine')
AND derivative_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'centrifuged urine');
UPDATE aliquot_controls 
SET flag_active=true WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('urine', 'centrifuged urine'));

-- Stool

UPDATE parent_to_derivative_sample_controls 
SET flag_active=true 
WHERE parent_sample_control_id IS NULL
AND derivative_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'stool');
UPDATE parent_to_derivative_sample_controls 
SET flag_active=true 
WHERE parent_sample_control_id = (SELECT id FROM sample_controls WHERE sample_type = 'stool')
AND derivative_sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('dna', 'rna'));
UPDATE aliquot_controls 
SET flag_active=true WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('stool'));
UPDATE realiquoting_controls SET flag_active=true WHERE id IN('71');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Hide  any diagnosis controls not used by iCORD
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : It seams that iCORD just used animal diagnosis - Hide other diagnosis types
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT CONCAT(category, '-', controls_type) AS '####################### Diagnosis inactivated - Please confirm! ############################' 
FROM diagnosis_controls 
WHERE flag_active = 1 AND id NOT IN (
  SELECT DISTINCT diagnosis_control_id FROM diagnosis_masters WHERE deleted <> 1
);
UPDATE diagnosis_controls SET flag_active = 0
WHERE flag_active = 1 AND id NOT IN (
  SELECT DISTINCT diagnosis_control_id FROM diagnosis_masters WHERE deleted <> 1
);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Hide any diagnosis masters fields not used by iCORD then move Notes field to the other column
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : To simplfy the data entry.
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT atim_field AS '####################### Diagnosis Master Field Hidden - Please confirm! ############################'
FROM (
      SELECT count(*) AS nbr_of_record_not_null, 'dx_date' AS atim_field FROM diagnosis_masters WHERE dx_date NOT LIKE '' AND dx_date IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'dx_method' AS atim_field FROM diagnosis_masters WHERE dx_method NOT LIKE '' AND dx_method IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'survival_time_months' AS atim_field FROM diagnosis_masters WHERE survival_time_months NOT LIKE '' AND survival_time_months IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'information_source' AS atim_field FROM diagnosis_masters WHERE information_source NOT LIKE '' AND information_source IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'icd10_code' AS atim_field FROM diagnosis_masters WHERE icd10_code NOT LIKE '' AND icd10_code IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'clinical_tstage' AS atim_field FROM diagnosis_masters WHERE clinical_tstage NOT LIKE '' AND clinical_tstage IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'clinical_nstage' AS atim_field FROM diagnosis_masters WHERE clinical_nstage NOT LIKE '' AND clinical_nstage IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'clinical_mstage' AS atim_field FROM diagnosis_masters WHERE clinical_mstage NOT LIKE '' AND clinical_mstage IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'clinical_stage_summary' AS atim_field FROM diagnosis_masters WHERE clinical_stage_summary NOT LIKE '' AND clinical_stage_summary IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'path_tstage' AS atim_field FROM diagnosis_masters WHERE path_tstage NOT LIKE '' AND path_tstage IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'path_nstage' AS atim_field FROM diagnosis_masters WHERE path_nstage NOT LIKE '' AND path_nstage IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'path_mstage' AS atim_field FROM diagnosis_masters WHERE path_mstage NOT LIKE '' AND path_mstage IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'path_stage_summary' AS atim_field FROM diagnosis_masters WHERE path_stage_summary NOT LIKE '' AND path_stage_summary IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'topography' AS atim_field FROM diagnosis_masters WHERE topography NOT LIKE '' AND topography IS NOT NULL AND deleted <> 1
      UNION ALL
      SELECT count(*) AS nbr_of_record_not_null, 'morphology' AS atim_field FROM diagnosis_masters WHERE morphology NOT LIKE '' AND morphology IS NOT NULL AND deleted <> 1
) AS tmp
WHERE tmp.nbr_of_record_not_null = 0;

UPDATE structure_formats 
SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_field_id IN (
  SELECT id 
  FROM structure_fields 
  WHERE `model`='DiagnosisMaster' 
  AND `tablename`='diagnosis_masters' 
  AND `field` IN (
    SELECT CONVERT(atim_field USING utf8)
      FROM (
        SELECT count(*) AS nbr_of_record_not_null, 'dx_date' AS atim_field FROM diagnosis_masters WHERE dx_date IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'dx_method' AS atim_field FROM diagnosis_masters WHERE dx_method NOT LIKE '' AND dx_method IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'survival_time_months' AS atim_field FROM diagnosis_masters WHERE survival_time_months NOT LIKE '' AND survival_time_months IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'information_source' AS atim_field FROM diagnosis_masters WHERE information_source NOT LIKE '' AND information_source IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'icd10_code' AS atim_field FROM diagnosis_masters WHERE icd10_code NOT LIKE '' AND icd10_code IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'clinical_tstage' AS atim_field FROM diagnosis_masters WHERE clinical_tstage NOT LIKE '' AND clinical_tstage IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'clinical_nstage' AS atim_field FROM diagnosis_masters WHERE clinical_nstage NOT LIKE '' AND clinical_nstage IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'clinical_mstage' AS atim_field FROM diagnosis_masters WHERE clinical_mstage NOT LIKE '' AND clinical_mstage IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'clinical_stage_summary' AS atim_field FROM diagnosis_masters WHERE clinical_stage_summary NOT LIKE '' AND clinical_stage_summary IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'path_tstage' AS atim_field FROM diagnosis_masters WHERE path_tstage NOT LIKE '' AND path_tstage IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'path_nstage' AS atim_field FROM diagnosis_masters WHERE path_nstage NOT LIKE '' AND path_nstage IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'path_mstage' AS atim_field FROM diagnosis_masters WHERE path_mstage NOT LIKE '' AND path_mstage IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'path_stage_summary' AS atim_field FROM diagnosis_masters WHERE path_stage_summary NOT LIKE '' AND path_stage_summary IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'topography' AS atim_field FROM diagnosis_masters WHERE topography NOT LIKE '' AND topography IS NOT NULL AND deleted <> 1
        UNION ALL
        SELECT count(*) AS nbr_of_record_not_null, 'morphology' AS atim_field FROM diagnosis_masters WHERE morphology NOT LIKE '' AND morphology IS NOT NULL AND deleted <> 1
    ) AS tmp
    WHERE tmp.nbr_of_record_not_null = 0
  )
);

UPDATE structure_formats 
SET `display_column`='2', `display_order`='1000'
WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');


-- -----------------------------------------------------------------------------------------------------------------------------------
-- Make all fields visible in search/index view to let them searchable and readable in data browser result forms.
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : -
-- -----------------------------------------------------------------------------------------------------------------------------------

-- participants

UPDATE structure_formats 
SET `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants')
 AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats 
SET `flag_search`='1', `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');

-- diagnosismasters

UPDATE structure_formats 
SET `flag_index`=`flag_detail`
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('diagnosismasters'));

-- dx_animals

UPDATE structure_formats 
SET `flag_index`=`flag_detail`, `flag_search`=`flag_detail`
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('diagnosismasters', 'dx_animals'));

-- consent_masters

UPDATE structure_formats 
SET `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='consent_masters') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ConsentMaster' AND `tablename`='consent_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- all consent details form

UPDATE structure_formats 
SET `flag_index`=`flag_detail`, `flag_search`=`flag_detail`
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('cd_biobanks', 'cd_campers', 'cd_csfs', 'cd_drainages', 'cd_pressures'));

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Changed ATiM to not allow people to link a collection to both treatment and annotation
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : See also app\Plugin\ClinicalAnnotation\View\ClinicalCollectionLinks\Hook.
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats 
SET `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model` IN ('TreatmentControl', 'TreatmentMaster', 'EventControl', 'EventMaster'));

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add corrections to database custom fields that generate errrors according to SQL_MODE 
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : -
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE collections MODIFY autopsy_datetime_accuracy char(1) NOT NULL DEFAULT '';
ALTER TABLE collections_revs MODIFY autopsy_datetime_accuracy char(1) NOT NULL DEFAULT '';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add corrections to databse custom fields based on ATiM database validation tool
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : -
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE dxd_animals MODIFY pig_injury_force varchar(6) DEFAULT NULL;
ALTER TABLE dxd_animals_revs MODIFY pig_injury_force varchar(6) DEFAULT NULL;

ALTER TABLE participants_revs DROP COLUMN icord_age_at_admission;
ALTER TABLE participants_revs DROP COLUMN icord_manner_of_death;
ALTER TABLE participants_revs DROP COLUMN icord_datetime_autopsy;
ALTER TABLE participants_revs DROP COLUMN icord_cause_of_death;
ALTER TABLE participants_revs DROP COLUMN icord_accident_details;
ALTER TABLE participants_revs DROP COLUMN icord_asia_grade;
ALTER TABLE participants_revs DROP COLUMN icord_mechanism_of_injury;
ALTER TABLE participants_revs DROP COLUMN icord_mechanism_of_injury_other;
ALTER TABLE participants_revs DROP COLUMN icord_injury_level_anatomical;
ALTER TABLE participants_revs DROP COLUMN icord_injury_level_neurological;
ALTER TABLE participants_revs DROP COLUMN icord_clinical_dx;
ALTER TABLE participants_revs DROP COLUMN icord_neurological_dx;
ALTER TABLE participants_revs DROP COLUMN icord_injury_datetime;
ALTER TABLE participants_revs DROP COLUMN icord_injury_datetime_accuracy;
ALTER TABLE participants_revs DROP COLUMN icord_postmortum_interal;
ALTER TABLE participants_revs DROP COLUMN icord_pig_species;
ALTER TABLE sample_masters_revs DROP COLUMN icord_vial_id;
ALTER TABLE sample_masters_revs DROP COLUMN icord_approx_timepoint;
ALTER TABLE sample_masters_revs DROP COLUMN icord_actual_timepoint;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Hide menu (and linked field) of unused tools 
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : -
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Sop

SELECT 'SOP exists! Script has to be reviewed to allow management of this type or records!' AS '!!! WARNING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' FROM sop_masters WHERE deleted <> 1 LIMIT 0 ,1;
SET @does_tool_exist = (SELECT IF(count(*) > 0, 1, 0) FROM sop_masters WHERE deleted <> 1);
UPDATE structure_formats 
SET `flag_add`=IF((@does_tool_exist + flag_add) = 2, 1, 0),
`flag_edit`=IF((@does_tool_exist + flag_edit) = 2, 1, 0),
`flag_search`=IF((@does_tool_exist + flag_search) = 2, 1, 0),
`flag_addgrid`=IF((@does_tool_exist + flag_addgrid) = 2, 1, 0),
`flag_editgrid`=IF((@does_tool_exist + flag_editgrid) = 2, 1, 0), 
`flag_batchedit`=IF((@does_tool_exist + flag_batchedit) = 2, 1, 0), 
`flag_index`=IF((@does_tool_exist + flag_index) = 2, 1, 0), 
`flag_detail`=IF((@does_tool_exist + flag_detail) = 2, 1, 0), 
`flag_summary`=IF((@does_tool_exist + flag_summary) = 2, 1, 0)
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='sop_master_id');
UPDATE menus SET flag_active = IF((@does_tool_exist + flag_active) = 2, 1, 0) WHERE use_link LIKE '/Sop/%';

-- Protocol

SELECT 'Protocol exists! Script has to be reviewed to allow management of this type or records!' AS '!!! WARNING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' FROM protocol_masters WHERE deleted <> 1 LIMIT 0 ,1;
SET @does_tool_exist = (SELECT IF(count(*) > 0, 1, 0) FROM protocol_masters WHERE deleted <> 1);
UPDATE structure_formats 
SET `flag_add`=IF((@does_tool_exist + flag_add) = 2, 1, 0),
`flag_edit`=IF((@does_tool_exist + flag_edit) = 2, 1, 0),
`flag_search`=IF((@does_tool_exist + flag_search) = 2, 1, 0),
`flag_addgrid`=IF((@does_tool_exist + flag_addgrid) = 2, 1, 0),
`flag_editgrid`=IF((@does_tool_exist + flag_editgrid) = 2, 1, 0), 
`flag_batchedit`=IF((@does_tool_exist + flag_batchedit) = 2, 1, 0), 
`flag_index`=IF((@does_tool_exist + flag_index) = 2, 1, 0), 
`flag_detail`=IF((@does_tool_exist + flag_detail) = 2, 1, 0), 
`flag_summary`=IF((@does_tool_exist + flag_summary) = 2, 1, 0)
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='protocol_master_id');
UPDATE menus SET flag_active = IF((@does_tool_exist + flag_active) = 2, 1, 0) WHERE use_link LIKE '/Protocol/%';

-- Drug

SELECT 'Drug exists! Script has to be reviewed to allow management of this type or records!' AS '!!! WARNING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' FROM drugs WHERE deleted <> 1 LIMIT 0 ,1;
SET @does_tool_exist = (SELECT IF(count(*) > 0, 1, 0) FROM drugs WHERE deleted <> 1);
UPDATE structure_formats 
SET `flag_add`=IF((@does_tool_exist + flag_add) = 2, 1, 0),
`flag_edit`=IF((@does_tool_exist + flag_edit) = 2, 1, 0),
`flag_search`=IF((@does_tool_exist + flag_search) = 2, 1, 0),
`flag_addgrid`=IF((@does_tool_exist + flag_addgrid) = 2, 1, 0),
`flag_editgrid`=IF((@does_tool_exist + flag_editgrid) = 2, 1, 0), 
`flag_batchedit`=IF((@does_tool_exist + flag_batchedit) = 2, 1, 0), 
`flag_index`=IF((@does_tool_exist + flag_index) = 2, 1, 0), 
`flag_detail`=IF((@does_tool_exist + flag_detail) = 2, 1, 0), 
`flag_summary`=IF((@does_tool_exist + flag_summary) = 2, 1, 0)
WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='drug_id');
UPDATE menus SET flag_active = IF((@does_tool_exist + flag_active) = 2, 1, 0) WHERE use_link LIKE '/Drug/%';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Hide any event controls not used by iCORD
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : -
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT CONCAT(disease_site, '-', event_group, '-', event_type) AS '####################### Event inactivated - Please confirm! ############################' 
FROM event_controls 
WHERE flag_active = 1 AND id NOT IN (
  SELECT DISTINCT event_control_id FROM event_masters WHERE deleted <> 1
)
AND event_type != 'animal data';
UPDATE event_controls SET flag_active = 0
WHERE flag_active = 1 AND id NOT IN (
  SELECT DISTINCT event_control_id FROM event_masters WHERE deleted <> 1
)
AND event_type != 'animal data';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add correcion to storage control properties of 'FreezerShelf'.
--
-- @author: Nicolas Luc
-- @date: 2019-02-04
-- @notes : See 'atim_v2.6.8_upgrade.sql' script comment ### 12 # Added new controls on storage_controls: coord_x_size 
--      and coord_y_size should be bigger than 1 if set.
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE storage_controls
SET horizontal_increment = 0,
display_x_size = 1,
display_y_size = 6,
coord_y_title = NULL,
coord_y_type = NULL,
coord_y_size = NULL
WHERE storage_type = 'FreezerShelf';

SET @modified_by = (SELECT id FROM users WHERE id = 1); -- Can be replace by a system users...
SET @modified = (SELECT NOW() FROM users WHERE id = 1);

-- Update aliquot masters 
-- (Note: All detail_revs table won't be completed because we don't know at this time which table will be impacted. But it could be a nice to have.)

UPDATE aliquot_masters AliquotMaster, storage_masters StorageMaster, storage_controls StorageControl
SET AliquotMaster.storage_coord_y = NULL,
AliquotMaster.modified = @modified,
AliquotMaster.modified_by = @modified_by
WHERE AliquotMaster.deleted <> 1
AND AliquotMaster.storage_master_id = StorageMaster.id
AND StorageMaster.storage_control_id = StorageControl.id
AND StorageMaster.deleted <> 1
AND StorageControl.storage_type = 'FreezerShelf';

INSERT aliquot_masters_revs(id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, 
study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, modified_by, version_created)
(SELECT id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, 
study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, product_code, notes, modified_by, modified
FROM aliquot_masters
WHERE modified = @modified AND modified_by = @modified_by);

INSERT INTO ad_tubes_revs (aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, cell_viability, hemolysis_signs, icord_storage_solution, version_created)
(SELECT aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, cell_viability, hemolysis_signs, icord_storage_solution, modified
FROM aliquot_masters, ad_tubes
WHERE id = aliquot_master_id AND modified = @modified AND modified_by = @modified_by);

-- Update storage_masters 
-- (Note: All detail_revs table won't be completed because we don't know at this time which table will be impacted. But it could be a nice to have.)

UPDATE storage_masters ChildStorageMaster, storage_masters StorageMaster, storage_controls StorageControl
SET ChildStorageMaster.parent_storage_coord_y = '',
ChildStorageMaster.modified = @modified,
ChildStorageMaster.modified_by = @modified_by
WHERE ChildStorageMaster.deleted <> 1
AND ChildStorageMaster.parent_id = StorageMaster.id
AND StorageMaster.storage_control_id = StorageControl.id
AND StorageMaster.deleted <> 1
AND StorageControl.storage_type = 'FreezerShelf';

INSERT INTO storage_masters_revs(id, code, storage_control_id, parent_id, lft, rght, barcode, short_label, selection_label, storage_status, parent_storage_coord_x, parent_storage_coord_y, temperature, temp_unit, notes, modified_by, version_created)
(SELECT id, code, storage_control_id, parent_id, lft, rght, barcode, short_label, selection_label, storage_status, parent_storage_coord_x, parent_storage_coord_y, temperature, temp_unit, notes, modified_by, modified
FROM storage_masters
WHERE modified = @modified AND modified_by = @modified_by);

INSERT INTO std_racks_revs (storage_master_id, version_created)
(SELECT storage_master_id, modified
FROM storage_masters, std_racks
WHERE id = storage_master_id AND modified = @modified AND modified_by = @modified_by);

-- TMA slide
-- No update. We consider no TMA currently exists.

SELECT 'Please review migration script' AS '### Error #iCord_0001 ###' FROM tma_slides WHERE deleted <> 1 LIMIT 0 ,1;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Hide collection protocol
--
-- @author: Nicolas Luc
-- @date: 2019-02-04
-- @notes : -
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='collection' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `language_heading`='', `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Add missing custom fields in revs table.
--
-- @author: Nicolas Luc
-- @date: 2019-02-04
-- @notes : Activate batch actions.
-- -----------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE participants_revs ADD COLUMN icord_species varchar(100) DEFAULT NULL;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Hid any treatment controls not used by iCORD
--
-- @author: Nicolas Luc
-- @date: 2019-02-04
-- @notes : -
-- -----------------------------------------------------------------------------------------------------------------------------------

SELECT CONCAT(disease_site, '-', tx_method) AS '####################### Treatment inactivated - Please confirm! ############################' 
FROM treatment_controls 
WHERE flag_active = 1 AND id NOT IN (
  SELECT DISTINCT treatment_control_id FROM treatment_masters WHERE deleted <> 1
);
UPDATE treatment_controls SET flag_active = 0
WHERE flag_active = 1 AND id NOT IN (
  SELECT DISTINCT treatment_control_id FROM treatment_masters WHERE deleted <> 1
);

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Update databrowser configuration.
--
-- @author: Nicolas Luc
-- @date: 2019-02-04
-- @notes : Activate databrowser relation links.
-- -----------------------------------------------------------------------------------------------------------------------------------

-- TMA Block to Storage

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage')) OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock'));

-- Aliquot to TMA Block

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock')) OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'ViewAliquot'));

-- TMA Slide to Storage

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage')) OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'NonTmaBlockStorage') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide'));

-- TMA Block To TMA Slide

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock')) OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaBlock') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide'));

-- TMA Slide to Study

UPDATE datamart_browsing_controls set flag_active_1_to_2 = 1, flag_active_2_to_1 = 1 
WHERE (id1 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary')) OR (id1 = (SELECT id FROM datamart_structures WHERE model = 'StudySummary') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TmaSlide'));

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Update batch actions configuration.
--
-- @author: Nicolas Luc
-- @date: 2019-02-04
-- @notes : Activate batch actions.
-- -----------------------------------------------------------------------------------------------------------------------------------

-- TmaBlock: Create tma slide

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaBlock' AND label = 'create tma slide';

-- TmaSlide: Edit

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'edit';

-- TmaSlide: Add to order

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'TmaSlide' AND label = 'add to order';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Hide MiscIdentifier data. 
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : -
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'MiscIdentifier') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'MiscIdentifier' AND label = 'number of elements per participant';
UPDATE menus SET flag_active = 0 WHERE use_link LIKE '/ClinicalAnnotation/MiscIdentifiers%';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Databrowser configuraton. 
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : Remove any object and objects link not used.
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');
UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ViewCollection') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'EventMaster');
UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster') OR id2 = (SELECT id FROM datamart_structures WHERE model = 'TreatmentMaster');

UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantContact') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ParticipantMessage') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'FamilyHistory') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');
UPDATE datamart_browsing_controls
SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0
WHERE id1 = (SELECT id FROM datamart_structures WHERE model = 'ReproductiveHistory') AND id2 = (SELECT id FROM datamart_structures WHERE model = 'Participant');

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Report configuraton. 
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : Remove any unusefull reports.
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'list all related diagnosis';

UPDATE datamart_reports SET flag_active = '0' WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'participant identifiers report';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Batch Actions configuraton. 
--
-- @author: Nicolas Luc
-- @date: 2019-01-31
-- @notes : Remove any unusefull batch actions.
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Print barcodes

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewCollection' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewSample' AND label = 'print barcodes';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'print barcodes';

-- List all related diagnosis

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'DiagnosisMaster' AND label = 'list all related diagnosis';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'Participant' AND label = 'list all related diagnosis';
	
-- Number of elements per participant
--   . TreatmentMaster
--   . TreatmentExtendMaster
--   . FamilyHistory
--   . ParticipantMessage
--   . ParticipantContact
--   . ReproductiveHistory

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentMaster' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'FamilyHistory' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ParticipantMessage' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ParticipantContact' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'ReproductiveHistory' AND label = 'number of elements per participant';
UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '0' WHERE fct.datamart_structure_id = str.id AND str.model = 'TreatmentExtendMaster' AND label = 'number of elements per participant';

-- ViewAliquot : Create use/event (applied to all)

UPDATE datamart_structure_functions fct, datamart_structures str SET fct.flag_active = '1' WHERE fct.datamart_structure_id = str.id AND str.model = 'ViewAliquot' AND label = 'create use/event (applied to all)';

-- -----------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------

UPDATE versions SET permissions_regenerated = 0;
UPDATE versions SET branch_build_number = 'xxxx' WHERE version_number = '2.7.1';