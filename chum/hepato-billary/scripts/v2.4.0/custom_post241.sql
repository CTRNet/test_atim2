-- run after 2.4.1

ALTER TABLE qc_hb_txd_surgery_livers
 DROP FOREIGN KEY qc_hb_txd_surgery_livers_ibfk_1,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE qc_hb_txd_surgery_livers_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;
 
ALTER TABLE qc_hb_txd_surgery_pancreas
 DROP FOREIGN KEY qc_hb_txd_surgery_pancreas_ibfk_1,
 CHANGE tx_master_id treatment_master_id INT NOT NULL,
 ADD FOREIGN KEY (treatment_master_id) REFERENCES treatment_masters(id);
ALTER TABLE qc_hb_txd_surgery_pancreas_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL; 

ALTER TABLE users 
 ADD FOREIGN KEY (group_id) REFERENCES groups(id);

DROP TABLE tmp_bogus_primary_dx;

UPDATE i18n SET en='ATiM - Advanced Tissue Management', fr='ATiM - Application de gestion avancée des tissus' WHERE id='core_appname';

INSERT INTO structures(`alias`) VALUES ('qc_hb_ident_summary');
INSERT INTO structure_fields(`plugin`, `model`, `tablename`, `field`, `type`, `structure_value_domain`, `flag_confidential`, `setting`, `default`, `language_help`, `language_label`, `language_tag`) VALUES
('', 'FunctionManagement', '', 'hepato_bil_bank_participant_id', 'input',  NULL , '0', '', '', '', 'hepato_bil_bank_participant_id', ''), 
('', 'FunctionManagement', '', 'health_insurance_card', 'input',  NULL , '0', '', '', '', 'health_insurance_card', ''), 
('', 'FunctionManagement', '', 'saint_luc_hospital_nbr', 'input',  NULL , '0', '', '', '', 'saint_luc_hospital_nbr', '');
INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='qc_hb_ident_summary'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='hepato_bil_bank_participant_id' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='hepato_bil_bank_participant_id' AND `language_tag`=''), '3', '100', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_ident_summary'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='health_insurance_card' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='health_insurance_card' AND `language_tag`=''), '3', '101', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'), 
((SELECT id FROM structures WHERE alias='qc_hb_ident_summary'), (SELECT id FROM structure_fields WHERE `model`='FunctionManagement' AND `tablename`='' AND `field`='saint_luc_hospital_nbr' AND `type`='input' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='saint_luc_hospital_nbr' AND `language_tag`=''), '3', '102', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1');

UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sex') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='sex' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='sex');
UPDATE structure_fields SET  `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='race') ,  `language_help`='' WHERE model='Participant' AND tablename='participants' AND field='race' AND `type`='select' AND structure_value_domain =(SELECT id FROM structure_value_domains WHERE domain_name='race');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='', `flag_summary`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_override_help`='0', `language_help`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='race' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='race') AND `flag_confidential`='0');

DROP VIEW view_collections;
CREATE VIEW `view_collections` AS select `col`.`id` AS `collection_id`,`col`.`bank_id` AS `bank_id`,`col`.`sop_master_id` AS `sop_master_id`,
`link`.`participant_id` AS `participant_id`,`link`.`diagnosis_master_id` AS `diagnosis_master_id`,`link`.`consent_master_id` AS `consent_master_id`,
`part`.`participant_identifier` AS `participant_identifier`,`col`.`acquisition_label` AS `acquisition_label`,`col`.`collection_site` AS `collection_site`,
`col`.`collection_datetime` AS `collection_datetime`,`col`.`collection_datetime_accuracy` AS `collection_datetime_accuracy`,
`col`.`collection_property` AS `collection_property`,`col`.`collection_notes` AS `collection_notes`,`col`.`deleted` AS `deleted`,
`banks`.`name` AS `bank_name`,`col`.`created` AS `created`, mi.identifier_value AS hepato_bil_bank_participant_id 
from `collections` `col` 
left join `clinical_collection_links` `link` on `col`.`id` = `link`.`collection_id` and `link`.`deleted` <> 1 
left join `participants` `part` on `link`.`participant_id` = `part`.`id` and `part`.`deleted` <> 1
left join `banks` on `col`.`bank_id` = `banks`.`id` and `banks`.`deleted` <> 1
LEFT JOIN misc_identifiers AS mi ON part.id=mi.participant_id AND mi.misc_identifier_control_id=3
where `col`.`deleted` <> 1;

