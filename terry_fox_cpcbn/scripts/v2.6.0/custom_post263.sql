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

INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'total_number_taken_biopsy', 'integer',  NULL , '0', '', '', '', 'total number taken', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'total_positive_biopsy', 'integer',  NULL , '0', '', '', '', 'total positive', ''), 
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_tf_dxd_cpcbn', 'greatest_percent_of_cancer ', 'integer',  NULL , '0', '', '', '', 'greatest percent of cancer ', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='total_number_taken_biopsy' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total number taken' AND `language_tag`=''), '1', '10', 'biopsy', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='total_positive_biopsy' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='total positive' AND `language_tag`=''), '1', '11', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0'), 
((SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='greatest_percent_of_cancer ' AND `type`='integer' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='greatest percent of cancer ' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='11' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_score_biopsy' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='15', `language_heading`='RP' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_dxd_cpcbn') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_dxd_cpcbn' AND `field`='gleason_score_rp' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_gleason_values') AND `flag_confidential`='0');
INSERT INTO i18n (id,en)
VALUES
('total number taken', 'Total Number Taken'),
('total positive', 'Total Positive'),
('greatest percent of cancer', 'Greatest Percent of Cancer');
REPLACE INTO i18n (id,en)
VALUES
('RP', 'RP');
UPDATE structure_fields SET language_label = 'greatest percent of cancer' WHERE language_label = 'greatest percent of cancer ';
ALTER TABLE qc_tf_dxd_cpcbn
  ADD COLUMN total_number_taken_biopsy int(6) default null,
  ADD COLUMN total_positive_biopsy int(6) default null,
  ADD COLUMN greatest_percent_of_cancer int(6) default null;
ALTER TABLE qc_tf_dxd_cpcbn_revs
  ADD COLUMN total_number_taken_biopsy int(6) default null,
  ADD COLUMN total_positive_biopsy int(6) default null,
  ADD COLUMN greatest_percent_of_cancer int(6) default null;
UPDATE structure_fields SET field = 'greatest_percent_of_cancer' WHERE field = 'greatest_percent_of_cancer '; 

INSERT INTO `structure_value_domains` (`id`, `domain_name`, `override`, `category`, `source`) VALUES (NULL, 'qc_tf_biopsy_type', 'open', '', "StructurePermissibleValuesCustom::getCustomDropdown('Biopsy Types')");
INSERT INTO structure_permissible_values_custom_controls (name,category,flag_active,values_max_length)
VALUES ('Biopsy Types', 'clinical - treatment', '1', '50');
INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `display_order`, `control_id`, `use_as_input`) 
VALUES 
('Dx Bx','','', 1, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'Biopsy Types'), 1),
('Bx prior to Tx','','', 2, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'Biopsy Types'), 1),
('TRUS','','', 7, (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'Biopsy Types'), 1);
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('ClinicalAnnotation', 'DiagnosisDetail', 'qc_tf_txd_biopsies', 'type', 'select', (SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_biopsy_type') , '0', '', '', '', 'type', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `margin`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`, `flag_float`) VALUES 
((SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies'), (SELECT id FROM structure_fields WHERE `model`='DiagnosisDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='type' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_biopsy_type')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='type' AND `language_tag`=''), '1', '12', '', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '0', '0', '1', '1', '0', '0');
UPDATE structure_formats SET `display_order`='13' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_tf_txd_biopsies') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_tf_txd_biopsies' AND `field`='samples_number' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
ALTER TABLE qc_tf_txd_biopsies ADD COLUMN type varchar(50) default null;
ALTER TABLE qc_tf_txd_biopsies_revs ADD COLUMN type varchar(50) default null;
UPDATE structure_fields SET  `model`='TreatmentDetail',  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_biopsy_type')  WHERE model='DiagnosisDetail' AND tablename='qc_tf_txd_biopsies' AND field='type' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='qc_tf_biopsy_type');

UPDATE versions SET branch_build_number = '58 WHERE version_number = '2.6.3';
