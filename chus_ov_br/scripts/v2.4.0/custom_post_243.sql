
UPDATE menus SET flag_active = '0' WHERE use_link LIKE '%/clinicalannotation/participant_contacts%';

UPDATE structure_fields SET  `type`='float_positive' WHERE model='Participant' AND tablename='participants' AND field='participant_identifier' AND `type`='input' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `flag_add`='1', `flag_edit_readonly`='0', `flag_editgrid_readonly`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

INSERT INTO `structure_validations` (`structure_field_id`, `rule`) 
VALUES ((SELECT id FROM structure_fields WHERE field = 'participant_identifier' AND model = 'Participant'), 'isUnique');

UPDATE structure_formats SET `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier');
UPDATE structure_formats SET `display_order`='102', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1', `display_order`='20', `language_heading`='coding' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='20', `language_heading`='coding' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='icd10_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1', `display_order`='10', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='laterality') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1', `display_order`='29' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='30' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='31' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='32' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='33' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='34' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='34' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='35' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='36' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='stage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_stage') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1', `display_order`='10', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='laterality' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_laterality') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1', `display_order`='29' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='30' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='31' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='32' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='clinical_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='33' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_tstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='34' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_nstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='34' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_mstage' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='35' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='path_stage_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='36' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='stage' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_stage') AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='19' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='atcd_description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='18', `language_heading`='atcd' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='atcd' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_order`='19' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='atcd_description' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='18', `language_heading`='atcd' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='atcd' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE chus_dxd_ovaries DROP COLUMN  morphology;
ALTER TABLE chus_dxd_ovaries_revs DROP COLUMN  morphology;

DELETE FROM structure_permissible_values_customs WHERE control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology');
DELETE FROM structure_permissible_values_custom_controls WHERE name LIKE 'ovary diagnosis morphology';
DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id = (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='morphology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_custom_ovary_dx_morphology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='morphology' AND `language_tag`='');
DELETE FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='morphology' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_custom_ovary_dx_morphology')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='morphology' AND `language_tag`='';
DELETE FROM `structure_value_domains` WHERE domain_name = 'chus_custom_ovary_dx_morphology';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_dx_nature', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_nature'), '0', '', '', '', 'nature (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_custom_tumour_grade'), '0', '', '', '', 'grade (lov)', ''),

('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_serous', 'yes_no',  NULL , '0', '', '', '', 'serous (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_papillary', 'yes_no',  NULL , '0', '', '', '', 'papillary (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_mucinous', 'yes_no',  NULL , '0', '', '', '', 'mucinous (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_endometrioid_endometriotic_endometriosis', 'yes_no',  NULL , '0', '', '', '', 'endometrioid/endometriotic/endometriosis (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_squamous', 'yes_no',  NULL , '0', '', '', '', 'squamous (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_Krukenberg', 'yes_no',  NULL , '0', '', '', '', 'Krukenberg (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_mullerian', 'yes_no',  NULL , '0', '', '', '', 'mullerian (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_granulosa', 'yes_no',  NULL , '0', '', '', '', 'granulosa (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_squamous_dermoid', 'yes_no',  NULL , '0', '', '', '', 'squamous/dermoid (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_mature_teratoma', 'yes_no',  NULL , '0', '', '', '', 'mature teratoma (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_immature_teratoma', 'yes_no',  NULL , '0', '', '', '', 'immature teratoma (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_brenner', 'yes_no',  NULL , '0', '', '', '', 'brenner (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_neuroendocrine', 'yes_no',  NULL , '0', '', '', '', 'neuroendocrine (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_sarcoma', 'yes_no',  NULL , '0', '', '', '', 'sarcoma (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_clear_cell', 'yes_no',  NULL , '0', '', '', '', 'clear cell (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_small_cell', 'yes_no',  NULL , '0', '', '', '', 'small cell (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_sex_cord', 'yes_no',  NULL , '0', '', '', '', 'sex cord (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_cells_in_cat_rings', 'yes_no',  NULL , '0', '', '', '', 'cells in cat rings (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_struma_ovarii', 'yes_no',  NULL , '0', '', '', '', 'struma ovarii (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_fibroma', 'yes_no',  NULL , '0', '', '', '', 'fibroma (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_atrophic', 'yes_no',  NULL , '0', '', '', '', 'atrophic (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_fibrothecoma', 'yes_no',  NULL , '0', '', '', '', 'fibrothecoma (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_polycystic', 'yes_no',  NULL , '0', '', '', '', 'polycystic (lov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_inclusion_cyst', 'yes_no',  NULL , '0', '', '', '', 'inclusion cyst (lov)', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_dx_nature'), '3', '98', 'left ovary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_tumour_grade'), '3', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 

((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_serous'), '2', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_papillary'), '2', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_mucinous'), '2', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_endometrioid_endometriotic_endometriosis'), '2', '103', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_squamous'), '2', '104', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_Krukenberg'), '2', '105', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_mullerian'), '2', '106', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_granulosa'), '2', '107', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_squamous_dermoid'), '2', '108', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_mature_teratoma'), '2', '109', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_immature_teratoma'), '2', '110', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_brenner'), '2', '111', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_neuroendocrine'), '2', '112', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_sarcoma'), '2', '113', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_clear_cell'), '2', '114', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_small_cell'), '2', '115', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_sex_cord'), '2', '116', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_cells_in_cat_rings'), '2', '117', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_struma_ovarii'), '2', '118', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_fibroma'), '2', '119', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_atrophic'), '2', '120', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_fibrothecoma'), '2', '121', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_polycystic'), '2', '122', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_inclusion_cyst'), '2', '123', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

