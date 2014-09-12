-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- General Cleanup
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

-- Add ctnm value

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("1a", "1a");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ctnm"), (SELECT id FROM structure_permissible_values WHERE value="1a" AND language_alias="1a"), "5", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("1c", "1c");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_ctnm"), (SELECT id FROM structure_permissible_values WHERE value="1c" AND language_alias="1c"), "6", "1");

-- Changed Biopsy to Biopsy & Turp 

SELECT 'Info#1: Merged TURP and Biopsy together' AS 'Script Action Detail';

RENAME TABLE qc_tf_txd_biopsies TO qc_tf_txd_biopsies_and_turps;
RENAME TABLE qc_tf_txd_biopsies_revs TO qc_tf_txd_biopsies_and_turps_revs;
UPDATE structures SET alias = 'qc_tf_txd_biopsies_and_turps' WHERE alias = 'qc_tf_txd_biopsies';
UPDATE structure_fields SET tablename = 'qc_tf_txd_biopsies_and_turps' WHERE tablename = 'qc_tf_txd_biopsies';
UPDATE treatment_controls SET tx_method = 'biopsy and turp', detail_tablename = 'qc_tf_txd_biopsies_and_turps', detail_form_alias = 'qc_tf_txd_biopsies_and_turps', databrowser_label = 'biopsy and turp' WHERE detail_tablename = 'qc_tf_txd_biopsies';

SET @biopsy_and_turp_treatment_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'biopsy and turp' AND flag_active = 1);

SET @turp_treatment_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'surgery' AND disease_site = 'TURP' AND flag_active = 1);
SELECT participant_id AS 'Participant# linked to a TURP (to review in new version)', id AS 'TURP treatment_master_id' FROM treatment_masters WHERE treatment_control_id = @turp_treatment_control_id;
INSERT INTO qc_tf_txd_biopsies_and_turps (treatment_master_id, samples_number) (SELECT treatment_master_id, '9999' FROM treatment_masters tm INNER JOIN txd_surgeries td ON td.treatment_master_id = tm.id WHERE treatment_control_id = @turp_treatment_control_id);
INSERT INTO qc_tf_txd_biopsies_and_turps_revs (treatment_master_id, samples_number, version_created) (SELECT treatment_master_id, '9999' , version_created FROM treatment_masters tm INNER JOIN txd_surgeries_revs td ON td.treatment_master_id = tm.id WHERE treatment_control_id = @turp_treatment_control_id ORDER BY version_id ASC);
DELETE FROM txd_surgeries WHERE treatment_master_id IN (SELECT id FROM treatment_masters WHERE treatment_control_id = @turp_treatment_control_id);
DELETE FROM txd_surgeries_revs WHERE treatment_master_id IN (SELECT id FROM treatment_masters WHERE treatment_control_id = @turp_treatment_control_id);
UPDATE treatment_masters SET treatment_control_id = @biopsy_and_turp_treatment_control_id WHERE treatment_control_id = @turp_treatment_control_id;
UPDATE treatment_masters_revs SET treatment_control_id = @biopsy_and_turp_treatment_control_id WHERE treatment_control_id = @turp_treatment_control_id;
DELETE FROM treatment_controls WHERE id = @turp_treatment_control_id;

-- Removed DFS start from TURP and Biopsy and other treatment

SELECT count(*) AS "Info#2: Number of DFS tx being not 'hormonotherapy', 'surgery', 'radiation', 'chemotherapy' (should be equal to 0)" 
FROM treatment_masters tm INNER JOIN treatment_controls tc ON tc.id = tm.treatment_control_id
WHERE qc_tf_disease_free_survival_start_events = '1' AND tx_method NOT IN ('hormonotherapy', 'surgery', 'radiation', 'chemotherapy') AND flag_active = 1;
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0', `flag_summary`='0' 
WHERE structure_id IN (SELECT id FROM structures WHERE alias IN ('qc_tf_txd_biopsies_and_turps', 'qc_tf_txd_others')) 
AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentMaster' AND `tablename`='treatment_masters' AND `field`='qc_tf_disease_free_survival_start_events' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ("this treatment can not be defined as the 'disease free survival start event'", "This treatment can not be defined as the 'Disease free survival start event'");

-- Biopsy And TURP new fields

ALTER TABLE qc_tf_txd_biopsies_and_turps
  ADD COLUMN gleason_score varchar(10) default '',
  ADD COLUMN total_positive int(6) default null,
  ADD COLUMN greatest_percent_of_cancer int(6) default null;
