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
UPDATE structure_formats SET `flag_override_type`='0', `type`='', `flag_override_setting`='0', `setting`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier');
UPDATE structure_formats SET display_order = (display_order + 1) WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_ident_summary');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='sex' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='sex') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='participants') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Participant' AND `tablename`='participants' AND `field`='vital_status' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='health_status') AND `flag_confidential`='0');

INSERT INTO i18n (id,en) VALUEs ('the dates accuracy is not sufficient: the field [%%field%%] can not be generated','The dates accuracy is not sufficient: the field [%%field%%] can not be generated!');
INSERT INTO i18n (id,en) VALUEs ('error in the dates definitions: the field [%%field%%] can not be generated','Error in the dates definitions: The field [%%field%%] can not be generated!');

-- ClinicalAnnotation.MiscIdentifier

UPDATE misc_identifier_controls SET flag_once_per_participant = '1';

-- ClinicalAnnotation.Treatment

UPDATE structure_formats SET `flag_override_label`='0', `language_label`='' WHERE structure_field_id IN (SELECT id FROM structure_fields WHERE field='start_date' AND model = 'TreatmentMaster');
 
UPDATE structure_formats SET display_order = (display_order + 10) WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_txd_surgery_livers');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_livers') AND structure_field_id IN (SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='qc_hb_txd_surgery_livers' AND `field` IN ('pathological_report','survival_time_in_months','type_of_vascular_occlusion'));
UPDATE structure_formats SET `display_order`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txe_surgery_complications') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentExtend' AND `tablename`='qc_hb_txe_surgery_complications' AND `field`='type');

UPDATE structure_formats SET display_order = (display_order + 10) WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_txd_surgery_pancreas');
UPDATE structure_formats SET `flag_search`='1', `flag_index`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_txd_surgery_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='TreatmentDetail' AND `tablename`='' AND `field`='survival_time_in_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE treatment_controls SET tx_method = 'chemotherapy' WHERE detail_tablename = 'txd_chemos' AND tx_method = 'surgery without extension'; 

UPDATE structure_formats SET display_order = (display_order + 10) WHERE structure_id = (SELECT id FROM structures WHERE alias = 'qc_hb_tx_chemos');

UPDATE event_controls SET flag_active = 1;
UPDATE event_controls SET flag_active = 0 WHERE event_type = 'comorbidity';

UPDATE structure_fields SET type = 'float' WHERE type = 'number' AND tablename like 'qc_hb_%';

INSERT IGNORE INTO i18n (id,en) VALUES ('chemo-embolization', 'Chemo-Embolization');

-- ClinicalAnnotation.Annotation

REPLACE INTO i18n (id,en,fr) VALUES ('this type of event has already been created for your participant', 'This type of annotation has already been created for your participant!', 'Ce type d''annotation a déjà été créée pour votre participant!');

UPDATE structure_fields SET tablename = 'qc_hb_ed_hospitalizations' WHERE field = 'hospitalization_end_date';
UPDATE structure_fields SET tablename = 'qc_hb_ed_hospitalizations' WHERE field = 'hospitalization_duration_in_days';

UPDATE structure_formats SET display_column = (display_column + 1) WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'qc_hb_ed_%');

UPDATE event_controls SET form_alias = '' WHERE form_alias = '';