ALTER TABLE chus_dxd_ovaries 
	ADD COLUMN `left_ovary_dx_nature` varchar(50) DEFAULT NULL,
	ADD COLUMN `left_ovary_tumour_grade` varchar(150) DEFAULT NULL,
	ADD COLUMN left_ovary_serous char(1) DEFAULT '',
	ADD COLUMN left_ovary_papillary char(1) DEFAULT '',
	ADD COLUMN left_ovary_mucinous char(1) DEFAULT '',
	ADD COLUMN left_ovary_endometrioid_endometriotic_endometriosis char(1) DEFAULT '',
	ADD COLUMN left_ovary_squamous char(1) DEFAULT '',
	ADD COLUMN left_ovary_Krukenberg char(1) DEFAULT '',
	ADD COLUMN left_ovary_mullerian char(1) DEFAULT '',
	ADD COLUMN left_ovary_granulosa char(1) DEFAULT '',
	ADD COLUMN left_ovary_squamous_dermoid char(1) DEFAULT '',
	ADD COLUMN left_ovary_mature_teratoma char(1) DEFAULT '',
	ADD COLUMN left_ovary_immature_teratoma char(1) DEFAULT '',
	ADD COLUMN left_ovary_brenner char(1) DEFAULT '',
	ADD COLUMN left_ovary_neuroendocrine char(1) DEFAULT '',
	ADD COLUMN left_ovary_sarcoma char(1) DEFAULT '',
	ADD COLUMN left_ovary_clear_cell char(1) DEFAULT '',
	ADD COLUMN left_ovary_small_cell char(1) DEFAULT '',
	ADD COLUMN left_ovary_sex_cord char(1) DEFAULT '',
	ADD COLUMN left_ovary_cells_in_cat_rings char(1) DEFAULT '',
	ADD COLUMN left_ovary_struma_ovarii char(1) DEFAULT '',
	ADD COLUMN left_ovary_fibroma char(1) DEFAULT '',
	ADD COLUMN left_ovary_atrophic char(1) DEFAULT '',
	ADD COLUMN left_ovary_fibrothecoma char(1) DEFAULT '',
	ADD COLUMN left_ovary_polycystic char(1) DEFAULT '',
	ADD COLUMN left_ovary_inclusion_cyst char(1) DEFAULT '';
	
ALTER TABLE chus_dxd_ovaries_revs
	ADD COLUMN `left_ovary_dx_nature` varchar(50) DEFAULT NULL,
	ADD COLUMN `left_ovary_tumour_grade` varchar(150) DEFAULT NULL,
	ADD COLUMN left_ovary_serous char(1) DEFAULT '',
	ADD COLUMN left_ovary_papillary char(1) DEFAULT '',
	ADD COLUMN left_ovary_mucinous char(1) DEFAULT '',
	ADD COLUMN left_ovary_endometrioid_endometriotic_endometriosis char(1) DEFAULT '',
	ADD COLUMN left_ovary_squamous char(1) DEFAULT '',
	ADD COLUMN left_ovary_Krukenberg char(1) DEFAULT '',
	ADD COLUMN left_ovary_mullerian char(1) DEFAULT '',
	ADD COLUMN left_ovary_granulosa char(1) DEFAULT '',
	ADD COLUMN left_ovary_squamous_dermoid char(1) DEFAULT '',
	ADD COLUMN left_ovary_mature_teratoma char(1) DEFAULT '',
	ADD COLUMN left_ovary_immature_teratoma char(1) DEFAULT '',
	ADD COLUMN left_ovary_brenner char(1) DEFAULT '',
	ADD COLUMN left_ovary_neuroendocrine char(1) DEFAULT '',
	ADD COLUMN left_ovary_sarcoma char(1) DEFAULT '',
	ADD COLUMN left_ovary_clear_cell char(1) DEFAULT '',
	ADD COLUMN left_ovary_small_cell char(1) DEFAULT '',
	ADD COLUMN left_ovary_sex_cord char(1) DEFAULT '',
	ADD COLUMN left_ovary_cells_in_cat_rings char(1) DEFAULT '',
	ADD COLUMN left_ovary_struma_ovarii char(1) DEFAULT '',
	ADD COLUMN left_ovary_fibroma char(1) DEFAULT '',
	ADD COLUMN left_ovary_atrophic char(1) DEFAULT '',
	ADD COLUMN left_ovary_fibrothecoma char(1) DEFAULT '',
	ADD COLUMN left_ovary_polycystic char(1) DEFAULT '',
	ADD COLUMN left_ovary_inclusion_cyst char(1) DEFAULT '';

