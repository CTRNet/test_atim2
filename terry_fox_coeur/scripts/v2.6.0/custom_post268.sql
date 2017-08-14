UPDATE users set flag_active = 0 WHERE username NOT IN ('Manon' , 'clepage' , 'Liliane' , 'NicoEn' , 'lportelance' , 'EuridiceCarmona' , 'kleclerc');
UPDATE users set flag_active = 0 WHERE group_id != 1;
UPDATE users SET force_password_reset = '0', password_modified = NOW() WHERE flag_active = 1;

UPDATE users SET username = 'System' WHERE id = 2;
UPDATE groups SET name = 'System' WHERE id = 2;

UPDATE banks SET name = REPLACE(name, '-COEUR', '');
UPDATE groups SET flag_show_confidential = '1' WHERE name = 'Administrators';

SET @created = NOW();
SET @created_by = (SELECT id FROM users where username = 'System');
INSERT INTO banks (name, description, created, created_by, modified, modified_by) VALUES ('MOBP', '', @created, @created_by, @created, @created_by);
INSERT INTO banks_revs (id, name, description, version_created, modified_by) (SELECT id, name, description, modified, modified_by FROM banks WHERE name = 'MOBP');

DROP TABLE console_stored_views;
DROP TABLE id_linking;
DROP TABLE start_time;

ALTER TABLE qc_tf_tx_empty DROP COLUMN deleted;

UPDATE structure_formats SET `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='chronology') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='custom' AND `tablename`='' AND `field`='time' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES ('suspected', 'Suspected', '');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Participant
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_index`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_bank_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='banks') AND `flag_confidential`='0');

UPDATE structure_fields 
SET `setting`='size=20,class=range file'
WHERE `model`='Participant' AND `tablename`='participants' AND `field`='qc_tf_bank_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0';

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_edit_readonly`='1' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Diagnosis
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Inactivate Primary Unknown & diagnosiscontrol

SELECT count(*) AS "###TO CHECK### Nbr of unknown primary diagnosis. If not equals to 0 then it's an error."
FROM diagnosis_masters WHERE diagnosis_control_id IN (SELECT id from diagnosis_controls WHERE category = 'primary' and controls_type = 'primary diagnosis unknown');
UPDATE diagnosis_controls SET flag_active = 0 WHERE category = 'primary' and controls_type = 'primary diagnosis unknown';

UPDATE diagnosis_controls SET controls_type = 'recurrence or metastasis' WHERE controls_type = 'progression and recurrence' AND category = 'secondary - distant';
INSERT IGNORE INTO i18n (id,en,fr) VALUES ('recurrence or metastasis', 'Recurrence or Metastasis', '');

-- Remove qc_tf_dx_origin

DELETE FROM structure_formats 
WHERE structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_dx_origin' AND `language_label`='origin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_dx_origin') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');
DELETE FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_dx_origin' AND `language_label`='origin' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_dx_origin') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1';
ALTER TABLE diagnosis_masters DROP COLUMN qc_tf_dx_origin;
ALTER TABLE diagnosis_masters_revs DROP COLUMN qc_tf_dx_origin;

-- qc_tf_tumor_site

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_tumor_site' AND `language_label`='tumor site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0' AND `sortable`='1');

UPDATE structure_formats SET `display_order`='4' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_other_primary_cancer') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_tumor_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') AND `flag_confidential`='0');

UPDATE diagnosis_masters SET qc_tf_tumor_site = 'Female Genital-Ovary', qc_tf_progression_detection_method = 'not applicable' WHERE diagnosis_control_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'EOC');
UPDATE diagnosis_masters_revs SET qc_tf_tumor_site = 'Female Genital-Ovary', qc_tf_progression_detection_method = 'not applicable' WHERE diagnosis_control_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'EOC');

UPDATE diagnosis_masters SET qc_tf_tumor_site = 'unknown' WHERE qc_tf_tumor_site = '' AND diagnosis_control_id NOT IN (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'EOC');
UPDATE diagnosis_masters_revs SET qc_tf_tumor_site = 'unknown' WHERE qc_tf_tumor_site = '' AND diagnosis_control_id NOT IN (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'EOC');

UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_tumor_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site') AND `flag_confidential`='0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_tumor_site' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_tumor_site')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='tumor site' AND `language_tag`=''), '1', '30', '', '0', '0', '', '1', 'site', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

-- ...

UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='presence_of_precursor_of_benign_lesions' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_presence_of_precursor_of_benign_lesions') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dx_eoc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_eocs' AND `field`='fallopian_tube_lesion' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_fallopian_tube_lesion') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='7' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_progression_recurrence') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_detection_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_detection_method') AND `flag_confidential`='0');

UPDATE structure_formats SET `flag_index`='0' 
WHERE structure_id=(SELECT id FROM structures WHERE alias='view_diagnosis') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `field` IN ('category', 'controls_type', 'dx_date'));

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='view_diagnosis'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='qc_tf_progression_detection_method' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_progression_detection_method')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='detection method' AND `language_tag`=''), '1', '31', '', '0', '0', '', '1', 'method', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');

INSERT INTO i18n (id,en,fr) VALUES ('site', 'Site', '');

REPLACE INTO i18n (id,en,fr)
VALUES
('new secondary - distant', 'New Secondary', 'Nouveau secondaire'),
('secondary - distant', 'Secondary', 'Secondaire');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Event Master
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO structures(`alias`) VALUES ('qc_tf_eventmasters_tree_view');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_eventmasters_tree_view'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_ca125s' AND `field`='precision_u' AND `type`='float_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='ca125 precision (u)' AND `language_tag`=''), '1', '10', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `display_order`='-2', `flag_override_tag`='1', `language_tag`='=', `flag_override_label`='1', `language_label`=''
WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_eventmasters_tree_view') 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_ca125s' AND `field`='precision_u' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE event_controls SET event_group = 'clinical', flag_use_for_ccl = '0', use_addgrid = '1', use_detail_form_for_index = '1'  WHERE flag_active = 1;
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '/ClinicalAnnotation/EventMasters/listall/lab%';
UPDATE event_controls SET databrowser_label = CONCAT(event_type, '|',event_group) WHERE flag_active = 1;

INSERT INTO structure_validations
(structure_field_id, rule, on_action, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0'), 'notEmpty', '', '');

-- CA 125

UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_ed_ca125s') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_ca125s' AND `field`='precision_u' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_ed_ca125s') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO structure_validations
(structure_field_id, rule, on_action, language_message) VALUES
((SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_ca125s'), 'notEmpty', '', '');

-- CT Scan

UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_ed_ct_scans') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_ct_scans' AND `field`='scan_precision' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ct_scan_precision') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_addgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_ed_ct_scans') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- radiology
-- Biopsy

UPDATE structure_formats SET `flag_addgrid`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_ed_no_details') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- Event control clean up

UPDATE event_controls SET databrowser_label = CONCAT(event_type, '|', disease_site) WHERE flag_active = 1;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Treatment Master
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE treatment_controls SET flag_use_for_ccl = '0';

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE `versions` SET branch_build_number = '6784' WHERE version_number = '2.6.8';
