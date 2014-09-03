UPDATE structure_formats SET `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='specimens') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewSample' AND `tablename`='view_samples' AND `field`='coll_to_rec_spent_time_msg' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0') AND `type`='integer_positive';

UPDATE datamart_reports SET flag_active = 0 WHERE name = 'participant identifiers';
UPDATE datamart_structure_functions SET flag_active = 0 WHERE link = (SELECT CONCAT('/Datamart/Reports/manageReport/',id) FROM datamart_reports WHERE name = 'participant identifiers');

DROP TABLE txe_radiations; DROP TABLE txe_radiations_revs;
UPDATE treatment_controls SET applied_protocol_control_id = null, flag_use_for_ccl = 0 WHERE flag_active = 1;

UPDATE treatment_extend_controls SET type = 'chemotherpay drugs', databrowser_label = 'chemotherpay drugs' WHERE detail_form_alias = 'qc_tf_txe_chemo_drugs';
UPDATE treatment_extend_controls SET type = 'hormonotherpay drugs', databrowser_label = 'hormonotherpay drugs' WHERE detail_form_alias = 'qc_tf_txe_horm_drugs';
UPDATE treatment_extend_controls SET type = 'bone treatment drugs', databrowser_label = 'bone treatment drugs' WHERE detail_form_alias = 'qc_tf_txe_bone_drugs';
UPDATE treatment_extend_controls SET type = 'HR treatment drugs', databrowser_label = 'HR treatment drugs' WHERE detail_form_alias = 'qc_tf_txe_HR_drugs';
INSERT INTO i18n (id,en) 
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