ALTER TABLE qc_tf_txd_biopsies_and_turps_revs
  ADD COLUMN gleason_score varchar(10) default '',
  ADD COLUMN total_positive int(6) default null,
  ADD COLUMN greatest_percent_of_cancer int(6) default null;
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies_and_turps', 'total_positive', 'integer_positive',  NULL , '0', 'size=3', '', '', 'total positive', ''), 
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies_and_turps', 'greatest_percent_of_cancer', 'integer_positive',  NULL , '0', 'size=3', '', '', 'greatest percent of cancer', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies_and_turps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies_and_turps' AND `field`='total_positive' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='total positive' AND `language_tag`=''), '2', '22', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies_and_turps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies_and_turps' AND `field`='greatest_percent_of_cancer' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=3' AND `default`='' AND `language_help`='' AND `language_label`='greatest percent of cancer' AND `language_tag`=''), '2', '23', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies_and_turps', 'gleason_score', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') , '0', '', '', '', 'gleason score', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies_and_turps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies_and_turps' AND `field`='gleason_score' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason score' AND `language_tag`=''), '2', '22', '', '0', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
INSERT INTO i18n (id,en)
VALUES
('total number taken', 'Total Number Taken'),
('total positive', 'Total Positive'),
('greatest percent of cancer', 'Greatest Percent of Cancer'),
('gleason score','Gleason Score');  
UPDATE structure_fields SET  `language_label`='total number taken' WHERE model='TreatmentDetail' AND tablename='qc_tf_txd_biopsies_and_turps' AND field='samples_number' AND `type`='integer_positive' AND structure_value_domain  IS NULL ;
UPDATE structure_formats SET `display_column`='2', `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies_and_turps') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies_and_turps' AND `field`='samples_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='21' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies_and_turps') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies_and_turps' AND `field`='gleason_score' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');
INSERT INTO i18n (id,en) VALUES ('biopsy and turp', 'Biopsy / TURP');

ALTER TABLE qc_tf_txd_biopsies_and_turps ADD COLUMN gleason_grade VARCHAR(10) DEFAULT NULL;
ALTER TABLE qc_tf_txd_biopsies_and_turps_revs ADD COLUMN gleason_grade VARCHAR(10) DEFAULT NULL;
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
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies_and_turps', 'gleason_grade', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades') , '0', '', '', '', 'gleason grade', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies_and_turps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies_and_turps' AND `field`='gleason_grade' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='gleason grade' AND `language_tag`=''), '2', '20', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_column`='1', `display_order`='80' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies_and_turps') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies_and_turps' AND `field`='gleason_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='81' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies_and_turps') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies_and_turps' AND `field`='gleason_score' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');
INSERT INTO i18n (id,en)
VALUES
("gleason grade", "Gleason Grade");

ALTER TABLE qc_tf_txd_biopsies_and_turps ADD COLUMN type varchar(50) default null;
ALTER TABLE qc_tf_txd_biopsies_and_turps_revs ADD COLUMN type varchar(50) default null;
INSERT INTO structure_value_domains (domain_name, override, category, source) VALUES ("qc_tf_biopsy_type", "", "", NULL);
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Bx", "Bx");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_type"), (SELECT id FROM structure_permissible_values WHERE value="Bx" AND language_alias="Bx"), "1", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Bx Dx", "Bx Dx");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_type"), (SELECT id FROM structure_permissible_values WHERE value="Bx Dx" AND language_alias="Bx Dx"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Bx CHUM", "Bx CHUM");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_type"), (SELECT id FROM structure_permissible_values WHERE value="Bx CHUM" AND language_alias="Bx CHUM"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Bx prior to Tx", "Bx prior to Tx");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_type"), (SELECT id FROM structure_permissible_values WHERE value="Bx prior to Tx" AND language_alias="Bx prior to Tx"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Bx TRUS-Guided", "Bx TRUS-Guided");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_type"), (SELECT id FROM structure_permissible_values WHERE value="Bx TRUS-Guided" AND language_alias="Bx TRUS-Guided"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("Bx Dx TRUS-Guided", "Bx Dx TRUS-Guided");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_type"), (SELECT id FROM structure_permissible_values WHERE value="Bx Dx TRUS-Guided" AND language_alias="Bx Dx TRUS-Guided"), "2", "1");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_type"), (SELECT id FROM structure_permissible_values WHERE value="TURP" AND language_alias="TURP"), "2", "1");
INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("TURP Dx", "TURP Dx");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_biopsy_type"), (SELECT id FROM structure_permissible_values WHERE value="TURP Dx" AND language_alias="TURP Dx"), "2", "1");
INSERT IGNORE INTO i18n (id,en) VALUES ("Bx", "Bx"),("Bx Dx", "Bx Dx"),("Bx CHUM", "Bx CHUM"),("Bx prior to Tx", "Bx prior to Tx"),("Bx TRUS-Guided", "Bx TRUS-Guided"),("Bx Dx TRUS-Guided","Bx Dx TRUS-Guided"),("TURP", "TURP"),("TURP Dx", "TURP Dx");
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'TreatmentDetail', 'qc_tf_txd_biopsies_and_turps', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_biopsy_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies_and_turps'), (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies_and_turps' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_biopsy_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
SELECT "Info#3: Set 'Biopsy & TURP' type to 'TURP' for any record created from 'Treatment - TURP' existing into the previous version" AS 'Script Action Detail';
UPDATE qc_tf_txd_biopsies_and_turps td SET type = 'TURP', samples_number = null WHERE samples_number = '9999';
UPDATE qc_tf_txd_biopsies_and_turps_revs td SET type = 'TURP', samples_number = null WHERE samples_number = '9999';
SELECT "Info#4: Set 'Biopsy & TURP' type to 'Bx' for any record defined as biopsy into the previous version" AS 'Script Action Detail';
UPDATE qc_tf_txd_biopsies_and_turps td SET type = 'Bx' WHERE type IS NULL;
UPDATE qc_tf_txd_biopsies_and_turps_revs td SET type = 'Bx' WHERE type IS NULL;
UPDATE structure_value_domains SET  domain_name='qc_tf_biopsy_turp_type' WHERE domain_name='qc_tf_biopsy_type';