UPDATE event_controls SET form_alias = 'eventmasters,qc_hb_imaging_dateNSummary,qc_hb_segment,qc_hb_other_localisations' WHERE form_alias = 'eventmasters,qc_hb_imaging_segment_other';
UPDATE event_controls SET form_alias = 'eventmasters,qc_hb_imaging_dateNSummary,qc_hb_segment,qc_hb_other_localisations,qc_hb_pancreas,qc_hb_volumetry' WHERE form_alias = 'eventmasters,qc_hb_imaging_segment_other_pancreas_volumetry';
UPDATE event_controls SET form_alias = 'eventmasters,qc_hb_imaging_dateNSummary,qc_hb_other_localisations' WHERE form_alias = 'eventmasters,qc_hb_imaging_other';
UPDATE event_controls SET form_alias = 'eventmasters,qc_hb_imaging_dateNSummary,qc_hb_segment,qc_hb_other_localisations,qc_hb_pancreas' WHERE form_alias = 'eventmasters,qc_hb_imaging_segment_other_pancreas';
UPDATE event_controls SET form_alias = 'eventmasters,qc_hb_imaging_dateNSummary,qc_hb_segment' WHERE form_alias = 'eventmasters,qc_hb_imaging_segment';
UPDATE event_controls SET form_alias = 'eventmasters,qc_hb_imaging_dateNSummary' WHERE form_alias = 'eventmasters,qc_hb_imaging';
UPDATE event_controls SET form_alias = 'eventmasters,qc_hb_imaging_dateNSummary,qc_hb_other_localisations,qc_hb_pancreas' WHERE form_alias = 'eventmasters,qc_hb_imaging_other_pancreas';

DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_imaging_dateNSummary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_date' AND `language_label`='date' AND `language_tag`='' AND `type`='date' AND `setting`='' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_imaging_dateNSummary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='' AND `plugin`='Clinicalannotation' AND `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_type' AND `language_label`='' AND `language_tag`='-' AND `type`='select' AND `setting`='' AND `default`='' AND `structure_value_domain`=(SELECT id FROM structure_value_domains WHERE domain_name='event_type_list') AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

-- qc_hb_imaging_dateNSummary
UPDATE structure_formats SET `display_column`='1', `display_order`='0', `flag_index`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_imaging_dateNSummary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- qc_hb_volumetry
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_volumetry') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-17' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `language_label`='participant identifier' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_participant identifier' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_volumetry') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-119' AND `plugin`='Clinicalannotation' AND `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `language_label`='value' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_volumetry') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-9' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `language_label`='' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_first_name' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_volumetry') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-11' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `language_label`='' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_last_name' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_formats SET display_column = 1,display_order = (display_order + 10)  WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'qc_hb_volumetry');
UPDATE structure_formats SET `language_heading`='volumetry' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_volumetry') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='is_volumetry_post_pve');

-- qc_hb_pancreas
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-17' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `language_label`='participant identifier' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_participant identifier' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-119' AND `plugin`='Clinicalannotation' AND `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `language_label`='value' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-9' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `language_label`='' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_first_name' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-11' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `language_label`='' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_last_name' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_formats SET display_column = 2,display_order = (display_order + 100)  WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'qc_hb_pancreas');
UPDATE structure_formats SET `language_heading`='pancreas (tumoral invasion)' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_pancreas') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventDetail' AND `tablename`='qc_hb_ed_hepatobilary_medical_imagings' AND `field`='hepatic_artery');

-- qc_hb_segment
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_segment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-17' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `language_label`='participant identifier' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_participant identifier' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_segment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-119' AND `plugin`='Clinicalannotation' AND `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `language_label`='value' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_segment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-9' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `language_label`='' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_first_name' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_segment') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-11' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `language_label`='' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_last_name' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_formats SET display_column = 2,display_order = (display_order + 200)  WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'qc_hb_segment');

UPDATE structure_fields SET language_tag = language_label WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND (field LIKE 'segment_%_number' OR field LIKE 'segment_%_size');
UPDATE structure_fields SET language_label = '' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND (field LIKE 'segment_%_number' OR field LIKE 'segment_%_size');

UPDATE structure_fields SET language_label = 'segment I' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND field = 'segment_1_number';
UPDATE structure_fields SET language_label = 'segment II' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND field = 'segment_2_number';
UPDATE structure_fields SET language_label = 'segment III' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND field = 'segment_3_number';
UPDATE structure_fields SET language_label = 'segment IVa' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND field = 'segment_4a_number';
UPDATE structure_fields SET language_label = 'segment IVb' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND field = 'segment_4b_number';
UPDATE structure_fields SET language_label = 'segment V' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND field = 'segment_5_number';
UPDATE structure_fields SET language_label = 'segment VI' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND field = 'segment_6_number';
UPDATE structure_fields SET language_label = 'segment VII' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND field = 'segment_7_number';
UPDATE structure_fields SET language_label = 'segment VIII' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND field = 'segment_8_number';

