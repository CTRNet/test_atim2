DROP TABLE tmp_bogus_primary_dx;

ALTER TABLE datamart_batch_sets
 DROP COLUMN form_alias_for_results,
 DROP COLUMN sql_query_for_results,
 DROP COLUMN form_links_for_results,
 DROP COLUMN flag_use_query_results,
 DROP COLUMN plugin,
 DROP COLUMN model;
 
UPDATE lab_book_controls SET flag_active = 0;
UPDATE realiquoting_controls SET lab_book_control_id = NULL;
UPDATE parent_to_derivative_sample_controls SET lab_book_control_id = NULL; 
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='lab_book_master_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='lab_book_code_from_id') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='realiquotedparent') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Realiquoting' AND `tablename`='realiquotings' AND `field`='sync_with_lab_book' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE menus SET FLAG_ACTIVE = 0 WHERE use_link like '/labbook%';

DELETE FROM diagnosis_controls WHERE form_alias LIKE 'dx_cap_%' OR form_alias LIKE 'qc_gastro_dxd_cap_%';

SELECT '****************************************************************' as msg_1_dx
UNION
SELECT 'Participant having diagnosis with no origin definition: set to primary by default' as msg_1_dx;
SELECT id, participant_id FROM diagnosis_masters WHERE dx_origin like '' AND deleted <> 1;
UPDATE diagnosis_masters SET dx_origin = 'primary' WHERE dx_origin like '' AND deleted <> 1;

SELECT '****************************************************************' as msg_1_dx
UNION
SELECT 'Participant having diagnosis with origin = unknown: set to primary by default' as msg_1_dx;
SELECT id, participant_id FROM diagnosis_masters WHERE dx_origin like 'unknown' AND deleted <> 1;
UPDATE diagnosis_masters SET dx_origin = 'primary' WHERE dx_origin like 'unknown' AND deleted <> 1;

SELECT '****************************************************************' as msg_1_dx
UNION
SELECT 'Check no secondary is linked to participant having other diagnosis' as msg_1_dx;
SELECT diagnosis_masters.id , diagnosis_masters.dx_identifier , diagnosis_masters.primary_number , diagnosis_masters.dx_nature , diagnosis_masters.dx_origin , 
diagnosis_controls.controls_type , 
diagnosis_masters.participant_id
FROM diagnosis_masters 
INNER JOIN diagnosis_controls ON diagnosis_controls.id = diagnosis_masters.diagnosis_control_id
WHERE diagnosis_masters.deleted <> 1 AND dx_origin = 'secondary'
AND diagnosis_masters.participant_id IN (SELECT res_t.participant_id FROM (SELECT count(*) AS nbr_dx, participant_id  FROM `diagnosis_masters` WHERE deleted <> 1 GROUP BY participant_id) AS res_t WHERE res_t.nbr_dx > 1)
ORDER BY diagnosis_masters.participant_id ;

SELECT '****************************************************************' as msg_1_dx
UNION
SELECT 'Check all dx linked to primary-other' as msg_1_dx;
SELECT distinct diagnosis_controls.category,  diagnosis_controls.controls_type
FROM diagnosis_masters 
INNER JOIN diagnosis_controls ON diagnosis_controls.id = diagnosis_masters.diagnosis_control_id
WHERE diagnosis_masters.deleted <> 1;

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'secondary', 'other', 1, 'qc_gastro_dx_other', 'dxd_tissues', 0, 'other', 1);

SET @primary_other_ctrl_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'other');
SET @primary_unknown_ctrl_id = (SELECT id FROM diagnosis_controls WHERE controls_type = 'primary diagnosis unknown');
SET @secondary_other_ctrl_id = (SELECT id FROM diagnosis_controls WHERE category = 'secondary' AND controls_type = 'other');

UPDATE diagnosis_masters SET diagnosis_control_id = @secondary_other_ctrl_id WHERE dx_origin = 'secondary';
UPDATE diagnosis_masters_revs SET diagnosis_control_id = @secondary_other_ctrl_id WHERE dx_origin = 'secondary';

UPDATE diagnosis_masters SET primary_number = CONCAT('tmp',id) WHERE dx_origin = 'secondary';
UPDATE diagnosis_masters_revs SET primary_number = CONCAT('tmp',id) WHERE dx_origin = 'secondary';