UPDATE structure_fields SET field = 'total_number_taken' WHERE field = 'samples_number' AND tablename = 'qc_tf_txd_biopsies_and_turps';
ALTER TABLE qc_tf_txd_biopsies_and_turps CHANGE samples_number total_number_taken int(4);  
ALTER TABLE qc_tf_txd_biopsies_and_turps_revs CHANGE samples_number total_number_taken int(4);  

-- RP new fields

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
UPDATE structure_formats SET `display_column`='1', `display_order`='80' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_rps') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_gleason_grade' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_grades') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_column`='1', `display_order`='81' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_rps') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='txd_surgeries' AND `field`='qc_tf_gleason_score' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');

-- Diagnosis fields

UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_index`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='6' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

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

UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_score_biopsy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit_readonly`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_score_rp' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');

INSERT IGNORE INTO structure_permissible_values (value, language_alias) VALUES("TRUS-guided biopsy", "TRUS-guided biopsy");
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) 
VALUES 
((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_dx_tool"), (SELECT id FROM structure_permissible_values WHERE value="TRUS-guided biopsy" AND language_alias="TRUS-guided biopsy"), "0", "1");
INSERT INTO i18n (id,en) VALUES ("TRUS-guided biopsy", "TRUS-Guided Biopsy");

DELETE svdpv FROM structure_value_domains_permissible_values AS svdpv INNER JOIN structure_permissible_values AS spv ON svdpv.structure_permissible_value_id=spv.id INNER JOIN structure_value_domains AS svd ON svd.id = svdpv .structure_value_domain_id WHERE svd.domain_name="qc_tf_dx_tool" AND spv.value="TRUS" AND spv.language_alias="TRUS";
DELETE FROM structure_permissible_values WHERE value="TRUS" AND language_alias="TRUS" AND id NOT IN (SELECT DISTINCT structure_permissible_value_id FROM structure_value_domains_permissible_values);
INSERT INTO structure_value_domains_permissible_values (structure_value_domain_id, structure_permissible_value_id, display_order, flag_active) VALUES ((SELECT id FROM structure_value_domains WHERE domain_name="qc_tf_dx_tool"), (SELECT id FROM structure_permissible_values WHERE value="TURP" AND language_alias="TURP"), "2", "1");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="1" WHERE svd.domain_name='qc_tf_dx_tool' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="biopsy" AND language_alias="biopsy");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="5" WHERE svd.domain_name='qc_tf_dx_tool' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="RP" AND language_alias="RP");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="4" WHERE svd.domain_name='qc_tf_dx_tool' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="PSA+DRE" AND language_alias="PSA+DRE");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="6" WHERE svd.domain_name='qc_tf_dx_tool' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="unknown" AND language_alias="unknown");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="2" WHERE svd.domain_name='qc_tf_dx_tool' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="TRUS-guided biopsy" AND language_alias="TRUS-guided biopsy");
UPDATE structure_value_domains AS svd INNER JOIN structure_value_domains_permissible_values AS svdpv ON svdpv.structure_value_domain_id=svd.id INNER JOIN structure_permissible_values AS spv ON spv.id=svdpv.structure_permissible_value_id SET `display_order`="3" WHERE svd.domain_name='qc_tf_dx_tool' AND spv.id=(SELECT id FROM structure_permissible_values WHERE value="TURP" AND language_alias="TURP");

