-- run after 2.4.0

ALTER TABLE users 
 ADD FOREIGN KEY (group_id) REFERENCES groups(id);

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


DELETE FROM diagnosis_controls WHERE form_alias LIKE 'dx_cap_%';

UPDATE structure_formats SET flag_summary = 0 WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters');
UPDATE structure_formats sf_sm, structure_formats sf_old
SET sf_sm.flag_summary = 1 
WHERE sf_sm.structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters')
AND sf_sm.structure_field_id = sf_old.structure_field_id 
AND sf_old.structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result') 
AND sf_old.flag_summary = '1';
DELETE from structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'sample_masters_for_search_result');
DELETE from structures WHERE alias = 'sample_masters_for_search_result';

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
ALTER TABLE qc_hb_txd_surgery_livers_revs
 CHANGE tx_master_id treatment_master_id INT NOT NULL;