INSERT INTO i18n (id,en,fr) VALUES
('serous (lov)','Serous (lov)','Séreux (ovg)'),
('papillary (lov)','Papillary (lov)','Papillaire (ovg)'),
('mucinous (lov)','Mucinous (lov)','Mucineux (ovg)'),
('endometrioid/endometriotic/endometriosis (lov)','Endometrioid/Endometriotic/Endometriosis (lov)','Endométrioide/Endométriotique/Endométriosique (ovg)'),
('squamous (lov)','Squamous (lov)','Malpighien (ovg)'),
('Krukenberg (lov)','Krukenberg (lov)','Krukenberg (ovg)'),
('mullerian (lov)','Mullerian (lov)','Mullerien (ovg)'),
('granulosa (lov)','Granulosa (lov)','Granulosa (ovg)'),
('squamous/dermoid (lov)','Squamous/Dermoid (lov)','Épidermoide/Dermoide (ovg)'),
('mature teratoma (lov)','Mature Teratoma (lov)','Tératome Mature (ovg)'),
('immature teratoma (lov)','Immature Teratoma (lov)','Tératome Immature (ovg)'),
('brenner (lov)','Brenner (lov)','Brenner (ovg)'),
('neuroendocrine (lov)','Neuroendocrine (lov)','Neuroendocrine (ovg)'),
('sarcoma (lov)','Sarcoma (lov)','Sarcome (ovg)'),
('clear cell (lov)','Clear Cell (lov)','Clear Cell (ovg)'),
('small cell (lov)','Small Cell (lov)','Small Cell (ovg)'),
('sex cord (lov)','Sex Cord (lov)','Sex cord (lov)'),
('cells in cat rings (lov)','Cells in Cat Rings (ovg)','Cellules en bagues de chaton (ovg)'),
('struma ovarii (lov)','Struma Ovarii (lov)','Struma Ovarii (ovg)'),
('fibroma (lov)','Fibroma (lov)','Fibrome (ovg)'),
('atrophic (lov)','Atrophic (lov)','Atrophique (ovg)'),
('fibrothecoma (lov)','Fibrothecoma (lov)','Fibrothécale (ovg)'),
('polycystic (lov)','Polycystic (lov)','Polykystique (ovg)'),
('inclusion cyst (lov)','Inclusion Cyst (lov)','Kyste d''inclusion (ovg)'),

('nature (lov)','Nature (lov)','Nature (ovg)'),
('grade (lov)','Grade (lov)','Grade (ovg)');

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_dx_nature', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_nature'), '0', '', '', '', 'nature (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_tumour_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_custom_tumour_grade'), '0', '', '', '', 'grade (rov)', ''),

('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_serous', 'yes_no',  NULL , '0', '', '', '', 'serous (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_papillary', 'yes_no',  NULL , '0', '', '', '', 'papillary (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_mucinous', 'yes_no',  NULL , '0', '', '', '', 'mucinous (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_endometrioid_endometriotic_endometriosis', 'yes_no',  NULL , '0', '', '', '', 'endometrioid/endometriotic/endometriosis (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_squamous', 'yes_no',  NULL , '0', '', '', '', 'squamous (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_Krukenberg', 'yes_no',  NULL , '0', '', '', '', 'Krukenberg (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_mullerian', 'yes_no',  NULL , '0', '', '', '', 'mullerian (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_granulosa', 'yes_no',  NULL , '0', '', '', '', 'granulosa (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_squamous_dermoid', 'yes_no',  NULL , '0', '', '', '', 'squamous/dermoid (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_mature_teratoma', 'yes_no',  NULL , '0', '', '', '', 'mature teratoma (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_immature_teratoma', 'yes_no',  NULL , '0', '', '', '', 'immature teratoma (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_brenner', 'yes_no',  NULL , '0', '', '', '', 'brenner (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_neuroendocrine', 'yes_no',  NULL , '0', '', '', '', 'neuroendocrine (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_sarcoma', 'yes_no',  NULL , '0', '', '', '', 'sarcoma (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_clear_cell', 'yes_no',  NULL , '0', '', '', '', 'clear cell (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_small_cell', 'yes_no',  NULL , '0', '', '', '', 'small cell (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_sex_cord', 'yes_no',  NULL , '0', '', '', '', 'sex cord (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_cells_in_cat_rings', 'yes_no',  NULL , '0', '', '', '', 'cells in cat rings (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_struma_ovarii', 'yes_no',  NULL , '0', '', '', '', 'struma ovarii (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_fibroma', 'yes_no',  NULL , '0', '', '', '', 'fibroma (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_atrophic', 'yes_no',  NULL , '0', '', '', '', 'atrophic (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_fibrothecoma', 'yes_no',  NULL , '0', '', '', '', 'fibrothecoma (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_polycystic', 'yes_no',  NULL , '0', '', '', '', 'polycystic (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_inclusion_cyst', 'yes_no',  NULL , '0', '', '', '', 'inclusion cyst (rov)', '');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_dx_nature'), '3', '198', 'right ovary', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_tumour_grade'), '3', '199', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 

((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_serous'), '3', '200', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_papillary'), '3', '201', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_mucinous'), '3', '202', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_endometrioid_endometriotic_endometriosis'), '3', '203', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_squamous'), '3', '204', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_Krukenberg'), '3', '205', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_mullerian'), '3', '206', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_granulosa'), '3', '207', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_squamous_dermoid'), '3', '208', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_mature_teratoma'), '3', '209', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_immature_teratoma'), '3', '210', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_brenner'), '3', '211', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_neuroendocrine'), '3', '212', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_sarcoma'), '3', '213', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_clear_cell'), '3', '214', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_small_cell'), '3', '215', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_sex_cord'), '3', '216', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_cells_in_cat_rings'), '3', '217', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_struma_ovarii'), '3', '218', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_fibroma'), '3', '219', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_atrophic'), '3', '220', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_fibrothecoma'), '3', '221', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_polycystic'), '3', '222', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_inclusion_cyst'), '3', '223', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

