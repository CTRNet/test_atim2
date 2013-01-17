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

UPDATE structure_formats SET flag_summary = 0 WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters');
UPDATE structure_formats sf_sm, structure_formats sf_old
SET sf_sm.flag_summary = 1 
WHERE sf_sm.structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters')
AND sf_sm.structure_field_id = sf_old.structure_field_id 
AND sf_old.structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result') 
AND sf_old.flag_summary = '1';
DELETE from structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result');
DELETE from structures WHERE alias = 'sample_masters_for_search_result';

-- diagnosis rebuild

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('primary_number', 'dx_origin', 'dx_identifier'));
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('primary_number', 'dx_origin', 'dx_identifier'));
DELETE FROM structure_fields WHERE field IN ('primary_number', 'dx_origin', 'dx_identifier');

DELETE FROM diagnosis_controls WHERE form_alias LIKE 'dx_cap_%';

UPDATE diagnosis_controls SET controls_type = 'ovary', databrowser_label = 'primary|ovary' WHERE id = 14;
UPDATE diagnosis_controls SET controls_type = 'other', databrowser_label = 'primary|other' WHERE id = 15;

INSERT INTO `diagnosis_controls` (`id`, `category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
(null, 'secondary', 'ovary', 1, 'ohri_dx_ovaries', 'ohri_dx_ovaries', 0, 'secondary|ovary', 1),
(null, 'secondary', 'other', 1, 'ohri_dx_others', 'ohri_dx_others', 0, 'secondary|other', 1);

UPDATE diagnosis_masters SET primary_number = CONCAT('-',id) WHERE primary_number IS NULL;

CREATE TABLE tmp_dx(
 diagnosis_master_id INT NOT NULL
)Engine=InnoDb;

SELECT '****************************************************************' as msg_1_dx
UNION
SELECT 'Work on diagnoses unlinked to other diagnosis of the particiant by the primary_number (no metastasis, etc)' AS msg_1_dx
UNION
SELECT '****************************************************************' as msg_1_dx
UNION
SELECT 'dx_origin can be either primary or unknonw. No secondary should exists' AS msg_1_dx
UNION 
SELECT 'dx_origin = unknown will be changed to secondary with unknown primary' AS msg_1_dx
UNION
SELECT '****************************************************************' as msg_1_dx;

SELECT count(*) AS nbr_participants, dm.dx_origin, dm.diagnosis_control_id
FROM diagnosis_masters dm
INNER JOIN (
	SELECT count(*) AS nbr_dx_per_primary_number, 
	participant_id, 
	primary_number 
	FROM diagnosis_masters 
	GROUP BY participant_id, primary_number
) res ON res.participant_id = dm.participant_id AND res.primary_number = dm.primary_number
WHERE res.nbr_dx_per_primary_number = 1
GROUP BY dm.dx_origin, dm.diagnosis_control_id;

SELECT dm.participant_id, dm.dx_origin, dm.diagnosis_control_id
FROM diagnosis_masters dm
INNER JOIN (
	SELECT count(*) AS nbr_dx_per_primary_number, 
	participant_id, 
	primary_number 
	FROM diagnosis_masters 
	GROUP BY participant_id, primary_number
) res ON res.participant_id = dm.participant_id AND res.primary_number = dm.primary_number
WHERE res.nbr_dx_per_primary_number = 1 AND dm.dx_origin = 'unknown';

INSERT INTO tmp_dx (diagnosis_master_id) 
(SELECT dm.id
FROM diagnosis_masters dm
INNER JOIN (
	SELECT count(*) AS nbr_dx_per_primary_number, 
	participant_id, 
	primary_number 
	FROM diagnosis_masters 
	GROUP BY participant_id, primary_number
) res ON res.participant_id = dm.participant_id AND res.primary_number = dm.primary_number
WHERE res.nbr_dx_per_primary_number = 1);

SET @primary_ovary_ctrl_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'ovary');
SET @secondary_ovary_ctrl_id = (SELECT id FROM diagnosis_controls WHERE category = 'secondary' AND controls_type = 'ovary');
SET @primary_other_ctrl_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'other');
SET @secondary_other_ctrl_id = (SELECT id FROM diagnosis_controls WHERE category = 'secondary' AND controls_type = 'other');
SET @primary_unknown_ctrl_id = (SELECT id FROM diagnosis_controls WHERE controls_type = 'primary diagnosis unknown');

UPDATE diagnosis_masters dm, tmp_dx
SET dm.dx_origin = 'secondary', dm.diagnosis_control_id = @secondary_ovary_ctrl_id 
WHERE dm.id = tmp_dx.diagnosis_master_id AND dm.dx_origin = 'unknown' AND dm.diagnosis_control_id = @primary_ovary_ctrl_id; 

UPDATE diagnosis_masters dm, tmp_dx
SET dm.dx_origin = 'secondary', dm.diagnosis_control_id = @secondary_other_ctrl_id 
WHERE dm.id = tmp_dx.diagnosis_master_id AND dm.dx_origin = 'unknown' AND dm.diagnosis_control_id = @primary_other_ctrl_id; 

INSERT INTO `diagnosis_masters` (`primary_number`, `dx_origin`, `diagnosis_control_id`, `participant_id`, `created`, `created_by`, `modified`, `modified_by`, `deleted`) 
(SELECT dm.primary_number, 'primary', @primary_unknown_ctrl_id, dm.participant_id, dm.created, dm.created_by, dm.modified, dm.modified_by, dm.deleted 
FROM diagnosis_masters dm
INNER JOIN tmp_dx ON dm.id = tmp_dx.diagnosis_master_id
WHERE dm.dx_origin = 'secondary');

INSERT INTO `dxd_primaries` (id, diagnosis_master_id, deleted) (SELECT id, id, deleted FROM diagnosis_masters WHERE diagnosis_control_id = @primary_unknown_ctrl_id);
INSERT INTO `tmp_dx` (diagnosis_master_id) (SELECT id FROM diagnosis_masters WHERE diagnosis_control_id = @primary_unknown_ctrl_id);

SELECT '****************************************************************' as msg_1_dx
UNION
SELECT 'Work on diagnoses linked to other diagnosis of the particiant by the primary_number (primary+secondary)' AS msg_1_dx
UNION
SELECT '****************************************************************' as msg_1_dx
UNION
SELECT 'dx_origin can be either primary or secondary. No unknown should exists' AS msg_1_dx
UNION 
SELECT 'only one primary per participant/primaru number' AS msg_1_dx
UNION
SELECT '****************************************************************' as msg_1_dx;

SELECT dm.participant_id, primary_number, dm.dx_origin, dm.diagnosis_control_id
FROM diagnosis_masters dm
WHERE dm.id NOT IN (SELECT diagnosis_master_id FROM tmp_dx)
ORDER BY dm.participant_id, primary_number, dm.dx_origin;

UPDATE diagnosis_masters dm, tmp_dx
SET dm.diagnosis_control_id = @secondary_ovary_ctrl_id 
WHERE dm.id NOT IN (SELECT diagnosis_master_id FROM tmp_dx) 
AND dm.dx_origin = 'secondary' AND dm.diagnosis_control_id = @primary_ovary_ctrl_id; 

UPDATE diagnosis_masters dm, tmp_dx
SET dm.diagnosis_control_id = @secondary_other_ctrl_id 
WHERE dm.id NOT IN (SELECT diagnosis_master_id FROM tmp_dx) 
AND dm.dx_origin = 'secondary' AND dm.diagnosis_control_id = @primary_other_ctrl_id; 

SELECT '************ existing dx_origin **********************' as msg_1_dx
UNION
SELECT distinct dx_origin  as msg_1_dx FROM diagnosis_masters;

UPDATE diagnosis_masters AS dm1
INNER JOIN diagnosis_masters AS dm2 ON dm1.participant_id=dm2.participant_id AND dm1.primary_number=dm2.primary_number AND dm1.dx_origin != 'primary' AND dm2.dx_origin = 'primary'
SET dm1.primary_id=dm2.id;
UPDATE diagnosis_masters SET primary_id=id WHERE dx_origin='primary';

ALTER TABLE diagnosis_masters 
	DROP COLUMN dx_identifier,
	DROP COLUMN primary_number,
	DROP COLUMN dx_origin;
ALTER TABLE diagnosis_masters_revs
	DROP COLUMN dx_identifier,
	DROP COLUMN primary_number,
	DROP COLUMN dx_origin;	
	
DROP TABLE tmp_dx;