UPDATE structure_fields SET type='yes_no', structure_value_domain=NULL WHERE id IN(991, 992, 2197, 2198, 2199, 2200, 2201, 2202, 2203, 2204);
UPDATE qc_hb_ed_hepatobiliary_lifestyles SET active_tobacco='y' WHERE active_tobacco='yes';
UPDATE qc_hb_ed_hepatobiliary_lifestyles SET active_tobacco='n' WHERE active_tobacco='no';
UPDATE qc_hb_ed_hepatobiliary_lifestyles SET active_alcohol='y' WHERE active_alcohol='yes';
UPDATE qc_hb_ed_hepatobiliary_lifestyles SET active_alcohol='n' WHERE active_alcohol='no';
UPDATE qc_hb_ed_hepatobiliary_lifestyles_revs SET active_tobacco='y' WHERE active_tobacco='yes';
UPDATE qc_hb_ed_hepatobiliary_lifestyles_revs SET active_tobacco='n' WHERE active_tobacco='no';
UPDATE qc_hb_ed_hepatobiliary_lifestyles_revs SET active_alcohol='y' WHERE active_alcohol='yes';
UPDATE qc_hb_ed_hepatobiliary_lifestyles_revs SET active_alcohol='n' WHERE active_alcohol='no';
ALTER TABLE qc_hb_ed_hepatobiliary_lifestyles
 MODIFY active_tobacco CHAR(1) NOT NULL DEFAULT '',
 MODIFY active_alcohol CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE qc_hb_ed_hepatobiliary_lifestyles_revs
 MODIFY active_tobacco CHAR(1) NOT NULL DEFAULT '',
 MODIFY active_alcohol CHAR(1) NOT NULL DEFAULT '';

UPDATE qc_hb_consents SET medical_data_access='n' WHERE medical_data_access='no';
UPDATE qc_hb_consents SET biological_material_collection='n' WHERE biological_material_collection='no';
UPDATE qc_hb_consents SET blood_collection='n' WHERE blood_collection='no';
UPDATE qc_hb_consents SET contact_for_additional_info='n' WHERE contact_for_additional_info='no';
UPDATE qc_hb_consents SET contact_for_additional_questionnaire='n' WHERE contact_for_additional_questionnaire='no';
UPDATE qc_hb_consents SET contact_if_news_on_hb='n' WHERE contact_if_news_on_hb='no';
UPDATE qc_hb_consents SET allow_research_on_other_disease='n' WHERE allow_research_on_other_disease='no';
UPDATE qc_hb_consents SET contact_if_news_on_other_disease='n' WHERE contact_if_news_on_other_disease='no';
UPDATE qc_hb_consents_revs SET medical_data_access='n' WHERE medical_data_access='no';
UPDATE qc_hb_consents_revs SET biological_material_collection='n' WHERE biological_material_collection='no';
UPDATE qc_hb_consents_revs SET blood_collection='n' WHERE blood_collection='no';
UPDATE qc_hb_consents_revs SET contact_for_additional_info='n' WHERE contact_for_additional_info='no';
UPDATE qc_hb_consents_revs SET contact_for_additional_questionnaire='n' WHERE contact_for_additional_questionnaire='no';
UPDATE qc_hb_consents_revs SET contact_if_news_on_hb='n' WHERE contact_if_news_on_hb='no';
UPDATE qc_hb_consents_revs SET allow_research_on_other_disease='n' WHERE allow_research_on_other_disease='no';
UPDATE qc_hb_consents_revs SET contact_if_news_on_other_disease='n' WHERE contact_if_news_on_other_disease='no';