ALTER TABLE chus_dxd_ovaries 
	ADD COLUMN `right_ovary_dx_nature` varchar(50) DEFAULT NULL,
	ADD COLUMN `right_ovary_tumour_grade` varchar(150) DEFAULT NULL,
	ADD COLUMN right_ovary_serous char(1) DEFAULT '',
	ADD COLUMN right_ovary_papillary char(1) DEFAULT '',
	ADD COLUMN right_ovary_mucinous char(1) DEFAULT '',
	ADD COLUMN right_ovary_endometrioid_endometriotic_endometriosis char(1) DEFAULT '',
	ADD COLUMN right_ovary_squamous char(1) DEFAULT '',
	ADD COLUMN right_ovary_Krukenberg char(1) DEFAULT '',
	ADD COLUMN right_ovary_mullerian char(1) DEFAULT '',
	ADD COLUMN right_ovary_granulosa char(1) DEFAULT '',
	ADD COLUMN right_ovary_squamous_dermoid char(1) DEFAULT '',
	ADD COLUMN right_ovary_mature_teratoma char(1) DEFAULT '',
	ADD COLUMN right_ovary_immature_teratoma char(1) DEFAULT '',
	ADD COLUMN right_ovary_brenner char(1) DEFAULT '',
	ADD COLUMN right_ovary_neuroendocrine char(1) DEFAULT '',
	ADD COLUMN right_ovary_sarcoma char(1) DEFAULT '',
	ADD COLUMN right_ovary_clear_cell char(1) DEFAULT '',
	ADD COLUMN right_ovary_small_cell char(1) DEFAULT '',
	ADD COLUMN right_ovary_sex_cord char(1) DEFAULT '',
	ADD COLUMN right_ovary_cells_in_cat_rings char(1) DEFAULT '',
	ADD COLUMN right_ovary_struma_ovarii char(1) DEFAULT '',
	ADD COLUMN right_ovary_fibroma char(1) DEFAULT '',
	ADD COLUMN right_ovary_atrophic char(1) DEFAULT '',
	ADD COLUMN right_ovary_fibrothecoma char(1) DEFAULT '',
	ADD COLUMN right_ovary_polycystic char(1) DEFAULT '',
	ADD COLUMN right_ovary_inclusion_cyst char(1) DEFAULT '';
	
ALTER TABLE chus_dxd_ovaries_revs
	ADD COLUMN `right_ovary_dx_nature` varchar(50) DEFAULT NULL,
	ADD COLUMN `right_ovary_tumour_grade` varchar(150) DEFAULT NULL,
	ADD COLUMN right_ovary_serous char(1) DEFAULT '',
	ADD COLUMN right_ovary_papillary char(1) DEFAULT '',
	ADD COLUMN right_ovary_mucinous char(1) DEFAULT '',
	ADD COLUMN right_ovary_endometrioid_endometriotic_endometriosis char(1) DEFAULT '',
	ADD COLUMN right_ovary_squamous char(1) DEFAULT '',
	ADD COLUMN right_ovary_Krukenberg char(1) DEFAULT '',
	ADD COLUMN right_ovary_mullerian char(1) DEFAULT '',
	ADD COLUMN right_ovary_granulosa char(1) DEFAULT '',
	ADD COLUMN right_ovary_squamous_dermoid char(1) DEFAULT '',
	ADD COLUMN right_ovary_mature_teratoma char(1) DEFAULT '',
	ADD COLUMN right_ovary_immature_teratoma char(1) DEFAULT '',
	ADD COLUMN right_ovary_brenner char(1) DEFAULT '',
	ADD COLUMN right_ovary_neuroendocrine char(1) DEFAULT '',
	ADD COLUMN right_ovary_sarcoma char(1) DEFAULT '',
	ADD COLUMN right_ovary_clear_cell char(1) DEFAULT '',
	ADD COLUMN right_ovary_small_cell char(1) DEFAULT '',
	ADD COLUMN right_ovary_sex_cord char(1) DEFAULT '',
	ADD COLUMN right_ovary_cells_in_cat_rings char(1) DEFAULT '',
	ADD COLUMN right_ovary_struma_ovarii char(1) DEFAULT '',
	ADD COLUMN right_ovary_fibroma char(1) DEFAULT '',
	ADD COLUMN right_ovary_atrophic char(1) DEFAULT '',
	ADD COLUMN right_ovary_fibrothecoma char(1) DEFAULT '',
	ADD COLUMN right_ovary_polycystic char(1) DEFAULT '',
	ADD COLUMN right_ovary_inclusion_cyst char(1) DEFAULT '';