ALTER TABLE qc_tf_dxd_cpcbn CHANGE gleason_score_biopsy gleason_score_biopsy_turp varchar(10) NOT NULL DEFAULT '';
ALTER TABLE qc_tf_dxd_cpcbn_revs CHANGE gleason_score_biopsy gleason_score_biopsy_turp varchar(10) NOT NULL DEFAULT '';
UPDATE structure_fields SET field = 'gleason_score_biopsy_turp', language_label = 'gleason score biopsy and turp' WHERE tablename = 'qc_tf_dxd_cpcbn' AND field = 'gleason_score_biopsy';
INSERT INTO i18n (id,en) VALUES ('gleason score biopsy and turp', 'Gleason Score Biopsy / TURP');

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Data Clean Up
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SET @prostate_diagnosis_control_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'prostate');
SET @biopsy_and_turp_treatment_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'biopsy and turp' AND flag_active = 1);

-- list multi-bx

SELECT participant_id AS 'Info#5: Patient# with more than 1 biopsy in the previous version (To check and clean-up after migration id required)' from (
	SELECT count(*) AS "Bx_nbr", participant_id	FROM treatment_masters tm WHERE tm.treatment_control_id = @biopsy_and_turp_treatment_control_id AND deleted <> 1 GROUP BY participant_id) res 
WHERE res.Bx_nbr > 1;

-- Dx Method TRUS changed to TURP

SELECT participant_id AS "Info#6: Patient# with Dx Method = 'TRUS' changed to 'TURP' based on Veronique O. request (to check and clean-up after migration id required)" 
FROM qc_tf_dxd_cpcbn dd, diagnosis_masters dm WHERE tool = 'TRUS' AND deleted <> 1 AND dm .id = dd.diagnosis_master_id;
UPDATE qc_tf_dxd_cpcbn dd, diagnosis_masters dm SET dd.tool = 'TURP' WHERE dd.tool = 'TRUS' AND deleted <> 1 AND dm .id = dd.diagnosis_master_id;
UPDATE qc_tf_dxd_cpcbn_revs dd, diagnosis_masters dm SET dd.tool = 'TURP' WHERE dd.tool = 'TRUS' AND deleted <> 1 AND dm .id = dd.diagnosis_master_id;

-- Change type of 'Biopsy & TURP' record from 'TURP' to 'TURP Dx' + copy the gleanson score

SELECT dm.participant_id AS "Info#7: Patient# with Dx Method = 'TURP' matching a 'Biopsy and TURP' record with type 'TURP' based on date (Will change type of 'Biopsy and TURP' from 'TURP' to type 'TURP Dx' and copy the Dx gleason)", dm.dx_date AS 'Diagnosis Date'
FROM qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'TURP'
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'TURP'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
UPDATE qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'TURP Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'TURP'
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'TURP'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
UPDATE qc_tf_txd_biopsies_and_turps_revs td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'TURP Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'TURP'
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'TURP'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;

-- Create missing 'Biopsy & TURP' with type 'TURP Dx'

SELECT dm.participant_id AS "Info#8: Patient# with Dx Method = 'TURP' matching no 'Biopsy and TURP' record with type 'TURP' based on date (Will create a new 'Biopsy and TURP' record with type 'TURP DX' and will copy the Dx gleason and the date)", dm.dx_date AS 'Diagnosis Date'
FROM qc_tf_dxd_cpcbn dd, diagnosis_masters dm
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'TURP'
AND dm.id NOT IN (
	SELECT dm.id 
	FROM qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
	WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'TURP'
	AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'TURP Dx'
	AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy
);
INSERT INTO treatment_masters (participant_id, diagnosis_master_id, treatment_control_id, start_date, start_date_accuracy, notes, modified, created, created_by, modified_by) 
(SELECT dm.participant_id, dm.id, @biopsy_and_turp_treatment_control_id, dm.dx_date, dm.dx_date_accuracy, '-9999', dm.created, dm.created, dm.created_by, dm.created_by
FROM qc_tf_dxd_cpcbn dd, diagnosis_masters dm
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'TURP'
AND dm.id NOT IN (
	SELECT dm.id 
	FROM qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
	WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'TURP'
	AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'TURP Dx'
	AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy
));
INSERT INTO treatment_masters_revs (participant_id, diagnosis_master_id, treatment_control_id, start_date, start_date_accuracy, notes, modified_by, id, version_created) 
(SELECT participant_id, diagnosis_master_id, treatment_control_id, start_date, start_date_accuracy, notes, modified_by, id, modified FROM treatment_masters WHERE notes = '-9999');
INSERT INTO qc_tf_txd_biopsies_and_turps (treatment_master_id) (SELECT id FROM treatment_masters WHERE notes = '-9999');
INSERT INTO qc_tf_txd_biopsies_and_turps_revs (treatment_master_id, version_created) (SELECT id, created FROM treatment_masters WHERE notes = '-9999'); 
UPDATE qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'TURP Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'TURP'
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND tm.notes = '-9999'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
UPDATE qc_tf_txd_biopsies_and_turps_revs td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'TURP Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'TURP'
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND tm.notes = '-9999'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
UPDATE treatment_masters SET notes = '' WHERE notes = '-9999';
UPDATE treatment_masters_revs SET notes = '' WHERE notes = '-9999';