UPDATE qc_hb_consents SET medical_data_access='y' WHERE medical_data_access='yes';
UPDATE qc_hb_consents SET biological_material_collection='y' WHERE biological_material_collection='yes';
UPDATE qc_hb_consents SET blood_collection='y' WHERE blood_collection='yes';
UPDATE qc_hb_consents SET contact_for_additional_info='y' WHERE contact_for_additional_info='yes';
UPDATE qc_hb_consents SET contact_for_additional_questionnaire='y' WHERE contact_for_additional_questionnaire='yes';
UPDATE qc_hb_consents SET contact_if_news_on_hb='y' WHERE contact_if_news_on_hb='yes';
UPDATE qc_hb_consents SET allow_research_on_other_disease='y' WHERE allow_research_on_other_disease='yes';
UPDATE qc_hb_consents SET contact_if_news_on_other_disease='y' WHERE contact_if_news_on_other_disease='yes';
UPDATE qc_hb_consents_revs SET medical_data_access='y' WHERE medical_data_access='yes';
UPDATE qc_hb_consents_revs SET biological_material_collection='y' WHERE biological_material_collection='yes';
UPDATE qc_hb_consents_revs SET blood_collection='y' WHERE blood_collection='yes';
UPDATE qc_hb_consents_revs SET contact_for_additional_info='y' WHERE contact_for_additional_info='yes';
UPDATE qc_hb_consents_revs SET contact_for_additional_questionnaire='y' WHERE contact_for_additional_questionnaire='yes';
UPDATE qc_hb_consents_revs SET contact_if_news_on_hb='y' WHERE contact_if_news_on_hb='yes';
UPDATE qc_hb_consents_revs SET allow_research_on_other_disease='y' WHERE allow_research_on_other_disease='yes';
UPDATE qc_hb_consents_revs SET contact_if_news_on_other_disease='y' WHERE contact_if_news_on_other_disease='yes';

ALTER TABLE qc_hb_consents
 MODIFY medical_data_access CHAR(1) NOT NULL DEFAULT '',
 MODIFY biological_material_collection CHAR(1) NOT NULL DEFAULT '',
 MODIFY blood_collection CHAR(1) NOT NULL DEFAULT '',
 MODIFY contact_for_additional_info CHAR(1) NOT NULL DEFAULT '',
 MODIFY contact_for_additional_questionnaire CHAR(1) NOT NULL DEFAULT '',
 MODIFY contact_if_news_on_hb CHAR(1) NOT NULL DEFAULT '',
 MODIFY allow_research_on_other_disease CHAR(1) NOT NULL DEFAULT '',
 MODIFY contact_if_news_on_other_disease CHAR(1) NOT NULL DEFAULT '';
ALTER TABLE qc_hb_consents_revs
 MODIFY medical_data_access CHAR(1) NOT NULL DEFAULT '',
 MODIFY biological_material_collection CHAR(1) NOT NULL DEFAULT '',
 MODIFY blood_collection CHAR(1) NOT NULL DEFAULT '',
 MODIFY contact_for_additional_info CHAR(1) NOT NULL DEFAULT '',
 MODIFY contact_for_additional_questionnaire CHAR(1) NOT NULL DEFAULT '',
 MODIFY contact_if_news_on_hb CHAR(1) NOT NULL DEFAULT '',
 MODIFY allow_research_on_other_disease CHAR(1) NOT NULL DEFAULT '',
 MODIFY contact_if_news_on_other_disease CHAR(1) NOT NULL DEFAULT '';
 
UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `language_label`='sample code' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='sample_code_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_site' AND `language_label`='creation site' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_site') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by' AND `language_label`='created by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_datetime' AND `language_label`='creation date' AND `language_tag`='' AND `type`='datetime' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='inv_creation_datetime_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id' AND `language_label`='parent sample code' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_master_parent_id') AND `language_help`='inv_sample_parent_id_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `language_label`='is problematic' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='0' AND `structure_value_domain` IS NULL  AND `language_help`='inv_is_problematic_sample_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_category' AND `language_label`='category' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `language_help`='inv_sample_category_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_type' AND `language_label`='sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_sd_der_pbmc') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='Generated' AND `tablename`='' AND `field`='coll_to_creation_spent_time_msg' AND `language_label`='collection to creation spent time' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

ALTER TABLE dxd_liver_metastases DROP COLUMN deleted_date;
ALTER TABLE qc_hb_consents DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biologies DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_clinical_presentations DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_lifestyles DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_med_hist_record_summaries DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_medical_past_histories DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_medical_past_history_asas DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_medical_past_history_pves DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hospitalizations DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_intensive_cares DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_medical_imaging_record_summaries DROP COLUMN deleted_date;
ALTER TABLE qc_hb_txe_surgery_complications DROP COLUMN deleted_date;
ALTER TABLE dxd_liver_metastases_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_consents_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobilary_lab_report_biologies_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobilary_medical_imagings_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_clinical_presentations_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_lifestyles_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_med_hist_record_summaries_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_medical_past_histories_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_medical_past_history_asas_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hepatobiliary_medical_past_history_pves_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_hospitalizations_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_intensive_cares_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_ed_medical_imaging_record_summaries_revs DROP COLUMN deleted_date;
ALTER TABLE qc_hb_txe_surgery_complications_revs DROP COLUMN deleted_date;