INSERT INTO i18n (id,en,fr) VALUES
('serous (rov)','Serous (rov)','Séreux (ovd)'),
('papillary (rov)','Papillary (rov)','Papillaire (ovd)'),
('mucinous (rov)','Mucinous (rov)','Mucineux (ovd)'),
('endometrioid/endometriotic/endometriosis (rov)','Endometrioid/Endometriotic/Endometriosis (rov)','Endométrioide/Endométriotique/Endométriosique (ovd)'),
('squamous (rov)','Squamous (rov)','Malpighien (ovd)'),
('Krukenberg (rov)','Krukenberg (rov)','Krukenberg (ovd)'),
('mullerian (rov)','Mullerian (rov)','Mullerien (ovd)'),
('granulosa (rov)','Granulosa (rov)','Granulosa (ovd)'),
('squamous/dermoid (rov)','Squamous/Dermoid (rov)','Épidermoide/Dermoide (ovd)'),
('mature teratoma (rov)','Mature Teratoma (rov)','Tératome Mature (ovd)'),
('immature teratoma (rov)','Immature Teratoma (rov)','Tératome Immature (ovd)'),
('brenner (rov)','Brenner (rov)','Brenner (ovd)'),
('neuroendocrine (rov)','Neuroendocrine (rov)','Neuroendocrine (ovd)'),
('sarcoma (rov)','Sarcoma (rov)','Sarcome (ovd)'),
('clear cell (rov)','Clear Cell (rov)','Clear Cell (ovd)'),
('small cell (rov)','Small Cell (rov)','Small Cell (ovd)'),
('sex cord (rov)','Sex Cord (rov)','Sex cord (rov)'),
('cells in cat rings (rov)','Cells in Cat Rings (ovd)','Cellules en bagues de chaton (ovd)'),
('struma ovarii (rov)','Struma Ovarii (rov)','Struma Ovarii (ovd)'),
('fibroma (rov)','Fibroma (rov)','Fibrome (ovd)'),
('atrophic (rov)','Atrophic (rov)','Atrophique (ovd)'),
('fibrothecoma (rov)','Fibrothecoma (rov)','Fibrothécale (ovd)'),
('polycystic (rov)','Polycystic (rov)','Polykystique (ovd)'),
('inclusion cyst (rov)','Inclusion Cyst (rov)','Kyste d''inclusion (ovd)'),

('nature (rov)','Nature (rov)','Nature (ovd)'),
('grade (rov)','Grade (rov)','Grade (ovd)'),

('left ovary','Left Ovary','Ovaire Gauche'),
('right ovary','Right Ovary','Ovaire Droit');

INSERT INTO structures(`alias`) VALUES ('chus_dx_undetailled_primary');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_undetailled_primary'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx nature' AND `language_label`='dx nature' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_nature') AND `flag_confidential`='0');

UPDATE diagnosis_controls SET form_alias = 'diagnosismasters,dx_primary,chus_dx_undetailled_primary' WHERE form_alias = 'diagnosismasters,dx_primary' AND detail_tablename = 'dxd_primaries';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_breasts', 'laterality', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='chus_laterality') , '0', '', '', 'dx_laterality', 'laterality', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='laterality' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_laterality')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='dx_laterality' AND `language_label`='laterality' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_breast') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename`='chus_dxd_breasts' AND `field`='laterality' AND `language_label`='laterality' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='laterality') AND `language_help`='dx_laterality' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_breast'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_nature' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_nature')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='help_dx nature' AND `language_label`='dx nature' AND `language_tag`=''), '1', '9', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '1');

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-88' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='tumour_grade' AND `language_label`='tumour grade' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_dx_nature' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_nature') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_tumour_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chus_custom_tumour_grade') AND `flag_confidential`='0');

INSERT INTO i18n (id,en,fr) VALUES ('insufficient accuracy of the dates','Insufficient accuracy of the dates!','Précision des dates insuffisantes!');

ALTER TABLE diagnosis_masters
	ADD COLUMN chus_uncertain_dx char(1) DEFAULT '',
	ADD COLUMN chus_uncertain_dx_description varchar(250) DEFAULT '';
ALTER TABLE diagnosis_masters_revs
	ADD COLUMN chus_uncertain_dx char(1) DEFAULT '',
	ADD COLUMN chus_uncertain_dx_description varchar(250) DEFAULT '';

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'chus_uncertain_dx', 'yes_no',  NULL , '0', '', '', '', 'uncertain dx', ''), 
('Clinicalannotation', 'DiagnosisMaster', 'diagnosis_masters', 'chus_uncertain_dx_description', 'input',  NULL , '0', 'size=30', '', '', '', 'uncertain dx description');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='chus_uncertain_dx'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='diagnosismasters'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `field`='chus_uncertain_dx_description'), '1', '12', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT INTO i18n (id,en,fr) VALUES ('uncertain dx','Uncertain Dx','Diag. incertain'),('uncertain dx description','Details','Détails');

ALTER TABLE chus_dxd_ovaries
	ADD COLUMN right_ovary_fallopian_tube_lesion char(1) DEFAULT '' AFTER right_ovary_atrophic;
ALTER TABLE chus_dxd_ovaries_revs
	ADD COLUMN right_ovary_fallopian_tube_lesion char(1) DEFAULT '' AFTER right_ovary_atrophic;
ALTER TABLE chus_dxd_ovaries
	ADD COLUMN left_ovary_fallopian_tube_lesion char(1) DEFAULT '' AFTER left_ovary_atrophic;
