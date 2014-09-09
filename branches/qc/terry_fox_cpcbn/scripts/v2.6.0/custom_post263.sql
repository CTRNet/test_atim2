-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- System cleanup
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0') AND `type`='integer_positive';

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');

-- DROP TABLE txe_radiations; DROP TABLE txe_radiations_revs;

UPDATE treatment_controls SET applied_protocol_control_id = null, flag_use_for_ccl = 0 WHERE flag_active = 1;

UPDATE treatment_extend_controls SET type = 'chemotherpay drugs', databrowser_label = 'chemotherpay drugs' WHERE detail_form_alias = 'qc_tf_txe_chemo_drugs';
UPDATE treatment_extend_controls SET type = 'hormonotherpay drugs', databrowser_label = 'hormonotherpay drugs' WHERE detail_form_alias = 'qc_tf_txe_horm_drugs';
UPDATE treatment_extend_controls SET type = 'bone treatment drugs', databrowser_label = 'bone treatment drugs' WHERE detail_form_alias = 'qc_tf_txe_bone_drugs';
UPDATE treatment_extend_controls SET type = 'HR treatment drugs', databrowser_label = 'HR treatment drugs' WHERE detail_form_alias = 'qc_tf_txe_HR_drugs';
INSERT IGNORE INTO i18n (id,en) 
VALUES 
('chemotherpay drugs','Chemotherpay Drugs'),
('hormonotherpay drugs','Hormonotherpay Drugs'),
('bone treatment drugs','Bone Treatment Drugs'),
('HR treatment drugs','HR Treatment Drugs');

UPDATE structure_permissible_values_custom_controls SET name = 'Active Surveillances', category = 'clinical - treatment' WHERE name = 'active surveillances';
UPDATE structure_permissible_values_custom_controls SET name = 'Radiotherapy Types', category = 'clinical - diagnosis' WHERE name = 'radiotherapy types';

UPDATE event_controls SET use_addgrid = 1, use_detail_form_for_index = 1  WHERE flag_active = 1;
UPDATE structure_formats SET `flag_addgrid`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_ed_psa') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_tf_ed_psa' AND `field`='psa_ng_per_ml' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE parent_to_derivative_sample_controls SET flag_active=false WHERE id IN(188, 192);
UPDATE realiquoting_controls SET flag_active=false WHERE id IN(34, 46);

ALTER TABLE qc_tf_dxd_cpcbn MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE qc_tf_dxd_cpcbn ADD CONSTRAINT FK_qc_tf_dxd_cpcbn_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);
ALTER TABLE qc_tf_dxd_metastasis MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE qc_tf_dxd_metastasis ADD CONSTRAINT FK_qc_tf_dxd_metastasis_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);
ALTER TABLE qc_tf_dxd_others MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE qc_tf_dxd_recurrence_bio MODIFY diagnosis_master_id int(11) NOT NULL;
ALTER TABLE qc_tf_dxd_recurrence_bio ADD CONSTRAINT FK_qc_tf_dxd_recurrence_bio_diagnosis_masters FOREIGN KEY (diagnosis_master_id) REFERENCES diagnosis_masters (id);

ALTER TABLE qc_tf_txd_biopsies DROP COLUMN created;
ALTER TABLE qc_tf_txd_biopsies DROP COLUMN created_by;
ALTER TABLE qc_tf_txd_biopsies DROP COLUMN modified;
ALTER TABLE qc_tf_txd_biopsies DROP COLUMN modified_by;
ALTER TABLE qc_tf_txd_hormonotherapies DROP COLUMN created;
ALTER TABLE qc_tf_txd_hormonotherapies DROP COLUMN created_by;
ALTER TABLE qc_tf_txd_hormonotherapies DROP COLUMN modified;
ALTER TABLE qc_tf_txd_hormonotherapies DROP COLUMN modified_by;

DROP TABLE qc_tf_ed_cpcbn;
DROP TABLE qc_tf_ed_cpcbn_revs;
DELETE FROM event_controls WHERE detail_tablename = 'qc_tf_ed_biopsy';