RENAME TABLE dxd_liver_metastases TO qc_hb_dxd_liver_metastases;
RENAME TABLE dxd_liver_metastases_revs TO qc_hb_dxd_liver_metastases_revs;
UPDATE structure_fields SET tablename='qc_hb_dxd_liver_metastases' WHERE tablename='dxd_liver_metastases';
UPDATE diagnosis_controls SET detail_tablename='qc_hb_dxd_liver_metastases' WHERE detail_tablename='dxd_liver_metastases';

ALTER TABLE qc_hb_ed_hospitalizations
 ADD COLUMN hospitalization_end_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER hospitalization_end_date;
ALTER TABLE qc_hb_ed_hospitalizations_revs
 ADD COLUMN hospitalization_end_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER hospitalization_end_date;

ALTER TABLE qc_hb_ed_intensive_cares
 ADD COLUMN intensive_care_end_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER intensive_care_end_date;
ALTER TABLE qc_hb_ed_intensive_cares_revs
 ADD COLUMN intensive_care_end_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER intensive_care_end_date;

ALTER TABLE qc_hb_txe_surgery_complications
 ADD COLUMN treatment_1_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER treatment_1_date,
 ADD COLUMN treatment_2_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER treatment_2_date,
 ADD COLUMN treatment_3_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER treatment_3_date,
 ADD COLUMN date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER date;
ALTER TABLE qc_hb_txe_surgery_complications_revs
 ADD COLUMN treatment_1_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER treatment_1_date,
 ADD COLUMN treatment_2_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER treatment_2_date,
 ADD COLUMN treatment_3_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER treatment_3_date,
 ADD COLUMN date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER date;

ALTER TABLE participants
 ADD COLUMN last_news_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER last_news_date;
ALTER TABLE participants_revs
 ADD COLUMN last_news_date_accuracy CHAR(1) NOT NULL DEFAULT '' AFTER last_news_date;
 
-- delete structurse_formats
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sample_code' AND `language_label`='sample code' AND `language_tag`='' AND `type`='input' AND `setting`='size=10' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='sample_code_help' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_type' AND `language_label`='sample type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='notes' AND `language_label`='notes' AND `language_tag`='' AND `type`='textarea' AND `setting`='rows=3,cols=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='parent_id' AND `language_label`='parent sample code' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_master_parent_id') AND `language_help`='inv_sample_parent_id_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleControl' AND `tablename`='sample_controls' AND `field`='sample_category' AND `language_label`='category' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_category') AND `language_help`='inv_sample_category_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='is_problematic' AND `language_label`='is problematic' AND `language_tag`='' AND `type`='yes_no' AND `setting`='' AND `default`='0' AND `structure_value_domain` IS NULL  AND `language_help`='inv_is_problematic_sample_defintion' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='sop_master_id' AND `language_label`='sample sop' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='sample_sop_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='Generated' AND `tablename`='' AND `field`='coll_to_creation_spent_time_msg' AND `language_label`='collection to creation spent time' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='SampleMaster' AND `tablename`='sample_masters' AND `field`='initial_specimen_sample_type' AND `language_label`='initial specimen type' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='specimen_sample_type') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_tissue_susp') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Inventorymanagement' AND `model`='DerivativeDetail' AND `tablename`='' AND `field`='creation_by' AND `language_label`='created by' AND `language_tag`='' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='custom_laboratory_staff') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