UPDATE structure_fields SET language_tag = language_label WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND (field LIKE 'density' OR field LIKE 'type');
UPDATE structure_fields SET language_label = '' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND (field LIKE 'density' OR field LIKE 'type');
UPDATE structure_fields SET language_label = 'other' WHERE tablename = 'qc_hb_ed_hepatobilary_medical_imagings' AND (field LIKE 'density');

UPDATE structure_formats SET language_heading = '' WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'qc_hb_segment');

UPDATE structure_formats SET language_heading = 'segments' WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'qc_hb_segment') AND structure_field_id = (SELECT id FROM structure_fields WHERE field = 'segment_1_number' AND tablename = 'qc_hb_ed_hepatobilary_medical_imagings');

-- qc_hb_other_localisations
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_other_localisations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-17' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='participant_identifier' AND `language_label`='participant identifier' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_participant identifier' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_other_localisations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-119' AND `plugin`='Clinicalannotation' AND `model`='MiscIdentifier' AND `tablename`='misc_identifiers' AND `field`='identifier_value' AND `language_label`='value' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_other_localisations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-9' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='first_name' AND `language_label`='' AND `language_tag`='' AND `type`='input' AND `setting`='size=20' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_first_name' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');
DELETE FROM structure_formats WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_other_localisations') AND structure_field_id=(SELECT id FROM structure_fields WHERE `public_identifier`='DE-11' AND `plugin`='Clinicalannotation' AND `model`='Participant' AND `tablename`='participants' AND `field`='last_name' AND `language_label`='' AND `language_tag`='' AND `type`='input' AND `setting`='size=30' AND `default`='' AND `structure_value_domain` IS NULL  AND `language_help`='help_last_name' AND `validation_control`='open' AND `value_domain_control`='open' AND `field_control`='open' AND `flag_confidential`='0');

UPDATE structure_formats SET display_column = 3,display_order = (display_order + 400)  WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'qc_hb_other_localisations');

INSERT IGNORE into i18n (id,en) VALUES ('pancreas (tumoral invasion)', 'Pancreas (Tumoral Invasion)'),('segments','Segments');

UPDATE structure_fields fi, structure_formats fo, structures st
SET fi.language_tag = fi.language_label
WHERE st.alias = 'qc_hb_other_localisations' AND st.id = fo.structure_id AND fo.structure_field_id = fi.id;

UPDATE structure_fields fi, structure_formats fo, structures st
SET fi.language_label = fo.language_heading
WHERE st.alias = 'qc_hb_other_localisations' AND st.id = fo.structure_id AND fo.structure_field_id = fi.id;

UPDATE structure_formats fo, structures st
SET fo.language_heading = ''
WHERE st.alias = 'qc_hb_other_localisations' AND st.id = fo.structure_id;

UPDATE structure_fields fi, structure_formats fo, structures st
SET fo.language_heading = 'other localisations'
WHERE st.alias = 'qc_hb_other_localisations' AND st.id = fo.structure_id AND fo.structure_field_id = fi.id AND fi.field = 'lungs_number';

UPDATE structure_formats SET display_column = 1,display_order = (display_order - 350)  WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'qc_hb_other_localisations');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history_cirrhosis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='qc_hb_ed_hepatobiliary_medical_past_history_hepatitis') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats SET `display_column`='1' WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'qc_hb_ed_score%') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

UPDATE structure_formats 
SET `flag_search`='1', flag_index = '1' WHERE structure_id IN (SELECT id FROM structures WHERE alias LIKE 'qc_hb_ed_score%') 
AND structure_field_id NOT IN (SELECT id FROM structure_fields WHERE `model`='EventMaster' AND `tablename`='event_masters' AND `field`='event_summary' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