ALTER TABLE chus_dxd_ovaries_revs
	ADD COLUMN left_ovary_fallopian_tube_lesion char(1) DEFAULT '' AFTER left_ovary_atrophic;
	
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'right_ovary_fallopian_tube_lesion', 'yes_no',  NULL , '0', '', '', '', 'fallopian tube lession (rov)', ''),
('Clinicalannotation', 'DiagnosisDetail', 'chus_dxd_ovaries', 'left_ovary_fallopian_tube_lesion', 'yes_no',  NULL , '0', '', '', '', 'fallopian tube lession (lov)', '');
	
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='right_ovary_fallopian_tube_lesion'), '3', '220', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='chus_dx_ovary'), (SELECT id FROM structure_fields WHERE `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_fallopian_tube_lesion'), '1', '120', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'); 

INSERT INTO i18n (id,en,fr) VALUES ('fallopian tube lession (rov)', 'Fallopian Tube Lession (rov)', 'Lésion trompes de fallope (ovd)'),('fallopian tube lession (lov)', 'Fallopian Tube Lession (lov)', 'Lésion trompes de fallope (ovg)');

UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_dx_ovary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='chus_dxd_ovaries' AND `field`='left_ovary_fallopian_tube_lesion' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('cells in cat rings (lov)', '', 'Cells in Cat Rings (lov)', 'Cellules en bagues de chaton (ovg)'),
('sex cord (lov)', '', 'Sex Cord (lov)', 'Sex cord (ovg)');

REPLACE INTO `i18n` (`id`, `page_id`, `en`, `fr`) VALUES
('cells in cat rings (rov)', '', 'Cells in Cat Rings (rov)', 'Cellules en bagues de chaton (ovd)'),
('sex cord (rov)', '', 'Sex Cord (rov)', 'Sex cord (ovd)');

INSERT INTO `diagnosis_controls` 
(`category`, `controls_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`, `flag_compare_with_cap`) VALUES
('primary', 'ureter', 1, 'diagnosismasters,dx_primary', 'dxd_primaries', 0, 'primary|ureter', 1);

INSERT INTO `i18n` (`id`, `en`, `fr`) VALUES ('ureter','Ureter','Uretère');

INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_nature"),
(SELECT id FROM structure_permissible_values WHERE value="normal" AND language_alias="normal"), "0", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="chus_dx_nature"),
(SELECT id FROM structure_permissible_values WHERE value="metastatic" AND language_alias="metastatic"), "4", "1");

ALTER TABLE chus_ed_clinical_followups
	DROP COLUMN weight_in_lbs,
	DROP COLUMN height_in_feet;

ALTER TABLE chus_ed_clinical_followups_revs
	DROP COLUMN weight_in_lbs,
	DROP COLUMN height_in_feet;	
	
DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field IN ('weight_in_lbs','height_in_feet') AND tablename = 'chus_ed_clinical_followups');
DELETE FROM structure_fields WHERE field IN ('weight_in_lbs','height_in_feet') AND tablename = 'chus_ed_clinical_followups';

ALTER TABLE `reproductive_histories` ADD `chus_hrt_use_precision` VARCHAR( 250 ) DEFAULT NULL AFTER `hrt_use` ;
ALTER TABLE `reproductive_histories_revs` ADD `chus_hrt_use_precision` VARCHAR( 250 ) DEFAULT NULL AFTER `hrt_use` ;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ReproductiveHistory', 'reproductive_histories', 'chus_hrt_use_precision', 'input',  NULL , '0', 'size=25', '', '', 'precision', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='chus_hrt_use_precision' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=25' AND `default`='' AND `language_help`='' AND `language_label`='precision' AND `language_tag`=''), '2', '41', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_fields SET  `language_label`='',  `language_tag`='precision' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='chus_hrt_use_precision' AND `type`='input' AND structure_value_domain  IS NULL ;

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('chus_dx_ovary', 'chus_dx_breast')) 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field` IN ('clinical_tstage', 'clinical_nstage', 'clinical_mstage'));

ALTER TABLE `chus_dxd_ovaries` 
	DROP COLUMN `stage`;
ALTER TABLE `chus_dxd_ovaries_revs` 
	DROP COLUMN `stage`;
ALTER TABLE `chus_dxd_breasts` 
	DROP COLUMN `stage`;
ALTER TABLE `chus_dxd_breasts_revs` 
	DROP COLUMN `stage`;	