REPLACE INTO i18n (id, en, fr) VALUES
('recurrent', 'Recurrent', 'Récurrent'),
('add new diagnosis', "Add New Diagnosis", "Ajouter un nouveau diagnostic"),
('additional dimension b', "Additional dimension b", "Dimension supplémentaire b"),
('adjacent liver parenchyma', "Adjacent liver parenchyma", "Parenchyme adjacent au foie"),
('adjacent liver parenchyma specify', "", ""),
('biological glue', "Biological glue", "Colle biologique"),
('chemo-embolization', "", ""),
('chronic hepatitis', "Chronic hepatitis", "Hépatite chronique"),
('contact data', "Contact data", "Données du contact"),
('gastric tube', "Gastric tube", "Tube gastrique"),
('heterogeneous', "Heterogeneous", "Hétérogène"),
('histologic type', "Histologic type", "Type histologique"),
('homogeneous', "Homogeneous", "Homogène"),
('hospitalization', "hospitalization", "Hospitalisation"),
('identifier name', "Identifier name", "Nom d'identifiant"),
('lesions', "Lesions", "Lésions"),
('margins', "Margins", "Marges"),
('necrosis percentage', "Necrosis percentage", "Pourcentage de nécrose"),
('operative bleeding', "Operative bleeding", "Saignement opératoire"),
('operative pathological report', "Operative pathological report", "Rapport pathologique d'opération"),
('operative time (mn)', "operative time (min)", "Temps d'opération (min)"),
('parenchyma', "Parenchyma", "Parenchyme"),
('pathological report', "Pathological report", "Rapport de pathologie"),
('principal surgery', "Principal surgery", "Chirurgie principale"),
('report date', "Report date", "Date du rapport"),
('specify margin', "Specify margin", "Spécifiez la marge"),
('steatosis', "Steatosis", "Stéatose hépatique"),
('storage method', "Storage method", "Méthode d'entreposage"),
('treatment date', 'Treatment date', "Date du traitement"),
('type of drain 1', 'Type of drain 1', "Type de drain 1"),
('type of drain 1', 'Type of drain 2', "Type de drain 2"),
('type of drain 1', 'Type of drain 3', "Type de drain 3"),
('type of glue', "Type of glue", "Type de colle"),
('type of local treatment', "Type of local treatment", "Type de traitement local"),
('type of vascular occlusion', "Type of vascular occlusion", "Type d'occlusion vasculaire"),
('vascular occlusion', "Vascular occlusion", "Occlusion vasculaire");

TRUNCATE missing_translations;

-- ---------------------------------------------------------------------
-- NL revision
-- ----------------------------------------------------------------------

UPDATE groups SET flag_show_confidential = 1 WHERE name IN ('Administrators', 'Users');
UPDATE groups SET name = CONCAT('to delete ',id) WHERE name IN ('Lapointe', 'Rousseau');

-- ClinicalAnnotation.Participant