INSERT INTO `diagnosis_masters` (`primary_number`, `dx_origin`, `diagnosis_control_id`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) 
(SELECT dm.primary_number, 'primary', @primary_unknown_ctrl_id, dm.participant_id, dm.created, dm.created_by, dm.modified, dm.modified_by, dm.deleted 
FROM diagnosis_masters dm WHERE dm.dx_origin = 'secondary');

UPDATE diagnosis_masters pdx, diagnosis_masters sdx
SET sdx.parent_id = pdx.id, sdx.primary_id = pdx.id
WHERE pdx.primary_number = sdx.primary_number AND pdx.dx_origin = 'primary' AND  sdx.dx_origin = 'secondary';

UPDATE diagnosis_masters SET primary_id = id WHERE dx_origin = 'primary';
UPDATE diagnosis_masters_revs SET primary_id = id WHERE dx_origin = 'primary';

TRUNCATE diagnosis_masters_revs;
INSERT INTO `diagnosis_masters_revs` (`id`, `primary_id`, `parent_id`, `dx_identifier`, `primary_number`, `dx_method`, `dx_nature`, `dx_origin`, `dx_date`, `dx_date_accuracy`, `tumor_size_greatest_dimension`, `additional_dimension_a`, `additional_dimension_b`, `tumor_size_cannot_be_determined`, `icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `morphology`, `topography`, `tumour_grade`, `tumour_grade_specify`, `age_at_dx`, `age_at_dx_precision`, `ajcc_edition`, `collaborative_staged`, `clinical_tstage`, `clinical_nstage`, `clinical_mstage`, `clinical_stage_summary`, `path_tnm_descriptor_m`, `path_tnm_descriptor_r`, `path_tnm_descriptor_y`, `path_tstage`, `path_nstage`, `path_nstage_nbr_node_examined`, `path_nstage_nbr_node_involved`, `path_mstage`, `path_mstage_metastasis_site_specify`, `path_stage_summary`, `survival_time_months`, `information_source`, `notes`, `diagnosis_control_id`, `participant_id`, `modified_by`, `version_created`)
(SELECT `id`, `primary_id`, `parent_id`, `dx_identifier`, `primary_number`, `dx_method`, `dx_nature`, `dx_origin`, `dx_date`, `dx_date_accuracy`, `tumor_size_greatest_dimension`, `additional_dimension_a`, `additional_dimension_b`, `tumor_size_cannot_be_determined`, `icd10_code`, `previous_primary_code`, `previous_primary_code_system`, `morphology`, `topography`, `tumour_grade`, `tumour_grade_specify`, `age_at_dx`, `age_at_dx_precision`, `ajcc_edition`, `collaborative_staged`, `clinical_tstage`, `clinical_nstage`, `clinical_mstage`, `clinical_stage_summary`, `path_tnm_descriptor_m`, `path_tnm_descriptor_r`, `path_tnm_descriptor_y`, `path_tstage`, `path_nstage`, `path_nstage_nbr_node_examined`, `path_nstage_nbr_node_involved`, `path_mstage`, `path_mstage_metastasis_site_specify`, `path_stage_summary`, `survival_time_months`, `information_source`, `notes`, `diagnosis_control_id`, `participant_id`, `created_by`, NOW() FROM diagnosis_masters);

ALTER TABLE diagnosis_masters 
	DROP COLUMN dx_identifier,
	DROP COLUMN primary_number,
	DROP COLUMN dx_origin;
ALTER TABLE diagnosis_masters_revs
	DROP COLUMN dx_identifier,
	DROP COLUMN primary_number,
	DROP COLUMN dx_origin;	
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('primary_number', 'dx_origin', 'dx_identifier'));
DELETE FROM structure_fields WHERE field IN ('primary_number', 'dx_origin', 'dx_identifier');

UPDATE structure_formats SET flag_summary = 0 WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters');
UPDATE structure_formats sf_sm, structure_formats sf_old
SET sf_sm.flag_summary = 1 
WHERE sf_sm.structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters')
AND sf_sm.structure_field_id = sf_old.structure_field_id 
AND sf_old.structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result') 
AND sf_old.flag_summary = '1';
DELETE from structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result');
DELETE from structures WHERE alias = 'sample_masters_for_search_result';

SELECT '****************************************************************' as msg_1_dx
UNION
SELECT 'Won''t link trt and cap report' as msg_1_dx;
DROP TABLE qc_gastro_tmp_cap_repor_to_trt;









-- qc_gastro_tmp_cap_repor_to_trt
