UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='disease_site' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='ctrnet_submission_disease_site') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='start_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='1', `flag_edit`='1', `flag_detail`='1' WHERE structure_id=(SELECT id FROM structures WHERE alias='studysummaries') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='StudySummary' AND `tablename`='study_summaries' AND `field`='end_date' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

-- CONSENT

DELETE FROM structure_formats WHERE structure_id = (SELECT id FROM structures WHERE alias = 'chuq_cd_consents');
DELETE FROM structures WHERE alias = 'chuq_cd_consents';

-- DIAGNOSIS

UPDATE consent_controls SET form_alias = 'consent_masters' WHERE form_alias = 'chuq_cd_consents';

UPDATE `diagnosis_controls` SET `form_alias` = 'diagnosismasters,dx_primary,chuq_dx_all_sites', `databrowser_label` = 'primary|chuq', `controls_type` = 'chuq' WHERE `controls_type` = 'chuq primary';

DELETE FROM structure_formats 
WHERE structure_id=(SELECT id FROM structures WHERE alias='chuq_dx_all_sites') 
AND structure_field_id IN (SELECT id FROM structure_fields WHERE `field` IN ('dx_date', 'notes', 'icd10_code', 'topography', 'morphology'));

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_search`='0', `flag_index`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_primary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='survival_time_months' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');
UPDATE structure_formats SET `display_order`='20' WHERE structure_id=(SELECT id FROM structures WHERE alias='diagnosismasters') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='notes');

UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0', `flag_summary`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='dx_method' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='dx_method') AND `flag_confidential`='0');
UPDATE structure_formats SET `flag_add`='0', `flag_edit`='0', `flag_detail`='0' WHERE structure_id=(SELECT id FROM structures WHERE alias='dx_secondary') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='DiagnosisMaster' AND `tablename`='diagnosis_masters' AND `field`='information_source' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='information_source') AND `flag_confidential`='0');


INSERT IGNORE INTO i18n (id,en,fr) VALUES ('chuq', 'CHUQ', 'CHUQ');

-- ANNOTATION

UPDATE event_controls SET flag_active = 0 WHERE disease_site != 'chuq';
UPDATE `event_controls` SET `disease_site` = 'chuq', `databrowser_label` = 'lab|chuq|ca125' WHERE disease_site like 'CHUQ';

-- TREATMENT

UPDATE `tx_controls` SET `disease_site` = 'chuq', `databrowser_label` = CONCAT('chuq|',`databrowser_label`) WHERE disease_site like 'CHUQ';
UPDATE `tx_controls` SET applied_protocol_control_id = null WHERE disease_site like 'CHUQ';

UPDATE structure_formats SET `flag_override_tag`='1', `language_tag`='' WHERE structure_id=(SELECT id FROM structures WHERE alias='sd_spe_tissues') AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll_unit' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chuq_spent_time_unit') AND `flag_confidential`='0');

REPLACE INTO i18n (id,en,fr) VALUEs ('chuq ap precision','AP Precision','AP Précision');

INSERT INTO structure_formats(`structure_id`, `structure_field_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`, `flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`, `flag_search`, `flag_search_readonly`, `flag_addgrid`, `flag_addgrid_readonly`, `flag_editgrid`, `flag_editgrid_readonly`, `flag_batchedit`, `flag_batchedit_readonly`, `flag_index`, `flag_detail`, `flag_summary`) VALUES 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll' AND `type`='integer_positive' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0' AND `setting`='size=5' AND `default`='' AND `language_help`='' AND `language_label`='evaluated collection to reception spent time' AND `language_tag`=''), '1', '435', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0'), 
((SELECT id FROM structures WHERE alias='specimens'), (SELECT id FROM structure_fields WHERE `model`='SpecimenDetail' AND `tablename`='' AND `field`='chuq_evaluated_spent_time_from_coll_unit' AND `type`='select' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='chuq_spent_time_unit')  AND `flag_confidential`='0' AND `setting`='' AND `default`='' AND `language_help`='' AND `language_label`='' AND `language_tag`='unit'), '1', '436', '', '0', '', '0', '', '0', '', '0', '', '0', '', '0', '', '1', '0', '1', '0', '1', '0', '1', '0', '0', '0', '0', '0', '1', '1', '0');

DELETE FROM structure_formats WHERE structure_id IN (SELECT id FROM structures WHERE alias like 'sd_spe%') AND structure_field_id IN (SELECT id FROM structure_fields WHERE field like 'chuq_evaluated_spent_time_from_coll%');
UPDATE structure_fields SET `language_tag`='' WHERE model='SpecimenDetail' AND tablename='' AND field='chuq_evaluated_spent_time_from_coll_unit';