-- Change type of 'Biopsy & TURP' record from 'Bx' to 'Bx Dx' + copy the gleanson score

SELECT dm.participant_id AS "Info#9: Patient# with Dx Method = 'biopsy' matching a 'Biopsy and TURP' record with type 'Bx' based on date (Will change type of 'Biopsy and TURP' from 'Bx' to type 'Bx Dx' and copy the Dx gleason)", dm.dx_date AS 'Diagnosis Date'
FROM qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'biopsy'
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'Bx'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
UPDATE qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'Bx Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'biopsy'
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'Bx'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
UPDATE qc_tf_txd_biopsies_and_turps_revs td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'Bx Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'biopsy'
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'Bx'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;

-- Create missing 'Biopsy & TURP' with type 'Bx Dx'

SELECT dm.participant_id AS "Info#10: Patient# with Dx Method = 'biopsy' matching no 'Biopsy and TURP' record with type 'Bx' based on date (Will create a new 'Biopsy and TURP' record with type 'Bx DX' and will copy the Dx gleason and the date)", dm.dx_date AS 'Diagnosis Date'
FROM qc_tf_dxd_cpcbn dd, diagnosis_masters dm
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'biopsy'
AND dm.id NOT IN (
	SELECT dm.id 
	FROM qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
	WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'biopsy'
	AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'Bx Dx'
	AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy
);
INSERT INTO treatment_masters (participant_id, diagnosis_master_id, treatment_control_id, start_date, start_date_accuracy, notes, modified, created, created_by, modified_by) 
(SELECT dm.participant_id, dm.id, @biopsy_and_turp_treatment_control_id, dm.dx_date, dm.dx_date_accuracy, '-9999', dm.created, dm.created, dm.created_by, dm.created_by
FROM qc_tf_dxd_cpcbn dd, diagnosis_masters dm
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'biopsy'
AND dm.id NOT IN (
	SELECT dm.id 
	FROM qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
	WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'biopsy'
	AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'Bx Dx'
	AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy
));
INSERT INTO treatment_masters_revs (participant_id, diagnosis_master_id, treatment_control_id, start_date, start_date_accuracy, notes, modified_by, id, version_created) 
(SELECT participant_id, diagnosis_master_id, treatment_control_id, start_date, start_date_accuracy, notes, modified_by, id, modified FROM treatment_masters WHERE notes = '-9999');
INSERT INTO qc_tf_txd_biopsies_and_turps (treatment_master_id) (SELECT id FROM treatment_masters WHERE notes = '-9999');
INSERT INTO qc_tf_txd_biopsies_and_turps_revs (treatment_master_id, version_created) (SELECT id, created FROM treatment_masters WHERE notes = '-9999'); 
UPDATE qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'Bx Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'biopsy'
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND tm.notes = '-9999'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
UPDATE qc_tf_txd_biopsies_and_turps_revs td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'Bx Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool = 'biopsy'
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND tm.notes = '-9999'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
UPDATE treatment_masters SET notes = '' WHERE notes = '-9999';
UPDATE treatment_masters_revs SET notes = '' WHERE notes = '-9999';

-- Change type of 'Biopsy & TURP' record from 'Bx' to 'Bx Dx' + copy the gleanson score

SELECT dm.participant_id AS "Info#11: Patient# with Dx Method different than 'biopsy' or 'TURP' matching a 'Biopsy and TURP' record with type 'Bx' based on date (Will change type of 'Biopsy and TURP' from 'Bx' to type 'Bx Dx' and copy the Dx gleason)", dm.dx_date AS 'Diagnosis Date'
FROM qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool NOT IN ('biopsy', 'TURP')
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'Bx'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
UPDATE qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'Bx Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool NOT IN ('biopsy', 'TURP')
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'Bx'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;
UPDATE qc_tf_txd_biopsies_and_turps_revs td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'Bx Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool NOT IN ('biopsy', 'TURP')
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'Bx'
AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy;

-- Create missing 'Biopsy & TURP' with type 'Bx Dx'