DELETE FROM structure_formats WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename` IN ('chus_dxd_ovaries','chus_dxd_breasts') AND `field`='stage');
DELETE FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='DiagnosisDetail' AND `tablename` IN ('chus_dxd_ovaries','chus_dxd_breasts') AND `field`='stage';

UPDATE structure_formats SET `language_heading` = 'staging', `flag_override_label` = '1', `language_label` = 'clinical stage', `flag_override_tag` = '1', `language_tag` = ''
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('chus_dx_ovary', 'chus_dx_breast')) 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND field = 'clinical_stage_summary');

UPDATE structure_fields SET type = 'select', setting = '', structure_value_domain = (SELECT id FROM structure_value_domains WHERE domain_name='chus_dx_stage')
WHERE `plugin`='Clinicalannotation' AND `model`='DiagnosisMaster' AND field = 'clinical_stage_summary';

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('chus_dx_ovary', 'chus_dx_breast'))  AND structure_field_id IN (SELECT id FROM structure_fields WHERE `plugin`='Clinicalannotation' AND `field`='path_stage_summary');

UPDATE structure_fields SET  `type`='float_positive' WHERE model='ReproductiveHistory' AND tablename='reproductive_histories' AND field='age_at_menarche';
ALTER TABLE reproductive_histories
 MODIFY age_at_menarche FLOAT UNSIGNED DEFAULT NULL;
ALTER TABLE reproductive_histories_revs
 MODIFY age_at_menarche FLOAT UNSIGNED DEFAULT NULL;

ALTER TABLE `reproductive_histories` ADD `chus_evista_use_precision` VARCHAR( 250 ) DEFAULT NULL AFTER `chus_evista_use` ;
ALTER TABLE `reproductive_histories_revs` ADD `chus_evista_use_precision` VARCHAR( 250 ) DEFAULT NULL AFTER `chus_evista_use` ;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'ReproductiveHistory', 'reproductive_histories', 'chus_evista_use_precision', 'input',  NULL , '0', 'size=25', '', '', '', 'precision');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='reproductivehistories'), (SELECT id FROM structure_fields WHERE `model`='ReproductiveHistory' AND `tablename`='reproductive_histories' AND `field`='chus_evista_use_precision' ), '2', '51', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

UPDATE structure_fields SET  `type`='float_positive' WHERE field='years_quit_smoking';
ALTER TABLE ed_all_lifestyle_smokings
 MODIFY years_quit_smoking FLOAT UNSIGNED DEFAULT NULL;
ALTER TABLE ed_all_lifestyle_smokings_revs
 MODIFY years_quit_smoking FLOAT UNSIGNED DEFAULT NULL;

UPDATE structure_fields SET  `type`='float_positive' WHERE field='chus_duration_in_years';
ALTER TABLE ed_all_lifestyle_smokings
 MODIFY chus_duration_in_years FLOAT UNSIGNED DEFAULT NULL;
ALTER TABLE ed_all_lifestyle_smokings_revs
 MODIFY chus_duration_in_years FLOAT UNSIGNED DEFAULT NULL;

ALTER TABLE family_histories
ADD COLUMN chus_notes text;
ALTER TABLE family_histories_revs
ADD COLUMN chus_notes text;

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'FamilyHistory', 'family_histories', 'chus_notes', 'textarea',  NULL , '0', '', '', '', 'notes', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='familyhistories'), (SELECT id FROM structure_fields WHERE `model`='FamilyHistory' AND `tablename`='family_histories' AND `field`='chus_notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='notes' AND `language_tag`=''), '1', '10', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
("great-grandfather", "great-grandfather"),
('great-grandmother','great-grandmother'),
('granddaughter','granddaughter'),
('grandson','grandson');
INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES((SELECT id FROM structure_value_domains WHERE domain_name="relation"),  (SELECT id FROM structure_permissible_values WHERE value="great-grandfather" AND language_alias="great-grandfather"), "15", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="relation"),  (SELECT id FROM structure_permissible_values WHERE value="great-grandmother" AND language_alias="great-grandmother"), "16", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="relation"),  (SELECT id FROM structure_permissible_values WHERE value="granddaughter" AND language_alias="granddaughter"), "17", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="relation"),  (SELECT id FROM structure_permissible_values WHERE value="grandson" AND language_alias="grandson"), "18", "1");

INSERT INTO i18n (id,en,fr) VALUES 
('great-grandfather', 'Great-Grandfather', 'Arrière grand-père'),
('great-grandmother', 'Great-Grandmother', 'Arrière grand-mère'),
('granddaughter', 'Granddaughter', 'Petite-fille'),
('grandson', 'Grandson', 'Petit-fils');
	
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES
('great-aunt','great-aunt'),
('great-uncle','great-uncle');
INSERT INTO structure_value_domains_permissible_values 
(`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) 
VALUES
((SELECT id FROM structure_value_domains WHERE domain_name="relation"),  (SELECT id FROM structure_permissible_values WHERE value="great-aunt" AND language_alias="great-aunt"), "20", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="relation"),  (SELECT id FROM structure_permissible_values WHERE value="great-uncle" AND language_alias="great-uncle"), "21", "1");
			
INSERT INTO i18n (id,en,fr) VALUES 
('great-aunt', 'Great-Aunt', ' Grande-tante'),
('great-uncle', 'Great-Uncle', ' Grand-oncle');		