ALTER TABLE qc_tf_dxd_others_revs MODIFY diagnosis_master_id int(11) NOT NULL;

UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 IN (SELECT id FROM datamart_structures WHERE model IN ('AliquotReviewMaster','SpecimenReviewMaster')) OR id2 IN (SELECT id FROM datamart_structures WHERE model IN ('AliquotReviewMaster','SpecimenReviewMaster'));
UPDATE datamart_structure_functions SET flag_active = 0 WHERE label IN ('define realiquoted children','realiquot','add to order','edit','initial specimens display','all derivatives display','list all children storages');

UPDATE menus SET flag_active = 0 WHERE use_link like '%/Order/Orders%';
UPDATE menus SET flag_active = 0 WHERE use_link like '%Tools/Template%';
UPDATE menus SET flag_active = 0 WHERE use_link like '%/Study/StudySummaries%';

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_addgrid`='0', `flag_editgrid`='0', `flag_batchedit`='0', `flag_batchedit_readonly`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE `field`='study_summary_id');

UPDATE datamart_reports SET flag_active = 0 WHERE name IN ('initial specimens display','all derivatives display','list all children storages','list all related diagnosis');
UPDATE datamart_reports SET associated_datamart_structure_id = (select id from datamart_structures where model = 'Participant') WHERE name like '%CPCBN Summary';

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Fields Update
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("1a", "1a");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ctnm"), (SELECT id FROM structure_permissible_values WHERE value="1a" AND language_alias="1a"), "5", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("1c", "1c");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ctnm"), (SELECT id FROM structure_permissible_values WHERE value="1c" AND language_alias="1c"), "6", "1");

-- ******* Check DFS start ******* 

SELECT count(*) AS "Test#1: Number of DFS tx being not 'hormonotherapy', 'surgery', 'radiation', 'chemotherapy' (should be equal to 0)" 
FROM treatment_masters tm INNER JOIN treatment_controls tc ON tc.id = tm.treatment_control_id
WHERE qc_tf_disease_free_survival_start_events = '1' AND tx_method NOT IN ('hormonotherapy', 'surgery', 'radiation', 'chemotherapy') AND flag_active = 1;

-- ******* FIELDS.... ******* 

INSERT INTO i18n (id,en) VALUES ("this treatment can not be defined as the 'disease free survival start event'", "This treatment can not be defined as the 'Disease free survival start event'");

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_tf_txd_biopsies', 'qc_tf_txd_others')) 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_tf_disease_free_survival_start_events' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

ALTER TABLE qc_tf_txd_biopsies
  ADD COLUMN gleason_score varchar(10) default '',
  ADD COLUMN total_positive int(6) default null,
  ADD COLUMN greatest_percent_of_cancer int(6) default null;
ALTER TABLE qc_tf_txd_biopsies_revs
  ADD COLUMN gleason_score varchar(10) default '',
  ADD COLUMN total_positive int(6) default null,
  ADD COLUMN greatest_percent_of_cancer int(6) default null;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies', 'total_positive', 'integer_positive',  NULL , '0', 'size=3', '', '', 'total positive', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies', 'greatest_percent_of_cancer', 'integer_positive',  NULL , '0', 'size=3', '', '', 'greatest percent of cancer', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='total_positive' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='total positive' AND `language_tag`=''), '2', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='greatest_percent_of_cancer' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='greatest percent of cancer' AND `language_tag`=''), '2', '23', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies', 'gleason_score', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') , '0', '', '', '', 'gleason score', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='gleason_score' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason score' AND `language_tag`=''), '2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en)
VALUES
('total number taken', 'Total Number Taken'),
('total positive', 'Total Positive'),
('greatest percent of cancer', 'Greatest Percent of Cancer'),
('gleason score','Gleason Score');  
UPDATE structure_fields SET  `language_label`='total number taken' WHERE model='TreatmentDetail' AND tablename='qc_tf_txd_biopsies' AND field='samples_number' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_column`='2', `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='samples_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='gleason_score' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');
ALTER TABLE qc_tf_txd_biopsies ADD COLUMN type varchar(50) default null;
ALTER TABLE qc_tf_txd_biopsies_revs ADD COLUMN type varchar(50) default null;
INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'qc_tf_biopsy_type', 'open', '', "StructurePermissibleValuesCustom::getCustomDropdown('Biopsy Types')");
INSERT INTO structure_permissible_values_custom_controls (name,category,flag_active,values_max_length)
VALUES ('Biopsy Types', 'clinical - treatment', '1', '50');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('Dx Bx','','', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'Biopsy Types'), 1),
('Bx prior to Tx','','', 2, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'Biopsy Types'), 1),
('TRUS','','', 7, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'Biopsy Types'), 1);
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('CHUM Bx','','', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'Biopsy Types'), 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_biopsy_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_biopsy_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_permissible_values_custom_controls SET name = 'Active Surveillances', category = 'clinical - diagnosis' WHERE name = 'Active Surveillances';
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('prior to Tx','Prior to Tx','', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'Active Surveillances'), 1);

UPDATE treatment_controls SET detail_form_alias = 'qc_tf_txd_surgeries,qc_tf_rps' WHERE tx_method = 'surgery' AND disease_site = 'RP';

ALTER TABLE txd_surgeries
  ADD COLUMN qc_tf_gleason_score varchar(10) default '',
  ADD COLUMN qc_tf_lymph_node_invasion char(1) default '',
  ADD COLUMN qc_tf_capsular_penetration char(1) default '',
  ADD COLUMN qc_tf_seminal_vesicle_invasion char(1) default '';
ALTER TABLE txd_surgeries_revs
  ADD COLUMN qc_tf_gleason_score varchar(10) default '',
  ADD COLUMN qc_tf_lymph_node_invasion char(1) default '',
  ADD COLUMN qc_tf_capsular_penetration char(1) default '',
  ADD COLUMN qc_tf_seminal_vesicle_invasion char(1) default '';
ALTER TABLE txd_surgeries
  ADD COLUMN qc_tf_margin varchar(1) default '';
ALTER TABLE txd_surgeries_revs
  ADD COLUMN qc_tf_margin varchar(1) default '';  
INSERT INTO structures(`alias`) VALUES ('qc_tf_rps');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txd_surgeries', 'qc_tf_gleason_score', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') , '0', '', '', '', 'gleason sum', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_surgeries', 'qc_tf_lymph_node_invasion', 'yes_no',  NULL , '0', '', '', '', 'lymph node invasion', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_surgeries', 'qc_tf_capsular_penetration', 'yes_no',  NULL , '0', '', '', '', 'capsular penetration', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_surgeries', 'qc_tf_seminal_vesicle_invasion', 'yes_no',  NULL , '0', '', '', '', 'seminal vesicle invasion', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'txd_surgeries', 'qc_tf_margin', 'yes_no',  NULL , '0', '', '', '', 'margin', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_rps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_gleason_score' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason sum' AND `language_tag`=''), '2', '21', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_rps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_lymph_node_invasion' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node invasion' AND `language_tag`=''), '2', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_rps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_capsular_penetration' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='capsular penetration' AND `language_tag`=''), '2', '23', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_rps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_seminal_vesicle_invasion' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='seminal vesicle invasion' AND `language_tag`=''), '2', '24', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_rps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_margin' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='margin' AND `language_tag`=''), '2', '25', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en) 
VALUES
('gleason sum','Gleason Sum'),
('lymph node invasion','Lymph Node Invasion'),
('capsular penetration','Capsular Penetration'),
('seminal vesicle invasion','Seminal Vesicle Invasion');

-- *******  Work on biopsy ******* 

SET @prostate_diagnosis_control_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'prostate');
SET @biopsy_treatment_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'biopsy' AND flag_active = 1);

-- list multi-bx

SELECT participant_id AS 'Test#2: Patient# with more than 1 Biopsy (should be 1 biopsy per patient) (Clean up after migration adding also gleason, Dx Bx, etc if required)' from (
	SELECT count(*) AS "Bx_nbr", participant_id
	FROM treatment_masters tm WHERE tm.treatment_control_id = @biopsy_treatment_control_id AND deleted <> 1
	GROUP BY participant_id) res 
WHERE res.Bx_nbr > 1;

-- Create missing BX based on DX method for any patient with no Bx and Dx method = TRUS or biopsy

SELECT p.id AS "Test#3: Patient# with no Biopsy but diagnosis method = {'Bx' or 'TRUS'}: Will create a biopsy with biopsy Date = Diagnosis Date", dd.tool
FROM participants p INNER JOIN diagnosis_masters dx ON dx.participant_id = p.id
INNER JOIN qc_tf_dxd_cpcbn dd ON dd.diagnosis_master_id = dx.id
WHERE p.deleted <> 1 AND p.id NOT IN (
	SELECT participant_id FROM treatment_masters tm WHERE tm.treatment_control_id = @biopsy_treatment_control_id AND deleted <> 1
) AND dx.deleted <> 1 AND dx.diagnosis_control_id = @prostate_diagnosis_control_id AND dd.tool IN ('biopsy', 'TRUS');
INSERT INTO treatment_masters (participant_id, diagnosis_master_id, treatment_control_id, start_date, start_date_accuracy, notes, modified, created, created_by, modified_by) 
(SELECT p.id, dx.id, @biopsy_treatment_control_id, dx.dx_date, dx.dx_date_accuracy, '-9999', dx.created, dx.created, dx.created_by, dx.created_by
FROM participants p INNER JOIN diagnosis_masters dx ON dx.participant_id = p.id
INNER JOIN qc_tf_dxd_cpcbn dd ON dd.diagnosis_master_id = dx.id
WHERE p.deleted <> 1 AND p.id NOT IN (
	SELECT participant_id FROM treatment_masters tm WHERE tm.treatment_control_id = @biopsy_treatment_control_id AND deleted <> 1
) AND dx.deleted <> 1 AND dx.diagnosis_control_id = @prostate_diagnosis_control_id AND dd.tool IN ('biopsy', 'TRUS'));
INSERT INTO treatment_masters_revs (treatment_control_id, start_date, diagnosis_master_id, participant_id, start_date_accuracy, modified_by, id, version_created) 
(SELECT treatment_control_id, start_date, diagnosis_master_id, participant_id, start_date_accuracy, modified_by, id, modified FROM treatment_masters WHERE notes = '-9999');
INSERT INTO qc_tf_txd_biopsies (treatment_master_id) (SELECT id FROM treatment_masters WHERE notes = '-9999');
INSERT INTO qc_tf_txd_biopsies_revs (treatment_master_id, version_created) (SELECT id, created FROM treatment_masters WHERE notes = '-9999'); 
UPDATE treatment_masters SET notes = '' WHERE notes = '-9999';

-- Flag biopsy as Dx Bx when Dx method = TRUS or biopsy and biopsy date = Dx date + copy gleason score

SELECT count(*) "Test#4.1: Existing biopsy flagged as 'Dx Bx' (should be equal to 0 before process)" FROM qc_tf_txd_biopsies WHERE type = 'Dx Bx';
SELECT "Flag biopsy as 'Dx Bx' plus copy the diagnosis gleason biopsy value for any biopsy having the same date than a diagnosis date of a diagnosis with a diagnosis method equals to {trus or biopsy}" AS process_message;
UPDATE treatment_masters tm, qc_tf_txd_biopsies td, diagnosis_masters dm, qc_tf_dxd_cpcbn dd
SET td.type = 'Dx Bx', td.gleason_score = dd.gleason_score_biopsy
WHERE tm.deleted <> 1 AND tm.treatment_control_id = @biopsy_treatment_control_id AND tm.id = td.treatment_master_id
AND dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dd.diagnosis_master_id = dm.id AND dd.tool IN ('biopsy', 'TRUS')
AND dm.participant_id = tm.participant_id AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
UPDATE treatment_masters tm, qc_tf_txd_biopsies_revs td, diagnosis_masters dm, qc_tf_dxd_cpcbn dd
SET td.type = 'Dx Bx', td.gleason_score = dd.gleason_score_biopsy
WHERE tm.deleted <> 1 AND tm.treatment_control_id = @biopsy_treatment_control_id AND tm.id = td.treatment_master_id
AND dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dd.diagnosis_master_id = dm.id AND dd.tool IN ('biopsy', 'TRUS')
AND dm.participant_id = tm.participant_id AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
SELECT participant_id AS "Test#4.2: Patient# with more than 1 Bx flagged as 'Dx Bx' at the end of the process (should be = 0)" from (
	SELECT count(*) AS "Bx_nbr", participant_id
	FROM treatment_masters tm INNER JOIN qc_tf_txd_biopsies td ON tm.id = td.treatment_master_id 
	WHERE tm.treatment_control_id = @biopsy_treatment_control_id AND deleted <> 1 AND td.type = 'Dx Bx'
	GROUP BY participant_id) res 
WHERE res.Bx_nbr > 1;

-- List all Dx with a gleason score at biopsy not null but not linked to a 'Bx Dx'

SELECT participant_id AS "Test#5.1: Patient# with a diagnosis with gleason score at biopsy but unlinked to a biopsy flagged as 'Dx Bx': To review and create Dx Bx if required"
FROM diagnosis_masters dm, qc_tf_dxd_cpcbn dd
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dd.diagnosis_master_id = dm.id AND (dd.gleason_score_biopsy IS NOT NULL AND dd.gleason_score_biopsy NOT LIKE '')
AND participant_id NOT IN (
	SELECT participant_id
	FROM treatment_masters tm INNER JOIN qc_tf_txd_biopsies td ON tm.id = td.treatment_master_id 
	WHERE tm.treatment_control_id = @biopsy_treatment_control_id AND deleted <> 1 AND td.type = 'Dx Bx'
);

-- List all Dx with a method = {TRUS or Biopsy} but not linked to a 'Bx Dx'

SELECT participant_id AS "Test#5.2: Patient# with a diagnosis with diagnosis method equals to {TRUS or biopsy} but unlinked to a biopsy flagged as 'Dx Bx': To review and create Dx Bx if required"
FROM diagnosis_masters dm, qc_tf_dxd_cpcbn dd
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dd.diagnosis_master_id = dm.id AND dd.tool IN ('biopsy', 'TRUS')
AND participant_id NOT IN (
	SELECT participant_id
	FROM treatment_masters tm INNER JOIN qc_tf_txd_biopsies td ON tm.id = td.treatment_master_id 
	WHERE tm.treatment_control_id = @biopsy_treatment_control_id AND deleted <> 1 AND td.type = 'Dx Bx'
);

-- *******  Work on DX Method != Biopsy and trus ******* 

SELECT participant_id AS "Test#6: Patient# with dx tool different than 'Bx or trus': to review", dd.tool
FROM diagnosis_masters dm INNER JOIN qc_tf_dxd_cpcbn dd ON dd.diagnosis_master_id = dm.id
WHERE dm.deleted <> 1 AND dd.tool NOT IN ('biopsy', 'TRUS', 'RP');

DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="qc_tf_dx_tool" AND spv.value="RP" AND spv.language_alias="RP";
SELECT participant_id AS "Test#7: Patient# with dx tool = 'PR': will be chnaged to unknown"
FROM diagnosis_masters dm INNER JOIN qc_tf_dxd_cpcbn dd ON dd.diagnosis_master_id = dm.id
WHERE dm.deleted <> 1 AND dd.tool IN ('RP');
UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn dd
SET dd.tool = 'unknown'
WHERE dd.diagnosis_master_id = dm.id AND dm.deleted <> 1 AND dd.tool IN ('RP');
UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn_revs dd
SET dd.tool = 'unknown'
WHERE dd.diagnosis_master_id = dm.id AND dm.deleted <> 1 AND dd.tool IN ('RP');

-- *******  Work on RP ******* 

SET @RP_treatment_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'surgery' AND disease_site = 'RP' AND flag_active = 1);

-- RP check

SELECT participant_id AS 'Test#8: Patient# with more than 1 RP to clean up (should be one)' from (
	SELECT count(*) AS "RP_nbr", participant_id FROM treatment_masters tm WHERE tm.treatment_control_id = @RP_treatment_control_id AND deleted <> 1 GROUP BY participant_id
) res WHERE res.RP_nbr > 1;
SELECT COUNT(*) As 'Nbr of patients with no RP'
FROM participants p INNER JOIN diagnosis_masters dx ON dx.participant_id = p.id
INNER JOIN qc_tf_dxd_cpcbn dd ON dd.diagnosis_master_id = dx.id
WHERE p.deleted <> 1 AND p.id NOT IN (
	SELECT participant_id FROM treatment_masters tm WHERE tm.treatment_control_id = @RP_treatment_control_id AND deleted <> 1
) AND dx.deleted <> 1 AND dx.diagnosis_control_id = @prostate_diagnosis_control_id;

-- Copy gleason score

SELECT participant_id AS "Test#9: Patient# with a gleason score at RP but unlinked to RP: To review"
FROM diagnosis_masters dm, qc_tf_dxd_cpcbn dd
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dd.diagnosis_master_id = dm.id AND (dd.gleason_score_rp IS NOT NULL AND dd.gleason_score_rp NOT LIKE '')
AND participant_id NOT IN (
	SELECT participant_id FROM treatment_masters tm WHERE tm.treatment_control_id = @RP_treatment_control_id AND deleted <> 1
);
SELECT "Copy the diagnosis gleason RP value to RP" AS process_message;
UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, txd_surgeries td
SET td.qc_tf_gleason_score = dd.gleason_score_rp
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.id = dd.diagnosis_master_id
AND tm.deleted <> 1 AND tm.treatment_control_id = @RP_treatment_control_id AND tm.id = td.treatment_master_id
AND tm.participant_id = dm.participant_id;
UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, txd_surgeries_revs td
SET td.qc_tf_gleason_score = dd.gleason_score_rp
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.id = dd.diagnosis_master_id
AND tm.deleted <> 1 AND tm.treatment_control_id = @RP_treatment_control_id AND tm.id = td.treatment_master_id
AND tm.participant_id = dm.participant_id;

-- ADD new fields

UPDATE structure_fields SET `language_label`='gleason score rp' WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_score_rp';
UPDATE structure_fields SET `language_label`='gleason score' WHERE model='TreatmentDetail' AND tablename='txd_surgeries' AND field='qc_tf_gleason_score' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values');
INSERT IGNORE INTO i18n (id,en) VALUES ('gleason score rp', 'Gleason Score RP'), ('gleason score', 'Gleason Score');

ALTER TABLE txd_surgeries ADD COLUMN qc_tf_gleason_grade VARCHAR(10) DEFAULT NULL;
ALTER TABLE txd_surgeries_revs ADD COLUMN qc_tf_gleason_grade VARCHAR(10) DEFAULT NULL;
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_tf_gleason_grades", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES
("3+3", "3+3"),
("3+4", "3+4"),
("4+3", "4+3"),
("4+4", "4+4"),
("4+5", "4+5"),
("5+4", "5+4"),
("5+5", "5+5");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="3+3" AND language_alias="3+3"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="3+4" AND language_alias="3+4"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="4+3" AND language_alias="4+3"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="4+4" AND language_alias="4+4"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="4+5" AND language_alias="4+5"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="5+4" AND language_alias="5+4"), "", "1"),
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_gleason_grades"), (SELECT id FROM structure_permissible_values WHERE value="5+5" AND language_alias="5+5"), "", "1");
INSERT INTO i18n (id,en)
VALUES
("3+3", "3+3"),
("3+4", "3+4"),
("4+3", "4+3"),
("4+4", "4+4"),
("4+5", "4+5"),
("5+4", "5+4"),
("5+5", "5+5");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'txd_surgeries', 'qc_tf_gleason_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades') , '0', '', '', '', 'gleason grade', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_rps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_gleason_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason grade' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en)
VALUES
("gleason grade", "Gleason Grade");

-- Move Dx Spread fields To RP

SELECT p.id AS "Test#10: Patient# with no RP but Dx spread fields not empty (should be empty)"
FROM participants p INNER JOIN diagnosis_masters dx ON dx.participant_id = p.id
INNER JOIN qc_tf_dxd_cpcbn dd ON dd.diagnosis_master_id = dx.id
WHERE p.deleted <> 1 AND p.id NOT IN (
	SELECT participant_id FROM treatment_masters tm WHERE tm.treatment_control_id = @RP_treatment_control_id AND deleted <> 1
) AND dx.deleted <> 1 AND dx.diagnosis_control_id = @prostate_diagnosis_control_id
AND (dd.presence_of_lymph_node_invasion NOT LIKE '' AND dd.presence_of_lymph_node_invasion IS NOT NULL)
AND (dd.presence_of_capsular_penetration NOT LIKE '' AND dd.presence_of_capsular_penetration IS NOT NULL)
AND (dd.presence_of_seminal_vesicle_invasion NOT LIKE '' AND dd.presence_of_seminal_vesicle_invasion IS NOT NULL)
AND (dd.margin  NOT LIKE '' AND dd.margin  IS NOT NULL);

SELECT "Move Dx Spread fields To RP" AS process_message;
UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, txd_surgeries td
SET td.qc_tf_lymph_node_invasion = dd.presence_of_lymph_node_invasion,
td.qc_tf_capsular_penetration = dd.presence_of_capsular_penetration,
td.qc_tf_seminal_vesicle_invasion = dd.presence_of_seminal_vesicle_invasion,
td.qc_tf_margin = dd.margin
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.id = dd.diagnosis_master_id
AND tm.deleted <> 1 AND tm.treatment_control_id = @RP_treatment_control_id AND tm.id = td.treatment_master_id
AND tm.participant_id = dm.participant_id;
UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, txd_surgeries_revs td
SET td.qc_tf_lymph_node_invasion = dd.presence_of_lymph_node_invasion,
td.qc_tf_capsular_penetration = dd.presence_of_capsular_penetration,
td.qc_tf_seminal_vesicle_invasion = dd.presence_of_seminal_vesicle_invasion,
td.qc_tf_margin = dd.margin
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.id = dd.diagnosis_master_id
AND tm.deleted <> 1 AND tm.treatment_control_id = @RP_treatment_control_id AND tm.id = td.treatment_master_id
AND tm.participant_id = dm.participant_id;

ALTER TABLE qc_tf_dxd_cpcbn DROP COLUMN presence_of_lymph_node_invasion, DROP COLUMN presence_of_capsular_penetration, DROP COLUMN presence_of_seminal_vesicle_invasion, DROP COLUMN margin;
ALTER TABLE qc_tf_dxd_cpcbn_revs DROP COLUMN presence_of_lymph_node_invasion, DROP COLUMN presence_of_capsular_penetration, DROP COLUMN presence_of_seminal_vesicle_invasion, DROP COLUMN margin;
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_lymph_node_invasion' AND `language_label`='presence lymph node invasion' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_capsular_penetration' AND `language_label`='presence capsular penetration' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_seminal_vesicle_invasion' AND `language_label`='presence seminal invasion' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='margin' AND `language_label`='margin' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='ptnm' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ptnm') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='ctnm' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ctnm') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_score_biopsy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='2' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_score_rp' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='survival_in_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='bcr_in_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='staging' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='ptnm' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_ptnm') AND `flag_confidential`='0');
UPDATE structure_formats SET `language_heading`='score' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_score_biopsy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');

-- ******* FIELDS.... *******

ALTER TABLE qc_tf_txd_biopsies ADD COLUMN gleason_grade VARCHAR(10) DEFAULT NULL;
ALTER TABLE qc_tf_txd_biopsies_revs ADD COLUMN gleason_grade VARCHAR(10) DEFAULT NULL;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies', 'gleason_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades') , '0', '', '', '', 'gleason grade', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='gleason_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason grade' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');

UPDATE structure_formats SET `display_column`='1', `display_order`='80' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='gleason_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='81' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='gleason_score' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='80' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_rps') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_gleason_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='81' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_rps') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_gleason_score' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_lymph_node_invasion' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node invasion' AND `language_tag`=''), '0', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_capsular_penetration' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='capsular penetration' AND `language_tag`=''), '0', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_seminal_vesicle_invasion' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='seminal vesicle invasion' AND `language_tag`=''), '0', '27', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_margin' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='margin' AND `language_tag`=''), '0', '28', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_full_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_lymph_node_invasion' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='lymph node invasion' AND `language_tag`=''), '0', '25', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_full_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_capsular_penetration' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='capsular penetration' AND `language_tag`=''), '0', '26', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_full_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_seminal_vesicle_invasion' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='seminal vesicle invasion' AND `language_tag`=''), '0', '27', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_full_cpcbn_summary_results'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_margin' AND `type`='yes_no' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='margin' AND `language_tag`=''), '0', '28', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_lymph_node_invasion' AND `language_label`='presence lymph node invasion' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_capsular_penetration' AND `language_label`='presence capsular penetration' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_seminal_vesicle_invasion' AND `language_label`='presence seminal invasion' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_cpcbn_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='margin' AND `language_label`='margin' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_full_cpcbn_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_lymph_node_invasion' AND `language_label`='presence lymph node invasion' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_full_cpcbn_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_capsular_penetration' AND `language_label`='presence capsular penetration' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_full_cpcbn_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_seminal_vesicle_invasion' AND `language_label`='presence seminal invasion' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_full_cpcbn_summary_results') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='margin' AND `language_label`='margin' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_validations WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_lymph_node_invasion' AND `language_label`='presence lymph node invasion' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_capsular_penetration' AND `language_label`='presence capsular penetration' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_seminal_vesicle_invasion' AND `language_label`='presence seminal invasion' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='margin' AND `language_label`='margin' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0'));
DELETE FROM structure_fields WHERE (`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_lymph_node_invasion' AND `language_label`='presence lymph node invasion' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_capsular_penetration' AND `language_label`='presence capsular penetration' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='presence_of_seminal_vesicle_invasion' AND `language_label`='presence seminal invasion' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0') OR (
`public_identifier`='' AND `plugin`='ClinicalAnnotation' AND `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='margin' AND `language_label`='margin' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

INSERT INTO i18n (id,en) VALUES ('a RP can not be created twice for the same participant','A RP can not be created twice for the same participant');
INSERT INTO i18n (id,en) VALUES ("a biopsy has already been defined as the 'Dx Bx' for this cancer","A biopsy has already been defined as the 'Dx Bx' for this cancer");
INSERT INTO i18n (id,en) 
VALUES 
('surgery and diagnosis gleason score discordance','A discordance exists between surgery and diagnosis gleason scores'),
('biopsy and diagnosis gleason score discordance','A discordance exists between biopsy and diagnosis gleason scores');
INSERT INTO i18n (id,en) 
VALUES 
('date of the biopsy at diagnosis and diagnosis date discordance','Date of the biopsy at diagnosis and diagnosis date discordance'),
('the biopsy used for the diagnosis is missing into the system','The biopsy used for the diagnosis is missing into the system'),
("the 'Gleason Score Biopsy' of the diagnosis is set but no biopsy at diagnosis is set into the system","The 'Gleason Score Biopsy' of the diagnosis is set but no biopsy at diagnosis is set into the system"),
('a biopsy is defined as diagnosis method but the method of the diagnosis is set to something else','A biopsy is defined as diagnosis method but the method of the diagnosis is set to something else');
UPDATE versions SET branch_build_number = '58??' WHERE version_number = '2.6.3';