SELECT dm.participant_id AS "Info#12: Patient# with Dx Method different than 'biopsy' or 'TURP' matching no 'Biopsy and TURP' record with type 'Bx' based on date and having a Gleason Score Biopsy AND TURP different than unknown (Will create a new 'Biopsy and TURP' record with type 'Bx DX' and will copy the Dx gleason but not the date)", dm.dx_date AS 'Diagnosis Date'
FROM qc_tf_dxd_cpcbn dd, diagnosis_masters dm
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool NOT IN ('biopsy', 'TURP')
AND dd.gleason_score_biopsy_turp IS NOT NULL AND dd.gleason_score_biopsy_turp NOT LIKE '' AND dd.gleason_score_biopsy_turp NOT LIKE 'unknown' 
AND dm.id NOT IN (
	SELECT dm.id 
	FROM qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
	WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool NOT IN ('biopsy', 'TURP')
	AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'Bx Dx'
	AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy
);
INSERT INTO treatment_masters (participant_id, diagnosis_master_id, treatment_control_id, notes, modified, created, created_by, modified_by) 
(SELECT dm.participant_id, dm.id, @biopsy_and_turp_treatment_control_id, '-9999', dm.created, dm.created, dm.created_by, dm.created_by
FROM qc_tf_dxd_cpcbn dd, diagnosis_masters dm
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool NOT IN ('biopsy', 'TURP')
AND dd.gleason_score_biopsy_turp IS NOT NULL AND dd.gleason_score_biopsy_turp NOT LIKE '' AND dd.gleason_score_biopsy_turp NOT LIKE 'unknown' 
AND dm.id NOT IN (
	SELECT dm.id 
	FROM qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
	WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool NOT IN ('biopsy', 'TURP')
	AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND td.type = 'Bx Dx'
	AND dm.dx_date = tm.start_date AND dm.dx_date_accuracy = tm.start_date_accuracy
));
INSERT INTO treatment_masters_revs (participant_id, diagnosis_master_id, treatment_control_id, start_date, start_date_accuracy, notes, modified_by, id, version_created) 
(SELECT participant_id, diagnosis_master_id, treatment_control_id, start_date, start_date_accuracy, notes, modified_by, id, modified FROM treatment_masters WHERE notes = '-9999');
INSERT INTO qc_tf_txd_biopsies_and_turps (treatment_master_id) (SELECT id FROM treatment_masters WHERE notes = '-9999');
INSERT INTO qc_tf_txd_biopsies_and_turps_revs (treatment_master_id, version_created) (SELECT id, created FROM treatment_masters WHERE notes = '-9999'); 
UPDATE qc_tf_txd_biopsies_and_turps td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'Bx Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool NOT IN ('biopsy', 'TURP')
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND tm.notes = '-9999';
UPDATE qc_tf_txd_biopsies_and_turps_revs td, treatment_masters tm, qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET td.type = 'Bx Dx', td.gleason_score = dd.gleason_score_biopsy_turp
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.tool NOT IN ('biopsy', 'TURP')
AND dm.id = tm.diagnosis_master_id AND tm.deleted <> 1 AND tm.id = td.treatment_master_id AND tm.notes = '-9999';
UPDATE treatment_masters SET notes = '' WHERE notes = '-9999';
UPDATE treatment_masters_revs SET notes = '' WHERE notes = '-9999';

-- Check after process

SELECT participant_id AS "Info#13: Patient# with more than 1 biopsy after 'Biopsy and TURP' clean-up process (To check and clean-up after migration id required - some biopsy can have been duplicated)" from (
	SELECT count(*) AS "Bx_nbr", participant_id	FROM treatment_masters tm WHERE tm.treatment_control_id = @biopsy_and_turp_treatment_control_id AND deleted <> 1 GROUP BY participant_id) res 
WHERE res.Bx_nbr > 1;
SELECT participant_id AS "Info#14: Patient# with more than 1 'Bx Dx' or 'TURP Dx' after 'Biopsy and TURP' clean-up process (To clean-up after migration should have one per patient)" from (
	SELECT count(*) AS "Bx_nbr", participant_id	FROM treatment_masters tm INNER JOIN qc_tf_txd_biopsies_and_turps td ON td.treatment_master_id = tm.id WHERE tm.treatment_control_id = @biopsy_and_turp_treatment_control_id AND deleted <> 1 AND td.type LIKE '% Dx' GROUP BY participant_id) res 