UPDATE structure_formats SET `display_order`='1202', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='created' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='1201', `language_heading`='system data' WHERE structure_id=(SELECT id FROM structures WHERE alias='aliquot_masters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='AliquotMaster' AND `tablename`='aliquot_masters' AND `field`='barcode' AND type = 'input');

UPDATE aliquot_controls SET volume_unit = 'ug' WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_type IN ('rna','amplified rna','cdna','dna'));
INSERT IGNORE INTO structure_permissible_values (`value`, `language_alias`) VALUES("ug", "ug");
INSERT INTO structure_value_domains_permissible_values (`structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `flag_active`) VALUES((SELECT id FROM structure_value_domains WHERE domain_name="aliquot_volume_unit"),  (SELECT id FROM structure_permissible_values WHERE value="ug" AND language_alias="ug"), "1", "1");
INSERT INTO i18n (id,en,fr) VALUES ('ug','ug','ug');

REPLACE INTO i18n (id,en,fr) VALUES 
('aliquot used volume', 'Used Volume/Weight', 'Volume/Poids utilisé'),
('aliquots with volume', 'Aliquots with volume/weight', 'Aliquots avec volume/poids'),
('aliquots without volume', 'Aliquots without volume/weight', 'Aliquots sans volume/poids'),
('current volume', 'Current Volume/Weight', 'Volume/Poids courant'),
('initial volume', 'Initial Volume/Weight', 'Volume/Poids initial'),
('no volume has to be recorded for this aliquot type', 'No volume/weight has to be recorded for this aliquot type!', 'Aucun volume/poids doit être enregistré pour ce type d''aliquot!'),
('no volume has to be recorded when the volume unit field is empty', 'No volume/weight has to be recorded when the volume unit field is empty!', 'Aucun volume/poids ne doit être enregistré losque le champ ''unité'' est vide!'),
('parent used volume', 'Parent Used Volume/Weight', 'Volume/Poids utilisé du parent'),
('parent_used_volume_help', 'Volume/Weight of the parent aliquot used to create the children aliquot.', 'Volume/Poids de l''aliquot parent utilisé pour créer l''aliquot enfant.'),
('source aliquot used volume', 'Used Volume/Weight', 'Volume/Poids utilisé'),
('source_used_volume_help', 'Volume/Weight of the source aliquot to create the new derivative sample.', 'Volume/Poids de l''aliquot source utilisé pour créer l''échantillon dérivé.'),
('tested aliquot used volume', 'Used Volume/Weight', 'Volume/Poids utilisé'),
('tested_aliquot_volume_help', 'Volume/Weight of the aliquot used for the quality control.', 'Volume/Poids de l''aliquot utilisé pour le contrôle de qualité.'),
('the aliquot with barcode [%s] has reached a volume bellow 0', 'The aliquot with barcode [%s] has reached a volume/weight below 0.', 'L''aliquot avec le code à barres [%s] a atteint un volume/poids inférieur à 0.'),
('the inputed volume was automatically removed', 'The inputed volume/weight was automatically removed', 'La valeur du volume/poids entrée a été automatiquement retirée'),
('the used volume is higher than the remaining volume', 'The used volume/weight is higher than the remaining volume', 'Le volume/poids utilisé est supérieur au volume restant'),
('this aliquot has no recorded volume', 'This aliquot has no recorded volume/weight', 'Cet aliquot n''a aucun volume/poids enregistré'),
('used volume', 'Used Volume/Weight', 'Volume/Poids utilisé'),
('volume should be a positif decimal', 'Volume/Weight should be a positive decimal!', 'Le volume/poids doit être un décimal positif!'),
('volume unit', 'Volume/Weight Unit', 'Unité de volume/poids');

-- ADD Event  : Past History

INSERT INTO `event_controls` (`disease_site`, `event_group`, `event_type`, `flag_active`, `form_alias`, `detail_tablename`, `display_order`, `databrowser_label`) VALUES
('all', 'clinical', 'past history', 1, 'eventmasters,chus_ed_past_histories', 'chus_ed_past_histories', 0, 'clinical|all|past history');

CREATE TABLE IF NOT EXISTS `chus_ed_past_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  
  `type` varchar(250) DEFAULT NULL, 
  
  `event_master_id` int(11) DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `chus_ed_past_histories_revs` (
  `id` int(11) NOT NULL,
  
  `type` varchar(250) DEFAULT NULL,  
  
  `event_master_id` int(11) DEFAULT NULL,
  `version_id` int(11) NOT NULL AUTO_INCREMENT,
  `version_created` datetime NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `event_master_id` (`event_master_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `chus_ed_past_histories`
  ADD CONSTRAINT `chus_ed_past_histories_ibfk_1` FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`);

INSERT INTO structures(`alias`) VALUES ('chus_ed_past_histories');

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'custom_past_history_types', 'open', '', 'StructurePermissibleValuesCustom::getCustomDropdown(''past history types'')');
INSERT INTO structure_permissible_values_custom_controls (name,flag_active,values_max_length)
VALUES ('past history types', '1', '250');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('breast - benin','Breast - Benin','Sein - Bénin', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'past history types'), 1),
('breast - cancer','Breast - Cancer','Sein - Cancer', 2, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'past history types'), 1),
('ovary - benin','Ovary - Benin','Ovaire - Bénin', 3, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'past history types'), 1),
('ovary - cancer','Ovary - Cancer','Ovaire - Cancer', 4, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'past history types'), 1),
('uterus - benin','Uterus - Benin','Utérus - Bénin', 5, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'past history types'), 1),
('uterus - cancer','Uterus - Cancer','Utérus - Cancer', 6, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'past history types'), 1),
('other','Other','Autre', 7, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'past history types'), 1);

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('Clinicalannotation', 'EventDetail', 'chus_ed_past_histories', 'type', 'select',  (SELECT id FROM structure_value_domains WHERE domain_name = 'custom_past_history_types'), '0', '', '', '', 'type', '');

INSERT INTO structure_formats (`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_ed_past_histories'), (SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='chus_ed_past_histories' AND `field`='type'), '1', '98', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0'),
((SELECT id FROM structures WHERE alias='chus_ed_past_histories'), (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='cols=40,rows=6' AND `default`='' AND `language_help`='' AND `language_label`='summary' AND `language_tag`=''), '1', '99', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');

INSERT IGNORE INTO i18n (id,en,fr) VALUES 
('past history','Past History','Antécédant');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries'), (SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `type`='textarea' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='rows=3,cols=30' AND `default`='' AND `language_help`='help_notes' AND `language_label`='notes' AND `language_tag`=''), '1', '17', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
UPDATE structure_formats SET `display_order`='45' WHERE structure_id=(SELECT id FROM structures WHERE alias='chus_txd_breast_surgeries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_fields SET  `type`='float_positive' WHERE field='chus_quantity_per_day';
ALTER TABLE ed_all_lifestyle_smokings
 MODIFY chus_quantity_per_day FLOAT UNSIGNED DEFAULT NULL;
ALTER TABLE ed_all_lifestyle_smokings_revs
 MODIFY chus_quantity_per_day FLOAT UNSIGNED DEFAULT NULL;