UPDATE structure_formats SET `display_order`='100', `language_heading`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_search`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');

INSERT INTO i18n (id,en) VALUEs ('the dates accuracy is not sufficient: the field [%%field%%] can not be generated','The dates accuracy is not sufficient: the field [%%field%%] can not be generated!');
INSERT INTO i18n (id,en) VALUEs ('error in the dates definitions: the field [%%field%%] can not be generated','Error in the dates definitions: The field [%%field%%] can not be generated!');


-- ClinicalAnnotation.Treatment

UPDATE structure_formats SET display_order = (display_order + 10) WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_txd_surgery_pancreas');

















































SELECT 'TODO: Work on datamart adhoc running sql statements after line 257';

exit

UPDATE datamart_adhoc SET sql_query_for_results='
SELECT 
EventMaster.id,
Participant.id,
Participant.participant_identifier,
Participant.first_name,
Participant.last_name,

MiscIdentifier.identifier_value,

EventDetail.hepatic_artery,
EventDetail.coeliac_trunk ,
EventDetail.splenic_artery,
EventDetail.superior_mesenteric_artery,
EventDetail.portal_vein,
EventDetail.superior_mesenteric_vein,
EventDetail.splenic_vein,
EventDetail.metastatic_lymph_nodes

FROM event_controls AS ctrl
INNER JOIN event_masters AS EventMaster ON ctrl.id = EventMaster.event_control_id AND ctrl.form_alias LIKE "qc_hb_imaging_%pancreas%" AND EventMaster.deleted != 1
INNER JOIN qc_hb_ed_hepatobilary_medical_imagings AS EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN participants AS Participant ON EventMaster.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN misc_identifiers AS MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.misc_identifier_control_id = "3" AND MiscIdentifier.deleted != 1

WHERE TRUE AND
Participant.participant_identifier = "@@Participant.participant_identifier@@"
AND MiscIdentifier.identifier_value = "@@MiscIdentifier.identifier_value@@"

AND EventDetail.hepatic_artery = "@@EventDetail.hepatic_artery@@"
AND EventDetail.coeliac_trunk = "@@EventDetail.coeliac_trunk@@"
AND EventDetail.splenic_artery = "@@EventDetail.splenic_artery@@"
AND EventDetail.superior_mesenteric_artery = "@@EventDetail.superior_mesenteric_artery@@"
AND EventDetail.portal_vein = "@@EventDetail.portal_vein@@"
AND EventDetail.superior_mesenteric_vein = "@@EventDetail.superior_mesenteric_vein@@"
AND EventDetail.splenic_vein = "@@EventDetail.splenic_vein@@"
AND EventDetail.metastatic_lymph_nodes = "@@EventDetail.metastatic_lymph_nodes@@";
' WHERE id=2;



UPDATE datamart_adhoc SET sql_query_for_results='
SELECT 
EventMaster.id,
Participant.id,
Participant.participant_identifier,
Participant.first_name,
Participant.last_name,

MiscIdentifier.identifier_value,

EventDetail.is_volumetry_post_pve,
EventDetail.total_liver_volume,
EventDetail.resected_liver_volume,
EventDetail.remnant_liver_volume,
EventDetail.tumoral_volume,
EventDetail.remnant_liver_percentage

FROM event_controls AS ctrl
INNER JOIN event_masters AS EventMaster ON ctrl.id = EventMaster.event_control_id AND ctrl.form_alias LIKE "qc_hb_imaging_%volumetry%" AND EventMaster.deleted != 1
INNER JOIN qc_hb_ed_hepatobilary_medical_imagings AS EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN participants AS Participant ON EventMaster.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN misc_identifiers AS MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.misc_identifier_control_id = "3" AND MiscIdentifier.deleted != 1

WHERE TRUE AND
Participant.participant_identifier = "@@Participant.participant_identifier@@"
AND MiscIdentifier.identifier_value = "@@MiscIdentifier.identifier_value@@"

AND EventDetail.is_volumetry_post_pve = "@@EventDetail.is_volumetry_post_pve@@"

AND EventDetail.total_liver_volume >= "@@EventDetail.total_liver_volume_start@@" 
AND EventDetail.total_liver_volume <= "@@EventDetail.total_liver_volume_end@@" 

AND EventDetail.resected_liver_volume >= "@@EventDetail.resected_liver_volume_start@@" 
AND EventDetail.resected_liver_volume <= "@@EventDetail.resected_liver_volume_end@@" 

AND EventDetail.remnant_liver_volume >= "@@EventDetail.remnant_liver_volume_start@@" 
AND EventDetail.remnant_liver_volume <= "@@EventDetail.remnant_liver_volume_end@@" 

AND EventDetail.tumoral_volume >= "@@EventDetail.tumoral_volume_start@@" 
AND EventDetail.tumoral_volume <= "@@EventDetail.tumoral_volume_end@@" 

AND EventDetail.remnant_liver_percentage >= "@@EventDetail.remnant_liver_percentage_start@@" 
AND EventDetail.remnant_liver_percentage <= "@@EventDetail.remnant_liver_percentage_end@@" ;
' WHERE id=3;

UPDATE structure_fields SET  `type`='float_positive' WHERE model='EventDetail' AND tablename='qc_hb_ed_hepatobilary_medical_imagings' AND field='remnant_liver_percentage' AND `type`='number' AND structure_value_domain  IS NULL ;
UPDATE structure_fields SET  `type`='float_positive' WHERE model='EventDetail' AND tablename='qc_hb_ed_hepatobilary_medical_imagings' AND field='remnant_liver_volume' AND `type`='number' AND structure_value_domain  IS NULL ;




UPDATE datamart_adhoc SET sql_query_for_results='
SELECT 
EventMaster.id,
Participant.id,
Participant.participant_identifier,
Participant.first_name,
Participant.last_name,

MiscIdentifier.identifier_value,

EventDetail.lungs_number,
EventDetail.lungs_size,
EventDetail.lungs_laterality,
EventDetail.lymph_node_number,
EventDetail.lymph_node_size,
EventDetail.colon_number,
EventDetail.colon_size,
EventDetail.rectum_number,
EventDetail.rectum_size,
EventDetail.bones_number,
EventDetail.bones_size,
EventDetail.other_localisation_1,
EventDetail.other_localisation_1_number,
EventDetail.other_localisation_1_size,
EventDetail.other_localisation_2,
EventDetail.other_localisation_2_number,
EventDetail.other_localisation_2_size,
EventDetail.other_localisation_3,
EventDetail.other_localisation_3_number,
EventDetail.other_localisation_3_size

FROM event_controls AS ctrl
INNER JOIN event_masters AS EventMaster ON ctrl.id = EventMaster.event_control_id AND ctrl.form_alias LIKE "qc_hb_imaging_%other%" AND EventMaster.deleted != 1
INNER JOIN qc_hb_ed_hepatobilary_medical_imagings AS EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN participants AS Participant ON EventMaster.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN misc_identifiers AS MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.misc_identifier_control_id = 3 AND MiscIdentifier.deleted != 1

WHERE TRUE AND
Participant.participant_identifier = "@@Participant.participant_identifier@@"
AND MiscIdentifier.identifier_value = "@@MiscIdentifier.identifier_value@@"

AND EventDetail.lungs_number >= "@@EventDetail.lungs_number_start@@" 
AND EventDetail.lungs_number <= "@@EventDetail.lungs_number_end@@"

AND EventDetail.lungs_size >= "@@EventDetail.lungs_size_start@@" 
AND EventDetail.lungs_size <= "@@EventDetail.lungs_size_end@@"

AND EventDetail.lungs_laterality = "@@EventDetail.lungs_laterality@@"

AND EventDetail.lymph_node_number >= "@@EventDetail.lymph_node_number_start@@" 
AND EventDetail.lymph_node_number <= "@@EventDetail.lymph_node_number_end@@"

AND EventDetail.lymph_node_size >= "@@EventDetail.lymph_node_size_start@@" 
AND EventDetail.lymph_node_size <= "@@EventDetail.lymph_node_size_end@@"

AND EventDetail.colon_number >= "@@EventDetail.colon_number_start@@" 
AND EventDetail.colon_number <= "@@EventDetail.colon_number_end@@"

AND EventDetail.colon_size >= "@@EventDetail.colon_size_start@@" 
AND EventDetail.colon_size <= "@@EventDetail.colon_size_end@@"

AND EventDetail.rectum_number >= "@@EventDetail.rectum_number_start@@" 
AND EventDetail.rectum_number <= "@@EventDetail.rectum_number_end@@"

AND EventDetail.rectum_size >= "@@EventDetail.rectum_size_start@@" 
AND EventDetail.rectum_size <= "@@EventDetail.rectum_size_end@@"

AND EventDetail.bones_number >= "@@EventDetail.bones_number_start@@" 
AND EventDetail.bones_number <= "@@EventDetail.bones_number_end@@"

AND EventDetail.bones_size >= "@@EventDetail.bones_size_start@@" 
AND EventDetail.bones_size <= "@@EventDetail.bones_size_end@@"

AND EventDetail.other_localisation_1 = "@@EventDetail.other_localisation_1@@"

AND EventDetail.other_localisation_1_number >= "@@EventDetail.other_localisation_1_number_start@@" 
AND EventDetail.other_localisation_1_number <= "@@EventDetail.other_localisation_1_number_end@@"

AND EventDetail.other_localisation_1_size >= "@@EventDetail.other_localisation_1_size_start@@" 
AND EventDetail.other_localisation_1_size <= "@@EventDetail.other_localisation_1_size_end@@"

AND EventDetail.other_localisation_2 = "@@EventDetail.other_localisation_2@@"

AND EventDetail.other_localisation_2_number >= "@@EventDetail.other_localisation_2_number_start@@" 
AND EventDetail.other_localisation_2_number <= "@@EventDetail.other_localisation_2_number_end@@"

AND EventDetail.other_localisation_2_size >= "@@EventDetail.other_localisation_2_size_start@@" 
AND EventDetail.other_localisation_2_size <= "@@EventDetail.other_localisation_2_size_end@@"

AND EventDetail.other_localisation_3 = "@@EventDetail.other_localisation_3@@"

AND EventDetail.other_localisation_3_number >= "@@EventDetail.other_localisation_3_number_start@@" 
AND EventDetail.other_localisation_3_number <= "@@EventDetail.other_localisation_3_number_end@@"

AND EventDetail.other_localisation_3_size >= "@@EventDetail.other_localisation_3_size_start@@" 
AND EventDetail.other_localisation_3_size <= "@@EventDetail.other_localisation_3_size_end@@"
' WHERE id=4;


UPDATE datamart_adhoc SET sql_query_for_results='
SELECT 
EventMaster.id,
Participant.id,
Participant.participant_identifier,
Participant.first_name,
Participant.last_name,

MiscIdentifier.identifier_value,

EventDetail.segment_1_number,
EventDetail.segment_1_size,
EventDetail.segment_2_number,
EventDetail.segment_2_size,
EventDetail.segment_3_number,
EventDetail.segment_3_size,
EventDetail.segment_4a_number,
EventDetail.segment_4a_size,
EventDetail.segment_4b_number,
EventDetail.segment_4b_size,
EventDetail.segment_5_number,
EventDetail.segment_5_size,
EventDetail.segment_6_number,
EventDetail.segment_6_size,
EventDetail.segment_7_number,
EventDetail.segment_7_size,
EventDetail.segment_8_number,
EventDetail.segment_8_size,
EventDetail.density,
EventDetail.type

FROM event_controls AS ctrl
INNER JOIN event_masters AS EventMaster ON ctrl.id = EventMaster.event_control_id AND ctrl.form_alias LIKE "qc_hb_imaging_%segment%" AND EventMaster.deleted != 1
INNER JOIN qc_hb_ed_hepatobilary_medical_imagings AS EventDetail ON EventDetail.event_master_id = EventMaster.id
INNER JOIN participants AS Participant ON EventMaster.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN misc_identifiers AS MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.misc_identifier_control_id = 3 AND MiscIdentifier.deleted != 1

WHERE TRUE AND
Participant.participant_identifier = "@@Participant.participant_identifier@@"
AND MiscIdentifier.identifier_value = "@@MiscIdentifier.identifier_value@@"

AND EventDetail.segment_1_number >= "@@EventDetail.segment_1_number_start@@" 
AND EventDetail.segment_1_number <= "@@EventDetail.segment_1_number_end@@" 

AND EventDetail.segment_1_size >= "@@EventDetail.segment_1_size_start@@" 
AND EventDetail.segment_1_size <= "@@EventDetail.segment_1_size_end@@" 

AND EventDetail.segment_2_number >= "@@EventDetail.segment_2_number_start@@" 
AND EventDetail.segment_2_number <= "@@EventDetail.segment_2_number_end@@" 

AND EventDetail.segment_2_size >= "@@EventDetail.segment_2_size_start@@" 
AND EventDetail.segment_2_size <= "@@EventDetail.segment_2_size_end@@" 

AND EventDetail.segment_3_number >= "@@EventDetail.segment_3_number_start@@" 
AND EventDetail.segment_3_number <= "@@EventDetail.segment_3_number_end@@" 

AND EventDetail.segment_3_size >= "@@EventDetail.segment_3_size_start@@" 
AND EventDetail.segment_3_size <= "@@EventDetail.segment_3_size_end@@" 

AND EventDetail.segment_4a_number >= "@@EventDetail.segment_4a_number_start@@" 
AND EventDetail.segment_4a_number <= "@@EventDetail.segment_4a_number_end@@" 

AND EventDetail.segment_4a_size >= "@@EventDetail.segment_4a_size_start@@" 
AND EventDetail.segment_4a_size <= "@@EventDetail.segment_4a_size_end@@" 

AND EventDetail.segment_4b_number >= "@@EventDetail.segment_4b_number_start@@" 
AND EventDetail.segment_4b_number <= "@@EventDetail.segment_4b_number_end@@" 

AND EventDetail.segment_4b_size >= "@@EventDetail.segment_4b_size_start@@" 
AND EventDetail.segment_4b_size <= "@@EventDetail.segment_4b_size_end@@" 

AND EventDetail.segment_5_number >= "@@EventDetail.segment_5_number_start@@" 
AND EventDetail.segment_5_number <= "@@EventDetail.segment_5_number_end@@" 

AND EventDetail.segment_5_size >= "@@EventDetail.segment_5_size_start@@" 
AND EventDetail.segment_5_size <= "@@EventDetail.segment_5_size_end@@" 

AND EventDetail.segment_6_number >= "@@EventDetail.segment_6_number_start@@" 
AND EventDetail.segment_6_number <= "@@EventDetail.segment_6_number_end@@" 

AND EventDetail.segment_6_size >= "@@EventDetail.segment_6_size_start@@" 
AND EventDetail.segment_6_size <= "@@EventDetail.segment_6_size_end@@" 

AND EventDetail.segment_7_number >= "@@EventDetail.segment_7_number_start@@" 
AND EventDetail.segment_7_number <= "@@EventDetail.segment_7_number_end@@" 

AND EventDetail.segment_7_size >= "@@EventDetail.segment_7_size_start@@" 
AND EventDetail.segment_7_size <= "@@EventDetail.segment_7_size_end@@" 

AND EventDetail.segment_8_number >= "@@EventDetail.segment_8_number_start@@" 
AND EventDetail.segment_8_number <= "@@EventDetail.segment_8_number_end@@" 

AND EventDetail.segment_8_size >= "@@EventDetail.segment_8_size_start@@" 
AND EventDetail.segment_8_size <= "@@EventDetail.segment_8_size_end@@" 

AND EventDetail.density >= "@@EventDetail.density_start@@" 
AND EventDetail.density <= "@@EventDetail.density_end@@" 

AND EventDetail.type = "@@EventDetail.type@@"
' WHERE id=1;