WHERE res.Bx_nbr > 1;
SELECT dm.participant_id AS "Info#15: Patient# with a Dx 'Gleason Score Biopsy / TURP' but not linked to a 'TURP Dx' or a 'Bx Dx' (Should be empty or limited to any Diagnosis with a Dx Method different than biopsy or TURP and with gleason = 'unknown')", dd.gleason_score_biopsy_turp AS 'Dx Gelason Score', dd.tool AS 'Dx Method'
FROM qc_tf_dxd_cpcbn dd, diagnosis_masters dm
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.gleason_score_biopsy_turp NOT LIKE '' AND dd.gleason_score_biopsy_turp IS NOT NULL
AND dm.id NOT IN (
	SELECT diagnosis_master_id FROM treatment_masters tm INNER JOIN qc_tf_txd_biopsies_and_turps td ON td.treatment_master_id = tm.id WHERE tm.treatment_control_id = @biopsy_and_turp_treatment_control_id AND deleted <> 1 AND td.type LIKE '% Dx'
);
SELECT "Info#16: Will change gleason unknown to empty for any Diagnosis with a Dx Method different than biopsy or TURP of the previous list (Info#15)" AS process_message;
UPDATE qc_tf_dxd_cpcbn dd, diagnosis_masters dm
SET dd.gleason_score_biopsy_turp = ''
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.gleason_score_biopsy_turp NOT LIKE '' AND dd.gleason_score_biopsy_turp IS NOT NULL
AND dm.id NOT IN (
	SELECT diagnosis_master_id FROM treatment_masters tm INNER JOIN qc_tf_txd_biopsies_and_turps td ON td.treatment_master_id = tm.id WHERE tm.treatment_control_id = @biopsy_and_turp_treatment_control_id AND deleted <> 1 AND td.type LIKE '% Dx'
) AND dd.tool NOT IN ('biopsy', 'TURP');
SELECT dm.participant_id AS "Info#15(bis): Patient# with a Dx 'Gleason Score Biopsy / TURP' but not linked to a 'TURP Dx' or a 'Bx Dx' (Should be empty or limited to any Diagnosis with a Dx Method different than biopsy or TURP and with gleason = 'unknown')", dd.gleason_score_biopsy_turp AS 'Dx Gelason Score', dd.tool AS 'Dx Method'
FROM qc_tf_dxd_cpcbn dd, diagnosis_masters dm
WHERE dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.deleted <> 1 AND dm.id = dd.diagnosis_master_id AND dd.gleason_score_biopsy_turp NOT LIKE '' AND dd.gleason_score_biopsy_turp IS NOT NULL
AND dm.id NOT IN (
	SELECT diagnosis_master_id FROM treatment_masters tm INNER JOIN qc_tf_txd_biopsies_and_turps td ON td.treatment_master_id = tm.id WHERE tm.treatment_control_id = @biopsy_and_turp_treatment_control_id AND deleted <> 1 AND td.type LIKE '% Dx'
);

-- *******  Work on RP ******* 

SET @prostate_diagnosis_control_id = (SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'prostate');
SET @RP_treatment_control_id = (SELECT id FROM treatment_controls WHERE tx_method = 'surgery' AND disease_site = 'RP' AND flag_active = 1);

-- RP check

SELECT participant_id AS 'Info#17: Patient# with more than 1 RP to clean up (should be one after migration process)' from (
	SELECT count(*) AS "RP_nbr", participant_id FROM treatment_masters tm WHERE tm.treatment_control_id = @RP_treatment_control_id AND deleted <> 1 GROUP BY participant_id
) res WHERE res.RP_nbr > 1;
SELECT COUNT(*) As 'Info#18: Nbr of patients with no RP'
FROM participants p INNER JOIN diagnosis_masters dm ON dm.participant_id = p.id
INNER JOIN qc_tf_dxd_cpcbn dd ON dd.diagnosis_master_id = dm.id
WHERE p.deleted <> 1 AND p.id NOT IN (
	SELECT participant_id FROM treatment_masters tm WHERE tm.treatment_control_id = @RP_treatment_control_id AND deleted <> 1
) AND dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id;
SELECT participant_id AS "Info#19: Patient# with a diagnosis gleason score at RP but unlinked to RP (For migration process we assumed result is empty)"
FROM diagnosis_masters dm, qc_tf_dxd_cpcbn dd
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dd.diagnosis_master_id = dm.id AND dd.gleason_score_rp IS NOT NULL AND dd.gleason_score_rp NOT LIKE ''
AND id NOT IN (
	SELECT diagnosis_master_id FROM treatment_masters tm WHERE tm.treatment_control_id = @RP_treatment_control_id AND deleted <> 1
);
SELECT participant_id AS "Info#20: Patient# with a diagnosis method equal RP but unlinked to an RP (For migration process we assumed result is empty)"
FROM diagnosis_masters dm, qc_tf_dxd_cpcbn dd
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dd.diagnosis_master_id = dm.id AND dd.tool = 'RP'
AND id NOT IN (
	SELECT diagnosis_master_id FROM treatment_masters tm WHERE tm.treatment_control_id = @RP_treatment_control_id AND deleted <> 1
);

-- Copy RP gleason score

SELECT COUNT(*) As "Info#21: Nbr of patients we copied the diagnosis gleason RP value to the RP record" 
FROM diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, txd_surgeries td
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.id = dd.diagnosis_master_id
AND tm.deleted <> 1 AND tm.treatment_control_id = @RP_treatment_control_id AND tm.id = td.treatment_master_id
AND tm.diagnosis_master_id = dm.id;
UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, txd_surgeries td
SET td.qc_tf_gleason_score = dd.gleason_score_rp
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.id = dd.diagnosis_master_id
AND tm.deleted <> 1 AND tm.treatment_control_id = @RP_treatment_control_id AND tm.id = td.treatment_master_id
AND tm.diagnosis_master_id = dm.id;
UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, txd_surgeries_revs td
SET td.qc_tf_gleason_score = dd.gleason_score_rp
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.id = dd.diagnosis_master_id
AND tm.deleted <> 1 AND tm.treatment_control_id = @RP_treatment_control_id AND tm.id = td.treatment_master_id
AND tm.diagnosis_master_id = dm.id;

-- Move Dx Spread fields To RP

SELECT dm.participant_id AS "Info#22: Patient# with no RP but Diagnosis 'Spread' fields (lymph node invasion, etc) not empty (For migration process we assumed result is empty)"
FROM diagnosis_masters dm INNER JOIN qc_tf_dxd_cpcbn dd ON dd.diagnosis_master_id = dm.id
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.id NOT IN (
	SELECT diagnosis_master_id FROM treatment_masters tm WHERE tm.treatment_control_id = @RP_treatment_control_id AND deleted <> 1
)
AND (dd.presence_of_lymph_node_invasion NOT LIKE '' AND dd.presence_of_lymph_node_invasion IS NOT NULL)
AND (dd.presence_of_capsular_penetration NOT LIKE '' AND dd.presence_of_capsular_penetration IS NOT NULL)
AND (dd.presence_of_seminal_vesicle_invasion NOT LIKE '' AND dd.presence_of_seminal_vesicle_invasion IS NOT NULL)
AND (dd.margin  NOT LIKE '' AND dd.margin  IS NOT NULL);
SELECT COUNT(*) As "Info#23: Nbr of patients we copied the diagnosis 'Spread' fields to RP record" 
FROM diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, txd_surgeries td
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.id = dd.diagnosis_master_id
AND tm.deleted <> 1 AND tm.treatment_control_id = @RP_treatment_control_id AND tm.id = td.treatment_master_id
AND tm.diagnosis_master_id = dm.id;
UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, txd_surgeries td
SET td.qc_tf_lymph_node_invasion = dd.presence_of_lymph_node_invasion,
td.qc_tf_capsular_penetration = dd.presence_of_capsular_penetration,
td.qc_tf_seminal_vesicle_invasion = dd.presence_of_seminal_vesicle_invasion,
td.qc_tf_margin = dd.margin
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.id = dd.diagnosis_master_id
AND tm.deleted <> 1 AND tm.treatment_control_id = @RP_treatment_control_id AND tm.id = td.treatment_master_id
AND tm.diagnosis_master_id = dm.id;
UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, txd_surgeries_revs td
SET td.qc_tf_lymph_node_invasion = dd.presence_of_lymph_node_invasion,
td.qc_tf_capsular_penetration = dd.presence_of_capsular_penetration,
td.qc_tf_seminal_vesicle_invasion = dd.presence_of_seminal_vesicle_invasion,
td.qc_tf_margin = dd.margin
WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = @prostate_diagnosis_control_id AND dm.id = dd.diagnosis_master_id
AND tm.deleted <> 1 AND tm.treatment_control_id = @RP_treatment_control_id AND tm.id = td.treatment_master_id
AND tm.diagnosis_master_id = dm.id;

SELECT "Info#24: Removed Diagnosis 'Spread' field (capsular penetration, lymph node invasion, etc)" AS process_message;
ALTER TABLE qc_tf_dxd_cpcbn DROP COLUMN presence_of_lymph_node_invasion, DROP COLUMN presence_of_capsular_penetration, DROP COLUMN presence_of_seminal_vesicle_invasion, DROP COLUMN margin;
ALTER TABLE qc_tf_dxd_cpcbn_revs DROP COLUMN presence_of_lymph_node_invasion, DROP COLUMN presence_of_capsular_penetration, DROP COLUMN presence_of_seminal_vesicle_invasion, DROP COLUMN margin;

-- Data check i18n msg

INSERT IGNORE INTO i18n (id,en)
VALUES
('a RP can not be created twice for the same participant','A RP can not be created twice for the same participant'),
('a biopsy or a turp has already been defined as the diagnosis method for this cancer', 'A biopsy or a turp has already been defined as the diagnosis method for this cancer');
INSERT INTO i18n (id,en)
VALUES
('the biopsy or the turp used for the diagnosis is missing into the system','The biopsy or the turp used for the diagnosis is missing into the system'),
('a biopsy or a turp is defined as diagnosis method but the method of the diagnosis is set to something else', 'A biopsy or a turp is defined as diagnosis method but the method of the diagnosis is set to something else'),
('date of the biopsy or turp at diagnosis and diagnosis date discordance', 'Date of the biopsy or turp at diagnosis and diagnosis date discordance');

-- ******* report FIELDS.... *******

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




TODO
- Dans le databrowser changer Treatment par Treatment & Biopsy
- change report file











UPDATE versions SET branch_build_number = '58??' WHERE version_number = '2.6.3';



